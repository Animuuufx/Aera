// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.http.LoaderFactory

package it.gotoandplay.smartfoxserver.http
{
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class LoaderFactory 
    {

        private static const DEFAULT_POOL_SIZE:int = 8;

        private var loadersPool:Array;
        private var currentLoaderIndex:int;

        public function LoaderFactory(_arg_1:Function, _arg_2:Function, _arg_3:int=8)
        {
            var _local_5:URLLoader;
            super();
            loadersPool = [];
            var _local_4:int;
            while (_local_4 < _arg_3)
            {
                _local_5 = new URLLoader();
                _local_5.dataFormat = URLLoaderDataFormat.TEXT;
                _local_5.addEventListener(Event.COMPLETE, _arg_1);
                _local_5.addEventListener(IOErrorEvent.IO_ERROR, _arg_2);
                _local_5.addEventListener(IOErrorEvent.NETWORK_ERROR, _arg_2);
                loadersPool.push(_local_5);
                _local_4++;
            };
            currentLoaderIndex = 0;
        }

        public function getLoader():URLLoader
        {
            var _local_1:URLLoader = loadersPool[currentLoaderIndex];
            currentLoaderIndex++;
            if (currentLoaderIndex >= loadersPool.length)
            {
                currentLoaderIndex = 0;
            };
            return (_local_1);
        }


    }
}//package it.gotoandplay.smartfoxserver.http

