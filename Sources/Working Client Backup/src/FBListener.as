// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//FBListener

package 
{
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.system.Security;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.external.ExternalInterface;
    import flash.net.URLRequestMethod;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.external.*;

    public class FBListener 
    {

        private var rootClass:MovieClip;
        private var fbID:Number = 0;
        private var strToken:String;
        private var fbName:String;
        private var fbEmail:String;
        private var fbIP:String;
        private var imgURL:String;
        private var fbImg:Bitmap;
        private var fbDOB:String;
        private var imgLoader:Loader = new Loader();
        private var imgLoaded:Boolean = false;

        public function FBListener(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            Security.allowDomain("fbcdn-profile-a.akamaihd.net");
            Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
        }

        public function consoleLog(_arg_1:String):void
        {
        }

        public function handleFBEvent(cmd:String, fbData:*):*
        {
            var tokens:Array;
            var rand:Number;
            var url:String;
            var request:URLRequest;
            var variables:URLVariables;
            consoleLog(("fb callback received, cmd: " + cmd));
            switch (cmd)
            {
                case "linkAccount":
                    if (rootClass.params.FBID)
                    {
                        ExternalInterface.call("GetCurrentUser");
                    };
                    return;
                case "GetCurrentUserComplete":
                    consoleLog(("FBData::::::::>>>>> " + fbData));
                    tokens = fbData.split(",");
                    fbID = Number(tokens[0]);
                    fbName = tokens[1];
                    fbEmail = tokens[2];
                    strToken = tokens[4];
                    fbIP = tokens[5];
                    consoleLog(((((((((("HANDLE FB EVENT USER DATA:   fbID: " + fbID) + " strToken: ") + strToken) + " fbName: ") + fbName) + " fbEMail: ") + fbEmail) + " fbIP: ") + fbIP));
                    try
                    {
                        if ((((fbID > 0) && (!(rootClass.sfc == null))) && (!(strToken == null))))
                        {
                            consoleLog("!!   fb sfc sendxt   !!");
                            rootClass.sfc.sendXtMessage("zm", "fbCmd", ["linkAccount", fbID, fbName, fbEmail, fbIP], "str", 1);
                        };
                        if (rootClass.mcO != null)
                        {
                            rootClass.mcO.checkFBStatus();
                        };
                    }
                    catch(e:Error)
                    {
                        consoleLog("Something null happened");
                    };
                    FacebookConnect.Me = new Object();
                    FacebookConnect.Me.id = fbID;
                    FacebookConnect.Me.name = fbName;
                    FacebookConnect.Me.email = fbEmail;
                    try
                    {
                        FacebookConnect.Me.birthday = tokens[3];
                    }
                    catch(e:Error)
                    {
                        FacebookConnect.Me.birthday = "5/5/2001";
                        consoleLog("Facebook Birthday is undefined");
                    };
                    if (fbID)
                    {
                        FacebookConnect.isLoggedIn = true;
                        if (rootClass.FBConnectCallback != null)
                        {
                            consoleLog("======> FBConnectCallback <======");
                            rootClass.FBConnectCallback();
                            rootClass.FBConnectCallback = null;
                        };
                    };
                    return;
                case "GetCurrentUserLogin":
                    tokens = fbData.split(",");
                    fbID = Number(tokens[0]);
                    fbName = tokens[1];
                    fbEmail = tokens[2];
                    fbDOB = tokens[3];
                    strToken = tokens[4];
                    fbIP = tokens[5];
                    imgURL = tokens[6];
                    FacebookConnect.isLoggedIn = true;
                    FacebookConnect.Me = new Object();
                    FacebookConnect.Me.id = fbID;
                    FacebookConnect.Me.name = fbName;
                    FacebookConnect.Me.email = fbEmail;
                    try
                    {
                        FacebookConnect.Me.birthday = tokens[3];
                    }
                    catch(e:Error)
                    {
                        FacebookConnect.Me.birthday = "5/5/2001";
                        consoleLog("Facebook Birthday is undefined");
                    };
                    if (rootClass.FBConnectCallback != null)
                    {
                        consoleLog("======> FBConnectCallback <======");
                        rootClass.FBConnectCallback();
                        rootClass.FBConnectCallback = null;
                    };
                    return;
                case "fbLogin":
                    if (fbData.indexOf("status:undefined") > -1)
                    {
                        return;
                    };
                    tokens = fbData.split(";");
                    fbID = Number(tokens[1].split(":")[1]);
                    strToken = String(tokens[2].split(":")[1]);
                    consoleLog(("fbLogin received = fbData = " + fbData));
                    if (fbID < 1) break;
                    ExternalInterface.call("GetCurrentUserLogin");
                    rootClass.mcConnDetail.showConn("Authenticating Account Info...");
                    rand = rootClass.rand();
                    url = ("cf-userlogin.asp?ran=" + rand);
                    if ((((rootClass.loaderInfo.url.toLowerCase().indexOf("file://") >= 0) || (rootClass.loaderInfo.url.toLowerCase().indexOf("cdn.aq.com") >= 0)) || (rootClass.loaderInfo.url.toLowerCase().indexOf("aqworldscdn.aq.com") >= 0)))
                    {
                        url = ("https://www.aq.com/game/" + url);
                    }
                    else
                    {
                        url = ((rootClass.params.loginURL + "?ran=") + rand);
                    };
                    request = new URLRequest(url);
                    variables = new URLVariables();
                    variables.fbid = fbID;
                    variables.fbtoken = strToken;
                    request.data = variables;
                    request.method = URLRequestMethod.POST;
                    FacebookConnect.isLoggedIn = true;
                    FacebookConnect.AccessToken = strToken;
                    FacebookConnect.SaveToken();
                    rootClass.loginLoader.removeEventListener(Event.COMPLETE, rootClass.onLoginComplete);
                    rootClass.loginLoader.addEventListener(Event.COMPLETE, rootClass.onLoginComplete);
                    rootClass.loginLoader.addEventListener(IOErrorEvent.IO_ERROR, rootClass.onLoginError, false, 0, true);
                    try
                    {
                        rootClass.loginLoader.load(request);
                    }
                    catch(error:Error)
                    {
                        consoleLog("Unable to load URL");
                    };
                    return;
                case "Logout":
                    fbID = 0;
                    strToken = "";
                    FacebookConnect.ClearToken();
                    if (rootClass.mcO != null)
                    {
                        rootClass.mcO.checkFBStatus();
                    };
                    return;
            };
        }

        private function imgComplete(_arg_1:Event):void
        {
            fbImg = Bitmap(_arg_1.target.content);
            fbImg.width = 62;
            fbImg.height = 60;
            imgLoaded = true;
        }

        private function imgError(_arg_1:IOErrorEvent):void
        {
        }

        public function handleEvent(_arg_1:Array):void
        {
            switch (_arg_1[2])
            {
                case "Link":
                    if (_arg_1[3] == "false")
                    {
                        ExternalInterface.call("fbLogout", "Logout");
                    };
                    return;
                case "unlink":
                    if (_arg_1[3] == "true")
                    {
                        ExternalInterface.call("fbLogout", "Logout");
                        fbID = 0;
                    };
                    if (rootClass.mcO != null)
                    {
                        rootClass.mcO.checkFBStatus();
                        rootClass.mcO.closeUnlink();
                    };
                    return;
            };
        }

        public function doFBLogin(ID:Number, Token:String):*
        {
            fbID = ID;
            strToken = Token;
            if (fbID < 1)
            {
                return;
            };
            ExternalInterface.call("GetCurrentUserLogin");
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
            variables.fbid = fbID;
            variables.fbtoken = strToken;
            request.data = variables;
            request.method = URLRequestMethod.POST;
            rootClass.loginLoader.removeEventListener(Event.COMPLETE, rootClass.onLoginComplete);
            rootClass.loginLoader.addEventListener(Event.COMPLETE, rootClass.onLoginComplete);
            rootClass.loginLoader.addEventListener(IOErrorEvent.IO_ERROR, rootClass.onLoginError, false, 0, true);
            try
            {
                rootClass.loginLoader.load(request);
            }
            catch(error:Error)
            {
                consoleLog("Unable to load URL");
            };
        }

        public function fbLogout():void
        {
            fbID = 0;
            strToken = "";
        }

        public function logoutFromFB():void
        {
            ExternalInterface.call("fbLogout", "Logout");
        }

        public function get isLoggedIn():Boolean
        {
            return (fbID > 0);
        }

        public function get ID():Number
        {
            return (fbID);
        }

        public function get Token():String
        {
            return (strToken);
        }

        public function get Loaded():Boolean
        {
            return (imgLoaded);
        }

        public function get FBImage():Bitmap
        {
            return (fbImg);
        }

        public function get Name():String
        {
            return (fbName);
        }


    }
}//package 

