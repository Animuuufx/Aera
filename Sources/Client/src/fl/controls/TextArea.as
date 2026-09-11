// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.controls.TextArea

package fl.controls
{
    import fl.core.UIComponent;
    import fl.managers.IFocusManagerComponent;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import fl.core.InvalidationType;
    import flash.system.IME;
    import flash.text.TextLineMetrics;
    import fl.events.ScrollEvent;
    import flash.events.TextEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextFieldType;
    import flash.ui.Keyboard;
    import fl.events.ComponentEvent;
    import flash.text.TextFormat;
    import fl.managers.IFocusManager;
    import flash.events.FocusEvent;

    public class TextArea extends UIComponent implements IFocusManagerComponent 
    {

        private static var defaultStyles:Object = {
            "upSkin":"TextArea_upSkin",
            "disabledSkin":"TextArea_disabledSkin",
            "focusRectSkin":null,
            "focusRectPadding":null,
            "textFormat":null,
            "disabledTextFormat":null,
            "textPadding":3,
            "embedFonts":false
        };
        protected static const SCROLL_BAR_STYLES:Object = {
            "downArrowDisabledSkin":"downArrowDisabledSkin",
            "downArrowDownSkin":"downArrowDownSkin",
            "downArrowOverSkin":"downArrowOverSkin",
            "downArrowUpSkin":"downArrowUpSkin",
            "upArrowDisabledSkin":"upArrowDisabledSkin",
            "upArrowDownSkin":"upArrowDownSkin",
            "upArrowOverSkin":"upArrowOverSkin",
            "upArrowUpSkin":"upArrowUpSkin",
            "thumbDisabledSkin":"thumbDisabledSkin",
            "thumbDownSkin":"thumbDownSkin",
            "thumbOverSkin":"thumbOverSkin",
            "thumbUpSkin":"thumbUpSkin",
            "thumbIcon":"thumbIcon",
            "trackDisabledSkin":"trackDisabledSkin",
            "trackDownSkin":"trackDownSkin",
            "trackOverSkin":"trackOverSkin",
            "trackUpSkin":"trackUpSkin",
            "repeatDelay":"repeatDelay",
            "repeatInterval":"repeatInterval"
        };
        public static var createAccessibilityImplementation:Function;

        public var textField:TextField;
        protected var _editable:Boolean = true;
        protected var _wordWrap:Boolean = true;
        protected var _horizontalScrollPolicy:String = "auto";
        protected var _verticalScrollPolicy:String = "auto";
        protected var _horizontalScrollBar:UIScrollBar;
        protected var _verticalScrollBar:UIScrollBar;
        protected var background:DisplayObject;
        protected var _html:Boolean = false;
        protected var _savedHTML:String;
        protected var textHasChanged:Boolean = false;


        public static function getStyleDefinition():Object
        {
            return (UIComponent.mergeStyles(defaultStyles, ScrollBar.getStyleDefinition()));
        }


        public function get horizontalScrollBar():UIScrollBar
        {
            return (_horizontalScrollBar);
        }

        public function get verticalScrollBar():UIScrollBar
        {
            return (_verticalScrollBar);
        }

        override public function get enabled():Boolean
        {
            return (super.enabled);
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            super.enabled = _arg_1;
            mouseChildren = enabled;
            invalidate(InvalidationType.STATE);
        }

        public function get text():String
        {
            return (textField.text);
        }

        public function set text(_arg_1:String):void
        {
            if (((componentInspectorSetting) && (_arg_1 == "")))
            {
                return;
            };
            textField.text = _arg_1;
            _html = false;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
            textHasChanged = true;
        }

        public function get htmlText():String
        {
            return (textField.htmlText);
        }

        public function set htmlText(_arg_1:String):void
        {
            if (((componentInspectorSetting) && (_arg_1 == "")))
            {
                return;
            };
            if (_arg_1 == "")
            {
                text = "";
                return;
            };
            _html = true;
            _savedHTML = _arg_1;
            textField.htmlText = _arg_1;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
            textHasChanged = true;
        }

        public function get condenseWhite():Boolean
        {
            return (textField.condenseWhite);
        }

        public function set condenseWhite(_arg_1:Boolean):void
        {
            textField.condenseWhite = _arg_1;
            invalidate(InvalidationType.DATA);
        }

        public function get horizontalScrollPolicy():String
        {
            return (_horizontalScrollPolicy);
        }

        public function set horizontalScrollPolicy(_arg_1:String):void
        {
            _horizontalScrollPolicy = _arg_1;
            invalidate(InvalidationType.SIZE);
        }

        public function get verticalScrollPolicy():String
        {
            return (_verticalScrollPolicy);
        }

        public function set verticalScrollPolicy(_arg_1:String):void
        {
            _verticalScrollPolicy = _arg_1;
            invalidate(InvalidationType.SIZE);
        }

        public function get horizontalScrollPosition():Number
        {
            return (textField.scrollH);
        }

        public function set horizontalScrollPosition(_arg_1:Number):void
        {
            drawNow();
            textField.scrollH = _arg_1;
        }

        public function get verticalScrollPosition():Number
        {
            return (textField.scrollV);
        }

        public function set verticalScrollPosition(_arg_1:Number):void
        {
            drawNow();
            textField.scrollV = _arg_1;
        }

        public function get textWidth():Number
        {
            drawNow();
            return (textField.textWidth);
        }

        public function get textHeight():Number
        {
            drawNow();
            return (textField.textHeight);
        }

        public function get length():Number
        {
            return (textField.text.length);
        }

        public function get restrict():String
        {
            return (textField.restrict);
        }

        public function set restrict(_arg_1:String):void
        {
            if (((componentInspectorSetting) && (_arg_1 == "")))
            {
                _arg_1 = null;
            };
            textField.restrict = _arg_1;
        }

        public function get maxChars():int
        {
            return (textField.maxChars);
        }

        public function set maxChars(_arg_1:int):void
        {
            textField.maxChars = _arg_1;
        }

        public function get maxHorizontalScrollPosition():int
        {
            return (textField.maxScrollH);
        }

        public function get maxVerticalScrollPosition():int
        {
            return (textField.maxScrollV);
        }

        public function get wordWrap():Boolean
        {
            return (_wordWrap);
        }

        public function set wordWrap(_arg_1:Boolean):void
        {
            _wordWrap = _arg_1;
            invalidate(InvalidationType.STATE);
        }

        public function get selectionBeginIndex():int
        {
            return (textField.selectionBeginIndex);
        }

        public function get selectionEndIndex():int
        {
            return (textField.selectionEndIndex);
        }

        public function get displayAsPassword():Boolean
        {
            return (textField.displayAsPassword);
        }

        public function set displayAsPassword(_arg_1:Boolean):void
        {
            textField.displayAsPassword = _arg_1;
        }

        public function get editable():Boolean
        {
            return (_editable);
        }

        public function set editable(_arg_1:Boolean):void
        {
            _editable = _arg_1;
            invalidate(InvalidationType.STATE);
        }

        public function get imeMode():String
        {
            return (IME.conversionMode);
        }

        public function set imeMode(_arg_1:String):void
        {
            _imeMode = _arg_1;
        }

        public function get alwaysShowSelection():Boolean
        {
            return (textField.alwaysShowSelection);
        }

        public function set alwaysShowSelection(_arg_1:Boolean):void
        {
            textField.alwaysShowSelection = _arg_1;
        }

        override public function drawFocus(_arg_1:Boolean):void
        {
            if (focusTarget != null)
            {
                focusTarget.drawFocus(_arg_1);
                return;
            };
            super.drawFocus(_arg_1);
        }

        public function getLineMetrics(_arg_1:int):TextLineMetrics
        {
            return (textField.getLineMetrics(_arg_1));
        }

        public function setSelection(_arg_1:int, _arg_2:int):void
        {
            textField.setSelection(_arg_1, _arg_2);
        }

        public function appendText(_arg_1:String):void
        {
            textField.appendText(_arg_1);
            invalidate(InvalidationType.DATA);
        }

        override protected function configUI():void
        {
            super.configUI();
            tabChildren = true;
            textField = new TextField();
            addChild(textField);
            updateTextFieldType();
            _verticalScrollBar = new UIScrollBar();
            _verticalScrollBar.name = "V";
            _verticalScrollBar.visible = false;
            _verticalScrollBar.focusEnabled = false;
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            _verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_verticalScrollBar);
            _horizontalScrollBar = new UIScrollBar();
            _horizontalScrollBar.name = "H";
            _horizontalScrollBar.visible = false;
            _horizontalScrollBar.focusEnabled = false;
            _horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
            _horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_horizontalScrollBar);
            textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
            textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
            textField.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
            _horizontalScrollBar.scrollTarget = textField;
            _verticalScrollBar.scrollTarget = textField;
            addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
        }

        protected function updateTextFieldType():void
        {
            textField.type = (((enabled) && (_editable)) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            textField.selectable = enabled;
            textField.wordWrap = _wordWrap;
            textField.multiline = true;
        }

        protected function handleKeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                dispatchEvent(new ComponentEvent(ComponentEvent.ENTER, true));
            };
        }

        protected function handleChange(_arg_1:Event):void
        {
            _arg_1.stopPropagation();
            dispatchEvent(new Event(Event.CHANGE, true));
            invalidate(InvalidationType.DATA);
        }

        protected function handleTextInput(_arg_1:TextEvent):void
        {
            _arg_1.stopPropagation();
            dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, true, false, _arg_1.text));
        }

        protected function handleScroll(_arg_1:ScrollEvent):void
        {
            dispatchEvent(_arg_1);
        }

        protected function handleWheel(_arg_1:MouseEvent):void
        {
            if (((!(enabled)) || (!(_verticalScrollBar.visible))))
            {
                return;
            };
            _verticalScrollBar.scrollPosition = (_verticalScrollBar.scrollPosition - (_arg_1.delta * _verticalScrollBar.lineScrollSize));
            dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, (_arg_1.delta * _verticalScrollBar.lineScrollSize), _verticalScrollBar.scrollPosition));
        }

        protected function setEmbedFont():*
        {
            var _local_1:Object = getStyleValue("embedFonts");
            if (_local_1 != null)
            {
                textField.embedFonts = _local_1;
            };
        }

        override protected function draw():void
        {
            if (isInvalid(InvalidationType.STATE))
            {
                updateTextFieldType();
            };
            if (isInvalid(InvalidationType.STYLES))
            {
                setStyles();
                setEmbedFont();
            };
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))
            {
                drawTextFormat();
                drawBackground();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.DATA))
            {
                drawLayout();
            };
            super.draw();
        }

        protected function setStyles():void
        {
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
        }

        protected function drawTextFormat():void
        {
            var _local_1:Object = UIComponent.getStyleDefinition();
            var _local_2:TextFormat = ((enabled) ? (_local_1.defaultTextFormat as TextFormat) : (_local_1.defaultDisabledTextFormat as TextFormat));
            textField.setTextFormat(_local_2);
            var _local_3:TextFormat = (getStyleValue(((enabled) ? "textFormat" : "disabledTextFormat")) as TextFormat);
            if (_local_3 != null)
            {
                textField.setTextFormat(_local_3);
            }
            else
            {
                _local_3 = _local_2;
            };
            textField.defaultTextFormat = _local_3;
            setEmbedFont();
            if (_html)
            {
                textField.htmlText = _savedHTML;
            };
        }

        protected function drawBackground():void
        {
            var _local_1:DisplayObject = background;
            var _local_2:String = ((enabled) ? "upSkin" : "disabledSkin");
            background = getDisplayObjectInstance(getStyleValue(_local_2));
            if (background != null)
            {
                addChildAt(background, 0);
            };
            if ((((!(_local_1 == null)) && (!(_local_1 == background))) && (contains(_local_1))))
            {
                removeChild(_local_1);
            };
        }

        protected function drawLayout():void
        {
            var _local_1:Number = Number(getStyleValue("textPadding"));
            textField.x = (textField.y = _local_1);
            background.width = width;
            background.height = height;
            var _local_2:Number = height;
            var _local_3:Boolean = needVScroll();
            var _local_4:Number = (width - ((_local_3) ? _verticalScrollBar.width : 0));
            var _local_5:Boolean = needHScroll();
            if (_local_5)
            {
                _local_2 = (_local_2 - _horizontalScrollBar.height);
            };
            setTextSize(_local_4, _local_2, _local_1);
            if ((((_local_5) && (!(_local_3))) && (needVScroll())))
            {
                _local_3 = true;
                _local_4 = (_local_4 - _verticalScrollBar.width);
                setTextSize(_local_4, _local_2, _local_1);
            };
            if (_local_3)
            {
                _verticalScrollBar.visible = true;
                _verticalScrollBar.x = (width - _verticalScrollBar.width);
                _verticalScrollBar.height = _local_2;
                _verticalScrollBar.visible = true;
                _verticalScrollBar.enabled = enabled;
            }
            else
            {
                _verticalScrollBar.visible = false;
            };
            if (_local_5)
            {
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.y = (height - _horizontalScrollBar.height);
                _horizontalScrollBar.width = _local_4;
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.enabled = enabled;
            }
            else
            {
                _horizontalScrollBar.visible = false;
            };
            updateScrollBars();
            addEventListener(Event.ENTER_FRAME, delayedLayoutUpdate, false, 0, true);
        }

        protected function delayedLayoutUpdate(_arg_1:Event):void
        {
            if (textHasChanged)
            {
                textHasChanged = false;
                drawLayout();
                return;
            };
            removeEventListener(Event.ENTER_FRAME, delayedLayoutUpdate);
        }

        protected function updateScrollBars():*
        {
            _horizontalScrollBar.update();
            _verticalScrollBar.update();
            _verticalScrollBar.enabled = enabled;
            _horizontalScrollBar.enabled = enabled;
            _horizontalScrollBar.drawNow();
            _verticalScrollBar.drawNow();
        }

        protected function needVScroll():Boolean
        {
            if (_verticalScrollPolicy == ScrollPolicy.OFF)
            {
                return (false);
            };
            if (_verticalScrollPolicy == ScrollPolicy.ON)
            {
                return (true);
            };
            return (textField.maxScrollV > 1);
        }

        protected function needHScroll():Boolean
        {
            if (_horizontalScrollPolicy == ScrollPolicy.OFF)
            {
                return (false);
            };
            if (_horizontalScrollPolicy == ScrollPolicy.ON)
            {
                return (true);
            };
            return (textField.maxScrollH > 0);
        }

        protected function setTextSize(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:Number = (_arg_1 - (_arg_3 * 2));
            var _local_5:Number = (_arg_2 - (_arg_3 * 2));
            if (_local_4 != textField.width)
            {
                textField.width = _local_4;
            };
            if (_local_5 != textField.height)
            {
                textField.height = _local_5;
            };
        }

        override protected function isOurFocus(_arg_1:DisplayObject):Boolean
        {
            return ((_arg_1 == textField) || (super.isOurFocus(_arg_1)));
        }

        override protected function focusInHandler(_arg_1:FocusEvent):void
        {
            setIMEMode(true);
            if (_arg_1.target == this)
            {
                stage.focus = textField;
            };
            var _local_2:IFocusManager = focusManager;
            if (_local_2)
            {
                if (editable)
                {
                    _local_2.showFocusIndicator = true;
                };
                _local_2.defaultButtonEnabled = false;
            };
            super.focusInHandler(_arg_1);
            if (editable)
            {
                setIMEMode(true);
            };
        }

        override protected function focusOutHandler(_arg_1:FocusEvent):void
        {
            var _local_2:IFocusManager = focusManager;
            if (_local_2)
            {
                _local_2.defaultButtonEnabled = true;
            };
            setSelection(0, 0);
            super.focusOutHandler(_arg_1);
            if (editable)
            {
                setIMEMode(false);
            };
        }


    }
}//package fl.controls

