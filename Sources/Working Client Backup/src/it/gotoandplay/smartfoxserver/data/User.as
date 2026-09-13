// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.data.User

package it.gotoandplay.smartfoxserver.data
{
    public class User 
    {

        private var id:int;
        private var name:String;
        private var variables:Array;
        private var isSpec:Boolean;
        private var isMod:Boolean;
        private var pId:int;

        public function User(_arg_1:int, _arg_2:String)
        {
            this.id = _arg_1;
            this.name = _arg_2;
            this.variables = [];
            this.isSpec = false;
            this.isMod = false;
        }

        public function getId():int
        {
            return (this.id);
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getVariable(_arg_1:String):*
        {
            return (this.variables[_arg_1]);
        }

        public function getVariables():Array
        {
            return (this.variables);
        }

        public function setVariables(_arg_1:Object):void
        {
            var _local_2:String;
            var _local_3:*;
            for (_local_2 in _arg_1)
            {
                _local_3 = _arg_1[_local_2];
                if (_local_3 != null)
                {
                    this.variables[_local_2] = _local_3;
                }
                else
                {
                    delete this.variables[_local_2];
                };
            };
        }

        public function clearVariables():void
        {
            this.variables = [];
        }

        public function setIsSpectator(_arg_1:Boolean):void
        {
            this.isSpec = _arg_1;
        }

        public function isSpectator():Boolean
        {
            return (this.isSpec);
        }

        public function setModerator(_arg_1:Boolean):void
        {
            this.isMod = _arg_1;
        }

        public function isModerator():Boolean
        {
            return (this.isMod);
        }

        public function getPlayerId():int
        {
            return (this.pId);
        }

        public function setPlayerId(_arg_1:int):void
        {
            this.pId = _arg_1;
        }


    }
}//package it.gotoandplay.smartfoxserver.data

