// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//util

package 
{
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;

    public class util extends MovieClip 
    {

        private var r:MovieClip;
        private var m:MovieClip;
        public var active:int = -1;
        public var interfaces:Array = ["manage characters", "character options", "character settings"];

        public function util(_arg_1:MovieClip, _arg_2:MovieClip)
        {
            r = _arg_1;
            m = _arg_2;
        }

        public function display(_arg_1:String):void
        {
            var _local_2:Class = (getDefinitionByName("ModalMC") as Class);
            var _local_3:* = new (_local_2)();
            var _local_4:* = {};
            _local_4.strBody = _arg_1;
            _local_4.params = {};
            _local_4.callback = null;
            _local_4.glow = "red,medium";
            r.ui.ModalStack.addChild(_local_3);
            _local_3.init(_local_4);
        }

        public function addCommas(_arg_1:uint):String
        {
            var _local_4:uint;
            if (_arg_1 == 0)
            {
                return ("0");
            };
            var _local_2:* = "";
            var _local_3:uint = _arg_1;
            while (_local_3 > 0)
            {
                _local_4 = (_local_3 % 1000);
                _local_2 = ((((_local_3 > 999) ? ("," + ((_local_4 < 100) ? ((_local_4 < 10) ? "00" : "0") : "")) : "") + _local_4) + _local_2);
                _local_3 = uint((_local_3 / 1000));
            };
            return (_local_2);
        }

        public function open(_arg_1:int):void
        {
            var _local_2:String = interfaces[_arg_1];
            if (active == _arg_1)
            {
                close(_arg_1);
                return;
            };
            close(active);
            switch (_local_2)
            {
                case "manage characters":
                    m.managecharsui.visible = true;
                    break;
                case "character options":
                    m.charoptionsui.visible = true;
                    break;
                case "character settings":
                    m.settingsui.visible = true;
                    break;
            };
            active = _arg_1;
        }

        public function close(_arg_1:int):void
        {
            var _local_2:String = interfaces[_arg_1];
            switch (_local_2)
            {
                case "manage characters":
                    m.managecharsui.visible = false;
                    m.updateCarousel();
                    break;
                case "character options":
                    m.charoptionsui.visible = false;
                    break;
                case "character settings":
                    m.settingsui.visible = false;
                    break;
            };
            active = -1;
        }


    }
}//package 

