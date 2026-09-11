// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Killvis

package 
{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.display.MovieClip;

    public class Killvis extends EventDispatcher 
    {

        internal var vobj:*;
        internal var vTimer:Timer = new Timer(1000, 1);

        public function Killvis()
        {
            vTimer.addEventListener(TimerEvent.TIMER, noVis, false, 0, true);
        }

        public function kill(_arg_1:Object, _arg_2:int):*
        {
            this.vobj = _arg_1;
            vTimer.delay = _arg_2;
            vTimer.reset();
            vTimer.start();
        }

        public function stopkill():*
        {
            if (((!(vTimer == null)) && (vTimer.running)))
            {
                vTimer.stop();
            };
        }

        public function resetkill():*
        {
            if (((!(vTimer == null)) && (vTimer.running)))
            {
                vTimer.reset();
                vTimer.start();
            };
        }

        public function noVis(_arg_1:TimerEvent):*
        {
            vobj.visible = false;
            MovieClip(MovieClip(vobj).parent).kv = null;
        }


    }
}//package 

