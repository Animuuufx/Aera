// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//cutsceneHandler

package 
{
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class cutsceneHandler 
    {

        private var rootClass:MovieClip;
        private var strMap:String;
        private var strFrame:String = "";
        private var strPad:String;
        private var changeMap:Boolean = false;
        private var strFile:String;
        private var cutFrame:String;
        private var cutPad:String;
        private var cutTimer:Timer;

        public function cutsceneHandler(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
        }

        public function setCutsceneTarget(_arg_1:String, _arg_2:String, _arg_3:String=""):void
        {
            strFrame = _arg_1;
            strPad = _arg_2;
            strMap = _arg_3;
            changeMap = (!(_arg_3 == ""));
        }

        public function transfer():void
        {
            if (changeMap)
            {
                rootClass.world.gotoTown(strMap, strFrame, strPad);
            }
            else
            {
                if (strFrame != "")
                {
                    rootClass.world.moveToCell(strFrame, strPad);
                };
            };
            rootClass.clearExternamSWF();
        }

        public function showCutscene(_arg_1:String, _arg_2:Boolean=false, _arg_3:String="Cut1", _arg_4:String="Left"):void
        {
            strFile = _arg_1;
            cutFrame = _arg_3;
            cutPad = _arg_4;
            if (_arg_2)
            {
                cutTimer = new Timer(3000, 1);
                cutTimer.addEventListener(TimerEvent.TIMER, onCutTimer, false, 0, true);
                cutTimer.start();
            }
            else
            {
                rootClass.loadExternalSWF(strFile);
                rootClass.world.moveToCell(cutFrame, cutPad);
            };
        }

        private function onCutTimer(_arg_1:TimerEvent):void
        {
            cutTimer.stop();
            cutTimer.removeEventListener(TimerEvent.TIMER, onCutTimer);
            rootClass.loadExternalSWF(strFile);
            rootClass.world.moveToCell(cutFrame, cutPad);
        }


    }
}//package 

