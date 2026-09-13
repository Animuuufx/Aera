// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.StatsEvent

package com.wildtangent
{
    import flash.events.Event;

    public class StatsEvent extends Event 
    {

        public static const STATS_COMPLETE:String = "statsLoaded";

        public var StatsData:Object;

        public function StatsEvent(_arg_1:String, _arg_2:Object)
        {
            super(_arg_1);
            StatsData = _arg_2;
        }

    }
}//package com.wildtangent

