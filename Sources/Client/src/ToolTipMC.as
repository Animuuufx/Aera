// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ToolTipMC

package 
{
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.text.*;

    public class ToolTipMC extends MovieClip 
    {

        public var cnt:MovieClip;
        internal var world:MovieClip;
        internal var isOpen:Boolean = false;
        internal var mc:MovieClip;
        internal var rootClass:MovieClip;
        internal var data:Object;
        internal var tWidth:int;
        private var neutralCT:ColorTransform = new ColorTransform();
        private var blackCT:ColorTransform = new ColorTransform(0, 0, 0);
        public var tOpen:Timer = new Timer(200, 1);
        public var tClose:Timer = new Timer(10000, 1);

        public function ToolTipMC(_arg_1:MovieClip=null)
        {
            addFrameScript(0, frame1, 9, frame10);
            mc = MovieClip(this);
            rootClass = ((_arg_1) ? _arg_1 : MovieClip(stage.getChildAt(0)));
            world = rootClass.world;
            mc.cnt.visible = false;
            mc.cnt.ti.autoSize = "left";
            tWidth = mc.cnt.ti.width;
            mc.mouseEnabled = false;
            mc.mouseChildren = false;
            tOpen.addEventListener(TimerEvent.TIMER_COMPLETE, open, false, 0, true);
            tClose.addEventListener(TimerEvent.TIMER_COMPLETE, close, false, 0, true);
            addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
            addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
            mc.cnt.ti.addEventListener(TextEvent.LINK, onTextLink, false, 0, true);
        }

        public function openWith(_arg_1:*):*
        {
            data = _arg_1;
            tOpen.reset();
            tOpen.start();
            if (("closein" in data))
            {
                tClose.reset();
                tClose.delay = int(data.closein);
                tClose.start();
            };
        }

        public function open(_arg_1:TimerEvent):*
        {
            isOpen = true;
            mc.cnt.visible = true;
            mc.cnt.ti.width = tWidth;
            mc.cnt.ti.htmlText = data.str;
            mc.cnt.ti.width = (int(mc.cnt.ti.textWidth) + 6);
            mc.cnt.bg.width = (int(mc.cnt.ti.width) + 10);
            mc.cnt.bg.height = (int(mc.cnt.ti.height) + 8);
            if ((("invert" in data) && (data.invert)))
            {
                mc.cnt.bg.transform.colorTransform = blackCT;
            }
            else
            {
                mc.cnt.bg.transform.colorTransform = neutralCT;
            };
            if (("lowerright" in data))
            {
                mc.x = ((960 - mc.cnt.bg.width) - 4);
                mc.y = ((480 - mc.cnt.bg.height) - 4);
            }
            else
            {
                if ((("fromlocal" in data) && (data.fromlocal)))
                {
                    mc.x = (data.fromlocal.x - (mc.width / 2));
                    mc.y = ((data.fromlocal.y - mc.height) - 15);
                }
                else
                {
                    mc.x = ((rootClass.mouseX - (mc.width / 2)) - rootClass.ui.x);
                    mc.y = ((rootClass.mouseY - mc.height) - 15);
                    if ((mc.x + mc.cnt.bg.width) > 960)
                    {
                        mc.x = ((960 - mc.cnt.bg.width) - 10);
                    };
                    if (mc.x < 1)
                    {
                        mc.x = 1;
                    };
                    if (mc.y < 1)
                    {
                        mc.y = (rootClass.mouseY + 10);
                    };
                };
            };
            if (data.str.indexOf("href") > -1)
            {
                mc.mouseEnabled = false;
                mc.mouseChildren = true;
            }
            else
            {
                mc.mouseEnabled = false;
                mc.mouseChildren = false;
            };
            if ((("frommap" in data) && (data.frommap)))
            {
                mc.x = data.x;
                mc.y = data.y;
            }
            else
            {
                mc.x = int(mc.x);
                mc.y = int(mc.y);
            };
            mc.gotoAndPlay("in");
        }

        private function onTextLink(_arg_1:TextEvent):void
        {
            var _local_2:String = String(_arg_1.text.split("::")[0]).toLowerCase();
            if (_local_2 == "link")
            {
                navigateToURL(new URLRequest(_arg_1.text.split("::")[1]), "_blank");
            };
        }

        public function close(_arg_1:Event=null):*
        {
            isOpen = false;
            tOpen.reset();
            tClose.reset();
            mc.gotoAndPlay("out");
        }

        public function hide():*
        {
            mc.cnt.visible = false;
            mc.x = 1050;
            mc.y = 0;
        }

        private function onMouseOut(_arg_1:MouseEvent):void
        {
            if (tOpen.running)
            {
                tOpen.stop();
            };
            if (tClose.running)
            {
                tClose.stop();
            };
            close();
        }

        private function onMouseOver(_arg_1:MouseEvent):void
        {
            tClose.reset();
        }

        internal function frame1():*
        {
            hide();
            stop();
        }

        internal function frame10():*
        {
            stop();
        }


    }
}//package 

