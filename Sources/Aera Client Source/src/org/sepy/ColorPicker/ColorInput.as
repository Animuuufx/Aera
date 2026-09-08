// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.ColorInput

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.Event;
    import flash.events.*;
    import flash.text.*;

    public class ColorInput extends MovieClip 
    {

        public var _color:Number;
        private var input:TextField;

        public function ColorInput()
        {
            var _local_1:TextFormat;
            super();
            _local_1 = new TextFormat();
            _local_1.font = "_sans";
            _local_1.size = 10;
            input = new TextField();
            input.name = "input";
            input.width = 57;
            input.height = 16;
            this.addChildAt(input, 1);
            input.x = 2;
            input.y = 1;
            input.type = "input";
            input.maxChars = 7;
            input.defaultTextFormat = _local_1;
            input.addEventListener(Event.CHANGE, onInput, false, 0, true);
        }

        public function set color(_arg_1:Number):*
        {
            _color = _arg_1;
            input.text = ("#" + ColorPicker2.ColorToString(_arg_1));
        }

        public function get color():Number
        {
            return (_color);
        }

        private function onInput(_arg_1:Event):void
        {
            MovieClip(parent.parent).changed(TextField(_arg_1.currentTarget).text);
        }


    }
}//package org.sepy.ColorPicker

