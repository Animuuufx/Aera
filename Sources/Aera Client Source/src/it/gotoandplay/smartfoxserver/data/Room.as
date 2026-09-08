// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.data.Room

package it.gotoandplay.smartfoxserver.data
{
    public class Room 
    {

        private var id:int;
        private var name:String;
        private var maxUsers:int;
        private var maxSpectators:int;
        private var temp:Boolean;
        private var game:Boolean;
        private var priv:Boolean;
        private var limbo:Boolean;
        private var userCount:int;
        private var specCount:int;
        private var myPlayerIndex:int;
        private var userList:Array;
        private var variables:Array;

        public function Room(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean, _arg_8:Boolean, _arg_9:int=0, _arg_10:int=0)
        {
            this.id = _arg_1;
            this.name = _arg_2;
            this.maxSpectators = _arg_4;
            this.maxUsers = _arg_3;
            this.temp = _arg_5;
            this.game = _arg_6;
            this.priv = _arg_7;
            this.limbo = _arg_8;
            this.userCount = _arg_9;
            this.specCount = _arg_10;
            this.userList = [];
            this.variables = [];
        }

        public function addUser(_arg_1:User, _arg_2:int):void
        {
            userList[_arg_2] = _arg_1;
            if (((this.game) && (_arg_1.isSpectator())))
            {
                specCount++;
            }
            else
            {
                userCount++;
            };
        }

        public function removeUser(_arg_1:int):void
        {
            var _local_2:User = userList[_arg_1];
            if (((this.game) && (_local_2.isSpectator())))
            {
                specCount--;
            }
            else
            {
                userCount--;
            };
            delete userList[_arg_1];
        }

        public function getUserList():Array
        {
            return (this.userList);
        }

        public function getUser(_arg_1:*):User
        {
            var _local_3:String;
            var _local_4:User;
            var _local_2:User;
            if (typeof(_arg_1) == "number")
            {
                _local_2 = userList[_arg_1];
            }
            else
            {
                if (typeof(_arg_1) == "string")
                {
                    for (_local_3 in userList)
                    {
                        _local_4 = this.userList[_local_3];
                        if (_local_4.getName() == _arg_1)
                        {
                            _local_2 = _local_4;
                            break;
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function clearUserList():void
        {
            this.userList = [];
            this.userCount = 0;
            this.specCount = 0;
        }

        public function getVariable(_arg_1:String):*
        {
            return (variables[_arg_1]);
        }

        public function getVariables():Array
        {
            return (variables);
        }

        public function setVariables(_arg_1:Array):void
        {
            this.variables = _arg_1;
        }

        public function clearVariables():void
        {
            this.variables = [];
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getId():int
        {
            return (this.id);
        }

        public function isTemp():Boolean
        {
            return (this.temp);
        }

        public function isGame():Boolean
        {
            return (this.game);
        }

        public function isPrivate():Boolean
        {
            return (this.priv);
        }

        public function getUserCount():int
        {
            return (this.userCount);
        }

        public function getSpectatorCount():int
        {
            return (this.specCount);
        }

        public function getMaxUsers():int
        {
            return (this.maxUsers);
        }

        public function getMaxSpectators():int
        {
            return (this.maxSpectators);
        }

        public function setMyPlayerIndex(_arg_1:int):void
        {
            this.myPlayerIndex = _arg_1;
        }

        public function getMyPlayerIndex():int
        {
            return (this.myPlayerIndex);
        }

        public function setIsLimbo(_arg_1:Boolean):void
        {
            this.limbo = _arg_1;
        }

        public function isLimbo():Boolean
        {
            return (this.limbo);
        }

        public function setUserCount(_arg_1:int):void
        {
            this.userCount = _arg_1;
        }

        public function setSpectatorCount(_arg_1:int):void
        {
            this.specCount = _arg_1;
        }


    }
}//package it.gotoandplay.smartfoxserver.data

