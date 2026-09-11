// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameQtySelector

package 
{
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import flash.text.*;

    public class LPFFrameQtySelector extends LPFFrame 
    {

        public var t1:TextField;
        public var t2:TextField;
        public var handle:MovieClip;
        public var bar:MovieClip;
        private var _min:int = 1;
        private var _max:int = 1;
        private var isMouseDown:Boolean = false;
        private var _p:Point = new Point();
        private var _n:Number = 0;
        private var _w:int = 0;
        private var _dx:int = 0;
        private var rootClass:MovieClip;
        protected var eventType:String = "";

        public function LPFFrameQtySelector():void
        {
            visible = false;
            _w = (bar.width - handle.width);
            t1.restrict = "0123456789";
            t1.maxChars = 4;
            handle.buttonMode = true;
        }

        private function get qty_container():*
        {
            return (MovieClip(MovieClip(parent).parent));
        }

        public function get _val():int
        {
            return (qty_container.iQty);
        }

        public function set _val(_arg_1:int):void
        {
            qty_container.iQty = _arg_1;
            t1.text = String(_arg_1);
        }

        public function get val():int
        {
            var _local_1:int = int(t1.text);
            if (getLayout().sMode == "shopBuy")
            {
                _local_1 = int((fData.iQty * Math.floor((_local_1 / fData.iQty))));
            };
            if (_val != _local_1)
            {
                _val = _local_1;
            };
            _val = Math.max(Math.min(_val, _max), _min);
            return (_val);
        }

        public function set val(_arg_1:int):void
        {
            var _local_2:int = _arg_1;
            if (getLayout().sMode == "shopBuy")
            {
                _local_2 = int((fData.iQty * Math.floor((_arg_1 / fData.iQty))));
            };
            _val = Math.max(Math.min(_local_2, _max), _min);
        }

        private function updateValues():void
        {
            if (_val == _max)
            {
                t1.htmlText = (("<font color='#FFFFFF'>" + _val) + "</font>");
            }
            else
            {
                t1.htmlText = (("<font color='#999999'>" + _val) + "</font>");
            };
            update({"eventType":"updateQtyValue"});
        }

        private function updateHandle():void
        {
            if (((handle == null) || (bar == null) || (_max <= 0) || (_w <= 0)))
            {
                return;
            }
            handle.x = Math.round((bar.x + (_w * (_val / _max))));
        }

        private function onEF(_arg_1:Event):void
        {
            if (isMouseDown)
            {
                _p.x = stage.mouseX;
                _p.y = stage.mouseY;
                _p = globalToLocal(_p);
                _p.x = (_p.x - _dx);
                handle.x = (_n = Math.max(Math.min(_p.x, (bar.x + _w)), bar.x));
                _n = (_n - bar.x);
                _n = (_n / _w);
                val = Math.round((_n * _max));
                updateValues();
            };
        }

        private function onDn(_arg_1:MouseEvent):void
        {
            isMouseDown = true;
            _p.x = stage.mouseX;
            _p.y = stage.mouseY;
            _p = globalToLocal(_p);
            _dx = (_p.x - handle.x);
        }

        private function onUp(_arg_1:MouseEvent):void
        {
            isMouseDown = false;
        }

        private function onKey(_arg_1:KeyboardEvent):void
        {
            if (((_arg_1.charCode == Keyboard.ENTER) || (_arg_1.charCode == Keyboard.ESCAPE)))
            {
                val;
                updateValues();
                updateHandle();
                rootClass.stage.focus = null;
            };
        }

        override public function fOpen(_arg_1:Object):void
        {
            visible = false;
            rootClass = MovieClip(stage.getChildAt(0));
            positionBy(_arg_1.r);
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            };
            getLayout().registerForEvents(this, eventTypes);
            fDraw();
            stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
            addEventListener(Event.ENTER_FRAME, onEF, false, 0, true);
            handle.addEventListener(MouseEvent.MOUSE_DOWN, onDn, false, 0, true);
            t1.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
            t2.addEventListener(MouseEvent.CLICK, onMax, false, 0, true);
        }

        private function onMax(_arg_1:MouseEvent):void
        {
            val = _max;
            updateValues();
            updateHandle();
        }

        override public function fClose():void
        {
            isMouseDown = false;
            removeEventListener(Event.ENTER_FRAME, onEF);
            if (handle != null)
            {
                handle.removeEventListener(MouseEvent.MOUSE_DOWN, onDn);
            }
            if (t1 != null)
            {
                t1.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
            }
            if (t2 != null)
            {
                t2.removeEventListener(MouseEvent.CLICK, onMax);
            }
            if (stage != null)
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            }
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        protected function fDraw():void
        {
            if (fData != null)
            {
                if (getLayout().sMode == "shopSell")
                {
                    _val = (_min = 1);
                    _max = rootClass.world.maximumShopSells(fData);
                }
                else
                {
                    _val = (_min = fData.iQty);
                    _max = rootClass.world.maximumShopBuys(fData);
                };
                val;
                updateValues();
                updateHandle();
                t2.htmlText = (("<font color='#FFFFFF'>" + _max) + "</font>");
                visible = true;
            }
            else
            {
                visible = false;
            };
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "listItemASel")
            {
                if ((("fData" in _arg_1) && (_arg_1.fData.hasOwnProperty("iSel"))))
                {
                    if (rootClass.ui.mcPopup.currentLabel == "EnhShop")
                    {
                        return;
                    };
                    if (((getLayout().sMode == "shopBuy") && ((rootClass.world.maximumShopBuys(_arg_1.fData.iSel) < 2) || ((_arg_1.fData.iSel.bCoins == 1) && (_arg_1.fData.iSel.iCost > 0)))))
                    {
                        fData = null;
                    }
                    else
                    {
                        if (((getLayout().sMode == "shopSell") && (rootClass.world.maximumShopSells(_arg_1.fData.iSel) < 2)))
                        {
                            fData = null;
                        }
                        else
                        {
                            fData = _arg_1.fData.iSel;
                        };
                    };
                };
                fDraw();
            };
        }


    }
}//package 

