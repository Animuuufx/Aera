// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameCostDisplay

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameCostDisplay extends LPFFrame 
    {

        public var mcCoins:MovieClip;
        public var mcGold:MovieClip;
        public var bg:MovieClip;
        private var rootClass:MovieClip;
        private var r:Object;

        public function LPFFrameCostDisplay():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            fData = _arg_1.fData;
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            if (("r" in _arg_1))
            {
                r = _arg_1.r;
            };
            fDraw();
            positionBy(r);
            getLayout().registerForEvents(this, eventTypes);
            mcCoins.addEventListener(MouseEvent.MOUSE_OVER, onCoinsTTOver, false, 0, true);
            mcCoins.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);
            mcGold.addEventListener(MouseEvent.MOUSE_OVER, onGoldTTOver, false, 0, true);
            mcGold.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);
            mcGold.hit.alpha = 0;
            mcCoins.hit.alpha = 0;
        }

        override public function fClose():void
        {
            mcCoins.removeEventListener(MouseEvent.MOUSE_OVER, onCoinsTTOver);
            mcCoins.removeEventListener(MouseEvent.MOUSE_OUT, onTTOut);
            mcGold.removeEventListener(MouseEvent.MOUSE_OVER, onGoldTTOver);
            mcGold.removeEventListener(MouseEvent.MOUSE_OUT, onTTOut);
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        private function get qty_parent():*
        {
            return ((MovieClip(MovieClip(parent).parent).iQty) ? MovieClip(MovieClip(parent).parent) : MovieClip(parent));
        }

        private function fDraw():void
        {
            var _local_4:int;
            visible = false;
            var _local_1:* = (getLayout().sMode == "shopSell");
            var _local_2:Number = 0;
            var _local_3:* = "#FFFFFF";
            if (((getLayout().sMode.indexOf("shop") > -1) && (!(fData == null))))
            {
                visible = true;
                mcGold.visible = false;
                mcCoins.visible = false;
                mcGold.x = 0;
                mcCoins.x = 0;
                mcGold.ti.text = "";
                mcCoins.ti.text = "";
                _local_2 = Number(fData.iCost);
                if ((((!(qty_parent.eSel == null)) && (getLayout().sMode == "shopBuy")) && (getLayout().hasOwnProperty("splitPanel"))))
                {
                    if (getLayout().splitPanel.visible)
                    {
                        _local_4 = getLayout().splitPanel.frames[2].mc.getSelected();
                        if (_local_4 > 1)
                        {
                            _local_2 = (_local_2 * _local_4);
                        };
                    };
                }
                else
                {
                    if (((((getLayout().sMode.indexOf("shop") > -1) && (qty_parent)) && (hasSlider())) && (qty_parent.iQty > 1)))
                    {
                        if (fData.sES != "ar")
                        {
                            _local_2 = (_local_2 * qty_parent.iQty);
                        };
                    };
                };
                if (_local_2 > 0)
                {
                    if ((("bCoins" in fData) && (fData.bCoins == 1)))
                    {
                        if (_local_1)
                        {
                            if (fData.ItemID == 8939)
                            {
                                _local_2 = Math.ceil((_local_2 / 4));
                            }
                            else
                            {
                                if (fData.iHrs < 24)
                                {
                                    _local_2 = Math.ceil(((_local_2 * 9) / 10));
                                }
                                else
                                {
                                    _local_2 = Math.ceil((_local_2 / 4));
                                };
                            };
                        }
                        else
                        {
                            if (_local_2 > rootClass.world.myAvatar.objData.intCoins)
                            {
                                _local_3 = "#FF0000";
                            };
                        };
                        mcCoins.ti.htmlText = (((("<font color='" + _local_3) + "'>") + rootClass.strNumWithCommas(_local_2)) + "</font>");
                        mcCoins.visible = true;
                    }
                    else
                    {
                        if (_local_1)
                        {
                            _local_2 = Math.ceil((_local_2 / 4));
                        }
                        else
                        {
                            if (_local_2 > rootClass.world.myAvatar.objData.intGold)
                            {
                                _local_3 = "#FF0000";
                            };
                        };
                        mcGold.ti.htmlText = (((("<font color='" + _local_3) + "'>") + rootClass.strNumWithCommas(_local_2)) + "</font>");
                        mcGold.visible = true;
                    };
                    mcGold.hit.width = ((mcGold.ti.x + mcGold.ti.textWidth) + 2);
                    mcCoins.hit.width = ((mcCoins.ti.x + mcCoins.ti.textWidth) + 2);
                    if (((rootClass.ui.mcPopup.currentLabel == "MergeShop") && (hasSlider())))
                    {
                        positionBy({
                            "x":450,
                            "y":-102,
                            "w":-1,
                            "h":-1,
                            "xPosRule":"centerOnX"
                        });
                    }
                    else
                    {
                        if (((rootClass.ui.mcPopup.currentLabel == "MergeShop") && (!(hasSlider()))))
                        {
                            positionBy(r);
                        };
                    };
                    visible = true;
                }
                else
                {
                    visible = false;
                };
            };
        }

        private function hasSlider():Boolean
        {
            if (((getLayout().sMode == "shopBuy") && ((rootClass.world.maximumShopBuys(fData) < 2) || ((fData.bCoins == 1) && (fData.iCost > 0)))))
            {
                return (false);
            };
            if (((getLayout().sMode == "shopSell") && (rootClass.world.maximumShopSells(fData) < 2)))
            {
                return (false);
            };
            return (true);
        }

        override protected function positionBy(_arg_1:Object):*
        {
            var _local_3:int;
            var _local_2:int;
            if (mcGold.visible)
            {
                bg.width = (((mcGold.x + mcGold.ti.x) + mcGold.ti.textWidth) + 10);
                w = bg.width;
                _local_2 = 1;
            }
            else
            {
                bg.width = (((mcCoins.x + mcCoins.ti.x) + mcCoins.ti.textWidth) + 10);
                w = bg.width;
            };
            if (((!(_arg_1 == null)) && ("xPosRule" in _arg_1)))
            {
                if (_arg_1.xPosRule == "centerOnX")
                {
                    x = (int((_arg_1.x - (w / 2))) + _local_2);
                };
            }
            else
            {
                if (_arg_1.x > -1)
                {
                    x = _arg_1.x;
                }
                else
                {
                    x = (int(((fParent.w / 2) - (w / 2))) + _local_2);
                };
            };
            if (_arg_1.y > -1)
            {
                y = _arg_1.y;
            }
            else
            {
                if (_arg_1.y == -1)
                {
                    _local_3 = fParent.numChildren;
                    if (_local_3 > 1)
                    {
                        y = ((fParent.getChildAt((_local_3 - 2)).y + fParent.getChildAt((_local_3 - 2)).height) + 10);
                    }
                    else
                    {
                        y = 10;
                    };
                }
                else
                {
                    y = (fParent.h + _arg_1.y);
                };
            };
        }

        override public function notify(_arg_1:Object):void
        {
            if (((_arg_1.eventType == "listItemASel") || (_arg_1.eventType == "listItemBSel")))
            {
                if (((!(_arg_1.fData == null)) && (!(_arg_1.fData.oSel == null))))
                {
                    fData = _arg_1.fData.oSel;
                };
                fDraw();
            };
            if (_arg_1.eventType == "updateQtyValue")
            {
                fDraw();
            };
        }

        private function onCoinsTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"Adventure Coins"});
        }

        private function onGoldTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"Gold"});
        }

        private function onTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }


    }
}//package 

