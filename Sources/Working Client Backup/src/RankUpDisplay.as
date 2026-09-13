// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//RankUpDisplay

package 
{
    import flash.display.MovieClip;

    public dynamic class RankUpDisplay extends MovieClip 
    {

        public var t:MovieClip;

        public function RankUpDisplay()
        {
            addFrameScript(37, this.frame38);
        }

        internal function frame38():*
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

