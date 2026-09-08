// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//charoptions

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    public class charoptions extends MovieClip 
    {

        public var tl3:MovieClip;
        public var bl1:MovieClip;
        public var checkmark:MovieClip;
        public var btnClose:SimpleButton;
        public var chkbox:MovieClip;
        public var bg:MovieClip;
        public var tr1:MovieClip;
        public var tr2:MovieClip;
        public var tl1:MovieClip;
        public var tr3:MovieClip;
        public var br1:MovieClip;
        public var tl2:MovieClip;
        private var m:MovieClip;

        public function charoptions(_arg_1:MovieClip)
        {
            m = _arg_1;
            visible = false;
            this.checkmark.mouseEnabled = false;
            this.chkbox.addEventListener(MouseEvent.CLICK, onChk, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
        }

        public function onBtnClose(_arg_1:MouseEvent):void
        {
            m.utl.close(1);
        }

        public function init(_arg_1:Boolean):void
        {
            this.checkmark.visible = _arg_1;
        }

        public function onChk(_arg_1:MouseEvent):void
        {
            if (this.checkmark.visible)
            {
                m.passwordui.bCharOpts = true;
                m.passwordui.pos = m.pos;
                m.passwordui.visible = true;
                this.visible = false;
                return;
            };
            this.checkmark.visible = (!(this.checkmark.visible));
            m.mngr.setAsk(m.mngr.displayAvts[m.pos].data.strUsername, this.checkmark.visible);
            m.mngr.displayAvts[m.pos].loginInfo.bAsk = this.checkmark.visible;
        }

        public function setOff():void
        {
            this.checkmark.visible = false;
            m.mngr.setAsk(m.mngr.displayAvts[m.passwordui.pos].data.strUsername, false);
            m.mngr.displayAvts[m.passwordui.pos].loginInfo.bAsk = false;
            m.passwordui.pos = -1;
            m.passwordui.visible = false;
        }


    }
}//package 

