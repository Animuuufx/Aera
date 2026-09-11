// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ItemList

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.geom.Rectangle;

    public class ItemList extends MovieClip 
    {

        public var mcSort:MovieClip;
        public var btnUp:SimpleButton;
        public var btnDown:SimpleButton;
        public var mcScrollBar:MovieClip;
        internal var rootClass:MovieClip = MovieClip(Game.root);
        internal var inventorySlot:Number = 20;
        internal var intSelected:Number = -1;
        internal var intPlacement:Number = 0;
        internal var itemList:Array;
        internal var sortedList:Array;
        internal var strSortBy:String = "all";

        public function ItemList()
        {
            var _local_2:MovieClip;
            super();
            mcSort.visible = false;
            mcScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            btnUp.addEventListener(MouseEvent.CLICK, onBtnClickHandler, false, 0, true);
            btnDown.addEventListener(MouseEvent.CLICK, onBtnClickHandler, false, 0, true);
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = new InventoryItem();
                _local_2.name = ("mcInventoryItem" + _local_1);
                _local_2.y = (22 * _local_1);
                _local_2.strIndex.text = "";
                _local_2.strName.text = "";
                _local_2.strLevel.text = "";
                _local_2.intIndex = -1;
                this.addChild(_local_2);
                _local_1++;
            };
            mcSort.btnAll.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnArmor.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnWeapon.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnHelm.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnBack.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnPet.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnItem.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
            mcSort.btnDesign.addEventListener(MouseEvent.CLICK, onSortClick, false, 0, true);
        }

        private function onSortClick(_arg_1:Event):void
        {
            switch (_arg_1.target.name)
            {
                case "btnAll":
                    sortBy("all");
                    return;
                case "btnArmor":
                    sortBy("armor");
                    return;
                case "btnWeapon":
                    sortBy("weapon");
                    return;
                case "btnHelm":
                    sortBy("helm");
                    return;
                case "btnBack":
                    sortBy("back");
                    return;
                case "btnPet":
                    sortBy("pet");
                    return;
                case "btnItem":
                    sortBy("item");
                    return;
                case "btnDesign":
                    sortBy("design");
                    return;
            };
        }

        public function sort():void
        {
            sortBy(strSortBy);
        }

        public function sortBy(_arg_1:String):void
        {
            var _local_4:Object;
            strSortBy = _arg_1.toLowerCase();
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < itemList.length)
            {
                _local_4 = itemList[_local_3];
                switch (_arg_1.toLowerCase())
                {
                    case "all":
                        _local_2.push(_local_4);
                        break;
                    case "armor":
                        if (((_local_4.sES == "ar") || (_local_4.sES == "co")))
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "weapon":
                        if (_local_4.sES == "Weapon")
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "helm":
                        if (_local_4.sES == "he")
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "back":
                        if (_local_4.sES == "ba")
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "pet":
                        if (_local_4.sES == "pe")
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "item":
                        if (_local_4.sES == "None")
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "design":
                        if ((((!(_local_4.sES == "co")) && (!(_local_4.sES == "None"))) && (!(_local_4.EnhID > 0))))
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "nonac":
                        if (_local_4.bCoins == 0)
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    case "ac":
                        if (_local_4.bCoins == 1)
                        {
                            _local_2.push(_local_4);
                        };
                        break;
                    default:
                        _local_2.push(_local_4);
                };
                _local_3++;
            };
            inventorySlot = _local_2.length;
            sortedList = _local_2;
            reset();
        }

        private function get intScrollCount():Number
        {
            return (inventorySlot - 10);
        }

        public function clearSelection():void
        {
            var _local_1:* = MovieClip(this.getChildByName(("mcInventoryItem" + (intSelected - intPlacement))));
            if (_local_1 != null)
            {
                _local_1.reset();
            };
            intSelected = -1;
            if (intPlacement != 0)
            {
                intPlacement = 0;
                mcScrollBar.mcSlider.y = 0;
            };
            MovieClip(parent).refreshDetail();
        }

        public function init(_arg_1:Array):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            itemList = _arg_1;
            if (itemList == rootClass.world.myAvatar.items)
            {
                mcSort.visible = true;
            };
            mcScrollBar.mcSlider.visible = (intScrollCount > 0);
            sort();
        }

        public function reset():void
        {
            clearSelection();
            refreshList();
        }

        public function refreshList():void
        {
            var _local_2:Object;
            var _local_3:MovieClip;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:Class;
            var _local_10:*;
            var _local_11:Class;
            var _local_12:MovieClip;
            var _local_13:Number;
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = sortedList[(_local_1 + intPlacement)];
                _local_3 = MovieClip(this.getChildByName(("mcInventoryItem" + _local_1)));
                _local_3.strIndex.text = ((_local_1 + intPlacement) + 1);
                if (intSelected == (_local_1 + intPlacement))
                {
                    _local_3.select();
                }
                else
                {
                    _local_3.reset();
                };
                _local_3.intIndex = (_local_1 + intPlacement);
                if (_local_2 == null)
                {
                    _local_3.clearText();
                    _local_3.unequip();
                }
                else
                {
                    if (_local_2.sType == "Enhancement")
                    {
                        _local_2.sIcon = getESIcon(_local_2.sES);
                        _local_2.EnhLvl = _local_2.iLvl;
                    };
                    _local_4 = "#E6E2DB";
                    if (_local_2.bUpg == 1)
                    {
                        _local_4 = "#FFB817";
                    };
                    _local_3.strName.htmlText = (((("<font color='" + _local_4) + "'>") + _local_2.sName) + "</font>");
                    if (_local_2.EnhLvl != null)
                    {
                        _local_3.strLevel.text = ("Lvl " + _local_2.EnhLvl);
                    }
                    else
                    {
                        _local_3.strLevel.text = "";
                    };
                    if (_local_2.bEquip)
                    {
                        _local_3.equip();
                    }
                    else
                    {
                        _local_3.unequip();
                    };
                    _local_5 = 21;
                    _local_6 = 19;
                    _local_7 = _local_5;
                    _local_8 = _local_6;
                    _local_3.icon.removeAllChildren();
                    if ((((!(_local_2.sIcon == null)) && (!(_local_2.sIcon == ""))) && (!(_local_2.sIcon == "none"))))
                    {
                        try
                        {
                            _local_9 = (rootClass.world.getClass(_local_2.sIcon) as Class);
                            _local_10 = _local_3.icon.addChild(new (_local_9)());
                            _local_7 = _local_10.width;
                            _local_8 = _local_10.height;
                            if (_local_7 > _local_8)
                            {
                                _local_10.scaleX = (_local_10.scaleY = (_local_5 / _local_7));
                            }
                            else
                            {
                                _local_10.scaleX = (_local_10.scaleY = (_local_6 / _local_8));
                            };
                            _local_3.icon.visible = true;
                        }
                        catch(err:Error)
                        {
                        };
                    };
                    if (((isEnhanceable(_local_2.sES)) && (!(_local_2.EnhID > 0))))
                    {
                        _local_11 = (rootClass.world.getClass("iidesign") as Class);
                        _local_12 = new (_local_11)();
                        _local_12.alpha = 0.4;
                        _local_7 = _local_12.width;
                        _local_8 = _local_12.height;
                        if (_local_7 > _local_8)
                        {
                            _local_12.scaleX = (_local_12.scaleY = (_local_5 / _local_7));
                        }
                        else
                        {
                            _local_12.scaleX = (_local_12.scaleY = (_local_6 / _local_8));
                        };
                        _local_3.icon.addChild(_local_12);
                    };
                    if (((_local_2.sES == "ar") && (_local_2.EnhID > 0)))
                    {
                        _local_13 = rootClass.getRankFromPoints(_local_2.iQty);
                        _local_3.strName.htmlText = (_local_3.strName.htmlText + ((" <font color='#999999'>(Rank " + _local_13) + ")</font>"));
                    };
                    if (_local_2.iStk > 1)
                    {
                        _local_3.strName.htmlText = (_local_3.strName.htmlText + ((" <font color='#999999'>x" + _local_2.iQty) + "</font>"));
                    };
                };
                _local_1++;
            };
        }

        public function isEnhanceable(_arg_1:String):Boolean
        {
            var _local_2:Array = ["Weapon", "he", "ba", "pe", "ar"];
            return (_local_2.indexOf(_arg_1) >= 0);
        }

        public function getESIcon(_arg_1:String):String
        {
            switch (_arg_1)
            {
                case "Weapon":
                    return ("iwsword");
                case "he":
                    return ("iihelm");
                case "ba":
                    return ("iicape");
                case "pe":
                    return ("iipet");
                case "ar":
                    return ("iiclass");
                case "co":
                    return ("iwarmor");
                case "ho":
                    return ("ihhouse");
                default:
                    return ("none");
            };
        }

        public function selectItem(_arg_1:int):void
        {
            var _local_3:*;
            if (_arg_1 == -1)
            {
                return;
            };
            if ((((intSelected - intPlacement) >= 0) && ((intSelected - intPlacement) < 10)))
            {
                _local_3 = MovieClip(this.getChildByName(("mcInventoryItem" + (intSelected - intPlacement))));
                _local_3.reset();
            };
            rootClass.mixer.playSound("Click");
            intSelected = _arg_1;
            var _local_2:* = MovieClip(this.getChildByName(("mcInventoryItem" + (intSelected - intPlacement))));
            _local_2.select();
            MovieClip(parent).refreshDetail();
        }

        internal function get selectedItem():Object
        {
            if (itemList == null)
            {
                return (null);
            };
            return (sortedList[intSelected]);
        }

        internal function mouseDownHandler(_arg_1:Event):void
        {
            mcScrollBar.mcSlider.startDrag(false, new Rectangle(0, 0, 0, 103));
            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
        }

        internal function mouseUpHandler(_arg_1:Event):void
        {
            mcScrollBar.mcSlider.stopDrag();
            stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }

        internal function mouseMoveHandler(_arg_1:Event):void
        {
            var _local_2:int = int(((mcScrollBar.mcSlider.y * intScrollCount) / 103));
            if (((_local_2 >= 0) && (_local_2 <= intScrollCount)))
            {
                intPlacement = _local_2;
            };
            refreshList();
        }

        private function onBtnClickHandler(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.name == "btnUp")
            {
                if (intPlacement > 0)
                {
                    intPlacement--;
                };
            }
            else
            {
                if (_arg_1.currentTarget.name == "btnDown")
                {
                    if (intPlacement < intScrollCount)
                    {
                        intPlacement++;
                    };
                };
            };
            refreshList();
            mcScrollBar.mcSlider.y = Math.ceil(((intPlacement * 103) / intScrollCount));
        }


    }
}//package 

