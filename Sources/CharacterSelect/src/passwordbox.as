// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//passwordbox

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;

    public class passwordbox extends MovieClip 
    {

        public var bl1:MovieClip;
        public var btnClose:SimpleButton;
        public var txtWarning:TextField;
        public var bg:MovieClip;
        public var txtPassword:TextField;
        public var tr1:MovieClip;
        public var tr2:MovieClip;
        public var tl1:MovieClip;
        public var tr3:MovieClip;
        public var br1:MovieClip;
        public var tl2:MovieClip;
        private var m:MovieClip;
        public var bCharOpts:Boolean = false;
        public var pos:int = -1;

        public function passwordbox(_arg_1:MovieClip)
        {
            m = _arg_1;
            visible = false;
            txtWarning.visible = false;
            txtPassword.addEventListener(MouseEvent.CLICK, onPasswordClick, false, 0, true);
            txtPassword.addEventListener(KeyboardEvent.KEY_DOWN, onPasswordEnter, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
        }

        public function onPasswordClick(_arg_1:MouseEvent):void
        {
            if (txtPassword.text == "Enter Password...")
            {
                txtPassword.text = "";
            };
            txtPassword.displayAsPassword = true;
        }

        public function onPasswordEnter(_arg_1:KeyboardEvent):void
        {
            var _local_2:*;
            if (_arg_1.keyCode == 13)
            {
                _local_2 = m.mngr.displayAvts[pos].loginInfo;
                if (bCharOpts)
                {
                    m.charoptionsui.setOff();
                }
                else
                {
                    m.login(_local_2.strUsername, txtPassword.text);
                };
            };
        }

        public function onBtnClose(_arg_1:MouseEvent):void
        {
            visible = false;
        }


    }
}//package 

