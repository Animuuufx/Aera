// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.iconDrops

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;

    public class iconDrops extends MovieClip 
    {

        public var border:MovieClip;
        private var iconTimer:Timer;
        internal var rootClass:MovieClip;
        private var alertTimer:Timer;
        private var glowFilter:GlowFilter;
        private var alternate:Boolean = false;

        public function iconDrops()
        {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK, onBtDrop, false, 0, true);
            glowFilter = new GlowFilter(0xFFFFFF, 1, 35, 35, 1, 1, true, false);
            alertTimer = new Timer(0);
            alertTimer.addEventListener(TimerEvent.TIMER, onGlow);
        }

        public function initRoot(_arg_1:MovieClip):void
        {
            rootClass = _arg_1;
        }

        public function onBtDrop(_arg_1:MouseEvent):void
        {
            if (alertTimer.running)
            {
                alertTimer.stop();
                border.filters = [];
            };
            _arg_1.stopPropagation();
            rootClass.cDropsUI.onShow();
        }

        public function onAlert():void
        {
            if (alertTimer.running)
            {
                return;
            };
            glowFilter.strength = 1;
            border.filters = [glowFilter];
            alternate = false;
            alertTimer.start();
        }

        public function onGlow(_arg_1:TimerEvent):void
        {
            if (rootClass.cDropsUI.isMenuOpen())
            {
                alertTimer.stop();
                border.filters = [];
                return;
            };
            glowFilter.strength = (glowFilter.strength + ((alternate) ? 0.05 : -0.05));
            border.filters = [glowFilter];
            if (((glowFilter.strength <= 0) || (glowFilter.strength >= 1)))
            {
                alternate = ((glowFilter.strength <= 0) ? true : false);
            };
        }


    }
}//package liteAssets.draw

