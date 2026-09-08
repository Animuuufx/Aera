// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.CameraToolWD_A_663

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import fl.controls.NumericStepper;
    import flash.text.TextField;
    import fl.controls.Slider;
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

    public dynamic class CameraToolWD_A_663 extends MovieClip 
    {

        public var background:MovieClip;
        public var btnMirror:SimpleButton;
        public var numWepScale:NumericStepper;
        public var txtFocus:TextField;
        public var sldrRotation:Slider;
        public var btnSetFocus:SimpleButton;
        public var btnAddLayer:SimpleButton;
        public var btnDelLayer:SimpleButton;
        public var btnInCombat:SimpleButton;

        public function CameraToolWD_A_663()
        {
            __setProp_sldrRotation_CameraToolWD_A_Layer1_0();
            __setProp_numWepScale_CameraToolWD_A_Layer1_0();
        }

        internal function __setProp_sldrRotation_CameraToolWD_A_Layer1_0():*
        {
            try
            {
                sldrRotation["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            sldrRotation.direction = "horizontal";
            sldrRotation.enabled = true;
            sldrRotation.liveDragging = true;
            sldrRotation.maximum = 360;
            sldrRotation.minimum = 0;
            sldrRotation.snapInterval = 0;
            sldrRotation.tickInterval = 0;
            sldrRotation.value = 0;
            sldrRotation.visible = true;
            try
            {
                sldrRotation["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function __setProp_numWepScale_CameraToolWD_A_Layer1_0():*
        {
            try
            {
                numWepScale["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            numWepScale.enabled = true;
            numWepScale.maximum = 10;
            numWepScale.minimum = 0;
            numWepScale.stepSize = 0.001;
            numWepScale.value = 0.222;
            numWepScale.visible = true;
            try
            {
                numWepScale["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }


    }
}//package spider_fla

