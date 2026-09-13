// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.targetAuras

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.geom.ColorTransform;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.ui.*;

    public class targetAuras extends MovieClip 
    {

        internal var rootClass:MovieClip;
        internal var auraContainer:MovieClip;
        public var icons:Object;
        public var scalar:Number = 0.6;
        internal var iconPriority:Array;
        public var auras:Object;

        public function targetAuras(_arg_1:MovieClip)
        {
            this.name = "targetAuras";
            this.x = 85;
            this.y = 93;
            this.visible = true;
            rootClass = _arg_1;
            auras = new Object();
            auraContainer = new MovieClip();
            auraContainer.mouseEnabled = (auraContainer.mouseChildren = false);
            _arg_1.ui.addChild(auraContainer);
            _arg_1.ui.setChildIndex(auraContainer, 0);
            auraContainer.name = "tAuraContainer";
            auraContainer.x = 320;
            auraContainer.y = 95;
        }

        public function createIconMC(_arg_1:String, _arg_2:Number, _arg_3:String=null):void
        {
            var _local_4:Class;
            var _local_5:MovieClip;
            var _local_6:Class;
            var _local_7:MovieClip;
            var _local_8:MovieClip;
            var _local_9:*;
            var _local_10:MovieClip;
            if (((!(rootClass.world.myAvatar.target)) || (rootClass.litePreference.data.bHideUI)))
            {
                return;
            };
            if (icons == null)
            {
                icons = new Object();
                iconPriority = new Array();
            };
            if (!icons.hasOwnProperty(_arg_1))
            {
                if (((_arg_3) && (!(_arg_3 == "undefined"))))
                {
                    if (_arg_3.indexOf(",") > -1)
                    {
                        _local_4 = (rootClass.world.getClass(_arg_3.split(",")[(_arg_3.split(",").length - 1)]) as Class);
                    }
                    else
                    {
                        _local_4 = (rootClass.world.getClass(_arg_3) as Class);
                    };
                }
                else
                {
                    _local_4 = (rootClass.world.getClass("isp2") as Class);
                };
                _local_5 = new (_local_4)();
                _local_6 = (getDefinitionByName("ib3") as Class);
                _local_7 = new (_local_6)();
                icons[_arg_1] = auraContainer.addChild(_local_7);
                icons[_arg_1].name = ("aura@" + _arg_1);
                icons[_arg_1].auraName = _arg_1;
                _local_8 = new MovieClip();
                _local_9 = new Shape();
                _local_9.graphics.beginFill(0xFFFFFF);
                _local_9.graphics.drawRect(0, 0, 23, 21);
                _local_9.graphics.endFill();
                _local_8.addChild(_local_9);
                _local_8.alpha = 0;
                addChild(_local_8);
                icons[_arg_1].hitbox = _local_8;
                icons[_arg_1].hitbox.auraName = _arg_1;
                icons[_arg_1].width = 42;
                icons[_arg_1].height = 39;
                icons[_arg_1].cnt.removeChildAt(0);
                icons[_arg_1].scaleX = scalar;
                icons[_arg_1].scaleY = scalar;
                icons[_arg_1].tQty.visible = false;
                _local_10 = icons[_arg_1].cnt.addChild(_local_5);
                if (_local_10.width > _local_10.height)
                {
                    _local_10.scaleX = (_local_10.scaleY = (34 / _local_10.width));
                }
                else
                {
                    _local_10.scaleX = (_local_10.scaleY = (31 / _local_10.height));
                };
                _local_10.x = ((icons[_arg_1].bg.width / 2) - (_local_10.width / 2));
                _local_10.y = ((icons[_arg_1].bg.height / 2) - (_local_10.height / 2));
                iconPriority.push(_arg_1);
                if (!rootClass.litePreference.data.dOptions["disAuraTips"])
                {
                    icons[_arg_1].hitbox.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                    icons[_arg_1].hitbox.addEventListener(MouseEvent.MOUSE_OUT, onExit, false, 0, true);
                }
                else
                {
                    this.mouseChildren = (this.mouseEnabled = false);
                };
            };
            icons[_arg_1].auraStacks = _arg_2;
            icons[_arg_1].hitbox.auraStacks = _arg_2;
        }

        public function onOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":(((_arg_1.currentTarget.auraName + " (") + _arg_1.currentTarget.auraStacks) + ")")});
        }

        public function onExit(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        public function rearrangeIconMC():void
        {
            var _local_1:Number = 0;
            var _local_2:Number = 0;
            var _local_3:int;
            while (_local_3 < iconPriority.length)
            {
                if (((!(_local_3 == 0)) && ((_local_3 % 4) == 0)))
                {
                    _local_1 = (_local_1 + 28);
                    _local_2++;
                };
                icons[iconPriority[_local_3]].x = ((32 * (_local_3 - (4 * _local_2))) + 3);
                icons[iconPriority[_local_3]].y = _local_1;
                icons[iconPriority[_local_3]].hitbox.x = (icons[iconPriority[_local_3]].x + 2);
                icons[iconPriority[_local_3]].hitbox.y = (icons[iconPriority[_local_3]].y + 1);
                _local_3++;
            };
        }

        public function cleanup():void
        {
            while (numChildren > 0)
            {
                removeChildAt(0);
            };
            rootClass.ui.removeChild(rootClass.ui.getChildByName("tAuraContainer"));
            parent.removeChild(this);
        }

        public function clearMCs():void
        {
            if (!rootClass.ui)
            {
                return;
            };
            while (numChildren > 0)
            {
                removeChildAt(0);
            };
            while (auraContainer.numChildren > 0)
            {
                auraContainer.removeChildAt(0);
            };
            icons = new Object();
            iconPriority = new Array();
        }

        public function handleAura(_arg_1:Object):*
        {
            var _local_2:Date;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            if (!rootClass.world.myAvatar.target)
            {
                return;
            };
            if (_arg_1.a == null)
            {
                return;
            };
            for each (_local_4 in _arg_1.a)
            {
                if (rootClass.world.myAvatar.target)
                {
                    if (rootClass.world.myAvatar.target.dataLeaf.MonID)
                    {
                        if (_local_4.tInf != ("m:" + rootClass.world.myAvatar.target.dataLeaf.MonMapID.toString())) continue;
                    }
                    else
                    {
                        if (_local_4.tInf != ("p:" + rootClass.world.myAvatar.target.dataLeaf.entID.toString())) continue;
                    };
                };
                if (_local_4.auras)
                {
                    for each (_local_5 in _local_4.auras)
                    {
                        if (_local_4.cmd.indexOf("+") > -1)
                        {
                            if (!auras.hasOwnProperty(_local_5.nam))
                            {
                                auras[_local_5.nam] = 1;
                                createIconMC(_local_5.nam, 1, _local_5.icon);
                                coolDownAct(icons[_local_5.nam], (_local_5.dur * 1000), new Date().getTime());
                            }
                            else
                            {
                                auras[_local_5.nam] = (auras[_local_5.nam] + 1);
                                if (!rootClass.world.myAvatar.target)
                                {
                                    auras = new Object();
                                    clearMCs();
                                };
                                for each (_local_6 in rootClass.world.myAvatar.target.dataLeaf.auras)
                                {
                                    if (_local_6.nam == _local_5.nam)
                                    {
                                        _local_6.ts = _local_5.ts;
                                        createIconMC(_local_5.nam, auras[_local_5.nam]);
                                        coolDownAct(icons[_local_5.nam], (_local_5.dur * 1000), _local_6.ts);
                                        break;
                                    };
                                };
                            };
                        }
                        else
                        {
                            if (_local_4.cmd.indexOf("-") > -1)
                            {
                                delete auras[_local_5.nam];
                            };
                        };
                    };
                }
                else
                {
                    if (_local_4.cmd.indexOf("+") > -1)
                    {
                        if (!auras.hasOwnProperty(_local_4.aura.nam))
                        {
                            auras[_local_4.aura.nam] = 1;
                            createIconMC(_local_4.aura.nam, 1, _local_4.aura.icon);
                            coolDownAct(icons[_local_4.aura.nam], (_local_4.aura.dur * 1000), new Date().getTime());
                        }
                        else
                        {
                            auras[_local_4.aura.nam] = (auras[_local_4.aura.nam] + 1);
                            if (!rootClass.world.myAvatar.target)
                            {
                                auras = new Object();
                                clearMCs();
                            };
                            for each (_local_7 in rootClass.world.myAvatar.target.dataLeaf.auras)
                            {
                                if (_local_7.nam == _local_4.aura.nam)
                                {
                                    _local_7.ts = _local_4.aura.ts;
                                    auras[_local_4.aura.nam] = 1;
                                    createIconMC(_local_4.aura.nam, auras[_local_4.aura.nam]);
                                    coolDownAct(icons[_local_4.aura.nam], (_local_4.aura.dur * 1000), _local_7.ts);
                                    break;
                                };
                            };
                        };
                    }
                    else
                    {
                        if (_local_4.cmd.indexOf("-") > -1)
                        {
                            delete auras[_local_4.aura.nam];
                        };
                    };
                };
            };
        }

        public function classChanged():void
        {
            clearMCs();
        }

        public function coolDownAct(_arg_1:*, _arg_2:int=-1, _arg_3:Number=127):*
        {
            var _local_5:MovieClip;
            var _local_6:int;
            var _local_7:*;
            var _local_8:MovieClip;
            var _local_9:*;
            var _local_10:*;
            var _local_11:int;
            var _local_12:DisplayObject;
            var _local_13:TextField;
            var _local_14:TextFormat;
            if (((!(rootClass.world.myAvatar.target)) || (rootClass.litePreference.data.bHideUI)))
            {
                auras = new Object();
                clearMCs();
                return;
            };
            var _local_4:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, -50, -50, -50, 0);
            _local_5 = _arg_1;
            _local_7 = null;
            _local_8 = null;
            if (_local_5.icon2 == null)
            {
                _local_9 = new BitmapData(50, 50, true, 0);
                _local_9.draw(_local_5, null, _local_4);
                _local_10 = new Bitmap(_local_9);
                _local_7 = _local_5.addChild(_local_10);
                _local_5.icon2 = _local_7;
                _local_7.transform = _local_5.transform;
                _local_7.scaleX = 1;
                _local_7.scaleY = 1;
                _local_5.ts = _arg_3;
                _local_5.cd = _arg_2;
                _local_5.auraName = _local_5.auraName;
                _local_8 = (_local_5.addChild(new ActMaskReverse()) as MovieClip);
                _local_8.scaleX = 1;
                _local_8.scaleY = 1;
                _local_8.x = int(((_local_7.x + (_local_7.width / 2)) - (244 / 2)));
                _local_8.y = int(((_local_7.y + (_local_7.height / 2)) - (244 / 2)));
                _local_11 = 0;
                while (_local_11 < 4)
                {
                    _local_8[(("e" + _local_11) + "oy")] = _local_8[("e" + _local_11)].y;
                    _local_11++;
                };
                _local_7.mask = _local_8;
                _local_13 = new TextField();
                _local_14 = new TextFormat();
                _local_14.size = 12;
                _local_14.bold = true;
                _local_14.font = "Arial";
                _local_14.color = 0xFFFFFF;
                _local_14.align = "right";
                _local_13.defaultTextFormat = _local_14;
                _local_5.stacks = _local_5.addChild(_local_13);
                _local_5.stacks.x = 3.25;
                _local_5.stacks.y = 28.1;
                _local_5.stacks.width = 42.7;
                _local_5.stacks.height = 16.25;
                _local_5.stacks.mouseEnabled = false;
                _local_5.stacks.filters = [new GlowFilter(0, 5, 0, 0, 5, 5)];
            }
            else
            {
                _local_7 = _local_5.icon2;
                _local_8 = _local_7.mask;
                _local_5.ts = _arg_3;
                _local_5.cd = _arg_2;
                _local_5.auraName = _local_5.auraName;
            };
            _local_5.stacks.text = _local_5.auraStacks;
            _local_8.e0.stop();
            _local_8.e1.stop();
            _local_8.e2.stop();
            _local_8.e3.stop();
            _local_5.removeEventListener(Event.ENTER_FRAME, countDownAct);
            _local_5.addEventListener(Event.ENTER_FRAME, countDownAct, false, 0, true);
            rearrangeIconMC();
        }

        public function countDownAct(e:Event):void
        {
            var dat:* = undefined;
            var ti:* = undefined;
            var ct1:* = undefined;
            var ct2:* = undefined;
            var cd:* = undefined;
            var tp:* = undefined;
            var mc:* = undefined;
            var fr:* = undefined;
            var i:* = undefined;
            var iMask:* = undefined;
            if (((!(rootClass.world.myAvatar.target)) || (rootClass.litePreference.data.bHideUI)))
            {
                auras = new Object();
                clearMCs();
                return;
            };
            dat = new Date();
            ti = dat.getTime();
            ct1 = MovieClip(e.target);
            ct2 = ct1.icon2;
            cd = (ct1.cd + 350);
            tp = ((ti - ct1.ts) / cd);
            mc = Math.floor((tp * 4));
            fr = (int(((tp * 360) % 90)) + 1);
            if (auras[ct1.auraName] == null)
            {
                tp = 1;
            };
            if (((tp < 0.99) && (rootClass.world.myAvatar.target)))
            {
                i = 0;
                while (i < 4)
                {
                    if (i >= mc)
                    {
                        ct2.mask[("e" + i)].y = ct2.mask[(("e" + i) + "oy")];
                        if (i > mc)
                        {
                            ct2.mask[("e" + i)].gotoAndStop(0);
                        };
                    };
                    i++;
                };
                MovieClip(ct2.mask[("e" + mc)]).gotoAndStop(fr);
            }
            else
            {
                try
                {
                    if (!rootClass.world.myAvatar.target)
                    {
                        auras = new Object();
                        clearMCs();
                        return;
                    };
                    iMask = ct2.mask;
                    ct2.mask = null;
                    ct2.parent.removeChild(iMask);
                    ct1.removeEventListener(Event.ENTER_FRAME, countDownAct);
                    stopDrag();
                    ct2.parent.removeChild(ct2);
                    ct2.bitmapData.dispose();
                    ct1.icon2 = null;
                    removeChild(icons[ct1.auraName].hitbox);
                    auraContainer.removeChild(icons[ct1.auraName]);
                    iconPriority.splice(iconPriority.indexOf(ct1.auraName), 1);
                    delete icons[ct1.auraName];
                    rearrangeIconMC();
                }
                catch(exception)
                {
                };
            };
        }


    }
}//package liteAssets.draw

