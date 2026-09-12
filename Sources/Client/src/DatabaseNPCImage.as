package
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.geom.Rectangle;

    /**
     * Static PNG/JPG renderer for database NPCs.
     *
     * The parent AvatarMC remains the authoritative NPC actor. This class only
     * replaces the visible mcChar artwork when the database Image field is set.
     */
    public class DatabaseNPCImage extends MovieClip
    {
        private var world:World;
        private var avatar:Avatar;
        private var owner:AvatarMC;
        private var imageURL:String;
        private var requestedScale:Number;
        private var offsetX:Number;
        private var offsetY:Number;
        private var facing:String;

        private var art:MovieClip;
        private var loader:Loader;
        private var disposed:Boolean = false;

        public function DatabaseNPCImage(
            worldRef:World,
            avatarRef:Avatar,
            url:String,
            scaleValue:Number=1,
            xOffset:Number=0,
            yOffset:Number=0,
            turn:String="right"
        )
        {
            super();

            world = worldRef;
            avatar = avatarRef;
            owner = ((avatar != null) ? (avatar.pMC as AvatarMC) : null);
            imageURL = url;
            requestedScale = scaleValue;
            offsetX = xOffset;
            offsetY = yOffset;
            facing = ((turn != null) ? turn.toLowerCase() : "right");

            if (isNaN(requestedScale) || requestedScale <= 0)
            {
                requestedScale = 1;
            }

            buttonMode = true;
            mouseChildren = false;
            addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);

            art = new MovieClip();
            art.mouseEnabled = false;
            art.mouseChildren = false;
            addChild(art);

            loader = new Loader();
            loader.mouseEnabled = false;
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError, false, 0, true);
            art.addChild(loader);

            try
            {
                loader.load(new URLRequest(imageURL));
            }
            catch(e:Error)
            {
                trace("DatabaseNPCImage load start failed: " + imageURL + " | " + e.message);
                restoreFallbackAvatar();
            }
        }

        private function onImageComplete(e:Event):void
        {
            if (disposed || loader == null || loader.content == null)
            {
                return;
            }

            try
            {
                if (loader.content is Bitmap)
                {
                    Bitmap(loader.content).smoothing = true;
                }

                // Anchor the image at the NPC's feet: horizontal center at x=0,
                // bottom edge at y=0. Database offsets are then applied in map px.
                loader.x = -(loader.content.width * 0.5);
                loader.y = -(loader.content.height);

                var worldScale:Number = ((world != null) ? world.SCALE : 1);
                if (isNaN(worldScale) || worldScale <= 0)
                {
                    worldScale = 1;
                }

                var finalScale:Number = requestedScale * worldScale;
                art.scaleX = ((facing == "left") ? -(finalScale) : finalScale);
                art.scaleY = finalScale;
                art.x = offsetX;
                art.y = offsetY;

                // Give the static image a reliable click target even though the
                // Loader itself is mouse-disabled. This keeps image NPCs opening
                // the same popup as equipment-driven NPCs.
                var hitBounds:Rectangle = art.getBounds(this);
                graphics.clear();
                graphics.beginFill(0x000000, 0.001);
                graphics.drawRect(hitBounds.x, hitBounds.y, hitBounds.width, hitBounds.height);
                graphics.endFill();

                updateNameplatePosition();
                dispatchEvent(new Event(Event.COMPLETE));
            }
            catch(err:Error)
            {
                trace("DatabaseNPCImage complete error: " + imageURL + " | " + err.message);
                restoreFallbackAvatar();
            }
        }

        private function updateNameplatePosition():void
        {
            if (owner == null)
            {
                return;
            }

            try
            {
                var bounds:Rectangle = getBounds(owner);
                if (bounds.height > 1)
                {
                    owner.pname.y = int(bounds.top - 4);
                    owner.bubble.y = int(owner.pname.y - owner.bubble.height);
                    owner.ignore.y = int((owner.pname.y - owner.ignore.height) - 2);
                }
            }
            catch(e:Error)
            {
            }
        }

        private function onImageError(e:IOErrorEvent):void
        {
            trace("Database NPC image failed: " + imageURL + " | " + e.text);
            restoreFallbackAvatar();
        }

        private function restoreFallbackAvatar():void
        {
            if (owner == null)
            {
                return;
            }

            try
            {
                owner.mcChar.visible = true;
                owner.mcChar.mouseEnabled = true;
                owner.shadow.visible = true;
                owner.shadow.mouseEnabled = true;
                owner.cShadow.visible = true;
            }
            catch(e:Error)
            {
            }
        }

        private function onClick(e:MouseEvent):void
        {
            e.stopPropagation();
            if (world != null && avatar != null)
            {
                world.openDatabaseNPC(avatar);
            }
        }

        private function onRemoved(e:Event):void
        {
            dispose();
        }

        public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            disposed = true;

            removeEventListener(MouseEvent.CLICK, onClick);
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);

            if (loader != null)
            {
                try
                {
                    loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageComplete);
                    loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onImageError);
                    loader.close();
                }
                catch(e:Error)
                {
                }
            }
        }
    }
}
