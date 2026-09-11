// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelListShopInvB

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFPanelListShopInvB extends LPFPanel 
    {

        public function LPFPanelListShopInvB():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_4:int;
            fData = _arg_1.fData;
            var _local_2:Object = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_4 = fParent.numChildren;
                if (_local_4 > 1)
                {
                    y = ((fParent.getChildAt((_local_4 - 2)).y + fParent.getChildAt((_local_4 - 2)).height) + 10);
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
                "h":271
            };
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameBackdrop();
            _local_3.fData = null;
            _local_3.r = {
                "x":14,
                "y":320,
                "w":(w - 26),
                "h":121
            };
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameListViewTabbed();
            _local_3.fData = {"list":fData.items};
            _local_3.r = {
                "x":20,
                "y":50,
                "w":265,
                "h":258
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
                "House":["House"],
                "Wall Item":["Wall Item"],
                "Floor Item":["Floor Item"]
            };
            _local_3.sName = "itemListB";
            _local_3.itemEventType = "listItemBSel";
            _local_3.eventTypes = ["listItemASel", "refreshInv", "refreshItems"];
            _local_3.filter = "sES";
            _local_3.multiSelect = (MovieClip(fParent).sMode == "shopBuy");
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameEnhText();
            _local_3.fData = null;
            _local_3.r = {
                "x":18,
                "y":321,
                "w":(w - 20),
                "h":-1
            };
            _local_3.eventTypes = ["listItemBSolo", "showItemListB", "refreshItems"];
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

        override public function fHide():void
        {
            var _local_1:MovieClip;
            isOpen = false;
            visible = false;
            switch (hideDir.toLowerCase())
            {
                case "left":
                    x = ((xo - w) - hidePad);
                    break;
                case "right":
                    x = ((xo + w) + hidePad);
                    break;
                case "top":
                    y = ((yo - h) - hidePad);
                    break;
                case "bottom":
                    y = ((yo + h) + hidePad);
                    break;
                case "":
            };
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < numChildren)
            {
                try
                {
                    _local_1 = MovieClip(getChildAt(_local_2));
                    _local_1.notify({"eventType":"clearState"});
                }
                catch(e:Error)
                {
                };
                _local_2++;
            };
        }


    }
}//package 

