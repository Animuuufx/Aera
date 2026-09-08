// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.managers.FocusManager

package fl.managers
{
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.display.InteractiveObject;
    import fl.controls.Button;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.display.Stage;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import fl.core.UIComponent;
    import flash.text.TextFieldType;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.*;

    public class FocusManager implements IFocusManager 
    {

        private var _form:DisplayObjectContainer;
        private var focusableObjects:Dictionary;
        private var focusableCandidates:Array;
        private var activated:Boolean = false;
        private var calculateCandidates:Boolean = true;
        private var lastFocus:InteractiveObject;
        private var _showFocusIndicator:Boolean = true;
        private var lastAction:String;
        private var defButton:Button;
        private var _defaultButton:Button;
        private var _defaultButtonEnabled:Boolean = true;

        public function FocusManager(_arg_1:DisplayObjectContainer)
        {
            focusableObjects = new Dictionary(true);
            if (_arg_1 != null)
            {
                _form = _arg_1;
                activate();
            };
        }

        private function addedHandler(_arg_1:Event):void
        {
            var _local_2:DisplayObject = DisplayObject(_arg_1.target);
            if (_local_2.stage)
            {
                addFocusables(DisplayObject(_arg_1.target));
            };
        }

        private function removedHandler(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_4:InteractiveObject;
            var _local_3:DisplayObject = DisplayObject(_arg_1.target);
            if (((_local_3 is IFocusManagerComponent) && (focusableObjects[_local_3] == true)))
            {
                if (_local_3 == lastFocus)
                {
                    IFocusManagerComponent(lastFocus).drawFocus(false);
                    lastFocus = null;
                };
                _local_3.removeEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false);
                delete focusableObjects[_local_3];
                calculateCandidates = true;
            }
            else
            {
                if (((_local_3 is InteractiveObject) && (focusableObjects[_local_3] == true)))
                {
                    _local_4 = (_local_3 as InteractiveObject);
                    if (_local_4)
                    {
                        if (_local_4 == lastFocus)
                        {
                            lastFocus = null;
                        };
                        delete focusableObjects[_local_4];
                        calculateCandidates = true;
                    };
                    _local_3.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false, 0, true);
                };
            };
            removeFocusables(_local_3);
        }

        private function addFocusables(o:DisplayObject, skipTopLevel:Boolean=false):void
        {
            var focusable:IFocusManagerComponent;
            var io:InteractiveObject;
            var doc:DisplayObjectContainer;
            var docParent:DisplayObjectContainer;
            var i:int;
            var child:DisplayObject;
            if (!skipTopLevel)
            {
                if ((o is IFocusManagerComponent))
                {
                    focusable = IFocusManagerComponent(o);
                    if (focusable.focusEnabled)
                    {
                        if (((focusable.tabEnabled) && (isTabVisible(o))))
                        {
                            focusableObjects[o] = true;
                            calculateCandidates = true;
                        };
                        o.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false, 0, true);
                        o.addEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler, false, 0, true);
                    };
                }
                else
                {
                    if ((o is InteractiveObject))
                    {
                        io = (o as InteractiveObject);
                        if ((((io) && (io.tabEnabled)) && (findFocusManagerComponent(io) == io)))
                        {
                            focusableObjects[io] = true;
                            calculateCandidates = true;
                        };
                        io.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false, 0, true);
                        io.addEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler, false, 0, true);
                    };
                };
            };
            if ((o is DisplayObjectContainer))
            {
                doc = DisplayObjectContainer(o);
                o.addEventListener(Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler, false, 0, true);
                docParent = null;
                try
                {
                    docParent = doc.parent;
                }
                catch(se:SecurityError)
                {
                    docParent = null;
                };
                if ((((doc is Stage) || (docParent is Stage)) || (doc.tabChildren)))
                {
                    i = 0;
                    while (i < doc.numChildren)
                    {
                        try
                        {
                            child = doc.getChildAt(i);
                            if (child != null)
                            {
                                addFocusables(doc.getChildAt(i));
                            };
                        }
                        catch(error:SecurityError)
                        {
                        };
                        i = (i + 1);
                    };
                };
            };
        }

        private function removeFocusables(_arg_1:DisplayObject):void
        {
            var _local_2:Object;
            var _local_3:DisplayObject;
            if ((_arg_1 is DisplayObjectContainer))
            {
                _arg_1.removeEventListener(Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler, false);
                _arg_1.removeEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler, false);
                for (_local_2 in focusableObjects)
                {
                    _local_3 = DisplayObject(_local_2);
                    if (DisplayObjectContainer(_arg_1).contains(_local_3))
                    {
                        if (_local_3 == lastFocus)
                        {
                            lastFocus = null;
                        };
                        _local_3.removeEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false);
                        delete focusableObjects[_local_2];
                        calculateCandidates = true;
                    };
                };
            };
        }

        private function isTabVisible(o:DisplayObject):Boolean
        {
            var p:DisplayObjectContainer;
            try
            {
                p = o.parent;
                while ((((p) && (!(p is Stage))) && (!((p.parent) && (p.parent is Stage)))))
                {
                    if (!p.tabChildren)
                    {
                        return (false);
                    };
                    p = p.parent;
                };
            }
            catch(se:SecurityError)
            {
            };
            return (true);
        }

        private function isValidFocusCandidate(_arg_1:DisplayObject, _arg_2:String):Boolean
        {
            var _local_3:IFocusManagerGroup;
            if (!isEnabledAndVisible(_arg_1))
            {
                return (false);
            };
            if ((_arg_1 is IFocusManagerGroup))
            {
                _local_3 = IFocusManagerGroup(_arg_1);
                if (_arg_2 == _local_3.groupName)
                {
                    return (false);
                };
            };
            return (true);
        }

        private function isEnabledAndVisible(o:DisplayObject):Boolean
        {
            var formParent:DisplayObjectContainer;
            var tf:TextField;
            var sb:SimpleButton;
            try
            {
                formParent = DisplayObject(form).parent;
                while (o != formParent)
                {
                    if ((o is UIComponent))
                    {
                        if (!UIComponent(o).enabled)
                        {
                            return (false);
                        };
                    }
                    else
                    {
                        if ((o is TextField))
                        {
                            tf = TextField(o);
                            if (((tf.type == TextFieldType.DYNAMIC) || (!(tf.selectable))))
                            {
                                return (false);
                            };
                        }
                        else
                        {
                            if ((o is SimpleButton))
                            {
                                sb = SimpleButton(o);
                                if (!sb.enabled)
                                {
                                    return (false);
                                };
                            };
                        };
                    };
                    if (!o.visible)
                    {
                        return (false);
                    };
                    o = o.parent;
                };
            }
            catch(se:SecurityError)
            {
            };
            return (true);
        }

        private function tabEnabledChangeHandler(_arg_1:Event):void
        {
            calculateCandidates = true;
            var _local_2:InteractiveObject = InteractiveObject(_arg_1.target);
            var _local_3:* = (focusableObjects[_local_2] == true);
            if (_local_2.tabEnabled)
            {
                if (((!(_local_3)) && (isTabVisible(_local_2))))
                {
                    if (!(_local_2 is IFocusManagerComponent))
                    {
                        _local_2.focusRect = false;
                    };
                    focusableObjects[_local_2] = true;
                };
            }
            else
            {
                if (_local_3)
                {
                    delete focusableObjects[_local_2];
                };
            };
        }

        private function tabIndexChangeHandler(_arg_1:Event):void
        {
            calculateCandidates = true;
        }

        private function tabChildrenChangeHandler(_arg_1:Event):void
        {
            if (_arg_1.target != _arg_1.currentTarget)
            {
                return;
            };
            calculateCandidates = true;
            var _local_2:DisplayObjectContainer = DisplayObjectContainer(_arg_1.target);
            if (_local_2.tabChildren)
            {
                addFocusables(_local_2, true);
            }
            else
            {
                removeFocusables(_local_2);
            };
        }

        public function activate():void
        {
            if (activated)
            {
                return;
            };
            addFocusables(form);
            form.addEventListener(Event.ADDED, addedHandler, false, 0, true);
            form.addEventListener(Event.REMOVED, removedHandler, false, 0, true);
            try
            {
                form.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
                form.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
                form.stage.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
                form.stage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
            }
            catch(se:SecurityError)
            {
                form.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
                form.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
                form.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
                form.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
            };
            form.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true, 0, true);
            form.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true, 0, true);
            form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            form.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true, 0, true);
            activated = true;
            if (lastFocus)
            {
                setFocus(lastFocus);
            };
        }

        public function deactivate():void
        {
            if (!activated)
            {
                return;
            };
            focusableObjects = new Dictionary(true);
            focusableCandidates = null;
            lastFocus = null;
            defButton = null;
            form.removeEventListener(Event.ADDED, addedHandler, false);
            form.removeEventListener(Event.REMOVED, removedHandler, false);
            try
            {
                form.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false);
                form.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false);
                form.stage.removeEventListener(Event.ACTIVATE, activateHandler, false);
                form.stage.removeEventListener(Event.DEACTIVATE, deactivateHandler, false);
            }
            catch(se:SecurityError)
            {
            };
            form.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false);
            form.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false);
            form.removeEventListener(Event.ACTIVATE, activateHandler, false);
            form.removeEventListener(Event.DEACTIVATE, deactivateHandler, false);
            form.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
            form.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false);
            form.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = false;
        }

        private function focusInHandler(_arg_1:FocusEvent):void
        {
            var _local_3:Button;
            if (!activated)
            {
                return;
            };
            var _local_2:InteractiveObject = InteractiveObject(_arg_1.target);
            if (form.contains(_local_2))
            {
                lastFocus = findFocusManagerComponent(InteractiveObject(_local_2));
                if ((lastFocus is Button))
                {
                    _local_3 = Button(lastFocus);
                    if (defButton)
                    {
                        defButton.emphasized = false;
                        defButton = _local_3;
                        _local_3.emphasized = true;
                    };
                }
                else
                {
                    if (((defButton) && (!(defButton == _defaultButton))))
                    {
                        defButton.emphasized = false;
                        defButton = _defaultButton;
                        _defaultButton.emphasized = true;
                    };
                };
            };
        }

        private function focusOutHandler(_arg_1:FocusEvent):void
        {
            if (!activated)
            {
                return;
            };
            var _local_2:InteractiveObject = (_arg_1.target as InteractiveObject);
        }

        private function activateHandler(_arg_1:Event):void
        {
            if (!activated)
            {
                return;
            };
            var _local_2:InteractiveObject = InteractiveObject(_arg_1.target);
            if (lastFocus)
            {
                if ((lastFocus is IFocusManagerComponent))
                {
                    IFocusManagerComponent(lastFocus).setFocus();
                }
                else
                {
                    form.stage.focus = lastFocus;
                };
            };
            lastAction = "ACTIVATE";
        }

        private function deactivateHandler(_arg_1:Event):void
        {
            if (!activated)
            {
                return;
            };
            var _local_2:InteractiveObject = InteractiveObject(_arg_1.target);
        }

        private function mouseFocusChangeHandler(_arg_1:FocusEvent):void
        {
            if (!activated)
            {
                return;
            };
            if ((_arg_1.relatedObject is TextField))
            {
                return;
            };
            _arg_1.preventDefault();
        }

        private function keyFocusChangeHandler(_arg_1:FocusEvent):void
        {
            if (!activated)
            {
                return;
            };
            showFocusIndicator = true;
            if ((((_arg_1.keyCode == Keyboard.TAB) || (_arg_1.keyCode == 0)) && (!(_arg_1.isDefaultPrevented()))))
            {
                setFocusToNextObject(_arg_1);
                _arg_1.preventDefault();
            };
        }

        private function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            if (!activated)
            {
                return;
            };
            if (_arg_1.keyCode == Keyboard.TAB)
            {
                lastAction = "KEY";
                if (calculateCandidates)
                {
                    sortFocusableObjects();
                    calculateCandidates = false;
                };
            };
            if (((((defaultButtonEnabled) && (_arg_1.keyCode == Keyboard.ENTER)) && (defaultButton)) && (defButton.enabled)))
            {
                sendDefaultButtonEvent();
            };
        }

        private function mouseDownHandler(_arg_1:MouseEvent):void
        {
            if (!activated)
            {
                return;
            };
            if (_arg_1.isDefaultPrevented())
            {
                return;
            };
            var _local_2:InteractiveObject = getTopLevelFocusTarget(InteractiveObject(_arg_1.target));
            if (!_local_2)
            {
                return;
            };
            showFocusIndicator = false;
            if ((((!(_local_2 == lastFocus)) || (lastAction == "ACTIVATE")) && (!(_local_2 is TextField))))
            {
                setFocus(_local_2);
            };
            lastAction = "MOUSEDOWN";
        }

        public function get defaultButton():Button
        {
            return (_defaultButton);
        }

        public function set defaultButton(_arg_1:Button):void
        {
            var _local_2:Button = ((_arg_1) ? Button(_arg_1) : null);
            if (_local_2 != _defaultButton)
            {
                if (_defaultButton)
                {
                    _defaultButton.emphasized = false;
                };
                if (defButton)
                {
                    defButton.emphasized = false;
                };
                _defaultButton = _local_2;
                defButton = _local_2;
                if (_local_2)
                {
                    _local_2.emphasized = true;
                };
            };
        }

        public function sendDefaultButtonEvent():void
        {
            defButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        private function setFocusToNextObject(_arg_1:FocusEvent):void
        {
            if (!hasFocusableObjects())
            {
                return;
            };
            var _local_2:InteractiveObject = getNextFocusManagerComponent(_arg_1.shiftKey);
            if (_local_2)
            {
                setFocus(_local_2);
            };
        }

        private function hasFocusableObjects():Boolean
        {
            var _local_1:Object;
            for (_local_1 in focusableObjects)
            {
                return (true);
            };
            return (false);
        }

        public function getNextFocusManagerComponent(_arg_1:Boolean=false):InteractiveObject
        {
            var _local_8:IFocusManagerGroup;
            if (!hasFocusableObjects())
            {
                return (null);
            };
            if (calculateCandidates)
            {
                sortFocusableObjects();
                calculateCandidates = false;
            };
            var _local_2:DisplayObject = form.stage.focus;
            _local_2 = DisplayObject(findFocusManagerComponent(InteractiveObject(_local_2)));
            var _local_3:* = "";
            if ((_local_2 is IFocusManagerGroup))
            {
                _local_8 = IFocusManagerGroup(_local_2);
                _local_3 = _local_8.groupName;
            };
            var _local_4:int = getIndexOfFocusedObject(_local_2);
            var _local_5:Boolean;
            var _local_6:int = _local_4;
            if (_local_4 == -1)
            {
                if (_arg_1)
                {
                    _local_4 = focusableCandidates.length;
                };
                _local_5 = true;
            };
            var _local_7:int = getIndexOfNextObject(_local_4, _arg_1, _local_5, _local_3);
            return (findFocusManagerComponent(focusableCandidates[_local_7]));
        }

        private function getIndexOfFocusedObject(_arg_1:DisplayObject):int
        {
            var _local_2:int = focusableCandidates.length;
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                if (focusableCandidates[_local_3] == _arg_1)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (-1);
        }

        private function getIndexOfNextObject(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean, _arg_4:String):int
        {
            var _local_7:DisplayObject;
            var _local_8:IFocusManagerGroup;
            var _local_9:int;
            var _local_10:DisplayObject;
            var _local_11:IFocusManagerGroup;
            var _local_5:int = focusableCandidates.length;
            var _local_6:int = _arg_1;
            while (true)
            {
                if (_arg_2)
                {
                    _arg_1--;
                }
                else
                {
                    _arg_1++;
                };
                if (_arg_3)
                {
                    if (((_arg_2) && (_arg_1 < 0))) break;
                    if (((!(_arg_2)) && (_arg_1 == _local_5))) break;
                }
                else
                {
                    _arg_1 = ((_arg_1 + _local_5) % _local_5);
                    if (_local_6 == _arg_1) break;
                };
                if (isValidFocusCandidate(focusableCandidates[_arg_1], _arg_4))
                {
                    _local_7 = DisplayObject(findFocusManagerComponent(focusableCandidates[_arg_1]));
                    if ((_local_7 is IFocusManagerGroup))
                    {
                        _local_8 = IFocusManagerGroup(_local_7);
                        _local_9 = 0;
                        while (_local_9 < focusableCandidates.length)
                        {
                            _local_10 = focusableCandidates[_local_9];
                            if ((_local_10 is IFocusManagerGroup))
                            {
                                _local_11 = IFocusManagerGroup(_local_10);
                                if (((_local_11.groupName == _local_8.groupName) && (_local_11.selected)))
                                {
                                    _arg_1 = _local_9;
                                    break;
                                };
                            };
                            _local_9++;
                        };
                    };
                    return (_arg_1);
                };
            };
            return (_arg_1);
        }

        private function sortFocusableObjects():void
        {
            var _local_1:Object;
            var _local_2:InteractiveObject;
            focusableCandidates = [];
            for (_local_1 in focusableObjects)
            {
                _local_2 = InteractiveObject(_local_1);
                if ((((_local_2.tabIndex) && (!(isNaN(Number(_local_2.tabIndex))))) && (_local_2.tabIndex > 0)))
                {
                    sortFocusableObjectsTabIndex();
                    return;
                };
                focusableCandidates.push(_local_2);
            };
            focusableCandidates.sort(sortByDepth);
        }

        private function sortFocusableObjectsTabIndex():void
        {
            var _local_1:Object;
            var _local_2:InteractiveObject;
            focusableCandidates = [];
            for (_local_1 in focusableObjects)
            {
                _local_2 = InteractiveObject(_local_1);
                if (((_local_2.tabIndex) && (!(isNaN(Number(_local_2.tabIndex))))))
                {
                    focusableCandidates.push(_local_2);
                };
            };
            focusableCandidates.sort(sortByTabIndex);
        }

        private function sortByDepth(aa:InteractiveObject, bb:InteractiveObject):Number
        {
            var index:int;
            var tmp:String;
            var tmp2:String;
            var val1:String = "";
            var val2:String = "";
            var zeros:String = "0000";
            var a:DisplayObject = DisplayObject(aa);
            var b:DisplayObject = DisplayObject(bb);
            try
            {
                while (((!(a == DisplayObject(form))) && (a.parent)))
                {
                    index = getChildIndex(a.parent, a);
                    tmp = index.toString(16);
                    if (tmp.length < 4)
                    {
                        tmp2 = (zeros.substring(0, (4 - tmp.length)) + tmp);
                    };
                    val1 = (tmp2 + val1);
                    a = a.parent;
                };
            }
            catch(se1:SecurityError)
            {
            };
            try
            {
                while (((!(b == DisplayObject(form))) && (b.parent)))
                {
                    index = getChildIndex(b.parent, b);
                    tmp = index.toString(16);
                    if (tmp.length < 4)
                    {
                        tmp2 = (zeros.substring(0, (4 - tmp.length)) + tmp);
                    };
                    val2 = (tmp2 + val2);
                    b = b.parent;
                };
            }
            catch(se2:SecurityError)
            {
            };
            return ((val1 > val2) ? 1 : ((val1 < val2) ? -1 : 0));
        }

        private function getChildIndex(_arg_1:DisplayObjectContainer, _arg_2:DisplayObject):int
        {
            return (_arg_1.getChildIndex(_arg_2));
        }

        private function sortByTabIndex(_arg_1:InteractiveObject, _arg_2:InteractiveObject):int
        {
            return ((_arg_1.tabIndex > _arg_2.tabIndex) ? 1 : ((_arg_1.tabIndex < _arg_2.tabIndex) ? -1 : sortByDepth(_arg_1, _arg_2)));
        }

        public function get defaultButtonEnabled():Boolean
        {
            return (_defaultButtonEnabled);
        }

        public function set defaultButtonEnabled(_arg_1:Boolean):void
        {
            _defaultButtonEnabled = _arg_1;
        }

        public function get nextTabIndex():int
        {
            return (0);
        }

        public function get showFocusIndicator():Boolean
        {
            return (_showFocusIndicator);
        }

        public function set showFocusIndicator(_arg_1:Boolean):void
        {
            _showFocusIndicator = _arg_1;
        }

        public function get form():DisplayObjectContainer
        {
            return (_form);
        }

        public function set form(_arg_1:DisplayObjectContainer):void
        {
            _form = _arg_1;
        }

        public function getFocus():InteractiveObject
        {
            var _local_1:InteractiveObject = form.stage.focus;
            return (findFocusManagerComponent(_local_1));
        }

        public function setFocus(_arg_1:InteractiveObject):void
        {
            if ((_arg_1 is IFocusManagerComponent))
            {
                IFocusManagerComponent(_arg_1).setFocus();
            }
            else
            {
                form.stage.focus = _arg_1;
            };
        }

        public function showFocus():void
        {
        }

        public function hideFocus():void
        {
        }

        public function findFocusManagerComponent(component:InteractiveObject):InteractiveObject
        {
            var p:InteractiveObject = component;
            try
            {
                while (component)
                {
                    if (((component is IFocusManagerComponent) && (IFocusManagerComponent(component).focusEnabled)))
                    {
                        return (component);
                    };
                    component = component.parent;
                };
            }
            catch(se:SecurityError)
            {
            };
            return (p);
        }

        private function getTopLevelFocusTarget(o:InteractiveObject):InteractiveObject
        {
            try
            {
                while (o != InteractiveObject(form))
                {
                    if (((((o is IFocusManagerComponent) && (IFocusManagerComponent(o).focusEnabled)) && (IFocusManagerComponent(o).mouseFocusEnabled)) && (UIComponent(o).enabled)))
                    {
                        return (o);
                    };
                    o = o.parent;
                    if (o == null) break;
                };
            }
            catch(se:SecurityError)
            {
            };
            return (null);
        }


    }
}//package fl.managers

