// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//MonsterMC

package 
{
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.utils.Timer;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.display.Sprite;
    import flash.display.Graphics;

    public class MonsterMC extends MovieClip 
    {

        public var pname:MovieClip;
        public var shadow:MovieClip;
        public var fx:MovieClip;
        public var mc:MovieClip;
        public var bubble:MovieClip;
        internal var ldr:Loader = new Loader();
        internal var WORLD:MovieClip;
        internal var xDep:*;
        internal var yDep:*;
        internal var xTar:*;
        internal var yTar:Number;
        internal var op:Point;
        internal var tp:Point;
        internal var walkTS:Number;
        internal var walkD:Number;
        internal var ox:*;
        internal var oy:*;
        internal var px:*;
        internal var py:*;
        internal var tx:*;
        internal var ty:Number;
        internal var nDuration:*;
        internal var nXStep:*;
        internal var nYStep:Number;
        internal var cbx:*;
        internal var cby:Number;
        internal var defaultCT:ColorTransform;
        internal var iniTimer:Timer;
        public var hitbox:Rectangle;
        public var hitboxDO:DisplayObject;
        public var spFX:Object;
        public var pAV:Avatar;
        internal var mcChar:MovieClip;
        public var isMonster:Boolean = true;
        public var isStatic:Boolean = false;
        public var noMove:Boolean = false;
        private var despawnTimer:Timer;
        private var totalTransform:Object;
        private var clampedTransform:ColorTransform;
        private var animQueue:Array;
        private var attacks:Array;

        public function MonsterMC(_arg_1:String)
        {
            this.defaultCT = MovieClip(this).transform.colorTransform;
            this.spFX = {};
            this.despawnTimer = new Timer(5000, 1);
            this.totalTransform = {
                "alphaMultiplier":1,
                "alphaOffset":0,
                "redMultiplier":1,
                "redOffset":0,
                "greenMultiplier":1,
                "greenOffset":0,
                "blueMultiplier":1,
                "blueOffset":0
            };
            this.clampedTransform = new ColorTransform();
            this.animQueue = [];
            this.attacks = new Array("Attack1", "Attack2", "Buff", "Cast");
            super();
            this.bubble.visible = false;
            this.bubble.t = "";
            this.pname.ti.text = _arg_1;
        }

        public function init():*
        {
            this.WORLD = MovieClip(parent.parent);
            this.mcChar = MovieClip(this.getChildAt(1));
            this.mcChar.addEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.pname.addEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.despawnTimer.addEventListener(TimerEvent.TIMER, this.despawn);
            this.addEventListener(Event.ENTER_FRAME, this.checkQueue, false, 0, true);
            this.pname.mouseChildren = false;
            this.mcChar.buttonMode = true;
            this.pname.buttonMode = true;
            this.shadow.addEventListener(MouseEvent.CLICK, this.onClickHandler, false, 0, true);
            this.shadow.mouseEnabled = (this.shadow.mouseChildren = true);
            this.mcChar.cacheAsBitmap = true;
            this.setVisible();
            if (MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
            {
                MovieClip(stage.getChildAt(0)).movieClipStopAll(this.mcChar);
            };
            this.mcChar.visible = (!(MovieClip(stage.getChildAt(0)).litePreference.data.bHideMons));
            this.noMove = MovieClip(stage.getChildAt(0)).litePreference.data.bFreezeMons;
        }

        public function setVisible():*
        {
            this.visible = this.WORLD.showMonsters;
        }

        public function setData():*
        {
            this.pAV.objData.strMonName = this.pname.ti.text;
        }

        public function updateNamePlate():void
        {
            this.WORLD = MovieClip(parent.parent);
            if (((((this.WORLD.bPvP) && (!(this.pAV.dataLeaf == null))) && (!(this.pAV.dataLeaf.react == null))) && (this.pAV.dataLeaf.react[this.WORLD.myAvatar.dataLeaf.pvpTeam] == 1)))
            {
                this.pname.ti.textColor = 0xFFFFFF;
                this.pname.typ.textColor = 0xFFFFFF;
            };
        }

        public function fClose():*
        {
            var _local_1:* = MovieClip(stage.getChildAt(0)).world;
            var _local_2:* = _local_1.CHARS;
            this.mcChar.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.pname.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.shadow.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
            this.despawnTimer.removeEventListener(TimerEvent.TIMER, this.despawn);
            this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
            this.removeEventListener(Event.ENTER_FRAME, this.onDespawn);
            this.removeEventListener(Event.ENTER_FRAME, this.checkQueue);
            if (_local_1.CHARS.contains(this))
            {
                _local_1.CHARS.removeChild(this);
            };
            if (_local_1.TRASH.contains(this))
            {
                _local_1.TRASH.removeChild(this);
            };
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
                };
                _local_3++;
            };
            return (false);
        }

        public function onClickHandler(_arg_1:MouseEvent):*
        {
            if (_arg_1.shiftKey)
            {
                this.WORLD.onWalkClick();
            }
            else
            {
                if (_arg_1.ctrlKey)
                {
                    if (this.WORLD.myAvatar.objData.intAccessLevel >= 40)
                    {
                        if (this.pAV.npcType == "monster")
                        {
                            this.WORLD.rootClass.sfc.sendXtMessage("zm", "cmd", ["km", ("m:" + this.pAV.objData.MonMapID)], "str", 1);
                        };
                        if (this.pAV.npcType == "player")
                        {
                            this.WORLD.rootClass.sfc.sendXtMessage("zm", "cmd", ["km", ("p:" + this.pAV.objData.unm.toLowerCase())], "str", 1);
                        };
                    };
                }
                else
                {
                    if (_arg_1.currentTarget.parent == this)
                    {
                        if (this.WORLD.myAvatar.target != this.pAV)
                        {
                            this.WORLD.setTarget(this.pAV);
                        }
                        else
                        {
                            if (((!(this.WORLD.bPvP)) || ((this.pAV.dataLeaf.react == null) || (this.pAV.dataLeaf.react[this.WORLD.myAvatar.dataLeaf.pvpTeam] == 0))))
                            {
                                this.WORLD.approachTarget();
                            };
                        };
                    };
                };
            };
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
                };
            };
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

        public function queueAnim(_arg_1:String):void
        {
            if (((MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim) && (!(_arg_1.toLowerCase() == "idle"))))
            {
                return;
            };
            var _local_2:MovieClip = (MovieClip(stage.getChildAt(0)).world as MovieClip);
            var _local_3:String = this.mcChar.currentLabel;
            if ((((this.hasLabel(_arg_1)) && (this.pAV.dataLeaf.intState > 0)) && (_local_2.staticAnims.indexOf(_local_3) == -1)))
            {
                if (((_local_2.combatAnims.indexOf(_arg_1) > -1) && (_local_2.combatAnims.indexOf(_local_3) > -1)))
                {
                    this.animQueue.push(_arg_1);
                }
                else
                {
                    this.mcChar.gotoAndPlay(_arg_1);
                };
            };
        }

        private function checkQueue(_arg_1:Event):Boolean
        {
            var _local_2:MovieClip;
            var _local_3:String;
            var _local_4:int;
            if (this.animQueue.length > 0)
            {
                _local_2 = (MovieClip(stage.getChildAt(0)).world as MovieClip);
                _local_3 = this.mcChar.currentLabel;
                _local_4 = this.emoteLoopFrame();
                if (((_local_2.combatAnims.indexOf(_local_3) > -1) && (this.mcChar.currentFrame >= (_local_4 + 4))))
                {
                    this.mcChar.gotoAndPlay(this.animQueue[0]);
                    this.animQueue.shift();
                    return (true);
                };
            };
            return (false);
        }

        public function clearQueue():void
        {
            this.animQueue = [];
        }

        private function emoteLoopFrame():int
        {
            var _local_1:Array = this.mcChar.currentLabels;
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                if (_local_1[_local_2].name == currentLabel)
                {
                    return (_local_1[_local_2].frame);
                };
                _local_2++;
            };
            return (8);
        }

        private function linearTween(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Number
        {
            return (((_arg_3 * _arg_1) / _arg_4) + _arg_2);
        }

        public function walkTo(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:Number;
            var _local_5:Number;
            if (!this.noMove)
            {
                if (((!(this.pAV.petMC == null)) && (!(this.pAV.petMC.mcChar == null))))
                {
                    this.pAV.petMC.walkTo((_arg_1 - 20), (_arg_2 + 5), (_arg_3 - 3));
                };
                this.op = new Point(this.x, this.y);
                this.tp = new Point(_arg_1, _arg_2);
                _local_4 = Point.distance(this.op, this.tp);
                this.walkTS = new Date().getTime();
                this.walkD = Math.round((1000 * (_local_4 / (_arg_3 * 22))));
                if (this.walkD > 0)
                {
                    _local_5 = (this.op.x - this.tp.x);
                    if (_local_5 < 0)
                    {
                        this.turn("right");
                    }
                    else
                    {
                        this.turn("left");
                    };
                    if (!this.mcChar.onMove)
                    {
                        this.mcChar.onMove = true;
                        if (((!(this.mcChar.currentLabel == "Walk")) && (!(MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim))))
                        {
                            this.mcChar.gotoAndPlay("Walk");
                        };
                    };
                    this.addEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
                };
            };
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
            var _local_2:Number = new Date().getTime();
            var _local_3:Number = ((_local_2 - this.walkTS) / this.walkD);
            if (_local_3 > 1)
            {
                _local_3 = 1;
            };
            if (((Point.distance(this.op, this.tp) > 0.5) && (this.mcChar.onMove)))
            {
                _local_4 = this.x;
                _local_5 = this.y;
                this.x = Point.interpolate(this.tp, this.op, _local_3).x;
                this.y = Point.interpolate(this.tp, this.op, _local_3).y;
                _local_6 = false;
                _local_7 = 0;
                while (_local_7 < this.WORLD.arrSolid.length)
                {
                    if (this.shadow.hitTestObject(this.WORLD.arrSolid[_local_7].shadow))
                    {
                        _local_6 = true;
                        _local_7 = this.WORLD.arrSolid.length;
                    };
                    _local_7++;
                };
                if (_local_6)
                {
                    _local_8 = this.y;
                    this.y = _local_5;
                    _local_6 = false;
                    _local_9 = 0;
                    while (_local_9 < this.WORLD.arrSolid.length)
                    {
                        if (this.shadow.hitTestObject(this.WORLD.arrSolid[_local_9].shadow))
                        {
                            this.y = _local_8;
                            _local_6 = true;
                            break;
                        };
                        _local_9++;
                    };
                    if (_local_6)
                    {
                        this.x = _local_4;
                        _local_6 = false;
                        _local_10 = 0;
                        while (_local_10 < this.WORLD.arrSolid.length)
                        {
                            if (this.shadow.hitTestObject(this.WORLD.arrSolid[_local_10].shadow))
                            {
                                _local_6 = true;
                                break;
                            };
                            _local_10++;
                        };
                        if (_local_6)
                        {
                            this.x = _local_4;
                            this.y = _local_5;
                            this.stopWalking();
                        };
                    };
                };
                if ((((Math.round(_local_4) == Math.round(this.x)) && (Math.round(_local_5) == Math.round(this.y))) && (_local_2 > (this.walkTS + 50))))
                {
                    this.stopWalking();
                };
            }
            else
            {
                this.stopWalking();
            };
        }

        public function stopWalking():void
        {
            if (this.mcChar.onMove)
            {
                this.mcChar.onMove = false;
                if (this.pAV.dataLeaf.intState != 2)
                {
                    this.mcChar.gotoAndPlay("Idle");
                    if (!this.isStatic)
                    {
                        if (this.x < MovieClip(stage.getChildAt(0)).world.myAvatar.pMC.x)
                        {
                            this.turn("right");
                        }
                        else
                        {
                            this.turn("left");
                        };
                    };
                };
                this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameWalk);
            };
            if (MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
            {
                this.mcChar.gotoAndStop("Idle");
            };
        }

        public function turn(_arg_1:String):void
        {
            if (!this.isStatic)
            {
                if ((((_arg_1 == "right") && (this.mcChar.scaleX < 0)) || ((_arg_1 == "left") && (this.mcChar.scaleX > 0))))
                {
                    this.mcChar.scaleX = (this.mcChar.scaleX * -1);
                };
            };
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
            };
            this.mcChar.scaleY = _arg_1;
            this.shadow.scaleX = (this.shadow.scaleY = _arg_1);
            this.bubble.y = (-(this.mcChar.height) - 10);
            this.pname.y = (-(this.mcChar.height) - 10);
            var _local_2:Point = new Point(0, (-(this.mcChar.height) - 10));
            var _local_3:Point = this.localToGlobal(_local_2);
            if (_local_3.y < 50)
            {
                _local_3.y = 50;
            };
            _local_2 = this.globalToLocal(_local_3);
            this.pname.y = _local_2.y;
            this.drawHitBox();
        }

        public function die():void
        {
            this.animQueue = [];
            MovieClip(this.getChildAt(1)).gotoAndPlay("Die");
            this.mcChar.mouseEnabled = false;
            this.mcChar.mouseChildren = false;
            this.despawnTimer.reset();
            this.despawnTimer.start();
        }

        private function despawn(_arg_1:TimerEvent):void
        {
            var _local_2:* = MovieClip(stage.getChildAt(0)).world;
            if (_local_2.myAvatar.target == this.pAV)
            {
                _local_2.setTarget(null);
            };
            this.addEventListener(Event.ENTER_FRAME, this.onDespawn);
        }

        private function onDespawn(_arg_1:Event):void
        {
            this.alpha = (this.alpha - 0.05);
            if (this.alpha < 0)
            {
                this.visible = false;
                this.alpha = 1;
                this.removeEventListener(Event.ENTER_FRAME, this.onDespawn);
            };
        }

        public function respawn(_arg_1:String=""):void
        {
            this.despawnTimer.reset();
            this.removeEventListener(Event.ENTER_FRAME, this.onDespawn);
            if (this.hasLabel("Start"))
            {
                MovieClip(this.getChildAt(1)).gotoAndPlay("Start");
            }
            else
            {
                if (MovieClip(this.getChildAt(1)).currentLabel != "Walk")
                {
                    MovieClip(this.getChildAt(1)).gotoAndStop("Idle");
                };
            };
            if (_arg_1 != "")
            {
                this.pname.ti.text = _arg_1;
            };
            this.alpha = 1;
            this.visible = true;
            this.mcChar.mouseEnabled = true;
            this.mcChar.mouseChildren = true;
            var _local_2:* = MovieClip(stage.getChildAt(0)).world;
            if (MovieClip(stage.getChildAt(0)).litePreference.data.bDisMonAnim)
            {
                MovieClip(stage.getChildAt(0)).movieClipStopAll(this.mcChar);
            };
            this.setVisible();
        }

        private function drawHitBox():void
        {
            if (this.hitboxDO != null)
            {
                this.mcChar.removeChild(this.hitboxDO);
            };
            this.hitboxDO = null;
            var _local_1:Rectangle = this.mcChar.getBounds(stage);
            var _local_2:Point = _local_1.topLeft;
            var _local_3:Point = _local_1.bottomRight;
            _local_2 = this.mcChar.globalToLocal(_local_2);
            _local_3 = this.mcChar.globalToLocal(_local_3);
            _local_1 = new Rectangle(_local_2.x, _local_2.y, (_local_3.x - _local_2.x), (_local_3.y - _local_2.y));
            var _local_4:int = (_local_1.x + (_local_1.width * 0.2));
            if (_local_4 > (this.shadow.x - this.shadow.width))
            {
                _local_4 = (this.shadow.x - this.shadow.width);
            };
            var _local_5:int = (_local_1.width * 0.6);
            if (_local_5 < (2 * this.shadow.width))
            {
                _local_5 = (2 * this.shadow.width);
            };
            var _local_6:int = (_local_1.y + (_local_1.height * 0.2));
            var _local_7:int = (_local_1.height * 0.6);
            this.hitbox = new Rectangle(_local_4, _local_6, _local_5, _local_7);
            var _local_8:Sprite = new Sprite();
            var _local_9:Graphics = _local_8.graphics;
            _local_9.lineStyle(0, 0xFFFFFF, 0);
            _local_9.beginFill(0xAA00FF, 0);
            _local_9.moveTo(_local_4, _local_6);
            _local_9.lineTo((_local_4 + _local_5), _local_6);
            _local_9.lineTo((_local_4 + _local_5), (_local_6 + _local_7));
            _local_9.lineTo(_local_4, (_local_6 + _local_7));
            _local_9.lineTo(_local_4, _local_6);
            _local_9.endFill();
            this.hitboxDO = this.mcChar.addChild(_local_8);
        }

        public function get Animation():String
        {
            if (((this.WORLD.getAchievement("ia1", 21) == 1) || (this.WORLD.getAchievement("ia1", 22) == 1)))
            {
                return (this.attacks[Math.round((Math.random() * (this.attacks.length - 1)))]);
            };
            return (this.attacks[Math.round(Math.random())]);
        }


    }
}//package 

