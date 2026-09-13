// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.mcDesignNotes

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.net.URLLoader;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.text.StyleSheet;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class mcDesignNotes extends MovieClip 
    {

        public var scrollTop:MovieClip;
        public var btnLeft:SimpleButton;
        public var btnClose:MovieClip;
        public var scrollBottom:MovieClip;
        public var btnRight:SimpleButton;
        public var txtContent:TextField;
        public var r:MovieClip;
        internal var loader:*;
        internal var dnLoader:URLLoader = new URLLoader();
        private var posts:Array;
        private var pos:Number = 0;
        private var bLoaded:Number = 0;
        private var bTotal:Number = 0;

        public function mcDesignNotes(_arg_1:MovieClip)
        {
            r = _arg_1;
            r.world.visible = false;
            loader = new ((r.world.getClass("mcLoader") as Class))();
            loader.x = 400;
            loader.y = 211;
            loader.name = "loader";
            this.addChild(loader);
            setupTF();
            loadDesignNotes();
            btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            btnLeft.addEventListener(MouseEvent.CLICK, onBtnMove, false, 0, true);
            btnRight.addEventListener(MouseEvent.CLICK, onBtnMove, false, 0, true);
        }

        public function onClose(_arg_1:MouseEvent):void
        {
            destroy();
        }

        public function onBtnMove(_arg_1:MouseEvent):void
        {
            if (_arg_1.target.name == "btnLeft")
            {
                pos--;
            }
            else
            {
                pos++;
            };
            if (pos < 0)
            {
                pos = (posts.length - 1);
            };
            if (pos >= posts.length)
            {
                pos = 0;
            };
            txtContent.htmlText = cleanup(posts[pos]);
        }

        public function destroy():void
        {
            r.world.visible = true;
            parent.removeChild(this);
        }

        public function loadDesignNotes():void
        {
            dnLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
            dnLoader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            dnLoader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            dnLoader.load(new URLRequest("https://www.aq.com/gamedesignnotes/"));
        }

        public function setupTF():void
        {
            var _local_1:StyleSheet = new StyleSheet();
            _local_1.parseCSS("img { display:block; margin-right: auto; margin-left: auto; } p { align:center; } strong { font-weight: bold; } a { color: #990000; font-size:16px; text-decoration:underline; } a:link { color:#f6a70c; } .date { font-weight:bold; font-size:12px; color: #444444; } h2 { font-weight:bold;font-size:24px; color: #222222; } h3 { font-weight:bold; color: #900000; font-size: 18px; }");
            txtContent.styleSheet = _local_1;
            txtContent.embedFonts = true;
            txtContent.condenseWhite = true;
            txtContent.multiline = true;
            txtContent.wordWrap = true;
        }

        public function onComplete(_arg_1:Event):void
        {
            var _local_2:String = _arg_1.target.data;
            posts = _local_2.match(/(?<=<div class='post pull-right'>)((.|\n)*)(?=<\/div><img src='\/img\/gfx\/divider-md.jpg' alt='divider')/igm);
            txtContent.htmlText = cleanup(posts[0]);
        }

        public function cleanup(_arg_1:String):String
        {
            var _local_2:* = /(?<=<h2>)((.|\n)*)(?=<\/h2>)/im;
            var _local_3:* = /(?<='>)((.|\n)*)(?=<\/a>)/im;
            var _local_4:* = /<\/?strong>/igm;
            _arg_1 = _arg_1.replace(_local_2, _arg_1.match(_local_2)[0].match(_local_3)[0]);
            return (_arg_1.replace(_local_4, ""));
        }

        public function onProgress(_arg_1:ProgressEvent):void
        {
            if (!loader)
            {
                return;
            };
            bLoaded = _arg_1.bytesLoaded;
            bTotal = _arg_1.bytesTotal;
            var _local_2:int = int(((bLoaded / bTotal) * 100));
            var _local_3:Number = (bLoaded / bTotal);
            loader.mcPct.text = (_local_2 + "%");
            if (bLoaded >= bTotal)
            {
                loader.parent.removeChild(loader);
                loader = null;
            };
        }

        public function onError(_arg_1:IOErrorEvent):void
        {
            destroy();
        }


    }
}//package liteAssets.draw

