// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.dEntry

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import fl.data.DataProvider;
    import flash.text.*;

    public class dEntry extends MovieClip 
    {

        public var btPreview:MovieClip;
        public var icon:MovieClip;
        public var overEntryBar:MovieClip;
        public var btNo:MovieClip;
        public var txtDrop:TextField;
        public var iconAC:MovieClip;
        public var btYes:MovieClip;
        public var entryBar:MovieClip;
        public var itemObj:Object;
        internal var format:TextFormat = new TextFormat();
        internal var rootClass:MovieClip;
        internal var allowPass:Boolean = false;

        public function dEntry(r:MovieClip, resObj:Object, relQty:int):void
        {
            var AssetClass:Class;
            var mcIcon:* = undefined;
            var check:detailedCheck;
            super();
            rootClass = r;
            allowPass = false;
            this.gotoAndStop("idle");
            this.btYes.visible = false;
            this.btNo.visible = false;
            this.btPreview.visible = false;
            itemObj = resObj;
            this.iconAC.visible = (resObj.bCoins == 1);
            this.txtDrop.text = "";
            this.txtDrop.htmlText = "";
            if (resObj.bUpg == 1)
            {
                this.txtDrop.htmlText = (((("<font color='#FCC749'>" + resObj.sName) + " x ") + relQty) + "</font>");
            }
            else
            {
                this.txtDrop.text = ((resObj.sName + " x ") + relQty);
            };
            this.txtDrop.autoSize = TextFieldAutoSize.LEFT;
            if (this.txtDrop.width > ((this.entryBar.width - this.txtDrop.x) - 20))
            {
                this.txtDrop.autoSize = TextFieldAutoSize.NONE;
                this.txtDrop.width = (((this.entryBar.width - this.txtDrop.x) - 20) - ((iconAC.visible) ? iconAC.width : 0));
            };
            if (this.iconAC.visible)
            {
                this.iconAC.x = (this.txtDrop.x + this.txtDrop.width);
            };
            var sIcon:String = "";
            if (resObj.sType.toLowerCase() == "enhancement")
            {
                sIcon = rootClass.getIconBySlot(resObj.sES);
            }
            else
            {
                if (((resObj.sType.toLowerCase() == "serveruse") || (resObj.sType.toLowerCase() == "clientuse")))
                {
                    if (((("sFile" in resObj) && (resObj.sFile.length > 0)) && (!(rootClass.world.getClass(resObj.sFile) == null))))
                    {
                        sIcon = resObj.sFile;
                    }
                    else
                    {
                        sIcon = resObj.sIcon;
                    };
                }
                else
                {
                    if ((((resObj.sIcon == null) || (resObj.sIcon == "")) || (resObj.sIcon == "none")))
                    {
                        if (resObj.sLink.toLowerCase() != "none")
                        {
                            sIcon = "iidesign";
                        }
                        else
                        {
                            sIcon = "iibag";
                        };
                    }
                    else
                    {
                        sIcon = resObj.sIcon;
                    };
                };
            };
            try
            {
                AssetClass = (rootClass.world.getClass(sIcon) as Class);
                mcIcon = this.icon.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
                AssetClass = (rootClass.world.getClass("iibag") as Class);
                mcIcon = this.icon.addChild(new (AssetClass)());
            };
            if (isOwned(resObj.bHouse, resObj.ItemID))
            {
                check = new detailedCheck();
                check.width = mcIcon.width;
                check.height = mcIcon.height;
                check.x = 0;
                check.y = 0;
                mcIcon.addChild(check);
            };
            mcIcon.scaleX = (mcIcon.scaleY = (16 / mcIcon.height));
            this.addEventListener(MouseEvent.ROLL_OVER, onHighlight, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OUT, onDeHighlight, false, 0, true);
            this.addEventListener(MouseEvent.CLICK, onShiftClick, false, 0, true);
            this.btYes.addEventListener(MouseEvent.CLICK, onBtYes, false, 0, true);
            this.btNo.addEventListener(MouseEvent.CLICK, onBtNo, false, 0, true);
            this.btPreview.addEventListener(MouseEvent.CLICK, onBtPreview, false, 0, true);
        }

        internal function onShiftClick(_arg_1:MouseEvent):void
        {
            var _local_2:Class;
            var _local_3:*;
            var _local_4:*;
            if (_arg_1.shiftKey)
            {
                if (itemObj.sName.indexOf("Item of Digital Awesomeness.") > -1)
                {
                    _local_2 = rootClass.world.getClass("ModalMC");
                    _local_3 = new (_local_2)();
                    _local_4 = {};
                    _local_4.strBody = "You can NOT block IoDAs!";
                    _local_4.callback = null;
                    _local_4.glow = "red,medium";
                    _local_4.btns = "mono";
                    rootClass.stage.addChild(_local_3);
                    _local_3.init(_local_4);
                    return;
                };
                _local_2 = rootClass.world.getClass("ModalMC");
                _local_3 = new (_local_2)();
                _local_4 = {};
                _local_4.strBody = (("Are you sure you want to add " + itemObj.sName) + " to the item block list?");
                _local_4.callback = onModifyBlacklist;
                _local_4.params = {
                    "sName":itemObj.sName,
                    "ItemID":itemObj.ItemID
                };
                _local_4.glow = "red,medium";
                _local_4.btns = "dual";
                rootClass.stage.addChild(_local_3);
                _local_3.init(_local_4);
            };
        }

        internal function onModifyBlacklist(_arg_1:Object):void
        {
            var _local_2:DataProvider;
            if (_arg_1.accept)
            {
                _local_2 = new DataProvider(rootClass.litePreference.data.blackList);
                _local_2.addItem({
                    "label":_arg_1.sName.toUpperCase(),
                    "value":_arg_1.ItemID
                });
                rootClass.litePreference.data.blackList = _local_2.toArray();
                rootClass.litePreference.flush();
                this.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
            rootClass.stage.focus = null;
        }

        internal function isOwned(_arg_1:Boolean, _arg_2:*):Boolean
        {
            var _local_3:*;
            for each (_local_3 in ((_arg_1) ? rootClass.world.myAvatar.houseitems : rootClass.world.myAvatar.items))
            {
                if (_local_3.ItemID == _arg_2)
                {
                    return (true);
                };
            };
            if (rootClass.world.bankinfo.isItemInBank(_arg_2))
            {
                return (true);
            };
            return (false);
        }

        internal function updateFormat(_arg_1:int):void
        {
            format.size = _arg_1;
            this.txtDrop.setTextFormat(format);
        }

        internal function onBtYes(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_2:Boolean = true;
            for each (_local_3 in rootClass.world.myAvatar.items)
            {
                if (((_local_3.ItemID == itemObj.ItemID) && (_local_3.iQty < _local_3.iStk)))
                {
                    _local_2 = false;
                };
            };
            if (((_local_2) && (rootClass.world.myAvatar.items.length < rootClass.world.myAvatar.objData.iBagSlots)))
            {
                _local_2 = false;
            };
            if (((rootClass.isHouseItem(itemObj)) && (rootClass.world.myAvatar.houseitems.length >= rootClass.world.myAvatar.objData.iHouseSlots)))
            {
                rootClass.MsgBox.notify("House Inventory Full!");
            }
            else
            {
                if (((!(rootClass.isHouseItem(itemObj))) && (_local_2)))
                {
                    rootClass.MsgBox.notify("Item Inventory Full!");
                }
                else
                {
                    rootClass.sfc.sendXtMessage("zm", "getDrop", [itemObj.ItemID], "str", rootClass.world.curRoom);
                };
            };
            rootClass.stage.focus = null;
        }

        internal function onDeclineDrop(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                allowPass = true;
                this.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        internal function onBtNo(_arg_1:MouseEvent):void
        {
            var _local_2:Class;
            var _local_3:*;
            var _local_4:*;
            if (rootClass.litePreference.data.dOptions["warnDecline"])
            {
                if (!allowPass)
                {
                    _local_2 = rootClass.world.getClass("ModalMC");
                    _local_3 = new (_local_2)();
                    _local_4 = {};
                    _local_4.strBody = (("Are you sure you want to decline the drop for " + itemObj.sName) + "?");
                    _local_4.callback = onDeclineDrop;
                    _local_4.params = {"sName":itemObj.sName};
                    _local_4.glow = "red,medium";
                    _local_4.btns = "dual";
                    rootClass.stage.addChild(_local_3);
                    _local_3.init(_local_4);
                    return;
                };
            };
            rootClass.cDropsUI.onBtNo(itemObj);
            allowPass = false;
            rootClass.stage.focus = null;
        }

        internal function onBtPreview(_arg_1:MouseEvent):void
        {
            if (rootClass.ui.getChildByName("qRewardPrev"))
            {
                rootClass.ui.getChildByName("qRewardPrev").fClose();
            };
            var _local_2:* = rootClass.ui.addChild(new qRewardPrev(itemObj));
            _local_2.world = rootClass.world;
            _local_2.rootClass = rootClass;
            _local_2.isDropPreview();
            _local_2.open();
            rootClass.stage.focus = null;
        }

        internal function onHighlight(_arg_1:MouseEvent):void
        {
            this.gotoAndStop("hover");
            this.btYes.visible = true;
            this.btNo.visible = true;
            this.btPreview.visible = true;
        }

        internal function onDeHighlight(_arg_1:MouseEvent):void
        {
            this.gotoAndStop("idle");
            this.btYes.visible = false;
            this.btNo.visible = false;
            this.btPreview.visible = false;
        }


    }
}//package liteAssets.draw

