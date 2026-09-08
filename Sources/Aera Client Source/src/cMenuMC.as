// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//cMenuMC

package 
{
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;
    import liteAssets.draw.charPage;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.text.*;

    public class cMenuMC extends MovieClip 
    {

        public var cnt:MovieClip;
        internal var world:MovieClip;
        internal var fData:Object = null;
        internal var isOpen:Boolean = false;
        internal var fMode:String;
        internal var mc:MovieClip;
        internal var rootClass:MovieClip;
        internal var iHi:Number = -1;
        internal var iSel:Number = -1;
        internal var iCT:ColorTransform;

        public function cMenuMC()
        {
            addFrameScript(0, frame1, 4, frame5, 9, frame10);
            mc = MovieClip(this);
            rootClass = MovieClip(stage.getChildAt(0));
            mc.cnt.iproto.visible = false;
            mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOn);
            mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            fData = {};
            fData.params = {};
            fData.user = ["Char Page", "Is Staff?", "Hide Helm", "Hide Cape", "Hide Weapon", "Hide Player", "Whisper", "Add Friend", "Go To", "Invite", "Report", "Delete Friend", "Ignore", "Trade", "Close"];
            fData.friend = ["Char Page", "Is Staff?", "Whisper", "Add Friend", "Go To", "Invite", "Report", "Delete Friend", "Ignore", "Close"];
            fData.party = ["Char Page", "Whisper", "Add Friend", "Go To", "Remove", "Summon", "Promote", "Report", "Delete Friend", "Ignore", "Close"];
            fData.self = ["Char Page", "Reputation", "Leave Party", "Close"];
            fData.pvpqueue = ["Leave Queue", "Close"];
            fData.offline = ["Char Page", "Delete Friend", "Close"];
            fData.ignored = ["Unignore", "Close"];
            fData.mons = ["Wiki Monster", "Hide Monster", "Close"];
            fData.cl = [];
            fData.clc = [];
        }

        public function fOpenWith(_arg_1:*, _arg_2:*):*
        {
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            isOpen = true;
            fMode = _arg_1.toLowerCase();
            fData.params = _arg_2;
            mc.cnt.mHi.visible = false;
            iCT = mc.cnt.mHi.transform.colorTransform;
            iCT.color = 13434675;
            mc.cnt.mHi.transform.colorTransform = iCT;
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < 13)
            {
                _local_7 = mc.cnt.getChildByName(("i" + _local_3));
                if (_local_7 != null)
                {
                    _local_7.removeEventListener(MouseEvent.CLICK, itemClick);
                    _local_7.removeEventListener(MouseEvent.MOUSE_OVER, itemMouseOver);
                    mc.cnt.removeChild(_local_7);
                };
                _local_3++;
            };
            var _local_4:* = 0;
            delete fData.cl;
            delete fData.clc;
            var _local_5:* = fData.params.strUsername.toLowerCase();
            var _local_6:* = rootClass.world.uoTree[_local_5];
            fData.cl = rootClass.copyObj(fData[fMode]);
            fData.clc = [];
            _local_3 = 0;
            while (_local_3 < fData.cl.length)
            {
                if (((fData.cl[_local_3] == "Add Friend") && (rootClass.world.myAvatar.isFriend(fData.params.ID))))
                {
                    fData.cl.splice(_local_3, 1);
                    _local_3--;
                };
                if (((fData.cl[_local_3] == "Delete Friend") && (!(rootClass.world.myAvatar.isFriend(fData.params.ID)))))
                {
                    fData.cl.splice(_local_3, 1);
                    _local_3--;
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < fData.cl.length)
            {
                if (_local_5 == rootClass.sfc.myUserName)
                {
                };
                if (rootClass.world.getAvatarByUserName(_local_5))
                {
                    if (((fData.cl[_local_3] == "Ignore") && (rootClass.chatF.isIgnored(_local_5))))
                    {
                        fData.cl[_local_3] = "Unignore";
                    };
                    if (((fData.cl[_local_3] == "Hide Helm") && (!(rootClass.world.getAvatarByUserName(_local_5).pMC.mcChar.head.helm.visible))))
                    {
                        fData.cl[_local_3] = "Show Helm";
                    };
                    if (((fData.cl[_local_3] == "Hide Cape") && (!(rootClass.world.getAvatarByUserName(_local_5).pMC.mcChar.cape.visible))))
                    {
                        fData.cl[_local_3] = "Show Cape";
                    };
                    if (((fData.cl[_local_3] == "Hide Player") && (!(rootClass.world.getAvatarByUserName(_local_5).pMC.mcChar.visible))))
                    {
                        fData.cl[_local_3] = "Show Player";
                    };
                    if (((fData.cl[_local_3] == "Hide Weapon") && (!(rootClass.world.getAvatarByUserName(_local_5).pMC.mcChar.weapon.visible))))
                    {
                        fData.cl[_local_3] = "Show Weapon";
                    };
                };
                if (fData.params.target)
                {
                    if (((fData.cl[_local_3] == "Freeze Monster") && (fData.params.target.noMove)))
                    {
                        fData.cl[_local_3] = "UnFreeze Monster";
                    };
                    if (((fData.cl[_local_3] == "Hide Monster") && (!(fData.params.target.getChildAt(1).visible))))
                    {
                        fData.cl[_local_3] = "Show Monster";
                    };
                };
                _local_8 = mc.cnt.addChild(new cProto());
                _local_8.name = ("i" + _local_3);
                _local_8.y = (mc.cnt.iproto.y + (_local_3 * 14));
                iCT = _local_8.transform.colorTransform;
                _local_9 = true;
                switch (fData.cl[_local_3].toLowerCase())
                {
                    case "add friend":
                        if ((((!(rootClass.world.getAvatarByUserName(_local_5) == null)) && (!(rootClass.world.getAvatarByUserName(_local_5).objData == null))) && ((rootClass.world.getAvatarByUserName(_local_5).isStaff()) && (!(rootClass.world.myAvatar.isStaff())))))
                        {
                            _local_9 = false;
                        };
                        break;
                    case "go to":
                        if (!((rootClass.world.isPartyMember(_local_5)) || (rootClass.world.myAvatar.isFriend(fData.params.ID))))
                        {
                            _local_9 = false;
                        };
                        break;
                    case "ignore":
                        if (_local_5 == rootClass.sfc.myUserName)
                        {
                            _local_9 = false;
                        };
                        break;
                    case "invite":
                        if ((((((((_local_5 == rootClass.sfc.myUserName) || (_local_6 == null)) || (((!(rootClass.world.getAvatarByUserName(_local_5) == null)) && (!(rootClass.world.getAvatarByUserName(_local_5).objData == null))) && ((rootClass.world.getAvatarByUserName(_local_5).isStaff()) && (!(rootClass.world.myAvatar.isStaff()))))) || (rootClass.world.partyMembers.length > 4)) || (rootClass.world.isPartyMember(fData.params.strUsername))) || ((rootClass.world.bPvP) && (!(_local_6.pvpTeam == rootClass.world.myAvatar.dataLeaf.pvpTeam)))) || ((rootClass.world.partyMembers.length > 0) && (!(rootClass.world.partyOwner.toLowerCase() == rootClass.sfc.myUserName)))))
                        {
                            _local_9 = false;
                        };
                        break;
                    case "leave party":
                        if (rootClass.world.partyMembers.length == 0)
                        {
                            _local_9 = false;
                        };
                        break;
                    case "remove":
                        if (rootClass.world.partyOwner.toLowerCase() != rootClass.sfc.myUserName)
                        {
                            fData.cl[_local_3] = "Leave Party";
                        };
                        break;
                    case "private: on":
                    case "private: off":
                    case "promote":
                        if (rootClass.world.partyOwner != rootClass.world.myAvatar.objData.strUsername)
                        {
                            _local_9 = false;
                        };
                        break;
                    case "inspect":
                        if (((_local_6 == null) || (!(_local_6.strFrame == rootClass.world.strFrame))))
                        {
                            _local_9 = false;
                        };
                        break;
                };
                if (_local_9)
                {
                    iCT.color = 0x999999;
                    _local_8.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
                    _local_8.buttonMode = true;
                }
                else
                {
                    iCT.color = 0x666666;
                };
                _local_8.addEventListener(MouseEvent.MOUSE_OVER, itemMouseOver, false, 0, true);
                fData.clc.push(iCT.color);
                _local_8.ti.text = fData.cl[_local_3];
                if (_local_8.ti.textWidth > _local_4)
                {
                    _local_4 = _local_8.ti.textWidth;
                };
                _local_8.transform.colorTransform = iCT;
                _local_8.ti.width = (_local_8.ti.textWidth + 5);
                _local_8.hit.width = ((_local_8.ti.x + _local_8.ti.textWidth) + 2);
                _local_3++;
            };
            mc.cnt.bg.height = (mc.cnt.getChildByName(String(("i" + (fData.cl.length - 1)))).y + 26);
            mc.cnt.bg.width = (_local_4 + 20);
            mc.x = (MovieClip(parent).mouseX - 5);
            mc.y = (MovieClip(parent).mouseY - 5);
            if ((mc.x + mc.cnt.bg.width) > 960)
            {
                mc.x = (MovieClip(parent).mouseX - mc.cnt.bg.width);
            };
            if ((mc.y + mc.cnt.bg.height) > 500)
            {
                mc.y = (500 - mc.cnt.bg.height);
            };
            mc.gotoAndPlay("in");
        }

        public function fClose():*
        {
            isOpen = false;
            if (mc.currentFrame != 1)
            {
                if (mc.currentFrame == 10)
                {
                    mc.gotoAndPlay("out");
                }
                else
                {
                    mc.gotoAndStop("hold");
                };
            };
        }

        private function itemMouseOver(_arg_1:MouseEvent):*
        {
            var _local_4:*;
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            iHi = int(_local_2.name.substr(1));
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < fData.cl.length)
            {
                _local_4 = mc.cnt.getChildByName(("i" + _local_3));
                iCT = _local_4.transform.colorTransform;
                if (_local_3 == iHi)
                {
                    if (_local_2.hasEventListener(MouseEvent.CLICK))
                    {
                        iCT.color = 0xFFFFFF;
                        cnt.mHi.visible = true;
                        cnt.mHi.y = (_local_4.y + 3);
                    }
                    else
                    {
                        cnt.mHi.visible = false;
                    };
                }
                else
                {
                    iCT.color = fData.clc[_local_3];
                };
                _local_4.transform.colorTransform = iCT;
                _local_3++;
            };
        }

        private function itemClick(_arg_1:MouseEvent):*
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:*;
            var _local_6:charPage;
            var _local_7:*;
            var _local_8:*;
            var _local_9:String;
            var _local_10:int;
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            iSel = int(_local_2.name.substr(1));
            iCT = mc.cnt.mHi.transform.colorTransform;
            iCT.color = 16763955;
            mc.cnt.mHi.transform.colorTransform = iCT;
            fClose();
            _local_3 = fData.cl[iSel];
            _local_4 = fData.params.strUsername;
            switch (_local_3.toLowerCase())
            {
                case "wiki monster":
                    navigateToURL(new URLRequest(("http://aqwwiki.wikidot.com/" + fData.params.target.pname.ti.text)), "_blank");
                    return;
                case "freeze monster":
                    fData.params.target.noMove = true;
                    return;
                case "unfreeze monster":
                    fData.params.target.noMove = false;
                    return;
                case "hide helm":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.head.helm.visible = false;
                    _local_5.pMC.mcChar.head.hair.visible = true;
                    _local_5.pMC.mcChar.backhair.visible = _local_5.pMC.bBackHair;
                    return;
                case "show helm":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.head.helm.visible = true;
                    _local_5.pMC.mcChar.head.hair.visible = false;
                    _local_5.pMC.mcChar.backhair.visible = false;
                    return;
                case "hide cape":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.cape.visible = false;
                    return;
                case "show cape":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.cape.visible = true;
                    return;
                case "hide monster":
                    fData.params.target.getChildAt(1).visible = false;
                    return;
                case "show monster":
                    fData.params.target.getChildAt(1).visible = true;
                    return;
                case "show weapon":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.weapon.visible = true;
                    if (_local_5.pMC.pAV.getItemByEquipSlot("Weapon").sType == "Dagger")
                    {
                        _local_5.pMC.mcChar.weaponOff.visible = true;
                    };
                    return;
                case "show player":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.visible = true;
                    _local_5.pMC.pname.visible = true;
                    _local_5.pMC.shadow.visible = true;
                    return;
                case "hide weapon":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.weapon.visible = false;
                    _local_5.pMC.mcChar.weaponOff.visible = false;
                    return;
                case "hide player":
                    _local_5 = rootClass.world.getAvatarByUserName(_local_4);
                    _local_5.pMC.mcChar.visible = false;
                    _local_5.pMC.pname.visible = false;
                    _local_5.pMC.shadow.visible = false;
                    return;
                case "char page":
                    rootClass.mixer.playSound("Click");
                    _local_6 = new charPage(rootClass, _local_4);
                    rootClass.ui.addChild(_local_6);
                    return;
                case "is staff?":
                    rootClass.world.isModerator(_local_4);
                    return;
                case "reputation":
                    rootClass.mixer.playSound("Click");
                    rootClass.showFactionInterface();
                    return;
                case "whisper":
                    rootClass.chatF.openPMsg(_local_4);
                    return;
                case "ignore":
                    rootClass.chatF.ignore(_local_4);
                    rootClass.chatF.pushMsg("server", (("You are now ignoring user " + _local_4) + "."), "SERVER", "", 0);
                    return;
                case "unignore":
                    rootClass.chatF.unignore(_local_4);
                    rootClass.chatF.pushMsg("server", (("User " + _local_4) + " is no longer being ignored."), "SERVER", "", 0);
                    return;
                case "trade":
                    rootClass.world.sendTradeInvite(_local_4);
                    return;
                case "report":
                    rootClass.ui.mcPopup.fOpen("Report", {"unm":_local_4});
                    return;
                case "close":
                    if (((fMode == "user") || (fMode == "party")))
                    {
                        rootClass.world.cancelTarget();
                    };
                    return;
                case "add friend":
                    if (rootClass.world.myAvatar.friends.length >= rootClass.iMaxFriends)
                    {
                        rootClass.chatF.pushMsg("server", (("You are too popular! (" + String(rootClass.iMaxFriends)) + " friends max)"), "SERVER", "", 0);
                    }
                    else
                    {
                        rootClass.world.requestFriend(_local_4);
                    };
                    return;
                case "delete friend":
                    _local_7 = new ModalMC();
                    _local_8 = {};
                    _local_8.strBody = (("Are you sure you want to delete " + _local_4) + " from your friends list?");
                    _local_8.params = {
                        "id":fData.params.ID,
                        "unm":_local_4
                    };
                    _local_8.callback = confirmDeleteFriend;
                    _local_8.glow = "red,medium";
                    rootClass.ui.ModalStack.addChild(_local_7);
                    _local_7.init(_local_8);
                    return;
                case "go to":
                    rootClass.world._SafeStr_1(_local_4);
                    return;
                case "invite":
                    rootClass.world.partyInvite(_local_4);
                    return;
                case "remove":
                    rootClass.world.partyKick(_local_4);
                    return;
                case "leave party":
                    rootClass.world.partyLeave();
                    return;
                case "private: on":
                case "private: off":
                    _local_9 = _local_3.toLowerCase().split(": ")[0];
                    _local_10 = ((_local_3.toLowerCase().split(": ")[1] == "on") ? 1 : 0);
                    rootClass.world.partyUpdate(_local_9, _local_10);
                    return;
                case "promote":
                    rootClass.world.partyPromote(_local_4);
                    return;
                case "summon":
                    rootClass.world.partySummon(_local_4);
                    return;
                case "leave queue":
                    rootClass.world.requestPVPQueue("none");
                    return;
            };
        }

        private function confirmDeleteFriend(_arg_1:Object):*
        {
            if (_arg_1.accept)
            {
                rootClass.world.deleteFriend(_arg_1.id, _arg_1.unm);
            };
        }

        private function mouseOn(_arg_1:MouseEvent):*
        {
            MovieClip(_arg_1.currentTarget).cnt.gotoAndStop("hold");
        }

        private function mouseOut(_arg_1:MouseEvent):*
        {
            MovieClip(_arg_1.currentTarget).cnt.gotoAndPlay("out");
        }

        internal function frame1():*
        {
            visible = false;
            stop();
        }

        internal function frame5():*
        {
            visible = true;
        }

        internal function frame10():*
        {
            stop();
        }


    }
}//package 

// _SafeStr_1 = "goto" (String#4022)


