// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.worldCamera

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.display.Shape;
    import flash.events.KeyboardEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.geom.*;
    import fl.data.*;
    import flash.utils.*;
    import fl.events.*;
    import flash.filters.*;

    public class worldCamera extends MovieClip 
    {

        public var btnLeft:MovieClip;
        public var btnZoomOut:SimpleButton;
        public var txtInfo:TextField;
        public var btnUp:MovieClip;
        public var btnZoomIn:SimpleButton;
        public var btnDown:MovieClip;
        public var btnExit:SimpleButton;
        public var btnReset:SimpleButton;
        public var btnRight:MovieClip;
        internal var rootClass:MovieClip;
        internal var mcMask:DisplayObject;

        public function worldCamera(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
            rootClass.world.myAvatar.isWorldCamera = true;
            rootClass.world.bitWalk = false;
            this.btnExit.addEventListener(MouseEvent.CLICK, onExit, false, 0, true);
            this.btnZoomIn.addEventListener(MouseEvent.CLICK, onZoomIn, false, 0, true);
            this.btnZoomOut.addEventListener(MouseEvent.CLICK, onZoomOut, false, 0, true);
            this.btnUp.addEventListener(MouseEvent.CLICK, onUp, false, 0, true);
            this.btnDown.addEventListener(MouseEvent.CLICK, onDown, false, 0, true);
            this.btnLeft.addEventListener(MouseEvent.CLICK, onLeft, false, 0, true);
            this.btnRight.addEventListener(MouseEvent.CLICK, onRight, false, 0, true);
            this.btnReset.addEventListener(MouseEvent.CLICK, onReset, false, 0, true);
            var _local_2:Shape = new Shape();
            _local_2.graphics.beginFill(0);
            _local_2.graphics.drawRect(0, 0, rootClass.world.width, rootClass.world.height);
            _local_2.graphics.endFill();
            mcMask = rootClass.world.addChild(_local_2);
            mcMask.name = "worldMask";
            mcMask.x = rootClass.world.x;
            mcMask.y = rootClass.world.y;
            rootClass.world.mask = mcMask;
            rootClass.ui.visible = false;
            rootClass.world.mouseEnabled = (rootClass.world.mouseChildren = false);
            rootClass.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            rootClass.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseDrag, false, 0, true);
            rootClass.stage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
            var _local_3:* = ((rootClass.litePreference.data.keys["World Camera's Hide"] == null) ? "" : rootClass.keyDict[rootClass.litePreference.data.keys["World Camera's Hide"]]);
            this.txtInfo.text = (('"' + _local_3) + '" to show/hide camera controls!');
        }

        public function onKey(_arg_1:KeyboardEvent):void
        {
            var _local_2:Number;
            if (_arg_1.keyCode == rootClass.litePreference.data.keys["World Camera's Hide"])
            {
                _local_2 = 0;
                while (_local_2 < this.numChildren)
                {
                    this.getChildAt(_local_2).visible = (!(this.getChildAt(_local_2).visible));
                    _local_2++;
                };
            };
        }

        public function onDrag(_arg_1:MouseEvent):void
        {
            rootClass.startDrag();
        }

        public function onReleaseDrag(_arg_1:MouseEvent):void
        {
            rootClass.stopDrag();
        }

        public function dispatchExit():void
        {
            btnExit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        public function onExit(_arg_1:MouseEvent):void
        {
            rootClass.removeEventListener(KeyboardEvent.KEY_UP, onKey);
            rootClass.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
            rootClass.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseDrag);
            rootClass.x = (rootClass.y = 0);
            rootClass.scaleX = (rootClass.scaleY = 1);
            rootClass.ui.visible = true;
            rootClass.world.mouseEnabled = (rootClass.world.mouseChildren = true);
            rootClass.world.myAvatar.isWorldCamera = false;
            rootClass.world.bitWalk = true;
            rootClass.world.mask = null;
            mcMask.parent.removeChild(mcMask);
            this.parent.removeChild(this);
            rootClass.stage.focus = null;
        }

        public function onZoomIn(_arg_1:MouseEvent):void
        {
            rootClass.scaleX = (rootClass.scaleY = (rootClass.scaleX = (rootClass.scaleX + 0.5)));
            rootClass.x = (rootClass.x - 220);
            rootClass.y = (rootClass.y - 150);
        }

        public function onZoomOut(_arg_1:MouseEvent):void
        {
            rootClass.scaleX = (rootClass.scaleY = (rootClass.scaleX = (rootClass.scaleX - 0.5)));
            rootClass.x = (rootClass.x + 220);
            rootClass.y = (rootClass.y + 150);
        }

        public function onReset(_arg_1:MouseEvent):void
        {
            rootClass.x = (rootClass.y = 0);
            rootClass.scaleX = (rootClass.scaleY = 1);
        }

        public function onUp(_arg_1:MouseEvent):void
        {
            rootClass.y = (rootClass.y + 10);
        }

        public function onLeft(_arg_1:MouseEvent):void
        {
            rootClass.x = (rootClass.x + 10);
        }

        public function onRight(_arg_1:MouseEvent):void
        {
            rootClass.x = (rootClass.x - 10);
        }

        public function onDown(_arg_1:MouseEvent):void
        {
            rootClass.y = (rootClass.y - 10);
        }


    }
}//package liteAssets.draw

