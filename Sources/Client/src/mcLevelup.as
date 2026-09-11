// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mcLevelup

package 
{
    import flash.display.MovieClip;

    public dynamic class mcLevelup extends MovieClip 
    {

        public var cnt:MovieClip;

        public function mcLevelup()
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

