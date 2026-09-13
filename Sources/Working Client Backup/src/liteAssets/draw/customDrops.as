// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.customDrops

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.filters.ColorMatrixFilter;
    import fl.motion.AdjustColor;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.ui.*;

    public class customDrops extends MovieClip 
    {

        public var inner_menu:MovieClip;
        internal var rootClass:MovieClip;
        public var mcDraggable:draggableDrops;
        private var inactive:ColorMatrixFilter;
        private var isOpen:Boolean = false;
        internal var itemCount:Object;
        internal var invTree:Array;

        public function customDrops(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            itemCount = {};
            invTree = new Array();
            var _local_2:AdjustColor = new AdjustColor();
            _local_2.saturation = -100;
            _local_2.brightness = -100;
            _local_2.contrast = 0;
            _local_2.hue = 0;
            inactive = new ColorMatrixFilter(_local_2.CalculateFinalFlatArray());
            this.name = "customDrops";
            rootClass.ui.mcPortrait.iconDrops.visible = true;
            this.visible = true;
            onChange(rootClass.litePreference.data.dOptions["dragMode"]);
        }

        public function onChange(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                if (this.numChildren > 1)
                {
                    while (this.numChildren > 1)
                    {
                        this.removeChildAt(1);
                    };
                };
                this.inner_menu.visible = false;
                if (inner_menu.hasEventListener(MouseEvent.CLICK))
                {
                    this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER, onRollOverAttached);
                    this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT, onRollOutAttached);
                    this.inner_menu.removeEventListener(MouseEvent.CLICK, onToggleAttached);
                };
                if (rootClass.ui.mcInterface.getChildByName("customDrops"))
                {
                    rootClass.ui.mcInterface.removeChild(this);
                };
                rootClass.ui.addChild(this);
                rootClass.ui.setChildIndex(rootClass.ui.getChildByName("customDrops"), (rootClass.ui.numChildren - 1));
                this.x = 0;
                this.y = 0;
                mcDraggable = new draggableDrops();
                this.addChild(mcDraggable);
                if (rootClass.litePreference.data.dmtPos)
                {
                    mcDraggable.x = rootClass.litePreference.data.dmtPos.x;
                    mcDraggable.y = rootClass.litePreference.data.dmtPos.y;
                };
                mcDraggable.visible = true;
                mcDraggable.txtQty.mouseEnabled = false;
                mcDraggable.menuBar.addEventListener(MouseEvent.CLICK, onToggleMenu, false, 0, true);
                mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false, 0, true);
                mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
                mcDraggable.menu.visible = rootClass.litePreference.data.dOptions["openMenu"];
                lockMode();
                reDraw();
            }
            else
            {
                if (mcDraggable)
                {
                    while (mcDraggable.menu.numChildren > 1)
                    {
                        mcDraggable.menu.removeChildAt(1);
                    };
                    mcDraggable.menuBar.removeEventListener(MouseEvent.CLICK, onToggleMenu);
                    mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN, onHold);
                    mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
                    this.removeChild(mcDraggable);
                    mcDraggable = null;
                    rootClass.ui.removeChild(this);
                };
                rootClass.ui.mcInterface.addChild(this);
                rootClass.ui.mcInterface.setChildIndex(rootClass.ui.mcInterface.getChildByName("customDrops"), 0);
                this.x = 352;
                this.y = ((rootClass.litePreference.data.dOptions["invertMenu"]) ? -530 : -19);
                this.inner_menu.visible = true;
                this.inner_menu.height = ((rootClass.litePreference.data.dOptions["invertMenu"]) ? 42.8 : 157.7);
                this.inner_menu.addEventListener(MouseEvent.ROLL_OVER, onRollOverAttached, false, 0, true);
                this.inner_menu.addEventListener(MouseEvent.ROLL_OUT, onRollOutAttached, false, 0, true);
                this.inner_menu.addEventListener(MouseEvent.CLICK, onToggleAttached, false, 0, true);
                if (rootClass.litePreference.data.dOptions["openMenu"])
                {
                    isOpen = true;
                    reDraw();
                }
                else
                {
                    this.inner_menu.filters = [inactive];
                };
            };
        }

        public function lockMode():void
        {
            if (!mcDraggable)
            {
                return;
            };
            if (!rootClass.litePreference.data.dOptions["lockMode"])
            {
                mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false, 0, true);
                mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
            }
            else
            {
                mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN, onHold);
                mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
            };
        }

        public function resetPos():void
        {
            if (mcDraggable)
            {
                mcDraggable.x = 0;
                mcDraggable.y = 0;
            };
            rootClass.litePreference.data.dmtPos.x = 0;
            rootClass.litePreference.data.dmtPos.y = 0;
        }

        public function onToggleMenu(_arg_1:MouseEvent):void
        {
            mcDraggable.menu.visible = (!(mcDraggable.menu.visible));
            if (mcDraggable.menu.visible)
            {
                reDraw();
            };
        }

        private function onHold(_arg_1:MouseEvent):void
        {
            mcDraggable.startDrag();
        }

        private function onMouseRelease(_arg_1:MouseEvent):void
        {
            mcDraggable.stopDrag();
            rootClass.litePreference.data.dmtPos = {
                "x":mcDraggable.x,
                "y":mcDraggable.y
            };
            rootClass.litePreference.flush();
        }

        public function cleanup():void
        {
            if (mcDraggable)
            {
                mcDraggable.menuBar.removeEventListener(MouseEvent.CLICK, onToggleMenu);
                mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN, onHold);
                mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
            }
            else
            {
                this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER, onRollOverAttached);
                this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT, onRollOutAttached);
                this.inner_menu.removeEventListener(MouseEvent.CLICK, onToggleAttached);
            };
            rootClass.cDropsUI = null;
            rootClass.ui.mcPortrait.iconDrops.visible = false;
            parent.removeChild(this);
        }

        public function isMenuOpen():Boolean
        {
            return ((mcDraggable) ? mcDraggable.visible : isOpen);
        }

        public function onRollOverAttached(_arg_1:MouseEvent):void
        {
            if (isOpen)
            {
                return;
            };
            this.y = ((rootClass.litePreference.data.dOptions["invertMenu"]) ? -521 : -28);
        }

        public function onRollOutAttached(_arg_1:MouseEvent):void
        {
            if (isOpen)
            {
                return;
            };
            this.y = ((rootClass.litePreference.data.dOptions["invertMenu"]) ? -530 : -19);
        }

        public function onToggleAttached(_arg_1:MouseEvent):void
        {
            isOpen = (!(isOpen));
            if (!isOpen)
            {
                this.inner_menu.filters = [inactive];
                while (this.numChildren > 1)
                {
                    this.removeChildAt(1);
                };
                this.inner_menu.height = ((rootClass.litePreference.data.dOptions["invertMenu"]) ? 42.8 : 157.7);
                this.inner_menu.y = 0;
                this.y = ((rootClass.litePreference.data.dOptions["invertMenu"]) ? -530 : -19);
            }
            else
            {
                this.inner_menu.filters = [];
                reDraw();
            };
        }

        public function onShow():void
        {
            if (mcDraggable)
            {
                mcDraggable.visible = (!(mcDraggable.visible));
            }
            else
            {
                this.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        public function onUpdate():*
        {
            itemCount = {};
            invTree.length = 0;
            if (((isOpen) || (mcDraggable)))
            {
                reDraw();
            };
        }

        public function onBtNo(_arg_1:*):void
        {
            var _local_2:*;
            for (_local_2 in invTree)
            {
                if (invTree[_local_2].ItemID == _arg_1.ItemID)
                {
                    itemCount[invTree[_local_2].dID] = null;
                    invTree.splice(_local_2, 1);
                };
            };
            if (((isOpen) || (mcDraggable)))
            {
                reDraw();
            };
        }

        public function isBlacklisted(_arg_1:String):Boolean
        {
            return (false);
        }

        public function cleanDSUI():void
        {
            var _local_2:MovieClip;
            var _local_3:MovieClip;
            var _local_1:* = rootClass.ui.getChildByName("dsUI").numChildren;
            _local_1 = (_local_1 - 2);
            while (_local_1 > -1)
            {
                _local_2 = (rootClass.ui.getChildByName("dsUI").getChildAt(_local_1) as MovieClip);
                _local_3 = (rootClass.ui.getChildByName("dsUI").getChildAt((_local_1 + 1)) as MovieClip);
                _local_2.fY = (_local_2.y = (_local_3.fY - (_local_3.fHeight + 8)));
                _local_1--;
            };
        }

        public function showItem(_arg_1:Object):void
        {
            if (isBlacklisted(_arg_1.sName.toUpperCase()))
            {
                return;
            };
            if (itemCount[_arg_1.dID] == null)
            {
                itemCount[_arg_1.dID] = int(_arg_1.dQty);
                invTree.push(_arg_1);
            }
            else
            {
                itemCount[_arg_1.dID] = (itemCount[_arg_1.dID] + int(_arg_1.dQty));
            };
            if (mcDraggable)
            {
                reDraw();
                if (!mcDraggable.visible)
                {
                    rootClass.ui.mcPortrait.iconDrops.onAlert();
                };
                return;
            };
            if (isOpen)
            {
                reDraw();
            }
            else
            {
                rootClass.ui.mcPortrait.iconDrops.onAlert();
            };
        }

        public function acceptDrop(_arg_1:Object):void
        {
            var _local_2:*;
            for (_local_2 in invTree)
            {
                if (invTree[_local_2].ItemID == _arg_1.ItemID)
                {
                    itemCount[invTree[_local_2].dID] = null;
                    invTree.splice(_local_2, 1);
                };
            };
            if (((isOpen) || (mcDraggable)))
            {
                reDraw();
            };
        }

        public function reDraw():void
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_1:int;
            while (((mcDraggable) ? mcDraggable.menu : this).numChildren > 1)
            {
                ((mcDraggable) ? mcDraggable.menu : this).removeChildAt(1);
            };
            var _local_2:Boolean;
            var _local_3:int;
            for each (_local_4 in invTree)
            {
                if ((itemCount[_local_4.dID] % 100) == 0)
                {
                    if (((_local_4.ItemID == 6521) && ((itemCount[_local_4.dID] % 1000) == 0)))
                    {
                        _local_2 = true;
                    }
                    else
                    {
                        if (_local_4.ItemID != 6521)
                        {
                            _local_2 = true;
                        };
                    };
                };
                _local_5 = new dEntry(rootClass, _local_4, itemCount[_local_4.dID]);
                if (rootClass.litePreference.data.dOptions["invertMenu"])
                {
                    _local_5.x = 1.5;
                    _local_5.y = ((mcDraggable) ? (161 + (21.5 * _local_3)) : ((24 + (21.5 * _local_3)) - 0.5));
                }
                else
                {
                    _local_5.x = 1.5;
                    _local_5.y = ((mcDraggable) ? (108 - (21.5 * _local_3)) : ((-16 - (21.5 * _local_3)) + 0.5));
                };
                _local_5.name = _local_4.sName;
                ((mcDraggable) ? mcDraggable.menu : this).addChild(_local_5);
                _local_1 = (_local_1 + itemCount[_local_4.dID]);
                _local_3++;
            };
            if (((_local_2) && (rootClass.litePreference.data.dOptions["termsAgree"])))
            {
                _local_6 = new ModalMC();
                _local_7 = {};
                _local_7.strBody = "You have an item that's over the 100x quantity threshold! Please pick up your drops before you bug out!";
                _local_7.callback = null;
                _local_7.btns = "mono";
                _local_7.glow = "red,medium";
                rootClass.ui.ModalStack.addChild(_local_6);
                _local_6.init(_local_7);
            };
            if (mcDraggable)
            {
                mcDraggable.txtQty.text = (" x " + _local_1);
                if (rootClass.litePreference.data.dOptions["invertMenu"])
                {
                    mcDraggable.menu.menuBG.y = 158;
                    mcDraggable.menu.menuBG.height = ((21.5 * _local_3) + 6);
                }
                else
                {
                    mcDraggable.menu.menuBG.y = ((108 - (21.5 * (_local_3 - 1))) - 3);
                    mcDraggable.menu.menuBG.height = ((21.5 * _local_3) + 6);
                };
            }
            else
            {
                if (rootClass.litePreference.data.dOptions["invertMenu"])
                {
                    this.inner_menu.y = 0;
                    this.inner_menu.height = ((_local_3 == 0) ? 47.5 : (47.5 + (21.5 * (_local_3 - 1))));
                    this.y = -521;
                }
                else
                {
                    this.inner_menu.y = (4 - (21.5 * _local_3));
                    this.inner_menu.height = ((_local_3 == 0) ? 157.7 : (157.7 + (21.5 * (_local_3 - 1))));
                    this.y = -28;
                };
            };
        }


    }
}//package liteAssets.draw

