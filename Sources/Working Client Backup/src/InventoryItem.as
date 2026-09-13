// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//InventoryItem

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class InventoryItem extends MovieClip 
    {

        public var icon:MovieClip;
        public var strLevel:TextField;
        public var bg:MovieClip;
        public var strName:TextField;
        public var strIndex:TextField;
        public var btnSelect:SimpleButton;
        public var isEq:Boolean;
        public var isSel:Boolean;

        public function InventoryItem()
        {
            addFrameScript(0, frame1);
        }

        public function onItemSelect(_arg_1:Event):void
        {
            MovieClip(parent).selectItem(_arg_1.target.parent.intIndex);
        }

        public function select():void
        {
            bg.b.visible = true;
            isSel = true;
        }

        public function equip():void
        {
            isEq = true;
            bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 30, 50, 0);
            bg.b.visible = false;
            bg.c.visible = true;
        }

        public function unequip():void
        {
            isEq = false;
            bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
            bg.c.visible = false;
            if (!isSel)
            {
                bg.b.visible = false;
            };
        }

        public function reset():void
        {
            if (!isEq)
            {
                bg.b.visible = false;
            };
            isSel = false;
        }

        public function clearText():void
        {
            strName.text = "";
            strLevel.text = "";
            icon.visible = false;
        }

        internal function frame1():*
        {
            isEq = false;
            isSel = false;
            btnSelect.addEventListener(MouseEvent.CLICK, onItemSelect);
            stop();
        }


    }
}//package 

