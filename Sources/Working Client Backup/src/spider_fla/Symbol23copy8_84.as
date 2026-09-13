// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.Symbol23copy8_84

package spider_fla
{
    import flash.display.MovieClip;

    public dynamic class Symbol23copy8_84 extends MovieClip 
    {

        public var buttons:Array;

        public function Symbol23copy8_84()
        {
            addFrameScript(0, frame1);
        }

        internal function frame1():*
        {
            buttons = new Array({
                "txt":"Stats & Class",
                "fct":"rootClass.toggleCharpanel"
            }, {
                "txt":"Reputations",
                "fct":"rootClass.showFactionInterface"
            }, {
                "txt":"Friends",
                "fct":"rootClass.world.showFriendsList"
            }, {
                "txt":"Guild",
                "fct":"rootClass.world.showGuildList"
            }, {
                "txt":"Character Page",
                "fct":"charPage"
            }, {"txt":"Your Hero"});
        }


    }
}//package spider_fla

