// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.simpleblackbutton2_489

package spider_fla
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class simpleblackbutton2_489 extends MovieClip 
    {

        public var bg:MovieClip;
        public var fx:MovieClip;
        public var isSelected:Boolean;

        public function simpleblackbutton2_489()
        {
            addFrameScript(0, frame1);
        }

        public function select():*
        {
            isSelected = true;
            setCT(bg, 18278);
        }

        public function unselect():*
        {
            isSelected = false;
            setCT(bg, 65793);
        }

        public function onMouseOver(_arg_1:MouseEvent):*
        {
            if (!isSelected)
            {
                this.fx.visible = true;
            };
        }

        public function onMouseOut(_arg_1:MouseEvent):*
        {
            this.fx.visible = false;
        }

        public function setCT(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = _arg_1.transform.colorTransform;
            _local_3.color = _arg_2;
            _arg_1.transform.colorTransform = _local_3;
        }

        internal function frame1():*
        {
            this.buttonMode = true;
            this.fx.visible = false;
            isSelected = false;
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            stop();
        }


    }
}//package spider_fla

