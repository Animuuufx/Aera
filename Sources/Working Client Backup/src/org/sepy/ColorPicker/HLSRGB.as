// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.HLSRGB

package org.sepy.ColorPicker
{
    import org.sepy.ColorPicker.RGB;

    internal class HLSRGB 
    {

        private var _red:Number = 0;
        private var _green:Number = 0;
        private var _blue:Number = 0;
        private var _hue:Number = 0;
        private var _luminance:Number = 0;
        private var _saturation:Number = 0;


        public function get red():Number
        {
            return (_red);
        }

        public function set red(_arg_1:Number):void
        {
            _red = _arg_1;
            ToHLS();
        }

        public function get green():Number
        {
            return (_green);
        }

        public function set green(_arg_1:Number):void
        {
            _green = _arg_1;
            ToHLS();
        }

        public function get blue():Number
        {
            return (_blue);
        }

        public function set blue(_arg_1:Number):void
        {
            _blue = _arg_1;
            ToHLS();
        }

        public function get luminance():Number
        {
            return (_luminance);
        }

        public function set luminance(_arg_1:Number):void
        {
            if (!((_arg_1 < 0) || (_arg_1 > 1)))
            {
                _luminance = _arg_1;
                ToRGB();
            };
        }

        public function get hue():Number
        {
            return (_hue);
        }

        public function set hue(_arg_1:Number):void
        {
            if (!((_arg_1 < 0) || (_arg_1 > 360)))
            {
                _hue = _arg_1;
                ToRGB();
            };
        }

        public function get saturation():Number
        {
            return (_saturation);
        }

        public function set saturation(_arg_1:Number):void
        {
            if (!((_arg_1 < 0) || (_arg_1 > 1)))
            {
                _saturation = _arg_1;
                ToRGB();
            };
        }

        public function get color():RGB
        {
            return (new RGB(_red, _green, _blue));
        }

        public function getRGB():Number
        {
            return (((_red << 16) | (_green << 8)) | _blue);
        }

        public function set color(_arg_1:RGB):void
        {
            _red = _arg_1.r;
            _green = _arg_1.g;
            _blue = _arg_1.b;
            ToHLS();
        }

        public function lightenBy(_arg_1:Number):void
        {
            _luminance = (_luminance * (1 + _arg_1));
            if (_luminance > 1)
            {
                _luminance = 1;
            };
            ToRGB();
        }

        public function darkenBy(_arg_1:Number):void
        {
            _luminance = (_luminance * _arg_1);
            ToRGB();
        }

        private function ToHLS():void
        {
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_1:Number = Math.min(_red, Math.min(_green, _blue));
            var _local_2:Number = Math.max(_red, Math.max(_green, _blue));
            var _local_3:Number = (_local_2 - _local_1);
            var _local_4:Number = (_local_2 + _local_1);
            _luminance = (_local_4 / 510);
            if (_local_2 == _local_1)
            {
                _saturation = 0;
                _hue = 0;
            }
            else
            {
                _local_5 = ((_local_2 - _red) / _local_3);
                _local_6 = ((_local_2 - _green) / _local_3);
                _local_7 = ((_local_2 - _blue) / _local_3);
                _saturation = ((_luminance <= 0.5) ? (_local_3 / _local_4) : (_local_3 / (510 - _local_4)));
                if (_red == _local_2)
                {
                    _hue = (60 * ((6 + _local_7) - _local_6));
                }
                else
                {
                    if (_green == _local_2)
                    {
                        _hue = (60 * ((2 + _local_5) - _local_7));
                    }
                    else
                    {
                        if (_blue == _local_2)
                        {
                            _hue = (60 * ((4 + _local_6) - _local_5));
                        };
                    };
                };
                _hue = (_hue % 360);
            };
        }

        private function ToRGB():void
        {
            var _local_1:Number;
            var _local_2:Number;
            if (_saturation == 0)
            {
                _red = (_green = (_blue = (_luminance * 0xFF)));
            }
            else
            {
                if (_luminance <= 0.5)
                {
                    _local_2 = (_luminance + (_luminance * _saturation));
                }
                else
                {
                    _local_2 = ((_luminance + _saturation) - (_luminance * _saturation));
                };
                _local_1 = ((2 * _luminance) - _local_2);
                _red = ToRGB1(_local_1, _local_2, (_hue + 120));
                _green = ToRGB1(_local_1, _local_2, _hue);
                _blue = ToRGB1(_local_1, _local_2, (_hue - 120));
            };
        }

        private function ToRGB1(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            if (_arg_3 > 360)
            {
                _arg_3 = (_arg_3 - 360);
            }
            else
            {
                if (_arg_3 < 0)
                {
                    _arg_3 = (_arg_3 + 360);
                };
            };
            if (_arg_3 < 60)
            {
                _arg_1 = (_arg_1 + (((_arg_2 - _arg_1) * _arg_3) / 60));
            }
            else
            {
                if (_arg_3 < 180)
                {
                    _arg_1 = _arg_2;
                }
                else
                {
                    if (_arg_3 < 240)
                    {
                        _arg_1 = (_arg_1 + (((_arg_2 - _arg_1) * (240 - _arg_3)) / 60));
                    };
                };
            };
            return (_arg_1 * 0xFF);
        }

        public function toString():String
        {
            return (((((((((((("[R:" + red) + ", G:") + green) + ", B:") + blue) + ", H:") + hue) + ", S:") + saturation) + ", L:") + luminance) + "]");
        }


    }
}//package org.sepy.ColorPicker

