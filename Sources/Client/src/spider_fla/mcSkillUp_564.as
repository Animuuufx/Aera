// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcSkillUp_564

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

    public dynamic class mcSkillUp_564 extends MovieClip 
    {

        public var rootClass:MovieClip;
        public var c:int;
        public var t:int;

        public function mcSkillUp_564()
        {
            addFrameScript(0, frame1, 1, frame2, 10, frame11, 41, frame42);
        }

        public function fClose():void
        {
            this.gotoAndStop("reset");
        }

        public function onSkillUpClick(_arg_1:MouseEvent):void
        {
            rootClass.toggleCharpanel("spend");
            fClose();
        }

        internal function frame1():*
        {
            this.visible = false;
            this.x = 961;
            rootClass = (stage.getChildAt(0) as MovieClip);
            c = 0;
            t = 60;
            this.addEventListener(MouseEvent.CLICK, onSkillUpClick, false, 0, true);
            this.buttonMode = true;
            stop();
        }

        internal function frame2():*
        {
            this.visible = false;
            this.x = 961;
            stop();
        }

        internal function frame11():*
        {
            this.visible = true;
            this.x = 766;
            c = 0;
        }

        internal function frame42():*
        {
            if (++c < t)
            {
                this.gotoAndPlay((this.currentFrame - 1));
            }
            else
            {
                fClose();
            };
        }


    }
}//package spider_fla

