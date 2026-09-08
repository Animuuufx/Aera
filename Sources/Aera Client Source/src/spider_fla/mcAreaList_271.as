// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcAreaList_271

package spider_fla
{
    import flash.display.MovieClip;
    import flash.text.TextField;
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

    public dynamic class mcAreaList_271 extends MovieClip 
    {

        public var t1:TextField;
        public var bMinMax:MovieClip;

        public function mcAreaList_271()
        {
            addFrameScript(0, frame1, 9, frame10);
        }

        internal function frame1():*
        {
            t1.mouseEnabled = false;
            bMinMax.a1.visible = false;
            bMinMax.a2.visible = true;
            stop();
        }

        internal function frame10():*
        {
            bMinMax.a1.visible = true;
            bMinMax.a2.visible = false;
            stop();
        }


    }
}//package spider_fla

