// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFElementSimpleItem

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFElementSimpleItem extends MovieClip 
    {

        public var tQty:TextField;
        public var tName:TextField;
        private var rootClass:MovieClip;
        protected var eventType:String = "";
        protected var sMode:String;
        public var fData:Object = {};
        public var fParent:LPFFrame;

        public function LPFElementSimpleItem():void
        {
        }

        protected function update():void
        {
        }

        public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            if (("eventType" in _arg_1))
            {
                eventType = _arg_1.eventType;
            };
            rootClass = MovieClip(stage.getChildAt(0));
            fDraw();
        }

        public function fClose():void
        {
            fData = null;
            parent.removeChild(this);
        }

        private function get realQty():int
        {
            var _local_1:Number = fData.iQty;
            var _local_2:* = MovieClip(MovieClip(MovieClip(MovieClip(parent).parent).parent).parent);
            if (_local_2.iQty > 1)
            {
                _local_1 = (fData.iQty * Math.floor((_local_2.iQty / _local_2.iSel.iQty)));
            };
            return (_local_1);
        }

        protected function fDraw():void
        {
            var _local_8:String;
            tName.htmlText = fData.sName;
            tName.autoSize = TextFieldAutoSize.LEFT;
            tName.wordWrap = true;
            var _local_1:* = "#FFFFFF";
            var _local_2:* = "#FFD900";
            var _local_3:* = "#999999";
            var _local_4:* = "#666666";
            var _local_5:Object = rootClass.world.invTree[fData.ItemID];
            var _local_6:int;
            var _local_7:Boolean;
            if (_local_5 != null)
            {
                _local_6 = _local_5.iQty;
            };
            if (_local_6 >= realQty)
            {
                _local_7 = true;
            };
            if (_local_7)
            {
                _local_8 = (((("<font color='" + _local_1) + "'>") + _local_6) + "</font>");
                _local_8 = (_local_8 + (("<font color='" + _local_2) + "'>/</font>"));
                _local_8 = (_local_8 + (((("<font color='" + _local_1) + "'>") + realQty) + "</font>"));
            }
            else
            {
                _local_8 = (((("<font color='" + _local_4) + "'>") + _local_6) + "</font>");
                _local_8 = (_local_8 + (("<font color='" + _local_3) + "'>/</font>"));
                _local_8 = (_local_8 + (((("<font color='" + _local_4) + "'>") + realQty) + "</font>"));
            };
            tQty.htmlText = _local_8;
            tQty.y = ((tName.y + tName.height) - 4);
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
        }

        protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        protected function onMouseOut(_arg_1:MouseEvent):void
        {
        }


    }
}//package 

