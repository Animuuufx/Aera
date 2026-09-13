// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.controls.Slider

package fl.controls
{
    import fl.core.UIComponent;
    import fl.managers.IFocusManagerComponent;
    import flash.display.Sprite;
    import fl.core.InvalidationType;
    import fl.events.InteractionInputType;
    import fl.events.SliderEvent;
    import flash.display.DisplayObject;
    import fl.events.SliderEventClickTarget;
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;

    public class Slider extends UIComponent implements IFocusManagerComponent 
    {

        protected static var defaultStyles:Object = {
            "thumbUpSkin":"SliderThumb_upSkin",
            "thumbOverSkin":"SliderThumb_overSkin",
            "thumbDownSkin":"SliderThumb_downSkin",
            "thumbDisabledSkin":"SliderThumb_disabledSkin",
            "sliderTrackSkin":"SliderTrack_skin",
            "sliderTrackDisabledSkin":"SliderTrack_disabledSkin",
            "tickSkin":"SliderTick_skin",
            "focusRectSkin":null,
            "focusRectPadding":null
        };
        protected static const TRACK_STYLES:Object = {
            "upSkin":"sliderTrackSkin",
            "overSkin":"sliderTrackSkin",
            "downSkin":"sliderTrackSkin",
            "disabledSkin":"sliderTrackDisabledSkin"
        };
        protected static const THUMB_STYLES:Object = {
            "upSkin":"thumbUpSkin",
            "overSkin":"thumbOverSkin",
            "downSkin":"thumbDownSkin",
            "disabledSkin":"thumbDisabledSkin"
        };
        protected static const TICK_STYLES:Object = {"upSkin":"tickSkin"};

        protected var _direction:String = SliderDirection.HORIZONTAL;
        protected var _minimum:Number = 0;
        protected var _maximum:Number = 10;
        protected var _value:Number = 0;
        protected var _tickInterval:Number = 0;
        protected var _snapInterval:Number = 0;
        protected var _liveDragging:Boolean = false;
        protected var tickContainer:Sprite;
        protected var thumb:BaseButton;
        protected var track:BaseButton;

        public function Slider()
        {
            setStyles();
        }

        public static function getStyleDefinition():Object
        {
            return (defaultStyles);
        }


        public function get direction():String
        {
            return (_direction);
        }

        public function set direction(_arg_1:String):void
        {
            _direction = _arg_1;
            var _local_2:* = (_direction == SliderDirection.VERTICAL);
            if (isLivePreview)
            {
                if (_local_2)
                {
                    setScaleY(-1);
                    y = track.height;
                }
                else
                {
                    setScaleY(1);
                    y = 0;
                };
                positionThumb();
                return;
            };
            if (((_local_2) && (componentInspectorSetting)))
            {
                if ((rotation % 90) == 0)
                {
                    setScaleY(-1);
                };
            };
            if (!componentInspectorSetting)
            {
                rotation = ((_local_2) ? 90 : 0);
            };
        }

        public function get minimum():Number
        {
            return (_minimum);
        }

        public function set minimum(_arg_1:Number):void
        {
            _minimum = _arg_1;
            this.value = Math.max(_arg_1, this.value);
            invalidate(InvalidationType.DATA);
        }

        public function get maximum():Number
        {
            return (_maximum);
        }

        public function set maximum(_arg_1:Number):void
        {
            _maximum = _arg_1;
            this.value = Math.min(_arg_1, this.value);
            invalidate(InvalidationType.DATA);
        }

        public function get tickInterval():Number
        {
            return (_tickInterval);
        }

        public function set tickInterval(_arg_1:Number):void
        {
            _tickInterval = _arg_1;
            invalidate(InvalidationType.SIZE);
        }

        public function get snapInterval():Number
        {
            return (_snapInterval);
        }

        public function set snapInterval(_arg_1:Number):void
        {
            _snapInterval = _arg_1;
        }

        public function set liveDragging(_arg_1:Boolean):void
        {
            _liveDragging = _arg_1;
        }

        public function get liveDragging():Boolean
        {
            return (_liveDragging);
        }

        override public function get enabled():Boolean
        {
            return (super.enabled);
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            if (enabled == _arg_1)
            {
                return;
            };
            super.enabled = _arg_1;
            track.enabled = (thumb.enabled = _arg_1);
        }

        override public function setSize(_arg_1:Number, _arg_2:Number):void
        {
            if (((_direction == SliderDirection.VERTICAL) && (!(isLivePreview))))
            {
                super.setSize(_arg_2, _arg_1);
            }
            else
            {
                super.setSize(_arg_1, _arg_2);
            };
            invalidate(InvalidationType.SIZE);
        }

        public function get value():Number
        {
            return (_value);
        }

        public function set value(_arg_1:Number):void
        {
            doSetValue(_arg_1);
        }

        protected function doSetValue(_arg_1:Number, _arg_2:String=null, _arg_3:String=null, _arg_4:int=undefined):void
        {
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_5:Number = _value;
            if (((!(_snapInterval == 0)) && (!(_snapInterval == 1))))
            {
                _local_6 = Math.pow(10, getPrecision(snapInterval));
                _local_7 = (_snapInterval * _local_6);
                _local_8 = Math.round((_arg_1 * _local_6));
                _local_9 = (Math.round((_local_8 / _local_7)) * _local_7);
                _arg_1 = (_local_9 / _local_6);
                _value = Math.max(minimum, Math.min(maximum, _arg_1));
            }
            else
            {
                _value = Math.max(minimum, Math.min(maximum, Math.round(_arg_1)));
            };
            if (((!(_local_5 == _value)) && (((liveDragging) && (!(_arg_3 == null))) || (_arg_2 == InteractionInputType.KEYBOARD))))
            {
                dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, _arg_3, _arg_2, _arg_4));
            };
            positionThumb();
        }

        protected function setStyles():void
        {
            copyStylesToChild(thumb, THUMB_STYLES);
            copyStylesToChild(track, TRACK_STYLES);
        }

        override protected function draw():void
        {
            if (isInvalid(InvalidationType.STYLES))
            {
                setStyles();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE))
            {
                track.setSize(_width, track.height);
                track.drawNow();
                thumb.drawNow();
            };
            if (tickInterval > 0)
            {
                drawTicks();
            }
            else
            {
                clearTicks();
            };
            positionThumb();
            super.draw();
        }

        protected function positionThumb():void
        {
            thumb.x = ((((_direction == SliderDirection.VERTICAL) ? (maximum - value) : (value - minimum)) / (maximum - minimum)) * _width);
        }

        protected function drawTicks():void
        {
            var _local_5:DisplayObject;
            clearTicks();
            tickContainer = new Sprite();
            var _local_1:Number = ((maximum < 1) ? (tickInterval / 100) : tickInterval);
            var _local_2:Number = ((maximum - minimum) / _local_1);
            var _local_3:Number = (_width / _local_2);
            var _local_4:uint;
            while (_local_4 <= _local_2)
            {
                _local_5 = getDisplayObjectInstance(getStyleValue("tickSkin"));
                _local_5.x = (_local_3 * _local_4);
                _local_5.y = ((track.y - _local_5.height) - 2);
                tickContainer.addChild(_local_5);
                _local_4++;
            };
            addChild(tickContainer);
        }

        protected function clearTicks():void
        {
            if (((!(tickContainer)) || (!(tickContainer.parent))))
            {
                return;
            };
            removeChild(tickContainer);
        }

        protected function calculateValue(_arg_1:Number, _arg_2:String, _arg_3:String, _arg_4:int=undefined):void
        {
            var _local_5:Number = ((_arg_1 / _width) * (maximum - minimum));
            if (_direction == SliderDirection.VERTICAL)
            {
                _local_5 = (maximum - _local_5);
            }
            else
            {
                _local_5 = (minimum + _local_5);
            };
            doSetValue(_local_5, _arg_2, _arg_3, _arg_4);
        }

        protected function doDrag(_arg_1:MouseEvent):void
        {
            var _local_2:Number = (_width / snapInterval);
            var _local_3:Number = track.mouseX;
            calculateValue(_local_3, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
        }

        protected function thumbPressHandler(_arg_1:MouseEvent):void
        {
            var _local_2:DisplayObjectContainer = focusManager.form;
            _local_2.addEventListener(MouseEvent.MOUSE_MOVE, doDrag, false, 0, true);
            _local_2.addEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler, false, 0, true);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
        }

        protected function thumbReleaseHandler(_arg_1:MouseEvent):void
        {
            var _local_2:DisplayObjectContainer = focusManager.form;
            _local_2.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
            _local_2.removeEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASE, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
        }

        protected function onTrackClick(_arg_1:MouseEvent):void
        {
            calculateValue(track.mouseX, InteractionInputType.MOUSE, SliderEventClickTarget.TRACK);
            if (!liveDragging)
            {
                dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, SliderEventClickTarget.TRACK, InteractionInputType.MOUSE));
            };
        }

        override protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            var _local_3:Number;
            if (!enabled)
            {
                return;
            };
            var _local_2:Number = ((snapInterval > 0) ? snapInterval : 1);
            var _local_4:* = (direction == SliderDirection.HORIZONTAL);
            if ((((_arg_1.keyCode == Keyboard.DOWN) && (!(_local_4))) || ((_arg_1.keyCode == Keyboard.LEFT) && (_local_4))))
            {
                _local_3 = (value - _local_2);
            }
            else
            {
                if ((((_arg_1.keyCode == Keyboard.UP) && (!(_local_4))) || ((_arg_1.keyCode == Keyboard.RIGHT) && (_local_4))))
                {
                    _local_3 = (value + _local_2);
                }
                else
                {
                    if ((((_arg_1.keyCode == Keyboard.PAGE_DOWN) && (!(_local_4))) || ((_arg_1.keyCode == Keyboard.HOME) && (_local_4))))
                    {
                        _local_3 = minimum;
                    }
                    else
                    {
                        if ((((_arg_1.keyCode == Keyboard.PAGE_UP) && (!(_local_4))) || ((_arg_1.keyCode == Keyboard.END) && (_local_4))))
                        {
                            _local_3 = maximum;
                        };
                    };
                };
            };
            if (!isNaN(_local_3))
            {
                _arg_1.stopPropagation();
                doSetValue(_local_3, InteractionInputType.KEYBOARD, null, _arg_1.keyCode);
            };
        }

        override protected function configUI():void
        {
            super.configUI();
            thumb = new BaseButton();
            thumb.setSize(13, 13);
            thumb.autoRepeat = false;
            addChild(thumb);
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbPressHandler, false, 0, true);
            track = new BaseButton();
            track.move(0, 0);
            track.setSize(80, 4);
            track.autoRepeat = false;
            track.useHandCursor = false;
            track.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
            addChildAt(track, 0);
        }

        protected function getPrecision(_arg_1:Number):Number
        {
            var _local_2:String = _arg_1.toString();
            if (_local_2.indexOf(".") == -1)
            {
                return (0);
            };
            return (_local_2.split(".").pop().length);
        }


    }
}//package fl.controls

