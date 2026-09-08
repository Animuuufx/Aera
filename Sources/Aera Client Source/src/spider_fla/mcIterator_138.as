// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcIterator_138

package spider_fla
{
    import flash.display.MovieClip;

    public dynamic class mcIterator_138 extends MovieClip 
    {

        public var cheats:MovieClip;
        public var serverStack:MovieClip;
        public var cmd:MovieClip;
        public var bg:MovieClip;
        public var bgfx:MovieClip;
        public var eventStack:MovieClip;
        public var iClass:IteratorMC;

        public function mcIterator_138()
        {
            addFrameScript(0, frame1);
        }

        internal function frame1():*
        {
            iClass = new IteratorMC();
            iClass.init(MovieClip(this.parent.parent), this, Game.objLogin);
        }


    }
}//package spider_fla

