// Hidden Project Augoeides - Official Client Source
// http://www.as3sorcerer.com/

//LPFLayoutBank

package {
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFLayoutAuction extends LPFLayout {

        public var iSel:Object;
        public var bSel:Object;
        public var rSel:Object;
        public var itemsI:Array;
        public var itemsB:Array;
        public var itemsC:Array;
        public var bankPanel:MovieClip;
        public var rootClass:MovieClip;
		public var notify:Boolean;
        public var previewPanel:MovieClip;
		public var tab:int;
		
        public function LPFLayoutAuction():void{
            x = 0;
            y = 0;
            panels = [];
            fData = {};
        }

        override public function fOpen(_arg1:Object):void{		
		    tab = 1;
			notify = true;
            var _local2:Object;
            var _local4:Object;
            var _local5:MovieClip;
            rootClass = MovieClip(stage.getChildAt(0));
            rootClass.auctionLayout = this;
            fData = _arg1.fData;
            sMode = _arg1.sMode;
            if (("itemsI" in fData)){
                itemsI = fData.itemsI;
            }
            if (("itemsB" in fData)){
                itemsB = fData.itemsB;
            }
            if (("itemsC" in fData)){
                itemsC = fData.itemsC;
            }
            _local2 = _arg1.r;
            var _local3 = "";
            x = _local2.x;
            y = _local2.y;
            w = _local2.w;
            h = _local2.h;
            _local4 = {};
            _local4.panel = new LPFPanelAuction();
            _local4.fData = {
                itemsI:itemsI,
                itemsB:itemsB,
                itemsC:itemsC,
                avatar:rootClass.world.myAvatar,
                objData:fData.objData
            };
            _local4.r = {
                x:30,
                y:80,
                w:900,
                h:400
            };
            _local4.isOpen = true;
            bankPanel = addPanel(_local4);			
            rootClass.dropStackBoost();
        }

        override public function fClose():void{
            var _local1:MovieClip;
            rootClass.dropStackReset();
            while (panels.length > 0) {
                panels[0].mc.fClose();
                panels.shift();
            }
            if (parent != null){
                _local1 = MovieClip(parent);
                _local1.removeChild(this);
                _local1.onClose();
            }
			
        }

        override protected function handleUpdate(_arg1:Object):Object{
            var _local3:Object;
            trace(("LayoutINVENH.handleUpdate > " + _arg1.eventType));
            var _local2:Boolean;
            var _local4:Object = iSel;
            var _local5:Object = bSel;
            var _local6:Object;
            if (_arg1.eventType == "auctionSel"){
                iSel = _arg1.fData;
				tab = 1;
                _arg1.fData = {iSel:iSel};
            }
            if (_arg1.eventType == "inventorySel"){
                iSel = _arg1.fData;
				tab = 2;
                _arg1.fData = {iSel:iSel};
            }
            if (_arg1.eventType == "retrieveSel"){
                iSel = _arg1.fData;
				tab = 3;
                _arg1.fData = {iSel:iSel};
            }
            if (_arg1.eventType == "categorySelAuction"){
                if (rootClass.world.auctionHasRequested(_arg1.fData.types)){
                    trace("  Drawing Auction locally");
                    _arg1.eventType = "refreshBank";
                }
                else {
                    _arg1.fData.loadPending = true;
                    _arg1.fData.msg = "Loading...";
                    trace("  Sending Auction request");
                    rootClass.world.sendLoadAuctionRequest(_arg1.fData.types);
                }
            }
            if (_arg1.eventType == "categorySelRetrieve"){
                if (rootClass.world.retrieveHasRequested(_arg1.fData.types)){
                    trace("  Drawing Auction locally");
                    _arg1.eventType = "refreshBank";
                }
                else {
                    _arg1.fData.loadPending = true;
                    _arg1.fData.msg = "Loading...";
                    trace("  Sending Auction request");
                    rootClass.world.sendLoadRetrieveRequest(_arg1.fData.types);
                }
            }
            if (_arg1.eventType == "refreshBank"){
            }
            if (_arg1.eventType == "refreshInventory"){
            }
            if (_arg1.eventType == "refreshItems"){

            }
            if (_arg1.eventType == "buyItem"){
                rootClass.world.sendBuyAuctionItemRequest(iSel);
            }

            updatePreviewButtons(_local6);
            _local4 = null;
            _local5 = null;
            if (!_local2){
                return (_arg1);
            }
            return (null);
        }

        public function updatePreviewButtons(_arg1:Object=null, _arg2:Object=null):void{
            var _local3:Object = {};
            if (((!((_arg1 == null))) && (!((_arg2 == null))))){
                _local3 = _arg2;
            }
            else {
                _local3.eventType = "previewButton1Update";
                _local3.fData = {};
                _local3.fData.sText = "";
                _local3.sMode = "grey";
                _local3.buttonNewEventType = "";
                if (tab == 1 && iSel != null) {
                    _local3.fData.sText = "Buy";
                    _local3.buttonNewEventType = "buyItem";
                    _local3.sMode = "red";
                }
                else {
                    _local3.fData.sText = "";
                    _local3.buttonNewEventType = "";
                }
            }
            notifyByEventType(_local3);
        }

        public function getTabStates(item:Object=null, exclude:Array=null):Array{
            var filter:String;
            var i:int;
            var o:Object;
            var tabStates:Array = [{
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
            if (exclude != null)
            {
                for each (filter in exclude)
                {
                    i = 0;
                    while (i < tabStates.length)
                    {
                        if (tabStates[i].filter == filter)
                        {
                            tabStates.splice(i--, 1);
                        }
                        i++;
                    }
                }
            }
            if (item != null)
            {
                for each (o in tabStates)
                {
                    if (o.filter == item.sES)
                    {
                        return ([o]);
                    }
                }
                return ([tabStates[0]]);
            }
            return (tabStates);
        }


    }
}//package 

