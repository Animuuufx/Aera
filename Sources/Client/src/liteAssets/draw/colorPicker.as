// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.colorPicker

package liteAssets.draw
{
    import flash.display.MovieClip;
    import fl.controls.TextInput;
    import flash.display.SimpleButton;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import fl.motion.Color;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.*;

    public class colorPicker extends MovieClip 
    {

        public var txtGreen:TextInput;
        public var txtHex:TextInput;
        public var btnColorPick:SimpleButton;
        public var txtRed:TextInput;
        public var colorPreview:MovieClip;
        public var txtBlue:TextInput;
        public var ui:MovieClip;
        private var _stageBitmap:BitmapData;

        public function colorPicker()
        {
            this.txtRed.text = "255";
            this.txtGreen.text = "255";
            this.txtBlue.text = "255";
            this.txtHex.text = "#ffffff";
            this.ui.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            this.ui.addEventListener(MouseEvent.MOUSE_UP, onMRelease, false, 0, true);
            this.ui.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            this.btnColorPick.addEventListener(MouseEvent.CLICK, onBtColor, false, 0, true);
            __setProp_txtHex_mcColorPicker_Layer1_0();
            __setProp_txtRed_mcColorPicker_Layer1_0();
            __setProp_txtBlue_mcColorPicker_Layer1_0();
            __setProp_txtGreen_mcColorPicker_Layer1_0();
        }

        public function cleanup():void
        {
            this.ui.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
            this.ui.removeEventListener(MouseEvent.MOUSE_UP, onMRelease);
            this.ui.btnClose.removeEventListener(MouseEvent.CLICK, onClose);
            this.btnColorPick.removeEventListener(MouseEvent.CLICK, onBtColor);
            parent.removeChild(this);
        }

        private function onClose(_arg_1:MouseEvent):void
        {
            cleanup();
        }

        private function onBtColor(_arg_1:MouseEvent):void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, getColor, false, 0, true);
        }

        private function getColor(_arg_1:MouseEvent):void
        {
            if (_stageBitmap == null)
            {
                _stageBitmap = new BitmapData(stage.width, stage.height);
            };
            _stageBitmap.draw(stage);
            var _local_2:uint = _stageBitmap.getPixel(stage.mouseX, stage.mouseY);
            var _local_3:* = ((_local_2 >> 16) & 0xFF);
            var _local_4:* = ((_local_2 >> 8) & 0xFF);
            var _local_5:* = (_local_2 & 0xFF);
            this.txtRed.text = _local_3.toString();
            this.txtGreen.text = _local_4.toString();
            this.txtBlue.text = _local_5.toString();
            this.txtHex.text = ("#" + _local_2.toString(16));
            var _local_6:Color = new Color();
            _local_6.setTint(_local_2, 1);
            this.colorPreview.transform.colorTransform = _local_6;
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        private function onDrag(_arg_1:MouseEvent):void
        {
            this.startDrag();
        }

        private function onMRelease(_arg_1:MouseEvent):void
        {
            this.stopDrag();
        }

        internal function __setProp_txtHex_mcColorPicker_Layer1_0():*
        {
            try
            {
                txtHex["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            txtHex.displayAsPassword = false;
            txtHex.editable = true;
            txtHex.enabled = true;
            txtHex.maxChars = 0;
            txtHex.restrict = "";
            txtHex.text = "#FFFFFF";
            txtHex.visible = true;
            try
            {
                txtHex["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function __setProp_txtRed_mcColorPicker_Layer1_0():*
        {
            try
            {
                txtRed["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            txtRed.displayAsPassword = false;
            txtRed.editable = true;
            txtRed.enabled = true;
            txtRed.maxChars = 0;
            txtRed.restrict = "";
            txtRed.text = "255";
            txtRed.visible = true;
            try
            {
                txtRed["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function __setProp_txtBlue_mcColorPicker_Layer1_0():*
        {
            try
            {
                txtBlue["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            txtBlue.displayAsPassword = false;
            txtBlue.editable = true;
            txtBlue.enabled = true;
            txtBlue.maxChars = 0;
            txtBlue.restrict = "";
            txtBlue.text = "255";
            txtBlue.visible = true;
            try
            {
                txtBlue["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }

        internal function __setProp_txtGreen_mcColorPicker_Layer1_0():*
        {
            try
            {
                txtGreen["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            };
            txtGreen.displayAsPassword = false;
            txtGreen.editable = true;
            txtGreen.enabled = true;
            txtGreen.maxChars = 0;
            txtGreen.restrict = "";
            txtGreen.text = "255";
            txtGreen.visible = true;
            try
            {
                txtGreen["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            };
        }


    }
}//package liteAssets.draw

