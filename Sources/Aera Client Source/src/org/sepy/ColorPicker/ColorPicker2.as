// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.ColorPicker2

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import fl.motion.*;
    import flash.geom.*;

    public class ColorPicker2 extends MovieClip 
    {

        private static var ADV_PANEL_DEPTH:Number = 5;
        public static var version:String = "2.2";
        public static var DOWN_LEFT:String = "DL";
        public static var DOWN_RIGHT:String = "DR";
        public static var UP_LEFT:String = "UL";
        public static var UP_RIGHT:String = "UR";
        private static var MIN_WIDTH:Number = 130;

        public var cpicker:MovieClip;
        private var _colors:Array = new Array();
        private var _opening_color:Number;
        private var _color:Number;
        private var _direction:String;
        private var _columns:Number = 21;
        private var panel:MovieClip;
        private var _baseColors:Array;
        private var selectedColorMC:MovieClip;
        public var _opened:Boolean;
        private var _allowUserColor:Boolean;
        private var keyListener:Object;
        private var advancedColor:MovieClip;
        private var noColor:MovieClip;
        public var advancedColorPanel:MovieClip;
        private var _useAdvColors:Boolean;
        private var _useNoColor:Boolean;
        private var newMC:MovieClip;
        private var newClass:*;
        private var hover:Boolean = false;
        private var hoverColor:uint;
        public var m_fillType:String = "linear";
        public var m_colors:Array = [0xFF0000, 0xFFFF00, 0xFF00, 0xFFFF, 0xFF, 0xFF00FF, 0xFF0000];
        public var m_alphas:Array = [100, 100, 100, 100, 100, 100, 100];
        public var m_ratios:Array = [0, 42, 64, 127, 184, 215, 0xFF];
        public var m_matrix:Object = {
            "matrixType":"box",
            "x":0,
            "y":0,
            "w":175,
            "h":187,
            "r":0
        };

        public function ColorPicker2()
        {
            addFrameScript(0, frame1);
            _color = 0;
            _allowUserColor = true;
            _baseColors = [0xFF00FF, 0xFFFF, 0xFFFF00, 0xFF, 0xFF00, 0xFF0000, 0xFFFFFF, 0xCCCCCC, 0x999999, 0x666666, 0x333333, 0];
            _colors = this.getStandardColors();
            initComponent();
        }

        public static function ColorToString(_arg_1:Number):String
        {
            var _local_2:String = Math.abs(_arg_1).toString(16);
            while (_local_2.length < 6)
            {
                _local_2 = ("0" + _local_2);
            };
            return (_local_2.toUpperCase());
        }

        public static function StringToColor(_arg_1:String):Number
        {
            return (parseInt(_arg_1, 16));
        }

        public static function ColorToRGB(_arg_1:Number):Object
        {
            var _local_2:Object = new Object();
            _local_2.red = ((_arg_1 >> 16) & 0xFF);
            _local_2.green = ((_arg_1 >> 8) & 0xFF);
            _local_2.blue = (_arg_1 & 0xFF);
            return (_local_2);
        }


        private function initComponent():void
        {
            this.useHandCursor = false;
            this.cpicker.nocolor_face.visible = false;
            this.cpicker.addEventListener(MouseEvent.CLICK, openMC, false, 0, true);
        }

        public function setIsOpened(_arg_1:Boolean):void
        {
            if (((_arg_1) && (!(_opened))))
            {
                _opening_color = _color;
                attachPanel();
                _opened = true;
            }
            else
            {
                if (panel != null)
                {
                    this.removeChild(panel);
                    panel = null;
                    stage.removeEventListener(MouseEvent.CLICK, onClickOutside, false);
                };
                if (advancedColorPanel != null)
                {
                    this.removeChild(advancedColorPanel);
                    advancedColorPanel = null;
                };
                _opened = false;
            };
        }

        public function getIsOpened():Boolean
        {
            return ((_opened) || (!(advancedColorPanel == null)));
        }

        private function colorMC(_arg_1:MovieClip, _arg_2:uint):void
        {
            var _local_3:* = ColorToRGB(_arg_2);
            _arg_1.transform.colorTransform = new ColorTransform(1, 1, 1, 1, _local_3.red, _local_3.green, _local_3.blue, 0);
        }

        private function attachPanel():void
        {
            panel = new MovieClip();
            panel.name = "panel";
            newMC = new MovieClip();
            newMC.name = "backgrounds";
            panel.addChild(newMC);
            newMC = new MovieClip();
            newMC.name = "colors";
            panel.colors = panel.addChild(newMC);
            newMC.x = 3;
            newMC.y = 26;
            newMC.addEventListener(MouseEvent.ROLL_OUT, onRollOutColors, false, 0, true);
            populateColorPanel();
            var _local_1:Number = ((((newMC.width < ColorPicker2.MIN_WIDTH) ? ColorPicker2.MIN_WIDTH : newMC.width) + 6) + newMC.x);
            var _local_2:Number = ((newMC.height + 6) + newMC.y);
            var _local_3:MovieClip = (panel.getChildByName("backgrounds") as MovieClip);
            _local_3.graphics.lineStyle(1, 0xFFFFFF, 100);
            _local_3.graphics.beginFill(13947080, 100);
            _local_3.graphics.moveTo(0, 0);
            _local_3.graphics.lineTo(_local_1, 0);
            _local_3.graphics.lineStyle(1, 0x808080, 100);
            _local_3.graphics.lineTo(_local_1, _local_2);
            _local_3.graphics.lineTo(0, _local_2);
            _local_3.graphics.lineStyle(1, 0xFFFFFF, 100);
            _local_3.graphics.lineTo(0, 0);
            _local_3.graphics.endFill();
            _local_3.graphics.lineStyle(1, 0, 100);
            _local_3.graphics.moveTo((_local_1 + 1), 0);
            _local_3.graphics.lineTo((_local_1 + 1), (_local_2 + 1));
            _local_3.graphics.lineTo(0, (_local_2 + 1));
            newMC = (new ColorDisplay() as MovieClip);
            newMC.name = "color_display";
            panel.addChild(newMC);
            newMC.color = selectedColor;
            colorMC(newMC, selectedColor);
            newMC.x = 3;
            newMC.y = 3;
            newMC.addEventListener(MouseEvent.CLICK, onClicks, false, 0, true);
            newMC = new ColorInput();
            newMC.name = "color_input";
            panel.addChildAt(newMC, 1);
            newMC.color = selectedColor;
            newMC.x = 48;
            newMC.y = 3;
            var _local_4:MovieClip = (panel.getChildByName("colors") as MovieClip);
            newMC = new face_borders();
            newMC.name = "face_borders";
            var _local_5:ColorTransform = newMC.transform.colorTransform;
            _local_5.color = 0xFFFFFF;
            newMC.transform.colorTransform = _local_5;
            _local_4.face_borders = _local_4.addChild(newMC);
            if (selectedColorMC == null)
            {
                newMC.visible = false;
            }
            else
            {
                newMC.x = selectedColorMC.x;
                newMC.y = selectedColorMC.y;
            };
            switch (direction)
            {
                case ColorPicker2.DOWN_LEFT:
                    panel.x = ((cpicker.x - panel.width) + cpicker.width);
                    panel.y = ((cpicker.y + cpicker.height) + 5);
                    break;
                case ColorPicker2.UP_LEFT:
                    panel.x = ((cpicker.x - panel.width) + cpicker.width);
                    panel.y = ((cpicker.y - panel.height) - 5);
                    break;
                case ColorPicker2.UP_RIGHT:
                    panel.x = cpicker.x;
                    panel.y = ((cpicker.y - panel.height) - 5);
                    break;
                default:
                    panel.x = cpicker.x;
                    panel.y = ((cpicker.y + cpicker.height) + 5);
            };
            if (useNoColorSelector)
            {
                noColor = (new NoColorButton() as MovieClip);
                noColor.name = "NoColorButton";
                panel.addChild(noColor);
                noColor.x = ((panel.width - noColor.width) - 7);
                noColor.y = 3;
            };
            if (useAdvancedColorSelector)
            {
                advancedColor = (new AdvancedColorButton() as MovieClip);
                advancedColor.name = "advancedColor";
                panel.addChild(advancedColor);
                advancedColor.x = ((panel.width - advancedColor.width) - 7);
                advancedColor.y = 3;
                if (useNoColorSelector)
                {
                    noColor.x = ((advancedColor.x - noColor.width) - 4);
                };
            };
            this.addChild(panel);
            stage.addEventListener(MouseEvent.CLICK, onClickOutside, false, 0, true);
        }

        public function onRollOutColors(_arg_1:MouseEvent):void
        {
            if (panel != null)
            {
                panel.colors.face_borders.visible = false;
            };
            updateColors(selectedColor, true);
        }

        public function onClickOutside(_arg_1:MouseEvent):void
        {
            if (advancedColorPanel == null)
            {
                if (!((panel.contains(DisplayObject(_arg_1.target))) || (cpicker.contains(DisplayObject(_arg_1.target)))))
                {
                    setIsOpened(false);
                };
            };
        }

        private function onClicks(_arg_1:MouseEvent):void
        {
            this.click((_arg_1.currentTarget as MovieClip));
        }

        private function populateColorPanel():*
        {
            var _local_2:Number;
            var _local_3:MovieClip;
            var _local_8:Object;
            var _local_1:Array = _colors.slice();
            var _local_4:Number = 0;
            var _local_5:Number = 0;
            var _local_6:Number = 0;
            var _local_7:MovieClip = (panel.getChildByName("colors") as MovieClip);
            while (_local_1.length)
            {
                _local_2 = Number(_local_1.shift());
                _local_8 = ColorToRGB(_local_2);
                _local_3 = (new ColorBox(_local_8) as MovieClip);
                _local_3.name = ("single_" + _local_6);
                _local_7.addChild(_local_3);
                _local_3.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
                _local_3.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
                _local_3.addEventListener(MouseEvent.CLICK, onClicks, false, 0, true);
                if (_local_2 == selectedColor)
                {
                    selectedColorMC = _local_3;
                };
                if ((((_local_6 % _columns) == 0) && (_local_6 > 0)))
                {
                    _local_5 = (_local_5 + _local_3.height);
                    _local_4 = 0;
                };
                _local_3.x = _local_4;
                _local_3.y = _local_5;
                _local_4 = (_local_4 + _local_3.width);
                _local_6++;
            };
        }

        public function getStandardColors():Array
        {
            var _local_11:*;
            var _local_1:Array = new Array();
            var _local_2:Number = 0xFFFFFF;
            var _local_3:Number = 0x3300;
            var _local_4:Number = 0x320100;
            var _local_5:Number = 0x9900FF;
            var _local_6:Number = 51;
            var _local_7:Number = 10026753;
            var _local_8:Number = _local_2;
            var _local_9:Number = _local_2;
            var _local_10:* = 0;
            while (_local_10 < 12)
            {
                _local_11 = 0;
                while (_local_11 < 21)
                {
                    if (_local_11 > 0)
                    {
                        if (_local_11 == 18)
                        {
                            _local_8 = 0;
                        }
                        else
                        {
                            if (_local_11 == 19)
                            {
                                _local_8 = _baseColors[_local_10];
                            }
                            else
                            {
                                if (_local_11 == 20)
                                {
                                    _local_8 = 0;
                                }
                                else
                                {
                                    if ((((_local_11 % 6) == 0) && (_local_11 > 0)))
                                    {
                                        _local_8 = (_local_8 - _local_4);
                                    }
                                    else
                                    {
                                        _local_8 = (_local_8 - _local_3);
                                    };
                                };
                            };
                        };
                    };
                    _local_1.push(_local_8);
                    _local_11++;
                };
                if (_local_10 == 5)
                {
                    _local_9 = (_local_9 - _local_7);
                }
                else
                {
                    _local_9 = (_local_9 - _local_6);
                };
                _local_8 = _local_9;
                _local_10++;
            };
            _local_1.reverse();
            return (_local_1);
        }

        public function set selectedColor(_arg_1:Number):void
        {
            _color = _arg_1;
            updateColors(_arg_1, true);
            updateface();
        }

        public function get selectedColor():Number
        {
            if (hover)
            {
                return (hoverColor);
            };
            return (_color);
        }

        public function set direction(_arg_1:String):*
        {
            _direction = _arg_1;
        }

        public function get direction():String
        {
            return (_direction);
        }

        public function set columns(_arg_1:Number):void
        {
            _columns = _arg_1;
        }

        public function get columns():Number
        {
            return (_columns);
        }

        public function set allowUserColor(_arg_1:Boolean):*
        {
            _allowUserColor = _arg_1;
        }

        public function get allowUserColor():Boolean
        {
            return (_allowUserColor);
        }

        public function set colors(_arg_1:Array):*
        {
            _colors = _arg_1;
        }

        public function get colors():Array
        {
            return (_colors);
        }

        public function get useAdvancedColorSelector():Boolean
        {
            return (_useAdvColors);
        }

        public function set useAdvancedColorSelector(_arg_1:Boolean):void
        {
            _useAdvColors = _arg_1;
        }

        public function get useNoColorSelector():Boolean
        {
            return (_useNoColor);
        }

        public function set useNoColorSelector(_arg_1:Boolean):void
        {
            _useNoColor = _arg_1;
        }

        public function setAdvancedColorsMatrix(_arg_1:String, _arg_2:Array, _arg_3:Array, _arg_4:Array):void
        {
            m_fillType = _arg_1;
            m_colors = _arg_2;
            m_alphas = _arg_3;
            m_ratios = _arg_4;
        }

        public function getRGB():String
        {
            return (ColorPicker2.ColorToString(selectedColor));
        }

        private function RGBtoColor(_arg_1:Object):int
        {
            var _local_2:int;
            _local_2 = ((_local_2 | _arg_1.red) << 16);
            _local_2 = (_local_2 | (_arg_1.green << 8));
            return (_local_2 | _arg_1.blue);
        }

        private function updateColors(_arg_1:Number, _arg_2:Boolean):*
        {
            var _local_4:MovieClip;
            if (_arg_1 < 0)
            {
                cpicker.nocolor_face.visible = true;
            }
            else
            {
                cpicker.nocolor_face.visible = false;
            };
            var _local_3:* = ColorToRGB(_arg_1);
            if (panel != null)
            {
                _local_4 = MovieClip(panel.getChildByName("color_display"));
                _local_4.transform.colorTransform = new ColorTransform(1, 1, 1, 1, _local_3.red, _local_3.green, _local_3.blue, 0);
                if (_arg_2)
                {
                    _local_4 = MovieClip(panel.getChildByName("color_input"));
                    _local_4.color = _arg_1;
                };
            };
        }

        private function updateface():void
        {
            var _local_1:* = ColorToRGB(selectedColor);
            cpicker.face.transform.colorTransform = new ColorTransform(1, 1, 1, 1, _local_1.red, _local_1.green, _local_1.blue, 0);
        }

        private function over(_arg_1:MouseEvent):*
        {
            var _local_2:* = (_arg_1.currentTarget as MovieClip);
            var _local_3:* = _local_2.color;
            hover = true;
            hoverColor = RGBtoColor(_local_3);
            updateColors(hoverColor, true);
            _local_2 = MovieClip(panel.getChildByName("colors")).getChildByName("face_borders");
            _local_2.x = MovieClip(_arg_1.currentTarget).x;
            _local_2.y = MovieClip(_arg_1.currentTarget).y;
            _local_2.visible = true;
            this.dispatchEvent(new Event("ROLL_OVER"));
        }

        private function out(_arg_1:MouseEvent):*
        {
            hover = false;
            this.dispatchEvent(new Event("ROLL_OUT"));
        }

        public function click(_arg_1:MovieClip):*
        {
            var _local_2:*;
            if (_arg_1 == advancedColor)
            {
                setIsOpened(false);
                createAdvancedColorPanel(selectedColor);
                selectedColor = _opening_color;
            }
            else
            {
                _local_2 = _arg_1.color;
                selectedColor = RGBtoColor(_local_2);
                try
                {
                    setIsOpened(false);
                }
                catch(e)
                {
                };
                this.dispatchEvent(new Event("CHANGE"));
            };
        }

        private function createAdvancedColorPanel(_arg_1:Number):void
        {
            advancedColorPanel = (new AdvColorPanel(ColorToRGB(_arg_1)) as MovieClip);
            advancedColorPanel.name = "advancedColorPanel";
            this.addChild(advancedColorPanel);
            switch (direction)
            {
                case ColorPicker2.DOWN_LEFT:
                    advancedColorPanel.x = ((cpicker.x - advancedColorPanel.width) + cpicker.width);
                    advancedColorPanel.y = ((cpicker.y + cpicker.height) + 5);
                    return;
                case ColorPicker2.UP_LEFT:
                    panel.x = ((cpicker.x + cpicker.width) - advancedColorPanel.width);
                    panel.y = ((cpicker.y - advancedColorPanel.height) - 5);
                    return;
                case ColorPicker2.UP_RIGHT:
                    panel.x = cpicker.x;
                    panel.y = ((cpicker.y - advancedColorPanel.height) - 5);
                    return;
                case ColorPicker2.DOWN_RIGHT:
                default:
                    advancedColorPanel.x = cpicker.x;
                    advancedColorPanel.y = ((cpicker.y + cpicker.height) + 5);
            };
        }

        public function unload(_arg_1:MovieClip):*
        {
            this.removeChild(advancedColorPanel);
        }

        public function changed(_arg_1:String):*
        {
            if (_arg_1.charAt(0) == "#")
            {
                _arg_1 = _arg_1.substr(1);
            };
            _color = ColorPicker2.StringToColor(_arg_1);
            updateColors(_color, false);
        }

        public function openMC(_arg_1:MouseEvent):void
        {
            setIsOpened((!(getIsOpened())));
        }

        internal function frame1():*
        {
            stop();
        }


    }
}//package org.sepy.ColorPicker

