// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.ColorDisplay

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;

    public class ColorDisplay extends MovieClip 
    {

        private var face:MovieClip;

        public function ColorDisplay()
        {
            this.useHandCursor = false;
            face = new FaceColor();
            face.name = "face";
            this.addChild(face);
            face.x = 1;
            face.y = 1;
            face.width = 39;
            face.height = 17;
        }

        public function set color(_arg_1:Number):*
        {
            face.color = _arg_1;
        }

        public function get color():Number
        {
            return (face.color);
        }

        public function getRGB():String
        {
            return ("0x" + face.color.toString(16));
        }


    }
}//package org.sepy.ColorPicker

