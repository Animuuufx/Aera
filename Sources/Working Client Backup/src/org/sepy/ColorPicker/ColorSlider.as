// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.ColorSlider

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class ColorSlider extends MovieClip 
    {

        private var mc:MovieClip;
        private var slider:MovieClip;
        private var _color:Number;
        private var bmp:BitmapData;
        private var down:Boolean = false;

        public function ColorSlider()
        {
            addFrameScript(0, frame1);
            mc = new MovieClip();
            mc.name = "mc";
            this.addChildAt(mc, 1);
            mc.x = 1;
            mc.y = 1;
            mc.useHandCursor = false;
            this.addEventListener(MouseEvent.MOUSE_DOWN, onPressDown, false, 0, true);
            slider = new slider_mc();
            slider.name = "slider";
            this.addChildAt(slider, 2);
            slider.x = 15;
            slider.y = 98;
        }

        private function onPressDown(_arg_1:MouseEvent):void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove, false, 0, true);
            changing(mouseY);
        }

        private function onUp(_arg_1:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, onUp, false);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove, false);
        }

        private function onMove(_arg_1:MouseEvent):void
        {
            if (((mouseY >= 0) && (mouseY <= mc.height)))
            {
                changing(mouseY);
            };
        }

        private function changing(_arg_1:Number):*
        {
            slider.y = _arg_1;
            var _local_2:Number = bmp.getPixel(5, slider.y);
            MovieClip(parent).changing(_local_2);
        }

        public function getCurrentColor():Number
        {
            return (bmp.getPixel(5, slider.y));
        }

        public function set color(_arg_1:Number):void
        {
            _color = _arg_1;
            draw();
        }

        public function get color():Number
        {
            return (_color);
        }

        private function draw():void
        {
            mc.graphics.clear();
            var _local_1:Array = [0, color, 0xFFFFFF];
            var _local_2:Array = [100, 100, 100];
            var _local_3:Array = [0, 127, 0xFF];
            var _local_4:Matrix = new Matrix();
            _local_4.createGradientBox(187, 187, ((270 * Math.PI) / 180));
            mc.graphics.clear();
            mc.graphics.beginGradientFill("linear", _local_1, _local_2, _local_3, (_local_4 as Matrix), "reflect", "linear");
            mc.graphics.moveTo(0, 0);
            mc.graphics.lineTo(12, 0);
            mc.graphics.lineTo(12, 187);
            mc.graphics.lineTo(0, 187);
            mc.graphics.lineTo(0, 0);
            mc.graphics.endFill();
            bmp = new BitmapData(mc.width, mc.height, false);
            bmp.draw(mc);
        }

        internal function frame1():*
        {
            stop();
        }


    }
}//package org.sepy.ColorPicker

