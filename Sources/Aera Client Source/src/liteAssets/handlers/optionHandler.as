// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.handlers.optionHandler

package liteAssets.handlers
{
    import flash.display.MovieClip;
    import liteAssets.draw.blackList;
    import liteAssets.draw.keybinds;
    import liteAssets.draw.travelMenu;
    import liteAssets.draw.cellMenu;
    import liteAssets.draw.packetlogger;
    import liteAssets.draw.battleAnalyzer;
    import liteAssets.draw.playerAuras;
    import liteAssets.draw.targetAuras;
    import liteAssets.draw.customDrops;
    import flash.media.SoundTransform;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.ui.*;

    public class optionHandler extends MovieClip 
    {


        public static function key(_arg_1:MovieClip, _arg_2:String, _arg_3:uint):void
        {
            var _local_4:*;
            var _local_5:*;
            _arg_1.litePreference.data.keys[_arg_2] = _arg_3;
            if (((_arg_2.indexOf("Auto Attack") > -1) || (_arg_2.indexOf("Skill ") > -1)))
            {
                _local_4 = ((_arg_3) ? _arg_1.keyDict[_arg_3] : " ");
                if (_arg_2 == "Auto Attack")
                {
                    _arg_1.ui.mcInterface.getChildByName("keyA0").text = _local_4;
                }
                else
                {
                    _local_5 = _arg_2.split(" ")[1];
                    _arg_1.ui.mcInterface.getChildByName(("keyA" + _local_5)).text = _local_4;
                };
            };
        }

        public static function cmd(r:MovieClip, id:String):void
        {
            var player:* = undefined;
            var mons:* = undefined;
            var i:int;
            var j:int;
            var mcDrop:* = undefined;
            var _m:* = undefined;
            var blacklist:blackList;
            var mcKeybinds:keybinds;
            var travelMenuMC:travelMenu;
            switch (id)
            {
                case "@ Debugger":
                    r.litePreference.data.bDebugger = (!(r.litePreference.data.bDebugger));
                    r.litePreference.flush();
                    if (r.litePreference.data.bDebugger)
                    {
                        r.cMenuUI = new cellMenu(r);
                        if (r.litePreference.data.dOptions["debugPacket"])
                        {
                            r.pLoggerUI = new packetlogger(r);
                        }
                        else
                        {
                            if (r.pLoggerUI != null)
                            {
                                r.pLoggerUI.cleanup();
                            };
                        };
                    }
                    else
                    {
                        if (r.cMenuUI != null)
                        {
                            r.cMenuUI.cleanup();
                        };
                        if (r.pLoggerUI != null)
                        {
                            r.pLoggerUI.cleanup();
                        };
                    };
                    return;
                case "Disable Linkage Errors":
                    r.litePreference.data.dOptions["debugLinkage"] = (!(r.litePreference.data.dOptions["debugLinkage"]));
                    r.litePreference.flush();
                    return;
                case "Disable Color Coded Items":
                    r.litePreference.data.dOptions["debugColor"] = (!(r.litePreference.data.dOptions["debugColor"]));
                    r.litePreference.flush();
                    return;
                case "Packet Logger":
                    r.litePreference.data.dOptions["debugPacket"] = (!(r.litePreference.data.dOptions["debugPacket"]));
                    r.litePreference.flush();
                    if (r.litePreference.data.bDebugger)
                    {
                        if (r.litePreference.data.dOptions["debugPacket"])
                        {
                            r.pLoggerUI = new packetlogger(r);
                        }
                        else
                        {
                            if (r.pLoggerUI != null)
                            {
                                r.pLoggerUI.cleanup();
                            };
                        };
                    }
                    else
                    {
                        if (r.pLoggerUI != null)
                        {
                            r.pLoggerUI.cleanup();
                        };
                    };
                    return;
                case "Allow Quest Log Turn-Ins":
                    r.litePreference.data.bQuestLog = (!(r.litePreference.data.bQuestLog));
                    r.litePreference.flush();
                    return;
                case "Auto-Untarget Dead Targets":
                    r.litePreference.data.bUntargetDead = (!(r.litePreference.data.bUntargetDead));
                    r.litePreference.flush();
                    if (r.litePreference.data.bUntargetDead)
                    {
                        if (((!(r.world.myAvatar.target == null)) && (r.world.myAvatar.target.dataLeaf.intState == 0)))
                        {
                            r.world.cancelTarget();
                        };
                    };
                    return;
                case "Auto-Untarget Self":
                    r.litePreference.data.bUntargetSelf = (!(r.litePreference.data.bUntargetSelf));
                    r.litePreference.flush();
                    if (r.litePreference.data.bUntargetSelf)
                    {
                        if (((!(r.world.myAvatar.target == null)) && (r.world.myAvatar.target.isMyAvatar)))
                        {
                            r.world.cancelTarget();
                        };
                    };
                    return;
                case "Battle Analyzer":
                    if (r.ui.getChildByName("battleAnalyzer"))
                    {
                        return;
                    };
                    r.bAnalyzer = new battleAnalyzer();
                    r.ui.addChild(r.bAnalyzer);
                    r.bAnalyzer.name = "battleAnalyzer";
                    return;
                case "Battlepets":
                    r.litePreference.data.bBattlepet = (!(r.litePreference.data.bBattlepet));
                    r.litePreference.flush();
                    return;
                case "Static Player Art":
                    r.litePreference.data.bCachePlayers = (!(r.litePreference.data.bCachePlayers));
                    r.litePreference.flush();
                    if (r.litePreference.data.bCachePlayers)
                    {
                        for each (player in r.world.avatars)
                        {
                            if (player.pMC)
                            {
                                if (!player.isMyAvatar)
                                {
                                    try
                                    {
                                        r.rasterize(player.pMC.mcChar);
                                    }
                                    catch(exception)
                                    {
                                    };
                                };
                            };
                        };
                    };
                    return;
                case "Character Select Screen":
                    r.litePreference.data.bCharSelect = (!(r.litePreference.data.bCharSelect));
                    r.litePreference.flush();
                    if (r.litePreference.data.bCharSelect)
                    {
                        r.saveChar();
                    };
                    return;
                case "Chat Settings":
                    r.litePreference.data.bChatFilter = (!(r.litePreference.data.bChatFilter));
                    r.litePreference.flush();
                    return;
                case "Vanishing Messages":
                    r.litePreference.data.dOptions["vanishMsg"] = (!(r.litePreference.data.dOptions["vanishMsg"]));
                    r.litePreference.flush();
                    return;
                case "Timestamps":
                    r.litePreference.data.dOptions["timeStamps"] = (!(r.litePreference.data.dOptions["timeStamps"]));
                    r.litePreference.flush();
                    return;
                case "Disable Blue Messages":
                    r.litePreference.data.dOptions["disBlue"] = (!(r.litePreference.data.dOptions["disBlue"]));
                    r.litePreference.flush();
                    return;
                case "Disable Red Messages":
                    r.litePreference.data.dOptions["disRed"] = (!(r.litePreference.data.dOptions["disRed"]));
                    r.litePreference.flush();
                    return;
                case "Chat UI":
                    r.litePreference.data.bChatUI = (!(r.litePreference.data.bChatUI));
                    r.litePreference.flush();
                    return;
                case "Minimal Mode":
                    r.litePreference.data.dOptions["chatMinimal"] = (!(r.litePreference.data.dOptions["chatMinimal"]));
                    r.litePreference.flush();
                    if (r.intChatMode)
                    {
                        r.chatF.setMinimalMode(r.litePreference.data.dOptions["chatMinimal"]);
                    };
                    return;
                case "Disable AutoScroll to Bottom":
                    r.litePreference.data.dOptions["chatScroll"] = (!(r.litePreference.data.dOptions["chatScroll"]));
                    r.litePreference.flush();
                    return;
                case "Class Actives/Auras UI":
                    r.litePreference.data.bAuras = (!(r.litePreference.data.bAuras));
                    r.litePreference.flush();
                    if (r.litePreference.data.bAuras)
                    {
                        r.pAurasUI = new playerAuras(r);
                        r.tAurasUI = new targetAuras(r);
                        r.ui.mcPortrait.addChild(r.pAurasUI);
                        r.ui.mcPortraitTarget.addChild(r.tAurasUI);
                    }
                    else
                    {
                        if (r.pAurasUI != null)
                        {
                            if (r.ui.mcPortrait.getChildByName("playerAuras"))
                            {
                                r.ui.mcPortrait.removeChild(r.ui.mcPortrait.getChildByName("playerAuras"));
                                r.ui.removeChild(r.ui.getChildByName("targetAuras"));
                            };
                            r.pAurasUI.cleanup();
                            r.tAurasUI.cleanup();
                        };
                    };
                    return;
                case "Disable ToolTips":
                    r.litePreference.data.dOptions["disAuraTips"] = (!(r.litePreference.data.dOptions["disAuraTips"]));
                    r.litePreference.flush();
                    return;
                case "Disable Aura Text":
                    r.litePreference.data.dOptions["disAuraText"] = (!(r.litePreference.data.dOptions["disAuraText"]));
                    r.litePreference.flush();
                    return;
                case "Color Sets":
                    r.litePreference.data.bColorSets = (!(r.litePreference.data.bColorSets));
                    r.litePreference.flush();
                    return;
                case "Custom Drops UI":
                    r.litePreference.data.bCustomDrops = (!(r.litePreference.data.bCustomDrops));
                    r.litePreference.flush();
                    if (r.litePreference.data.bCustomDrops)
                    {
                        r.cDropsUI = new customDrops(r);
                    }
                    else
                    {
                        if (r.cDropsUI != null)
                        {
                            r.cDropsUI.cleanup();
                        };
                    };
                    return;
                case "Invert Menu":
                    r.litePreference.data.dOptions["invertMenu"] = (!(r.litePreference.data.dOptions["invertMenu"]));
                    r.litePreference.flush();
                    return;
                case "Warn When Declining A Drop":
                    r.litePreference.data.dOptions["warnDecline"] = (!(r.litePreference.data.dOptions["warnDecline"]));
                    r.litePreference.flush();
                    return;
                case "Hide Drop Notifications":
                    r.litePreference.data.dOptions["hideDrop"] = (!(r.litePreference.data.dOptions["hideDrop"]));
                    r.litePreference.flush();
                    return;
                case "Hide Temporary Drop Notifications":
                    r.litePreference.data.dOptions["hideTemp"] = (!(r.litePreference.data.dOptions["hideTemp"]));
                    r.litePreference.flush();
                    return;
                case "Opened Menu":
                    r.litePreference.data.dOptions["openMenu"] = (!(r.litePreference.data.dOptions["openMenu"]));
                    r.litePreference.flush();
                    return;
                case "Draggable Mode":
                    r.litePreference.data.dOptions["dragMode"] = (!(r.litePreference.data.dOptions["dragMode"]));
                    r.litePreference.flush();
                    if (r.cDropsUI)
                    {
                        r.cDropsUI.onChange(r.litePreference.data.dOptions["dragMode"]);
                    };
                    return;
                case "Lock Position":
                    r.litePreference.data.dOptions["lockMode"] = (!(r.litePreference.data.dOptions["lockMode"]));
                    r.litePreference.flush();
                    if (r.cDropsUI)
                    {
                        r.cDropsUI.lockMode();
                    };
                    return;
                case "Reset Position":
                    if (r.cDropsUI)
                    {
                        r.cDropsUI.resetPos();
                    };
                    return;
                case "Quantity Warnings":
                    r.litePreference.data.dOptions["termsAgree"] = (!(r.litePreference.data.dOptions["termsAgree"]));
                    r.litePreference.flush();
                    return;
                case "Disable Chat Scrolling":
                    r.litePreference.data.bDisChatScroll = (!(r.litePreference.data.bDisChatScroll));
                    r.litePreference.flush();
                    return;
                case "Disable Damage Numbers":
                    r.litePreference.data.bDisDmgDisplay = (!(r.litePreference.data.bDisDmgDisplay));
                    r.litePreference.flush();
                    return;
                case "Disable Damage Strobe":
                    r.litePreference.data.bDisDmgStrobe = (!(r.litePreference.data.bDisDmgStrobe));
                    r.litePreference.flush();
                    return;
                case "Disable Monster Animations":
                    r.litePreference.data.bDisMonAnim = (!(r.litePreference.data.bDisMonAnim));
                    r.litePreference.flush();
                    if (r.litePreference.data.bDisMonAnim)
                    {
                        for (mons in r.world.monsters)
                        {
                            if (r.world.monsters[mons].dataLeaf)
                            {
                                if (r.world.monsters[mons].pMC)
                                {
                                    r.movieClipStopAll((r.world.monsters[mons].pMC.getChildAt(1) as MovieClip));
                                };
                            };
                        };
                    };
                    return;
                case "Disable Self Animations":
                    r.litePreference.data.bDisSelfMAnim = (!(r.litePreference.data.bDisSelfMAnim));
                    r.litePreference.flush();
                    return;
                case "Disable Skill Animations":
                    r.litePreference.data.bDisSkillAnim = (!(r.litePreference.data.bDisSkillAnim));
                    r.litePreference.flush();
                    return;
                case "Show Your Skill Animations Only":
                    r.litePreference.data.dOptions["animSelf"] = (!(r.litePreference.data.dOptions["animSelf"]));
                    r.litePreference.flush();
                    return;
                case "Disable Sound FX":
                    r.litePreference.data.bDisSoundFX = (!(r.litePreference.data.bDisSoundFX));
                    r.litePreference.flush();
                    r.mixer.stf = ((r.litePreference.data.bDisSoundFX) ? new SoundTransform(0) : new SoundTransform(1));
                    return;
                case "Disable Quest Popup":
                    r.litePreference.data.bDisQPopup = (!(r.litePreference.data.bDisQPopup));
                    r.litePreference.flush();
                    return;
                case "Disable Quest Tracker":
                    r.litePreference.data.bDisQTracker = (!(r.litePreference.data.bDisQTracker));
                    r.litePreference.flush();
                    return;
                case "Disable Weapon Animations":
                    r.litePreference.data.bDisWepAnim = (!(r.litePreference.data.bDisWepAnim));
                    r.litePreference.flush();
                    if (r.litePreference.data.bDisWepAnim)
                    {
                        for each (player in r.world.avatars)
                        {
                            if (player.objData)
                            {
                                if (player.pMC)
                                {
                                    try
                                    {
                                        player.pMC.mcChar.weapon.mcWeapon.gotoAndStop(0);
                                        (player.pMC.mcChar.weaponOff.getChildAt(0) as MovieClip).gotoAndStop(0);
                                        r.movieClipStopAll(player.pMC.mcChar.weapon.mcWeapon);
                                        r.movieClipStopAll((player.pMC.mcChar.weaponOff.getChildAt(0) as MovieClip));
                                    }
                                    catch(exception)
                                    {
                                    };
                                };
                            };
                        };
                    };
                    return;
                case "Keep Your Weapon Animations Only":
                    r.litePreference.data.dOptions["wepSelf"] = (!(r.litePreference.data.dOptions["wepSelf"]));
                    r.litePreference.flush();
                    return;
                case "Decline All Drops":
                    if (r.litePreference.data.bCustomDrops)
                    {
                        r.cDropsUI.onUpdate();
                    }
                    else
                    {
                        i = 0;
                        while (i < r.ui.dropStack.numChildren)
                        {
                            try
                            {
                                r.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                            }
                            catch(e)
                            {
                            };
                            i = (i + 1);
                        };
                    };
                    return;
                case "Display FPS":
                    r.ui.mcFPS.visible = (!(r.ui.mcFPS.visible));
                    return;
                case "Draggable Drops":
                    r.litePreference.data.bDraggable = (!(r.litePreference.data.bDraggable));
                    r.litePreference.flush();
                    if (r.ui.dropStack.numChildren < 1) break;
                    j = 0;
                    while (j < r.ui.dropStack.numChildren)
                    {
                        try
                        {
                            mcDrop = r.ui.dropStack.getChildAt(i);
                            if (mcDrop.hasEventListener(MouseEvent.MOUSE_DOWN))
                            {
                                mcDrop.addEventListener(MouseEvent.MOUSE_DOWN, dStartDrag, false, 0, true);
                                mcDrop.addEventListener(MouseEvent.MOUSE_UP, dStopDrag, false, 0, true);
                            };
                        }
                        catch(exception)
                        {
                        };
                        j = (j + 1);
                    };
                    return;
                case "Freeze / Lock Monster Position":
                    r.litePreference.data.bFreezeMons = (!(r.litePreference.data.bFreezeMons));
                    r.litePreference.flush();
                    for each (_m in r.world.monsters)
                    {
                        if (_m)
                        {
                            if (_m.pMC)
                            {
                                if (_m.pMC.getChildAt(1))
                                {
                                    _m.pMC.noMove = r.litePreference.data.bFreezeMons;
                                };
                            };
                        };
                    };
                    return;
                case "Invisible Monsters":
                    r.litePreference.data.bHideMons = (!(r.litePreference.data.bHideMons));
                    r.litePreference.flush();
                    for each (_m in r.world.monsters)
                    {
                        if (_m)
                        {
                            if (_m.pMC)
                            {
                                if (_m.pMC.getChildAt(1))
                                {
                                    _m.pMC.getChildAt(1).visible = (!(r.litePreference.data.bHideMons));
                                };
                            };
                        };
                    };
                    return;
                case "Hide Players":
                    r.litePreference.data.bHidePlayers = (!(r.litePreference.data.bHidePlayers));
                    r.litePreference.flush();
                    for each (player in r.world.avatars)
                    {
                        if (((player.pMC) && (!(player.isMyAvatar))))
                        {
                            player.pMC.mcChar.visible = (!(r.litePreference.data.bHidePlayers));
                            player.pMC.pname.visible = r.litePreference.data.dOptions["showNames"];
                            player.pMC.shadow.visible = r.litePreference.data.dOptions["showShadows"];
                            if (!r.litePreference.data.bHidePlayers)
                            {
                                player.pMC.pname.visible = true;
                                player.pMC.shadow.visible = true;
                            };
                        };
                    };
                    return;
                case "Show Name Tags":
                    r.litePreference.data.dOptions["showNames"] = (!(r.litePreference.data.dOptions["showNames"]));
                    r.litePreference.flush();
                    return;
                case "Show Shadows":
                    r.litePreference.data.dOptions["showShadows"] = (!(r.litePreference.data.dOptions["showShadows"]));
                    r.litePreference.flush();
                    return;
                case "Hide Player Names":
                    r.litePreference.data.bHideNames = (!(r.litePreference.data.bHideNames));
                    r.litePreference.flush();
                    for each (player in r.world.avatars)
                    {
                        if (player.pMC)
                        {
                            if (!r.litePreference.data.bHideNames)
                            {
                                player.pMC.hideNameCleanup();
                            }
                            else
                            {
                                player.pMC.hideNameSetup();
                            };
                        };
                    };
                    return;
                case "Hide Guild Names Only":
                    r.litePreference.data.dOptions["hideGuild"] = (!(r.litePreference.data.dOptions["hideGuild"]));
                    r.litePreference.flush();
                    if (r.litePreference.data.bHideNames)
                    {
                        for each (player in r.world.avatars)
                        {
                            if (player.pMC)
                            {
                                player.pMC.hideNameSetup();
                            };
                        };
                    };
                    return;
                case "Hide Your Name Only":
                    r.litePreference.data.dOptions["hideSelf"] = (!(r.litePreference.data.dOptions["hideSelf"]));
                    r.litePreference.flush();
                    if (r.litePreference.data.bHideNames)
                    {
                        for each (player in r.world.avatars)
                        {
                            if (player.pMC)
                            {
                                player.pMC.hideNameSetup();
                            };
                        };
                    };
                    return;
                case "Hide UI":
                    r.litePreference.data.bHideUI = (!(r.litePreference.data.bHideUI));
                    r.litePreference.flush();
                    if (r.litePreference.data.bHideUI)
                    {
                        r.ui.mcInterface.areaList.visible = false;
                        r.hidePortrait();
                        r.hidePortraitTarget();
                    }
                    else
                    {
                        r.world.setTarget(null);
                        r.ui.mcInterface.areaList.visible = true;
                        r.showPortrait(r.world.myAvatar);
                        if (r.world.myAvatar.target)
                        {
                            r.showPortraitTarget(r.world.myAvatar.target);
                        };
                    };
                    return;
                case "Item Drops Block List":
                    if (!r.ui.getChildByName("mcBlacklist"))
                    {
                        blacklist = new blackList(r);
                        blacklist.name = "mcBlacklist";
                        r.ui.addChild(blacklist);
                    };
                    return;
                case "Keybinds":
                    if (!r.ui.getChildByName("mcKeybinds"))
                    {
                        mcKeybinds = new keybinds(r);
                        mcKeybinds.name = "mcKeybinds";
                        r.ui.addChild(mcKeybinds);
                        r.ui.setChildIndex(mcKeybinds, (r.ui.getChildIndex(r.ui.ToolTip) - 1));
                    };
                    return;
                case "Reaccept Quest After Turn-In":
                    r.litePreference.data.bReaccept = (!(r.litePreference.data.bReaccept));
                    r.litePreference.flush();
                    return;
                case "Show Monster Type":
                    r.litePreference.data.bMonsType = (!(r.litePreference.data.bMonsType));
                    r.litePreference.flush();
                    return;
                case "Smooth Background":
                    r.litePreference.data.bSmoothBG = (!(r.litePreference.data.bSmoothBG));
                    r.litePreference.flush();
                    return;
                case "Travel Menu":
                    if (!r.ui.getChildByName("mcTravelMenu"))
                    {
                        travelMenuMC = new travelMenu(r);
                        travelMenuMC.name = "mcTravelMenu";
                        r.ui.addChild(travelMenuMC);
                    };
                    return;
                case "Quest Pinner":
                    r.litePreference.data.bQuestPin = (!(r.litePreference.data.bQuestPin));
                    r.litePreference.flush();
                    return;
                case "Quest Progress Notifications":
                    r.litePreference.data.bQuestNotif = (!(r.litePreference.data.bQuestNotif));
                    r.litePreference.flush();
                    return;
                case "Visual Skill CDs":
                    r.litePreference.data.bSkillCD = (!(r.litePreference.data.bSkillCD));
                    r.litePreference.flush();
                    return;
                case "Hide Ground Items":
                    r.litePreference.data.bDisGround = (!(r.litePreference.data.bDisGround));
                    r.litePreference.flush();
                    if (r.litePreference.data.bDisGround)
                    {
                        for each (player in r.world.avatars)
                        {
                            if (!((player.isMyAvatar) && (r.litePreference.data.dOptions["groundSelf"])))
                            {
                                if (((player.pMC) && (player.getItemByEquipSlot("mi"))))
                                {
                                    MovieClip(player.pMC).cShadow.visible = false;
                                    MovieClip(player.pMC).shadow.alpha = 1;
                                };
                            };
                        };
                    }
                    else
                    {
                        for each (player in r.world.avatars)
                        {
                            if (!((player.isMyAvatar) && (r.litePreference.data.dOptions["groundSelf"])))
                            {
                                if (((player.pMC) && (player.getItemByEquipSlot("mi"))))
                                {
                                    MovieClip(player.pMC).cShadow.visible = true;
                                    MovieClip(player.pMC).shadow.alpha = 0;
                                };
                            };
                        };
                    };
                    return;
                case "Show Your Ground Item Only":
                    r.litePreference.data.dOptions["groundSelf"] = (!(r.litePreference.data.dOptions["groundSelf"]));
                    r.litePreference.flush();
                    if (r.litePreference.data.bDisGround)
                    {
                        if (r.world.myAvatar.pMC)
                        {
                            MovieClip(r.world.myAvatar.pMC).cShadow.visible = true;
                            MovieClip(r.world.myAvatar.pMC).shadow.alpha = 0;
                        };
                    }
                    else
                    {
                        if (r.world.myAvatar.pMC)
                        {
                            MovieClip(r.world.myAvatar.pMC).cShadow.visible = false;
                            MovieClip(r.world.myAvatar.pMC).shadow.alpha = 1;
                        };
                    };
                    return;
                case "Hide Healing Bubbles":
                    r.litePreference.data.bDisHealBubble = (!(r.litePreference.data.bDisHealBubble));
                    r.litePreference.flush();
                    return;
            };
        }

        private static function dStartDrag(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.startDrag();
        }

        private static function dStopDrag(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.stopDrag();
        }


    }
}//package liteAssets.handlers

