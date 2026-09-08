package
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.system.ApplicationDomain;

    /**
     * Database-driven map arrow.
     *
     * FLA artwork:
     *   Create a MovieClip in the Client FLA named/exported as:
     *       DatabaseMapArrowArt
     *
     * Draw that symbol pointing RIGHT with its registration point centered.
     *
     * FLA frames:
     *   frame label "room" = GOLD version
     *   frame label "map"  = SILVER version
     *
     * The code selects the correct design from TargetType and supports any
     * clockwise database Rotation angle. Legacy Left/Right/Up/Down still work.
     *
     * The arrow is NOT clickable and does NOT bob/hover/animate.
     * It activates only when the player walks into the invisible trigger area.
     */
    public class DatabaseMapArrow extends MovieClip
    {
        private static const ART_LINKAGE:String = "DatabaseMapArrowArt";

        // Walk-over trigger size. This is independent from the visible FLA art.
        private static const TRIGGER_WIDTH:Number = 76;
        private static const TRIGGER_HEIGHT:Number = 54;

        // Legacy AQW map-marker compatibility. World.cellSetup() historically
        // reads these properties directly from every MovieClip in the map.
        // DatabaseMapArrow is a sealed AS3 class, so missing properties throw
        // Error #1069 instead of behaving like timeline-defined MovieClips.
        public var hasPads:Boolean = false;
        public var isSolid:Boolean = false;
        public var isEvent:Boolean = false;
        public var isProp:Boolean = false;
        public var isMonster:Boolean = false;

        private var world:World;
        private var data:Object;

        private var hitAreaMC:Sprite;
        private var arrowArt:DisplayObject;

        private var wasInside:Boolean = false;
        private var active:Boolean = true;

        public function DatabaseMapArrow(worldRef:World, row:Object)
        {
            super();

            world = worldRef;
            data = row;

            name = "dbMapArrow_" + String(
                (row != null && ("ArrowID" in row)) ? row.ArrowID : "0"
            );

            // This object is a world trigger, never a UI button.
            mouseEnabled = false;
            mouseChildren = false;
            buttonMode = false;
            useHandCursor = false;
            tabEnabled = false;

            createTrigger();
            createArrowArt();
            applyDestinationStyle();
            orientArrow();

            addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
        }

        /**
         * Invisible walk-over trigger.
         * It intentionally does not depend on the size of DatabaseMapArrowArt.
         */
        private function createTrigger():void
        {
            hitAreaMC = new Sprite();
            hitAreaMC.name = "dbArrowTrigger";

            hitAreaMC.graphics.beginFill(0x000000, 0);
            hitAreaMC.graphics.drawRect(
                -(TRIGGER_WIDTH / 2),
                -(TRIGGER_HEIGHT / 2),
                TRIGGER_WIDTH,
                TRIGGER_HEIGHT
            );
            hitAreaMC.graphics.endFill();

            hitAreaMC.mouseEnabled = false;
            addChild(hitAreaMC);
        }

        /**
         * Loads the visual arrow from the Client FLA library.
         *
         * Required FLA symbol:
         *   Symbol name: DatabaseMapArrowArt
         *   Export for ActionScript: enabled
         *   Class: DatabaseMapArrowArt
         *   Base class: flash.display.MovieClip
         */
        private function createArrowArt():void
        {
            var domain:ApplicationDomain;
            var ArtClass:Class;
            var instance:Object;

            try
            {
                domain = ApplicationDomain.currentDomain;

                if (domain != null && domain.hasDefinition(ART_LINKAGE))
                {
                    ArtClass = domain.getDefinition(ART_LINKAGE) as Class;
                    instance = new ArtClass();

                    if (instance is DisplayObject)
                    {
                        arrowArt = DisplayObject(instance);
                    }
                }
            }
            catch (e:Error)
            {
                trace(
                    "[DatabaseMapArrow] Could not create " +
                    ART_LINKAGE + ": " + e.message
                );
            }

            // Safe fallback so arrows still function if the FLA linkage
            // was forgotten or has not been added yet.
            if (arrowArt == null)
            {
                trace(
                    "[DatabaseMapArrow] FLA linkage '" +
                    ART_LINKAGE +
                    "' was not found. Using fallback artwork."
                );

                arrowArt = createFallbackArrow();
            }

            arrowArt.name = "arrowArt";
            arrowArt.mouseEnabled = false;

            if (arrowArt is DisplayObjectContainer)
            {
                DisplayObjectContainer(arrowArt).mouseChildren = false;
            }

            // Keep the FLA symbol static. There is no hover/bobbing animation.
            if (arrowArt is MovieClip)
            {
                MovieClip(arrowArt).stop();
            }

            addChild(arrowArt);
        }

        /**
         * Temporary fallback shown only when DatabaseMapArrowArt is missing
         * from the Client FLA.
         */
        private function createFallbackArrow():Sprite
        {
            var art:Sprite = new Sprite();

            art.graphics.lineStyle(4, 0x171006, 1, true);
            art.graphics.beginFill(0xE2A51A, 1);

            art.graphics.moveTo(-28, -12);
            art.graphics.lineTo(3, -12);
            art.graphics.lineTo(3, -21);
            art.graphics.lineTo(31, 0);
            art.graphics.lineTo(3, 21);
            art.graphics.lineTo(3, 12);
            art.graphics.lineTo(-28, 12);
            art.graphics.lineTo(-28, -12);

            art.graphics.endFill();

            art.mouseEnabled = false;
            return art;
        }

        /**
         * FLA design convention:
         *
         * DatabaseMapArrowArt frame label "room" = GOLD room arrow
         * DatabaseMapArrowArt frame label "map"  = SILVER map arrow
         *
         * If labels are not present, frame 1 is used for Room and frame 2
         * is used for Map when the MovieClip has at least two frames.
         */
        private function applyDestinationStyle():void
        {
            var artMC:MovieClip;
            var targetType:String;
            var fallbackFrame:int;

            if (!(arrowArt is MovieClip))
            {
                return;
            }

            artMC = MovieClip(arrowArt);

            targetType = String(
                (data != null && ("TargetType" in data))
                ? data.TargetType
                : "Room"
            ).toLowerCase();

            fallbackFrame = (targetType == "map" && artMC.totalFrames >= 2) ? 2 : 1;

            try
            {
                if (targetType == "map")
                {
                    artMC.gotoAndStop("map");
                }
                else
                {
                    artMC.gotoAndStop("room");
                }
            }
            catch (e:Error)
            {
                artMC.gotoAndStop(fallbackFrame);
            }
        }

        /**
         * DatabaseMapArrowArt must be drawn pointing RIGHT.
         * Only the artwork rotates; the walk-over trigger stays centered.
         */
        private function orientArrow():void
        {
            var direction:String;
            var rotationValue:Number;

            if (arrowArt == null)
            {
                return;
            }

            // New database Rotation field wins when present.
            // Flash rotation is clockwise, which maps naturally to:
            //   0   Right
            //   45  Down-Right
            //   90  Down
            //   180 Left
            //   270 Up
            if (
                data != null &&
                ("Rotation" in data) &&
                data.Rotation !== null &&
                String(data.Rotation) != ""
            )
            {
                rotationValue = Number(data.Rotation);

                if (!isNaN(rotationValue))
                {
                    rotationValue = (rotationValue % 360);
                    if (rotationValue < 0)
                    {
                        rotationValue += 360;
                    }

                    arrowArt.rotation = rotationValue;
                    return;
                }
            }

            // Backward compatibility for old rows with no Rotation value.
            direction = String(
                (data != null && ("Direction" in data))
                ? data.Direction
                : "Right"
            ).toLowerCase();

            switch (direction)
            {
                case "slight down-right":
                    arrowArt.rotation = 22.5;
                    break;

                case "down-right":
                    arrowArt.rotation = 45;
                    break;

                case "steep down-right":
                    arrowArt.rotation = 67.5;
                    break;

                case "down":
                    arrowArt.rotation = 90;
                    break;

                case "steep down-left":
                    arrowArt.rotation = 112.5;
                    break;

                case "down-left":
                    arrowArt.rotation = 135;
                    break;

                case "slight down-left":
                    arrowArt.rotation = 157.5;
                    break;

                case "left":
                    arrowArt.rotation = 180;
                    break;

                case "slight up-left":
                    arrowArt.rotation = 202.5;
                    break;

                case "up-left":
                    arrowArt.rotation = 225;
                    break;

                case "steep up-left":
                    arrowArt.rotation = 247.5;
                    break;

                case "up":
                    arrowArt.rotation = 270;
                    break;

                case "steep up-right":
                    arrowArt.rotation = 292.5;
                    break;

                case "up-right":
                    arrowArt.rotation = 315;
                    break;

                case "slight up-right":
                    arrowArt.rotation = 337.5;
                    break;

                case "right":
                default:
                    arrowArt.rotation = 0;
                    break;
            }
        }

        /**
         * Walk-over detection only.
         * No MouseEvent listeners are used anywhere in this class.
         */
        private function onEnterFrame(event:Event):void
        {
            var point:Point;
            var localPoint:Point;
            var inside:Boolean = false;

            if (
                !active ||
                world == null ||
                world.myAvatar == null ||
                world.myAvatar.pMC == null ||
                hitAreaMC == null
            )
            {
                return;
            }

            try
            {
                // Player registration point -> global -> arrow-local coordinates.
                point = world.myAvatar.pMC.localToGlobal(new Point(0, 0));
                localPoint = globalToLocal(point);

                inside =
                    localPoint.x >= -(TRIGGER_WIDTH / 2) &&
                    localPoint.x <=  (TRIGGER_WIDTH / 2) &&
                    localPoint.y >= -(TRIGGER_HEIGHT / 2) &&
                    localPoint.y <=  (TRIGGER_HEIGHT / 2);
            }
            catch (e:Error)
            {
                inside = false;
            }

            // Fire once when the player ENTERS the trigger.
            if (inside && !wasInside)
            {
                activate();
            }

            wasInside = inside;
        }

        private function activate():void
        {
            var targetType:String;
            var targetFrame:String;
            var targetPad:String;
            var targetMap:String;

            if (!active || world == null || data == null)
            {
                return;
            }

            active = false;

            targetType = String(
                ("TargetType" in data) ? data.TargetType : "Room"
            ).toLowerCase();

            targetFrame = clean(
                ("TargetFrame" in data) ? data.TargetFrame : "Enter",
                "Enter"
            );

            targetPad = clean(
                ("TargetPad" in data) ? data.TargetPad : "Spawn",
                "Spawn"
            );

            if (targetType == "map")
            {
                targetMap = clean(
                    ("TargetMapName" in data) ? data.TargetMapName : "",
                    ""
                );

                if (targetMap != "")
                {
                    world.gotoTown(targetMap, targetFrame, targetPad);
                    active = true;
                    return;
                }
            }
            else
            {
                world.moveToCell(targetFrame, targetPad);
                active = true;
                return;
            }

            active = true;
        }

        private function clean(value:*, fallback:String):String
        {
            var text:String = (value == null) ? "" : String(value);
            return text == "" ? fallback : text;
        }

        public function dispose():void
        {
            active = false;
            wasInside = false;

            removeEventListener(Event.ENTER_FRAME, onEnterFrame);

            if (arrowArt != null && arrowArt.parent == this)
            {
                removeChild(arrowArt);
            }

            if (hitAreaMC != null && hitAreaMC.parent == this)
            {
                removeChild(hitAreaMC);
            }

            arrowArt = null;
            hitAreaMC = null;
            world = null;
            data = null;
        }
    }
}
