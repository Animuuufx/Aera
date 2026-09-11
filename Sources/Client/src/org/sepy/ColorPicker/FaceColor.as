// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.FaceColor

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;

    public class FaceColor extends MovieClip 
    {

        private var _color:Number;


        public function set color(_arg_1:Number):*
        {
            _color = _arg_1;
        }

        public function get color():Number
        {
            return (_color);
        }

        public function getRGB():String
        {
            return ("0x" + _color.toString(16));
        }


    }
}//package org.sepy.ColorPicker

