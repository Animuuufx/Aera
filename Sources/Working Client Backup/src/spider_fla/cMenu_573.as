// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.cMenu_573

package spider_fla
{
    import flash.display.MovieClip;

    public dynamic class cMenu_573 extends MovieClip 
    {

        public var bg:MovieClip;
        public var mHi:MovieClip;
        public var iproto:cProto;

        public function cMenu_573()
        {
            addFrameScript(0, frame1, 19, frame20);
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame20():*
        {
            MovieClip(parent).gotoAndPlay("out");
            gotoAndStop("hold");
        }


    }
}//package spider_fla

