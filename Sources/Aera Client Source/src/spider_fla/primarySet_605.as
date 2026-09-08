// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.primarySet_605

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import fl.controls.ColorPicker;
    import fl.controls.ComboBox;
    import fl.controls.NumericStepper;
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

    public dynamic class primarySet_605 extends MovieClip 
    {

        public var btnGlowOff:SimpleButton;
        public var btnVisibility:SimpleButton;
        public var txtClassName:TextField;
        public var colGlowOff:ColorPicker;
        public var btnResetPlayer:SimpleButton;
        public var btnToggleDummy:SimpleButton;
        public var cbVisibility:ComboBox;
        public var btnClass5:SimpleButton;
        public var btnEmote:SimpleButton;
        public var colGlow:ColorPicker;
        public var cbEmotes:ComboBox;
        public var btnClass4:SimpleButton;
        public var btnGlowPlayer:SimpleButton;
        public var btnStonePlayer:SimpleButton;
        public var btnFreezePlayer:SimpleButton;
        public var btnHitPlayer:SimpleButton;
        public var btnGlowMain:SimpleButton;
        public var btnClass1:SimpleButton;
        public var colGlowMain:ColorPicker;
        public var btnShowDeattach:SimpleButton;
        public var btnClass3:SimpleButton;
        public var numScaling:NumericStepper;
        public var btnClass2:SimpleButton;
        public var btnDeattach:SimpleButton;
        public var txtDeattached:TextField;
        public var colBG:ColorPicker;

        public function primarySet_605()
        {
            __setProp_numScaling_primarySet_Layer1_0();
        }

        internal function __setProp_numScaling_primarySet_Layer1_0():*
        {
            try
            {
                numScaling["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            numScaling.enabled = true;
            numScaling.maximum = 10;
            numScaling.minimum = 0;
            numScaling.stepSize = 0.1;
            numScaling.value = 3;
            numScaling.visible = true;
            try
            {
                numScaling["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }


    }
}//package spider_fla

