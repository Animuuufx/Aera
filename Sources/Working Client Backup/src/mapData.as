// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mapData

package 
{
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class mapData 
    {

        private var rootClass:MovieClip;
        private var qID:int;
        private var qAccepted:Boolean;
        private var qTimer:Timer;

        public function mapData(_arg_1:MovieClip)
        {
            rootClass = _arg_1;
        }

        public function initObjSess(_arg_1:Array, _arg_2:Array):void
        {
            var _local_3:uint;
            if (rootClass.world.objSession[rootClass.world.strMapName] == null)
            {
                rootClass.world.objSession[rootClass.world.strMapName] = new Object();
                _local_3 = 0;
                while (_local_3 < _arg_1.length)
                {
                    initClicky(_arg_2[_local_3], _arg_1[_local_3]);
                    _local_3++;
                };
            };
        }

        public function updateSessArray(_arg_1:String, _arg_2:int=0):void
        {
            rootClass.world.objSession[rootClass.world.strMapName][(_arg_1 + _arg_2)] = true;
        }

        public function checkSess(_arg_1:String, _arg_2:int=0):Boolean
        {
            return (rootClass.world.objSession[rootClass.world.strMapName][(_arg_1 + _arg_2)]);
        }

        public function checkSessArr(_arg_1:String, _arg_2:Array):Boolean
        {
            var _local_3:* = checkSess(_arg_1, (_arg_2[0] - 1));
            var _local_4:uint = 1;
            while (_local_4 < _arg_2.length)
            {
                _local_3 = ((_local_3) && (checkSess(_arg_1, (_arg_2[_local_4] - 1))));
                _local_4++;
            };
            return (_local_3);
        }

        public function completeQuest(_arg_1:int, _arg_2:Boolean=false):void
        {
            var _local_3:*;
            if (_arg_2)
            {
                if (rootClass.world.isQuestInProgress(_arg_1))
                {
                    _local_3 = rootClass.world.questTree[_arg_1];
                    if (_local_3 != null)
                    {
                        if ((((!(isOneTimeQuestDone(_local_3))) && (!(_local_3.status == null))) && (_local_3.status == "c")))
                        {
                            rootClass.world.tryQuestComplete(_arg_1);
                        };
                    }
                    else
                    {
                        rootClass.world.tryQuestComplete(_arg_1);
                    };
                };
            }
            else
            {
                rootClass.world.tryQuestComplete(_arg_1);
            };
        }

        public function delayedTurnin(_arg_1:int, _arg_2:Boolean=false):void
        {
            qID = _arg_1;
            qAccepted = _arg_2;
            qTimer = new Timer(3000, 1);
            qTimer.addEventListener(TimerEvent.TIMER, onQuestTimer, false, 0, true);
            qTimer.start();
        }

        public function checkChaos():Boolean
        {
            var _local_1:Boolean = rootClass.world.getAchievement("ia1", 20);
            _local_1 = ((_local_1) || (rootClass.world.getAchievement("ia1", 21)));
            _local_1 = ((_local_1) || (rootClass.world.getAchievement("ia1", 22)));
            return ((_local_1) || (rootClass.world.getAchievement("ia1", 23)));
        }

        public function checkUpholder():Boolean
        {
            var _local_1:Boolean = ((rootClass.world.getAchievement("ip0", 3)) || (rootClass.world.getAchievement("ip0", 4)));
            _local_1 = (((_local_1) || (rootClass.world.getAchievement("ip0", 10))) || (rootClass.world.getAchievement("ip0", 24)));
            _local_1 = (((_local_1) || (rootClass.world.getAchievement("ip1", 16))) || (rootClass.world.getAchievement("ip2", 27)));
            return (((_local_1) || (rootClass.world.getAchievement("ip4", 22))) || (rootClass.world.getAchievement("ip8", 11)));
        }

        private function onQuestTimer(_arg_1:TimerEvent):void
        {
            qTimer.stop();
            qTimer.removeEventListener(TimerEvent.TIMER, onQuestTimer);
            completeQuest(qID, qAccepted);
        }

        private function initClicky(_arg_1:int, _arg_2:String):void
        {
            var _local_3:uint;
            while (_local_3 < _arg_1)
            {
                rootClass.world.objSession[rootClass.world.strMapName][(_arg_2 + _local_3)] = false;
                _local_3++;
            };
        }

        private function isOneTimeQuestDone(_arg_1:*):Boolean
        {
            return ((_arg_1.bOnce == 1) && ((_arg_1.iSlot < 0) || (rootClass.world.getQuestValue(_arg_1.iSlot) >= _arg_1.iValue)));
        }


    }
}//package 

