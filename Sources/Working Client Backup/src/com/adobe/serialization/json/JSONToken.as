// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.adobe.serialization.json.JSONToken

package com.adobe.serialization.json
{
    public class JSONToken 
    {

        private var _type:int;
        private var _value:Object;

        public function JSONToken(_arg_1:int=-1, _arg_2:Object=null)
        {
            _type = _arg_1;
            _value = _arg_2;
        }

        public function get type():int
        {
            return (_type);
        }

        public function set type(_arg_1:int):void
        {
            _type = _arg_1;
        }

        public function get value():Object
        {
            return (_value);
        }

        public function set value(_arg_1:Object):void
        {
            _value = _arg_1;
        }


    }
}//package com.adobe.serialization.json

