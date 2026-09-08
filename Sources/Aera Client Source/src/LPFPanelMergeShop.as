// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelMergeShop

package 
{
    import flash.geom.Point;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFPanelMergeShop extends LPFPanel 
    {

        public function LPFPanelMergeShop():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_6:int;
            fData = _arg_1.fData;
            drawBG(LPFPanelBg2);
            bg.tPane1.text = "Preview";
            bg.tPane2.text = "Cost";
            bg.tPane3.text = "Item List";
            bg.tSearch.visible = false;
            bg.mcHouse.visible = false;
            _local_2 = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_6 = fParent.numChildren;
                if (_local_6 > 1)
                {
                    y = ((fParent.getChildAt((_local_6 - 2)).y + fParent.getChildAt((_local_6 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                };
            };
            var _local_3:Point = new Point(0, 0);
            _local_3 = bg.localToGlobal(_local_3);
            bg.y = (bg.y - int((_local_2.y - _local_3.y)));
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
            if (("xBuffer" in _arg_1))
            {
                xBuffer = _arg_1.xBuffer;
            };
            if (("isOpen" in _arg_1))
            {
                isOpen = _arg_1.isOpen;
            };
            var _local_4:Object = {};
            _local_4 = {};
            _local_4.frame = new LPFFrameBackdrop();
            _local_4.fData = null;
            _local_4.r = {
                "x":15,
                "y":36,
                "w":290,
                "h":204
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameBackdrop();
            _local_4.fData = null;
            _local_4.r = {
                "x":15,
                "y":244,
                "w":290,
                "h":121
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameItemPreview();
            _local_4.fData = null;
            _local_4.r = {
                "x":19,
                "y":40,
                "w":284,
                "h":-1
            };
            _local_4.eventTypes = ["listItemASel"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameEnhText();
            _local_4.fData = null;
            _local_4.r = {
                "x":19,
                "y":245,
                "w":284,
                "h":-1
            };
            _local_4.eventTypes = ["listItemASel"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameBackdrop();
            _local_4.fData = null;
            _local_4.r = {
                "x":(14 + 581),
                "y":44,
                "w":290,
                "h":310
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGoldDisplay();
            _local_4.fData = fData.objData;
            _local_4.r = {
                "x":-1,
                "y":-70,
                "w":-1,
                "h":24,
                "center":true,
                "centerOn":740,
                "shiftAmount":0
            };
            _local_4.eventTypes = ["refreshCoins"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSlotDisplay();
            _local_4.fData = fData.objData;
            _local_4.fData.list = fData.itemsInv;
            _local_4.r = {
                "x":(32 + 581),
                "y":-40,
                "w":-1,
                "h":24
            };
            _local_4.eventTypes = ["refreshItems", "refreshSlots"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGenericButton();
            _local_4.fData = {"sText":"Add Space"};
            _local_4.r = {
                "x":(185 + 581),
                "y":-38,
                "w":-1,
                "h":-1
            };
            _local_4.buttonNewEventType = ["buyBagSlots"];
            addFrame(_local_4);
            var _local_5:int = 50;
            _local_4 = {};
            _local_4.frame = new LPFFrameListViewTabbed();
            _local_4.fData = {"list":fData.items};
            _local_4.r = {
                "x":(20 + 581),
                "y":_local_5,
                "w":265,
                "h":270
            };
            _local_4.tabStates = MovieClip(fParent).getTabStates();
            _local_4.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring", "Pet"];
            _local_4.filterMap = {
                "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
                "enh":["Enhancement"],
                "houseitems":["House", "Wall Item", "Floor Item"]
            };
            _local_4.sName = "itemListA";
            _local_4.itemEventType = "listItemASel";
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSimpleText();
            _local_4.fData = {"msg":"<p align='center'>Select an item from the list. Below are the required parts to buy the desired item.</p>"};
            _local_4.r = {
                "x":-1,
                "y":71,
                "w":200,
                "h":-1,
                "center":true
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSimpleList();
            _local_4.fData = {"msg":"<p align='center'>*Items must be in your backpack to appear.</p>"};
            _local_4.r = {
                "x":-1,
                "y":140,
                "w":240,
                "h":-1,
                "center":true
            };
            _local_4.eventTypes = ["refreshItems", "listItemASel", "updateQtyValue"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameCostDisplay();
            _local_4.fData = null;
            _local_4.r = {
                "x":450,
                "y":-70,
                "w":-1,
                "h":-1,
                "xPosRule":"centerOnX"
            };
            _local_4.eventTypes = ["listItemASel", "updateQtyValue"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGenericButton();
            _local_4.fData = null;
            _local_4.r = {
                "x":-1,
                "y":-40,
                "w":250,
                "h":-1,
                "center":true
            };
            _local_4.eventTypes = ["previewButton1Update"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameQtySelector();
            _local_4.fData = null;
            _local_4.r = {
                "x":-1,
                "y":-80,
                "w":-1,
                "h":-1,
                "center":true
            };
            _local_4.eventTypes = ["listItemASel"];
            addFrame(_local_4);
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

