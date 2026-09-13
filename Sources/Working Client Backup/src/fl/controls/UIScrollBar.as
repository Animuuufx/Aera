// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.controls.UIScrollBar

package fl.controls
{
    import flash.display.DisplayObject;
    import fl.core.UIComponent;
    import flash.events.Event;
    import flash.events.TextEvent;
    import fl.core.InvalidationType;
    import fl.events.ScrollEvent;

    public class UIScrollBar extends ScrollBar 
    {

        private static var defaultStyles:Object = {};

        protected var _scrollTarget:DisplayObject;
        protected var inEdit:Boolean = false;
        protected var inScroll:Boolean = false;
        protected var _targetScrollProperty:String;
        protected var _targetMaxScrollProperty:String;


        public static function getStyleDefinition():Object
        {
            return (UIComponent.mergeStyles(defaultStyles, ScrollBar.getStyleDefinition()));
        }


        override public function set minScrollPosition(_arg_1:Number):void
        {
            super.minScrollPosition = ((_arg_1 < 0) ? 0 : _arg_1);
        }

        override public function set maxScrollPosition(_arg_1:Number):void
        {
            var _local_2:Number = _arg_1;
            if (_scrollTarget != null)
            {
                _local_2 = Math.min(_local_2, _scrollTarget[_targetMaxScrollProperty]);
            };
            super.maxScrollPosition = _local_2;
        }

        public function get scrollTarget():DisplayObject
        {
            return (_scrollTarget);
        }

        public function set scrollTarget(target:DisplayObject):void
        {
            if (_scrollTarget != null)
            {
                _scrollTarget.removeEventListener(Event.CHANGE, handleTargetChange, false);
                _scrollTarget.removeEventListener(TextEvent.TEXT_INPUT, handleTargetChange, false);
                _scrollTarget.removeEventListener(Event.SCROLL, handleTargetScroll, false);
            };
            _scrollTarget = target;
            var blockProg:String;
            var textDir:String;
            var hasPixelVS:Boolean;
            if (_scrollTarget != null)
            {
                try
                {
                    if (_scrollTarget.hasOwnProperty("blockProgression"))
                    {
                        blockProg = _scrollTarget["blockProgression"];
                    };
                    if (_scrollTarget.hasOwnProperty("direction"))
                    {
                        textDir = _scrollTarget["direction"];
                    };
                    if (_scrollTarget.hasOwnProperty("pixelScrollV"))
                    {
                        hasPixelVS = true;
                    };
                }
                catch(e:Error)
                {
                    blockProg = null;
                    textDir = null;
                };
            };
            var scrollHoriz:Boolean = (this.direction == ScrollBarDirection.HORIZONTAL);
            var rot:Number = Math.abs(this.rotation);
            if (((scrollHoriz) && ((blockProg == "rl") || (textDir == "rtl"))))
            {
                if (((getScaleY() > 0) && (rotation == 90)))
                {
                    x = (x + width);
                };
                setScaleY(-1);
            }
            else
            {
                if ((((!(scrollHoriz)) && (blockProg == "rl")) && (textDir == "rtl")))
                {
                    if (((getScaleY() > 0) && (!(rotation == 90))))
                    {
                        y = (y + height);
                    };
                    setScaleY(-1);
                }
                else
                {
                    if (getScaleY() < 0)
                    {
                        if (scrollHoriz)
                        {
                            if (rotation == 90)
                            {
                                x = (x - width);
                            };
                        }
                        else
                        {
                            if (rotation != 90)
                            {
                                y = (y - height);
                            };
                        };
                    };
                    setScaleY(1);
                };
            };
            setTargetScrollProperties(scrollHoriz, blockProg, hasPixelVS);
            if (_scrollTarget != null)
            {
                _scrollTarget.addEventListener(Event.CHANGE, handleTargetChange, false, 0, true);
                _scrollTarget.addEventListener(TextEvent.TEXT_INPUT, handleTargetChange, false, 0, true);
                _scrollTarget.addEventListener(Event.SCROLL, handleTargetScroll, false, 0, true);
            };
            invalidate(InvalidationType.DATA);
        }

        public function get scrollTargetName():String
        {
            return (_scrollTarget.name);
        }

        public function set scrollTargetName(target:String):void
        {
            try
            {
                scrollTarget = parent.getChildByName(target);
            }
            catch(error:Error)
            {
                throw (new Error("ScrollTarget not found, or is not a valid target"));
            };
        }

        override public function get direction():String
        {
            return (super.direction);
        }

        override public function set direction(_arg_1:String):void
        {
            var _local_2:DisplayObject;
            if (isLivePreview)
            {
                return;
            };
            if (((!(componentInspectorSetting)) && (!(_scrollTarget == null))))
            {
                _local_2 = _scrollTarget;
                scrollTarget = null;
            };
            super.direction = _arg_1;
            if (_local_2 != null)
            {
                scrollTarget = _local_2;
            }
            else
            {
                updateScrollTargetProperties();
            };
        }

        public function update():void
        {
            inEdit = true;
            updateScrollTargetProperties();
            inEdit = false;
        }

        override protected function draw():void
        {
            if (isInvalid(InvalidationType.DATA))
            {
                updateScrollTargetProperties();
            };
            super.draw();
        }

        protected function updateScrollTargetProperties():void
        {
            const local_tlf_internal:Namespace = new Namespace("http://ns.adobe.com/textLayout/internal/2008");
            var blockProg:String;
            var hasPixelVS:Boolean;
            var pageSize:Number;
            var minScroll:Number;
            var minScrollVValue:* = undefined;
            if (_scrollTarget == null)
            {
                setScrollProperties(pageSize, minScrollPosition, maxScrollPosition);
                scrollPosition = 0;
            }
            else
            {
                blockProg = null;
                hasPixelVS = false;
                try
                {
                    if (_scrollTarget.hasOwnProperty("blockProgression"))
                    {
                        blockProg = _scrollTarget["blockProgression"];
                    };
                    if (_scrollTarget.hasOwnProperty("pixelScrollV"))
                    {
                        hasPixelVS = true;
                    };
                }
                catch(e1:Error)
                {
                };
                setTargetScrollProperties((this.direction == ScrollBarDirection.HORIZONTAL), blockProg, hasPixelVS);
                if (_targetScrollProperty == "scrollH")
                {
                    minScroll = 0;
                    try
                    {
                        if (((_scrollTarget.hasOwnProperty("controller")) && (_scrollTarget["controller"].hasOwnProperty("compositionWidth"))))
                        {
                            pageSize = _scrollTarget["controller"]["compositionWidth"];
                        }
                        else
                        {
                            pageSize = _scrollTarget.width;
                        };
                    }
                    catch(e2:Error)
                    {
                        pageSize = _scrollTarget.width;
                    };
                }
                else
                {
                    try
                    {
                        if (blockProg != null)
                        {
                            minScrollVValue = _scrollTarget["pixelMinScrollV"];
                            if ((minScrollVValue is int))
                            {
                                minScroll = minScrollVValue;
                            }
                            else
                            {
                                minScroll = 1;
                            };
                        }
                        else
                        {
                            minScroll = 1;
                        };
                    }
                    catch(e3:Error)
                    {
                        minScroll = 1;
                    };
                    pageSize = 10;
                };
                setScrollProperties(pageSize, minScroll, scrollTarget[_targetMaxScrollProperty]);
                scrollPosition = _scrollTarget[_targetScrollProperty];
            };
        }

        override public function setScrollProperties(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number=0):void
        {
            var _local_5:Number = _arg_3;
            var _local_6:Number = ((_arg_2 < 0) ? 0 : _arg_2);
            if (_scrollTarget != null)
            {
                _local_5 = Math.min(_arg_3, _scrollTarget[_targetMaxScrollProperty]);
            };
            super.setScrollProperties(_arg_1, _local_6, _local_5, _arg_4);
        }

        override public function setScrollPosition(_arg_1:Number, _arg_2:Boolean=true):void
        {
            super.setScrollPosition(_arg_1, _arg_2);
            if (!_scrollTarget)
            {
                inScroll = false;
                return;
            };
            updateTargetScroll();
        }

        protected function updateTargetScroll(_arg_1:ScrollEvent=null):void
        {
            if (inEdit)
            {
                return;
            };
            _scrollTarget[_targetScrollProperty] = scrollPosition;
        }

        protected function handleTargetChange(_arg_1:Event):void
        {
            inEdit = true;
            setScrollPosition(_scrollTarget[_targetScrollProperty], true);
            updateScrollTargetProperties();
            inEdit = false;
        }

        protected function handleTargetScroll(_arg_1:Event):void
        {
            if (inDrag)
            {
                return;
            };
            if (!enabled)
            {
                return;
            };
            inEdit = true;
            updateScrollTargetProperties();
            scrollPosition = _scrollTarget[_targetScrollProperty];
            inEdit = false;
        }

        private function setTargetScrollProperties(_arg_1:Boolean, _arg_2:String, _arg_3:Boolean=false):void
        {
            if (_arg_2 == "rl")
            {
                if (_arg_1)
                {
                    _targetScrollProperty = ((_arg_3) ? "pixelScrollV" : "scrollV");
                    _targetMaxScrollProperty = ((_arg_3) ? "pixelMaxScrollV" : "maxScrollV");
                }
                else
                {
                    _targetScrollProperty = "scrollH";
                    _targetMaxScrollProperty = "maxScrollH";
                };
            }
            else
            {
                if (_arg_1)
                {
                    _targetScrollProperty = "scrollH";
                    _targetMaxScrollProperty = "maxScrollH";
                }
                else
                {
                    _targetScrollProperty = ((_arg_3) ? "pixelScrollV" : "scrollV");
                    _targetMaxScrollProperty = ((_arg_3) ? "pixelMaxScrollV" : "maxScrollV");
                };
            };
        }


    }
}//package fl.controls

