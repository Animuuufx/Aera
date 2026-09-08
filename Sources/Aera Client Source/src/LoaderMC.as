// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LoaderMC

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.*;

    public class LoaderMC extends MovieClip 
    {

        public var mcPct:TextField;
        public var btnCancel:SimpleButton;
        public var strLoad:TextField;
        internal var mcDest:MovieClip;
        internal var isEvent:Boolean = false;
        private var rootClass:Game;
        public var history:Object = {};
        private var _file:String;

        public function LoaderMC(rootClassMC:Game)
        {
            btnCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
            rootClass = rootClassMC;
        }

        public function loadFile(mcDestination:MovieClip, strFilename:String, strDescription:String, isEvt:Boolean=false):void
        {
            _file = strFilename;
            var now:Number = new Date().getTime();

            var assetsDomain:ApplicationDomain = new ApplicationDomain();
            var assetsContext:LoaderContext = new LoaderContext(false, assetsDomain);
            assetsContext.checkPolicyFile = false;
            assetsContext.allowCodeImport = true;

            isEvent = isEvt;
            if (strDescription != "Inline Asset")
            {
                MovieClip(Game.root).addChild(this);
            }
            mcDest = mcDestination;

            rootClass.onLoadMaster(onFileLoadComplete, assetsContext, strFilename, onFileLoadProgress);
        }

        private function onFileLoadComplete(evt:Event):void
        {
            var s:String;
            var o:Object;
            var world:* = rootClass.world;
            var ldr:Loader = Loader(evt.target.loader);
            try
            {
                for each (s in history)
                {
                    if (history[s].ldr == ldr)
                    {
                        delete history[s];
                    }
                }
            }
            catch(e:Error)
            {
            }
            ldr.removeEventListener(Event.COMPLETE, onFileLoadComplete);
            ldr.removeEventListener(ProgressEvent.PROGRESS, onFileLoadProgress);
            var swf:* = MovieClip(ldr.content);
            mcDest.addChild(swf);
            if (((isEvent) && ("eventTrigger" in world.map)))
            {
                o = {
                    "cmd":"fileLoaded",
                    "args":{"loc":"default"}
                };
                world.map.eventTrigger(o);
            }
            mcDest = null;
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e:Error)
            {
            }
        }

        private function onFileLoadProgress(_arg_1:ProgressEvent):void
        {
            var _local_2:int = int(Math.floor(((_arg_1.bytesLoaded / _arg_1.bytesTotal) * 100)));
            if (_arg_1.bytesTotal <= 0)
            {
                _local_2 = 0;
            };
            strLoad.text = "Loading!";
            mcPct.text = (_local_2 + "%");
        }

        public function closeHistory():void
        {
            var _local_1:String;
            for each (_local_1 in history)
            {
                try
                {
                    history[_local_1].ldr.close();
                }
                catch(e:Error)
                {
                };
                delete history[_local_1];
            };
            history = {};
        }

        private function onCancelClick(_arg_1:MouseEvent):void
        {
            MovieClip(Game.root).logout();
            MovieClip(parent).removeChild(this);
        }


    }
}//package 

