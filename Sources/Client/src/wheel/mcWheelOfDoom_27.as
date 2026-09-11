// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//town_fla.mcWheelOfDoom_27

package wheel
{

    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
import flash.text.TextField;

public dynamic class mcWheelOfDoom_27 extends MovieClip
    {

        private var rootClass:Game = Game.root;

        public var tTicket:TextField;

        public var btnWheel:SimpleButton;
        public var btnClose:SimpleButton;
        public var btnShop:SimpleButton;

        public var btnLever:MovieClip;
        public var mcWheel:MovieClip;

        public var bHasItem:Boolean;
        public var bIsMember:Boolean;
        public var bCooldown:Boolean;

        public var sFrame:String = null;
        private var intQuest:int = -1;
        private var intItem:int = -1;

        public var objReward:Object;
        public var prize1:Object;
        public var prize2:Object;

        public var itemType:Object = {
            "Sword":"Weapon",
            "Dagger":"Weapon",
            "Axe":"Weapon",
            "Mace":"Weapon",
            "Staff":"Weapon",
            "Wand":"Weapon",
            "Gun":"Weapon",
            "Polearm":"Weapon",
            "Enhancement":"Weapon",
            "Class":"Class",
            "Armor":"Armor",
            "Cape":"Cape",
            "Helm":"Helm",
            "Item":"Potion",
            "Note":"Potion",
            "Necklace":"Potion",
            "House":"Potion",
            "Ring":"Potion",
            "ServerUse":"Potion",
            "ClientUse":"Potion",
            "Building":"Potion",
            "Belt":"Potion",
            "Resource":"Gold",
            "Pet":"Weapon",
            "Wall Item":"Potion",
            "Floor Item":"Potion"
        };

        public function mcWheelOfDoom_27()
        {
            addFrameScript(0, frame1, 7, frame8, 8, frame9, 9, frame10, 10, frame11, 11, frame12, 12, frame13, 13, frame14, 14, frame15, 15, frame16, 17, frame18, 19, frame20, 21, frame22, 23, frame24, 25, frame26, 27, frame28, 29, frame30, 31, frame32, 32, frame33, 33, frame34, 35, frame36, 36, frame37, 38, frame39, 42, frame43, 50, frame51, 57, frame58, 68, frame69);
            btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            update();
        }

        private function onClick(event:MouseEvent) : void
        {
            switch (event.currentTarget.name) {
                case "btnShop":
                    rootClass.mixer.playSound("Click");
                    rootClass.world.sendLoadShopRequest(1);
                    break;
                case "btnLever":
                case "btnWheel":
                    bHasItem = false;

                    if (bCooldown || !rootClass.world.coolDown("wheel"))
                    {
                        rootClass.mixer.playSound("Bad");
                        rootClass.addUpdate("Swaggy: Slow down! One spin at a time.");
                        return;
                    }

                    if (!setQuestVariables())
                    {
                        rootClass.MsgBox.notify("You need a Fortune Ticket to spin for Amazing Prizes!");
                        return;
                    }
					
					if (intQuest == -1)
					{
						rootClass.mixer.playSound("Bad");
                        rootClass.addUpdate("Error. Please try again later!");
						return;
					}

                    bCooldown = true;
                    gotoAndPlay("Spin");
                    btnLever.gotoAndPlay("Opening");
                    rootClass.world.tryQuestComplete(intQuest);
                    update();
                    break;
                case "btnClose":
                    rootClass.mixer.playSound("Click");
                    MovieClip(parent).onClose();
                    break;
            }
        }

        public function update() : void {
            var standardTicket:Object = rootClass.world.myAvatar.getItemByID(12);
            var stackTicket:Object = rootClass.world.myAvatar.getItemByID(13);
            var totalTicket:int = 0;

            if (standardTicket != null) totalTicket += int(standardTicket.iQty);
            if (stackTicket != null) totalTicket += int(stackTicket.iQty);

            tTicket.text = totalTicket;
        }

        public function doWheelDrop(dItem:Object):void
        {
            if (prize1 == null)
            {
                prize1 = rootClass.copyObj(rootClass.world.invTree["3"]);
				prize1.canDrop = prize1.iQty < prize1.iStk;
                prize1.iQty = 1;
            }
            if (prize2 == null)
            {
                prize2 = rootClass.copyObj(rootClass.world.invTree["11"]);
				prize2.canDrop = prize2.iQty < prize2.iStk;
                prize2.iQty = 1;
            }

            objReward = dItem;

            if (objReward == null) {
                sFrame = "Potion";
            } else if (objReward.iRty == 26) {
                sFrame = "Treasure";
            } else if (objReward.iRty == 28) {
                sFrame = "Gold";
            } else {
                sFrame = itemType[objReward.sType];
            }
        }

        private function setQuestVariables() : Boolean
        {
            bHasItem = false;

            if (hasItem(12))
            {
                intQuest = 1;
                intItem = 12;
                bHasItem = true;
            }
            else if (hasItem(13))
            {
                intQuest = 1;
                intItem = 13;
                bHasItem = true;
            }
			else
			{
				rootClass.world.sendLoadShopRequest(2);
			}

            return bHasItem;
        }

        private function hasItem(itemId:int) : Boolean
        {
            if (rootClass.world.myAvatar.isItemInInventory(itemId))
            {
                var item:Object = rootClass.world.myAvatar.getItemByID(itemId);
                bHasItem = item.iQty >= 1;
            }
            else
            {
                bHasItem = false;
            }

            return (bHasItem);
        }

        private function frame1() : void
        {
            bIsMember = rootClass.world.myAvatar.isUpgraded();
            bCooldown = false;
			intQuest = -1;
            btnShop.addEventListener(MouseEvent.MOUSE_DOWN, onClick, false, 0, true);
            btnLever.addEventListener(MouseEvent.MOUSE_DOWN, onClick, false, 0, true);
            btnWheel.addEventListener(MouseEvent.MOUSE_DOWN, onClick, false, 0, true);
            stop();
        }

        private function frame8() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame9() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame10() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame11() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame12() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame13() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame14() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame15() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame16() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame18() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame20() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame22() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame24() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame26() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame28() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame30() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame32() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame33() : void
        {
            if (sFrame == null)
            {
                trace("lag looping 1");
                gotoAndPlay("Init");
                rootClass.mixer.playSound("Bad");
                rootClass.addUpdate("Error. Please try again later!");
            }
        }

        private function frame34() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame36() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame37() : void
        {
            mcWheel.gotoAndPlay(sFrame);
        }

        private function frame39() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame43() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame51() : void
        {
            rootClass.mixer.playSound("Click");
        }

        private function frame58() : void
        {
            btnLever.gotoAndPlay("Closing");
        }

        private function frame69() : void
        {
            bCooldown = false;

            if (objReward != null && objReward.iQty < objReward.iStk) rootClass.showItemDrop(objReward, false);
			if (prize1.canDrop) rootClass.showItemDrop(prize1, false);
			if (prize2.canDrop) rootClass.showItemDrop(prize2, false);

            sFrame = null;
            objReward = null;

            gotoAndStop("Init");
        }


    }
}//package town_fla

