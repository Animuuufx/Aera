// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcQFrame_548

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class mcQFrame_548 extends MovieClip 
    {

        public var tl3:MovieClip;
        public var bl1:MovieClip;
        public var btnWiki:SimpleButton;
        public var btnClose:SimpleButton;
        public var bg:MovieClip;
        public var tr1:MovieClip;
        public var fx:MovieClip;
        public var tr2:MovieClip;
        public var btnPin:SimpleButton;
        public var tl1:MovieClip;
        public var tr3:MovieClip;
        public var br1:MovieClip;
        public var tl2:MovieClip;
        public var btnTry:SimpleButton;

        public function mcQFrame_548()
        {
            addFrameScript(0, frame1);
        }

        public function buildBounds():void
        {
            this.boundsOK = true;
            var _local_1:Array = (this.tl = [{
                "mc":tl1,
                "dx":0,
                "dy":0
            }, {
                "mc":tl2,
                "dx":0,
                "dy":0
            }, {
                "mc":tl3,
                "dx":0,
                "dy":0
            }]);
            var _local_2:Array = (this.tr = [{
                "mc":tl1,
                "dx":0,
                "dy":0
            }, {
                "mc":tr2,
                "dx":0,
                "dy":0
            }, {
                "mc":tr3,
                "dx":0,
                "dy":0
            }, {
                "mc":btnClose,
                "dx":0,
                "dy":0
            }]);
            var _local_3:Array = (this.bl = [{
                "mc":bl1,
                "dx":0,
                "dy":0
            }]);
            var _local_4:Array = (this.br = [{
                "mc":br1,
                "dx":0,
                "dy":0
            }]);
            var _local_5:int;
            var _local_6:Object = {};
            var _local_7:Point = new Point();
            var _local_8:Point = new Point();
            var _local_9:Rectangle = (this.bgA = bg.getBounds(this));
            _local_5 = 0;
            while (_local_5 < _local_1.length)
            {
                _local_6 = _local_1[_local_5];
                _local_7 = _local_9.topLeft;
                _local_6.dx = (_local_7.x - _local_6.mc.x);
                _local_6.dy = (_local_7.y - _local_6.mc.y);
                _local_5++;
            };
            _local_5 = 0;
            while (_local_5 < _local_2.length)
            {
                _local_6 = _local_2[_local_5];
                _local_7 = _local_9.topLeft;
                _local_7.x = (_local_7.x + _local_9.width);
                _local_6.dx = (_local_7.x - _local_6.mc.x);
                _local_6.dy = (_local_7.y - _local_6.mc.y);
                _local_5++;
            };
            _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_6 = _local_3[_local_5];
                _local_7 = _local_9.topLeft;
                _local_7.y = (_local_7.y + _local_9.height);
                _local_6.dx = (_local_7.x - _local_6.mc.x);
                _local_6.dy = (_local_7.y - _local_6.mc.y);
                _local_5++;
            };
            _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = _local_4[_local_5];
                _local_7 = _local_9.bottomRight;
                _local_6.dx = (_local_7.x - _local_6.mc.x);
                _local_6.dy = (_local_7.y - _local_6.mc.y);
                _local_5++;
            };
        }

        public function resizeTo(_arg_1:int, _arg_2:int, _arg_3:int=0):void
        {
            if (!("boundsOK" in this))
            {
                buildBounds();
            };
            var _local_4:Array = this.tl;
            var _local_5:Array = this.tr;
            var _local_6:Array = this.bl;
            var _local_7:Array = this.br;
            var _local_8:int;
            var _local_9:Object = {};
            var _local_10:Point = new Point();
            var _local_11:Point = new Point();
            var _local_12:Rectangle = this.bgA;
            bg.width = _arg_1;
            bg.height = _arg_2;
            bg.x = (_local_12.topLeft.x + Math.round((bg.width / 2)));
            bg.y = (_local_12.topLeft.y + Math.round((bg.height / 2)));
            var _local_13:Rectangle = bg.getBounds(this);
            _local_8 = 0;
            while (_local_8 < _local_4.length)
            {
                _local_9 = _local_4[_local_8];
                _local_11 = _local_13.topLeft;
                _local_9.mc.x = (_local_11.x - _local_9.dx);
                _local_9.mc.y = (_local_11.y - _local_9.dy);
                _local_8++;
            };
            _local_8 = 0;
            while (_local_8 < _local_5.length)
            {
                _local_9 = _local_5[_local_8];
                _local_11 = _local_13.topLeft;
                _local_11.x = (_local_11.x + _local_13.width);
                _local_9.mc.x = (_local_11.x - _local_9.dx);
                _local_9.mc.y = (_local_11.y - _local_9.dy);
                _local_8++;
            };
            _local_8 = 0;
            while (_local_8 < _local_6.length)
            {
                _local_9 = _local_6[_local_8];
                _local_11 = _local_13.topLeft;
                _local_11.y = (_local_11.y + _local_13.height);
                _local_9.mc.x = (_local_11.x - _local_9.dx);
                _local_9.mc.y = (_local_11.y - _local_9.dy);
                _local_8++;
            };
            _local_8 = 0;
            while (_local_8 < _local_7.length)
            {
                _local_9 = _local_7[_local_8];
                _local_11 = _local_13.bottomRight;
                _local_9.mc.x = (_local_11.x - _local_9.dx);
                _local_9.mc.y = (_local_11.y - _local_9.dy);
                _local_8++;
            };
            fx.y = 110;
        }

        internal function frame1():*
        {
        }


    }
}//package spider_fla

