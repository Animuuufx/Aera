// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.game_1_mcNotificationWrapper_2

package spider_fla
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

    public dynamic class game_1_mcNotificationWrapper_2 extends MovieClip 
    {

        public var mcNoticeBubble:MovieClip;

        public function game_1_mcNotificationWrapper_2()
        {
            addFrameScript(0, frame1, 59, frame60);
        }

        public function notify(_arg_1:String):void
        {
            mcNoticeBubble.strNotice.text = _arg_1;
            gotoAndPlay(3);
            visible = true;
        }

        internal function frame1():*
        {
            visible = false;
            stop();
        }

        internal function frame60():*
        {
            visible = false;
            stop();
        }


    }
}//package spider_fla

