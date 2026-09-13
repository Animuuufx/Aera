// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.adobe.serialization.json.JSON

package com.adobe.serialization.json
{
    public class JSON 
    {


        public static function encode(_arg_1:Object):String
        {
            var _local_2:JSONEncoder = new JSONEncoder(_arg_1);
            return (_local_2.getString());
        }

        public static function decode(_arg_1:String):*
        {
            var _local_2:JSONDecoder = new JSONDecoder(_arg_1);
            return (_local_2.getValue());
        }


    }
}//package com.adobe.serialization.json

