// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mcOption

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.ColorTransform;
    import flash.media.SoundTransform;
    import flash.media.SoundMixer;
    import liteAssets.draw.worldCamera;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import liteAssets.draw.cameraTool;
    import liteAssets.listOptionsItem.listOptionsItemTxt;
    import liteAssets.listOptionsItem.listOptionsItemBtn;
    import liteAssets.listOptionsItem.listOptionsItem;
    import liteAssets.listOptionsItem.listOptionsItemExtraBtn;
    import liteAssets.listOptionsItem.listOptionsItemExtra;
    import liteAssets.listOptionsItem.*;

    public class mcOption extends MovieClip 
    {

        private const arrQuality:Array = new Array("AUTO", "LOW", "MEDIUM", "HIGH");

        public var txtGuild:TextField;
        public var btnRightAllCloak:MovieClip;
        public var txtFriendsList:TextField;
        public var btnLeftAnim:MovieClip;
        public var txtGoto:TextField;
        public var btnLeftTool:MovieClip;
        public var btnShowAdv:SimpleButton;
        public var btnAllSound:SimpleButton;
        public var fbText:TextField;
        public var btnHelp:SimpleButton;
        public var btnLeftParty:MovieClip;
        public var txtFriend:TextField;
        public var btnLogoutFB:MovieClip;
        public var txtBGProf:TextField;
        public var btnLeftWhisp:MovieClip;
        public var btnLeftOtherPet:MovieClip;
        public var btnFriend:SimpleButton;
        public var txtFBLink:TextField;
        public var btnLeftCloak:MovieClip;
        public var txtCloak:TextField;
        public var btnRightCloak:MovieClip;
        public var btnAccount:MovieClip;
        public var mcVis:MovieClip;
        public var txtShare:TextField;
        public var btnLore:SimpleButton;
        public var btnRightWhisp:MovieClip;
        public var btnRightDuel:MovieClip;
        public var mcServer:MovieClip;
        public var btnLeftGuild:MovieClip;
        public var txtDuel:TextField;
        public var txtHelm:TextField;
        public var btnGame:MovieClip;
        public var btnMusic:SimpleButton;
        public var btnPlayer:SimpleButton;
        public var btnRightGuild:MovieClip;
        public var btnGeneral:MovieClip;
        public var btnGuild:SimpleButton;
        public var btnRightParty:MovieClip;
        public var btnRightFriend:MovieClip;
        public var btnLeftFriend:MovieClip;
        public var btnLeftGoto:MovieClip;
        public var txtTool:TextField;
        public var txtPet:TextField;
        public var btnIgnore:SimpleButton;
        public var bg:MovieClip;
        public var txtProf:TextField;
        public var txtParty:TextField;
        public var btnRightHelm:MovieClip;
        public var btnLeftHelm:MovieClip;
        public var btnRightTool:MovieClip;
        public var btnAdvOptions:SimpleButton;
        public var btnCameraTool:SimpleButton;
        public var txtAllCloak:TextField;
        public var btnChange:SimpleButton;
        public var btnLogout:SimpleButton;
        public var btnFBFriends:SimpleButton;
        public var btnFX:SimpleButton;
        public var txtOtherPet:TextField;
        public var btnRightPet:MovieClip;
        public var btnLeftPet:MovieClip;
        public var bg2:MovieClip;
        public var btnScreen:SimpleButton;
        public var btnRightAnim:MovieClip;
        public var txtAnim:TextField;
        public var btnLeftAllCloak:MovieClip;
        public var btnChat:MovieClip;
        public var txtLatency:TextField;
        public var btnLink:SimpleButton;
        public var btnAcc:SimpleButton;
        public var btnLeftProf:MovieClip;
        public var bgProf:MovieClip;
        public var txtWhisp:TextField;
        public var btnRightOtherPet:MovieClip;
        public var btnRightGoto:MovieClip;
        public var latencyStatus:MovieClip;
        public var btnShare:SimpleButton;
        public var btnRightProf:MovieClip;
        public var btnLeftDuel:MovieClip;
        public var txtCVersion:TextField;
        private var rootClass:MovieClip;
        private var ptrQ:uint = 0;
        private var serverTimer:Timer = new Timer(1000);
        private var strFriend:String = "{app_id:163679093835836, redirect_uri:'nightvaults.com/', title='title 50 max characters', data='requestTrackingID=5125136'}";
        private var strExclude:String = "";
        private var passMC:MovieClip;
        private var ArrowButtons:Object;
        public var optObj:*;
        public var optItem:*;
        public var Len:*;
        public var optionList:*;
        public var hRun:Number;
        public var dRun:Number;
        public var oy:Number;
        public var mDown:Boolean;
        public var mbY:int;
        public var mbD:int;
        public var mhY:int;
        public var pos:int;
        public var i:int;
        private var toolTip:ToolTipMC;
        private var toolTipMC:*;
        public var latency:Number;
        internal var sDown:Boolean;

        public function mcOption(_arg_1:MovieClip)
        {
            addFrameScript(0, frame1, 9, frame10, 17, frame18, 25, frame26);
            rootClass = _arg_1;
        }

        public function Init():void
        {
            btnGeneral.gotoAndStop(1);
            btnChat.gotoAndStop(1);
            btnAccount.gotoAndStop(1);
            btnGame.gotoAndStop(1);
            if (this.currentLabel != "General")
            {
                this.gotoAndPlay("General");
            };
            btnGeneral.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnGeneral.gotoAndStop(2);
            btnGeneral.buttonMode = true;
            btnChat.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnChat.buttonMode = true;
            btnAccount.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnAccount.buttonMode = true;
            btnGame.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnGame.buttonMode = true;
            bg.btnClose.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            btnChange.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            btnLogout.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            setUpFrame("General");
            this.btnShowAdv.visible = false;
            this.btnAdvOptions.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            bg2.visible = rootClass.litePreference.data.bVisible;
            bg2.bg.btnClose.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            bg2.bg.btnClose.visible = true;
            toolTipMC = rootClass.ui.ToolTip;
            rootClass.initlitePref();
            redraw(rootClass.litePref);
            bg2.SBar.h.addEventListener(MouseEvent.MOUSE_DOWN, onScrDown, false, 0, true);
            bg2.addEventListener(MouseEvent.MOUSE_UP, onScrUp, false, 0, true);
            bg2.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
            optionList.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
            optionList.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            bg2.txtSearch.addEventListener(Event.CHANGE, onSearch, false, 0, true);
            bg2.txtSearch.text = "";
            serverTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            serverTimer.start();
            txtCVersion.visible = true;
            txtCVersion.text = rootClass.cVersion;
            if (int(rootClass.world.myAvatar.objData.iAge) < 18)
            {
                rootClass.uoPref.bProf = true;
            };
            latency = new Date().getTime();
            var _local_1:ColorTransform = new ColorTransform();
            _local_1.color = 0xFF0000;
            latencyStatus.transform.colorTransform = _local_1;
            rootClass.sfc.sendXtMessage("zm", "hi", [], "str", 1);
        }

        public function fClose():void
        {
            serverTimer.stop();
            serverTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
            var _local_1:MovieClip = MovieClip(parent);
            _local_1.removeChild(this);
            if (_local_1.currentLabel != "Init")
            {
                _local_1.gotoAndPlay("Init");
            };
        }

        public function setProfanity(_arg_1:Boolean):void
        {
            bgProf.visible = _arg_1;
            txtBGProf.visible = _arg_1;
            txtProf.visible = _arg_1;
            btnLeftProf.visible = _arg_1;
            btnRightProf.visible = _arg_1;
        }

        public function InitAccount():void
        {
            btnGeneral.gotoAndStop(1);
            btnChat.gotoAndStop(1);
            btnAccount.gotoAndStop(1);
            btnGame.gotoAndStop(1);
            if (this.currentLabel != "Account")
            {
                this.gotoAndPlay("Account");
            };
            btnGeneral.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnGeneral.buttonMode = true;
            btnChat.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnChat.buttonMode = true;
            btnGame.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnGame.buttonMode = true;
            btnAccount.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            btnAccount.buttonMode = true;
            btnChange.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            btnLogout.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            bg.btnClose.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
            btnAccount.gotoAndStop(2);
            serverTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            serverTimer.start();
        }

        private function timerHandler(_arg_1:TimerEvent):void
        {
            if (stage == null)
            {
                serverTimer.stop();
                serverTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
            }
            else
            {
                if (mcServer != null)
                {
                    mcServer.txtTime.text = rootClass.date_server.toLocaleTimeString();
                };
            };
            if (MovieClip(parent) != null)
            {
                if (MovieClip(parent).currentLabel != "Option")
                {
                    MovieClip(parent).removeChild(this);
                    serverTimer.stop();
                    serverTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
                };
            };
        }

        public function updateLatency():void
        {
            txtLatency.text = (String(latency) + " ms");
            var _local_1:ColorTransform = new ColorTransform();
            if (Number(latency) < 100)
            {
                _local_1.color = 0xFF00;
            }
            else
            {
                if (Number(latency) < 200)
                {
                    _local_1.color = 0xFFFF00;
                }
                else
                {
                    _local_1.color = 0xFF0000;
                };
            };
            latencyStatus.transform.colorTransform = _local_1;
        }

        private function setUpFrame(_arg_1:String):void
        {
            var _local_2:uint;
            switch (_arg_1)
            {
                case "General":
                    rootClass.userPreference.data.bSoundOn = true;
                    mcVis.txtQuality.text = rootClass.userPreference.data.quality;
                    mcServer.txtServer.text = rootClass.objServerInfo.sName;
                    if (!mcVis.btnLeftQual.hasEventListener(MouseEvent.CLICK))
                    {
                        mcVis.btnLeftQual.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        mcVis.btnRightQual.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnScreen.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnMusic.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnFX.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnAllSound.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnCameraTool.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnFriend.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnGuild.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnIgnore.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnAdvOptions.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        _local_2 = 0;
                        while (_local_2 < arrQuality.length)
                        {
                            if (mcVis.txtQuality.text == arrQuality[_local_2])
                            {
                                ptrQ = _local_2;
                                break;
                            };
                            _local_2++;
                        };
                    };
                    setQual();
                    return;
                case "Gameplay":
                    if (!btnRightTool.hasEventListener(MouseEvent.CLICK))
                    {
                        btnRightTool.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftTool.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightPet.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftPet.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightHelm.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftHelm.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightCloak.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftCloak.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftAllCloak.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightAllCloak.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightGoto.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftGoto.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftOtherPet.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightOtherPet.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightAnim.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftAnim.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                    };
                    txtTool.text = ((rootClass.uoPref.bTT) ? "On" : "Off");
                    txtPet.text = ((rootClass.uoPref.bPet) ? "Yes" : "No");
                    txtHelm.text = ((rootClass.uoPref.bHelm) ? "Yes" : "No");
                    txtCloak.text = ((rootClass.uoPref.bCloak) ? "Yes" : "No");
                    txtGoto.text = ((rootClass.uoPref.bGoto) ? "On" : "Off");
                    txtAnim.text = ((rootClass.world.showAnimations) ? "On" : "Off");
                    txtAllCloak.text = ((rootClass.world.hideAllCapes) ? "Yes" : "No");
                    txtOtherPet.text = ((rootClass.world.hideOtherPets) ? "Yes" : "No");
                    return;
                case "Social":
                    setProfanity((int(rootClass.world.myAvatar.objData.iAge) >= 18));
                    if (!btnRightParty.hasEventListener(MouseEvent.CLICK))
                    {
                        btnRightParty.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftParty.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightFriend.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftFriend.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightDuel.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftDuel.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightGuild.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftGuild.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightWhisp.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftWhisp.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnRightProf.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLeftProf.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                    };
                    txtParty.text = ((rootClass.uoPref.bParty) ? "On" : "Off");
                    txtFriend.text = ((rootClass.uoPref.bFriend) ? "On" : "Off");
                    txtDuel.text = ((rootClass.uoPref.bDuel) ? "On" : "Off");
                    txtGuild.text = ((rootClass.uoPref.bGuild) ? "On" : "Off");
                    txtWhisp.text = ((rootClass.uoPref.bWhisper) ? "On" : "Off");
                    txtProf.text = ((rootClass.uoPref.bProf) ? "On" : "Off");
                    return;
                case "Account":
                    if (!btnAcc.hasEventListener(MouseEvent.CLICK))
                    {
                        btnAcc.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnHelp.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnPlayer.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        btnLore.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        if (((rootClass.world.myAvatar.objData.iAge < 13) || ((Game.objLogin.FBID > 0) && (!(FacebookConnect.isLoggedIn)))))
                        {
                            btnLink.visible = false;
                            txtFBLink.visible = false;
                            fbText.visible = false;
                        }
                        else
                        {
                            btnLink.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                        };
                        btnLink.visible = false;
                        txtFBLink.visible = false;
                    };
                    checkFBStatus();
                    txtFBLink.mouseEnabled = false;
                    btnLogoutFB.visible = FacebookConnect.isLoggedIn;
                    btnLogoutFB.addEventListener(MouseEvent.CLICK, onArrowClick, false, 0, true);
                    btnLogoutFB.buttonMode = true;
                    btnFBFriends.visible = false;
                    txtFriendsList.visible = false;
                    btnShare.visible = false;
                    txtShare.visible = false;
                    return;
            };
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            btnGeneral.gotoAndStop(1);
            btnChat.gotoAndStop(1);
            btnAccount.gotoAndStop(1);
            btnGame.gotoAndStop(1);
            _arg_1.currentTarget.gotoAndStop(2);
            switch (_arg_1.currentTarget.name)
            {
                case "btnGeneral":
                    if (this.currentLabel != "General")
                    {
                        this.gotoAndPlay("General");
                    };
                    return;
                case "btnGame":
                    if (this.currentLabel != "Gameplay")
                    {
                        this.gotoAndPlay("Gameplay");
                    };
                    return;
                case "btnChat":
                    if (this.currentLabel != "Social")
                    {
                        this.gotoAndPlay("Social");
                    };
                    return;
                case "btnAccount":
                    if (this.currentLabel != "Account")
                    {
                        this.gotoAndPlay("Account");
                    };
                    return;
            };
        }

        public function musicVolume(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.litePreference.data.dOptions["iSoundMusic"] = Number((_arg_1.iQty / 100));
                rootClass.litePreference.flush();
                if (((rootClass.world.sController) && (rootClass.world.sController.mChannel)))
                {
                    rootClass.world.sController.mChannel.soundTransform = new SoundTransform((_arg_1.iQty / 100));
                };
            };
        }

        public function fxVolume(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.litePreference.data.dOptions["iSoundFX"] = Number((_arg_1.iQty / 100));
                rootClass.litePreference.flush();
                rootClass.mixer.stf = new SoundTransform((_arg_1.iQty / 100));
            };
        }

        public function allVolume(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.litePreference.data.dOptions["iSoundAll"] = Number((_arg_1.iQty / 100));
                rootClass.litePreference.flush();
                SoundMixer.soundTransform = new SoundTransform((_arg_1.iQty / 100));
            };
        }

        private function onArrowClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            var _local_3:*;
            rootClass.mixer.playSound("Click");
            switch (_arg_1.currentTarget.name)
            {
                case "btnAdvOptions":
                    bg2.visible = (!(bg2.visible));
                    rootClass.litePreference.data.bVisible = bg2.visible;
                    return;
                case "btnLeftQual":
                    ptrQ = ((--ptrQ < 0) ? 3 : ptrQ);
                    setQual();
                    return;
                case "btnRightQual":
                    ptrQ = ((++ptrQ > 3) ? 0 : ptrQ);
                    setQual();
                    return;
                case "btnScreen":
                    rootClass.stage.addChild(new worldCamera(rootClass));
                    return;
                case "btnMusic":
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.params = {};
                    _local_3.strBody = "Change Music Volume?";
                    _local_3.callback = musicVolume;
                    _local_3.qtySel = {
                        "min":0,
                        "max":100,
                        "base":((rootClass.litePreference.data.dOptions["iSoundMusic"] != null) ? (rootClass.litePreference.data.dOptions["iSoundMusic"] * 100) : 35)
                    };
                    _local_3.glow = "white,medium";
                    _local_3.greedy = true;
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                    return;
                case "btnFX":
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.params = {};
                    _local_3.strBody = "Change Sound FX Volume?";
                    _local_3.callback = fxVolume;
                    _local_3.qtySel = {
                        "min":0,
                        "max":100,
                        "base":((rootClass.litePreference.data.dOptions["iSoundFX"] != null) ? (rootClass.litePreference.data.dOptions["iSoundFX"] * 100) : 100)
                    };
                    _local_3.glow = "white,medium";
                    _local_3.greedy = true;
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                    return;
                case "btnAllSound":
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.params = {};
                    _local_3.strBody = "Change Other Sounds Volume? This will affect the volume of Music and SoundFX as well";
                    _local_3.callback = allVolume;
                    _local_3.qtySel = {
                        "min":0,
                        "max":100,
                        "base":((rootClass.litePreference.data.dOptions["iSoundAll"] != null) ? (rootClass.litePreference.data.dOptions["iSoundAll"] * 100) : 100)
                    };
                    _local_3.glow = "white,medium";
                    _local_3.greedy = true;
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                    return;
                case "btnLeftPet":
                case "btnRightPet":
                    txtPet.text = ((txtPet.text == "Yes") ? "No" : "Yes");
                    if (rootClass.uoPref.bPet)
                    {
                        rootClass.uoPref.bPet = false;
                        rootClass.world.hideAllPets();
                    }
                    else
                    {
                        rootClass.uoPref.bPet = true;
                        rootClass.world.showAllPets();
                        if (rootClass.world.hideOtherPets)
                        {
                            rootClass.world.hideAllPets(false);
                        };
                    };
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bPet", String(rootClass.uoPref.bPet)], "str", 1);
                    return;
                case "btnLeftOtherPet":
                case "btnRightOtherPet":
                    txtOtherPet.text = ((txtOtherPet.text == "Yes") ? "No" : "Yes");
                    if (rootClass.world.hideOtherPets)
                    {
                        rootClass.world.hideOtherPets = false;
                        rootClass.world.showAllPets(false);
                    }
                    else
                    {
                        rootClass.world.hideOtherPets = true;
                        rootClass.world.hideAllPets(false);
                    };
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bOtherPets", String(rootClass.world.hideOtherPets)], "str", 1);
                    return;
                case "btnLeftHelm":
                case "btnRightHelm":
                    txtHelm.text = ((txtHelm.text == "Yes") ? "No" : "Yes");
                    rootClass.uoPref.bHelm = (!(rootClass.uoPref.bHelm));
                    rootClass.world.myAvatar.dataLeaf.showHelm = rootClass.uoPref.bHelm;
                    rootClass.world.myAvatar.pMC.setHelmVisibility(rootClass.uoPref.bHelm);
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bHelm", String(rootClass.uoPref.bHelm)], "str", 1);
                    return;
                case "btnLeftCloak":
                case "btnRightCloak":
                    txtCloak.text = ((txtCloak.text == "Yes") ? "No" : "Yes");
                    rootClass.uoPref.bCloak = (!(rootClass.uoPref.bCloak));
                    rootClass.world.myAvatar.dataLeaf.showCloak = rootClass.uoPref.bCloak;
                    rootClass.world.myAvatar.pMC.setCloakVisibility(rootClass.uoPref.bCloak);
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bCloak", String(rootClass.uoPref.bCloak)], "str", 1);
                    return;
                case "btnLeftAllCloak":
                case "btnRightAllCloak":
                    txtAllCloak.text = ((txtAllCloak.text == "Yes") ? "No" : "Yes");
                    rootClass.world.hideAllCapes = (!(rootClass.world.hideAllCapes));
                    rootClass.world.setAllCloakVisibility();
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bAllCloak", String(rootClass.world.hideAllCapes)], "str", 1);
                    return;
                case "btnLeftTool":
                case "btnRightTool":
                    txtTool.text = ((txtTool.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bTT = (!(rootClass.uoPref.bTT));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bTT", String(rootClass.uoPref.bTT)], "str", 1);
                    return;
                case "btnLeftGoto":
                case "btnRightGoto":
                    txtGoto.text = ((txtGoto.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bGoto = (!(rootClass.uoPref.bGoto));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bGoto", String(rootClass.uoPref.bGoto)], "str", 1);
                    return;
                case "btnLeftParty":
                case "btnRightParty":
                    txtParty.text = ((txtParty.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bParty = (!(rootClass.uoPref.bParty));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bParty", String(rootClass.uoPref.bParty)], "str", 1);
                    return;
                case "btnLeftDuel":
                case "btnRightDuel":
                    txtDuel.text = ((txtDuel.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bDuel = (!(rootClass.uoPref.bDuel));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bDuel", String(rootClass.uoPref.bDuel)], "str", 1);
                    return;
                case "btnLeftAnim":
                case "btnRightAnim":
                    txtAnim.text = ((txtAnim.text == "On") ? "Off" : "On");
                    rootClass.world.showAnimations = (!(rootClass.world.showAnimations));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bAnim", String(rootClass.world.showAnimations)], "str", 1);
                    return;
                case "btnLeftFriend":
                case "btnRightFriend":
                    txtFriend.text = ((txtFriend.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bFriend = (!(rootClass.uoPref.bFriend));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bFriend", String(rootClass.uoPref.bFriend)], "str", 1);
                    return;
                case "btnLeftGuild":
                case "btnRightGuild":
                    txtGuild.text = ((txtGuild.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bGuild = (!(rootClass.uoPref.bGuild));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bGuild", String(rootClass.uoPref.bGuild)], "str", 1);
                    return;
                case "btnLeftWhisp":
                case "btnRightWhisp":
                    txtWhisp.text = ((txtWhisp.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bWhisper = (!(rootClass.uoPref.bWhisper));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bWhisper", String(rootClass.uoPref.bWhisper)], "str", 1);
                    return;
                case "btnLeftProf":
                case "btnRightProf":
                    txtProf.text = ((txtProf.text == "On") ? "Off" : "On");
                    rootClass.uoPref.bProf = (!(rootClass.uoPref.bProf));
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["uopref", "bProf", String(rootClass.uoPref.bProf)], "str", 1);
                    return;
                case "btnFriend":
                    rootClass.world.showFriendsList();
                    return;
                case "btnGuild":
                    rootClass.world.showGuildList();
                    return;
                case "btnIgnore":
                    rootClass.world.showIgnoreList();
                    return;
                case "btnAcc":
                    navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
                    return;
                case "btnChar":
                    return;
                case "btnHelp":
                    navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
                    return;
                case "btnCameraTool":
                    rootClass.cameraToolMC = new cameraTool(rootClass);
                    rootClass.cameraToolMC.x = -7;
                    rootClass.addChild(rootClass.cameraToolMC);
                    rootClass.world.visible = false;
                    return;
                case "btnLogout":
                    rootClass.logout();
                    return;
                case "btnClose":
                    rootClass.ui.mcPopup.onClose();
                    rootClass.stage.focus = null;
                    return;
                case "btnLore":
                    navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
                    return;
                case "btnChange":
                    rootClass.showServerList();
                    return;
                case "btnPlayer":
                    navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
                    return;
                case "btnLink":
                    if (FacebookConnect.isLoggedIn)
                    {
                        passMC = (new mcFBPassword(rootClass) as MovieClip);
                        passMC.x = 268;
                        passMC.y = 30;
                        rootClass.ui.addChild(passMC);
                    };
                    return;
                case "btnLogoutFB":
                    FacebookConnect.Logout();
                    rootClass.logout();
                    return;
            };
        }

        private function setQual():void
        {
            mcVis.txtQuality.text = (rootClass.userPreference.data.quality = arrQuality[ptrQ]);
            if (rootClass.userPreference.data.quality == "AUTO")
            {
                stage.quality = "HIGH";
            }
            else
            {
                stage.quality = rootClass.userPreference.data.quality;
            };
            try
            {
                rootClass.userPreference.flush();
            }
            catch(e:Error)
            {
            };
        }

        public function checkFBStatus():void
        {
            if (this.currentLabel == "Account")
            {
                txtFBLink.text = ((FacebookConnect.isLoggedIn) ? "Unlink" : "Link");
            };
        }

        public function closeUnlink():void
        {
            try
            {
                rootClass.ui.removeChild(passMC);
            }
            catch(e)
            {
            };
        }

        public function onOver(_arg_1:MouseEvent):void
        {
            try
            {
                if (!_arg_1.target.parent.sDesc)
                {
                    return;
                };
                toolTipMC.openWith({"str":_arg_1.target.parent.sDesc});
            }
            catch(e)
            {
            };
        }

        public function onOut(_arg_1:MouseEvent):*
        {
            try
            {
                toolTipMC.close();
            }
            catch(e)
            {
            };
        }

        public function orderName(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = _arg_1["strName"];
            var _local_4:* = _arg_2["strName"];
            if (_local_3 < _local_4)
            {
                return (-1);
            };
            if (_local_3 > _local_4)
            {
                return (1);
            };
            return (0);
        }

        public function redraw(_arg_1:Array):void
        {
            var _local_2:*;
            var _local_4:int;
            bg2.SBar.h.y = 0;
            if (optionList != null)
            {
                bg2.removeChild(optionList);
                optionList = null;
            };
            optionList = bg2.addChild(new MovieClip());
            Len = _arg_1.length;
            _arg_1.sort(orderName);
            i = 0;
            var _local_3:* = 0;
            while (i < Len)
            {
                optObj = _arg_1[i];
                if (optObj.hasOwnProperty("minAccess"))
                {
                    if (Game.objLogin.iAccess < optObj.minAccess)
                    {
                        i = (i + 1);
                        continue;
                    };
                };
                switch (true)
                {
                    case optObj.hasOwnProperty("special"):
                        optItem = new listOptionsItemTxt(rootClass, optObj.sDesc);
                        optItem.txtName.text = optObj.strName;
                        _local_2 = optionList.addChild(optItem);
                        _local_2.x = bg2.cntMask.x;
                        _local_2.y = (bg2.cntMask.y + (35 * _local_3));
                        _local_2.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                        _local_2.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
                        break;
                    case ((optObj.hasOwnProperty("extra")) && (optObj.extra is String)):
                        optItem = new listOptionsItemBtn(rootClass, optObj.sDesc);
                        optItem.txtName.text = optObj.strName;
                        _local_2 = optionList.addChild(optItem);
                        _local_2.x = bg2.cntMask.x;
                        _local_2.y = (bg2.cntMask.y + (35 * _local_3));
                        _local_2.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                        _local_2.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
                        break;
                    case ((optObj.hasOwnProperty("extra")) && (optObj.extra is Array)):
                        optItem = new listOptionsItem(rootClass, optObj.bEnabled, optObj.sDesc);
                        optItem.txtName.text = optObj.strName;
                        _local_2 = optionList.addChild(optItem);
                        _local_2.x = bg2.cntMask.x;
                        _local_2.y = (bg2.cntMask.y + (35 * _local_3));
                        _local_2.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                        _local_2.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
                        _local_4 = 0;
                        while (_local_4 < optObj.extra.length)
                        {
                            _local_3++;
                            if (optObj.extra[_local_4].hasOwnProperty("extra"))
                            {
                                optItem = new listOptionsItemExtraBtn(rootClass, optObj.extra[_local_4].sDesc);
                            }
                            else
                            {
                                optItem = new listOptionsItemExtra(rootClass, optObj.extra[_local_4].bEnabled, optObj.extra[_local_4].sDesc);
                            };
                            optItem.txtName.text = optObj.extra[_local_4].strName;
                            _local_2 = optionList.addChild(optItem);
                            _local_2.x = (bg2.cntMask.x + 9);
                            _local_2.y = (bg2.cntMask.y + (35 * _local_3));
                            _local_2.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                            _local_2.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
                            _local_4++;
                        };
                        break;
                    default:
                        optItem = new listOptionsItem(rootClass, optObj.bEnabled, optObj.sDesc);
                        optItem.txtName.text = optObj.strName;
                        _local_2 = optionList.addChild(optItem);
                        _local_2.x = bg2.cntMask.x;
                        _local_2.y = (bg2.cntMask.y + (35 * _local_3));
                        _local_2.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                        _local_2.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
                };
                i++;
                _local_3++;
            };
            optionList.mask = bg2.cntMask;
            mDown = false;
            hRun = (bg2.SBar.b.height - bg2.SBar.h.height);
            dRun = ((optionList.height - bg2.cntMask.height) + 5);
            oy = optionList.y;
            optionList.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
            optionList.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
        }

        public function onSearch(_arg_1:Event):void
        {
            rootClass.initlitePref();
            var _local_2:Number = 0;
            var _local_3:Array = new Array();
            var _local_4:int;
            while (_local_4 < rootClass.litePref.length)
            {
                if (rootClass.litePref[_local_4].strName.toLowerCase().indexOf(bg2.txtSearch.text.toLowerCase()) > -1)
                {
                    _local_3.push(rootClass.litePref[_local_4]);
                    _local_2 = (_local_2 + ((rootClass.litePref[_local_4].extra) ? (1 + rootClass.litePref[_local_4].extra.length) : 1));
                };
                _local_4++;
            };
            if (_local_2 <= 9)
            {
                bg2.SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN, onScrDown);
                bg2.removeEventListener(MouseEvent.MOUSE_UP, onScrUp);
                bg2.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            }
            else
            {
                if (((_local_2 > 9) && (!(bg2.SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN)))))
                {
                    bg2.SBar.h.addEventListener(MouseEvent.MOUSE_DOWN, onScrDown, false, 0, true);
                    bg2.addEventListener(MouseEvent.MOUSE_UP, onScrUp, false, 0, true);
                    bg2.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
                };
            };
            redraw(((bg2.txtSearch.text) ? _local_3 : rootClass.litePref));
            _local_3 = null;
        }

        private function onWheel(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            _local_2 = bg2.SBar;
            _local_2.h.y = (int(bg2.SBar.h.y) + ((_arg_1.delta * 3) * -1));
            if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
            {
                _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
            };
            if (_local_2.h.y < 0)
            {
                _local_2.h.y = 0;
            };
        }

        private function onScrDown(_arg_1:MouseEvent):*
        {
            mbY = int(mouseY);
            mhY = int(bg2.SBar.h.y);
            mDown = true;
        }

        private function onScrUp(_arg_1:MouseEvent):void
        {
            mDown = false;
        }

        private function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            if (mDown)
            {
                _local_2 = bg2.SBar;
                mbD = (int(mouseY) - mbY);
                _local_2.h.y = (mhY + mbD);
                if (((_local_2.h.y + 1) + _local_2.h.height) > (_local_2.b.height + 1))
                {
                    _local_2.h.y = int(((_local_2.b.height + 1) - _local_2.h.height));
                };
                if (_local_2.h.y < 1)
                {
                    _local_2.h.y = 1;
                };
            };
        }

        private function dEF(_arg_1:Event):*
        {
            var _local_2:* = bg2.SBar;
            var _local_3:* = optionList;
            var _local_4:* = (-(_local_2.h.y - 1) / hRun);
            var _local_5:* = (int((_local_4 * dRun)) + oy);
            if (Math.abs((_local_5 - _local_3.y)) > 0.2)
            {
                _local_3.y = (_local_3.y + ((_local_5 - _local_3.y) / 4));
            }
            else
            {
                _local_3.y = _local_5;
            };
        }

        internal function frame1():*
        {
            this.setUpFrame(this.currentLabel);
            stop();
        }

        internal function frame10():*
        {
            this.setUpFrame(this.currentLabel);
            stop();
        }

        internal function frame18():*
        {
            this.setUpFrame(this.currentLabel);
            stop();
        }

        internal function frame26():*
        {
            this.setUpFrame(this.currentLabel);
            stop();
        }


    }
}//package 

