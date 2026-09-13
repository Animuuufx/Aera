// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.events.SliderEvent

package fl.events
{
    import flash.events.Event;

    public class SliderEvent extends Event 
    {

        public static const CHANGE:String = "change";
        public static const THUMB_DRAG:String = "thumbDrag";
        public static const THUMB_PRESS:String = "thumbPress";
        public static const THUMB_RELEASE:String = "thumbRelease";

        protected var _triggerEvent:String;
        protected var _value:Number;
        protected var _keyCode:Number;
        protected var _clickTarget:String;

        public function SliderEvent(_arg_1:String, _arg_2:Number, _arg_3:String, _arg_4:String, _arg_5:int=0)
        {
            _value = _arg_2;
            _keyCode = _arg_5;
            _triggerEvent = _arg_4;
            _clickTarget = _arg_3;
            super(_arg_1);
        }

        public function get value():Number
        {
            return (_value);
        }

        public function get keyCode():Number
        {
            return (_keyCode);
        }

        public function get triggerEvent():String
        {
            return (_triggerEvent);
        }

        public function get clickTarget():String
        {
            return (_clickTarget);
        }

        override public function toString():String
        {
            return (formatToString("SliderEvent", "type", "value", "bubbles", "cancelable", "keyCode", "triggerEvent", "clickTarget"));
        }

        override public function clone():Event
        {
            return (new SliderEvent(type, _value, _clickTarget, _triggerEvent, _keyCode));
        }


    }
}//package fl.events

