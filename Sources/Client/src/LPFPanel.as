// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanel

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import liteAssets.draw.invSearch;
    import flash.text.*;

    public class LPFPanel extends MovieClip 
    {

        public var frames:Array;
        public var w:int;
        public var h:int;
        public var xo:int;
        public var yo:int;
        public var xBuffer:int;
        public var yBuffer:int;
        public var frameID:int = 0;
        public var fParent:LPFLayout;
        public var bg:MovieClip;
        public var isOpen:Boolean = false;
        protected var fData:Object;
        protected var sMode:String;
        protected var closeType:String;
        protected var hideDir:String = "";
        protected var hidePad:int = 0;
        public var mcSearch:*;

        public function LPFPanel():void
        {
        }

        public function notify(_arg_1:Object):void
        {
            var _local_2:int;
            while (_local_2 < frames.length)
            {
                frames[_local_2].mc.notify(_arg_1);
                _local_2++;
            }
        }

        public function addFrame(_arg_1:Object):void
        {
            var _local_2:LPFFrame = (addChild(_arg_1.frame) as LPFFrame);
            _local_2.subscribeTo(this);
            frames.push({
                "mc":_local_2,
                "id":frameID++
            });
            _local_2.fOpen(_arg_1);
        }

        public function delFrame(_arg_1:LPFFrame):void
        {
            var _local_2:int;
            while (_local_2 < frames.length)
            {
                if (frames[_local_2].mc == _arg_1)
                {
                    frames[_local_2].fClose();
                    frames.splice(_local_2, 1);
                }
                _local_2++;
            }
        }

        public function subscribeTo(_arg_1:LPFLayout):void
        {
            fParent = _arg_1;
        }

        public function fOpen(_arg_1:Object):void
        {
            var _local_3:int;
            fData = _arg_1.fData;
            var _local_2:Object = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_3 = fParent.numChildren;
                if (_local_3 > 1)
                {
                    y = ((fParent.getChildAt((_local_3 - 2)).y + fParent.getChildAt((_local_3 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                }
            }
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
        }

        public function fClose():void
        {
            if (((!(bg == null)) && (!(bg.btnClose == null))))
            {
                bg.btnClose.removeEventListener(MouseEvent.CLICK, onCloseClick);
            }
            while (frames.length > 0)
            {
                frames[0].mc.fClose();
                frames.shift();
            }
            if (mcSearch)
            {
                mcSearch.reset();
            }
            mcSearch = null;
            MovieClip(fParent).delPanel(this);
        }

        public function fHide():void
        {
            isOpen = false;
            visible = false;
            switch (hideDir.toLowerCase())
            {
                case "left":
                    x = ((xo - w) - hidePad);
                    return;
                case "right":
                    x = ((xo + w) + hidePad);
                    return;
                case "top":
                    y = ((yo - h) - hidePad);
                    return;
                case "bottom":
                    y = ((yo + h) + hidePad);
                    return;
                case "":
            }
        }

        public function fShow(_arg_1:int=-1):void
        {
            isOpen = true;
            visible = true;
            if (_arg_1 > -1)
            {
                x = _arg_1;
            }
            else
            {
                x = xo;
            }
        }

        protected function drawBG(_arg_1:*=null):void
        {
            var _local_2:*;
            if (_arg_1 == null)
            {
                bg = (addChildAt(new LPFPanelBg(), 0) as MovieClip);
                bg.frame.width = w;
                bg.frame.height = h;
                bg.bg.width = (w - (6 * 2));
                bg.bg.height = (h - (5 * 2));
                bg.btnClose.x = (w - 31);
                bg.dragonRight.x = (bg.frame.width + 21);
                bg.tTitle.x = int(((w / 2) - (bg.tTitle.width / 2)));
            }
            else
            {
                bg = (addChildAt(new (_arg_1)(), 0) as MovieClip);
            }
            if (("sName" in fData))
            {
                bg.tTitle.text = fData.sName;
                bg.tTitle.textColor = 0xFFFFFF;
                _local_2 = MovieClip(stage.getChildAt(0)).world.shopinfo;
                if (_local_2)
                {
                    bg.tTitle.textColor = ((Number(_local_2.bUpgrd) == 1) ? 16566089 : 0xFFFFFF);
                    if (Number(_local_2.bStaff) == 1)
                    {
                        bg.tTitle.textColor = 0xFFFF00;
                    }
                }
            }

            if (Game.root.ui.mcPopup.currentLabel.indexOf("Trade") > -1 || Game.root.ui.mcPopup.currentLabel.indexOf("Auction") > -1) return;

            if ((Game.root.ui.mcPopup.currentLabel.indexOf("Bank") > -1 || (fData.sName.toLowerCase() == "inventory") || (fData.sName.toLowerCase() == "house inventory")))
            {
                if (!bg.getChildByName("mcInvSearch"))
                {
                    mcSearch = bg.addChild(new invSearch(MovieClip(stage.getChildAt(0))));
                    mcSearch.name = "mcInvSearch";
                    if (MovieClip(stage.getChildAt(0)).ui.mcPopup.currentLabel.indexOf("Bank") == -1)
                    {
                        mcSearch.x = 156;
                        mcSearch.y = 26;
                    }
                    else
                    {
                        mcSearch.x = 737;
                        mcSearch.y = 24;
                    }
                    bg.tTitle.visible = false;
                }
            }
        }

        protected function onCloseClick(_arg_1:MouseEvent=null):void
        {
            switch (closeType)
            {
                case "hide":
                    fHide();
                    return;
                case "close":
                default:
                    mcSearch = null;
                    bg.btnClose.removeEventListener(MouseEvent.CLICK, onCloseClick);
                    fParent.fClose();
            }
        }


    }
}//package 

