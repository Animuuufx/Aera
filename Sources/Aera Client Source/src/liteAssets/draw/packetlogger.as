// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.packetlogger

package liteAssets.draw
{
    import flash.display.MovieClip;
    import fl.controls.TextArea;
    import fl.controls.TextInput;
    import flash.text.TextFormat;
    import flash.display.Shape;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import com.adobe.serialization.json.JSON;

    public class packetlogger extends MovieClip 
    {

        public var btnClose:MovieClip;
        public var output:TextArea;
        public var input:TextInput;
        private var tf:TextFormat = new TextFormat();
        public var r:MovieClip;
        private var alwaysOn:Boolean = false;
        private var scrToBottom:Boolean = false;
        private var jsonLimit:int = 0;
        private var whiteSpace:RegExp = /\s{2,}/gim;
        private var tabPos:int = 0;
        private var separator:RegExp = /[%]+/gim;
        private var gdq:RegExp = /[&quot;]+/gim;
        private var gtrue:RegExp = /[true]+/gim;
        private var gfalse:RegExp = /[false]+/gim;

        public function packetlogger(_arg_1:MovieClip)
        {
            this.visible = false;
            r = _arg_1;
            r.stage.addChild(this);
            this.name = "packetlogger";
            tf.font = "Arial";
            tf.size = 18;
            output.setStyle("textFormat", tf);
            tf.size = 25;
            input.setStyle("textFormat", tf);
            var _local_2:Shape = new Shape();
            _local_2.graphics.beginFill(0xFFFFFF, 0.9);
            _local_2.graphics.drawRect(0, 0, 960, 500);
            _local_2.graphics.endFill();
            var _local_3:* = new MovieClip();
            _local_3.addChild(_local_2);
            output.setStyle("upSkin", _local_3);
            _local_2 = new Shape();
            _local_2.graphics.beginFill(0xFFFFFF, 0.9);
            _local_2.graphics.drawRect(0, 0, 960, 40);
            _local_2.graphics.endFill();
            _local_3 = new MovieClip();
            _local_3.addChild(_local_2);
            input.setStyle("upSkin", _local_3);
            input.addEventListener(KeyboardEvent.KEY_DOWN, onInput, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onHide, false, 0, true);
        }

        public function onHide(_arg_1:MouseEvent):void
        {
            this.visible = false;
            toggle();
        }

        public function onInput(_arg_1:KeyboardEvent):void
        {
            var _local_2:String;
            if (_arg_1.keyCode == 13)
            {
                _local_2 = input.text.replace(whiteSpace, "");
                if (_local_2.indexOf("/setlimit") == 0)
                {
                    regular("This command is currently disabled");
                }
                else
                {
                    switch (_local_2)
                    {
                        case "/help":
                            regular("\tCOMMANDS ---");
                            regular("\t/help - COMMANDS");
                            regular("\t/autoscr - AUTO SCROLL TO BOTTOM (DEFAULT: OFF)");
                            regular("\t/clear - CLEARS SCREEN");
                            regular("\t/hide - HIDES SCREEN");
                            regular("\t/alwayson - ALWAYS LOG EVEN IF HIDDEN");
                            regular("\tENTERING ANYTHING WILL SEND TO THE SERVER");
                            break;
                        case "/alwayson":
                            alwaysOn = (!(alwaysOn));
                            regular(("\tALWAYS ON SET TO: " + alwaysOn));
                            break;
                        case "/autoscr":
                            scrToBottom = (!(scrToBottom));
                            regular(("\tAUTO SCROLL TO BOTTOM SET TO: " + scrToBottom));
                            break;
                        case "/getlimit":
                            regular((("\tJSON PRETTY PRINT STRING LIMIT -- " + jsonLimit) + " CHARACTERS"));
                            break;
                        case "/clear":
                            output.text = "";
                            break;
                        case "/hide":
                            this.visible = false;
                            toggle();
                            break;
                        default:
                            if (r.world.myAvatar.isStaff())
                            {
                                r.sfc.sendString(input.text);
                                regular(("\tSENT TO SERVER: " + input.text));
                            };
                    };
                };
                input.text = "";
                if (scrToBottom)
                {
                    output.verticalScrollPosition = output.maxVerticalScrollPosition;
                };
            };
        }

        public function cleanup():void
        {
            if ((this.parent as MovieClip) != null)
            {
                (this.parent as MovieClip).removeChild(this);
            };
            input.removeEventListener(KeyboardEvent.KEY_DOWN, onInput);
            r.sfc.removeEventListener("onDebugMessage", onLogger);
            r.pLoggerUI = null;
        }

        public function getTabs():String
        {
            var _local_1:* = "";
            var _local_2:int;
            while (_local_2 < tabPos)
            {
                _local_1 = (_local_1 + "    ");
                _local_2++;
            };
            return (_local_1);
        }

        public function color(_arg_1:String, _arg_2:String):String
        {
            return (((('<font face="Arial" size="20" color="' + _arg_2) + '">') + _arg_1) + "</font>");
        }

        public function tab(_arg_1:String):void
        {
            output.htmlText = (output.htmlText + ((('<font face="Arial" size="20">' + getTabs()) + _arg_1) + "</font>"));
            if (scrToBottom)
            {
                output.verticalScrollPosition = output.textField.maxScrollV;
            };
        }

        public function noTab(_arg_1:String):void
        {
            output.htmlText = (output.htmlText + (('<font face="Arial" size="20">' + _arg_1) + "</font>"));
            if (scrToBottom)
            {
                output.verticalScrollPosition = output.textField.maxScrollV;
            };
        }

        public function regular(_arg_1:String):void
        {
            output.appendText((_arg_1 + "\n"));
        }

        public function parse(_arg_1:*):String
        {
            var _local_3:*;
            var _local_6:*;
            tabPos++;
            var _local_2:int;
            for (_local_3 in _arg_1)
            {
                _local_2++;
            };
            if (_local_2 == 0)
            {
                tabPos--;
                return (" {}");
            };
            var _local_4:int;
            var _local_5:* = " {\n";
            for (_local_6 in _arg_1)
            {
                _local_5 = (_local_5 + (getTabs() + (('"' + color(_local_6, "#BF40BF")) + '":')));
                if ((_arg_1[_local_6] is String))
                {
                    _local_5 = (_local_5 + ((' "' + color(_arg_1[_local_6], "#FF0000")) + '"'));
                }
                else
                {
                    if (((_arg_1[_local_6] is Number) || (_arg_1[_local_6] is Boolean)))
                    {
                        _local_5 = (_local_5 + (" " + color(_arg_1[_local_6], "#FF0000")));
                    }
                    else
                    {
                        if (((_arg_1[_local_6] is Object) || (_arg_1[_local_6] is Array)))
                        {
                            _local_5 = (_local_5 + parse(_arg_1[_local_6]));
                        }
                        else
                        {
                            _local_5 = (_local_5 + (" " + color(_arg_1[_local_6], "#FF0000")));
                        };
                    };
                };
                if ((_local_4 + 1) != _local_2)
                {
                    _local_5 = (_local_5 + ",");
                };
                _local_5 = (_local_5 + "\n");
                _local_4++;
            };
            tabPos--;
            _local_5 = (_local_5 + (getTabs() + "}"));
            return (_local_5);
        }

        internal function raw_parse(_arg_1:*):String
        {
            var _local_3:*;
            var _local_6:*;
            tabPos++;
            var _local_2:int;
            for (_local_3 in _arg_1)
            {
                _local_2++;
            };
            if (_local_2 == 0)
            {
                tabPos--;
                return (" {}");
            };
            var _local_4:int;
            var _local_5:* = " {\n";
            for (_local_6 in _arg_1)
            {
                _local_5 = (_local_5 + (getTabs() + (('"' + _local_6) + '":')));
                if ((_arg_1[_local_6] is String))
                {
                    _local_5 = (_local_5 + ((' "' + _arg_1[_local_6]) + '"'));
                }
                else
                {
                    if (((_arg_1[_local_6] is Number) || (_arg_1[_local_6] is Boolean)))
                    {
                        _local_5 = (_local_5 + (" " + _arg_1[_local_6]));
                    }
                    else
                    {
                        if (((_arg_1[_local_6] is Object) || (_arg_1[_local_6] is Array)))
                        {
                            _local_5 = (_local_5 + raw_parse(_arg_1[_local_6]));
                        }
                        else
                        {
                            _local_5 = (_local_5 + (" " + _arg_1[_local_6]));
                        };
                    };
                };
                if ((_local_4 + 1) != _local_2)
                {
                    _local_5 = (_local_5 + ",");
                };
                _local_5 = (_local_5 + "\n");
                _local_4++;
            };
            tabPos--;
            _local_5 = (_local_5 + (getTabs() + "}"));
            return (_local_5);
        }

        private function fixHTML(_arg_1:String):String
        {
            var _local_2:RegExp = /[<]+/gim;
            var _local_3:RegExp = /[>]+/gim;
            var _local_4:RegExp = /[&]+/gim;
            var _local_5:RegExp = /["]+/gim;
            var _local_6:RegExp = /[']+/gim;
            _arg_1 = _arg_1.replace(_local_2, "&lt;");
            _arg_1 = _arg_1.replace(_local_3, "&gt;");
            _arg_1 = _arg_1.replace(_local_4, "&amp;");
            _arg_1 = _arg_1.replace(_local_5, "&quot;");
            return (_arg_1.replace(_local_6, "&apos;"));
        }

        public function onLogger(_arg_1:*):void
        {
            var _local_3:*;
            var _local_2:* = _arg_1.params.message;
            if (_local_2.indexOf("[ RECEIVED ]:") == 0)
            {
                _local_3 = (_local_2.substr((_local_2.indexOf("]: ") + 3), (_local_2.lastIndexOf(", (len:") - 14)) + "\n");
                if (_local_3.length > jsonLimit)
                {
                    if (_local_3.indexOf("%") != -1)
                    {
                        regular(("\t" + _local_3));
                    }
                    else
                    {
                        regular(raw_parse(com.adobe.serialization.json.JSON.decode(_local_3)));
                    };
                }
                else
                {
                    noTab(parse(com.adobe.serialization.json.JSON.decode(_local_3)));
                };
                tabPos = 0;
            }
            else
            {
                _local_3 = _local_2.substr((_local_2.indexOf("]: ") + 3), _local_2.length);
                if (_local_3.length > jsonLimit)
                {
                    regular(("\t" + _local_3));
                }
                else
                {
                    if (((!(_local_3.indexOf("%") == -1)) && (_local_3.length <= jsonLimit)))
                    {
                        _local_3 = fixHTML(_local_3);
                        _local_3 = color(_local_3, "#BF40BF");
                        _local_3 = _local_3.replace(separator, color("%", "#FF0000"));
                    };
                    noTab(("<br>" + _local_3));
                };
            };
            if (scrToBottom)
            {
                output.verticalScrollPosition = output.maxVerticalScrollPosition;
            };
        }

        public function toggle():void
        {
            r.stage.focus = null;
            if (!alwaysOn)
            {
                if (this.visible)
                {
                    r.sfc.addEventListener("onDebugMessage", onLogger, false, 0, true);
                }
                else
                {
                    r.sfc.removeEventListener("onDebugMessage", onLogger);
                };
            };
        }


    }
}//package liteAssets.draw

