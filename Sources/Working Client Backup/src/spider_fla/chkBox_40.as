// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.chkBox_40

package spider_fla
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public dynamic class chkBox_40 extends MovieClip 
    {

        public var checkmark:MovieClip;
        public var bitChecked:Boolean;

        public function chkBox_40()
        {
            addFrameScript(0, frame1);
        }

        public function onClick(_arg_1:MouseEvent):*
        {
            bitChecked = (!(bitChecked));
            checkmark.visible = bitChecked;
        }

        internal function frame1():*
        {
            checkmark.mouseEnabled = false;
            checkmark.visible = bitChecked;
            this.addEventListener(MouseEvent.CLICK, onClick);
        }


    }
}//package spider_fla

