// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.listOptionsItem.listOptionsItemTxt

package liteAssets.listOptionsItem
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import liteAssets.draw.charPage;
    import fl.controls.*;
    import flash.events.*;
    import flash.text.*;

    public class listOptionsItemTxt extends MovieClip 
    {

        public var txtName:TextField;
        public var txtSearch:TextField;
        public var btnActive:SimpleButton;
        public var sDesc:String;
        public var rootClass:MovieClip;

        public function listOptionsItemTxt(_arg_1:MovieClip, _arg_2:String)
        {
            rootClass = _arg_1;
            this.sDesc = _arg_2;
            btnActive.addEventListener(MouseEvent.CLICK, onActive, false, 0, true);
            txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true);
        }

        public function onActive(_arg_1:MouseEvent):void
        {
            if (txtSearch.text.length < 1)
            {
                return;
            };
            var _local_2:charPage = new charPage(rootClass, txtSearch.text);
            rootClass.ui.addChild(_local_2);
        }

        public function onKeyPress(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }


    }
}//package liteAssets.listOptionsItem

