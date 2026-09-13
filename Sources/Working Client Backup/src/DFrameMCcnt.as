// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//DFrameMCcnt

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    public dynamic class DFrameMCcnt extends MovieClip 
    {

        public var strQ:TextField;
        public var icon:MovieClip;
        public var fadedAC:MovieClip;
        public var fx1:MovieClip;
        public var strRate:TextField;
        public var bg:MovieClip;
        public var strName:TextField;
        public var strType:TextField;

        public function DFrameMCcnt()
        {
            addFrameScript(0, frame1);
        }

        internal function frame1():*
        {
            if (strRate.text == "vendor trash")
            {
                strRate.visible = false;
            };
        }


    }
}//package 

