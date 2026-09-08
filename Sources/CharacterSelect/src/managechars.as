// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//managechars

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.utils.getDefinitionByName;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class managechars extends MovieClip 
    {

        public var tl3:MovieClip;
        public var bl1:MovieClip;
        public var btnClose:SimpleButton;
        public var btnUp:SimpleButton;
        public var btn0:selBtnChar;
        public var btnCharPage:SimpleButton;
        public var btnDown:SimpleButton;
        public var highlighter:MovieClip;
        public var bg:MovieClip;
        public var btnAdd0:SimpleButton;
        public var btnAdd1:SimpleButton;
        public var tr1:MovieClip;
        public var btnAdd2:SimpleButton;
        public var tr2:MovieClip;
        public var btnAdd3:SimpleButton;
        public var tl1:MovieClip;
        public var tr3:MovieClip;
        public var br1:MovieClip;
        public var tl2:MovieClip;
        private var m:MovieClip;
        private var active:int = 0;

        public function managechars(_arg_1:MovieClip)
        {
            m = _arg_1;
            visible = false;
            highlighter.mouseEnabled = false;
            btnCharPage.addEventListener(MouseEvent.CLICK, onBtnCharPage, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
            btnUp.addEventListener(MouseEvent.CLICK, onBtnUp, false, 0, true);
            btnDown.addEventListener(MouseEvent.CLICK, onBtnDown, false, 0, true);
        }

        public function onBtnUp(_arg_1:MouseEvent):void
        {
            if (m.mngr.displayAvts.length < 2)
            {
                return;
            };
            var _local_2:int = m.mngr.displayAvts[active].index;
            var _local_3:int = _local_2;
            _local_2 = (((_local_2 - 1) < 0) ? (m.mngr.displayAvts.length - 1) : (_local_2 - 1));
            m.mngr.displayAvts[active].index = _local_2;
            m.mngr.setCharIndex(m.mngr.displayAvts[active].data.strUsername, _local_2);
            var _local_4:int = (((active - 1) < 0) ? (m.mngr.displayAvts.length - 1) : (active - 1));
            m.mngr.displayAvts[_local_4].index = _local_3;
            m.mngr.setCharIndex(m.mngr.displayAvts[_local_4].data.strUsername, _local_3);
            active--;
            if (active < 0)
            {
                active = (m.mngr.displayAvts.length - 1);
            };
            m.mngr.displayAvts.sortOn("index");
            init(m.mngr.displayAvts);
        }

        public function onBtnDown(_arg_1:MouseEvent):void
        {
            if (m.mngr.displayAvts.length < 2)
            {
                return;
            };
            var _local_2:int = m.mngr.displayAvts[active].index;
            var _local_3:int = _local_2;
            _local_2 = (((_local_2 + 1) > (m.mngr.displayAvts.length - 1)) ? 0 : (_local_2 + 1));
            m.mngr.displayAvts[active].index = _local_2;
            m.mngr.setCharIndex(m.mngr.displayAvts[active].data.strUsername, _local_2);
            var _local_4:int = (((active + 1) > (m.mngr.displayAvts.length - 1)) ? 0 : (active + 1));
            m.mngr.displayAvts[_local_4].index = _local_3;
            m.mngr.setCharIndex(m.mngr.displayAvts[_local_4].data.strUsername, _local_3);
            active++;
            if (active > (m.mngr.displayAvts.length - 1))
            {
                active = 0;
            };
            m.mngr.displayAvts.sortOn("index");
            init(m.mngr.displayAvts);
        }

        public function init(_arg_1:Array):*
        {
            var _local_5:MovieClip;
            var _local_6:Class;
            var _local_2:int = 1;
            while (_local_2 < 5)
            {
                if (getChildByName(("btn" + _local_2)))
                {
                    removeChild(getChildByName(("btn" + _local_2)));
                };
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_local_3 == 0)
                {
                    _local_5 = MovieClip(getChildByName("btn0"));
                }
                else
                {
                    _local_6 = (getDefinitionByName("selBtnChar") as Class);
                    _local_5 = new (_local_6)();
                    _local_5.name = ("btn" + _local_3);
                };
                _local_5.x = -0.8;
                _local_5.y = (-77.15 + (_local_3 * 39.15));
                _local_5.txtName.text = _arg_1[_local_3].data.strUsername;
                _local_5.txtName.mouseEnabled = false;
                _local_5.btnSelectCharacter.addEventListener(MouseEvent.CLICK, onCharButton, false, 0, true);
                _local_5.btnRemoveCharacter.addEventListener(MouseEvent.CLICK, onRemoveChar, false, 0, true);
                if (_local_3 != 0)
                {
                    addChild(_local_5);
                };
                if (_local_3 == active)
                {
                    highlighter.y = (_local_5.y - 17.5);
                    setChildIndex(highlighter, (numChildren - 1));
                };
                _local_3++;
            };
            var _local_4:int;
            while (_local_4 < this.numChildren)
            {
                if (getChildAt(_local_4).name.indexOf("btnAdd") > -1)
                {
                    if (!getChildAt(_local_4).hasEventListener(MouseEvent.CLICK))
                    {
                        getChildAt(_local_4).addEventListener(MouseEvent.CLICK, onBtnAddChar, false, 0, true);
                    };
                };
                _local_4++;
            };
        }

        public function onBtnAddChar(_arg_1:MouseEvent):void
        {
            m.parent.removeChild(m);
            m.r.csShowServers = false;
            m.r.gotoAndPlay("Login");
        }

        public function onBtnClose(_arg_1:MouseEvent):void
        {
            m.utl.close(0);
        }

        public function onBtnCharPage(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(("https://account.aq.com/CharPage?id=" + m.mngr.displayAvts[active].data.strUsername)), "_blank");
        }

        public function onCharButton(_arg_1:MouseEvent):void
        {
            highlighter.y = (_arg_1.currentTarget.parent.y - 17.5);
            setChildIndex(highlighter, (numChildren - 1));
            active = parseInt(_arg_1.currentTarget.parent.name.slice(3));
        }

        public function onRemoveChar(_arg_1:MouseEvent):void
        {
            var _local_2:* = parseInt(_arg_1.currentTarget.parent.name.slice(3));
            m.mngr.delCharByName(m.mngr.displayAvts[_local_2].data.strUsername, _local_2);
            init(m.mngr.displayAvts);
            m.pos = 0;
            active = 0;
            m.updateCarousel();
        }


    }
}//package 

