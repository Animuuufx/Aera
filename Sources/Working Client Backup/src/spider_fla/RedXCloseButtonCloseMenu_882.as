// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.RedXCloseButtonCloseMenu_882

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    public dynamic class RedXCloseButtonCloseMenu_882 extends MovieClip 
    {

        public var btnClose:SimpleButton;

        public function RedXCloseButtonCloseMenu_882()
        {
            addFrameScript(0, frame1);
        }

        public function onButtonPress(_arg_1:MouseEvent):void
        {
            MovieClip(parent).gotoAndPlay("Close");
        }

        internal function frame1():*
        {
            btnClose.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPress, false, 0, true);
        }


    }
}//package spider_fla

