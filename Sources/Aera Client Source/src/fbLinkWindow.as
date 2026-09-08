// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fbLinkWindow

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLRequestMethod;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.navigateToURL;
    import flash.net.*;

    public class fbLinkWindow extends MovieClip 
    {

        private var mcFB:MovieClip;
        private var rootClass:MovieClip;

        public function fbLinkWindow(_arg_1:MovieClip, _arg_2:MovieClip)
        {
            mcFB = _arg_1;
            rootClass = _arg_2;
            mcFB.strPassword.tabIndex = 1;
            this.mcFB.btnFBLink.addEventListener(MouseEvent.CLICK, onLinkClick, false, 0, true);
            this.mcFB.btnFBCreate.addEventListener(MouseEvent.CLICK, onCreateClick, false, 0, true);
            this.mcFB.btnClose.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
            mcFB.visible = (rootClass.showFB = true);
        }

        private function onLinkClick(e:MouseEvent):void
        {
            rootClass.mcConnDetail.showConn("Authenticating Account Info...");
            var rand:Number = rootClass.rand();
            var url:String = ("cf-userlogin.asp?ran=" + rand);
            if ((((rootClass.loaderInfo.url.toLowerCase().indexOf("file://") >= 0) || (rootClass.loaderInfo.url.toLowerCase().indexOf("cdn.aq.com") >= 0)) || (rootClass.loaderInfo.url.toLowerCase().indexOf("aqworldscdn.aq.com") >= 0)))
            {
                url = ("https://www.aq.com/game/" + url);
            }
            else
            {
                url = ((rootClass.params.loginURL + "?ran=") + rand);
            };
            var request:URLRequest = new URLRequest(url);
            var variables:URLVariables = new URLVariables();
            variables.fbid = FacebookConnect.Me.id;
            variables.fbtoken = FacebookConnect.AccessToken;
            variables.doLink = "true";
            variables.user = mcFB.strUsername.text;
            variables.pass = mcFB.strPassword.text;
            request.data = variables;
            request.method = URLRequestMethod.POST;
            rootClass.loginLoader.removeEventListener(Event.COMPLETE, rootClass.onLoginComplete);
            rootClass.loginLoader.addEventListener(Event.COMPLETE, rootClass.onLoginComplete);
            rootClass.loginLoader.addEventListener(IOErrorEvent.IO_ERROR, rootClass.onLoginError, false, 0, true);
                    rootClass.loginLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, rootClass.onLoginError, false, 0, true);
            try
            {
                rootClass.loginLoader.load(request);
            }
            catch(error:Error)
            {
            };
        }

        private function onCreateClick(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://www.aq.com/landing/"), "_blank");
        }

        public function destroy(_arg_1:MouseEvent=null):void
        {
            this.mcFB.btnFBLink.removeEventListener(MouseEvent.CLICK, onLinkClick);
            this.mcFB.btnFBCreate.removeEventListener(MouseEvent.CLICK, onCreateClick);
            this.mcFB.btnClose.removeEventListener(MouseEvent.CLICK, destroy);
            mcFB.visible = (rootClass.showFB = false);
            rootClass.fbL = null;
        }


    }
}//package 

