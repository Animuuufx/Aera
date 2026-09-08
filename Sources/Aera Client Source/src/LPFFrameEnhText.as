// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameEnhText

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.text.*;

    public class LPFFrameEnhText extends LPFFrame 
    {

        public var mcStats:MovieClip;
        public var tDesc:TextField;
        private var iSel:Object;
        private var eSel:Object;
        private var iEnh:Object;
        private var eEnh:Object;
        private var rootClass:MovieClip;
        private var curItem:Object;
        internal var mcContainer:MovieClip;
        internal var boostsObj:Object;

        public function LPFFrameEnhText():void
        {
            mcStats.sproto.visible = false;
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            positionBy(_arg_1.r);
            iEnh = null;
            eEnh = null;
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            var _local_1:DisplayObject;
            while (mcStats.numChildren > 1)
            {
                _local_1 = mcStats.getChildAt(1);
                mcStats.removeChildAt(1);
            };
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        protected function fDraw():void
        {
            var _local_3:Object;
            var _local_4:String;
            var _local_5:Boolean;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:Object;
            var _local_16:int;
            var _local_17:int;
            var _local_1:* = "";
            var _local_2:* = "#00CCFF";
            if (iSel != null)
            {
                _local_1 = "<font size='10' color='#FFFFFF'>Enhancement: </font>";
                if (["Weapon", "he", "ar", "ba"].indexOf(iSel.sES) > -1)
                {
                    rootClass.world.initPatternTree();
                    iEnh = null;
                    eEnh = null;
                    if (iSel.PatternID != null)
                    {
                        iEnh = rootClass.world.enhPatternTree[iSel.PatternID];
                    };
                    if (iSel.EnhPatternID != null)
                    {
                        iEnh = rootClass.world.enhPatternTree[iSel.EnhPatternID];
                    };
                    if (eSel != null)
                    {
                        if (eSel.sES == iSel.sES)
                        {
                            if (eSel.PatternID != null)
                            {
                                eEnh = rootClass.world.enhPatternTree[eSel.PatternID];
                            };
                            if (eSel.EnhPatternID != null)
                            {
                                eEnh = rootClass.world.enhPatternTree[eSel.EnhPatternID];
                            };
                            _local_1 = (_local_1 + ((("<font size='11' color='" + _local_2) + "'>") + rootClass.getDisplayEnhName(eEnh)));
                            if (eSel.iRty > 1)
                            {
                                _local_1 = (_local_1 + (" +" + (eSel.iRty - 1)));
                            };
                            if ((((eEnh) && (eEnh.hasOwnProperty("DIS"))) && (eEnh["DIS"])))
                            {
                                _local_1 = (_local_1 + (", " + rootClass.getDisplayEnhTraitName(eEnh)));
                            };
                            _local_1 = (_local_1 + "</font>");
                            _local_1 = (_local_1 + "<font size='11' color='#FFFFFF'> vs. </font>");
                            _local_2 = "#999999";
                            if (iEnh != null)
                            {
                                if (iEnh.hasOwnProperty("DIS"))
                                {
                                    _local_1 = (_local_1 + (("<font size='11' color='" + _local_2) + "'>Forge"));
                                }
                                else
                                {
                                    _local_1 = (_local_1 + ((("<font size='11' color='" + _local_2) + "'>") + iEnh.sName));
                                };
                                if (iSel.EnhRty > 1)
                                {
                                    _local_1 = (_local_1 + (" +" + (iSel.EnhRty - 1)));
                                };
                                if (((iEnh.hasOwnProperty("DIS")) && (iEnh["DIS"])))
                                {
                                    _local_1 = (_local_1 + (", " + rootClass.getDisplayEnhTraitName(iEnh)));
                                };
                                _local_1 = (_local_1 + "</font>");
                            }
                            else
                            {
                                _local_1 = (_local_1 + "<font size='10' color='#00CCFF'>No enhancement</font>");
                            };
                        }
                        else
                        {
                            _local_1 = (_local_1 + "<font size='11' color='#00CCFF'>Enhancement type must match item slot!</font>");
                        };
                    }
                    else
                    {
                        if (iEnh != null)
                        {
                            _local_1 = (_local_1 + ((("<font size='10' color='" + _local_2) + "'>") + rootClass.getDisplayEnhName(iEnh)));
                            if ((("EnhRty" in iSel) && (iSel.EnhRty > 1)))
                            {
                                _local_1 = (_local_1 + (" +" + (iSel.EnhRty - 1)));
                            }
                            else
                            {
                                if (((("iRty" in iSel) && (iSel.iRty < 10)) && (iSel.iRty > 1)))
                                {
                                    _local_1 = (_local_1 + (" +" + (iSel.iRty - 1)));
                                };
                            };
                            if (((iSel.ProcID) && (!(iEnh.hasOwnProperty("DIS")))))
                            {
                                switch (iSel.ProcID)
                                {
                                    case 2:
                                        _local_4 = "Spiral Carve";
                                        break;
                                    case 3:
                                        _local_4 = "Awe Blast";
                                        break;
                                    case 4:
                                        _local_4 = "Health Vamp";
                                        break;
                                    case 5:
                                        _local_4 = "Mana Vamp";
                                        break;
                                    case 6:
                                        _local_4 = "Powerword DIE";
                                        break;
                                    case 7:
                                        _local_4 = "Lacerate";
                                        break;
                                    case 8:
                                        _local_4 = "Smite";
                                        break;
                                    case 9:
                                        _local_4 = "Valiance";
                                        break;
                                    case 10:
                                        _local_4 = "Arcana's Concerto";
                                        break;
                                    case 11:
                                        _local_4 = "Acheron";
                                        break;
                                    case 12:
                                        _local_4 = "Elysium";
                                        break;
                                    case 13:
                                        _local_4 = "Praxis";
                                        break;
                                    case 14:
                                        _local_4 = "Dauntless";
                                        break;
                                    case 15:
                                        _local_4 = "Ravenous";
                                        break;
                                    default:
                                        _local_4 = "Unknown";
                                };
                                _local_1 = (_local_1 + (", " + _local_4));
                            }
                            else
                            {
                                if (((iEnh.hasOwnProperty("DIS")) && (iEnh["DIS"])))
                                {
                                    _local_1 = (_local_1 + (", " + rootClass.getDisplayEnhTraitName(iEnh)));
                                };
                            };
                            _local_1 = (_local_1 + "</font>");
                        }
                        else
                        {
                            _local_1 = (_local_1 + "<font size='11' color='#00CCFF'>No enhancement</font>");
                        };
                    };
                    if (iSel.sType.toLowerCase() == "enhancement")
                    {
                        _local_1 = (_local_1 + " <font size='11' color='#FFFFFF'>imbues an item with: </font>");
                    };
                    _local_3 = rootClass.copyObj(iSel);
                    if (eSel != null)
                    {
                        _local_3 = rootClass.copyObj(eSel);
                        if (iSel != null)
                        {
                            _local_3.sType = iSel.sType;
                            if (("EnhRty" in iSel))
                            {
                                _local_3.EnhRty = iSel.EnhRty;
                            };
                            if (("iRng" in iSel))
                            {
                                _local_3.iRng = iSel.iRng;
                            }
                            else
                            {
                                _local_3.iRng = 10;
                            };
                        };
                    };
                    if (_local_3.sES.toLowerCase() == "weapon")
                    {
                        _local_5 = (_local_3.sType.toLowerCase() == "enhancement");
                        if (_local_5)
                        {
                            _local_6 = _local_3.iDPS;
                        }
                        else
                        {
                            if (("EnhDPS" in _local_3))
                            {
                                _local_6 = _local_3.EnhDPS;
                            }
                            else
                            {
                                if (((!(eSel == null)) && ("iDPS" in eSel)))
                                {
                                    _local_6 = eSel.iDPS;
                                }
                                else
                                {
                                    _local_6 = -1;
                                };
                            };
                        };
                        if (_local_6 == 0)
                        {
                            _local_6 = 100;
                        };
                        if (_local_6 == -1)
                        {
                            _local_6 = 100;
                        };
                        _local_6 = (_local_6 / 100);
                        _local_7 = (("iRng" in _local_3) ? _local_3.iRng : 0);
                        _local_7 = (_local_7 / 100);
                        _local_8 = 0;
                        if (("iRty" in _local_3))
                        {
                            _local_8 = (_local_3.iRty - 1);
                        };
                        if (("EnhRty" in _local_3))
                        {
                            _local_8 = (_local_3.EnhRty - 1);
                        };
                        if (_local_5)
                        {
                            _local_9 = _local_3.iLvl;
                        }
                        else
                        {
                            if (("EnhLvl" in _local_3))
                            {
                                _local_9 = _local_3.EnhLvl;
                            }
                            else
                            {
                                if (((!(eSel == null)) && ("iLvl" in eSel)))
                                {
                                    _local_9 = eSel.iLvl;
                                }
                                else
                                {
                                    _local_9 = iSel.iLvl;
                                };
                            };
                        };
                        _local_10 = rootClass.getBaseHPByLevel((_local_9 + _local_8));
                        _local_11 = 20;
                        _local_12 = 2;
                        _local_13 = Math.round((((_local_10 / _local_11) * _local_6) * rootClass.PCDPSMod));
                        _local_14 = Math.round((_local_13 * _local_12));
                        _local_15 = rootClass.world.getAutoAttack();
                        _local_14 = (_local_14 * _local_15.damage);
                        _local_16 = Math.floor((_local_14 - (_local_14 * _local_7)));
                        _local_17 = Math.ceil((_local_14 + (_local_14 * _local_7)));
                        if (((_local_3.sType.toLowerCase() == "enhancement") || (("EnhLvl" in _local_3) || (!(eSel == null)))))
                        {
                            _local_1 = (_local_1 + (("<br><font color='#FFFFFF'>" + _local_13) + " DPS"));
                        };
                        if (((!(_local_3.sType.toLowerCase() == "enhancement")) && (("EnhLvl" in _local_3) || (!(eSel == null)))))
                        {
                            _local_1 = (_local_1 + ((((((" ( <font color='#999999'>" + _local_16) + "-") + _local_17) + ", ") + rootClass.numToStr((_local_15.cd / 1000), 1)) + " speed</font> )</font>"));
                        };
                    };
                }
                else
                {
                    _local_1 = (_local_1 + "<font size='10' color='#00CCFF'>This item cannot be enhanced.</font>");
                    if (((((iSel.sES == "pe") || (iSel.sES == "co")) || (iSel.sES == "am")) || (((iSel.sType.toLowerCase() == "item") && (!(iSel.sLink == null))) && (!(iSel.sLink == "")))))
                    {
                    };
                };
                tDesc.htmlText = _local_1;
                showStats();
            }
            else
            {
                if (((!(MovieClip(getLayout()).iSel == null)) && (!(rootClass.doIHaveEnhancements()))))
                {
                    tDesc.htmlText = "<font color='#FF0000'>You need an Enhancement!</font><br>";
                    tDesc.htmlText = (tDesc.htmlText + "<font color='#FFFFFF'>No enhancments for this type of item were found in your backpack. Enhancements are used to power up your item. You can buy at shops or find them on monsters.</font>");
                }
                else
                {
                    tDesc.htmlText = "No item selected.";
                };
                showStats();
            };
            tDesc.x = 2;
            tDesc.y = 7;
            mcStats.x = 13;
            tDesc.y--;
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType != "showItemListB")
            {
                if (_arg_1.eventType == "refreshItems")
                {
                    if (((!(iSel == _arg_1.fData.iSel)) && (!(iSel == _arg_1.fData.eSel))))
                    {
                        iSel = null;
                        eSel = null;
                    };
                }
                else
                {
                    if (_arg_1.eventType == "clearState")
                    {
                        iSel = null;
                        eSel = null;
                    }
                    else
                    {
                        iSel = _arg_1.fData.iSel;
                        eSel = _arg_1.fData.eSel;
                        if (((iSel == null) && (!(eSel == null))))
                        {
                            iSel = eSel;
                            eSel = null;
                        };
                    };
                };
            };
            fDraw();
        }

        private function showStats():void
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_4:int;
            var _local_10:MovieClip;
            var _local_11:Object;
            var _local_12:Boolean;
            var _local_13:Array;
            var _local_14:MovieClip;
            var _local_15:String;
            var _local_16:*;
            var _local_17:int;
            var _local_18:*;
            var _local_19:String;
            var _local_20:MovieClip;
            var _local_21:MovieClip;
            var _local_22:MovieClip;
            var _local_23:MovieClip;
            var _local_24:MovieClip;
            var _local_25:MovieClip;
            while (mcStats.numChildren > 1)
            {
                mcStats.removeChildAt(1);
            };
            mcStats.sproto.x = 0;
            mcStats.sproto.y = (tDesc.textHeight + 8);
            var _local_1:* = (!(eSel == null));
            _local_4 = 0;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:* = "";
            var _local_9:Class = (mcStats.sproto.constructor as Class);
            if (((!(iSel == null)) && ((((!(iEnh == null)) || (!(eEnh == null))) && ((eSel == null) || (eSel.sES == iSel.sES))) || ((_local_1) && (eSel.sES == iSel.sES)))))
            {
                if (((_local_1) && (!(iEnh == null))))
                {
                    _local_2 = rootClass.getStatsA(eSel, iSel.sES);
                    _local_3 = rootClass.getStatsA(iSel, iSel.sES);
                }
                else
                {
                    _local_11 = rootClass.copyObj(iSel);
                    if (_local_1)
                    {
                        _local_11.EnhPatternID = eSel.PatternID;
                        _local_11.EnhLvl = eSel.iLvl;
                        _local_11.EnhRty = eSel.iRty;
                        _local_1 = false;
                    };
                    _local_2 = rootClass.getStatsA(_local_11, iSel.sES);
                };
                _local_4 = 0;
                while (_local_4 < rootClass.orderedStats.length)
                {
                    _local_8 = rootClass.orderedStats[_local_4];
                    _local_7 = 0;
                    if ((((_local_1) && (!(_local_3[("$" + _local_8)] == null))) && (_local_2[("$" + _local_8)] == null)))
                    {
                        _local_2[("$" + _local_8)] = 0;
                    };
                    if (_local_2[("$" + _local_8)] != null)
                    {
                        _local_10 = new (_local_9)();
                        _local_6 = _local_2[("$" + _local_8)];
                        _local_10.tSta.text = rootClass.getFullStatName(_local_8).toUpperCase();
                        _local_10.tOldval.visible = false;
                        if (_local_1)
                        {
                            if (_local_3[("$" + _local_8)] != null)
                            {
                                _local_7 = _local_3[("$" + _local_8)];
                            };
                            _local_10.tOldval.text = (("(" + _local_7) + ")");
                            _local_10.tOldval.visible = true;
                            _local_10.tVal.text = _local_6;
                        }
                        else
                        {
                            _local_10.tVal.text = _local_6;
                        };
                        _local_10.tOldval.x = ((_local_10.tVal.x + _local_10.tVal.textWidth) + 3);
                        _local_10.x = (mcStats.sproto.x + ((_local_5 % 3) * 100));
                        _local_10.y = (mcStats.sproto.y + (Math.floor((_local_5 / 3)) * 16));
                        _local_10.hit.alpha = 0;
                        _local_10.name = ("t" + _local_8);
                        mcStats.addChild(_local_10);
                        _local_5++;
                    };
                    _local_4++;
                };
                mcStats.visible = true;
            }
            else
            {
                mcStats.visible = false;
            };
            if (((mcContainer) && (getChildByName("mcContainer"))))
            {
                removeChild(getChildByName("mcContainer"));
            };
            if (((mcContainer) && (mcStats.getChildByName("mcContainer"))))
            {
                mcStats.removeChild(mcStats.getChildByName("mcContainer"));
            };
            if (((((!(iSel == null)) && (!(iSel.sMeta == null))) && (!(iSel.sMeta is Number))) && (iSel.sMeta.indexOf(":") > -1)))
            {
                _local_12 = false;
                switch (iSel.sES)
                {
                    case "he":
                    case "ba":
                    case "Weapon":
                    case "pe":
                    case "co":
                    case "mi":
                        _local_12 = true;
                        break;
                };
                if (!_local_12)
                {
                    return;
                };
                boostsObj = {};
                mcContainer = new boostsContainer();
                iEnh = null;
                if (iSel.PatternID != null)
                {
                    iEnh = rootClass.world.enhPatternTree[iSel.PatternID];
                };
                if (iSel.EnhPatternID != null)
                {
                    iEnh = rootClass.world.enhPatternTree[iSel.EnhPatternID];
                };
                if (iEnh)
                {
                    mcStats.addChild(mcContainer);
                    mcContainer.name = "mcContainer";
                    mcContainer.x = -13;
                    mcContainer.y = (mcStats.height - 8);
                }
                else
                {
                    addChild(mcContainer);
                    mcContainer.name = "mcContainer";
                    mcContainer.x = -2;
                    mcContainer.y = 20;
                };
                while (mcContainer.numChildren > 0)
                {
                    mcContainer.removeChildAt(0);
                };
                _local_13 = iSel.sMeta.split(",");
                _local_14 = new damageBoost();
                if (!boostsObj["dmgBoost"])
                {
                    boostsObj["dmgBoost"] = "";
                };
                for each (_local_16 in _local_13)
                {
                    _local_19 = _local_16.split(":")[1];
                    _local_15 = Math.round(((Number(_local_19) - 1) * 100)).toString();
                    switch (_local_16.split(":")[0].toLowerCase())
                    {
                        case "dmgall":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("All +" + _local_15) + "%\n"));
                            break;
                        case "undead":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Undead +" + _local_15) + "%\n"));
                            break;
                        case "human":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Human +" + _local_15) + "%\n"));
                            break;
                        case "chaos":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Chaos +" + _local_15) + "%\n"));
                            break;
                        case "dragonkin":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Dragonkin +" + _local_15) + "%\n"));
                            break;
                        case "orc":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Orc +" + _local_15) + "%\n"));
                            break;
                        case "drakath":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Drakath +" + _local_15) + "%\n"));
                            break;
                        case "elemental":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Elemental +" + _local_15) + "%\n"));
                            break;
                        case "cp":
                            boostsObj["classBoost"] = (("Class Points +" + _local_15) + "%");
                            break;
                        case "gold":
                            boostsObj["goldBoost"] = (("Gold +" + _local_15) + "%");
                            break;
                        case "rep":
                            boostsObj["repBoost"] = (("Reputation +" + _local_15) + "%");
                            break;
                        case "exp":
                            boostsObj["xpBoost"] = (("Experience +" + _local_15) + "%");
                            break;
                    };
                };
                _local_17 = 30;
                for (_local_18 in boostsObj)
                {
                    switch (_local_18)
                    {
                        case "dmgBoost":
                            if (boostsObj[_local_18] == "") break;
                            mcContainer.addChild(_local_14);
                            _local_14.width = _local_17;
                            _local_14.height = _local_17;
                            _local_14.name = "dmgBoost";
                            _local_14.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                            _local_14.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                            break;
                        case "classBoost":
                            _local_20 = new classBoost();
                            mcContainer.addChild(_local_20);
                            _local_20.width = _local_17;
                            _local_20.height = _local_17;
                            _local_20.name = "classBoost";
                            _local_20.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                            _local_20.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                            break;
                        case "goldBoost":
                            _local_21 = new goldBoost();
                            mcContainer.addChild(_local_21);
                            _local_21.width = _local_17;
                            _local_21.height = _local_17;
                            _local_21.name = "goldBoost";
                            _local_21.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                            _local_21.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                            break;
                        case "repBoost":
                            _local_22 = new repBoost();
                            mcContainer.addChild(_local_22);
                            _local_22.width = _local_17;
                            _local_22.height = _local_17;
                            _local_22.name = "repBoost";
                            _local_22.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                            _local_22.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                            break;
                        case "xpBoost":
                            _local_23 = new xpBoost();
                            mcContainer.addChild(_local_23);
                            _local_23.width = _local_17;
                            _local_23.height = _local_17;
                            _local_23.name = "xpBoost";
                            _local_23.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                            _local_23.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                            break;
                    };
                };
                _local_4 = 0;
                while (_local_4 < mcContainer.numChildren)
                {
                    _local_24 = (mcContainer.getChildAt(_local_4) as MovieClip);
                    _local_24.x = ((_local_4 * _local_24.width) + 2);
                    _local_4++;
                };
                if (mcContainer.numChildren > 0)
                {
                    _local_25 = new btnMoreInfo();
                    _local_25.addEventListener(MouseEvent.CLICK, onBoostsInfo, false, 0, true);
                    mcContainer.addChild(_local_25);
                    _local_25.x = ((mcContainer.getChildAt((mcContainer.numChildren - 2)).x + mcContainer.getChildAt((mcContainer.numChildren - 2)).width) + 3);
                    _local_25.y = ((_local_25.height / 4) + 2);
                };
            };
        }

        private function onBoostsInfo(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://www.aq.com/lore/Guides/AQWBoosts"), "_blank");
        }

        private function onBoostGet(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name;
            rootClass.ui.ToolTip.openWith({"str":boostsObj[_local_2]});
        }

        private function onBoostOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        private function onTTFieldMouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name;
            var _local_3:* = "";
            switch (_local_2)
            {
                case "tAP":
                    _local_3 = "Attack Power increases the effectiveness of your physical damage attacks.";
                    break;
                case "tSP":
                    _local_3 = "Magic Power increases the effectiveness of your magical damage attacks.";
                    break;
                case "tDmg":
                    _local_3 = "This is the damage you would expect to see on a normal melee hit, before any other modifiers.";
                    break;
                case "tHP":
                    _local_3 = "Your total Hit Points.  When these reach zero, you will need to wait a short time before being able to continue playing.";
                    break;
                case "tHitTF":
                    _local_3 = "Hit chance determines how likely you are to hit a target, before any other modifiers.";
                    break;
                case "tHasteTF":
                    _local_3 = "Haste reduces the cooldown on all of your attacks and spells, including Auto Attack, by a certain percentage (hard capped at 50%).";
                    break;
                case "tCritTF":
                    _local_3 = "Critical Strike chance increases the likelihood of dealing additional damage on a any attack.";
                    break;
                case "tDodgeTF":
                    _local_3 = "Evasion chance allows you to completely avoid incoming damage.";
                    break;
                case "tSTR":
                case "sl1":
                    _local_3 = "Strength increases Attack Power, which boosts physical damage. It also improves Critical Strike chance for melee classes.";
                    break;
                case "tINT":
                case "sl2":
                    _local_3 = "Intellect increases Magic Power, which boosts magical damage. It also improve Critical Strike chance for caster classes.";
                    break;
                case "tEND":
                case "sl3":
                    _local_3 = "Endurance directly contributes to your total Hit Points.  While very useful for all classes, some abilities work best with very high or very low total HP.";
                    break;
                case "tDEX":
                case "sl4":
                    _local_3 = "Dexterity is valuable to melee classes. It increases Haste, Hit chance, and Evasion chance. It increases only Evasion chance for caster classes.";
                    break;
                case "tWIS":
                case "sl5":
                    _local_3 = "Wisdom is valuable to caster classes. It increases Hit chance, Crit chance, and Evasion chance. It improves only Evasion chance for melee classes.";
                    break;
                case "tLCK":
                case "sl6":
                    _local_3 = "Luck increases your Critical Strike modifier value directly, and may have effects outside of combat.";
                    break;
            };
            rootClass.ui.ToolTip.openWith({"str":_local_3});
        }

        private function onTTFieldMouseOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }


    }
}//package 

