// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mcQuestpopup

package 
{
    import flash.display.MovieClip;

    public dynamic class mcQuestpopup extends MovieClip 
    {

        public var fx2:MovieClip;
        public var cnt:MovieClip;

        public function mcQuestpopup()
        {
            addFrameScript(124, frame125);
        }

        internal function frame125():*
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

