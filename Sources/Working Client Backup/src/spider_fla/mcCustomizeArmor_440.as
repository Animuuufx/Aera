// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcCustomizeArmor_440

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import org.sepy.ColorPicker.ColorPicker2;
    import liteAssets.draw.colorSets;
    import liteAssets.draw.colorPicker;
    import flash.events.Event;
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

    public dynamic class mcCustomizeArmor_440 extends MovieClip 
    {

        public var submit:SimpleButton;
        public var btnClose:SimpleButton;
        public var cpTrim:ColorPicker2;
        public var btnColor:MovieClip;
        public var cpAccessory:ColorPicker2;
        public var cpBase:ColorPicker2;
        public var bg:MovieClip;
        public var rootClass:*;
        public var avt:Avatar;
        public var backData:*;
        public var mcSets:colorSets;

        public function mcCustomizeArmor_440()
        {
            addFrameScript(0, frame1, 19, frame20, 35, frame36);
            __setProp_cpAccessory_mcCustomizeArmor_Layer22_0();
            __setProp_cpTrim_mcCustomizeArmor_Layer23_0();
            __setProp_cpBase_mcCustomizeArmor_Layer24_0();
        }

        public function onColorClick(_arg_1:Event):*
        {
            if (rootClass.stage.getChildByName("mcColorPicker"))
            {
                return;
            };
            var _local_2:colorPicker = new colorPicker();
            _local_2.name = "mcColorPicker";
            rootClass.stage.addChild(_local_2);
        }

        public function onCloseClick(_arg_1:Event):*
        {
            if ((((!(backData.intColorBase == avt.objData.intColorBase)) || (!(backData.intColorTrim == avt.objData.intColorTrim))) || (!(backData.intColorAccessory == avt.objData.intColorAccessory))))
            {
                avt.objData.intColorBase = backData.intColorBase;
                avt.objData.intColorTrim = backData.intColorTrim;
                avt.objData.intColorAccessory = backData.intColorAccessory;
                avt.pMC.updateColor();
            };
            MovieClip(Game.root).mixer.playSound("Click");
            gotoAndPlay("out");
        }

        public function onSaveClick(_arg_1:Event):*
        {
            if ((((!(backData.intColorBase == avt.objData.intColorBase)) || (!(backData.intColorTrim == avt.objData.intColorTrim))) || (!(backData.intColorAccessory == avt.objData.intColorAccessory))))
            {
                rootClass.world.sendChangeArmorColorRequest(avt.objData.intColorBase, avt.objData.intColorTrim, avt.objData.intColorAccessory);
            };
            MovieClip(Game.root).mixer.playSound("Click");
            gotoAndPlay("out");
        }

        public function onColorSelect(_arg_1:Event):void
        {
            switch (_arg_1.target.name)
            {
                case "cpBase":
                    avt.objData.intColorBase = _arg_1.target.selectedColor;
                    break;
                case "cpTrim":
                    avt.objData.intColorTrim = _arg_1.target.selectedColor;
                    break;
                case "cpAccessory":
                    avt.objData.intColorAccessory = _arg_1.target.selectedColor;
                    break;
            };
            avt.pMC.updateColor();
        }

        public function onItemRollOver(_arg_1:Event):void
        {
            var _local_2:* = new Object();
            _local_2.intColorSkin = avt.objData.intColorSkin;
            _local_2.intColorHair = avt.objData.intColorHair;
            _local_2.intColorEye = avt.objData.intColorEye;
            _local_2.intColorBase = avt.objData.intColorBase;
            _local_2.intColorTrim = avt.objData.intColorTrim;
            _local_2.intColorAccessory = avt.objData.intColorAccessory;
            switch (_arg_1.target.name)
            {
                case "cpBase":
                    _local_2.intColorBase = _arg_1.target.selectedColor;
                    break;
                case "cpTrim":
                    _local_2.intColorTrim = _arg_1.target.selectedColor;
                    break;
                case "cpAccessory":
                    _local_2.intColorAccessory = _arg_1.target.selectedColor;
                    break;
            };
            avt.pMC.updateColor(_local_2);
        }

        public function onItemRollOut(_arg_1:Event):void
        {
            avt.pMC.updateColor();
        }

        internal function __setProp_cpAccessory_mcCustomizeArmor_Layer22_0():*
        {
            try
            {
                cpAccessory["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            cpAccessory.allowUserColor = true;
            cpAccessory.selectedColor = 0;
            cpAccessory.columns = 21;
            cpAccessory.direction = "DL";
            cpAccessory.useAdvancedColorSelector = true;
            cpAccessory.useNoColorSelector = false;
            try
            {
                cpAccessory["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function __setProp_cpTrim_mcCustomizeArmor_Layer23_0():*
        {
            try
            {
                cpTrim["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            cpTrim.allowUserColor = true;
            cpTrim.selectedColor = 0;
            cpTrim.columns = 21;
            cpTrim.direction = "DL";
            cpTrim.useAdvancedColorSelector = true;
            cpTrim.useNoColorSelector = false;
            try
            {
                cpTrim["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function __setProp_cpBase_mcCustomizeArmor_Layer24_0():*
        {
            try
            {
                cpBase["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            cpBase.allowUserColor = true;
            cpBase.selectedColor = 0;
            cpBase.columns = 21;
            cpBase.direction = "DL";
            cpBase.useAdvancedColorSelector = true;
            cpBase.useNoColorSelector = false;
            try
            {
                cpBase["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function frame1():*
        {
            rootClass = MovieClip(stage.getChildAt(0));
            avt = rootClass.world.myAvatar;
            backData = new Object();
            backData.intColorBase = avt.objData.intColorBase;
            backData.intColorTrim = avt.objData.intColorTrim;
            backData.intColorAccessory = avt.objData.intColorAccessory;
            btnColor.addEventListener(MouseEvent.CLICK, onColorClick, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            submit.addEventListener(MouseEvent.CLICK, onSaveClick, false, 0, true);
            cpBase.addEventListener("CHANGE", onColorSelect, false, 0, true);
            cpBase.addEventListener("ROLL_OVER", onItemRollOver, false, 0, true);
            cpBase.addEventListener("ROLL_OUT", onItemRollOut, false, 0, true);
            cpTrim.addEventListener("CHANGE", onColorSelect, false, 0, true);
            cpTrim.addEventListener("ROLL_OVER", onItemRollOver, false, 0, true);
            cpTrim.addEventListener("ROLL_OUT", onItemRollOut, false, 0, true);
            cpAccessory.addEventListener("CHANGE", onColorSelect, false, 0, true);
            cpAccessory.addEventListener("ROLL_OVER", onItemRollOver, false, 0, true);
            cpAccessory.addEventListener("ROLL_OUT", onItemRollOut, false, 0, true);
            cpBase.selectedColor = avt.objData.intColorBase;
            cpTrim.selectedColor = avt.objData.intColorTrim;
            cpAccessory.selectedColor = avt.objData.intColorAccessory;
            if (((!(getChildByName("mcColorSets"))) && (rootClass.litePreference.data.bColorSets)))
            {
                mcSets = new colorSets(rootClass);
                mcSets.name = "mcColorSets";
                mcSets.mode = "mcCustomizeArmor";
                mcSets.y = 224;
                mcSets.onUpdate();
                addChild(mcSets);
                setChildIndex(mcSets, 0);
            };
        }

        internal function frame20():*
        {
            stop();
        }

        internal function frame36():*
        {
            MovieClip(parent).onClose();
        }


    }
}//package spider_fla

