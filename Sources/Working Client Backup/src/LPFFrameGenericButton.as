// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameGenericButton

package 
{
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameGenericButton extends LPFFrame 
    {

        public var t1:TextField;
        public var t2:TextField;
        public var btn1:SimpleButton;
        public var btn2:SimpleButton;
        private var rootClass:MovieClip;
        protected var eventType:String = "";

        public function LPFFrameGenericButton():void
        {
            t1.mouseEnabled = false;
            t2.mouseEnabled = false;
            addEventListener(MouseEvent.CLICK, onBtnClick, false, 0, true);
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            positionBy(_arg_1.r);
            sMode = "grey";
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            };
            if (("buttonNewEventType" in _arg_1))
            {
                eventType = _arg_1.buttonNewEventType;
            };
            if (("sMode" in _arg_1))
            {
                sMode = _arg_1.sMode.toLowerCase();
            };
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            removeEventListener(MouseEvent.CLICK, onBtnClick);
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        protected function fDraw():void
        {
            if (((!(fData == null)) && (!(fData.sText == ""))))
            {
                if (sMode == "red")
                {
                    t1.text = "";
                    t2.text = fData.sText;
                    btn1.visible = false;
                    btn2.visible = true;
                }
                else
                {
                    t1.text = fData.sText;
                    t2.text = "";
                    btn1.visible = true;
                    btn2.visible = false;
                };
                visible = true;
            }
            else
            {
                t1.text = "";
                t2.text = "";
                btn1.visible = false;
                btn2.visible = false;
                visible = false;
            };
        }

        override public function notify(_arg_1:Object):void
        {
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            };
            if (("buttonNewEventType" in _arg_1))
            {
                eventType = _arg_1.buttonNewEventType;
            };
            if (("sMode" in _arg_1))
            {
                sMode = _arg_1.sMode.toLowerCase();
            };
            if (("r" in _arg_1))
            {
                positionBy(_arg_1.r);
            };
            fDraw();
        }

        private function onBtnClick(_arg_1:MouseEvent):void
        {
            if (eventType != "none")
            {
                rootClass.mixer.playSound("Click");
                if (("sModeBroadcast" in fData))
                {
                    update({
                        "eventType":eventType,
                        "sModeBroadcast":fData.sModeBroadcast
                    });
                }
                else
                {
                    update({"eventType":eventType});
                };
            };
        }


    }
}//package 

