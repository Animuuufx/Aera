// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.ui_259

package spider_fla
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
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

    public dynamic class ui_259 extends MovieClip 
    {

        public var mcHead:MovieClip;
        public var HP:MovieClip;
        public var strLevel:TextField;
        public var strName:TextField;
        public var strClass:TextField;
        public var MP:MovieClip;
        public var pvpIcon:MovieClip;
        public var stars:MovieClip;
        public var btnOption:SimpleButton;

        public function ui_259()
        {
            addFrameScript(0, frame1);
        }

        internal function frame1():*
        {
            mcHead.backhair.visible = false;
        }


    }
}//package spider_fla

