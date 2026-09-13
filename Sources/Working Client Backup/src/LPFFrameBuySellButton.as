// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameBuySellButton

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameBuySellButton extends LPFFrame 
    {

        public var btn:MovieClip;
        public var ti:TextField;
        private var rootClass:MovieClip;
        protected var eventType:String = "";

        public function LPFFrameBuySellButton():void
        {
            ti.mouseEnabled = false;
            btn.addEventListener(MouseEvent.CLICK, onBtnClick, false, 0, true);
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            positionBy(_arg_1.r);
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            if (("eventType" in _arg_1))
            {
                eventType = _arg_1.eventType;
            };
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            };
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            btn.removeEventListener(MouseEvent.CLICK, onBtnClick);
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
                ti.text = fData.sText;
                visible = true;
            }
            else
            {
                ti.text = "";
                visible = false;
            };
        }

        override public function notify(_arg_1:Object):void
        {
            if (("buttonNewEventType" in _arg_1))
            {
                eventType = _arg_1.buttonNewEventType;
            };
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            };
            fDraw();
        }

        private function onBtnClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            update({
                "eventType":eventType,
                "sModeBroadcast":fData.sModeBroadcast
            });
        }


    }
}//package 

