// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.Button_543

package spider_fla
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
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

    public dynamic class Button_543 extends MovieClip 
    {

        public var btnButton:MovieClip;
        public var txtLabel:TextField;
        public var rootClass:*;
        public var world:*;

        public function Button_543()
        {
            addFrameScript(1, frame2);
        }

        public function onButtonPress(_arg_1:MouseEvent):void
        {
            if (this.bitMemberOnly)
            {
                rootClass.showUpgradeWindow();
            }
            else
            {
                navigateToURL(new URLRequest("https://www.aq.com/order-now/direct/"), "_blank");
            };
        }

        internal function frame2():*
        {
            rootClass = MovieClip(this.stage.getChildAt(0));
            world = rootClass.world;
            btnButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPress, false, 0, true);
            stop();
        }


    }
}//package spider_fla

