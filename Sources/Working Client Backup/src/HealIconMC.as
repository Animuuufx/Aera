// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//HealIconMC

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class HealIconMC extends MovieClip 
    {

        public var shp:MovieClip;
        public var hit:MovieClip;
        private var world:MovieClip;
        private var avt:Avatar;

        public function HealIconMC(_arg_1:Avatar, _arg_2:MovieClip):void
        {
            addFrameScript(35, this.frame36);
            this.world = _arg_2;
            this.avt = _arg_1;
            this.hit.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true);
            this.hit.buttonMode = true;
            this.hit.alpha = 0;
            this.shp.mouseEnabled = false;
            this.shp.mouseChildren = false;
            y = ((this.avt.pMC.pname.y - height) - 5);
            x = (x - int((width / 2)));
        }

        public function onClick(_arg_1:MouseEvent):void
        {
            this.world.healByIcon(this.avt);
            this.fClose();
        }

        public function fClose():void
        {
            stop();
            this.hit.removeEventListener(MouseEvent.CLICK, this.onClick);
            parent.removeChild(this);
        }

        internal function frame36():*
        {
            gotoAndPlay("loop");
        }


    }
}//package 

