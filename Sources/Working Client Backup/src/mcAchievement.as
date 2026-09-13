// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mcAchievement

package 
{
    import flash.display.MovieClip;

    public dynamic class mcAchievement extends MovieClip 
    {

        public var fx2:MovieClip;
        public var cnt:MovieClip;

        public function mcAchievement()
        {
            addFrameScript(122, frame123);
        }

        internal function frame123():*
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

