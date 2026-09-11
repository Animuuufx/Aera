// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.ColorMap

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.filters.*;

    public class ColorMap extends MovieClip 
    {

        private var mc:Sprite;
        private var cross_Mc:MovieClip;
        private var cross_Mask:MovieClip;
        public var newMC:*;
        private var b:Bitmap;
        private var bmp:BitmapData;
        private var _color:Number;
        private var down:Boolean = false;
        public var m_fillType:String = "linear";
        public var m_colors:Array = [0xFF0000, 0xFFFF00, 0xFF00, 0xFFFF, 0xFF, 0xFF00FF, 0xFF0000];
        public var m_alphas:Array = [100, 100, 100, 100, 100, 100, 100];
        public var m_ratios:Array = [0, 42, 64, 127, 184, 215, 0xFF];
        public var m_matrix:Matrix = new Matrix();

        public function ColorMap()
        {
            addFrameScript(0, frame1);
            mc = new Sprite();
            mc.name = "mc";
            this.addChild(mc);
            mc.x = 1;
            mc.y = 1;
            cross_Mc = (new cross_mc() as MovieClip);
            cross_Mc.name = "cross_mc";
            this.addChild(cross_Mc);
            cross_Mask = (new cross_mask() as MovieClip);
            cross_Mask.name = "cross_mask";
            this.addChild(cross_Mask);
            cross_Mc.mask = cross_Mask;
            init();
        }

        private function init():void
        {
            var _local_1:* = "linear";
            var _local_2:Array = [0xFFFFFF, 0, 0];
            var _local_3:Array = [0, 0, 100];
            var _local_4:Array = [0, 127, 0xFF];
            var _local_5:Matrix = new Matrix();
            _local_5.createGradientBox(175, 187, ((90 * Math.PI) / 180));
            m_matrix.createGradientBox(175, 187);
            mc.graphics.beginGradientFill(m_fillType, m_colors, m_alphas, m_ratios, (m_matrix as Matrix));
            mc.graphics.moveTo(0, 0);
            mc.graphics.lineTo(175, 0);
            mc.graphics.lineTo(175, 187);
            mc.graphics.lineTo(0, 187);
            mc.graphics.lineTo(0, 0);
            mc.graphics.endFill();
            newMC = new MovieClip();
            newMC.name = "upper";
            mc.addChild(newMC);
            newMC.graphics.beginGradientFill(_local_1, _local_2, _local_3, _local_4, (_local_5 as Matrix));
            newMC.graphics.moveTo(0, 0);
            newMC.graphics.lineTo(175, 0);
            newMC.graphics.lineTo(175, 187);
            newMC.graphics.lineTo(0, 187);
            newMC.graphics.lineTo(0, 0);
            newMC.graphics.endFill();
            this.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_MOVE, onMove, false, 0, true);
            this.draw();
        }

        private function onDown(_arg_1:MouseEvent):void
        {
            down = true;
            onMove(_arg_1);
        }

        private function onUp(_arg_1:MouseEvent):void
        {
            down = false;
        }

        private function onMove(_arg_1:MouseEvent):void
        {
            var _local_2:Number;
            if (down)
            {
                _local_2 = bmp.getPixel(((mouseX - mc.x) - 1), (mouseY - mc.y));
                this.cross_Mc.x = mouseX;
                this.cross_Mc.y = mouseY;
                MovieClip(parent).change(this, _local_2);
            };
        }

        private function draw():void
        {
            bmp = new BitmapData(mc.width, mc.height);
            bmp.draw(mc);
        }

        private function change(_arg_1:MovieClip, _arg_2:Number):*
        {
            _color = _arg_2;
        }

        public function set color(_arg_1:Number):void
        {
            _color = _arg_1;
        }

        public function get color():Number
        {
            return (_color);
        }

        public function findTheColor(_arg_1:Number):Boolean
        {
            var _local_2:Rectangle = bmp.getColorBoundsRect(0xFFFFFFFF, (0xFF000000 + _arg_1), true);
            cross_Mc.x = ((_local_2.x + (_local_2.width / 2)) + 2);
            cross_Mc.y = ((_local_2.y + (_local_2.height / 2)) + 2);
            return (!((((_local_2.x == 0) && (_local_2.y == 0)) && (_local_2.width == bmp.width)) && (_local_2.width == bmp.height)));
        }

        internal function frame1():*
        {
            stop();
        }


    }
}//package org.sepy.ColorPicker

