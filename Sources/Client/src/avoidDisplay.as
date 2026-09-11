// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//avoidDisplay

package 
{
    import flash.display.MovieClip;

    public dynamic class avoidDisplay extends MovieClip 
    {

        public var t:MovieClip;

        public function avoidDisplay()
        {
            addFrameScript(19, this.frame20);
        }

        internal function frame20():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }


    }
}//package 

