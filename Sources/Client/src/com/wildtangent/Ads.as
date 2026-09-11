// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.Ads

package com.wildtangent
{
    public final class Ads extends Core 
    {


        public function show(_arg_1:Object=null):Boolean
        {
            if (vexReady)
            {
                return (myVex.showAd(_arg_1));
            };
            storeMethod(show, _arg_1);
            return (true);
        }

        public function sendExistingParameters():void
        {
            if (_adComplete != null)
            {
                myVex.adComplete = _adComplete;
            };
            if (_error != null)
            {
                myVex.error = _error;
            };
        }

        public function set complete(_arg_1:Function):void
        {
            if (vexReady)
            {
                myVex.adComplete = _arg_1;
            }
            else
            {
                _adComplete = _arg_1;
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

