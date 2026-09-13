// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//OFrameMC

package 
{
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.text.*;

    public class OFrameMC extends MovieClip 
    {

        public var t1:MovieClip;
        public var cntMask:MovieClip;
        public var bg:MovieClip;
        internal var world:MovieClip;
        internal var rootClass:MovieClip;
        public var fData:Object = null;
        internal var uli:int;
        internal var isOpen:Boolean = false;
        internal var mc:MovieClip;
        internal var tcnt:MovieClip;
        internal var mDown:Boolean = false;
        internal var hRun:int = 0;
        internal var dRun:int = 0;
        internal var mbY:int = 0;
        internal var mhY:int = 0;
        internal var mbD:int = 0;

        public function OFrameMC()
        {
            addFrameScript(0, frame1, 4, frame5, 9, frame10);
            mc = MovieClip(this);
            rootClass = MovieClip(stage.getChildAt(0));
        }

        public function fOpenWith(_arg_1:*):*
        {
            fData = _arg_1;
            isOpen = true;
            clearCnt();
            if (mc.currentLabel != "Idle")
            {
                mc.gotoAndPlay("Open");
            }
            else
            {
                update();
            };
        }

        public function fClose():*
        {
            isOpen = false;
            fData = {};
            clearCnt();
            if (mc.currentLabel != "Init")
            {
                if (mc.currentLabel == "Idle")
                {
                    mc.gotoAndPlay("Close");
                }
                else
                {
                    mc.gotoAndStop("Init");
                };
            };
        }

        public function update():*
        {
            var _local_1:String;
            var _local_2:Class;
            var _local_3:MovieClip;
            var _local_4:Class;
            var _local_5:Object;
            var _local_8:String;
            var _local_9:MovieClip;
            var _local_10:MovieClip;
            var _local_11:MovieClip;
            mc.bg.btnPin.visible = false;
            mc.bg.btnTry.visible = false;
            mc.bg.btnWiki.visible = false;
            clearCnt();
            var _local_6:int;
            var _local_7:int;
            switch (fData.typ)
            {
                case "userListA":
                    _local_1 = "mcUListA";
                    _local_2 = (getDefinitionByName(_local_1) as Class);
                    _local_3 = (mc.addChild(new (_local_2)()) as MovieClip);
                    _local_3.name = "cnt";
                    _local_3.x = 10;
                    _local_3.y = ((t1.y + t1.height) + 4);
                    _local_3.mask = cntMask;
                    _local_3.scr.buttonMode = true;
                    t1.txtTitle.text = "Users in your area";
                    t1.txtSubTitle.text = "/who";
                    _local_6 = 0;
                    tcnt = MovieClip(mc.getChildByName("cnt"));
                    tcnt.strMeta.text = "Class";
                    for (_local_8 in fData.ul)
                    {
                        _local_5 = tcnt.cnt.addChild(new mcUListAItem());
                        _local_5.ID = fData.ul[_local_8].ID;
                        _local_5.txtName.text = fData.ul[_local_8].sName;
                        _local_5.txtMeta.text = fData.ul[_local_8].sClass;
                        _local_5.txtLevel.text = fData.ul[_local_8].iLvl;
                        _local_5.addEventListener(MouseEvent.CLICK, uNameClick, false, 0, true);
                        _local_5.buttonMode = true;
                        _local_5.y = (_local_6 * 20);
                        _local_6++;
                    };
                    _local_9 = tcnt.scr;
                    if (tcnt.cnt.height < tcnt.cntMask.height)
                    {
                        _local_9.visible = false;
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.cntMask.width / 2)));
                    }
                    else
                    {
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.width / 2)));
                        _local_10 = tcnt.cntMask;
                        _local_11 = tcnt.cnt;
                        _local_9.visible = true;
                        _local_9.h.height = int(((_local_10.height / _local_11.height) * _local_9.b.height));
                        hRun = (_local_9.b.height - _local_9.h.height);
                        dRun = ((_local_11.height - _local_10.height) + 5);
                        _local_9.h.y = 0;
                        _local_11.oy = (_local_11.y = _local_9.y);
                        _local_9.visible = false;
                        _local_9.hit.alpha = 0;
                        mDown = false;
                        if (_local_11.height > _local_9.b.height)
                        {
                            _local_9.visible = true;
                            _local_9.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                            _local_9.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                            _local_11.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
                        };
                    };
                    tcnt.cnt.iproto.visible = false;
                    break;
                case "userListFriends":
                    _local_1 = "mcUListA";
                    _local_2 = (getDefinitionByName(_local_1) as Class);
                    _local_3 = (mc.addChild(new (_local_2)()) as MovieClip);
                    _local_3.name = "cnt";
                    _local_3.x = 10;
                    _local_3.y = ((t1.y + t1.height) + 4);
                    _local_3.mask = cntMask;
                    _local_3.scr.buttonMode = true;
                    t1.txtTitle.text = ((("Friends List - " + fData.ul.length) + "/") + String(rootClass.iMaxFriends));
                    t1.txtSubTitle.text = "/friends";
                    _local_6 = 0;
                    tcnt = MovieClip(mc.getChildByName("cnt"));
                    tcnt.strMeta.text = "Server";
                    _local_7 = 0;
                    while (_local_7 < fData.ul.length)
                    {
                        _local_5 = tcnt.cnt.addChild(new mcUListAItem());
                        _local_5.ID = fData.ul[_local_7].ID;
                        _local_5.txtName.text = fData.ul[_local_7].sName;
                        _local_5.txtMeta.text = fData.ul[_local_7].sServer;
                        _local_5.txtLevel.text = fData.ul[_local_7].iLvl;
                        _local_5.addEventListener(MouseEvent.CLICK, uNameClick, false, 0, true);
                        _local_5.buttonMode = true;
                        _local_5.y = (_local_6 * 20);
                        _local_6++;
                        if (fData.ul[_local_7].sServer == "Offline")
                        {
                            _local_5.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -100, -100, -100, 0);
                        };
                        _local_7++;
                    };
                    _local_9 = tcnt.scr;
                    if (tcnt.cnt.height < tcnt.cntMask.height)
                    {
                        _local_9.visible = false;
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.cntMask.width / 2)));
                    }
                    else
                    {
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.width / 2)));
                        _local_10 = tcnt.cntMask;
                        _local_11 = tcnt.cnt;
                        _local_9.visible = true;
                        _local_9.h.height = int(((_local_10.height / _local_11.height) * _local_9.b.height));
                        hRun = (_local_9.b.height - _local_9.h.height);
                        dRun = ((_local_11.height - _local_10.height) + 5);
                        _local_9.h.y = 0;
                        _local_11.oy = (_local_11.y = _local_9.y);
                        _local_9.visible = false;
                        _local_9.hit.alpha = 0;
                        mDown = false;
                        if (_local_11.height > _local_9.b.height)
                        {
                            _local_9.visible = true;
                            _local_9.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                            _local_9.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                            _local_11.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
                        };
                    };
                    tcnt.cnt.iproto.visible = false;
                    break;
                case "userListGuild":
                    _local_1 = "mcUListA";
                    _local_2 = (getDefinitionByName(_local_1) as Class);
                    _local_3 = (mc.addChild(new (_local_2)()) as MovieClip);
                    _local_3.name = "cnt";
                    _local_3.x = 10;
                    _local_3.y = ((t1.y + t1.height) + 4);
                    _local_3.mask = cntMask;
                    _local_3.scr.buttonMode = true;
                    t1.txtTitle.text = "Guild Members";
                    t1.txtSubTitle.text = "/guild";
                    _local_6 = 0;
                    tcnt = MovieClip(mc.getChildByName("cnt"));
                    tcnt.strMeta.text = "Server";
                    _local_7 = 0;
                    while (_local_7 < fData.ul.length)
                    {
                        _local_5 = tcnt.cnt.addChild(new mcUListAItem());
                        _local_5.ID = fData.ul[_local_7].ID;
                        _local_5.txtName.text = fData.ul[_local_7].userName;
                        _local_5.txtMeta.text = fData.ul[_local_7].Server;
                        _local_5.txtLevel.text = fData.ul[_local_7].Level;
                        _local_5.addEventListener(MouseEvent.CLICK, uNameClick, false, 0, true);
                        _local_5.buttonMode = true;
                        _local_5.y = (_local_6 * 20);
                        _local_6++;
                        if (fData.ul[_local_7].sServer == "Offline")
                        {
                            _local_5.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -100, -100, -100, 0);
                        };
                        _local_7++;
                    };
                    _local_9 = tcnt.scr;
                    if (tcnt.cnt.height < tcnt.cntMask.height)
                    {
                        _local_9.visible = false;
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.cntMask.width / 2)));
                    }
                    else
                    {
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.width / 2)));
                        _local_10 = tcnt.cntMask;
                        _local_11 = tcnt.cnt;
                        _local_9.visible = true;
                        _local_9.h.height = int(((_local_10.height / _local_11.height) * _local_9.b.height));
                        hRun = (_local_9.b.height - _local_9.h.height);
                        dRun = ((_local_11.height - _local_10.height) + 5);
                        _local_9.h.y = 0;
                        _local_11.oy = (_local_11.y = _local_9.y);
                        _local_9.visible = false;
                        _local_9.hit.alpha = 0;
                        mDown = false;
                        if (_local_11.height > _local_9.b.height)
                        {
                            _local_9.visible = true;
                            _local_9.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                            _local_9.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                            _local_11.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
                        };
                    };
                    tcnt.cnt.iproto.visible = false;
                    break;
                case "userListIgnore":
                    _local_1 = "mcUListB";
                    _local_2 = (getDefinitionByName(_local_1) as Class);
                    _local_3 = (mc.addChild(new (_local_2)()) as MovieClip);
                    _local_3.name = "cnt";
                    _local_3.x = 10;
                    _local_3.y = ((t1.y + t1.height) + 4);
                    _local_3.mask = cntMask;
                    _local_3.scr.buttonMode = true;
                    t1.txtTitle.text = "Ignore List";
                    t1.txtSubTitle.text = "";
                    _local_6 = 0;
                    tcnt = MovieClip(mc.getChildByName("cnt"));
                    fData.ul = [];
                    for each (_local_8 in rootClass.chatF.ignoreList.data.users)
                    {
                        fData.ul.push({"sName":_local_8});
                    };
                    _local_7 = 0;
                    while (_local_7 < fData.ul.length)
                    {
                        _local_5 = tcnt.cnt.addChild(new mcUListBItem());
                        _local_5.txtName.text = fData.ul[_local_7].sName;
                        _local_5.addEventListener(MouseEvent.CLICK, uNameClick, false, 0, true);
                        _local_5.buttonMode = true;
                        _local_5.y = (_local_6 * 20);
                        _local_6++;
                        _local_7++;
                    };
                    _local_9 = tcnt.scr;
                    if (tcnt.cnt.height < tcnt.cntMask.height)
                    {
                        _local_9.visible = false;
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.cntMask.width / 2)));
                    }
                    else
                    {
                        _local_3.x = int(((mc.bg.x + (mc.bg.width / 2)) - (_local_3.width / 2)));
                        _local_10 = tcnt.cntMask;
                        _local_11 = tcnt.cnt;
                        _local_9.visible = true;
                        _local_9.h.height = int(((_local_10.height / _local_11.height) * _local_9.b.height));
                        hRun = (_local_9.b.height - _local_9.h.height);
                        dRun = ((_local_11.height - _local_10.height) + 5);
                        _local_9.h.y = 0;
                        _local_11.oy = (_local_11.y = _local_9.y);
                        _local_9.visible = false;
                        _local_9.hit.alpha = 0;
                        mDown = false;
                        if (_local_11.height > _local_9.b.height)
                        {
                            _local_9.visible = true;
                            _local_9.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                            _local_9.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                            _local_11.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
                        };
                    };
                    tcnt.cnt.iproto.visible = false;
                    break;
            };
            mc.bg.btnClose.addEventListener(MouseEvent.CLICK, closeClick, false, 0, true);
            mc.bg.fx.visible = false;
        }

        private function clearCnt():*
        {
            var _local_1:* = mc.getChildByName("cnt");
            if (_local_1 != null)
            {
                mc.removeChild(_local_1);
            };
        }

        private function closeClick(_arg_1:MouseEvent):*
        {
            fClose();
        }

        private function uNameClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            rootClass.debugMessage(("User clicked: " + _local_2.txtName.text));
            var _local_3:* = {};
            if (("ID" in _local_2))
            {
                _local_3.ID = _local_2.ID;
            };
            _local_3.strUsername = _local_2.txtName.text;
            if (((fData.typ == "userListFriends") && (!(_local_2.txtMeta.text == rootClass.objServerInfo.sName))))
            {
                rootClass.ui.cMenu.fOpenWith("offline", _local_3);
            }
            else
            {
                if (((fData.typ == "userListFriends") && (_local_2.txtMeta.text == rootClass.objServerInfo.sName)))
                {
                    rootClass.ui.cMenu.fOpenWith("friend", _local_3);
                }
                else
                {
                    if (fData.typ == "userListIgnore")
                    {
                        rootClass.ui.cMenu.fOpenWith("ignored", _local_3);
                    }
                    else
                    {
                        rootClass.ui.cMenu.fOpenWith("user", _local_3);
                    };
                };
            };
        }

        private function scrUp(_arg_1:MouseEvent):*
        {
            mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        private function scrDown(_arg_1:MouseEvent):*
        {
            mbY = int(mouseY);
            mhY = int(tcnt.scr.h.y);
            mDown = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        private function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            if (mDown)
            {
                _local_2 = tcnt.scr;
                mbD = (int(mouseY) - mbY);
                _local_2.h.y = (mhY + mbD);
                if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
                {
                    _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
                };
                if (_local_2.h.y < 0)
                {
                    _local_2.h.y = 0;
                };
            };
        }

        private function dEF(_arg_1:Event):*
        {
            var _local_2:* = tcnt.scr;
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
            };
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame5():*
        {
            update();
        }

        internal function frame10():*
        {
            stop();
        }


    }
}//package 

