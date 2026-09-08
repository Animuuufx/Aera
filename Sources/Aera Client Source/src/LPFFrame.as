// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrame

package 
{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.text.*;

    public class LPFFrame extends MovieClip 
    {

        public var w:int;
        public var h:int;
        public var fParent:LPFPanel;
        public var eventTypes:Array = [];
        public var sName:String = "";
        protected var fData:Object;
        protected var sMode:String;

        public function LPFFrame():void
        {
        }

        public function subscribeTo(_arg_1:LPFPanel):void
        {
            fParent = _arg_1;
        }

        public function getLayout():MovieClip
        {
            var _local_1:* = fParent;
            while ((("fParent" in _local_1) && (!(_local_1.fParent == null))))
            {
                _local_1 = _local_1.fParent;
            };
            return (_local_1 as MovieClip);
        }

        public function notify(_arg_1:Object):void
        {
        }

        public function update(_arg_1:Object):void
        {
            getLayout().update(_arg_1);
        }

        public function getState():Object
        {
            var _local_1:Object = {};
            _local_1.fParent = fParent;
            _local_1.element = this;
            _local_1.fData = fData;
            return (_local_1);
        }

        public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            positionBy(_arg_1.r);
            getLayout().registerForEvents(this, eventTypes);
        }

        public function fClose():void
        {
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        public function fRemove():void
        {
            if (((!(fParent == null)) && ("delFrame" in fParent)))
            {
                fParent.delFrame(this);
            };
        }

        protected function positionBy(_arg_1:Object):*
        {
            var _local_3:DisplayObject;
            var _local_5:int;
            var _local_6:Rectangle;
            var _local_7:int;
            if (("shiftY" in _arg_1))
            {
                y = (y + _arg_1.y);
                return;
            };
            var _local_2:int = int(int((fParent.w / 2)));
            var _local_4:int = int((this.width / 2));
            if (parent != null)
            {
                _local_5 = 0;
                while (_local_5 < parent.numChildren)
                {
                    if (parent.getChildAt(_local_5) == this)
                    {
                        _local_3 = parent.getChildAt(_local_5);
                    };
                    _local_5++;
                };
                _local_6 = _local_3.getBounds(parent);
                _local_4 = int(int((_local_6.width / 2)));
            };
            if (("centerOn" in _arg_1))
            {
                _local_2 = _arg_1.centerOn;
            };
            if ((("center" in _arg_1) && (_arg_1.center)))
            {
                x = int((_local_2 - _local_4));
            }
            else
            {
                if (_arg_1.x > -1)
                {
                    x = _arg_1.x;
                }
                else
                {
                    x = int(((fParent.w / 2) - (width / 2)));
                };
            };
            if (("shiftAmount" in _arg_1))
            {
                x = (x + int(_arg_1.shiftAmount));
            };
            if (_arg_1.y > -1)
            {
                y = _arg_1.y;
            }
            else
            {
                if (_arg_1.y == -1)
                {
                    _local_7 = fParent.numChildren;
                    if (_local_7 > 1)
                    {
                        y = ((fParent.getChildAt((_local_7 - 2)).y + fParent.getChildAt((_local_7 - 2)).height) + 10);
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
            w = _arg_1.w;
            h = _arg_1.h;
        }


    }
}//package 

