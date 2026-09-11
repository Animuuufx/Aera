package
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    /**
     * Aera database-driven NPC popup.
     *
     * IMPORTANT:
     * Export the main NPC popup MovieClip for ActionScript as:
     *     DatabaseNPCPanel
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
     *     new DatabaseNPCPanel(rootClass, avatar)
     *
     * The database NPC payload is already copied onto Avatar.objData as:
     *     strUsername
     *     dbJob
     *     dbDialog
     *     dbButtons
     */
    public class DatabaseNPCPanel extends MovieClip
    {
        private static const BUTTON_GAP:Number = 6;
        private static const WHEEL_STEP:Number = 54;

        private var rootClass:*;
        private var npcAvatar:*;
        private var npcData:Object;

        private var buttonList:MovieClip;
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

        public function DatabaseNPCPanel(game:*=null, avatar:*=null)
        {
            super();

            rootClass = game;
            npcAvatar = avatar;
            npcData = (npcAvatar != null) ? npcAvatar.objData : null;

            // Timeline/linkage children are safest to access once the symbol is on stage.
            if (stage != null)
            {
                initialize();
            }
            else
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
            scrollTrack = getChildByName("npcScrollTrack") as MovieClip;
            scrollHandle = getChildByName("npcScrollHandle") as MovieClip;
            closeButton = getChildByName("npcBtnClose") as MovieClip;

            setPanelText();
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

            while (buttonList.numChildren > 0)
            {
                buttonList.removeChildAt(0);
            }

            var buttons:Array = getButtons();
            var yPos:Number = 0;
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
                row.y = yPos;
                row.name = "npcButton_" + i;
                row["npcButtonData"] = buttons[i];

                populateButtonRow(row, buttons[i]);

                row.buttonMode = true;
                row.mouseChildren = false;
                row.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);

                buttonList.addChild(row);
                buttonRows.push(row);

                yPos += Math.max(1, row.height) + BUTTON_GAP;
            }

            contentHeight = Math.max(0, yPos - BUTTON_GAP);
            listStartY = buttonList.y;
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
                trace("DatabaseNPCPanel: npcPanelButton linkage missing: " + e.message);
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
                trace("DatabaseNPCPanel button action error: " + e1.message);
            }

            // Some client builds expose World as rootClass.world directly only after
            // map initialization. Do not silently invent a second protocol.
            trace("DatabaseNPCPanel: World action router unavailable.");
        }

        private function setupScroller():void
        {
            if (buttonList == null || scrollTrack == null || scrollHandle == null)
            {
                return;
            }

            viewHeight = scrollTrack.height;

            // Create a clipping mask aligned to the button list and scrollbar height.
            listMask = new Shape();
            listMask.graphics.beginFill(0xFF00FF, 1);
            listMask.graphics.drawRect(0, 0, Math.max(1, buttonList.width + 4), Math.max(1, viewHeight));
            listMask.graphics.endFill();
            listMask.x = buttonList.x;
            listMask.y = buttonList.y;

            addChild(listMask);
            buttonList.mask = listMask;

            handleTop = scrollTrack.y;

            // Current FLA places the handle inside the visible rail.
            handleBottom = scrollTrack.y + scrollTrack.height - scrollHandle.height;

            scrollHandle.buttonMode = true;
            scrollHandle.mouseChildren = false;
            scrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown, false, 0, true);
            scrollTrack.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
            addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);

            // Hide/disable the scrollbar if all buttons already fit.
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

            var newY:Number = mouseY - dragOffset;
            newY = clamp(newY, handleTop, handleBottom);

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

            // Positive delta = wheel up.
            var pixelDelta:Number = -e.delta * (WHEEL_STEP / 3);
            scrollListBy(pixelDelta);
        }

        private function scrollListBy(delta:Number):void
        {
            if (contentHeight <= viewHeight)
            {
                setScrollPercent(0);
                return;
            }

            var minY:Number = listStartY - (contentHeight - viewHeight);
            var newY:Number = clamp(buttonList.y - delta, minY, listStartY);
            buttonList.y = newY;
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
            if (contentHeight <= viewHeight)
            {
                scrollHandle.y = handleTop;
                return;
            }

            var maxScroll:Number = contentHeight - viewHeight;
            var scrolled:Number = listStartY - buttonList.y;
            var percent:Number = clamp(scrolled / maxScroll, 0, 1);

            scrollHandle.y = handleTop + ((handleBottom - handleTop) * percent);
        }

        private function setScrollPercent(percent:Number, updateHandle:Boolean=true):void
        {
            percent = clamp(percent, 0, 1);

            if (buttonList != null)
            {
                var maxScroll:Number = Math.max(0, contentHeight - viewHeight);
                buttonList.y = listStartY - (maxScroll * percent);
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
