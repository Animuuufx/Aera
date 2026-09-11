// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.cameraTool

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import fl.events.ColorPickerEvent;
    import flash.events.Event;
    import fl.data.DataProvider;
    import fl.events.SliderEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;
    import flash.filters.GlowFilter;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import fl.data.*;
    import flash.utils.*;
    import fl.events.*;
    import flash.filters.*;

    public class cameraTool extends MovieClip 
    {

        public var weaponUI:MovieClip;
        public var background:MovieClip;
        public var dummyMC:MovieClip;
        public var btnLeft:SimpleButton;
        public var btnClose:SimpleButton;
        public var txtRight:TextField;
        public var btnExpand:SimpleButton;
        public var txtLeft:TextField;
        public var btnExpandTxt:TextField;
        public var btnRight:SimpleButton;
        public var cameratoolUI:MovieClip;
        public var AvatarDisplay:AvatarMC;
        internal var rootClass:MovieClip;
        private var op:*;
        private var tp:*;
        private var walkTS:*;
        private var walkD:*;
        public var mcCharHidden:Boolean;
        public var mcCharOptions:Object = {
            "backhair":false,
            "robe":false,
            "backrobe":false
        };
        public var scaleAvt:Number = 3;
        public var weaponDeattached:Boolean;
        public var deattachedMain:MovieClip;
        public var deattachedOff:MovieClip;
        public var weaponFocus:int = 0;
        public var isMirrored:Boolean;
        public var isMirroredOff:Boolean;
        public var isFrozen:Boolean;
        public var isStoned:Boolean;
        public var isHit:Boolean;
        public var glowMain:Boolean;
        public var glowOff:Boolean;
        public var glowPlayer:Boolean;
        internal var oldX:int;
        internal var oldY:int;

        public function cameraTool(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            this.btnExpandTxt.mouseEnabled = false;
            this.weaponUI.visible = false;
            this.dummyMC.visible = false;
            this.cameratoolUI.secondary.visible = false;
            this.btnExpand.addEventListener(MouseEvent.CLICK, onBtnExpand, false, 0, true);
            AvatarDisplay = new AvatarMC();
            AvatarDisplay.world = rootClass.world;
            this.copyTo(AvatarDisplay.mcChar);
            AvatarDisplay.x = 650;
            AvatarDisplay.y = 450;
            AvatarDisplay.hideHPBar();
            AvatarDisplay.gotoAndPlay("in2");
            AvatarDisplay.mcChar.gotoAndPlay("Idle");
            this.addChild(AvatarDisplay);
            AvatarDisplay.scale(scaleAvt);
            AvatarDisplay.shadow.visible = false;
            this.cameratoolUI.primary.txtClassName.text = rootClass.world.myAvatar.objData.strClassName;
            this.background.mouseEnabled = true;
            this.background.addEventListener(MouseEvent.CLICK, onWalk, false, 0, true);
            this.cameratoolUI.primary.colBG.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColBG, false, 0, true);
            this.cameratoolUI.primary.colBG.addEventListener(Event.CLOSE, onColBG, false, 0, true);
            var _local_2:Array = [{"label":"Idle"}, {"label":"Walk"}, {"label":"Dance"}, {"label":"Laugh"}, {"label":"Point"}, {"label":"Use"}, {"label":"Stern"}, {"label":"SternLoop"}, {"label":"Salute"}, {"label":"Cheer"}, {"label":"Facepalm"}, {"label":"Airguitar"}, {"label":"Backflip"}, {"label":"Sleep"}, {"label":"Jump"}, {"label":"Punt"}, {"label":"Dance2"}, {"label":"Swordplay"}, {"label":"Feign"}, {"label":"Dead"}, {"label":"Wave"}, {"label":"Bow"}, {"label":"Rest"}, {"label":"Cry"}, {"label":"Unsheath"}, {"label":"Fight"}, {"label":"Attack1"}, {"label":"Attack2"}, {"label":"Attack3"}, {"label":"Attack4"}, {"label":"Hit"}, {"label":"Knockout"}, {"label":"Getup"}, {"label":"Stab"}, {"label":"Thrash"}, {"label":"Castgood"}, {"label":"Cast1"}, {"label":"Cast2"}, {"label":"Cast3"}, {"label":"Sword/ShieldFight"}, {"label":"Sword/ShieldAttack1"}, {"label":"Sword/ShieldAttack2"}, {"label":"ShieldBlock"}, {"label":"DuelWield/DaggerFight"}, {"label":"DuelWield/DaggerAttack1"}, {"label":"DuelWield/DaggerAttack2"}, {"label":"FistweaponFight"}, {"label":"FistweaponAttack1"}, {"label":"FistweaponAttack2"}, {"label":"PolearmFight"}, {"label":"PolearmAttack1"}, {"label":"PolearmAttack2"}, {"label":"RangedFight"}, {"label":"UnarmedFight"}, {"label":"UnarmedAttack1"}, {"label":"UnarmedAttack2"}, {"label":"KickAttack"}, {"label":"FlipAttack"}, {"label":"Dodge"}, {"label":"Powerup"}, {"label":"Kneel"}, {"label":"Jumpcheer"}, {"label":"Salute2"}, {"label":"Cry2"}, {"label":"Spar"}, {"label":"Samba"}, {"label":"Stepdance"}, {"label":"Headbang"}, {"label":"Dazed"}, {"label":"Psychic1"}, {"label":"Psychic2"}, {"label":"Danceweapon"}, {"label":"Useweapon"}, {"label":"Throw"}, {"label":"FireBreath"}];
            _local_2.sortOn("label");
            this.cameratoolUI.primary.cbEmotes.dataProvider = new DataProvider(_local_2);
            this.cameratoolUI.primary.btnEmote.addEventListener(MouseEvent.CLICK, onBtnEmote, false, 0, true);
            this.cameratoolUI.primary.btnClass1.addEventListener(MouseEvent.CLICK, onBtnClass, false, 0, true);
            this.cameratoolUI.primary.btnClass2.addEventListener(MouseEvent.CLICK, onBtnClass, false, 0, true);
            this.cameratoolUI.primary.btnClass3.addEventListener(MouseEvent.CLICK, onBtnClass, false, 0, true);
            this.cameratoolUI.primary.btnClass4.addEventListener(MouseEvent.CLICK, onBtnClass, false, 0, true);
            this.cameratoolUI.primary.btnClass5.addEventListener(MouseEvent.CLICK, onBtnClass, false, 0, true);
            this.cameratoolUI.primary.btnToggleDummy.addEventListener(MouseEvent.CLICK, onBtnToggleDummy, false, 0, true);
            this.dummyMC.addEventListener(MouseEvent.MOUSE_DOWN, onDummyDown, false, 0, true);
            this.dummyMC.addEventListener(MouseEvent.MOUSE_UP, onDummyUp, false, 0, true);
            var _local_3:Array = [{"label":"Mainhand"}, {"label":"Offhand"}, {"label":"Cape"}, {"label":"Helmet"}, {"label":"Player"}, {"label":"Shadow"}, {"label":"Head"}, {"label":"Robe"}, {"label":"Back Robe"}, {"label":"Misc"}, {"label":"Backhair"}];
            _local_3.sortOn("label");
            this.cameratoolUI.primary.cbVisibility.dataProvider = new DataProvider(_local_3);
            this.cameratoolUI.primary.btnVisibility.addEventListener(MouseEvent.CLICK, onBtnVisibility, false, 0, true);
            this.cameratoolUI.primary.numScaling.addEventListener(Event.CHANGE, onNumScaling, false, 0, true);
            this.cameratoolUI.primary.btnDeattach.addEventListener(MouseEvent.CLICK, onBtnDeattach, false, 0, true);
            this.cameratoolUI.primary.btnShowDeattach.addEventListener(MouseEvent.CLICK, onBtnShowDeattach, false, 0, true);
            this.weaponUI.background.addEventListener(MouseEvent.MOUSE_DOWN, onWeaponUIDown, false, 0, true);
            this.weaponUI.background.addEventListener(MouseEvent.MOUSE_UP, onWeaponUIUp, false, 0, true);
            this.weaponUI.txtFocus.mouseEnabled = false;
            this.weaponUI.btnSetFocus.addEventListener(MouseEvent.CLICK, onBtnSetFocus, false, 0, true);
            this.weaponUI.sldrRotation.addEventListener(SliderEvent.CHANGE, onSldrRotation, false, 0, true);
            this.weaponUI.btnAddLayer.addEventListener(MouseEvent.CLICK, onBtnAddLayer, false, 0, true);
            this.weaponUI.btnDelLayer.addEventListener(MouseEvent.CLICK, onBtnDelLayer, false, 0, true);
            this.weaponUI.numWepScale.addEventListener(Event.CHANGE, onNumWepScale, false, 0, true);
            this.weaponUI.btnMirror.addEventListener(MouseEvent.CLICK, onBtnMirror, false, 0, true);
            this.weaponUI.btnInCombat.addEventListener(MouseEvent.CLICK, onBtnInCombat, false, 0, true);
            this.cameratoolUI.primary.btnFreezePlayer.addEventListener(MouseEvent.CLICK, onBtnFreezePlayer, false, 0, true);
            this.cameratoolUI.primary.btnStonePlayer.addEventListener(MouseEvent.CLICK, onBtnStonePlayer, false, 0, true);
            this.cameratoolUI.primary.btnHitPlayer.addEventListener(MouseEvent.CLICK, onBtnHitPlayer, false, 0, true);
            this.cameratoolUI.primary.btnResetPlayer.addEventListener(MouseEvent.CLICK, onBtnResetPlayer, false, 0, true);
            this.cameratoolUI.primary.colGlow.addEventListener(Event.CLOSE, onColGlow, false, 0, true);
            this.cameratoolUI.primary.colGlow.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColGlow, false, 0, true);
            this.cameratoolUI.primary.colGlowMain.addEventListener(Event.CLOSE, onColGlowMain, false, 0, true);
            this.cameratoolUI.primary.colGlowMain.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColGlowMain, false, 0, true);
            this.cameratoolUI.primary.colGlowOff.addEventListener(Event.CLOSE, onColGlowOff, false, 0, true);
            this.cameratoolUI.primary.colGlowOff.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColGlowOff, false, 0, true);
            this.cameratoolUI.primary.btnGlowMain.addEventListener(MouseEvent.CLICK, onBtnGlowMain, false, 0, true);
            this.cameratoolUI.primary.btnGlowOff.addEventListener(MouseEvent.CLICK, onBtnGlowOff, false, 0, true);
            this.cameratoolUI.primary.btnGlowPlayer.addEventListener(MouseEvent.CLICK, onBtnGlowPlayer, false, 0, true);
            this.cameratoolUI.secondary.btnGender.addEventListener(MouseEvent.CLICK, onBtnGender, false, 0, true);
            this.cameratoolUI.secondary.btnTurnHead.addEventListener(MouseEvent.CLICK, onBtnTurnHead, false, 0, true);
            this.txtLeft.mouseEnabled = false;
            this.txtRight.mouseEnabled = false;
            this.btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
            this.btnLeft.addEventListener(MouseEvent.CLICK, onBtnLeft, false, 0, true);
            this.btnRight.addEventListener(MouseEvent.CLICK, onBtnRight, false, 0, true);
        }

        public function onBtnLeft(_arg_1:MouseEvent):void
        {
            this.cameratoolUI.primary.visible = (!(this.cameratoolUI.primary.visible));
            this.cameratoolUI.secondary.visible = (!(this.cameratoolUI.secondary.visible));
        }

        public function onBtnRight(_arg_1:MouseEvent):void
        {
            this.cameratoolUI.primary.visible = (!(this.cameratoolUI.primary.visible));
            this.cameratoolUI.secondary.visible = (!(this.cameratoolUI.secondary.visible));
        }

        public function copyTo(_arg_1:MovieClip):void
        {
            var _local_4:*;
            var _local_2:* = undefined;
            AvatarDisplay.pAV = rootClass.world.myAvatar;
            AvatarDisplay.pAV.isCameraTool = true;
            AvatarDisplay.strGender = AvatarDisplay.pAV.objData.strGender;
            var _local_3:* = ["cape", "backhair", "robe", "backrobe"];
            for (_local_2 in _local_3)
            {
                if (typeof(_arg_1[_local_3[_local_2]]) != undefined)
                {
                    _arg_1[_local_3[_local_2]].visible = false;
                };
            };
            if (((!(AvatarDisplay.pAV.dataLeaf.showHelm)) || ((!("he" in AvatarDisplay.pAV.objData.eqp)) && (AvatarDisplay.pAV.objData.eqp.he == null))))
            {
                AvatarDisplay.loadHair();
            };
            for (_local_4 in rootClass.world.myAvatar.objData.eqp)
            {
                switch (_local_4)
                {
                    case "Weapon":
                        AvatarDisplay.loadWeapon(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        break;
                    case "he":
                        if (AvatarDisplay.pAV.dataLeaf.showHelm)
                        {
                            AvatarDisplay.loadHelm(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        };
                        break;
                    case "ba":
                        if (AvatarDisplay.pAV.dataLeaf.showCloak)
                        {
                            AvatarDisplay.loadCape(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        };
                        break;
                    case "ar":
                        if (rootClass.world.myAvatar.objData.eqp.co == null)
                        {
                            AvatarDisplay.loadClass(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        };
                        break;
                    case "co":
                        AvatarDisplay.loadArmor(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, AvatarDisplay.pAV.objData.eqp[_local_4].sLink);
                        break;
                    case "mi":
                        AvatarDisplay.loadMisc(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, AvatarDisplay.pAV.objData.eqp[_local_4].sLink);
                        break;
                };
            };
        }

        public function loadWeaponOff(_arg_1:*, _arg_2:*):void
        {
            rootClass.world.queueLoad({
                "strFile":(rootClass.world.rootClass.getFilePath() + _arg_1),
                "callBackA":this.onLoadWeaponOffComplete,
                "avt":AvatarDisplay.pAV,
                "sES":"weapon"
            });
        }

        public function onLoadWeaponOffComplete(param1:Event):void
        {
            var AssetClass:Class;
            AvatarDisplay.pAV.updateLoaded();
            AvatarDisplay.mcChar.weaponOff.removeChildAt(0);
            try
            {
                AssetClass = (rootClass.world.getClass(AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class);
                AvatarDisplay.mcChar.weaponOff.addChild(new (AssetClass)());
            }
            catch(err:Error)
            {
                AvatarDisplay.mcChar.weaponOff.addChild(param1.target.content);
            };
            AvatarDisplay.mcChar.weaponOff.visible = true;
        }

        public function onBtnClose(_arg_1:MouseEvent):void
        {
            rootClass.world.visible = true;
            AvatarDisplay.pAV.isCameraTool = false;
            this.parent.removeChild(this);
            rootClass.stage.focus = null;
        }

        public function onWalk(_arg_1:MouseEvent):void
        {
            if (isFrozen)
            {
                return;
            };
            walkTo(_arg_1.stageX, _arg_1.stageY, 16);
        }

        public function walkTo(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:Number;
            var _local_5:Number;
            op = new Point(AvatarDisplay.x, AvatarDisplay.y);
            tp = new Point(_arg_1, _arg_2);
            _local_4 = Point.distance(op, tp);
            walkTS = new Date().getTime();
            walkD = Math.round((1000 * (_local_4 / (_arg_3 * 22))));
            if (walkD > 0)
            {
                _local_5 = (op.x - tp.x);
                if (_local_5 < 0)
                {
                    AvatarDisplay.turn("right");
                }
                else
                {
                    AvatarDisplay.turn("left");
                };
                if (!AvatarDisplay.mcChar.onMove)
                {
                    AvatarDisplay.mcChar.onMove = true;
                    if (AvatarDisplay.mcChar.currentLabel != "Walk")
                    {
                        AvatarDisplay.mcChar.gotoAndPlay("Walk");
                    };
                };
                AvatarDisplay.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
                AvatarDisplay.addEventListener(Event.ENTER_FRAME, onEnterFrameWalk, false, 0, true);
            };
        }

        public function onEnterFrameWalk(_arg_1:Event):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:*;
            var _local_5:*;
            var _local_6:Boolean;
            var _local_7:Point;
            var _local_8:Rectangle;
            _local_2 = new Date().getTime();
            _local_3 = ((_local_2 - walkTS) / walkD);
            if (_local_3 > 1)
            {
                _local_3 = 1;
            };
            if (((Point.distance(op, tp) > 0.5) && (AvatarDisplay.mcChar.onMove)))
            {
                _local_4 = AvatarDisplay.x;
                _local_5 = AvatarDisplay.y;
                AvatarDisplay.x = Point.interpolate(tp, op, _local_3).x;
                AvatarDisplay.y = Point.interpolate(tp, op, _local_3).y;
                if ((((Math.round(_local_4) == Math.round(AvatarDisplay.x)) && (Math.round(_local_5) == Math.round(AvatarDisplay.y))) && (_local_2 > (walkTS + 50))))
                {
                    stopWalking();
                };
            }
            else
            {
                stopWalking();
            };
        }

        public function stopWalking():void
        {
            if (AvatarDisplay.mcChar.onMove)
            {
                AvatarDisplay.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
            };
            AvatarDisplay.mcChar.onMove = false;
            AvatarDisplay.mcChar.gotoAndPlay("Idle");
        }

        public function onBtnExpand(_arg_1:MouseEvent):void
        {
            if (cameratoolUI.visible)
            {
                this.cameratoolUI.visible = false;
                this.weaponUI.visible = false;
                this.btnLeft.visible = false;
                this.btnRight.visible = false;
                this.txtLeft.visible = false;
                this.txtRight.visible = false;
                this.btnExpandTxt.text = "+";
            }
            else
            {
                this.cameratoolUI.visible = true;
                this.btnLeft.visible = true;
                this.btnRight.visible = true;
                this.txtLeft.visible = true;
                this.txtRight.visible = true;
                this.btnExpandTxt.text = "-";
            };
        }

        public function onColBG(_arg_1:*):void
        {
            var _local_2:* = new ColorTransform();
            _local_2.color = ("0x" + _arg_1.currentTarget.hexValue);
            this.background.transform.colorTransform = _local_2;
        }

        public function onBtnEmote(_arg_1:MouseEvent):void
        {
            if (this.cameratoolUI.primary.cbEmotes.selectedItem.label == "Walk")
            {
                AvatarDisplay.mcChar.onMove = true;
            }
            else
            {
                AvatarDisplay.mcChar.onMove = false;
            };
            AvatarDisplay.mcChar.gotoAndPlay(this.cameratoolUI.primary.cbEmotes.selectedItem.label);
        }

        public function onBtnClass(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            var _local_3:*;
            switch (_arg_1.currentTarget.name)
            {
                case "btnClass1":
                    _local_2 = rootClass.world.actions.active[0].anim;
                    _local_3 = rootClass.world.actions.active[0];
                    break;
                case "btnClass2":
                    _local_2 = rootClass.world.actions.active[1].anim;
                    _local_3 = rootClass.world.actions.active[1];
                    break;
                case "btnClass3":
                    _local_2 = rootClass.world.actions.active[2].anim;
                    _local_3 = rootClass.world.actions.active[2];
                    break;
                case "btnClass4":
                    _local_2 = rootClass.world.actions.active[3].anim;
                    _local_3 = rootClass.world.actions.active[3];
                    break;
                case "btnClass5":
                    _local_2 = rootClass.world.actions.active[4].anim;
                    _local_3 = rootClass.world.actions.active[4];
                    break;
            };
            if (_local_2.indexOf(",") > -1)
            {
                _local_2 = _local_2.split(",")[Math.round((Math.random() * (_local_2.split(",").length - 1)))];
            };
            AvatarDisplay.spFX.strl = _local_3.strl;
            AvatarDisplay.spFX.fx = _local_3.fx;
            AvatarDisplay.spFX.tgt = _local_3.tgt;
            AvatarDisplay.mcChar.gotoAndPlay(_local_2);
        }

        public function init_func():void
        {
        }

        public function castSpellFX(_arg_1:*=null):*
        {
            var _local_3:*;
            if (_arg_1 == null)
            {
                _arg_1 = AvatarDisplay.spFX;
            };
            var _local_2:Class = (rootClass.world.getClass(_arg_1.strl) as Class);
            if (_local_2 != null)
            {
                _local_3 = new (_local_2)();
                _local_3.spellDur = 0;
                this.addChild(_local_3);
                _local_3.scaleX = (_local_3.scaleX * scaleAvt);
                _local_3.scaleY = (_local_3.scaleY * scaleAvt);
                _local_3.mouseEnabled = false;
                _local_3.mouseChildren = false;
                _local_3.visible = true;
                _local_3.world = this;
                _local_3.strl = _arg_1.strl;
                if (((_arg_1.tgt) && (_arg_1.tgt == "s")))
                {
                    _local_3.tMC = AvatarDisplay;
                }
                else
                {
                    if (!this.dummyMC.mcChar)
                    {
                        this.dummyMC.mcChar = {"height":122};
                    };
                    _local_3.tMC = this.dummyMC;
                };
                switch (_arg_1.fx)
                {
                    case "w":
                        _local_3.x = _local_3.tMC.x;
                        _local_3.y = (_local_3.tMC.y + 3);
                        _local_3.scaleX = (_local_3.scaleX * ((_local_3.tMC.x < AvatarDisplay.x) ? -1 : 1));
                        return;
                    case "p":
                        _local_3.x = AvatarDisplay.x;
                        _local_3.y = (AvatarDisplay.y - (AvatarDisplay.mcChar.height * 0.5));
                        _local_3.dir = (((_local_3.tMC.x - AvatarDisplay.x) >= 0) ? 1 : -1);
                        return;
                };
            };
        }

        public function showSpellFXHit(_arg_1:*):*
        {
            var _local_2:* = {};
            switch (_arg_1.strl)
            {
                case "sp_ice1":
                    _local_2.strl = "sp_ice2";
                    break;
                case "sp_el3":
                    _local_2.strl = "sp_el2";
                    break;
                case "sp_ed3":
                    _local_2.strl = "sp_ed1";
                    break;
                case "sp_ef1":
                case "sp_ef6":
                    _local_2.strl = "sp_ef2";
                    break;
            };
            _local_2.fx = "w";
            _local_2.avts = [_arg_1.tMC];
            this.castSpellFX(_local_2);
        }

        public function onBtnToggleDummy(_arg_1:MouseEvent):void
        {
            this.dummyMC.visible = (!(this.dummyMC.visible));
        }

        public function onDummyDown(_arg_1:MouseEvent):void
        {
            this.dummyMC.startDrag();
        }

        public function onDummyUp(_arg_1:MouseEvent):void
        {
            this.dummyMC.stopDrag();
        }

        public function get isCharHidden():Boolean
        {
            return (mcCharHidden);
        }

        public function onBtnVisibility(_arg_1:MouseEvent):void
        {
            switch (cameratoolUI.primary.cbVisibility.selectedItem.label)
            {
                case "Mainhand":
                    AvatarDisplay.mcChar.weapon.visible = (!(AvatarDisplay.mcChar.weapon.visible));
                    return;
                case "Offhand":
                    AvatarDisplay.mcChar.weaponOff.visible = (!(AvatarDisplay.mcChar.weaponOff.visible));
                    return;
                case "Cape":
                    AvatarDisplay.mcChar.cape.visible = (!(AvatarDisplay.mcChar.cape.visible));
                    return;
                case "Helmet":
                    AvatarDisplay.mcChar.head.helm.visible = (!(AvatarDisplay.mcChar.head.helm.visible));
                    AvatarDisplay.mcChar.head.hair.visible = (!(AvatarDisplay.mcChar.head.helm.visible));
                    return;
                case "Player":
                    mcCharHidden = (!(mcCharHidden));
                    if (!mcCharHidden)
                    {
                        AvatarDisplay.mcChar.head.visible = true;
                        AvatarDisplay.mcChar.chest.visible = true;
                        AvatarDisplay.mcChar.frontshoulder.visible = true;
                        AvatarDisplay.mcChar.backshoulder.visible = true;
                        AvatarDisplay.mcChar.fronthand.visible = true;
                        AvatarDisplay.mcChar.backhand.visible = true;
                        AvatarDisplay.mcChar.frontthigh.visible = true;
                        AvatarDisplay.mcChar.backthigh.visible = true;
                        AvatarDisplay.mcChar.frontshin.visible = true;
                        AvatarDisplay.mcChar.backshin.visible = true;
                        AvatarDisplay.mcChar.idlefoot.visible = true;
                        AvatarDisplay.mcChar.backfoot.visible = true;
                        AvatarDisplay.mcChar.hip.visible = true;
                        AvatarDisplay.mcChar.robe.visible = mcCharOptions["robe"];
                        AvatarDisplay.mcChar.backrobe.visible = mcCharOptions["backrobe"];
                        AvatarDisplay.mcChar.backhair.visible = mcCharOptions["backhair"];
                    }
                    else
                    {
                        AvatarDisplay.mcChar.head.visible = false;
                        AvatarDisplay.mcChar.chest.visible = false;
                        AvatarDisplay.mcChar.frontshoulder.visible = false;
                        AvatarDisplay.mcChar.backshoulder.visible = false;
                        AvatarDisplay.mcChar.fronthand.visible = false;
                        AvatarDisplay.mcChar.backhand.visible = false;
                        AvatarDisplay.mcChar.frontthigh.visible = false;
                        AvatarDisplay.mcChar.backthigh.visible = false;
                        AvatarDisplay.mcChar.frontshin.visible = false;
                        AvatarDisplay.mcChar.backshin.visible = false;
                        AvatarDisplay.mcChar.idlefoot.visible = false;
                        AvatarDisplay.mcChar.backfoot.visible = false;
                        AvatarDisplay.mcChar.hip.visible = false;
                        if (AvatarDisplay.mcChar.robe.visible)
                        {
                            AvatarDisplay.mcChar.robe.visible = false;
                            mcCharOptions["robe"] = true;
                        };
                        if (AvatarDisplay.mcChar.backrobe.visible)
                        {
                            AvatarDisplay.mcChar.backrobe.visible = false;
                            mcCharOptions["backrobe"] = true;
                        };
                        if (AvatarDisplay.mcChar.backhair.visible)
                        {
                            AvatarDisplay.mcChar.backhair.visible = false;
                            mcCharOptions["backhair"] = true;
                        };
                    };
                    return;
                case "Shadow":
                    AvatarDisplay.shadow.visible = (!(AvatarDisplay.shadow.visible));
                    return;
                case "Head":
                    AvatarDisplay.mcChar.head.visible = (!(AvatarDisplay.mcChar.head.visible));
                    return;
                case "Robe":
                    AvatarDisplay.mcChar.robe.visible = (!(AvatarDisplay.mcChar.robe.visible));
                    return;
                case "Back Robe":
                    AvatarDisplay.mcChar.backrobe.visible = (!(AvatarDisplay.mcChar.backrobe.visible));
                    return;
                case "Misc":
                    AvatarDisplay.cShadow.visible = (!(AvatarDisplay.cShadow.visible));
                    return;
                case "Backhair":
                    AvatarDisplay.mcChar.backhair.visible = (!(AvatarDisplay.mcChar.backhair.visible));
                    return;
            };
        }

        public function onNumScaling(_arg_1:Event):void
        {
            scaleAvt = this.cameratoolUI.primary.numScaling.textField.text;
            AvatarDisplay.scale(scaleAvt);
        }

        public function onBtnDeattach(_arg_1:MouseEvent):void
        {
            var _local_2:Object;
            if (weaponDeattached)
            {
                weaponDeattached = false;
                isMirrored = false;
                isMirroredOff = false;
                this.cameratoolUI.primary.txtDeattached.text = "Weapon Deattachment: OFF";
                deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponDownDrag);
                deattachedMain.removeEventListener(MouseEvent.MOUSE_UP, onWeaponUpDrag);
                AvatarDisplay.mcChar.weapon.visible = true;
                _local_2 = AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
                if (((!(_local_2 == null)) && (!(_local_2.sType == null))))
                {
                    if (_local_2.sType == "Dagger")
                    {
                        AvatarDisplay.mcChar.weaponOff.visible = true;
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponOffDownDrag);
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_UP, onWeaponOffUpDrag);
                    };
                };
                AvatarDisplay.mcChar.removeChild(deattachedMain);
                AvatarDisplay.mcChar.removeChild(deattachedOff);
                deattachedMain = null;
                deattachedOff = null;
            }
            else
            {
                weaponDeattached = true;
                this.cameratoolUI.primary.txtDeattached.text = "Weapon Deattachment: ON";
                rootClass.world.queueLoad({
                    "strFile":(rootClass.world.rootClass.getFilePath() + AvatarDisplay.pAV.objData.eqp.Weapon.sFile),
                    "callBackA":this.onLoadWeaponClones,
                    "avt":AvatarDisplay.pAV,
                    "sES":"weapon"
                });
                AvatarDisplay.mcChar.weapon.visible = false;
                AvatarDisplay.mcChar.weaponOff.visible = false;
            };
        }

        public function onLoadWeaponClones(e:*):void
        {
            var AssetClass:Class;
            try
            {
                AssetClass = (rootClass.world.getClass(AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class);
                deattachedMain = new (AssetClass)();
            }
            catch(err:Error)
            {
                deattachedMain = MovieClip(e.target.content);
            };
            AvatarDisplay.mcChar.addChild(deattachedMain);
            deattachedMain.addEventListener(MouseEvent.MOUSE_DOWN, onWeaponDownDrag, false, 0, true);
            deattachedMain.addEventListener(MouseEvent.MOUSE_UP, onWeaponUpDrag, false, 0, true);
            deattachedMain.scaleX = (deattachedMain.scaleY = 0.222);
            var wItem:Object = AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
            if (((!(wItem == null)) && (!(wItem.sType == null))))
            {
                if (wItem.sType == "Dagger")
                {
                    rootClass.world.queueLoad({
                        "strFile":(rootClass.world.rootClass.getFilePath() + AvatarDisplay.pAV.objData.eqp.Weapon.sFile),
                        "callBackA":this.onLoadWeaponOffClones,
                        "avt":AvatarDisplay.pAV,
                        "sES":"weapon"
                    });
                };
            };
        }

        public function onLoadWeaponOffClones(e:*):void
        {
            var AssetClass:Class;
            try
            {
                AssetClass = (rootClass.world.getClass(AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class);
                deattachedOff = new (AssetClass)();
            }
            catch(err:Error)
            {
                deattachedOff = MovieClip(e.target.content);
            };
            AvatarDisplay.mcChar.addChild(deattachedOff);
            deattachedOff.scaleX = (deattachedOff.scaleY = 0.222);
            deattachedOff.addEventListener(MouseEvent.MOUSE_UP, onWeaponOffUpDrag, false, 0, true);
            deattachedOff.addEventListener(MouseEvent.MOUSE_DOWN, onWeaponOffDownDrag, false, 0, true);
        }

        public function onWeaponUpDrag(_arg_1:MouseEvent):void
        {
            deattachedMain.stopDrag();
        }

        public function onWeaponDownDrag(_arg_1:MouseEvent):void
        {
            deattachedMain.startDrag();
        }

        public function onWeaponOffUpDrag(_arg_1:MouseEvent):void
        {
            deattachedOff.stopDrag();
        }

        public function onWeaponOffDownDrag(_arg_1:MouseEvent):void
        {
            deattachedOff.startDrag();
        }

        public function onBtnShowDeattach(_arg_1:MouseEvent):void
        {
            if (!weaponDeattached)
            {
                this.weaponUI.visible = false;
                return;
            };
            this.weaponUI.visible = (!(this.weaponUI.visible));
            if (this.weaponUI.visible)
            {
                this.setChildIndex(this.weaponUI, (this.numChildren - 1));
            };
        }

        public function onBtnSetFocus(_arg_1:MouseEvent):void
        {
            if (!deattachedOff)
            {
                weaponFocus = 0;
                this.weaponUI.txtFocus.text = "Mainhand";
                return;
            };
            weaponFocus++;
            if (weaponFocus >= 3)
            {
                weaponFocus = 0;
            };
            switch (weaponFocus)
            {
                case 0:
                    this.weaponUI.txtFocus.text = "Mainhand";
                    return;
                case 1:
                    this.weaponUI.txtFocus.text = "Offhand";
                    return;
                case 2:
                    this.weaponUI.txtFocus.text = "Both";
                    return;
            };
        }

        public function onSldrRotation(_arg_1:Event):void
        {
            switch (weaponFocus)
            {
                case 0:
                    deattachedMain.rotation = this.weaponUI.sldrRotation.value;
                    return;
                case 1:
                    deattachedOff.rotation = this.weaponUI.sldrRotation.value;
                    return;
                case 2:
                    deattachedMain.rotation = this.weaponUI.sldrRotation.value;
                    deattachedOff.rotation = this.weaponUI.sldrRotation.value;
                    return;
            };
        }

        public function onBtnAddLayer(_arg_1:MouseEvent):void
        {
            switch (weaponFocus)
            {
                case 0:
                    if (AvatarDisplay.mcChar.getChildIndex(deattachedMain) >= (AvatarDisplay.mcChar.numChildren - 2))
                    {
                        return;
                    };
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, (AvatarDisplay.mcChar.getChildIndex(deattachedMain) + 1));
                    return;
                case 1:
                    if (AvatarDisplay.mcChar.getChildIndex(deattachedOff) >= (AvatarDisplay.mcChar.numChildren - 2))
                    {
                        return;
                    };
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, (AvatarDisplay.mcChar.getChildIndex(deattachedOff) + 1));
                    return;
                case 2:
                    if (((AvatarDisplay.mcChar.getChildIndex(deattachedMain) >= (AvatarDisplay.mcChar.numChildren - 2)) || (AvatarDisplay.mcChar.getChildIndex(deattachedOff) == (AvatarDisplay.mcChar.numChildren - 2))))
                    {
                        return;
                    };
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, (AvatarDisplay.mcChar.getChildIndex(deattachedMain) + 1));
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, (AvatarDisplay.mcChar.getChildIndex(deattachedOff) + 1));
                    return;
            };
        }

        public function onBtnDelLayer(_arg_1:MouseEvent):void
        {
            switch (weaponFocus)
            {
                case 0:
                    if (AvatarDisplay.mcChar.getChildIndex(deattachedMain) <= 0)
                    {
                        return;
                    };
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, (AvatarDisplay.mcChar.getChildIndex(deattachedMain) - 1));
                    return;
                case 1:
                    if (AvatarDisplay.mcChar.getChildIndex(deattachedOff) <= 0)
                    {
                        return;
                    };
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, (AvatarDisplay.mcChar.getChildIndex(deattachedOff) - 1));
                    return;
                case 2:
                    if (((AvatarDisplay.mcChar.getChildIndex(deattachedMain) <= 0) || (AvatarDisplay.mcChar.getChildIndex(deattachedOff) <= 0)))
                    {
                        return;
                    };
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, (AvatarDisplay.mcChar.getChildIndex(deattachedMain) - 1));
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, (AvatarDisplay.mcChar.getChildIndex(deattachedOff) - 1));
                    return;
            };
        }

        public function onNumWepScale(_arg_1:Event):void
        {
            switch (weaponFocus)
            {
                case 0:
                    deattachedMain.scaleX = (deattachedMain.scaleY = (this.weaponUI.numWepScale.textField.text * ((isMirrored) ? -1 : 1)));
                    return;
                case 1:
                    deattachedOff.scaleX = (deattachedOff.scaleY = (this.weaponUI.numWepScale.textField.text * ((isMirroredOff) ? -1 : 1)));
                    return;
                case 2:
                    deattachedMain.scaleX = (deattachedMain.scaleY = (this.weaponUI.numWepScale.textField.text * ((isMirrored) ? -1 : 1)));
                    deattachedOff.scaleX = (deattachedOff.scaleY = (this.weaponUI.numWepScale.textField.text * ((isMirroredOff) ? -1 : 1)));
                    return;
            };
        }

        public function onBtnMirror(_arg_1:MouseEvent):void
        {
            switch (weaponFocus)
            {
                case 0:
                    isMirrored = (!(isMirrored));
                    deattachedMain.scaleX = (deattachedMain.scaleX * -1);
                    return;
                case 1:
                    isMirroredOff = (!(isMirroredOff));
                    deattachedOff.scaleX = (deattachedOff.scaleX * -1);
                    return;
                case 2:
                    isMirrored = (!(isMirrored));
                    isMirroredOff = (!(isMirroredOff));
                    deattachedMain.scaleX = (deattachedMain.scaleX * -1);
                    deattachedOff.scaleX = (deattachedOff.scaleX * -1);
                    return;
            };
        }

        public function onBtnInCombat(_arg_1:MouseEvent):void
        {
            switch (weaponFocus)
            {
                case 0:
                    if (((deattachedMain.bAttack == true) && (!(deattachedMain.currentLabel == "Attack"))))
                    {
                        deattachedMain.gotoAndPlay("Attack");
                    }
                    else
                    {
                        deattachedMain.gotoAndPlay("Idle");
                    };
                    return;
                case 1:
                    if (((deattachedOff.bAttack == true) && (!(deattachedOff.currentLabel == "Attack"))))
                    {
                        deattachedOff.gotoAndPlay("Attack");
                    }
                    else
                    {
                        deattachedOff.gotoAndPlay("Idle");
                    };
                    return;
                case 2:
                    if (((deattachedMain.bAttack == true) && (!(deattachedMain.currentLabel == "Attack"))))
                    {
                        deattachedMain.gotoAndPlay("Attack");
                    }
                    else
                    {
                        deattachedMain.gotoAndPlay("Idle");
                    };
                    if (((deattachedOff.bAttack == true) && (!(deattachedOff.currentLabel == "Attack"))))
                    {
                        deattachedOff.gotoAndPlay("Attack");
                    }
                    else
                    {
                        deattachedOff.gotoAndPlay("Idle");
                    };
                    return;
            };
        }

        public function onWeaponUIDown(_arg_1:MouseEvent):void
        {
            this.weaponUI.startDrag();
        }

        public function onWeaponUIUp(_arg_1:MouseEvent):void
        {
            this.weaponUI.stopDrag();
        }

        public function onAvatarDown(_arg_1:MouseEvent):void
        {
            AvatarDisplay.startDrag();
        }

        public function onAvatarUp(_arg_1:MouseEvent):void
        {
            AvatarDisplay.stopDrag();
        }

        public function onBtnFreezePlayer(_arg_1:MouseEvent):void
        {
            if (!isFrozen)
            {
                isFrozen = true;
                AvatarDisplay.mcChar.stop();
                AvatarDisplay.mcChar.addEventListener(MouseEvent.MOUSE_DOWN, onAvatarDown, false, 0, true);
                AvatarDisplay.mcChar.addEventListener(MouseEvent.MOUSE_UP, onAvatarUp, false, 0, true);
            }
            else
            {
                isFrozen = false;
                AvatarDisplay.mcChar.play();
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN, onAvatarDown);
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP, onAvatarUp);
            };
        }

        public function onBtnStonePlayer(_arg_1:MouseEvent):void
        {
            if (!isStoned)
            {
                isStoned = true;
                AvatarDisplay.modulateColor(new ColorTransform(-1.3, -1.3, -1.3, 0, 100, 100, 100, 0), "+");
            }
            else
            {
                isStoned = false;
                AvatarDisplay.modulateColor(new ColorTransform(-1.3, -1.3, -1.3, 0, 100, 100, 100, 0), "-");
            };
        }

        public function onBtnHitPlayer(_arg_1:MouseEvent):void
        {
            if (!isHit)
            {
                isHit = true;
                AvatarDisplay.modulateColor(new ColorTransform(0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0), "+");
            }
            else
            {
                isHit = false;
                AvatarDisplay.modulateColor(new ColorTransform(0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0), "-");
            };
        }

        public function onBtnResetPlayer(_arg_1:MouseEvent):void
        {
            var _local_2:Object;
            if (isFrozen)
            {
                isFrozen = false;
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN, onAvatarDown);
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP, onAvatarUp);
            };
            isStoned = false;
            isHit = false;
            glowPlayer = false;
            glowMain = false;
            glowOff = false;
            isMirrored = false;
            isMirroredOff = false;
            mcCharHidden = false;
            mcCharOptions = {
                "backhair":false,
                "robe":false,
                "backrobe":false
            };
            if (weaponDeattached)
            {
                weaponDeattached = false;
                this.cameratoolUI.primary.txtDeattached.text = "Weapon Deattachment: OFF";
                deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponDownDrag);
                deattachedMain.removeEventListener(MouseEvent.MOUSE_UP, onWeaponUpDrag);
                AvatarDisplay.mcChar.weapon.visible = true;
                _local_2 = AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
                if (((!(_local_2 == null)) && (!(_local_2.sType == null))))
                {
                    if (_local_2.sType == "Dagger")
                    {
                        AvatarDisplay.mcChar.weaponOff.visible = true;
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponOffDownDrag);
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_UP, onWeaponOffUpDrag);
                    };
                };
                AvatarDisplay.mcChar.removeChild(deattachedMain);
                AvatarDisplay.mcChar.removeChild(deattachedOff);
                deattachedMain = null;
                deattachedOff = null;
            };
            this.removeChild(AvatarDisplay);
            AvatarDisplay = new AvatarMC();
            AvatarDisplay.world = rootClass.world;
            this.copyTo(AvatarDisplay.mcChar);
            AvatarDisplay.x = 650;
            AvatarDisplay.y = 450;
            AvatarDisplay.hideHPBar();
            AvatarDisplay.gotoAndPlay("in2");
            AvatarDisplay.mcChar.gotoAndPlay("Idle");
            this.addChild(AvatarDisplay);
            AvatarDisplay.scale(scaleAvt);
        }

        public function onColGlow(_arg_1:*):void
        {
            if (!glowPlayer)
            {
                return;
            };
            var _local_2:* = new GlowFilter(_arg_1.currentTarget.selectedColor, 1, 8, 8, 2, 1, false, false);
            AvatarDisplay.mcChar.filters = [_local_2];
        }

        public function onColGlowMain(_arg_1:*):void
        {
            if (!glowMain)
            {
                return;
            };
            var _local_2:* = new GlowFilter(_arg_1.currentTarget.selectedColor, 1, 8, 8, 2, 1, false, false);
            if (weaponDeattached)
            {
                deattachedMain.filters = [_local_2];
            }
            else
            {
                AvatarDisplay.mcChar.weapon.filters = [_local_2];
            };
        }

        public function onColGlowOff(_arg_1:*):void
        {
            if (!glowOff)
            {
                return;
            };
            var _local_2:* = new GlowFilter(_arg_1.currentTarget.selectedColor, 1, 8, 8, 2, 1, false, false);
            if (((weaponDeattached) && (deattachedOff)))
            {
                deattachedOff.filters = [_local_2];
            }
            else
            {
                AvatarDisplay.mcChar.weaponOff.filters = [_local_2];
            };
        }

        public function onBtnGlowMain(_arg_1:MouseEvent):void
        {
            var _local_2:* = new GlowFilter(this.cameratoolUI.primary.colGlowMain.selectedColor, 1, 8, 8, 2, 1, false, false);
            if (!glowMain)
            {
                glowMain = true;
                AvatarDisplay.mcChar.weapon.filters = [_local_2];
            }
            else
            {
                glowMain = false;
                AvatarDisplay.mcChar.weapon.filters = [];
            };
        }

        public function onBtnGlowOff(_arg_1:MouseEvent):void
        {
            var _local_2:* = new GlowFilter(this.cameratoolUI.primary.colGlowOff.selectedColor, 1, 8, 8, 2, 1, false, false);
            if (!glowOff)
            {
                glowOff = true;
                AvatarDisplay.mcChar.weaponOff.filters = [_local_2];
            }
            else
            {
                glowOff = false;
                AvatarDisplay.mcChar.weaponOff.filters = [];
            };
        }

        public function onBtnGlowPlayer(_arg_1:MouseEvent):void
        {
            var _local_2:* = new GlowFilter(this.cameratoolUI.primary.colGlow.selectedColor, 1, 8, 8, 2, 1, false, false);
            if (!glowPlayer)
            {
                glowPlayer = true;
                AvatarDisplay.mcChar.filters = [_local_2];
            }
            else
            {
                glowPlayer = false;
                AvatarDisplay.mcChar.filters = [];
            };
        }

        public function onBtnGender(_arg_1:MouseEvent):void
        {
            var _local_4:*;
            var _local_2:* = undefined;
            AvatarDisplay.pAV = rootClass.world.myAvatar;
            AvatarDisplay.strGender = ((AvatarDisplay.strGender == "M") ? "F" : "M");
            var _local_3:* = ["cape", "backhair", "robe", "backrobe"];
            for (_local_2 in _local_3)
            {
                if (typeof(AvatarDisplay.mcChar[_local_3[_local_2]]) != undefined)
                {
                    AvatarDisplay.mcChar[_local_3[_local_2]].visible = false;
                };
            };
            if (((!(AvatarDisplay.pAV.dataLeaf.showHelm)) || ((!("he" in AvatarDisplay.pAV.objData.eqp)) && (AvatarDisplay.pAV.objData.eqp.he == null))))
            {
                AvatarDisplay.loadHair();
            };
            for (_local_4 in rootClass.world.myAvatar.objData.eqp)
            {
                switch (_local_4)
                {
                    case "Weapon":
                        AvatarDisplay.loadWeapon(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        break;
                    case "he":
                        if (AvatarDisplay.pAV.dataLeaf.showHelm)
                        {
                            AvatarDisplay.loadHelm(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        };
                        break;
                    case "ba":
                        if (AvatarDisplay.pAV.dataLeaf.showCloak)
                        {
                            AvatarDisplay.loadCape(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        };
                        break;
                    case "ar":
                        if (rootClass.world.myAvatar.objData.eqp.co == null)
                        {
                            AvatarDisplay.loadClass(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, null);
                        };
                        break;
                    case "co":
                        AvatarDisplay.loadArmor(AvatarDisplay.pAV.objData.eqp[_local_4].sFile, AvatarDisplay.pAV.objData.eqp[_local_4].sLink);
                        break;
                };
            };
        }

        public function onBtnTurnHead(_arg_1:MouseEvent):void
        {
            if (!oldX)
            {
                oldX = AvatarDisplay.mcChar.head.x;
                oldY = AvatarDisplay.mcChar.head.y;
            };
            AvatarDisplay.mcChar.head.scaleX = (AvatarDisplay.mcChar.head.scaleX * -1);
            if (AvatarDisplay.mcChar.head.scaleX < 0)
            {
                AvatarDisplay.mcChar.head.x = (AvatarDisplay.mcChar.head.x - 7);
            }
            else
            {
                AvatarDisplay.mcChar.head.x = oldX;
                AvatarDisplay.mcChar.head.y = oldY;
            };
        }


    }
}//package liteAssets.draw

