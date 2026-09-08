// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ConnDetailMC

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;

    public class ConnDetailMC extends MovieClip 
    {

        public var txtContact:TextField;
        public var mcPct:TextField;
        public var txtBack:TextField;
        public var mcSpinner:MovieClip;
        public var txtDetail:TextField;
        public var mcSpinner2:MovieClip;
        public var btnContact:SimpleButton;
        public var btnBack:SimpleButton;
        private var timerConnDetail:Timer = new Timer(10000, 1);
        public var rootClass:MovieClip;
        private var minutes:int;
        private var countDownTimer:Timer;
        private var firstJoin:Boolean = false;

        public function ConnDetailMC(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            txtBack.mouseEnabled = false;
            mcPct.visible = false;
            txtDetail.mouseEnabled = false;
            txtContact.mouseEnabled = false;
            setBtnContact(false);
            btnBack.addEventListener(MouseEvent.CLICK, onBackClick, false, 0, true);
            timerConnDetail.removeEventListener(TimerEvent.TIMER, showBackButton);
            timerConnDetail.addEventListener(TimerEvent.TIMER, showBackButton, false, 0, true);
            btnContact.addEventListener(MouseEvent.CLICK, onContactClick, false, 0, true);
        }

        internal function setBtnContact(_arg_1:Boolean):void
        {
            txtContact.visible = _arg_1;
            btnContact.visible = _arg_1;
            if (_arg_1)
            {
                btnBack.x = 397.25;
                txtBack.x = 340.9;
                txtDetail.y = 397.3;
            }
            else
            {
                btnBack.x = 476.7;
                txtBack.x = 420.35;
                txtDetail.y = 364.7;
            };
        }

        internal function logout():void
        {
            if (rootClass.sfc.isConnected)
            {
                rootClass.sfc.disconnect();
            };
            rootClass.gotoAndPlay("Login");
        }

        internal function onContactClick(_arg_1:MouseEvent):void
        {
            logout();
            navigateToURL(new URLRequest("https://www.aq.com/help/aw-accounts-locked.asp"), "_blank");
            hideConn();
            FacebookConnect.StopPoll();
        }

        internal function onBackClick(_arg_1:MouseEvent=null):void
        {
            if ((((rootClass.sfc.isConnected) && (rootClass.litePreference.data.bDebugger)) && ((rootClass.world) && (rootClass.world.myAvatar))))
            {
                hideConn();
                return;
            };
            logout();
            hideConn();
            FacebookConnect.StopPoll();
        }

        public function showConn(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            setBtnContact(false);
            mcSpinner.visible = true;
            mcSpinner2.visible = true;
            btnBack.visible = false;
            txtBack.visible = false;
            txtBack.text = "Cancel";
            txtDetail.text = _arg_1;
            firstJoin = _arg_2;
            if (stage == null)
            {
                rootClass.addChild(this);
            };
            rootClass.setChildIndex(this, (rootClass.numChildren - 1));
            if (((!(timerConnDetail.running)) && (!(_arg_3))))
            {
                timerConnDetail.reset();
                timerConnDetail.start();
            };
        }

        public function showDisconnect(_arg_1:String):void
        {
            setBtnContact(false);
            btnBack.visible = true;
            txtBack.visible = true;
            txtBack.text = "Back";
            txtDetail.text = _arg_1;
            mcSpinner.visible = false;
            mcPct.visible = false;
            if (stage == null)
            {
                rootClass.addChild(this);
            };
            if (timerConnDetail.running)
            {
                timerConnDetail.stop();
            };
        }

        public function showBackButton(_arg_1:TimerEvent=null):void
        {
            btnBack.visible = true;
            txtBack.visible = true;
        }

        public function showError(_arg_1:String):void
        {
            if (stage == null)
            {
                rootClass.addChild(this);
            };
            setBtnContact(true);
            txtDetail.htmlText = _arg_1;
            mcSpinner.visible = false;
            mcSpinner2.visible = false;
            txtBack.text = "Back";
            showBackButton();
        }

        public function hideConn():void
        {
            setBtnContact(false);
            if (stage != null)
            {
                rootClass.removeChild(this);
            };
        }

        public function showCountDown(_arg_1:int):void
        {
            countDownTimer = new Timer(60000, 1);
            minutes = _arg_1;
            this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
            countDownTimer.addEventListener(TimerEvent.TIMER, onCountdown, false, 0, true);
            countDownTimer.start();
        }

        private function onRemove(_arg_1:Event):void
        {
            countDownTimer.removeEventListener(TimerEvent.TIMER, onCountdown);
        }

        private function onCountdown(_arg_1:TimerEvent):void
        {
            minutes--;
            countDownTimer.stop();
            if (minutes > 0)
            {
                countDownTimer.reset();
                countDownTimer.start();
            }
            else
            {
                countDownTimer.removeEventListener(TimerEvent.TIMER, onCountdown);
            };
        }


    }
}//package 

