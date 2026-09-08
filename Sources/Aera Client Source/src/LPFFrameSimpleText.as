// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameSimpleText

package 
{
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFFrameSimpleText extends LPFFrame 
    {

        public var ti:TextField;
        private var rootClass:MovieClip;

        public function LPFFrameSimpleText():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            fData = _arg_1.fData;
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            };
            positionBy(_arg_1.r);
            fDraw();
            positionBy(_arg_1.r);
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            fData = {};
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        private function fDraw(_arg_1:Boolean=true):void
        {
            if (_arg_1)
            {
                ti.width = w;
                ti.autoSize = "left";
                ti.wordWrap = true;
                ti.htmlText = fData.msg;
            }
            else
            {
                visible = false;
            };
        }

        override public function notify(_arg_1:Object):void
        {
            if ((("fData" in _arg_1) && ("msg" in _arg_1.fData)))
            {
                fData = _arg_1.fData;
            };
            if (("r" in _arg_1))
            {
                positionBy(_arg_1.r);
            };
            if (_arg_1.eventType == "listItemASel")
            {
                fDraw((!(_arg_1.fData.iSel == null)));
            };
        }


    }
}//package 

