// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.colorSets

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import fl.controls.ComboBox;
    import fl.controls.TextInput;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import fl.data.DataProvider;
    import flash.geom.ColorTransform;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.*;

    public class colorSets extends MovieClip 
    {

        public var txtColor1:TextField;
        public var cPreview2:MovieClip;
        public var btnAdd:SimpleButton;
        public var cPreview3:MovieClip;
        public var cPreview1:MovieClip;
        public var btnDel:SimpleButton;
        public var cbSets:ComboBox;
        public var txtName:TextInput;
        public var bg:MovieClip;
        public var btnCopy:SimpleButton;
        public var btnApply:SimpleButton;
        public var txtColor3:TextField;
        public var txtColor2:TextField;
        public var mode:String;
        internal var rootClass:MovieClip;

        public function colorSets(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            this.txtColor1.text = "#ffffff";
            this.txtColor2.text = "#ffffff";
            this.txtColor3.text = "#ffffff";
            this.txtName.text = "My Color Set 1";
            this.cbSets.addEventListener(MouseEvent.CLICK, onCbSets, false, 0, true);
            this.cbSets.addEventListener(Event.CHANGE, onCbSets, false, 0, true);
            this.txtColor1.addEventListener(Event.CHANGE, onTxtColor1, false, 0, true);
            this.txtColor2.addEventListener(Event.CHANGE, onTxtColor2, false, 0, true);
            this.txtColor3.addEventListener(Event.CHANGE, onTxtColor3, false, 0, true);
            this.btnApply.addEventListener(MouseEvent.CLICK, onBtApply, false, 0, true);
            this.btnAdd.addEventListener(MouseEvent.CLICK, onBtAdd, false, 0, true);
            this.btnDel.addEventListener(MouseEvent.CLICK, onBtDel, false, 0, true);
            this.btnCopy.addEventListener(MouseEvent.CLICK, onBtCopy, false, 0, true);
            __setProp_txtName_mcColorSets_Layer1_0();
        }

        public function onUpdate():void
        {
            if (rootClass.litePreference.data.colorSets)
            {
                this.cbSets.dataProvider = new DataProvider(rootClass.litePreference.data.colorSets);
            };
        }

        private function onBtCopy(_arg_1:MouseEvent):void
        {
            if (mode == "mcCustomize")
            {
                this.txtColor1.text = ("#" + rootClass.ui.mcPopup.mcCustomize.cpHair.selectedColor.toString(16));
                this.txtColor2.text = ("#" + rootClass.ui.mcPopup.mcCustomize.cpSkin.selectedColor.toString(16));
                this.txtColor3.text = ("#" + rootClass.ui.mcPopup.mcCustomize.cpEye.selectedColor.toString(16));
            }
            else
            {
                this.txtColor1.text = ("#" + rootClass.ui.mcPopup.mcCustomizeArmor.cpBase.selectedColor.toString(16));
                this.txtColor2.text = ("#" + rootClass.ui.mcPopup.mcCustomizeArmor.cpTrim.selectedColor.toString(16));
                this.txtColor3.text = ("#" + rootClass.ui.mcPopup.mcCustomizeArmor.cpAccessory.selectedColor.toString(16));
            };
            this.txtColor1.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor2.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor3.dispatchEvent(new Event(Event.CHANGE));
        }

        private function onBtApply(_arg_1:MouseEvent):void
        {
            if (mode == "mcCustomize")
            {
                rootClass.ui.mcPopup.mcCustomize.cpHair.selectedColor = int(("0x" + this.txtColor1.text.replace("#", "")));
                rootClass.ui.mcPopup.mcCustomize.cpSkin.selectedColor = int(("0x" + this.txtColor2.text.replace("#", "")));
                rootClass.ui.mcPopup.mcCustomize.cpEye.selectedColor = int(("0x" + this.txtColor3.text.replace("#", "")));
                if (!rootClass.ui.mcPopup.mcCustomize.backData.intColorHair)
                {
                    rootClass.ui.mcPopup.mcCustomize.backData.intColorHair = rootClass.world.myAvatar.objData.intColorHair;
                };
                if (!rootClass.ui.mcPopup.mcCustomize.backData.intColorSkin)
                {
                    rootClass.ui.mcPopup.mcCustomize.backData.intColorSkin = rootClass.world.myAvatar.objData.intColorSkin;
                };
                if (!rootClass.ui.mcPopup.mcCustomize.backData.intColorEye)
                {
                    rootClass.ui.mcPopup.mcCustomize.backData.intColorEye = rootClass.world.myAvatar.objData.intColorEye;
                };
                rootClass.world.myAvatar.objData.intColorHair = int(("0x" + this.txtColor1.text.replace("#", "")));
                rootClass.world.myAvatar.objData.intColorSkin = int(("0x" + this.txtColor2.text.replace("#", "")));
                rootClass.world.myAvatar.objData.intColorEye = int(("0x" + this.txtColor3.text.replace("#", "")));
            }
            else
            {
                rootClass.ui.mcPopup.mcCustomizeArmor.cpBase.selectedColor = int(("0x" + this.txtColor1.text.replace("#", "")));
                rootClass.ui.mcPopup.mcCustomizeArmor.cpTrim.selectedColor = int(("0x" + this.txtColor2.text.replace("#", "")));
                rootClass.ui.mcPopup.mcCustomizeArmor.cpAccessory.selectedColor = int(("0x" + this.txtColor3.text.replace("#", "")));
                if (!rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorBase)
                {
                    rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorBase = rootClass.world.myAvatar.objData.intColorBase;
                };
                if (!rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorTrim)
                {
                    rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorTrim = rootClass.world.myAvatar.objData.intColorTrim;
                };
                if (!rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorAccessory)
                {
                    rootClass.ui.mcPopup.mcCustomizeArmor.backData.intColorAccessory = rootClass.world.myAvatar.objData.intColorAccessory;
                };
                rootClass.world.myAvatar.objData.intColorBase = int(("0x" + this.txtColor1.text.replace("#", "")));
                rootClass.world.myAvatar.objData.intColorTrim = int(("0x" + this.txtColor2.text.replace("#", "")));
                rootClass.world.myAvatar.objData.intColorAccessory = int(("0x" + this.txtColor3.text.replace("#", "")));
            };
            rootClass.world.myAvatar.pMC.updateColor();
        }

        private function onCbSets(_arg_1:Event):void
        {
            if (this.cbSets.selectedIndex < 0)
            {
                return;
            };
            this.txtName.text = this.cbSets.selectedItem.label;
            this.txtColor1.text = this.cbSets.selectedItem.color1;
            this.txtColor2.text = this.cbSets.selectedItem.color2;
            this.txtColor3.text = this.cbSets.selectedItem.color3;
            this.txtColor1.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor2.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor3.dispatchEvent(new Event(Event.CHANGE));
        }

        private function onTxtColor1(_arg_1:Event):void
        {
            var _local_2:*;
            try
            {
                _local_2 = new ColorTransform();
                _local_2.color = int(("0x" + this.txtColor1.text.replace("#", "")));
                this.cPreview1.transform.colorTransform = _local_2;
            }
            catch(exception)
            {
            };
        }

        private function onTxtColor2(_arg_1:Event):void
        {
            var _local_2:*;
            try
            {
                _local_2 = new ColorTransform();
                _local_2.color = int(("0x" + this.txtColor2.text.replace("#", "")));
                this.cPreview2.transform.colorTransform = _local_2;
            }
            catch(exception)
            {
            };
        }

        private function onTxtColor3(_arg_1:Event):void
        {
            var _local_2:*;
            try
            {
                _local_2 = new ColorTransform();
                _local_2.color = int(("0x" + this.txtColor3.text.replace("#", "")));
                this.cPreview3.transform.colorTransform = _local_2;
            }
            catch(exception)
            {
            };
        }

        private function onBtAdd(_arg_1:MouseEvent):void
        {
            this.cbSets.addItem({
                "label":this.txtName.text,
                "color1":this.txtColor1.text,
                "color2":this.txtColor2.text,
                "color3":this.txtColor3.text
            });
            rootClass.litePreference.data.colorSets = this.cbSets.dataProvider.toArray();
            rootClass.litePreference.flush();
        }

        private function onBtDel(_arg_1:MouseEvent):void
        {
            if (this.cbSets.selectedIndex != -1)
            {
                this.cbSets.removeItemAt(this.cbSets.selectedIndex);
            };
            this.cbSets.selectedIndex = -1;
            rootClass.litePreference.data.colorSets = this.cbSets.dataProvider.toArray();
            rootClass.litePreference.flush();
        }

        internal function __setProp_txtName_mcColorSets_Layer1_0():*
        {
            try
            {
                txtName["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            txtName.displayAsPassword = false;
            txtName.editable = true;
            txtName.enabled = true;
            txtName.maxChars = 25;
            txtName.restrict = "";
            txtName.text = "";
            txtName.visible = true;
            try
            {
                txtName["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }


    }
}//package liteAssets.draw

