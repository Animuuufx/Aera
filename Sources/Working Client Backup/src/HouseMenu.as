// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//HouseMenu

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.geom.Rectangle;
    import flash.filters.GlowFilter;
    import flash.text.*;

    public class HouseMenu extends MovieClip 
    {

        public var preview:MovieClip;
        public var fxmask:MovieClip;
        public var btnClose:SimpleButton;
        public var txtSearch:TextField;
        public var tTitle:MovieClip;
        public var bg:MovieClip;
        public var iListA:MovieClip;
        public var iListB:MovieClip;
        public var hit:MovieClip;
        public var world:MovieClip;
        public var rootClass:MovieClip;
        public var CHARS:MovieClip;
        public var fData:Object = null;
        internal var mDown:Boolean = false;
        internal var hRun:int = 0;
        internal var dRun:int = 0;
        internal var mbY:int = 0;
        internal var mhY:int = 0;
        internal var mbD:int = 0;
        internal var ox:int = 0;
        internal var oy:int = 0;
        internal var mox:int = 0;
        internal var moy:int = 0;
        internal var scrTgt:MovieClip;
        private var currentCategory:String = "";

        public function HouseMenu():void
        {
            var _local_1:MovieClip = (this as MovieClip);
            _local_1.tTitle.mouseEnabled = false;
            _local_1.preview.tPreview.mouseEnabled = false;
            _local_1.hit.alpha = 0;
            _local_1.hit.buttonMode = true;
        }

        public function fOpen(_arg_1:String):void
        {
            var _local_2:MovieClip;
            rootClass = (stage.getChildAt(0) as MovieClip);
            world = (rootClass.world as MovieClip);
            CHARS = (rootClass.world.CHARS as MovieClip);
            _local_2 = MovieClip(this.parent).mcHouseItemHandle;
            _local_2.visible = false;
            _local_2.x = 1000;
            _local_2.addEventListener(Event.ENTER_FRAME, onHandleEnterFrame, false, 0, true);
            _local_2.bCancel.addEventListener(MouseEvent.CLICK, onHandleCancelClick, false, 0, true);
            _local_2.bDelete.addEventListener(MouseEvent.CLICK, onHandleDeleteClick, false, 0, true);
            _local_2.bFlip.addEventListener(MouseEvent.CLICK, onHandleFlipClick, false, 0, true);
            _local_2.frame.addEventListener(MouseEvent.MOUSE_DOWN, onHandleMoveClick, false, 0, true);
            _local_2.bCancel.buttonMode = true;
            _local_2.bDelete.buttonMode = true;
            _local_2.bFlip.buttonMode = true;
            var _local_3:MovieClip = MovieClip(rootClass.ui.mcPopup);
            _local_3.mcHouseOptions.cnt.bDesign.addEventListener(MouseEvent.CLICK, world.onHouseOptionsDesignClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bSave.addEventListener(MouseEvent.CLICK, world.onHouseOptionsSaveClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bHide.addEventListener(MouseEvent.CLICK, world.onHouseOptionsHideClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bFloor.addEventListener(MouseEvent.CLICK, world.onHouseOptionsFloorClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bWall.addEventListener(MouseEvent.CLICK, world.onHouseOptionsWallClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bMisc.addEventListener(MouseEvent.CLICK, world.onHouseOptionsMiscClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bHouse.addEventListener(MouseEvent.CLICK, world.onHouseOptionsHouseClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bReset.addEventListener(MouseEvent.CLICK, world.onHouseOptionsHouseReset, false, 0, true);
            _local_3.mcHouseOptions.bExpand.addEventListener(MouseEvent.CLICK, world.onHouseOptionsExpandClick, false, 0, true);
            _local_3.mcHouseOptions.cnt.bDesign.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bSave.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bHide.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bFloor.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bWall.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bMisc.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bHouse.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bReset.buttonMode = true;
            _local_3.mcHouseOptions.bExpand.buttonMode = true;
            _local_3.mcHouseOptions.cnt.bDesign.ti.mouseEnabled = false;
            _local_3.mcHouseOptions.cnt.txtPlaced.text = (world.strFrame + " - ?/200 placed");
            var _local_4:MovieClip = (this as MovieClip);
            _local_4.preview.bAdd.buttonMode = true;
            _local_4.preview.t2.mouseEnabled = false;
            _local_4.preview.bAdd.addEventListener(MouseEvent.CLICK, onItemAddClick, false, 0, true);
            _local_4.btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0, true);
            _local_4.bg.addEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick, false, 0, true);
            _local_4.bg.addEventListener(Event.ENTER_FRAME, onHouseMenuBGEnterFrame, false, 0, true);
            _local_4.hit.addEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick, false, 0, true);
            _local_4.hit.addEventListener(Event.ENTER_FRAME, onHouseMenuBGEnterFrame, false, 0, true);
            _local_4.txtSearch.addEventListener(MouseEvent.CLICK, onClear, false, 0, true);
            _local_4.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onSearch, false, 0, true);
            _local_4.txtSearch.addEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick, false, 0, true);
            _local_4.iListB.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
            rootClass.world.showHouseOptions("default");
            if (_arg_1.toLowerCase() == "edit")
            {
                showEditMenu();
            }
        }

        public function onScroll(_arg_1:MouseEvent):void
        {
            var _local_2:* = (this as MovieClip).iListB.scr;
            _local_2.h.y = (_local_2.h.y + (_arg_1.delta * -3));
            if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
            {
                _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
            }
            if (_local_2.h.y < 0)
            {
                _local_2.h.y = 0;
            }
        }

        public function onFilter(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
        {
            return (_arg_1.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) > -1);
        }

        public function onSearch(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                buildItemList(fData[currentCategory].filter(onFilter), "B", this);
            }
        }

        public function onClear(_arg_1:MouseEvent):void
        {
            if (this.txtSearch.text.toLowerCase() == "search")
            {
                this.txtSearch.text = "";
            }
        }

        public function showEditMenu():void
        {
            var _local_1:MovieClip;
            _local_1 = MovieClip(this);
            buildHouseMenu();
            _local_1.visible = true;
            _local_1.y = 315;
            _local_1.x = int((480 - (_local_1.bg.width / 2)));
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseOptions.cnt;
            _local_2.bDesign.ti.text = "Done Editing";
            _local_2.bWall.txtWall.textColor = 0x333333;
            _local_2.bFloor.txtFloor.textColor = 0x333333;
            _local_2.bMisc.txtMisc.textColor = 0x333333;
            _local_2.bHouse.txtHouse.textColor = 0x333333;
            _local_2.bFloor.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsFloorClick);
            _local_2.bWall.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsWallClick);
            _local_2.bMisc.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsMiscClick);
            _local_2.bHouse.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsHouseClick);
        }

        public function hideEditMenu():void
        {
            var _local_1:MovieClip = MovieClip(this);
            _local_1.visible = false;
            _local_1.x = 1000;
            stage.focus = stage;
            rootClass.ui.mcPopup.mcHouseOptions.cnt.bDesign.ti.text = "Edit House";
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseOptions.cnt;
            _local_2.bWall.txtWall.textColor = 0xFFFFFF;
            _local_2.bFloor.txtFloor.textColor = 0xFFFFFF;
            _local_2.bMisc.txtMisc.textColor = 0xFFFFFF;
            _local_2.bHouse.txtHouse.textColor = 0xFFFFFF;
            _local_2.bFloor.addEventListener(MouseEvent.CLICK, world.onHouseOptionsFloorClick, false, 0, true);
            _local_2.bWall.addEventListener(MouseEvent.CLICK, world.onHouseOptionsWallClick, false, 0, true);
            _local_2.bMisc.addEventListener(MouseEvent.CLICK, world.onHouseOptionsMiscClick, false, 0, true);
            _local_2.bHouse.addEventListener(MouseEvent.CLICK, world.onHouseOptionsHouseClick, false, 0, true);
            onHandleCancelClick();
        }

        public function btnCloseClick(_arg_1:MouseEvent=null):void
        {
            rootClass.mixer.playSound("Click");
            rootClass.world.toggleHouseEdit();
        }

        public function fClose(_arg_1:MouseEvent=null):void
        {
            hideItemHandle();
            var _local_2:MovieClip = MovieClip(this);
            var _local_3:MovieClip = MovieClip(rootClass.ui.mcPopup);
            var _local_4:MovieClip = MovieClip(this.parent).mcHouseItemHandle;
            _local_4.removeEventListener(Event.ENTER_FRAME, onHandleEnterFrame);
            _local_4.bCancel.removeEventListener(MouseEvent.CLICK, onHandleCancelClick);
            _local_4.bDelete.removeEventListener(MouseEvent.CLICK, onHandleDeleteClick);
            _local_4.bFlip.removeEventListener(MouseEvent.CLICK, onHandleFlipClick);
            _local_4.frame.removeEventListener(MouseEvent.MOUSE_DOWN, onHandleMoveClick);
            _local_2.txtSearch.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick);
            _local_3.mcHouseOptions.cnt.bDesign.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsDesignClick);
            _local_3.mcHouseOptions.cnt.bSave.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsSaveClick);
            _local_3.mcHouseOptions.cnt.bHide.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsHideClick);
            _local_3.mcHouseOptions.cnt.bFloor.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsFloorClick);
            _local_3.mcHouseOptions.cnt.bWall.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsWallClick);
            _local_3.mcHouseOptions.cnt.bMisc.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsMiscClick);
            _local_3.mcHouseOptions.cnt.bHouse.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsHouseClick);
            _local_3.mcHouseOptions.cnt.bReset.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsHouseReset);
            _local_3.mcHouseOptions.bExpand.removeEventListener(MouseEvent.CLICK, world.onHouseOptionsExpandClick);
            _local_2.preview.bAdd.removeEventListener(MouseEvent.CLICK, onItemAddClick);
            _local_2.btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClick);
            _local_2.bg.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick);
            _local_2.bg.removeEventListener(Event.ENTER_FRAME, onHouseMenuBGEnterFrame);
            _local_2.hit.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick);
            _local_2.hit.removeEventListener(Event.ENTER_FRAME, onHouseMenuBGEnterFrame);
            _local_2.btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClick);
            _local_2.txtSearch.removeEventListener(MouseEvent.CLICK, onClear);
            _local_2.txtSearch.removeEventListener(KeyboardEvent.KEY_DOWN, onSearch);
            _local_2.iListB.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
            destroyIList(_local_2.iListA);
            destroyIList(_local_2.iListB);
            _local_2.visible = false;
            stage.focus = stage;
        }

        public function buildHouseMenu():void
        {
            var _local_9:Array;
            var _local_10:int;
            var _local_1:int;
            var _local_2:Object = {};
            var _local_3:MovieClip = (this as MovieClip);
            var _local_4:Object = {};
            var _local_5:* = "";
            var _local_6:Array = [];
            var _local_7:Boolean = true;
            var _local_8:* = world.myAvatar.houseitems.sortOn("sType");
            _local_1 = 0;
            while (_local_1 < world.myAvatar.houseitems.length)
            {
                _local_7 = true;
                _local_4 = _local_8[_local_1];
                _local_5 = _local_4.sType;
                if (!(_local_5 in _local_2))
                {
                    _local_2[_local_5] = [];
                }
                _local_6 = _local_2[_local_5];
                _local_10 = 0;
                while (_local_10 < _local_6.length)
                {
                    if (_local_6[_local_10].ItemID == _local_4.ItemID)
                    {
                        _local_7 = false;
                        break;
                    }
                    _local_10++;
                }
                if (_local_7)
                {
                    _local_6.push(_local_4);
                }
                _local_1++;
            }
            for (_local_5 in _local_2)
            {
                _local_2[_local_5].sortOn("sName");
            }
            fData = _local_2;
            _local_9 = [];
            for (_local_5 in _local_2)
            {
                _local_9.push(_local_5);
            }
            _local_9.sort(rootClass.arraySort);
            buildItemList(_local_9, "A", _local_3);
        }

        public function buildItemList(_arg_1:Array, _arg_2:String, _arg_3:MovieClip):void
        {
            var _local_6:MovieClip;
            var _local_7:MovieClip;
            var _local_8:Class;
            var _local_15:*;
            var _local_4:int;
            var _local_5:MovieClip = (this as MovieClip);
            var _local_9:* = "";
            var _local_10:Boolean = true;
            var _local_11:int = 90;
            _local_5.preview.cnt.visible = false;
            _local_5.preview.t2.visible = false;
            _local_5.preview.bAdd.visible = false;
            _local_5.preview.tPreview.visible = false;
            if (_arg_2 == "A")
            {
                _local_5.iListB.visible = false;
                _local_5.txtSearch.visible = false;
                _local_6 = _local_5.iListA;
                destroyIList(_local_6);
                _local_6.par = _arg_3;
                _local_4 = 0;
                while (_local_4 < _arg_1.length)
                {
                    _local_7 = _local_6.iList.addChild(new hProto());
                    _local_7.ti.autoSize = "left";
                    _local_7.ti.text = String(_arg_1[_local_4]);
                    if (_local_7.ti.textWidth > _local_11)
                    {
                        _local_11 = int(_local_7.ti.textWidth);
                    }
                    _local_7.hit.alpha = 0;
                    _local_7.typ = _arg_2;
                    _local_7.val = _arg_1[_local_4];
                    _local_7.iSel = false;
                    _local_7.addEventListener(MouseEvent.CLICK, onHouseMenuItemClick, false, 0, true);
                    _local_7.addEventListener(MouseEvent.MOUSE_OVER, onHouseMenuItemMouseOver, false, 0, true);
                    _local_7.y = (_local_6.iList.iproto.y + (_local_4 * 16));
                    _local_7.bg.visible = false;
                    _local_7.buttonMode = true;
                    _local_4++;
                }
                _local_6.iList.iproto.visible = false;
                _local_6.iList.y = ((_local_6.imask.height / 2) - (_local_6.iList.height / 2));
            }
            else
            {
                if (_arg_2 == "B")
                {
                    _local_5.iListB.visible = true;
                    _local_5.txtSearch.visible = true;
                    _local_6 = _local_5.iListB;
                    destroyIList(_local_6);
                    _local_6.par = _arg_3;
                    _local_4 = 0;
                    while (_local_4 < _arg_1.length)
                    {
                        _local_7 = _local_6.iList.addChild(new hProto());
                        _local_7.ti.autoSize = "left";
                        _local_15 = ((_arg_1[_local_4].bEquip) ? _arg_1[_local_4].bEquip : "0");
                        _local_7.ti.text = (String(_arg_1[_local_4].sName) + ((_arg_1[_local_4].iQty > 1) ? (((" - " + _local_15) + "/") + _arg_1[_local_4].iQty) : ""));
                        if (_local_7.ti.textWidth > _local_11)
                        {
                            _local_11 = int(_local_7.ti.textWidth);
                        }
                        _local_7.hit.alpha = 0;
                        _local_7.typ = _arg_2;
                        _local_7.val = _arg_1[_local_4];
                        _local_7.iSel = false;
                        _local_7.addEventListener(MouseEvent.CLICK, onHouseMenuItemClick, false, 0, true);
                        _local_7.addEventListener(MouseEvent.MOUSE_OVER, onHouseMenuItemMouseOver, false, 0, true);
                        _local_7.y = (_local_6.iList.iproto.y + (_local_4 * 16));
                        _local_7.bg.visible = _local_7.val.bEquip;
                        _local_7.buttonMode = true;
                        _local_4++;
                    }
                    _local_6.iList.iproto.visible = false;
                    _local_6.x = ((_local_6.par.x + _local_6.par.width) + 1);
                    _local_6.iList.y = ((_local_6.imask.height / 2) - (_local_6.iList.height / 2));
                }
            }
            _local_11 = (_local_11 + 7);
            _local_4 = 1;
            while (_local_4 < _local_6.iList.numChildren)
            {
                _local_7 = (_local_6.iList.getChildAt(_local_4) as MovieClip);
                _local_7.bg.width = _local_11;
                _local_7.hit.width = _local_11;
                _local_4++;
            }
            var _local_12:MovieClip = _local_6.scr;
            var _local_13:MovieClip = _local_6.imask;
            var _local_14:MovieClip = _local_6.iList;
            _local_12.h.y = 0;
            _local_12.visible = false;
            _local_12.hit.alpha = 0;
            _local_12.mDown = false;
            if (_local_14.height > _local_12.b.height)
            {
                _local_12.h.height = int(((_local_12.b.height / _local_14.height) * _local_12.b.height));
                hRun = (_local_12.b.height - _local_12.h.height);
                dRun = ((_local_14.height - _local_12.b.height) + 10);
                _local_14.oy = (_local_14.y = _local_13.y);
                _local_12.visible = true;
                _local_12.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                _local_12.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                _local_14.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            }
            else
            {
                _local_12.hit.removeEventListener(MouseEvent.MOUSE_DOWN, scrDown);
                _local_12.h.removeEventListener(Event.ENTER_FRAME, hEF);
                _local_14.removeEventListener(Event.ENTER_FRAME, dEF);
            }
            _local_6.imask.width = (_local_11 - 1);
            _local_6.divider.x = _local_11;
            _local_6.scr.x = _local_11;
            if (_local_6.scr.visible)
            {
                _local_6.w = (_local_11 + _local_6.scr.width);
            }
            else
            {
                _local_6.w = (_local_11 + 1);
            }
            resizeMe();
        }

        private function destroyIList(_arg_1:MovieClip):void
        {
            var _local_2:MovieClip;
            while (_arg_1.iList.numChildren > 1)
            {
                _local_2 = _arg_1.iList.getChildAt(1);
                _local_2.removeEventListener(MouseEvent.CLICK, onHouseMenuItemClick);
                _local_2.removeEventListener(MouseEvent.MOUSE_OVER, onHouseMenuItemMouseOver);
                delete _local_2.val;
                _arg_1.iList.removeChildAt(1);
            }
            _arg_1.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN, scrDown);
            _arg_1.scr.h.removeEventListener(Event.ENTER_FRAME, hEF);
            _arg_1.iList.removeEventListener(Event.ENTER_FRAME, dEF);
        }

        public function onHouseMenuItemClick(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_6:Object;
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            var _local_4:MovieClip = (_local_2.parent as MovieClip);
            var _local_5:MovieClip = (this as MovieClip);
            var _local_7:int;
            var _local_8:* = "";
            if (_local_2.typ == "A")
            {
                _local_7 = 0;
                while (_local_7 < _local_4.numChildren)
                {
                    MovieClip(_local_4.getChildAt(_local_7)).bg.visible = false;
                    _local_7++;
                }
                _local_2.bg.visible = true;
                buildItemList(fData[_local_2.val], "B", MovieClip(_local_2.parent));
                currentCategory = _local_2.val;
            }
            if (_local_2.typ == "B")
            {
                _local_7 = 1;
                while (_local_7 < _local_4.numChildren)
                {
                    _local_3 = (_local_4.getChildAt(_local_7) as MovieClip);
                    _local_3.iSel = false;
                    _local_7++;
                }
                _local_2.iSel = true;
                refreshIListB();
                _local_6 = _local_2.val;
                world.loadHouseItemB(_local_6);
                resizeMe();
            }
        }

        public function onHouseMenuItemMouseOver(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_2:MovieClip = MovieClip(_arg_1.currentTarget);
            var _local_4:int = 1;
            while (_local_4 < _local_2.parent.numChildren)
            {
                _local_3 = MovieClip(_local_2.parent.getChildAt(_local_4));
                if (_local_3.bg.alpha < 0.4)
                {
                    _local_3.bg.visible = false;
                }
                _local_4++;
            }
            if (!_local_2.bg.visible)
            {
                _local_2.bg.visible = true;
                _local_2.bg.alpha = 0.33;
            }
        }

        private function refreshIListB():void
        {
            var _local_3:MovieClip;
            var _local_1:MovieClip = MovieClip(this).iListB.iList;
            var _local_2:int = 1;
            while (_local_2 < _local_1.numChildren)
            {
                _local_3 = (_local_1.getChildAt(_local_2) as MovieClip);
                if (_local_3.val != null)
                {
                    _local_3.bg.visible = false;
                    if (_local_3.iSel)
                    {
                        _local_3.bg.visible = true;
                        _local_3.bg.alpha = 0.5;
                    }
                    if (_local_3.val.iQty > 1)
                    {
                        _local_3.ti.text = (String(_local_3.val.sName) + ((_local_3.val.iQty > 1) ? (((" - " + _local_3.val.bEquip) + "/") + _local_3.val.iQty) : ""));
                    }
                    if (int(_local_3.val.bEquip))
                    {
                        _local_3.bg.visible = true;
                        _local_3.bg.alpha = 1;
                    }
                }
                _local_2++;
            }
        }

        public function onItemAddClick(_arg_1:MouseEvent):void
        {
            var _local_3:int;
            var _local_2:Object = MovieClip(_arg_1.currentTarget.parent).item;
            if (!_local_2.hasOwnProperty("bEquip"))
            {
                _local_2.bEquip = 0;
            }
            if (int(_local_2.bEquip) < _local_2.iQty)
            {
                if (((_local_2.iQty > 1) && (int(_local_2.bEquip) < _local_2.iQty)))
                {
                    _local_2.bEquip = (_local_2.bEquip + 1);
                    refreshIListB();
                    _local_3 = ((_local_2.sType.toLowerCase().indexOf("wall") > -1) ? 150 : 300);
                    world.loadHouseItem(_local_2, 480, _local_3);
                    rootClass.world.hasModified = true;
                }
                else
                {
                    if (((_local_2.bUpg == 1) && (!(rootClass.world.myAvatar.isUpgraded()))))
                    {
                        rootClass.showUpgradeWindow();
                    }
                    else
                    {
                        if (_local_2.sType == "House")
                        {
                            world.equipHouse(_local_2);
                        }
                        else
                        {
                            _local_2.bEquip = (_local_2.bEquip + 1);
                            refreshIListB();
                            _local_3 = ((_local_2.sType.toLowerCase().indexOf("wall") > -1) ? 150 : 300);
                            world.loadHouseItem(_local_2, 480, _local_3);
                            rootClass.world.hasModified = true;
                        }
                    }
                }
            }
        }

        public function previewHouseItem(_arg_1:Object):void
        {
            var _local_2:String;
            if (_arg_1.item.sType == "House")
            {
                _local_2 = (_arg_1.item.sFile.substr(0, -4).substr((_arg_1.item.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview");
            }
            else
            {
                _local_2 = _arg_1.item.sLink;
            }

            var _local_3:Class = (world.loaderD.getDefinition(_local_2) as Class);
            var _local_4:MovieClip = (MovieClip(this).preview.cnt as MovieClip);
            if (_local_4.numChildren > 0)
            {
                _local_4.removeChildAt(0);
            }
            var _local_5:MovieClip = (_local_4.addChild(new (_local_3)()) as MovieClip);
            var _local_6:* = (130 / _local_5.width);
            if (_local_5.height > _local_5.width)
            {
                _local_6 = (113 / _local_5.height);
            }
            _local_5.scaleX = _local_6;
            _local_5.scaleY = _local_6;
            _local_5.x = (130 / 2);
            _local_5.y = ((113 / 2) + (_local_5.height / 2));
            _local_5.ItemID = _arg_1.item.ItemID;
            MovieClip(this).preview.item = _arg_1.item;
            MovieClip(this).preview.bAdd.visible = true;
            MovieClip(this).preview.tPreview.visible = true;
            MovieClip(this).preview.t2.visible = false;
            MovieClip(this).preview.cnt.visible = true;
        }

        public function resizeMe():*
        {
            var _local_1:MovieClip = MovieClip(this);
            if (_local_1.iListA.visible)
            {
                _local_1.bg.width = ((_local_1.iListA.x + _local_1.iListA.w) + 5);
            }
            if (_local_1.iListB.visible)
            {
                _local_1.iListB.x = ((_local_1.iListA.x + _local_1.iListA.w) + 1);
                _local_1.bg.width = (_local_1.bg.width + (_local_1.iListB.w + 1));
                _local_1.iListA.divider.visible = (!(_local_1.iListA.scr.visible));
            }
            else
            {
                _local_1.iListA.divider.visible = false;
            }
            if (((_local_1.preview.t2.visible) || (_local_1.preview.cnt.visible)))
            {
                _local_1.preview.x = ((_local_1.iListB.x + _local_1.iListB.w) + 4);
                _local_1.bg.width = (_local_1.bg.width + (_local_1.preview.width + 4));
                _local_1.iListB.divider.visible = (!(_local_1.iListB.scr.visible));
            }
            else
            {
                _local_1.iListB.divider.visible = false;
            }
            var _local_2:* = ((((_local_1.tTitle.x + tTitle.width) + 4) + _local_1.btnClose.width) + 4);
            if (_local_1.bg.width < _local_2)
            {
                _local_1.bg.width = _local_2;
            }
            _local_1.btnClose.x = (_local_1.bg.width - 19);
            _local_1.fxmask.width = _local_1.bg.width;
            if (_local_1.x < 0)
            {
                _local_1.x = 0;
            }
            if ((_local_1.x + _local_1.bg.width) > 960)
            {
                _local_1.x = (960 - _local_1.bg.width);
            }
            if (_local_1.y < 0)
            {
                _local_1.y = 0;
            }
            if ((_local_1.y + _local_1.bg.height) > 495)
            {
                _local_1.y = (495 - _local_1.bg.height);
            }
            _local_1.txtSearch.width = (_local_1.iListB.width - ((_local_1.btnClose.width + 4) + 10));
        }

        public function scrDown(_arg_1:MouseEvent):*
        {
            mbY = int(mouseY);
            mhY = int(MovieClip(_arg_1.currentTarget.parent).h.y);
            scrTgt = MovieClip(_arg_1.currentTarget.parent);
            scrTgt.mDown = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, scrUp, false, 0, true);
        }

        public function scrUp(_arg_1:MouseEvent):*
        {
            scrTgt.mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        public function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            if (MovieClip(_arg_1.currentTarget.parent).mDown)
            {
                _local_2 = MovieClip(_arg_1.currentTarget.parent);
                mbD = (int(mouseY) - mbY);
                _local_2.h.y = (mhY + mbD);
                if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
                {
                    _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
                }
                if (_local_2.h.y < 0)
                {
                    _local_2.h.y = 0;
                }
            }
        }

        public function dEF(_arg_1:Event):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget.parent).scr;
            var _local_3:* = MovieClip(_arg_1.currentTarget);
            var _local_4:* = (-(_local_2.h.y) / hRun);
            var _local_5:* = (int((_local_4 * dRun)) + _local_3.oy);
            if (Math.abs((_local_5 - _local_3.y)) > 0.2)
            {
                _local_3.y = (_local_3.y + ((_local_5 - _local_3.y) / 4));
            }
            else
            {
                _local_3.y = _local_5;
            }
        }

        public function drawItemHandle(_arg_1:MovieClip):void
        {
            var _local_2:int = Math.ceil(_arg_1.width);
            var _local_3:int = Math.ceil(_arg_1.height);
            var _local_4:MovieClip = (MovieClip(this.parent).mcHouseItemHandle as MovieClip);
            _local_4.visible = true;
            var _local_5:Rectangle = _arg_1.getBounds(stage);
            _local_4.frame.width = ((_local_2 > 100) ? _local_2 : 100);
            _local_4.frame.height = ((_local_3 > 50) ? _local_3 : 50);
            _local_4.x = int((_arg_1.x - (_local_4.frame.width / 2)));
            _local_4.y = int(_local_5.y);
            if (_local_4.tgt != null)
            {
                _local_4.tgt.filters = [];
            }
            _local_4.tgt = _arg_1;
            _local_4.tgt.filters = [new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 2)];
        }

        public function hideItemHandle():void
        {
            var _local_1:MovieClip = (MovieClip(this.parent).mcHouseItemHandle as MovieClip);
            _local_1.visible = false;
            _local_1.x = 1000;
            if (_local_1.tgt != null)
            {
                _local_1.tgt.filters = [];
            }
            _local_1.tgt = null;
        }

        public function onHandleFlipClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseItemHandle;
            _local_2.tgt.scaleX = (_local_2.tgt.scaleX * -1);
            rootClass.world.hasModified = true;
        }

        public function onHandleMoveClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseItemHandle;
            _local_2.mDown = true;
            _local_2.ox = _local_2.x;
            _local_2.oy = _local_2.y;
            _local_2.mox = stage.mouseX;
            _local_2.moy = stage.mouseY;
            stage.addEventListener(MouseEvent.MOUSE_UP, onHandleMoveRelease, false, 0, true);
            rootClass.world.hasModified = true;
        }

        public function onHandleMoveRelease(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseItemHandle;
            _local_2.mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onHandleMoveRelease);
            world.houseItemValidate(MovieClip(_local_2.tgt));
        }

        public function onHandleDeleteClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseItemHandle;
            var _local_3:MovieClip = _local_2.tgt;
            _local_3.item.bEquip--;
            refreshIListB();
            delete _local_3.item;
            delete _local_3.ItemID;
            _local_3.removeEventListener(Event.ENTER_FRAME, world.onHouseItemEnterFrame);
            _local_3.parent.removeChild(_local_3);
            hideItemHandle();
            rootClass.world.hasModified = true;
        }

        public function onHandleCancelClick(_arg_1:MouseEvent=null):void
        {
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseItemHandle;
            if (((_local_2.tgt) && (!(_local_2.tgt.isStable))))
            {
                rootClass.showMessageBox("You can not leave this house item placed here!");
                return;
            }
            if (_local_2.tgt != null)
            {
                _local_2.tgt.filters = [];
            }
            _local_2.tgt = null;
            _local_2.x = 1000;
            _local_2.visible = false;
        }

        public function onHandleEnterFrame(_arg_1:Event):*
        {
            var _local_6:*;
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (_local_2.visible)
            {
                _local_2.bCancel.x = ((_local_2.frame.width - _local_2.bCancel.width) - 8);
                _local_2.bDelete.x = ((_local_2.bCancel.x - _local_2.bDelete.width) - 8);
                _local_2.bFlip.x = ((_local_2.bDelete.x - _local_2.bFlip.width) - 8);
                if (_local_2.mDown)
                {
                    _local_2.x = (_local_2.ox + (stage.mouseX - _local_2.mox));
                    _local_2.y = (_local_2.oy + (stage.mouseY - _local_2.moy));
                    if ((_local_2.x + (_local_2.frame.width / 2)) < 0)
                    {
                        _local_2.x = -(int((_local_2.frame.width / 2)));
                    }
                    if ((_local_2.x + (_local_2.frame.width / 2)) > 960)
                    {
                        _local_2.x = int((960 - (_local_2.frame.width / 2)));
                    }
                    if ((_local_2.y + (_local_2.frame.height / 2)) < 0)
                    {
                        _local_2.y = -(int((_local_2.frame.height / 2)));
                    }
                    if ((_local_2.y + (_local_2.frame.height / 2)) > 495)
                    {
                        _local_2.y = int((495 - (_local_2.frame.height / 2)));
                    }
                    _local_2.tgt.x = Math.ceil((_local_2.x + (_local_2.frame.width / 2)));
                    _local_2.tgt.y = Math.ceil((_local_2.y - (_local_2.tgt.getBounds(stage).y - _local_2.tgt.y)));
                }
            }
            var _local_3:MovieClip = MovieClip(rootClass.ui.mcPopup);
            var _local_4:int;
            var _local_5:int;
            while (_local_5 < world.CHARS.numChildren)
            {
                _local_6 = world.CHARS.getChildAt(_local_5);
                if (((_local_6.hasOwnProperty("isHouseItem")) && (MovieClip(_local_6).isHouseItem)))
                {
                    _local_4++;
                }
                _local_5++;
            }
            _local_3.mcHouseOptions.cnt.txtPlaced.text = (((world.strFrame + " - ") + _local_4) + "/200 placed");
        }

        public function onHouseMenuBGClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = MovieClip(this);
            _local_2.mDown = true;
            _local_2.ox = _local_2.x;
            _local_2.oy = _local_2.y;
            _local_2.mox = stage.mouseX;
            _local_2.moy = stage.mouseY;
            stage.addEventListener(MouseEvent.MOUSE_UP, onHouseMenuBGRelease, false, 0, true);
        }

        public function onHouseMenuBGRelease(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = MovieClip(this);
            _local_2.mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onHouseMenuBGRelease);
        }

        public function onHouseMenuBGEnterFrame(_arg_1:Event):*
        {
            var _local_2:MovieClip = (_arg_1.currentTarget.parent as MovieClip);
            if (_local_2.visible)
            {
                if (_local_2.mDown)
                {
                    _local_2.x = (_local_2.ox + (stage.mouseX - _local_2.mox));
                    _local_2.y = (_local_2.oy + (stage.mouseY - _local_2.moy));
                    if (_local_2.x < 0)
                    {
                        _local_2.x = 0;
                    }
                    if ((_local_2.x + _local_2.bg.width) > 960)
                    {
                        _local_2.x = (960 - _local_2.bg.width);
                    }
                    if (_local_2.y < 0)
                    {
                        _local_2.y = 0;
                    }
                    if ((_local_2.y + _local_2.bg.height) > 495)
                    {
                        _local_2.y = (495 - _local_2.bg.height);
                    }
                }
            }
        }


    }
}//package 

