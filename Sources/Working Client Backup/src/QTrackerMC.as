// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//QTrackerMC

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.*;

    public class QTrackerMC extends MovieClip 
    {

        public var bMask:MovieClip;
        public var bg:MovieClip;
        public var scr:MovieClip;
        public var close:SimpleButton;
        public var txtDetail:TextField;
        public var rootClass:MovieClip;
        internal var mDown:Boolean = false;
        internal var mbY:*;
        internal var mhY:*;
        internal var drag:Object = new Object();

        public function QTrackerMC():void
        {
            addFrameScript(0, frame1);
            visible = false;
        }

        private function initOpen():void
        {
            rootClass = MovieClip(this.stage.getChildAt(0));
            scr.hit.alpha = 0;
            txtDetail.autoSize = "left";
            close.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMoveClick, false, 0, true);
        }

        private function onCloseClick(_arg_1:MouseEvent):void
        {
            visible = false;
        }

        private function onRollOver(_arg_1:MouseEvent):void
        {
            bg.visible = true;
            scr.visible = (txtDetail.height > scr.height);
            close.visible = true;
        }

        private function onRollOut(_arg_1:MouseEvent):void
        {
            bg.visible = false;
            scr.visible = false;
            close.visible = false;
        }

        public function updateQuest():void
        {
            var _local_2:*;
            var _local_4:*;
            var _local_5:String;
            var _local_6:int;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            txtDetail.htmlText = "";
            var _local_1:int;
            for (_local_2 in rootClass.world.questTree)
            {
                _local_4 = rootClass.world.questTree[_local_2];
                if (_local_4.status != null)
                {
                    _local_1++;
                    txtDetail.htmlText = (txtDetail.htmlText + (("<font color='#00CC00'><b>" + _local_4.sName) + "</b></font>"));
                    if (((!(_local_4.turnin == null)) && (_local_4.turnin.length > 0)))
                    {
                        _local_5 = "";
                        _local_6 = 0;
                        while (_local_6 < _local_4.turnin.length)
                        {
                            _local_7 = rootClass.world.invTree[_local_4.turnin[_local_6].ItemID];
                            _local_8 = _local_7.sName;
                            _local_9 = int(_local_4.turnin[_local_6].iQty);
                            if (_local_6 > 0)
                            {
                                _local_5 = (_local_5 + ",<br>");
                            };
                            _local_5 = (_local_5 + ((((("    " + _local_8) + " ") + _local_7.iQty) + "/") + _local_9));
                            _local_6++;
                        };
                        txtDetail.htmlText = (txtDetail.htmlText + _local_5);
                    };
                };
            };
            if (_local_1 == 0)
            {
                txtDetail.htmlText = "You are not on any quest!";
            };
            close.x = ((txtDetail.x + txtDetail.textWidth) + 10);
            bg.width = (close.x + 20);
            var _local_3:* = ((txtDetail.y + txtDetail.textHeight) + 10);
            if (_local_3 > 108)
            {
                _local_3 = 108;
            };
            bg.height = _local_3;
            if (txtDetail.height > scr.height)
            {
                scr.visible = true;
                scr.x = (close.x + 5);
                scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
            }
            else
            {
                scr.visible = false;
            };
        }

        private function scrDown(_arg_1:MouseEvent):*
        {
            mDown = true;
            mbY = int(mouseY);
            mhY = int(MovieClip(_arg_1.currentTarget.parent).h.y);
            stage.addEventListener(MouseEvent.MOUSE_UP, scrUp, false, 0, true);
            scr.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
        }

        private function scrUp(_arg_1:MouseEvent):*
        {
            mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, scrUp);
            scr.h.addEventListener(Event.ENTER_FRAME, hEF);
        }

        private function hEF(_arg_1:Event):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            if (mDown)
            {
                scr.h.y = (mhY + (int(mouseY) - mbY));
                if ((scr.h.y + scr.h.height) > scr.b.height)
                {
                    scr.h.y = int((scr.b.height - scr.h.height));
                };
                if (scr.h.y < 0)
                {
                    scr.h.y = 0;
                };
                _local_2 = (-(scr.h.y) / (scr.b.height - scr.h.height));
                _local_3 = (txtDetail.height - scr.b.height);
                _local_4 = (int((_local_2 * _local_3)) + 22);
                txtDetail.y = _local_4;
            };
        }

        public function toggle():void
        {
            if (rootClass.litePreference.data.bDisQTracker)
            {
                visible = false;
                return;
            };
            visible = (!(visible));
            if (visible)
            {
                updateQuest();
            };
        }

        public function onMoveClick(_arg_1:MouseEvent):void
        {
            if (((!(_arg_1.target == close)) && (!(_arg_1.target == scr.hit))))
            {
                drag.ox = this.x;
                drag.oy = this.y;
                drag.mox = stage.mouseX;
                drag.moy = stage.mouseY;
                stage.addEventListener(MouseEvent.MOUSE_UP, onMoveRelease, false, 0, true);
                this.addEventListener(Event.ENTER_FRAME, onMoveEnterFrame, false, 0, true);
            };
        }

        public function onMoveRelease(_arg_1:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMoveRelease);
            this.removeEventListener(Event.ENTER_FRAME, onMoveEnterFrame);
        }

        public function onMoveEnterFrame(_arg_1:Event):*
        {
            this.x = (drag.ox + (stage.mouseX - drag.mox));
            if (this.x < 0)
            {
                this.x = 0;
            };
            if ((this.x + bg.width) > 960)
            {
                this.x = (960 - bg.width);
            };
            this.y = (drag.oy + (stage.mouseY - drag.moy));
            if (this.y < 0)
            {
                this.y = 0;
            };
            if ((this.y + bg.height) > 500)
            {
                this.y = (500 - bg.height);
            };
        }

        internal function frame1():*
        {
            initOpen();
            stop();
        }


    }
}//package 

