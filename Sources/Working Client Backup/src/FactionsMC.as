// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//FactionsMC

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.*;

    public class FactionsMC extends MovieClip 
    {

        public var cnt:MovieClip;
        public var world:MovieClip;
        public var rootClass:MovieClip;
        internal var isOpen:Boolean = false;
        internal var mc:MovieClip;
        internal var mDown:Boolean = false;
        internal var hRun:int = 0;
        internal var dRun:int = 0;
        internal var mbY:int = 0;
        internal var mhY:int = 0;
        internal var mbD:int = 0;
        internal var qly:int = 57;
        internal var iRepMax:int = 302500;
        public var factions:Array;

        public function FactionsMC():void
        {
            addFrameScript(0, frame1, 6, frame7, 11, frame12, 15, frame16);
            mc = MovieClip(this);
            mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK, xClick);
        }

        public function open():*
        {
            rootClass = MovieClip(this.stage.getChildAt(0));
            world = rootClass.world;
            factions = world.myAvatar.factions;
            mc = MovieClip(this);
            if (!isOpen)
            {
                isOpen = true;
                mc.cnt.gotoAndPlay("intro");
            }
            else
            {
                isOpen = false;
                fClose();
            };
        }

        public function showFactionList():*
        {
            if (factions.length > 0)
            {
                buildFactionList();
            }
            else
            {
                showEmptyList();
            };
            mc.cnt.fList.visible = true;
            mc.cnt.fList.mHi.visible = false;
            mc.cnt.mouseChildren = true;
        }

        private function buildFactionList():*
        {
            var _local_2:MovieClip;
            var _local_1:Object = {};
            factions.sortOn("sName");
            var _local_3:* = 0;
            while (_local_3 < factions.length)
            {
                _local_1 = factions[_local_3];
                if (_local_1 != null)
                {
                    _local_2 = (mc.cnt.fList.addChild(new fProto()) as MovieClip);
                    _local_2.t1.htmlText = _local_1.sName;
                    _local_2.tRank.htmlText = ("Rank " + _local_1.iRank);
                    if (_local_1.iRank == "10")
                    {
                        _local_1.iSpillRep = 0;
                    };
                    _local_2.t2.htmlText = ((_local_1.iSpillRep + " <font color='#FF0000'>/</font> ") + _local_1.iRepToRank);
                    _local_2.addEventListener(MouseEvent.MOUSE_OVER, iMouseOver, false, 0, true);
                    _local_2.addEventListener(MouseEvent.MOUSE_OUT, iMouseOut, false, 0, true);
                    _local_2.hit.alpha = 0;
                    _local_2.y = (_local_3 * 20);
                    _local_2.x = 10;
                };
                _local_3++;
            };
            var _local_4:* = mc.cnt.scr;
            var _local_5:* = mc.cnt.bMask;
            var _local_6:* = mc.cnt.fList;
            _local_4.h.height = int(((_local_4.b.height / _local_6.height) * _local_4.b.height));
            hRun = (_local_4.b.height - _local_4.h.height);
            dRun = ((_local_6.height - _local_4.b.height) + 20);
            _local_4.h.y = 0;
            _local_6.oy = (_local_6.y = qly);
            _local_4.visible = false;
            _local_4.hit.alpha = 0;
            mDown = false;
            if (_local_6.height > _local_4.b.height)
            {
                _local_4.visible = true;
                _local_4.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                _local_4.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                _local_6.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            };
            mc.cnt.scr.hit.buttonMode = true;
            mc.cnt.fList.iproto.visible = false;
        }

        private function fListClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
        }

        private function showEmptyList():*
        {
            var _local_1:* = mc.cnt.fList.addChild(new fProto());
            _local_1.t1.htmlText = '<font color="#DDDDDD">No Factions!</font>';
            _local_1.t2.visible = false;
            _local_1.tRank.visible = false;
            _local_1.hit.alpha = 0;
            _local_1.x = 10;
            mc.cnt.fList.iproto.visible = false;
            mc.cnt.scr.visible = false;
        }

        private function scrDown(_arg_1:MouseEvent):*
        {
            mbY = int(mouseY);
            mhY = int(MovieClip(_arg_1.currentTarget.parent).h.y);
            mDown = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        private function scrUp(_arg_1:MouseEvent):*
        {
            mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        private function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            if (mDown)
            {
                _local_2 = MovieClip(_arg_1.currentTarget.parent);
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
            };
        }

        public function xClick(_arg_1:MouseEvent=null):*
        {
            mc.gotoAndPlay("outro");
        }

        public function fClose():void
        {
            mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK, xClick);
            rootClass.ui.mcPopup.onClose();
        }

        private function bMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.fx.visible = true;
        }

        private function bMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.fx.visible = false;
        }

        private function setCT(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = _arg_1.transform.colorTransform;
            _local_3.color = _arg_2;
            _arg_1.transform.colorTransform = _local_3;
        }

        private function iMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.parent.mHi.visible = true;
            _local_2.parent.mHi.y = _local_2.y;
        }

        private function iMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.parent.mHi.visible = false;
        }

        internal function frame1():*
        {
            open();
        }

        internal function frame7():*
        {
            stop();
        }

        internal function frame12():*
        {
        }

        internal function frame16():*
        {
            fClose();
        }


    }
}//package 

