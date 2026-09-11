// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//goldDisplay

package 
{
    import flash.display.MovieClip;

    public dynamic class goldDisplay extends MovieClip 
    {

        public var tMask:MovieClip;
        public var t:MovieClip;

        public function goldDisplay()
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

