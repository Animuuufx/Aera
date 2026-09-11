// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcGuildpanel_520

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
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

    public dynamic class mcGuildpanel_520 extends MovieClip 
    {

        public var btnClose:SimpleButton;
        public var __id0_:MovieClip;
        public var tMemCount:TextField;
        public var cntMask:MovieClip;
        public var tTitle:TextField;
        public var frame:MovieClip;
        public var tSlots:TextField;
        public var bg:MovieClip;
        public var guildDisplay:MovieClip;
        public var mcBuyButtons:MovieClip;
        public var scr:MovieClip;

        public function mcGuildpanel_520()
        {
            __setProp___id0__mcGuildpanel_tTitle_0();
        }

        internal function __setProp___id0__mcGuildpanel_tTitle_0():*
        {
            try
            {
                __id0_["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            __id0_.strAction = "loadSWF";
            __id0_.bitQS = false;
            __id0_.intQS = 54;
            __id0_.intVal = 0;
            __id0_.qsType = "Gray";
            __id0_.strLabel = "";
            __id0_.strFrame = "Enter";
            __id0_.strPad = "Spawn";
            __id0_.strString = "events/TMBG/Cutscene-TMBG-1.swf";
            __id0_.intID = 1;
            __id0_.bitCloseFront = false;
            __id0_.bitCloseUI = false;
            __id0_.intMinLevel = 1;
            __id0_.bitMemberOnly = false;
            __id0_.strRestriction = "All";
            __id0_.msg = "";
            __id0_.altLabel = "";
            try
            {
                __id0_["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }


    }
}//package spider_fla

