// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelPreview

package 
{
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFPanelPreview extends LPFPanel 
    {

        public function LPFPanelPreview():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_4:int;
            fData = _arg_1.fData;
            var _local_2:Object = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_4 = fParent.numChildren;
                if (_local_4 > 1)
                {
                    y = ((fParent.getChildAt((_local_4 - 2)).y + fParent.getChildAt((_local_4 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                };
            };
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
            if (("closeType" in _arg_1))
            {
                closeType = _arg_1.closeType;
            };
            if (("hideDir" in _arg_1))
            {
                hideDir = _arg_1.hideDir;
            };
            if (("hidePad" in _arg_1))
            {
                hidePad = _arg_1.hidePad;
            };
            if (("xBuffer" in _arg_1))
            {
                xBuffer = _arg_1.xBuffer;
            };
            var _local_3:Object = {};
            _local_3 = {};
            _local_3.frame = new LPFFrameBackdrop();
            _local_3.fData = null;
            _local_3.r = {
                "x":14,
                "y":36,
                "w":(w - 26),
                "h":204
            };
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameBackdrop();
            _local_3.fData = null;
            _local_3.r = {
                "x":14,
                "y":244,
                "w":(w - 26),
                "h":121
            };
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameItemPreview();
            _local_3.fData = null;
            _local_3.r = {
                "x":18,
                "y":40,
                "w":(w - 20),
                "h":-1
            };
            _local_3.eventTypes = ["listItemASel", "listItemBSel", "refreshItems"];
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameEnhText();
            _local_3.fData = null;
            _local_3.r = {
                "x":18,
                "y":245,
                "w":(w - 20),
                "h":-1
            };
            _local_3.eventTypes = ["listItemASel", "listItemBSel", "refreshItems"];
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameCostDisplay();
            _local_3.fData = null;
            _local_3.r = {
                "x":int((173 + (96 / 2))),
                "y":-66,
                "w":-1,
                "h":-1,
                "xPosRule":"centerOnX"
            };
            _local_3.eventTypes = ["listItemASel", "listItemBSel", "updateQtyValue"];
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameGenericButton();
            _local_3.fData = null;
            _local_3.r = {
                "x":46,
                "y":-40,
                "w":-1,
                "h":-1
            };
            _local_3.eventTypes = ["previewButton1Update"];
            addFrame(_local_3);
            _local_3 = {};
            _local_3.frame = new LPFFrameGenericButton();
            _local_3.fData = null;
            _local_3.r = {
                "x":173,
                "y":-40,
                "w":-1,
                "h":-1
            };
            _local_3.eventTypes = ["previewButton2Update"];
            addFrame(_local_3);
            if (fParent.sMode.indexOf("shop") > -1)
            {
                _local_3 = {};
                _local_3.frame = new LPFFrameQtySelector();
                _local_3.fData = null;
                _local_3.openOn = "shopBuy";
                _local_3.eventTypes = ["listItemASel"];
                _local_3.r = {
                    "x":40,
                    "y":-47.5,
                    "w":-1,
                    "h":-1
                };
                addFrame(_local_3);
            };
            drawBG();
            bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            if (!(("showDragonLeft" in _arg_1) && (_arg_1.showDragonLeft == true)))
            {
                bg.dragonLeft.visible = false;
            };
            if (!(("showDragonRight" in _arg_1) && (_arg_1.showDragonRight == true)))
            {
                bg.dragonRight.visible = false;
            };
        }


    }
}//package 

