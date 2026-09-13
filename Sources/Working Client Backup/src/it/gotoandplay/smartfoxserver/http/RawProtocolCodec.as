// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.http.RawProtocolCodec

package it.gotoandplay.smartfoxserver.http
{
    public class RawProtocolCodec implements IHttpProtocolCodec 
    {

        private static const SESSION_ID_LEN:int = 32;


        public function encode(_arg_1:String, _arg_2:String):String
        {
            return (((_arg_1 == null) ? "" : _arg_1) + _arg_2);
        }

        public function decode(_arg_1:String):String
        {
            var _local_2:String;
            if (_arg_1.charAt(0) == HttpConnection.HANDSHAKE_TOKEN)
            {
                _local_2 = _arg_1.substr(1, SESSION_ID_LEN);
            };
            return (_local_2);
        }


    }
}//package it.gotoandplay.smartfoxserver.http

