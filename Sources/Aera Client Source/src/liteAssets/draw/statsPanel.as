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

    public class statsPanel extends MovieClip 
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

        // Aera v30.68 - user-designed stat allocation controls on the statsPanel FLA symbol.
        // Keep these instance names exactly as shown in Adobe Animate.
        public var txtStatPoints:TextField;
        public var txtSTR:TextField;
        public var txtINT:TextField;
        public var txtDEX:TextField;
        public var txtEND:TextField;
        public var txtWIS:TextField;
        public var txtLCK:TextField;
        public var btnSTR:MovieClip;
        public var btnINT:MovieClip;
        public var btnDEX:MovieClip;
        public var btnEND:MovieClip;
        public var btnWIS:MovieClip;
        public var btnLCK:MovieClip;
        public var btnMinusSTR:MovieClip;
        public var btnMinusINT:MovieClip;
        public var btnMinusDEX:MovieClip;
        public var btnMinusEND:MovieClip;
        public var btnMinusWIS:MovieClip;
        public var btnMinusLCK:MovieClip;
        public var btnSaveStats:MovieClip;
        public var btnResetStats:MovieClip;

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
private var allocPoints:TextField;
private var allocValues:Object = {};
private var allocButtons:Object = {};
private var allocMinusButtons:Object = {};
private var allocSaveButton:MovieClip;
private var allocResetButton:MovieClip;
private var allocDesigned:Boolean = false;
private var allocationBusy:Boolean = false;
private var pendingStats:Object = {"STR":0, "INT":0, "DEX":0, "END":0, "WIS":0, "LCK":0};
private var allocNames:Object = {"STR":"Strength", "INT":"Intellect", "DEX":"Dexterity", "END":"Endurance", "WIS":"Wisdom", "LCK":"Luck"};

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
            navigateToURL(new URLRequest("https://www.aq.com/lore/guides/stats"), "_blank");
        }

        public function cleanup():void
        {
            var _local_1:MovieClip;
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
            buildAllocationPanel();
            update();
            this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
            tt = new ToolTipMC(r);
            addChild(tt);
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
            refreshAllocationPanel();
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

private function resetPendingStats():void
{
    pendingStats = {"STR":0, "INT":0, "DEX":0, "END":0, "WIS":0, "LCK":0};
}

private function pendingTotal():int
{
    return (int(pendingStats.STR) + int(pendingStats.INT) + int(pendingStats.DEX) + int(pendingStats.END) + int(pendingStats.WIS) + int(pendingStats.LCK));
}

private function savedTotal():int
{
    var _local_1:Object = ((uoData.allocatedStats != null) ? uoData.allocatedStats : {});
    return (int(_local_1.Strength) + int(_local_1.Intellect) + int(_local_1.Dexterity) + int(_local_1.Endurance) + int(_local_1.Wisdom) + int(_local_1.Luck));
}

/**
 * Aera v30.69 - bind ONLY the user-designed allocation controls from the FLA.
 * No ActionScript-generated/fallback panel is created anymore.
 *
 * Controls may be directly on statsPanel OR nested inside another MovieClip.
 * Required instance names:
 * txtStatPoints, txtSTR/txtINT/txtDEX/txtEND/txtWIS/txtLCK,
 * btnSTR/btnINT/btnDEX/btnEND/btnWIS/btnLCK,
 * btnMinusSTR/btnMinusINT/btnMinusDEX/btnMinusEND/btnMinusWIS/btnMinusLCK,
 * btnSaveStats, btnResetStats.
 */
private function findDesignedInstance(_arg_1:DisplayObjectContainer, _arg_2:String):DisplayObject
{
    var _local_1:int;
    var _local_2:DisplayObject;
    var _local_3:DisplayObject;
    if (_arg_1 == null)
    {
        return (null);
    };
    _local_1 = 0;
    while (_local_1 < _arg_1.numChildren)
    {
        _local_2 = _arg_1.getChildAt(_local_1);
        if (_local_2.name == _arg_2)
        {
            return (_local_2);
        };
        if (_local_2 is DisplayObjectContainer)
        {
            _local_3 = findDesignedInstance(DisplayObjectContainer(_local_2), _arg_2);
            if (_local_3 != null)
            {
                return (_local_3);
            };
        };
        _local_1++;
    };
    return (null);
}

private function designedText(_arg_1:String, _arg_2:TextField):TextField
{
    if (_arg_2 != null)
    {
        return (_arg_2);
    };
    return (findDesignedInstance(this, _arg_1) as TextField);
}

private function designedButton(_arg_1:String, _arg_2:MovieClip):MovieClip
{
    if (_arg_2 != null)
    {
        return (_arg_2);
    };
    return (findDesignedInstance(this, _arg_1) as MovieClip);
}

private function bindDesignedAllocationPanel():Boolean
{
    var _local_1:Array = ["STR", "INT", "DEX", "END", "WIS", "LCK"];
    var _local_2:Object;
    var _local_3:Object;
    var _local_4:Object;
    var _local_5:int;
    var _local_6:String;

    // Aera v30.71: bind the user's actual FLA-authored controls.
    // Prefer the timeline variables generated by Animate, then fall back to a
    // recursive name lookup so nested designs continue to work too.
    allocPoints = designedText("txtStatPoints", txtStatPoints);
    allocSaveButton = designedButton("btnSaveStats", btnSaveStats);
    allocResetButton = designedButton("btnResetStats", btnResetStats);

    _local_2 = {
        "STR":designedText("txtSTR", txtSTR),
        "INT":designedText("txtINT", txtINT),
        "DEX":designedText("txtDEX", txtDEX),
        "END":designedText("txtEND", txtEND),
        "WIS":designedText("txtWIS", txtWIS),
        "LCK":designedText("txtLCK", txtLCK)
    };
    _local_3 = {
        "STR":designedButton("btnSTR", btnSTR),
        "INT":designedButton("btnINT", btnINT),
        "DEX":designedButton("btnDEX", btnDEX),
        "END":designedButton("btnEND", btnEND),
        "WIS":designedButton("btnWIS", btnWIS),
        "LCK":designedButton("btnLCK", btnLCK)
    };
    _local_4 = {
        "STR":designedButton("btnMinusSTR", btnMinusSTR),
        "INT":designedButton("btnMinusINT", btnMinusINT),
        "DEX":designedButton("btnMinusDEX", btnMinusDEX),
        "END":designedButton("btnMinusEND", btnMinusEND),
        "WIS":designedButton("btnMinusWIS", btnMinusWIS),
        "LCK":designedButton("btnMinusLCK", btnMinusLCK)
    };

    allocValues = _local_2;
    allocButtons = _local_3;
    allocMinusButtons = _local_4;

    // The points field is the only object required to identify that the custom
    // allocator exists. A missing/misnamed individual button no longer aborts
    // every other control on the panel.
    if (allocPoints == null)
    {
        trace("[Aera] statsPanel: txtStatPoints was not found; stat allocator was not bound.");
        return (false);
    };

    allocDesigned = true;
    allocPoints.mouseEnabled = false;
    allocPoints.selectable = false;

    _local_5 = 0;
    while (_local_5 < _local_1.length)
    {
        _local_6 = String(_local_1[_local_5]);

        if (allocValues[_local_6] != null)
        {
            TextField(allocValues[_local_6]).mouseEnabled = false;
            TextField(allocValues[_local_6]).selectable = false;
        }
        else
        {
            trace(("[Aera] statsPanel: missing text field txt" + _local_6));
        };

        if (allocButtons[_local_6] != null)
        {
            MovieClip(allocButtons[_local_6]).buttonMode = true;
            MovieClip(allocButtons[_local_6]).mouseChildren = false;
            MovieClip(allocButtons[_local_6]).addEventListener(MouseEvent.MOUSE_DOWN, stopAllocatorDrag, false, 0, true);
            MovieClip(allocButtons[_local_6]).addEventListener(MouseEvent.CLICK, onAddPendingStat, false, 0, true);
        }
        else
        {
            trace(("[Aera] statsPanel: missing plus button btn" + _local_6));
        };

        if (allocMinusButtons[_local_6] != null)
        {
            MovieClip(allocMinusButtons[_local_6]).buttonMode = true;
            MovieClip(allocMinusButtons[_local_6]).mouseChildren = false;
            MovieClip(allocMinusButtons[_local_6]).addEventListener(MouseEvent.MOUSE_DOWN, stopAllocatorDrag, false, 0, true);
            MovieClip(allocMinusButtons[_local_6]).addEventListener(MouseEvent.CLICK, onRemovePendingStat, false, 0, true);
        }
        else
        {
            trace(("[Aera] statsPanel: missing minus button btnMinus" + _local_6));
        };
        _local_5++;
    };

    if (allocSaveButton != null)
    {
        allocSaveButton.buttonMode = true;
        allocSaveButton.mouseChildren = false;
        allocSaveButton.addEventListener(MouseEvent.MOUSE_DOWN, stopAllocatorDrag, false, 0, true);
        allocSaveButton.addEventListener(MouseEvent.CLICK, onSaveAllocation, false, 0, true);
    }
    else
    {
        trace("[Aera] statsPanel: missing btnSaveStats.");
    };

    if (allocResetButton != null)
    {
        allocResetButton.buttonMode = true;
        allocResetButton.mouseChildren = false;
        allocResetButton.addEventListener(MouseEvent.MOUSE_DOWN, stopAllocatorDrag, false, 0, true);
        allocResetButton.addEventListener(MouseEvent.CLICK, onResetAllocation, false, 0, true);
    }
    else
    {
        trace("[Aera] statsPanel: missing btnResetStats. Other stat controls remain active.");
    };

    trace("[Aera] statsPanel: custom FLA stat allocator bound.");
    return (true);
}
private function buildAllocationPanel():void
{
    if (allocDesigned)
    {
        return;
    };
    if (bindDesignedAllocationPanel())
    {
        refreshAllocationPanel();
    };
}

private function stopAllocatorDrag(_arg_1:MouseEvent):void
{
    _arg_1.stopPropagation();
}

private function statCodeFromButton(_arg_1:MovieClip, _arg_2:Boolean):String
{
    var _local_1:String = _arg_1.name;
    if (_arg_2)
    {
        if (_local_1.indexOf("btnMinus") == 0)
        {
            return (_local_1.substr(8));
        };
        if (_local_1.indexOf("minus_") == 0)
        {
            return (_local_1.substr(6));
        };
    }
    else
    {
        if (((_local_1.indexOf("btn") == 0) && (_local_1 != "btnSaveStats") && (_local_1 != "btnResetStats")))
        {
            return (_local_1.substr(3));
        };
        if (_local_1.indexOf("add_") == 0)
        {
            return (_local_1.substr(4));
        };
    };
    return ("");
}

private function onAddPendingStat(_arg_1:MouseEvent):void
{
    var _local_1:String;
    var _local_2:int = (((uoData.statPoints != null) ? int(uoData.statPoints) : 0) - pendingTotal());
    if (((allocationBusy) || (_local_2 < 1)))
    {
        return;
    };
    _local_1 = statCodeFromButton(MovieClip(_arg_1.currentTarget), false);
    if (pendingStats[_local_1] == null)
    {
        return;
    };
    pendingStats[_local_1] = (int(pendingStats[_local_1]) + 1);
    refreshAllocationPanel();
}

private function onRemovePendingStat(_arg_1:MouseEvent):void
{
    var _local_1:String;
    if (allocationBusy)
    {
        return;
    };
    _local_1 = statCodeFromButton(MovieClip(_arg_1.currentTarget), true);
    if (((pendingStats[_local_1] == null) || (int(pendingStats[_local_1]) < 1)))
    {
        return;
    };
    // Only unsaved points can be removed with the minus button.
    pendingStats[_local_1] = (int(pendingStats[_local_1]) - 1);
    refreshAllocationPanel();
}

private function onSaveAllocation(_arg_1:MouseEvent):void
{
    var _local_1:int = pendingTotal();
    if (((allocationBusy) || (_local_1 < 1)))
    {
        return;
    };
    if (_local_1 > ((uoData.statPoints != null) ? int(uoData.statPoints) : 0))
    {
        refreshAllocationPanel();
        return;
    };
    allocationBusy = true;
    refreshAllocationPanel();
    r.sfc.sendXtMessage("zm", "saveStatPoints", [String(pendingStats.STR), String(pendingStats.INT), String(pendingStats.DEX), String(pendingStats.END), String(pendingStats.WIS), String(pendingStats.LCK)], "str", world.curRoom);
}

private function onResetAllocation(_arg_1:MouseEvent):void
{
    if (allocationBusy)
    {
        return;
    };

    // If nothing has ever been saved and the player only has pending edits,
    // Reset simply cancels those local edits. No server round-trip is needed.
    if (savedTotal() < 1)
    {
        if (pendingTotal() > 0)
        {
            resetPendingStats();
            refreshAllocationPanel();
        };
        return;
    };

    // Saved allocations exist: the server resets all six stats and refunds every
    // committed point. Pending unsaved edits are discarded after success.
    allocationBusy = true;
    refreshAllocationPanel();
    r.sfc.sendXtMessage("zm", "resetStatPoints", [], "str", world.curRoom);
}

public function onStatAllocationSaved():void
{
    allocationBusy = false;
    resetPendingStats();
    refreshAllocationPanel();
}

public function onStatAllocationReset():void
{
    allocationBusy = false;
    resetPendingStats();
    refreshAllocationPanel();
}

public function onStatAllocationFailed():void
{
    allocationBusy = false;
    refreshAllocationPanel();
}

private function setAllocButtonState(_arg_1:MovieClip, _arg_2:Boolean):void
{
    if (_arg_1 == null)
    {
        return;
    };
    _arg_1.mouseEnabled = _arg_2;
    _arg_1.alpha = ((_arg_2) ? 1 : 0.35);
}

private function refreshAllocationPanel():void
{
    var _local_1:int;
    var _local_2:int;
    var _local_3:Object;
    var _local_4:String;
    var _local_5:int;
    var _local_6:MovieClip;
    var _local_7:MovieClip;
    if (!(allocDesigned))
    {
        return;
    };

    _local_1 = ((uoData.statPoints != null) ? int(uoData.statPoints) : 0);
    _local_2 = Math.max(0, (_local_1 - pendingTotal()));
    _local_3 = ((uoData.allocatedStats != null) ? uoData.allocatedStats : {});

    if (allocPoints != null)
    {
        allocPoints.text = String(_local_2);
    };

    for (_local_4 in allocNames)
    {
        _local_5 = int(_local_3[allocNames[_local_4]]) + int(pendingStats[_local_4]);
        if (allocValues[_local_4] != null)
        {
            TextField(allocValues[_local_4]).text = String(_local_5);
        };

        _local_6 = ((allocButtons[_local_4] != null) ? MovieClip(allocButtons[_local_4]) : null);
        _local_7 = ((allocMinusButtons[_local_4] != null) ? MovieClip(allocMinusButtons[_local_4]) : null);
        setAllocButtonState(_local_6, (((!(allocationBusy)) && (_local_2 > 0))));
        setAllocButtonState(_local_7, (((!(allocationBusy)) && (int(pendingStats[_local_4]) > 0))));
    };

    setAllocButtonState(allocSaveButton, (((!(allocationBusy)) && (pendingTotal() > 0))));
    setAllocButtonState(allocResetButton, (((!(allocationBusy)) && (((savedTotal() > 0) || (pendingTotal() > 0))))));
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

