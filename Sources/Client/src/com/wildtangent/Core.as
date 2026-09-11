// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.Core

package com.wildtangent
{
    import flash.display.Sprite;

    public class Core extends Sprite 
    {

        public var vexReady:Boolean = false;
        public var myVex:* = null;
        private var callbacks:Object;
        private var _dpName:String;
        private var _gameName:String;
        private var _partnerName:String;
        private var _siteName:String;
        private var _userId:String;
        private var _cipherKey:String;
        private var _vexUrl:String = "http://vex.wildtangent.com";
        private var _sandbox:Boolean = false;
        private var _javascriptReady:Boolean = false;
        protected var _adComplete:Function;
        protected var _closed:Function;
        protected var _error:Function;
        protected var _handlePromo:Function;
        protected var _redeemCode:Function;
        protected var _requireLogin:Function;
        protected var methodStorage:Array = [];


        protected function storeMethod(_arg_1:Function, _arg_2:Object=null):void
        {
            methodStorage.push({
                "tempMethod":_arg_1,
                "obj":_arg_2
            });
        }

        public function launchMethods():void
        {
            var _local_1:String;
            for (_local_1 in methodStorage)
            {
                if (methodStorage[_local_1].obj != null)
                {
                    methodStorage[_local_1].tempMethod.call(null, methodStorage[_local_1].obj);
                }
                else
                {
                    methodStorage[_local_1].tempMethod.call(null);
                };
            };
        }

        protected function checkTop():void
        {
            var _local_1:* = root;
            var _local_2:* = parent;
            var _local_3:int;
            while (_local_3 < _local_1.numChildren)
            {
                if ((_local_1.getChildAt(_local_3) is WildTangentAPI))
                {
                    _local_2 = _local_1.getChildAt(_local_3);
                };
                _local_3++;
            };
            _local_1.setChildIndex(_local_1.getChildByName(_local_2.name), (_local_1.numChildren - 1));
        }


    }
}//package com.wildtangent

