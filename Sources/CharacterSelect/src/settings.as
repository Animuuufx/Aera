// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//settings

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    public class settings extends MovieClip 
    {

        public var txtQuality:TextField;
        public var tl3:MovieClip;
        public var bl1:MovieClip;
        public var btnLeft:SimpleButton;
        public var btnClose:SimpleButton;
        public var bg:MovieClip;
        public var tr1:MovieClip;
        public var btnRight:SimpleButton;
        public var tr2:MovieClip;
        public var tl1:MovieClip;
        public var tr3:MovieClip;
        public var br1:MovieClip;
        public var tl2:MovieClip;
        private var m:MovieClip;
        private var arrQuality:Array = ["AUTO", "LOW", "MEDIUM", "HIGH"];
        private var pos:int = 1;

        public function settings(_arg_1:MovieClip)
        {
            m = _arg_1;
            visible = false;
            txtQuality.text = "HIGH";
            btnLeft.addEventListener(MouseEvent.CLICK, onBtnLeft, false, 0, true);
            btnRight.addEventListener(MouseEvent.CLICK, onBtnRight, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
        }

        public function onBtnLeft(_arg_1:MouseEvent):void
        {
            pos--;
            if (pos < 0)
            {
                pos = (arrQuality.length - 1);
            };
            txtQuality.text = arrQuality[pos];
            m.stage.quality = arrQuality[pos];
        }

        public function onBtnRight(_arg_1:MouseEvent):void
        {
            pos++;
            if (pos > (arrQuality.length - 1))
            {
                pos = 0;
            };
            txtQuality.text = arrQuality[pos];
            m.stage.quality = arrQuality[pos];
        }

        public function onBtnClose(_arg_1:MouseEvent):void
        {
            m.utl.close(2);
        }


    }
}//package 

