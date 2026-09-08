// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.Stats

package com.wildtangent
{
    import flash.events.Event;

    public final class Stats extends Core 
    {


        public function getStats(obj:Object):void
        {
            if (vexReady)
            {
                if (!myVex.hasEventListener(Event.COMPLETE))
                {
                    myVex.addEventListener(Event.COMPLETE, function (_arg_1:Event):void
                    {
                        dispatchEvent(new StatsEvent(StatsEvent.STATS_COMPLETE, _arg_1.target.statsData));
                    });
                };
                myVex.getStats(obj);
            }
            else
            {
                storeMethod(getStats, obj);
            };
        }

        public function submit(_arg_1:Object):Boolean
        {
            if (vexReady)
            {
                return (myVex.submitStats(_arg_1));
            };
            storeMethod(submit, _arg_1);
            return (true);
        }

        public function sendExistingParameters():void
        {
            if (_error != null)
            {
                myVex.error = _error;
            };
        }

        public function set error(_arg_1:Function):void
        {
            if (vexReady)
            {
                myVex.error = _arg_1;
            }
            else
            {
                _error = _arg_1;
            };
        }


    }
}//package com.wildtangent

