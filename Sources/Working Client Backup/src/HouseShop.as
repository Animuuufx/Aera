// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//HouseShop

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class HouseShop extends MovieClip 
    {

        public var tabInv:MovieClip;
        public var btnPreview:SimpleButton;
        public var strGold:TextField;
        public var strCost:TextField;
        public var mcItemList:ItemList;
        public var mcCoin:MovieClip;
        public var strInfo:TextField;
        public var mcUpgrade:MovieClip;
        public var txtTitle:TextField;
        public var txtAction:TextField;
        public var bg1:MovieClip;
        public var tabShop:MovieClip;
        public var bg2:MovieClip;
        public var btnAction:SimpleButton;
        public var mcShopList:ItemList;
        public var strCoins:TextField;
        internal var rootClass:* = MovieClip(parent.parent.parent);
        internal var bitShop:Boolean = true;

        public function HouseShop()
        {
            bg1.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            btnPreview.addEventListener(MouseEvent.CLICK, onPreviewClick, false, 0, true);
            btnAction.addEventListener(MouseEvent.CLICK, onActionClick, false, 0, true);
            tabShop.addEventListener(MouseEvent.CLICK, onClickShop, false, 0, true);
            tabInv.addEventListener(MouseEvent.CLICK, onClickInv, false, 0, true);
            mcShopList.inventorySlot = rootClass.world.shopinfo.items.length;
            mcShopList.init(rootClass.world.shopinfo.items);
            mcItemList.inventorySlot = rootClass.world.myAvatar.houseitems.length;
            mcItemList.init(rootClass.world.myAvatar.houseitems);
            txtAction.mouseEnabled = false;
            updateGoldCoin();
            onClickShop(null);
        }

        internal function onCloseClick(_arg_1:Event):*
        {
            MovieClip(parent).onClose();
        }

        public function refreshDetail():void
        {
            if (selectedItem == null)
            {
                strInfo.htmlText = "Please select an item to view details.";
                txtAction.visible = false;
                btnAction.visible = false;
                btnPreview.visible = false;
                strCost.text = "";
                mcCoin.visible = (mcUpgrade.visible = false);
            }
            else
            {
                showItemDetail();
            };
        }

        public function get selectedItem():Object
        {
            if (bitShop)
            {
                return (mcShopList.selectedItem);
            };
            return (mcItemList.selectedItem);
        }

        public function showItemDetail():void
        {
            var _local_1:Object;
            var _local_2:* = "#CC9900";
            if (bitShop)
            {
                _local_1 = mcShopList.selectedItem;
                strInfo.htmlText = rootClass.getItemInfoString(_local_1);
                if ((((_local_1.bCoins == 0) && (_local_1.iCost > rootClass.world.myAvatar.objData.intGold)) || ((_local_1.bCoins == 1) && (_local_1.iCost > rootClass.world.myAvatar.objData.intCoins))))
                {
                    _local_2 = "#CC0000";
                };
                if (_local_1.bCoins == 0)
                {
                    strCost.htmlText = (((("<font size='14' color='" + _local_2) + "'><b>") + Number(_local_1.iCost)) + " Gold</b></font>");
                }
                else
                {
                    strCost.htmlText = (((("<font size='14' color='" + _local_2) + "'><b>") + Number(_local_1.iCost)) + " ACs</b></font>");
                };
                txtAction.text = "Buy";
                btnPreview.visible = true;
            }
            else
            {
                _local_1 = mcItemList.selectedItem;
                strInfo.htmlText = rootClass.getItemInfoString(_local_1);
                if (_local_1.bCoins == 0)
                {
                    if (rootClass.world.myAvatar.objData.intGold > 100000000)
                    {
                        strCost.htmlText = (("<font size='14' color='" + _local_2) + "'><b>0 Gold</b></font>");
                    }
                    else
                    {
                        strCost.htmlText = (((("<font size='14' color='" + _local_2) + "'><b>") + Math.ceil((_local_1.iCost / 4))) + " Gold</b></font>");
                    };
                }
                else
                {
                    if (_local_1.iHrs < 24)
                    {
                        strCost.htmlText = (((("<font size='14' color='" + _local_2) + "'><b>") + Math.ceil(((_local_1.iCost * 9) / 10))) + " ACs</b></font>");
                    }
                    else
                    {
                        strCost.htmlText = (((("<font size='14' color='" + _local_2) + "'><b>") + Math.ceil((_local_1.iCost / 4))) + " ACs</b></font>");
                    };
                };
                txtAction.text = "Sell";
                btnPreview.visible = false;
            };
            txtAction.visible = true;
            btnAction.visible = true;
            mcCoin.visible = (_local_1.bCoins == 1);
            mcUpgrade.visible = (_local_1.bUpg == 1);
        }

        public function updateGoldCoin():void
        {
            strGold.text = rootClass.world.myAvatar.objData.intGold;
            strCoins.text = rootClass.world.myAvatar.objData.intCoins;
        }

        internal function onClickShop(_arg_1:Event):*
        {
            tabShop.select();
            tabInv.unselect();
            mcShopList.visible = true;
            mcItemList.visible = false;
            txtTitle.text = "Shop";
            bitShop = true;
            refreshDetail();
        }

        internal function onClickInv(_arg_1:Event):*
        {
            tabShop.unselect();
            tabInv.select();
            mcShopList.visible = false;
            mcItemList.visible = true;
            txtTitle.text = "Inventory";
            bitShop = false;
            refreshDetail();
        }

        public function onActionClick(_arg_1:Event):*
        {
            if (bitShop)
            {
                onBuyClick();
            }
            else
            {
                onSellClick();
            };
        }

        public function onBuyClick():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            if ((((rootClass.world.shopinfo.bStaff == 1) || (mcShopList.selectedItem.bStaff == 1)) && (rootClass.world.myAvatar.objData.intAccessLevel < 40)))
            {
                rootClass.MsgBox.notify("Test Item.. cannot be purchased yet!");
            }
            else
            {
                if (((!(rootClass.world.shopinfo.sField == "")) && (!(rootClass.world.getAchievement(rootClass.world.shopinfo.sField, rootClass.world.shopinfo.iIndex) == 1))))
                {
                    rootClass.MsgBox.notify("Item requires special requirement!");
                }
                else
                {
                    if (((mcShopList.selectedItem.bUpg == 1) && (!(rootClass.world.myAvatar.isUpgraded()))))
                    {
                        rootClass.showUpgradeWindow();
                    }
                    else
                    {
                        if (((mcShopList.selectedItem.FactionID > 1) && (rootClass.world.myAvatar.getRep(mcShopList.selectedItem.FactionID) < mcShopList.selectedItem.iReqRep)))
                        {
                            rootClass.MsgBox.notify("Item Locked: Reputation Requirement not met.");
                        }
                        else
                        {
                            if (((mcShopList.selectedItem.iClass > 0) && (rootClass.world.myAvatar.getCPByID(mcShopList.selectedItem.iClass) < mcShopList.selectedItem.iReqCP)))
                            {
                                rootClass.MsgBox.notify("Item Locked: Class Requirement not met.");
                            }
                            else
                            {
                                if ((((rootClass.world.myAvatar.isItemInInventory(mcShopList.selectedItem.ItemID)) || (rootClass.world.myAvatar.isItemInBank(mcShopList.selectedItem.ItemID))) && (rootClass.world.myAvatar.isItemStackMaxed(mcShopList.selectedItem.ItemID))))
                                {
                                    _local_1 = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
                                    rootClass.MsgBox.notify((("You cannot have more than " + _local_1[mcShopList.selectedItem.iStk]) + " of that item!"));
                                }
                                else
                                {
                                    if ((((mcShopList.selectedItem.bCoins == 0) && (mcShopList.selectedItem.iCost > rootClass.world.myAvatar.objData.intGold)) || ((mcShopList.selectedItem.bCoins == 1) && (mcShopList.selectedItem.iCost > rootClass.world.myAvatar.objData.intCoins))))
                                    {
                                        rootClass.MsgBox.notify("Insufficient Funds!");
                                    }
                                    else
                                    {
                                        if (rootClass.world.myAvatar.houseitems.length >= rootClass.world.myAvatar.objData.iHouseSlots)
                                        {
                                            rootClass.MsgBox.notify("House Inventory Full!");
                                        }
                                        else
                                        {
                                            _local_2 = new ModalMC();
                                            _local_3 = {};
                                            _local_3.strBody = (('Are you sure you want to buy "' + mcShopList.selectedItem.sName) + '"?');
                                            _local_3.params = {};
                                            _local_3.params.item = mcShopList.selectedItem;
                                            _local_3.callback = buyRequest;
                                            rootClass.ui.ModalStack.addChild(_local_2);
                                            _local_2.init(_local_3);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function buyRequest(_arg_1:*):void
        {
            if (_arg_1.accept)
            {
                rootClass.world.sendBuyItemRequest(_arg_1.item);
            };
        }

        public function onSellClick():void
        {
            var _local_1:*;
            var _local_2:*;
            if (mcItemList.selectedItem.bEquip)
            {
                rootClass.MsgBox.notify("Item is currently equipped!");
            }
            else
            {
                if (mcItemList.selectedItem.bTemp == 0)
                {
                    _local_1 = new ModalMC();
                    _local_2 = {};
                    _local_2.strBody = (('Are you sure you want to sell "' + mcItemList.selectedItem.sName) + '"?');
                    _local_2.params = {};
                    _local_2.params.item = mcItemList.selectedItem;
                    _local_2.callback = sellRequest;
                    rootClass.ui.ModalStack.addChild(_local_1);
                    _local_1.init(_local_2);
                };
            };
        }

        public function sellRequest(_arg_1:*):void
        {
            if (_arg_1.accept)
            {
                rootClass.world.sendSellItemRequest(_arg_1.item);
            };
        }

        public function onPreviewClick(_arg_1:Event):*
        {
            var _local_3:*;
            var _local_2:* = mcShopList.selectedItem;
            if ((((_local_2.sType == "Floor Item") || (_local_2.sType == "Wall Item")) || (_local_2.sType == "House")))
            {
                _local_3 = rootClass.attachOnModalStack("ItemPreview");
                _local_3.loadItem(_local_2);
            };
        }

        public function reset():void
        {
            mcItemList.inventorySlot = rootClass.world.myAvatar.houseitems.length;
            mcItemList.init(rootClass.world.myAvatar.houseitems);
            updateGoldCoin();
        }


    }
}//package 

