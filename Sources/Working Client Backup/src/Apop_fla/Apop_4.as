// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Apop_fla.Apop_4

package Apop_fla
{
    import flash.display.MovieClip;

    public dynamic class Apop_4 extends MovieClip 
    {

        public var npc:MovieClip;

        public function Apop_4()
        {
            addFrameScript(0, this.frame1, 1, this.frame2, 9, this.frame10, 27, this.frame28, 30, this.frame31, 37, this.frame38, 45, this.frame46, 53, this.frame54, 56, this.frame57, 63, this.frame64, 71, this.frame72);
        }

        internal function frame1():*
        {
            this.npc.visible = false;
        }

        internal function frame2():*
        {
            stop();
        }

        internal function frame10():*
        {
            this.npc.visible = true;
        }

        internal function frame28():*
        {
            stop();
        }

        internal function frame31():*
        {
            this.npc.visible = true;
        }

        internal function frame38():*
        {
            gotoAndPlay("init");
        }

        internal function frame46():*
        {
            this.npc.visible = true;
        }

        internal function frame54():*
        {
            stop();
        }

        internal function frame57():*
        {
            this.npc.visible = true;
        }

        internal function frame64():*
        {
            gotoAndPlay("init");
        }

        internal function frame72():*
        {
            gotoAndStop("hold");
        }


    }
}//package Apop_fla

