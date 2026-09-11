// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameBackdrop

package 
{
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFFrameBackdrop extends LPFFrame 
    {

        public var bg:MovieClip;
        private var rootClass:MovieClip;

        public function LPFFrameBackdrop():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            fData = _arg_1.fData;
            positionBy(_arg_1.r);
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            fData = {};
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        private function fDraw():void
        {
        }

        override public function notify(_arg_1:Object):void
        {
            fDraw();
        }

        override protected function positionBy(_arg_1:Object):*
        {
            var _local_2:int;
            w = _arg_1.w;
            h = _arg_1.h;
            bg.width = w;
            bg.height = h;
            if (_arg_1.x > -1)
            {
                x = _arg_1.x;
            }
            else
            {
                x = int(((fParent.w / 2) - (width / 2)));
            };
            if (_arg_1.y > -1)
            {
                y = _arg_1.y;
            }
            else
            {
                if (_arg_1.y == -1)
                {
                    _local_2 = fParent.numChildren;
                    if (_local_2 > 1)
                    {
                        y = ((fParent.getChildAt((_local_2 - 2)).y + fParent.getChildAt((_local_2 - 2)).height) + 10);
                    }
                    else
                    {
                        y = 10;
                    };
                }
                else
                {
                    y = (fParent.h + _arg_1.y);
                };
            };
        }


    }
}//package 

