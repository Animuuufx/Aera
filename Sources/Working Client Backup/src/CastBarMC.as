// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//CastBarMC

package 
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.text.*;

    public class CastBarMC extends MovieClip 
    {

        public var cnt:MovieClip;
        public var o:Object = null;
        public var isOpen:Boolean = false;
        public var callback:Object = null;
        public var state:int = -1;
        public var dur:int = 1000;
        private var world:MovieClip;
        private var rootClass:MovieClip;
        private var mc:MovieClip;
        private var run:int;
        private var ts:Number;
        private var date:Date;

        public function CastBarMC():void
        {
            addFrameScript(0, frame1, 4, frame5, 5, frame6, 9, frame10);
        }

        public function init():void
        {
            mc = MovieClip(this);
            rootClass = MovieClip(stage.getChildAt(0));
        }

        public function fOpenWith(_arg_1:*):void
        {
            var _local_2:*;
            var _local_3:*;
            o = _arg_1;
            isOpen = true;
            switch (o.typ)
            {
                case "sia":
                    state = o.args.ID;
                case "generic":
                    mc.cnt.t1.text = o.txt;
                    _local_2 = mc.cnt.fill;
                    _local_3 = mc.cnt.fillMask;
                    _local_3.x = int((_local_2.x - _local_3.width));
                    run = int((_local_2.x - _local_3.x));
                    date = new Date();
                    ts = Number(date.getTime());
                    dur = int((1000 * o.dur));
                    _local_3.removeEventListener(Event.ENTER_FRAME, slide);
                    _local_3.addEventListener(Event.ENTER_FRAME, slide);
                    mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                    mc.cnt.tip.addEventListener(Event.ENTER_FRAME, tipFollow);
                    mc.gotoAndPlay("in");
                    return;
            };
        }

        public function fClose():void
        {
            var _local_1:*;
            if (isOpen)
            {
                o = null;
                state = -1;
                isOpen = false;
                _local_1 = mc.cnt.fillMask;
                _local_1.removeEventListener(Event.ENTER_FRAME, slide);
                mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                mc.gotoAndPlay("out");
                rootClass.world.myAvatar.pMC.endAction();
            };
        }

        private function slide(_arg_1:Event):void
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            date = new Date();
            var _local_3:* = (date.getTime() - ts);
            var _local_4:* = (_local_3 / dur);
            if (_local_4 >= 1)
            {
                mc.gotoAndPlay("out");
                _local_2.removeEventListener(Event.ENTER_FRAME, slide);
                mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                fCallback();
                fClose();
            }
            else
            {
                _local_2.x = ((mc.cnt.fill.x - mc.cnt.fillMask.width) + (run * _local_4));
            };
        }

        private function tipFollow(_arg_1:Event):void
        {
            var _local_2:* = mc.cnt.tip;
            var _local_3:* = mc.cnt.fillMask;
            _local_2.x = ((_local_3.x + _local_3.width) - _local_2.width);
        }

        private function fCallback():void
        {
            if (o.msg != null)
            {
                rootClass.chatF.pushMsg("event", o.msg, "SERVER", "", 0);
            };
            if (o.callback != null)
            {
                if (o.args != null)
                {
                    o.callback(o.args);
                }
                else
                {
                    o.callback();
                };
            };
            if (o.xtObj != null)
            {
                rootClass.sfc.sendXtMessage("zm", o.xtObj.cmd, o.xtObj.args, "str", rootClass.world.curRoom);
            };
        }

        internal function frame1():*
        {
            cnt.visible = false;
            init();
            stop();
        }

        internal function frame5():*
        {
            cnt.visible = true;
            cnt.tip.visible = true;
        }

        internal function frame6():*
        {
            stop();
        }

        internal function frame10():*
        {
            cnt.tip.visible = false;
        }


    }
}//package 

