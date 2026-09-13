// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.invSearch

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.KeyboardEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.*;

    public class invSearch extends MovieClip 
    {

        public var txtSearch:TextField;
        internal var rootClass:MovieClip;

        public function invSearch(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            this.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onInvSearch, false, 0, true);
        }

        public function onFilter(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
        {
            return (_arg_1.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) > -1);
        }

        public function apply():void
        {
            if (rootClass.ui.mcPopup.currentLabel == "Inventory")
            {
                rootClass.world.myAvatar.filtered_list = ((this.txtSearch.text != "") ? rootClass.world.myAvatar.items.filter(onFilter) : null);
                MovieClip(rootClass.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshInv"});
            }
            else
            {
                if (rootClass.ui.mcPopup.currentLabel == "HouseInventory")
                {
                    rootClass.world.myAvatar.filtered_list = ((this.txtSearch.text != "") ? rootClass.world.myAvatar.houseitems.filter(onFilter) : null);
                    MovieClip(rootClass.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshInv"});
                }
                else
                {
                    if (rootClass.ui.mcPopup.currentLabel == "Bank")
                    {
                        rootClass.world.myAvatar.filtered_list = ((this.txtSearch.text != "") ? rootClass.world.myAvatar.items.filter(onFilter) : null);
                        MovieClip(rootClass.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshInv"});
                    }
                    else
                    {
                        if (rootClass.ui.mcPopup.currentLabel == "HouseBank")
                        {
                            rootClass.world.myAvatar.filtered_list = ((this.txtSearch.text != "") ? rootClass.world.myAvatar.houseitems.filter(onFilter) : null);
                            MovieClip(rootClass.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshInv"});
                        };
                    };
                };
            };
        }

        internal function onInvSearch(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.charCode == 13)
            {
                apply();
            };
        }

        public function reset():void
        {
            rootClass.world.myAvatar.filtered_list = null;
        }


    }
}//package liteAssets.draw

