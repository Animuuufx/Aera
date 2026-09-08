package
{

    import flash.display.MovieClip;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.system.ApplicationDomain;
    import flash.events.Event;
    import flash.display.Loader;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.events.ProgressEvent;
    import flash.text.TextField;
    import flash.utils.Dictionary;

    public dynamic class Main extends MovieClip
    {

        public var txtLoading:TextField;
        public var sFile:String;
        public var sTitle:String;
        public var sBG:String;
        public var sURL:String;
        public var loginURL:String;
        public var versionURL:String;
        public var sCharSelect:String;
        public var sLoadout:String;
        private var loader:URLLoader = new URLLoader();
        public var loaderVars:Object;
        public var game:*;

        private var contexts:Dictionary = new Dictionary();

        public function Main()
        {
            addFrameScript(0, frame1);
            txtLoading.mouseEnabled = false;

            contexts["title"] = new LoaderContext(true, new ApplicationDomain());
            contexts["title"].checkPolicyFile = false;
            contexts["title"].allowCodeImport = true;

            contexts["client"] = new LoaderContext(true, new ApplicationDomain());
            contexts["client"].checkPolicyFile = false;
            contexts["client"].allowCodeImport = true;
        }

        private function onLoadCheckCache(onComplete:Function, context:LoaderContext, file:String, onProgress:Function = null, onError:Function = null, customPath:Boolean = false):void {
            trace(customPath ? file : sURL + "gamefiles/" + file);
            var urlLoader:URLLoader = new URLLoader(new URLRequest(customPath ? file : sURL + "gamefiles/" + file));
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

            if (onComplete != null) {
                urlLoader.addEventListener(Event.COMPLETE, onLoadMaster(onComplete, context));
            }

            if (onProgress != null) {
                urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
            }

            if (onError != null) {
                urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            }
        }

        private function onLoadMaster(callback:Function, context:LoaderContext):Function {
            return function(event:Event):void {
                var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callback);
                loader.loadBytes(URLLoader(event.target).data, context);
            };
        }

        private function loadContent(sType:String, path:String, onComplete:Function):void {
            onLoadCheckCache(onComplete, contexts[sType], path, onProgress(sType), onError);
        }

        private function onProgress(sType:String):Function {
            return function(event:ProgressEvent):void {
                var loadingCount:int = int((event.bytesLoaded / event.bytesTotal) * 100);
                txtLoading.text = "Loading " + sType + " " + loadingCount + "%";
            };
        }

        public function loadTitle() : void
        {
            loadContent("title", "title/" + sBG, function (event:Event) : void {
                addChildAt(MovieClip(Loader(event.target.loader).content), 0);
                loadGameClient();
            });
        }

        public function loadGameClient() : void {
            loadContent("client", sFile, function (event:Event) : void {
                game = Object(Loader(event.target.loader).content).root;
                startGame();
            });
        }

        public function startGame():void
        {
            removeChildAt(0);

            var loader:* = stage;
            stage.removeChildAt(0);
            game = loader.addChild(game);
            game.params = {
                sTitle: sTitle,
                vars: loaderVars,
                sURL: sURL,
                sBG: sBG,
                loginURL: loginURL,
                sCharSelect: sCharSelect,
                sLoadout: sLoadout
            };
            game.titleDomain = contexts["title"].applicationDomain;

            loader.setChildIndex(game, 0);

            for (var parameter:String in root.loaderInfo.parameters) {
                game.params[parameter] = root.loaderInfo.parameters[parameter];
            }
        }

        public function onError(event:IOErrorEvent):void
        {
            trace(("Preloader IOError: " + event));
            txtLoading.text = "Connection error. Could not reach the Aera website.";
        }

        public function onSecurityError(event:SecurityErrorEvent):void
        {
            trace(("Preloader SecurityError: " + event));
            txtLoading.text = "Security/TLS error. Could not reach the Aera website.";
        }

        public function onDataComplete(event:Event):void
        {
            trace("onDataComplete:" + event.target.data);
            var o:Object = JSON.parse(event.target.data);
            sFile = o.sFile + "?ver=" + o.sVersion;
            sTitle = o.sTitle;
            sBG = o.sBG;
            sCharSelect = o.sCharSelect;
            sLoadout = o.sLoadout;
            loaderVars = o;

            loadTitle();
        }

        private function frame1() : void
        {
            sURL = "https://nightvaults.com/";
            loginURL = sURL + "api/game/login";
            versionURL = sURL + "api/game/version?ver=" + Math.random();
            trace(("versionURL: " + versionURL));
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onDataComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
            loader.load(new URLRequest(versionURL));
        }

    }
}//package Loader_Spider_fla
