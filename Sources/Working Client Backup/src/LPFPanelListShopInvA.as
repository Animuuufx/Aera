// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelListShopInvA

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFPanelListShopInvA extends LPFPanel 
    {

        public function LPFPanelListShopInvA():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_8:int;
            fData = _arg_1.fData;
            var _local_2:Object = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_8 = fParent.numChildren;
                if (_local_8 > 1)
                {
                    y = ((fParent.getChildAt((_local_8 - 2)).y + fParent.getChildAt((_local_8 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                };
            };
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
            if (("closeType" in _arg_1))
            {
                closeType = _arg_1.closeType;
            };
            if (("hideDir" in _arg_1))
            {
                hideDir = _arg_1.hideDir;
            };
            if (("hidePad" in _arg_1))
            {
                hidePad = _arg_1.hidePad;
            };
            var _local_3:Object = {};
            _local_3 = {};
            _local_3.frame = new LPFFrameBackdrop();
            _local_3.fData = null;
            _local_3.r = {
                "x":14,
                "y":44,
                "w":(w - 26),
                "h":396
            };
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameGoldDisplay();
            _local_3.fData = fData.objData;
            _local_3.r = {
                "x":-1,
                "y":-79,
                "w":-1,
                "h":24,
                "center":true,
                "shiftAmount":45
            };
            _local_3.eventTypes = ["refreshCoins"];
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameSlotDisplay();
            _local_3.fData = fData.objData;
            _local_3.fData.list = fData.itemsInv;
            _local_3.r = {
                "x":32,
                "y":-40,
                "w":-1,
                "h":24
            };
            _local_3.eventTypes = ["refreshItems", "refreshSlots"];
            addFrame(_local_3);
            var _local_4:Boolean = ((MovieClip(fParent).rootClass.ui.mcPopup.currentLabel == "Inventory") || (MovieClip(fParent).rootClass.ui.mcPopup.currentLabel == "HouseInventory"));
            _local_3 = {};
            _local_3.frame = new LPFFrameGenericButton();
            _local_3.fData = {"sText":"Add Space"};
            _local_3.r = {
                "x":185,
                "y":((_local_4) ? -29 : -38),
                "w":-1,
                "h":-1
            };
            _local_3.buttonNewEventType = ["buyBagSlots"];
            addFrame(_local_3);
            if (_local_4)
            {
                _local_3 = {};
                _local_3.frame = new LPFFrameGenericButton();
                _local_3.fData = {"sText":((MovieClip(fParent).rootClass.ui.mcPopup.currentLabel == "Inventory") ? "House Inventory" : "Item Inventory")};
                _local_3.r = {
                    "x":185,
                    "y":-48,
                    "w":-1,
                    "h":-1
                };
                _local_3.buttonNewEventType = ["toggleHouseInventory"];
                addFrame(_local_3);
            };
            var _local_5:* = 353;
            var _local_6:int = 50;
            if (fParent.sMode.indexOf("shop") > -1)
            {
                _local_5 = (_local_5 - 38);
                _local_3 = {};
                _local_3.frame = new LPFFrameCheapBuySell();
                _local_3.fData = null;
                _local_3.eventType = "sModeSet";
                _local_3.openOn = "shopBuy";
                _local_3.r = {
                    "x":20,
                    "y":(_local_6 + _local_5),
                    "w":-1,
                    "h":-1
                };
                addFrame(_local_3);
            };
            _local_3 = {};
            _local_3.frame = new LPFFrameListViewTabbed();
            var _local_7:Object = {
                "list":fData.items,
                "bLimited":false
            };
            if (("shopinfo" in fData))
            {
                if (("bLimited" in fData.shopinfo))
                {
                    _local_7.bLimited = fData.shopinfo.bLimited;
                };
            };
            _local_3.fData = _local_7;
            _local_3.r = {
                "x":20,
                "y":_local_6,
                "w":265,
                "h":_local_5
            };
            _local_3.tabStates = MovieClip(fParent).getTabStates();
            _local_3.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring", "Pet"];
            _local_3.filterMap = {
                "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
                "enh":["Enhancement"],
                "houseitems":["House", "Wall Item", "Floor Item"],
                "pots":["Item"]
            };
            _local_3.sName = "itemListA";
            _local_3.itemEventType = "listItemASel";
            _local_3.eventTypes = ["refreshItems", "refreshInv", "sModeSet"];
            addFrame(_local_3);
            drawBG();
            bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            if (!(("showDragonLeft" in _arg_1) && (_arg_1.showDragonLeft == true)))
            {
                bg.dragonLeft.visible = false;
            };
            if (!(("showDragonRight" in _arg_1) && (_arg_1.showDragonRight == true)))
            {
                bg.dragonRight.visible = false;
            };
        }


    }
}//package 

