// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//AvatarMC

package 
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.events.IOErrorEvent;
    import fl.motion.Color;
    import flash.system.ApplicationDomain;
    import flash.display.Graphics;

    public class AvatarMC extends MovieClip 
    {

        private const MAX_RATIO:Number = 4.6566128752458E-10;
        public var cShadow:MovieClip;
        public var hpBar:MovieClip;
        public var mcChar:mcSkel;
        public var pname:MovieClip;
        public var ignore:MovieClip;
        public var shadow:MovieClip;
        public var Sounds:MovieClip;
        public var fx:MovieClip;
        public var proxy:MovieClip;
        public var bubble:MovieClip;
        private var xDep:*;
        private var yDep:*;
        private var xTar:*;
        private var yTar:Number;
        private var nDuration:*;
        private var nXStep:*;
        private var nYStep:*;
        private var walkSpeed:Number;
        private var op:Point;
        public var tp:Point;
        private var walkTS:Number;
        private var walkD:Number;
        private var headPoint:Point;
        private var cbx:*;
        private var cby:Number;
        private var bLoadingHelm:Boolean = false;
        public var pAV:Avatar;
        public var projClass:Projectile;
        public var spellDur:int = 0;
        public var bBackHair:Boolean = false;
        public var isLoaded:Boolean = false;
        public var STAGE:MovieClip;
        public var world:World;
        public var px:*;
        public var py:*;
        public var tx:*;
        public var ty:Number;
        public var kv:Killvis = null;
        public var strGender:String;
        public var previousframe:int = -1;
        public var hitboxR:Rectangle;
        private var rootClass:Game = Game.root;
        private var randNum:Number;
        private var weaponLoad:Boolean = true;
        private var armorLoad:Boolean = true;
        private var classLoad:Boolean = true;
        private var helmLoad:Boolean = true;
        private var hairLoad:Boolean = true;
        private var capeLoad:Boolean = true;
        private var miscLoad:Boolean = true;
        private var testMC:*;
        private var topIndex:int = 0;
        public var isRasterized:Boolean;
        public var helmBackHair:Boolean = false;
        public var sp:Number = 8;
        public var mvts:Number;
        public var mvtd:Number;

        private var objLinks:Object = {};
        private var heavyAssets:Array = [];
        private var totalTransform:Object = {
            "alphaMultiplier":1,
            "alphaOffset":0,
            "redMultiplier":1,
            "redOffset":0,
            "greenMultiplier":1,
            "greenOffset":0,
            "blueMultiplier":1,
            "blueOffset":0
        };
        private var clampedTransform:ColorTransform = new ColorTransform();
        private var animQueue:Array = [];
        public var spFX:Object = {};
        public var defaultCT:ColorTransform = MovieClip(this).transform.colorTransform;
        public var CT3:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0);
        public var CT2:ColorTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127, 0);
        public var CT1:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        private const NEGA_MAX_RATIO:Number = -(MAX_RATIO);
        private var r:int = (Math.random() * int.MAX_VALUE);
        private var animEvents:Object = {};
        private var mcOrder:Object = {};
        public var attackFrames:Array = [];
        private var _spFXQueue:Array = [];

        public function AvatarMC(_arg_1:Boolean=true):void
        {
            addFrameScript(0, this.frame1, 4, this.frame5, 7, this.frame8, 9, this.frame10, 11, this.frame12, 12, this.frame13, 13, this.frame14, 17, this.frame18, 19, this.frame20, 22, this.frame23);
            this.Sounds.visible = false;
            this.ignore.visible = false;
            if (_arg_1)
            {
                this.mcChar.addEventListener(MouseEvent.CLICK, this.onClickHandler);
            }
            this.mcChar.buttonMode = true;
            this.mcChar.pvpFlag.mouseEnabled = false;
            this.mcChar.pvpFlag.mouseChildren = false;
            this.pname.mouseChildren = false;
            this.pname.buttonMode = false;
            this.mcChar.mouseChildren = true;
            this.bubble.mouseEnabled = (this.bubble.mouseChildren = false);
            if (_arg_1)
            {
                this.shadow.addEventListener(MouseEvent.CLICK, this.onClickHandler);
            }
            this.addEventListener(Event.ENTER_FRAME, this.checkQueue, false, 0, true);
            this.bubble.visible = false;
            this.bubble.t = "";
            this.pname.ti.text = "";
            this.headPoint = new Point(0, (this.mcChar.head.y - (1.4 * this.mcChar.head.height)));
            this.hideOptionalParts();
        }

        public function get location():Point {
            return new Point(x, y);
        }

        public function fClose():void
        {
            if (this.pAV != null)
            {
                this.pAV.unloadPet();
                if (this.pAV == this.world.myAvatar)
                {
                    this.world.setTarget(null);
                }
                else
                {
                    this.pAV.target = null;
                }
                this.pAV.pMC = null;
                this.pAV = null;
            }
            this.recursiveStop(this);
            this.mcChar.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.pname.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.shadow.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
            this.removeEventListener(Event.ENTER_FRAME, this.checkQueue);
            if (this.world.CHARS.contains(this))
            {
                this.world.CHARS.removeChild(this);
            }
            if (this.world.TRASH.contains(this))
            {
                this.world.TRASH.removeChild(this);
            }
            try
            {
                if (getChildByName("HealIconMC") != null)
                {
                    MovieClip(getChildByName("HealIconMC")).fClose();
                }
            }
            catch(e:Error)
            {
            }
            while (this.fx.numChildren > 0)
            {
                this.fx.removeChildAt(0);
            }
        }

        override public function gotoAndPlay(_arg_1:Object, _arg_2:String=null):void
        {
            this.handleAnimEvent(String(_arg_1));
            super.gotoAndPlay(_arg_1);
        }

        public function disablePNameMouse():void
        {
            mouseEnabled = false;
            this.pname.mouseEnabled = false;
            this.pname.mouseChildren = false;
            this.pname.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
        }

        public function hasLabel(_arg_1:String):Boolean
        {
            var _local_2:Array = this.mcChar.currentLabels;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].name == _arg_1)
                {
                    return (true);
                }
                _local_3++;
            }
            return (false);
        }

        private function recursiveStop(_arg_1:MovieClip):void
        {
            var _local_3:DisplayObject;
            var _local_2:int;
            while (_local_2 < _arg_1.numChildren)
            {
                _local_3 = _arg_1.getChildAt(_local_2);
                if ((_local_3 is MovieClip))
                {
                    MovieClip(_local_3).stop();
                    this.recursiveStop(MovieClip(_local_3));
                }
                _local_2++;
            }
        }

        public function showHPBar():void
        {
            this.hpBar.y = (this.pname.y - 3);
            this.hpBar.visible = true;
            this.updateHPBar();
        }

        public function hideHPBar():void
        {
            this.hpBar.visible = false;
        }

        public function updateHPBar():void
        {
            var _local_3:Object;
            var _local_1:MovieClip = (this.hpBar.g as MovieClip);
            var _local_2:MovieClip = (this.hpBar.r as MovieClip);
            if (this.hpBar.visible)
            {
                _local_3 = this.pAV.dataLeaf;
                if (((!(_local_3 == null)) && (!(_local_3.intHP == null))))
                {
                    _local_1.visible = true;
                    _local_1.width = Math.round(((_local_3.intHP / _local_3.intHPMax) * _local_2.width));
                    if (_local_3.intHP < 1)
                    {
                        _local_1.visible = false;
                    }
                }
            }
        }

        public function updateName():void
        {
            var uoLeaf:* = this.world.uoTree[this.pAV.pnm];
            if (uoLeaf == null)
            {
                uoLeaf = this.world.uoTree[this.pAV.pnm.toLowerCase()];
            }
            try
            {
                if (uoLeaf.afk)
                {
                    this.pname.ti.text = ("<AFK> " + this.pAV.objData.strUsername);
                }
                else
                {
                    this.pname.ti.text = this.pAV.objData.strUsername;
                }
                if (this.pAV.objData.guild != null)
                {
                    this.pname.tg.text = (("< " + String(this.pAV.objData.guild.Name)) + " >");
                }
            }
            catch(e:Error)
            {
            }
        }

        private function hideOptionalParts():void
        {
            var _local_1:* = ["cape", "backhair", "robe", "backrobe", "pvpFlag"];
            var _local_2:* = ["weapon", "weaponOff", "weaponFist", "weaponFistOff", "shield"];
            var _local_3:* = "";
            for (_local_3 in _local_1)
            {
                if (typeof(this.mcChar[_local_1[_local_3]]) != undefined)
                {
                    this.mcChar[_local_1[_local_3]].visible = false;
                }
            }
            for (_local_3 in _local_2)
            {
                if (typeof(this.mcChar[_local_2[_local_3]]) != undefined)
                {
                    this.mcChar[_local_2[_local_3]].visible = false;
                }
            }
        }

        private function onClickHandler(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_4:*;
            var _local_2:Avatar = _arg_1.currentTarget.parent.pAV;

            // Database NPCs are interactable UI actors, not combat targets.
            // Clicking one opens its database-driven popup directly.
            if ((_local_2 != null) && (_local_2.npcType == "npc") &&
                (_local_2.objData != null) && ("dbNPC" in _local_2.objData) &&
                Boolean(_local_2.objData.dbNPC))
            {
                this.world.openDatabaseNPC(_local_2);
                _arg_1.stopImmediatePropagation();
                return;
            }

            if (_arg_1.shiftKey)
            {
                this.world.onWalkClick();
            }
            else
            {
                if (_arg_1.altKey)
                {
                    _local_3 = stage.getObjectsUnderPoint(new Point(_arg_1.stageX, _arg_1.stageY));
                    for (_local_4 in _local_3)
                    {
                        if (((_local_3[_local_4].parent) && (_local_3[_local_4].parent.name == "mcChar")))
                        {
                            this.world.setTarget(_local_3[_local_4].parent.parent.pAV);
                            break;
                        }
                    }
                }
                else
                {
                    if (!_arg_1.ctrlKey)
                    {
                        if (((((!(_local_2 == this.world.myAvatar)) && (this.world.bPvP)) && (!(_local_2.dataLeaf.pvpTeam == this.world.myAvatar.dataLeaf.pvpTeam))) && (_local_2 == this.world.myAvatar.target)))
                        {
                            this.world.approachTarget();
                        }
                        else
                        {
                            if (_local_2 != this.world.myAvatar.target)
                            {
                                this.world.setTarget(_local_2);
                            }
                        }
                    }
                }
            }
        }

        public function loadClass(_arg_1:String, _arg_2:String):void
        {
            trace("LOAD CLASS => 1 => " + _arg_1);

            if (this.pAV.objData.eqp.co == null)
            {
                trace("LOAD CLASS => 2");

                this.classLoad = false;
                this.world.queueLoad({
                    "strFile":((((this.world.rootClass.getFilePath() + "classes/") + this.strGender) + "/") + _arg_1),
                    "callBackA":world.rootClass.onLoadToBytes(onLoadClassComplete, world.loaderC),
                    "callBackB":this.ioErrorHandler,
                    "avt":this.pAV,
                    "sES":"ar"
                });
            }
        }

        public function onLoadClassComplete(_arg_1:Event=null):void
        {
            this.classLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            if (this.pAV.objData.eqp.co == null)
            {
                this.loadArmorPieces(this.pAV.objData.eqp.ar.sLink);
            }
        }

        public function loadMisc(_arg_1:String, _arg_2:String):void
        {
            this.miscLoad = false;
            this.objLinks.mi = _arg_2;
            this.world.queueLoad({
                "strFile":(this.world.rootClass.getFilePath() + _arg_1),
                "callBackA":this.onLoadMiscComplete,
                "callBackB":this.ioErrorHandler,
                "avt":this.pAV,
                "sES":"ac"
            });
        }

        public function onLoadMiscComplete(_arg_1:Event):void
        {
            this.miscLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            var _local_2:Class = (this.world.getClass(this.objLinks.mi) as Class);
            if (_local_2 != null)
            {
                this.cShadow.visible = true;
                this.cShadow.removeChildAt(0);
                this.cShadow.addChild(new (_local_2)());
                this.cShadow.scaleX = this.mcChar.scaleX;
                this.cShadow.scaleY = this.mcChar.scaleY;
                this.cShadow.mouseEnabled = (this.cShadow.mouseChildren = false);
                this.shadow.alpha = 0;
            }
            else
            {
                this.cShadow.visible = false;
                this.shadow.alpha = 1;
            }
            if (this.world.rootClass.litePreference.data.bDisGround)
            {
                if (((this.pAV.isMyAvatar) && (this.world.rootClass.litePreference.data.dOptions["groundSelf"])))
                {
                    return;
                }
                this.cShadow.visible = false;
                this.shadow.alpha = 1;
            }
        }

        public function loadArmor(_arg_1:String, _arg_2:String):void
        {
            objLinks.co = _arg_2;
            armorLoad = false;
            world.queueLoad({
                "strFile":((((world.rootClass.getFilePath() + "classes/") + strGender) + "/") + _arg_1),
                "callBackA":world.rootClass.onLoadToBytes(onLoadArmorComplete, world.loaderC),
                "callBackB":ioErrorHandler,
                "avt":pAV,
                "sES":"ar"
            });
        }

        public function onLoadArmorComplete(_arg_1:Event):void
        {
            this.armorLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            this.clearAnimEvents();
            this.loadArmorPieces(this.objLinks.co);
            if (this.name.indexOf("previewMCB") > -1)
            {
                MovieClip(parent.parent).repositionPreview(MovieClip(this.mcChar));
            }
        }

        public function ioErrorHandler(_arg_1:IOErrorEvent):void
        {
        }

        public function loadArmorPieces(strSkinLinkage:String):void
        {
            var AssetClass:Class;
            var child:DisplayObject;
            var drk:Color;
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Head")) as Class);
                child = this.mcChar.head.getChildByName("face");
                if (child != null)
                {
                    this.mcChar.head.removeChild(child);
                }
                this.testMC = this.mcChar.head.addChildAt(new (AssetClass)(), 0);
                this.testMC.name = "face";
            }
            catch(err:Error)
            {
                AssetClass = (world.getClass(("mcHead" + strGender)) as Class);
                child = mcChar.head.getChildByName("face");
                if (child != null)
                {
                    mcChar.head.removeChild(child);
                }
                testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
                testMC.name = "face";
            }
            if (this.pAV == this.world.myAvatar)
            {
                this.world.rootClass.showPortrait(this.pAV);
            }
            else
            {
                if (this.pAV == this.world.myAvatar.target)
                {
                    this.world.rootClass.showPortraitTarget(this.pAV);
                }
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Chest")) as Class);
                this.mcChar.chest.removeChildAt(0);
                this.mcChar.chest.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Hip")) as Class);
                this.mcChar.hip.removeChildAt(0);
                this.mcChar.hip.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "FootIdle")) as Class);
                this.mcChar.idlefoot.removeChildAt(0);
                this.mcChar.idlefoot.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Foot")) as Class);
                this.mcChar.frontfoot.removeChildAt(0);
                this.mcChar.frontfoot.addChild(new (AssetClass)());
                this.mcChar.frontfoot.visible = false;
                this.mcChar.backfoot.removeChildAt(0);
                this.mcChar.backfoot.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Shoulder")) as Class);
                this.mcChar.frontshoulder.removeChildAt(0);
                this.mcChar.frontshoulder.addChild(new (AssetClass)());
                this.mcChar.backshoulder.removeChildAt(0);
                this.mcChar.backshoulder.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Hand")) as Class);
                this.mcChar.fronthand.removeChildAt(0);
                this.mcChar.fronthand.addChildAt(new (AssetClass)(), 0);
                this.mcChar.backhand.removeChildAt(0);
                this.mcChar.backhand.addChildAt(new (AssetClass)(), 0);
                drk = new Color();
                drk.brightness = -1;
                this.mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Thigh")) as Class);
                this.mcChar.frontthigh.removeChildAt(0);
                this.mcChar.frontthigh.addChild(new (AssetClass)());
                this.mcChar.backthigh.removeChildAt(0);
                this.mcChar.backthigh.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            try
            {
                AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Shin")) as Class);
                this.mcChar.frontshin.removeChildAt(0);
                this.mcChar.frontshin.addChild(new (AssetClass)());
                this.mcChar.backshin.removeChildAt(0);
                this.mcChar.backshin.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
            }
            AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "Robe")) as Class);
            if (AssetClass != null)
            {
                this.mcChar.robe.removeChildAt(0);
                this.mcChar.robe.addChild(new (AssetClass)());
                this.mcChar.robe.visible = true;
            }
            else
            {
                this.mcChar.robe.visible = false;
            }
            AssetClass = (this.world.getClass(((strSkinLinkage + this.strGender) + "RobeBack")) as Class);
            if (AssetClass != null)
            {
                this.mcChar.backrobe.removeChildAt(0);
                this.mcChar.backrobe.addChild(new (AssetClass)());
                this.mcChar.backrobe.visible = true;
            }
            else
            {
                this.mcChar.backrobe.visible = false;
            }
            this.gotoAndPlay("in1");
            this.isLoaded = true;
            this.handleAfterAvatarLoad();
        }

        public function handleAfterAvatarLoad():void
        {
            if (((this.pAV.isCameraTool) || (this.pAV.isCharPage)))
            {
                return;
            }
            if (((this.world.rootClass.litePreference.data.bCachePlayers) && (!(this.isRasterized))))
            {
                if (!this.pAV.isMyAvatar)
                {
                    this.mcChar.gotoAndStop("Idle");
                    this.world.rootClass.rasterize(this.mcChar);
                    this.isRasterized = true;
                }
            }
            if (this.world.rootClass.litePreference.data.bHideNames)
            {
                this.hideNameSetup();
            }
            if (((this.world.rootClass.litePreference.data.bHidePlayers) && (!(this.pAV.isMyAvatar))))
            {
                this.mcChar.visible = false;
                this.pname.visible = this.world.rootClass.litePreference.data.dOptions["showNames"];
                this.shadow.visible = this.world.rootClass.litePreference.data.dOptions["showShadows"];
            }
        }

        public function hideNameSetup():void
        {
            if (this.world.rootClass.litePreference.data.dOptions["hideSelf"])
            {
                if (this.pAV.isMyAvatar)
                {
                    this.pname.visible = false;
                }
                else
                {
                    this.hideNameCleanup();
                }
                return;
            }
            this.pname.ti.visible = this.world.rootClass.litePreference.data.dOptions["hideGuild"];
            this.pname.tg.visible = false;
            if (!this.mcChar.hasEventListener(MouseEvent.ROLL_OVER))
            {
                this.mcChar.addEventListener(MouseEvent.ROLL_OVER, this.onNameHover, false, 0, true);
                this.mcChar.addEventListener(MouseEvent.ROLL_OUT, this.onNameOut, false, 0, true);
            }
        }

        public function hideNameCleanup():void
        {
            if (this.mcChar.hasEventListener(MouseEvent.ROLL_OVER))
            {
                this.mcChar.removeEventListener(MouseEvent.ROLL_OVER, this.onNameHover);
                this.mcChar.removeEventListener(MouseEvent.ROLL_OUT, this.onNameOut);
            }
            this.pname.visible = true;
            this.pname.ti.visible = true;
            this.pname.tg.visible = this.pname.tg.text;
        }

        public function onNameHover(_arg_1:MouseEvent):void
        {
            if (this.world.rootClass.litePreference.data.dOptions["hideGuild"])
            {
                this.pname.tg.visible = true;
            }
            else
            {
                this.pname.ti.visible = true;
                this.pname.tg.visible = true;
            }
        }

        public function onNameOut(_arg_1:MouseEvent):void
        {
            if (this.world.rootClass.litePreference.data.dOptions["hideGuild"])
            {
                this.pname.tg.visible = false;
            }
            else
            {
                this.pname.ti.visible = false;
                this.pname.tg.visible = false;
            }
        }

        public function loadArmorPiecesFromDomain(strSkinLinkage:String, pLoaderD:ApplicationDomain):void
        {
            var AssetClass:Class;
            var child:DisplayObject;
            try
            {
                AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Head")) as Class);
                child = this.mcChar.head.getChildByName("face");
                if (child != null)
                {
                    this.mcChar.head.removeChild(child);
                }
                this.testMC = this.mcChar.head.addChildAt(new (AssetClass)(), 0);
                this.testMC.name = "face";
            }
            catch(err:Error)
            {
                AssetClass = (pLoaderD.getDefinition(("mcHead" + strGender)) as Class);
                child = mcChar.head.getChildByName("face");
                if (child != null)
                {
                    mcChar.head.removeChild(child);
                }
                testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
                testMC.name = "face";
            }
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Chest")) as Class);
            this.mcChar.chest.removeChildAt(0);
            this.mcChar.chest.addChild(new (AssetClass)());
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Hip")) as Class);
            this.mcChar.hip.removeChildAt(0);
            this.mcChar.hip.addChild(new (AssetClass)());
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "FootIdle")) as Class);
            this.mcChar.idlefoot.removeChildAt(0);
            this.mcChar.idlefoot.addChild(new (AssetClass)());
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Foot")) as Class);
            this.mcChar.frontfoot.removeChildAt(0);
            this.mcChar.frontfoot.addChild(new (AssetClass)());
            this.mcChar.frontfoot.visible = false;
            this.mcChar.backfoot.removeChildAt(0);
            this.mcChar.backfoot.addChild(new (AssetClass)());
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Shoulder")) as Class);
            this.mcChar.frontshoulder.removeChildAt(0);
            this.mcChar.frontshoulder.addChild(new (AssetClass)());
            this.mcChar.backshoulder.removeChildAt(0);
            this.mcChar.backshoulder.addChild(new (AssetClass)());
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Hand")) as Class);
            this.mcChar.fronthand.removeChildAt(0);
            this.mcChar.fronthand.addChildAt(new (AssetClass)(), 0);
            this.mcChar.backhand.removeChildAt(0);
            this.mcChar.backhand.addChildAt(new (AssetClass)(), 0);
            var drk:Color = new Color();
            drk.brightness = -1;
            this.mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Thigh")) as Class);
            this.mcChar.frontthigh.removeChildAt(0);
            this.mcChar.frontthigh.addChild(new (AssetClass)());
            this.mcChar.backthigh.removeChildAt(0);
            this.mcChar.backthigh.addChild(new (AssetClass)());
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Shin")) as Class);
            this.mcChar.frontshin.removeChildAt(0);
            this.mcChar.frontshin.addChild(new (AssetClass)());
            this.mcChar.backshin.removeChildAt(0);
            this.mcChar.backshin.addChild(new (AssetClass)());
            try
            {
                AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "Robe")) as Class);
                if (AssetClass != null)
                {
                    this.mcChar.robe.removeChildAt(0);
                    this.mcChar.robe.addChild(new (AssetClass)());
                    this.mcChar.robe.visible = true;
                }
                else
                {
                    this.mcChar.robe.visible = false;
                }
            }
            catch(e:Error)
            {
                mcChar.robe.visible = false;
            }
            try
            {
                AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + this.strGender) + "RobeBack")) as Class);
                if (AssetClass != null)
                {
                    this.mcChar.backrobe.removeChildAt(0);
                    this.mcChar.backrobe.addChild(new (AssetClass)());
                    this.mcChar.backrobe.visible = true;
                }
                else
                {
                    this.mcChar.backrobe.visible = false;
                }
            }
            catch(e:Error)
            {
                mcChar.backrobe.visible = false;
            }
            this.gotoAndPlay("in1");
            this.isLoaded = true;
            this.handleAfterAvatarLoad();
        }

        public function loadHair():void
        {
            var _local_1:* = this.pAV.objData.strHairFilename;
            if (((((_local_1 == undefined) || (_local_1 == null)) || (_local_1 == "")) || (_local_1 == "none")))
            {

                this.mcChar.head.hair.visible = false;
                return;
            }

            this.hairLoad = false;
            this.world.queueLoad({
                "strFile":(this.world.rootClass.getFilePath() + _local_1),
                "callBackA": world.rootClass.onLoadToBytes(onHairLoadComplete, world.loaderC),
                "avt":this.pAV,
                "sES":"hair"
            });
        }

        public function onHairLoadComplete(e:Event):void
        {
            var AssetClass:Class;
            this.hairLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            try
            {
                AssetClass = (this.world.getClass(((this.pAV.objData.strHairName + this.pAV.objData.strGender) + "Hair")) as Class);
                if (AssetClass != null)
                {
                    if (this.mcChar.head.hair.numChildren > 0)
                    {
                        this.mcChar.head.hair.removeChildAt(0);
                    }
                    this.mcChar.head.hair.addChild(new (AssetClass)());
                    this.mcChar.head.hair.visible = true;
                }
                else
                {
                    this.mcChar.head.hair.visible = false;
                }
                AssetClass = (this.world.getClass(((this.pAV.objData.strHairName + this.pAV.objData.strGender) + "HairBack")) as Class);
                if (AssetClass != null)
                {
                    if (((!(this.helmBackHair)) || ((this.helmBackHair) && (!(this.pAV.dataLeaf.showHelm)))))
                    {
                        if (this.mcChar.backhair.numChildren > 0)
                        {
                            this.mcChar.backhair.removeChildAt(0);
                        }
                        this.mcChar.backhair.addChild(new (AssetClass)());
                        this.mcChar.backhair.visible = true;
                    }
                    this.bBackHair = true;
                }
                else
                {
                    this.mcChar.backhair.visible = false;
                    this.bBackHair = false;
                }
                if ((((this.pAV.isMyAvatar) && (!(MovieClip(parent.parent.parent).ui.mcPortrait.visible))) && (!(this.bLoadingHelm))))
                {
                    this.world.rootClass.showPortrait(pAV);
                }
                else
                {
                    if (this.pAV == this.world.myAvatar.target)
                    {
                        this.world.rootClass.showPortraitTarget(pAV);
                    }
                }
                if ((("he" in this.pAV.objData.eqp) && (!(this.pAV.objData.eqp.he == null))))
                {
                    if (this.pAV.dataLeaf.showHelm)
                    {
                        this.mcChar.head.hair.visible = false;
                        this.mcChar.backhair.visible = this.helmBackHair;
                    }
                    else
                    {
                        this.mcChar.head.hair.visible = true;
                        this.mcChar.backhair.visible = this.bBackHair;
                    }
                }
            }
            catch(e:Error)
            {
            }
        }

        public function loadWeapon(_arg_1:*, _arg_2:*):void
        {
            trace("LOAD WEAPON => " + _arg_1);

            this.weaponLoad = false;
            this.world.queueLoad({
                "strFile":(this.world.rootClass.getFilePath() + _arg_1),
                "callBackA":world.rootClass.onLoadToBytes(onLoadWeaponComplete, world.loaderC),
                "avt":this.pAV,
                "sES":"weapon"
            });
        }

        public function onLoadWeaponComplete(e:Event):void
        {
            var wItem:Object;
            var AssetClass:Class;
            this.weaponLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            wItem = this.pAV.getItemByEquipSlot("Weapon");
            if (this.mcChar.weaponFist.numChildren > 0)
            {
                this.mcChar.weaponFist.removeChildAt(0);
            }
            if (this.mcChar.weaponFistOff.numChildren > 0)
            {
                this.mcChar.weaponFistOff.removeChildAt(0);
            }
            if (this.mcChar.weapon.numChildren > 0)
            {
                this.mcChar.weapon.removeChildAt(0);
            }
            if (this.mcChar.fronthand.numChildren > 1)
            {
                this.mcChar.fronthand.removeChildAt(1);
            }
            if (this.mcChar.backhand.numChildren > 1)
            {
                this.mcChar.backhand.removeChildAt(1);
            }
            try
            {
                AssetClass = (this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class);
                if (wItem.sType == "Gauntlet")
                {
                    this.mcChar.fronthand.addChildAt(new (AssetClass)(), 1);
                    this.mcChar.fronthand.getChildAt(1).scaleX = 0.8;
                    this.mcChar.fronthand.getChildAt(1).scaleY = 0.8;
                    this.mcChar.fronthand.getChildAt(1).scaleX = (this.mcChar.fronthand.getChildAt(1).scaleX * -1);
                    this.mcChar.backhand.addChildAt(new (AssetClass)(), 1);
                    this.mcChar.backhand.getChildAt(1).scaleX = 0.8;
                    this.mcChar.backhand.getChildAt(1).scaleY = 0.8;
                    this.mcChar.backhand.getChildAt(1).scaleX = (this.mcChar.backhand.getChildAt(1).scaleX * -1);
                    this.mcChar.weapon.mcWeapon = new MovieClip();
                }
                else
                {
                    this.mcChar.weapon.mcWeapon = new (AssetClass)();
                    this.mcChar.weapon.addChild(this.mcChar.weapon.mcWeapon);
                }
            }
            catch(err:Error)
            {
                if (wItem.sType != "Gauntlet")
                {
                    mcChar.weapon.mcWeapon = MovieClip(e.target.content);
                    mcChar.weapon.addChild(mcChar.weapon.mcWeapon);
                }
            }
            this.mcChar.weapon.visible = false;
            this.mcChar.weaponOff.visible = false;
            this.mcChar.weaponFist.visible = false;
            this.mcChar.weaponFistOff.visible = false;
            if (wItem.sType != "Gauntlet")
            {
                this.mcChar.weapon.visible = true;
            }
            if (wItem.sType == "Dagger")
            {
                this.loadWeaponOff(this.pAV.objData.eqp.Weapon.sFile, this.pAV.objData.eqp.Weapon.sLink);
            }
            if ((((this.world.rootClass.litePreference.data.bDisWepAnim) && (!(wItem.ItemID == 4711))) && (!(wItem.ItemID == 31273))))
            {
                if ((((!(this.pAV.isMyAvatar)) && (this.world.rootClass.litePreference.data.dOptions["wepSelf"])) || (!(this.world.rootClass.litePreference.data.dOptions["wepSelf"]))))
                {
                    this.world.rootClass.movieClipStopAll(this.mcChar.weapon);
                }
            }
        }

        public function loadWeaponOff(_arg_1:*, _arg_2:*):void
        {
            this.weaponLoad = false;
            this.world.queueLoad({
                "strFile":(this.world.rootClass.getFilePath() + _arg_1),
                "callBackA":this.onLoadWeaponOffComplete,
                "avt":this.pAV,
                "sES":"weapon"
            });
        }

        public function onLoadWeaponOffComplete(e:Event):void
        {
            var AssetClass:Class;
            this.weaponLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            var wItem:Object = this.pAV.getItemByEquipSlot("Weapon");
            if (this.mcChar.weaponOff.numChildren > 0)
            {
                this.mcChar.weaponOff.removeChildAt(0);
            }
            try
            {
                AssetClass = (this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class);
                this.mcChar.weaponOff.addChild(new (AssetClass)());
            }
            catch(err:Error)
            {
                mcChar.weaponOff.addChild(e.target.content);
            }
            this.mcChar.weaponOff.visible = true;
            if (this.world.rootClass.litePreference.data.bDisWepAnim)
            {
                if ((((!(this.pAV.isMyAvatar)) && (this.world.rootClass.litePreference.data.dOptions["wepSelf"])) || (!(this.world.rootClass.litePreference.data.dOptions["wepSelf"]))))
                {
                    this.world.rootClass.movieClipStopAll(this.mcChar.weaponOff);
                }
            }
        }

        public function loadCape(_arg_1:*, _arg_2:*):void
        {
            this.capeLoad = false;
            this.world.queueLoad({
                "strFile":(this.world.rootClass.getFilePath() + _arg_1),
                "callBackA":world.rootClass.onLoadToBytes(onLoadCapeComplete, world.loaderC),
                "avt":this.pAV,
                "sES":"cape"
            });
        }

        public function onLoadCapeComplete(_arg_1:Event):void
        {
            var _local_2:Class;
            this.capeLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            try
            {
                _local_2 = (this.world.getClass(this.pAV.objData.eqp.ba.sLink) as Class);
                this.mcChar.cape.removeChildAt(0);
                this.mcChar.cape.cape = new (_local_2)();
                this.mcChar.cape.addChild(this.mcChar.cape.cape);
                this.setCloakVisibility(this.pAV.dataLeaf.showCloak);
            }
            catch(e)
            {
            }
        }

        public function loadHelm(_arg_1:*, _arg_2:*):void
        {
            this.helmLoad = false;
            this.world.queueLoad({
                "strFile":(this.world.rootClass.getFilePath() + _arg_1),
                "callBackA":world.rootClass.onLoadToBytes(onLoadHelmComplete, world.loaderC),
                "avt":this.pAV,
                "sES":"helm"
            });
            this.bLoadingHelm = true;
        }

        public function onLoadHelmComplete(_arg_1:Event):void
        {
            this.helmLoad = true;
            if (((this.pAV.isMyAvatar) && (this.pAV.FirstLoad)))
            {
                this.pAV.updateLoaded();
                if (this.pAV.LoadCount <= 0)
                {
                    this.pAV.firstDone();
                    this.world.rootClass.showTracking("7");
                    this.world.rootClass.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
                }
            }
            var _local_2:Class = (this.world.getClass(this.pAV.objData.eqp.he.sLink) as Class);
            var _local_3:Class = (this.world.getClass((this.pAV.objData.eqp.he.sLink + "_backhair")) as Class);
            if (_local_2 != null)
            {
                if (this.mcChar.head.helm.numChildren > 0)
                {
                    this.mcChar.head.helm.removeChildAt(0);
                }
                this.mcChar.head.helm.visible = this.pAV.dataLeaf.showHelm;
                this.mcChar.head.hair.visible = (!(this.mcChar.head.helm.visible));
                this.mcChar.backhair.visible = ((this.mcChar.head.hair.visible) && (this.bBackHair));
                if (_local_3 != null)
                {
                    if (this.pAV.dataLeaf.showHelm)
                    {
                        if (this.mcChar.backhair.numChildren > 0)
                        {
                            this.mcChar.backhair.removeChildAt(0);
                        }
                        this.mcChar.backhair.visible = true;
                        this.mcChar.backhair.addChild(new (_local_3)());
                    }
                    this.helmBackHair = true;
                }
                else
                {
                    this.helmBackHair = false;
                }
                this.mcChar.head.helm.addChild(new (_local_2)());
                if (this.pAV == this.world.myAvatar)
                {
                    trace("== onLoadHelmComplete ==");
                    trace("onLoadHelmComplete => OBJ DATA => " + JSON.stringify(pAV.objData));
                    this.world.rootClass.showPortrait(this.pAV);
                }
                if (this.pAV == this.world.myAvatar.target)
                {
                    this.world.rootClass.showPortraitTarget(this.pAV);
                }
            }
            this.bLoadingHelm = false;
        }

        public function setHelmVisibility(_arg_1:Boolean):void
        {
            if (((!(this.pAV.objData.eqp.he == null)) && (!(this.pAV.objData.eqp.he.sLink == null))))
            {
                if (_arg_1)
                {
                    if (((this.helmBackHair) && (this.bBackHair)))
                    {
                        this.pAV.loadMovieAtES("he", this.pAV.objData.eqp["he"].sFile, this.pAV.objData.eqp["he"].sLink);
                        return;
                    }
                    this.mcChar.head.helm.visible = true;
                    this.mcChar.head.hair.visible = false;
                    this.mcChar.backhair.visible = this.helmBackHair;
                }
                else
                {
                    if (((this.helmBackHair) && (this.bBackHair)))
                    {
                        this.loadHair();
                        return;
                    }
                    this.mcChar.head.helm.visible = false;
                    this.mcChar.head.hair.visible = true;
                    this.mcChar.backhair.visible = this.bBackHair;
                }
                if (this.pAV == this.world.myAvatar)
                {
                    this.world.rootClass.showPortrait(this.pAV);
                }
                if (this.pAV == this.world.myAvatar.target)
                {
                    this.world.rootClass.showPortraitTarget(this.pAV);
                }
            }
        }

        public function setCloakVisibility(_arg_1:Boolean):void
        {
            if (((!(this.pAV.objData.eqp.ba == null)) && (!(this.pAV.objData.eqp.ba.sLink == null))))
            {
                if (this.pAV.isMyAvatar)
                {
                    this.mcChar.cape.visible = _arg_1;
                }
                else
                {
                    if (this.pAV.isCharPage)
                    {
                        this.mcChar.cape.visible = _arg_1;
                    }
                    else
                    {
                        this.mcChar.cape.visible = ((_arg_1) && (!(this.world.hideAllCapes)));
                    }
                }
            }
        }

        public function setColor(_arg_1:MovieClip, _arg_2:String, _arg_3:String, _arg_4:String):void
        {
            var _local_5:Number = Number(this.pAV.objData[("intColor" + _arg_3)]);
            _arg_1.isColored = true;
            _arg_1.intColor = _local_5;
            _arg_1.strLocation = _arg_3;
            _arg_1.strShade = _arg_4;
            this.changeColor(_arg_1, _local_5, _arg_4);
        }

        public function changeColor(_arg_1:MovieClip, _arg_2:Number, _arg_3:String, _arg_4:String=""):void
        {
            var _local_5:ColorTransform = new ColorTransform();
            if (_arg_4 == "")
            {
                _local_5.color = _arg_2;
            }
            switch (_arg_3.toUpperCase())
            {
                case "LIGHT":
                    _local_5.redOffset = (_local_5.redOffset + 100);
                    _local_5.greenOffset = (_local_5.greenOffset + 100);
                    _local_5.blueOffset = (_local_5.blueOffset + 100);
                    break;
                case "DARK":
                    _local_5.redOffset = (_local_5.redOffset - ((_arg_1.strLocation == "Skin") ? 25 : 50));
                    _local_5.greenOffset = (_local_5.greenOffset - 50);
                    _local_5.blueOffset = (_local_5.blueOffset - 50);
                    break;
                case "DARKER":
                    _local_5.redOffset = (_local_5.redOffset - 125);
                    _local_5.greenOffset = (_local_5.greenOffset - 125);
                    _local_5.blueOffset = (_local_5.blueOffset - 125);
                    break;
            }
            if (_arg_4 == "-")
            {
                _local_5.redOffset = (_local_5.redOffset * -1);
                _local_5.greenOffset = (_local_5.greenOffset * -1);
                _local_5.blueOffset = (_local_5.blueOffset * -1);
            }
            if (((_arg_4 == "") || (!(_arg_1.transform.colorTransform.redOffset == _local_5.redOffset))))
            {
                _arg_1.transform.colorTransform = _local_5;
            }
        }

        public function modulateColor(_arg_1:ColorTransform, _arg_2:String):void
        {
            var _local_3:MovieClip = (this.stage.getChildAt(0) as MovieClip);
            if (_arg_2 == "+")
            {
                this.totalTransform.alphaMultiplier = (this.totalTransform.alphaMultiplier + _arg_1.alphaMultiplier);
                this.totalTransform.alphaOffset = (this.totalTransform.alphaOffset + _arg_1.alphaOffset);
                this.totalTransform.redMultiplier = (this.totalTransform.redMultiplier + _arg_1.redMultiplier);
                this.totalTransform.redOffset = (this.totalTransform.redOffset + _arg_1.redOffset);
                this.totalTransform.greenMultiplier = (this.totalTransform.greenMultiplier + _arg_1.greenMultiplier);
                this.totalTransform.greenOffset = (this.totalTransform.greenOffset + _arg_1.greenOffset);
                this.totalTransform.blueMultiplier = (this.totalTransform.blueMultiplier + _arg_1.blueMultiplier);
                this.totalTransform.blueOffset = (this.totalTransform.blueOffset + _arg_1.blueOffset);
            }
            else
            {
                if (_arg_2 == "-")
                {
                    this.totalTransform.alphaMultiplier = (this.totalTransform.alphaMultiplier - _arg_1.alphaMultiplier);
                    this.totalTransform.alphaOffset = (this.totalTransform.alphaOffset - _arg_1.alphaOffset);
                    this.totalTransform.redMultiplier = (this.totalTransform.redMultiplier - _arg_1.redMultiplier);
                    this.totalTransform.redOffset = (this.totalTransform.redOffset - _arg_1.redOffset);
                    this.totalTransform.greenMultiplier = (this.totalTransform.greenMultiplier - _arg_1.greenMultiplier);
                    this.totalTransform.greenOffset = (this.totalTransform.greenOffset - _arg_1.greenOffset);
                    this.totalTransform.blueMultiplier = (this.totalTransform.blueMultiplier - _arg_1.blueMultiplier);
                    this.totalTransform.blueOffset = (this.totalTransform.blueOffset - _arg_1.blueOffset);
                }
            }
            this.clampedTransform.alphaMultiplier = _local_3.clamp(this.totalTransform.alphaMultiplier, -1, 1);
            this.clampedTransform.alphaOffset = _local_3.clamp(this.totalTransform.alphaOffset, -255, 0xFF);
            this.clampedTransform.redMultiplier = _local_3.clamp(this.totalTransform.redMultiplier, -1, 1);
            this.clampedTransform.redOffset = _local_3.clamp(this.totalTransform.redOffset, -255, 0xFF);
            this.clampedTransform.greenMultiplier = _local_3.clamp(this.totalTransform.greenMultiplier, -1, 1);
            this.clampedTransform.greenOffset = _local_3.clamp(this.totalTransform.greenOffset, -255, 0xFF);
            this.clampedTransform.blueMultiplier = _local_3.clamp(this.totalTransform.blueMultiplier, -1, 1);
            this.clampedTransform.blueOffset = _local_3.clamp(this.totalTransform.blueOffset, -255, 0xFF);
            this.transform.colorTransform = this.clampedTransform;
        }

        public function updateColor(_arg_1:Object=null):*
        {
            var _local_2:* = this.pAV.objData;
            if (_arg_1 != null)
            {
                _local_2 = _arg_1;
            }
            var _local_3:* = MovieClip(stage.getChildAt(0)).ui;
            this.scanColor(this, _local_2);
            if ((((!(this.pAV == null)) && (!(_local_3.mcPortrait.pAV == null))) && (_local_3.mcPortrait.pAV == this.pAV)))
            {
                this.scanColor(_local_3.mcPortrait.mcHead, _local_2);
            }
            if ((((!(this.pAV == null)) && (!(_local_3.mcPortraitTarget.pAV == null))) && (_local_3.mcPortraitTarget.pAV == this.pAV)))
            {
                this.scanColor(_local_3.mcPortraitTarget.mcHead, _local_2);
            }
        }

        private function scanColor(_arg_1:MovieClip, _arg_2:*):void
        {
            var _local_4:DisplayObject;
            if (("isColored" in _arg_1))
            {
                this.changeColor(_arg_1, Number(_arg_2[("intColor" + _arg_1.strLocation)]), _arg_1.strShade);
            }
            var _local_3:int;
            while (_local_3 < _arg_1.numChildren)
            {
                _local_4 = _arg_1.getChildAt(_local_3);
                if ((_local_4 is MovieClip))
                {
                    this.scanColor(MovieClip(_local_4), _arg_2);
                }
                _local_3++;
            }
        }

        public function queueAnim(s:String):void
        {
            var petSplit:Array;
            var p:String;
            var pItem:Object;
            var sType:* = undefined;
            var l:String;
            var sES:* = undefined;
            var world:MovieClip = (MovieClip(stage.getChildAt(0)).world as MovieClip);
            if ((((this.pAV.isMyAvatar) && (world.rootClass.litePreference.data.bDisSelfMAnim)) && (!(s == "Walk"))))
            {
                return;
            }
            if ((((!(this.pAV.isMyAvatar)) && (!(world.showAnimations))) && (!(s == "Walk"))))
            {
                return;
            }
            if ((((s.indexOf("Pet") > -1) && (this.pAV.petMC)) && (!(this.pAV.petMC.stage == null))))
            {
                pItem = this.pAV.getItemByEquipSlot("pe");
                if (s.indexOf(":") > -1)
                {
                    petSplit = s.split(":");
                    s = petSplit[0];
                    try
                    {
                        if (pItem != null)
                        {
                            if (petSplit[1] == "PetAttack")
                            {
                                p = ["Attack1", "Attack2"][Math.round((Math.random() * 1))];
                                if (this.pAV.petMC.mcChar.currentLabel == "Idle")
                                {
                                    this.pAV.petMC.mcChar.gotoAndPlay(p);
                                }
                            }
                            else
                            {
                                p = petSplit[1].slice(3);
                                if (this.pAV.petMC.mcChar.currentLabel == "Idle")
                                {
                                    this.pAV.petMC.mcChar.gotoAndPlay(p);
                                }
                            }
                        }
                    }
                    catch(e)
                    {
                    }
                }
                else
                {
                    if (pItem != null)
                    {
                        try
                        {
                            p = ["Attack1", "Attack2"][Math.round((Math.random() * 1))];
                            if (this.pAV.petMC.mcChar.currentLabel == "Idle")
                            {
                                this.pAV.petMC.mcChar.gotoAndPlay(p);
                            }
                            return;
                        }
                        catch(e)
                        {
                            s = ["Attack1", "Attack2"][Math.round((Math.random() * 1))];
                        }
                    }
                    else
                    {
                        s = ((s.indexOf("1") > -1) ? "Attack1" : "Attack2");
                    }
                }
            }
            var wItem:Object = this.pAV.getItemByEquipSlot("Weapon");
            if (((s == "Attack1") || (s == "Attack2")))
            {
                if (((!(wItem == null)) && (!(wItem.sType == null))))
                {
                    sType = wItem.sType;
                    if (((wItem.ItemID == 156) || (wItem.ItemID == 12583)))
                    {
                        sType = "Unarmed";
                    }
                    switch (sType)
                    {
                        case "Unarmed":
                            s = ["UnarmedAttack1", "UnarmedAttack2", "KickAttack", "FlipAttack"][Math.round((Math.random() * 3))];
                            break;
                        case "Polearm":
                            s = ["PolearmAttack1", "PolearmAttack2"][Math.round((Math.random() * 1))];
                            break;
                        case "Dagger":
                            s = ["DuelWield/DaggerAttack1", "DuelWield/DaggerAttack2"][Math.round((Math.random() * 1))];
                            break;
                        case "Bow":
                            s = "RangedAttack3";
                            break;
                        case "Whip":
                            s = "WhipAttack";
                            break;
                        case "HandGun":
                            s = ["GunAttack", "GunAttack2"][Math.round((Math.random() * 1))];
                            break;
                        case "Rifle":
                            s = "RifleAttack2";
                            break;
                        case "Gauntlet":
                            s = ["UnarmedAttack1", "UnarmedAttack2", "FistweaponAttack1", "FistweaponAttack2"][Math.round((Math.random() * 3))];
                            break;
                    }
                }
            }
            if (((this.hasLabel(s)) && (this.pAV.dataLeaf.intState > 0)))
            {
                this.pAV.handleItemAnimation();
                l = this.mcChar.currentLabel;
                if (((world.combatAnims.indexOf(s) > -1) && (world.combatAnims.indexOf(l) > -1)))
                {
                    this.animQueue.push(s);
                }
                else
                {
                    this.mcChar.gotoAndPlay(s);
                    if (this.pAV.dataLeaf.intState == 2)
                    {
                        if (this.pAV.objData.eqp != null)
                        {
                            for (sES in this.pAV.objData.eqp)
                            {
                                this.handleAttack(sES);
                            }
                        }
                    }
                }
            }
        }

        private function checkQueue(_arg_1:Event):Boolean
        {
            var _local_2:MovieClip;
            var _local_3:String;
            var _local_4:int;
            var _local_5:*;
            var _local_6:*;
            if (this.animQueue.length > 0)
            {
                _local_2 = (MovieClip(stage.getChildAt(0)).world as MovieClip);
                _local_3 = this.mcChar.currentLabel;
                _local_4 = this.mcChar.emoteLoopFrame();
                if (((_local_2.combatAnims.indexOf(_local_3) > -1) && (this.mcChar.currentFrame > (_local_4 + 4))))
                {
                    _local_5 = this.animQueue[0];
                    this.mcChar.gotoAndPlay(_local_5);
                    if (this.pAV.dataLeaf.intState == 2)
                    {
                        if (this.pAV.objData.eqp != null)
                        {
                            for (_local_6 in this.pAV.objData.eqp)
                            {
                                this.handleAttack(_local_6);
                            }
                        }
                    }
                    this.animQueue.shift();
                    return (true);
                }
            }
            return (false);
        }

        public function performAttack(_arg_1:*):void
        {
            var _local_2:int;
            if (!(_arg_1 is MovieClip))
            {
                return;
            }
            _arg_1 = MovieClip(_arg_1);
            while (((_local_2 < 4) && (_arg_1)))
            {
                if (_arg_1.hasOwnProperty("bAttack"))
                {
                    _arg_1.gotoAndPlay("Attack");
                }
                else
                {
                    if (((_arg_1.numChildren > 0) && (_arg_1.getChildAt(0) is MovieClip)))
                    {
                        _arg_1 = MovieClip(_arg_1.getChildAt(0));
                        _local_2++;
                        continue;
                    }
                }
                return;
            }
        }

        public function handleAttack(_arg_1:String):void
        {
            var _local_3:*;
            var _local_5:Array;
            var _local_6:*;
            var _local_7:*;
            var _local_2:Object = this.pAV.getItemByEquipSlot(_arg_1);
            if (_arg_1 == "Weapon")
            {
                if (_local_2.sType == "Gauntlet")
                {
                    _local_5 = [(this.mcChar.fronthand.getChildAt(1) as MovieClip).getChildAt(1), (this.mcChar.backhand.getChildAt(1) as MovieClip).getChildAt(0)];
                    for each (_local_6 in _local_5)
                    {
                        this.performAttack(_local_6);
                    }
                    return;
                }
                if (_local_2.sType == "Dagger")
                {
                    _local_5 = [this.mcChar.weapon.mcWeapon, this.mcChar.weaponOff];
                    if (this.mcChar.weapon.mcWeapon.numChildren > 1)
                    {
                        _local_5 = [(this.mcChar.weapon.mcWeapon as MovieClip).getChildAt(1), (this.mcChar.weaponOff as MovieClip).getChildAt(0)];
                    }
                    for each (_local_6 in _local_5)
                    {
                        this.performAttack(_local_6);
                    }
                    return;
                }
                _local_3 = this.mcChar.weapon.mcWeapon;
                this.performAttack(_local_3);
                return;
            }
            var _local_4:int;
            while (_local_4 < this.attackFrames.length)
            {
                _local_7 = this.attackFrames[_local_4];
                if (!_local_7)
                {
                    this.attackFrames.splice(_local_4, 1);
                    _local_4--;
                }
                else
                {
                    if ((_local_7 is MovieClip))
                    {
                        MovieClip(_local_7).gotoAndPlay("Attack");
                    }
                }
                _local_4++;
            }
        }

        public function clearQueue():void
        {
            this.animQueue = [];
        }

        private function linearTween(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Number
        {
            return (((_arg_3 * _arg_1) / _arg_4) + _arg_2);
        }

        public function walkTo(toX:int, toY:int, walkSpeed:int):void
        {
            var dist:Number;
            var turned:Boolean;
            var dx:Number;
            if (((this.pAV.isMyAvatar) && (this.pAV.isWorldCamera)))
            {
                return;
            }
            var isOK:Boolean = true;
            try
            {
                this.STAGE = MovieClip(parent.parent);
            }
            catch(e:Error)
            {
                isOK = false;
            }
            if (isOK)
            {
                this.op = new Point(this.x, this.y);
                this.tp = new Point(toX, toY);
                if (((!(this.pAV.petMC == null)) && (!(this.pAV.petMC.mcChar == null))))
                {
                    turned = false;
                    if ((this.op.x - this.tp.x) < 0)
                    {
                        if (this.pAV.petMC.mcChar.scaleX < 0)
                        {
                            this.pAV.petMC.turn("right");
                            turned = true;
                        }
                    }
                    else
                    {
                        if (this.pAV.petMC.mcChar.scaleX > 0)
                        {
                            this.pAV.petMC.turn("left");
                            turned = true;
                        }
                    }
                    this.pAV.petMC.walkTo((toX - 20), (toY + 5), (walkSpeed - 3));
                }
                this.walkSpeed = walkSpeed;
                dist = Point.distance(this.op, this.tp);
                this.walkTS = new Date().getTime();
                this.walkD = Math.round((1000 * (dist / (walkSpeed * 22))));
                if (this.walkD > 0)
                {
                    dx = (this.op.x - this.tp.x);
                    if (dx < 0)
                    {
                        this.turn("right");
                    }
                    else
                    {
                        this.turn("left");
                    }
                    if (!this.mcChar.onMove)
                    {
                        this.mcChar.onMove = true;
                        if (this.mcChar.currentLabel != "Walk")
                        {
                            this.mcChar.gotoAndPlay("Walk");
                        }
                    }
                    this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
                    this.addEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
                }
            }
        }

        private function lerp(_arg_1:*, _arg_2:*, _arg_3:*):Number
        {
            return (_arg_1 + ((_arg_2 - _arg_1) * _arg_3));
        }

        public function calculateNewPxPy():void
        {
            var _local_1:* = MovieClip(stage.getChildAt(0));
            var _local_2:Number = ((_local_1.mtcidNow - this.mvts) / this.mvtd);
            if (_local_2 > 1)
            {
                this.x = this.tx;
                this.y = this.ty;
                this.resetSyncVars();
                return;
            }
            this.x = Math.floor(this.lerp(this.px, this.tx, _local_2));
            this.y = Math.floor(this.lerp(this.py, this.ty, _local_2));
        }

        public function resetSyncVars():void
        {
            this.px = 0;
            this.py = 0;
            this.mvts = 0;
            this.mvtd = 0;
            this.mcChar.onMove = false;
        }

        public function destroyWalkFrame():void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
            if (this.mcChar.onMove)
            {
                this.stopWalking();
            }
        }

        private function onEnterFrameWalk(_arg_1:Event):void
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:Boolean;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:int;
            var _local_12:Boolean;
            var _local_13:Point;
            var _local_14:Rectangle;
            var _local_2:Number = new Date().getTime();
            var _local_3:Number = ((_local_2 - this.walkTS) / this.walkD);
            if (_local_3 > 1)
            {
                _local_3 = 1;
            }
            if (((Point.distance(this.op, this.tp) > 0.5) && (this.mcChar.onMove)))
            {
                _local_4 = this.x;
                _local_5 = this.y;
                this.x = Point.interpolate(this.tp, this.op, _local_3).x;
                this.y = Point.interpolate(this.tp, this.op, _local_3).y;
                _local_6 = false;
                _local_7 = 0;
                while (_local_7 < this.STAGE.arrSolid.length)
                {
                    if (this.shadow.hitTestObject(this.STAGE.arrSolid[_local_7].shadow))
                    {
                        _local_6 = true;
                        _local_7 = this.STAGE.arrSolid.length;
                    }
                    _local_7++;
                }
                if (_local_6)
                {
                    _local_8 = this.y;
                    this.y = _local_5;
                    _local_6 = false;
                    _local_9 = 0;
                    while (_local_9 < this.STAGE.arrSolid.length)
                    {
                        if (this.shadow.hitTestObject(this.STAGE.arrSolid[_local_9].shadow))
                        {
                            this.y = _local_8;
                            _local_6 = true;
                            break;
                        }
                        _local_9++;
                    }
                    if (_local_6)
                    {
                        this.x = _local_4;
                        _local_6 = false;
                        _local_10 = 0;
                        while (_local_10 < this.STAGE.arrSolid.length)
                        {
                            if (this.shadow.hitTestObject(this.STAGE.arrSolid[_local_10].shadow))
                            {
                                _local_6 = true;
                                break;
                            }
                            _local_10++;
                        }
                        if (_local_6)
                        {
                            this.x = _local_4;
                            this.y = _local_5;
                            this.stopWalking();
                        }
                    }
                }
                if ((((Math.round(_local_4) == Math.round(this.x)) && (Math.round(_local_5) == Math.round(this.y))) && (_local_2 > (this.walkTS + 50))))
                {
                    this.stopWalking();
                }
                if (this.pAV.isMyAvatar)
                {
                    Game.root.world.mapScrollCheck();
                    this.checkPadLabels();
                    _local_11 = 0;
                    while (_local_11 < this.STAGE.arrEvent.length)
                    {
                        _local_12 = false;
                        this.world = MovieClip(stage.getChildAt(0)).world;
                        if (this.world.bPvP)
                        {
                            _local_13 = this.shadow.localToGlobal(new Point(0, 0));
                            _local_14 = this.STAGE.arrEvent[_local_11].shadow.getBounds(stage);
                            if (_local_14.containsPoint(_local_13))
                            {
                                _local_12 = true;
                            }
                        }
                        else
                        {
                            if (this.shadow.hitTestObject(this.STAGE.arrEvent[_local_11].shadow))
                            {
                                _local_12 = true;
                            }
                        }
                        if (_local_12)
                        {
                            if (((!(this.STAGE.arrEvent[_local_11]._entered)) && (MovieClip(this.STAGE.arrEvent[_local_11]).isEvent)))
                            {
                                this.STAGE.arrEvent[_local_11]._entered = true;
                                if (this == MovieClip(parent.parent).myAvatar.pMC)
                                {
                                    this.STAGE.arrEvent[_local_11].dispatchEvent(new Event("enter"));
                                }
                            }
                        }
                        else
                        {
                            if (this.STAGE.arrEvent[_local_11]._entered)
                            {
                                this.STAGE.arrEvent[_local_11]._entered = false;
                            }
                        }
                        _local_11++;
                    }
                }
            }
            else
            {
                this.stopWalking();
            }
        }

        public function simulateTo(_arg_1:int, _arg_2:int, _arg_3:int):Point
        {
            this.STAGE = MovieClip(parent.parent);
            this.xDep = this.x;
            this.yDep = this.y;
            this.xTar = _arg_1;
            this.yTar = _arg_2;
            this.walkSpeed = _arg_3;
            this.nDuration = Math.round((Math.sqrt((Math.pow((this.xTar - this.x), 2) + Math.pow((this.yTar - this.y), 2))) / _arg_3));
            var _local_4:* = new Point();
            if (this.nDuration)
            {
                this.nXStep = 0;
                this.nYStep = 0;
                if (!this.mcChar.onMove)
                {
                    this.mcChar.onMove = true;
                }
                _local_4 = this.simulateWalkLoop();
            }
            else
            {
                _local_4 = null;
            }
            this.x = this.xDep;
            this.y = this.yDep;
            this.mcChar.onMove = false;
            return (_local_4);
        }

        private function simulateWalkLoop():Point
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:Boolean;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            while ((((this.nXStep <= this.nDuration) || (this.nYStep <= this.nDuration)) && (this.mcChar.onMove)))
            {
                _local_1 = this.x;
                _local_2 = this.y;
                this.x = this.linearTween(this.nXStep, this.xDep, (this.xTar - this.xDep), this.nDuration);
                this.y = this.linearTween(this.nYStep, this.yDep, (this.yTar - this.yDep), this.nDuration);
                _local_3 = false;
                _local_4 = 0;
                while (_local_4 < this.STAGE.arrSolid.length)
                {
                    if (this.shadow.hitTestObject(this.STAGE.arrSolid[_local_4].shadow))
                    {
                        _local_3 = true;
                        _local_4 = this.STAGE.arrSolid.length;
                    }
                    _local_4++;
                }
                if (_local_3)
                {
                    _local_5 = this.y;
                    this.y = _local_2;
                    _local_3 = false;
                    _local_6 = 0;
                    while (_local_6 < this.STAGE.arrSolid.length)
                    {
                        if (this.shadow.hitTestObject(this.STAGE.arrSolid[_local_6].shadow))
                        {
                            this.y = _local_5;
                            _local_3 = true;
                            break;
                        }
                        _local_6++;
                    }
                    if (_local_3)
                    {
                        this.x = _local_1;
                        _local_3 = false;
                        _local_7 = 0;
                        while (_local_7 < this.STAGE.arrSolid.length)
                        {
                            if (this.shadow.hitTestObject(this.STAGE.arrSolid[_local_7].shadow))
                            {
                                _local_3 = true;
                                break;
                            }
                            _local_7++;
                        }
                        if (_local_3)
                        {
                            this.x = _local_1;
                            this.y = _local_2;
                            this.mcChar.onMove = false;
                            this.nDuration = -1;
                            return (new Point(this.x, this.y));
                        }
                        if (this.nYStep <= this.nDuration)
                        {
                            this.nYStep++;
                        }
                    }
                    else
                    {
                        if (this.nXStep <= this.nDuration)
                        {
                            this.nXStep++;
                        }
                    }
                }
                else
                {
                    if (this.nXStep <= this.nDuration)
                    {
                        this.nXStep++;
                    }
                    if (this.nYStep <= this.nDuration)
                    {
                        this.nYStep++;
                    }
                }
                if ((((Math.round(_local_1) == Math.round(this.x)) && (Math.round(_local_2) == Math.round(this.y))) && ((this.nXStep > 1) || (this.nYStep > 1))))
                {
                    this.mcChar.onMove = false;
                    this.nDuration = -1;
                    return (new Point(this.x, this.y));
                }
            }
            this.mcChar.onMove = false;
            this.nDuration = -1;
            return (new Point(this.x, this.y));
        }

        public function stopWalking():void
        {
            this.world = MovieClip(stage.getChildAt(0)).world;
            if (this.mcChar.onMove)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
                if (((this.pAV.isMyAvatar) && (MovieClip(parent.parent).actionReady)))
                {
                    this.world.testAction(this.world.getAutoAttack());
                }
            }
            this.mcChar.onMove = false;
            this.mcChar.gotoAndPlay("Idle");
            this.px = 0;
            this.py = 0;
        }

        public function checkPadLabels():*
        {
            var _local_4:*;
            var _local_5:*;
            var _local_1:* = MovieClip(stage.getChildAt(0));
            var _local_2:* = _local_1.ui;
            var _local_3:int;
            while (_local_3 < _local_2.mcPadNames.numChildren)
            {
                _local_4 = MovieClip(_local_2.mcPadNames.getChildAt(_local_3));
                _local_5 = new Point(4, 8);
                _local_5 = _local_4.cnt.localToGlobal(_local_5);
                if (_local_1.distanceO(this, _local_5) < 200)
                {
                    if (!_local_4.isOn)
                    {
                        _local_4.isOn = true;
                        _local_4.gotoAndPlay("in");
                    }
                }
                else
                {
                    if (_local_4.isOn)
                    {
                        _local_4.isOn = false;
                        _local_4.gotoAndPlay("out");
                    }
                }
                _local_3++;
            }
        }

        public function turn(_arg_1:String):void
        {
            if ((((_arg_1 == "right") && (this.mcChar.scaleX < 0)) || ((_arg_1 == "left") && (this.mcChar.scaleX > 0))))
            {
                this.mcChar.scaleX = (this.mcChar.scaleX * -1);
                if (((!(this.pAV.morphMC == null)) && (this.pAV.morphMC.visible)))
                {
                    this.pAV.morphMC.scaleX = (this.pAV.morphMC.scaleX * -1);
                }
            }
        }

        public function scale(_arg_1:Number):void
        {
            if ((this.mcChar.scaleX >= 0))
            {
                this.mcChar.scaleX = _arg_1;
            }
            else
            {
                this.mcChar.scaleX = -(_arg_1);
            }
            this.mcChar.scaleY = _arg_1;
            this.shadow.scaleX = (this.shadow.scaleY = _arg_1);
            this.cShadow.scaleX = (this.cShadow.scaleY = _arg_1);
            var _local_2:Point = this.mcChar.localToGlobal(this.headPoint);
            _local_2 = this.globalToLocal(_local_2);
            this.pname.y = int(_local_2.y);
            this.bubble.y = int((this.pname.y - this.bubble.height));
            this.ignore.y = int(((this.pname.y - this.ignore.height) - 2));
            this.drawHitBox();
        }

        public function endAction():void
        {
            var _local_2:Number;
            var _local_3:String;
            var _local_4:Object;
            var _local_5:*;
            var _local_1:* = null;
            if (this.pAV.target != null)
            {
                _local_1 = this.pAV.target.pMC.mcChar;
            }
            if (!this.checkQueue(null))
            {
                if (this.mcChar.onMove)
                {
                    this.mcChar.gotoAndPlay("Walk");
                    _local_2 = (this.x - this.xTar);
                    if ((_local_2 < 0))
                    {
                        this.turn("right");
                    }
                    else
                    {
                        this.turn("left");
                    }
                }
                else
                {
                    if (((_local_1 == null) || ((!(_local_1 == null)) && ((((_local_1.currentLabel == "Die") || (_local_1.currentLabel == "Feign")) || (_local_1.currentLabel == "Dead")) || ((this.pAV.target.npcType == "player") && ((!("pvpTeam" in this.pAV.dataLeaf)) || (this.pAV.dataLeaf.pvpTeam == this.pAV.target.dataLeaf.pvpTeam)))))))
                    {
                        if (this.mcChar.currentLabel != "Jump")
                        {
                            this.mcChar.gotoAndPlay("Idle");
                        }
                        if (_local_1 != null)
                        {
                            if (this.pAV.target.dataLeaf.intState == 0)
                            {
                                if (this.pAV == this.world.myAvatar)
                                {
                                    this.world.setTarget(null);
                                }
                            }
                        }
                    }
                    else
                    {
                        _local_3 = "Fight";
                        _local_4 = this.pAV.getItemByEquipSlot("Weapon");
                        if (((!(_local_4 == null)) && (!(_local_4.sType == null))))
                        {
                            _local_5 = _local_4.sType;
                            if (_local_4.ItemID == 156)
                            {
                                _local_5 = "Unarmed";
                            }
                            switch (_local_5)
                            {
                                case "Bow":
                                    _local_3 = "RangedFight";
                                    break;
                                case "Rifle":
                                    _local_3 = "RifleFight";
                                    break;
                                case "Gauntlet":
                                    _local_3 = "UnarmedFight";
                                    break;
                                case "Unarmed":
                                    _local_3 = "UnarmedFight";
                                    break;
                                case "Polearm":
                                    _local_3 = "PolearmFight";
                                    break;
                                case "Dagger":
                                    _local_3 = "DuelWield/DaggerFight";
                                    break;
                            }
                        }
                        this.mcChar.gotoAndPlay(_local_3);
                    }
                }
            }
        }

        private function drawHitBox():void
        {
            this.mcChar.hitbox.graphics.clear();
            var _local_1:int = -30;
            var _local_2:int = 60;
            var _local_3:int = this.mcChar.head.y;
            var _local_4:int = (-(_local_3) * 0.8);
            this.hitboxR = new Rectangle(_local_1, _local_3, _local_2, _local_4);
            var _local_5:Graphics = this.mcChar.hitbox.graphics;
            _local_5.lineStyle(0, 0xFFFFFF, 0);
            _local_5.beginFill(0xAA00FF, 0);
            _local_5.moveTo(_local_1, _local_3);
            _local_5.lineTo((_local_1 + _local_2), _local_3);
            _local_5.lineTo((_local_1 + _local_2), (_local_3 + _local_4));
            _local_5.lineTo(_local_1, (_local_3 + _local_4));
            _local_5.lineTo(_local_1, _local_3);
            _local_5.endFill();
        }

        public function showHealIcon():void
        {
            var _local_1:HealIconMC;
            if (this.rootClass.litePreference.data.bDisHealBubble)
            {
                return;
            }
            if (!getChildByName("HealIconMC"))
            {
                _local_1 = new HealIconMC(this.pAV, this.world);
                _local_1.name = "HealIconMC";
                addChild(_local_1);
            }
        }

        private function randomNumber(_arg_1:Number, _arg_2:Number):Number
        {
            this.randNum = (_arg_1 + (((_arg_2 + 1) - _arg_1) * this.XORandom()));
            return ((this.randNum < _arg_2) ? this.randNum : _arg_2);
        }

        private function XORandom():Number
        {
            this.r = (this.r ^ (this.r << 21));
            this.r = (this.r ^ (this.r >>> 35));
            this.r = (this.r ^ (this.r << 4));
            if (this.r > 0)
            {
                return (this.r * this.MAX_RATIO);
            }
            return (this.r * this.NEGA_MAX_RATIO);
        }

        public function iaF(_arg_1:Object):void
        {
            var _local_2:MovieClip;
            _local_2 = (this.mcChar.head.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.chest.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.hip.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.idlefoot.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.frontfoot.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.backfoot.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.frontshoulder.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.backshoulder.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.fronthand.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.backhand.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.frontthigh.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.backthigh.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.frontshin.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.backshin.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.robe.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
            _local_2 = (this.mcChar.backrobe.getChildAt(0) as MovieClip);
            if (_local_2 != null)
            {
                try
                {
                    _local_2.iaF(_arg_1);
                }
                catch(e)
                {
                }
            }
        }

        public function clearSpFXQueue():void
        {
            this._spFXQueue = [];
        }

        public function canCastSpFX():void
        {
            if (this._spFXQueue.length < 1)
            {
                return;
            }
            this.world.castSpellFX(this.pAV, this.nextSpFX, null, 0);
        }

        public function get nextSpFX():Object
        {
            return (this._spFXQueue.shift());
        }

        public function queueSpFX(_arg_1:Object):void
        {
            if (this.spFX.strl != "")
            {
                this._spFXQueue.push(_arg_1);
            }
            else
            {
                this.spFX = _arg_1;
            }
        }

        public function playSound():void
        {
        }

        public function addAnimationListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=true):void
        {
            if (this.animEvents[_arg_1] == null)
            {
                this.animEvents[_arg_1] = [];
            }
            if (!this.hasAnimationListener(_arg_1, _arg_2))
            {
                this.animEvents[_arg_1].push(_arg_2);
                this.animEvents[_arg_1].push(_arg_3);
            }
        }

        public function removeAnimationListener(_arg_1:String, _arg_2:Function):void
        {
            if (this.animEvents[_arg_1] == null)
            {
                return;
            }
            var _local_3:uint;
            while (_local_3 < this.animEvents[_arg_1].length)
            {
                if (this.animEvents[_arg_1][_local_3] == _arg_2)
                {
                    this.animEvents[_arg_1].splice(_local_3, 1);
                    return;
                }
                _local_3 = (_local_3 + 2);
            }
        }

        public function hasAnimationListener(_arg_1:String, _arg_2:Function):Boolean
        {
            if (this.animEvents[_arg_1] == null)
            {
                return (false);
            }
            var _local_3:uint;
            while (_local_3 < this.animEvents[_arg_1].length)
            {
                if (this.animEvents[_arg_1][_local_3] == _arg_2)
                {
                    return (true);
                }
                _local_3 = (_local_3 + 2);
            }
            return (false);
        }

        private function handleAnimEvent(_arg_1:String):void
        {
            var _local_2:Function;
            if (this.animEvents[_arg_1] == null)
            {
                return;
            }
            var _local_3:uint;
            while (_local_3 < this.animEvents[_arg_1].length)
            {
                _local_2 = this.animEvents[_arg_1][_local_3];
                (_local_2());
                _local_3 = (_local_3 + 2);
            }
        }

        public function clearAnimEvents():void
        {
            this.animEvents = {};
        }

        public function get AnimEvent():Object
        {
            return (this.animEvents);
        }

        public function artLoaded():Boolean
        {
            return (((((((this.weaponLoad) && (this.capeLoad)) && (this.helmLoad)) && (this.armorLoad)) && (this.classLoad)) && (this.hairLoad)) && (this.miscLoad));
        }

        internal function frame1():*
        {
            this.mcChar.transform.colorTransform = this.CT1;
            this.mcChar.alpha = 0;
            stop();
        }

        internal function frame5():*
        {
            this.mcChar.transform.colorTransform = this.CT1;
            this.mcChar.alpha = 0;
        }

        internal function frame8():*
        {
            stop();
        }

        internal function frame10():*
        {
            this.mcChar.alpha = 0;
        }

        internal function frame12():*
        {
            this.mcChar.transform.colorTransform = this.CT3;
        }

        internal function frame13():*
        {
            this.mcChar.transform.colorTransform = this.CT2;
        }

        internal function frame14():*
        {
            this.mcChar.transform.colorTransform = this.CT1;
        }

        internal function frame18():*
        {
            stop();
        }

        internal function frame20():*
        {
            this.mcChar.transform.colorTransform = this.CT1;
        }

        internal function frame23():*
        {
            stop();
        }


    }
}//package 

