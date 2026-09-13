// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameListViewTabbed

package 
{
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.display.Graphics;
    import flash.text.*;

    public class LPFFrameListViewTabbed extends LPFFrame 
    {

        public var tMsg:TextField;
        public var listMask:MovieClip;
        public var bgTabs:MovieClip;
        public var bgList:MovieClip;
        public var tabs:MovieClip;
        public var iList:MovieClip;
        public var scr:LPFElementScrollBar;
        private var listA:Array = [];
        private var aSel:Array = [];
        private var iSel:Object;
        public var tSel:Object;
        private var tabStates:Array = [];
        private var filterMap:Object = {};
        private var itemEventType:String;
        private var tabEventType:String;
        private var sortOrder:Array = [];
        private var filter:String = "";
        private var allowDesel:Boolean = false;
        private var onDemand:Boolean = false;
        private var openBlank:Boolean = false;
        private var refreshTabs:Boolean = false;
        private var bLimited:Boolean = false;
        private var multiSelect:Boolean = false;
        private var itemList:Array;

        public var Param1:TextField;
        public var Duration:TextField;
        public var Price:TextField;
        public var Level:TextField;
        public var onSearch:Boolean = false;
        private var onAuction:Boolean = false;
        private var onRetrieve:Boolean = false;
        private var onInventory:Boolean = false;

        public var mcSeller:MovieClip;
        public var mcDuration:MovieClip;
        public var mcPrice:MovieClip;
        public var mcLevel:MovieClip;

        public function LPFFrameListViewTabbed():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            itemList = fData.list;
            positionBy(_arg_1.r);
            drawBG();
            if (("tabStates" in _arg_1))
            {
                tabStates = _arg_1.tabStates;
            }
            if (("filterMap" in _arg_1))
            {
                filterMap = _arg_1.filterMap;
            }
            if (("sortOrder" in _arg_1))
            {
                sortOrder = _arg_1.sortOrder;
            }
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if (("filter" in _arg_1))
            {
                filter = _arg_1.filter;
            }
            if (("itemEventType" in _arg_1))
            {
                itemEventType = _arg_1.itemEventType;
            }
            if (("tabEventType" in _arg_1))
            {
                tabEventType = _arg_1.tabEventType;
            }
            if (("sName" in _arg_1))
            {
                sName = _arg_1.sName;
            }
            if (("allowDesel" in _arg_1))
            {
                allowDesel = _arg_1.allowDesel;
            }
            if (("openBlank" in _arg_1))
            {
                openBlank = _arg_1.openBlank;
            }
            if (("onDemand" in _arg_1))
            {
                onDemand = _arg_1.onDemand;
            }
            if (("refreshTabs" in _arg_1))
            {
                refreshTabs = _arg_1.refreshTabs;
            }
            if (("onAuction" in _arg_1))
            {
                onAuction = _arg_1.onAuction;
            }
            if (("onRetrieve" in _arg_1))
            {
                onRetrieve = _arg_1.onRetrieve;
            }
            if (("onInventory" in _arg_1))
            {
                onInventory = _arg_1.onInventory;
            }
            if (("multiSelect" in _arg_1))
            {
                multiSelect = _arg_1.multiSelect;
            }
            if (("bLimited" in fData))
            {
                bLimited = _arg_1.fData.bLimited;
            }
            if (!openBlank)
            {
                if (iSel == null)
                {
                    tSel = getTabByFilter("*");
                }
                else
                {
                    tSel = getTabByFilter(iSel.sType);
                }
            }
            if(onAuction)
            {
                Param1.visible = true;
                Duration.visible = true;
                Price.visible = true;
                Level.visible = true;
                mcSeller.visible = true;
                mcDuration.visible = true;
                mcPrice.visible = true;
                mcLevel.visible = true;
            }
            if(onInventory)
            {
                Param1.visible = false;
                Duration.visible = false;
                Price.visible = false;
                Level.visible = false;
                mcSeller.visible = false;
                mcDuration.visible = false;
                mcPrice.visible = false;
                mcLevel.visible = false;
            }
            if(onRetrieve)
            {
                Param1.visible = true;
                Duration.visible = true;
                Price.visible = true;
                Level.visible = true;
                mcSeller.visible = true;
                mcDuration.visible = true;
                mcPrice.visible = true;
                mcLevel.visible = true;
            }
            initTabs();
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
            if(getLayout().rootClass.ui.mcPopup.currentLabel == "Auction")
            {
                getLayout().rootClass.auctionTabs = this;
            }
            else
            {
                Param1.visible = false;
                Duration.visible = false;
                Price.visible = false;
                Level.visible = false;
                mcSeller.visible = false;
                mcDuration.visible = false;
                mcPrice.visible = false;
                mcLevel.visible = false;
            }
        }

        public function fRefresh(_arg_1:Object):void
        {
            if (("tabStates" in _arg_1))
            {
                tabStates = _arg_1.tabStates;
            }
            if (("filterMap" in _arg_1))
            {
                filterMap = _arg_1.filterMap;
            }
            if (("sortOrder" in _arg_1))
            {
                sortOrder = _arg_1.sortOrder;
            }
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if (("filter" in _arg_1))
            {
                filter = _arg_1.filter;
            }
            if (("itemEventType" in _arg_1))
            {
                itemEventType = _arg_1.itemEventType;
            }
            if (("tabEventType" in _arg_1))
            {
                tabEventType = _arg_1.tabEventType;
            }
            if (("sName" in _arg_1))
            {
                sName = _arg_1.sName;
            }
            iSel = null;
            tSel = getTabByFilter("*");
            if (fData.list != null)
            {
                itemList = fData.list;
            }
            initTabs();
            fDraw();
        }

        private function initTabs():void
        {
            var _local_6:MovieClip;
            var _local_7:Object;
            var _local_8:DisplayObject;
            var _local_9:String;
            var _local_1:int;
            var _local_2:int;
            var _local_3:Object = {};
            var _local_4:Array = [];
            var _local_5:* = "";
            while (tabs.numChildren > 0)
            {
                tabs.removeChildAt(0);
            }
            bgTabs.graphics.clear();
            _local_2 = 0;
            while (_local_2 < tabStates.length)
            {
                if (onDemand)
                {
                    tabStates[_local_2].state = 0;
                }
                else
                {
                    tabStates[_local_2].state = -1;
                    for each (_local_3 in fData.list)
                    {
                        for (_local_9 in filterMap)
                        {
                            if (((filterMap[_local_9].indexOf(_local_3.sType) > -1) || ((_local_3.sType == "Enhancement") && (_local_3.sES == _local_9))))
                            {
                                if (tabStates[_local_2].filter == _local_9)
                                {
                                    tabStates[_local_2].state = 0;
                                }
                            }
                        }
                    }
                }
                _local_2++;
            }
            _local_4 = [];
            _local_1 = 0;
            while (_local_1 < tabStates.length)
            {
                _local_3 = tabStates[_local_1];
                _local_6 = (tabs.addChild(new LPFElementListViewTab()) as MovieClip);
                _local_7 = getLayout().rootClass.world.getClass(_local_3.icon);
                _local_8 = _local_6.icon.addChild(new (_local_7)());
                _local_8.scaleX = (_local_8.scaleY = (16 / _local_8.height));
                _local_8.x = (_local_8.x - (_local_8.width / 2));
                _local_8.y = 2;
                _local_6.icon.mouseEnabled = false;
                _local_6.icon.mouseChildren = false;
                _local_6.o = _local_3;
                _local_3.mc = _local_6;
                _local_6.bg2.visible = false;
                if (_local_3 == tSel)
                {
                    _local_3.state = 1;
                }
                if (_local_3.state == -1)
                {
                    _local_6.icon.alpha = 0.3;
                    _local_6.bg3.visible = true;
                    _local_6.bg2.visible = false;
                    _local_6.bg.visible = false;
                    _local_6.mouseEnabled = false;
                    _local_6.mouseChildren = false;
                }
                else
                {
                    _local_6.bg3.visible = false;
                    _local_6.buttonMode = true;
                    if (_local_3.state == 1)
                    {
                        _local_6.bg.visible = false;
                        _local_6.bg2.visible = true;
                    }
                    _local_6.addEventListener(MouseEvent.MOUSE_DOWN, tabClick, false, 0, true);
                }
                _local_6.x = (int(((_local_6.width + 3) * _local_1)) + 1);
                _local_4.push(_local_6.getBounds(this.bgTabs));
                _local_1++;
            }
            drawTabBG();
        }

        private function fDraw(_arg_1:Boolean=true):void
        {
            var _local_8:String;
            var _local_10:LPFElementListItemItem;
            var _local_12:DisplayObject;
            var _local_13:DisplayObject;
            listA = [];
            var _local_2:Array = [];
            var _local_3:Array = [];
            var _local_4:Array = [];
            var _local_5:Array = [];
            var _local_6:int;
            var _local_7:int;
            var _local_9:Object = {};
            while (iList.numChildren > 0)
            {
                LPFElementListItem(iList.getChildAt(0)).fClose();
            }
            if (_arg_1)
            {
                iList.y = (bgTabs.height - 1);
            }
            if (tSel == null)
            {
                setMessage("No Tab Selected");
                scr.fOpen({
                    "subject":iList,
                    "subjectMask":listMask,
                    "reset":_arg_1
                });
                return;
            }
            setMessage("");
            if (tSel.filter != "*")
            {
                for each (_local_9 in itemList)
                {
                    if (((filterMap[tSel.filter].indexOf(_local_9.sType) > -1) || ((_local_9.sType == "Enhancement") && (_local_9.sES.indexOf(tSel.filter) > -1))))
                    {
                        if (!((tSel.filter == "pots") && ((((!(_local_9.sLink == "potion")) && (!(_local_9.sLink == "elixir"))) && (!(_local_9.sLink == "tonic"))) && (!(_local_9.sLink == "scroll")))))
                        {
                            _local_5.push(_local_9);
                        }
                    }
                }
            }
            else
            {
                _local_5 = itemList;
            }
            if (((onDemand) && (_local_5.length == 0)))
            {
                setMessage("No items of this type");
                scr.fOpen({
                    "subject":iList,
                    "subjectMask":listMask,
                    "reset":_arg_1
                });
                return;
            }
            _local_6 = 0;
            while (_local_6 < sortOrder.length)
            {
                _local_2 = [];
                for each (_local_9 in _local_5)
                {
                    if (_local_9.sType == sortOrder[_local_6])
                    {
                        _local_2.push(_local_9);
                    }
                }
                if (_local_2.length > 0)
                {
                    _local_2.sortOn(["sName", "iLvl"], [undefined, (Array.DESCENDING | Array.NUMERIC)]);
                    listA = listA.concat(_local_2);
                }
                _local_6++;
            }
            _local_2 = [];
            for each (_local_9 in _local_5)
            {
                if (listA.indexOf(_local_9) == -1)
                {
                    _local_2.push(_local_9);
                }
            }
            if (_local_2.length > 0)
            {
                _local_2.sortOn(["sType", "sName"]);
                listA = listA.concat(_local_2);
            }
            var _local_11:Object = {};
            _local_11.eventType = itemEventType;
            _local_11.allowDesel = allowDesel;
            _local_11.onAuction = onAuction;
            _local_11.onInventory = onInventory;
            _local_11.onRetrieve = onRetrieve;
            _local_11.multiSelect = multiSelect;
            _local_11.bLimited = ((bLimited) && (getLayout().sMode == "shopBuy"));
            _local_6 = 0;
            while (_local_6 < listA.length)
            {
                _local_11.fData = listA[_local_6];
                _local_10 = new LPFElementListItemItem();
                _local_12 = iList.addChild(_local_10);
                _local_10.subscribeTo(this);
                _local_10.fOpen(_local_11);
                if (_local_10.fData == iSel)
                {
                    _local_10.select();
                }
                if (_local_6 > 0)
                {
                    _local_13 = iList.getChildAt((_local_6 - 1));
                    _local_12.y = (_local_13.y + _local_13.height);
                }
                _local_6++;
            }
            scr.fOpen({
                "subject":iList,
                "subjectMask":listMask,
                "reset":_arg_1
            });
        }

        public function getTabByFilter(_arg_1:String):Object
        {
            var _local_2:Object;
            var _local_3:int;
            while (_local_3 < tabStates.length)
            {
                _local_2 = tabStates[_local_3];
                if (_local_2.filter == _arg_1)
                {
                    return (_local_2);
                }
                _local_3++;
            }
            if (((tabStates.length > 0) && (!(_arg_1 == "none"))))
            {
                return (tabStates[0]);
            }
            return null;
        }

        public function forceTabClick(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:Object = _arg_1;
            if (tSel != null)
            {
                tSel.mc.bg.visible = true;
                tSel.mc.bg2.visible = false;
                tSel.state = 0;
            };
            tSel = _local_3;
            tSel.mc.bg.visible = false;
            tSel.mc.bg2.visible = true;
            tSel.state = 1;
            drawTabBG();
            _local_2 = {
                "fData":{"types":filterMap[tSel.filter]},
                "eventType":tabEventType,
                "fCaller":sName
            };
            while (iList.numChildren > 0)
            {
                LPFElementListItem(iList.getChildAt(0)).fClose();
            };
            iList.y = (bgTabs.height - 1);
            update(_local_2);
        }

        private function tabClick(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_2:Object = MovieClip(_arg_1.currentTarget).o;
            if (tSel != null)
            {
                tSel.mc.bg.visible = true;
                tSel.mc.bg2.visible = false;
                tSel.state = 0;
            }
            tSel = _local_2;
            tSel.mc.bg.visible = false;
            tSel.mc.bg2.visible = true;
            tSel.state = 1;
            drawTabBG();
            if (onDemand)
            {
                _local_3 = {
                    "fData":{"types":filterMap[tSel.filter]},
                    "eventType":tabEventType,
                    "fCaller":sName
                };
                while (iList.numChildren > 0)
                {
                    LPFElementListItem(iList.getChildAt(0)).fClose();
                }
                iList.y = (bgTabs.height - 1);
                update(_local_3);
            }
            else
            {
                fDraw();
            }
        }

        private function drawTabBG():void
        {
            var _local_1:Rectangle;
            var _local_2:Rectangle;
            var _local_5:MovieClip;
            var _local_3:Graphics = bgTabs.graphics;
            var _local_4:int = (bgTabs.bg.height - 1);
            _local_3.clear();
            _local_3.lineStyle(0, 0x666666, 1);
            _local_3.moveTo(0, _local_4);
            if (tSel != null)
            {
                _local_5 = tSel.mc;
                if (_local_5.x > 1)
                {
                    _local_3.lineTo(tSel.mc.x, _local_4);
                }
                _local_3.moveTo((tSel.mc.x + tSel.mc.width), _local_4);
                _local_3.lineTo(bgList.width, _local_4);
                bgTabs.bg.x = (tSel.mc.x - 1);
                bgTabs.bg.visible = true;
            }
            else
            {
                _local_3.lineTo(bgList.width, _local_4);
                bgTabs.bg.visible = false;
            }
        }

        private function setMessage(_arg_1:String):void
        {
            if (((!(_arg_1 == null)) && (_arg_1.length > 0)))
            {
                tMsg.text = _arg_1;
                tMsg.visible = true;
            }
            else
            {
                tMsg.text = "";
                tMsg.visible = false;
            }
        }

        override public function update(_arg_1:Object):void
        {
            if (_arg_1.eventType == itemEventType)
            {
                iSel = _arg_1.fData;
            }
            if (_arg_1.eventType == tabEventType)
            {
                iSel = null;
            }
            getLayout().update(_arg_1);
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "sModeSet")
            {
                fData = _arg_1.fData;
                fRefresh(_arg_1);
            }
            if (_arg_1.eventType == "refreshItems")
            {
                if (fData.isBank)
                {
                    itemList = getLayout().rootClass.world.bankinfo.items;
                }
                if (itemList.indexOf(iSel) == -1)
                {
                    iSel = null;
                }
                fDraw(false);
                if (refreshTabs)
                {
                    initTabs();
                }
            }
            if (_arg_1.eventType == "refreshInv")
            {
                itemList = getLayout().rootClass.world.myAvatar.filtered_inventory;
                fDraw(true);
            }
            if (_arg_1.eventType == "refreshBank")
            {
                if (fData.isBank)
                {
                    itemList = getLayout().rootClass.world.bankinfo.items;
                }
                fDraw((!(fData.isBank == null)));
            }
            if (_arg_1.eventType == "listItemASel")
            {
                fRefresh(_arg_1);
                if (filter != "")
                {
                    shadeListByTypeFilter(_arg_1.fData);
                }
            }
            if (((_arg_1.eventType == tabEventType) && (!(_arg_1.fData == null))))
            {
                if (("loadPending" in _arg_1.fData))
                {
                    if (("msg" in _arg_1.fData))
                    {
                        setMessage(_arg_1.fData.msg);
                    }
                }
            }
        }

        private function shadeListByTypeFilter(_arg_1:Object):void
        {
            var _local_2:MovieClip;
            var _local_3:Object;
            var _local_4:int;
            if (_arg_1.eSel != null)
            {
                _local_3 = _arg_1.eSel;
            }
            if (_arg_1.iSel != null)
            {
                _local_3 = _arg_1.iSel;
            }
            if (_local_3 != null)
            {
                _local_4 = 0;
                while (_local_4 < iList.numChildren)
                {
                    _local_2 = (iList.getChildAt(_local_4) as MovieClip);
                    if (((_local_2.fData[filter] == _local_3[filter]) && (!(_local_2.fData.sType == _local_3.sType))))
                    {
                        _local_2.alpha = 1;
                        _local_2.mouseEnabled = true;
                        _local_2.mouseChildren = true;
                    }
                    else
                    {
                        _local_2.alpha = 0.3;
                        _local_2.mouseEnabled = false;
                        _local_2.mouseChildren = false;
                    }
                    _local_4++;
                }
            }
        }

        public function getListItemByiSel():MovieClip
        {
            var _local_2:MovieClip;
            var _local_1:int;
            _local_1 = 0;
            while (_local_1 < iList.numChildren)
            {
                _local_2 = MovieClip(iList.getChildAt(_local_1));
                if (_local_2.fData == iSel)
                {
                    return (_local_2);
                }
                _local_1++;
            }
            return null;
        }

        public function getSelected():int
        {
            var _local_2:MovieClip;
            var _local_1:int;
            var _local_3:* = 0;
            while (_local_3 < iList.numChildren)
            {
                _local_2 = MovieClip(iList.getChildAt(_local_3));
                if (_local_2.sel)
                {
                    _local_1 = (_local_1 + 1);
                }
                _local_3++;
            }
            return (_local_1);
        }

        public function getSelectedItems():Array
        {
            var _local_2:MovieClip;
            var _local_1:Array = [];
            var _local_3:* = 0;
            while (_local_3 < iList.numChildren)
            {
                _local_2 = MovieClip(iList.getChildAt(_local_3));
                if (_local_2.sel)
                {
                    _local_1.push(_local_2.fData.ItemID);
                }
                _local_3++;
            }
            return (_local_1);
        }

        private function drawBG():void
        {
            bgList.width = w;
            bgList.height = ((h - listMask.y) + 3);
            bgList.y = listMask.y;
            listMask.width = w;
            listMask.height = ((h - listMask.y) - 0);
            scr.b.height = ((listMask.height - (2 * scr.a2.height)) + 1);
            scr.hit.height = scr.b.height;
            scr.hit.alpha = 0;
            scr.a2.y = ((scr.b.y + scr.b.height) + scr.a2.height);
            scr.x = (w + 2);
            tMsg.x = Math.round(((bgList.width / 2) - (tMsg.width / 2)));
            tMsg.y = Math.round((bgList.y + ((bgList.height / 2) - (tMsg.height / 2))));
        }


    }
}//package 

