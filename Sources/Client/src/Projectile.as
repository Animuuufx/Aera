// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Projectile

package 
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.utils.getTimer;
    import flash.events.Event;

    public class Projectile extends MovieClip 
    {

        private const velocity:Number = 1500;

        private var rootClass:MovieClip;
        private var interPoint:Point = new Point();
        private var pointStart:Point;
        private var mc:MovieClip;
        private var startTime:Number = 0;
        private var curTime:Number;
        private var timeTotal:Number;
        private var mcParent:MovieClip;
        private var xPos:Number;
        private var yPos:Number;
        private var tempPoint:Point;

        public function Projectile(_arg_1:Point, _arg_2:Point, _arg_3:MovieClip, _arg_4:MovieClip)
        {
            rootClass = _arg_4;
            pointStart = _arg_1;
            interPoint.x = (_arg_2.x - _arg_1.x);
            interPoint.y = (_arg_2.y - _arg_1.y);
            mc = _arg_3;
            mc.scaleX = ((interPoint.x < 0) ? (mc.scaleX * -1) : mc.scaleX);
            mcParent = MovieClip(mc.parent);
            var _local_5:Number = (_arg_2.x - _arg_1.x);
            var _local_6:Number = (_arg_2.y - _arg_1.y);
            var _local_7:Number = Math.sqrt(((_local_5 * _local_5) + (_local_6 * _local_6)));
            timeTotal = (1000 * (_local_7 / velocity));
            startTime = getTimer();
            this.addEventListener(Event.ENTER_FRAME, onEnter, false, 0, true);
        }

        private function onEnter(_arg_1:Event):void
        {
            curTime = (getTimer() - startTime);
            curTime = ((curTime >= timeTotal) ? timeTotal : curTime);
            xPos = (pointStart.x + (interPoint.x * (curTime / timeTotal)));
            yPos = (pointStart.y + (interPoint.y * (curTime / timeTotal)));
            mc.x = (pointStart.x + (interPoint.x * (curTime / timeTotal)));
            mc.y = (pointStart.y + (interPoint.y * (curTime / timeTotal)));
            if (curTime >= timeTotal)
            {
                mc.visible = false;
                mcParent.removeChild(mc);
                this.removeEventListener(Event.ENTER_FRAME, onEnter);
                return;
            };
        }


    }
}//package 

