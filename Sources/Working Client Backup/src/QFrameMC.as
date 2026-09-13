// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//QFrameMC

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.display.DisplayObject;
    import flash.text.TextFormat;
    import liteAssets.draw.detailedCheck;
    import liteAssets.draw.qRewardPrev;
    import flash.net.*;
    import flash.text.*;

    public class QFrameMC extends MovieClip 
    {

        public var cnt:MovieClip;
        public var world:MovieClip;
        public var rootClass:MovieClip;
        public var qData:Object = null;
        internal var qMode:String = null;
        internal var choiceID:int = -1;
        internal var isOpen:Boolean = false;
        internal var mc:MovieClip;
        internal var mDown:Boolean = false;
        internal var hRun:int = 0;
        internal var dRun:int = 0;
        internal var mbY:int = 0;
        internal var mhY:int = 0;
        internal var mbD:int = 0;
        internal var qly:int = 70;
        internal var qdy:int = 58;
        internal var qla:Array = [];
        internal var qlb:Array = [];
        public var qIDs:Array = [];
        public var sIDs:Array = [];
        public var tIDs:Array = [];
        internal var rewardCount:int = -1;

        public function QFrameMC():void
        {
            addFrameScript(6, frame7, 11, frame12, 15, frame16);
            mc = MovieClip(this);
            mc.x = 0;
            mc.y = 65;
            mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK, xClick);
            mc.cnt.bg.btnTry.visible = false;
            mc.cnt.bg.btnPin.visible = false;
            mc.cnt.bg.btnWiki.visible = false;
        }

        public function onPin(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            rootClass.pinnedQuests = "";
            if (!_arg_1.shiftKey)
            {
                for each (_local_2 in qIDs)
                {
                    rootClass.pinnedQuests = (rootClass.pinnedQuests + (_local_2 + ","));
                }
            }
        }

        public function open():*
        {
            rootClass = MovieClip(this.stage.getChildAt(0));
            mc.cnt.bg.btnPin.addEventListener(MouseEvent.CLICK, onPin, false, 0, true);
            mc.cnt.bg.btnWiki.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            world = rootClass.world;
            mc = MovieClip(this);
            mc.cnt.bg.fx.visible = false;
            if (rootClass.isDialoqueUp())
            {
                mc.cnt.bg.fx.visible = true;
            }
            if (!isOpen)
            {
                isOpen = true;
                mc.cnt.gotoAndPlay("intro");
            }
            else
            {
                isOpen = false;
                fClose();
            }
        }

        public function onWiki(_arg_1:MouseEvent):void
        {
            if (!qData)
            {
                return;
            }
            navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
        }

        public function showQuestList():*
        {
            var _local_1:int;
            var _local_2:int;
            mc.cnt.bg.btnPin.visible = rootClass.litePreference.data.bQuestPin;
            mc.cnt.bg.btnWiki.visible = false;
            if ((((qMode == "l") && (!(world.getActiveQuests() == ""))) || (qMode == "q")))
            {
                if (qMode == "l")
                {
                    qIDs = world.getActiveQuests().split(",");
                }
                else
                {
                    qIDs = new Array();
                    _local_1 = 0;
                    while (_local_1 < sIDs.length)
                    {
                        qIDs.push(sIDs[_local_1]);
                        _local_1++;
                    }
                    _local_2 = 0;
                    while (_local_2 < tIDs.length)
                    {
                        if (((world.isQuestInProgress(tIDs[_local_2])) && (qIDs.indexOf(tIDs[_local_2]) == -1)))
                        {
                            qIDs.push(tIDs[_local_2]);
                        }
                        _local_2++;
                    }
                }
                world.checkAllQuestStatus();
                buildQuestList();
            }
            else
            {
                showEmptyList();
            }
            if (mc.cnt.bg.btnPin.visible)
            {
                mc.cnt.strTitle.x = 53;
                mc.cnt.strTitle.width = 0x0100;
            }
            else
            {
                mc.cnt.strTitle.x = 42;
                mc.cnt.strTitle.width = 270;
            }
            if (qMode == "l")
            {
                mc.cnt.strTitle.htmlText = 'Current Quests<font color="#FF0000">:</font>';
            }
            if (qMode == "q")
            {
                mc.cnt.strTitle.htmlText = 'Available Quests<font color="#FF0000">:</font>';
            }
            mc.cnt.qList.visible = true;
            mc.cnt.qList.mHi.visible = false;
            mc.cnt.mouseChildren = true;
        }

        private function isQuestAvailable(_arg_1:Object):Boolean
        {
            if (_arg_1 != null)
            {
                if (((!(_arg_1.bGuild == null)) && (_arg_1.bGuild == 1)))
                {
                    if (rootClass.world.myAvatar.objData.guild == null)
                    {
                        return (false);
                    }
                    if (((_arg_1.iReqRep > 0) && (rootClass.world.myAvatar.objData.guild.guildRep < _arg_1.iReqRep)))
                    {
                        return (false);
                    }
                }
                if ((((((((!(_arg_1.sField == null)) && (!(world.getAchievement(_arg_1.sField, _arg_1.iIndex) == 0))) || (_arg_1.iLvl > world.myAvatar.objData.intLevel)) || ((_arg_1.bUpg == 1) && (!(world.myAvatar.isUpgraded())))) || ((_arg_1.iSlot >= 0) && (world.getQuestValue(_arg_1.iSlot) < (Math.abs(_arg_1.iValue) - 1)))) || ((_arg_1.iClass > 0) && (world.myAvatar.getCPByID(_arg_1.iClass) < _arg_1.iReqCP))) || ((_arg_1.FactionID > 1) && (world.myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep))))
                {
                    return (false);
                }
                if (((_arg_1.QuestID == 3190) && (!(world.myAvatar.isUpgraded()))))
                {
                    if (world.getQuestValue(43) < 3)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(21) < 26)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(22) < 35)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(25) < 22)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(26) < 23)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(27) < 14)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(32) < 35)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(36) < 28)
                    {
                        return (false);
                    }
                    if (((world.getQuestValue(51) < 34) && (world.getQuestValue(52) < 34)))
                    {
                        return (false);
                    }
                    if (world.getQuestValue(100) < 15)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(117) < 17)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(131) < 27)
                    {
                        return (false);
                    }
                    if (world.getQuestValue(122) < 35)
                    {
                        return (false);
                    }
                }
                return (true);
            }
            return (false);
        }

        private function getQuestListA():void
        {
            var _local_2:*;
            qla = [];
            var _local_1:int;
            while (_local_1 < qIDs.length)
            {
                _local_2 = world.questTree[qIDs[_local_1]];
                qla.push(isQuestAvailable(_local_2));
                _local_1++;
            }
        }

        private function getQuestListB():void
        {
            var _local_2:*;
            qlb = [];
            var _local_1:int;
            while (_local_1 < qIDs.length)
            {
                _local_2 = world.questTree[qIDs[_local_1]];
                qlb.push(isQuestAvailable(_local_2));
                _local_1++;
            }
        }

        private function nextQuestAvailable():Object
        {
            var _local_1:Object;
            var _local_2:int;
            while (_local_2 < qIDs.length)
            {
                if (((qla[_local_2] == false) && (qlb[_local_2] == true)))
                {
                    _local_1 = world.questTree[qIDs[_local_2]];
                }
                _local_2++;
            }
            return (_local_1);
        }

        private function hasRequiredItemsForQuest(_arg_1:Object):Boolean
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:int;
            if (((!(_arg_1.reqd == null)) && (_arg_1.reqd.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < _arg_1.reqd.length)
                {
                    _local_3 = _arg_1.reqd[_local_2].ItemID;
                    _local_4 = int(_arg_1.reqd[_local_2].iQty);
                    if (((rootClass.world.invTree[_local_3] == null) || (int(rootClass.world.invTree[_local_3].iQty) < _local_4)))
                    {
                        return (false);
                    }
                    _local_2++;
                }
            }
            return (true);
        }

        private function getQuestValidationString(_arg_1:Object):String
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:int;
            var _local_5:*;
            var _local_6:String;
            var _local_7:int;
            var _local_8:Object;
            var _local_9:int;
            var _local_10:int;
            var _local_11:*;
            if (((!(_arg_1.sField == null)) && (!(world.getAchievement(_arg_1.sField, _arg_1.iIndex) == 0))))
            {
                if (_arg_1.sField == "im0")
                {
                    return ("Monthly Quests are only available once per month.");
                }
                if (_arg_1.sField == "iw0")
                {
                    return ("Weekly Quests reset every Friday morning.");
                }
                return ("Daily Quests are only available once per day.");
            }
            if (((_arg_1.bUpg == 1) && (!(world.myAvatar.isUpgraded()))))
            {
                return ("Upgrade is required for this quest!");
            }
            if (((_arg_1.iSlot >= 0) && (world.getQuestValue(_arg_1.iSlot) < (_arg_1.iValue - 1))))
            {
                return ("Quest has not been unlocked!");
            }
            if (_arg_1.iLvl > world.myAvatar.objData.intLevel)
            {
                return (("Unlocks at Level " + _arg_1.iLvl) + ".");
            }
            if (((_arg_1.iClass > 0) && (world.myAvatar.getCPByID(_arg_1.iClass) < _arg_1.iReqCP)))
            {
                _local_2 = rootClass.getRankFromPoints(_arg_1.iReqCP);
                _local_3 = (_arg_1.iReqCP - rootClass.arrRanks[(_local_2 - 1)]);
                if (_local_3 > 0)
                {
                    return (((((("Requires " + _local_3) + " Class Points on ") + _arg_1.sClass) + ", Rank ") + _local_2) + ".");
                }
                return ((((("Requires " + ((rootClass.litePreference.data.bDebugger) ? (("(" + _arg_1.iClass) + ") ") : "")) + _arg_1.sClass) + ", Rank ") + _local_2) + ".");
            }
            if (((_arg_1.FactionID > 1) && (world.myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep)))
            {
                _local_4 = rootClass.getRankFromPoints(_arg_1.iReqRep);
                _local_5 = (_arg_1.iReqRep - rootClass.arrRanks[(_local_4 - 1)]);
                if (_local_5 > 0)
                {
                    return (((((("Requires " + _local_5) + " Reputation for ") + _arg_1.sFaction) + ", Rank ") + _local_4) + ".");
                }
                return (((("Requires " + _arg_1.sFaction) + ", Rank ") + _local_4) + ".");
            }
            if (((!(_arg_1.reqd == null)) && (!(hasRequiredItemsForQuest(_arg_1)))))
            {
                _local_6 = "Required Item(s): ";
                _local_7 = 0;
                while (_local_7 < _arg_1.reqd.length)
                {
                    _local_8 = world.invTree[_arg_1.reqd[_local_7].ItemID];
                    _local_9 = _arg_1.reqd[_local_7].iQty;
                    if (_local_8.sES == "ar")
                    {
                        _local_10 = rootClass.getRankFromPoints(_local_9);
                        _local_11 = (_local_9 - rootClass.arrRanks[(_local_10 - 1)]);
                        if (_local_11 > 0)
                        {
                            _local_6 = (_local_6 + (_local_11 + " Class Points on "));
                        }
                        if (rootClass.litePreference.data.bDebugger)
                        {
                            _local_6 = (_local_6 + (("(" + _arg_1.reqd[_local_7].ItemID) + ")"));
                        }
                        _local_6 = (_local_6 + ((_local_8.sName + ", Rank ") + _local_10));
                    }
                    else
                    {
                        if (rootClass.litePreference.data.bDebugger)
                        {
                            _local_6 = (_local_6 + (("(" + _arg_1.reqd[_local_7].ItemID) + ")"));
                        }
                        _local_6 = (_local_6 + _local_8.sName);
                        if (_local_9 > 1)
                        {
                            _local_6 = (_local_6 + ("x" + _local_9));
                        }
                    }
                    _local_6 = (_local_6 + ", ");
                    _local_7++;
                }
                _local_6 = (_local_6.substr(0, (_local_6.length - 2)) + ".");
                return (_local_6);
            }
            return ("");
        }

        private function isOneTimeQuestDone(_arg_1:*):Boolean
        {
            return ((_arg_1.bOnce == 1) && ((_arg_1.iSlot < 0) || (world.getQuestValue(_arg_1.iSlot) >= _arg_1.iValue)));
        }

        private function buildQuestList():*
        {
            var _local_5:*;
            var _local_6:*;
            var _local_7:String;
            var _local_1:* = 0;
            while (_local_1 < qIDs.length)
            {
                _local_5 = world.questTree[qIDs[_local_1]];
                if (((!(_local_5 == null)) && (!(isOneTimeQuestDone(_local_5)))))
                {
                    _local_6 = mc.cnt.qList.addChild(new qProto());
                    _local_7 = ((rootClass.litePreference.data.bDebugger) ? (("(" + _local_5.QuestID) + ")") : "");
                    if (isQuestAvailable(_local_5))
                    {
                        _local_6.ti.htmlText = ((("<font color='#009900'><b>" + _local_7) + _local_5.sName) + "</b></font>");
                    }
                    else
                    {
                        _local_6.ti.htmlText = ((("<font color='#990000'><b>" + _local_7) + _local_5.sName) + "</b></font>");
                    }
                    _local_6.addEventListener(MouseEvent.CLICK, qListClick);
                    _local_6.QuestID = _local_5.QuestID;
                    if (_local_5.sTyp != null)
                    {
                        _local_6.ti.htmlText = (_local_6.ti.htmlText + ((' <font color="#888888">' + _local_5.sTyp) + "</font>"));
                    }
                    if (_local_5.status != null)
                    {
                        switch (_local_5.status)
                        {
                            case "p":
                                _local_6.ti.htmlText = (_local_6.ti.htmlText + "<font color='#888888'> - In progress</font>");
                                break;
                            case "c":
                                _local_6.ti.htmlText = (_local_6.ti.htmlText + "<font color='#99FF00'> - <b>Complete!</b></font>");
                                break;
                        }
                    }
                    _local_6.addEventListener(MouseEvent.MOUSE_OVER, iMouseOver, false, 0, true);
                    _local_6.addEventListener(MouseEvent.MOUSE_OUT, iMouseOut, false, 0, true);
                    _local_6.buttonMode = true;
                    _local_6.hit.alpha = 0;
                    _local_6.y = (_local_1 * 20);
                    _local_6.x = 10;
                }
                _local_1++;
            }
            var _local_2:* = mc.cnt.scr;
            var _local_3:* = mc.cnt.bMask;
            var _local_4:* = mc.cnt.qList;
            _local_2.h.height = int(((_local_2.b.height / _local_4.height) * _local_2.b.height));
            hRun = (_local_2.b.height - _local_2.h.height);
            dRun = ((_local_4.height - _local_2.b.height) + 20);
            _local_2.h.y = 0;
            _local_4.oy = (_local_4.y = qly);
            _local_2.visible = false;
            _local_2.hit.alpha = 0;
            mDown = false;
            if (_local_4.height > _local_2.b.height)
            {
                _local_2.visible = true;
                _local_2.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                _local_2.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                _local_4.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            }
            mc.cnt.qList.iproto.visible = false;
        }

        private function qListClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            qData = world.questTree[_local_2.QuestID];
            _local_2.removeEventListener(MouseEvent.CLICK, qListClick);
            _local_2.removeEventListener(MouseEvent.MOUSE_OVER, iMouseOver);
            _local_2.removeEventListener(MouseEvent.MOUSE_OUT, iMouseOut);
            mc.cnt.gotoAndPlay("out");
            if (mc.cnt.qList.hasEventListener(Event.ENTER_FRAME))
            {
                mc.cnt.qList.removeEventListener(Event.ENTER_FRAME, dEF);
            }
            mc.cnt.qList.mouseEnabled = false;
            mc.cnt.qList.mouseChildren = false;
        }

        private function showEmptyList():*
        {
            var _local_1:* = mc.cnt.qList.addChild(new qProto());
            _local_1.ti.htmlText = "<font color=\"#DDDDDD\">You aren't on any quests!</font>";
            _local_1.hit.alpha = 0;
            _local_1.x = 10;
            mc.cnt.qList.iproto.visible = false;
            mc.cnt.scr.visible = false;
        }

        private function isOwned(_arg_1:Boolean, _arg_2:*):Boolean
        {
            var _local_3:*;
            for each (_local_3 in ((_arg_1) ? rootClass.world.myAvatar.houseitems : rootClass.world.myAvatar.items))
            {
                if (_local_3.ItemID == _arg_2)
                {
                    return (true);
                }
            }
            if (rootClass.world.bankinfo.isItemInBank(_arg_2))
            {
                return (true);
            }
            return (false);
        }

        public function getCount(_arg_1:String):int
        {
            var _local_2:*;
            if (rewardCount != -1)
            {
                return (rewardCount);
            }
            rewardCount = 0;
            for (_local_2 in qData.oRewards[_arg_1])
            {
                rewardCount++;
            }
            return (rewardCount);
        }

        public function showQuestDetail():*
        {
            var _local_2:String;
            var _local_3:Object;
            var _local_4:Object;
            var _local_10:*;
            var _local_11:*;
            var _local_12:*;
            var _local_13:String;
            var _local_14:*;
            var _local_15:*;
            var _local_16:*;
            var _local_17:Class;
            var _local_18:MovieClip;
            var _local_19:GlowFilter;
            var _local_20:Array;
            var _local_21:String;
            var _local_22:Object;
            var _local_23:MovieClip;
            var _local_24:Object;
            var _local_25:int;
            var _local_26:int;
            var _local_27:String;
            var _local_28:String;
            var _local_29:String;
            var _local_30:Object;
            var _local_31:Object;
            var _local_32:Object;
            var _local_33:Class;
            var _local_34:DisplayObject;
            var _local_35:*;
            var _local_36:TextFormat;
            var _local_37:*;
            mc.cnt.bg.btnPin.visible = false;
            mc.cnt.bg.btnWiki.visible = true;
            if (mc.cnt.bg.btnWiki.visible)
            {
                mc.cnt.strTitle.x = 53;
                mc.cnt.strTitle.width = 0x0100;
            }
            else
            {
                mc.cnt.strTitle.x = 42;
                mc.cnt.strTitle.width = 270;
            }
            var _local_1:int;
            choiceID = -1;
            world.checkAllQuestStatus();
            mc.cnt.mouseChildren = true;
            mc.cnt.strTitle.text = qData.sName;
            var _local_5:* = mc.cnt.core;
            _local_5.strNote.autoSize = "left";
            _local_5.strNote.text = getQuestValidationString(qData);
            _local_5.strDesc.mouseWheelEnabled = false;
            _local_5.strReq.mouseWheelEnabled = false;
            _local_5.rewards.strRew.mouseWheelEnabled = false;
            _local_5.strDesc.autoSize = "left";
            _local_5.strReq.autoSize = "left";
            _local_5.rewards.strRew.autoSize = "left";
            if ((((qData.status == "c") && (tIDs.indexOf(String(qData.QuestID)) >= 0)) && (!(qData.sEndText == ""))))
            {
                _local_5.strDesc.text = qData.sEndText;
            }
            else
            {
                _local_5.strDesc.text = qData.sDesc;
            }
            _local_5.strReq.htmlText = "";
            if (((!(qData.turnin == null)) && (qData.turnin.length > 0)))
            {
                _local_13 = "";
                _local_1 = 0;
                while (_local_1 < qData.turnin.length)
                {
                    _local_14 = world.invTree[qData.turnin[_local_1].ItemID];
                    _local_15 = qData.oItems[qData.turnin[_local_1].ItemID].sName;
                    if (rootClass.litePreference.data.bDebugger)
                    {
                        _local_15 = ((("(" + qData.turnin[_local_1].ItemID) + ") ") + _local_15);
                    }
                    _local_16 = int(qData.turnin[_local_1].iQty);
                    if (_local_1 > 0)
                    {
                        _local_13 = (_local_13 + ",<br>");
                    }
                    if (_local_14.iQty < _local_16)
                    {
                        _local_13 = (_local_13 + ((((_local_15 + ' <font color="#888888">') + _local_14.iQty) + "/</font>") + _local_16));
                    }
                    else
                    {
                        _local_13 = (_local_13 + (((((('<font color="#888888">' + _local_15) + " ") + _local_14.iQty) + "/") + _local_16) + "</font>"));
                    }
                    _local_1++;
                }
                _local_5.strReq.htmlText = _local_13;
            }
            var _local_6:String = (qData.iGold + '<font color="#FFCC00"> gold</font><br>');
            _local_6 = (_local_6 + (qData.iCoins + '<font color="#FF9900"> ac</font><br>'));
            _local_6 = (_local_6 + (qData.iExp + '<font color="#FF00FF"> xp</font>'));
            if (((qData.hasOwnProperty("metaValues")) && (qData.metaValues.hasOwnProperty("freeac"))))
            {
                _local_6 = (_local_6 + (("<br>" + qData.metaValues.freeac) + '<font color="#FFCC00"> ac</font>'));
            }
            if (((qData.FactionID > 1) && (qData.iRep > 0)))
            {
                _local_6 = (_local_6 + (((("<br>" + qData.iRep) + " <font color='#00FF66'>rep : ") + qData.sFaction) + "</font>"));
            }
            _local_5.rewards.strRew.htmlText = _local_6;
            if (_local_5.strNote.text == "")
            {
                _local_5.descTitle.y = 0;
            }
            else
            {
                _local_5.descTitle.y = ((_local_5.strNote.y + _local_5.strNote.textHeight) + 10);
            }
            _local_5.strDesc.y = (_local_5.descTitle.y + 15);
            _local_5.reqTitle.y = Math.round(((_local_5.strDesc.y + _local_5.strDesc.textHeight) + 10));
            _local_5.strReq.y = (_local_5.reqTitle.y + 15);
            _local_5.rewards.y = Math.round(((_local_5.strReq.y + _local_5.strReq.textHeight) + 10));
            var _local_7:Number = ((_local_5.rewards.y + _local_5.rewards.height) + 15);
            if (qData.oRewards != null)
            {
                _local_17 = world.getClass("DFrameMCcnt");
                _local_20 = ["itemsS", "itemsC", "itemsR", "itemsrand"];
                _local_1 = 0;
                while (_local_1 < _local_20.length)
                {
                    _local_21 = _local_20[_local_1];
                    switch (_local_21)
                    {
                        case "itemsS":
                        default:
                            _local_23 = _local_5.rewardsStatic;
                            break;
                        case "itemsC":
                            _local_23 = _local_5.rewardsChoice;
                            break;
                        case "itemsR":
                            _local_23 = _local_5.rewardsRoll;
                            break;
                        case "itemsrand":
                            _local_23 = _local_5.rewardsRandom;
                    }
                    if (qData.oRewards[_local_21] == null)
                    {
                        _local_23.visible = false;
                    }
                    else
                    {
                        _local_22 = qData.oRewards[_local_21];
                        _local_26 = 16;
                        for (_local_2 in _local_22)
                        {
                            _local_24 = _local_22[_local_2];
                            _local_25 = _local_24.iQty;
                            _local_18 = (_local_23.addChild(new (_local_17)()) as MovieClip);
                            _local_18.ItemID = _local_24.ItemID;
                            _local_18.strName.autoSize = "left";
                            _local_27 = ((rootClass.litePreference.data.bDebugger) ? (("(" + _local_24.ItemID) + ")") : "");
                            _local_18.strName.text = (_local_27 + _local_24.sName);
                            _local_18.strName.width = (_local_18.strName.textWidth + 6);
                            _local_28 = "100";
                            if (_local_21 != "itemsrand")
                            {
                                for each (_local_32 in qData.reward)
                                {
                                    if (((_local_32.ItemID == _local_18.ItemID) && (_local_32.iQty == _local_25)))
                                    {
                                        _local_28 = _local_32.iRate;
                                    }
                                }
                            }
                            if (_local_21 == "itemsrand")
                            {
                                _local_28 = Number((Number(_local_28) / getCount(_local_21))).toFixed(2).toString();
                            }
                            _local_18.strType.text = ((_local_28) ? (((_local_24.sType + " (") + _local_28) + "%)") : _local_24.sType);
                            _local_18.strType.width = 100;
                            _local_18.strRate.visible = false;
                            _local_18.bg.width = (int(_local_18.strName.textWidth) + 75);
                            if (_local_18.bg.width < 175)
                            {
                                _local_18.bg.width = 175;
                            }
                            _local_18.fx1.width = _local_18.bg.width;
                            if (_local_25 > 1)
                            {
                                _local_18.strQ.text = ("x" + _local_25);
                                _local_18.strQ.x = ((_local_18.bg.width - _local_18.strQ.width) - 7);
                                _local_18.strQ.visible = true;
                            }
                            else
                            {
                                _local_18.strQ.x = 0;
                                _local_18.strQ.visible = false;
                            }
                            _local_19 = new GlowFilter(world.rarityCA[_local_24.iRty], 1, 8, 8, 2, 1, false, false);
                            _local_18.bg.filters = [_local_19];
                            rootClass.onRemoveChildrens(_local_18.icon);
                            _local_29 = "";
                            if (_local_24.sType.toLowerCase() == "enhancement")
                            {
                                _local_29 = rootClass.getIconBySlot(_local_24.sES);
                            }
                            else
                            {
                                if ((((_local_24.sIcon == null) || (_local_24.sIcon == "")) || (_local_24.sIcon == "none")))
                                {
                                    if (_local_24.sLink.toLowerCase() != "none")
                                    {
                                        _local_29 = "iidesign";
                                    }
                                    else
                                    {
                                        _local_29 = "iibag";
                                    }
                                }
                                else
                                {
                                    _local_29 = _local_24.sIcon;
                                }
                            }
                            try
                            {
                                _local_33 = (world.getClass(_local_29) as Class);
                                _local_34 = _local_18.icon.addChild(new (_local_33)());
                                _local_34.scaleX = (_local_34.scaleY = 0.5);
                                _local_19 = new GlowFilter(world.rarityCA[_local_24.iRty], 1, 8, 8, 2, 1, false, false);
                                _local_18.icon.filters = [_local_19];
                                if (isOwned(_local_24.bHouse, _local_24.ItemID))
                                {
                                    _local_35 = _local_18.icon.addChild(new detailedCheck());
                                    _local_35.width = _local_18.icon.width;
                                    _local_35.height = _local_18.icon.height;
                                }
                            }
                            catch(e:Error)
                            {
                            }
                            _local_18.y = _local_26;
                            _local_26 = (_local_26 + Math.round((_local_18.height + 8)));
                            if ((((((_local_21 == "itemsC") && (!(qMode == "l"))) && (!(qData.status == null))) && (qData.status == "c")) && (tIDs.indexOf(String(qData.QuestID)) >= 0)))
                            {
                                _local_18.mouseEnabled = true;
                                _local_18.mouseChildren = false;
                                _local_18.buttonMode = true;
                                _local_18.addEventListener(MouseEvent.CLICK, btnRewardClick, false, 0, true);
                            }
                            if (_local_24.bCoins != 1)
                            {
                                _local_18.fadedAC.visible = false;
                            }
                            else
                            {
                                _local_18.fadedAC.x = (_local_18.bg.width - 72);
                            }
                            if (_local_24.bUpg)
                            {
                                _local_36 = _local_18.strName.defaultTextFormat;
                                _local_36.color = 16566089;
                                _local_18.strName.setTextFormat(_local_36);
                                _local_36 = _local_18.strQ.defaultTextFormat;
                                _local_36.color = 16566089;
                                _local_18.strQ.setTextFormat(_local_36);
                            }
                            for each (_local_31 in qData.oRewards)
                            {
                                for each (_local_32 in _local_31)
                                {
                                    if (_local_32.ItemID == _local_18.ItemID)
                                    {
                                        _local_30 = _local_32;
                                    }
                                }
                            }
                            if (!_local_18.hasEventListener(MouseEvent.CLICK))
                            {
                                _local_18.addEventListener(MouseEvent.CLICK, onRewardPreview, false, 0, true);
                            }
                        }
                    }
                    if (_local_23.visible)
                    {
                        _local_23.y = _local_7;
                        _local_7 = ((_local_23.y + _local_23.height) + 15);
                    }
                    _local_1++;
                }
            }
            rewardCount = -1;
            var _local_8:* = null;
            var _local_9:* = {};
            if (qMode != "l")
            {
                if (qData.status == null)
                {
                    _local_8 = mc.cnt.btns.dual;
                    mc.cnt.btns.tri.visible = false;
                    _local_9 = {
                        "b1":{
                            "txt":"Accept",
                            "fn":btnAccept
                        },
                        "b2":{
                            "txt":"Decline",
                            "fn":btnBack
                        }
                    };
                }
                else
                {
                    if (((qData.status == "c") && (tIDs.indexOf(String(qData.QuestID)) >= 0)))
                    {
                        _local_8 = mc.cnt.btns.tri;
                        mc.cnt.btns.dual.visible = false;
                        _local_9 = {
                            "b1":{
                                "txt":"Back",
                                "fn":btnBack
                            },
                            "b2":{
                                "txt":"Turn in!",
                                "fn":btnComplete
                            },
                            "b3":{
                                "txt":"Abandon",
                                "fn":btnAbandon
                            }
                        };
                    }
                    else
                    {
                        _local_8 = mc.cnt.btns.dual;
                        mc.cnt.btns.tri.visible = false;
                        _local_9 = {
                            "b1":{
                                "txt":"Back",
                                "fn":btnBack
                            },
                            "b2":{
                                "txt":"Abandon",
                                "fn":btnAbandon
                            }
                        };
                    }
                }
            }
            else
            {
                _local_8 = mc.cnt.btns.dual;
                mc.cnt.btns.tri.visible = false;
                _local_9 = {
                    "b1":{
                        "txt":"Back",
                        "fn":btnBack
                    },
                    "b2":{
                        "txt":"Abandon",
                        "fn":btnAbandon
                    }
                };
            }
            for (_local_10 in _local_9)
            {
                _local_37 = _local_8[_local_10];
                _local_37.buttonMode = true;
                _local_37.fx.visible = false;
                _local_37.ti.mouseEnabled = false;
                _local_37.addEventListener(MouseEvent.MOUSE_OVER, bMouseOver, false, 0, true);
                _local_37.addEventListener(MouseEvent.MOUSE_OUT, bMouseOut, false, 0, true);
                _local_37.ti.text = _local_9[_local_10].txt;
                _local_37.addEventListener(MouseEvent.CLICK, _local_9[_local_10].fn, false, 0, true);
            }
            _local_11 = mc.cnt.scr;
            _local_12 = mc.cnt.bMask;
            _local_11.h.height = int(((_local_11.b.height / _local_5.height) * _local_11.b.height));
            hRun = (_local_11.b.height - _local_11.h.height);
            dRun = ((_local_5.height - _local_11.b.height) + 20);
            _local_11.h.y = 0;
            _local_5.oy = (_local_5.y = qdy);
            _local_11.visible = false;
            _local_11.hit.alpha = 0;
            mDown = false;
            if (_local_5.height > _local_11.b.height)
            {
                _local_11.visible = true;
                _local_11.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                _local_11.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                _local_5.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            }
            mc.cnt.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
        }

        private function onRewardPreview(_arg_1:MouseEvent):void
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_5:Object;
            for each (_local_3 in qData.oRewards)
            {
                for each (_local_5 in _local_3)
                {
                    if (_local_5.ItemID == _arg_1.currentTarget.ItemID)
                    {
                        _local_2 = _local_5;
                    }
                }
            }
            if (rootClass.ui.getChildByName("qRewardPrev"))
            {
                rootClass.ui.getChildByName("qRewardPrev").fClose();
            }
            var _local_4:* = rootClass.ui.addChild(new qRewardPrev(_local_2));
            _local_4.world = rootClass.world;
            _local_4.rootClass = rootClass;
            _local_4.open();
        }

        private function onWheel(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = mc.cnt.scr;
            if (((!(_local_2)) || (!(_local_2.visible))))
            {
                return;
            }
            _local_2.h.y = (_local_2.h.y + ((_arg_1.delta * -1) * 3));
            if (_local_2.h.y < 0)
            {
                _local_2.h.y = 0;
            }
            if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
            {
                _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
            }
        }

        private function scrDown(_arg_1:MouseEvent):*
        {
            mbY = int(mouseY);
            mhY = int(MovieClip(_arg_1.currentTarget.parent).h.y);
            mDown = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, scrUp, false, 0, true);
        }

        private function scrUp(_arg_1:MouseEvent):*
        {
            mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        private function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            if (mDown)
            {
                _local_2 = MovieClip(_arg_1.currentTarget.parent);
                mbD = (int(mouseY) - mbY);
                _local_2.h.y = (mhY + mbD);
                if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
                {
                    _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
                }
                if (_local_2.h.y < 0)
                {
                    _local_2.h.y = 0;
                }
            }
        }

        private function dEF(_arg_1:Event):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget.parent).scr;
            var _local_3:* = MovieClip(_arg_1.currentTarget);
            var _local_4:* = (-(_local_2.h.y) / hRun);
            var _local_5:* = (int((_local_4 * dRun)) + _local_3.oy);
            if (Math.abs((_local_5 - _local_3.y)) > 0.2)
            {
                _local_3.y = (_local_3.y + ((_local_5 - _local_3.y) / 4));
            }
            else
            {
                _local_3.y = _local_5;
            }
        }

        public function killDetailUI():*
        {
            if (mc.cnt.core.hasEventListener(Event.ENTER_FRAME))
            {
                mc.cnt.core.removeEventListener(Event.ENTER_FRAME, dEF);
            }
        }

        public function turninResult(_arg_1:String):*
        {
            getQuestListB();
            qData = null;
            if (mc.cnt.currentLabel == "hold")
            {
                if (_arg_1 == "pass")
                {
                    qData = nextQuestAvailable();
                }
                mc.cnt.gotoAndPlay("back");
            }
        }

        private function xClick(_arg_1:MouseEvent):*
        {
            fClose();
            if (rootClass.ui.getChildByName("qRewardPrev"))
            {
                rootClass.ui.getChildByName("qRewardPrev").fClose();
            }
        }

        public function fClose():void
        {
            mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK, xClick);
            stage.focus = stage;
            mc.parent.removeChild(mc);
        }

        private function btnAccept(_arg_1:MouseEvent):*
        {
            var _local_3:*;
            var _local_2:* = getQuestValidationString(qData);
            if ((((qData.hasOwnProperty("sMeta")) && (!(qData.sMeta.indexOf("EmailConfirm") == -1))) && (world.myAvatar.objData.intActivationFlag < 5)))
            {
                rootClass.MsgBox.notify("Confirmed Contact Email Address Required");
            }
            else
            {
                if (_local_2 != "")
                {
                    MovieClip(Game.root).MsgBox.notify(_local_2);
                }
                else
                {
                    if (world.coolDown("acceptQuest"))
                    {
                        _local_3 = MovieClip(_arg_1.currentTarget);
                        setCT(_local_3.bg, 43775);
                        _local_3.removeEventListener(MouseEvent.CLICK, btnAccept);
                        _local_3.removeEventListener(MouseEvent.MOUSE_OVER, bMouseOver);
                        _local_3.removeEventListener(MouseEvent.MOUSE_OUT, bMouseOut);
                        world.acceptQuest(qData.QuestID);
                        qData = null;
                    }
                }
            }
        }

        private function btnAbandon(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            world.abandonQuest(qData.QuestID);
            setCT(_local_2.bg, 0xFF0000);
            _local_2.removeEventListener(MouseEvent.CLICK, btnAbandon);
            _local_2.removeEventListener(MouseEvent.MOUSE_OVER, bMouseOver);
            _local_2.removeEventListener(MouseEvent.MOUSE_OUT, bMouseOut);
            qData = null;
            mc.cnt.gotoAndPlay("back");
        }

        private function btnComplete(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            if (((world.coolDown("tryQuestComplete")) && (world.canTurnInQuest(qData.QuestID))))
            {
                if (((!(qData.oRewards.itemsC == null)) && (choiceID == -1)))
                {
                    rootClass.addUpdate("Please choose a reward before turning the quest in!");
                    rootClass.chatF.pushMsg("warning", "Please choose a reward before turning the quest in!", "SERVER", "", 0);
                    return;
                }
                _local_2 = MovieClip(_arg_1.currentTarget);
                setCT(_local_2.bg, 0xFF00);
                _local_2.removeEventListener(MouseEvent.CLICK, btnAbandon);
                _local_2.removeEventListener(MouseEvent.MOUSE_OVER, bMouseOver);
                _local_2.removeEventListener(MouseEvent.MOUSE_OUT, bMouseOut);
                mc.cnt.gotoAndPlay("hold");
                getQuestListA();
                if ((((qData.sField == null) && (world.maximumQuestTurnIns(qData.QuestID) > 1)) && (qData.bOnce == 0)))
                {
                    _local_3 = new ModalMC();
                    _local_4 = {};
                    _local_4.params = {};
                    _local_4.strBody = "Turn-in the quest how many times?";
                    _local_4.callback = onQtyComplete;
                    _local_4.qtySel = {
                        "min":1,
                        "max":world.maximumQuestTurnIns(qData.QuestID),
                        "base":1
                    };
                    _local_4.glow = "white,medium";
                    _local_4.greedy = false;
                    rootClass.ui.ModalStack.addChild(_local_3);
                    _local_3.init(_local_4);
                }
                else
                {
                    world.tryQuestComplete(qData.QuestID, choiceID);
                }
            }
        }

        private function onQtyComplete(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                world.tryQuestComplete(qData.QuestID, choiceID, false, Number(_arg_1.iQty));
            }
        }

        private function btnBack(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            setCT(_local_2.bg, 0xAAAAAA);
            _local_2.removeEventListener(MouseEvent.CLICK, btnBack);
            _local_2.removeEventListener(MouseEvent.MOUSE_OVER, bMouseOver);
            _local_2.removeEventListener(MouseEvent.MOUSE_OUT, bMouseOut);
            mc.cnt.mouseChildren = false;
            qData = null;
            mc.cnt.gotoAndPlay("back");
        }

        private function btnRewardClick(_arg_1:MouseEvent):void
        {
            var _local_4:MovieClip;
            var _local_5:Array;
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            var _local_3:MovieClip = (_local_2.parent as MovieClip);
            choiceID = _local_2.ItemID;
            var _local_6:int = 1;
            while (_local_6 < _local_3.numChildren)
            {
                _local_4 = (_local_3.getChildAt(_local_6) as MovieClip);
                _local_5 = _local_4.bg.filters;
                if (((choiceID == _local_4.ItemID) && (_local_5.length == 1)))
                {
                    _local_5.push(new GlowFilter(16763955, 1, 5, 5, 2, 1, true, false));
                    _local_4.bg.filters = _local_5;
                }
                if (((!(choiceID == _local_4.ItemID)) && (_local_5.length > 1)))
                {
                    _local_5.pop();
                    _local_4.bg.filters = _local_5;
                }
                _local_6++;
            }
        }

        private function bMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.fx.visible = true;
        }

        private function bMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.fx.visible = false;
        }

        private function setCT(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = _arg_1.transform.colorTransform;
            _local_3.color = _arg_2;
            _arg_1.transform.colorTransform = _local_3;
        }

        private function iMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.parent.mHi.visible = true;
            _local_2.parent.mHi.y = _local_2.y;
        }

        private function iMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.parent.mHi.visible = false;
        }

        internal function frame7():*
        {
            stop();
        }

        internal function frame12():*
        {
        }

        internal function frame16():*
        {
            fClose();
        }


    }
}//package 

