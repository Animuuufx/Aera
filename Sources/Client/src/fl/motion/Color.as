// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.motion.Color

package fl.motion
{
    import flash.geom.ColorTransform;
    import flash.display.*;

    public class Color extends ColorTransform 
    {

        private var _tintColor:Number = 0;
        private var _tintMultiplier:Number = 0;

        public function Color(_arg_1:Number=1, _arg_2:Number=1, _arg_3:Number=1, _arg_4:Number=1, _arg_5:Number=0, _arg_6:Number=0, _arg_7:Number=0, _arg_8:Number=0)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
        }

        public static function fromXML(_arg_1:XML):Color
        {
            return (Color(new (Color)().parseXML(_arg_1)));
        }

        public static function interpolateTransform(_arg_1:ColorTransform, _arg_2:ColorTransform, _arg_3:Number):ColorTransform
        {
            var _local_4:Number = (1 - _arg_3);
            var _local_5:ColorTransform = new ColorTransform(((_arg_1.redMultiplier * _local_4) + (_arg_2.redMultiplier * _arg_3)), ((_arg_1.greenMultiplier * _local_4) + (_arg_2.greenMultiplier * _arg_3)), ((_arg_1.blueMultiplier * _local_4) + (_arg_2.blueMultiplier * _arg_3)), ((_arg_1.alphaMultiplier * _local_4) + (_arg_2.alphaMultiplier * _arg_3)), ((_arg_1.redOffset * _local_4) + (_arg_2.redOffset * _arg_3)), ((_arg_1.greenOffset * _local_4) + (_arg_2.greenOffset * _arg_3)), ((_arg_1.blueOffset * _local_4) + (_arg_2.blueOffset * _arg_3)), ((_arg_1.alphaOffset * _local_4) + (_arg_2.alphaOffset * _arg_3)));
            return (_local_5);
        }

        public static function interpolateColor(_arg_1:uint, _arg_2:uint, _arg_3:Number):uint
        {
            var _local_4:Number = (1 - _arg_3);
            var _local_5:uint = ((_arg_1 >> 24) & 0xFF);
            var _local_6:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_7:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_8:uint = (_arg_1 & 0xFF);
            var _local_9:uint = ((_arg_2 >> 24) & 0xFF);
            var _local_10:uint = ((_arg_2 >> 16) & 0xFF);
            var _local_11:uint = ((_arg_2 >> 8) & 0xFF);
            var _local_12:uint = (_arg_2 & 0xFF);
            var _local_13:uint = ((_local_5 * _local_4) + (_local_9 * _arg_3));
            var _local_14:uint = ((_local_6 * _local_4) + (_local_10 * _arg_3));
            var _local_15:uint = ((_local_7 * _local_4) + (_local_11 * _arg_3));
            var _local_16:uint = ((_local_8 * _local_4) + (_local_12 * _arg_3));
            var _local_17:uint = ((((_local_13 << 24) | (_local_14 << 16)) | (_local_15 << 8)) | _local_16);
            return (_local_17);
        }


        public function get brightness():Number
        {
            return ((this.redOffset) ? (1 - this.redMultiplier) : (this.redMultiplier - 1));
        }

        public function set brightness(_arg_1:Number):void
        {
            if (_arg_1 > 1)
            {
                _arg_1 = 1;
            }
            else
            {
                if (_arg_1 < -1)
                {
                    _arg_1 = -1;
                };
            };
            var _local_2:Number = (1 - Math.abs(_arg_1));
            var _local_3:Number = 0;
            if (_arg_1 > 0)
            {
                _local_3 = (_arg_1 * 0xFF);
            };
            this.redMultiplier = (this.greenMultiplier = (this.blueMultiplier = _local_2));
            this.redOffset = (this.greenOffset = (this.blueOffset = _local_3));
        }

        public function setTint(_arg_1:uint, _arg_2:Number):void
        {
            this._tintColor = _arg_1;
            this._tintMultiplier = _arg_2;
            this.redMultiplier = (this.greenMultiplier = (this.blueMultiplier = (1 - _arg_2)));
            var _local_3:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_4:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_5:uint = (_arg_1 & 0xFF);
            this.redOffset = Math.round((_local_3 * _arg_2));
            this.greenOffset = Math.round((_local_4 * _arg_2));
            this.blueOffset = Math.round((_local_5 * _arg_2));
        }

        public function get tintColor():uint
        {
            return (this._tintColor);
        }

        public function set tintColor(_arg_1:uint):void
        {
            this.setTint(_arg_1, this.tintMultiplier);
        }

        private function deriveTintColor():uint
        {
            var _local_1:Number = (1 / this.tintMultiplier);
            var _local_2:uint = Math.round((this.redOffset * _local_1));
            var _local_3:uint = Math.round((this.greenOffset * _local_1));
            var _local_4:uint = Math.round((this.blueOffset * _local_1));
            var _local_5:uint = (((_local_2 << 16) | (_local_3 << 8)) | _local_4);
            return (_local_5);
        }

        public function get tintMultiplier():Number
        {
            return (this._tintMultiplier);
        }

        public function set tintMultiplier(_arg_1:Number):void
        {
            this.setTint(this.tintColor, _arg_1);
        }

        private function parseXML(_arg_1:XML=null):Color
        {
            var _local_3:XML;
            var _local_4:String;
            var _local_5:uint;
            if (!_arg_1)
            {
                return (this);
            };
            var _local_2:XML = _arg_1.elements()[0];
            if (!_local_2)
            {
                return (this);
            };
            for each (_local_3 in _local_2.attributes())
            {
                _local_4 = _local_3.localName();
                if (_local_4 == "tintColor")
                {
                    _local_5 = (Number(_local_3.toString()) as uint);
                    this.tintColor = _local_5;
                }
                else
                {
                    this[_local_4] = Number(_local_3.toString());
                };
            };
            return (this);
        }


    }
}//package fl.motion

