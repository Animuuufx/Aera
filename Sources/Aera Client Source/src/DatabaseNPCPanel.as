package
{
    import flash.display.DisplayObject;
    import flash.display.FrameLabel;
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    /**
     * Database NPC dialog controller.
     *
     * VISUALS ARE OWNED BY THE FLA.
     * This class does not draw the NPC window or action buttons.
     *
     * Required exported MovieClip linkage/class names:
     *   DatabaseNPCPanelMC
     *   DatabaseNPCButtonMC
     *
     * DatabaseNPCPanelMC required instance names:
     *   mcPreview
     *   txtName
     *   txtJob
     *   txtDialog
     *   mcButtons       (recommended; fallback holder is created if omitted)
     *   btnClose        (Animate Button/SimpleButton or MovieClip both supported)
     *
     * DatabaseNPCButtonMC required instance names:
     *   txtLabel
     *   mcIcon        (optional at runtime, but supported)
     *
     * Optional button timeline labels:
     *   up, over, down
     *
     * Optional mcIcon timeline frame labels can match database Icon values
     * such as iwarmor, iidesign, iwsword, etc. If a matching label exists,
     * the icon MovieClip is moved to it automatically.
     */
    public class DatabaseNPCPanel extends MovieClip
    {
        private var rootClass:MovieClip;
        private var avatar:Avatar;
        private var panelMC:MovieClip;
        private var clickShield:Sprite;
        private var closeButton:InteractiveObject;

        private var buttonData:Dictionary = new Dictionary(true);
        private var dynamicButtons:Array = [];

        // Real AvatarMC used by the FLA preview holder. This intentionally does
        // not bitmap-capture the map NPC; imported AQW item SWFs can prevent
        // BitmapData.draw() from producing a usable preview.
        private var previewMC:AvatarMC;
        private var previewImageHolder:Sprite;
        private var previewImageLoader:Loader;
        private var previewViewport:Rectangle;
        private var previewFitFrames:int = 0;

        // Cached before runtime buttons are inserted, so button layout uses the
        // original FLA artwork bounds instead of expanding the panel with itself.
        private var panelDesignBounds:Rectangle;

        // Change only these if you want a different automatic button layout.
        // The actual artwork remains entirely in DatabaseNPCButtonMC.
        private const BUTTON_COLUMNS:int = 1;
        private const BUTTON_GAP_X:Number = 8;
        private const BUTTON_GAP_Y:Number = 6;
        private const FALLBACK_BUTTON_WIDTH:Number = 360;
        private const FALLBACK_BUTTON_HEIGHT:Number = 38;
        private const BUTTON_BOTTOM_MARGIN:Number = 34;

        // Large classic NPC preview tuning.
        private const PREVIEW_STAGE_LEFT_MARGIN:Number = 88;
        private const PREVIEW_STAGE_TOP_MARGIN:Number = 12;
        private const PREVIEW_STAGE_RIGHT_GAP:Number = 12;
        private const PREVIEW_STAGE_BOTTOM_MARGIN:Number = 8;
        private const PREVIEW_TARGET_HEIGHT_RATIO:Number = 1.08;
        private const PREVIEW_WIDTH_OVERFLOW_RATIO:Number = 1.90;
        private const PREVIEW_CENTER_X_RATIO:Number = 0.57;
        private const PREVIEW_MAX_SCALE:Number = 4.75;
        private const PREVIEW_VERTICAL_LIFT:Number = 32;

        public function DatabaseNPCPanel(root:MovieClip, npc:Avatar)
        {
            super();
            rootClass = root;
            avatar = npc;
            name = "DatabaseNPCPanel";

            buildFromLibrary();
        }

        /** Build the popup from the MovieClips exported by the client FLA. */
        private function buildFromLibrary():void
        {
            var panelClass:Class;

            try
            {
                panelClass = (getDefinitionByName("DatabaseNPCPanelMC") as Class);
            }
            catch (e:Error)
            {
                throw new Error(
                    "DatabaseNPCPanelMC was not found. Export your NPC popup MovieClip for ActionScript " +
                    "with class/linkage name DatabaseNPCPanelMC."
                );
            }

            createInvisibleClickShield();

            panelMC = (new panelClass() as MovieClip);
            if (panelMC == null)
            {
                throw new Error("DatabaseNPCPanelMC must extend MovieClip.");
            }

            addChild(panelMC);
            panelDesignBounds = panelMC.getBounds(panelMC).clone();
            centerPanel();
            fillNPCText();
            fillNPCPreview();
            buildButtons();
            hookCloseButton();
        }

        /**
         * Invisible only: blocks map clicks behind the modal without imposing
         * any programmatic visual design. Add your own dimmer/background art
         * to DatabaseNPCPanelMC if you want one.
         */
        private function createInvisibleClickShield():void
        {
            var stageWidth:Number = getStageWidth();
            var stageHeight:Number = getStageHeight();

            clickShield = new Sprite();
            clickShield.graphics.beginFill(0x000000, 0.01);
            clickShield.graphics.drawRect(0, 0, stageWidth, stageHeight);
            clickShield.graphics.endFill();
            addChild(clickShield);
        }

        private function centerPanel():void
        {
            var stageWidth:Number = getStageWidth();
            var stageHeight:Number = getStageHeight();
            var bounds:Rectangle = ((panelDesignBounds != null) ? panelDesignBounds : panelMC.getBounds(panelMC));
            var scale:Number = 1;
            var maxWidth:Number = stageWidth * 0.96;
            var maxHeight:Number = stageHeight * 0.96;

            if (bounds.width > 1 && bounds.height > 1)
            {
                scale = Math.min(1, maxWidth / bounds.width, maxHeight / bounds.height);
            }

            panelMC.scaleX = scale;
            panelMC.scaleY = scale;
            panelMC.x = ((stageWidth - (bounds.width * scale)) / 2) - (bounds.x * scale);
            panelMC.y = ((stageHeight - (bounds.height * scale)) / 2) - (bounds.y * scale);
        }

        private function fillNPCText():void
        {
            var data:Object = ((avatar != null) ? avatar.objData : null);
            if (data == null)
            {
                return;
            }

            setFieldText(findPanelInstance("txtName", true), clean(data.strUsername));
            setFieldText(findPanelInstance("txtJob", true), clean(data.dbJob));
            setFieldText(findPanelInstance("txtDialog", true), clean(data.dbDialog));
        }

        /**
         * Put a real AvatarMC copy of the database NPC into mcPreview.
         *
         * Do not rasterize the live map NPC here. AQW equipment is loaded from
         * external SWFs/application domains and BitmapData.draw() is unreliable
         * for those display lists. A separate AvatarMC gives the popup the same
         * rendering path used by the client itself.
         */
        private function fillNPCPreview():void
        {
            var holder:MovieClip;
            var oldPreview:DisplayObject;
            var holderBounds:Rectangle;
            var previewAvatar:Avatar;
            var data:Object;

            holder = (findPanelInstance("mcPreview", true) as MovieClip);
            if (holder == null)
            {
                throw new Error("DatabaseNPCPanelMC.mcPreview must be a MovieClip.");
            }

            oldPreview = holder.getChildByName("__databaseNPCPreview");
            if (oldPreview != null)
            {
                holder.removeChild(oldPreview);
            }
            oldPreview = holder.getChildByName("__databaseNPCPreviewImage");
            if (oldPreview != null)
            {
                holder.removeChild(oldPreview);
            }

            if (avatar == null || avatar.objData == null || rootClass == null || rootClass.world == null)
            {
                trace("DatabaseNPCPanel preview: NPC data/world is not ready.");
                return;
            }

            // Build a large left-side viewport like the classic Gravelyn-style
            // NPC popup: big character art on the left, dialog panel centered.
            // If the designer gave mcPreview a usable size, keep it as a fallback,
            // but prefer the full stage space to the left of the popup panel.
            previewViewport = buildClassicLargePreviewViewport(holder);
            if (previewViewport == null)
            {
                holderBounds = holder.getBounds(holder);
                if (holderBounds.width > 10 && holderBounds.height > 10)
                {
                    previewViewport = new Rectangle(holderBounds.x, holderBounds.y, holderBounds.width, holderBounds.height);
                }
                else
                {
                    previewViewport = new Rectangle(0, 0, 270, 390);
                }
            }

            try
            {
                data = avatar.objData;

                // Image-based NPCs should show the same artwork in the popup
                // instead of trying to rebuild a paper-doll avatar preview.
                if (beginImagePreview(holder, data))
                {
                    trace("DatabaseNPCPanel image preview loading: " + clean(data.strUsername));
                    return;
                }

                previewMC = new AvatarMC(false);
                previewMC.name = "__databaseNPCPreview";
                previewMC.world = rootClass.world;
                previewMC.strGender = clean(data.strGender).toUpperCase();
                previewMC.strGender = ((previewMC.strGender.charAt(0) == "F") ? "F" : "M");

                previewAvatar = new Avatar(rootClass);
                previewAvatar.uid = avatar.uid;
                previewAvatar.pnm = avatar.pnm;
                previewAvatar.npcType = "npc";
                previewAvatar.npcData = avatar.npcData;
                previewAvatar.objData = data;
                previewAvatar.isMyAvatar = false;
                previewAvatar.isCharPage = true;
                previewAvatar.dataLeaf = {};
                previewAvatar.dataLeaf.showHelm = readLeafBoolean(avatar, "showHelm", true);
                previewAvatar.dataLeaf.showCloak = readLeafBoolean(avatar, "showCloak", true);
                previewAvatar.pMC = previewMC;
                previewMC.pAV = previewAvatar;

                previewMC.mouseEnabled = false;
                previewMC.mouseChildren = false;
                previewMC.mcChar.mouseEnabled = false;
                previewMC.mcChar.mouseChildren = false;
                previewMC.hpBar.visible = false;
                previewMC.pname.visible = false;
                previewMC.ignore.visible = false;
                previewMC.shadow.visible = false;
                previewMC.cShadow.visible = false;
                previewMC.bubble.visible = false;

                holder.addChild(previewMC);

                // Build the copy from the same already-loaded linkage definitions
                // as the NPC standing on the map. If a definition is not cached,
                // fall back to AvatarMC's normal asynchronous loader.
                loadPreviewAppearance(previewMC, previewAvatar);

                try
                {
                    previewMC.mcChar.gotoAndPlay("Idle");
                }
                catch (idleError:Error)
                {
                }

                fitPreviewAvatar();

                // Async fallback loads may finish a few frames later. Re-fit and
                // recolor briefly so armor/helm/cape/weapon never appear off-center.
                previewFitFrames = 60;
                addEventListener(Event.ENTER_FRAME, onPreviewFitFrame, false, 0, true);
                trace("DatabaseNPCPanel live AvatarMC preview ready: " + clean(data.strUsername));
            }
            catch (e:Error)
            {
                trace("DatabaseNPCPanel preview error: " + e.message);
            }
        }

        private function beginImagePreview(holder:MovieClip, data:Object):Boolean
        {
            var imagePath:String = databaseNPCImagePath(data);
            var imageURL:String;

            if (holder == null || data == null)
            {
                return false;
            }

            // Image mode is only for bitmap/static image NPCs. A .swf path
            // must stay on the normal Avatar/AvatarMC renderer so its linkage,
            // timelines and equipment load exactly like the NPC on the map.
            if (!isStaticNPCImagePath(imagePath))
            {
                return false;
            }

            imageURL = databaseNPCImageURL(imagePath);
            if (imageURL == "")
            {
                return false;
            }
            trace(("DatabaseNPCPanel image preview path: " + imagePath + " -> " + imageURL));

            closeImagePreview();

            previewImageHolder = new Sprite();
            previewImageHolder.name = "__databaseNPCPreviewImage";
            previewImageHolder.mouseEnabled = false;
            previewImageHolder.mouseChildren = false;

            previewImageLoader = new Loader();
            previewImageLoader.mouseEnabled = false;
            previewImageLoader.mouseChildren = false;
            previewImageHolder.addChild(previewImageLoader);
            holder.addChild(previewImageHolder);

            previewImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPreviewImageComplete, false, 0, true);
            previewImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError, false, 0, true);
            previewImageLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onPreviewImageError, false, 0, true);

            try
            {
                previewImageLoader.load(new URLRequest(imageURL));
            }
            catch (e:Error)
            {
                trace("DatabaseNPCPanel image preview load error: " + e.message);
                closeImagePreview();
                return false;
            }

            return true;
        }

        private function databaseNPCImagePath(data:Object):String
        {
            var value:String;

            if (data == null)
            {
                return "";
            }

            // World.as stores the resolved database image path on Avatar.objData
            // as dbImage. The raw npcmap payload may use strImage or Image, so
            // accept all three names for compatibility with current Aera builds.
            if (("dbImage" in data) && data.dbImage != null)
            {
                value = clean(data.dbImage);
                if (value != "")
                {
                    return value;
                }
            }
            if (("strImage" in data) && data.strImage != null)
            {
                value = clean(data.strImage);
                if (value != "")
                {
                    return value;
                }
            }
            if (("Image" in data) && data.Image != null)
            {
                value = clean(data.Image);
                if (value != "")
                {
                    return value;
                }
            }

            // Last fallback: the map-placement object is kept on Avatar.npcData.
            // This handles builds where the image field was not copied to objData.
            try
            {
                if (avatar != null && avatar.npcData != null)
                {
                    if (("strImage" in avatar.npcData) && avatar.npcData.strImage != null)
                    {
                        value = clean(avatar.npcData.strImage);
                        if (value != "")
                        {
                            return value;
                        }
                    }
                    if (("Image" in avatar.npcData) && avatar.npcData.Image != null)
                    {
                        value = clean(avatar.npcData.Image);
                        if (value != "")
                        {
                            return value;
                        }
                    }
                }
            }
            catch (e:Error)
            {
            }

            return "";
        }

        private function isStaticNPCImagePath(value:String):Boolean
        {
            var path:String = clean(value).toLowerCase();
            var q:int;
            var hash:int;
            if (path == "")
            {
                return false;
            }
            q = path.indexOf("?");
            if (q >= 0)
            {
                path = path.substr(0, q);
            }
            hash = path.indexOf("#");
            if (hash >= 0)
            {
                path = path.substr(0, hash);
            }
            return (path.lastIndexOf(".png") == path.length - 4 ||
                    path.lastIndexOf(".jpg") == path.length - 4 ||
                    path.lastIndexOf(".jpeg") == path.length - 5 ||
                    path.lastIndexOf(".gif") == path.length - 4);
        }

        private function databaseNPCImageURL(value:String):String
        {
            var url:String = ((value == null) ? "" : String(value).replace(/\\/g, "/"));
            var lower:String;
            while (url.length > 0 && url.charAt(0) == "/")
            {
                url = url.substr(1);
            }
            lower = url.toLowerCase();
            if (lower.indexOf("http://") == 0 || lower.indexOf("https://") == 0)
            {
                return url;
            }
            if (lower.indexOf("gamefiles/") == 0)
            {
                url = url.substr(10);
            }
            try
            {
                return (rootClass.getFilePath() + url);
            }
            catch (e:Error)
            {
            }
            return "";
        }

        private function onPreviewImageComplete(event:Event):void
        {
            if (previewImageLoader == null)
            {
                return;
            }

            previewImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPreviewImageComplete);
            previewImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError);
            previewImageLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onPreviewImageError);

            if (previewImageLoader.content is Bitmap)
            {
                Bitmap(previewImageLoader.content).smoothing = true;
            }

            fitPreviewImage();
        }

        private function onPreviewImageError(event:Event):void
        {
            trace("DatabaseNPCPanel image preview failed: " + event);
            closeImagePreview();
        }

        private function fitPreviewImage():void
        {
            var imageBounds:Rectangle;
            var scale:Number;
            var maxWidthScale:Number;
            var imageCenterX:Number;

            if (previewImageHolder == null || previewImageLoader == null || previewViewport == null)
            {
                return;
            }

            previewImageHolder.scaleX = 1;
            previewImageHolder.scaleY = 1;
            imageBounds = previewImageLoader.getBounds(previewImageHolder);
            if (imageBounds.width <= 1 || imageBounds.height <= 1)
            {
                return;
            }

            scale = (previewViewport.height * PREVIEW_TARGET_HEIGHT_RATIO) / imageBounds.height;
            maxWidthScale = (previewViewport.width * PREVIEW_WIDTH_OVERFLOW_RATIO) / imageBounds.width;
            scale = Math.min(scale, maxWidthScale);
            scale = Math.min(scale, PREVIEW_MAX_SCALE);

            previewImageHolder.scaleX = scale;
            previewImageHolder.scaleY = scale;
            imageCenterX = ((imageBounds.left + imageBounds.right) / 2);
            previewImageHolder.x = previewViewport.x + (previewViewport.width * PREVIEW_CENTER_X_RATIO) - (imageCenterX * scale);
            previewImageHolder.y = previewViewport.y + previewViewport.height - (imageBounds.bottom * scale) - PREVIEW_VERTICAL_LIFT;
        }

        private function closeImagePreview():void
        {
            if (previewImageLoader != null)
            {
                try
                {
                    previewImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPreviewImageComplete);
                    previewImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onPreviewImageError);
                    previewImageLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onPreviewImageError);
                    previewImageLoader.close();
                }
                catch (loaderCloseError:Error)
                {
                }
                try
                {
                    previewImageLoader.unload();
                }
                catch (loaderUnloadError:Error)
                {
                }
                previewImageLoader = null;
            }

            if (previewImageHolder != null)
            {
                if (previewImageHolder.parent != null)
                {
                    previewImageHolder.parent.removeChild(previewImageHolder);
                }
                previewImageHolder = null;
            }
        }

        private function loadPreviewAppearance(mc:AvatarMC, pAV:Avatar):void
        {
            var data:Object = pAV.objData;
            var eqp:Object = ((data != null && data.eqp != null) ? data.eqp : {});
            var slot:String;
            var item:Object;
            var file:String;
            var link:String;

            // Use the exact same Avatar.loadMovieAtES() route as the live map
            // NPC. This is important on Game3098r26: class/armor SWFs and their
            // linkage/timelines are not interchangeable, and the older popup
            // preview code could route an `ar` class through loadArmor().
            for (slot in eqp)
            {
                item = eqp[slot];
                if (item == null)
                {
                    continue;
                }
                if (slot == "he" && !pAV.dataLeaf.showHelm)
                {
                    continue;
                }
                if (slot == "ba" && !pAV.dataLeaf.showCloak)
                {
                    continue;
                }

                file = clean(("sFile" in item) ? item.sFile : "");
                link = clean(("sLink" in item) ? item.sLink : "");
                if (file == "" && link == "")
                {
                    continue;
                }

                try
                {
                    pAV.loadMovieAtES(slot, file, link);
                }
                catch (equipmentError:Error)
                {
                    trace("DatabaseNPCPanel preview " + slot + " error: " + equipmentError.message);
                }
            }

            // Match normal Avatar.initAvatar() hair behavior.
            try
            {
                mc.loadHair();
            }
            catch (hairError:Error)
            {
                trace("DatabaseNPCPanel preview hair error: " + hairError.message);
            }

            try
            {
                mc.updateColor(data);
            }
            catch (colorError:Error)
            {
                // ENTER_FRAME fitting retries color once the popup is on stage.
            }
        }

        private function previewClassExists(linkage:String):Boolean
        {
            if (linkage == "" || rootClass == null || rootClass.world == null)
            {
                return false;
            }
            try
            {
                return (rootClass.world.getClass(linkage) != null);
            }
            catch (e:Error)
            {
                return false;
            }
        }

        private function readLeafBoolean(source:Avatar, key:String, fallback:Boolean):Boolean
        {
            try
            {
                if (source != null && source.dataLeaf != null && (key in source.dataLeaf))
                {
                    return Boolean(source.dataLeaf[key]);
                }
            }
            catch (e:Error)
            {
            }
            return fallback;
        }

        private function buildClassicLargePreviewViewport(holder:MovieClip):Rectangle
        {
            var panelBounds:Rectangle;
            var left:Number;
            var top:Number;
            var right:Number;
            var bottom:Number;
            var topLeftLocal:Point;
            var bottomRightLocal:Point;

            if (holder == null || panelMC == null)
            {
                return null;
            }

            panelBounds = panelMC.getBounds(this);
            left = PREVIEW_STAGE_LEFT_MARGIN;
            top = PREVIEW_STAGE_TOP_MARGIN;
            right = Math.max(left + 220, panelBounds.left - PREVIEW_STAGE_RIGHT_GAP);
            bottom = getStageHeight() - PREVIEW_STAGE_BOTTOM_MARGIN;

            topLeftLocal = holder.globalToLocal(this.localToGlobal(new Point(left, top)));
            bottomRightLocal = holder.globalToLocal(this.localToGlobal(new Point(right, bottom)));

            if (bottomRightLocal.x <= topLeftLocal.x || bottomRightLocal.y <= topLeftLocal.y)
            {
                return null;
            }

            return new Rectangle(
                topLeftLocal.x,
                topLeftLocal.y,
                bottomRightLocal.x - topLeftLocal.x,
                bottomRightLocal.y - topLeftLocal.y
            );
        }

        private function onPreviewFitFrame(event:Event):void
        {
            if (previewMC == null || previewFitFrames <= 0)
            {
                removeEventListener(Event.ENTER_FRAME, onPreviewFitFrame);
                return;
            }

            try
            {
                previewMC.updateColor(previewMC.pAV.objData);
            }
            catch (colorError:Error)
            {
            }

            fitPreviewAvatar();
            previewFitFrames--;
            if (previewFitFrames <= 0)
            {
                removeEventListener(Event.ENTER_FRAME, onPreviewFitFrame);
            }
        }

        private function fitPreviewAvatar():void
        {
            var charBounds:Rectangle;
            var scale:Number;
            var maxWidthScale:Number;
            var charCenterX:Number;

            if (previewMC == null || previewMC.mcChar == null || previewViewport == null)
            {
                return;
            }

            // Always measure at native scale, then fit the visible character only.
            previewMC.scaleX = 1;
            previewMC.scaleY = 1;
            charBounds = previewMC.mcChar.getBounds(previewMC);
            if (charBounds.width <= 1 || charBounds.height <= 1)
            {
                return;
            }

            // Gravelyn-style presentation: fit mostly by height so the body stays
            // large, and allow generous horizontal overflow for swords/capes.
            scale = (previewViewport.height * PREVIEW_TARGET_HEIGHT_RATIO) / charBounds.height;
            maxWidthScale = (previewViewport.width * PREVIEW_WIDTH_OVERFLOW_RATIO) / charBounds.width;
            scale = Math.min(scale, maxWidthScale);
            scale = Math.min(scale, PREVIEW_MAX_SCALE);

            previewMC.scaleX = scale;
            previewMC.scaleY = scale;
            charCenterX = ((charBounds.left + charBounds.right) / 2);
            previewMC.x = previewViewport.x + (previewViewport.width * PREVIEW_CENTER_X_RATIO) - (charCenterX * scale);
            previewMC.y = previewViewport.y + previewViewport.height - (charBounds.bottom * scale) - PREVIEW_VERTICAL_LIFT;
        }

        /** Create one visually-designed DatabaseNPCButtonMC per database button. */
        private function buildButtons():void
        {
            var data:Object = ((avatar != null) ? avatar.objData : null);
            var buttons:Array;
            var holder:MovieClip;
            var buttonClass:Class;
            var buttonMC:MovieClip;
            var button:Object;
            var i:int;
            var col:int;
            var row:int;
            var width:Number;
            var height:Number;

            holder = (findPanelInstance("mcButtons", false) as MovieClip);
            if (holder == null)
            {
                // Keep the popup usable even if the designer forgot the optional
                // empty mcButtons holder. A holder is created just below txtDialog.
                holder = createFallbackButtonHolder();
                trace("DatabaseNPCPanel: mcButtons was not found; using automatic fallback holder.");
            }

            buttons = ((data != null && data.dbButtons is Array) ? data.dbButtons : []);
            if (buttons.length == 0)
            {
                return;
            }

            try
            {
                buttonClass = (getDefinitionByName("DatabaseNPCButtonMC") as Class);
            }
            catch (e:Error)
            {
                throw new Error(
                    "DatabaseNPCButtonMC was not found. Export your NPC action button MovieClip for " +
                    "ActionScript with class/linkage name DatabaseNPCButtonMC."
                );
            }

            for (i = 0; i < buttons.length; i++)
            {
                button = buttons[i];
                buttonMC = (new buttonClass() as MovieClip);
                if (buttonMC == null)
                {
                    continue;
                }

                if (!("txtLabel" in buttonMC))
                {
                    throw new Error("DatabaseNPCButtonMC requires an instance named txtLabel.");
                }

                setButtonLabel(buttonMC.txtLabel, buttonLabel(button));
                applyButtonIcon(buttonMC, button);
                tryGoto(buttonMC, "up");

                width = ((buttonMC.width > 1) ? buttonMC.width : FALLBACK_BUTTON_WIDTH);
                height = ((buttonMC.height > 1) ? buttonMC.height : FALLBACK_BUTTON_HEIGHT);
                col = (i % BUTTON_COLUMNS);
                row = int(i / BUTTON_COLUMNS);
                buttonMC.x = col * (width + BUTTON_GAP_X);
                buttonMC.y = 0; // positioned after all buttons are created
                buttonMC.buttonMode = true;
                buttonMC.mouseChildren = false;

                buttonData[buttonMC] = button;
                dynamicButtons.push(buttonMC);

                buttonMC.addEventListener(MouseEvent.CLICK, onActionClick, false, 0, true);
                buttonMC.addEventListener(MouseEvent.MOUSE_OVER, onActionOver, false, 0, true);
                buttonMC.addEventListener(MouseEvent.MOUSE_OUT, onActionOut, false, 0, true);
                buttonMC.addEventListener(MouseEvent.MOUSE_DOWN, onActionDown, false, 0, true);
                buttonMC.addEventListener(MouseEvent.MOUSE_UP, onActionUp, false, 0, true);

                holder.addChild(buttonMC);
            }

            layoutButtonsBottomUp(holder);
        }

        /**
         * Position action buttons from the bottom of the panel upward. The first
         * database button is the bottom-most button, so a single button always
         * sits at the bottom instead of floating in the middle of the dialog.
         */
        private function layoutButtonsBottomUp(holder:MovieClip):void
        {
            var panelBounds:Rectangle;
            var globalBottom:Point;
            var localBottom:Point;
            var cursorY:Number;
            var buttonMC:MovieClip;
            var width:Number;
            var height:Number;
            var i:int;
            var col:int;

            if (holder == null || panelMC == null || dynamicButtons.length == 0)
            {
                return;
            }

            // IMPORTANT: do not call panelMC.getBounds(panelMC) here after the
            // buttons have been added. Their own bounds would enlarge the panel
            // and push the stack farther down on every layout pass. Use the FLA
            // artwork bounds captured before runtime buttons existed.
            panelBounds = ((panelDesignBounds != null) ? panelDesignBounds : panelMC.getBounds(panelMC));
            globalBottom = panelMC.localToGlobal(new Point(panelBounds.left, panelBounds.bottom - BUTTON_BOTTOM_MARGIN));
            localBottom = holder.globalToLocal(globalBottom);
            cursorY = localBottom.y;

            for (i = 0; i < dynamicButtons.length; i++)
            {
                buttonMC = (dynamicButtons[i] as MovieClip);
                if (buttonMC == null)
                {
                    continue;
                }

                width = ((buttonMC.width > 1) ? buttonMC.width : FALLBACK_BUTTON_WIDTH);
                height = ((buttonMC.height > 1) ? buttonMC.height : FALLBACK_BUTTON_HEIGHT);
                col = (i % BUTTON_COLUMNS);

                cursorY -= height;
                buttonMC.x = col * (width + BUTTON_GAP_X);
                buttonMC.y = cursorY;
                cursorY -= BUTTON_GAP_Y;
            }
        }

        /**
         * Populate mcIcon from the database Icon value.
         *
         * Preferred behavior is the stock AQW linkage path: values such as
         * iwarmor, iidesign, iwsword, etc. are resolved through World.getClass()
         * and instantiated inside the designer-created mcIcon holder.
         *
         * A timeline label with the same name is still supported as a fallback.
         */
        private function applyButtonIcon(buttonMC:MovieClip, button:Object):void
        {
            var iconName:String = clean(
                (("strIcon" in button) ? button.strIcon : (("Icon" in button) ? button.Icon : ""))
            );
            var iconMC:MovieClip;
            var iconClass:Class;
            var iconDisplay:DisplayObject;
            var oldIcon:DisplayObject;
            var holderBounds:Rectangle;
            var sourceBounds:Rectangle;
            var targetWidth:Number;
            var targetHeight:Number;
            var scale:Number;

            if (!("mcIcon" in buttonMC) || iconName == "")
            {
                return;
            }

            // Legacy data occasionally contains a comma-delimited icon list.
            // NPC buttons use the first icon.
            if (iconName.indexOf(",") > -1)
            {
                iconName = iconName.split(",")[0];
            }

            iconMC = (buttonMC.mcIcon as MovieClip);
            if (iconMC == null)
            {
                return;
            }

            oldIcon = iconMC.getChildByName("__databaseNPCButtonIcon");
            if (oldIcon != null)
            {
                iconMC.removeChild(oldIcon);
            }

            try
            {
                if (rootClass != null && rootClass.world != null)
                {
                    iconClass = (rootClass.world.getClass(iconName) as Class);
                }
            }
            catch (e:Error)
            {
                iconClass = null;
            }

            if (iconClass != null)
            {
                try
                {
                    iconDisplay = (new iconClass() as DisplayObject);
                    if (iconDisplay != null)
                    {
                        holderBounds = iconMC.getBounds(iconMC);
                        targetWidth = ((holderBounds.width > 2) ? holderBounds.width : 32);
                        targetHeight = ((holderBounds.height > 2) ? holderBounds.height : 32);

                        sourceBounds = iconDisplay.getBounds(iconDisplay);
                        if (sourceBounds.width > 0 && sourceBounds.height > 0)
                        {
                            scale = Math.min(
                                (targetWidth * 0.82) / sourceBounds.width,
                                (targetHeight * 0.82) / sourceBounds.height
                            );
                            iconDisplay.scaleX = scale;
                            iconDisplay.scaleY = scale;
                            iconDisplay.x = holderBounds.x + ((targetWidth - (sourceBounds.width * scale)) / 2) - (sourceBounds.x * scale);
                            iconDisplay.y = holderBounds.y + ((targetHeight - (sourceBounds.height * scale)) / 2) - (sourceBounds.y * scale);
                        }

                        iconDisplay.name = "__databaseNPCButtonIcon";
                        if (iconDisplay is InteractiveObject)
                        {
                            InteractiveObject(iconDisplay).mouseEnabled = false;
                        }
                        iconMC.addChild(iconDisplay);
                        return;
                    }
                }
                catch (iconError:Error)
                {
                    trace("DatabaseNPCPanel icon instantiate error for " + iconName + ": " + iconError.message);
                }
            }

            // Designer-controlled timeline icon fallback.
            if (hasFrameLabel(iconMC, iconName))
            {
                iconMC.gotoAndStop(iconName);
            }
            else
            {
                trace("DatabaseNPCPanel: icon linkage not found: " + iconName);
            }
        }

        private function hookCloseButton():void
        {
            var closeDisplay:DisplayObject = findPanelInstance("btnClose", true);
            closeButton = (closeDisplay as InteractiveObject);
            if (closeButton == null)
            {
                throw new Error("DatabaseNPCPanelMC.btnClose must be a Button, MovieClip, Sprite, or other InteractiveObject.");
            }

            // Animate Button symbols compile as SimpleButton. MovieClip/Sprite
            // close controls are supported too.
            if (closeButton is Sprite)
            {
                Sprite(closeButton).buttonMode = true;
            }
            if (closeButton is SimpleButton)
            {
                SimpleButton(closeButton).useHandCursor = true;
            }

            closeButton.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            closeButton.addEventListener(MouseEvent.MOUSE_OVER, onCloseOver, false, 0, true);
            closeButton.addEventListener(MouseEvent.MOUSE_OUT, onCloseOut, false, 0, true);
            closeButton.addEventListener(MouseEvent.MOUSE_DOWN, onCloseDown, false, 0, true);
            closeButton.addEventListener(MouseEvent.MOUSE_UP, onCloseUp, false, 0, true);

            // SimpleButton already owns its Up/Over/Down states. Timeline labels
            // are only applied when the close control is actually a MovieClip.
            if (closeButton is MovieClip)
            {
                tryGoto(MovieClip(closeButton), "up");
            }
        }

        private function onActionClick(event:MouseEvent):void
        {
            var buttonMC:MovieClip = (event.currentTarget as MovieClip);
            var data:Object;
            var npcAvatar:Avatar;
            var worldRef:*;
            if (buttonMC == null)
            {
                return;
            }

            // Keep everything needed by the action before removing this modal.
            data = buttonData[buttonMC];
            npcAvatar = avatar;
            worldRef = ((rootClass != null) ? rootClass.world : null);

            // IMPORTANT: close first. Stock quest UI refuses to open while a
            // conflicting modal is still in ModalStack. This was why database
            // NPC Quest buttons appeared to do nothing.
            close();

            if (data != null && worldRef != null)
            {
                worldRef.executeDatabaseNPCButton(data, npcAvatar);
            }
        }

        private function onActionOver(event:MouseEvent):void
        {
            tryGoto(event.currentTarget as MovieClip, "over");
        }

        private function onActionOut(event:MouseEvent):void
        {
            tryGoto(event.currentTarget as MovieClip, "up");
        }

        private function onActionDown(event:MouseEvent):void
        {
            tryGoto(event.currentTarget as MovieClip, "down");
        }

        private function onActionUp(event:MouseEvent):void
        {
            tryGoto(event.currentTarget as MovieClip, "over");
        }

        private function onCloseClick(event:MouseEvent):void
        {
            close();
        }

        private function onCloseOver(event:MouseEvent):void
        {
            if (event.currentTarget is MovieClip)
            {
                tryGoto(MovieClip(event.currentTarget), "over");
            }
        }

        private function onCloseOut(event:MouseEvent):void
        {
            if (event.currentTarget is MovieClip)
            {
                tryGoto(MovieClip(event.currentTarget), "up");
            }
        }

        private function onCloseDown(event:MouseEvent):void
        {
            if (event.currentTarget is MovieClip)
            {
                tryGoto(MovieClip(event.currentTarget), "down");
            }
        }

        private function onCloseUp(event:MouseEvent):void
        {
            if (event.currentTarget is MovieClip)
            {
                tryGoto(MovieClip(event.currentTarget), "over");
            }
        }

        /** Remove listeners and close the modal. */
        public function close():void
        {
            var i:int;
            var buttonMC:MovieClip;

            for (i = 0; i < dynamicButtons.length; i++)
            {
                buttonMC = (dynamicButtons[i] as MovieClip);
                if (buttonMC != null)
                {
                    buttonMC.removeEventListener(MouseEvent.CLICK, onActionClick);
                    buttonMC.removeEventListener(MouseEvent.MOUSE_OVER, onActionOver);
                    buttonMC.removeEventListener(MouseEvent.MOUSE_OUT, onActionOut);
                    buttonMC.removeEventListener(MouseEvent.MOUSE_DOWN, onActionDown);
                    buttonMC.removeEventListener(MouseEvent.MOUSE_UP, onActionUp);
                }
            }
            dynamicButtons.length = 0;

            if (closeButton != null)
            {
                closeButton.removeEventListener(MouseEvent.CLICK, onCloseClick);
                closeButton.removeEventListener(MouseEvent.MOUSE_OVER, onCloseOver);
                closeButton.removeEventListener(MouseEvent.MOUSE_OUT, onCloseOut);
                closeButton.removeEventListener(MouseEvent.MOUSE_DOWN, onCloseDown);
                closeButton.removeEventListener(MouseEvent.MOUSE_UP, onCloseUp);
                closeButton = null;
            }

            removeEventListener(Event.ENTER_FRAME, onPreviewFitFrame);
            previewFitFrames = 0;
            if (previewMC != null)
            {
                try
                {
                    previewMC.fClose();
                }
                catch (previewCloseError:Error)
                {
                }
                if (previewMC.parent != null)
                {
                    previewMC.parent.removeChild(previewMC);
                }
                previewMC = null;
            }
            closeImagePreview();
            previewViewport = null;

            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        /**
         * Resolve timeline instance names safely. Timeline-generated symbols do
         * not always expose named children as dynamic properties, especially
         * when stage-instance auto declaration settings differ between FLAs.
         */
        private function findPanelInstance(instanceName:String, required:Boolean = true):DisplayObject
        {
            var value:*;
            var found:DisplayObject;

            if (panelMC == null)
            {
                if (required)
                {
                    throw new Error("DatabaseNPCPanelMC has not been created.");
                }
                return null;
            }

            try
            {
                if ((instanceName in panelMC) && panelMC[instanceName] != null)
                {
                    value = panelMC[instanceName];
                    if (value is DisplayObject)
                    {
                        return DisplayObject(value);
                    }
                }
            }
            catch (e:Error)
            {
            }

            found = findDescendantByName(panelMC, instanceName);
            if (found == null && required)
            {
                throw new Error("DatabaseNPCPanelMC is missing required instance: " + instanceName);
            }
            return found;
        }

        private function findDescendantByName(container:DisplayObjectContainer, instanceName:String):DisplayObject
        {
            var direct:DisplayObject;
            var child:DisplayObject;
            var nested:DisplayObject;
            var i:int;

            if (container == null)
            {
                return null;
            }

            direct = container.getChildByName(instanceName);
            if (direct != null)
            {
                return direct;
            }

            for (i = 0; i < container.numChildren; i++)
            {
                child = container.getChildAt(i);
                if (child is DisplayObjectContainer)
                {
                    nested = findDescendantByName(DisplayObjectContainer(child), instanceName);
                    if (nested != null)
                    {
                        return nested;
                    }
                }
            }
            return null;
        }

        private function createFallbackButtonHolder():MovieClip
        {
            var holder:MovieClip = new MovieClip();
            var dialog:DisplayObject = findPanelInstance("txtDialog", false);
            holder.name = "mcButtons";

            if (dialog != null)
            {
                holder.x = dialog.x;
                holder.y = dialog.y + dialog.height + 10;
            }
            else
            {
                holder.x = 18;
                holder.y = 150;
            }

            panelMC.addChild(holder);
            return holder;
        }

        /** Keep all button typography exactly as authored in the FLA. */
        private function setButtonLabel(field:Object, value:String):void
        {
            setFieldText(field, value);
        }

        private function setFieldText(field:Object, value:String):void
        {
            if (field == null)
            {
                return;
            }

            if (field is TextField)
            {
                TextField(field).text = value;
                return;
            }

            // Supports custom text components that expose a .text property.
            try
            {
                field.text = value;
            }
            catch (e:Error)
            {
                trace("DatabaseNPCPanel text field does not expose .text");
            }
        }

        private function buttonLabel(button:Object):String
        {
            var text:String = clean(
                (("strText" in button) ? button.strText : (("Text" in button) ? button.Text : ""))
            );
            var action:String = clean(
                (("strAction" in button) ? button.strAction : (("Action" in button) ? button.Action : "Action"))
            );
            return ((text != "") ? text : action);
        }

        private function clean(value:*):String
        {
            if (value == null)
            {
                return "";
            }
            var text:String = String(value);
            if (text == "null" || text == "undefined")
            {
                return "";
            }
            return text;
        }

        private function tryGoto(mc:MovieClip, label:String):void
        {
            if (mc == null || !hasFrameLabel(mc, label))
            {
                return;
            }
            try
            {
                mc.gotoAndStop(label);
            }
            catch (e:Error)
            {
            }
        }

        private function hasFrameLabel(mc:MovieClip, label:String):Boolean
        {
            var labels:Array;
            var frameLabel:FrameLabel;
            var i:int;
            if (mc == null || label == null || label == "")
            {
                return false;
            }

            labels = mc.currentLabels;
            for (i = 0; i < labels.length; i++)
            {
                frameLabel = (labels[i] as FrameLabel);
                if (frameLabel != null && frameLabel.name == label)
                {
                    return true;
                }
            }
            return false;
        }

        private function getStageWidth():Number
        {
            if (rootClass != null && rootClass.stage != null && rootClass.stage.stageWidth > 0)
            {
                return rootClass.stage.stageWidth;
            }
            return 960;
        }

        private function getStageHeight():Number
        {
            if (rootClass != null && rootClass.stage != null && rootClass.stage.stageHeight > 0)
            {
                return rootClass.stage.stageHeight;
            }
            return 550;
        }
    }
}
