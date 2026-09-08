// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Avatar

package 
{
    import flash.display.MovieClip;
    import flash.filters.GlowFilter;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class Avatar 
    {

        public var morphMC:MovieClip;
        public var rootClass:*;
        public var uid:int;
        public var pMC:MovieClip;
        public var pnm:String;
        public var objData:Object = null;
        public var dataLeaf:Object = {};
        public var guild:Object = {};
        public var npcType:String = "player";
        // Populated for database-driven NPCs. Kept separate from objData so
        // server placement/button metadata never collides with normal player fields.
        public var npcData:Object = null;
        public var target:* = null;
        public var targets:Object = {};
        public var isMyAvatar:Boolean = false;
        public var friends:Array = [];
        public var classes:Array;
        public var factions:Array = [];
        public var bank:Array;
        public var items:Array;
        public var houseitems:Array;
        public var tempitems:Array = [];
        public var bitData:Boolean = false;
        public var strFrame:String = "";
        public var petMC:PetMC;
        public var sLinkPet:String = "";
        public var friendsLoaded:Number;
        public var strProj:String = "";
        public var invLoaded:Boolean = false;
        private var loadCount:int = 0;
        public var firstLoad:Boolean = true;
        private var specialAnimation:Object = new Object();
        public var equipOrder:Array = [];
        public var isCharPage:Boolean = false;
        public var isCameraTool:Boolean = false;
        public var isWorldCamera:Boolean = false;
        public var filtered_list:Array;
        public var boosts:Object = {
            "dmgall":[0, ""],
            "undead":[0, ""],
            "human":[0, ""],
            "chaos":[0, ""],
            "dragonkin":[0, ""],
            "orc":[0, ""],
            "drakath":[0, ""],
            "elemental":[0, ""],
            "cp":[0, ""],
            "gold":[0, ""],
            "rep":[0, ""],
            "exp":[0, ""]
        };

        public function Avatar(_arg_1:MovieClip)
        {
            this.rootClass = _arg_1;
        }

        public function initAvatar(_arg_1:Object):*
        {
            var _local_4:*;
            this.isMyAvatar = (this.uid == this.rootClass.sfc.myUserId);
            var _local_2:* = this.rootClass.world;
            var _local_3:* = _local_2.uoTree[this.pnm];
            this.objData = _arg_1.data;

            if (("intGold" in this.objData))
            {
                this.objData.intGold = Number(this.objData.intGold);
            }
            if (("intCoins" in this.objData))
            {
                this.objData.intCoins = Number(this.objData.intCoins);
            }
            if (("dUpgExp" in this.objData))
            {
                this.objData.dUpgExp = this.rootClass.stringToDate(this.objData.dUpgExp);
            }
            if (("dMutedTill" in this.objData))
            {
                this.objData.dMutedTill = this.rootClass.stringToDate(this.objData.dMutedTill);
            }
            if (("dCreated" in this.objData))
            {
                this.objData.dCreated = this.rootClass.stringToDate(this.objData.dCreated);
            }
            this.dataLeaf.intSP = 100;
            this.pMC.strGender = this.objData.strGender;
            this.updateRep();
            this.pMC.updateName();

            switch (Number(_arg_1.data.intAccessLevel))
            {
                case 100:
                case 50:
                    this.pMC.pname.ti.textColor = 12283391;
                    this.pMC.pname.filters = [new GlowFilter(0, 1, 3, 3, 64, 1)];
                    break;
                case 60:
                    this.pMC.pname.ti.textColor = 16698168;
                    this.pMC.pname.filters = [new GlowFilter(0, 1, 3, 3, 64, 1)];
                    break;
                case 40:
                    this.pMC.pname.ti.textColor = 5308200;
                    this.pMC.pname.filters = [new GlowFilter(0, 1, 3, 3, 64, 1)];
                    break;
                case 30:
                    this.pMC.pname.ti.textColor = 52881;
                    this.pMC.pname.filters = [new GlowFilter(0, 1, 3, 3, 64, 1)];
                    break;
                default:
                    if (this.isUpgraded())
                    {
                        this.pMC.pname.ti.textColor = 9229823;
                    }
                    this.pMC.pname.filters = [new GlowFilter(0, 1, 3, 3, 64, 1)];
            }

            if (this.objData.guild != null)
            {
                this.pMC.pname.tg.text = (("< " + String(this.objData.guild.Name)) + " >");
            }

            if (objData.title != null) {
                pMC.pname.tt.text = objData.title.Name;
                pMC.pname.tt.textColor = objData.title.Color;
            } else {
                pMC.pname.tt.text = "";
            }

            this.pMC.ignore.visible = this.rootClass.chatF.isIgnored(_arg_1.data.strUsername);

            if (this.objData.eqp != null)
            {
                for (_local_4 in this.objData.eqp)
                {
                    this.loadCount++;
                    this.loadMovieAtES(_local_4, this.objData.eqp[_local_4].sFile, this.objData.eqp[_local_4].sLink);
                    this.updateItemAnimation(this.objData.eqp[_local_4].sMeta);
                }
            }
            this.pMC.loadHair();
            this.bitData = true;
            if (((_local_2.strAreaName.toLowerCase().indexOf("magicmeadow") == 0) || (_local_2.strAreaName.toLowerCase().indexOf("magicmeaderp") == 0)))
            {
                this.swapMorphs(true);
            }
        }

        public function swapMorphs(_arg_1:Boolean):void
        {
            var _local_2:*;
            var _local_3:Class;
            if (_arg_1)
            {
                if (((!(this.morphMC == null)) && (!(this.morphMC.parent == null))))
                {
                    MovieClip(this.morphMC.parent).removeChild(this.morphMC);
                    this.morphMC = null;
                }
                _local_2 = this.rootClass.getInterface("pony_engine");
                _local_2 = _local_2.getChildAt(0);
                switch (this.pMC.strGender)
                {
                    case "F":
                        _local_3 = (_local_2.FemalePonyMC() as Class);
                        break;
                    default:
                        _local_3 = (_local_2.MalePonyMC() as Class);
                }
                this.morphMC = new (_local_3)();
                this.pMC.addChild(this.morphMC);
                this.morphMC.name = "morphMC";
                this.morphMC.x = 0;
                this.morphMC.y = 0;
                this.morphMC.scaleX = (this.morphMC.scaleX * ((this.pMC.mcChar.scaleX < 0) ? -1 : 1));
                this.morphMC.visible = true;
                this.pMC.mcChar.visible = false;
            }
            else
            {
                this.morphMC.visible = false;
                this.pMC.mcChar.visible = true;
            }
        }

        public function loadMovieAtES(_arg_1:*, _arg_2:*, _arg_3:*):void
        {
            if (((this.pMC.isRasterized) && (!(_arg_1 == "pe"))))
            {
                return;
            }
            if (_arg_1 != null)
            {
                switch (_arg_1)
                {
                    case "Weapon":
                        this.pMC.loadWeapon(_arg_2, _arg_3);
                        return;
                    case "he":
                        this.pMC.loadHelm(_arg_2, _arg_3);
                        return;
                    case "ba":
                        this.pMC.loadCape(_arg_2, _arg_3);
                        return;
                    case "ar":
                        this.pMC.loadClass(_arg_2, _arg_3);
                        return;
                    case "co":
                        this.pMC.loadArmor(_arg_2, _arg_3);
                        return;
                    case "pe":
                        this.loadPet();
                        return;
                    case "mi":
                        this.pMC.loadMisc(_arg_2, _arg_3);
                        return;
                }
            }
        }

        public function unloadMovieAtES(_arg_1:*):void
        {
            if (((this.pMC.isRasterized) && (!(_arg_1 == "pe"))))
            {
                return;
            }
            if (_arg_1 != null)
            {
                switch (_arg_1)
                {
                    case "he":
                        this.pMC.mcChar.head.helm.visible = false;
                        if (((this.pMC.helmBackHair) && (this.pMC.bBackHair)))
                        {
                            this.pMC.helmBackHair = false;
                            this.pMC.loadHair();
                        }
                        else
                        {
                            this.pMC.mcChar.head.hair.visible = true;
                            this.pMC.mcChar.backhair.visible = this.pMC.bBackHair;
                            if (this == this.rootClass.world.myAvatar)
                            {
                                this.rootClass.showPortrait(this);
                            }
                            if (this == this.rootClass.world.myAvatar.target)
                            {
                                this.rootClass.showPortraitTarget(this);
                            }
                        }
                        return;
                    case "ba":
                        this.pMC.mcChar.cape.visible = false;
                        return;
                    case "pe":
                        this.unloadPet();
                        return;
                    case "co":
                        this.pMC.loadClass(this.objData.eqp["ar"].sFile, this.objData.eqp["ar"].sLink);
                        return;
                    case "mi":
                        this.pMC.cShadow.visible = false;
                        this.pMC.shadow.alpha = 1;
                        return;
                }
            }
        }

        public function loadPet():void
        {
            if ((((((this.rootClass.world.doLoadPet(this)) && (!(this.objData == null))) && (!(this.objData.eqp == null))) && (!(this.objData.eqp["pe"] == null))) && (this.rootClass.world.CHARS.contains(this.pMC))))
            {
                if (((this.petMC == null) || (!(this.petMC))))
                {
                    this.petMC = new PetMC();
                    this.petMC.mouseEnabled = (this.petMC.mouseChildren = false);
                    this.petMC.WORLD = this.rootClass.world;
                    this.petMC.pAV = this;
                }

                rootClass.onLoadMaster(onLoadPetComplete, rootClass.world.loaderC, this.objData.eqp["pe"].sFile, null, this.onLoadPetError);
            }
        }

        private function onLoadPetError(_arg_1:Event):void
        {
            this.unloadPet();
        }

        public function onLoadPetComplete(_arg_1:Event):void
        {
            var _local_2:Class;
            try
            {
                _local_2 = (this.rootClass.world.loaderD.getDefinition(this.objData.eqp["pe"].sLink) as Class);
                this.petMC.removeChildAt(1);
                this.petMC.mcChar = MovieClip(this.petMC.addChildAt(new (_local_2)(), 1));
                this.petMC.mcChar.name = "mc";
            }
            catch(e:Error)
            {
            }
            if (((!(this.isMyAvatar)) && (this.rootClass.world.hideOtherPets)))
            {
                return;
            }
            if (this.rootClass.world.uoTree[this.objData.strUsername.toLowerCase()].strFrame == this.rootClass.world.strFrame)
            {
                if (((this.petMC.stage == null) && (this.petMC.getChildByName("defaultmc") == null)))
                {
                    MovieClip(this.rootClass.world.CHARS.addChild(this.petMC)).name = ("pet_" + this.uid);
                }
                this.petMC.scale(this.pMC.mcChar.scaleY);
                this.petPos();
            }
        }

        public function petPos():void
        {
            this.petMC.x = (this.pMC.x - 20);
            this.petMC.y = (this.pMC.y + 5);
        }

        public function unloadPet():void
        {
            if (this.petMC != null)
            {
                if (this.petMC.stage != null)
                {
                    this.rootClass.world.CHARS.removeChild(this.petMC);
                }
                this.petMC = null;
            }
        }

        public function showMC():void
        {
            if (this.pMC != null)
            {
                if (this.rootClass.world.TRASH.contains(this.pMC))
                {
                    this.rootClass.world.CHARS.addChild(this.rootClass.world.TRASH.removeChild(this.pMC));
                }
                else
                {
                    this.rootClass.world.CHARS.addChild(this.pMC);
                }
                if (((this.rootClass.world.bPvP) && (this.pMC.mcChar.onMove)))
                {
                    this.pMC.calculateNewPxPy();
                    if (((!(this.pMC.px == 0)) && (!(this.pMC.py == 0))))
                    {
                        this.pMC.mcChar.gotoAndPlay("Walk");
                        this.pMC.walkTo(this.pMC.tx, this.pMC.ty, this.pMC.sp);
                    }
                }
                this.showPetMC();
            }
        }

        public function hideMC():void
        {
            if (this.pMC != null)
            {
                if (this.rootClass.world.CHARS.contains(this.pMC))
                {
                    this.rootClass.world.TRASH.addChild(this.rootClass.world.CHARS.removeChild(this.pMC));
                }
                else
                {
                    this.rootClass.world.TRASH.addChild(this.pMC);
                }
                this.hidePetMC();
            }
        }

        public function showPetMC():void
        {
            if (this.petMC == null)
            {
                this.loadPet();
            }
            else
            {
                if (((this.petMC.stage == null) && (this.petMC.getChildByName("defaultmc") == null)))
                {
                    this.rootClass.world.CHARS.addChild(this.petMC);
                    this.petMC.scale(this.pMC.mcChar.scaleY);
                    this.petPos();
                }
            }
        }

        public function hidePetMC():void
        {
            if (((!(this.petMC == null)) && (!(this.petMC.stage == null))))
            {
                this.rootClass.world.CHARS.removeChild(this.petMC);
            }
        }

        public function initFactions(_arg_1:Array):void
        {
            var _local_2:int;
            if (_arg_1 == null)
            {
                this.factions = [];
            }
            else
            {
                this.factions = _arg_1;
                _local_2 = 0;
                while (_local_2 < this.factions.length)
                {
                    this.initFaction(this.factions[_local_2]);
                    _local_2++;
                }
            }
        }

        public function addFaction(_arg_1:Object):void
        {
            if (((!(_arg_1 == null)) && (!(this.factions == null))))
            {
                this.factions.push(_arg_1);
                this.initFaction(_arg_1);
            }
        }

        public function addRep(_arg_1:int, _arg_2:int, _arg_3:int=0):void
        {
            var _local_5:int;
            var _local_6:String;
            var _local_4:* = this.getFaction(_arg_1);
            if (_local_4 != null)
            {
                _local_5 = _local_4.iRank;
                _local_4.iRep = (_local_4.iRep + _arg_2);
                this.initFaction(_local_4);
                if (_local_4.iRank > _local_5)
                {
                    this.rankUp(_local_4.sName, _local_4.iRank);
                    this.rootClass.FB_showFeedDialog("Rank Up!", (((("reached Rank " + _local_4.iRank) + " for ") + _local_4.sName) + " Reputation in AQWorlds!"), "aqw-rankup.jpg");
                }
                _local_6 = "";
                if (_arg_3 > 0)
                {
                    _local_6 = ((" + " + _arg_3) + "(Bonus)");
                }
                this.rootClass.chatF.pushMsg("server", ((((("Reputation for " + _local_4.sName) + " increased by ") + (_arg_2 - _arg_3)) + _local_6) + "."), "SERVER", "", 0);
            }
        }

        public function initFaction(_arg_1:*):void
        {
            _arg_1.iRep = int(_arg_1.iRep);
            _arg_1.iRank = this.rootClass.getRankFromPoints(_arg_1.iRep);
            _arg_1.iRepToRank = 0;
            if (_arg_1.iRank < this.rootClass.iRankMax)
            {
                _arg_1.iRepToRank = (this.rootClass.arrRanks[_arg_1.iRank] - this.rootClass.arrRanks[(_arg_1.iRank - 1)]);
            }
            _arg_1.iSpillRep = (_arg_1.iRep - this.rootClass.arrRanks[(_arg_1.iRank - 1)]);
        }

        public function getRep(_arg_1:Object):int
        {
            var _local_2:* = this.getFaction(_arg_1);
            return ((_local_2 == null) ? 0 : _local_2.iRep);
        }

        public function getFaction(_arg_1:Object):Object
        {
            return ((isNaN(Number(_arg_1))) ? this.getFactionByName(String(_arg_1)) : this.getFactionByID(int(_arg_1)));
        }

        private function getFactionByID(_arg_1:int):Object
        {
            var _local_2:int;
            while (_local_2 < this.factions.length)
            {
                if (this.factions[_local_2].FactionID == _arg_1)
                {
                    return (this.factions[_local_2]);
                }
                _local_2++;
            }
            return (null);
        }

        private function getFactionByName(_arg_1:String):Object
        {
            var _local_2:int;
            while (_local_2 < this.factions.length)
            {
                if (this.factions[_local_2].sName == _arg_1)
                {
                    return (this.factions[_local_2]);
                }
                _local_2++;
            }
            return (null);
        }

        public function initFriendsList(_arg_1:Array):void
        {
            if (_arg_1 != null)
            {
                this.friends = _arg_1;
            }
        }

        public function addFriend(_arg_1:Object):void
        {
            if (_arg_1 != null)
            {
                this.friends.push(_arg_1);
                if (this.rootClass.ui.mcOFrame.currentLabel == "Idle")
                {
                    this.rootClass.ui.mcOFrame.update();
                }
            }
        }

        public function updateFriend(_arg_1:Object):void
        {
            var _local_2:int;
            if (_arg_1 != null)
            {
                _local_2 = 0;
                while (_local_2 < this.friends.length)
                {
                    if (this.friends[_local_2].ID == _arg_1.ID)
                    {
                        this.friends[_local_2] = _arg_1;
                        break;
                    }
                    _local_2++;
                }
                if (this.rootClass.ui.mcOFrame.currentLabel == "Idle")
                {
                    this.rootClass.ui.mcOFrame.update();
                }
            }
        }

        public function deleteFriend(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < this.friends.length)
            {
                if (this.friends[_local_2].ID == _arg_1)
                {
                    this.friends.splice(_local_2, 1);
                    break;
                }
                _local_2++;
            }
            if (this.rootClass.ui.mcOFrame.currentLabel == "Idle")
            {
                this.rootClass.ui.mcOFrame.update();
            }
        }

        public function isFriend(_arg_1:int):Boolean
        {
            var _local_2:* = 0;
            while (_local_2 < this.friends.length)
            {
                if (this.friends[_local_2].ID == _arg_1)
                {
                    return (true);
                }
                _local_2++;
            }
            return (false);
        }

        public function isFriendName(_arg_1:String):Boolean
        {
            var _local_2:* = 0;
            while (_local_2 < this.friends.length)
            {
                if (this.friends[_local_2].sName.toLowerCase() == _arg_1.toLowerCase())
                {
                    return (true);
                }
                _local_2++;
            }
            return (false);
        }

        internal function initGuild(_arg_1:Object):void
        {
            this.guild = _arg_1;
            if (_arg_1 != null)
            {
                this.pMC.pname.tg.text = (("< " + String(_arg_1.Name)) + " >");
                this.rootClass.chatF.chn.guild.act = 1;
                this.objData.guild = _arg_1;
            }
        }

        public function updateGuild(_arg_1:Object):void
        {
            this.objData.guild = _arg_1;
            if (this.objData.guild != null)
            {
                this.pMC.pname.tg.text = (("< " + String(this.objData.guild.Name)) + " >");
            }
            else
            {
                this.pMC.pname.tg.text = "";
            }
            if (_arg_1 != null)
            {
                this.updateGuildInfo();
            }
        }

        public function updateGuildInfo():void
        {
            if (this.rootClass.ui.mcPopup.currentLabel == "GuildPanelNew")
            {
                if (this.rootClass.getChildByName("guildPanel"))
                {
                    ((this.rootClass.getChildByName("guildPanel") as MovieClip).getChildAt(0) as MovieClip).updateData();
                }
            }
        }

        public function initInventory(_arg_1:Array):void
        {
            var _local_2:*;
            var _local_3:Array;
            var _local_4:String;
            var _local_5:Object;
            if (_arg_1 == null)
            {
                this.items = [];
            }
            else
            {
                this.items = _arg_1;
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    this.items[_local_2].iQty = int(this.items[_local_2].iQty);
                    this.rootClass.world.invTree[this.items[_local_2].ItemID] = this.items[_local_2];
                    _local_2++;
                }
                _local_3 = ["Weapon", "he", "ba", "co"];
                for each (_local_4 in _local_3)
                {
                    if (this.objData.eqp[_local_4] == null)
                    {
                        _local_5 = this.getWearAtES(_local_4);
                        if (_local_5 != null)
                        {
                            this.objData.eqp[_local_4] = {};
                            this.objData.eqp[_local_4].sFile = _local_5.sFile;
                            this.objData.eqp[_local_4].sLink = _local_5.sLink;
                            this.objData.eqp[_local_4].sType = _local_5.sType;
                            this.loadMovieAtES(_local_4, _local_5.sFile, _local_5.sLink);
                        }
                    }
                }
            }
        }

        public function cleanInventory():void
        {
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < this.items.length)
            {
                _local_2 = this.items[_local_1];
                if (_local_2.iQty == null)
                {
                    _local_2.iQty = 1;
                }
                _local_1++;
            }
        }

        public function auctionReset():void{
            rootClass.world.auctioninfo.items.splice(0);
            rootClass.auctionTabs.fRefresh({"filter":'*'});
        }

        public function retrieveReset():void{
            rootClass.world.retrieveinfo.items.splice(0);
            rootClass.auctionTabs.fRefresh({"test":''});
        }

        public function inventoryReset() : void
        {
            rootClass.world.myAvatar.items.splice(0);
            rootClass.inventoryTabs.fRefresh({"filter":"*"});
        }

        public function removeRetrieve(AuctionId:int):void{
            var _local3:*;
            var _local2:int;
            var test:*;
            while (_local2 < rootClass.world.retrieveinfo.items.length) {
                if (rootClass.world.retrieveinfo.items[_local2].AuctionID == AuctionId){
                    _local3 = rootClass.world.retrieveinfo.items[_local2];
                    test = rootClass.world.retrieveinfo.items.splice(_local2, 1)[0];
                    return;
                }
                _local2++;
            }
        }

        public function auctionToInv(item:Object):void{
            var AuctionId = item.AuctionID;
            var itemId = item.ItemID;
            var _local3:*;
            var _local2:int;
            var test:*;
            while (_local2 < rootClass.world.auctioninfo.items.length) {
                if (rootClass.world.auctioninfo.items[_local2].AuctionID == AuctionId){
                    _local3 = rootClass.world.auctioninfo.items[_local2];
                    test = rootClass.world.auctioninfo.items.splice(_local2, 1)[0];
                    if (isItemInInventory(itemId)) {
                        trace("Found");
                        _local3.iQty += rootClass.world.invTree[itemId].iQty;
                        var _local4:int;
                        while (_local4 < items.length) {
                            if (items[_local4].ItemID == itemId) {
                                items[_local4].iQty = _local3.iQty;
                                items[_local4].CharItemID = item.CharItemID;
                                trace("Updated existing");
                                break;
                            }
                            _local4++;
                        }
                    } else {
                        test.CharItemID = item.CharItemID;
                        items.push(test);
                    }

                    rootClass.world.invTree[itemId] = _local3;
                    rootClass.world.invTree[itemId].CharItemID = item.CharItemID;
                    return;
                }
                _local2++;
            }
        }

        public function initBank(_arg_1:Array):void
        {
            var _local_2:int;
            if (_arg_1 == null)
            {
                this.bank = [];
            }
            else
            {
                this.bank = _arg_1;
                _local_2 = 0;
                while (_local_2 < this.bank.length)
                {
                    if (this.bank[_local_2].bCoins == 0)
                    {
                        this.iBankCount++;
                    }
                    this.bank[_local_2].iQty = int(this.bank[_local_2].iQty);
                    _local_2++;
                }
            }
        }

        public function bankFromInv(_arg_1:int):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].ItemID == _arg_1)
                {
                    if (this.items[_local_2].bCoins == 0)
                    {
                        this.iBankCount++;
                    }
                    this.rootClass.world.addItemsToBank(this.rootClass.copyObj(this.items.splice(_local_2, 1)));
                    this.rootClass.world.invTree[_arg_1].iQty = 0;
                    this.removeFromFiltered(_arg_1);
                    this.rootClass.world.bankinfo.bankFromInv(_arg_1);
                    return;
                }
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this.houseitems.length)
            {
                if (this.houseitems[_local_2].ItemID == _arg_1)
                {
                    if (this.houseitems[_local_2].bCoins == 0)
                    {
                        this.iBankCount++;
                    }
                    this.rootClass.world.addItemsToBank(this.rootClass.copyObj(this.houseitems.splice(_local_2, 1)));
                    this.rootClass.world.invTree[_arg_1].iQty = 0;
                    this.removeFromFiltered(_arg_1);
                    this.rootClass.world.bankinfo.bankFromInv(_arg_1);
                    return;
                }
                _local_2++;
            }
        }

        public function bankToInv(_arg_1:int):void
        {
            var _local_2:Object = this.rootClass.world.bankinfo.bankToInv(_arg_1);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3:Boolean = ((_local_2.bHouse != null) ? (int(_local_2.bHouse) == 1) : false);
            (((((_local_3) || (_local_2.sType == "House")) || (_local_2.sType == "Floor Item")) || (_local_2.sType == "Wall Item")) ? this.houseitems : this.items).push(_local_2);
            this.rootClass.world.invTree[_arg_1] = _local_2;
        }

        public function bankSwapInv(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Object;
            var _local_4:Object;
            var _local_6:Boolean;
            var _local_5:int;
            _local_5 = 0;
            while (_local_5 < this.items.length)
            {
                if (this.items[_local_5].ItemID == _arg_1)
                {
                    _local_4 = this.items.splice(_local_5, 1)[0];
                    break;
                }
                _local_5++;
            }
            _local_5 = 0;
            while (_local_5 < this.houseitems.length)
            {
                if (this.houseitems[_local_5].ItemID == _arg_1)
                {
                    _local_4 = this.houseitems.splice(_local_5, 1)[0];
                    break;
                }
                _local_5++;
            }
            _local_3 = this.rootClass.world.bankinfo.bankToInv(_arg_2);
            if (((!(_local_3 == null)) && (!(_local_4 == null))))
            {
                this.rootClass.world.bankinfo.addItem(this.rootClass.copyObj(_local_4));
                if (_local_4.bCoins == 0)
                {
                    this.iBankCount++;
                }
                this.rootClass.world.invTree[_arg_1].iQty = 0;
                _local_6 = ((_local_3.bHouse != null) ? (int(_local_3.bHouse) == 1) : false);
                (((((_local_6) || (_local_3.sType == "House")) || (_local_3.sType == "Floor Item")) || (_local_3.sType == "Wall Item")) ? this.houseitems : this.items).push(_local_3);
                if (_local_3.bCoins == 0)
                {
                    this.iBankCount--;
                }
                this.rootClass.world.invTree[_arg_2] = _local_3;
                this.rootClass.world.bankinfo.bankFromInv(_arg_1);
            }
        }

        public function tradeFromInv(_arg1:int, _arg2:int, _arg3:int):void{
            var _local2:int;
            var test:int;
            while (_local2 < items.length) {
                if (items[_local2].ItemID == _arg1){
                    var initItem:Object = rootClass.copyObj(items[_local2]);
                    var test2:* = rootClass.copyObj(items.splice(_local2, 1));
                    var _local4:int;
                    while (_local4 < test2.length) {
                        if (test2[_local4].ItemID == _arg1) {
                            test2[_local4].iQty = _arg3;
                            trace(" Quantity Set: " + _arg3);
                        }
                        _local4++;
                    }

                    rootClass.world.addItemsToTradeA(test2);

                    initItem.iQty -= _arg3;
                    if (initItem.iQty > 0) {
                        trace("Quantity item: " + initItem.iQty);
                        rootClass.world.invTree[_arg1].iQty = initItem.iQty;
                        items.push(rootClass.world.invTree[_arg1]);
                    } else {
                        rootClass.world.invTree[_arg1].iQty = 0;
                    }
                    return;
                }
                _local2++;
            }
        }

        public function tradeToInvReset():void{
            var _local3:*;
            var _local2:int;
            var test:*;
            while (_local2 < rootClass.world.tradeinfo.itemsA.length) {
                _local3 = rootClass.world.tradeinfo.itemsA[_local2];
                trace("Offer Item: " + _local3.ItemID);
                if (isItemInInventory(_local3.ItemID)) {
                    trace("Found");
                    _local3.iQty += rootClass.world.invTree[_local3.ItemID].iQty;
                    var _local4:int;
                    while (_local4 < items.length) {
                        if (items[_local4].ItemID == _local3.ItemID) {
                            items[_local4].iQty = _local3.iQty;
                            trace("Updated existing: " + _local3.ItemID);
                            break;
                        }
                        _local4++;
                    }
                } else {
                    trace("Adding back item: " + _local3.ItemID);
                    items.push(_local3);
                }

                rootClass.world.invTree[_local3.ItemID] = _local3;
                _local2++;
            }
        }

        public function tradeToInvA(_arg1:int):void{
            var _local3:*;
            var _local2:int;
            var test:*;
            while (_local2 < rootClass.world.tradeinfo.itemsA.length) {
                if (rootClass.world.tradeinfo.itemsA[_local2].ItemID == _arg1){
                    _local3 = rootClass.world.tradeinfo.itemsA[_local2];
                    test = rootClass.world.tradeinfo.itemsA.splice(_local2, 1)[0];
                    if (isItemInInventory(_arg1)) {
                        trace("Found");
                        _local3.iQty += rootClass.world.invTree[_arg1].iQty;
                        var _local4:int;
                        while (_local4 < items.length) {
                            if (items[_local4].ItemID == _arg1) {
                                items[_local4].iQty = _local3.iQty;
                                trace("Updated existing");
                                break;
                            }
                            _local4++;
                        }
                    } else {
                        items.push(test);
                    }

                    rootClass.world.invTree[_arg1] = _local3;
                    return;
                }
                _local2++;
            }
        }

        public function tradeToInvB(_arg1:int):void{
            var _local2:int;
            while (_local2 < rootClass.world.tradeinfo.itemsB.length) {
                if (rootClass.world.tradeinfo.itemsB[_local2].ItemID == _arg1){
                    rootClass.world.tradeinfo.itemsB.splice(_local2, 1)[0];
                    return;
                }
                _local2++;
            }
        }

        public function tradeSwapInv(_arg1:int, _arg2:int):void{
            var _local3:Object;
            var _local4:Object;
            var _local5:int;
            _local5 = 0;
            while (_local5 < items.length) {
                if (items[_local5].ItemID == _arg1){
                    _local4 = items.splice(_local5, 1)[0];
                    break;
                }
                _local5++;
            }
            _local5 = 0;
            while (_local5 < rootClass.world.tradeinfo.itemsA.length) {
                if (rootClass.world.tradeinfo.itemsA[_local5].ItemID == _arg2){
                    _local3 = rootClass.world.tradeinfo.itemsA.splice(_local5, 1)[0];
                    break;
                }
                _local5++;
            }
            if (((!((_local3 == null))) && (!((_local4 == null))))){
                rootClass.world.tradeinfo.itemsA.push(rootClass.copyObj(_local4));
                rootClass.world.invTree[_arg1].iQty = 0;
                items.push(_local3);
                rootClass.world.invTree[_arg2] = _local3;
            }
        }

        public function removeItem(_arg_1:Object):void
        {
            var _local_4:*;
            var _local_5:int;
            var _local_6:int;
            if (((_arg_1.hasOwnProperty("bBank")) && (Boolean(_arg_1.bBank))))
            {
                _local_4 = this.getItemByCharID(_arg_1.CharItemID);
                if (_local_4 != null)
                {
                    if (this.isItemInInventory(_local_4.ItemID))
                    {
                        this.bankFromInv(_local_4.ItemID);
                    }
                    this.removeFromBank(_arg_1);
                }
                return;
            }
            if (!_arg_1.hasOwnProperty("iQty"))
            {
                _arg_1.iQty = 1;
            }
            var _local_2:int;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].CharItemID == _arg_1.CharItemID)
                {
                    _local_5 = ((_arg_1.hasOwnProperty("iQtyNow")) ? _arg_1.iQtyNow : (this.items[_local_2].iQty - _arg_1.iQty));
                    if (((this.items[_local_2].sES == "ar") || (_local_5 < 1)))
                    {
                        this.items[_local_2].iQty = 0;
                        this.rootClass.resetInvTreeByItemID(this.items[_local_2].ItemID);
                        this.removeFromFiltered(this.items[_local_2].ItemID);
                        this.items.splice(_local_2, 1);
                    }
                    else
                    {
                        this.items[_local_2].iQty = _local_5;
                    }
                    return;
                }
                _local_2++;
            }
            var _local_3:int;
            while (_local_3 < this.houseitems.length)
            {
                _local_6 = ((_arg_1.hasOwnProperty("iQtyNow")) ? _arg_1.iQtyNow : (this.houseitems[_local_3].iQty - _arg_1.iQty));
                if (this.houseitems[_local_3].CharItemID == _arg_1.CharItemID)
                {
                    if (_local_6 > 0)
                    {
                        this.houseitems[_local_3].iQty = _local_6;
                    }
                    else
                    {
                        this.houseitems[_local_3].iQty = 0;
                        this.removeFromFiltered(this.houseitems[_local_3].ItemID);
                        this.houseitems.splice(_local_3, 1);
                    }
                    return;
                }
                _local_3++;
            }
        }

        public function removeItemByID(_arg_1:int, _arg_2:int=1):void
        {
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < this.items.length)
            {
                if (this.items[_local_3].ItemID == _arg_1)
                {
                    if (((this.items[_local_3].sES == "ar") || (this.items[_local_3].iQty <= _arg_2)))
                    {
                        this.items[_local_3].iQty = 0;
                        this.items.splice(_local_3, 1);
                    }
                    else
                    {
                        this.items[_local_3].iQty = (this.items[_local_3].iQty - _arg_2);
                    }
                    return;
                }
                _local_3++;
            }
            _local_3 = 0;
            while (_local_3 < this.houseitems.length)
            {
                if (this.houseitems[_local_3].ItemID == _arg_1)
                {
                    if (this.houseitems[_local_3].iQty <= _arg_2)
                    {
                        this.houseitems[_local_3].iQty = 0;
                        this.houseitems.splice(_local_3, 1);
                    }
                    else
                    {
                        this.houseitems[_local_3].iQty = (this.houseitems[_local_3].iQty - _arg_2);
                    }
                    return;
                }
                _local_3++;
            }
        }

        public function removeFromFiltered(_arg_1:int):void
        {
            if (!this.filtered_list)
            {
                return;
            }
            if (((this.filtered_list) && (this.filtered_list.length < 1)))
            {
                return;
            }
            var _local_2:int;
            while (_local_2 < this.filtered_list.length)
            {
                if (this.filtered_list[_local_2].ItemID == _arg_1)
                {
                    this.filtered_list.splice(_local_2, 1);
                    return;
                }
                _local_2++;
            }
        }

        public function get filtered_inventory():Array
        {
            return (((this.filtered_list) && (this.filtered_list.length > 0)) ? this.filtered_list : (((this.rootClass.ui.mcPopup.currentLabel == "HouseInventory") || (this.rootClass.ui.mcPopup.currentLabel == "HouseBank")) ? this.houseitems : this.items));
        }

        public function addItem(_arg_1:Object):void
        {
            var _local_2:Array;
            var _local_5:*;
            if (Boolean(_arg_1.bBank))
            {
                _local_5 = this.getItemByCharID(_arg_1.CharItemID);
                if (_local_5 != null)
                {
                    if (this.isItemInInventory(_local_5.ItemID))
                    {
                        this.bankFromInv(_local_5.ItemID);
                    }
                    this.addToBank(_arg_1);
                }
                return;
            }
            var _local_3:Boolean = ((_arg_1.bHouse != null) ? (int(_arg_1.bHouse) == 1) : false);
            _local_2 = (((((_local_3) || (_arg_1.sType == "House")) || (_arg_1.sType == "Floor Item")) || (_arg_1.sType == "Wall Item")) ? this.houseitems : this.items);
            var _local_4:int;
            while (_local_4 < _local_2.length)
            {
                if (_local_2[_local_4].ItemID == _arg_1.ItemID)
                {
                    if (_arg_1.hasOwnProperty("iQtyNow"))
                    {
                        _local_2[_local_4].iQty = int(_arg_1.iQtyNow);
                    }
                    else
                    {
                        _local_2[_local_4].iQty = (_local_2[_local_4].iQty + int(_arg_1.iQty));
                    }
                    return;
                }
                _local_4++;
            }
            _arg_1.iQty = int(_arg_1.iQty);
            this.rootClass.world.invTree[_arg_1.ItemID] = _arg_1;
            _local_2.push(_arg_1);
        }

        public function addToBank(_arg_1:*):void
        {
            var _local_3:*;
            var _local_2:* = this.rootClass.world.bankinfo.bankItems;
            if (((_local_2 == null) || (_local_2.length == 0)))
            {
                return;
            }
            for each (_local_3 in _local_2)
            {
                if (_local_3.ItemID == _arg_1.ItemID)
                {
                    if (_arg_1.hasOwnProperty("iQtyNow"))
                    {
                        _local_3.iQty = int(_arg_1.iQtyNow);
                    }
                    else
                    {
                        _local_3.iQty = (_local_3.iQty + int(_arg_1.iQty));
                    }
                    this.rootClass.world.bankinfo.bankModified = true;
                    return;
                }
            }
        }

        public function removeFromBank(_arg_1:*):void
        {
            var _local_4:int;
            var _local_2:* = this.rootClass.world.bankinfo.bankItems;
            if (((_local_2 == null) || (_local_2.length == 0)))
            {
                return;
            }
            if (!_arg_1.hasOwnProperty("iQty"))
            {
                _arg_1.iQty = 1;
            }
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].CharItemID == _arg_1.CharItemID)
                {
                    _local_4 = ((_arg_1.hasOwnProperty("iQtyNow")) ? _arg_1.iQtyNow : (_local_2[_local_3].iQty - _arg_1.iQty));
                    if (((_local_2[_local_3].sES == "ar") || (_local_4 < 1)))
                    {
                        _local_2[_local_3].iQty = 0;
                        this.rootClass.resetInvTreeByItemID(_local_2[_local_3].ItemID);
                        this.removeFromFiltered(_local_2[_local_3].ItemID);
                        this.rootClass.world.bankinfo.bankItems.splice(_local_3, 1);
                    }
                    else
                    {
                        _local_2[_local_3].iQty = _local_4;
                    }
                    this.rootClass.world.bankinfo.bankModified = true;
                    return;
                }
                _local_3++;
            }
        }

        public function varVal(_arg_1:String):*
        {
            var _local_2:* = MovieClip(this.pMC.mcChar.stage.getChildAt(0));
            var _local_3:* = _local_2.world;
            return (_local_2.sfc.getRoom(_local_3.curRoom).getUser(this.uid).getVariable(_arg_1));
        }

        public function getItemByCharID(_arg_1:Number):Object
        {
            var _local_4:int;
            var _local_2:int;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].CharItemID == _arg_1)
                {
                    return (this.items[_local_2]);
                }
                _local_2++;
            }
            var _local_3:int;
            while (_local_3 < this.houseitems.length)
            {
                if (this.houseitems[_local_3].CharItemID == _arg_1)
                {
                    return (this.houseitems[_local_3]);
                }
                _local_3++;
            }
            if (this.bank != null)
            {
                _local_4 = 0;
                while (_local_4 < this.bank.length)
                {
                    if (this.bank[_local_4].CharItemID == _arg_1)
                    {
                        return (this.bank[_local_4]);
                    }
                    _local_4++;
                }
            }
            return (null);
        }

        public function getItemByID(_arg_1:int):Object
        {
            var _local_2:int;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].ItemID == _arg_1)
                {
                    return (this.items[_local_2]);
                }
                _local_2++;
            }
            var _local_3:int;
            while (_local_3 < this.houseitems.length)
            {
                if (this.houseitems[_local_3].ItemID == _arg_1)
                {
                    return (this.houseitems[_local_3]);
                }
                _local_3++;
            }
            var _local_4:int;
            while (_local_4 < this.tempitems.length)
            {
                if (this.tempitems[_local_4].ItemID == _arg_1)
                {
                    return (this.tempitems[_local_4]);
                }
                _local_4++;
            }
            if (this.rootClass.world.bankinfo != null)
            {
                if (this.rootClass.world.bankinfo.isItemInBank(_arg_1))
                {
                    return (this.rootClass.world.bankinfo.getBankItem(_arg_1));
                }
            }
            return (null);
        }

        public function getItemIDByName(_arg_1:String):int
        {
            var _local_2:int;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].sName == _arg_1)
                {
                    return (this.items[_local_2].ItemID);
                }
                _local_2++;
            }
            var _local_3:int;
            while (_local_3 < this.houseitems.length)
            {
                if (this.houseitems[_local_3].sName == _arg_1)
                {
                    return (this.houseitems[_local_3].ItemID);
                }
                _local_3++;
            }
            var _local_4:int;
            while (_local_4 < this.tempitems.length)
            {
                if (this.tempitems[_local_4].sName == _arg_1)
                {
                    return (this.tempitems[_local_4].ItemID);
                }
                _local_4++;
            }
            return (-1);
        }

        public function isItemInBank(_arg_1:Number):Boolean
        {
            var _local_2:int;
            if (this.bank != null)
            {
                _local_2 = 0;
                while (_local_2 < this.bank.length)
                {
                    if (this.bank[_local_2].ItemID == _arg_1)
                    {
                        return (true);
                    }
                    _local_2++;
                }
            }
            return (false);
        }

        public function isItemInInventory(_arg_1:Object):Boolean
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:int = ((isNaN(Number(_arg_1))) ? this.getItemIDByName(String(_arg_1)) : int(_arg_1));
            if (_local_2 > 0)
            {
                _local_3 = 0;
                while (_local_3 < this.items.length)
                {
                    if (this.items[_local_3].ItemID == _local_2)
                    {
                        return (true);
                    }
                    _local_3++;
                }
                _local_4 = 0;
                while (_local_4 < this.houseitems.length)
                {
                    if (this.houseitems[_local_4].ItemID == _local_2)
                    {
                        return (true);
                    }
                    _local_4++;
                }
            }
            return (false);
        }

        public function isItemStackMaxed(_arg_1:Number):Boolean
        {
            var _local_2:int;
            if (this.bank != null)
            {
                _local_2 = 0;
                while (_local_2 < this.bank.length)
                {
                    if (((this.bank[_local_2].ItemID == _arg_1) && (this.bank[_local_2].iQty >= this.bank[_local_2].iStk)))
                    {
                        return (true);
                    }
                    _local_2++;
                }
            }
            if (this.items != null)
            {
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    if (((this.items[_local_2].ItemID == _arg_1) && (this.items[_local_2].iQty >= this.items[_local_2].iStk)))
                    {
                        return (true);
                    }
                    _local_2++;
                }
            }
            if (this.houseitems != null)
            {
                _local_2 = 0;
                while (_local_2 < this.houseitems.length)
                {
                    if (((this.houseitems[_local_2].ItemID == _arg_1) && (this.houseitems[_local_2].iQty >= this.houseitems[_local_2].iStk)))
                    {
                        return (true);
                    }
                    _local_2++;
                }
            }
            return (false);
        }

        public function addTempItem(_arg_1:Object):void
        {
            var _local_2:int;
            while (_local_2 < this.tempitems.length)
            {
                if (this.tempitems[_local_2].ItemID == _arg_1.ItemID)
                {
                    this.tempitems[_local_2].iQty = (this.tempitems[_local_2].iQty + int(_arg_1.iQty));
                    return;
                }
                _local_2++;
            }
            this.tempitems.push(_arg_1);
            this.rootClass.world.invTree[_arg_1.ItemID] = _arg_1;
        }

        public function removeTempItem(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            while (_local_3 < this.tempitems.length)
            {
                if (this.tempitems[_local_3].ItemID == _arg_1)
                {
                    if (this.tempitems[_local_3].iQty > _arg_2)
                    {
                        this.tempitems[_local_3].iQty = (this.tempitems[_local_3].iQty - _arg_2);
                    }
                    else
                    {
                        this.tempitems[_local_3].iQty = 0;
                        this.tempitems.splice(_local_3, 1);
                    }
                    return;
                }
                _local_3++;
            }
        }

        public function checkTempItem(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int;
            while (_local_3 < this.tempitems.length)
            {
                if (((this.tempitems[_local_3].ItemID == _arg_1) && (this.tempitems[_local_3].iQty >= _arg_2)))
                {
                    return (true);
                }
                _local_3++;
            }
            return (false);
        }

        public function getTempItemQty(_arg_1:int):int
        {
            var _local_2:int;
            while (_local_2 < this.tempitems.length)
            {
                if (this.tempitems[_local_2].ItemID == _arg_1)
                {
                    return (this.tempitems[_local_2].iQty);
                }
                _local_2++;
            }
            return (-1);
        }

        public function unequipItemAtES(_arg_1:String):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].sES == _arg_1)
                {
                    this.items[_local_2].bEquip = 0;
                    this.removeItemAnimation(this.items[_local_2].sMeta);
                }
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this.tempitems.length)
            {
                if (this.tempitems[_local_2].sES == _arg_1)
                {
                    this.tempitems[_local_2].bEquip = 0;
                }
                _local_2++;
            }
        }

        public function unequipItemAtType(_arg_1:String):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].sType == _arg_1)
                {
                    this.items[_local_2].bEquip = 0;
                    this.removeItemAnimation(this.items[_local_2].sMeta);
                }
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this.tempitems.length)
            {
                if (this.tempitems[_local_2].sType == _arg_1)
                {
                    this.tempitems[_local_2].bEquip = 0;
                }
                _local_2++;
            }
        }

        public function getWearAtES(_arg_1:String):Object
        {
            var _local_2:int;
            if (((!(this.items == null)) && (this.items.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    if (((this.items[_local_2].bWear == 1) && (this.items[_local_2].sES == _arg_1)))
                    {
                        return (this.items[_local_2]);
                    }
                    _local_2++;
                }
            }
            return (null);
        }

        public function unwearItemAtES(_arg_1:String):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < this.items.length)
            {
                if (this.items[_local_2].sES == _arg_1)
                {
                    this.items[_local_2].bWear = 0;
                }
                _local_2++;
            }
        }

        public function wearItem(_arg_1:int):void
        {
            var _local_2:int;
            if (((!(this.items == null)) && (this.items.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    if (this.items[_local_2].ItemID == _arg_1)
                    {
                        this.unwearItemAtES(this.items[_local_2].sES);
                        this.items[_local_2].bWear = 1;
                        return;
                    }
                    _local_2++;
                }
            }
        }

        public function unwearItem(_arg_1:int):void
        {
            var _local_2:int;
            if (((!(this.items == null)) && (this.items.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    if (this.items[_local_2].ItemID == _arg_1)
                    {
                        this.items[_local_2].bWear = 0;
                        return;
                    }
                    _local_2++;
                }
            }
        }

        public function equipItem(_arg_1:int):void
        {
            var _local_2:int;
            this.rootClass.world.afkPostpone();
            if (((!(this.items == null)) && (this.items.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    if (this.items[_local_2].ItemID == _arg_1)
                    {
                        if (this.items[_local_2].sType == "Item")
                        {
                            this.unequipItemAtType(this.items[_local_2].sType);
                        }
                        else
                        {
                            this.unequipItemAtES(this.items[_local_2].sES);
                        }
                        this.items[_local_2].bEquip = 1;
                        this.updateItemAnimation(this.items[_local_2].sMeta);
                        return;
                    }
                    _local_2++;
                }
            }
            if (((!(this.tempitems == null)) && (this.tempitems.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.tempitems.length)
                {
                    if (this.tempitems[_local_2].ItemID == _arg_1)
                    {
                        if (this.items[_local_2].sType == "Item")
                        {
                            this.unequipItemAtType(this.tempitems[_local_2].sType);
                        }
                        else
                        {
                            this.unequipItemAtES(this.tempitems[_local_2].sES);
                        }
                        this.tempitems[_local_2].bEquip = 1;
                        return;
                    }
                    _local_2++;
                }
            }
        }

        public function unequipItem(_arg_1:int):void
        {
            var _local_2:int;
            if (((!(this.items == null)) && (this.items.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.items.length)
                {
                    if (this.items[_local_2].ItemID == _arg_1)
                    {
                        this.items[_local_2].bEquip = 0;
                        this.removeItemAnimation(this.items[_local_2].sMeta);
                        return;
                    }
                    _local_2++;
                }
            }
            if (((!(this.tempitems == null)) && (this.tempitems.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this.tempitems.length)
                {
                    if (this.tempitems[_local_2].ItemID == _arg_1)
                    {
                        this.tempitems[_local_2].bEquip = 0;
                        return;
                    }
                    _local_2++;
                }
            }
        }

        public function calculateIntoBoosts():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            this.boosts = {
                "dmgall":[0, ""],
                "undead":[0, ""],
                "human":[0, ""],
                "chaos":[0, ""],
                "dragonkin":[0, ""],
                "orc":[0, ""],
                "drakath":[0, ""],
                "elemental":[0, ""],
                "cp":[0, ""],
                "gold":[0, ""],
                "rep":[0, ""],
                "exp":[0, ""]
            };
            for (_local_1 in this.objData.eqp)
            {
                if (_local_1 != "ar")
                {
                    if (this.objData.eqp[_local_1].sMeta != null)
                    {
                        _local_2 = this.objData.eqp[_local_1].sMeta.split(",");
                        if (_local_2.length >= 1)
                        {
                            _local_3 = 0;
                            while (_local_3 < _local_2.length)
                            {
                                _local_4 = _local_2[_local_3].split(":")[0].toLowerCase();
                                _local_5 = _local_2[_local_3].split(":")[1];
                                if (this.boosts.hasOwnProperty(_local_4))
                                {
                                    if (_local_5 > this.boosts[_local_4][0])
                                    {
                                        this.boosts[_local_4] = [_local_5, _local_1];
                                    }
                                }
                                _local_3++;
                            }
                        }
                    }
                }
            }
            if (this.rootClass.ui.getChildByName("mcStatsPanel"))
            {
                this.rootClass.ui.getChildByName("mcStatsPanel").updateBoosts();
                return;
            }
        }

        public function checkItemAnimation():void
        {
            var _local_1:uint;
            while (_local_1 < this.items.length)
            {
                if (this.items[_local_1].bEquip == 1)
                {
                    this.updateItemAnimation(this.items[_local_1].sMeta);
                }
                _local_1++;
            }
        }

        private function updateItemAnimation(_arg_1:String):void
        {
            var _local_5:Array;
            if (_arg_1 == null)
            {
                return;
            }
            if (((_arg_1.indexOf("anim") < 0) && (_arg_1.indexOf("proj") < 0)))
            {
                return;
            }
            var _local_2:* = "";
            var _local_3:Number = -1;
            var _local_4:Array = _arg_1.split(",");
            var _local_6:uint;
            while (_local_6 < _local_4.length)
            {
                _local_5 = _local_4[_local_6].split(":");
                if (_local_5[0] == "anim")
                {
                    _local_2 = _local_5[1];
                }
                else
                {
                    if (_local_5[0] == "chance")
                    {
                        _local_3 = Number(_local_5[1]);
                    }
                    if (_local_5[0] == "proj")
                    {
                        this.strProj = _local_5[1];
                    }
                }
                _local_6++;
            }
            if (((!(_local_2 == "")) && (_local_3 > 0)))
            {
                this.specialAnimation[_local_2] = _local_3;
            }
        }

        private function removeItemAnimation(_arg_1:String):*
        {
            var _local_2:String;
            if (_arg_1 == null)
            {
                return;
            }
            if (_arg_1.indexOf("proj") > -1)
            {
                this.strProj = "";
            }
            for (_local_2 in this.specialAnimation)
            {
                if (_arg_1.indexOf(_local_2) > -1)
                {
                    delete this.specialAnimation[_local_2];
                    return;
                }
            }
        }

        public function isItemEquipped(_arg_1:int):Boolean
        {
            var _local_2:* = this.getItemByID(_arg_1);
            if ((((_local_2 == null) || (_local_2.bEquip == null)) || (_local_2.bEquip == 0)))
            {
                return (false);
            }
            return (true);
        }

        public function getClassArmor(_arg_1:String):Object
        {
            var _local_2:int;
            while (_local_2 < this.items.length)
            {
                if ((((this.items[_local_2].bEquip == 1) && (this.items[_local_2].sName == _arg_1)) && (this.items[_local_2].sES == "ar")))
                {
                    return (this.items[_local_2]);
                }
                _local_2++;
            }
            return (null);
        }

        public function getEquippedItemBySlot(_arg_1:String):Object
        {
            var _local_2:int;
            while (_local_2 < this.items.length)
            {
                if (((this.items[_local_2].bEquip == 1) && (this.items[_local_2].sES == _arg_1)))
                {
                    return (this.items[_local_2]);
                }
                _local_2++;
            }
            return (null);
        }

        public function getItemByEquipSlot(_arg_1:String):Object
        {
            if ((((!(this.objData == null)) && (!(this.objData.eqp == null))) && (!(this.objData.eqp[_arg_1] == null))))
            {
                return (this.objData.eqp[_arg_1]);
            }
            return (null);
        }

        public function updateArmorRep():void
        {
            var _local_1:* = this.getEquippedItemBySlot("ar");
            _local_1.iQty = Number(this.objData.iCP);
        }

        public function getArmorRep(_arg_1:String=""):int
        {
            if (_arg_1 == "")
            {
                _arg_1 = this.objData.strClassName;
            }
            var _local_2:* = this.getEquippedItemBySlot("ar");
            if (_local_2 != null)
            {
                return (_local_2.iQty);
            }
            return (0);
        }

        public function getCPByID(_arg_1:int):int
        {
            var _local_2:* = this.getItemByID(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2.iQty);
            }
            return (-1);
        }

        public function updateRep():void
        {
            var _local_1:* = this.objData.iRank;
            var _local_2:* = this.objData.iCP;
            var _local_3:int = this.rootClass.getRankFromPoints(_local_2);
            var _local_4:int;
            var _local_5:* = this.rootClass.world;
            if (_local_3 < this.rootClass.iRankMax)
            {
                _local_4 = (this.rootClass.arrRanks[_local_3] - this.rootClass.arrRanks[(_local_3 - 1)]);
            }
            this.objData.iCurCP = (_local_2 - this.rootClass.arrRanks[(_local_3 - 1)]);
            this.objData.iRank = _local_3;
            this.objData.iCPToRank = _local_4;
            if (((this.isMyAvatar) && (!(_local_1 == _local_3))))
            {
                _local_5.updatePortrait(this);
            }
            if (this.isMyAvatar)
            {
                this.rootClass.updateRepBar();
            }
        }

        public function levelUp():void
        {
            this.healAnimation();
            var _local_1:* = this.pMC.addChild(new LevelUpDisplay());
            _local_1.t.ti.text = this.objData.intLevel;
            _local_1.x = this.pMC.mcChar.x;
            _local_1.y = (this.pMC.pname.y + 10);
            this.rootClass.FB_showFeedDialog("Level Up!", (("reached Level " + this.objData.intLevel) + " in AQWorlds!"), "aqw-levelup.jpg");
        }

        public function rankUp(_arg_1:String, _arg_2:int):void
        {
            this.healAnimation();
            var _local_3:* = this.pMC.addChild(new RankUpDisplay());
            _local_3.t.ti.text = ((_arg_1 + ", Rank ") + _arg_2);
            _local_3.x = this.pMC.mcChar.x;
            _local_3.y = (this.pMC.pname.y + 10);
        }

        public function healAnimation():void
        {
            this.rootClass.mixer.playSound("Heal");
            var _local_1:* = this.pMC.parent.addChild(new sp_eh1());
            _local_1.x = this.pMC.x;
            _local_1.y = this.pMC.y;
        }

        public function isUpgraded():Boolean
        {
            return (int(this.objData.iUpgDays) >= 0);
        }

        public function hasUpgraded():Boolean
        {
            return (int(this.objData.iUpg) > 0);
        }

        public function isVerified():Boolean
        {
            return (((this.objData.intAQ > 0) || (this.objData.intDF > 0)) || (this.objData.intMQ > 0));
        }

        public function isStaff():Boolean
        {
            return (this.objData.intAccessLevel >= 40);
        }

        public function isEmailVerified():Boolean
        {
            return (this.objData.intActivationFlag == 5);
        }

        public function updatePending(_arg_1:int):void
        {
            var _local_5:String;
            var _local_6:uint;
            if (this.objData.pending == null)
            {
                _local_5 = "";
                _local_6 = 0;
                while (_local_6 < 500)
                {
                    _local_5 = (_local_5 + String.fromCharCode(0));
                    _local_6++;
                }
                this.objData.pending = _local_5;
            }
            var _local_2:int = Math.floor((_arg_1 >> 3));
            var _local_3:int = (_arg_1 % 8);
            var _local_4:int = this.objData.pending.charCodeAt(_local_2);
            _local_4 = (_local_4 | (1 << _local_3));
            this.objData.pending = ((this.objData.pending.substr(0, _local_2) + String.fromCharCode(_local_4)) + this.objData.pending.substr((_local_2 + 1)));
        }

        public function updateScrolls(_arg_1:int):void
        {
            var _local_5:String;
            var _local_6:uint;
            if (this.objData.scrolls == null)
            {
                _local_5 = "";
                _local_6 = 0;
                while (_local_6 < 500)
                {
                    _local_5 = (_local_5 + String.fromCharCode(0));
                    _local_6++;
                }
                this.objData.scrolls = _local_5;
            }
            var _local_2:int = Math.floor((_arg_1 >> 3));
            var _local_3:int = (_arg_1 % 8);
            var _local_4:int = this.objData.scrolls.charCodeAt(_local_2);
            _local_4 = (_local_4 | (1 << _local_3));
            this.objData.scrolls = ((this.objData.scrolls.substr(0, _local_2) + String.fromCharCode(_local_4)) + this.objData.scrolls.substr((_local_2 + 1)));
        }

        public function handleItemAnimation():void
        {
            var _local_2:String;
            var _local_3:Class;
            var _local_4:MovieClip;
            var _local_1:Number = (Math.random() * 100);
            for (_local_2 in this.specialAnimation)
            {
                if (_local_1 < this.specialAnimation[_local_2])
                {
                    _local_3 = (this.rootClass.world.getClass(_local_2) as Class);
                    if (_local_3 != null)
                    {
                        _local_4 = (new (_local_3)() as MovieClip);
                        _local_4.x = this.pMC.x;
                        _local_4.y = this.pMC.y;
                        if (this.pMC.mcChar.scaleX < 0)
                        {
                            _local_4.scaleX = (_local_4.scaleX * -1);
                        }
                        this.rootClass.world.CHARS.addChild(_local_4);
                    }
                    return;
                }
            }
        }

        public function get FirstLoad():Boolean
        {
            return (this.firstLoad);
        }

        public function get LoadCount():int
        {
            return (this.loadCount);
        }

        public function updateLoaded():void
        {
            this.loadCount--;
        }

        public function firstDone():void
        {
            this.firstLoad = false;
        }

        public function get iBankCount():int
        {
            return (this.rootClass.world.bankinfo.Count);
        }

        public function set iBankCount(_arg_1:int):void
        {
            this.rootClass.world.bankinfo.Count = _arg_1;
        }


    }
}//package 

