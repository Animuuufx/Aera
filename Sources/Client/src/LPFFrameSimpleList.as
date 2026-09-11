// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameSimpleList

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.Shape;
    import liteAssets.draw.mergeScroll;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.*;

    public class LPFFrameSimpleList extends LPFFrame 
    {

        public var bg:MovieClip;
        public var iList:MovieClip;
        public var ti:TextField;
        private var rootClass:MovieClip;
        private var r:Object;
        internal var maskMC:Shape;
        internal var scrollMC:mergeScroll;
        internal var mDown:Boolean = false;
        internal var hRun:int = 0;
        internal var dRun:int = 0;
        internal var mbY:int = 0;
        internal var mhY:int = 0;
        internal var mbD:int = 0;

        public function LPFFrameSimpleList():void
        {
            x = 0;
            y = 0;
            fData = null;
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            };
            r = _arg_1.r;
            w = int(r.w);
            ti.autoSize = "left";
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            if ((("msg" in fData) && (fData.msg.length > 0)))
            {
                ti.htmlText = fData.msg;
            };
            fDraw();
            positionBy(r);
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            fData = null;
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        private function fDraw():void
        {
            var _local_1:LPFElementSimpleItem;
            var _local_2:DisplayObject;
            var _local_3:DisplayObject;
            var _local_4:Array;
            var _local_5:Object;
            var _local_6:int;
            while (iList.numChildren > 0)
            {
                iList.removeChildAt(0);
            };
            if (scrollMC)
            {
                scrollMC.visible = false;
                scrollMC.h.y = 0;
                iList.y = 0;
                bg.height = (iList.height + 1);
                ti.y = (bg.height + 2);
                scrollMC.hit.removeEventListener(MouseEvent.MOUSE_DOWN, merge_scrDown);
                scrollMC.h.removeEventListener(Event.ENTER_FRAME, merge_hEF);
                iList.removeEventListener(Event.ENTER_FRAME, merge_dEF);
                removeEventListener(MouseEvent.MOUSE_WHEEL, onMergeBoxScroll);
                removeChild(scrollMC);
                removeChild(maskMC);
                scrollMC = null;
                maskMC = null;
                iList.mask = null;
            };
            if (((!(fData == null)) && (!(fData.turnin == null))))
            {
                _local_4 = fData.turnin;
                _local_6 = 0;
                while (_local_6 < _local_4.length)
                {
                    _local_5 = _local_4[_local_6];
                    _local_1 = new LPFElementSimpleItem();
                    _local_2 = iList.addChild(_local_1);
                    _local_1.fOpen({"fData":_local_5});
                    if (_local_6 > 0)
                    {
                        _local_3 = iList.getChildAt((_local_6 - 1));
                        _local_2.y = (_local_3.y + _local_3.height);
                    };
                    _local_2.x = int(((w / 2) - (_local_2.width / 2)));
                    _local_6++;
                };
                bg.height = (int((iList.height + (iList.y * 2))) + 1);
                bg.width = int(w);
                ti.width = int((w - 2));
                if (ti.htmlText.length > 0)
                {
                    ti.y = (bg.height + 2);
                    ti.visible = true;
                }
                else
                {
                    ti.visible = false;
                };
                visible = true;
                if (_local_4.length >= 5)
                {
                    bg.height = 166;
                    maskMC = new Shape();
                    maskMC.graphics.beginFill(0);
                    maskMC.graphics.drawRect(0, 0, bg.width, bg.height);
                    maskMC.graphics.endFill();
                    addChild(maskMC);
                    maskMC.name = "maskMC";
                    maskMC.x = bg.x;
                    maskMC.y = bg.y;
                    iList.mask = maskMC;
                    scrollMC = new mergeScroll();
                    addChild(scrollMC);
                    scrollMC.name = "scrollMC";
                    scrollMC.x = ((bg.x + bg.width) - (scrollMC.width / 2));
                    scrollMC.y = (bg.y + 5);
                    scrollMC.height = (bg.height - 10);
                    scrollMC.h.height = (scrollMC.h.height / 2);
                    hRun = (scrollMC.b.height - scrollMC.h.height);
                    dRun = (((int((iList.height + (iList.y * 2))) + 1) - maskMC.height) + 5);
                    scrollMC.h.y = 0;
                    iList.y = 0;
                    iList.oy = iList.y;
                    scrollMC.hit.alpha = 0;
                    mDown = false;
                    scrollMC.hit.addEventListener(MouseEvent.MOUSE_DOWN, merge_scrDown, false, 0, true);
                    scrollMC.h.addEventListener(Event.ENTER_FRAME, merge_hEF, false, 0, true);
                    iList.addEventListener(Event.ENTER_FRAME, merge_dEF, false, 0, true);
                    ti.y = (bg.height + 2);
                    addEventListener(MouseEvent.MOUSE_WHEEL, onMergeBoxScroll, false, 0, true);
                };
            }
            else
            {
                visible = false;
            };
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "listItemASel")
            {
                fData = null;
                if (((!(_arg_1.fData == null)) && (!(_arg_1.fData.oSel == null))))
                {
                    fData = _arg_1.fData.oSel;
                };
                fDraw();
                positionBy(r);
            };
            if (_arg_1.eventType == "refreshItems")
            {
                fDraw();
                positionBy(r);
            };
            if (_arg_1.eventType == "updateQtyValue")
            {
                fDraw();
                positionBy(r);
            };
        }

        private function merge_scrDown(_arg_1:MouseEvent):*
        {
            mbY = int(_arg_1.currentTarget.parent.mouseY);
            mhY = int(MovieClip(_arg_1.currentTarget.parent).h.y);
            mDown = true;
            rootClass.stage.addEventListener(MouseEvent.MOUSE_UP, merge_scrUp, false, 0, true);
        }

        private function merge_scrUp(_arg_1:MouseEvent):*
        {
            mDown = false;
            rootClass.stage.removeEventListener(MouseEvent.MOUSE_UP, merge_scrUp);
        }

        private function merge_hEF(_arg_1:Event):*
        {
            var _local_2:* = undefined;
            if (mDown)
            {
                _local_2 = MovieClip(_arg_1.currentTarget.parent);
                mbD = (int(_arg_1.currentTarget.parent.mouseY) - mbY);
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

        private function merge_dEF(_arg_1:Event):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget.parent).getChildByName("scrollMC");
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

        public function onMergeBoxScroll(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = MovieClip(_arg_1.currentTarget.getChildByName("scrollMC"));
            _local_2.h.y = (_local_2.h.y + ((_arg_1.delta * -1) * 6));
            if (_local_2.h.y < 0)
            {
                _local_2.h.y = 0;
            };
            if ((_local_2.h.y + _local_2.h.height) > _local_2.b.height)
            {
                _local_2.h.y = int((_local_2.b.height - _local_2.h.height));
            };
        }


    }
}//package 

