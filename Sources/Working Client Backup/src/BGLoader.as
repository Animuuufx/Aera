// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//BGLoader

package 
{
    import flash.display.MovieClip;
    import flash.net.URLVariables;
    import flash.events.Event;
    import flash.display.Loader;
    import flash.system.ApplicationDomain;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;

    public class BGLoader 
    {

        internal static var mcLogin:MovieClip;
        internal static var sUrl:String;
        internal static var sTitle:String = "";


        public static function LoadBG(_arg_1:String, _arg_2:MovieClip, _arg_3:String, _arg_4:String):void
        {
            mcLogin = _arg_2;
            if (_arg_1.indexOf("file:") > -1)
            {
                sUrl = "https://content.aq.com/game/";
            }
            else
            {
                sUrl = _arg_1;
            };
            sTitle = _arg_4;
            loadTitle(_arg_3);
        }

        internal static function onDataComplete(_arg_1:Event):void
        {
            var _local_2:URLVariables = new URLVariables(_arg_1.target.data);
            if (_local_2.status == "success")
            {
                loadTitle(_local_2.sBG);
            };
        }

        internal static function loadTitle(_arg_1:String):void
        {
            var _local_3:Loader;
            var _local_2:ApplicationDomain = new ApplicationDomain();
            if (_arg_1 != null)
            {
                _local_3 = new Loader();
                _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onTitleComplete);
                _local_3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
                _local_3.load(new URLRequest(((sUrl + "gamefiles/title/") + _arg_1)), new LoaderContext(false, _local_2));
            }
            else
            {
                Game.root["mcLogin"].gotoAndStop("GetLauncher");
            };
        }

        internal static function onTitleComplete(_arg_1:Event):void
        {
            var _local_2:MovieClip;
            if (((mcLogin == null) || (_arg_1 == null) || (_arg_1.target == null)))
            {
                return;
            }
            try
            {
                _local_2 = MovieClip(Loader(_arg_1.target.loader).content);
                while (mcLogin.mcTitle.numChildren > 0)
                {
                    mcLogin.mcTitle.removeChildAt(0);
                }
                mcLogin.mcTitle.addChild(_local_2);
                mcLogin.mcLogo.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + sTitle);
            }
            catch(e:Error)
            {
            }
            mcLogin = null;
        }

        internal static function onError(_arg_1:IOErrorEvent):*
        {
            try
            {
                if (((mcLogin != null) && (mcLogin.mcLogo != null) && (mcLogin.mcLogo.txtTitle != null)))
                {
                    mcLogin.mcLogo.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + sTitle);
                }
            }
            catch(e:Error)
            {
            }
            mcLogin = null;
        }


    }
}//package 

