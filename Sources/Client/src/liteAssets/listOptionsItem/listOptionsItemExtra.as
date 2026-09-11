// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.listOptionsItem.listOptionsItemExtra

package liteAssets.listOptionsItem
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import liteAssets.handlers.optionHandler;
    import fl.controls.*;
    import flash.events.*;
    import flash.text.*;

    public class listOptionsItemExtra extends MovieClip 
    {

        public var txtName:TextField;
        public var chkActive:MovieClip;
        public var sDesc:String;
        public var rootClass:MovieClip;
        internal var bypass:Boolean = false;

        public function listOptionsItemExtra(_arg_1:MovieClip, _arg_2:Boolean, _arg_3:String)
        {
            this.rootClass = _arg_1;
            this.sDesc = _arg_3;
            chkActive.checkmark.visible = _arg_2;
            chkActive.addEventListener(MouseEvent.CLICK, onToggle, false, 0, true);
        }

        public function confirmAction(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                bypass = true;
                chkActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        public function onToggle(_arg_1:MouseEvent):void
        {
            var _local_2:Class;
            var _local_3:*;
            var _local_4:*;
            switch (txtName.text)
            {
                case "Quantity Warnings":
                    if (((!(chkActive.checkmark.visible)) || (bypass))) break;
                    _local_3 = new ModalMC();
                    _local_4 = {};
                    _local_4.strBody = "Turning this off means that you will not go to player support for unaccepted drops! Are you sure?";
                    _local_4.params = {};
                    _local_4.callback = confirmAction;
                    _local_4.glow = "red,medium";
                    rootClass.ui.ModalStack.addChild(_local_3);
                    _local_3.init(_local_4);
                    return;
            };
            bypass = false;
            chkActive.checkmark.visible = (!(chkActive.checkmark.visible));
            optionHandler.cmd(rootClass, txtName.text);
        }


    }
}//package liteAssets.listOptionsItem

