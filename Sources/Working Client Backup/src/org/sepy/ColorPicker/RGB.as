// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.RGB

package org.sepy.ColorPicker
{
    public class RGB 
    {

        private var _r:Number;
        private var _g:Number;
        private var _b:Number;

        public function RGB(_arg_1:Number, _arg_2:Number, _arg_3:Number)
        {
            _r = _arg_1;
            _g = _arg_2;
            _b = _arg_3;
        }

        public function set r(_arg_1:Number):void
        {
            _r = _arg_1;
        }

        public function get r():Number
        {
            return (_r);
        }

        public function set g(_arg_1:Number):void
        {
            _g = _arg_1;
        }

        public function get g():Number
        {
            return (_g);
        }

        public function set b(_arg_1:Number):void
        {
            _b = _arg_1;
        }

        public function get b():Number
        {
            return (_b);
        }

        public function getRGB():Number
        {
            return (((r << 16) | (g << 8)) | b);
        }

        public function toString():String
        {
            return (((((("[R:" + r) + ", G:") + g) + ", B:") + b) + "]");
        }


    }
}//package org.sepy.ColorPicker

