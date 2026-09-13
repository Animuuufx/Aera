// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//QtySelectorMC

package 
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    public class QtySelectorMC extends Sprite 
    {

        public var t1:TextField;
        public var t2:TextField;
        public var t3:TextField;
        public var handle:MovieClip;
        public var bar:MovieClip;
        private var _min:int = 1;
        private var _max:int = 1;
        private var _val:int = 1;
        private var isMouseDown:Boolean = false;
        private var p:Point = new Point();
        private var n:Number = 0;
        private var w:int = 0;
        private var dx:int = 0;
        private var rootClass:MovieClip;
        private var _parent:MovieClip;

        public function QtySelectorMC(_arg_1:*, _arg_2:MovieClip, _arg_3:int, _arg_4:int, _arg_5:int=-1):void
        {
            this.rootClass = _arg_2;
            this._parent = _arg_1;
            this._val = (this._min = _arg_3);
            this._max = _arg_4;
            this.w = (this.bar.width - this.handle.width);
            this.t2.htmlText = (("<font color='#FFFFFF'>" + this._min) + "</font>");
            this.t3.htmlText = (("<font color='#FFFFFF'>" + this._max) + "</font>");
            addEventListener(Event.ENTER_FRAME, this.onEF, false, 0, true);
            this.handle.addEventListener(MouseEvent.MOUSE_DOWN, this.onDn, false, 0, true);
            addEventListener(Event.ADDED_TO_STAGE, this.onStage, false, 0, true);
            this.t1.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey, false, 0, true);
            this.t2.addEventListener(MouseEvent.CLICK, this.onMin, false, 0, true);
            this.t3.addEventListener(MouseEvent.CLICK, this.onMax, false, 0, true);
            this.t1.restrict = "0123456789";
            this.t1.maxChars = 4;
            this.handle.buttonMode = true;
            if (_arg_5 != -1)
            {
                this._val = _arg_5;
            };
            this.updateHandle();
            this.update();
        }

        private function onMax(_arg_1:MouseEvent):void
        {
            this.val = this._max;
            this.update();
            this.updateHandle();
            this.rootClass.stage.focus = null;
        }

        private function onMin(_arg_1:MouseEvent):void
        {
            this.val = this._min;
            this.update();
            this.updateHandle();
            this.rootClass.stage.focus = null;
        }

        private function onStage(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onStage);
            this.rootClass.stage.addEventListener(MouseEvent.MOUSE_UP, this.onUp, false, 0, true);
        }

        private function update():void
        {
            if (this._val == this._max)
            {
                this.t1.htmlText = (("<font color='#FFFFFF'>" + this._val) + "</font>");
            }
            else
            {
                this.t1.htmlText = (("<font color='#999999'>" + this._val) + "</font>");
            };
        }

        private function updateHandle():void
        {
            this.handle.x = Math.round((this.bar.x + (this.w * (this._val / this._max))));
        }

        private function onEF(_arg_1:Event):void
        {
            if (this.isMouseDown)
            {
                this.p.x = stage.mouseX;
                this.p.y = stage.mouseY;
                this.p = globalToLocal(this.p);
                this.p.x = (this.p.x - this.dx);
                this.handle.x = (this.n = Math.max(Math.min(this.p.x, (this.bar.x + this.w)), this.bar.x));
                this.n = (this.n - this.bar.x);
                this.n = (this.n / this.w);
                this.val = Math.round((this.n * this._max));
                this.update();
            };
        }

        private function onDn(_arg_1:MouseEvent):void
        {
            this.isMouseDown = true;
            this.p.x = stage.mouseX;
            this.p.y = stage.mouseY;
            this.p = globalToLocal(this.p);
            this.dx = (this.p.x - this.handle.x);
        }

        private function onUp(_arg_1:MouseEvent):void
        {
            this.isMouseDown = false;
        }

        private function onKey(_arg_1:KeyboardEvent):void
        {
            if (((_arg_1.charCode == Keyboard.ENTER) || (_arg_1.charCode == Keyboard.ESCAPE)))
            {
                this.val;
                this.update();
                this.updateHandle();
                this.rootClass.stage.focus = null;
            };
        }

        public function killButtons():void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEF);
            this.handle.removeEventListener(MouseEvent.MOUSE_UP, this.onDn);
            this.rootClass.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onUp);
        }

        public function fClose():void
        {
            this.killButtons();
            parent.removeChild(this);
        }

        public function get val():int
        {
            if (this._val != int(this.t1.text))
            {
                this._val = int(this.t1.text);
            };
            this._val = Math.max(Math.min(this._val, this._max), this._min);
            return (this._val);
        }

        public function set val(_arg_1:int):void
        {
            this._val = Math.max(Math.min(_arg_1, this._max), this._min);
        }


    }
}//package 

