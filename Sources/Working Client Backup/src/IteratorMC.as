// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//IteratorMC

package 
{
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class IteratorMC extends MovieClip 
    {

        internal var objLogin:Object;
        internal var mcI:MovieClip;
        internal var rootClass:MovieClip;
        internal var iCap:int = 0;
        internal var mHiOnCT:ColorTransform = new ColorTransform();
        internal var mHiPendingCT:ColorTransform = new ColorTransform();
        internal var eventStackCenter:int;
        internal var cheatArr:* = ["/iay Artix@Battle On!", "/iteratortest", "/clear map", "/clear quest", "/clear item", "/clear shop", "/clear report", "/moveafk ultra battleon", "/killmap", "/restartnow", "/restart", "/boost reset"];

        public function IteratorMC()
        {
            trace("setting up iterator");
        }

        public function init(_arg_1:MovieClip, _arg_2:MovieClip, _arg_3:Object):*
        {
            this.rootClass = _arg_1;
            this.mcI = _arg_2;
            this.mcI.cheats.cnt.iproto.visible = false;
            this.mcI.serverStack.cnt.iproto.visible = false;
            this.mcI.eventStack.cnt.iproto.visible = false;
            this.mcI.bgfx.visible = false;
            this.objLogin = _arg_3;
            this.rootClass.serialCmd.servers = [];
            this.mHiOnCT.color = 39423;
            this.mHiPendingCT.color = 0xFF6600;
            this.eventStackCenter = this.mcI.eventStack.y;
            this.mcI.cmd.msgBox.text = "Iterator Loaded\n";
            this.mcI.cmd.btnGo.addEventListener(MouseEvent.CLICK, this.submitClick, false, 0, true);
            this.mcI.cmd.btnLogout.addEventListener(MouseEvent.CLICK, this.onLogout, false, 0, true);
            this.mcI.cmd.btnSelectAll.addEventListener(MouseEvent.CLICK, this.onSelectAll, false, 0, true);
            this.mcI.cmd.btnUnselectAll.addEventListener(MouseEvent.CLICK, this.onUnselectAll, false, 0, true);
            this.mcI.cmd.btnSelectAll.buttonMode = true;
            this.mcI.cmd.btnUnselectAll.buttonMode = true;
            this.mcI.cmd.btnLogout.buttonMode = true;
            this.mcI.cmd.btnGo.buttonMode = true;
            this.buildCheats();
            this.buildServers();
            this.initEventStack();
        }

        public function onSelectAll(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_2:int = this.mcI.serverStack.cnt.numChildren;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_3 = (this.mcI.serverStack.cnt.getChildAt(_local_4) as MovieClip);
                this.serverOn(_local_3);
                _local_4++;
            };
        }

        public function onUnselectAll(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_2:int = this.mcI.serverStack.cnt.numChildren;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_3 = (this.mcI.serverStack.cnt.getChildAt(_local_4) as MovieClip);
                this.serverOff(_local_3);
                _local_4++;
            };
        }

        public function onLogout(_arg_1:MouseEvent):void
        {
            this.rootClass.serialCmdMode = false;
            (this.mcI.parent as MovieClip).gotoAndPlay("Login");
        }

        private function buildServers():void
        {
            var _local_5:Object;
            var _local_6:MovieClip;
            var _local_1:Array = this.objLogin.servers;
            var _local_2:MovieClip = this.mcI.serverStack.cnt;
            var _local_3:int;
            var _local_4:int;
            while (_local_4 < _local_1.length)
            {
                _local_5 = _local_1[_local_4];
                _local_6 = (_local_2.addChild(new itProto()) as MovieClip);
                _local_6.t1.text = _local_5.sName;
                _local_6.t2.text = ((_local_5.sIP + ":") + _local_5.iPort);
                _local_6.t2.visible = false;
                _local_6.t3.visible = false;
                _local_6.isOn = false;
                _local_6.server = _local_1[_local_4];
                _local_6.name = ("i" + _local_4);
                _local_6.buttonMode = true;
                _local_6.addEventListener(MouseEvent.MOUSE_DOWN, this.onServerDown, false, 0, true);
                _local_6.addEventListener(MouseEvent.MOUSE_OVER, this.onServerOver, false, 0, true);
                _local_6.mouseChildren = false;
                _local_6.y = (this.mcI.serverStack.cnt.iproto.y - (_local_3++ * 24));
                if (_local_5.sName.substr(0, 3) == "Dev")
                {
                    this.serverOff(_local_6);
                }
                else
                {
                    this.serverOn(_local_6);
                };
                _local_4++;
            };
        }

        private function buildCheats():void
        {
            var _local_2:MovieClip;
            var _local_1:MovieClip = this.mcI.cheats.cnt;
            var _local_3:int;
            while (_local_3 < this.cheatArr.length)
            {
                _local_2 = (_local_1.addChild(new itCProto()) as MovieClip);
                _local_2.ti.text = this.cheatArr[_local_3];
                _local_2.addEventListener(MouseEvent.CLICK, this.onCheatClick, false, 0, true);
                _local_2.buttonMode = true;
                _local_2.y = (this.mcI.cheats.cnt.iproto.y + (_local_3 * 21));
                _local_3++;
            };
        }

        private function initEventStack():void
        {
            this.mcI.eventStack.adder.addEventListener(MouseEvent.CLICK, this.onAdderClick);
            this.mcI.eventStack.adder.buttonMode = true;
        }

        private function updateEventStack():void
        {
            var _local_3:DisplayObject;
            var _local_4:int;
            var _local_1:MovieClip = this.mcI.eventStack.cnt;
            var _local_2:int = _local_1.numChildren;
            if (_local_2 > 1)
            {
                _local_4 = 1;
                while (_local_4 < _local_2)
                {
                    _local_3 = _local_1.getChildAt(_local_4);
                    _local_3.y = int((_local_4 * 26));
                    _local_4++;
                };
            };
        }

        private function addToEventStack():void
        {
            var _local_1:MovieClip = this.mcI.eventStack.cnt;
            var _local_2:MovieClip = _local_1.iproto;
            var _local_3:* = _local_2.constructor;
            var _local_4:MovieClip = (_local_1.addChild(new itEProto()) as MovieClip);
            _local_4.btnAdd.addEventListener(MouseEvent.CLICK, this.onVarAddClick, false, 0, true);
            _local_4.btnDel.addEventListener(MouseEvent.CLICK, this.onVarDelClick, false, 0, true);
            _local_4.btnAdd.buttonMode = true;
            _local_4.btnDel.buttonMode = true;
            this.updateEventStack();
        }

        private function addVarToCmd(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            var _local_8:Array;
            var _local_9:int;
            var _local_10:Array;
            var _local_4:String = this.mcI.cmd.ti.text;
            var _local_5:Array = this.mcI.cmd.ti.text.split(" ");
            var _local_6:Boolean;
            var _local_7:Boolean;
            if ((((_local_5.length > 2) && (_local_5[1].toLowerCase() == _arg_1.toLowerCase())) && (_local_4.indexOf("=") > -1)))
            {
                _local_8 = _local_5[2].split(",");
                _local_9 = 0;
                while (_local_9 < _local_8.length)
                {
                    _local_10 = _local_8[_local_9].split("=");
                    if (_local_10[0].toLowerCase() == _arg_2.toLowerCase())
                    {
                        _local_7 = true;
                        _local_10[1] = _arg_3;
                        _local_8[_local_9] = _local_10.join("=");
                    };
                    _local_9++;
                };
                if (!_local_7)
                {
                    _local_8.push(((_arg_2 + "=") + _arg_3));
                };
                _local_5[2] = _local_8.join(",");
                this.mcI.cmd.ti.text = ((("/event " + _arg_1) + " ") + _local_5[2]);
            }
            else
            {
                this.mcI.cmd.ti.text = ((((("/event " + _arg_1) + " ") + _arg_2) + "=") + _arg_3);
            };
        }

        private function delVarFromCmd(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
        }

        public function getServerItemByIP(_arg_1:String, _arg_2:Number):MovieClip
        {
            var _local_4:MovieClip;
            var _local_3:int = this.mcI.serverStack.cnt.numChildren;
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _local_4 = (this.mcI.serverStack.cnt.getChildAt(_local_5) as MovieClip);
                if (((((!(_local_4.name.toLowerCase() == "iproto")) && (!(_local_4.server == null))) && (_local_4.server.sIP == _arg_1)) && (_local_4.server.iPort == _arg_2)))
                {
                    return (_local_4);
                };
                _local_5++;
            };
            return (null);
        }

        private function assignActiveServers():void
        {
            var _local_3:MovieClip;
            var _local_1:int = this.mcI.serverStack.cnt.numChildren;
            this.rootClass.serialCmd.servers = [];
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                _local_3 = (this.mcI.serverStack.cnt.getChildAt(_local_2) as MovieClip);
                if (((!(_local_3.name == "iproto")) && (_local_3.isOn)))
                {
                    this.rootClass.serialCmd.servers.push(_local_3.server);
                    this.serverPending(_local_3);
                };
                _local_2++;
            };
        }

        private function onCheatClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            this.mcI.cmd.ti.text = _local_2.ti.text;
        }

        private function toggleServer(_arg_1:MovieClip):void
        {
            if (_arg_1.isOn)
            {
                this.serverOff(_arg_1);
            }
            else
            {
                this.serverOn(_arg_1);
            };
        }

        public function serverOn(_arg_1:MovieClip):void
        {
            _arg_1.isOn = true;
            _arg_1.mHi.visible = true;
            _arg_1.mHi.transform.colorTransform = this.mHiOnCT;
        }

        public function serverOff(_arg_1:MovieClip):void
        {
            _arg_1.isOn = false;
            _arg_1.mHi.visible = false;
            _arg_1.mHi.transform.colorTransform = this.mHiOnCT;
        }

        private function serverPending(_arg_1:MovieClip):void
        {
            _arg_1.mHi.visible = true;
            _arg_1.mHi.transform.colorTransform = this.mHiPendingCT;
        }

        public function serversOff(_arg_1:MovieClip):void
        {
            var _local_2:Array = this.rootClass.serialCmd.servers;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _arg_1 = this.getServerItemByIP(_local_2[_local_3].sIP, _local_2[_local_3].iPort);
                if (_arg_1 != null)
                {
                    this.serverOff(_arg_1);
                };
                _local_3++;
            };
        }

        private function onServerDown(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            this.toggleServer(_local_2);
        }

        private function onServerOver(_arg_1:MouseEvent):void
        {
            if (_arg_1.buttonDown)
            {
                this.serverOn((_arg_1.currentTarget as MovieClip));
            };
        }

        private function onVarAddClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget.parent as MovieClip);
            this.addVarToCmd(_local_2.t1.text, _local_2.t2.text, _local_2.t3.text);
        }

        private function onVarDelClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget.parent as MovieClip);
            _local_2.btnAdd.removeEventListener(MouseEvent.CLICK, this.onVarAddClick);
            _local_2.btnDel.removeEventListener(MouseEvent.CLICK, this.onVarDelClick);
            this.delVarFromCmd(_local_2.t1.text, _local_2.t2.text, _local_2.t3.text);
            this.mcI.eventStack.cnt.removeChild(_local_2);
            this.updateEventStack();
        }

        private function onAdderClick(_arg_1:MouseEvent):void
        {
            this.addToEventStack();
        }

        private function submitClick(_arg_1:MouseEvent):void
        {
            if (!this.rootClass.serialCmd.active)
            {
                this.clearTimes();
                this.mcI.cmd.lastcmd.ti.text = this.mcI.cmd.ti.text;
                if (!this.mcI.cmd.lastcmd.visible)
                {
                    this.mcI.cmd.lastcmd.visible = true;
                };
                this.assignActiveServers();
                this.rootClass.serialCmdInit(this.mcI.cmd.ti.text);
            }
            else
            {
                trace("serirlCmd busy!!");
            };
        }

        private function eventStackPos(_arg_1:Event):void
        {
            if (int((this.mcI.eventStack.y + (this.mcI.eventStack.height / 2))) != this.eventStackCenter)
            {
                this.mcI.eventStack.y = (this.mcI.eventStack.y - (((this.mcI.eventStack.y - (this.mcI.eventStack.height / 2)) - this.eventStackCenter) / 4));
                if (Math.abs(((this.mcI.eventStack.y - (this.mcI.eventStack.height / 2)) - this.eventStackCenter)) < 1)
                {
                    this.mcI.eventStack.y = int((this.eventStackCenter + (this.mcI.eventStack.height / 2)));
                };
            };
        }

        private function clearTimes():void
        {
            var _local_3:MovieClip;
            var _local_1:int = this.mcI.serverStack.cnt.numChildren;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                _local_3 = (this.mcI.serverStack.cnt.getChildAt(_local_2) as MovieClip);
                if (((!(_local_3.name == "iproto")) && (_local_3.isOn)))
                {
                    _local_3.t3.visible = false;
                };
                _local_2++;
            };
        }


    }
}//package 

