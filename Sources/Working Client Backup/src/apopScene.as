// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//apopScene

package 
{
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.AntiAliasType;

    public class apopScene extends Sprite 
    {

        private const titleFormat:TextFormat = new TextFormat("Arial", 16, null, true);
        private const descFormat:TextFormat = new TextFormat("Arial", 12);
        private const questFormat:TextFormat = new TextFormat("Arial", 9, null, true);
        private const coinFormat:TextFormat = new TextFormat("Arial", 12, null, true);
        private const btnAccept:Object = {
            "intAction":9,
            "buttonText":"Begin Quest",
            "buttonID":-1,
            "strIcon":"iidesign"
        };
        private const btnTurnin:Object = {
            "intAction":11,
            "buttonText":"Turnin",
            "buttonID":-1,
            "strIcon":"iCheck"
        };
        private const btnAbandon:Object = {
            "intAction":12,
            "buttonText":"Abandon",
            "buttonID":-1,
            "strIcon":"iTrash",
            "width":148
        };
        private const btnBack:Object = {
            "intAction":10,
            "buttonText":"Back",
            "strIcon":"iArrow",
            "buttonID":-1
        };
        private const rewardTypes:Array = ["itemsS", "itemsC", "itemsR", "itemsrand"];

        public var mcBackground:MovieClip;
        public var bMask:MovieClip;
        public var bMask2:MovieClip;
        public var mcGold:MovieClip;
        public var tbBold:TextField;
        public var mcScene2:MovieClip;
        public var mcScene:MovieClip;
        private var rootClass:MovieClip;
        private var bQuest:Boolean;
        private var intBack:int = -1;
        private var qID:int;
        private var questTitle:String;
        private var parent_:apopCore;
        private var initialized:Boolean = false;
        public var accepted:Boolean = false;
        private var complete:Boolean = false;
        private var tbTitle:TextField;
        private var tbDesc:TextField;
        private var tbQuestO:TextField;
        private var tbReward:TextField;
        private var tbCoinExp:TextField;
        private var ID_:int = -1;
        private var curY:Number;
        private var btns:apopBtn;
        private var start_:Boolean = false;
        private var locked:Boolean = false;
        private var qData:Object;
        private var arrQuest:Array;
        private var arrBtns:Array;
        private var questBtns:Array = new Array();
        private var item:Object;

        public function apopScene(_arg_1:MovieClip, _arg_2:Object, _arg_3:apopCore)
        {
            var _local_4:Sprite;
            var _local_5:Object;
            var _local_6:uint;
            var _local_7:mcObjective;
            var _local_8:MovieClip;
            var _local_9:*;
            var _local_10:String;
            var _local_11:Class;
            var _local_12:MovieClip;
            var _local_13:MovieClip;
            super();
            if (_arg_2.sceneID != null)
            {
                this.rootClass = _arg_1;
                this.parent_ = _arg_3;
                this.bQuest = _arg_2.bType;
                if (_arg_2.arrQuests != null)
                {
                    this.arrQuest = String(_arg_2.arrQuests).split(",");
                };
                if (_arg_2.sBtns != null)
                {
                    this.arrBtns = _arg_2.sBtns;
                };
                this.tbBold.visible = false;
                this.bMask.visible = false;
                this.bMask2.visible = false;
                this.ID_ = _arg_2.sceneID;
                this.start_ = _arg_2.bStart;
                if (_arg_2.strLock != null)
                {
                    this.locked = this.decodeLock(_arg_2.strLock);
                };
                if (this.bQuest)
                {
                    this.qID = _arg_2.qID;
                    this.qData = this.rootClass.world.questTree[_arg_2.qID];
                    this.tbTitle = new TextField();
                    this.tbTitle.defaultTextFormat = this.titleFormat;
                    this.tbTitle.embedFonts = true;
                    this.tbTitle.antiAliasType = AntiAliasType.ADVANCED;
                    this.tbTitle.text = this.qData.sName;
                    this.questTitle = this.qData.sName;
                    this.tbTitle.width = 283;
                    this.tbTitle.mouseEnabled = false;
                    this.mcScene.addChild(this.tbTitle);
                    this.tbDesc = new TextField();
                    this.tbDesc.defaultTextFormat = this.descFormat;
                    this.tbDesc.embedFonts = true;
                    this.tbDesc.wordWrap = true;
                    this.tbDesc.multiline = true;
                    this.tbDesc.width = 283;
                    this.tbDesc.antiAliasType = AntiAliasType.ADVANCED;
                    this.tbDesc.text = this.qData.sDesc;
                    this.tbDesc.mouseEnabled = false;
                    this.tbDesc.y = 22;
                    this.mcScene.addChild(this.tbDesc);
                    this.tbDesc.height = (this.tbDesc.textHeight + 10);
                    this.curY = (this.tbDesc.y + this.tbDesc.height);
                    if (this.qData.turnin != null)
                    {
                        this.tbQuestO = new TextField();
                        this.tbQuestO.defaultTextFormat = this.questFormat;
                        this.tbQuestO.embedFonts = true;
                        this.tbQuestO.antiAliasType = AntiAliasType.ADVANCED;
                        this.tbQuestO.width = 283;
                        this.tbQuestO.text = "QUEST OBJECTIVES";
                        this.tbQuestO.mouseEnabled = false;
                        this.tbQuestO.y = this.curY;
                        this.mcScene.addChild(this.tbQuestO);
                        this.curY = (this.curY + 15);
                        _local_6 = 0;
                        while (_local_6 < this.qData.turnin.length)
                        {
                            _local_5 = this.rootClass.world.invTree[this.qData.turnin[_local_6].ItemID];
                            _local_7 = new mcObjective();
                            _local_7.x = 1;
                            _local_7.y = this.curY;
                            this.curY = (this.curY + 18.25);
                            _local_7.txtObjective.text = ((((_local_5.sName + " ") + _local_5.iQty) + "/") + this.qData.turnin[_local_6].iQty);
                            if (_local_5.iQty >= this.qData.turnin[_local_6].iQty)
                            {
                                _local_7.txtObjective.textColor = 2518295;
                            }
                            else
                            {
                                _local_7.txtObjective.textColor = 8198940;
                            };
                            this.mcScene.addChild(_local_7);
                            _local_6++;
                        };
                    };
                    this.curY = (this.curY + 7);
                    this.tbReward = new TextField();
                    this.tbReward.defaultTextFormat = this.questFormat;
                    this.tbReward.embedFonts = true;
                    this.tbReward.antiAliasType = AntiAliasType.ADVANCED;
                    this.tbReward.width = 283;
                    this.tbReward.text = "REWARDS";
                    this.tbReward.y = this.curY;
                    this.tbReward.mouseEnabled = false;
                    this.mcScene.addChild(this.tbReward);
                    this.curY = (this.curY + 17);
                    _local_4 = new iCoin();
                    _local_4.x = 2;
                    _local_4.y = this.curY;
                    _local_4.width = (_local_4.height = 17);
                    this.mcScene.addChild(_local_4);
                    this.tbCoinExp = new TextField();
                    this.tbCoinExp.defaultTextFormat = this.coinFormat;
                    this.tbCoinExp.embedFonts = true;
                    this.tbCoinExp.textColor = 0x4C4C4C;
                    this.tbCoinExp.antiAliasType = AntiAliasType.ADVANCED;
                    this.tbCoinExp.text = ("x" + this.qData.iGold);
                    this.tbCoinExp.x = 23;
                    this.tbCoinExp.y = this.curY;
                    this.tbCoinExp.mouseEnabled = false;
                    this.mcScene.addChild(this.tbCoinExp);
                    _local_4 = new iXP();
                    _local_4.x = 79;
                    _local_4.y = this.curY;
                    _local_4.width = 27;
                    _local_4.height = 18;
                    this.mcScene.addChild(_local_4);
                    this.tbCoinExp = new TextField();
                    this.tbCoinExp.defaultTextFormat = this.coinFormat;
                    this.tbCoinExp.embedFonts = true;
                    this.tbCoinExp.textColor = 0x4C4C4C;
                    this.tbCoinExp.antiAliasType = AntiAliasType.ADVANCED;
                    this.tbCoinExp.text = ("x" + this.qData.iExp);
                    this.tbCoinExp.x = (_local_4.x + 30);
                    this.tbCoinExp.y = this.curY;
                    this.tbCoinExp.mouseEnabled = false;
                    this.mcScene.addChild(this.tbCoinExp);
                    this.curY = (this.curY + 25);
                    if (this.qData.oRewards != null)
                    {
                        _local_6 = 0;
                        while (_local_6 < this.rewardTypes.length)
                        {
                            if (this.qData.oRewards[this.rewardTypes[_local_6]] != null)
                            {
                                this.tbCoinExp = new TextField();
                                this.tbCoinExp.defaultTextFormat = this.coinFormat;
                                this.tbCoinExp.embedFonts = true;
                                this.tbCoinExp.textColor = 0x4C4C4C;
                                this.tbCoinExp.antiAliasType = AntiAliasType.ADVANCED;
                                this.tbCoinExp.y = this.curY;
                                this.tbCoinExp.mouseEnabled = false;
                                switch (this.rewardTypes[_local_6])
                                {
                                    case "itemsS":
                                    default:
                                        this.tbCoinExp.text = "Items:";
                                        break;
                                    case "itemsC":
                                        this.tbCoinExp.text = "You may also choose one of:";
                                        break;
                                    case "itemsR":
                                        this.tbCoinExp.text = "You may also recieve, at random:";
                                        break;
                                    case "itemsrand":
                                        this.tbCoinExp.text = "You will recieve ONE OF THE FOLLOWING ITEMS:";
                                };
                                this.mcScene.addChild(this.tbCoinExp);
                                this.curY = (this.curY + 17);
                                for (_local_9 in this.qData.oRewards[this.rewardTypes[_local_6]])
                                {
                                    _local_8 = new mcItem();
                                    _local_8.y = this.curY;
                                    _local_5 = this.qData.oRewards[this.rewardTypes[_local_6]][_local_9];
                                    _local_8.txtName.text = _local_5.sName;
                                    _local_8.txtQty.text = ("X" + _local_5.iQty);
                                    this.mcScene.addChild(_local_8);
                                    _local_10 = "";
                                    if (_local_5.sType.toLowerCase() == "enhancement")
                                    {
                                        _local_10 = this.rootClass.getIconBySlot(_local_5.sES);
                                    }
                                    else
                                    {
                                        if ((((_local_5.sIcon == null) || (_local_5.sIcon == "")) || (_local_5.sIcon == "none")))
                                        {
                                            if (_local_5.sLink.toLowerCase() != "none")
                                            {
                                                _local_10 = "iidesign";
                                            }
                                            else
                                            {
                                                _local_10 = "iibag";
                                            };
                                        }
                                        else
                                        {
                                            _local_10 = _local_5.sIcon;
                                        };
                                    };
                                    try
                                    {
                                        _local_11 = (this.rootClass.world.getClass(_local_10) as Class);
                                        _local_12 = (_local_8.addChild(new (_local_11)()) as MovieClip);
                                        _local_12.scaleX = (_local_12.scaleY = 0.5);
                                    }
                                    catch(e:Error)
                                    {
                                    };
                                    this.curY = (this.curY + 33);
                                };
                            };
                            _local_6++;
                        };
                    };
                    this.curY = (this.curY + 20);
                    if (this.curY > 290)
                    {
                        _local_13 = (this.addChild(new sBar(this.mcScene, this.bMask, this.rootClass)) as MovieClip);
                        _local_13.x = 309;
                        _local_13.y = 25;
                        this.curY = 290;
                    };
                    this.mcBackground.height = this.curY;
                    this.mcBackground.height = ((this.mcBackground.height < 130) ? 130 : this.mcBackground.height);
                    this.curY = (this.mcBackground.height + 15);
                }
                else
                {
                    this.tbDesc = new TextField();
                    this.tbDesc.defaultTextFormat = this.descFormat;
                    this.tbDesc.embedFonts = true;
                    this.tbDesc.wordWrap = true;
                    this.tbDesc.multiline = true;
                    this.tbDesc.width = 283;
                    this.tbDesc.antiAliasType = AntiAliasType.ADVANCED;
                    this.tbDesc.text = _arg_2.strText;
                    this.tbDesc.mouseEnabled = false;
                    this.mcScene.addChild(this.tbDesc);
                    this.tbDesc.height = (this.tbDesc.textHeight + 10);
                    this.curY = (this.tbDesc.height + 15);
                    this.mcBackground.height = this.curY;
                    this.mcBackground.height = ((this.mcBackground.height < 130) ? 130 : this.mcBackground.height);
                    this.curY = (this.mcBackground.height + 15);
                    if (this.arrQuest != null)
                    {
                        this.tbTitle = new TextField();
                        this.tbTitle.defaultTextFormat = this.titleFormat;
                        this.tbTitle.embedFonts = true;
                        this.tbTitle.antiAliasType = AntiAliasType.ADVANCED;
                        this.tbTitle.text = "Quests";
                        this.tbTitle.width = 283;
                        this.tbTitle.y = this.tbDesc.height;
                        this.tbTitle.mouseEnabled = false;
                        this.mcScene.addChild(this.tbTitle);
                        this.curY = (this.tbTitle.y + 22);
                        this.mcBackground.height = this.curY;
                    };
                };
            };
        }

        private function decodeLock(strLock:String):Boolean
        {
            var lockData:Array;
            var qVal:int;
            var fct:Function;
            var lockTokens:Array = strLock.split(";");
            var bReturn:Boolean = true;
            var i:uint;
            while (i < lockTokens.length)
            {
                lockData = lockTokens[i].split(",");
                switch (lockData[0])
                {
                    case "map":
                        try
                        {
                            fct = this.rootClass.world.map[lockData[1]];
                            return (fct(this.ID_));
                        }
                        catch(e)
                        {
                            trace(("apop function call error: " + e));
                        };
                        break;
                    case "qs":
                        qVal = this.rootClass.world.getQuestValue(int(lockData[1]));
                        bReturn = ((bReturn) && (qVal >= int(lockData[2])));
                        break;
                    case "qsb":
                        qVal = this.rootClass.world.getQuestValue(int(lockData[1]));
                        bReturn = ((bReturn) && ((qVal >= int(lockData[2])) && (qVal < int(lockData[3]))));
                        break;
                    case "qip":
                        bReturn = ((bReturn) && (this.rootClass.world.isQuestInProgress(int(lockData[1]))));
                        break;
                    case "item":
                        bReturn = ((bReturn) && (this.rootClass.world.myAvatar.isItemInInventory(int(lockData[1]))));
                        break;
                };
                i++;
            };
            return (!(bReturn));
        }

        public function isQuestComplete():Boolean
        {
            var _local_1:Object;
            if (this.qData.turnin.length < 1)
            {
                return (true);
            };
            var _local_2:uint;
            while (_local_2 < this.qData.turnin.length)
            {
                _local_1 = this.rootClass.world.invTree[this.qData.turnin[_local_2].ItemID];
                if (_local_1.iQty < this.qData.turnin[_local_2].iQty)
                {
                    return (false);
                };
                _local_2++;
            };
            return (true);
        }

        public function isQuestAvailable():Boolean
        {
            if (this.qData != null)
            {
                if (((!(this.qData.bGuild == null)) && (this.qData.bGuild == 1)))
                {
                    if (this.rootClass.world.myAvatar.objData.guild == null)
                    {
                        return (false);
                    };
                    if (((this.qData.iReqRep > 0) && (this.rootClass.world.myAvatar.objData.guild.guildRep < this.qData.iReqRep)))
                    {
                        return (false);
                    };
                };
                if ((((((((!(this.qData.sField == null)) && (!(this.rootClass.world.getAchievement(this.qData.sField, this.qData.iIndex) == 0))) || (this.qData.iLvl > this.rootClass.world.myAvatar.objData.intLevel)) || ((this.qData.bUpg == 1) && (!(this.rootClass.world.myAvatar.isUpgraded())))) || ((this.qData.iSlot >= 0) && (this.rootClass.world.getQuestValue(this.qData.iSlot) < (Math.abs(this.qData.iValue) - 1)))) || ((this.qData.iClass > 0) && (this.rootClass.world.myAvatar.getCPByID(this.qData.iClass) < this.qData.iReqCP))) || ((this.qData.FactionID > 1) && (this.rootClass.world.myAvatar.getRep(this.qData.FactionID) < this.qData.iReqRep))))
                {
                    return (false);
                };
            }
            else
            {
                return (false);
            };
            return (true);
        }

        public function init(_arg_1:int=-1):void
        {
            var _local_2:Boolean;
            var _local_3:apopScene;
            var _local_4:uint;
            var _local_5:questBtn;
            var _local_6:uint;
            var _local_7:MovieClip;
            var _local_8:int;
            var _local_9:int;
            if (_arg_1 > -1)
            {
                this.intBack = _arg_1;
            };
            this.btnBack.width = 227;
            if (this.bQuest)
            {
                if (this.initialized)
                {
                    return;
                };
                this.accepted = this.rootClass.world.isQuestInProgress(this.qID);
                if (!this.accepted)
                {
                    this.btns = new apopBtn(this.rootClass, this.btnAccept, this);
                    this.btns.y = this.curY;
                    this.btns.x = 50;
                    this.addChild(this.btns);
                    this.curY = (this.curY + 37);
                    this.btns = new apopBtn(this.rootClass, this.btnBack, this);
                    this.btns.y = this.curY;
                    this.btns.x = 50;
                    this.addChild(this.btns);
                }
                else
                {
                    _local_2 = false;
                    if (this.isQuestComplete())
                    {
                        this.btns = new apopBtn(this.rootClass, this.btnTurnin, this);
                        this.btns.y = this.curY;
                        this.btns.x = 50;
                        this.addChild(this.btns);
                        this.btnBack.width = 148;
                        this.curY = (this.curY + 37);
                        this.btns = new apopBtn(this.rootClass, this.btnBack, this);
                        this.btns.y = this.curY;
                        this.btns.x = 10;
                        this.addChild(this.btns);
                        this.btns = new apopBtn(this.rootClass, this.btnAbandon, this);
                        this.btns.y = this.curY;
                        this.btns.x = 170;
                        this.addChild(this.btns);
                    }
                    else
                    {
                        this.btnBack.width = 148;
                        this.btns = new apopBtn(this.rootClass, this.btnBack, this);
                        this.btns.y = this.curY;
                        this.btns.x = 10;
                        this.addChild(this.btns);
                        this.btns = new apopBtn(this.rootClass, this.btnAbandon, this);
                        this.btns.y = this.curY;
                        this.btns.x = 170;
                        this.addChild(this.btns);
                    };
                };
                this.mcGold.height = (this.curY + 50);
            }
            else
            {
                if (this.arrQuest != null)
                {
                    if (this.initialized)
                    {
                        while (_local_4 < this.questBtns.length)
                        {
                            _local_3 = this.parent_.getQuestScene(("q" + String(this.questBtns[_local_4].ID)));
                            this.questBtns[_local_4].update(this.rootClass.world.isQuestInProgress(_local_3.QuestID), _local_3.isQuestAvailable(), _local_3.isQuestComplete());
                            _local_4++;
                        };
                    }
                    else
                    {
                        _local_6 = 0;
                        while (_local_6 < this.arrQuest.length)
                        {
                            _local_3 = this.parent_.getQuestScene(("q" + String(this.arrQuest[_local_6])));
                            _local_5 = new questBtn(this.parent_, {
                                "sceneID":_local_3.QuestID,
                                "strText":_local_3.QuestTitle,
                                "accepted":this.rootClass.world.isQuestInProgress(_local_3.QuestID),
                                "available":_local_3.isQuestAvailable(),
                                "complete":_local_3.isQuestComplete()
                            }, this.rootClass);
                            _local_5.x = 1;
                            _local_5.y = this.curY;
                            this.questBtns.push(_local_5);
                            this.mcScene.addChild(_local_5);
                            this.curY = (this.curY + 18.25);
                            _local_6++;
                        };
                        this.curY = (this.curY + 30);
                        if (this.curY > 290)
                        {
                            _local_7 = (this.addChild(new sBar(this.mcScene, this.bMask, this.rootClass)) as MovieClip);
                            _local_7.x = 309;
                            _local_7.y = 25;
                            this.curY = 290;
                        };
                        this.mcBackground.height = this.curY;
                        this.mcBackground.height = ((this.mcBackground.height < 130) ? 130 : this.mcBackground.height);
                        this.curY = (this.mcBackground.height + 30);
                        this.btns = new apopBtn(this.rootClass, this.btnBack, this);
                        this.btns.y = this.curY;
                        this.btns.x = 50;
                        this.addChild(this.btns);
                        this.curY = (this.curY + 30);
                    };
                }
                else
                {
                    if (this.arrBtns != null)
                    {
                        if (this.initialized)
                        {
                            return;
                        };
                        if (!this.start_)
                        {
                            this.arrBtns.push(this.btnBack);
                        };
                        _local_8 = this.arrBtns.length;
                        _local_9 = 10;
                        _local_9 = 0;
                        this.mcScene2.y = this.curY;
                        this.bMask2.y = this.curY;
                        _local_6 = 0;
                        while (_local_6 < _local_8)
                        {
                            this.btns = new apopBtn(this.rootClass, this.arrBtns[_local_6], this);
                            this.btns.y = _local_9;
                            this.curY = (this.curY + 37);
                            _local_9 = (_local_9 + 37);
                            this.mcScene2.addChild(this.btns);
                            _local_6++;
                        };
                        if (this.curY > 360)
                        {
                            this.curY = 360;
                            this.bMask2.height = (360 - this.bMask2.y);
                            _local_7 = (this.addChild(new sBar(this.mcScene2, this.bMask2, this.rootClass)) as MovieClip);
                            _local_7.x = 309;
                            _local_7.y = (this.mcScene2.y + 5);
                        };
                    }
                    else
                    {
                        if (((!(this.start_)) && (!(this.initialized))))
                        {
                            this.btns = new apopBtn(this.rootClass, this.btnBack, this);
                            this.btns.y = this.curY;
                            this.btns.x = 40;
                            this.addChild(this.btns);
                            this.curY = (this.curY + 30);
                        };
                    };
                };
                this.mcGold.height = (this.curY + 20);
            };
            this.initialized = true;
        }

        public function Back():void
        {
            this.parent_.showScene(this.intBack, true);
        }

        public function get ID():int
        {
            return (this.ID_);
        }

        public function get QuestID():int
        {
            return (this.qID);
        }

        public function get Start():Boolean
        {
            return (this.start_);
        }

        public function get Locked():Boolean
        {
            return (this.locked);
        }

        public function get Quest():Boolean
        {
            return (this.bQuest);
        }

        public function get QuestTitle():String
        {
            return (this.questTitle);
        }

        public function get Parent():apopCore
        {
            return (this.parent_);
        }


    }
}//package 

