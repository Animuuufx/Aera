// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcMenu_299

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class mcMenu_299 extends MovieClip 
    {

        public var btnQuest:MovieClip;
        public var btnRest:SimpleButton;
        public var btnHouse:MovieClip;
        public var btnChar:MovieClip;
        public var btnMenu:SimpleButton;
        public var btnBook:SimpleButton;
        public var btnBag:SimpleButton;
        public var btnMap:SimpleButton;
        public var btnOption:SimpleButton;
        public var menu:*;

        public function mcMenu_299()
        {
            addFrameScript(0, frame1);
        }

        public function onMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(stage.getChildAt(0));
            var _local_3:* = MovieClip(stage.getChildAt(0)).ui.ToolTip;
            switch (_arg_1.currentTarget.name)
            {
                case "btnRest":
                    _local_3.openWith({"str":"Rest"});
                    return;
                case "btnBag":
                    _local_3.openWith({"str":"Inventory"});
                    return;
                case "btnTemp":
                    _local_3.openWith({"str":"Temp Inventory"});
                    return;
                case "btnMenu":
                    _local_3.openWith({"str":"Game Menu"});
                    return;
                case "btnMap":
                    _local_3.openWith({"str":"Map"});
                    return;
                case "btnOption":
                    _local_3.openWith({"str":"Options"});
                    return;
                case "btnQuest":
                    _local_3.openWith({"str":"Quests"});
                    return;
                case "btnBook":
                    _local_3.openWith({"str":"Book of Lore"});
                    return;
                case "btnHouse":
                    _local_3.openWith({"str":"House"});
                    return;
                case "btnChar":
                    if (menu == null)
                    {
                        _local_3.openWith({"str":"Character"});
                    };
                    return;
            };
        }

        public function onMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(stage.getChildAt(0));
            var _local_3:* = MovieClip(stage.getChildAt(0)).ui.ToolTip;
            _local_3.close();
        }

        public function onMouseClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(stage.getChildAt(0));
            MovieClip(Game.root).mixer.playSound("Click");
            if (_arg_1.currentTarget.name != "btnMenu")
            {
                _local_2.menuClose();
            };
            switch (_arg_1.currentTarget.name)
            {
                case "btnRest":
                    handleMenu(null);
                    MovieClip(parent.parent.parent).world.rest();
                    return;
                case "btnBag":
                    handleMenu(null);
                    toggleInventory();
                    return;
                case "btnMenu":
                    handleMenu(null);
                    _local_2.MenuShow();
                    return;
                case "btnMap":
                    if (_local_2.ui.mcPopup.currentLabel == "Map")
                    {
                        _local_2.ui.mcPopup.onClose();
                    }
                    else
                    {
                        handleMenu(null);
                        _local_2.ui.mcPopup.fOpen("Map");
                    };
                    return;
                case "btnBook":
                    if (_local_2.ui.mcPopup.currentLabel == "Book")
                    {
                        _local_2.ui.mcPopup.onClose();
                    }
                    else
                    {
                        handleMenu(null);
                        _local_2.ui.mcPopup.fOpen("Book");
                    };
                    return;
                case "btnOption":
                    if (_local_2.ui.mcPopup.currentLabel == "Option")
                    {
                        _local_2.ui.mcPopup.onClose();
                    }
                    else
                    {
                        handleMenu(null);
                        _local_2.ui.mcPopup.fOpen("Option");
                    };
                    return;
                case "btnQuest":
                    handleMenu(MovieClip(_arg_1.currentTarget));
                    return;
                case "btnHouse":
                    if (((_local_2.world.strMapName.toLowerCase() == "house") && (_local_2.world.isMyHouse())))
                    {
                        _local_2.world.moveToCell("Enter", "Spawn");
                        return;
                    };
                    if (_local_2.world.isHouseEquipped())
                    {
                        _local_2.world.gotoHouse(_local_2.sfc.myUserName);
                    }
                    else
                    {
                        _local_2.world.gotoTown("buyhouse", "Enter", "Spawn");
                    };
                    return;
                case "btnChar":
                    handleMenu(MovieClip(_arg_1.currentTarget));
                    return;
            };
        }

        public function handleMenu(_arg_1:MovieClip):void
        {
            var _local_2:MovieClip;
            if (_arg_1 == null)
            {
                if (menu == null)
                {
                    return;
                };
                _local_2 = MovieClip(this.getChildByName(menu.btnOpen));
                _local_2.removeChild(menu.mcMenu);
                menu = null;
                return;
            };
            if (menu == null)
            {
                menu = new interfaceMenu(_arg_1.buttons, _arg_1.name, MovieClip(stage.getChildAt(0)));
                _arg_1.addChild(menu.mcMenu);
            }
            else
            {
                if (((_arg_1 == null) || (menu.btnOpen == _arg_1.name)))
                {
                    _arg_1.removeChild(menu.mcMenu);
                    menu = null;
                }
                else
                {
                    _local_2 = MovieClip(this.getChildByName(menu.btnOpen));
                    _local_2.removeChild(menu.mcMenu);
                    menu = null;
                    menu = new interfaceMenu(_arg_1.buttons, _arg_1.name, MovieClip(stage.getChildAt(0)));
                    _arg_1.addChild(menu.mcMenu);
                };
            };
        }

        public function toggleTempInventory():void
        {
            var _local_1:* = MovieClip(stage.getChildAt(0));
            if (!_local_1.world.uiLock)
            {
                if (_local_1.ui.mcPopup.currentLabel == "Temp")
                {
                    _local_1.ui.mcPopup.onClose();
                }
                else
                {
                    _local_1.ui.mcPopup.fOpen("Temp");
                };
            };
        }

        public function toggleInventory():void
        {
            var _local_1:* = MovieClip(stage.getChildAt(0));
            if (!_local_1.world.uiLock)
            {
                if (((_local_1.ui.mcPopup.currentLabel == "Inventory") || (_local_1.ui.mcPopup.currentLabel == "HouseInventory")))
                {
                    MovieClip(_local_1.ui.mcPopup.getChildByName("mcInventory")).fClose();
                }
                else
                {
                    _local_1.ui.mcPopup.fOpen("Inventory");
                };
            };
        }

        internal function frame1():*
        {
            btnRest.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnRest.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnBag.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnBag.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnMenu.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnMenu.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnMap.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnMap.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnOption.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnOption.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnQuest.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnQuest.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnRest.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnBag.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnMenu.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnOption.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnMap.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnQuest.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnBook.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnBook.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnBook.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnHouse.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnHouse.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnHouse.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnChar.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnChar.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnChar.addEventListener(MouseEvent.CLICK, onMouseClick);
        }


    }
}//package spider_fla

