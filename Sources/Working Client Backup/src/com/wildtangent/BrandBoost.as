// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//com.wildtangent.BrandBoost

package com.wildtangent
{
    public final class BrandBoost extends Core 
    {


        public function launch(_arg_1:Object):void
        {
            if (vexReady)
            {
                if (_arg_1.promoName != null)
                {
                    myVex.launchBrandBoost(_arg_1);
                }
                else
                {
                    throw (new Error("Please provide a valid promoName when calling BrandBoost.launch"));
                };
            }
            else
            {
                storeMethod(launch, _arg_1);
            };
        }

        public function getPromo(_arg_1:Object):Boolean
        {
            var _local_2:Boolean;
            if (vexReady)
            {
                _local_2 = myVex.addPromo(_arg_1);
                if (_local_2)
                {
                    myVex.initialize();
                };
                return (_local_2);
            };
            storeMethod(getPromo, _arg_1);
            return (true);
        }

        public function resumeAfterLogin(_arg_1:Object):void
        {
            myVex.userId = _arg_1.userId;
        }

        public function sendExistingParameters():void
        {
            if (_closed != null)
            {
                myVex.closed = _closed;
            };
            if (_error != null)
            {
                myVex.error = _error;
            };
            if (_handlePromo != null)
            {
                myVex.handlePromo = _handlePromo;
            };
            if (_requireLogin != null)
            {
                myVex.requireLogin = _requireLogin;
            };
        }

        public function set closed(_arg_1:Function):void
        {
            if (vexReady)
            {
                myVex.closed = _arg_1;
            }
            else
            {
                _closed = _arg_1;
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

        public function set handlePromo(_arg_1:Function):void
        {
            if (vexReady)
            {
                myVex.handlePromo = _arg_1;
            }
            else
            {
                _handlePromo = _arg_1;
            };
        }

        public function set requireLogin(_arg_1:Function):void
        {
            if (vexReady)
            {
                myVex.requireLogin = _arg_1;
            }
            else
            {
                _requireLogin = _arg_1;
            };
        }


    }
}//package com.wildtangent

