package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.text.TextField;

    /**
     * Aera database-driven NPC popup.
     *
     * IMPORTANT:
     * Export the main NPC popup MovieClip for ActionScript as:
     *     npcPanel
     *
     * Required instance names inside that MovieClip:
     *     npcName
     *     npcJob
     *     npcDialog
     *     npcButtonList
     *     npcScrollTrack
     *     npcScrollHandle
     *     npcBtnClose
     *
     * Optional:
     *     npcPreview
     *
     * World.as already creates this class with:
     *     new npcPanel(); panel.init(rootClass, avatar)
     *
     * The database NPC payload is already copied onto Avatar.objData as:
     *     strUsername
     *     dbJob
     *     dbDialog
     *     dbButtons
     */
    public dynamic class npcPanel extends MovieClip
    {
        private static const BUTTON_STEP:Number = 76;
        private static const WHEEL_STEP:Number = 46;
        private static const PREVIEW_MAX_WIDTH:Number = 630;
        private static const PREVIEW_MAX_HEIGHT:Number = 990;

        // PNG/JPG NPC popup preview only.
        // Kept separate from normal SWF/equipment NPC previews and from the
        // database ImageScale used by the NPC actor on the map.
        // Kael's 1086x1448 portrait is visually broader/taller than the normal
        // equipment-avatar snapshot, so ~67% makes it read close to Animu's
        // popup preview size.
        private static const IMAGE_PREVIEW_SCALE:Number = 0.67;

        private var rootClass:*;
        private var npcAvatar:*;
        private var npcData:Object;

        private var buttonList:MovieClip;
        private var buttonContent:MovieClip;
        private var npcPreview:MovieClip;
        private var previewLoader:Loader;
        private var scrollTrack:MovieClip;
        private var scrollHandle:MovieClip;
        private var closeButton:MovieClip;

        private var listMask:Shape;
        private var buttonRows:Array = [];

        private var listStartY:Number = 0;
        private var contentHeight:Number = 0;
        private var viewHeight:Number = 0;

        private var handleTop:Number = 0;
        private var handleBottom:Number = 0;
        private var dragging:Boolean = false;
        private var dragOffset:Number = 0;
        private var initialized:Boolean = false;

        public function npcPanel()
        {
            super();
            stop();
        }

        /**
         * Called by World.openDatabaseNPC() after the actual FLA-linked npcPanel
         * symbol has been constructed. Keeping the constructor argument-free is
         * required for Animate linkage symbols.
         */
        public function init(game:*=null, avatar:*=null):void
        {
            rootClass = game;
            npcAvatar = avatar;
            npcData = (npcAvatar != null) ? npcAvatar.objData : null;
            initialized = false;

            if (stage != null)
            {
                initialize();
            }
            else if (!hasEventListener(Event.ADDED_TO_STAGE))
            {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
            }
        }

        private function onAddedToStage(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            initialize();
        }

        private function initialize():void
        {
            if (initialized)
            {
                return;
            }
            initialized = true;

            stop();

            buttonList = getChildByName("npcButtonList") as MovieClip;
            npcPreview = getChildByName("npcPreview") as MovieClip;
            scrollTrack = getChildByName("npcScrollTrack") as MovieClip;
            scrollHandle = getChildByName("npcScrollHandle") as MovieClip;
            closeButton = getChildByName("npcBtnClose") as MovieClip;

            setPanelText();
            setupNPCPreview();
            setupCloseButton();
            buildButtons();
            setupScroller();

            // Keep this panel above map interaction while it is open.
            mouseEnabled = true;
        }

        private function setPanelText():void
        {
            var nameField:TextField = getChildByName("npcName") as TextField;
            var jobField:TextField = getChildByName("npcJob") as TextField;
            var dialogField:TextField = getChildByName("npcDialog") as TextField;

            var npcName:String = readString(npcData, ["strUsername", "Name", "name"], "NPC");
            var npcJob:String = readString(npcData, ["dbJob", "strJob", "Job", "job"], "");
            var npcDialog:String = readString(npcData, ["dbDialog", "strDialog", "Dialog", "dialog"], "");

            if (nameField != null)
            {
                nameField.text = npcName;
                nameField.mouseEnabled = false;
            }

            if (jobField != null)
            {
                jobField.text = npcJob;
                jobField.mouseEnabled = false;
            }

            if (dialogField != null)
            {
                dialogField.text = npcDialog;
                dialogField.mouseEnabled = false;
                dialogField.wordWrap = true;
                dialogField.multiline = true;
            }
        }

        private function setupNPCPreview():void
        {
            if (npcPreview == null || npcAvatar == null || npcAvatar.pMC == null)
            {
                return;
            }

            // npcPreview is an empty FLA MovieClip used only as the anchor.
            // Render a snapshot of the already-loaded database NPC character so
            // the map NPC remains in the world and is not re-parented into the UI.
            while (npcPreview.numChildren > 0)
            {
                npcPreview.removeChildAt(0);
            }

            npcPreview.mouseEnabled = false;
            npcPreview.mouseChildren = false;

            // Image NPCs use the same database PNG/JPG in the popup preview.
            // Loading it directly avoids BitmapData security issues and avoids
            // snapshotting the hidden mcChar fallback.
            var imagePath:String = readString(npcData, ["dbImage", "strImage", "Image", "image"], "");
            if (imagePath != "")
            {
                setupDatabaseImagePreview(imagePath);
                return;
            }

            var source:DisplayObject = null;
            try
            {
                if (("mcChar" in npcAvatar.pMC) && npcAvatar.pMC.mcChar != null)
                {
                    source = npcAvatar.pMC.mcChar as DisplayObject;
                }
            }
            catch (e0:Error)
            {
            }

            if (source == null)
            {
                source = npcAvatar.pMC as DisplayObject;
            }
            if (source == null)
            {
                return;
            }

            try
            {
                var bounds:Rectangle = source.getBounds(source);
                if (bounds.width <= 1 || bounds.height <= 1)
                {
                    return;
                }

                var scale:Number = Math.min(PREVIEW_MAX_WIDTH / bounds.width, PREVIEW_MAX_HEIGHT / bounds.height);
                if (scale <= 0 || isNaN(scale))
                {
                    return;
                }

                var bmpW:int = Math.max(1, Math.ceil(bounds.width * scale));
                var bmpH:int = Math.max(1, Math.ceil(bounds.height * scale));
                var bmd:BitmapData = new BitmapData(bmpW, bmpH, true, 0x00000000);
                var matrix:Matrix = new Matrix();
                matrix.scale(scale, scale);
                matrix.translate((-bounds.x * scale), (-bounds.y * scale));
                bmd.draw(source, matrix, null, null, null, true);

                var bmp:Bitmap = new Bitmap(bmd);
                bmp.smoothing = true;
                bmp.x = 0;
                bmp.y = 0;
                npcPreview.addChild(bmp);
            }
            catch (e:Error)
            {
                trace("npcPanel: unable to render NPC preview: " + e.message);
            }
        }

        private function setupDatabaseImagePreview(imagePath:String):void
        {
            if (npcPreview == null || rootClass == null)
            {
                return;
            }

            previewLoader = new Loader();
            previewLoader.mouseEnabled = false;
            previewLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPreviewImageComplete, false, 0, true);
            previewLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError, false, 0, true);
            npcPreview.addChild(previewLoader);

            try
            {
                previewLoader.load(new URLRequest(resolveImageURL(imagePath)));
            }
            catch(e:Error)
            {
                trace("npcPanel: image preview load start failed: " + e.message);
            }
        }

        private function onPreviewImageComplete(e:Event):void
        {
            if (previewLoader == null || previewLoader.content == null)
            {
                return;
            }

            try
            {
                if (previewLoader.content is Bitmap)
                {
                    Bitmap(previewLoader.content).smoothing = true;
                }

                var rawWidth:Number = previewLoader.content.width;
                var rawHeight:Number = previewLoader.content.height;
                if (rawWidth <= 1 || rawHeight <= 1)
                {
                    return;
                }

                var scale:Number = Math.min(PREVIEW_MAX_WIDTH / rawWidth, PREVIEW_MAX_HEIGHT / rawHeight);
                if (isNaN(scale) || scale <= 0)
                {
                    return;
                }

                // Do not enlarge tiny source art; only fit large images down.
                if (scale > 1)
                {
                    scale = 1;
                }

                // IMAGE NPC PREVIEW ONLY:
                // This extra multiplier is intentionally applied only to PNG/JPG
                // previews. Normal SWF/equipment NPC previews continue using the
                // PREVIEW_MAX_WIDTH / PREVIEW_MAX_HEIGHT values above unchanged.
                // It also does not modify the NPC's database ImageScale on the map.
                scale *= IMAGE_PREVIEW_SCALE;

                previewLoader.scaleX = scale;
                previewLoader.scaleY = scale;
                previewLoader.x = 0;
                previewLoader.y = 0;
            }
            catch(err:Error)
            {
                trace("npcPanel: image preview layout failed: " + err.message);
            }
        }

        private function onPreviewImageError(e:IOErrorEvent):void
        {
            trace("npcPanel: image preview failed: " + e.text);
        }

        private function resolveImageURL(imagePath:String):String
        {
            var path:String = ((imagePath == null) ? "" : imagePath.replace(/^\s+|\s+$/g, ""));
            var lower:String = path.toLowerCase();

            if ((lower.indexOf("http://") == 0) || (lower.indexOf("https://") == 0))
            {
                return path;
            }

            while (path.charAt(0) == "/")
            {
                path = path.substr(1);
            }

            lower = path.toLowerCase();
            if (lower.indexOf("gamefiles/") == 0)
            {
                return (rootClass.getGamePath() + path);
            }

            return (rootClass.getFilePath() + path);
        }

        private function setupCloseButton():void
        {
            if (closeButton == null)
            {
                return;
            }

            closeButton.buttonMode = true;
            closeButton.mouseChildren = false;
            closeButton.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
        }

        private function onCloseClick(e:MouseEvent):void
        {
            close();
        }

        public function close():void
        {
            dispose();

            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        public function dispose():void
        {
            if (previewLoader != null)
            {
                try
                {
                    previewLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPreviewImageComplete);
                    previewLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError);
                    previewLoader.close();
                }
                catch(ePreview:Error)
                {
                }
                previewLoader = null;
            }

            if (closeButton != null)
            {
                closeButton.removeEventListener(MouseEvent.CLICK, onCloseClick);
            }

            if (scrollHandle != null)
            {
                scrollHandle.removeEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
            }

            if (scrollTrack != null)
            {
                scrollTrack.removeEventListener(MouseEvent.CLICK, onTrackClick);
            }

            removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

            if (stage != null)
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
                stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            }

            dragging = false;

            // Release the preview snapshot bitmap data when the popup closes.
            if (npcPreview != null && npcPreview.numChildren > 0)
            {
                var previewChild:DisplayObject = npcPreview.getChildAt(0);
                if (previewChild is Bitmap && Bitmap(previewChild).bitmapData != null)
                {
                    Bitmap(previewChild).bitmapData.dispose();
                }
                while (npcPreview.numChildren > 0)
                {
                    npcPreview.removeChildAt(0);
                }
            }

            var i:int;
            for (i = 0; i < buttonRows.length; i++)
            {
                if (buttonRows[i] is MovieClip)
                {
                    MovieClip(buttonRows[i]).removeEventListener(MouseEvent.CLICK, onButtonClick);
                }
            }
            buttonRows.length = 0;
        }

        private function buildButtons():void
        {
            if (buttonList == null)
            {
                return;
            }

            // Keep the timeline placeholder fixed. The generated rows live in a
            // separate content clip so scrolling never moves the clipping window.
            while (buttonList.numChildren > 0)
            {
                buttonList.removeChildAt(0);
            }

            buttonContent = new MovieClip();
            buttonContent.name = "npcButtonContent";
            buttonList.addChild(buttonContent);

            var buttons:Array = getButtons();
            var row:MovieClip;
            var i:int;

            for (i = 0; i < buttons.length; i++)
            {
                row = createButtonRow();
                if (row == null)
                {
                    continue;
                }

                row.x = 0;
                row.y = (buttonRows.length * BUTTON_STEP);
                row.name = "npcButton_" + i;
                row["npcButtonData"] = buttons[i];

                populateButtonRow(row, buttons[i]);

                row.buttonMode = true;
                row.mouseChildren = false;
                row.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);

                buttonContent.addChild(row);
                buttonRows.push(row);
            }

            // BUTTON_STEP deliberately ignores the symbol's reported height. The
            // current FLA button contains decorative bounds that made row.height
            // report much taller than the visible button, which caused huge gaps.
            if (buttonRows.length > 0)
            {
                contentHeight = ((buttonRows.length - 1) * BUTTON_STEP) + Math.min(BUTTON_STEP, Math.max(1, MovieClip(buttonRows[0]).height));
            }
            else
            {
                contentHeight = 0;
            }

            listStartY = 0;
        }

        private function createButtonRow():MovieClip
        {
            // The FLA library symbol is exported as npcPanelButton.
            try
            {
                return new npcPanelButton();
            }
            catch (e:Error)
            {
                trace("npcPanel: npcPanelButton linkage missing: " + e.message);
            }
            return null;
        }

        private function populateButtonRow(row:MovieClip, data:Object):void
        {
            var label:String = readString(data, ["strText", "Text", "text", "Label", "label"], "Action");

            // Prefer common explicit names if you add one later.
            var tf:TextField = findTextField(row, ["txtLabel", "txtButton", "buttonText", "txtText", "label", "txt"]);
            if (tf == null)
            {
                // Current button art only needs one text field, so fall back to the first.
                tf = findFirstTextField(row);
            }

            if (tf != null)
            {
                tf.text = label;
                tf.mouseEnabled = false;
            }

            // Optional icon support:
            // If the button MovieClip contains a child named npcButtonIcon/iconHolder,
            // World/database strIcon can be used by a future icon loader without changing
            // the DB contract. Current UI remains functional when no icon is present.
        }

        private function onButtonClick(e:MouseEvent):void
        {
            var row:MovieClip = e.currentTarget as MovieClip;
            if (row == null || !("npcButtonData" in row))
            {
                return;
            }

            var data:Object = row["npcButtonData"];

            // Use Aera's existing World action router, which already understands
            // shop, hair shop, enhancement, quests, joins, bank, auction, etc.
            try
            {
                if (rootClass != null && rootClass.world != null &&
                    ("executeDatabaseNPCButton" in rootClass.world))
                {
                    rootClass.world.executeDatabaseNPCButton(data, npcAvatar);
                    return;
                }
            }
            catch (e1:Error)
            {
                trace("npcPanel button action error: " + e1.message);
            }

            // Some client builds expose World as rootClass.world directly only after
            // map initialization. Do not silently invent a second protocol.
            trace("npcPanel: World action router unavailable.");
        }

        private function setupScroller():void
        {
            if (buttonList == null || buttonContent == null || scrollTrack == null || scrollHandle == null)
            {
                return;
            }

            viewHeight = Math.max(1, scrollTrack.height);

            // scrollRect is more reliable here than a stage mask because the FLA's
            // button-list placeholder has no artwork/bounds of its own. It guarantees
            // that generated buttons cannot draw below the bottom of the panel.
            var viewWidth:Number = Math.max(1, buttonContent.width + 4);
            buttonList.scrollRect = new Rectangle(0, 0, viewWidth, viewHeight);

            handleTop = scrollTrack.y;
            handleBottom = Math.max(handleTop, scrollTrack.y + scrollTrack.height - scrollHandle.height);

            scrollHandle.buttonMode = true;
            scrollHandle.mouseChildren = false;
            scrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown, false, 0, true);
            scrollTrack.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
            addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);

            var needsScroll:Boolean = contentHeight > viewHeight + 0.5;
            scrollTrack.visible = needsScroll;
            scrollHandle.visible = needsScroll;
            scrollTrack.mouseEnabled = needsScroll;
            scrollHandle.mouseEnabled = needsScroll;

            setScrollPercent(0);
        }

        private function onHandleDown(e:MouseEvent):void
        {
            if (stage == null || !scrollHandle.visible)
            {
                return;
            }

            dragging = true;
            dragOffset = mouseY - scrollHandle.y;

            stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
            e.stopPropagation();
        }

        private function onStageMouseMove(e:MouseEvent):void
        {
            if (!dragging)
            {
                return;
            }

            var newY:Number = clamp(mouseY - dragOffset, handleTop, handleBottom);
            scrollHandle.y = newY;
            syncListFromHandle();
            e.updateAfterEvent();
        }

        private function onStageMouseUp(e:MouseEvent):void
        {
            dragging = false;

            if (stage != null)
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
                stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            }
        }

        private function onTrackClick(e:MouseEvent):void
        {
            if (!scrollHandle.visible || e.target === scrollHandle)
            {
                return;
            }

            var targetY:Number = mouseY - (scrollHandle.height * 0.5);
            scrollHandle.y = clamp(targetY, handleTop, handleBottom);
            syncListFromHandle();
        }

        private function onMouseWheel(e:MouseEvent):void
        {
            if (!scrollHandle.visible)
            {
                return;
            }

            // Positive wheel delta scrolls toward the top.
            var pixelDelta:Number = -e.delta * (WHEEL_STEP / 3);
            scrollListBy(pixelDelta);
        }

        private function scrollListBy(delta:Number):void
        {
            if (buttonContent == null || contentHeight <= viewHeight)
            {
                setScrollPercent(0);
                return;
            }

            var minY:Number = -(contentHeight - viewHeight);
            buttonContent.y = clamp(buttonContent.y - delta, minY, 0);
            syncHandleFromList();
        }

        private function syncListFromHandle():void
        {
            var range:Number = handleBottom - handleTop;
            var percent:Number = (range <= 0) ? 0 : ((scrollHandle.y - handleTop) / range);
            setScrollPercent(percent, false);
        }

        private function syncHandleFromList():void
        {
            if (buttonContent == null || contentHeight <= viewHeight)
            {
                scrollHandle.y = handleTop;
                return;
            }

            var maxScroll:Number = contentHeight - viewHeight;
            var percent:Number = clamp((-buttonContent.y) / maxScroll, 0, 1);
            scrollHandle.y = handleTop + ((handleBottom - handleTop) * percent);
        }

        private function setScrollPercent(percent:Number, updateHandle:Boolean=true):void
        {
            percent = clamp(percent, 0, 1);

            if (buttonContent != null)
            {
                var maxScroll:Number = Math.max(0, contentHeight - viewHeight);
                buttonContent.y = -(maxScroll * percent);
            }

            if (updateHandle && scrollHandle != null)
            {
                scrollHandle.y = handleTop + ((handleBottom - handleTop) * percent);
            }
        }

        private function getButtons():Array
        {
            if (npcData == null)
            {
                return [];
            }

            if ("dbButtons" in npcData && npcData.dbButtons is Array)
            {
                return npcData.dbButtons as Array;
            }

            if ("buttons" in npcData && npcData.buttons is Array)
            {
                return npcData.buttons as Array;
            }

            return [];
        }

        private function readString(source:Object, keys:Array, fallback:String=""):String
        {
            if (source == null)
            {
                return fallback;
            }

            var key:String;
            var value:*;

            for each (key in keys)
            {
                try
                {
                    if (key in source)
                    {
                        value = source[key];
                        if (value != null && String(value) != "")
                        {
                            return String(value);
                        }
                    }
                }
                catch (e:Error)
                {
                }
            }

            return fallback;
        }

        private function findTextField(container:DisplayObjectContainer, names:Array):TextField
        {
            var n:String;
            var child:DisplayObject;

            for each (n in names)
            {
                child = container.getChildByName(n);
                if (child is TextField)
                {
                    return child as TextField;
                }
            }
            return null;
        }

        private function findFirstTextField(container:DisplayObjectContainer):TextField
        {
            var i:int;
            var child:DisplayObject;
            var nested:TextField;

            for (i = 0; i < container.numChildren; i++)
            {
                child = container.getChildAt(i);

                if (child is TextField)
                {
                    return child as TextField;
                }

                if (child is DisplayObjectContainer)
                {
                    nested = findFirstTextField(child as DisplayObjectContainer);
                    if (nested != null)
                    {
                        return nested;
                    }
                }
            }

            return null;
        }

        private function clamp(value:Number, min:Number, max:Number):Number
        {
            if (value < min)
            {
                return min;
            }
            if (value > max)
            {
                return max;
            }
            return value;
        }
    }
}
