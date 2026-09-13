// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFElementScrollBar

package 
{
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFElementScrollBar extends MovieClip 
    {

        public var h:MovieClip;
        public var a1:MovieClip;
        public var a2:MovieClip;
        public var b:MovieClip;
        public var hit:MovieClip;
        private var mDown:Boolean = false;
        private var subjectMask:MovieClip;
        private var subject:MovieClip;
        private var hRun:int = 0;
        private var dRun:int = 0;
        private var mbY:int = 0;
        private var mhY:int = 0;
        private var mbD:int = 0;
        private var qly:int = 70;
        private var qdy:int = 58;
        private var defaultCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        private var greyCT:ColorTransform = new ColorTransform(0.4, 0.4, 0.4, 1, -20, -20, -20, 0);
        public var fParent:LPFFrame;

        public function LPFElementScrollBar():void
        {
            hit.buttonMode = true;
            a1.buttonMode = true;
            a2.buttonMode = true;
        }

        public function fOpen(_arg_1:Object):void
        {
            subjectMask = _arg_1.subjectMask;
            subject = _arg_1.subject;
            hRun = (b.height - h.height);
            dRun = ((subject.height - subjectMask.height) + 20);
            if ((((_arg_1.reset) || (!("oy" in subject))) || (subject.height <= subjectMask.height)))
            {
                if (subject.height <= subjectMask.height)
                {
                    subject.y = 24;
                };
                subject.oy = subject.y;
                h.y = 0;
            };
            h.removeEventListener(Event.ENTER_FRAME, hEF);
            hit.removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
            a1.removeEventListener(MouseEvent.CLICK, onUpArrowClick);
            a2.removeEventListener(MouseEvent.CLICK, onDnArrowClick);
            hit.alpha = 0;
            if (subject.height > subjectMask.height)
            {
                h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                hit.addEventListener(MouseEvent.MOUSE_DOWN, onMDown, false, 0, true);
                a1.addEventListener(MouseEvent.CLICK, onUpArrowClick, false, 0, true);
                a2.addEventListener(MouseEvent.CLICK, onDnArrowClick, false, 0, true);
                transform.colorTransform = defaultCT;
            }
            else
            {
                transform.colorTransform = greyCT;
            };
            parent.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
            parent.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
        }

        public function fClose():void
        {
            removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
            removeEventListener(MouseEvent.MOUSE_UP, onMUp);
            a1.removeEventListener(MouseEvent.CLICK, onUpArrowClick);
            a2.removeEventListener(MouseEvent.CLICK, onDnArrowClick);
            parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
            parent.removeChild(this);
        }

        protected function fDraw():void
        {
        }

        public function subscribeTo(_arg_1:LPFFrame):void
        {
            fParent = _arg_1;
        }

        private function onWheel(_arg_1:MouseEvent):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (_arg_1.delta > 0)
            {
                _local_2 = 0;
                while (_local_2 < _arg_1.delta)
                {
                    a1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    _local_2++;
                };
            }
            else
            {
                _local_3 = 0;
                while (_local_3 < (_arg_1.delta * -1))
                {
                    a2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    _local_3++;
                };
            };
        }

        private function onUpArrowClick(_arg_1:MouseEvent):void
        {
            var _local_2:int = int(((1.1 * subject.height) / (subject.numChildren - 1)));
            var _local_3:int = int(Math.ceil((hRun * (_local_2 / subject.height))));
            h.y = (h.y - _local_3);
            if ((h.y + h.height) > b.height)
            {
                h.y = int((b.height - h.height));
            };
            if (h.y < 0)
            {
                h.y = 0;
            };
        }

        private function onDnArrowClick(_arg_1:MouseEvent):void
        {
            var _local_2:int = int(((1.1 * subject.height) / subject.numChildren));
            var _local_3:int = int(Math.ceil((hRun * (_local_2 / subject.height))));
            h.y = (h.y + _local_3);
            if ((h.y + h.height) > b.height)
            {
                h.y = int((b.height - h.height));
            };
            if (h.y < 0)
            {
                h.y = 0;
            };
        }

        private function onMDown(_arg_1:MouseEvent):*
        {
            if (!h.hitTestPoint(mouseX, mouseY))
            {
                h.y = (mouseY - int((h.height / 2)));
                if ((h.y + h.height) > b.height)
                {
                    h.y = int((b.height - h.height));
                };
                if (h.y < 0)
                {
                    h.y = 0;
                };
            };
            mbY = int(mouseY);
            mhY = int(h.y);
            mDown = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, onMUp, false, 0, true);
        }

        private function onMUp(_arg_1:MouseEvent):*
        {
            mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
        }

        private function hEF(_arg_1:Event):*
        {
            if (mDown)
            {
                mbD = (int(mouseY) - mbY);
                h.y = (mhY + mbD);
                if ((h.y + h.height) > b.height)
                {
                    h.y = int((b.height - h.height));
                };
                if (h.y < 0)
                {
                    h.y = 0;
                };
            };
            var _local_2:* = (-(h.y) / hRun);
            var _local_3:* = (int((_local_2 * dRun)) + subject.oy);
            if (Math.abs((_local_3 - subject.y)) > 0.2)
            {
                subject.y = (subject.y + ((_local_3 - subject.y) / 1.1));
            }
            else
            {
                subject.y = _local_3;
            };
        }


    }
}//package 

