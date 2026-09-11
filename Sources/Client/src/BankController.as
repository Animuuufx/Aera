// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//BankController

package 
{
    import flash.display.MovieClip;

    public class BankController 
    {

        private var bankModified:Boolean = true;
        private var rootClass:MovieClip;
        public var bankItems:Object;
        private var bankArr:Array = new Array();
        public var searchArr:Array = new Array();
        public var lastSearch:String = "";
        private var requestedTypes:Object = new Object();
        public var Count:int = 0;

        public function BankController()
        {
            rootClass = World.GameRoot;
            bankItems = new Object();
        }

        public function addItemsToBank(_arg_1:Array):void
        {
            var _local_2:Object;
            for each (_local_2 in _arg_1)
            {
                bankItems[int(_local_2.ItemID)] = _local_2;
            };
            bankModified = true;
        }

        public function addItem(_arg_1:Object):void
        {
            bankItems[_arg_1.ItemID] = _arg_1;
        }

        public function isItemInBank(_arg_1:int):Boolean
        {
            return (!(bankItems[_arg_1] == null));
        }

        public function get items():Array
        {
            return ((searchArr.length == 0) ? BankArray : SearchArray);
        }

        public function get BankArray():Array
        {
            var _local_1:Object;
            if (bankModified)
            {
                bankArr = new Array();
                for each (_local_1 in bankItems)
                {
                    bankArr.push(_local_1);
                };
                bankModified = false;
            };
            return (bankArr);
        }

        public function addRequestedTypes(_arg_1:Array):void
        {
            var _local_2:uint;
            while (_local_2 < _arg_1.length)
            {
                requestedTypes[String(_arg_1[_local_2])] = true;
                _local_2++;
            };
        }

        public function hasRequested(_arg_1:Array):Boolean
        {
            var _local_2:uint;
            while (_local_2 < _arg_1.length)
            {
                if (requestedTypes[_arg_1[_local_2]] == null)
                {
                    return (false);
                };
                _local_2++;
            };
            return (true);
        }

        public function bankToInv(_arg_1:int):Object
        {
            if (bankItems[_arg_1] == null)
            {
                return (null);
            };
            var _local_2:Object = bankItems[_arg_1];
            delete bankItems[_arg_1];
            bankModified = true;
            if (_local_2.bCoins == 0)
            {
                Count--;
            };
            var _local_3:String = lastSearch;
            resetSearch();
            search(_local_3);
            return (_local_2);
        }

        public function bankFromInv(_arg_1:int=-1):void
        {
            bankModified = true;
            var _local_2:String = lastSearch;
            resetSearch();
            search(_local_2);
        }

        public function getBankItem(_arg_1:int):Object
        {
            return (bankItems[_arg_1]);
        }

        public function resetSearch():void
        {
            lastSearch = "";
            searchArr = new Array();
        }

        public function get SearchArray():Array
        {
            return (searchArr);
        }

        public function search(_arg_1:String):void
        {
            var _local_2:Object;
            if (((!(rootClass.ui.mcPopup.currentLabel == "Bank")) && (!(rootClass.ui.mcPopup.currentLabel == "HouseBank"))))
            {
                return;
            };
            if (((!(lastSearch == _arg_1)) && (!(_arg_1 == ""))))
            {
                searchArr = new Array();
                lastSearch = _arg_1;
                for each (_local_2 in bankItems)
                {
                    if (((_local_2.sName.toLowerCase().indexOf(_arg_1) > -1) && (rootClass.bankFiltersMC.onFilter(_local_2))))
                    {
                        searchArr.push(_local_2);
                    };
                };
            };
            if (_arg_1 == "")
            {
                searchArr = new Array();
                lastSearch = "";
            };
            rootClass.bankFiltersMC.dispatch();
        }


    }
}//package 

