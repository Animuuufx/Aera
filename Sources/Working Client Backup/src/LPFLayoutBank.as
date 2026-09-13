// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFLayoutBank

package 
{
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFLayoutBank extends LPFLayout 
    {

        public var iSel:Object;
        public var bSel:Object;
        public var itemsI:Array;
        public var itemsB:Array;
        public var bankPanel:MovieClip;
        public var rootClass:MovieClip;
        public var previewPanel:MovieClip;

        public function LPFLayoutBank():void
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
            if (("itemsI" in fData))
            {
                itemsI = fData.itemsI;
            };
            if (("itemsB" in fData))
            {
                itemsB = fData.itemsB;
            };
            _local_2 = _arg_1.r;
            var _local_3:* = "";
            x = _local_2.x;
            y = _local_2.y;
            w = _local_2.w;
            h = _local_2.h;
            _local_4 = {};
            _local_4.panel = new LPFPanelBank();
            _local_4.fData = {
                "itemsI":itemsI,
                "itemsB":itemsB,
                "avatar":rootClass.world.myAvatar,
                "objData":fData.objData
            };
            _local_4.r = {
                "x":30,
                "y":80,
                "w":900,
                "h":400
            };
            _local_4.isOpen = true;
            bankPanel = addPanel(_local_4);
            _local_4 = {};
            _local_4.panel = new BankPreview();
            _local_3 = "Preview";
            _local_4.fData = {"sName":_local_3};
            _local_4.r = {
                "x":357,
                "y":197,
                "w":0xFF,
                "h":204.2
            };
            _local_4.closeType = "hide";
            _local_4.isOpen = false;
            previewPanel = (addChild(_local_4.panel) as MovieClip);
            previewPanel.Open(_local_4);
            previewPanel.visible = false;
            previewPanel.mouseEnabled = false;
            previewPanel.mouseChildren = false;
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
            rootClass.world.bankinfo.resetSearch();
        }

        override protected function handleUpdate(_arg_1:Object):Object
        {
            var _local_3:Object;
            var _local_2:Boolean;
            var _local_4:Object = iSel;
            var _local_5:Object = bSel;
            var _local_6:Object;
            if (_arg_1.eventType == "inventorySel")
            {
                iSel = _arg_1.fData;
                if (_local_4 == iSel)
                {
                    iSel = null;
                };
                _arg_1.fData = {"iSel":iSel};
                previewPanel.Show(iSel);
            };
            if (_arg_1.eventType == "bankSel")
            {
                bSel = _arg_1.fData;
                if (_local_5 == bSel)
                {
                    bSel = null;
                };
                _arg_1.fData = {"bSel":bSel};
                previewPanel.Show(bSel);
            };
            if (_arg_1.eventType == "categorySel")
            {
                bSel = null;
                _arg_1.eventType = "refreshBank";
            };
            if (_arg_1.eventType == "refreshBank")
            {
            };
            if (_arg_1.eventType == "refreshInventory")
            {
            };
            if (_arg_1.eventType == "refreshItems")
            {
            };
            if (_arg_1.eventType == "sendBankFromInvRequest")
            {
                rootClass.world.sendBankFromInvRequest(iSel);
                iSel = null;
            };
            if (_arg_1.eventType == "sendBankToInvRequest")
            {
                rootClass.world.sendBankToInvRequest(bSel);
                bSel = null;
            };
            if (_arg_1.eventType == "sendBankSwapInvRequest")
            {
                rootClass.world.sendBankSwapInvRequest(bSel, iSel);
                iSel = null;
                bSel = null;
            };
            if (_arg_1.eventType == "buyBagSlots")
            {
                _local_2 = true;
                rootClass.world.loadMovieFront(rootClass.bagSpace, "Inline Asset");
                fClose();
            };
            if (_arg_1.eventType == "switchBank")
            {
                rootClass.world.toggleHouseBank();
            };
            if (_arg_1.eventType == "helpAC")
            {
                _local_2 = true;
                rootClass.world.loadMovieFront("interface/goldAC5.swf", "Inline Asset");
            };
            updatePreviewButtons(_local_6);
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
                if (((!(iSel == null)) && (bSel == null)))
                {
                    _local_3.fData.sText = "< To Bank";
                    _local_3.buttonNewEventType = "sendBankFromInvRequest";
                    _local_3.sMode = "red";
                }
                else
                {
                    if (((iSel == null) && (!(bSel == null))))
                    {
                        _local_3.fData.sText = "To Inventory >";
                        _local_3.buttonNewEventType = "sendBankToInvRequest";
                        _local_3.sMode = "red";
                    }
                    else
                    {
                        if (((!(iSel == null)) && (!(bSel == null))))
                        {
                            _local_3.fData.sText = "< Swap >";
                            _local_3.buttonNewEventType = "sendBankSwapInvRequest";
                            _local_3.sMode = "red";
                        }
                        else
                        {
                            _local_3.fData.sText = "";
                            _local_3.buttonNewEventType = "";
                        };
                    };
                };
            };
            notifyByEventType(_local_3);
        }

        public function getTabStates(_arg_1:Object=null, _arg_2:Array=null):Array
        {
            var _local_4:String;
            var _local_5:int;
            var _local_6:Object;
            var _local_3:Array = [{
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
                "sTag":"Show only enhancements",
                "icon":"iidesign",
                "state":-1,
                "filter":"enh",
                "mc":{}
            }];
            if (_arg_2 != null)
            {
                for each (_local_4 in _arg_2)
                {
                    _local_5 = 0;
                    while (_local_5 < _local_3.length)
                    {
                        if (_local_3[_local_5].filter == _local_4)
                        {
                            _local_3.splice(_local_5--, 1);
                        };
                        _local_5++;
                    };
                };
            };
            if (_arg_1 != null)
            {
                for each (_local_6 in _local_3)
                {
                    if (_local_6.filter == _arg_1.sES)
                    {
                        return ([_local_6]);
                    };
                };
                return ([_local_3[0]]);
            };
            return (_local_3);
        }


    }
}//package 

