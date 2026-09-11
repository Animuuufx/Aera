// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.Symbol25_320

package spider_fla
{
    import flash.display.MovieClip;

    public dynamic class Symbol25_320 extends MovieClip 
    {

        public var buttons:Array;

        public function Symbol25_320()
        {
            addFrameScript(0, frame1);
        }

        internal function frame1():*
        {
            buttons = new Array({
                "txt":"Temp Inventory",
                "fct":"toggleTempInventory"
            }, {
                "txt":"Quests",
                "fct":"rootClass.world.toggleQuestLog"
            }, {"txt":"Quests"});
        }


    }
}//package spider_fla

