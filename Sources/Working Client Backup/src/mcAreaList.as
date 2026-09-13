// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mcAreaList

package 
{
    import flash.display.MovieClip;
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

    public dynamic class mcAreaList extends MovieClip 
    {

        public var cntMask:MovieClip;
        public var cnt:MovieClip;
        public var title:MovieClip;

        public function mcAreaList()
        {
            addFrameScript(0, frame1, 1, frame2, 4, frame5, 19, frame20, 24, frame25);
        }

        internal function frame1():*
        {
            title.gotoAndStop(1);
        }

        internal function frame2():*
        {
            stop();
        }

        internal function frame5():*
        {
            title.gotoAndPlay("in");
            MovieClip(Game.root).areaListGet();
        }

        internal function frame20():*
        {
            stop();
        }

        internal function frame25():*
        {
            title.gotoAndPlay("out");
        }


    }
}//package 

