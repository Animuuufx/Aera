// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFElementListItemItem

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import liteAssets.draw.detailedCheck;
    import flash.geom.ColorTransform;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFElementListItemItem extends LPFElementListItem 
    {

        private const MAX_SELECTED:int = 100;

        public var tSeller:TextField;
        public var tDuration:TextField;
        public var tGold:TextField;
        public var tCoins:TextField;
        public var tLevelDisplay:TextField;
        public var mcLine:MovieClip;
        public var blackBG:MovieClip;

        public var icon:MovieClip;
        public var tName:TextField;
        public var selBG:MovieClip;
        public var tLevel:TextField;
        public var wearBG:MovieClip;
        public var check:detailedCheck;
        public var iconAC:MovieClip;
        public var eqpBG:MovieClip;
        public var iconRing:MovieClip;
        public var hit:MovieClip;
        public var sel:Boolean = false;
        private var rootClass:Game = Game.root;
        private var allowDesel:Boolean = false;
        private var bLimited:Boolean = false;
        private var multiSelect:Boolean = false;
        private var onAuction:Boolean = false;
        private var onInventory:Boolean = false;
        private var onRetrieve:Boolean = false;
        private var redCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 0, 0, 0);
        private var greenCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 96, 0, 0);
        private var blueCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 96, 0);
        private var whiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 64, 64, 64, 0);
        private var orangeCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 36, 0, 0);
        private var yellowCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 64, 24, 0);
        private var purpleCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 0, 96, 0);
        private var greyCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        private var blackoutCT:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
        private var greyoutCT:ColorTransform = new ColorTransform(0, 0, 0, 1, 40, 40, 40, 0);
        private var staffFilter:GlowFilter = new GlowFilter(0xFFFF00, 1, 5, 5, 5, 1, false, true);
        private var mispricedFilter:GlowFilter = new GlowFilter(0xFF0000, 1, 5, 5, 5, 1, false, true);

        public function LPFElementListItemItem():void
        {
            check.visible = false;
            check.mouseEnabled = false;
            addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
        }

        override public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            if (("eventType" in _arg_1))
            {
                eventType = _arg_1.eventType;
            }
            if (("allowDesel" in _arg_1))
            {
                allowDesel = _arg_1.allowDesel;
            }
            if (("bLimited" in _arg_1))
            {
                bLimited = _arg_1.bLimited;
            }
            if (("multiSelect" in _arg_1))
            {
                multiSelect = _arg_1.multiSelect;
            }
            if (("onAuction" in _arg_1))
            {
                onAuction = _arg_1.onAuction;
            }
            if (("onInventory" in _arg_1))
            {
                onInventory = _arg_1.onInventory;
            }
            if (("onRetrieve" in _arg_1))
            {
                onRetrieve = _arg_1.onRetrieve;
            }
            fDraw();
        }

        private function setupMode() : void
        {
            if (rootClass.ui.mcPopup.currentLabel == "Auction")
            {
                eqpBG.width = 580;
                selBG.width = 580;
                blackBG.width = 580;
                mcLine.width = 580;
                tLevel.x = 518;
                tLevelDisplay.x = 504;
                tSeller.visible = true;
                tDuration.visible = true;
                tGold.visible = true;
                tCoins.visible = true;
            }
            else
            {
                eqpBG.width = 263;
                selBG.width = 263;
                blackBG.width = 263;
                mcLine.width = 263;
                tLevel.x = 240;
                tLevelDisplay.x = 226;
                tSeller.visible = false;
                tDuration.visible = false;
                tGold.visible = false;
                tCoins.visible = false;
            }
        }

        override protected function fDraw():void
        {
            var _local_4:Object;
            var _local_12:Number;
            var _local_13:Class;
            var _local_14:*;
            var _local_15:int;
            var _local_16:int;
            var _local_1:Object = rootClass.world.myAvatar.dataLeaf;
            var _local_2:int = (hit.width - 2);
            var _local_3:* = (("<font color='#FFFFFF'>" + fData.sName) + "</font>");

            setupMode();

            if (rootClass.ui.mcPopup.currentLabel == "Auction")
            {
                if(onAuction)
                {
                    tSeller.visible = true;
                    tDuration.visible = true;
                    tGold.visible = true;
                    tCoins.visible = true;
                    tSeller.htmlText = fData.Player;
                    tDuration.htmlText = fData.Duration;
                    tGold.htmlText = rootClass.strNumWithCommas(fData.Gold);
                    tCoins.htmlText = rootClass.strNumWithCommas(fData.Coins);
                }
                if(onInventory)
                {
                    tSeller.htmlText = "";
                    tDuration.htmlText = "";
                    tGold.htmlText = "";
                    tCoins.htmlText = "";
                }
                if(onRetrieve)
                {
                    tSeller.visible = true;
                    tDuration.visible = true;
                    tGold.visible = true;
                    tCoins.visible = true;
                    tSeller.htmlText = fData.Player;
                    tDuration.htmlText = fData.Duration;
                    tGold.htmlText = rootClass.strNumWithCommas(fData.Gold);
                    tCoins.htmlText = rootClass.strNumWithCommas(fData.Coins);
                }
            }
            else
            {
                tSeller.visible = false;
                tDuration.visible = false;
                tGold.visible = false;
                tCoins.visible = false;
            }

            if (fData.bUpg == 1)
            {
                _local_3 = (("<font color='#FCC749'>" + fData.sName) + "</font>");
            }
            if (((fData.iLvl > _local_1.intLevel) || ((!(fData.EnhLvl == null)) && (fData.EnhLvl > _local_1.intLevel))))
            {
                _local_3 = (("<font color='#FF0000'>" + fData.sName) + "</font>");
            }
            if (((bLimited) && (fData.iQtyRemain <= 0)))
            {
                _local_3 = (("<font color='#666666'>" + fData.sName) + "</font>");
            }
            tName.htmlText = _local_3;
            if (fData.iRty != null)
            {
            }
            if (rootClass.world.enhPatternTree == null)
            {
                rootClass.world.initPatternTree();
            }
            if (["Weapon", "he", "ar", "ba"].indexOf(fData.sES) > -1)
            {
                if (fData.PatternID != null)
                {
                    _local_4 = rootClass.world.enhPatternTree[fData.PatternID];
                }
                if (fData.EnhPatternID != null)
                {
                    _local_4 = rootClass.world.enhPatternTree[fData.EnhPatternID];
                }
                if (_local_4 != null)
                {
                }
            }
            if (bLimited)
            {
                tName.htmlText = (tName.htmlText + (("<font color='#AA0000'> x" + fData.iQtyRemain) + "</font>"));
            }
            else
            {
                if (fData.iStk > 1)
                {
                    tName.htmlText = (tName.htmlText + (("<font color='#999999'> x" + fData.iQty) + "</font>"));
                }
            }
            if (((fData.sES == "ar") && (fData.EnhID > 0)))
            {
                _local_12 = rootClass.getRankFromPoints(fData.iQty);
                tName.htmlText = (tName.htmlText + (("<font color='#999999'>, Rank " + _local_12) + "</font>"));
            }
            if (((!(fData.EnhLvl == null)) && (fData.EnhLvl > 0)))
            {
                tLevel.htmlText = (("<font color='#00CCFF'>" + fData.EnhLvl) + "</font>");
            }
            else
            {
                if (((!(fData.iLvl == null)) && (fData.iLvl > 0)))
                {
                    tLevel.htmlText = (("<font color='#FFFFFF'>" + fData.iLvl) + "</font>");
                }
                else
                {
                    tLevel.visible = false;
                }
            }
            iconAC.visible = false;
            if ((("bCoins" in fData) && (fData.bCoins == 1)))
            {
                iconAC.visible = true;
            }
            var _local_5:* = 23;
            var _local_6:* = 19;
            var _local_7:* = 13;
            var _local_8:* = 11;
            var _local_9:* = _local_5;
            var _local_10:* = _local_6;
            var _local_11:* = "";
            rootClass.onRemoveChildrens(icon);
            icon.visible = false;
            try
            {
                if (fData.sType.toLowerCase() == "enhancement")
                {
                    _local_11 = rootClass.getIconBySlot(fData.sES);
                }
                else
                {
                    if (((fData.sType.toLowerCase() == "serveruse") || (fData.sType.toLowerCase() == "clientuse")))
                    {
                        if (((("sFile" in fData) && (fData.sFile.length > 0)) && (!(rootClass.world.getClass(fData.sFile) == null))))
                        {
                            _local_11 = fData.sFile;
                        }
                        else
                        {
                            _local_11 = fData.sIcon;
                        }
                    }
                    else
                    {
                        if ((((fData.sIcon == null) || (fData.sIcon == "")) || (fData.sIcon == "none")))
                        {
                            if (fData.sLink.toLowerCase() != "none")
                            {
                                _local_11 = "iidesign";
                            }
                            else
                            {
                                _local_11 = "iibag";
                            }
                        }
                        else
                        {
                            _local_11 = fData.sIcon;
                        }
                    }
                }
                try
                {
                    _local_13 = (rootClass.world.getClass(_local_11) as Class);
                    _local_14 = icon.addChild(new (_local_13)());
                    _local_9 = _local_14.width;
                    _local_10 = _local_14.height;
                    _local_15 = 0;
                    _local_16 = 0;
                    if (fData.sType.toLowerCase() == "enhancement")
                    {
                        _local_15 = int((((_local_5 - _local_7) / 4) - 1));
                        _local_16 = int((((_local_6 - _local_8) / 4) - 1));
                        _local_5 = _local_7;
                        _local_6 = _local_8;
                    }
                    if (_local_9 > _local_10)
                    {
                        _local_14.scaleX = (_local_14.scaleY = (_local_5 / _local_9));
                    }
                    else
                    {
                        _local_14.scaleX = (_local_14.scaleY = (_local_6 / _local_10));
                    }
                    _local_14.x = (-(_local_14.width / 2) + _local_15);
                    _local_14.y = (-(_local_14.height / 2) + _local_16);
                    icon.visible = true;
                }
                catch(e:Error)
                {
                }
                iconRing.visible = true;
                iconRing.y = (iconRing.y = 2);
                iconRing.width = (iconRing.height = 25);
                if (fData.sType.toLowerCase() == "enhancement")
                {
                    icon.transform.colorTransform = blackoutCT;
                }
                else
                {
                    if (((!(fData.EnhLvl == null)) && (fData.EnhLvl > 0)))
                    {
                        iconRing.width = (iconRing.height = 19);
                        iconRing.x = (iconRing.x + 3);
                        iconRing.y = (iconRing.y + 3);
                    }
                    else
                    {
                        iconRing.visible = false;
                        if (["Weapon", "he", "ar", "ba"].indexOf(fData.sES) > -1)
                        {
                            icon.transform.colorTransform = greyoutCT;
                        }
                    }
                }
                if (_local_4 != null)
                {
                    if (_local_4.hasOwnProperty("COLOR"))
                    {
                        iconRing.bg.transform.colorTransform = _local_4.COLOR;
                    }
                    else
                    {
                        iconRing.bg.transform.colorTransform = getCatCT(_local_4.sDesc);
                    }
                }
                wearBG.visible = false;
                eqpBG.visible = false;
                if (fData.bEquip)
                {
                    eqpBG.visible = true;
                }
                else
                {
                    if (((fData.hasOwnProperty("bWear")) && (fData.bWear)))
                    {
                        wearBG.visible = true;
                    }
                }
                selBG.alpha = 0;
                if (((rootClass.litePreference.data.bDebugger) && (!(rootClass.litePreference.data.dOptions["debugColor"]))))
                {
                    if (Number(fData.bStaff) == 1)
                    {
                        eqpBG.visible = true;
                        eqpBG.filters = [staffFilter];
                    }
                    else
                    {
                        eqpBG.filters = [];
                        if (((Number(fData.iCost) > 12000) && (Number(fData.bCoins) == 1)))
                        {
                            eqpBG.visible = true;
                            eqpBG.filters = [mispricedFilter];
                        }
                        else
                        {
                            if (Number(fData.iCost) == 0)
                            {
                                eqpBG.visible = true;
                                eqpBG.filters = [mispricedFilter];
                            }
                        }
                    }
                }
                buttonMode = true;
                mouseChildren = false;
            }
            catch(e)
            {
            }
        }

        override public function select():void
        {
            sel = true;
            if (multiSelect)
            {
                check.visible = true;
            }
            else
            {
                selBG.alpha = 1;
            }
        }

        override public function deselect():void
        {
            sel = false;
            if (multiSelect)
            {
                check.visible = false;
            }
            else
            {
                selBG.alpha = 0;
            }
        }

        override protected function onClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            if (!rootClass.isGreedyModalInStack())
            {
                if (multiSelect)
                {
                    if (sel)
                    {
                        deselect();
                    }
                    else
                    {
                        if (LPFFrameListViewTabbed(fParent).getSelected() < MAX_SELECTED)
                        {
                            select();
                        }
                        else
                        {
                            rootClass.MsgBox.notify((("You can only select up to a maximum of " + MAX_SELECTED) + " items."));
                        }
                    }
                }
                else
                {
                    if (!sel)
                    {
                        _local_2 = LPFFrameListViewTabbed(fParent).getListItemByiSel();
                        if (_local_2 != null)
                        {
                            _local_2.deselect();
                        }
                        select();
                    }
                    else
                    {
                        if (allowDesel)
                        {
                            deselect();
                        }
                    }
                }
                update();
            }
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            if (!sel)
            {
                selBG.alpha = 0.6;
            }
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
            if (!sel)
            {
                selBG.alpha = 0;
            }
        }

        private function getCatCT(_arg_1:String):ColorTransform
        {
            var _local_2:ColorTransform = greyCT;
            if (_arg_1 == "M1")
            {
                _local_2 = redCT;
            }
            if (_arg_1 == "M2")
            {
                _local_2 = greenCT;
            }
            if (_arg_1 == "M3")
            {
                _local_2 = yellowCT;
            }
            if (_arg_1 == "C1")
            {
                _local_2 = blueCT;
            }
            if (_arg_1 == "C2")
            {
                _local_2 = whiteCT;
            }
            if (_arg_1 == "C3")
            {
                _local_2 = orangeCT;
            }
            if (_arg_1 == "S1")
            {
                _local_2 = purpleCT;
            }
            if (_arg_1 == "none")
            {
                _local_2 = greyCT;
            }
            return (_local_2);
        }


    }
}//package 

