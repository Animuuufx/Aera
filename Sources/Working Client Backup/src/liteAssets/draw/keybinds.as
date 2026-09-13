// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.keybinds

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import liteAssets.listOptionsItem.listKeybind;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.ui.*;

    public class keybinds extends MovieClip 
    {

        public var a1:MovieClip;
        public var btnClose:SimpleButton;
        public var a2:MovieClip;
        public var txtSearch:TextField;
        public var cntMask:MovieClip;
        public var frame:MovieClip;
        public var bg:MovieClip;
        public var btnReset:SimpleButton;
        public var SBar:MovieClip;
        public var optObj:*;
        public var optItem:*;
        public var Len:*;
        public var optionList:*;
        public var hRun:Number;
        public var dRun:Number;
        public var oy:Number;
        public var mDown:Boolean;
        public var mbY:int;
        public var mbD:int;
        public var mhY:int;
        public var pos:int;
        public var i:int;
        public var optionGet:Array;
        private var toolTip:*;
        internal var r:MovieClip;
        internal var sDown:Boolean;

        public function keybinds(_arg_1:MovieClip)
        {
            this.r = _arg_1;
            this.x = 480.3;
            this.y = 259.35;
            toolTip = _arg_1.ui.ToolTip;
            initOptions();
            redraw(optionGet);
            SBar.h.addEventListener(MouseEvent.MOUSE_DOWN, onScrDown, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_UP, onScrUp, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
            optionList.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
            optionList.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            txtSearch.addEventListener(Event.CHANGE, onSearch, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            btnReset.addEventListener(MouseEvent.CLICK, onReset, false, 0, true);
        }

        public function onReset(_arg_1:MouseEvent):void
        {
            var _local_3:*;
            r.initKeybindPref(true);
            var _local_2:int;
            while (_local_2 < 6)
            {
                _local_3 = r.ui.mcInterface.getChildByName(("keyA" + _local_2));
                _local_3.text = (_local_2 + 1).toString();
                _local_3.mouseEnabled = false;
                _local_2++;
            };
            this.parent.removeChild(this);
        }

        public function initOptions():void
        {
            optionGet = [{
                "strName":"Camera Tool",
                "sDesc":"Launches Camera Tool"
            }, {
                "strName":"World Camera",
                "sDesc":"Launches World Camera"
            }, {
                "strName":"Target Random Monster",
                "sDesc":"Targets a random monster in your room if available"
            }, {
                "strName":"Inventory",
                "sDesc":"Opens your inventory"
            }, {
                "strName":"Bank",
                "sDesc":"Opens the bank if you have a bank pet or bank cape in your inventory"
            }, {
                "strName":"Quest Log",
                "sDesc":"Opens your quest log where you can turn in your completed quests"
            }, {
                "strName":"Friends List",
                "sDesc":"Opens your friends list"
            }, {
                "strName":"Character Panel",
                "sDesc":"Opens the character panel"
            }, {
                "strName":"Player HP Bar",
                "sDesc":"Toggles the appearance of an HP bar above all player heads"
            }, {
                "strName":"Options",
                "sDesc":"Opens the options"
            }, {
                "strName":"Area List",
                "sDesc":"Opens up the /who list that shows who's in the map"
            }, {
                "strName":"Jump",
                "sDesc":"Makes your player do the jump animation"
            }, {
                "strName":"Auto Attack",
                "sDesc":"Activates the attack that every class knows"
            }, {
                "strName":"Skill 1",
                "sDesc":"Actives the first skill of your class if available"
            }, {
                "strName":"Skill 2",
                "sDesc":"Actives the second skill of your class if available"
            }, {
                "strName":"Skill 3",
                "sDesc":"Actives the third skill of your class if available"
            }, {
                "strName":"Skill 4",
                "sDesc":"Actives the fourth skill of your class if available"
            }, {
                "strName":"Skill 5",
                "sDesc":"Actives the potion slot if available"
            }, {
                "strName":"Travel Menu's Travel",
                "sDesc":"The keybind used to travel to the next map in the list for the Travel Menu"
            }, {
                "strName":"World Camera's Hide",
                "sDesc":"The keybind used to hide the World Camera's ui"
            }, {
                "strName":"Rest",
                "sDesc":"Your character will start resting to restore HP / MP"
            }, {
                "strName":"Hide Monsters",
                "sDesc":"Toggles the hide monsters function located on your player portrait"
            }, {
                "strName":"Hide Players",
                "sDesc":"Toggles the hide players feature"
            }, {
                "strName":"Cancel Target",
                "sDesc":"Cancels your target if available. Cooldown is your auto attack speed. (Has a minimum cooldown of 2 seconds)"
            }, {
                "strName":"Hide UI",
                "sDesc":"Hides portraits and map information located on the bottom right"
            }, {
                "strName":"Battle Analyzer",
                "sDesc":"Launches Battle Analyzer"
            }, {
                "strName":"Decline All Drops",
                "sDesc":"Declines all the drops on your screen. Be very cautious when binding this to a key"
            }, {
                "strName":"Stats Overview",
                "sDesc":"Toggle the Stats Panel/Overview!"
            }, {
                "strName":"Battle Analyzer Toggle",
                "sDesc":"Toggles the Start/Stop of Battle Analyzer"
            }, {
                "strName":"Custom Drops UI",
                "sDesc":"Toggles the visibility of Custom Drops UI"
            }, {
                "strName":"@ Debugger - Cell Menu",
                "sDesc":"Toggles the visibility of the Cell Menu"
            }, {
                "strName":"@ Debugger - Packet Logger",
                "sDesc":"Toggles the visibility of the Packet Logger"
            }, {
                "strName":"Dash",
                "sDesc":"After activating this keybind, your next movement click will be a dash."
            }, {
                "strName":"Outfits",
                "sDesc":"Opens the Outfits interface"
            }, {
                "strName":"Friendships UI",
                "sDesc":"Opens the Friendships UI interface"
            }];
        }

        public function onClose(_arg_1:MouseEvent):void
        {
            this.parent.removeChild(this);
            r.stage.focus = null;
        }

        public function onOver(_arg_1:MouseEvent):void
        {
            try
            {
                if (!_arg_1.target.parent.sDesc)
                {
                    return;
                };
                toolTip.openWith({"str":_arg_1.target.parent.sDesc});
            }
            catch(e)
            {
            };
        }

        public function onOut(_arg_1:MouseEvent):*
        {
            toolTip.close();
        }

        public function orderName(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = _arg_1["strName"];
            var _local_4:* = _arg_2["strName"];
            if (_local_3 < _local_4)
            {
                return (-1);
            };
            if (_local_3 > _local_4)
            {
                return (1);
            };
            return (0);
        }

        public function redraw(_arg_1:Array):void
        {
            var _local_2:*;
            SBar.h.y = 0;
            if (optionList != null)
            {
                this.removeChild(optionList);
                optionList = null;
            };
            optionList = this.addChild(new MovieClip());
            Len = _arg_1.length;
            _arg_1.sort(orderName);
            i = 0;
            var _local_3:* = 0;
            while (i < Len)
            {
                optObj = _arg_1[i];
                if (optObj.strName.indexOf("@ Debugger") != -1)
                {
                    if (Game.objLogin.iAccess < 30)
                    {
                        i = (i + 1);
                        continue;
                    };
                };
                optItem = new listKeybind(r, r.litePreference.data.keys[optObj.strName], optObj.sDesc);
                optItem.txtName.text = optObj.strName;
                _local_2 = optionList.addChild(optItem);
                _local_2.x = cntMask.x;
                _local_2.y = (cntMask.y + (35 * _local_3));
                _local_2.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
                _local_2.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
                i++;
                _local_3++;
            };
            optionList.mask = cntMask;
            mDown = false;
            hRun = (SBar.b.height - SBar.h.height);
            dRun = ((optionList.height - cntMask.height) + 5);
            oy = optionList.y;
            optionList.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
            optionList.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
        }

        public function onSearch(_arg_1:Event):void
        {
            initOptions();
            var _local_2:Number = 0;
            var _local_3:Array = new Array();
            var _local_4:int;
            while (_local_4 < optionGet.length)
            {
                if (optionGet[_local_4].strName.toLowerCase().indexOf(txtSearch.text.toLowerCase()) > -1)
                {
                    _local_3.push(optionGet[_local_4]);
                    _local_2 = (_local_2 + ((optionGet[_local_4].extra) ? (1 + optionGet[_local_4].extra.length) : 1));
                };
                _local_4++;
            };
            if (_local_2 <= 9)
            {
                SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN, onScrDown);
                this.removeEventListener(MouseEvent.MOUSE_UP, onScrUp);
                this.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            }
            else
            {
                if (((_local_2 > 9) && (!(SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN)))))
                {
                    SBar.h.addEventListener(MouseEvent.MOUSE_DOWN, onScrDown, false, 0, true);
                    this.addEventListener(MouseEvent.MOUSE_UP, onScrUp, false, 0, true);
                    this.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
                };
            };
            redraw(((txtSearch.text) ? _local_3 : optionGet));
            _local_3 = null;
        }

        public function onWheel(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            _local_2 = SBar;
            _local_2.h.y = (int(SBar.h.y) + ((_arg_1.delta * 3) * -1));
            if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
            {
                _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
            };
            if (_local_2.h.y < 0)
            {
                _local_2.h.y = 0;
            };
        }

        public function onScrDown(_arg_1:MouseEvent):*
        {
            mbY = int(mouseY);
            mhY = int(SBar.h.y);
            mDown = true;
        }

        public function onScrUp(_arg_1:MouseEvent):void
        {
            mDown = false;
        }

        public function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            if (mDown)
            {
                _local_2 = SBar;
                mbD = (int(mouseY) - mbY);
                _local_2.h.y = (mhY + mbD);
                if (((_local_2.h.y + 1) + _local_2.h.height) > (_local_2.b.height + 1))
                {
                    _local_2.h.y = int(((_local_2.b.height + 1) - _local_2.h.height));
                };
                if (_local_2.h.y < 1)
                {
                    _local_2.h.y = 1;
                };
            };
        }

        public function dEF(_arg_1:Event):*
        {
            var _local_2:* = SBar;
            var _local_3:* = optionList;
            var _local_4:* = (-(_local_2.h.y - 1) / hRun);
            var _local_5:* = (int((_local_4 * dRun)) + oy);
            if (Math.abs((_local_5 - _local_3.y)) > 0.2)
            {
                _local_3.y = (_local_3.y + ((_local_5 - _local_3.y) / 4));
            }
            else
            {
                _local_3.y = _local_5;
            };
        }


    }
}//package liteAssets.draw

