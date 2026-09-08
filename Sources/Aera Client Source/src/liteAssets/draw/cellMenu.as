// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.cellMenu

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.filters.ColorMatrixFilter;
    import fl.motion.AdjustColor;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.ui.*;

    public class cellMenu extends MovieClip 
    {

        public var inner_menu:MovieClip;
        internal var rootClass:MovieClip;
        private var inactive:ColorMatrixFilter;
        private var isOpen:Boolean = false;
        private var possiblePads:Array = ["Spawn", "Center", "Left", "Right", "Top", "Bottom", "Up", "Down"];

        public function cellMenu(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            var _local_2:AdjustColor = new AdjustColor();
            _local_2.saturation = -100;
            _local_2.brightness = -100;
            _local_2.contrast = 0;
            _local_2.hue = 0;
            inactive = new ColorMatrixFilter(_local_2.CalculateFinalFlatArray());
            this.name = "cellMenu";
            this.visible = true;
            onSetup();
        }

        public function onSetup():void
        {
            rootClass.ui.mcInterface.addChild(this);
            rootClass.ui.mcInterface.setChildIndex(rootClass.ui.mcInterface.getChildByName("cellMenu"), 0);
            this.x = 808;
            this.y = -530;
            this.inner_menu.visible = true;
            this.inner_menu.height = 42.8;
            this.inner_menu.addEventListener(MouseEvent.ROLL_OVER, onRollOverAttached, false, 0, true);
            this.inner_menu.addEventListener(MouseEvent.ROLL_OUT, onRollOutAttached, false, 0, true);
            this.inner_menu.addEventListener(MouseEvent.CLICK, onToggleAttached, false, 0, true);
            this.inner_menu.filters = [inactive];
        }

        public function cleanup():void
        {
            this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER, onRollOverAttached);
            this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT, onRollOutAttached);
            this.inner_menu.removeEventListener(MouseEvent.CLICK, onToggleAttached);
            parent.removeChild(this);
        }

        public function isMenuOpen():Boolean
        {
            return (isOpen);
        }

        public function onRollOverAttached(_arg_1:MouseEvent):void
        {
            if (isOpen)
            {
                return;
            };
            this.y = -521;
        }

        public function onRollOutAttached(_arg_1:MouseEvent):void
        {
            if (isOpen)
            {
                return;
            };
            this.y = -530;
        }

        public function toggle():void
        {
            this.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        public function onToggleAttached(_arg_1:MouseEvent):void
        {
            isOpen = (!(isOpen));
            if (!isOpen)
            {
                this.inner_menu.filters = [inactive];
                while (this.numChildren > 1)
                {
                    this.removeChildAt(1);
                };
                this.inner_menu.height = 42.8;
                this.inner_menu.y = 0;
                this.y = -530;
            }
            else
            {
                this.inner_menu.filters = [];
                reDraw();
            };
        }

        public function onScroll(_arg_1:MouseEvent):void
        {
            _arg_1.delta = (_arg_1.delta * 3);
            this.y = (this.y + _arg_1.delta);
            if (this.y < ((-521 + (-1 * this.height)) + 50))
            {
                this.y = ((-521 + (-1 * this.height)) + 50);
            };
            if (this.y >= -521)
            {
                this.y = -521;
            };
        }

        public function reDraw(_arg_1:String=""):void
        {
            var _local_3:*;
            var _local_4:*;
            while (this.numChildren > 1)
            {
                this.removeChildAt(1);
            };
            var _local_2:int;
            for each (_local_3 in ((_arg_1 != "") ? possiblePads : rootClass.world.map.currentScene.labels))
            {
                if (!((_arg_1 == "") && ((_local_3.name == "Wait") || (_local_3.name == "Blank"))))
                {
                    _local_4 = new cEntry(rootClass, ((_arg_1 != "") ? _local_3 : _local_3.name), _arg_1);
                    _local_4.x = 1.5;
                    _local_4.y = ((24 + (21.5 * _local_2)) - 0.5);
                    this.addChild(_local_4);
                    _local_2++;
                };
            };
            this.inner_menu.y = 0;
            this.inner_menu.height = ((_local_2 == 0) ? 47.5 : (47.5 + (21.5 * (_local_2 - 1))));
            this.y = -521;
        }


    }
}//package liteAssets.draw

