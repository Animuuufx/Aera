// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//apopBtn

package 
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.display.MovieClip;
    import fl.motion.Color;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.events.*;

    public class apopBtn extends Sprite 
    {

        public var txt:TextField;
        public var BG:btnBack;
        private var rootClass:MovieClip;
        private var intAction:int;
        private var locksArr:Array = new Array();
        private var intID:int = -1;
        private var strActionData:String;
        private var strAction:*;
        private var strFrame:String;
        private var strMap:String;
        private var strPad:String;
        private var id:int;
        private var tintColor:Color = new Color();
        private var parent_:apopScene;
        private var iconClass:Class;
        private var actionParams:Array;

        public function apopBtn(_arg_1:MovieClip, _arg_2:Object, _arg_3:apopScene)
        {
            var _local_4:DisplayObject;
            var _local_5:Number;
            super();
            this.rootClass = _arg_1;
            this.tintColor.setTint(0xFF0000, 0.27);
            this.parent_ = _arg_3;
            if (_arg_2.width != null)
            {
                this.BG.width = _arg_2.width;
            };
            if (_arg_2 != null)
            {
                this.intAction = int(_arg_2.intAction);
                this.setupLock(String(_arg_2.strLocks));
                this.actionParams = String(_arg_2.strActionData).split(",");
                this.id = int(_arg_2.buttonID);
                this.txt.text = _arg_2.buttonText;
                this.txt.mouseEnabled = false;
                if (_arg_2.strIcon != null)
                {
                    this.iconClass = this.rootClass.world.getClass(_arg_2.strIcon);
                    _local_4 = this.addChild(new this.iconClass());
                    _local_5 = (25 / _local_4.height);
                    _local_4.width = (_local_4.width * _local_5);
                    _local_4.height = 25;
                    if (_local_4.width < 43)
                    {
                        _local_4.x = ((43 - _local_4.width) >> 1);
                    };
                    if (_local_4.height < 30)
                    {
                        _local_4.y = (((30 - _local_4.height) >> 1) + 1);
                    };
                };
                this.addEventListener(MouseEvent.MOUSE_UP, this.onClick, false, 0, true);
                this.addEventListener(MouseEvent.MOUSE_OUT, this.onOut, false, 0, true);
                this.addEventListener(MouseEvent.MOUSE_OVER, this.onOver, false, 0, true);
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown, false, 0, true);
                this.buttonMode = true;
            };
        }

        private function onOut(_arg_1:MouseEvent):void
        {
            this.tintColor.setTint(0xFF0000, 0);
            this.transform.colorTransform = this.tintColor;
        }

        private function onOver(_arg_1:MouseEvent):void
        {
            this.tintColor.setTint(0xFF0000, 0.27);
            this.transform.colorTransform = this.tintColor;
        }

        private function onDown(_arg_1:MouseEvent):void
        {
            this.tintColor.setTint(0xFF0000, 0);
            this.tintColor.brightness = -0.28;
            this.transform.colorTransform = this.tintColor;
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            this.tintColor.setTint(0xFF0000, 0);
            this.tintColor.brightness = 0;
            this.transform.colorTransform = this.tintColor;
            if (this.checkLock())
            {
                switch (this.intAction)
                {
                    case 0:
                        this.parent_.Parent.showScene(this.actionParams[0]);
                        return;
                    case 1:
                        this.rootClass.world.sendLoadShopRequest(this.actionParams[0]);
                        return;
                    case 2:
                        this.rootClass.world.sendLoadHairShopRequest(this.actionParams[0]);
                        return;
                    case 3:
                        this.rootClass.world.sendLoadEnhShopRequest(this.actionParams[0]);
                        return;
                    case 4:
                        this.rootClass.world.attachMovieFront(this.actionParams[0]);
                        return;
                    case 5:
                        this.rootClass.loadExternalSWF(this.actionParams[0]);
                        return;
                    case 6:
                        this.rootClass.world.gotoTown(this.actionParams[0], this.actionParams[1], this.actionParams[2]);
                        this.rootClass.removeApop();
                        return;
                    case 7:
                        this.rootClass.world.moveToCell(this.actionParams[0], this.actionParams[1]);
                        return;
                    case 9:
                        this.rootClass.world.acceptQuest(this.parent_.QuestID);
                        this.rootClass.removeApop();
                        return;
                    case 10:
                        this.parent_.Back();
                        return;
                    case 11:
                        this.rootClass.world.tryQuestComplete(this.parent_.QuestID);
                        return;
                    case 12:
                        this.rootClass.world.abandonQuest(this.parent_.QuestID);
                        this.parent_.Back();
                        return;
                };
            };
        }

        private function setupLock(_arg_1:String):*
        {
            var _local_4:Array;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:Array = _arg_1.split(";");
            var _local_3:uint;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3].split(",");
                switch (_local_4[0])
                {
                    case "QS":
                    case "qs":
                        this.locksArr.push({
                            "strType":_local_4[0],
                            "qsIndex":_local_4[1],
                            "qsValue":_local_4[2]
                        });
                        break;
                    case "mapVar":
                        this.locksArr.push({
                            "strType":_local_4[0],
                            "strName":_local_4[1]
                        });
                        break;
                    case "rep":
                        this.locksArr.push({
                            "strType":_local_4[0],
                            "intRep":_local_4[1],
                            "intValue":_local_4[2]
                        });
                        break;
                    case "class":
                    case "classor":
                        this.locksArr.push({
                            "strType":_local_4[0],
                            "intClass":_local_4[1],
                            "intValue":_local_4[2]
                        });
                        break;
                    case "item":
                        this.locksArr.push({
                            "strType":_local_4[0],
                            "intID":_local_4[1]
                        });
                        break;
                    case "upgrade":
                        this.locksArr.push({"strType":"upgrade"});
                        break;
                };
                _local_3++;
            };
        }

        private function checkLock():Boolean
        {
            var _local_1:Boolean = true;
            var _local_2:uint;
            while (_local_2 < this.locksArr.length)
            {
                switch (this.locksArr[_local_2].strType)
                {
                    case "QS":
                    case "qs":
                        _local_1 = ((_local_1) && (this.rootClass.getQuestValue(this.locksArr[_local_2].qsIndex) >= this.locksArr[_local_2].qsValue));
                        break;
                    case "mapVar":
                        _local_1 = ((_local_1) && (this.rootClass.world.map[this.locksArr[_local_2].strName]));
                        break;
                    case "rep":
                        _local_1 = ((_local_1) && (this.rootClass.world.myAvatar.getRep(this.locksArr[_local_2].intRep) >= this.locksArr[_local_2].intValue));
                        break;
                    case "class":
                        _local_1 = ((_local_1) && (this.rootClass.world.myAvatar.getCPByID(this.locksArr[_local_2].intClass) >= Number(this.locksArr[_local_2].intValue)));
                        break;
                    case "classor":
                        _local_1 = ((_local_1) || (this.rootClass.world.myAvatar.getCPByID(this.locksArr[_local_2].intClass) >= Number(this.locksArr[_local_2].intValue)));
                        break;
                    case "item":
                        _local_1 = ((_local_1) && (this.rootClass.world.myAvatar.isItemInInventory(int(this.locksArr[_local_2].intID))));
                        break;
                    case "upgrade":
                        _local_1 = ((_local_1) && (this.rootClass.world.myAvatar.isUpgraded()));
                        break;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function get ID():int
        {
            return (this.id);
        }


    }
}//package 

