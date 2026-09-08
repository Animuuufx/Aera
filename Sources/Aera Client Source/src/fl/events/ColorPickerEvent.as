// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.events.ColorPickerEvent

package fl.events
{
    import flash.events.Event;

    public class ColorPickerEvent extends Event 
    {

        public static const ITEM_ROLL_OUT:String = "itemRollOut";
        public static const ITEM_ROLL_OVER:String = "itemRollOver";
        public static const ENTER:String = "enter";
        public static const CHANGE:String = "change";

        protected var _color:uint;

        public function ColorPickerEvent(_arg_1:String, _arg_2:uint)
        {
            super(_arg_1, true);
            _color = _arg_2;
        }

        public function get color():uint
        {
            return (_color);
        }

        override public function toString():String
        {
            return (formatToString("ColorPickerEvent", "type", "bubbles", "cancelable", "color"));
        }

        override public function clone():Event
        {
            return (new ColorPickerEvent(type, color));
        }


    }
}//package fl.events

