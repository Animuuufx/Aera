// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//main

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.utils.Timer;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.net.SharedObject;
    import flash.net.URLVariables;
    import flash.net.URLRequestMethod;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import com.adobe.serialization.json.JSON;

    public class main extends MovieClip 
    {

        public var txtGold:TextField;
        public var txtGuild:TextField;
        public var btnCharOptions:SimpleButton;
        public var btnLeft:SimpleButton;
        public var btnServer:SimpleButton;
        public var txtRank:TextField;
        public var _lb1:MovieClip;
        public var _lb2:MovieClip;
        public var SCbuyACbtn:SimpleButton;
        public var _lb3:MovieClip;
        public var txtLvl:TextField;
        public var txtName:TextField;
        public var btnReset:SimpleButton;
        public var txtTitle:TextField;
        public var avt0:MovieClip;
        public var btnSettings:SimpleButton;
        public var btnManager:SimpleButton;
        public var avt1:MovieClip;
        public var txtClass:TextField;
        public var txtAC:TextField;
        public var avt2:MovieClip;
        public var btnRight:SimpleButton;
        public var btnBack:SimpleButton;
        public var btnLogin:SimpleButton;
        public var managecharsui:MovieClip;
        public var charoptionsui:MovieClip;
        public var settingsui:MovieClip;
        public var mngr:manager;
        public var utl:util;
        public var r:MovieClip;
        public var Game:Class;
        private var animTimer:Timer;
        private var anims:Array = ["Idle", "Stern", "Cheer", "Wave"];
        public var pos:* = 0;
        public var passwordui:MovieClip;
        public var skipServers:Boolean = true;
        private var loginLoader:URLLoader = new URLLoader();

        public function main()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, onStage);
            __setTab_btnLogin_Scene1_UI_0();
        }

        public function onStage(_arg_1:Event):void
        {
            r = MovieClip(stage.getChildAt(0));
            Game = (getDefinitionByName("Game") as Class);
            btnBack.addEventListener(MouseEvent.CLICK, onBtnBack, false, 0, true);
            btnReset.addEventListener(MouseEvent.CLICK, onBtnReset, false, 0, true);
            managecharsui = new managechars(this);
            addChild(managecharsui);
            managecharsui.x = 469.9;
            managecharsui.y = 288.25;
            charoptionsui = new charoptions(this);
            addChild(charoptionsui);
            charoptionsui.x = 469.9;
            charoptionsui.y = 276.35;
            passwordui = new passwordbox(this);
            addChild(passwordui);
            passwordui.x = 469.9;
            passwordui.y = 264;
            settingsui = new settings(this);
            addChild(settingsui);
            settingsui.x = 469.9;
            settingsui.y = 0xFF;
            mngr = new manager(MovieClip(stage.getChildAt(0)), this);
            utl = new util(MovieClip(stage.getChildAt(0)), this);
            _lb1.mouseEnabled = (_lb1.mouseChildren = false);
            _lb2.mouseEnabled = (_lb2.mouseChildren = false);
            _lb3.mouseEnabled = (_lb3.mouseChildren = false);
            btnManager.addEventListener(MouseEvent.CLICK, onBtnManager, false, 0, true);
            btnCharOptions.addEventListener(MouseEvent.CLICK, onBtnCharOptions, false, 0, true);
            btnServer.addEventListener(MouseEvent.CLICK, onBtnServer, false, 0, true);
            btnLogin.addEventListener(MouseEvent.CLICK, onBtnLogin, false, 0, true);
            btnLeft.addEventListener(MouseEvent.CLICK, prevCarousel, false, 0, true);
            btnRight.addEventListener(MouseEvent.CLICK, nextCarousel, false, 0, true);
            avt1.addEventListener(MouseEvent.CLICK, nextCarousel, false, 0, true);
            avt2.addEventListener(MouseEvent.CLICK, prevCarousel, false, 0, true);
            SCbuyACbtn.addEventListener(MouseEvent.CLICK, onBuyAC, false, 0, true);
            btnSettings.addEventListener(MouseEvent.CLICK, onBtnSettings, false, 0, true);
            updateCarousel();
            animTimer = new Timer(10000);
            animTimer.addEventListener(TimerEvent.TIMER, onRandomAnimations, false, 0, true);
            animTimer.start();
        }

        public function onRandomAnimations(_arg_1:TimerEvent):void
        {
            var _local_2:* = Math.floor((Math.random() * 3));
            if (MovieClip(getChildByName(("avt" + _local_2))).numChildren > 0)
            {
                MovieClip(MovieClip(getChildByName(("avt" + _local_2))).getChildAt(0)).mcChar.gotoAndPlay(anims[Math.floor((Math.random() * 4))]);
            }
        }

        public function mcSetColor(_arg_1:MovieClip, _arg_2:String, _arg_3:String):*
        {
            var _local_4:MovieClip = _arg_1;
            while ((((!(_local_4 == null)) && (!(_local_4.parent == null))) && (!(_local_4.parent == _local_4.stage))))
            {
                if (("pAV" in _local_4)) break;
                _local_4 = MovieClip(_local_4.parent);
            }
            _local_4.pAV.pMC.setColor(_arg_1, _arg_2, _arg_3);
        }

        public function updateValues(_arg_1:*, _arg_2:String):void
        {
            this.txtTitle.text = "";
            this.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + r.params.sTitle);
            _lb3.txtServer.text = _arg_2.toUpperCase();
            if (!_arg_1)
            {
                return;
            }
            this.txtGold.text = utl.addCommas(_arg_1.intGold);
            this.txtAC.text = utl.addCommas(_arg_1.intCoins);
            this.txtClass.text = _arg_1.strClassName.toUpperCase();
            this.txtRank.text = ("Rank " + r.getRankFromPoints(_arg_1.iCP));
            this.txtLvl.text = _arg_1.intLevel;
            this.txtName.text = _arg_1.strUsername;
            if (_arg_1.guild)
            {
                this.txtName.y = 109.3;
                this.txtGuild.text = (("< " + _arg_1.guild.Name) + " >");
                this.txtGuild.visible = true;
            }
            else
            {
                this.txtName.y = 123.8;
                this.txtGuild.visible = false;
            }
            switch (Number(_arg_1.intAccessLevel))
            {
                case 100:
                case 50:
                    this.txtName.textColor = 12283391;
                    return;
                case 60:
                    this.txtName.textColor = 16698168;
                    return;
                case 40:
                    this.txtName.textColor = 5308200;
                    return;
                case 30:
                    this.txtName.textColor = 52881;
                    return;
                default:
                    if ((int(_arg_1.iUpgDays) >= 0))
                    {
                        this.txtName.textColor = 9229823;
                    }
                    else
                    {
                        this.txtName.textColor = 0xFFFFFF;
                    }
            }
        }

        public function updateCarousel():void
        {
            var _local_5:*;
            var _local_1:int;
            while (_local_1 < 3)
            {
                if (MovieClip(getChildByName(("avt" + _local_1))).numChildren > 0)
                {
                    (getChildByName(("avt" + _local_1)) as MovieClip).removeChildAt(0);
                }
                _local_1++;
            }
            if (mngr.displayAvts.length < 1)
            {
                parent.removeChild(this);
                r.gotoAndPlay("Login");
                return;
            }
            var _local_2:int = (pos - 1);
            if (_local_2 < 0)
            {
                _local_2 = (mngr.displayAvts.length - 1);
            }
            var _local_3:int = (pos + 1);
            if (_local_3 > (mngr.displayAvts.length - 1))
            {
                _local_3 = 0;
            }
            var _local_4:Array = [pos, _local_3, _local_2];
            for each (_local_5 in _local_4)
            {
                if (mngr.displayAvts[_local_5])
                {
                    if (!mngr.displayAvts[_local_5]["mc"])
                    {
                        mngr.displayAvts[_local_5]["mc"] = mngr.createAvt(mngr.displayAvts[_local_5]["data"]);
                    }
                }
            }
            (getChildByName("avt0") as MovieClip).addChild(mngr.displayAvts[pos]["mc"]);
            if (_local_3 != pos)
            {
                (getChildByName("avt1") as MovieClip).addChild(mngr.displayAvts[_local_3]["mc"]);
            }
            if (((!(_local_2 == pos)) && (!(_local_2 == _local_3))))
            {
                (getChildByName("avt2") as MovieClip).addChild(mngr.displayAvts[_local_2]["mc"]);
            }
            setChildIndex(getChildByName("avt1"), (getChildIndex(getChildByName("avt0")) - 1));
            setChildIndex(getChildByName("avt2"), (getChildIndex(getChildByName("avt0")) - 1));
            updateValues(mngr.displayAvts[pos]["data"], mngr.displayAvts[pos]["server"]);
            charoptionsui.init((mngr.displayAvts[pos].loginInfo.bAsk as Boolean));
        }

        public function nextCarousel(_arg_1:MouseEvent):void
        {
            if (utl.active != -1)
            {
                return;
            }
            if (passwordui.visible)
            {
                return;
            }
            pos++;
            if (pos >= mngr.displayAvts.length)
            {
                pos = 0;
            }
            updateCarousel();
        }

        public function prevCarousel(_arg_1:MouseEvent):void
        {
            if (utl.active != -1)
            {
                return;
            }
            if (passwordui.visible)
            {
                return;
            }
            pos--;
            if (pos < 0)
            {
                pos = (mngr.displayAvts.length - 1);
            }
            updateCarousel();
        }

        public function onBuyAC(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://www.aq.com/order-now/direct/"), "_blank");
        }

        public function showConfirmBox(sMsg:String, fHandler:Function):void
        {
            var AssetClass:Class = (getDefinitionByName("ModalMC") as Class);
            var modal:* = new (AssetClass)();
            var modalO:* = {};
            modalO.strBody = sMsg;
            modalO.btns = "dual";
            modalO.params = {};
            modalO.callback = function (_arg_1:Object):*
            {
                fHandler(_arg_1.accept);
            };
            this.addChild(modal);
            modal.init(modalO);
        }

        public function onBtnReset(_arg_1:MouseEvent):void
        {
            showConfirmBox("Remove all saved characters?", onReset);
        }

        public function onReset(_arg_1:Boolean):void
        {
            var _local_2:SharedObject;
            if (_arg_1)
            {
                _local_2 = SharedObject.getLocal("AQWChars", "/");
                _local_2.data.users = new Object();
                _local_2.data.retro = true;
                _local_2.flush();
                r.showServers = false;
                r.csShowServers = false;
                parent.removeChild(this);
                r.gotoAndPlay("Login");
            }
        }

        public function onBtnBack(_arg_1:MouseEvent):void
        {
            r.showServers = false;
            r.csShowServers = false;
            parent.removeChild(this);
            r.gotoAndPlay("Login");
        }

        public function onBtnManager(_arg_1:MouseEvent):void
        {
            utl.open(0);
        }

        public function onBtnCharOptions(_arg_1:MouseEvent):void
        {
            utl.open(1);
        }

        public function onBtnSettings(_arg_1:MouseEvent):void
        {
            utl.open(2);
        }

        public function onBtnServer(_arg_1:MouseEvent):void
        {
            skipServers = false;
            var _local_2:* = mngr.displayAvts[pos].loginInfo;
            if (_local_2.bAsk)
            {
                utl.close(1);
                passwordui.pos = pos;
                passwordui.bCharOpts = false;
                passwordui.visible = true;
            }
            else
            {
                login(_local_2.strUsername, _local_2.strPassword);
            }
        }

        public function onBtnLogin(_arg_1:MouseEvent):void
        {
            skipServers = true;
            var _local_2:* = mngr.displayAvts[pos].loginInfo;
            if (_local_2.bAsk)
            {
                utl.close(1);
                passwordui.pos = pos;
                passwordui.bCharOpts = false;
                passwordui.visible = true;
            }
            else
            {
                login(_local_2.strUsername, _local_2.strPassword);
            }
        }

        public function login(strUsername:String, strPassword:String):*
        {
            r.mcConnDetail.showConn("Authenticating Account Info...");
            Game.loginInfo.strUsername = strUsername;
            Game.loginInfo.strPassword = strPassword;
            var url:String = ((r.params.loginURL + "?ran=") + Math.random());
            var request:URLRequest = new URLRequest(url);
            var variables:URLVariables = new URLVariables();
            variables.user = strUsername;
            variables.pass = strPassword;
            variables.option = "1";
            request.data = variables;
            request.method = URLRequestMethod.POST;
            loginLoader = new URLLoader();
            loginLoader.addEventListener(Event.COMPLETE, onLoginComplete, false, 0, true);
            loginLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoginError, false, 0, true);
            loginLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoginError, false, 0, true);
            try
            {
                loginLoader.load(request);
            }
            catch(error:Error)
            {
                r.mcConnDetail.showError("Login connection failed. " + error.message);
            }
        }

        public function onLoginError(_arg_1:Event):void
        {
            var detail:String = "";
            if (_arg_1 is IOErrorEvent) detail = IOErrorEvent(_arg_1).text;
            else if (_arg_1 is SecurityErrorEvent) detail = SecurityErrorEvent(_arg_1).text;
            trace("CharacterSelect login transport error: " + detail);
            r.mcConnDetail.showError("Could not reach the Aera login server." + ((detail.length > 0) ? ("\n" + detail) : ""));
            if (passwordui.visible)
            {
                passwordui.txtWarning.visible = true;
            }
        }

        public function onLoginComplete(event:Event):void
        {
            var _obj:Object = com.adobe.serialization.json.JSON.decode(event.target.data);
            if (_obj.login)
            {
                Game.objLogin = _obj.login;
                Game.objLogin.servers = _obj.servers;
                r.playerPollData = _obj.polldata;
            }
            else
            {
                Game.objLogin = _obj;
            }
            if (Game.objLogin.bSuccess == 1)
            {
                try
                {
                    Game.loginInfo.strUsername = Game.objLogin.unm.toLowerCase();
                }
                catch(e)
                {
                }
                r.mcConnDetail.hideConn();
                Game.loginInfo.strToken = Game.objLogin.sToken;
                r.sToken = Game.loginInfo.strToken;
                Game.strToken = Game.loginInfo.strToken;
                if (skipServers)
                {
                    directConnect();
                    skipServers = true;
                }
                else
                {
                    parent.removeChild(this);
                    r.csShowServers = true;
                    r.gotoAndPlay("Login");
                }
            }
            else
            {
                r.mcConnDetail.showError(Game.objLogin.sMsg);
            }
            r.resetsOnNewSession();
        }

        private function directConnect():*
        {
            var _local_1:String = mngr.displayAvts[pos].server;
            var _local_2:* = null;
            var _local_3:* = 0;
            while (_local_3 < Game.objLogin.servers.length)
            {
                if (Game.objLogin.servers[_local_3].sName.toLowerCase() == _local_1.toLowerCase())
                {
                    _local_2 = Game.objLogin.servers[_local_3];
                }
                _local_3++;
            }
            if (!_local_2)
            {
                r.MsgBox.notify("Server is missing!");
                return;
            }
            var _local_4:int = _local_2.iMax;
            if (Game.objLogin.iAccess >= 40)
            {
                _local_4 = (_local_4 + 10000);
            }
            else
            {
                if (Game.objLogin.iUpgDays >= 0)
                {
                    _local_4 = (_local_4 + 1000);
                }
            }
            if (_local_2.bOnline == 0)
            {
                r.MsgBox.notify("Server currently offline!");
            }
            else
            {
                if (_local_2.iCount >= _local_4)
                {
                    r.MsgBox.notify("Server is Full!");
                }
                else
                {
                    if (((_local_2.iChat > 0) && (Game.objLogin.bCCOnly == 1)))
                    {
                        r.MsgBox.notify("Account Restricted to Moglin Sage Server Only.");
                    }
                    else
                    {
                        if ((((_local_2.iChat > 0) && (Game.objLogin.iAge < 13)) && (Game.objLogin.iUpgDays < 0)))
                        {
                            r.MsgBox.notify("Ask your parent to upgrade your account in order to play on chat enabled servers.");
                        }
                        else
                        {
                            if (((_local_2.bUpg == 1) && (Game.objLogin.iUpgDays < 0)))
                            {
                                r.MsgBox.notify("This server is member only.");
                            }
                            else
                            {
                                if ((_local_2.iMax % 2) > 0)
                                {
                                    r.MsgBox.notify("This server is a testing server.");
                                }
                                else
                                {
                                    parent.removeChild(this);
                                    r.objServerInfo = _local_2;
                                    r.chatF.iChat = _local_2.iChat;
                                    r.connectTo(_local_2.sIP, _local_2.iPort);
                                }
                            }
                        }
                    }
                }
            }
        }

        internal function __setTab_btnLogin_Scene1_UI_0():*
        {
            btnLogin.tabIndex = 3;
        }


    }
}//package 

