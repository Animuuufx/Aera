// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameHousePreview

package 
{
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.net.*;
    import flash.text.*;

    public class LPFFrameHousePreview extends LPFFrameItemPreview 
    {

        public function LPFFrameHousePreview():void
        {
            mcCoin.visible = false;
            mcUpgrade.visible = false;
            btnTry.visible = false;
            btnFGender.visible = false;
            btnMGender.visible = false;
            btnWiki.visible = false;
            btnWiki.addEventListener(MouseEvent.CLICK, super.onBtnWiki, false, 0, true);
            btnWiki.addEventListener(MouseEvent.MOUSE_OVER, super.onWikiTTOver, false, 0, true);
            btnWiki.addEventListener(MouseEvent.MOUSE_OUT, super.onWikiTTOut, false, 0, true);
            btnDelete.addEventListener(MouseEvent.CLICK, super.onBtnDeleteClick, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OVER, super.onDeleteTTOver, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OUT, super.onDeleteTTOut, false, 0, true);
            mcCoin.addEventListener(MouseEvent.MOUSE_OVER, super.onCoinTTOver, false, 0, true);
            mcCoin.addEventListener(MouseEvent.MOUSE_OUT, super.onCoinTTOut, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER, super.onUpgradeTTOver, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT, super.onUpgradeTTOut, false, 0, true);
            addEventListener(Event.ENTER_FRAME, super.onEF, false, 0, true);
        }

        override public function fClose():void
        {
            btnWiki.removeEventListener(MouseEvent.CLICK, super.onBtnWiki);
            btnWiki.removeEventListener(MouseEvent.MOUSE_OVER, super.onWikiTTOver);
            btnWiki.removeEventListener(MouseEvent.MOUSE_OUT, super.onWikiTTOut);
            btnDelete.removeEventListener(MouseEvent.CLICK, super.onBtnDeleteClick);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OVER, super.onDeleteTTOver);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OUT, super.onDeleteTTOut);
            mcCoin.removeEventListener(MouseEvent.MOUSE_OVER, super.onCoinTTOver);
            mcCoin.removeEventListener(MouseEvent.MOUSE_OUT, super.onCoinTTOut);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER, super.onUpgradeTTOver);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT, super.onUpgradeTTOut);
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        override protected function fDraw():void
        {
            var _local_1:Object;
            tInfo.visible = false;
            btnDelete.visible = false;
            _local_1 = iSel;
            if (_local_1 != null)
            {
                btnDelete.visible = true;
                mcUpgrade.visible = false;
                mcCoin.visible = false;
                if (_local_1.bUpg == 1)
                {
                    mcUpgrade.visible = true;
                };
                if (_local_1.bCoins == 1)
                {
                    mcUpgrade.visible = false;
                    mcCoin.visible = true;
                };
                loadPreview(_local_1);
            }
            else
            {
                tInfo.htmlText = "Please select an item to preview.";
                while (mcPreview.numChildren > 0)
                {
                    mcPreview.removeChildAt(0);
                };
                super.clearPreview();
            };
            btnDelete.visible = true;
            if (getLayout().sMode.toLowerCase().indexOf("shop") > -1)
            {
                btnDelete.visible = false;
            };
            if (_local_1 != null)
            {
                btnWiki.y = btnMGender.y;
                if (!btnDelete.visible)
                {
                    btnWiki.y = btnTry.y;
                };
                btnWiki.visible = true;
            };
        }

        override protected function loadPreview(_arg_1:Object):void
        {
            if (curItem != _arg_1)
            {
                curItem = _arg_1;
                switch (_arg_1.sType)
                {
                    case "House":
                        super.loadHouse(_arg_1.sFile);
                        return;
                    case "Wall Item":
                    case "Floor Item":
                        super.loadHouseItem(_arg_1.sFile, _arg_1.sLink);
                        return;
                    default:
                        super.clearPreview();
                };
            };
        }


    }
}//package 

