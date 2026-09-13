// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.WildTangentAPI

package com.wildtangent
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.system.LoaderContext;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.system.SecurityDomain;
    import flash.net.URLVariables;
    import flash.net.URLRequestMethod;

    public class WildTangentAPI extends Sprite 
    {

        public var Ads:com.wildtangent.Ads = new com.wildtangent.Ads();
        public var BrandBoost:com.wildtangent.BrandBoost = new com.wildtangent.BrandBoost();
        public var Stats:com.wildtangent.Stats = new com.wildtangent.Stats();
        public var Vex:com.wildtangent.Vex = new com.wildtangent.Vex();
        protected var myVex:* = null;
        protected var _vexReady:Boolean = false;
        private var _dpName:String;
        private var _gameName:String;
        private var _adServerGameName:String;
        private var _partnerName:String;
        private var _siteName:String;
        private var _userId:String;
        private var _cipherKey:String;
        private var _vexUrl:String = "http://vex.wildtangent.com";
        private var _sandbox:Boolean = false;
        private var _javascriptReady:Boolean = false;
        private var _adComplete:Function;
        private var _closed:Function;
        private var _error:Function;
        private var _handlePromo:Function;
        private var _redeemCode:Function;
        private var _requireLogin:Function;
        private var _localMode:Boolean = false;
        protected var methodStorage:Array = [];

        public function WildTangentAPI()
        {
            addEventListener(Event.ADDED_TO_STAGE, loadVex);
        }

        private function loadVex(e:Event):void
        {
            var context:LoaderContext;
            var request:URLRequest;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAPI);
            try
            {
                _localMode = (loaderInfo.url.indexOf("file") == 0);
            }
            catch(e)
            {
            };
            if (!_localMode)
            {
                context = new LoaderContext();
                context.securityDomain = SecurityDomain.currentDomain;
                request = new URLRequest((_vexUrl + "/Vex/swf/VexAPI"));
                request.data = new URLVariables(("cache=" + new Date().time));
                request.method = URLRequestMethod.POST;
                loader.load(request, context);
            }
            else
            {
                loader.load(new URLRequest("VexAPI.swf"));
            };
        }

        private function loadAPI(_arg_1:Event):void
        {
            myVex = _arg_1.target.content;
            addChild(myVex);
            if (root.loaderInfo.parameters.canvasSize != null)
            {
                myVex.canvasSize = root.loaderInfo.parameters.canvasSize;
            };
            vexReady = true;
            myVex.loaderParameters = root.loaderInfo.parameters;
            myVex.localMode = _localMode;
            sendExistingParameters();
            initBrandBoost();
            initVex();
            initStats();
            initAds();
            dispatchEvent(_arg_1);
        }

        private function initBrandBoost():void
        {
            public::BrandBoost.myVex = myVex;
            public::BrandBoost.launchMethods();
            public::BrandBoost.sendExistingParameters();
        }

        private function initVex():void
        {
            public::Vex.myVex = myVex;
            public::Vex.launchMethods();
            public::Vex.sendExistingParameters();
        }

        private function initStats():void
        {
            public::Stats.myVex = myVex;
            public::Stats.launchMethods();
            public::Stats.sendExistingParameters();
        }

        private function initAds():void
        {
            public::Ads.myVex = myVex;
            public::Ads.launchMethods();
            public::Ads.sendExistingParameters();
        }

        private function sendExistingParameters():void
        {
            if (_dpName)
            {
                myVex.dpName = _dpName;
            };
            if (_gameName)
            {
                myVex.gameName = _gameName;
            };
            if (_adServerGameName)
            {
                myVex.adServerGameName = _adServerGameName;
            };
            if (_partnerName)
            {
                myVex.partnerName = _partnerName;
            };
            if (_siteName)
            {
                myVex.siteName = _siteName;
            };
            if (_userId)
            {
                myVex.userId = _userId;
            };
            if (_sandbox)
            {
                myVex.sandbox = _sandbox;
            };
            if (_cipherKey)
            {
                myVex.cipherKey = _cipherKey;
            };
            if (_adComplete != null)
            {
                myVex.adComplete = _adComplete;
            };
            if (_closed != null)
            {
                myVex.closed = _closed;
            };
            if (_error != null)
            {
                myVex.error = _error;
            };
            if (_redeemCode != null)
            {
                myVex.redeemCode = _redeemCode;
            };
        }

        private function set vexReady(_arg_1:Boolean):void
        {
            public::BrandBoost.vexReady = _arg_1;
            public::Ads.vexReady = _arg_1;
            public::Stats.vexReady = _arg_1;
            public::Vex.vexReady = _arg_1;
            _vexReady = _arg_1;
        }

        private function get vexReady():Boolean
        {
            return (_vexReady);
        }

        private function set javascriptReady(_arg_1:Boolean):void
        {
            if (vexReady)
            {
                myVex.javascriptReady = _arg_1;
            }
            else
            {
                _javascriptReady = _arg_1;
            };
        }

        public function get userId():String
        {
            return ((vexReady) ? myVex.userId : _userId);
        }

        public function set userId(_arg_1:String):void
        {
            if (vexReady)
            {
                myVex.userId = _arg_1;
            }
            else
            {
                _userId = _arg_1;
            };
        }

        public function set partnerName(_arg_1:String):void
        {
            if (vexReady)
            {
                myVex.partnerName = _arg_1;
            }
            else
            {
                _partnerName = _arg_1;
            };
        }

        public function get partnerName():String
        {
            return ((vexReady) ? myVex.partnerName : _partnerName);
        }

        public function set siteName(_arg_1:String):void
        {
            if (vexReady)
            {
                myVex.siteName = _arg_1;
            }
            else
            {
                _siteName = _arg_1;
            };
        }

        public function get siteName():String
        {
            return ((vexReady) ? myVex.siteName : _siteName);
        }

        public function set gameName(_arg_1:String):void
        {
            if (vexReady)
            {
                myVex.gameName = _arg_1;
            }
            else
            {
                _gameName = _arg_1;
            };
        }

        public function get gameName():String
        {
            return ((vexReady) ? myVex.gameName : _gameName);
        }

        public function set adServerGameName(_arg_1:String):void
        {
            if (vexReady)
            {
                myVex.adServerGameName = _arg_1;
            }
            else
            {
                _adServerGameName = _arg_1;
            };
        }

        public function set dpName(_arg_1:String):void
        {
            if (vexReady)
            {
                myVex.dpName = _arg_1;
            }
            else
            {
                _dpName = _arg_1;
            };
        }

        public function get dpName():String
        {
            return ((vexReady) ? myVex.dpName : _dpName);
        }

        public function set sandbox(_arg_1:Boolean):void
        {
            _vexUrl = ((_arg_1) ? "http://vex.bpi.wildtangent.com" : "http://vex.wildtangent.com");
            _sandbox = _arg_1;
        }

        public function get VERSION():String
        {
            return ((vexReady) ? myVex.VERSION : "Not yet loaded");
        }


    }
}//package com.wildtangent

