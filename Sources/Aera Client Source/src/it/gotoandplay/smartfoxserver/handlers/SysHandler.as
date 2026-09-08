// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.handlers.SysHandler

package it.gotoandplay.smartfoxserver.handlers
{
    import it.gotoandplay.smartfoxserver.SmartFoxClient;
    import it.gotoandplay.smartfoxserver.SFSEvent;
    import it.gotoandplay.smartfoxserver.data.Room;
    import it.gotoandplay.smartfoxserver.data.User;
    import it.gotoandplay.smartfoxserver.util.Entities;
    import it.gotoandplay.smartfoxserver.util.ObjectSerializer;
    import flash.utils.getTimer;

    public class SysHandler implements IMessageHandler 
    {

        private var sfs:SmartFoxClient;
        private var handlersTable:Array;

        public function SysHandler(_arg_1:SmartFoxClient)
        {
            this.sfs = _arg_1;
            handlersTable = [];
            handlersTable["apiOK"] = this.handleApiOK;
            handlersTable["apiKO"] = this.handleApiKO;
            handlersTable["logOK"] = this.handleLoginOk;
            handlersTable["logKO"] = this.handleLoginKo;
            handlersTable["logout"] = this.handleLogout;
            handlersTable["rmList"] = this.handleRoomList;
            handlersTable["uCount"] = this.handleUserCountChange;
            handlersTable["joinOK"] = this.handleJoinOk;
            handlersTable["joinKO"] = this.handleJoinKo;
            handlersTable["uER"] = this.handleUserEnterRoom;
            handlersTable["userGone"] = this.handleUserLeaveRoom;
            handlersTable["pubMsg"] = this.handlePublicMessage;
            handlersTable["prvMsg"] = this.handlePrivateMessage;
            handlersTable["dmnMsg"] = this.handleAdminMessage;
            handlersTable["modMsg"] = this.handleModMessage;
            handlersTable["dataObj"] = this.handleASObject;
            handlersTable["rVarsUpdate"] = this.handleRoomVarsUpdate;
            handlersTable["roomAdd"] = this.handleRoomAdded;
            handlersTable["roomDel"] = this.handleRoomDeleted;
            handlersTable["rndK"] = this.handleRandomKey;
            handlersTable["roundTripRes"] = this.handleRoundTripBench;
            handlersTable["uVarsUpdate"] = this.handleUserVarsUpdate;
            handlersTable["createRmKO"] = this.handleCreateRoomError;
            handlersTable["bList"] = this.handleBuddyList;
            handlersTable["bUpd"] = this.handleBuddyListUpdate;
            handlersTable["bAdd"] = this.handleBuddyAdded;
            handlersTable["roomB"] = this.handleBuddyRoom;
            handlersTable["leaveRoom"] = this.handleLeaveRoom;
            handlersTable["swSpec"] = this.handleSpectatorSwitched;
            handlersTable["bPrm"] = this.handleAddBuddyPermission;
            handlersTable["remB"] = this.handleRemoveBuddy;
        }

        public function handleMessage(_arg_1:Object, _arg_2:String):void
        {
            var _local_3:XML = (_arg_1 as XML);
            var _local_4:String = _local_3.body.@action;
            var _local_5:Function = handlersTable[_local_4];
            if (_local_5 != null)
            {
                _local_5.apply(this, [_arg_1]);
            };
        }

        public function handleApiOK(_arg_1:Object):void
        {
            sfs.isConnected = true;
            var _local_2:SFSEvent = new SFSEvent(SFSEvent.onConnection, {"success":true});
            sfs.dispatchEvent(_local_2);
        }

        public function handleApiKO(_arg_1:Object):void
        {
            var _local_2:Object = {};
            _local_2.success = false;
            _local_2.error = "API are obsolete, please upgrade";
            var _local_3:SFSEvent = new SFSEvent(SFSEvent.onConnection, _local_2);
            sfs.dispatchEvent(_local_3);
        }

        public function handleLoginOk(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.login.@id);
            var _local_3:int = int(_arg_1.body.login.@mod);
            var _local_4:String = _arg_1.body.login.@n;
            sfs.amIModerator = (_local_3 == 1);
            sfs.myUserId = _local_2;
            sfs.myUserName = _local_4;
            sfs.playerId = -1;
            var _local_5:Object = {};
            _local_5.success = true;
            _local_5.name = _local_4;
            _local_5.error = "";
            var _local_6:SFSEvent = new SFSEvent(SFSEvent.onLogin, _local_5);
            sfs.dispatchEvent(_local_6);
            sfs.getRoomList();
        }

        public function handleLoginKo(_arg_1:Object):void
        {
            var _local_2:Object = {};
            _local_2.success = false;
            _local_2.error = _arg_1.body.login.@e;
            var _local_3:SFSEvent = new SFSEvent(SFSEvent.onLogin, _local_2);
            sfs.dispatchEvent(_local_3);
        }

        public function handleLogout(_arg_1:Object):void
        {
            sfs.__logout();
            var _local_2:SFSEvent = new SFSEvent(SFSEvent.onLogout, {});
            sfs.dispatchEvent(_local_2);
        }

        public function handleRoomList(_arg_1:Object):void
        {
            var _local_3:XML;
            var _local_4:Object;
            var _local_5:SFSEvent;
            var _local_6:int;
            var _local_7:Room;
            sfs.clearRoomList();
            var _local_2:Array = sfs.getAllRooms();
            for each (_local_3 in _arg_1.body.rmList.rm)
            {
                _local_6 = int(_local_3.@id);
                _local_7 = new Room(_local_6, _local_3.n, int(_local_3.@maxu), int(_local_3.@maxs), (_local_3.@temp == "1"), (_local_3.@game == "1"), (_local_3.@priv == "1"), (_local_3.@lmb == "1"), int(_local_3.@ucnt), int(_local_3.@scnt));
                if (_local_3.vars.toString().length > 0)
                {
                    populateVariables(_local_7.getVariables(), _local_3);
                };
                _local_2[_local_6] = _local_7;
            };
            _local_4 = {};
            _local_4.roomList = _local_2;
            _local_5 = new SFSEvent(SFSEvent.onRoomListUpdate, _local_4);
            sfs.dispatchEvent(_local_5);
        }

        public function handleUserCountChange(_arg_1:Object):void
        {
            var _local_6:Object;
            var _local_7:SFSEvent;
            var _local_2:int = int(_arg_1.body.@u);
            var _local_3:int = int(_arg_1.body.@s);
            var _local_4:int = int(_arg_1.body.@r);
            var _local_5:Room = sfs.getAllRooms()[_local_4];
            if (_local_5 != null)
            {
                _local_5.setUserCount(_local_2);
                _local_5.setSpectatorCount(_local_3);
                _local_6 = {};
                _local_6.room = _local_5;
                _local_7 = new SFSEvent(SFSEvent.onUserCountChange, _local_6);
                sfs.dispatchEvent(_local_7);
            };
        }

        private function fakeRoomAdd(_arg_1:int):void
        {
            var _local_2:int = int(_arg_1);
            var _local_3:String = String(_arg_1);
            var _local_4:int = 20;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Boolean = true;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_10:Room = new Room(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9);
            var _local_11:Array = sfs.getAllRooms();
            _local_11[_local_2] = _local_10;
        }

        public function handleJoinOk(_arg_1:Object):void
        {
            var _local_7:XML;
            var _local_8:Object;
            var _local_9:SFSEvent;
            var _local_10:String;
            var _local_11:int;
            var _local_12:Boolean;
            var _local_13:Boolean;
            var _local_14:int;
            var _local_15:User;
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:XMLList = _arg_1.body;
            var _local_4:XMLList = _arg_1.body.uLs.u;
            var _local_5:int = int(_arg_1.body.pid.@id);
            if (_local_2 != 1)
            {
                fakeRoomAdd(_local_2);
            };
            sfs.activeRoomId = _local_2;
            var _local_6:Room = sfs.getRoom(_local_2);
            _local_6.clearUserList();
            sfs.playerId = _local_5;
            _local_6.setMyPlayerIndex(_local_5);
            if (_local_3.vars.toString().length > 0)
            {
                _local_6.clearVariables();
                populateVariables(_local_6.getVariables(), _local_3);
            };
            for each (_local_7 in _local_4)
            {
                _local_10 = _local_7.n;
                _local_11 = int(_local_7.@i);
                _local_12 = ((_local_7.@m == "1") ? true : false);
                _local_13 = ((_local_7.@s == "1") ? true : false);
                _local_14 = ((_local_7.@p == null) ? -1 : int(_local_7.@p));
                _local_15 = new User(_local_11, _local_10);
                _local_15.setModerator(_local_12);
                _local_15.setIsSpectator(_local_13);
                _local_15.setPlayerId(_local_14);
                if (_local_7.vars.toString().length > 0)
                {
                    populateVariables(_local_15.getVariables(), _local_7);
                };
                _local_6.addUser(_local_15, _local_11);
            };
            sfs.changingRoom = false;
            _local_8 = {};
            _local_8.room = _local_6;
            _local_9 = new SFSEvent(SFSEvent.onJoinRoom, _local_8);
            sfs.dispatchEvent(_local_9);
        }

        public function handleJoinKo(_arg_1:Object):void
        {
            sfs.changingRoom = false;
            var _local_2:Object = {};
            _local_2.error = _arg_1.body.error.@msg;
            var _local_3:SFSEvent = new SFSEvent(SFSEvent.onJoinRoomError, _local_2);
            sfs.dispatchEvent(_local_3);
        }

        public function handleUserEnterRoom(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.u.@i);
            var _local_4:String = _arg_1.body.u.n;
            var _local_5:* = (_arg_1.body.u.@m == "1");
            var _local_6:* = (_arg_1.body.u.@s == "1");
            var _local_7:int = ((_arg_1.body.u.@p != null) ? int(_arg_1.body.u.@p) : -1);
            var _local_8:XMLList = _arg_1.body.u.vars["var"];
            var _local_9:Room = sfs.getRoom(_local_2);
            var _local_10:User = new User(_local_3, _local_4);
            _local_10.setModerator(_local_5);
            _local_10.setIsSpectator(_local_6);
            _local_10.setPlayerId(_local_7);
            _local_9.addUser(_local_10, _local_3);
            if (_arg_1.body.u.vars.toString().length > 0)
            {
                populateVariables(_local_10.getVariables(), _arg_1.body.u);
            };
            var _local_11:Object = {};
            _local_11.roomId = _local_2;
            _local_11.user = _local_10;
            var _local_12:SFSEvent = new SFSEvent(SFSEvent.onUserEnterRoom, _local_11);
            sfs.dispatchEvent(_local_12);
        }

        public function handleUserLeaveRoom(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.user.@id);
            var _local_3:int = int(_arg_1.body.@r);
            var _local_4:Room = sfs.getRoom(_local_3);
            var _local_5:String = _local_4.getUser(_local_2).getName();
            _local_4.removeUser(_local_2);
            var _local_6:Object = {};
            _local_6.roomId = _local_3;
            _local_6.userId = _local_2;
            _local_6.userName = _local_5;
            var _local_7:SFSEvent = new SFSEvent(SFSEvent.onUserLeaveRoom, _local_6);
            sfs.dispatchEvent(_local_7);
        }

        public function handlePublicMessage(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.user.@id);
            var _local_4:String = _arg_1.body.txt;
            var _local_5:User = sfs.getRoom(_local_2).getUser(_local_3);
            var _local_6:Object = {};
            _local_6.message = Entities.decodeEntities(_local_4);
            _local_6.sender = _local_5;
            _local_6.roomId = _local_2;
            var _local_7:SFSEvent = new SFSEvent(SFSEvent.onPublicMessage, _local_6);
            sfs.dispatchEvent(_local_7);
        }

        public function handlePrivateMessage(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.user.@id);
            var _local_4:String = _arg_1.body.txt;
            var _local_5:User = sfs.getRoom(_local_2).getUser(_local_3);
            var _local_6:Object = {};
            _local_6.message = Entities.decodeEntities(_local_4);
            _local_6.sender = _local_5;
            _local_6.roomId = _local_2;
            _local_6.userId = _local_3;
            var _local_7:SFSEvent = new SFSEvent(SFSEvent.onPrivateMessage, _local_6);
            sfs.dispatchEvent(_local_7);
        }

        public function handleAdminMessage(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.user.@id);
            var _local_4:String = _arg_1.body.txt;
            var _local_5:Object = {};
            _local_5.message = Entities.decodeEntities(_local_4);
            var _local_6:SFSEvent = new SFSEvent(SFSEvent.onAdminMessage, _local_5);
            sfs.dispatchEvent(_local_6);
        }

        public function handleModMessage(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.user.@id);
            var _local_4:String = _arg_1.body.txt;
            var _local_5:User;
            var _local_6:Room = sfs.getRoom(_local_2);
            if (_local_6 != null)
            {
                _local_5 = sfs.getRoom(_local_2).getUser(_local_3);
            };
            var _local_7:Object = {};
            _local_7.message = Entities.decodeEntities(_local_4);
            _local_7.sender = _local_5;
            var _local_8:SFSEvent = new SFSEvent(SFSEvent.onModeratorMessage, _local_7);
            sfs.dispatchEvent(_local_8);
        }

        public function handleASObject(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.user.@id);
            var _local_4:String = _arg_1.body.dataObj;
            var _local_5:User = sfs.getRoom(_local_2).getUser(_local_3);
            var _local_6:Object = ObjectSerializer.getInstance().deserialize(new XML(_local_4));
            var _local_7:Object = {};
            _local_7.obj = _local_6;
            _local_7.sender = _local_5;
            var _local_8:SFSEvent = new SFSEvent(SFSEvent.onObjectReceived, _local_7);
            sfs.dispatchEvent(_local_8);
        }

        public function handleRoomVarsUpdate(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.user.@id);
            var _local_4:Room = sfs.getRoom(_local_2);
            var _local_5:Array = [];
            if (_arg_1.body.vars.toString().length > 0)
            {
                populateVariables(_local_4.getVariables(), _arg_1.body, _local_5);
            };
            var _local_6:Object = {};
            _local_6.room = _local_4;
            _local_6.changedVars = _local_5;
            var _local_7:SFSEvent = new SFSEvent(SFSEvent.onRoomVariablesUpdate, _local_6);
            sfs.dispatchEvent(_local_7);
        }

        public function handleUserVarsUpdate(_arg_1:Object):void
        {
            var _local_3:Array;
            var _local_6:Room;
            var _local_7:Object;
            var _local_8:SFSEvent;
            var _local_2:int = int(_arg_1.body.user.@id);
            var _local_4:User;
            var _local_5:User;
            if (_arg_1.body.vars.toString().length > 0)
            {
                for each (_local_6 in sfs.getAllRooms())
                {
                    _local_4 = _local_6.getUser(_local_2);
                    if (_local_4 != null)
                    {
                        if (_local_5 == null)
                        {
                            _local_5 = _local_4;
                        };
                        _local_3 = [];
                        populateVariables(_local_4.getVariables(), _arg_1.body, _local_3);
                    };
                };
                _local_7 = {};
                _local_7.user = _local_5;
                _local_7.changedVars = _local_3;
                _local_8 = new SFSEvent(SFSEvent.onUserVariablesUpdate, _local_7);
                sfs.dispatchEvent(_local_8);
            };
        }

        private function handleRoomAdded(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.rm.@id);
            var _local_3:String = _arg_1.body.rm.name;
            var _local_4:int = int(_arg_1.body.rm.@max);
            var _local_5:int = int(_arg_1.body.rm.@spec);
            var _local_6:Boolean = ((_arg_1.body.rm.@temp == "1") ? true : false);
            var _local_7:Boolean = ((_arg_1.body.rm.@game == "1") ? true : false);
            var _local_8:Boolean = ((_arg_1.body.rm.@priv == "1") ? true : false);
            var _local_9:Boolean = ((_arg_1.body.rm.@limbo == "1") ? true : false);
            var _local_10:Room = new Room(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9);
            var _local_11:Array = sfs.getAllRooms();
            _local_11[_local_2] = _local_10;
            if (_arg_1.body.rm.vars.toString().length > 0)
            {
                populateVariables(_local_10.getVariables(), _arg_1.body.rm);
            };
            var _local_12:Object = {};
            _local_12.room = _local_10;
            var _local_13:SFSEvent = new SFSEvent(SFSEvent.onRoomAdded, _local_12);
            sfs.dispatchEvent(_local_13);
        }

        private function handleRoomDeleted(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.rm.@id);
            var _local_3:Array = sfs.getAllRooms();
            var _local_4:Object = {};
            _local_4.room = _local_3[_local_2];
            delete _local_3[_local_2];
            var _local_5:SFSEvent = new SFSEvent(SFSEvent.onRoomDeleted, _local_4);
            sfs.dispatchEvent(_local_5);
        }

        private function handleRandomKey(_arg_1:Object):void
        {
            var _local_2:String = _arg_1.body.k.toString();
            var _local_3:Object = {};
            _local_3.key = _local_2;
            var _local_4:SFSEvent = new SFSEvent(SFSEvent.onRandomKey, _local_3);
            sfs.dispatchEvent(_local_4);
        }

        private function handleRoundTripBench(_arg_1:Object):void
        {
            var _local_2:int = getTimer();
            var _local_3:int = (_local_2 - sfs.getBenchStartTime());
            var _local_4:Object = {};
            _local_4.elapsed = _local_3;
            var _local_5:SFSEvent = new SFSEvent(SFSEvent.onRoundTripResponse, _local_4);
            sfs.dispatchEvent(_local_5);
        }

        private function handleCreateRoomError(_arg_1:Object):void
        {
            var _local_2:String = _arg_1.body.room.@e;
            var _local_3:Object = {};
            _local_3.error = _local_2;
            var _local_4:SFSEvent = new SFSEvent(SFSEvent.onCreateRoomError, _local_3);
            sfs.dispatchEvent(_local_4);
        }

        private function handleBuddyList(_arg_1:Object):void
        {
            var _local_4:Object;
            var _local_7:XML;
            var _local_8:XML;
            var _local_9:XMLList;
            var _local_10:XML;
            var _local_2:XMLList = _arg_1.body.bList;
            var _local_3:XMLList = _arg_1.body.mv;
            var _local_5:Object = {};
            var _local_6:SFSEvent;
            if (((!(_local_3 == null)) && (_local_3.toString().length > 0)))
            {
                for each (_local_7 in _local_3.v)
                {
                    sfs.myBuddyVars[_local_7.@n.toString()] = _local_7.toString();
                };
            };
            if (((!(_local_2 == null)) && (!(_local_2.b.length == null))))
            {
                if (_local_2.toString().length > 0)
                {
                    for each (_local_8 in _local_2.b)
                    {
                        _local_4 = {};
                        _local_4.isOnline = ((_local_8.@s == "1") ? true : false);
                        _local_4.name = _local_8.n.toString();
                        _local_4.id = _local_8.@i;
                        _local_4.isBlocked = ((_local_8.@x == "1") ? true : false);
                        _local_4.variables = {};
                        _local_9 = _local_8.vs;
                        if (_local_9.toString().length > 0)
                        {
                            for each (_local_10 in _local_9.v)
                            {
                                _local_4.variables[_local_10.@n.toString()] = _local_10.toString();
                            };
                        };
                        sfs.buddyList.push(_local_4);
                    };
                };
                _local_5.list = sfs.buddyList;
                _local_6 = new SFSEvent(SFSEvent.onBuddyList, _local_5);
                sfs.dispatchEvent(_local_6);
            }
            else
            {
                _local_5.error = _arg_1.body.err.toString();
                _local_6 = new SFSEvent(SFSEvent.onBuddyListError, _local_5);
                sfs.dispatchEvent(_local_6);
            };
        }

        private function handleBuddyListUpdate(_arg_1:Object):void
        {
            var _local_4:Object;
            var _local_5:XMLList;
            var _local_6:Object;
            var _local_7:Boolean;
            var _local_8:String;
            var _local_9:XML;
            var _local_2:Object = {};
            var _local_3:SFSEvent;
            if (_arg_1.body.b != null)
            {
                _local_4 = {};
                _local_4.isOnline = ((_arg_1.body.b.@s == "1") ? true : false);
                _local_4.name = _arg_1.body.b.n.toString();
                _local_4.id = _arg_1.body.b.@i;
                _local_4.isBlocked = ((_arg_1.body.b.@x == "1") ? true : false);
                _local_5 = _arg_1.body.b.vs;
                _local_6 = null;
                _local_7 = false;
                for (_local_8 in sfs.buddyList)
                {
                    _local_6 = sfs.buddyList[_local_8];
                    if (_local_6.name == _local_4.name)
                    {
                        sfs.buddyList[_local_8] = _local_4;
                        _local_4.isBlocked = _local_6.isBlocked;
                        _local_4.variables = _local_6.variables;
                        if (_local_5.toString().length > 0)
                        {
                            for each (_local_9 in _local_5.v)
                            {
                                _local_4.variables[_local_9.@n.toString()] = _local_9.toString();
                            };
                        };
                        _local_7 = true;
                        break;
                    };
                };
                if (_local_7)
                {
                    _local_2.buddy = _local_4;
                    _local_3 = new SFSEvent(SFSEvent.onBuddyListUpdate, _local_2);
                    sfs.dispatchEvent(_local_3);
                };
            }
            else
            {
                _local_2.error = _arg_1.body.err.toString();
                _local_3 = new SFSEvent(SFSEvent.onBuddyListError, _local_2);
                sfs.dispatchEvent(_local_3);
            };
        }

        private function handleAddBuddyPermission(_arg_1:Object):void
        {
            var _local_2:Object = {};
            _local_2.sender = _arg_1.body.n.toString();
            _local_2.message = "";
            if (_arg_1.body.txt != undefined)
            {
                _local_2.message = Entities.decodeEntities(_arg_1.body.txt);
            };
            var _local_3:SFSEvent = new SFSEvent(SFSEvent.onBuddyPermissionRequest, _local_2);
            sfs.dispatchEvent(_local_3);
        }

        private function handleBuddyAdded(_arg_1:Object):void
        {
            var _local_6:XML;
            var _local_2:Object = {};
            _local_2.isOnline = ((_arg_1.body.b.@s == "1") ? true : false);
            _local_2.name = _arg_1.body.b.n.toString();
            _local_2.id = _arg_1.body.b.@i;
            _local_2.isBlocked = ((_arg_1.body.b.@x == "1") ? true : false);
            _local_2.variables = {};
            var _local_3:XMLList = _arg_1.body.b.vs;
            if (_local_3.toString().length > 0)
            {
                for each (_local_6 in _local_3.v)
                {
                    _local_2.variables[_local_6.@n.toString()] = _local_6.toString();
                };
            };
            sfs.buddyList.push(_local_2);
            var _local_4:Object = {};
            _local_4.list = sfs.buddyList;
            var _local_5:SFSEvent = new SFSEvent(SFSEvent.onBuddyList, _local_4);
            sfs.dispatchEvent(_local_5);
        }

        private function handleRemoveBuddy(_arg_1:Object):void
        {
            var _local_4:String;
            var _local_5:Object;
            var _local_6:SFSEvent;
            var _local_2:String = _arg_1.body.n.toString();
            var _local_3:Object;
            for (_local_4 in sfs.buddyList)
            {
                _local_3 = sfs.buddyList[_local_4];
                if (_local_3.name == _local_2)
                {
                    delete sfs.buddyList[_local_4];
                    _local_5 = {};
                    _local_5.list = sfs.buddyList;
                    _local_6 = new SFSEvent(SFSEvent.onBuddyList, _local_5);
                    sfs.dispatchEvent(_local_6);
                    break;
                };
            };
        }

        private function handleBuddyRoom(_arg_1:Object):void
        {
            var _local_2:String = _arg_1.body.br.@r;
            var _local_3:Array = _local_2.split(",");
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_3[_local_4] = int(_local_3[_local_4]);
                _local_4++;
            };
            var _local_5:Object = {};
            _local_5.idList = _local_3;
            var _local_6:SFSEvent = new SFSEvent(SFSEvent.onBuddyRoom, _local_5);
            sfs.dispatchEvent(_local_6);
        }

        private function handleLeaveRoom(_arg_1:Object):void
        {
            var _local_2:int = int(_arg_1.body.rm.@id);
            var _local_3:Object = {};
            _local_3.roomId = _local_2;
            var _local_4:SFSEvent = new SFSEvent(SFSEvent.onRoomLeft, _local_3);
            sfs.dispatchEvent(_local_4);
        }

        private function handleSpectatorSwitched(_arg_1:Object):void
        {
            var _local_5:int;
            var _local_6:User;
            var _local_7:Object;
            var _local_8:SFSEvent;
            var _local_2:int = int(_arg_1.body.@r);
            var _local_3:int = int(_arg_1.body.pid.@id);
            var _local_4:Room = sfs.getRoom(_local_2);
            if (_local_3 > 0)
            {
                _local_4.setUserCount((_local_4.getUserCount() + 1));
                _local_4.setSpectatorCount((_local_4.getSpectatorCount() - 1));
            };
            if (_arg_1.body.pid.@u != undefined)
            {
                _local_5 = int(_arg_1.body.pid.@u);
                _local_6 = _local_4.getUser(_local_5);
                if (_local_6 != null)
                {
                    _local_6.setIsSpectator(false);
                    _local_6.setPlayerId(_local_3);
                };
            }
            else
            {
                sfs.playerId = _local_3;
                _local_7 = {};
                _local_7.success = (sfs.playerId > 0);
                _local_7.newId = sfs.playerId;
                _local_7.room = _local_4;
                _local_8 = new SFSEvent(SFSEvent.onSpectatorSwitched, _local_7);
                sfs.dispatchEvent(_local_8);
            };
        }

        private function populateVariables(_arg_1:Array, _arg_2:Object, _arg_3:Array=null):void
        {
            var _local_4:XML;
            var _local_5:String;
            var _local_6:String;
            var _local_7:String;
            for each (_local_4 in _arg_2.vars["var"])
            {
                _local_5 = _local_4.@n;
                _local_6 = _local_4.@t;
                _local_7 = _local_4;
                if (_arg_3 != null)
                {
                    _arg_3.push(_local_5);
                    _arg_3[_local_5] = true;
                };
                if (_local_6 == "b")
                {
                    _arg_1[_local_5] = ((_local_7 == "1") ? true : false);
                }
                else
                {
                    if (_local_6 == "n")
                    {
                        _arg_1[_local_5] = Number(_local_7);
                    }
                    else
                    {
                        if (_local_6 == "s")
                        {
                            _arg_1[_local_5] = _local_7;
                        }
                        else
                        {
                            if (_local_6 == "x")
                            {
                                delete _arg_1[_local_5];
                            };
                        };
                    };
                };
            };
        }

        public function dispatchDisconnection():void
        {
            var _local_1:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost, null);
            sfs.dispatchEvent(_local_1);
        }


    }
}//package it.gotoandplay.smartfoxserver.handlers

