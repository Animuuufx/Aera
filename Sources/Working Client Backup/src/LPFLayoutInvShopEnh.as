// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFLayoutInvShopEnh

package 
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.text.*;

    public class LPFLayoutInvShopEnh extends LPFLayout 
    {

        private var aSel:String = "";
        private var bSel:String = "";
        public var iQty:int = 1;
        public var iSel:Object;
        public var eSel:Object;
        public var shopinfo:Object;
        public var itemsInv:Array;
        public var itemsShop:Array;
        public var multiPanel:MovieClip;
        public var splitPanel:MovieClip;
        public var previewPanel:MovieClip;
        public var rootClass:MovieClip;

        public function LPFLayoutInvShopEnh():void
        {
            x = 0;
            y = 0;
            panels = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_4:Object;
            var _local_5:MovieClip;
            rootClass = MovieClip(stage.getChildAt(0));
            fData = _arg_1.fData;
            sMode = _arg_1.sMode;
            if (("itemsInv" in fData))
            {
                itemsInv = fData.itemsInv;
            };
            if (("itemsShop" in fData))
            {
                itemsShop = fData.itemsShop;
            };
            if (("shopinfo" in fData))
            {
                shopinfo = fData.shopinfo;
            };
            _local_2 = _arg_1.r;
            var _local_3:* = "";
            x = _local_2.x;
            y = _local_2.y;
            w = _local_2.w;
            h = _local_2.h;
            tempFill();
            _local_4 = {};
            _local_4.panel = new LPFPanelListShopInvB();
            _local_3 = "EnhInventory";
            _local_4.fData = {
                "items":itemsInv,
                "sName":_local_3
            };
            _local_4.r = {
                "x":322,
                "y":3,
                "w":316,
                "h":495
            };
            _local_4.closeType = "hide";
            _local_4.hideDir = "right";
            _local_4.hidePad = 3;
            _local_4.isOpen = false;
            splitPanel = addPanel(_local_4);
            splitPanel.visible = false;
            splitPanel.fHide();
            _local_4 = {};
            _local_4.panel = new LPFPanelPreview();
            _local_3 = "Preview";
            _local_4.fData = {"sName":_local_3};
            _local_4.r = {
                "x":322,
                "y":78,
                "w":316,
                "h":420
            };
            _local_4.closeType = "hide";
            _local_4.xBuffer = 3;
            _local_4.showDragonLeft = true;
            _local_4.isOpen = false;
            previewPanel = addPanel(_local_4);
            previewPanel.visible = false;
            previewPanel.addEventListener(Event.ENTER_FRAME, previewPanelEF, false, 0, true);
            _local_4 = {};
            _local_4.panel = new LPFPanelListShopInvA();
            _local_3 = ((sMode.toLowerCase().indexOf("shop") > -1) ? rootClass.world.shopinfo.sName : "Inventory");
            _local_4.fData = {
                "items":((itemsShop != null) ? itemsShop : itemsInv),
                "itemsInv":itemsInv,
                "objData":fData.objData,
                "sName":_local_3
            };
            if (shopinfo != null)
            {
                _local_4.fData.shopinfo = shopinfo;
            };
            _local_4.r = {
                "x":641,
                "y":3,
                "w":316,
                "h":495
            };
            _local_4.closeType = "close";
            _local_4.showDragonRight = true;
            _local_4.isOpen = true;
            multiPanel = addPanel(_local_4);
            updatePreviewButtons();
            rootClass.dropStackBoost();
        }

        override public function fClose():void
        {
            var _local_1:MovieClip;
            rootClass.dropStackReset();
            previewPanel.removeEventListener(Event.ENTER_FRAME, previewPanelEF);
            while (panels.length > 0)
            {
                panels[0].mc.fClose();
                panels.shift();
            };
            if (parent != null)
            {
                _local_1 = MovieClip(parent);
                _local_1.removeChild(this);
                _local_1.onClose();
            };
        }

        override protected function handleUpdate(_arg_1:Object):Object
        {
            var _local_3:Object;
            var _local_8:Array;
            var _local_9:*;
            var _local_10:Object;
            var _local_11:String;
            var _local_12:*;
            var _local_13:*;
            var _local_14:Object;
            var _local_2:Boolean;
            var _local_4:Object = iSel;
            var _local_5:Object = eSel;
            var _local_6:Object;
            var _local_7:Object;
            if (((!(iSel == null)) && (!(eSel == null))))
            {
                previewPanel.bg.tTitle.text = "Create";
            }
            else
            {
                previewPanel.bg.tTitle.text = "Preview";
            };
            if (_arg_1.eventType == "sModeSet")
            {
                if (sMode != _arg_1.sModeBroadcast)
                {
                    sMode = _arg_1.sModeBroadcast;
                    iSel = null;
                    eSel = null;
                    _arg_1.iSel = iSel;
                    _local_8 = itemsInv;
                    if (sMode == "shopBuy")
                    {
                        _local_8 = itemsShop;
                    };
                    _arg_1.fData = {"list":_local_8};
                    splitPanel.fHide();
                    previewPanel.fHide();
                };
            };
            if (_arg_1.eventType == "listItemASel")
            {
                if (!rootClass.isGreedyModalInStack())
                {
                    iQty = 1;
                    eSel = null;
                    iSel = null;
                    aSel = _arg_1.fData.sType.toLowerCase();
                    bSel = "";
                    if (aSel == "enhancement")
                    {
                        eSel = _arg_1.fData;
                    }
                    else
                    {
                        iSel = _arg_1.fData;
                    };
                    if (_arg_1.fData.sType.toLowerCase() == "enhancement")
                    {
                        _arg_1.tabStates = getTabStates(_arg_1.fData);
                    }
                    else
                    {
                        _arg_1.tabStates = getTabStates({"sES":"enh"});
                    };
                    _arg_1.fData = {
                        "iSel":iSel,
                        "eSel":eSel,
                        "oSel":_arg_1.fData
                    };
                    splitPanel.fHide();
                    previewPanel.fShow();
                    if (((!(iSel == null)) && (eSel == null)))
                    {
                        splitPanel.bg.tTitle.text = "Select Enhancement to Apply";
                    };
                    if (((iSel == null) && (!(eSel == null))))
                    {
                        splitPanel.bg.tTitle.text = ((sMode == "shopBuy") ? "Select Items to Enhance" : "Select Item to Enhance");
                    };
                }
                else
                {
                    _local_2 = true;
                };
            };
            if (_arg_1.eventType == "listItemBSel")
            {
                if (!rootClass.isGreedyModalInStack())
                {
                    _local_3 = rootClass.copyObj(_arg_1);
                    _local_3.eventType = "listItemBSolo";
                    if (_arg_1.fData.sType.toLowerCase() == "enhancement")
                    {
                        _local_3.fData = {
                            "iSel":null,
                            "eSel":_local_3.fData
                        };
                    }
                    else
                    {
                        _local_3.fData = {
                            "iSel":_local_3.fData,
                            "eSel":null
                        };
                    };
                    if (bSel == "enhancement")
                    {
                        eSel = null;
                    }
                    else
                    {
                        if (bSel != "")
                        {
                            iSel = null;
                        };
                    };
                    bSel = _arg_1.fData.sType.toLowerCase();
                    if (bSel == "enhancement")
                    {
                        eSel = _arg_1.fData;
                    }
                    else
                    {
                        iSel = _arg_1.fData;
                    };
                    _arg_1.fData = {
                        "iSel":iSel,
                        "eSel":eSel
                    };
                    if (((!(_local_4 == iSel)) || (!(_local_5 == eSel))))
                    {
                        notifyByEventType(_local_3);
                    };
                    previewPanel.fShow();
                }
                else
                {
                    _local_2 = true;
                };
            };
            if (_arg_1.eventType == "refreshItems")
            {
                if (itemsInv.indexOf(iSel) == -1)
                {
                    iSel = null;
                };
                if (itemsInv.indexOf(eSel) == -1)
                {
                    eSel = null;
                };
                _arg_1.fData = {
                    "iSel":iSel,
                    "eSel":eSel
                };
                if (("sInstruction" in _arg_1))
                {
                    if (_arg_1.sInstruction == "closeWindows")
                    {
                        splitPanel.fHide();
                        previewPanel.fHide();
                    };
                    if (_arg_1.sInstruction == "previewEquipOnly")
                    {
                        splitPanel.fHide();
                        if (((!(iSel == null)) && (!(iSel.bEquip == 1))))
                        {
                            _local_6 = {};
                            _local_6.eventType = "previewButton1Update";
                            _local_6.fData = {};
                            _local_6.fData.sText = "Equip";
                            _local_6.sMode = "red";
                            _local_6.r = {
                                "x":-1,
                                "y":-40,
                                "w":-1,
                                "h":-1
                            };
                            _local_6.buttonNewEventType = "equipItem";
                            _local_7 = {};
                            _local_7.eventType = "previewButton2Update";
                            _local_7.fData = {};
                            _local_7.fData.sText = "";
                            _local_7.sMode = "grey";
                            _local_7.r = {
                                "x":173,
                                "y":-40,
                                "w":-1,
                                "h":-1
                            };
                        }
                        else
                        {
                            previewPanel.fHide();
                        };
                    };
                };
                if (((iSel == null) && (eSel == null)))
                {
                    splitPanel.fHide();
                    previewPanel.fHide();
                };
            };
            if (_arg_1.eventType == "refreshShop")
            {
                rootClass.world.sendReloadShopRequest(shopinfo.ShopID);
                _local_2 = true;
            };
            if (_arg_1.eventType == "showItemListB")
            {
                if (!rootClass.isGreedyModalInStack())
                {
                    splitPanel.fShow();
                }
                else
                {
                    _local_2 = true;
                };
            };
            if (_arg_1.eventType == "showItemListBNoBtns")
            {
                if (!rootClass.isGreedyModalInStack())
                {
                    _local_6 = {};
                    _local_6.eventType = "previewButton1Update";
                    _local_6.fData = {};
                    _local_6.fData.sText = "";
                    _local_7 = {};
                    _arg_1.eventType = "showItemListB";
                    splitPanel.fShow();
                }
                else
                {
                    _local_2 = true;
                };
            };
            if (((_arg_1.eventType == "equipItem") || (_arg_1.eventType == "unequipItem")))
            {
                if (!rootClass.isGreedyModalInStack())
                {
                    if (iSel != null)
                    {
                        if (((iSel.sES == "Weapon") && (_arg_1.eventType == "unequipItem")))
                        {
                            if (rootClass.world.myAvatar.getItemByID(156) != null)
                            {
                                rootClass.toggleItemEquip(rootClass.world.myAvatar.getItemByID(156));
                                splitPanel.fHide();
                                previewPanel.fHide();
                            }
                            else
                            {
                                rootClass.MsgBox.notify("Selected Item cannot be unequipped!");
                            };
                        }
                        else
                        {
                            if (((rootClass.toggleItemEquip(iSel)) && (_arg_1.eventType == "equipItem")))
                            {
                                splitPanel.fHide();
                                previewPanel.fHide();
                            };
                        };
                    };
                }
                else
                {
                    _local_2 = true;
                };
            };
            if (_arg_1.eventType == "consumePotion")
            {
                if (((iSel.bEquip == 1) || (rootClass.toggleItemEquip(iSel))))
                {
                    rootClass.equipPotionOnSeia = true;
                    splitPanel.fHide();
                    previewPanel.fHide();
                };
            };
            if (_arg_1.eventType == "enhanceItem")
            {
                if (!rootClass.isGreedyModalInStack())
                {
                    if (((!(iSel == null)) && (!(eSel == null))))
                    {
                        rootClass.tryEnhance(splitPanel.frames[2].mc.getSelectedItems(), eSel, (sMode == "shopBuy"));
                    };
                }
                else
                {
                    _local_2 = true;
                };
            };
            if (_arg_1.eventType == "buyItem")
            {
                _local_9 = ((iSel != null) ? iSel : eSel);
                if (_local_9 != null)
                {
                    if (_local_9.iCost <= 0)
                    {
                        _local_10 = {
                            "accept":true,
                            "iSel":_local_9,
                            "iQty":iQty
                        };
                        rootClass.world.sendBuyItemRequestWithQuantity(_local_10);
                    }
                    else
                    {
                        _local_11 = (("Are you sure you want to buy '" + _local_9.sName) + "'?");
                        if (iQty > 1)
                        {
                            _local_11 = (((("Are you sure you want to buy " + String(iQty)) + "x '") + _local_9.sName) + "'?");
                        };
                        _local_12 = new ModalMC();
                        _local_13 = {};
                        _local_13.strBody = _local_11;
                        _local_13.params = {
                            "iSel":_local_9,
                            "iQty":iQty
                        };
                        _local_13.callback = rootClass.world.sendBuyItemRequestWithQuantity;
                        _local_13.glow = "white,medium";
                        _local_13.greedy = false;
                        rootClass.ui.ModalStack.addChild(_local_12);
                        _local_12.init(_local_13);
                    };
                };
            };
            if (_arg_1.eventType == "useItem")
            {
                if (iSel != null)
                {
                    rootClass.world.tryUseItem(iSel);
                };
            };
            if (_arg_1.eventType == "sellItem")
            {
                if (iSel != null)
                {
                    _local_14 = iSel;
                }
                else
                {
                    if (eSel != null)
                    {
                        _local_14 = eSel;
                    };
                };
                if (((((_local_14.bEquip) && (!(_local_14.sType == "Floor Item"))) && (!(_local_14.sType == "Wall Item"))) || (_local_14.bEquip >= _local_14.iQty)))
                {
                    if (((_local_14.sType == "Floor Item") || (_local_14.sType == "Wall Item")))
                    {
                        rootClass.MsgBox.notify("Item is currently placed in your house!");
                    }
                    else
                    {
                        rootClass.MsgBox.notify("Item is currently equipped!");
                    };
                }
                else
                {
                    if (((((_local_14.bCoins == 1) && (_local_14.iHrs == null)) && (!(_local_14.ItemID == 8939))) && (!(_local_14.iCost == 0))))
                    {
                        rootClass.MsgBox.notify("Cannot be sold, free storage in your bank!");
                    }
                    else
                    {
                        if ((((_local_14) && (_local_14.hasOwnProperty("sMeta"))) && (_local_14.sMeta.toString().indexOf("NoSell") > -1)))
                        {
                            rootClass.MsgBox.notify("This item cannot be sold!");
                        }
                        else
                        {
                            _local_11 = (("Are you sure you want to sell '" + _local_14.sName) + "'?");
                            if (iQty > 1)
                            {
                                _local_11 = (((("Are you sure you want to sell " + String(iQty)) + "x '") + _local_14.sName) + "'?");
                            };
                            _local_12 = new ModalMC();
                            _local_13 = {};
                            _local_13.strBody = _local_11;
                            _local_13.params = {
                                "iSel":_local_14,
                                "iQty":iQty
                            };
                            _local_13.callback = rootClass.world.sendSellItemRequestWithQuantity;
                            _local_13.glow = "white,medium";
                            _local_13.greedy = false;
                            rootClass.ui.ModalStack.addChild(_local_12);
                            _local_12.init(_local_13);
                        };
                    };
                };
            };
            if (_arg_1.eventType == "buyBagSlots")
            {
                _local_2 = true;
                rootClass.world.loadMovieFront(rootClass.bagSpace, "Inline Asset");
                fClose();
            };
            if (_arg_1.eventType == "toggleHouseInventory")
            {
                if (!rootClass.world.uiLock)
                {
                    rootClass.ui.mcPopup.fOpen("HouseInventory");
                };
            };
            if (_arg_1.eventType == "helpAC")
            {
                _local_2 = true;
                rootClass.world.loadMovieFront("interface/goldAC5.swf", "Inline Asset");
            };
            if (_arg_1.eventType == "hideItem")
            {
                if (rootClass.world.coolDown("unwearItem"))
                {
                    rootClass.sfc.sendXtMessage("zm", "unwearItem", [iSel.sES], "str", rootClass.world.curRoom);
                };
                splitPanel.fHide();
                previewPanel.fHide();
            };
            if (_arg_1.eventType == "showItem")
            {
                if (((iSel.bUpg == 1) && (!(rootClass.world.myAvatar.isUpgraded()))))
                {
                    rootClass.showUpgradeWindow();
                }
                else
                {
                    if (rootClass.world.coolDown("wearItem"))
                    {
                        rootClass.sfc.sendXtMessage("zm", "wearItem", [iSel.ItemID], "str", rootClass.world.curRoom);
                    };
                    splitPanel.fHide();
                    previewPanel.fHide();
                };
            };
            updatePreviewButtons(_local_6, _local_7);
            _local_4 = null;
            _local_5 = null;
            if (!_local_2)
            {
                return (_arg_1);
            };
            return (null);
        }

        private function updatePreviewButtons(_arg_1:Object=null, _arg_2:Object=null):void
        {
            var _local_5:String;
            var _local_6:String;
            var _local_7:Boolean;
            var _local_3:Object = {};
            var _local_4:Object = {};
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                _local_3 = _arg_1;
                _local_4 = _arg_2;
            }
            else
            {
                _local_3.eventType = "previewButton1Update";
                _local_3.fData = {};
                _local_3.fData.sText = "";
                _local_3.sMode = "grey";
                _local_3.r = {
                    "x":46,
                    "y":-40,
                    "w":-1,
                    "h":-1
                };
                _local_3.buttonNewEventType = "";
                _local_4.eventType = "previewButton2Update";
                _local_4.fData = {};
                _local_4.fData.sText = "";
                _local_4.sMode = "grey";
                _local_4.r = {
                    "x":173,
                    "y":-40,
                    "w":-1,
                    "h":-1
                };
                _local_4.buttonNewEventType = "";
                if (sMode == "inventory")
                {
                    if (((iSel == null) && (eSel == null)))
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                        _local_4.fData.sText = "";
                        _local_4.buttonNewEventType = "";
                    }
                    else
                    {
                        if (((!(iSel == null)) && (!(eSel == null))))
                        {
                            _local_3.fData.sText = "Enhance!";
                            _local_3.buttonNewEventType = "enhanceItem";
                            _local_3.sMode = "red";
                            if (iSel.bEquip == 1)
                            {
                                _local_4.fData.sText = "Unequip";
                                _local_4.buttonNewEventType = "unequipItem";
                            }
                            else
                            {
                                _local_4.fData.sText = "Equip";
                                _local_4.buttonNewEventType = "equipItem";
                                if (_local_3.sMode != "red")
                                {
                                    _local_4.sMode = "red";
                                };
                            };
                        }
                        else
                        {
                            if (eSel != null)
                            {
                                _local_3.fData.sText = "";
                                _local_3.buttonNewEventType = "";
                                _local_4.fData.sText = "Apply Now";
                                _local_4.buttonNewEventType = "showItemListB";
                                _local_4.sMode = "red";
                            }
                            else
                            {
                                if (iSel != null)
                                {
                                    if (["Weapon", "he", "ar", "ba"].indexOf(iSel.sES) > -1)
                                    {
                                        if ((((iSel.bUpg == 1) && (rootClass.world.myAvatar.isUpgraded())) || (iSel.bUpg == 0)))
                                        {
                                            if (iSel.sES != "ar")
                                            {
                                                if (iSel.bWear)
                                                {
                                                    _local_3.fData.sText = "Hide";
                                                    _local_3.buttonNewEventType = "hideItem";
                                                }
                                                else
                                                {
                                                    _local_3.fData.sText = "Show";
                                                    _local_3.buttonNewEventType = "showItem";
                                                };
                                            };
                                        };
                                        if (!("EnhLvl" in iSel))
                                        {
                                            _local_3.sMode = "red";
                                        }
                                        else
                                        {
                                            _local_4.sMode = "red";
                                        };
                                        if (iSel.bEquip == 1)
                                        {
                                            _local_4.fData.sText = "Unequip";
                                            _local_4.buttonNewEventType = "unequipItem";
                                        }
                                        else
                                        {
                                            _local_4.fData.sText = "Equip";
                                            _local_4.buttonNewEventType = "equipItem";
                                        };
                                        _local_3.sMode = "red";
                                    }
                                    else
                                    {
                                        _local_5 = String(iSel.sLink).toLowerCase();
                                        _local_6 = String(iSel.sType).toLowerCase();
                                        _local_7 = (((_local_6 == "item") && (_local_5.length > 0)) && (!(_local_5 == "none")));
                                        if ((((((iSel.sType.toLowerCase() == "pet") || (_local_7)) || (iSel.sES == "co")) || (iSel.sES == "am")) || (iSel.sES == "mi")))
                                        {
                                            if ((((iSel.bUpg == 1) && (rootClass.world.myAvatar.isUpgraded())) || (iSel.bUpg == 0)))
                                            {
                                                if (iSel.sES == "co")
                                                {
                                                    if (iSel.bWear)
                                                    {
                                                        _local_3.fData.sText = "Hide";
                                                        _local_3.buttonNewEventType = "hideItem";
                                                    }
                                                    else
                                                    {
                                                        _local_3.fData.sText = "Show";
                                                        _local_3.buttonNewEventType = "showItem";
                                                    };
                                                    _local_3.sMode = "red";
                                                };
                                                if ((((iSel.sType.toLowerCase() == "item") && (!(iSel.sName == "Treasure Potion"))) && (iSel.sName.indexOf(" Item of Digital Awesomeness") == -1)))
                                                {
                                                    _local_3.fData.sText = "Consume";
                                                    _local_3.buttonNewEventType = "consumePotion";
                                                    _local_3.sMode = "red";
                                                };
                                            };
                                            if (iSel.sName.indexOf(" Item of Digital Awesomeness") == -1)
                                            {
                                                _local_4.sMode = "red";
                                                if (iSel.bEquip == 1)
                                                {
                                                    _local_4.fData.sText = "Unequip";
                                                    _local_4.buttonNewEventType = "unequipItem";
                                                }
                                                else
                                                {
                                                    _local_4.fData.sText = "Equip";
                                                    _local_4.buttonNewEventType = "equipItem";
                                                };
                                            };
                                        };
                                        if (((iSel.sType.toLowerCase() == "serveruse") || (iSel.sType.toLowerCase() == "clientuse")))
                                        {
                                            _local_4.sMode = "red";
                                            _local_4.fData.sText = "Use";
                                            _local_4.buttonNewEventType = "useItem";
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                if (sMode == "shopBuy")
                {
                    if (((iSel == null) && (eSel == null)))
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                        _local_4.fData.sText = "";
                        _local_4.buttonNewEventType = "";
                    }
                    else
                    {
                        if (((!(iSel == null)) && (!(eSel == null))))
                        {
                            _local_3.fData.sText = "";
                            _local_3.buttonNewEventType = "";
                            _local_4.fData.sText = "Enhance!";
                            _local_4.buttonNewEventType = "enhanceItem";
                            _local_4.sMode = "red";
                        }
                        else
                        {
                            if (eSel != null)
                            {
                                _local_3.fData.sText = "Buy and Hold";
                                _local_3.buttonNewEventType = "buyItem";
                                _local_4.fData.sText = "Apply Now";
                                _local_4.buttonNewEventType = "showItemListBNoBtns";
                                _local_4.sMode = "red";
                            }
                            else
                            {
                                if (iSel != null)
                                {
                                    if (((("bLimited" in shopinfo) && (shopinfo.bLimited)) && (iSel.iQtyRemain <= 0)))
                                    {
                                        _local_3.fData.sText = "";
                                        _local_3.buttonNewEventType = "";
                                        _local_4.fData.sText = "Sold Out!";
                                        _local_4.buttonNewEventType = "none";
                                        _local_4.sMode = "grey";
                                    }
                                    else
                                    {
                                        _local_3.fData.sText = "";
                                        _local_3.buttonNewEventType = "";
                                        _local_4.fData.sText = "Buy";
                                        _local_4.buttonNewEventType = "buyItem";
                                        _local_4.sMode = "red";
                                    };
                                };
                            };
                        };
                    };
                };
                if (sMode == "shopSell")
                {
                    if (((iSel == null) && (eSel == null)))
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                        _local_4.fData.sText = "";
                        _local_4.buttonNewEventType = "";
                    }
                    else
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                        _local_4.fData.sText = "Sell";
                        _local_4.buttonNewEventType = "sellItem";
                        _local_4.sMode = "red";
                    };
                };
            };
            notifyByEventType(_local_3);
            notifyByEventType(_local_4);
        }

        private function onSellRequest(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.world.sendSellItemRequest(_arg_1.iSel);
            };
        }

        public function getTabStates(_arg_1:Object=null):Array
        {
            var _local_3:Object;
            var _local_2:Array = [{
                "sTag":"Show All",
                "icon":"iipack",
                "state":-1,
                "filter":"*",
                "mc":{}
            }, {
                "sTag":"Show only weapons",
                "icon":"iwsword",
                "state":-1,
                "filter":"Weapon",
                "mc":{}
            }, {
                "sTag":"Show only armor",
                "icon":"iiclass",
                "state":-1,
                "filter":"ar",
                "mc":{}
            }, {
                "sTag":"Show only helms",
                "icon":"iihelm",
                "state":-1,
                "filter":"he",
                "mc":{}
            }, {
                "sTag":"Show only capes",
                "icon":"iicape",
                "state":-1,
                "filter":"ba",
                "mc":{}
            }, {
                "sTag":"Show only pets",
                "icon":"iipet",
                "state":-1,
                "filter":"pe",
                "mc":{}
            }, {
                "sTag":"Show only amulets",
                "icon":"iin1",
                "state":-1,
                "filter":"am",
                "mc":{}
            }, {
                "sTag":"Show only items",
                "icon":"iibag",
                "state":-1,
                "filter":"it",
                "mc":{}
            }];
            if (itemsShop == null)
            {
                _local_2.push({
                    "sTag":"Show only potions & elixirs",
                    "icon":"ich1",
                    "state":-1,
                    "filter":"pots",
                    "mc":{}
                });
            }
            else
            {
                _local_2.push({
                    "sTag":"Show only house items",
                    "icon":"ihhouse",
                    "state":-1,
                    "filter":"houseitems",
                    "mc":{}
                });
            };
            if (_arg_1 != null)
            {
                for each (_local_3 in _local_2)
                {
                    if (_local_3.filter == _arg_1.sES)
                    {
                        return ([_local_3]);
                    };
                };
                return ([_local_2[0]]);
            };
            return (_local_2);
        }

        private function previewPanelEF(_arg_1:Event):void
        {
            var _local_2:Number = previewPanel.x;
            var _local_3:Number = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
            var _local_4:Number = (_local_3 - _local_2);
            if (((_local_4 > 20) || (splitPanel.visible)))
            {
                previewPanel.x = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
            };
        }


    }
}//package 

