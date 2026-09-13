// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//uProto

package 
{
    import flash.display.MovieClip;

    public dynamic class uProto extends MovieClip 
    {

        public var t1:MovieClip;

        public function uProto()
        {
            addFrameScript(0, frame1, 100, frame101);
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame101():*
        {
            try
            {
                if (parent != null)
                {
                    parent.removeChild(this);
                };
            }
            catch(e:Error)
            {
            };
            stop();
        }


    }
}//package 

