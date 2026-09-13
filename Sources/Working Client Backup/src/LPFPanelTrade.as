package {
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.*;

	public class LPFPanelTrade extends LPFPanel {

		public var mainClass:* = MovieClip(Game.root);

		public function LPFPanelTrade() {
			x = 0;
			y = 0;
			frames = [];
			fData = {};
		}
		  
		override public function fOpen(param1:Object) : void {
			var _loc2_:Object = null;
			var _loc3_:int = 0;
			fData = param1.fData;
			drawBG(LPFPanelBg4);
			bg.tTitle.text = "Trade";
			bg.tPane1.text = "Your Inventory";
			bg.tPane2.text = "Your Offer";
			bg.tPane3.text = "Their Offer";
			_loc2_ = param1.r;
			x = _loc2_.x;

			if(_loc2_.y > -1) {
				y = _loc2_.y;
			} else {
				_loc3_ = fParent.numChildren;
				if(_loc3_ > 1) {
					y = fParent.getChildAt(_loc3_ - 2).y + fParent.getChildAt(_loc3_ - 2).height + 10;
				} else {
					y = 10;
				}
			}

			var _loc4_:Point = new Point(0,0);
			_loc4_ = bg.localToGlobal(_loc4_);
			bg.y = 0;
			w = _loc2_.w;
			h = _loc2_.h;
			xo = x;
			yo = y;

			if("closeType" in param1) {
				closeType = param1.closeType;
			}
			if("hideDir" in param1) {
				hideDir = param1.hideDir;
			}
			if("hidePad" in param1) {
				hidePad = param1.hidePad;
			}
			if("xBuffer" in param1) {
				xBuffer = param1.xBuffer;
			}
			if("isOpen" in param1) {
				isOpen = param1.isOpen;
			}

			var _loc5_:Object = {};
			_loc5_ = {};
			_loc5_.frame = new LPFFrameBackdrop();
			_loc5_.fData = null;
			_loc5_.r = {
				"x":10,
				"y":35,
				"w":280,
				"h":303
			};
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameBackdrop();
			_loc5_.fData = null;
			_loc5_.r = {
				"x":313,
				"y":35,
				"w":280,
				"h":225
			};
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameBackdrop();
			_loc5_.fData = null;
			_loc5_.r = {
				"x":616,
				"y":35,
				"w":280,
				"h":225
			};
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameListViewTabbed();
			_loc5_.fData = {"list":fData.itemsB};
			_loc5_.r = {
				"x":317,
				"y":39,
				"w":260,
				"h":212
			};
			_loc5_.tabStates = MovieClip(fParent).getTabStates();
			_loc5_.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring", "Pet"];
			_loc5_.filterMap = {
                "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
                "enh":["Enhancement"]
            };
			_loc5_.sName = "offer";
			_loc5_.itemEventType = "offerSel";
			_loc5_.tabEventType = "categorySelMyOffer";
			_loc5_.eventTypes = ["refreshItems","refreshBank","categorySelMyOffer"];
			_loc5_.onDemand = true;
			_loc5_.openBlank = false;
			_loc5_.allowDesel = true;
			this.mainClass.tradeItem1 = _loc5_.frame;
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameListViewTabbed();
			_loc5_.fData = {"list":fData.itemsC};
			_loc5_.r = {
				"x":620,
				"y":39,
				"w":260,
				"h":212
			};
			_loc5_.tabStates = MovieClip(fParent).getTabStates();
			_loc5_.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring", "Pet"];
			_loc5_.filterMap = {
                "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
                "enh":["Enhancement"]
            };
			_loc5_.sName = "their";
			_loc5_.itemEventType = "otherSel";
			_loc5_.tabEventType = "categorySelTheirOffer";
			_loc5_.eventTypes = ["refreshItems","refreshBank","categorySelTheirOffer"];
			_loc5_.onDemand = true;
			_loc5_.openBlank = false;
			_loc5_.allowDesel = true;
			this.mainClass.tradeItem2 = _loc5_.frame;
			addFrame(_loc5_);
			_loc5_.eventTypes = ["refreshItems","refreshBank","refreshSlots"];
			_loc5_.isBank = true;
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameListViewTabbed();
			_loc5_.fData = {"list":fData.itemsI};
			_loc5_.r = {
				"x":14,
				"y":39,
				"w":260,
				"h":294
			};
			_loc5_.tabStates = MovieClip(fParent).getTabStates();
			_loc5_.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring", "Pet"];
			_loc5_.filterMap = {
                "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
                "enh":["Enhancement"]
            };
			_loc5_.sName = "inventory";
			_loc5_.itemEventType = "inventorySel";
			_loc5_.eventTypes = ["refreshItems","refreshInventory"];
			_loc5_.openBlank = false;
			_loc5_.allowDesel = true;
			this.mainClass.tradeItem3 = _loc5_.frame;
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameSimpleText();
			_loc5_.fData = {"msg":""};
			_loc5_.r = {
				"x":-1,
				"y":42,
				"w":200,
				"h":-1,
				"center":true
			};
			addFrame(_loc5_);
			_loc5_ = {};
			_loc5_.frame = new LPFFrameGenericButton();
			_loc5_.fData = null;
			_loc5_.r = {
				"x":100,
				"y":343,
				"w":95,
				"h":24
			};
			_loc5_.eventTypes = ["previewButton1Update"];
			addFrame(_loc5_);
			bg.btnClose.addEventListener(MouseEvent.CLICK,onCloseClick,false,0,true);
			if(!("showDragonLeft" in param1 && param1.showDragonLeft == true)) {
				bg.dragonLeft.visible = true;
			}
			if(!("showDragonRight" in param1 && param1.showDragonRight == true)) {
				bg.dragonRight.visible = true;
			}
		}
	}
}
