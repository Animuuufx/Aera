// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFElementListItem

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFElementListItem extends MovieClip 
    {

        protected var eventType:String = "";
        protected var sMode:String;
        public var fData:Object = {};
        public var fParent:LPFFrame;
        public var state:int = 0;

        public function LPFElementListItem():void
        {
        }

        protected function update():void
        {
            var _local_1:Object = {
                "fData":fData,
                "eventType":eventType,
                "fCaller":fParent.sName
            };
            fParent.update(_local_1);
        }

        public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            if (("eventType" in _arg_1))
            {
                eventType = _arg_1.eventType;
            };
        }

        public function fClose():void
        {
            fData = null;
            removeEventListener(MouseEvent.CLICK, onClick);
            parent.removeChild(this);
        }

        protected function fDraw():void
        {
        }

        public function subscribeTo(_arg_1:LPFFrame):void
        {
            fParent = _arg_1;
        }

        public function select():void
        {
        }

        public function deselect():void
        {
        }

        protected function onClick(_arg_1:MouseEvent):void
        {
            update();
        }

        protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        protected function onMouseOut(_arg_1:MouseEvent):void
        {
        }


    }
}//package 

