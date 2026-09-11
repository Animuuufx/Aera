// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameCheapBuySell

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameCheapBuySell extends LPFFrame 
    {

        public var btnBuy:MovieClip;
        public var btnSell:MovieClip;
        private var rootClass:MovieClip;
        protected var eventType:String = "";

        public function LPFFrameCheapBuySell():void
        {
            btnBuy.addEventListener(MouseEvent.CLICK, onBtnBuyClick, false, 0, true);
            btnBuy.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            btnBuy.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            btnSell.addEventListener(MouseEvent.CLICK, onBtnSellClick, false, 0, true);
            btnSell.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            btnSell.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            btnBuy.buttonMode = true;
            btnSell.buttonMode = true;
            btnBuy.sel = (btnBuy.bg2.visible = (btnBuy.bg3.visible = false));
            btnSell.sel = (btnSell.bg2.visible = (btnSell.bg3.visible = false));
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            positionBy(_arg_1.r);
            if (("eventType" in _arg_1))
            {
                eventType = _arg_1.eventType;
            };
            if (("openOn" in _arg_1))
            {
                if (_arg_1.openOn == "shopBuy")
                {
                    select(btnBuy);
                };
                if (_arg_1.openOn == "shopSell")
                {
                    select(btnSell);
                };
            };
        }

        override public function fClose():void
        {
            btnBuy.removeEventListener(MouseEvent.CLICK, onBtnBuyClick);
            btnBuy.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnBuy.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnSell.removeEventListener(MouseEvent.CLICK, onBtnSellClick);
            btnSell.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnSell.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        protected function fDraw():void
        {
        }

        override public function notify(_arg_1:Object):void
        {
        }

        private function onBtnSellClick(_arg_1:MouseEvent):void
        {
            if (!btnSell.sel)
            {
                rootClass.mixer.playSound("Click");
                unselect(btnBuy);
                select(btnSell);
                update({
                    "eventType":eventType,
                    "sModeBroadcast":"shopSell"
                });
            };
        }

        private function onBtnBuyClick(_arg_1:MouseEvent):void
        {
            if (!btnBuy.sel)
            {
                rootClass.mixer.playSound("Click");
                unselect(btnSell);
                select(btnBuy);
                update({
                    "eventType":eventType,
                    "sModeBroadcast":"shopBuy"
                });
            };
        }

        private function onMouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (!_local_2.sel)
            {
                _local_2.bg2.visible = true;
            };
        }

        private function onMouseOut(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (!_local_2.sel)
            {
                _local_2.bg2.visible = false;
            };
        }

        private function select(_arg_1:MovieClip):void
        {
            _arg_1.sel = true;
            _arg_1.bg2.visible = false;
            _arg_1.bg3.visible = true;
            setChildIndex(_arg_1, 1);
        }

        private function unselect(_arg_1:MovieClip):void
        {
            _arg_1.sel = false;
            _arg_1.bg2.visible = false;
            _arg_1.bg3.visible = false;
            setChildIndex(_arg_1, 0);
        }


    }
}//package 

