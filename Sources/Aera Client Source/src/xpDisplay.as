// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//xpDisplay

package 
{
    import flash.display.MovieClip;

    public dynamic class xpDisplay extends MovieClip 
    {

        public var t:MovieClip;

        public function xpDisplay()
        {
            addFrameScript(39, frame40);
        }

        internal function frame40():*
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

