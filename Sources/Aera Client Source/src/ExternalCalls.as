// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ExternalCalls

package 
{
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.navigateToURL;
    import flash.net.URLRequestMethod;

    public class ExternalCalls 
    {

        private var isWeb:Boolean = false;
        private var sourceID:String;
        private var isFBSource:Boolean = false;
        private var rootClass:MovieClip;
        private var conn:*;
        private var webCall:ExternalCallsWeb;

        public function ExternalCalls(_arg_1:Boolean, _arg_2:String, _arg_3:MovieClip)
        {
            isWeb = Game.ISWEB;
            sourceID = _arg_2;
            isFBSource = (sourceID == "FACEBOOK");
            rootClass = _arg_3;
            if (isWeb)
            {
                webCall = new ExternalCallsWeb(_arg_2, _arg_3);
            };
        }

        public function setGameObject(_arg_1:Object):void
        {
            if (isWeb)
            {
                webCall.setGameObject(_arg_1);
            };
        }

        public function showFeedDialog(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            if (!isFBSource)
            {
                return;
            };
            if (isWeb)
            {
                webCall.showFeedDialog(_arg_1, _arg_2, _arg_3);
            };
        }

        public function fbLogin():void
        {
            if (isWeb)
            {
                webCall.fbLogin();
            };
        }

        public function fbLoginWithPermissions():void
        {
            if (isWeb)
            {
                webCall.fbLoginWithPermissions();
            };
        }

        public function fbLogout():void
        {
            if (isWeb)
            {
                webCall.fbLogout();
            };
        }

        public function getFBUser():void
        {
            if (isWeb)
            {
                webCall.getFBUser();
            };
        }

        public function showIt(_arg_1:String):void
        {
            var _local_3:URLRequest;
            var _local_4:URLLoader;
            var _local_2:Boolean = isWeb;
            switch (_arg_1)
            {
                case "level10":
                    navigateToURL(new URLRequest("https://www.aq.com/aw-level10.asp"), "_blank");
                    _local_2 = false;
                    break;
                case "signup":
                    navigateToURL(new URLRequest(("https://www.aq.com/aw-welcome.asp?id=" + rootClass.world.myAvatar.objData.UserID)), "_blank");
                    _local_3 = new URLRequest((("https://www.aq.com/game/quest.asp?userid=" + rootClass.world.myAvatar.objData.UserID) + "&qvalue=1"));
                    _local_3.method = URLRequestMethod.GET;
                    _local_4 = new URLLoader();
                    _local_4.load(_local_3);
                    break;
                case "login":
                    break;
                default:
                    if (!isWeb)
                    {
                        navigateToURL(new URLRequest("https://www.aq.com/aextras/offers/"), "_blank");
                    };
            };
            if (webCall)
            {
                webCall.showIt(_arg_1);
            };
        }

        public function callJSFunction(_arg_1:String):void
        {
            if (isWeb)
            {
                webCall.callJSFunction(_arg_1);
            };
        }

        public function getQueryString():String
        {
            if (isWeb)
            {
                return (webCall.getQueryString());
            };
            return ("");
        }

        public function setToken(_arg_1:Object):void
        {
            if (isWeb)
            {
                webCall.setToken(_arg_1);
            };
        }

        public function setUpPayment(_arg_1:String):void
        {
            if (isWeb)
            {
                webCall.setUpPayment(_arg_1);
            }
            else
            {
                navigateToURL(new URLRequest("https://www.aq.com/order-now/direct/"), "_blank");
            };
        }

        public function logQuestProgress(uid:int, qsVal:String):void
        {
            var request:URLRequest;
            var loader:URLLoader;
            try
            {
                request = new URLRequest(((("https://www.aq.com/game/quest.asp?userid=" + rootClass.world.myAvatar.objData.UserID) + "&qvalue=") + qsVal));
                request.method = URLRequestMethod.GET;
                loader = new URLLoader();
                loader.load(request);
            }
            catch(e:Error)
            {
            };
        }

        public function getGroup():int
        {
            if (isWeb)
            {
                return (webCall.getGroup());
            };
            return (1);
        }


    }
}//package 

