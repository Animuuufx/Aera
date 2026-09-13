// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.bankFilters

package liteAssets.draw
{
    import flash.display.MovieClip;
    import Game_fla.searchBtn_664;
    import Game_fla.chkBox_32;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.*;

    public class bankFilters extends MovieClip 
    {

        public var btnFilter:searchBtn_664;
        public var chkLegend:chkBox_32;
        public var chkRarity:chkBox_32;
        public var chkGold:chkBox_32;
        public var chkFree:chkBox_32;
        public var chkAC:chkBox_32;
        internal var rootClass:MovieClip;

        public function bankFilters(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            this.chkAC.checkmark.visible = false;
            this.chkGold.checkmark.visible = false;
            this.chkLegend.checkmark.visible = false;
            this.chkFree.checkmark.visible = false;
            this.chkRarity.checkmark.visible = false;
            this.chkAC.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkGold.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkLegend.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkFree.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkRarity.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.btnFilter.addEventListener(MouseEvent.CLICK, onBtnFilter, false, 0, true);
        }

        public function onChkChange(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.checkmark.visible = (!(_arg_1.currentTarget.checkmark.visible));
            switch (_arg_1.currentTarget.name)
            {
                case "chkAC":
                    if (_arg_1.currentTarget.checkmark.visible)
                    {
                        chkGold.checkmark.visible = false;
                    };
                    return;
                case "chkGold":
                    if (_arg_1.currentTarget.checkmark.visible)
                    {
                        chkAC.checkmark.visible = false;
                    };
                    return;
                case "chkLegend":
                    if (_arg_1.currentTarget.checkmark.visible)
                    {
                        chkFree.checkmark.visible = false;
                    };
                    return;
                case "chkFree":
                    if (_arg_1.currentTarget.checkmark.visible)
                    {
                        chkLegend.checkmark.visible = false;
                    };
                    return;
            };
        }

        public function onFilter(_arg_1:*, _arg_2:int=-1, _arg_3:Array=null):Boolean
        {
            var _local_4:Boolean = true;
            if (chkAC.checkmark.visible)
            {
                _local_4 = (_arg_1.bCoins == 1);
            }
            else
            {
                if (chkGold.checkmark.visible)
                {
                    _local_4 = (_arg_1.bCoins == 0);
                };
            };
            if (chkLegend.checkmark.visible)
            {
                _local_4 = ((_local_4) && (_arg_1.bUpg == 1));
            }
            else
            {
                if (chkFree.checkmark.visible)
                {
                    _local_4 = ((_local_4) && (_arg_1.bUpg == 0));
                };
            };
            if (chkRarity.checkmark.visible)
            {
                _local_4 = ((_local_4) && (_arg_1.iRty == 30));
            };
            if ((((((!(chkAC.checkmark.visible)) && (!(chkGold.checkmark.visible))) && (!(chkLegend.checkmark.visible))) && (!(chkFree.checkmark.visible))) && (!(chkRarity.checkmark.visible))))
            {
                _local_4 = true;
            };
            return (_local_4);
        }

        public function dispatch():void
        {
            btnFilter.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        public function onBtnFilter(_arg_1:MouseEvent):void
        {
            var _local_3:*;
            var _local_4:*;
            var _local_2:Array = new Array();
            for each (_local_3 in ((rootClass.world.bankinfo.lastSearch == "") ? rootClass.world.bankinfo.bankItems : rootClass.world.bankinfo.searchArr))
            {
                _local_2.push(_local_3);
            };
            rootClass.world.bankController.searchArr = new Array();
            for each (_local_4 in _local_2.filter(onFilter))
            {
                rootClass.world.bankController.searchArr.push(_local_4);
            };
            MovieClip(rootClass.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
        }


    }
}//package liteAssets.draw

