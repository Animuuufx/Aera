// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.statsPanel

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.text.TextFormat;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.getQualifiedClassName;

    public dynamic class statsPanel extends MovieClip 
    {

        public var btnHelp:MovieClip;
        public var tName:TextField;
        public var bContainer:MovieClip;
        public var tCombat2:TextField;
        public var tCombat1:TextField;
        public var btnExit:MovieClip;
        public var bg:MovieClip;
        public var btnHelp2:MovieClip;
        public var tCat:TextField;
        public var btnHelp3:MovieClip;
        public var tMod:TextField;
        public var tStats:TextField;
        public var tCore:TextField;
        private var r:MovieClip;
        private var world:MovieClip;
        internal var tt:MovieClip;
        private var allocated:Object;
        private var nextMode:String;
        private var uoLeaf:Object;
        private var uoData:Object;
        private var stp:Object;
        private var stg:Object;
        internal var tStatVals:Array = ["STR", "INT", "DEX", "END", "WIS", "LCK"];
        internal var tStatFormats:Array = [];
        internal var tFormats:Array = [];
        internal var tValues:Array = ["$cai", "$cao", "$cpi", "$cpo", "$cmi", "$cmo", "$chi", "$cho", "$cdi", "$cdo", "$cmc"];
        internal var tCombatFormats1:Array = [];
        internal var tCombatFormats2:Array = [];
        internal var tCombat1Vals:Array = ["$ap", "$sp", "$thi", "$tha"];
        internal var tCombat2Vals:Array = ["$tcr", "$scm", "$tdo"];
        internal var boostsObj:Object = {};

        // Aera persistent stat-point allocator. The artwork and timeline fields live
        // in the FLA; this class only binds behavior/data to those existing assets.
        private const statPointKeys:Array = ["Strength", "Intellect", "Dexterity", "Endurance", "Wisdom", "Luck"];
        private const statPointCodes:Array = ["STR", "INT", "DEX", "END", "WIS", "LCK"];
        private var serverStatPoints:int = 0;
        private var serverAllocatedStats:Object = {};
        private var pendingStats:Object = {};
        private var statPlusButtons:Array = [];
        private var statMinusButtons:Array = [];
        private var statSaveButton:MovieClip;
        private var statResetButton:MovieClip;
        private var statControlsReady:Boolean = false;

        public function statsPanel(_arg_1:MovieClip)
        {
            r = _arg_1;
            world = r.world;
            uoLeaf = world.myLeaf();
            uoData = world.myAvatar.objData;
            stp = new Object();
            stg = new Object();
            this.addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_UP, onStop, false, 0, true);
            this.btnHelp.addEventListener(MouseEvent.CLICK, onHelp, false, 0, true);
            this.btnHelp2.addEventListener(MouseEvent.CLICK, onHelp, false, 0, true);
            this.btnHelp3.addEventListener(MouseEvent.CLICK, onHelp, false, 0, true);
            this.btnExit.addEventListener(MouseEvent.CLICK, onExit, false, 0, true);
            tName.mouseEnabled = false;
            tCat.mouseEnabled = false;
            updateBoosts();
        }

        public function onHelp(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
        }

        public function cleanup():void
        {
            var _local_1:MovieClip;
            cleanupStatPointControls();
            if (parent != null)
            {
                _local_1 = MovieClip(parent);
                _local_1.removeChild(this);
                r.stage.focus = null;
            };
        }

        public function onExit(_arg_1:MouseEvent):void
        {
            cleanup();
        }

        public function onStage(_arg_1:Event):void
        {
            updateBase();
            update();
            setupStatPointControls();
            this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
            tt = new ToolTipMC(r);
            addChild(tt);
        }

        /**
         * Bind the +/- / SAVE / RESET assets already present in the user's FLA.
         * We intentionally discover controls by both instance name and generated
         * timeline class name, so the FLA does not need new instance names on all
         * twelve small +/- buttons.
         */
        private function setupStatPointControls():void
        {
            var i:int;
            var mc:MovieClip;
            var index:int;

            if (statControlsReady)
            {
                return;
            }
            statControlsReady = true;

            // The stat allocation controls are MovieClips, not Button symbols.
            // Force mouse input back on for the panel and its nested controls.
            this.mouseEnabled = true;
            this.mouseChildren = true;

            resetPendingStats();
            loadStatPointDataFromAvatar();
            statPlusButtons = [];
            statMinusButtons = [];
            statSaveButton = null;
            statResetButton = null;

            discoverStatPointControls(this);
            sortStatButtonsByY(statPlusButtons);
            sortStatButtonsByY(statMinusButtons);

            i = 0;
            while ((i < statPlusButtons.length) && (i < statPointKeys.length))
            {
                mc = statPlusButtons[i] as MovieClip;
                if (mc != null)
                {
                    index = (("aeraStatIndex" in mc) ? int(mc["aeraStatIndex"]) : i);
                    mc["aeraStatIndex"] = index;
                    mc.mouseEnabled = true;
                    mc.mouseChildren = false;
                    mc.buttonMode = true;
                    mc.useHandCursor = true;
                    // Use MOUSE_DOWN instead of CLICK because the stats window itself
                    // is draggable and can otherwise swallow the completed click.
                    mc.addEventListener(MouseEvent.MOUSE_DOWN, onStatPlus, false, 1000, true);
                    trace("[Aera Stats] bound + " + mc.name + " -> " + statPointKeys[index]);
                }
                i++;
            }

            i = 0;
            while ((i < statMinusButtons.length) && (i < statPointKeys.length))
            {
                mc = statMinusButtons[i] as MovieClip;
                if (mc != null)
                {
                    index = (("aeraStatIndex" in mc) ? int(mc["aeraStatIndex"]) : i);
                    mc["aeraStatIndex"] = index;
                    mc.mouseEnabled = true;
                    mc.mouseChildren = false;
                    mc.buttonMode = true;
                    mc.useHandCursor = true;
                    mc.addEventListener(MouseEvent.MOUSE_DOWN, onStatMinus, false, 1000, true);
                    trace("[Aera Stats] bound - " + mc.name + " -> " + statPointKeys[index]);
                }
                i++;
            }

            if (statSaveButton != null)
            {
                statSaveButton.mouseEnabled = true;
                statSaveButton.mouseChildren = false;
                statSaveButton.buttonMode = true;
                statSaveButton.useHandCursor = true;
                statSaveButton.addEventListener(MouseEvent.MOUSE_DOWN, onStatSave, false, 1000, true);
                trace("[Aera Stats] bound SAVE " + statSaveButton.name);
            }
            if (statResetButton != null)
            {
                statResetButton.mouseEnabled = true;
                statResetButton.mouseChildren = false;
                statResetButton.buttonMode = true;
                statResetButton.useHandCursor = true;
                statResetButton.addEventListener(MouseEvent.MOUSE_DOWN, onStatReset, false, 1000, true);
                trace("[Aera Stats] bound RESET " + statResetButton.name);
            }

            renderStatPointUI();
        }

        private function discoverStatPointControls(container:DisplayObjectContainer):void
        {
            var i:int;
            var child:DisplayObject;
            var mc:MovieClip;
            var instanceName:String;
            var id:String;
            var statIndex:int;

            if (container == null)
            {
                return;
            }

            // A parent MovieClip with mouseChildren=false prevents every nested
            // +/- MovieClip from ever receiving a mouse event.
            if (container is MovieClip)
            {
                MovieClip(container).mouseEnabled = true;
                MovieClip(container).mouseChildren = true;
            }

            i = 0;
            while (i < container.numChildren)
            {
                child = container.getChildAt(i);
                if (child is MovieClip)
                {
                    mc = child as MovieClip;
                    mc.mouseEnabled = true;

                    instanceName = ((mc.name == null) ? "" : mc.name);
                    id = instanceName.toLowerCase();

                    // Bind the exact instance names used by the Aera FLA:
                    // btnSTR / btnINT / btnDEX / btnEND / btnWIS / btnLCK (or btnLUK)
                    // and btnMinusSTR / btnMinusINT / ...
                    statIndex = statIndexFromInstanceName(instanceName, false);
                    if (statIndex >= 0)
                    {
                        mc["aeraStatIndex"] = statIndex;
                        pushUniqueMovieClip(statPlusButtons, mc);
                    }
                    else
                    {
                        statIndex = statIndexFromInstanceName(instanceName, true);
                        if (statIndex >= 0)
                        {
                            mc["aeraStatIndex"] = statIndex;
                            pushUniqueMovieClip(statMinusButtons, mc);
                        }
                        else if ((id == "btnsave") || (id == "btnsavestats") || (id == "btnsavestat") || (id.indexOf("savestats") > -1) || (id.indexOf("savestatbutton") > -1))
                        {
                            statSaveButton = mc;
                        }
                        else if ((id == "btnreset") || (id == "btnresetstats") || (id == "btnresetstat") || (id.indexOf("resetstats") > -1) || (id.indexOf("resetstatbutton") > -1))
                        {
                            statResetButton = mc;
                        }
                        else
                        {
                            // Backward-compatible fallback for older FLA library names.
                            try
                            {
                                id = (id + " " + getQualifiedClassName(mc).toLowerCase());
                            }
                            catch(e:Error)
                            {
                            }
                            if ((id.indexOf("addstat") > -1) || (id.indexOf("plusstat") > -1))
                            {
                                pushUniqueMovieClip(statPlusButtons, mc);
                            }
                            else if ((((id.indexOf("minus") > -1) || (id.indexOf("minut") > -1)) && (id.indexOf("stat") > -1)))
                            {
                                pushUniqueMovieClip(statMinusButtons, mc);
                            }
                            else if ((id.indexOf("savestats") > -1) || (id.indexOf("savestatbutton") > -1))
                            {
                                statSaveButton = mc;
                            }
                            else if ((id.indexOf("resetstats") > -1) || (id.indexOf("resetstatbutton") > -1))
                            {
                                statResetButton = mc;
                            }
                        }
                    }

                    discoverStatPointControls(mc);
                }
                i++;
            }
        }

        private function statIndexFromInstanceName(rawName:String, minus:Boolean):int
        {
            var n:String = ((rawName == null) ? "" : rawName.toLowerCase());
            var prefix:String = (minus ? "btnminus" : "btn");
            var code:String;

            if (n.indexOf(prefix) != 0)
            {
                return -1;
            }
            code = n.substr(prefix.length);

            switch (code)
            {
                case "str":
                case "strength":
                    return 0;
                case "int":
                case "intellect":
                    return 1;
                case "dex":
                case "dexterity":
                    return 2;
                case "end":
                case "endurance":
                    return 3;
                case "wis":
                case "wisdom":
                    return 4;
                case "lck":
                case "luk":
                case "luck":
                    return 5;
            }
            return -1;
        }

        private function pushUniqueMovieClip(list:Array, mc:MovieClip):void
        {
            if ((mc != null) && (list.indexOf(mc) < 0))
            {
                list.push(mc);
            }
        }

        private function sortStatButtonsByY(list:Array):void
        {
            var panel:statsPanel = this;
            list.sort(function(a:MovieClip, b:MovieClip):Number
            {
                var ay:Number;
                var by:Number;
                try
                {
                    ay = a.getBounds(panel).y;
                    by = b.getBounds(panel).y;
                }
                catch(e:Error)
                {
                    ay = a.y;
                    by = b.y;
                }
                if (ay < by) return -1;
                if (ay > by) return 1;
                return 0;
            });
        }

        private function stopStatButtonDrag(e:MouseEvent):void
        {
            e.stopPropagation();
        }

        private function onStatPlus(e:MouseEvent):void
        {
            var mc:MovieClip = e.currentTarget as MovieClip;
            var index:int;
            var key:String;
            e.stopPropagation();
            if ((mc == null) || (!("aeraStatIndex" in mc)) || (remainingStatPoints() <= 0))
            {
                return;
            }
            index = int(mc["aeraStatIndex"]);
            if ((index < 0) || (index >= statPointKeys.length))
            {
                return;
            }
            key = statPointKeys[index];
            pendingStats[key] = (int(pendingStats[key]) + 1);
            renderStatPointUI();
        }

        private function onStatMinus(e:MouseEvent):void
        {
            var mc:MovieClip = e.currentTarget as MovieClip;
            var index:int;
            var key:String;
            e.stopPropagation();
            if ((mc == null) || (!("aeraStatIndex" in mc)))
            {
                return;
            }
            index = int(mc["aeraStatIndex"]);
            if ((index < 0) || (index >= statPointKeys.length))
            {
                return;
            }
            key = statPointKeys[index];
            // Minus only removes points staged since the last SAVE. Already-saved
            // database allocations are refunded by RESET, matching Aera's rules.
            if (int(pendingStats[key]) > 0)
            {
                pendingStats[key] = (int(pendingStats[key]) - 1);
                renderStatPointUI();
            }
        }

        private function onStatSave(e:MouseEvent):void
        {
            var args:Array;
            e.stopPropagation();
            if ((r == null) || (r.sfc == null))
            {
                return;
            }
            args = [
                int(pendingStats.Strength),
                int(pendingStats.Intellect),
                int(pendingStats.Dexterity),
                int(pendingStats.Endurance),
                int(pendingStats.Wisdom),
                int(pendingStats.Luck)
            ];
            // Do not clear pending values here. The saveStatPoints ACK is authoritative
            // and Game.as clears them only after the database transaction succeeds.
            r.sfc.sendXtMessage("zm", "saveStatPoints", args, "str", 1);
        }

        private function onStatReset(e:MouseEvent):void
        {
            e.stopPropagation();
            if ((r == null) || (r.sfc == null))
            {
                return;
            }
            // RESET means refund every already-saved allocation. Pending unsaved edits
            // are discarded locally while the server performs the persistent refund.
            resetPendingStats();
            renderStatPointUI();
            r.sfc.sendXtMessage("zm", "resetStatPoints", [], "str", 1);
        }

        private function loadStatPointDataFromAvatar():void
        {
            var source:Object;
            var key:String;
            if ((uoData != null) && ("stats" in uoData) && (uoData.stats != null))
            {
                source = uoData.stats;
                serverStatPoints = ((source.StatPoints != null) ? Math.max(0, int(source.StatPoints)) : 0);
                for each (key in statPointKeys)
                {
                    serverAllocatedStats[key] = ((source[key] != null) ? Math.max(0, int(source[key])) : 0);
                }
            }
            else
            {
                serverStatPoints = 0;
                for each (key in statPointKeys)
                {
                    serverAllocatedStats[key] = 0;
                }
            }
        }

        /** Called by Game.as when a stu/save/reset packet supplies database truth. */
        public function syncStatPointData(points:*, allocatedStats:Object, clearPending:Boolean=false):void
        {
            var key:String;
            if (points != null)
            {
                serverStatPoints = Math.max(0, int(points));
            }
            if (allocatedStats != null)
            {
                for each (key in statPointKeys)
                {
                    if ((key in allocatedStats) && (allocatedStats[key] != null))
                    {
                        serverAllocatedStats[key] = Math.max(0, int(allocatedStats[key]));
                    }
                }
            }
            if (clearPending)
            {
                resetPendingStats();
            }

            if (uoData != null)
            {
                if (((!("stats" in uoData)) || (uoData.stats == null)))
                {
                    uoData.stats = {};
                }
                uoData.stats.StatPoints = serverStatPoints;
                for each (key in statPointKeys)
                {
                    uoData.stats[key] = int(serverAllocatedStats[key]);
                }
            }
            renderStatPointUI();
        }

        private function resetPendingStats():void
        {
            var key:String;
            pendingStats = {};
            for each (key in statPointKeys)
            {
                pendingStats[key] = 0;
            }
        }

        private function pendingStatTotal():int
        {
            var key:String;
            var total:int = 0;
            for each (key in statPointKeys)
            {
                total = (total + Math.max(0, int(pendingStats[key])));
            }
            return total;
        }

        private function remainingStatPoints():int
        {
            return Math.max(0, (serverStatPoints - pendingStatTotal()));
        }

        private function renderStatPointUI():void
        {
            var pointsField:TextField;
            var statField:TextField;
            var i:int;
            var key:String;
            var code:String;

            pointsField = findTimelineTextField("txtStatPoints");
            if (pointsField != null)
            {
                // The user's FLA already contains the static "Remaining:" label.
                pointsField.text = String(remainingStatPoints());
            }

            i = 0;
            while (i < statPointKeys.length)
            {
                key = statPointKeys[i];
                code = statPointCodes[i];
                statField = findTimelineTextField(("txt" + code));
                if (statField == null)
                {
                    statField = findTimelineTextField(("txt" + key));
                }
                if (statField != null)
                {
                    statField.text = String((int(serverAllocatedStats[key]) + int(pendingStats[key])));
                }
                i++;
            }
        }

        private function findTimelineTextField(targetName:String):TextField
        {
            return findTimelineTextFieldIn(this, targetName);
        }

        private function findTimelineTextFieldIn(container:DisplayObjectContainer, targetName:String):TextField
        {
            var i:int;
            var child:DisplayObject;
            var nested:TextField;
            if (container == null)
            {
                return null;
            }
            i = 0;
            while (i < container.numChildren)
            {
                child = container.getChildAt(i);
                if ((child is TextField) && (child.name == targetName))
                {
                    return child as TextField;
                }
                if (child is DisplayObjectContainer)
                {
                    nested = findTimelineTextFieldIn(child as DisplayObjectContainer, targetName);
                    if (nested != null)
                    {
                        return nested;
                    }
                }
                i++;
            }
            return null;
        }

        private function cleanupStatPointControls():void
        {
            var mc:MovieClip;
            for each (mc in statPlusButtons)
            {
                if (mc != null)
                {
                    mc.removeEventListener(MouseEvent.MOUSE_DOWN, onStatPlus);
                }
            }
            for each (mc in statMinusButtons)
            {
                if (mc != null)
                {
                    mc.removeEventListener(MouseEvent.MOUSE_DOWN, onStatMinus);
                }
            }
            if (statSaveButton != null)
            {
                statSaveButton.removeEventListener(MouseEvent.MOUSE_DOWN, onStatSave);
            }
            if (statResetButton != null)
            {
                statResetButton.removeEventListener(MouseEvent.MOUSE_DOWN, onStatReset);
            }
            statControlsReady = false;
        }

        private function getCatDefinition():String
        {
            switch (uoData.sClassCat)
            {
                case "M1":
                    return ("Tank Melee");
                case "M2":
                    return ("Dodge Melee");
                case "M3":
                    return ("Full Hybrid");
                case "M4":
                    return ("Power Melee");
                case "C1":
                    return ("Offensive Caster");
                case "C2":
                    return ("Defensive Caster");
                case "C3":
                    return ("Power Caster");
                case "S1":
                    return ("Luck Hybrid");
                default:
                    return ("Adventurer");
            };
        }

        private function buildStu():void
        {
            var _local_5:String;
            var _local_6:String;
            var _local_1:Object = r.getCategoryStats(uoData.sClassCat, uoLeaf.intLevel);
            var _local_2:* = "";
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < r.stats.length)
            {
                _local_2 = r.stats[_local_3];
                stg[("^" + _local_2)] = 0;
                stp[("_" + _local_2)] = Math.floor(_local_1[_local_2]);
                _local_3++;
            };
            var _local_4:* = world.uoTree[r.sfc.myUserName.toLowerCase()];
            for (_local_5 in _local_4.tempSta)
            {
                if (_local_5 != "innate")
                {
                    for (_local_6 in _local_4.tempSta[_local_5])
                    {
                        if (stg[("^" + _local_6)] == null)
                        {
                            stg[("^" + _local_6)] = 0;
                        };
                        stg[("^" + _local_6)] = (stg[("^" + _local_6)] + int(_local_4.tempSta[_local_5][_local_6]));
                    };
                };
            };
        }

        private function fixValues(_arg_1:String, _arg_2:Number):Array
        {
            var _local_3:Array = [((((_arg_1 == "$chi") || (_arg_1 == "$cmc")) || (_arg_1 == "$tha")) ? r.coeffToPct(_arg_2) : r.coeffToPct((_arg_2 - 1)))];
            switch (_arg_1)
            {
                case "$cai":
                    _local_3[0] = (_local_3[0] * -1);
                    return ((_arg_2 <= 0.2) ? [r.coeffToPct((1 - 0.2)), "*"] : _local_3);
                case "$cao":
                    return ((_arg_2 <= 0.1) ? [r.coeffToPct((0.1 - 1)), "*"] : _local_3);
                case "$tha":
                    return ((_arg_2 >= 0.5) ? [r.coeffToPct((1 - 0.5)), "*"] : _local_3);
                case "$cpi":
                    _local_3[0] = (_local_3[0] * -1);
                    return ((_arg_2 <= 0.2) ? [r.coeffToPct((1 - 0.2)), "*"] : _local_3);
                case "$cmi":
                    _local_3[0] = (_local_3[0] * -1);
                    return ((_arg_2 <= 0.2) ? [r.coeffToPct((1 - 0.2)), "*"] : _local_3);
                case "$cmo":
                    return ((_arg_2 <= 0.2) ? [r.coeffToPct((1 - 0.1)), "*"] : _local_3);
                case "$cdi":
                    _local_3[0] = (_local_3[0] * -1);
                    return (_local_3);
            };
            return (_local_3);
        }

        private function determineColor(_arg_1:String, _arg_2:Number):*
        {
            if (!allocated[_arg_1])
            {
                allocated[_arg_1] = _arg_2;
                return (0xCCCCCC);
            };
            var _local_3:Number = (fixValues(_arg_1, _arg_2)[0] - 1);
            var _local_4:Number = (fixValues(_arg_1, allocated[_arg_1])[0] - 1);
            if (_arg_1 == "$cmc")
            {
                _local_3 = (_local_3 * -1);
                _local_4 = (_local_4 * -1);
            };
            if (_local_3 < _local_4)
            {
                return (0x666666);
            };
            if (_local_3 > _local_4)
            {
                return (0xCC9900);
            };
            return (0xCCCCCC);
        }

        private function determineStatColor(_arg_1:String, _arg_2:Number):*
        {
            var _local_3:Number = (stp[("_" + _arg_1)] + stg[("^" + _arg_1)]);
            var _local_4:Number = _arg_2;
            if (_local_3 > _local_4)
            {
                return (0x666666);
            };
            if (_local_3 < _local_4)
            {
                return (0xCC9900);
            };
            return (0xCCCCCC);
        }

        private function allocateBaseValues():void
        {
            var _local_2:*;
            var _local_3:*;
            if (!allocated)
            {
                allocated = new Object();
            };
            if (r.baseClassStats)
            {
                for (_local_3 in r.baseClassStats)
                {
                    allocated[_local_3] = r.baseClassStats[_local_3];
                };
                allocated["intHPMax"] = uoData.intHPMax;
                r.baseClassStats = null;
                return;
            };
            var _local_1:* = world.uoTree[r.sfc.myUserName.toLowerCase()].sta;
            for each (_local_2 in tValues)
            {
                allocated[_local_2] = _local_1[_local_2];
            };
            for each (_local_2 in tCombat1Vals)
            {
                allocated[_local_2] = _local_1[_local_2];
            };
            for each (_local_2 in tCombat2Vals)
            {
                allocated[_local_2] = _local_1[_local_2];
            };
            allocated["intHPMax"] = uoData.intHPMax;
        }

        public function updateBase():void
        {
            tName.text = uoData.strClassName;
            tCat.text = getCatDefinition();
            allocateBaseValues();
        }

        public function update():void
        {
            var _local_5:String;
            var _local_6:int;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:*;
            var _local_12:*;
            var _local_13:Array;
            var _local_14:*;
            var _local_15:*;
            var _local_16:TextFormat;
            buildStu();
            var _local_1:* = world.uoTree[r.sfc.myUserName.toLowerCase()].sta;
            var _local_2:int = Math.floor((100 - world.myAvatar.getEquippedItemBySlot("Weapon").iRng));
            var _local_3:int = (100 + world.myAvatar.getEquippedItemBySlot("Weapon").iRng);
            var _local_4:Object = getEnhances();
            tCore.text = ((((((((((((((((((_local_2 + "% - ") + _local_3) + "%\n") + _local_4["Weapon"][0]) + _local_4["Weapon"][1]) + ((_local_4["Weapon"][2] != "") ? (", " + _local_4["Weapon"][2]) : "")) + "\n") + _local_4["ar"][0]) + _local_4["ar"][1]) + "\n") + _local_4["ba"][0]) + _local_4["ba"][1]) + ((_local_4["ba"][2] != "") ? (", " + _local_4["ba"][2]) : "")) + "\n") + _local_4["he"][0]) + _local_4["he"][1]) + ((_local_4["he"][2] != "") ? (", " + _local_4["he"][2]) : "")) + "\n");
            var _local_7:int;
            tStats.text = "";
            for each (_local_8 in tStatVals)
            {
                tStats.text = (tStats.text + ((((stp[("_" + _local_8)] + stg[("^" + _local_8)]) + " (") + ((_local_1[("$" + _local_8)]) ? _local_1[("$" + _local_8)] : 0)) + ")\n"));
                tStatFormats[_local_7] = [(tStats.text.lastIndexOf("(") + 1), tStats.text.lastIndexOf(")"), determineStatColor(_local_8, _local_1[("$" + _local_8)])];
                _local_7++;
            };
            tCombat1.text = "";
            _local_7 = 0;
            for each (_local_9 in tCombat1Vals)
            {
                if (((_local_9 == "$ap") || (_local_9 == "$sp")))
                {
                    _local_5 = String(_local_1[_local_9]);
                };
                if (_local_9 == "$thi")
                {
                    _local_5 = (r.coeffToPct(Number(((1 - r.baseMiss) + _local_1["$thi"]))) + "%");
                };
                if (_local_9 == "$tha")
                {
                    _local_13 = fixValues("$tha", _local_1["$tha"]);
                    _local_5 = ((((_local_13.length == 2) ? _local_13[1] : "") + _local_13[0]) + "%");
                };
                _local_6 = tCombat1.length;
                tCombat1.text = (tCombat1.text + (_local_5 + "\n"));
                tCombatFormats1[_local_7] = [_local_6, tCombat1.length, determineColor(_local_9, _local_1[_local_9])];
                _local_7++;
            };
            tCombat2.text = "";
            _local_7 = 0;
            for each (_local_10 in tCombat2Vals)
            {
                _local_6 = tCombat2.length;
                tCombat2.text = (tCombat2.text + (r.coeffToPct(_local_1[_local_10]) + "%\n"));
                tCombatFormats2[_local_7] = [_local_6, tCombat2.length, determineColor(_local_10, _local_1[_local_10])];
                _local_7++;
            };
            _local_6 = tCombat2.length;
            tCombat2.text = (tCombat2.text + uoData.intHPMax);
            tCombatFormats2[_local_7] = [_local_6, tCombat2.length, determineColor("intHPMax", uoData.intHPMax)];
            tMod.text = "";
            _local_7 = 0;
            for each (_local_11 in tValues)
            {
                _local_14 = ((stg[("^" + _local_11)] != null) ? (_local_1[_local_11] + stg[("^" + _local_11)]) : _local_1[_local_11]);
                _local_15 = fixValues(_local_11, _local_14);
                _local_6 = tMod.length;
                tMod.text = (tMod.text + (((_local_15.length == 2) ? (_local_15[1] + _local_15[0]) : _local_15[0]) + "%\n"));
                tFormats[_local_7] = [_local_6, tMod.length, determineColor(_local_11, _local_14)];
                _local_7++;
            };
            for each (_local_12 in tStatFormats)
            {
                _local_16 = tStats.getTextFormat(_local_12[0], _local_12[1]);
                _local_16.color = _local_12[2];
                _local_16.leading = 4;
                tStats.setTextFormat(_local_16, _local_12[0], _local_12[1]);
            };
            for each (_local_12 in tFormats)
            {
                _local_16 = tMod.getTextFormat(_local_12[0], _local_12[1]);
                _local_16.color = _local_12[2];
                _local_16.leading = 2.6;
                tMod.setTextFormat(_local_16, _local_12[0], _local_12[1]);
            };
            for each (_local_12 in tCombatFormats1)
            {
                _local_16 = tCombat1.getTextFormat(_local_12[0], _local_12[1]);
                _local_16.color = _local_12[2];
                _local_16.leading = 2;
                tCombat1.setTextFormat(_local_16, _local_12[0], _local_12[1]);
            };
            for each (_local_12 in tCombatFormats2)
            {
                _local_16 = tCombat2.getTextFormat(_local_12[0], _local_12[1]);
                _local_16.color = _local_12[2];
                _local_16.leading = 2;
                tCombat2.setTextFormat(_local_16, _local_12[0], _local_12[1]);
            };
        }

        private function getProc(_arg_1:Object):String
        {
            var _local_2:* = "";
            if (((_arg_1) && (_arg_1.hasOwnProperty("ProcID"))))
            {
                switch (_arg_1.ProcID)
                {
                    case 2:
                        _local_2 = "Spiral Carve";
                        break;
                    case 3:
                        _local_2 = "Awe Blast";
                        break;
                    case 4:
                        _local_2 = "Health Vamp";
                        break;
                    case 5:
                        _local_2 = "Mana Vamp";
                        break;
                    case 6:
                        _local_2 = "Powerword DIE";
                        break;
                    case 7:
                        _local_2 = "Lacerate";
                        break;
                    case 8:
                        _local_2 = "Smite";
                        break;
                    case 9:
                        _local_2 = "Valiance";
                        break;
                    case 10:
                        _local_2 = "Arcana's Concerto";
                        break;
                    case 11:
                        _local_2 = "Acheron";
                        break;
                    case 12:
                        _local_2 = "Elysium";
                        break;
                    case 13:
                        _local_2 = "Praxis";
                        break;
                    case 14:
                        _local_2 = "Dauntless";
                        break;
                    case 15:
                        _local_2 = "Ravenous";
                        break;
                    default:
                        _local_2 = "None";
                };
            };
            return (_local_2);
        }

        private function getEnh(_arg_1:String):Array
        {
            var _local_4:*;
            var _local_2:Array = ["None", "", ""];
            var _local_3:Object = world.myAvatar.getEquippedItemBySlot(_arg_1);
            _local_2[2] = getProc(_local_3);
            if (!_local_3)
            {
                return (_local_2);
            };
            if (_local_3.PatternID != null)
            {
                _local_4 = r.world.enhPatternTree[_local_3.PatternID];
            };
            if (_local_3.EnhPatternID != null)
            {
                _local_4 = r.world.enhPatternTree[_local_3.EnhPatternID];
            };
            if (!_local_4)
            {
                return (_local_2);
            };
            _local_2[0] = _local_4.sName;
            _local_2[1] = ((_local_3.EnhRty > 1) ? (" +" + String((_local_3.EnhRty - 1))) : "");
            if (_local_4.hasOwnProperty("DIS"))
            {
                _local_2[0] = r.getDisplayEnhName(_local_4);
                _local_2[2] = r.getDisplayEnhTraitName(_local_4);
            };
            return (_local_2);
        }

        private function getEnhances():Object
        {
            var _local_2:*;
            var _local_1:Object = {
                "Weapon":[],
                "ar":[],
                "ba":[],
                "he":[]
            };
            r.world.initPatternTree();
            for (_local_2 in _local_1)
            {
                _local_1[_local_2] = getEnh(_local_2);
            };
            return (_local_1);
        }

        private function handleMissing(_arg_1:String):String
        {
            return ((_arg_1 == "NaN") ? "100" : _arg_1);
        }

        private function onDrag(_arg_1:MouseEvent):void
        {
            this.startDrag();
        }

        private function onStop(_arg_1:MouseEvent):void
        {
            this.stopDrag();
        }

        public function updateBoosts():void
        {
            var _local_3:*;
            var _local_4:MovieClip;
            var _local_5:*;
            var _local_6:int;
            var _local_7:String;
            var _local_8:String;
            var _local_9:MovieClip;
            var _local_10:MovieClip;
            var _local_11:MovieClip;
            var _local_12:MovieClip;
            var _local_13:*;
            while (bContainer.numChildren > 1)
            {
                bContainer.removeChildAt(1);
            };
            var _local_1:Object = r.world.myAvatar.boosts;
            var _local_2:Boolean;
            for each (_local_3 in _local_1)
            {
                if (_local_3[0] > 0)
                {
                    _local_2 = true;
                    break;
                };
            };
            bContainer.visible = _local_2;
            if (!_local_2)
            {
                return;
            };
            boostsObj = {};
            boostsObj["dmgBoost"] = "";
            for (_local_3 in _local_1)
            {
                _local_7 = _local_1[_local_3][0];
                if (Number(_local_7) != 0)
                {
                    _local_8 = Math.round(((Number(_local_7) - 1) * 100)).toString();
                    switch (_local_3)
                    {
                        case "dmgall":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("All +" + _local_8) + "%\n"));
                            break;
                        case "undead":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Undead +" + _local_8) + "%\n"));
                            break;
                        case "human":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Human +" + _local_8) + "%\n"));
                            break;
                        case "chaos":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Chaos +" + _local_8) + "%\n"));
                            break;
                        case "dragonkin":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Dragonkin +" + _local_8) + "%\n"));
                            break;
                        case "orc":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Orc +" + _local_8) + "%\n"));
                            break;
                        case "drakath":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Drakath +" + _local_8) + "%\n"));
                            break;
                        case "elemental":
                            boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Elemental +" + _local_8) + "%\n"));
                            break;
                        case "cp":
                            boostsObj["classBoost"] = (("Class Points +" + _local_8) + "%");
                            break;
                        case "gold":
                            boostsObj["goldBoost"] = (("Gold +" + _local_8) + "%");
                            break;
                        case "rep":
                            boostsObj["repBoost"] = (("Reputation +" + _local_8) + "%");
                            break;
                        case "exp":
                            boostsObj["xpBoost"] = (("Experience +" + _local_8) + "%");
                            break;
                    };
                };
            };
            _local_4 = new damageBoost();
            for (_local_5 in boostsObj)
            {
                switch (_local_5)
                {
                    case "dmgBoost":
                        if (boostsObj[_local_5] == "") break;
                        bContainer.addChild(_local_4);
                        _local_4.scaleX = 0.043;
                        _local_4.scaleY = 0.04;
                        _local_4.name = "dmgBoost";
                        _local_4.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                        _local_4.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                        break;
                    case "classBoost":
                        _local_9 = new classBoost();
                        bContainer.addChild(_local_9);
                        _local_9.scaleX = 0.043;
                        _local_9.scaleY = 0.04;
                        _local_9.name = "classBoost";
                        _local_9.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                        _local_9.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                        break;
                    case "goldBoost":
                        _local_10 = new goldBoost();
                        bContainer.addChild(_local_10);
                        _local_10.scaleX = 0.043;
                        _local_10.scaleY = 0.04;
                        _local_10.name = "goldBoost";
                        _local_10.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                        _local_10.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                        break;
                    case "repBoost":
                        _local_11 = new repBoost();
                        bContainer.addChild(_local_11);
                        _local_11.scaleX = 0.043;
                        _local_11.scaleY = 0.04;
                        _local_11.name = "repBoost";
                        _local_11.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                        _local_11.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                        break;
                    case "xpBoost":
                        _local_12 = new xpBoost();
                        bContainer.addChild(_local_12);
                        _local_12.scaleX = 0.043;
                        _local_12.scaleY = 0.04;
                        _local_12.name = "xpBoost";
                        _local_12.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                        _local_12.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                        break;
                };
            };
            _local_6 = 1;
            while (_local_6 < bContainer.numChildren)
            {
                _local_13 = bContainer.getChildAt(_local_6);
                if ((_local_13 is MovieClip))
                {
                    _local_13.y = 3;
                    _local_13.x = (((_local_6 - 1) * _local_13.width) + 2);
                };
                _local_6++;
            };
        }

        private function onBoostGet(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name;
            tt.openWith({
                "str":boostsObj[_local_2],
                "fromlocal":{
                    "x":(bContainer.x + (bContainer.width / 2)),
                    "y":(bContainer.y + bContainer.height)
                }
            });
        }

        private function onBoostOut(_arg_1:MouseEvent):void
        {
            tt.close();
        }


    }
}//package liteAssets.draw

