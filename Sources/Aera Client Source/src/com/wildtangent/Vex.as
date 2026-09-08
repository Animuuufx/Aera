// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.Vex

package com.wildtangent
{
    public final class Vex extends Core 
    {


        public function redemptionComplete(_arg_1:Object):Boolean
        {
            return (myVex.redemptionComplete(_arg_1));
        }

        public function sendExistingParameters():void
        {
            if (_redeemCode != null)
            {
                myVex.redeemCode = _redeemCode;
            };
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

        public function set redeemCode(_arg_1:Function):void
        {
            if (vexReady)
            {
                myVex.redeemCode = _arg_1;
            }
            else
            {
                _redeemCode = _arg_1;
            };
        }


    }
}//package com.wildtangent

