// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.http.HttpConnection

package it.gotoandplay.smartfoxserver.http
{
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class HttpConnection extends EventDispatcher 
    {

        private static const HANDSHAKE:String = "connect";
        private static const DISCONNECT:String = "disconnect";
        private static const CONN_LOST:String = "ERR#01";
        public static const HANDSHAKE_TOKEN:String = "#";
        private static const servletUrl:String = "BlueBox/HttpBox.do";
        private static const paramName:String = "sfsHttp";

        private var sessionId:String;
        private var connected:Boolean = false;
        private var ipAddr:String;
        private var port:int;
        private var webUrl:String;
        private var urlLoaderFactory:LoaderFactory;
        private var urlRequest:URLRequest;
        private var codec:IHttpProtocolCodec;

        public function HttpConnection()
        {
            codec = new RawProtocolCodec();
            urlLoaderFactory = new LoaderFactory(handleResponse, handleIOError);
        }

        public function getSessionId():String
        {
            return (this.sessionId);
        }

        public function isConnected():Boolean
        {
            return (this.connected);
        }

        public function connect(_arg_1:String, _arg_2:int=8080):void
        {
            this.ipAddr = _arg_1;
            this.port = _arg_2;
            this.webUrl = ((((("https://" + this.ipAddr) + ":") + this.port) + "/") + servletUrl);
            this.sessionId = null;
            urlRequest = new URLRequest(webUrl);
            urlRequest.method = URLRequestMethod.POST;
            send(HANDSHAKE);
        }

        public function close():void
        {
            send(DISCONNECT);
        }

        public function send(_arg_1:String):void
        {
            var _local_2:URLVariables;
            var _local_3:URLLoader;
            if ((((connected) || ((!(connected)) && (_arg_1 == HANDSHAKE))) || ((!(connected)) && (_arg_1 == "poll"))))
            {
                _local_2 = new URLVariables();
                _local_2[paramName] = codec.encode(this.sessionId, _arg_1);
                urlRequest.data = _local_2;
                if (_arg_1 != "poll")
                {
                };
                _local_3 = urlLoaderFactory.getLoader();
                _local_3.data = _local_2;
                _local_3.load(urlRequest);
            };
        }

        private function handleResponse(_arg_1:Event):void
        {
            var _local_4:HttpEvent;
            var _local_2:URLLoader = (_arg_1.target as URLLoader);
            var _local_3:String = (_local_2.data as String);
            var _local_5:Object = {};
            if (_local_3.charAt(0) == HANDSHAKE_TOKEN)
            {
                if (sessionId == null)
                {
                    sessionId = codec.decode(_local_3);
                    connected = true;
                    _local_5.sessionId = this.sessionId;
                    _local_5.success = true;
                    _local_4 = new HttpEvent(HttpEvent.onHttpConnect, _local_5);
                    dispatchEvent(_local_4);
                };
            }
            else
            {
                if (_local_3.indexOf(CONN_LOST) == 0)
                {
                    _local_5.data = {};
                    _local_4 = new HttpEvent(HttpEvent.onHttpClose, _local_5);
                }
                else
                {
                    _local_5.data = _local_3;
                    _local_4 = new HttpEvent(HttpEvent.onHttpData, _local_5);
                };
                dispatchEvent(_local_4);
            };
        }

        private function handleIOError(_arg_1:IOErrorEvent):void
        {
            var _local_2:Object = {};
            _local_2.message = _arg_1.text;
            var _local_3:HttpEvent = new HttpEvent(HttpEvent.onHttpError, _local_2);
            dispatchEvent(_local_3);
        }


    }
}//package it.gotoandplay.smartfoxserver.http

