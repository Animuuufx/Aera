// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameHouseDesc

package 
{
    import flash.net.*;
    import flash.text.*;

    public class LPFFrameHouseDesc extends LPFFrameItemPreview 
    {

        public function LPFFrameHouseDesc():void
        {
            mcPreview.visible = false;
            mcCoin.visible = false;
            mcUpgrade.visible = false;
            btnTry.visible = false;
            btnFGender.visible = false;
            btnMGender.visible = false;
            btnWiki.visible = false;
            btnDelete.visible = false;
        }

        override public function fClose():void
        {
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        override protected function fDraw():void
        {
            var _local_1:* = "";
            var _local_2:* = "";
            var _local_3:Object = iSel;
            if (_local_3 != null)
            {
                tInfo.htmlText = rootClass.getItemInfoStringB(_local_3);
                tInfo.y = 0;
                tInfo.height = 121;
            }
            else
            {
                tInfo.htmlText = "Please select an item to preview.";
            };
        }


    }
}//package 

