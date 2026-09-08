// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.blackList

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import fl.controls.List;
    import flash.events.MouseEvent;
    import fl.data.DataProvider;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.*;

    public class blackList extends MovieClip 
    {

        public var btnClear:SimpleButton;
        public var btnDel:SimpleButton;
        public var btnClose:SimpleButton;
        public var frame:MovieClip;
        public var listBlack:List;
        internal var rootClass:MovieClip;

        public function blackList(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            this.frame.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            this.frame.addEventListener(MouseEvent.MOUSE_UP, onMRelease, false, 0, true);
            this.btnDel.addEventListener(MouseEvent.CLICK, onBtnRemoveBlacklist, false, 0, true);
            this.btnClear.addEventListener(MouseEvent.CLICK, onBtnClearBlacklist, false, 0, true);
            this.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            if (rootClass.litePreference.data.blackList)
            {
                this.listBlack.dataProvider = new DataProvider(rootClass.litePreference.data.blackList.sortOn("label"));
            };
        }

        private function onClose(_arg_1:MouseEvent):void
        {
            this.parent.removeChild(this);
        }

        private function onBtnRemoveBlacklist(_arg_1:MouseEvent):void
        {
            if (this.listBlack.selectedIndex != -1)
            {
                this.listBlack.removeItemAt(this.listBlack.selectedIndex);
                this.listBlack.selectedIndex = -1;
            };
            rootClass.litePreference.data.blackList = this.listBlack.dataProvider.toArray();
            rootClass.litePreference.flush();
        }

        private function onBtnClearBlacklist(_arg_1:MouseEvent):void
        {
            if (!this.listBlack)
            {
                return;
            };
            this.listBlack.removeAll();
            rootClass.litePreference.data.blackList = this.listBlack.dataProvider.toArray();
            rootClass.litePreference.flush();
        }

        private function onDrag(_arg_1:MouseEvent):void
        {
            this.startDrag();
        }

        private function onMRelease(_arg_1:MouseEvent):void
        {
            this.stopDrag();
        }


    }
}//package liteAssets.draw

