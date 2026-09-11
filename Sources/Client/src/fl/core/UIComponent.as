// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.core.UIComponent

package fl.core
{
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.Dictionary;
    import fl.managers.IFocusManagerComponent;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import fl.managers.StyleManager;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import fl.events.ComponentEvent;
    import fl.managers.IFocusManager;
    import flash.display.InteractiveObject;
    import flash.system.IME;
    import flash.system.IMEConversionMode;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    import flash.display.DisplayObjectContainer;
    import fl.managers.FocusManager;

    public class UIComponent extends Sprite 
    {

        public static var inCallLaterPhase:Boolean = false;
        private static var defaultStyles:Object = {
            "focusRectSkin":"focusRectSkin",
            "focusRectPadding":2,
            "textFormat":new TextFormat("_sans", 11, 0, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
            "disabledTextFormat":new TextFormat("_sans", 11, 0x999999, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
            "defaultTextFormat":new TextFormat("_sans", 11, 0, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
            "defaultDisabledTextFormat":new TextFormat("_sans", 11, 0x999999, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)
        };
        private static var focusManagers:Dictionary = new Dictionary(true);
        private static var focusManagerUsers:Dictionary = new Dictionary(true);
        public static var createAccessibilityImplementation:Function;

        public const version:String = "3.0.3.1";

        public var focusTarget:IFocusManagerComponent;
        protected var isLivePreview:Boolean = false;
        private var tempText:TextField;
        protected var instanceStyles:Object;
        protected var sharedStyles:Object;
        protected var callLaterMethods:Dictionary;
        protected var invalidateFlag:Boolean = false;
        protected var _enabled:Boolean = true;
        protected var invalidHash:Object;
        protected var uiFocusRect:DisplayObject;
        protected var isFocused:Boolean = false;
        private var _focusEnabled:Boolean = true;
        private var _mouseFocusEnabled:Boolean = true;
        protected var _width:Number;
        protected var _height:Number;
        protected var _x:Number;
        protected var _y:Number;
        protected var startWidth:Number;
        protected var startHeight:Number;
        protected var _imeMode:String = null;
        protected var _oldIMEMode:String = null;
        protected var errorCaught:Boolean = false;
        protected var _inspector:Boolean = false;

        public function UIComponent()
        {
            instanceStyles = {};
            sharedStyles = {};
            invalidHash = {};
            callLaterMethods = new Dictionary();
            StyleManager.registerInstance(this);
            configUI();
            invalidate(InvalidationType.ALL);
            tabEnabled = (this is IFocusManagerComponent);
            focusRect = false;
            if (tabEnabled)
            {
                addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
                addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
                addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            };
            initializeFocusManager();
            addEventListener(Event.ENTER_FRAME, hookAccessibility, false, 0, true);
        }

        public static function getStyleDefinition():Object
        {
            return (defaultStyles);
        }

        public static function mergeStyles(... _args):Object
        {
            var _local_5:Object;
            var _local_6:String;
            var _local_2:Object = {};
            var _local_3:uint = _args.length;
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_5 = _args[_local_4];
                for (_local_6 in _local_5)
                {
                    if (_local_2[_local_6] == null)
                    {
                        _local_2[_local_6] = _args[_local_4][_local_6];
                    };
                };
                _local_4++;
            };
            return (_local_2);
        }


        public function get componentInspectorSetting():Boolean
        {
            return (_inspector);
        }

        public function set componentInspectorSetting(_arg_1:Boolean):void
        {
            _inspector = _arg_1;
            if (_inspector)
            {
                beforeComponentParameters();
            }
            else
            {
                afterComponentParameters();
            };
        }

        protected function beforeComponentParameters():void
        {
        }

        protected function afterComponentParameters():void
        {
        }

        public function get enabled():Boolean
        {
            return (_enabled);
        }

        public function set enabled(_arg_1:Boolean):void
        {
            if (_arg_1 == _enabled)
            {
                return;
            };
            _enabled = _arg_1;
            invalidate(InvalidationType.STATE);
        }

        public function setSize(_arg_1:Number, _arg_2:Number):void
        {
            _width = _arg_1;
            _height = _arg_2;
            invalidate(InvalidationType.SIZE);
            dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, false));
        }

        override public function get width():Number
        {
            return (_width);
        }

        override public function set width(_arg_1:Number):void
        {
            if (_width == _arg_1)
            {
                return;
            };
            setSize(_arg_1, height);
        }

        override public function get height():Number
        {
            return (_height);
        }

        override public function set height(_arg_1:Number):void
        {
            if (_height == _arg_1)
            {
                return;
            };
            setSize(width, _arg_1);
        }

        public function setStyle(_arg_1:String, _arg_2:Object):void
        {
            if (((instanceStyles[_arg_1] === _arg_2) && (!(_arg_2 is TextFormat))))
            {
                return;
            };
            instanceStyles[_arg_1] = _arg_2;
            invalidate(InvalidationType.STYLES);
        }

        public function clearStyle(_arg_1:String):void
        {
            setStyle(_arg_1, null);
        }

        public function getStyle(_arg_1:String):Object
        {
            return (instanceStyles[_arg_1]);
        }

        public function move(_arg_1:Number, _arg_2:Number):void
        {
            _x = _arg_1;
            _y = _arg_2;
            super.x = Math.round(_arg_1);
            super.y = Math.round(_arg_2);
            dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
        }

        override public function get x():Number
        {
            return ((isNaN(_x)) ? super.x : _x);
        }

        override public function set x(_arg_1:Number):void
        {
            move(_arg_1, _y);
        }

        override public function get y():Number
        {
            return ((isNaN(_y)) ? super.y : _y);
        }

        override public function set y(_arg_1:Number):void
        {
            move(_x, _arg_1);
        }

        override public function get scaleX():Number
        {
            return (width / startWidth);
        }

        override public function set scaleX(_arg_1:Number):void
        {
            setSize((startWidth * _arg_1), height);
        }

        override public function get scaleY():Number
        {
            return (height / startHeight);
        }

        override public function set scaleY(_arg_1:Number):void
        {
            setSize(width, (startHeight * _arg_1));
        }

        protected function getScaleY():Number
        {
            return (super.scaleY);
        }

        protected function setScaleY(_arg_1:Number):void
        {
            super.scaleY = _arg_1;
        }

        protected function getScaleX():Number
        {
            return (super.scaleX);
        }

        protected function setScaleX(_arg_1:Number):void
        {
            super.scaleX = _arg_1;
        }

        override public function get visible():Boolean
        {
            return (super.visible);
        }

        override public function set visible(_arg_1:Boolean):void
        {
            if (super.visible == _arg_1)
            {
                return;
            };
            super.visible = _arg_1;
            var _local_2:String = ((_arg_1) ? ComponentEvent.SHOW : ComponentEvent.HIDE);
            dispatchEvent(new ComponentEvent(_local_2, true));
        }

        public function validateNow():void
        {
            invalidate(InvalidationType.ALL, false);
            draw();
        }

        public function invalidate(_arg_1:String="all", _arg_2:Boolean=true):void
        {
            invalidHash[_arg_1] = true;
            if (_arg_2)
            {
                this.callLater(draw);
            };
        }

        public function setSharedStyle(_arg_1:String, _arg_2:Object):void
        {
            if (((sharedStyles[_arg_1] === _arg_2) && (!(_arg_2 is TextFormat))))
            {
                return;
            };
            sharedStyles[_arg_1] = _arg_2;
            if (instanceStyles[_arg_1] == null)
            {
                invalidate(InvalidationType.STYLES);
            };
        }

        public function get focusEnabled():Boolean
        {
            return (_focusEnabled);
        }

        public function set focusEnabled(_arg_1:Boolean):void
        {
            _focusEnabled = _arg_1;
        }

        public function get mouseFocusEnabled():Boolean
        {
            return (_mouseFocusEnabled);
        }

        public function set mouseFocusEnabled(_arg_1:Boolean):void
        {
            _mouseFocusEnabled = _arg_1;
        }

        public function get focusManager():IFocusManager
        {
            var o:DisplayObject = this;
            while (o)
            {
                if (UIComponent.focusManagers[o] != null)
                {
                    return (IFocusManager(UIComponent.focusManagers[o]));
                };
                try
                {
                    o = o.parent;
                }
                catch(se:SecurityError)
                {
                    return (null);
                };
            };
            return (null);
        }

        public function set focusManager(_arg_1:IFocusManager):void
        {
            UIComponent.focusManagers[this] = _arg_1;
        }

        public function drawFocus(_arg_1:Boolean):void
        {
            var _local_2:Number;
            isFocused = _arg_1;
            if (((!(uiFocusRect == null)) && (contains(uiFocusRect))))
            {
                removeChild(uiFocusRect);
                uiFocusRect = null;
            };
            if (_arg_1)
            {
                uiFocusRect = (getDisplayObjectInstance(getStyleValue("focusRectSkin")) as Sprite);
                if (uiFocusRect == null)
                {
                    return;
                };
                _local_2 = Number(getStyleValue("focusRectPadding"));
                uiFocusRect.x = -(_local_2);
                uiFocusRect.y = -(_local_2);
                uiFocusRect.width = (width + (_local_2 * 2));
                uiFocusRect.height = (height + (_local_2 * 2));
                addChildAt(uiFocusRect, 0);
            };
        }

        public function setFocus():void
        {
            if (stage)
            {
                stage.focus = this;
            };
        }

        public function getFocus():InteractiveObject
        {
            if (stage)
            {
                return (stage.focus);
            };
            return (null);
        }

        protected function setIMEMode(enabled:Boolean):*
        {
            if (_imeMode != null)
            {
                if (enabled)
                {
                    IME.enabled = true;
                    _oldIMEMode = IME.conversionMode;
                    try
                    {
                        if (((!(errorCaught)) && (!(IME.conversionMode == IMEConversionMode.UNKNOWN))))
                        {
                            IME.conversionMode = _imeMode;
                        };
                        errorCaught = false;
                    }
                    catch(e:Error)
                    {
                        errorCaught = true;
                        throw (new Error(("IME mode not supported: " + _imeMode)));
                    };
                }
                else
                {
                    if (((!(IME.conversionMode == IMEConversionMode.UNKNOWN)) && (!(_oldIMEMode == IMEConversionMode.UNKNOWN))))
                    {
                        IME.conversionMode = _oldIMEMode;
                    };
                    IME.enabled = false;
                };
            };
        }

        public function drawNow():void
        {
            draw();
        }

        protected function configUI():void
        {
            isLivePreview = checkLivePreview();
            var _local_1:Number = rotation;
            rotation = 0;
            var _local_2:Number = super.width;
            var _local_3:Number = super.height;
            var _local_4:int = 1;
            super.scaleY = _local_4;
            super.scaleX = _local_4;
            setSize(_local_2, _local_3);
            move(super.x, super.y);
            rotation = _local_1;
            startWidth = _local_2;
            startHeight = _local_3;
            if (numChildren > 0)
            {
                removeChildAt(0);
            };
        }

        protected function checkLivePreview():Boolean
        {
            var className:String;
            if (parent == null)
            {
                return (false);
            };
            try
            {
                className = getQualifiedClassName(parent);
            }
            catch(e:Error)
            {
            };
            return (className == "fl.livepreview::LivePreviewParent");
        }

        protected function isInvalid(_arg_1:String, ... _args):Boolean
        {
            if (((invalidHash[_arg_1]) || (invalidHash[InvalidationType.ALL])))
            {
                return (true);
            };
            while (_args.length > 0)
            {
                if (invalidHash[_args.pop()])
                {
                    return (true);
                };
            };
            return (false);
        }

        protected function validate():void
        {
            invalidHash = {};
        }

        protected function draw():void
        {
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
            {
                if (((isFocused) && (focusManager.showFocusIndicator)))
                {
                    drawFocus(true);
                };
            };
            validate();
        }

        protected function getDisplayObjectInstance(skin:Object):DisplayObject
        {
            var classDef:Object;
            if ((skin is Class))
            {
                return (new (skin)() as DisplayObject);
            };
            if ((skin is DisplayObject))
            {
                (skin as DisplayObject).x = 0;
                (skin as DisplayObject).y = 0;
                return (skin as DisplayObject);
            };
            try
            {
                classDef = getDefinitionByName(skin.toString());
            }
            catch(e:Error)
            {
                try
                {
                    classDef = (loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object);
                }
                catch(e:Error)
                {
                };
            };
            if (classDef == null)
            {
                return (null);
            };
            return (new (classDef)() as DisplayObject);
        }

        protected function getStyleValue(_arg_1:String):Object
        {
            return ((instanceStyles[_arg_1] == null) ? sharedStyles[_arg_1] : instanceStyles[_arg_1]);
        }

        protected function copyStylesToChild(_arg_1:UIComponent, _arg_2:Object):void
        {
            var _local_3:String;
            for (_local_3 in _arg_2)
            {
                _arg_1.setStyle(_local_3, getStyleValue(_arg_2[_local_3]));
            };
        }

        protected function callLater(fn:Function):void
        {
            if (inCallLaterPhase)
            {
                return;
            };
            callLaterMethods[fn] = true;
            if (stage != null)
            {
                try
                {
                    stage.addEventListener(Event.RENDER, callLaterDispatcher, false, 0, true);
                    stage.invalidate();
                }
                catch(se:SecurityError)
                {
                    addEventListener(Event.ENTER_FRAME, callLaterDispatcher, false, 0, true);
                };
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher, false, 0, true);
            };
        }

        private function callLaterDispatcher(event:Event):void
        {
            var method:Object;
            if (event.type == Event.ADDED_TO_STAGE)
            {
                try
                {
                    removeEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher);
                    stage.addEventListener(Event.RENDER, callLaterDispatcher, false, 0, true);
                    stage.invalidate();
                    return;
                }
                catch(se1:SecurityError)
                {
                    addEventListener(Event.ENTER_FRAME, callLaterDispatcher, false, 0, true);
                };
            }
            else
            {
                event.target.removeEventListener(Event.RENDER, callLaterDispatcher);
                event.target.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
                try
                {
                    if (stage == null)
                    {
                        addEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher, false, 0, true);
                        return;
                    };
                }
                catch(se2:SecurityError)
                {
                };
            };
            inCallLaterPhase = true;
            var methods:Dictionary = callLaterMethods;
            for (method in methods)
            {
                (method());
                delete methods[method];
            };
            inCallLaterPhase = false;
        }

        private function initializeFocusManager():void
        {
            var _local_1:IFocusManager;
            var _local_2:Dictionary;
            if (stage == null)
            {
                addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
            }
            else
            {
                createFocusManager();
                _local_1 = focusManager;
                if (_local_1 != null)
                {
                    _local_2 = focusManagerUsers[_local_1];
                    if (_local_2 == null)
                    {
                        _local_2 = new Dictionary(true);
                        focusManagerUsers[_local_1] = _local_2;
                    };
                    _local_2[this] = true;
                };
            };
            addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
        }

        private function addedHandler(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
            initializeFocusManager();
        }

        private function removedHandler(_arg_1:Event):void
        {
            var _local_3:Dictionary;
            var _local_4:Boolean;
            var _local_5:*;
            var _local_6:*;
            var _local_7:IFocusManager;
            removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
            addEventListener(Event.ADDED_TO_STAGE, addedHandler);
            var _local_2:IFocusManager = focusManager;
            if (_local_2 != null)
            {
                _local_3 = focusManagerUsers[_local_2];
                if (_local_3 != null)
                {
                    delete _local_3[this];
                    _local_4 = true;
                    for (_local_5 in _local_3)
                    {
                        _local_4 = false;
                        break;
                    };
                    if (_local_4)
                    {
                        delete focusManagerUsers[_local_2];
                        _local_3 = null;
                    };
                };
                if (_local_3 == null)
                {
                    _local_2.deactivate();
                    for (_local_6 in focusManagers)
                    {
                        _local_7 = focusManagers[_local_6];
                        if (_local_2 == _local_7)
                        {
                            delete focusManagers[_local_6];
                        };
                    };
                };
            };
        }

        protected function createFocusManager():void
        {
            var stageAccessOK:Boolean = true;
            try
            {
                stage.getChildAt(0);
            }
            catch(se:SecurityError)
            {
                stageAccessOK = false;
            };
            var myTopLevel:DisplayObjectContainer;
            if (stageAccessOK)
            {
                myTopLevel = stage;
            }
            else
            {
                myTopLevel = this;
                try
                {
                    while (myTopLevel.parent != null)
                    {
                        myTopLevel = myTopLevel.parent;
                    };
                }
                catch(se:SecurityError)
                {
                };
            };
            if (focusManagers[myTopLevel] == null)
            {
                focusManagers[myTopLevel] = new FocusManager(myTopLevel);
            };
        }

        protected function isOurFocus(_arg_1:DisplayObject):Boolean
        {
            return (_arg_1 == this);
        }

        protected function focusInHandler(_arg_1:FocusEvent):void
        {
            var _local_2:IFocusManager;
            if (isOurFocus((_arg_1.target as DisplayObject)))
            {
                _local_2 = focusManager;
                if (((_local_2) && (_local_2.showFocusIndicator)))
                {
                    drawFocus(true);
                    isFocused = true;
                };
            };
        }

        protected function focusOutHandler(_arg_1:FocusEvent):void
        {
            if (isOurFocus((_arg_1.target as DisplayObject)))
            {
                drawFocus(false);
                isFocused = false;
            };
        }

        protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
        }

        protected function keyUpHandler(_arg_1:KeyboardEvent):void
        {
        }

        protected function hookAccessibility(_arg_1:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, hookAccessibility);
            initializeAccessibility();
        }

        protected function initializeAccessibility():void
        {
            if (UIComponent.createAccessibilityImplementation != null)
            {
                UIComponent.createAccessibilityImplementation(this);
            };
        }


    }
}//package fl.core

