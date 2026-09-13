// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.controls.ColorPicker

package fl.controls
{
    import fl.core.UIComponent;
    import fl.managers.IFocusManagerComponent;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    import fl.core.InvalidationType;
    import fl.managers.IFocusManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.text.TextFieldType;
    import flash.ui.Keyboard;
    import fl.events.ColorPickerEvent;
    import flash.events.KeyboardEvent;
    import flash.display.Graphics;
    import flash.events.FocusEvent;

    public class ColorPicker extends UIComponent implements IFocusManagerComponent 
    {

        public static var defaultColors:Array;
        private static var defaultStyles:Object = {
            "upSkin":"ColorPicker_upSkin",
            "disabledSkin":"ColorPicker_disabledSkin",
            "overSkin":"ColorPicker_overSkin",
            "downSkin":"ColorPicker_downSkin",
            "colorWell":"ColorPicker_colorWell",
            "swatchSkin":"ColorPicker_swatchSkin",
            "swatchSelectedSkin":"ColorPicker_swatchSelectedSkin",
            "swatchWidth":10,
            "swatchHeight":10,
            "columnCount":18,
            "swatchPadding":1,
            "textFieldSkin":"ColorPicker_textFieldSkin",
            "textFieldWidth":null,
            "textFieldHeight":null,
            "textPadding":3,
            "background":"ColorPicker_backgroundSkin",
            "backgroundPadding":5,
            "textFormat":null,
            "focusRectSkin":null,
            "focusRectPadding":null,
            "embedFonts":false
        };
        protected static const POPUP_BUTTON_STYLES:Object = {
            "disabledSkin":"disabledSkin",
            "downSkin":"downSkin",
            "overSkin":"overSkin",
            "upSkin":"upSkin"
        };
        protected static const SWATCH_STYLES:Object = {
            "disabledSkin":"swatchSkin",
            "downSkin":"swatchSkin",
            "overSkin":"swatchSkin",
            "upSkin":"swatchSkin"
        };

        public var textField:TextField;
        protected var customColors:Array;
        protected var colorHash:Object;
        protected var paletteBG:DisplayObject;
        protected var selectedSwatch:Sprite;
        protected var _selectedColor:uint;
        protected var rollOverColor:int = -1;
        protected var _editable:Boolean = true;
        protected var _showTextField:Boolean = true;
        protected var isOpen:Boolean = false;
        protected var doOpen:Boolean = false;
        protected var swatchButton:BaseButton;
        protected var colorWell:DisplayObject;
        protected var swatchSelectedSkin:DisplayObject;
        protected var palette:Sprite;
        protected var textFieldBG:DisplayObject;
        protected var swatches:Sprite;
        protected var swatchMap:Array;
        protected var currRowIndex:int;
        protected var currColIndex:int;


        public static function getStyleDefinition():Object
        {
            return (defaultStyles);
        }


        public function get selectedColor():uint
        {
            if (colorWell == null)
            {
                return (0);
            };
            return (colorWell.transform.colorTransform.color);
        }

        public function set selectedColor(_arg_1:uint):void
        {
            if (!_enabled)
            {
                return;
            };
            _selectedColor = _arg_1;
            rollOverColor = -1;
            currColIndex = (currRowIndex = 0);
            var _local_2:ColorTransform = new ColorTransform();
            _local_2.color = _arg_1;
            setColorWellColor(_local_2);
            invalidate(InvalidationType.DATA);
        }

        public function get hexValue():String
        {
            if (colorWell == null)
            {
                return (colorToString(0));
            };
            return (colorToString(colorWell.transform.colorTransform.color));
        }

        override public function get enabled():Boolean
        {
            return (super.enabled);
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            super.enabled = _arg_1;
            if (!_arg_1)
            {
                close();
            };
            swatchButton.enabled = _arg_1;
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

        public function get showTextField():Boolean
        {
            return (_showTextField);
        }

        public function set showTextField(_arg_1:Boolean):void
        {
            invalidate(InvalidationType.STYLES);
            _showTextField = _arg_1;
        }

        public function get colors():Array
        {
            return ((customColors != null) ? customColors : ColorPicker.defaultColors);
        }

        public function set colors(_arg_1:Array):void
        {
            customColors = _arg_1;
            invalidate(InvalidationType.DATA);
        }

        public function get imeMode():String
        {
            return (_imeMode);
        }

        public function set imeMode(_arg_1:String):void
        {
            _imeMode = _arg_1;
        }

        public function open():void
        {
            if (!_enabled)
            {
                return;
            };
            doOpen = true;
            var _local_1:IFocusManager = focusManager;
            if (_local_1)
            {
                _local_1.defaultButtonEnabled = false;
            };
            invalidate(InvalidationType.STATE);
        }

        public function close():void
        {
            if (isOpen)
            {
                focusManager.form.removeChild(palette);
                isOpen = false;
                dispatchEvent(new Event(Event.CLOSE));
            };
            var _local_1:IFocusManager = focusManager;
            if (_local_1)
            {
                _local_1.defaultButtonEnabled = true;
            };
            removeStageListener();
            cleanUpSelected();
        }

        private function addCloseListener(_arg_1:Event):*
        {
            removeEventListener(Event.ENTER_FRAME, addCloseListener);
            if (!isOpen)
            {
                return;
            };
            addStageListener();
        }

        protected function onStageClick(_arg_1:MouseEvent):void
        {
            if (((!(contains((_arg_1.target as DisplayObject)))) && (!(palette.contains((_arg_1.target as DisplayObject))))))
            {
                selectedColor = _selectedColor;
                close();
            };
        }

        protected function setStyles():void
        {
            var _local_1:DisplayObject = colorWell;
            var _local_2:Object = getStyleValue("colorWell");
            if (_local_2 != null)
            {
                colorWell = (getDisplayObjectInstance(_local_2) as DisplayObject);
            };
            addChildAt(colorWell, getChildIndex(swatchButton));
            copyStylesToChild(swatchButton, POPUP_BUTTON_STYLES);
            swatchButton.drawNow();
            if ((((!(_local_1 == null)) && (contains(_local_1))) && (!(_local_1 == colorWell))))
            {
                removeChild(_local_1);
            };
        }

        protected function cleanUpSelected():void
        {
            if (((swatchSelectedSkin) && (palette.contains(swatchSelectedSkin))))
            {
                palette.removeChild(swatchSelectedSkin);
            };
        }

        protected function onPopupButtonClick(_arg_1:MouseEvent):void
        {
            if (isOpen)
            {
                close();
            }
            else
            {
                open();
            };
        }

        override protected function draw():void
        {
            if (isInvalid(InvalidationType.STYLES, InvalidationType.DATA))
            {
                setStyles();
                drawPalette();
                setEmbedFonts();
                invalidate(InvalidationType.DATA, false);
                invalidate(InvalidationType.STYLES, false);
            };
            if (isInvalid(InvalidationType.DATA))
            {
                drawSwatchHighlight();
                setColorDisplay();
            };
            if (isInvalid(InvalidationType.STATE))
            {
                setTextEditable();
                if (doOpen)
                {
                    doOpen = false;
                    showPalette();
                };
                colorWell.visible = enabled;
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
            {
                swatchButton.setSize(width, height);
                swatchButton.drawNow();
                colorWell.width = width;
                colorWell.height = height;
            };
            super.draw();
        }

        protected function showPalette():void
        {
            if (isOpen)
            {
                positionPalette();
                return;
            };
            addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);
            focusManager.form.addChild(palette);
            isOpen = true;
            positionPalette();
            dispatchEvent(new Event(Event.OPEN));
            stage.focus = textField;
            var _local_1:Sprite = selectedSwatch;
            if (_local_1 == null)
            {
                _local_1 = findSwatch(_selectedColor);
            };
            setSwatchHighlight(_local_1);
        }

        protected function setEmbedFonts():void
        {
            var _local_1:Object = getStyleValue("embedFonts");
            if (_local_1 != null)
            {
                textField.embedFonts = _local_1;
            };
        }

        protected function drawSwatchHighlight():void
        {
            cleanUpSelected();
            var _local_1:Object = getStyleValue("swatchSelectedSkin");
            var _local_2:Number = (getStyleValue("swatchPadding") as Number);
            if (_local_1 != null)
            {
                swatchSelectedSkin = getDisplayObjectInstance(_local_1);
                swatchSelectedSkin.x = 0;
                swatchSelectedSkin.y = 0;
                swatchSelectedSkin.width = ((getStyleValue("swatchWidth") as Number) + 2);
                swatchSelectedSkin.height = ((getStyleValue("swatchHeight") as Number) + 2);
            };
        }

        protected function drawPalette():void
        {
            if (isOpen)
            {
                focusManager.form.removeChild(palette);
            };
            palette = new Sprite();
            drawTextField();
            drawSwatches();
            drawBG();
        }

        protected function drawTextField():void
        {
            if (!showTextField)
            {
                return;
            };
            var _local_1:Number = (getStyleValue("backgroundPadding") as Number);
            var _local_2:Number = (getStyleValue("textPadding") as Number);
            textFieldBG = getDisplayObjectInstance(getStyleValue("textFieldSkin"));
            if (textFieldBG != null)
            {
                palette.addChild(textFieldBG);
                textFieldBG.x = (textFieldBG.y = _local_1);
            };
            var _local_3:Object = UIComponent.getStyleDefinition();
            var _local_4:TextFormat = ((enabled) ? (_local_3.defaultTextFormat as TextFormat) : (_local_3.defaultDisabledTextFormat as TextFormat));
            textField.setTextFormat(_local_4);
            var _local_5:TextFormat = (getStyleValue("textFormat") as TextFormat);
            if (_local_5 != null)
            {
                textField.setTextFormat(_local_5);
            }
            else
            {
                _local_5 = _local_4;
            };
            textField.defaultTextFormat = _local_5;
            setEmbedFonts();
            textField.restrict = "A-Fa-f0-9#";
            textField.maxChars = 6;
            palette.addChild(textField);
            textField.text = " #888888 ";
            textField.height = (textField.textHeight + 3);
            textField.width = (textField.textWidth + 3);
            textField.text = "";
            textField.x = (textField.y = (_local_1 + _local_2));
            textFieldBG.width = (textField.width + (_local_2 * 2));
            textFieldBG.height = (textField.height + (_local_2 * 2));
            setTextEditable();
        }

        protected function drawSwatches():void
        {
            var _local_10:Sprite;
            var _local_1:Number = (getStyleValue("backgroundPadding") as Number);
            var _local_2:Number = ((showTextField) ? ((textFieldBG.y + textFieldBG.height) + _local_1) : _local_1);
            swatches = new Sprite();
            palette.addChild(swatches);
            swatches.x = _local_1;
            swatches.y = _local_2;
            var _local_3:uint = (getStyleValue("columnCount") as uint);
            var _local_4:uint = (getStyleValue("swatchPadding") as uint);
            var _local_5:Number = (getStyleValue("swatchWidth") as Number);
            var _local_6:Number = (getStyleValue("swatchHeight") as Number);
            colorHash = {};
            swatchMap = [];
            var _local_7:uint = Math.min(0x0400, colors.length);
            var _local_8:int = -1;
            var _local_9:uint;
            while (_local_9 < _local_7)
            {
                _local_10 = createSwatch(colors[_local_9]);
                _local_10.x = ((_local_5 + _local_4) * (_local_9 % _local_3));
                if (_local_10.x == 0)
                {
                    swatchMap.push([_local_10]);
                    _local_8++;
                }
                else
                {
                    swatchMap[_local_8].push(_local_10);
                };
                colorHash[colors[_local_9]] = {
                    "swatch":_local_10,
                    "row":_local_8,
                    "col":(swatchMap[_local_8].length - 1)
                };
                _local_10.y = (Math.floor((_local_9 / _local_3)) * (_local_6 + _local_4));
                swatches.addChild(_local_10);
                _local_9++;
            };
        }

        protected function drawBG():void
        {
            var _local_1:Object = getStyleValue("background");
            if (_local_1 != null)
            {
                paletteBG = (getDisplayObjectInstance(_local_1) as Sprite);
            };
            if (paletteBG == null)
            {
                return;
            };
            var _local_2:Number = Number(getStyleValue("backgroundPadding"));
            paletteBG.width = (Math.max(((showTextField) ? textFieldBG.width : 0), swatches.width) + (_local_2 * 2));
            paletteBG.height = ((swatches.y + swatches.height) + _local_2);
            palette.addChildAt(paletteBG, 0);
        }

        protected function positionPalette():void
        {
            var myForm:DisplayObjectContainer;
            var theStageHeight:Number;
            var theStageWidth:Number;
            var p:Point = swatchButton.localToGlobal(new Point(0, 0));
            myForm = focusManager.form;
            p = myForm.globalToLocal(p);
            var padding:Number = (getStyleValue("backgroundPadding") as Number);
            try
            {
                theStageHeight = stage.stageHeight;
                theStageWidth = stage.stageWidth;
            }
            catch(se:SecurityError)
            {
                theStageHeight = myForm.height;
                theStageWidth = myForm.width;
            };
            if ((p.x + palette.width) > theStageWidth)
            {
                palette.x = ((p.x - palette.width) << 0);
            }
            else
            {
                palette.x = (((p.x + swatchButton.width) + padding) << 0);
            };
            palette.y = (Math.max(0, Math.min(p.y, (theStageHeight - palette.height))) << 0);
        }

        protected function setTextEditable():void
        {
            if (!showTextField)
            {
                return;
            };
            textField.type = ((editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            textField.selectable = editable;
        }

        override protected function keyUpHandler(_arg_1:KeyboardEvent):void
        {
            var _local_2:uint;
            var _local_4:String;
            var _local_5:Sprite;
            if (!isOpen)
            {
                return;
            };
            var _local_3:ColorTransform = new ColorTransform();
            if (((editable) && (showTextField)))
            {
                _local_4 = textField.text;
                if (_local_4.indexOf("#") > -1)
                {
                    _local_4 = _local_4.replace(/^\s+|\s+$/g, "");
                    _local_4 = _local_4.replace(/#/g, "");
                };
                _local_2 = parseInt(_local_4, 16);
                _local_5 = findSwatch(_local_2);
                setSwatchHighlight(_local_5);
                _local_3.color = _local_2;
                setColorWellColor(_local_3);
            }
            else
            {
                _local_2 = rollOverColor;
                _local_3.color = _local_2;
            };
            if (_arg_1.keyCode != Keyboard.ENTER)
            {
                return;
            };
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ENTER, _local_2));
            _selectedColor = rollOverColor;
            setColorText(_local_3.color);
            rollOverColor = _local_3.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
        }

        protected function positionTextField():void
        {
            if (!showTextField)
            {
                return;
            };
            var _local_1:Number = (getStyleValue("backgroundPadding") as Number);
            var _local_2:Number = (getStyleValue("textPadding") as Number);
            textFieldBG.x = (paletteBG.x + _local_1);
            textFieldBG.y = (paletteBG.y + _local_1);
            textField.x = (textFieldBG.x + _local_2);
            textField.y = (textFieldBG.y + _local_2);
        }

        protected function setColorDisplay():void
        {
            if (!swatchMap.length)
            {
                return;
            };
            var _local_1:ColorTransform = new ColorTransform(0, 0, 0, 1, (_selectedColor >> 16), ((_selectedColor >> 8) & 0xFF), (_selectedColor & 0xFF), 0);
            setColorWellColor(_local_1);
            setColorText(_selectedColor);
            var _local_2:Sprite = findSwatch(_selectedColor);
            setSwatchHighlight(_local_2);
            if (((swatchMap.length) && (colorHash[_selectedColor] == undefined)))
            {
                cleanUpSelected();
            };
        }

        protected function setSwatchHighlight(_arg_1:Sprite):void
        {
            if (_arg_1 == null)
            {
                if (palette.contains(swatchSelectedSkin))
                {
                    palette.removeChild(swatchSelectedSkin);
                };
                return;
            };
            if (((!(palette.contains(swatchSelectedSkin))) && (colors.length > 0)))
            {
                palette.addChild(swatchSelectedSkin);
            }
            else
            {
                if (!colors.length)
                {
                    return;
                };
            };
            var _local_2:Number = (getStyleValue("swatchPadding") as Number);
            palette.setChildIndex(swatchSelectedSkin, (palette.numChildren - 1));
            swatchSelectedSkin.x = ((swatches.x + _arg_1.x) - 1);
            swatchSelectedSkin.y = ((swatches.y + _arg_1.y) - 1);
            var _local_3:* = _arg_1.getChildByName("color").transform.colorTransform.color;
            currColIndex = colorHash[_local_3].col;
            currRowIndex = colorHash[_local_3].row;
        }

        protected function findSwatch(_arg_1:uint):Sprite
        {
            if (!swatchMap.length)
            {
                return (null);
            };
            var _local_2:Object = colorHash[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2.swatch);
            };
            return (null);
        }

        protected function onSwatchClick(_arg_1:MouseEvent):void
        {
            var _local_2:ColorTransform = _arg_1.target.getChildByName("color").transform.colorTransform;
            _selectedColor = _local_2.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
        }

        protected function onSwatchOver(_arg_1:MouseEvent):void
        {
            var _local_2:BaseButton = (_arg_1.target.getChildByName("color") as BaseButton);
            var _local_3:ColorTransform = _local_2.transform.colorTransform;
            setColorWellColor(_local_3);
            setSwatchHighlight((_arg_1.target as Sprite));
            setColorText(_local_3.color);
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER, _local_3.color));
        }

        protected function onSwatchOut(_arg_1:MouseEvent):void
        {
            var _local_2:ColorTransform = _arg_1.target.transform.colorTransform;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT, _local_2.color));
        }

        protected function setColorText(_arg_1:uint):void
        {
            if (textField == null)
            {
                return;
            };
            textField.text = ("#" + colorToString(_arg_1));
        }

        protected function colorToString(_arg_1:uint):String
        {
            var _local_2:String = _arg_1.toString(16);
            while (_local_2.length < 6)
            {
                _local_2 = ("0" + _local_2);
            };
            return (_local_2);
        }

        protected function setColorWellColor(_arg_1:ColorTransform):void
        {
            if (!colorWell)
            {
                return;
            };
            colorWell.transform.colorTransform = _arg_1;
        }

        protected function createSwatch(_arg_1:uint):Sprite
        {
            var _local_2:Sprite = new Sprite();
            var _local_3:BaseButton = new BaseButton();
            _local_3.focusEnabled = false;
            var _local_4:Number = (getStyleValue("swatchWidth") as Number);
            var _local_5:Number = (getStyleValue("swatchHeight") as Number);
            _local_3.setSize(_local_4, _local_5);
            _local_3.transform.colorTransform = new ColorTransform(0, 0, 0, 1, (_arg_1 >> 16), ((_arg_1 >> 8) & 0xFF), (_arg_1 & 0xFF), 0);
            copyStylesToChild(_local_3, SWATCH_STYLES);
            _local_3.mouseEnabled = false;
            _local_3.drawNow();
            _local_3.name = "color";
            _local_2.addChild(_local_3);
            var _local_6:Number = (getStyleValue("swatchPadding") as Number);
            var _local_7:Graphics = _local_2.graphics;
            _local_7.beginFill(0);
            _local_7.drawRect(-(_local_6), -(_local_6), (_local_4 + (_local_6 * 2)), (_local_5 + (_local_6 * 2)));
            _local_7.endFill();
            _local_2.addEventListener(MouseEvent.CLICK, onSwatchClick, false, 0, true);
            _local_2.addEventListener(MouseEvent.MOUSE_OVER, onSwatchOver, false, 0, true);
            _local_2.addEventListener(MouseEvent.MOUSE_OUT, onSwatchOut, false, 0, true);
            return (_local_2);
        }

        protected function addStageListener(_arg_1:Event=null):void
        {
            focusManager.form.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
        }

        protected function removeStageListener(_arg_1:Event=null):void
        {
            focusManager.form.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false);
        }

        override protected function focusInHandler(_arg_1:FocusEvent):void
        {
            super.focusInHandler(_arg_1);
            setIMEMode(true);
        }

        override protected function focusOutHandler(_arg_1:FocusEvent):void
        {
            if (_arg_1.relatedObject == textField)
            {
                setFocus();
                return;
            };
            if (isOpen)
            {
                close();
            };
            super.focusOutHandler(_arg_1);
            setIMEMode(false);
        }

        override protected function isOurFocus(_arg_1:DisplayObject):Boolean
        {
            return ((_arg_1 == textField) || (super.isOurFocus(_arg_1)));
        }

        override protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            var _local_3:Sprite;
            switch (_arg_1.keyCode)
            {
                case Keyboard.SHIFT:
                case Keyboard.CONTROL:
                    return;
            };
            if (_arg_1.ctrlKey)
            {
                switch (_arg_1.keyCode)
                {
                    case Keyboard.DOWN:
                        open();
                        return;
                    case Keyboard.UP:
                        close();
                        return;
                };
                return;
            };
            if (!isOpen)
            {
                switch (_arg_1.keyCode)
                {
                    case Keyboard.UP:
                    case Keyboard.DOWN:
                    case Keyboard.LEFT:
                    case Keyboard.RIGHT:
                    case Keyboard.SPACE:
                        open();
                        return;
                };
            };
            textField.maxChars = (((_arg_1.keyCode == "#".charCodeAt(0)) || (textField.text.indexOf("#") > -1)) ? 7 : 6);
            switch (_arg_1.keyCode)
            {
                case Keyboard.TAB:
                    _local_3 = findSwatch(_selectedColor);
                    setSwatchHighlight(_local_3);
                    return;
                case Keyboard.HOME:
                    currColIndex = (currRowIndex = 0);
                    break;
                case Keyboard.END:
                    currColIndex = (swatchMap[(swatchMap.length - 1)].length - 1);
                    currRowIndex = (swatchMap.length - 1);
                    break;
                case Keyboard.PAGE_DOWN:
                    currRowIndex = (swatchMap.length - 1);
                    break;
                case Keyboard.PAGE_UP:
                    currRowIndex = 0;
                    break;
                case Keyboard.ESCAPE:
                    if (isOpen)
                    {
                        selectedColor = _selectedColor;
                    };
                    close();
                    return;
                case Keyboard.ENTER:
                    return;
                case Keyboard.UP:
                    currRowIndex = Math.max(-1, (currRowIndex - 1));
                    if (currRowIndex == -1)
                    {
                        currRowIndex = (swatchMap.length - 1);
                    };
                    break;
                case Keyboard.DOWN:
                    currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                    if (currRowIndex == swatchMap.length)
                    {
                        currRowIndex = 0;
                    };
                    break;
                case Keyboard.RIGHT:
                    currColIndex = Math.min(swatchMap[currRowIndex].length, (currColIndex + 1));
                    if (currColIndex == swatchMap[currRowIndex].length)
                    {
                        currColIndex = 0;
                        currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                        if (currRowIndex == swatchMap.length)
                        {
                            currRowIndex = 0;
                        };
                    };
                    break;
                case Keyboard.LEFT:
                    currColIndex = Math.max(-1, (currColIndex - 1));
                    if (currColIndex == -1)
                    {
                        currColIndex = (swatchMap[currRowIndex].length - 1);
                        currRowIndex = Math.max(-1, (currRowIndex - 1));
                        if (currRowIndex == -1)
                        {
                            currRowIndex = (swatchMap.length - 1);
                        };
                    };
                    break;
                default:
                    return;
            };
            var _local_2:ColorTransform = swatchMap[currRowIndex][currColIndex].getChildByName("color").transform.colorTransform;
            rollOverColor = _local_2.color;
            setColorWellColor(_local_2);
            setSwatchHighlight(swatchMap[currRowIndex][currColIndex]);
            setColorText(_local_2.color);
        }

        override protected function configUI():void
        {
            var _local_1:uint;
            super.configUI();
            tabChildren = false;
            if (ColorPicker.defaultColors == null)
            {
                ColorPicker.defaultColors = [];
                _local_1 = 0;
                while (_local_1 < 216)
                {
                    ColorPicker.defaultColors.push(((((((((_local_1 / 6) % 3) << 0) + (((_local_1 / 108) << 0) * 3)) * 51) << 16) | (((_local_1 % 6) * 51) << 8)) | ((((_local_1 / 18) << 0) % 6) * 51)));
                    _local_1++;
                };
            };
            colorHash = {};
            swatchMap = [];
            textField = new TextField();
            textField.tabEnabled = false;
            swatchButton = new BaseButton();
            swatchButton.focusEnabled = false;
            swatchButton.useHandCursor = false;
            swatchButton.autoRepeat = false;
            swatchButton.setSize(25, 25);
            swatchButton.addEventListener(MouseEvent.CLICK, onPopupButtonClick, false, 0, true);
            addChild(swatchButton);
            palette = new Sprite();
            palette.tabChildren = false;
            palette.cacheAsBitmap = true;
        }


    }
}//package fl.controls

