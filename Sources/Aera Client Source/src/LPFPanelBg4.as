package {

    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;

	public dynamic class LPFPanelBg4 extends MovieClip {

		public var dragonRight:MovieClip;
		public var dragonLeft:MovieClip;
		public var rootClass:Game = Game.root;
		public var btnLock:SimpleButton;
		public var btnDeal:SimpleButton;
		public var bg:MovieClip;
		public var btnClose:SimpleButton;
		public var tTitle:TextField;
		public var tPane1:TextField;
		public var tPane2:TextField;
		public var tPane3:TextField;
		public var txtMyGold:TextField;
		public var txtMyCoins:TextField;
		public var txtTargetGold:TextField;
		public var txtTargetCoins:TextField;
		public var txtLock:TextField;
      
		public function LPFPanelBg4() {
			addFrameScript(0, frame1);
		}
		  
		private function frame1() : void {
			tTitle.mouseEnabled = false;
			tPane1.mouseEnabled = false;
			tPane2.mouseEnabled = false;
			tPane3.mouseEnabled = false;
			txtLock.mouseEnabled = false;
			txtLock.text = "Lock";
			txtMyGold.restrict = "0-9";
			txtMyCoins.restrict = "0-9";
			btnDeal.alpha = 0.5;
			btnDeal.mouseEnabled = false;
			btnLock.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
			btnDeal.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
			rootClass.ctrlTrade = this;
			stop();
		}

		private function onClick(param1:MouseEvent) : void {
			this.rootClass.mixer.playSound("Click");
			switch(param1.currentTarget.name) {
				case "btnLock":
					if(this.txtLock.text == "Lock") {
						if(this.txtMyCoins.length == 0) {
							this.txtMyCoins.text = "0";
						}
						if(this.txtMyGold.length == 0) {
							this.txtMyGold.text = "0";
						}
						MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcTrade")).update({"eventType":"lockOffer"});
					} else {
						MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcTrade")).update({"eventType":"unlockOffer"});
					}
					break;
				case "btnDeal":
					MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcTrade")).update({"eventType":"completeTrade"});
					break;
			}
		}
	}
}