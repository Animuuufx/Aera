// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.adobe.utils.StringUtil

package com.adobe.utils
{
    public class StringUtil 
    {


        public static function stringsAreEqual(_arg_1:String, _arg_2:String, _arg_3:Boolean):Boolean
        {
            if (_arg_3)
            {
                return (_arg_1 == _arg_2);
            };
            return (_arg_1.toUpperCase() == _arg_2.toUpperCase());
        }

        public static function trim(_arg_1:String):String
        {
            return (StringUtil.ltrim(StringUtil.rtrim(_arg_1)));
        }

        public static function ltrim(_arg_1:String):String
        {
            var _local_2:Number = _arg_1.length;
            var _local_3:Number = 0;
            while (_local_3 < _local_2)
            {
                if (_arg_1.charCodeAt(_local_3) > 32)
                {
                    return (_arg_1.substring(_local_3));
                };
                _local_3++;
            };
            return ("");
        }

        public static function rtrim(_arg_1:String):String
        {
            var _local_2:Number = _arg_1.length;
            var _local_3:Number = _local_2;
            while (_local_3 > 0)
            {
                if (_arg_1.charCodeAt((_local_3 - 1)) > 32)
                {
                    return (_arg_1.substring(0, _local_3));
                };
                _local_3--;
            };
            return ("");
        }

        public static function beginsWith(_arg_1:String, _arg_2:String):Boolean
        {
            return (_arg_2 == _arg_1.substring(0, _arg_2.length));
        }

        public static function endsWith(_arg_1:String, _arg_2:String):Boolean
        {
            return (_arg_2 == _arg_1.substring((_arg_1.length - _arg_2.length)));
        }

        public static function remove(_arg_1:String, _arg_2:String):String
        {
            return (StringUtil.replace(_arg_1, _arg_2, ""));
        }

        public static function replace(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            var _local_9:Number;
            var _local_4:String = new String();
            var _local_5:Boolean;
            var _local_6:Number = _arg_1.length;
            var _local_7:Number = _arg_2.length;
            var _local_8:Number = 0;
            for (;_local_8 < _local_6;_local_8++)
            {
                if (_arg_1.charAt(_local_8) == _arg_2.charAt(0))
                {
                    _local_5 = true;
                    _local_9 = 0;
                    while (_local_9 < _local_7)
                    {
                        if (_arg_1.charAt((_local_8 + _local_9)) != _arg_2.charAt(_local_9))
                        {
                            _local_5 = false;
                            break;
                        };
                        _local_9++;
                    };
                    if (_local_5)
                    {
                        _local_4 = (_local_4 + _arg_3);
                        _local_8 = (_local_8 + (_local_7 - 1));
                        continue;
                    };
                };
                _local_4 = (_local_4 + _arg_1.charAt(_local_8));
            };
            return (_local_4);
        }


    }
}//package com.adobe.utils

