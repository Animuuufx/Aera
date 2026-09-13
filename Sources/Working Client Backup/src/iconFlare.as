// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//iconFlare

package 
{
    import flash.display.MovieClip;

    public dynamic class iconFlare extends MovieClip 
    {

        public var bg:MovieClip;

        public function iconFlare()
        {
            addFrameScript(8, frame9);
        }

        internal function frame9():*
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

