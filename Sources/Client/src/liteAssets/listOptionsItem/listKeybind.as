// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.listOptionsItem.listKeybind

package liteAssets.listOptionsItem
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.utils.Dictionary;
    import flash.events.MouseEvent;
    import flash.utils.describeType;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import liteAssets.handlers.optionHandler;
    import flash.events.*;

    public class listKeybind extends MovieClip 
    {

        public var txtName:TextField;
        public var txtKey:TextField;
        public var btnSetKeybindActive:SimpleButton;
        public var sKey:uint;
        public var sDesc:String;
        public var r:MovieClip;
        internal var keyDict:Dictionary;

        public function listKeybind(_arg_1:MovieClip, _arg_2:uint, _arg_3:String)
        {
            this.r = _arg_1;
            keyDict = getKeyboardDict();
            if (!_arg_2)
            {
                this.txtKey.text = "NONE";
            }
            else
            {
                this.txtKey.text = keyDict[_arg_2];
            };
            this.txtKey.mouseEnabled = false;
            this.sKey = _arg_2;
            this.sDesc = _arg_3;
            btnSetKeybindActive.addEventListener(MouseEvent.CLICK, onActive, false, 0, true);
        }

        internal function getKeyboardDict():Dictionary
        {
            var _local_1:XML = describeType(Keyboard);
            var _local_2:XMLList = _local_1.constant.@name;
            var _local_3:Dictionary = new Dictionary();
            var _local_4:int = _local_2.length();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_3[Keyboard[_local_2[_local_5]]] = _local_2[_local_5];
                _local_5++;
            };
            return (_local_3);
        }

        public function onActive(_arg_1:MouseEvent):void
        {
            r.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeybindKeyDown, false, 0, true);
            r.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseExit, false, 0, true);
            this.txtKey.text = "...";
        }

        public function onMouseExit(_arg_1:MouseEvent):void
        {
            r.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseExit);
            r.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeybindKeyDown);
            this.txtKey.text = keyDict[sKey];
        }

        public function handleKeybindKeyDown(_arg_1:KeyboardEvent):void
        {
            _arg_1.preventDefault();
            _arg_1.stopPropagation();
            var _local_2:* = _arg_1.keyCode;
            r.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeybindKeyDown);
            r.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseExit);
            if (((_arg_1.keyCode == Keyboard.ENTER) || (_arg_1.keyCode == 191)))
            {
                this.txtKey.text = keyDict[sKey];
                return;
            };
            if (((_arg_1.keyCode >= 96) && (_arg_1.keyCode <= 105)))
            {
                _arg_1.keyCode = (_arg_1.keyCode - 48);
            };
            if (_arg_1.keyCode == 8)
            {
                this.txtKey.text = "NONE";
                _local_2 = null;
            }
            else
            {
                this.txtKey.text = keyDict[_arg_1.keyCode];
            };
            optionHandler.key(r, txtName.text, _local_2);
            sKey = _local_2;
        }


    }
}//package liteAssets.listOptionsItem

