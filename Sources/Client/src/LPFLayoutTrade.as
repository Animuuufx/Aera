package{
	import flash.display.MovieClip;
	import flash.text.*;

	public class LPFLayoutTrade extends LPFLayout {

		public var iSel:Object;
		public var bSel:Object;
		public var cSel:Object;
		public var itemsI:Array;
		public var itemsB:Array;
		public var itemsC:Array;
		public var tradePanel:MovieClip;
		public var rootClass:MovieClip;
		public var notify:Boolean;
		public var previewPanel:MovieClip;

		public function LPFLayoutTrade() {
			x = 0;
			y = 0;
			panels = [];
			fData = {};
		}

		override public function fOpen(param1:Object) : void {
			var r:Object;
			var panelDef:Object;
			this.notify = true;
			rootClass = MovieClip(stage.getChildAt(0));
			fData = param1.fData;
			sMode = param1.sMode;

			if("itemsI" in fData) {
				this.itemsI = fData.itemsI;
			}
			if("itemsB" in fData) {
				this.itemsB = fData.itemsB;
			}
			if("itemsC" in fData) {
				this.itemsC = fData.itemsC;
			}

			r = param1.r;
			x = r.x;
			y = r.y;
			w = r.w;
			h = r.h;
			panelDef = {};
			panelDef.panel = new LPFPanelTrade();
			panelDef.fData = {
				"itemsI":this.itemsI,
				"itemsB":this.itemsB,
				"itemsC":this.itemsC,
				"avatar":this.rootClass.world.myAvatar,
				"objData":fData.objData
			};
			panelDef.r = {
				"x":25,
				"y":100,
				"w":900,
				"h":400
			};
			panelDef.isOpen = true;
			tradePanel = addPanel(panelDef);
			rootClass.dropStackBoost();
		}

		override public function fClose() : void {
			var _loc1_:MovieClip;
			this.rootClass.dropStackReset();
			while(panels.length > 0) {
				panels[0].mc.fClose();
				panels.shift();
			}
			if(parent != null) {
				_loc1_ = MovieClip(parent);
				_loc1_.removeChild(this);
				_loc1_.onClose();
			}
			if(this.notify) {
				this.rootClass.sfc.sendXtMessage("zm","tradeCancel",[fData.tradeId],"str",this.rootClass.world.curRoom);
			}
		}

		override protected function handleUpdate(param1:Object) : Object {
			var _loc7_:*;
			var _loc8_:*;
			var _loc9_:*;
			trace("LayoutINVENH.handleUpdate > " + param1.eventType);
			var _loc4_:Object = this.iSel;
			var _loc5_:Object = this.bSel;
			if(param1.eventType == "inventorySel") {
				this.iSel = param1.fData;
				if(_loc4_ == this.iSel) {
					this.iSel = null;
				}
				param1.fData = {"iSel":this.iSel};
			}
			if(param1.eventType == "offerSel") {
				this.bSel = param1.fData;
				if(_loc5_ == this.bSel) {
					this.bSel = null;
				}
				param1.fData = {"bSel":this.bSel};
			}
			if(param1.eventType == "otherSel") {
				this.cSel = param1.fData;
				if(_loc5_ == this.cSel) {
					this.cSel = null;
				}
				param1.fData = {"cSel":this.cSel};
			}
			if(param1.eventType == "categorySelMyOffer" || param1.eventType == "categorySelTheirOffer") {
				this.bSel = null;
				if(this.rootClass.world.tradeHasRequested(param1.fData.types)) {
					trace("  Drawing Trade locally");
					param1.eventType = "refreshBank";
				}
				else {
					param1.fData.loadPending = true;
					param1.fData.msg = "Loading...";
					trace("  Sending Trade request");
					this.rootClass.world.sendLoadOfferRequest(param1.fData.types);
				}
			}
			if(param1.eventType == "refreshBank") {
			}
			if(param1.eventType == "refreshInventory") {
			}
			if(param1.eventType == "clickPreview") {
				if(!this.rootClass.isGreedyModalInStack()) {
					eSel = null;
					this.iSel = null;
					aSel = param1.fData.sType.toLowerCase();
					this.bSel = "";
					if(aSel == "enhancement") {
						eSel = param1.fData;
					}
					else {
						this.iSel = param1.fData;
					}
					if(param1.fData.sType.toLowerCase() == "enhancement") {
						param1.tabStates = this.getTabStates(param1.fData);
					}
					else {
						param1.tabStates = this.getTabStates({"sES":"enh"});
					}
					param1.fData = {
						"iSel":this.iSel,
						"eSel":eSel,
						"oSel":param1.fData
					};
					this.previewPanel.fShow(param1);
					trace("SHOW");
				}
			}
			if(param1.eventType == "lockOffer") {
				this.rootClass.sfc.sendXtMessage("zm","tradeLock",[fData.tradeId,this.rootClass.ctrlTrade.txtMyGold.text,this.rootClass.ctrlTrade.txtMyCoins.text],"str",this.rootClass.world.curRoom);
			}
			if(param1.eventType == "unlockOffer") {
				this.rootClass.sfc.sendXtMessage("zm","tradeUnlock",[fData.tradeId],"str",this.rootClass.world.curRoom);
			}
			if(param1.eventType == "completeTrade") {
				this.rootClass.sfc.sendXtMessage("zm","tradeDeal",[fData.tradeId],"str",this.rootClass.world.curRoom);
			}
				if(param1.eventType == "refreshItems") {
			}
			if(param1.eventType == "sendTradeFromInvRequest") {
				trace("  Sending Inv->Trade request");
				trace("  Quantity: " + this.iSel.iQty);
				_loc9_ = this.iSel.iQty != null?this.iSel.iQty:1;
				if(_loc9_ > 1 && this.iSel.sES != "ar") {
					_loc7_ = new ModalMC();
					_loc8_ = {};
					_loc8_.params = {};
					_loc8_.strBody = "Please specify item quantity you want to trade.";
					_loc8_.callback = this.qtyRequest;
					if(_loc9_ > 1) {
						_loc8_.qtySel = {
							"min":1,
							"max":_loc9_
						};
					}
					_loc8_.glow = "white,medium";
					_loc8_.greedy = true;
					this.rootClass.ui.ModalStack.addChild(_loc7_);
					_loc7_.init(_loc8_);
				}
				else {
					this.iSel.TradeID = fData.tradeId;
					this.iSel.Quantity = _loc9_;
					this.rootClass.world.sendTradeFromInvRequest(this.iSel);
					this.iSel = null;
				}
			}
			if(param1.eventType == "sendTradeToInvRequest") {
				trace("  Sending Trade->Inv request");
				this.bSel.TradeID = fData.tradeId;
				this.rootClass.world.sendTradeToInvRequest(this.bSel);
				this.bSel = null;
			}
			if(param1.eventType == "sendTradeSwapInvRequest") {
				trace("  Sending Inv<->Trade request");
				this.bSel.TradeID = fData.tradeId;
				this.rootClass.world.sendTradeSwapInvRequest(this.bSel,this.iSel);
				this.iSel = null;
				this.bSel = null;
			}
			this.updatePreviewButtons(null);
			_loc4_ = null;
			_loc5_ = null;
			return param1;
		}

		public function qtyRequest(param1:Object) : void {
			if(param1.accept) {
				trace("iqty: " + param1.iQty);
				this.iSel.TradeID = fData.tradeId;
				this.iSel.Quantity = 1;
				if(param1.iQty != null) {
					this.iSel.Quantity = param1.iQty;
				}
				this.rootClass.world.sendTradeFromInvRequest(this.iSel);
				this.iSel = null;
			}
		}

		private function updatePreviewButtons(param1:Object = null, param2:Object = null) : void {
			var _loc3_:Object = {};
			if(param1 != null && param2 != null) {
				_loc3_ = param2;
			} else {
				_loc3_.eventType = "previewButton1Update";
				_loc3_.fData = {};
				_loc3_.fData.sText = "";
				_loc3_.sMode = "grey";
				_loc3_.buttonNewEventType = "";
				if(this.iSel != null && this.bSel == null) {
					_loc3_.fData.sText = "Add to Offer >";
					_loc3_.buttonNewEventType = "sendTradeFromInvRequest";
					_loc3_.sMode = "red";
				} else if(this.iSel == null && this.bSel != null) {
					_loc3_.fData.sText = "< To Inventory";
					_loc3_.buttonNewEventType = "sendTradeToInvRequest";
					_loc3_.sMode = "red";
				} else {
					_loc3_.fData.sText = "";
					_loc3_.buttonNewEventType = "";
				}
			}
			notifyByEventType(_loc3_);
		}

		public function getTabStates(param1:Object = null, param2:Array = null) : Array {
			var _loc3_:String;
			var _loc4_:int;
			var _loc5_:Object;
			var _loc7_:*;
			var _loc6_:Array = [{
                sTag:"Show All",
                icon:"iipack",
                state:-1,
                filter:"*",
                mc:{}
            }, {
                sTag:"Show only weapons",
                icon:"iwsword",
                state:-1,
                filter:"Weapon",
                mc:{}
            }, {
                sTag:"Show only armor",
                icon:"iiclass",
                state:-1,
                filter:"ar",
                mc:{}
            }, {
                sTag:"Show only helms",
                icon:"iihelm",
                state:-1,
                filter:"he",
                mc:{}
            }, {
                sTag:"Show only capes",
                icon:"iicape",
                state:-1,
                filter:"ba",
                mc:{}
            }, {
                sTag:"Show only pets",
                icon:"iipet",
                state:-1,
                filter:"pe",
                mc:{}
            }, {
                sTag:"Show only amulets",
                icon:"iin1",
                state:-1,
                filter:"am",
                mc:{}
            }, {
                sTag:"Show only items",
                icon:"iibag",
                state:-1,
                filter:"it",
                mc:{}
            }, {
                sTag:"Show only enhancements",
                icon:"iidesign",
                state:-1,
                filter:"enh",
                mc:{}
            }];
			if(param2 != null) {
				for each(_loc3_ in param2) {
					_loc4_ = 0;
					while(_loc4_ < _loc6_.length) {
						if(_loc6_[_loc4_].filter == _loc3_) {
							_loc7_ = _loc4_;
							_loc4_--;
							_loc6_.splice(_loc7_,1);
						}
						_loc4_++;
					}
				}
			}
			if(param1 != null) {
				for each(_loc5_ in _loc6_) {
					if(_loc5_.filter == param1.sES) {
						return [_loc5_];
					}
				}
				return [_loc6_[0]];
			}
			return _loc6_;
		}
	}
}