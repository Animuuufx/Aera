// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//critDisplay

package 
{
    import flash.display.MovieClip;

    public dynamic class critDisplay extends MovieClip 
    {

        public var t:MovieClip;

        public function critDisplay()
        {
            addFrameScript(24, this.frame25);
        }

        internal function frame25():*
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

