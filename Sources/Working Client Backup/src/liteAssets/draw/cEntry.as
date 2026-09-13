// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.cEntry

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class cEntry extends MovieClip 
    {

        public var txtEntry:TextField;
        public var overEntryBar:MovieClip;
        public var entryBar:MovieClip;
        private var cellName:String;
        private var sCellName:String;
        internal var rootClass:MovieClip;

        public function cEntry(_arg_1:MovieClip, _arg_2:String, _arg_3:String):void
        {
            rootClass = _arg_1;
            cellName = _arg_2;
            sCellName = _arg_3;
            this.gotoAndStop("idle");
            this.txtEntry.text = _arg_2;
            if (_arg_2 == rootClass.world.strFrame)
            {
                this.txtEntry.textColor = 12283391;
            };
            this.addEventListener(MouseEvent.ROLL_OVER, onHighlight, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OUT, onDeHighlight, false, 0, true);
            this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
        }

        internal function onWheel(_arg_1:MouseEvent):void
        {
            rootClass.cMenuUI.onScroll(_arg_1);
        }

        internal function onClick(_arg_1:MouseEvent):void
        {
            if (sCellName != "")
            {
                rootClass.world.moveToCell(sCellName, cellName);
            };
            rootClass.cMenuUI.reDraw(((sCellName != "") ? "" : cellName));
            rootClass.stage.focus = null;
        }

        internal function onHighlight(_arg_1:MouseEvent):void
        {
            this.gotoAndStop("hover");
        }

        internal function onDeHighlight(_arg_1:MouseEvent):void
        {
            this.gotoAndStop("idle");
        }


    }
}//package liteAssets.draw

