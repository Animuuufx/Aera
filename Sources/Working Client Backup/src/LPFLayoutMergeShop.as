// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFLayoutMergeShop

package 
{
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFLayoutMergeShop extends LPFLayout 
    {

        public var iQty:int = 1;
        private var aSel:String = "";
        private var bSel:String = "";
        public var iSel:Object;
        public var eSel:Object;
        public var itemsInv:Array;
        public var itemsShop:Array;
        public var mergePanel:MovieClip;
        public var rootClass:MovieClip;

        public function LPFLayoutMergeShop():void
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
            _local_2 = _arg_1.r;
            var _local_3:* = "";
            x = _local_2.x;
            y = _local_2.y;
            w = _local_2.w;
            h = _local_2.h;
            _local_4 = {};
            _local_4.panel = new LPFPanelMergeShop();
            _local_3 = rootClass.world.shopinfo.sName;
            _local_4.fData = {
                "items":itemsShop,
                "itemsInv":itemsInv,
                "sName":_local_3,
                "objData":fData.objData
            };
            _local_4.r = {
                "x":30,
                "y":80,
                "w":900,
                "h":400
            };
            _local_4.isOpen = true;
            mergePanel = addPanel(_local_4);
            updatePreviewButtons();
            rootClass.dropStackBoost();
        }

        override public function fClose():void
        {
            var _local_1:MovieClip;
            rootClass.dropStackReset();
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
            var _local_6:Array;
            var _local_7:*;
            var _local_8:String;
            var _local_9:*;
            var _local_10:*;
            var _local_11:Object;
            var _local_2:Boolean;
            var _local_4:Object = iSel;
            var _local_5:Object;
            if (_arg_1.eventType == "sModeSet")
            {
                if (sMode != _arg_1.sModeBroadcast)
                {
                    sMode = _arg_1.sModeBroadcast;
                    iSel = null;
                    eSel = null;
                    _arg_1.iSel = iSel;
                    _local_6 = itemsInv;
                    if (sMode == "shopBuy")
                    {
                        _local_6 = itemsShop;
                    };
                    _arg_1.fData = {"list":_local_6};
                };
            };
            if (_arg_1.eventType == "listItemASel")
            {
                iQty = 1;
                iSel = null;
                aSel = _arg_1.fData.sType.toLowerCase();
                iSel = _arg_1.fData;
                _arg_1.fData = {
                    "iSel":iSel,
                    "oSel":_arg_1.fData
                };
                if (_local_4 == iSel)
                {
                    _local_2 = true;
                };
            };
            if (_arg_1.eventType == "refreshItems")
            {
            };
            if (_arg_1.eventType == "buyItem")
            {
                _local_7 = ((iSel != null) ? iSel : eSel);
                if (_local_7 != null)
                {
                    _local_8 = (("Are you sure you want to buy '" + _local_7.sName) + "'?");
                    if (iQty > 1)
                    {
                        _local_8 = (((("Are you sure you want to buy " + String(iQty)) + "x '") + _local_7.sName) + "'?");
                    };
                    _local_9 = new ModalMC();
                    _local_10 = {};
                    _local_10.strBody = _local_8;
                    _local_10.params = {
                        "iSel":_local_7,
                        "iQty":iQty
                    };
                    _local_10.callback = rootClass.world.sendBuyItemRequestWithQuantity;
                    _local_10.glow = "white,medium";
                    _local_10.greedy = true;
                    rootClass.ui.ModalStack.addChild(_local_9);
                    _local_9.init(_local_10);
                };
            };
            if (_arg_1.eventType == "sellItem")
            {
                if (iSel != null)
                {
                    _local_11 = iSel;
                };
                _local_9 = new ModalMC();
                _local_10 = {};
                _local_10.strBody = (("Are you sure you want to sell '" + _local_11.sName) + "'?");
                _local_10.params = {"iSel":_local_11};
                _local_10.callback = onSellRequest;
                _local_10.glow = "white,medium";
                rootClass.ui.ModalStack.addChild(_local_9);
                _local_9.init(_local_10);
            };
            if (_arg_1.eventType == "buyBagSlots")
            {
                _local_2 = true;
                rootClass.world.loadMovieFront(rootClass.bagSpace, "Inline Asset");
                fClose();
            };
            if (_arg_1.eventType == "helpAC")
            {
                _local_2 = true;
                rootClass.world.loadMovieFront("interface/goldAC5.swf", "Inline Asset");
            };
            updatePreviewButtons(_local_5);
            _local_4 = null;
            if (!_local_2)
            {
                return (_arg_1);
            };
            return (null);
        }

        private function updatePreviewButtons(_arg_1:Object=null, _arg_2:Object=null):void
        {
            var _local_3:Object = {};
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                _local_3 = _arg_2;
            }
            else
            {
                _local_3.eventType = "previewButton1Update";
                _local_3.fData = {};
                _local_3.fData.sText = "";
                _local_3.sMode = "grey";
                _local_3.buttonNewEventType = "";
                if (sMode == "shopBuy")
                {
                    if (iSel != null)
                    {
                        _local_3.fData.sText = "Buy";
                        _local_3.buttonNewEventType = "buyItem";
                        _local_3.sMode = "red";
                    }
                    else
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                    };
                };
                if (sMode == "shopSell")
                {
                    if (iSel != null)
                    {
                        _local_3.fData.sText = "Sell";
                        _local_3.buttonNewEventType = "sellItem";
                        _local_3.sMode = "red";
                    }
                    else
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                    };
                };
            };
            notifyByEventType(_local_3);
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
            }, {
                "sTag":"Show only house items",
                "icon":"ihhouse",
                "state":-1,
                "filter":"houseitems",
                "mc":{}
            }];
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


    }
}//package 

