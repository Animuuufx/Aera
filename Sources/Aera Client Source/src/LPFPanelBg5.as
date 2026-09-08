// Hidden Project Augoeides - Official Client Source
// http://www.as3sorcerer.com/

//LPFPanelBg5

package {
	import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import fl.controls.ColorPicker;
    import fl.controls.ComboBox;
    import flash.utils.Dictionary;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.external.ExternalInterface;
    import flash.net.URLRequestMethod;
    import flash.net.navigateToURL;
    import flash.events.KeyboardEvent;
    import flash.net.SharedObject;
    import fl.data.DataProvider;
    import fl.data.SimpleCollectionItem;
    import flash.system.Security;
    import fl.events.ColorPickerEvent;
    import flash.utils.setTimeout;
    import flash.net.sendToURL;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.ui.*;
    import flash.system.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

	public dynamic class LPFPanelBg5 extends MovieClip {

		public var dragonRight:MovieClip;
		public var cbFilterBy:ComboBox;
		public var dragonLeft:MovieClip;
		public var rootClass:Game = Game.root;
		public var btnClose:SimpleButton;
		public var tabSell:SimpleButton;
		public var tabPurchase:SimpleButton;
		public var tabCheckout:SimpleButton;
		public var btnSearch:SimpleButton;
		public var btnSell:SimpleButton;
		public var btnCheckout:SimpleButton;
		public var btnCheckoutAll:SimpleButton;
		public var txtSellGold:TextField;
		public var txtSellCoins:TextField;
		public var bg:MovieClip;
		public var tTitle:TextField;
		public var tPane1:TextField;
		public var itemName:TextField;
		
		public function LPFPanelBg5(){
			addFrameScript(0, frame1, 1, frame2, 2, frame3);
		}
		
		private function frame1() : void {
			tTitle.mouseEnabled = false;
			tPane1.mouseEnabled = false;
			btnSearch.addEventListener(MouseEvent.CLICK, onSearch, false, 0, true);
			tabPurchase.addEventListener(MouseEvent.CLICK, toPurchase);
			tabCheckout.addEventListener(MouseEvent.CLICK, toCheckout);
			tabSell.addEventListener(MouseEvent.CLICK, toSell);

			rootClass.auctionItem1.visible = true;
			rootClass.auctionItem2.visible = false;
			rootClass.auctionItem3.visible = false;
			
			rootClass.auctionLayout.iSel = null;
			rootClass.auctionLayout.updatePreviewButtons();
			
			rootClass.auctionItem1.mouseEnabled = true;
			rootClass.auctionItem2.mouseEnabled = true;
			rootClass.auctionItem3.mouseEnabled = true;

			stop();
		}

		private function onSearch(evt:MouseEvent):void {
		    rootClass.auctionTabs.onSearch = true;
		    rootClass.auctionTabs.tSel = rootClass.auctionTabs.getTabByFilter("*");
		    rootClass.auctionTabs.forceTabClick(rootClass.auctionTabs.getTabByFilter("*"));
			rootClass.auctionTabs.tSel = rootClass.auctionTabs.getTabByFilter("*");
			rootClass.world.myAvatar.auctionReset();
			rootClass.auctionTabs.tSel = rootClass.auctionTabs.getTabByFilter("*");
			rootClass.mixer.playSound("Click");
			if (itemName.length == 0) {
				rootClass.world.sendLoadAuctionRequest(["*"]);
			} else {
				rootClass.sfc.sendXtMessage("zm", "searchAuction", [itemName.text], "str", this.curRoom);
			}
		}

		private function frame2() : void {
			txtSellGold.restrict="0-9";
			txtSellCoins.restrict="0-9";
			btnSell.addEventListener(MouseEvent.CLICK, SellItem);
			stop();
		}
		
		private function frame3() : void{
			btnCheckout.addEventListener(MouseEvent.CLICK, onCheckout);
			btnCheckoutAll.addEventListener(MouseEvent.CLICK, onCheckoutAll);
			stop();
		}
		
		private function SellItem(evt:MouseEvent):void {
			var modal:ModalMC;
			var modalO:Object;
			var qty:int;

			if (rootClass.auctionLayout.iSel == null)
			{
				modal = new ModalMC();
				modalO = {};
				modalO.strBody = ("Please select the item you want to sell!");
				modalO.params = {};
				modalO.glow = "red,medium";
				modalO.btns = "mono";
				rootClass.ui.ModalStack.addChild(modal);
				modal.init(modalO);
				return;
			}

			qty = (((rootClass.auctionLayout.iSel.iQty)!=null) ? rootClass.auctionLayout.iSel.iQty : 1);

			rootClass.auctionLayout.iSel.auctionGold = txtSellGold.text;
			rootClass.auctionLayout.iSel.auctionCoins = txtSellCoins.text;

			btnSell.alpha = 0.5;
			btnSell.mouseEnabled = false;	

			if (txtSellCoins.length == 0) {
				txtSellCoins.text = "0";
			}
			
			if (txtSellGold.length == 0) {
				txtSellGold.text = "0";
			}				
			rootClass.mixer.playSound("Click");
			if (qty > 1 && rootClass.auctionLayout.iSel.sES != "ar") {
				modal = new ModalMC();
				modalO = {};
				modalO.params = {};
				modalO.strBody = ("Please specify item quantity you want to sell.");
				modalO.callback = qtyRequest;
				if (qty > 1){
					modalO.qtySel = {
						min:1,
						max:qty
					};
				}
				modalO.glow = "white,medium";
				modalO.greedy = true;
				rootClass.ui.ModalStack.addChild(modal);
				modal.init(modalO);
			} else {				
				rootClass.auctionLayout.iSel.Quantity = qty;
				sendSellAuctionItemRequest(rootClass.auctionLayout.iSel);				
            }
		}

        public function sendSellAuctionItemRequest(_arg1:Object) : void {
            var _local2:ModalMC;
            var _local3:Object;
            if (_arg1.bEquip == 1){
                _local2 = new ModalMC();
                _local3 = {};
                _local3.strBody = "You must unequip the item before offering it!";
                _local3.params = {};
                _local3.glow = "red,medium";
                _local3.btns = "mono";
                this.rootClass.ui.ModalStack.addChild(_local2);
                _local2.init(_local3);
				rootClass.auctionItem2.alpha = 1;
                rootClass.auctionItem2.mouseEnabled = true;	
            }
            else {
                var modal:ModalMC = new ModalMC();
                var modalO:Object = {};
                modalO.strBody = ("Are you sure you want to list '" + _arg1.sName + "' on Auction House?");
                modalO.params = {item:_arg1};
                modalO.callback = sellConfirm;
                modalO.glow = "white,medium";
                rootClass.ui.ModalStack.addChild(modal);
                modal.init(modalO);
				rootClass.auctionItem2.alpha = 0.5;
                rootClass.auctionItem2.mouseEnabled = false;				
            }
        }


        private function qtyRequest(_arg1:Object):void{
            if (_arg1.accept){
                trace(("iqty: " + _arg1.iQty));
				rootClass.auctionLayout.iSel.Quantity = 1;
                if (_arg1.iQty != null){
				    rootClass.auctionLayout.iSel.Quantity = _arg1.iQty;
                }		
				sendSellAuctionItemRequest(rootClass.auctionLayout.iSel);			
				rootClass.auctionLayout.iSel = null;
            } else {
				btnSell.alpha = 1;
				btnSell.mouseEnabled = true;	
				rootClass.auctionItem2.alpha = 1;
				rootClass.auctionItem2.mouseEnabled = true;				
			}
        }

		private function sellConfirm(_arg1:Object):void{
			if (_arg1.accept){
				rootClass.sfc.sendXtMessage("zm", "sellAuctionItem", [_arg1.item.ItemID, _arg1.item.CharItemID, _arg1.item.Quantity, txtSellGold.text, txtSellCoins.text], "str", this.curRoom);
			}

			btnSell.alpha = 1;
			btnSell.mouseEnabled = true;
			txtSellCoins.text = "";
			txtSellGold.text = "";
			rootClass.auctionItem2.alpha = 1;
            rootClass.auctionItem2.mouseEnabled = true;
		}

		
		function toCheckout(evt:MouseEvent):void {
		    rootClass.world.myAvatar.retrieveReset();
			rootClass.auctionItem1.visible = false;
			rootClass.auctionItem2.visible = false;
			rootClass.auctionItem3.visible = true;
			
			rootClass.auctionLayout.iSel = null;
			rootClass.auctionLayout.tab = 3;
			rootClass.auctionLayout.updatePreviewButtons();
			rootClass.world.sendLoadRetrieveRequest(["*"]);
			rootClass.auctionTabs.Param1.text = "STATUS";
			
			rootClass.mixer.playSound("Click");
			MovieClip(rootClass.ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
			gotoAndStop(3);
		}
		
		function toSell(evt:MouseEvent):void {
			rootClass.auctionItem1.visible = false;
			rootClass.auctionItem2.visible = true;
			rootClass.auctionItem3.visible = false;
			
			rootClass.auctionLayout.iSel = null;
			rootClass.auctionLayout.tab = 2;
			rootClass.auctionLayout.updatePreviewButtons();
			
			rootClass.mixer.playSound("Click");
			MovieClip(rootClass.ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
			gotoAndStop(2);
		}
		
		function toPurchase(evt:MouseEvent):void {
		    rootClass.world.myAvatar.auctionReset();
			rootClass.auctionItem1.visible = true;
			rootClass.auctionItem2.visible = false;
			rootClass.auctionItem3.visible = false;
			
			rootClass.auctionLayout.iSel = null;
			rootClass.auctionLayout.tab = 1;
			rootClass.auctionLayout.updatePreviewButtons();
			rootClass.world.sendLoadAuctionRequest(["*"]);
			rootClass.auctionTabs.Param1.text = "SELLER";
			
			rootClass.mixer.playSound("Click");
			MovieClip(rootClass.ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});			
			gotoAndStop(1);
		}
		
		private function onCheckout(evt:MouseEvent):void {
			var modal:ModalMC = new ModalMC();
			var modalO:Object = {};

			if (rootClass.auctionLayout.iSel == null)
			{
				modalO.strBody = ("Please select the item you want to check out!");
				modalO.params = {};
				modalO.glow = "red,medium";
				modalO.btns = "mono";
				rootClass.ui.ModalStack.addChild(modal);
				modal.init(modalO);
			}
			else
			{
				rootClass.mixer.playSound("Click");
				rootClass.auctionItem3.alpha = 0.5;
				rootClass.auctionItem3.mouseEnabled = false;

				modalO.strBody = ("Are you sure you want to check out " + rootClass.auctionLayout.iSel.sName + "?");
				modalO.params = {item:rootClass.auctionLayout.iSel};
				modalO.callback = checkOutConfirm;
				modalO.glow = "white,medium";
				rootClass.ui.ModalStack.addChild(modal);
				modal.init(modalO);
			}
		}
		
		private function checkOutConfirm(_arg1:Object):void{
			if (_arg1.accept){
				rootClass.sfc.sendXtMessage("zm", "retrieveAuctionItem", [_arg1.item.AuctionID], "str", this.curRoom);
			}
			
			rootClass.auctionItem3.alpha = 1;
			rootClass.auctionItem3.mouseEnabled = true;
		}
		
		private function onCheckoutAll(evt:MouseEvent):void {
			var modal:ModalMC = new ModalMC();
			var modalO:Object = {};

			modalO.strBody = ("Are you sure you want to check out all items? These will include your items that are still listed in Auction House.");
			modalO.params = {item:""};
			modalO.callback = auctionConfirm;
			modalO.glow = "white,medium";
			rootClass.ui.ModalStack.addChild(modal);
			modal.init(modalO);
			rootClass.mixer.playSound("Click");
			btnCheckoutAll.alpha = 0.5;
			btnCheckoutAll.mouseEnabled = false;	
		}
		
		private function auctionConfirm(_arg1:Object):void{
			if (_arg1.accept){
				rootClass.sfc.sendXtMessage("zm", "retrieveAuctionItems", [], "str", this.curRoom);
			}
			
			btnCheckoutAll.alpha = 1;
			btnCheckoutAll.mouseEnabled = true;	
		}
	}
}//package 

