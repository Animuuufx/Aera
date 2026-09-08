// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ServerList

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.geom.ColorTransform;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.net.URLRequestMethod;
    import com.adobe.serialization.json.JSON;
    import flash.net.navigateToURL;

    public class ServerList extends MovieClip 
    {

        public var uCount:MovieClip;
        public var l1:MovieClip;
        public var bg:MovieClip;
        public var l2:MovieClip;
        public var iList:MovieClip;
        public var txtServerSelect:TextField;
        public var legend:MovieClip;
        public var liveLink:MovieClip;
        private var objLogin:Object;
        private var rootClass:MovieClip;
        private var arrServers:Array;
        private var blackCT:ColorTransform = new ColorTransform();
        private var iCap:int = 0;
        private var mDown:Boolean = false;
        private var hRun:int = 0;
        private var dRun:int = 0;
        private var mbY:int = 0;
        private var mhY:int = 0;
        private var mbD:int = 0;
        private var ox:int = 0;
        private var oy:int = 0;
        private var mox:int = 0;
        private var moy:int = 0;
        private var scrTgt:MovieClip;
        private var whiteListA:Array = ["74.53.22.26", "74.53.7.201"];
        private var whiteListB:Array = ["74.53.7.201"];
        private var langMap:Object = {
            "xx":"Canned-Chat",
            "en":"English",
            "pt":"Portuguese",
            "ph":"Philippines",
            "it":"Global"
        };
        private var iTotal:int = 0;
        internal var tRefresh:Timer = new Timer(1000, 5);

        public function ServerList()
        {
            var itemClass:Class;
            var server:MovieClip;
            var n:int;
            super();
            addFrameScript(0, frame1, 1, frame2);
            visible = false;
            objLogin = Game.objLogin;
            rootClass = MovieClip(root);
            legend.fbWindow.btnFBID.visible = false;
            if (FacebookConnect.isLoggedIn)
            {
                legend.fbNoLink.visible = false;
                legend.fbWindow.visible = true;
                legend.fbWindow.fbImg.visible = true;
                legend.fbWindow.btnFBLogout.visible = true;
                try
                {
                    legend.fbWindow.txtFBName.text = FacebookConnect.Me.name;
                }
                catch(e)
                {
                }
            }
            else
            {
                legend.fbWindow.visible = false;
                legend.fbNoLink.visible = true;
                legend.fbWindow.addEventListener(MouseEvent.CLICK, onBackClick, false, 0, true);
            }
            txtServerSelect.text = (Game.loginInfo.strUsername + ", please select a server.");
            if (objLogin.iAccess >= 70)
            {
                arrServers = whiteList(objLogin.servers, []);
            }
            else
            {
                if (Game.bPTR)
                {
                    if (objLogin.iAccess >= 40)
                    {
                        arrServers = whiteList(objLogin.servers, whiteListA);
                    }
                    else
                    {
                        arrServers = whiteList(objLogin.servers, whiteListB);
                    }
                    liveLink.alpha = 100;
                }
                else
                {
                    arrServers = whiteList(objLogin.servers, []);
                }
            }

            rootClass.serialCmd.servers = objLogin.servers;
            blackCT.color = 0;
            var drawnItems:int;
            var i:* = 0;

            while (i < arrServers.length)
            {
                itemClass = (iList.iProto.constructor as Class);
                server = (iList.addChildAt(new (itemClass)(), 0) as MovieClip);
                server.ttStr = "";
                if ((i % 2) > 0)
                {
                    server.x = 286;
                }
                else
                {
                    server.x = 0;
                };
                server.y = (Math.floor((i / 2)) * 32);
                server.obj = arrServers[i];
                server.tName.ti.text = arrServers[i].sName;
                try
                {
                    server.mcPop.txtLang.text = langMap[arrServers[i].sLang];
                }
                catch(e)
                {
                    server.mcPop.txtLang.text = "English";
                };
                if (arrServers[i].bUpg == 1)
                {
                    server.mcPop.txtLang.text = "Member";
                };
                iTotal = (iTotal + int(arrServers[i].iCount));
                if (objLogin.iAccess >= 40)
                {
                    iCap = (parseInt(arrServers[i].iMax) + 10000);
                }
                else
                {
                    if (objLogin.iUpgDays >= 0)
                    {
                        iCap = (parseInt(arrServers[i].iMax) + 1000);
                    }
                    else
                    {
                        iCap = parseInt(arrServers[i].iMax);
                    };
                };
                arrServers[i].iMax = iCap;
                server.iconStandard.visible = false;
                server.iconSafe.visible = false;
                server.iconLegen.visible = false;
                server.iconChat.visible = true;
                server.iconChat.nullset.visible = false;
                if (arrServers[i].bUpg == 0)
                {
                    server.ttStr = (server.ttStr + "This is a free server. ");
                }
                else
                {
                    server.ttStr = (server.ttStr + "This is an upgrade-only server. ");
                    server.tName.ti.textColor = 16763955;
                };
                if (arrServers[i].iChat == 0)
                {
                    server.iconSafe.visible = true;
                    server.iconChat.nullset.visible = true;
                    server.ttStr = (server.ttStr + "Only Canned Chat enabled.");
                }
                else
                {
                    if (arrServers[i].iChat == 1)
                    {
                        server.iconChat.alpha = 0.5;
                        server.ttStr = (server.ttStr + "Chat is limited.");
                    }
                    else
                    {
                        server.ttStr = (server.ttStr + "Chat is enabled.");
                    };
                    if (arrServers[i].bUpg == 1)
                    {
                        server.iconLegen.visible = true;
                    }
                    else
                    {
                        server.iconStandard.visible = true;
                    };
                    server.iconChat.visible = true;
                };
                n = arrServers[i].iCount;
                server.mcPop.visible = true;
                server.iconFull.visible = false;
                if (n < iCap)
                {
                    server.mcPop.txtPopulation.text = n;
                }
                else
                {
                    server.mcPop.visible = false;
                    server.iconFull.visible = true;
                    server.ttStr = "Server is full.";
                };
                if (arrServers[i].bOnline == 1)
                {
                    if (langMap[rootClass.params.sLang] == null)
                    {
                        rootClass.params.sLang = "en";
                    };
                    server.bgOn.gotoAndStop("Online");
                    if (arrServers[i].sLang == "xx")
                    {
                        server.mcNonPreferred.visible = false;
                    }
                    else
                    {
                        if ((((arrServers[i].sLang == rootClass.params.sLang) || (arrServers[i].sLang == "it")) && (objLogin.iAge >= 13)))
                        {
                            server.mcNonPreferred.visible = false;
                        };
                    };
                    server.iconOffline.visible = false;
                }
                else
                {
                    server.bgOn.gotoAndStop("Offline");
                    server.iconOffline.visible = true;
                    server.iconStandard.visible = false;
                    server.iconSafe.visible = false;
                    server.iconLegen.visible = false;
                    server.iconChat.visible = false;
                    server.mcPop.visible = false;
                    server.tName.alpha = 0.8;
                    server.ttStr = "Server is temporarily offline.";
                };
                server.mouseChildren = false;
                server.addEventListener(MouseEvent.CLICK, onServerClick, false, 0, true);
                server.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
                server.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
                if ((((((arrServers[i].bOnline == 0) || (n >= iCap)) || ((arrServers[i].bUpg == 1) && (objLogin.iUpgDays < 0))) || (((arrServers[i].iChat > 0) && (objLogin.iAge < 13)) && (objLogin.iUpgDays < 0))) || ((arrServers[i].iChat > 0) && (objLogin.bCCOnly == 1))))
                {
                    server.buttonMode = true;
                }
                else
                {
                    server.mouseChildren = false;
                    server.buttonMode = true;
                };
                i++;
            }

//            while (i < arrServers.length)
//            {
//                itemClass = (iList.iProto.constructor as Class);
//                server = (iList.addChildAt(new (itemClass)(), 0) as MovieClip);
//                if (objLogin.iLevel >= arrServers[i].iLevel)
//                {
//                    server.ttStr = "";
//                    if ((drawnItems % 2) > 0)
//                    {
//                        server.x = 286;
//                    }
//                    else
//                    {
//                        server.x = 0;
//                    }
//                    server.y = (Math.floor((drawnItems / 2)) * 32);
//                    server.obj = arrServers[i];
//                    server.tName.ti.text = arrServers[i].sName;
//                    try
//                    {
//                        server.mcPop.txtLang.text = langMap[arrServers[i].sLang];
//                    }
//                    catch(e)
//                    {
//                        server.mcPop.txtLang.text = "English";
//                    }
//                    if (arrServers[i].bUpg == 1)
//                    {
//                        server.mcPop.txtLang.text = "Member";
//                    }
//                    iTotal = (iTotal + int(arrServers[i].iCount));
//                    if (objLogin.iAccess >= 40)
//                    {
//                        iCap = (parseInt(arrServers[i].iMax) + 10000);
//                    }
//                    else
//                    {
//                        if (objLogin.iUpgDays >= 0)
//                        {
//                            iCap = (parseInt(arrServers[i].iMax) + 1000);
//                        }
//                        else
//                        {
//                            iCap = parseInt(arrServers[i].iMax);
//                        }
//                    }
//                    arrServers[i].iMax = iCap;
//                    server.iconStandard.visible = false;
//                    server.iconSafe.visible = false;
//                    server.iconLegen.visible = false;
//                    server.iconChat.visible = true;
//                    server.iconChat.nullset.visible = false;
//                    server.iconTest.visible = false;
//                    if (arrServers[i].bUpg == 0)
//                    {
//                        server.ttStr = (server.ttStr + "This is a free server. ");
//                    }
//                    else
//                    {
//                        server.ttStr = (server.ttStr + "This is an upgrade-only server. ");
//                        server.tName.ti.textColor = 16763955;
//                    }
//                    if (arrServers[i].iChat == 0)
//                    {
//                        server.iconSafe.visible = true;
//                        server.iconChat.nullset.visible = true;
//                        server.ttStr = (server.ttStr + "Only Canned Chat enabled.");
//                    }
//                    else
//                    {
//                        if (arrServers[i].iChat == 1)
//                        {
//                            server.iconChat.alpha = 0.5;
//                            server.ttStr = (server.ttStr + "Chat is limited.");
//                        }
//                        else
//                        {
//                            server.ttStr = (server.ttStr + "Chat is enabled.");
//                        }
//                        if (arrServers[i].bUpg == 1)
//                        {
//                            server.iconLegen.visible = true;
//                        }
//                        else
//                        {
//                            server.iconStandard.visible = true;
//                        }
//                        server.iconChat.visible = true;
//                    }
//                    if (arrServers[i].sName == "Class Test Realm")
//                    {
//                        server.iconStandard.visible = false;
//                        server.iconTest.visible = true;
//                    }
//                    n = arrServers[i].iCount;
//                    server.mcPop.visible = true;
//                    server.iconFull.visible = false;
//                    if (n < iCap)
//                    {
//                        server.mcPop.txtPopulation.text = n;
//                    }
//                    else
//                    {
//                        server.mcPop.visible = false;
//                        server.iconFull.visible = true;
//                        server.ttStr = "Server is full.";
//                    }
//                    if (arrServers[i].bOnline == 1)
//                    {
//                        if (langMap[rootClass.params.sLang] == null)
//                        {
//                            rootClass.params.sLang = "en";
//                        }
//                        server.bgOn.gotoAndStop("Online");
//                        server.mcNonPreferred.visible = false;
//                        server.iconOffline.visible = false;
//                    }
//                    else
//                    {
//                        server.bgOn.gotoAndStop("Offline");
//                        server.iconOffline.visible = true;
//                        server.iconStandard.visible = false;
//                        server.iconSafe.visible = false;
//                        server.iconLegen.visible = false;
//                        server.iconChat.visible = false;
//                        server.iconTest.visible = false;
//                        server.mcPop.visible = false;
//                        server.tName.alpha = 0.8;
//                        server.ttStr = "Server is temporarily offline.";
//                    }
//                    server.mouseChildren = false;
//                    server.addEventListener(MouseEvent.CLICK, onServerClick, false, 0, true);
//                    server.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
//                    server.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
//                    if ((((((arrServers[i].bOnline == 0) || (n >= iCap)) || ((arrServers[i].bUpg == 1) && (objLogin.iUpgDays < 0))) || (((arrServers[i].iChat > 0) && (objLogin.iAge < 13)) && (objLogin.iUpgDays < 0))) || ((arrServers[i].iChat > 0) && (objLogin.bCCOnly == 1))))
//                    {
//                        server.buttonMode = true;
//                    }
//                    else
//                    {
//                        server.mouseChildren = false;
//                        server.buttonMode = true;
//                    }
//                    drawnItems = (drawnItems + 1);
//                }
//                i++;
//            }
            iList.iProto.visible = false;
            l2.y = ((iList.y + iList.height) + 10);
            legend.y = (l2.y + 8);
            var bgh:int = int(bg.height);
            bg.height = int(((legend.y + legend.height) + 7));
            bg.y = (bg.y + int(((bg.height - bgh) / 2)));
            var ts:String = "";
            if (iTotal > 0)
            {
                uCount.ti.htmlText = '<font color="#FFBB3E">';
                uCount.ti.htmlText = (uCount.ti.htmlText + rootClass.strNumWithCommas(iTotal));
                uCount.ti.htmlText = (uCount.ti.htmlText + "</font>");
                uCount.t2.x = (uCount.ti.textWidth + 7);
            }
            else
            {
                uCount.visible = false;
            }
            MovieClip(this).y = int((275 - (MovieClip(this).height / 2)));
            legend.btnRefresh.addEventListener(MouseEvent.CLICK, onRefreshClick, false, 0, true);
            legend.txtRefresh.mouseEnabled = false;
            tRefresh.addEventListener(TimerEvent.TIMER, onRefreshCooldown, false, 0, true);
            tRefresh.start();
            legend.btnBack.addEventListener(MouseEvent.CLICK, onBackClick, false, 0, true);
            legend.btnHelp.addEventListener(MouseEvent.CLICK, onHelpClick, false, 0, true);
            legend.btnManage.addEventListener(MouseEvent.CLICK, onManageClick, false, 0, true);
            legend.fbWindow.btnFBLogout.addEventListener(MouseEvent.CLICK, onFBLogoutClick, false, 0, true);
            legend.fbWindow.btnFBLogout.buttonMode = true;
            if (FacebookConnect.isLoggedIn)
            {
                try
                {
                    if (rootClass.FBApi.FBImage != null)
                    {
                        legend.fbImg.removeChildAt(0);
                        legend.fbWindow.fbImg.addChildAt(rootClass.FBApi.FBImage, 1);
                    }
                }
                catch(e)
                {
                }
            }
        }

        private function onRefreshCooldown(_arg_1:TimerEvent):void
        {
            legend.txtRefresh.text = ((tRefresh.currentCount > 4) ? "Refresh" : (("Refresh (" + (5 - tRefresh.currentCount)) + ")"));
            if (tRefresh.currentCount > 4)
            {
                tRefresh.removeEventListener(TimerEvent.TIMER, onRefreshClick);
            }
        }

        private function onRefreshClick(_arg_1:MouseEvent):*
        {
            var _local_5:URLVariables;
            if (tRefresh.running)
            {
                return;
            }
            rootClass.mcLogin.gotoAndStop("Init");
            var _local_2:URLLoader = new URLLoader();
            var _local_3:String = (((Game.serverGamePath + ((Game.objLogin.iAccess >= 24) ? "api/data/serversext" : "api/data/servers")) + "?v=") + Math.random());
            var _local_4:URLRequest = new URLRequest(_local_3);
            _local_2.addEventListener(Event.COMPLETE, onServerListComplete, false, 0, true);
            if (Game.objLogin.iAccess >= 24)
            {
                _local_5 = new URLVariables();
                _local_5.uid = Game.objLogin.userid;
                _local_5.token = Game.objLogin.sToken;
                _local_4.data = _local_5;
                _local_4.method = URLRequestMethod.POST;
            }
            else
            {
                _local_4.method = URLRequestMethod.GET;
            }
            _local_2.load(_local_4);
        }

        private function onServerListComplete(_arg_1:Event):void
        {
            if (_arg_1.target.data.indexOf("{notused}") == -1)
            {
                Game.objLogin.servers = com.adobe.serialization.json.JSON.decode(_arg_1.target.data);
            }
            rootClass.mcLogin.gotoAndStop("Servers");
        }

        private function onIDClick(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(("https://www.facebook.com/profile.php?id=" + objLogin.FBID)), "_blank");
        }

        private function onFBLogoutClick(_arg_1:MouseEvent):void
        {
            FacebookConnect.Logout();
            MovieClip(parent).gotoAndPlay("Login");
        }

        private function onHelpClick(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://www.aq.com/help/"), "_blank");
        }

        private function onManageClick(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://account.aq.com/"), "_blank");
        }

        private function onBackClick(_arg_1:MouseEvent):*
        {
            MovieClip(parent).gotoAndPlay("Login");
        }

        private function onServerClick(_arg_1:MouseEvent):*
        {
            var _local_2:ModalMC;
            var _local_3:Object;
            var _local_4:*;
            rootClass.showTracking("4");
            if (!rootClass.serialCmdMode)
            {
                _local_4 = MovieClip(_arg_1.currentTarget);
                if (_local_4.obj.bOnline == 0)
                {
                    rootClass.MsgBox.notify("Server currently offline!");
                }
                else
                {
                    if (_local_4.obj.iCount >= _local_4.obj.iMax)
                    {
                        rootClass.MsgBox.notify("Server is Full!");
                    }
                    else
                    {
                        if (((_local_4.obj.iChat > 0) && (objLogin.bCCOnly == 1)))
                        {
                            rootClass.MsgBox.notify("Account Restricted to Moglin Sage Server Only.");
                        }
                        else
                        {
                            if ((((_local_4.obj.iChat > 0) && (objLogin.iAge < 13)) && (objLogin.iUpgDays < 0)))
                            {
                                rootClass.MsgBox.notify("Ask your parent to upgrade your account in order to play on chat enabled servers.");
                            }
                            else
                            {
                                if (((_local_4.obj.bUpg == 1) && (objLogin.iUpgDays < 0)))
                                {
                                    _local_2 = new ModalMC();
                                    _local_3 = {};
                                    _local_3.strBody = "Member Server! Do you want to upgrade your account to access this premium server now?";
                                    _local_3.params = {};
                                    _local_3.callback = onModalClickUpgrade;
                                    _local_3.glow = "white,medium";
                                    _local_3.btns = "dual";
                                    rootClass.mcLogin.ModalStack.addChild(_local_2);
                                    _local_2.init(_local_3);
                                }
                                else
                                {
                                    if ((_local_4.obj.iMax % 2) > 0)
                                    {
                                        _local_2 = new ModalMC();
                                        _local_3 = {};
                                        _local_3.strBody = "Testing Server! Do you want to switch to the testing game client?";
                                        _local_3.params = {};
                                        _local_3.callback = onModalClickTest;
                                        _local_3.glow = "white,medium";
                                        _local_3.btns = "dual";
                                        rootClass.mcLogin.ModalStack.addChild(_local_2);
                                        _local_2.init(_local_3);
                                    }
                                    else
                                    {
                                        if (((_local_4.obj.iLevel > 0) && (objLogin.iEmailStatus <= 2)))
                                        {
                                            _local_2 = new ModalMC();
                                            _local_3 = {};
                                            _local_3.strBody = "This server requires a confirmed email address.";
                                            _local_3.params = {};
                                            _local_3.glow = "red,medium";
                                            _local_3.btns = "mono";
                                            rootClass.mcLogin.ModalStack.addChild(_local_2);
                                            _local_2.init(_local_3);
                                        }
                                        else
                                        {
                                            rootClass.objServerInfo = _local_4.obj;
                                            rootClass.chatF.iChat = _local_4.obj.iChat;
                                            fClose();
                                            rootClass.connectTo(_local_4.obj.sIP, _local_4.obj.iPort);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private function onMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            if (((_local_2.obj.bOnline > 0) && (!(_local_2.frame.currentLabel == "in"))))
            {
                _local_2.frame.gotoAndPlay("in");
            }
        }

        private function onMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            if (((_local_2.obj.bOnline > 0) && (_local_2.frame.currentLabel == "in")))
            {
                _local_2.frame.gotoAndPlay("out");
            }
        }

        private function onModalClickUpgrade(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                navigateToURL(new URLRequest("https://aq.com/order-now/direct"), "_blank");
            }
        }

        private function onModalClickPTR(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                fClose();
            }
        }

        private function onModalClickTest(_arg_1:Object):void
        {
        }

        private function onLiveLinkClick(_arg_1:MouseEvent):*
        {
            fClose();
        }

        public function fClose():void
        {
            killModals();
        }

        private function killModals():void
        {
            var _local_2:MovieClip;
            var _local_1:MovieClip = rootClass.mcLogin.ModalStack;
            var _local_3:int;
            while (_local_3 < _local_1.numChildren)
            {
                _local_2 = (_local_1.getChildAt(_local_3) as MovieClip);
                if (("fClose" in _local_2))
                {
                    _local_2.fClose();
                }
                _local_3++;
            }
        }

        public function getServerTabByIP(_arg_1:String):MovieClip
        {
            var _local_2:* = numChildren;
            var _local_3:* = null;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_3 = getChildAt(_local_4);
                if ((((_local_3.constructor.toString().indexOf("MCServerItem") > -1) && (!(MovieClip(_local_3).obj == null))) && (_local_3.obj.sIP == _arg_1)))
                {
                    return (MovieClip(_local_3));
                }
                _local_4++;
            }
            return (null);
        }

        private function whiteList(_arg_1:Array, _arg_2:Array, _arg_3:Boolean=false):Array
        {
            var _local_5:Boolean;
            var _local_6:int;
            var _local_4:Array = [];
            if (_arg_1.length > 0)
            {
                _local_6 = 0;
                while (_local_6 < _arg_1.length)
                {
                    _local_5 = false;
                    if (((_arg_2.length == 0) || (_arg_2.indexOf(_arg_1[_local_6].sIP) > -1)))
                    {
                        _local_5 = true;
                        if (((_arg_3) && (rootClass.objLogin.iUpgDays < 1)))
                        {
                            _local_5 = false;
                        }
                    }
                    if (_local_5)
                    {
                        _local_4.push(_arg_1[_local_6]);
                    }
                    _local_6++;
                }
            }
            return (_local_4);
        }

        private function ccWhiteList(_arg_1:Array, _arg_2:String):Array
        {
            if (_arg_2 == "")
            {
                return (_arg_1);
            }
            var _local_3:Array = new Array();
            var _local_4:uint;
            while (_local_4 < _arg_1.length)
            {
                if ((((_arg_1[_local_4].sLang == _arg_2) || (_arg_1[_local_4].bUpg == 1)) || (_arg_1[_local_4].sLang == "it")))
                {
                    _local_3.push(_arg_1[_local_4]);
                }
                else
                {
                    iTotal = (iTotal + int(arrServers[_local_4].iCount));
                }
                _local_4++;
            }
            return (_local_3);
        }

        private function sortServers(_arg_1:Array, _arg_2:String):Array
        {
            var _local_3:Object = {
                "upg":[],
                "it":[]
            };
            _local_3[_arg_2] = [];
            var _local_4:uint;
            while (_local_4 < _arg_1.length)
            {
                switch (_arg_1[_local_4].sLang)
                {
                    case "ph":
                    case "pt":
                    case "it":
                        _local_3[_arg_1[_local_4].sLang].push(_arg_1[_local_4]);
                        break;
                    default:
                        _local_3["upg"].push(_arg_1[_local_4]);
                }
                _local_4++;
            }
            var _local_5:Array = new Array();
            _local_5 = pushServers(_local_5, "it", _local_3);
            _local_5 = pushServers(_local_5, "upg", _local_3);
            _local_5 = pushServers(_local_5, _arg_2, _local_3);
            return (_local_5);
        }

        private function pushServers(_arg_1:Array, _arg_2:String, _arg_3:Object):Array
        {
            var _local_4:uint;
            while (_local_4 < _arg_3[_arg_2].length)
            {
                _arg_1.push(_arg_3[_arg_2][_local_4]);
                _local_4++;
            }
            return (_arg_1);
        }

        internal function frame1():*
        {
            visible = false;
        }

        internal function frame2():*
        {
            visible = true;
            stop();
        }


    }
}//package 

