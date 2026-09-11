// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.controls.NumericStepper

package fl.controls
{
    import fl.core.UIComponent;
    import fl.managers.IFocusManagerComponent;
    import flash.events.FocusEvent;
    import flash.events.Event;
    import fl.events.ComponentEvent;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import fl.core.InvalidationType;
    import flash.display.DisplayObject;

    public class NumericStepper extends UIComponent implements IFocusManagerComponent 
    {

        private static var defaultStyles:Object = {
            "downArrowDisabledSkin":"NumericStepperDownArrow_disabledSkin",
            "downArrowDownSkin":"NumericStepperDownArrow_downSkin",
            "downArrowOverSkin":"NumericStepperDownArrow_overSkin",
            "downArrowUpSkin":"NumericStepperDownArrow_upSkin",
            "upArrowDisabledSkin":"NumericStepperUpArrow_disabledSkin",
            "upArrowDownSkin":"NumericStepperUpArrow_downSkin",
            "upArrowOverSkin":"NumericStepperUpArrow_overSkin",
            "upArrowUpSkin":"NumericStepperUpArrow_upSkin",
            "upSkin":"TextInput_upSkin",
            "disabledSkin":"TextInput_disabledSkin",
            "focusRect":null,
            "focusRectSkin":null,
            "focusRectPadding":null,
            "repeatDelay":500,
            "repeatInterval":35,
            "embedFonts":false
        };
        protected static const DOWN_ARROW_STYLES:Object = {
            "disabledSkin":"downArrowDisabledSkin",
            "downSkin":"downArrowDownSkin",
            "overSkin":"downArrowOverSkin",
            "upSkin":"downArrowUpSkin",
            "repeatDelay":"repeatDelay",
            "repeatInterval":"repeatInterval"
        };
        protected static const UP_ARROW_STYLES:Object = {
            "disabledSkin":"upArrowDisabledSkin",
            "downSkin":"upArrowDownSkin",
            "overSkin":"upArrowOverSkin",
            "upSkin":"upArrowUpSkin",
            "repeatDelay":"repeatDelay",
            "repeatInterval":"repeatInterval"
        };
        protected static const TEXT_INPUT_STYLES:Object = {
            "upSkin":"upSkin",
            "disabledSkin":"disabledSkin",
            "textPadding":"textPadding",
            "textFormat":"textFormat",
            "disabledTextFormat":"disabledTextFormat",
            "embedFonts":"embedFonts"
        };

        protected var inputField:TextInput;
        protected var upArrow:BaseButton;
        protected var downArrow:BaseButton;
        protected var _maximum:Number = 10;
        protected var _minimum:Number = 0;
        protected var _value:Number = 1;
        protected var _stepSize:Number = 1;
        protected var _precision:Number;

        public function NumericStepper()
        {
            setStyles();
            stepSize = _stepSize;
        }

        public static function getStyleDefinition():Object
        {
            return (defaultStyles);
        }


        override public function get enabled():Boolean
        {
            return (super.enabled);
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            if (_arg_1 == enabled)
            {
                return;
            };
            super.enabled = _arg_1;
            upArrow.enabled = (downArrow.enabled = (inputField.enabled = _arg_1));
        }

        public function get maximum():Number
        {
            return (_maximum);
        }

        public function set maximum(_arg_1:Number):void
        {
            _maximum = _arg_1;
            if (_value > _maximum)
            {
                setValue(_maximum, false);
            };
        }

        public function get minimum():Number
        {
            return (_minimum);
        }

        public function set minimum(_arg_1:Number):void
        {
            _minimum = _arg_1;
            if (_value < _minimum)
            {
                setValue(_minimum, false);
            };
        }

        public function get nextValue():Number
        {
            var _local_1:Number = (_value + _stepSize);
            return ((inRange(_local_1)) ? _local_1 : _value);
        }

        public function get previousValue():Number
        {
            var _local_1:Number = (_value - _stepSize);
            return ((inRange(_local_1)) ? _local_1 : _value);
        }

        public function get stepSize():Number
        {
            return (_stepSize);
        }

        public function set stepSize(_arg_1:Number):void
        {
            _stepSize = _arg_1;
            _precision = getPrecision();
            setValue(_value);
        }

        public function get value():Number
        {
            return (_value);
        }

        public function set value(_arg_1:Number):void
        {
            setValue(_arg_1, false);
        }

        public function get textField():TextInput
        {
            return (inputField);
        }

        public function get imeMode():String
        {
            return (inputField.imeMode);
        }

        public function set imeMode(_arg_1:String):void
        {
            inputField.imeMode = _arg_1;
        }

        override protected function configUI():void
        {
            super.configUI();
            upArrow = new BaseButton();
            copyStylesToChild(upArrow, UP_ARROW_STYLES);
            upArrow.autoRepeat = true;
            upArrow.setSize(21, 12);
            upArrow.focusEnabled = false;
            addChild(upArrow);
            downArrow = new BaseButton();
            copyStylesToChild(downArrow, DOWN_ARROW_STYLES);
            downArrow.autoRepeat = true;
            downArrow.setSize(21, 12);
            downArrow.focusEnabled = false;
            addChild(downArrow);
            inputField = new TextInput();
            copyStylesToChild(inputField, TEXT_INPUT_STYLES);
            inputField.restrict = "0-9\\-\\.\\,";
            inputField.text = _value.toString();
            inputField.setSize(21, 24);
            inputField.focusTarget = (this as IFocusManagerComponent);
            inputField.focusEnabled = false;
            inputField.addEventListener(FocusEvent.FOCUS_IN, passEvent);
            inputField.addEventListener(FocusEvent.FOCUS_OUT, passEvent);
            addChild(inputField);
            inputField.addEventListener(Event.CHANGE, onTextChange, false, 0, true);
            upArrow.addEventListener(ComponentEvent.BUTTON_DOWN, stepperPressHandler, false, 0, true);
            downArrow.addEventListener(ComponentEvent.BUTTON_DOWN, stepperPressHandler, false, 0, true);
        }

        protected function setValue(_arg_1:Number, _arg_2:Boolean=true):void
        {
            if (_arg_1 == _value)
            {
                return;
            };
            var _local_3:Number = _value;
            _value = getValidValue(_arg_1);
            inputField.text = _value.toString();
            if (_arg_2)
            {
                dispatchEvent(new Event(Event.CHANGE, true));
            };
        }

        override protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            if (!enabled)
            {
                return;
            };
            _arg_1.stopImmediatePropagation();
            var _local_2:Number = Number(inputField.text);
            switch (_arg_1.keyCode)
            {
                case Keyboard.END:
                    setValue(maximum);
                    return;
                case Keyboard.HOME:
                    setValue(minimum);
                    return;
                case Keyboard.UP:
                    setValue(nextValue);
                    return;
                case Keyboard.DOWN:
                    setValue(previousValue);
                    return;
                case Keyboard.ENTER:
                    setValue(_local_2);
                    return;
            };
        }

        protected function stepperPressHandler(_arg_1:ComponentEvent):void
        {
            setValue(Number(inputField.text), false);
            switch (_arg_1.currentTarget)
            {
                case upArrow:
                    setValue(nextValue);
                    break;
                case downArrow:
                    setValue(previousValue);
            };
            inputField.setFocus();
            inputField.textField.setSelection(0, 0);
        }

        override public function drawFocus(_arg_1:Boolean):void
        {
            var _local_2:Number;
            super.drawFocus(_arg_1);
            if (_arg_1)
            {
                _local_2 = Number(getStyleValue("focusRectPadding"));
                uiFocusRect.width = (width + (_local_2 * 2));
                uiFocusRect.height = (height + (_local_2 * 2));
            };
        }

        override protected function focusOutHandler(_arg_1:FocusEvent):void
        {
            if (_arg_1.eventPhase == 3)
            {
                setValue(Number(inputField.text));
            };
            super.focusOutHandler(_arg_1);
        }

        override protected function draw():void
        {
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))
            {
                setStyles();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE))
            {
                drawLayout();
            };
            if (((isFocused) && (focusManager.showFocusIndicator)))
            {
                drawFocus(true);
            };
            validate();
        }

        protected function drawLayout():void
        {
            var _local_1:Number;
            _local_1 = (width - upArrow.width);
            var _local_2:Number = (height / 2);
            inputField.setSize(_local_1, height);
            upArrow.height = _local_2;
            downArrow.height = Math.floor(_local_2);
            downArrow.move(_local_1, _local_2);
            upArrow.move(_local_1, 0);
            downArrow.drawNow();
            upArrow.drawNow();
            inputField.drawNow();
        }

        protected function onTextChange(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
        }

        protected function passEvent(_arg_1:Event):void
        {
            dispatchEvent(_arg_1);
        }

        override public function setFocus():void
        {
            if (stage)
            {
                stage.focus = inputField.textField;
            };
        }

        override protected function isOurFocus(_arg_1:DisplayObject):Boolean
        {
            return ((_arg_1 == inputField) || (super.isOurFocus(_arg_1)));
        }

        protected function setStyles():void
        {
            copyStylesToChild(downArrow, DOWN_ARROW_STYLES);
            copyStylesToChild(upArrow, UP_ARROW_STYLES);
            copyStylesToChild(inputField, TEXT_INPUT_STYLES);
        }

        protected function inRange(_arg_1:Number):Boolean
        {
            return ((_arg_1 >= _minimum) && (_arg_1 <= _maximum));
        }

        protected function inStep(_arg_1:Number):Boolean
        {
            return (((_arg_1 - _minimum) % _stepSize) == 0);
        }

        protected function getValidValue(_arg_1:Number):Number
        {
            if (isNaN(_arg_1))
            {
                return (_value);
            };
            var _local_2:Number = Number((_stepSize * Math.round((_arg_1 / _stepSize))).toFixed(_precision));
            if (_local_2 > maximum)
            {
                return (maximum);
            };
            if (_local_2 < minimum)
            {
                return (minimum);
            };
            return (_local_2);
        }

        protected function getPrecision():Number
        {
            var _local_1:String = _stepSize.toString();
            if (_local_1.indexOf(".") == -1)
            {
                return (0);
            };
            return (_local_1.split(".").pop().length);
        }


    }
}//package fl.controls

