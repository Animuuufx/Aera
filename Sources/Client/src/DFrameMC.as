// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//DFrameMC

package 
{
    import flash.display.MovieClip;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class DFrameMC extends MovieClip 
    {

        public var cnt:DFrameMCcnt;
        internal var world:MovieClip;
        internal var rootClass:MovieClip;
        internal var fData:Object = null;
        internal var isOpen:Boolean = false;
        internal var iniFrameT:int = 0;
        internal var iniFrameC:int = 0;
        internal var durFrameT:int = 35;
        internal var durFrameC:int = 0;
        internal var mc:MovieClip;
        internal var rarityCA:Array = [0x666666, 0xFFFFFF, 0x66FF00, 2663679, 0xFF00FF, 0xFFCC00, 0xFF0000];
        public var fWidth:int = 175;
        public var fHeight:int = 38;
        public var fX:int = 0;
        public var fY:int = 0;

        public function DFrameMC(_arg_1:Object):void
        {
            addFrameScript(0, frame1, 2, frame3, 3, frame4, 8, frame9, 12, frame13);
            fData = _arg_1;
        }

        public function init():*
        {
            mc = MovieClip(this);
            rootClass = MovieClip(stage.getChildAt(0));
            mc.cnt.strName.autoSize = "left";
            mc.cnt.strName.text = fData.sName;
            if (mc.cnt.strName.height > 20)
            {
                mc.cnt.strName.y = (mc.cnt.strName.y - int((mc.cnt.strName.height / 2)));
                if (mc.cnt.strName.y < 3)
                {
                    mc.cnt.strName.y = 3;
                };
            };
            mc.cnt.strType.text = (rootClass.getDisplaysType(fData) + ((Boolean(fData.bBank)) ? " added to Bank" : ""));
            if (fData.virtual)
            {
                mc.cnt.strType.text = "Gold Donation";
            };
            mc.cnt.strType.width = (int(mc.cnt.strType.textWidth) + 50);
            if (((fData.iQty > 1) && (!(fData.sES == "ar"))))
            {
                mc.cnt.strQ.text = ("x" + fData.iQty);
                mc.cnt.strQ.x = ((mc.cnt.bg.width - mc.cnt.strQ.width) - 7);
                mc.cnt.strQ.visible = true;
                mc.cnt.bg.width = (int(mc.cnt.strName.textWidth) + 75);
            }
            else
            {
                mc.cnt.strQ.x = 0;
                mc.cnt.strQ.visible = false;
                mc.cnt.bg.width = (int(mc.cnt.strName.textWidth) + 50);
            };
            if (((fData.iQty > 1) && (!(fData.sES == "ar"))))
            {
                mc.cnt.bg.width = (int(mc.cnt.strName.textWidth) + 50);
                mc.cnt.bg.width = (mc.cnt.bg.width + (mc.cnt.strQ.textWidth + 2));
                mc.cnt.fx1.width = mc.cnt.bg.width;
                mc.fWidth = mc.cnt.bg.width;
            }
            else
            {
                if (mc.cnt.strName.textWidth < mc.cnt.strType.textWidth)
                {
                    mc.cnt.bg.width = (int(mc.cnt.strType.textWidth) + 50);
                    mc.cnt.fx1.width = mc.cnt.bg.width;
                    mc.fWidth = mc.cnt.bg.width;
                };
            };
            if (mc.cnt.strType.width > mc.cnt.bg.width)
            {
                mc.cnt.bg.width = (int(mc.cnt.strType.textWidth) + 50);
            };
            mc.cnt.strQ.x = (mc.cnt.bg.width - 65);
            mc.cnt.fx1.width = mc.cnt.bg.width;
            fWidth = mc.cnt.bg.width;
            var _local_1:* = mc.cnt.bg.filters;
            _local_1 = new GlowFilter(rarityCA[fData.iRty], 1, 8, 8, 2, 1, false, false);
            mc.cnt.bg.filters = [_local_1];
            rootClass.onRemoveChildrens(mc.cnt.icon);
            var _local_2:* = "";
            if (fData.sType.toLowerCase() == "enhancement")
            {
                _local_2 = rootClass.getIconBySlot(fData.sES);
            }
            else
            {
                if (((fData.sType.toLowerCase() == "serveruse") || (fData.sType.toLowerCase() == "clientuse")))
                {
                    if (((("sFile" in fData) && (fData.sFile.length > 0)) && (!(rootClass.world.getClass(fData.sFile) == null))))
                    {
                        _local_2 = fData.sFile;
                    }
                    else
                    {
                        _local_2 = fData.sIcon;
                    };
                }
                else
                {
                    if ((((fData.sIcon == null) || (fData.sIcon == "")) || (fData.sIcon == "none")))
                    {
                        if (fData.sLink.toLowerCase() != "none")
                        {
                            _local_2 = "iidesign";
                        }
                        else
                        {
                            _local_2 = "iibag";
                        };
                    }
                    else
                    {
                        _local_2 = fData.sIcon;
                    };
                };
            };
            var _local_3:Class = (rootClass.world.getClass(_local_2) as Class);
            var _local_4:* = mc.cnt.icon.addChild(new (_local_3)());
            _local_4.scaleX = (_local_4.scaleY = 0.5);
            _local_1 = mc.cnt.icon.filters;
            _local_1 = new GlowFilter(rarityCA[fData.iRty], 1, 8, 8, 2, 1, false, false);
            mc.cnt.icon.filters = [_local_1];
            mc.cnt.fadedAC.visible = false;
            mc.cnt.icon.detailedCheck.visible = false;
        }

        private function closeClick(_arg_1:MouseEvent):*
        {
        }

        internal function frame1():*
        {
            visible = false;
        }

        internal function frame3():*
        {
            iniFrameC++;
            if (!(iniFrameC > (MovieClip(parent).getChildIndex(this) * 2)))
            {
                this.gotoAndPlay((currentFrame - 1));
            };
        }

        internal function frame4():*
        {
            visible = true;
        }

        internal function frame9():*
        {
            durFrameC++;
            if (!(durFrameC > (durFrameT + 5)))
            {
                this.gotoAndPlay((currentFrame - 1));
            };
        }

        internal function frame13():*
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

