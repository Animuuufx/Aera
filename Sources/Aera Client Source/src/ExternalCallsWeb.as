// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ExternalCallsWeb

package 
{
    import flash.display.MovieClip;
    import flash.external.ExternalInterface;

    public class ExternalCallsWeb 
    {

        private var sourceID:String;
        private var isFBSource:Boolean = false;
        private var rootClass:MovieClip;
        private var conn:*;

        public function ExternalCallsWeb(_arg_1:String, _arg_2:MovieClip)
        {
            sourceID = _arg_1;
            isFBSource = (sourceID == "FACEBOOK");
            rootClass = _arg_2;
            DiscordPresence.watchGame(rootClass);
            conn = ExternalInterface.addCallback("SendMessage", rootClass.FBMessage);
        }

        public function setGameObject(_arg_1:Object):void
        {
            DiscordPresence.watchGame(rootClass);
            ExternalInterface.call("setGameObject", _arg_1);
        }

        public function showFeedDialog(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            if (!isFBSource)
            {
                return;
            };
            ExternalInterface.call("showFeedDialog", _arg_1, _arg_2, _arg_3);
        }

        public function fbLogin():void
        {
            ExternalInterface.call("fbLoginNoAuth", "email,publish_actions", "fbLogin");
        }

        public function fbLoginWithPermissions():void
        {
            ExternalInterface.call("fbLoginWithPermissions", "email,publish_actions", "linkAccount");
        }

        public function fbLogout():void
        {
            ExternalInterface.call("fbLogout", "Logout");
        }

        public function getFBUser():void
        {
            if (!rootClass.params.FBID)
            {
                return;
            };
            ExternalInterface.call("GetCurrentUser");
        }

        public function showIt(_arg_1:String):void
        {
            var _local_2:* = "none";
            ExternalInterface.call("showIt", _arg_1, rootClass.world.myAvatar.objData.iAge, rootClass.world.myAvatar.objData.UserID, _local_2, rootClass.world.myAvatar.isUpgraded());
        }

        public function callJSFunction(_arg_1:String):void
        {
            ExternalInterface.call(_arg_1);
        }

        public function getQueryString():String
        {
            return (ExternalInterface.call("window.location.search.substring", 1));
        }

        public function setToken(_arg_1:Object):void
        {
            ExternalInterface.call("setToken", _arg_1.strToken);
        }

        public function setUpPayment(_arg_1:String):void
        {
            ExternalInterface.call("setUpPayment", rootClass.world.myAvatar.objData.CharID, _arg_1, "");
        }

        public function logQuestProgress(_arg_1:int, _arg_2:String):void
        {
            ExternalInterface.call("logQuestProgress", _arg_1, _arg_2);
        }

        public function getGroup():int
        {
            return (ExternalInterface.call("getGroup"));
        }


    }
}//package 

