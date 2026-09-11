// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.listOptionsItem.listOptionsItem

package liteAssets.listOptionsItem
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import liteAssets.handlers.optionHandler;
    import flash.events.*;

    public class listOptionsItem extends MovieClip 
    {

        public var txtName:TextField;
        public var txtStatus:TextField;
        public var btnLeft:MovieClip;
        public var btnRight:MovieClip;
        public var bEnabled:Boolean;
        public var sDesc:String;
        public var rootClass:MovieClip;
        internal var bypass:Boolean = false;

        public function listOptionsItem(_arg_1:MovieClip, _arg_2:Boolean, _arg_3:String)
        {
            rootClass = _arg_1;
            txtStatus.text = ((_arg_2) ? "ON" : " OFF");
            this.bEnabled = _arg_2;
            this.sDesc = _arg_3;
            btnLeft.addEventListener(MouseEvent.CLICK, onToggle, false, 0, true);
            btnRight.addEventListener(MouseEvent.CLICK, onToggle, false, 0, true);
        }

        public function confirmAction(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                bypass = true;
                btnLeft.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        public function onToggle(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            var _local_3:*;
            switch (txtName.text)
            {
                case "Custom Drops UI":
                    if (((!(bEnabled)) || (bypass))) break;
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "Turning this off will decline all drops! Are you sure?";
                    _local_3.params = {};
                    _local_3.callback = confirmAction;
                    _local_3.glow = "red,medium";
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                    return;
                case "Chat UI":
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "You must restart your client for changes to take affect!";
                    _local_3.callback = null;
                    _local_3.btns = "mono";
                    _local_3.glow = "red,medium";
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                    break;
            };
            bypass = false;
            bEnabled = (!(bEnabled));
            txtStatus.text = ((bEnabled) ? "ON" : " OFF");
            optionHandler.cmd(rootClass, txtName.text);
        }


    }
}//package liteAssets.listOptionsItem

