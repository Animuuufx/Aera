// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.battleAnalyzer

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.*;
    import flash.utils.*;

    public class battleAnalyzer extends MovieClip 
    {

        public var txtStart:TextField;
        public var bgStart:MovieClip;
        public var btnClose:MovieClip;
        public var txtValues:TextField;
        internal var startTime:Number;
        internal var seconds:Number = 0;
        private var _running:Boolean = false;
        internal var dmg:Number = 0;
        internal var heal:Number = 0;
        internal var dmgRecv:Number = 0;
        internal var gold:Number = 0;
        internal var xp:Number = 0;
        internal var kills:Number = 0;

        public function battleAnalyzer()
        {
            this.bgStart.addEventListener(MouseEvent.CLICK, onStart, false, 0, true);
            this.bgStart.buttonMode = true;
            this.txtStart.mouseEnabled = false;
            this.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_UP, onStopDrag, false, 0, true);
            this.btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
        }

        public function onBattleTimer(_arg_1:Event):void
        {
            seconds = Math.round((Math.abs((startTime - new Date().getTime())) / 1000));
            updateDisplay();
        }

        public function updateDisplay():void
        {
            this.txtValues.text = ((((((((((((((((((formatSeconds() + "\n") + addCommas(dmg)) + ((" (" + addCommas(Math.round((dmg / seconds)))) + "/sec)")) + "\n") + addCommas(heal)) + ((" (" + addCommas(Math.round((heal / seconds)))) + "/sec)")) + "\n") + addCommas(dmgRecv)) + ((" (" + addCommas(Math.round((dmgRecv / seconds)))) + "/sec)")) + "\n") + addCommas(gold)) + ((" (" + addCommas(Math.round((gold / seconds)))) + "/sec)")) + "\n") + addCommas(xp)) + ((" (" + addCommas(Math.round((xp / seconds)))) + "/sec)")) + "\n") + addCommas(kills)) + ((" (" + ((seconds == 0) ? "0" : Number((kills / (seconds / 60))).toFixed(2))) + "/min)"));
        }

        public function addCommas(_arg_1:uint):String
        {
            var _local_4:uint;
            if (_arg_1 == 0)
            {
                return ("0");
            };
            var _local_2:* = "";
            var _local_3:uint = _arg_1;
            while (_local_3 > 0)
            {
                _local_4 = (_local_3 % 1000);
                _local_2 = ((((_local_3 > 999) ? ("," + ((_local_4 < 100) ? ((_local_4 < 10) ? "00" : "0") : "")) : "") + _local_4) + _local_2);
                _local_3 = uint((_local_3 / 1000));
            };
            return (_local_2);
        }

        public function isRunning():Boolean
        {
            return (_running);
        }

        public function formatSeconds():String
        {
            var _local_1:* = Math.floor((seconds / 3600));
            var _local_2:* = Math.floor(((seconds % 3600) / 60));
            var _local_3:* = (seconds % 60);
            if (_local_1 < 10)
            {
                _local_1 = ("0" + _local_1);
            };
            if (_local_2 < 10)
            {
                _local_2 = ("0" + _local_2);
            };
            if (_local_3 < 10)
            {
                _local_3 = ("0" + _local_3);
            };
            return ((((_local_1 + ":") + _local_2) + ":") + _local_3);
        }

        public function addDamage(_arg_1:Number):void
        {
            this.dmg = (this.dmg + _arg_1);
        }

        public function addHeal(_arg_1:Number):void
        {
            this.heal = (this.heal + _arg_1);
        }

        public function addReceived(_arg_1:Number):void
        {
            this.dmgRecv = (this.dmgRecv + _arg_1);
        }

        public function addGold(_arg_1:Number):void
        {
            this.gold = (this.gold + _arg_1);
        }

        public function addExp(_arg_1:Number):void
        {
            this.xp = (this.xp + _arg_1);
        }

        public function addKill():void
        {
            this.kills = (this.kills + 1);
        }

        public function reset():void
        {
            startTime = new Date().getTime();
            seconds = 0;
            dmg = 0;
            heal = 0;
            dmgRecv = 0;
            gold = 0;
            xp = 0;
            kills = 0;
            updateDisplay();
        }

        public function toggle():void
        {
            this.bgStart.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        public function onStart(_arg_1:MouseEvent):void
        {
            if (_running)
            {
                this.removeEventListener(Event.ENTER_FRAME, onBattleTimer);
            }
            else
            {
                reset();
                this.addEventListener(Event.ENTER_FRAME, onBattleTimer, false, 0, true);
            };
            _running = (!(_running));
            txtStart.text = ((_running) ? "Stop" : "Start");
        }

        public function onBtnClose(_arg_1:MouseEvent):void
        {
            this.removeEventListener(Event.ENTER_FRAME, onBattleTimer);
            MovieClip(getChildAt(0)).bAnalyzer = null;
            parent.removeChild(this);
        }

        public function onDrag(_arg_1:MouseEvent):void
        {
            this.startDrag();
        }

        public function onStopDrag(_arg_1:MouseEvent):void
        {
            this.stopDrag();
        }


    }
}//package liteAssets.draw

