// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFLayout

package 
{
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFLayout extends MovieClip 
    {

        public var panels:Array;
        public var fData:Object;
        public var w:int;
        public var h:int;
        public var panelID:int = 0;
        public var events:Object = {};
        public var sMode:String;

        public function LPFLayout():void
        {
        }

        public function update(_arg_1:Object):*
        {
            _arg_1 = handleUpdate(_arg_1);
            notifyByEventType(_arg_1);
        }

        protected function handleUpdate(_arg_1:Object):Object
        {
            return (_arg_1);
        }

        public function notifyByEventType(_arg_1:Object):void
        {
            var _local_2:Array;
            var _local_3:int;
            if (_arg_1 != null)
            {
                if (events[_arg_1.eventType] != null)
                {
                    _local_2 = events[_arg_1.eventType];
                    _local_3 = 0;
                    while (_local_3 < _local_2.length)
                    {
                        _local_2[_local_3].notify(_arg_1);
                        _local_3++;
                    };
                };
            };
        }

        public function registerForEvents(_arg_1:LPFFrame, _arg_2:Array):void
        {
            var _local_3:String;
            var _local_4:int;
            while (_local_4 < _arg_2.length)
            {
                _local_3 = _arg_2[_local_4];
                if (events[_local_3] == null)
                {
                    events[_local_3] = [];
                };
                if (events[_local_3].indexOf(_arg_1) == -1)
                {
                    events[_local_3].push(_arg_1);
                };
                _local_4++;
            };
        }

        public function unregisterFrame(_arg_1:*):void
        {
            var _local_2:String;
            var _local_3:int;
            while (_local_3 < _arg_1.eventTypes.length)
            {
                _local_2 = _arg_1.eventTypes[_local_3];
                if (events[_local_2] == null)
                {
                    return;
                };
                while (events[_local_2].indexOf(_arg_1) > -1)
                {
                    events[_local_2].splice(events[_local_2].indexOf(_arg_1), 1);
                };
                _local_3++;
            };
        }

        public function addPanel(_arg_1:Object):MovieClip
        {
            var _local_2:LPFPanel = (addChild(_arg_1.panel) as LPFPanel);
            _local_2.subscribeTo(this);
            panels.push({
                "mc":_local_2,
                "id":panelID++
            });
            _local_2.fOpen(_arg_1);
            return (_local_2);
        }

        public function delPanel(_arg_1:*):void
        {
            var _local_2:int;
            while (_local_2 < panels.length)
            {
                if (panels[_local_2].mc == _arg_1)
                {
                    panels.splice(_local_2, 1);
                };
                _local_2++;
            };
            removeChild(_arg_1);
        }

        public function fOpen(_arg_1:Object):void
        {
            var _local_2:Object;
            fData = _arg_1.fData;
            _local_2 = _arg_1.r;
            x = _local_2.x;
            y = _local_2.y;
            w = _local_2.w;
            h = _local_2.h;
        }

        public function fClose():void
        {
            var _local_1:MovieClip;
            while (panels.length > 0)
            {
                panels[0].mc.fClose();
                panels.shift();
            };
            if (parent != null)
            {
                _local_1 = MovieClip(parent);
                _local_1.removeChild(this);
                _local_1.onClose();
            };
        }

        protected function tempFill():void
        {
        }


    }
}//package 

