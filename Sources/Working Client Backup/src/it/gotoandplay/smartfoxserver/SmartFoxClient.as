// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.SmartFoxClient

package it.gotoandplay.smartfoxserver
{
    import flash.events.EventDispatcher;
    import flash.system.Capabilities;
    import it.gotoandplay.smartfoxserver.handlers.SysHandler;
    import it.gotoandplay.smartfoxserver.handlers.ExtHandler;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import it.gotoandplay.smartfoxserver.http.HttpConnection;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import it.gotoandplay.smartfoxserver.http.HttpEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import it.gotoandplay.smartfoxserver.data.Room;
    import flash.utils.getTimer;
    import it.gotoandplay.smartfoxserver.util.Entities;
    import it.gotoandplay.smartfoxserver.util.ObjectSerializer;
    import com.adobe.serialization.json.JSON;
    import it.gotoandplay.smartfoxserver.data.User;
    import flash.net.FileReference;
    import it.gotoandplay.smartfoxserver.handlers.IMessageHandler;
    import flash.utils.setTimeout;
    import flash.events.ErrorEvent;

    public class SmartFoxClient extends EventDispatcher 
    {

        private static const EOM:int = 0;
        private static const MSG_XML:String = "<";
        private static const MSG_JSON:String = "{";
        private static var MSG_STR:String = "%";
        private static var MIN_POLL_SPEED:Number = 0;
        private static var DEFAULT_POLL_SPEED:Number = 750;
        private static var MAX_POLL_SPEED:Number = 10000;
        private static var HTTP_POLL_REQUEST:String = "poll";
        public static const MODMSG_TO_USER:String = "u";
        public static const MODMSG_TO_ROOM:String = "r";
        public static const MODMSG_TO_ZONE:String = "z";
        public static const XTMSG_TYPE_XML:String = "xml";
        public static const XTMSG_TYPE_STR:String = "str";
        public static const XTMSG_TYPE_JSON:String = "json";
        public static const CONNECTION_MODE_DISCONNECTED:String = "disconnected";
        public static const CONNECTION_MODE_SOCKET:String = "socket";
        public static const CONNECTION_MODE_HTTP:String = "http";

        public var sfsOS:String = Capabilities.os.toLowerCase();
        public var onLinux:Boolean = ((sfsOS.indexOf("linux") > -1) ? true : false);
        private var roomList:Array;
        private var connected:Boolean;
        private var benchStartTime:int;
        private var sysHandler:SysHandler;
        private var extHandler:ExtHandler;
        private var majVersion:Number;
        private var minVersion:Number;
        private var subVersion:Number;
        private var messageHandlers:Array;
        private var socketConnection:Socket;
        private var byteBuffer:ByteArray;
        private var autoConnectOnConfigSuccess:Boolean = false;
        public var ipAddress:String;
        public var port:int = 9339;
        public var defaultZone:String;
        private var isHttpMode:Boolean = false;
        private var _httpPollSpeed:int = DEFAULT_POLL_SPEED;
        private var httpConnection:HttpConnection;
        public var blueBoxIpAddress:String;
        public var blueBoxPort:Number = 0;
        public var smartConnect:Boolean = true;
        public var buddyList:Array;
        public var myBuddyVars:Array;
        public var debug:Boolean;
        public var myUserId:int;
        public var myUserName:String;
        public var playerId:int;
        public var amIModerator:Boolean;
        public var activeRoomId:int;
        public var changingRoom:Boolean;
        public var httpPort:int = 8080;
        public var properties:Object = null;

        public function SmartFoxClient(_arg_1:Boolean=false)
        {
            this.majVersion = 1;
            this.minVersion = 5;
            this.subVersion = 7;
            this.activeRoomId = -1;
            this.debug = _arg_1;
            this.messageHandlers = [];
            setupMessageHandlers();
            socketConnection = new Socket();
            socketConnection.addEventListener(Event.CONNECT, handleSocketConnection);
            socketConnection.addEventListener(Event.CLOSE, handleSocketDisconnection);
            socketConnection.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
            socketConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
            socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
            socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
            httpConnection = new HttpConnection();
            httpConnection.addEventListener(HttpEvent.onHttpConnect, handleHttpConnect);
            httpConnection.addEventListener(HttpEvent.onHttpClose, handleHttpClose);
            httpConnection.addEventListener(HttpEvent.onHttpData, handleHttpData);
            httpConnection.addEventListener(HttpEvent.onHttpError, handleHttpError);
            byteBuffer = new ByteArray();
        }

        public function get rawProtocolSeparator():String
        {
            return (MSG_STR);
        }

        public function set rawProtocolSeparator(_arg_1:String):void
        {
            if (((!(_arg_1 == "<")) && (!(_arg_1 == "{"))))
            {
                MSG_STR = _arg_1;
            };
        }

        public function get isConnected():Boolean
        {
            return (this.connected);
        }

        public function set isConnected(_arg_1:Boolean):void
        {
            this.connected = _arg_1;
        }

        public function get httpPollSpeed():int
        {
            return (this._httpPollSpeed);
        }

        public function set httpPollSpeed(_arg_1:int):void
        {
            if (((_arg_1 >= 0) && (_arg_1 <= 10000)))
            {
                this._httpPollSpeed = _arg_1;
            };
        }

        public function loadConfig(_arg_1:String="config.xml", _arg_2:Boolean=true):void
        {
            this.autoConnectOnConfigSuccess = _arg_2;
            var _local_3:URLLoader = new URLLoader();
            _local_3.addEventListener(Event.COMPLETE, onConfigLoadSuccess);
            _local_3.addEventListener(IOErrorEvent.IO_ERROR, onConfigLoadFailure);
            _local_3.load(new URLRequest(_arg_1));
        }

        public function getConnectionMode():String
        {
            var _local_1:String = CONNECTION_MODE_DISCONNECTED;
            if (this.isConnected)
            {
                if (this.isHttpMode)
                {
                    _local_1 = CONNECTION_MODE_HTTP;
                }
                else
                {
                    _local_1 = CONNECTION_MODE_SOCKET;
                };
            };
            return (_local_1);
        }

        public function connect(_arg_1:String, _arg_2:int=9339):void
        {
            if (!connected)
            {
                initialize();
                this.ipAddress = _arg_1;
                this.port = _arg_2;
                socketConnection.connect(_arg_1, _arg_2);
            }
            else
            {
                debugMessage("*** ALREADY CONNECTED ***");
            };
        }

        public function disconnect():void
        {
            connected = false;
            if (!isHttpMode)
            {
                socketConnection.close();
            }
            else
            {
                httpConnection.close();
            };
            sysHandler.dispatchDisconnection();
        }

        public function addBuddy(_arg_1:String):void
        {
            var _local_2:String;
            if (((!(_arg_1 == myUserName)) && (!(checkBuddyDuplicates(_arg_1)))))
            {
                _local_2 = (("<n>" + _arg_1) + "</n>");
                send({"t":"sys"}, "addB", -1, _local_2);
            };
        }

        public function autoJoin():void
        {
            if (!checkRoomList())
            {
                return;
            };
            var _local_1:Object = {"t":"sys"};
            this.send(_local_1, "autoJoin", ((this.activeRoomId) ? this.activeRoomId : -1), "");
        }

        public function clearBuddyList():void
        {
            buddyList = [];
            send({"t":"sys"}, "clearB", -1, "");
            var _local_1:Object = {};
            _local_1.list = buddyList;
            var _local_2:SFSEvent = new SFSEvent(SFSEvent.onBuddyList, _local_1);
            dispatchEvent(_local_2);
        }

        public function createRoom(_arg_1:Object, _arg_2:int=-1):void
        {
            var _local_10:String;
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_2 == -1)
            {
                _arg_2 = activeRoomId;
            };
            var _local_3:Object = {"t":"sys"};
            var _local_4:String = ((_arg_1.isGame) ? "1" : "0");
            var _local_5:* = "1";
            var _local_6:String = ((_arg_1.maxUsers == null) ? "0" : String(_arg_1.maxUsers));
            var _local_7:String = ((_arg_1.maxSpectators == null) ? "0" : String(_arg_1.maxSpectators));
            var _local_8:String = ((_arg_1.joinAsSpectator) ? "1" : "0");
            if (((_arg_1.isGame) && (!(_arg_1.exitCurrentRoom == null))))
            {
                _local_5 = ((_arg_1.exitCurrentRoom) ? "1" : "0");
            };
            var _local_9:* = (((((((("<room tmp='1' gam='" + _local_4) + "' spec='") + _local_7) + "' exit='") + _local_5) + "' jas='") + _local_8) + "'>");
            _local_9 = (_local_9 + (("<name><![CDATA[" + ((_arg_1.name == null) ? "" : _arg_1.name)) + "]]></name>"));
            _local_9 = (_local_9 + (("<pwd><![CDATA[" + ((_arg_1.password == null) ? "" : _arg_1.password)) + "]]></pwd>"));
            _local_9 = (_local_9 + (("<max>" + _local_6) + "</max>"));
            if (_arg_1.uCount != null)
            {
                _local_9 = (_local_9 + (("<uCnt>" + ((_arg_1.uCount) ? "1" : "0")) + "</uCnt>"));
            };
            if (_arg_1.extension != null)
            {
                _local_9 = (_local_9 + ("<xt n='" + _arg_1.extension.name));
                _local_9 = (_local_9 + (("' s='" + _arg_1.extension.script) + "' />"));
            };
            if (_arg_1.vars == null)
            {
                _local_9 = (_local_9 + "<vars></vars>");
            }
            else
            {
                _local_9 = (_local_9 + "<vars>");
                for (_local_10 in _arg_1.vars)
                {
                    _local_9 = (_local_9 + getXmlRoomVariable(_arg_1.vars[_local_10]));
                };
                _local_9 = (_local_9 + "</vars>");
            };
            _local_9 = (_local_9 + "</room>");
            send(_local_3, "createRoom", _arg_2, _local_9);
        }

        public function getAllRooms():Array
        {
            return (roomList);
        }

        public function getBuddyByName(_arg_1:String):Object
        {
            var _local_2:Object;
            for each (_local_2 in buddyList)
            {
                if (_local_2.name == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function getBuddyById(_arg_1:int):Object
        {
            var _local_2:Object;
            for each (_local_2 in buddyList)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function getBuddyRoom(_arg_1:Object):void
        {
            if (_arg_1.id != -1)
            {
                send({"t":"sys"}, "roomB", -1, (("<b id='" + _arg_1.id) + "' />"));
            };
        }

        public function getRoom(_arg_1:int):Room
        {
            if (!checkRoomList())
            {
                return (null);
            };
            return (roomList[_arg_1]);
        }

        public function getRoomByName(_arg_1:String):Room
        {
            var _local_3:Room;
            if (!checkRoomList())
            {
                return (null);
            };
            var _local_2:Room;
            for each (_local_3 in roomList)
            {
                if (_local_3.getName() == _arg_1)
                {
                    _local_2 = _local_3;
                    break;
                };
            };
            return (_local_2);
        }

        public function getRoomList():void
        {
            var _local_1:Object = {"t":"sys"};
            send(_local_1, "getRmList", activeRoomId, "");
        }

        public function getActiveRoom():Room
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return (null);
            };
            return (roomList[activeRoomId]);
        }

        public function getRandomKey():void
        {
            send({"t":"sys"}, "rndK", -1, "");
        }

        public function getUploadPath():String
        {
            return (((("https://" + this.ipAddress) + ":") + this.httpPort) + "/default/uploads/");
        }

        public function getVersion():String
        {
            return ((((this.majVersion + ".") + this.minVersion) + ".") + this.subVersion);
        }

        public function joinRoom(_arg_1:*, _arg_2:String="", _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:int=-1):void
        {
            var _local_8:Room;
            var _local_9:Object;
            var _local_10:String;
            var _local_11:int;
            var _local_12:String;
            if (!checkRoomList())
            {
                return;
            };
            var _local_6:int = -1;
            var _local_7:int = ((_arg_3) ? 1 : 0);
            if (!this.changingRoom)
            {
                if (typeof(_arg_1) == "number")
                {
                    _local_6 = int(_arg_1);
                }
                else
                {
                    if (typeof(_arg_1) == "string")
                    {
                        for each (_local_8 in roomList)
                        {
                            if (_local_8.getName() == _arg_1)
                            {
                                _local_6 = _local_8.getId();
                                break;
                            };
                        };
                    };
                };
                if (_local_6 != -1)
                {
                    _local_9 = {"t":"sys"};
                    _local_10 = ((_arg_4) ? "0" : "1");
                    _local_11 = ((_arg_5 > -1) ? _arg_5 : activeRoomId);
                    if (activeRoomId == -1)
                    {
                        _local_10 = "0";
                        _local_11 = -1;
                    };
                    _local_12 = (((((((((("<room id='" + _local_6) + "' pwd='") + _arg_2) + "' spec='") + _local_7) + "' leave='") + _local_10) + "' old='") + _local_11) + "' />");
                    send(_local_9, "joinRoom", activeRoomId, _local_12);
                    changingRoom = true;
                }
                else
                {
                    debugMessage("SmartFoxError: requested room to join does not exist!");
                };
            };
        }

        public function leaveRoom(_arg_1:int):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            var _local_2:Object = {"t":"sys"};
            var _local_3:* = (("<rm id='" + _arg_1) + "' />");
            send(_local_2, "leaveRoom", _arg_1, _local_3);
        }

        public function loadBuddyList():void
        {
            send({"t":"sys"}, "loadB", -1, "");
        }

        public function login(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            var _local_4:Object = {"t":"sys"};
            var _local_5:* = (((((("<login z='" + _arg_1) + "'><nick><![CDATA[") + _arg_2) + "]]></nick><pword><![CDATA[") + _arg_3) + "]]></pword></login>");
            send(_local_4, "login", 0, _local_5);
        }

        public function logout():void
        {
            var _local_1:Object = {"t":"sys"};
            send(_local_1, "logout", -1, "");
        }

        public function removeBuddy(_arg_1:String):void
        {
            var _local_3:Object;
            var _local_4:String;
            var _local_5:Object;
            var _local_6:String;
            var _local_7:Object;
            var _local_8:SFSEvent;
            var _local_2:Boolean;
            for (_local_4 in buddyList)
            {
                _local_3 = buddyList[_local_4];
                if (_local_3.name == _arg_1)
                {
                    delete buddyList[_local_4];
                    _local_2 = true;
                    break;
                };
            };
            if (_local_2)
            {
                _local_5 = {"t":"sys"};
                _local_6 = (("<n>" + _arg_1) + "</n>");
                send(_local_5, "remB", -1, _local_6);
                _local_7 = {};
                _local_7.list = buddyList;
                _local_8 = new SFSEvent(SFSEvent.onBuddyList, _local_7);
                dispatchEvent(_local_8);
            };
        }

        public function roundTripBench():void
        {
            this.benchStartTime = getTimer();
            send({"t":"sys"}, "roundTrip", activeRoomId, "");
        }

        public function sendBuddyPermissionResponse(_arg_1:Boolean, _arg_2:String):void
        {
            var _local_3:Object = {"t":"sys"};
            var _local_4:* = (((("<n res='" + ((_arg_1) ? "g" : "r")) + "'>") + _arg_2) + "</n>");
            send(_local_3, "bPrm", -1, _local_4);
        }

        public function sendPublicMessage(_arg_1:String, _arg_2:int=-1):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_2 == -1)
            {
                _arg_2 = activeRoomId;
            };
            var _local_3:Object = {"t":"sys"};
            var _local_4:* = (("<txt><![CDATA[" + Entities.encodeEntities(_arg_1)) + "]]></txt>");
            send(_local_3, "pubMsg", _arg_2, _local_4);
        }

        public function sendPrivateMessage(_arg_1:String, _arg_2:int, _arg_3:int=-1):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_3 == -1)
            {
                _arg_3 = activeRoomId;
            };
            var _local_4:Object = {"t":"sys"};
            var _local_5:* = (((("<txt rcp='" + _arg_2) + "'><![CDATA[") + Entities.encodeEntities(_arg_1)) + "]]></txt>");
            send(_local_4, "prvMsg", _arg_3, _local_5);
        }

        public function sendModeratorMessage(_arg_1:String, _arg_2:String, _arg_3:int=-1):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            var _local_4:Object = {"t":"sys"};
            var _local_5:* = (((((("<txt t='" + _arg_2) + "' id='") + _arg_3) + "'><![CDATA[") + Entities.encodeEntities(_arg_1)) + "]]></txt>");
            send(_local_4, "modMsg", activeRoomId, _local_5);
        }

        public function sendObject(_arg_1:Object, _arg_2:int=-1):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_2 == -1)
            {
                _arg_2 = activeRoomId;
            };
            var _local_3:* = (("<![CDATA[" + ObjectSerializer.getInstance().serialize(_arg_1)) + "]]>");
            var _local_4:Object = {"t":"sys"};
            send(_local_4, "asObj", _arg_2, _local_3);
        }

        public function sendObjectToGroup(_arg_1:Object, _arg_2:Array, _arg_3:int=-1):void
        {
            var _local_5:String;
            var _local_6:Object;
            var _local_7:String;
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_3 == -1)
            {
                _arg_3 = activeRoomId;
            };
            var _local_4:* = "";
            for (_local_5 in _arg_2)
            {
                if (!isNaN(_arg_2[_local_5]))
                {
                    _local_4 = (_local_4 + (_arg_2[_local_5] + ","));
                };
            };
            _local_4 = _local_4.substr(0, (_local_4.length - 1));
            _arg_1._$$_ = _local_4;
            _local_6 = {"t":"sys"};
            _local_7 = (("<![CDATA[" + ObjectSerializer.getInstance().serialize(_arg_1)) + "]]>");
            send(_local_6, "asObjG", _arg_3, _local_7);
        }

        public function sendXtMessage(_arg_1:String, _arg_2:String, _arg_3:*, _arg_4:String="xml", _arg_5:int=-1):void
        {
            var _local_6:Object;
            var _local_7:Object;
            var _local_8:String;
            var _local_9:String;
            var _local_10:Number;
            var _local_11:Object;
            var _local_12:Object;
            var _local_13:String;
            if (!this.isConnected)
            {
                return;
            };
            if (!checkRoomList())
            {
                return;
            };
            if (_arg_5 == -1)
            {
                _arg_5 = activeRoomId;
            };
            if (_arg_4 == XTMSG_TYPE_XML)
            {
                _local_6 = {"t":"xt"};
                _local_7 = {
                    "name":_arg_1,
                    "cmd":_arg_2,
                    "param":_arg_3
                };
                _local_8 = (("<![CDATA[" + ObjectSerializer.getInstance().serialize(_local_7)) + "]]>");
                send(_local_6, "xtReq", _arg_5, _local_8);
            }
            else
            {
                if (_arg_4 == XTMSG_TYPE_STR)
                {
                    _local_9 = ((((((((MSG_STR + "xt") + MSG_STR) + _arg_1) + MSG_STR) + _arg_2) + MSG_STR) + _arg_5) + MSG_STR);
                    _local_10 = 0;
                    while (_local_10 < _arg_3.length)
                    {
                        _local_9 = (_local_9 + (_arg_3[_local_10].toString() + MSG_STR));
                        _local_10++;
                    };
                    sendString(_local_9);
                }
                else
                {
                    if (_arg_4 == XTMSG_TYPE_JSON)
                    {
                        _local_11 = {};
                        _local_11.x = _arg_1;
                        _local_11.c = _arg_2;
                        _local_11.r = _arg_5;
                        _local_11.p = _arg_3;
                        _local_12 = {};
                        _local_12.t = "xt";
                        _local_12.b = _local_11;
                        _local_13 = com.adobe.serialization.json.JSON.encode(_local_12);
                        sendJson(_local_13);
                    };
                };
            };
        }

        public function setBuddyBlockStatus(_arg_1:String, _arg_2:Boolean):void
        {
            var _local_4:String;
            var _local_5:Object;
            var _local_6:SFSEvent;
            var _local_3:Object = getBuddyByName(_arg_1);
            if (_local_3 != null)
            {
                if (_local_3.isBlocked != _arg_2)
                {
                    _local_3.isBlocked = _arg_2;
                    _local_4 = (((("<n x='" + ((_arg_2) ? "1" : "0")) + "'>") + _arg_1) + "</n>");
                    send({"t":"sys"}, "setB", -1, _local_4);
                    _local_5 = {};
                    _local_5.buddy = _local_3;
                    _local_6 = new SFSEvent(SFSEvent.onBuddyListUpdate, _local_5);
                    dispatchEvent(_local_6);
                };
            };
        }

        public function setBuddyVariables(_arg_1:Array):void
        {
            var _local_4:String;
            var _local_5:String;
            var _local_2:Object = {"t":"sys"};
            var _local_3:* = "<vars>";
            for (_local_4 in _arg_1)
            {
                _local_5 = _arg_1[_local_4];
                if (myBuddyVars[_local_4] != _local_5)
                {
                    myBuddyVars[_local_4] = _local_5;
                    _local_3 = (_local_3 + (((("<var n='" + _local_4) + "'><![CDATA[") + _local_5) + "]]></var>"));
                };
            };
            _local_3 = (_local_3 + "</vars>");
            this.send(_local_2, "setBvars", -1, _local_3);
        }

        public function setRoomVariables(_arg_1:Array, _arg_2:int=-1, _arg_3:Boolean=true):void
        {
            var _local_5:String;
            var _local_6:Object;
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_2 == -1)
            {
                _arg_2 = activeRoomId;
            };
            var _local_4:Object = {"t":"sys"};
            if (_arg_3)
            {
                _local_5 = "<vars>";
            }
            else
            {
                _local_5 = "<vars so='0'>";
            };
            for each (_local_6 in _arg_1)
            {
                _local_5 = (_local_5 + getXmlRoomVariable(_local_6));
            };
            _local_5 = (_local_5 + "</vars>");
            send(_local_4, "setRvars", _arg_2, _local_5);
        }

        public function setUserVariables(_arg_1:Object, _arg_2:int=-1):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_2 == -1)
            {
                _arg_2 = activeRoomId;
            };
            var _local_3:Object = {"t":"sys"};
            var _local_4:Room = getActiveRoom();
            var _local_5:User = _local_4.getUser(myUserId);
            _local_5.setVariables(_arg_1);
            var _local_6:String = getXmlUserVariable(_arg_1);
            send(_local_3, "setUvars", _arg_2, _local_6);
        }

        public function switchSpectator(_arg_1:int=-1):void
        {
            if (((!(checkRoomList())) || (!(checkJoin()))))
            {
                return;
            };
            if (_arg_1 == -1)
            {
                _arg_1 = activeRoomId;
            };
            send({"t":"sys"}, "swSpec", _arg_1, "");
        }

        public function uploadFile(_arg_1:FileReference, _arg_2:int=-1, _arg_3:String="", _arg_4:int=-1):void
        {
            if (_arg_2 == -1)
            {
                _arg_2 = this.myUserId;
            };
            if (_arg_3 == "")
            {
                _arg_3 = this.myUserName;
            };
            if (_arg_4 == -1)
            {
                _arg_4 = this.httpPort;
            };
            _arg_1.upload(new URLRequest(((((((("https://" + this.ipAddress) + ":") + _arg_4) + "/default/Upload.py?id=") + _arg_2) + "&nick=") + _arg_3)));
            debugMessage(((((((("[UPLOAD]: https://" + this.ipAddress) + ":") + _arg_4) + "/default/Upload.py?id=") + _arg_2) + "&nick=") + _arg_3));
        }

        public function __logout():void
        {
            initialize(true);
        }

        public function sendString(_arg_1:String):void
        {
            debugMessage((("[Sending - STR]: " + _arg_1) + "\n"));
            if (isHttpMode)
            {
                httpConnection.send(_arg_1);
            }
            else
            {
                writeToSocket(_arg_1);
            };
        }

        public function sendJson(_arg_1:String):void
        {
            debugMessage((("[Sending - JSON]: " + _arg_1) + "\n"));
            if (isHttpMode)
            {
                httpConnection.send(_arg_1);
            }
            else
            {
                writeToSocket(_arg_1);
            };
        }

        public function getBenchStartTime():int
        {
            return (this.benchStartTime);
        }

        public function clearRoomList():void
        {
            this.roomList = [];
        }

        private function initialize(_arg_1:Boolean=false):void
        {
            this.changingRoom = false;
            this.amIModerator = false;
            this.playerId = -1;
            this.activeRoomId = -1;
            this.myUserId = -1;
            this.myUserName = "";
            this.roomList = [];
            this.buddyList = [];
            this.myBuddyVars = [];
            if (!_arg_1)
            {
                this.connected = false;
                this.isHttpMode = false;
            };
        }

        private function onConfigLoadSuccess(_arg_1:Event):void
        {
            var _local_4:SFSEvent;
            var _local_2:URLLoader = (_arg_1.target as URLLoader);
            var _local_3:XML = new XML(_local_2.data);
            this.ipAddress = (this.blueBoxIpAddress = _local_3.ip);
            this.port = int(_local_3.port);
            this.defaultZone = _local_3.zone;
            if (_local_3.blueBoxIpAddress != undefined)
            {
                this.blueBoxIpAddress = _local_3.blueBoxIpAddress;
            };
            if (_local_3.blueBoxPort != undefined)
            {
                this.blueBoxPort = _local_3.blueBoxPort;
            };
            if (_local_3.debug != undefined)
            {
                this.debug = ((_local_3.debug.toLowerCase() == "true") ? true : false);
            };
            if (_local_3.smartConnect != undefined)
            {
                this.smartConnect = ((_local_3.smartConnect.toLowerCase() == "true") ? true : false);
            };
            if (_local_3.httpPort != undefined)
            {
                this.httpPort = int(_local_3.httpPort);
            };
            if (_local_3.httpPollSpeed != undefined)
            {
                this.httpPollSpeed = int(_local_3.httpPollSpeed);
            };
            if (_local_3.rawProtocolSeparator != undefined)
            {
                rawProtocolSeparator = _local_3.rawProtocolSeparator;
            };
            if (autoConnectOnConfigSuccess)
            {
                this.connect(ipAddress, port);
            }
            else
            {
                _local_4 = new SFSEvent(SFSEvent.onConfigLoadSuccess, {});
                dispatchEvent(_local_4);
            };
        }

        private function onConfigLoadFailure(_arg_1:IOErrorEvent):void
        {
            var _local_2:Object = {"message":_arg_1.text};
            var _local_3:SFSEvent = new SFSEvent(SFSEvent.onConfigLoadFailure, _local_2);
            dispatchEvent(_local_3);
        }

        private function setupMessageHandlers():void
        {
            sysHandler = new SysHandler(this);
            extHandler = new ExtHandler(this);
            addMessageHandler("sys", sysHandler);
            addMessageHandler("xt", extHandler);
        }

        private function addMessageHandler(_arg_1:String, _arg_2:IMessageHandler):void
        {
            if (this.messageHandlers[_arg_1] == null)
            {
                this.messageHandlers[_arg_1] = _arg_2;
            }
            else
            {
                debugMessage((("Warning, message handler called: " + _arg_1) + " already exist!"));
            };
        }

        private function debugMessage(_arg_1:String):void
        {
            var _local_2:SFSEvent;
            if (this.debug)
            {
                _local_2 = new SFSEvent(SFSEvent.onDebugMessage, {"message":_arg_1});
                dispatchEvent(_local_2);
            };
        }

        private function send(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:String):void
        {
            var _local_5:String = makeXmlHeader(_arg_1);
            _local_5 = (_local_5 + ((((((("<body action='" + _arg_2) + "' r='") + _arg_3) + "'>") + _arg_4) + "</body>") + closeHeader()));
            debugMessage((("[Sending]: " + _local_5) + "\n"));
            if (isHttpMode)
            {
                httpConnection.send(_local_5);
            }
            else
            {
                writeToSocket(_local_5);
            };
        }

        private function writeToSocket(_arg_1:String):void
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(_arg_1);
            _local_2.writeByte(0);
            socketConnection.writeBytes(_local_2);
            socketConnection.flush();
        }

        private function writeToSocketLinux(_arg_1:String):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                socketConnection.writeByte(_arg_1.charCodeAt(_local_2));
                _local_2++;
            };
            socketConnection.writeByte(0);
            socketConnection.flush();
        }

        private function makeXmlHeader(_arg_1:Object):String
        {
            var _local_3:String;
            var _local_2:* = "<msg";
            for (_local_3 in _arg_1)
            {
                _local_2 = (_local_2 + ((((" " + _local_3) + "='") + _arg_1[_local_3]) + "'"));
            };
            return (_local_2 + ">");
        }

        private function closeHeader():String
        {
            return ("</msg>");
        }

        private function checkBuddyDuplicates(_arg_1:String):Boolean
        {
            var _local_3:Object;
            var _local_2:Boolean;
            for each (_local_3 in buddyList)
            {
                if (_local_3.name == _arg_1)
                {
                    _local_2 = true;
                    break;
                };
            };
            return (_local_2);
        }

        private function xmlReceived(_arg_1:String):void
        {
            var _local_2:XML = new XML(_arg_1);
            var _local_3:String = _local_2.@t;
            var _local_4:String = _local_2.body.@action;
            var _local_5:int = int(_local_2.body.@r);
            var _local_6:IMessageHandler = messageHandlers[_local_3];
            if (_local_6 != null)
            {
                _local_6.handleMessage(_local_2, XTMSG_TYPE_XML);
            };
        }

        private function jsonReceived(_arg_1:String):void
        {
            var _local_2:Object = com.adobe.serialization.json.JSON.decode(_arg_1);
            var _local_3:String = _local_2["t"];
            var _local_4:IMessageHandler = messageHandlers[_local_3];
            if (_local_4 != null)
            {
                _local_4.handleMessage(_local_2["b"], XTMSG_TYPE_JSON);
            };
        }

        private function strReceived(_arg_1:String):void
        {
            var _local_2:Array = _arg_1.substr(1, (_arg_1.length - 2)).split(MSG_STR);
            var _local_3:String = _local_2[0];
            var _local_4:IMessageHandler = messageHandlers[_local_3];
            if (_local_4 != null)
            {
                _local_4.handleMessage(_local_2.splice(1, (_local_2.length - 1)), XTMSG_TYPE_STR);
            };
        }

        private function getXmlRoomVariable(_arg_1:Object):String
        {
            var _local_2:String = _arg_1.name.toString();
            var _local_3:* = _arg_1.val;
            var _local_4:String = ((_arg_1.priv) ? "1" : "0");
            var _local_5:String = ((_arg_1.persistent) ? "1" : "0");
            var _local_6:String;
            var _local_7:* = typeof(_local_3);
            if (_local_7 == "boolean")
            {
                _local_6 = "b";
                _local_3 = ((_local_3) ? "1" : "0");
            }
            else
            {
                if (_local_7 == "number")
                {
                    _local_6 = "n";
                }
                else
                {
                    if (_local_7 == "string")
                    {
                        _local_6 = "s";
                    }
                    else
                    {
                        if ((((_local_3 == null) && (_local_7 == "object")) || (_local_7 == "undefined")))
                        {
                            _local_6 = "x";
                            _local_3 = "";
                        };
                    };
                };
            };
            if (_local_6 != null)
            {
                return (((((((((("<var n='" + _local_2) + "' t='") + _local_6) + "' pr='") + _local_4) + "' pe='") + _local_5) + "'><![CDATA[") + _local_3) + "]]></var>");
            };
            return ("");
        }

        private function getXmlUserVariable(_arg_1:Object):String
        {
            var _local_3:*;
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            var _local_2:* = "<vars>";
            for (_local_6 in _arg_1)
            {
                _local_3 = _arg_1[_local_6];
                _local_5 = typeof(_local_3);
                _local_4 = null;
                if (_local_5 == "boolean")
                {
                    _local_4 = "b";
                    _local_3 = ((_local_3) ? "1" : "0");
                }
                else
                {
                    if (_local_5 == "number")
                    {
                        _local_4 = "n";
                    }
                    else
                    {
                        if (_local_5 == "string")
                        {
                            _local_4 = "s";
                        }
                        else
                        {
                            if ((((_local_3 == null) && (_local_5 == "object")) || (_local_5 == "undefined")))
                            {
                                _local_4 = "x";
                                _local_3 = "";
                            };
                        };
                    };
                };
                if (_local_4 != null)
                {
                    _local_2 = (_local_2 + (((((("<var n='" + _local_6) + "' t='") + _local_4) + "'><![CDATA[") + _local_3) + "]]></var>"));
                };
            };
            return (_local_2 + "</vars>");
        }

        private function checkRoomList():Boolean
        {
            return (true);
        }

        private function checkJoin():Boolean
        {
            var _local_1:Boolean = true;
            if (activeRoomId < 0)
            {
                _local_1 = false;
                errortrace("You haven't joined any rooms!\nIn order to interact with the server you should join at least one room.\nPlease consult the documentation for more infos.");
            };
            return (_local_1);
        }

        private function errortrace(_arg_1:String):void
        {
        }

        private function handleHttpConnect(_arg_1:HttpEvent):void
        {
            this.handleSocketConnection(null);
            connected = true;
            httpConnection.send(HTTP_POLL_REQUEST);
        }

        private function handleHttpClose(_arg_1:HttpEvent):void
        {
            initialize();
            var _local_2:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost, {});
            dispatchEvent(_local_2);
        }

        private function handleHttpData(_arg_1:HttpEvent):void
        {
            var _local_4:String;
            var _local_5:int;
            var _local_2:String = (_arg_1.params.data as String);
            var _local_3:Array = _local_2.split("\n");
            if (_local_3[0] != "")
            {
                _local_5 = 0;
                while (_local_5 < (_local_3.length - 1))
                {
                    _local_4 = _local_3[_local_5];
                    if (_local_4.length > 0)
                    {
                        handleMessage(_local_4);
                    };
                    _local_5++;
                };
                if (this._httpPollSpeed > 0)
                {
                    setTimeout(this.handleDelayedPoll, this._httpPollSpeed);
                }
                else
                {
                    handleDelayedPoll();
                };
            };
        }

        private function handleDelayedPoll():void
        {
            httpConnection.send(HTTP_POLL_REQUEST);
        }

        private function handleHttpError(_arg_1:HttpEvent):void
        {
            if (!connected)
            {
                dispatchConnectionError();
            };
        }

        private function handleSocketConnection(_arg_1:Event):void
        {
            var _local_2:Object = {"t":"sys"};
            var _local_3:* = (((("<ver v='" + this.majVersion.toString()) + this.minVersion.toString()) + this.subVersion.toString()) + "' />");
            send(_local_2, "verChk", 0, _local_3);
        }

        private function handleSocketDisconnection(_arg_1:Event):void
        {
            initialize();
            var _local_2:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost, {"disconnect":true});
            dispatchEvent(_local_2);
        }

        private function handleIOError(_arg_1:IOErrorEvent):void
        {
            tryBlueBoxConnection(_arg_1);
        }

        private function tryBlueBoxConnection(_arg_1:ErrorEvent):void
        {
            var _local_2:String;
            var _local_3:int;
            if (!connected)
            {
                if (smartConnect)
                {
                    debugMessage("Socket connection failed. Trying BlueBox");
                    isHttpMode = true;
                    _local_2 = ((blueBoxIpAddress != null) ? blueBoxIpAddress : ipAddress);
                    _local_3 = ((blueBoxPort != 0) ? blueBoxPort : httpPort);
                    httpConnection.connect(_local_2, _local_3);
                }
                else
                {
                    dispatchConnectionError();
                };
            }
            else
            {
                dispatchEvent(_arg_1);
                debugMessage(("[WARN] Connection error: " + _arg_1.text));
            };
        }

        private function handleSocketError(_arg_1:SecurityErrorEvent):void
        {
            debugMessage(("Socket Error: " + _arg_1.text));
        }

        private function handleSecurityError(_arg_1:SecurityErrorEvent):void
        {
            tryBlueBoxConnection(_arg_1);
        }

        private function handleSocketData(_arg_1:Event):void
        {
            var _local_3:int;
            var _local_2:int = socketConnection.bytesAvailable;
            while (--_local_2 >= 0)
            {
                _local_3 = socketConnection.readByte();
                if (_local_3 != 0)
                {
                    byteBuffer.writeByte(_local_3);
                }
                else
                {
                    handleMessage(byteBuffer.toString());
                    byteBuffer = new ByteArray();
                };
            };
        }

        private function handleMessage(_arg_1:String):void
        {
            if (_arg_1 != "ok")
            {
                debugMessage((((("[ RECEIVED ]: " + _arg_1) + ", (len: ") + _arg_1.length) + ")"));
            };
            var _local_2:String = _arg_1.charAt(0);
            if (_local_2 == MSG_XML)
            {
                xmlReceived(_arg_1);
            }
            else
            {
                if (_local_2 == MSG_STR)
                {
                    strReceived(_arg_1);
                }
                else
                {
                    if (_local_2 == MSG_JSON)
                    {
                        jsonReceived(_arg_1);
                    };
                };
            };
        }

        private function dispatchConnectionError():void
        {
            var _local_1:Object = {};
            _local_1.success = false;
            _local_1.error = "I/O Error";
            var _local_2:SFSEvent = new SFSEvent(SFSEvent.onConnection, _local_1);
            dispatchEvent(_local_2);
        }


    }
}//package it.gotoandplay.smartfoxserver

