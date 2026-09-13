// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.listOptionsItem.listOptionsItemBtn

package liteAssets.listOptionsItem
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import liteAssets.handlers.optionHandler;
    import flash.events.*;

    public class listOptionsItemBtn extends MovieClip 
    {

        public var txtName:TextField;
        public var btnActive:SimpleButton;
        public var sDesc:String;
        public var rootClass:MovieClip;
        internal var bypass:Boolean = false;

        public function listOptionsItemBtn(_arg_1:MovieClip, _arg_2:String)
        {
            rootClass = _arg_1;
            this.sDesc = _arg_2;
            btnActive.addEventListener(MouseEvent.CLICK, onActive, false, 0, true);
        }

        public function confirmAction(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                bypass = true;
                btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        public function onActive(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            var _local_3:*;
            switch (txtName.text)
            {
                case "Decline All Drops":
                    if (bypass) break;
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "Are you sure you want to decline all drops?";
                    _local_3.params = {};
                    _local_3.callback = confirmAction;
                    _local_3.glow = "red,medium";
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                    return;
            };
            bypass = false;
            optionHandler.cmd(rootClass, txtName.text);
        }


    }
}//package liteAssets.listOptionsItem

