// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.IntInput

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.Event;
    import flash.events.*;
    import flash.text.*;

    public class IntInput extends MovieClip 
    {

        public var _value:Number;
        private var broadcastMessage:Function;
        private var input:TextField;
        private var tlabel:TextField;
        private var _label:String;
        private var _max:Number;

        public function IntInput(_arg_1:String, _arg_2:String)
        {
            var _local_3:TextFormat;
            super();
            _local_3 = new TextFormat();
            _local_3.font = "_sans";
            _local_3.size = 10;
            tlabel = new TextField();
            tlabel.width = 31;
            tlabel.height = 16;
            this.addChildAt(tlabel, 1);
            tlabel.x = 2;
            tlabel.y = 1;
            tlabel.defaultTextFormat = _local_3;
            tlabel.text = _arg_1;
            input = new TextField();
            input.height = 16;
            input.width = 31;
            input.name = "input";
            this.addChildAt(input, 2);
            input.x = 22;
            input.y = 1;
            input.type = _arg_2;
            input.maxChars = 3;
            input.restrict = "[0-9]";
            input.defaultTextFormat = _local_3;
            input.addEventListener(Event.CHANGE, onChanged, false, 0, true);
        }

        public function set value(_arg_1:Number):*
        {
            _value = _arg_1;
            input.text = _value.toString(10);
        }

        public function get value():Number
        {
            return (_value);
        }

        private function onChanged(_arg_1:Event):*
        {
            var _local_2:Number = Number(input.text);
            if (isNaN(_local_2))
            {
                input.text = "0";
            };
            if (_local_2 > _max)
            {
                input.text = _max.toString();
            };
            _value = Number(input.text);
            MovieClip(parent).changed(this, Number(input.text));
        }

        public function set label(_arg_1:String):void
        {
            _label = _arg_1;
            tlabel.text = _arg_1;
        }

        public function get label():String
        {
            return (_label);
        }

        public function set max(_arg_1:Number):*
        {
            _max = _arg_1;
        }

        public function get max():Number
        {
            return (_max);
        }


    }
}//package org.sepy.ColorPicker

