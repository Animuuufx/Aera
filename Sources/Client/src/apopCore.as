// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//apopCore

package 
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class apopCore extends Sprite 
    {

        public var mcBG:MovieClip;
        public var btnClose:SimpleButton;
        public var txtName:TextField;
        public var txtTitle:TextField;
        private var rootClass:MovieClip;
        private var apopData:Object;
        private var apopScenes:Object = new Object();
        private var currentScene:apopScene;
        private var nullScene:apopScene;
        private var questArray:Array = new Array();
        private var mcNPC:MovieClip;
        private var finalX:Number;

        public function apopCore(_arg_1:MovieClip, _arg_2:Object)
        {
            var _local_3:apopScene;
            var _local_4:Array;
            var _local_7:uint;
            super();
            this.rootClass = _arg_1;
            this.txtName.text = _arg_2.strName;
            this.txtTitle.text = _arg_2.strTitle;
            var _local_5:uint;
            while (_local_5 < _arg_2.arrScenes.length)
            {
                _local_3 = new apopScene(this.rootClass, _arg_2.arrScenes[_local_5], this);
                if (_local_3.ID != -1)
                {
                    this.apopScenes[_local_3.ID] = _local_3;
                    if (_arg_2.arrScenes[_local_5].arrQuests != null)
                    {
                        _local_4 = String(_arg_2.arrScenes[_local_5].arrQuests).split(",");
                        _local_7 = 0;
                        while (_local_7 < _local_4.length)
                        {
                            _local_3 = new apopScene(this.rootClass, {
                                "bType":true,
                                "sceneID":_local_4[_local_7],
                                "bStart":false,
                                "qID":_local_4[_local_7]
                            }, this);
                            if (_local_3.ID != -1)
                            {
                                this.apopScenes[("q" + String(_local_3.ID))] = _local_3;
                            };
                            _local_7++;
                        };
                    };
                };
                _local_5++;
            };
            this.nullScene = new apopScene(this.rootClass, {
                "bType":false,
                "strText":"This text is broken, please report this bug using the bug tracker. https://nightvaults.com/",
                "ID":-1,
                "bStart":false
            }, this);
            this.nullScene.x = 5;
            this.nullScene.y = 60;
            this.btnClose.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true);
            this.showScene(this.getStartScene());
            var _local_6:Class = this.rootClass.world.map.getNPC(_arg_2.strNpc);
            this.mcNPC = (this.addChildAt((new (_local_6)() as MovieClip), 0) as MovieClip);
            this.finalX = (this.mcNPC.x - 80);
            this.mcNPC.y = (this.mcNPC.y + 130);
            this.mcNPC.x = (this.mcNPC.x - 160);
            this.addEventListener(Event.ENTER_FRAME, this.animateNPC, false, 0, true);
        }

        private function getStartScene():int
        {
            var _local_1:apopScene;
            var _local_2:apopScene;
            var _local_3:*;
            for (_local_3 in this.apopScenes)
            {
                if (this.apopScenes[_local_3].Start)
                {
                    _local_2 = this.apopScenes[_local_3];
                    if (!_local_2.Locked)
                    {
                        if (_local_1 == null)
                        {
                            _local_1 = _local_2;
                        }
                        else
                        {
                            if (_local_2.ID > _local_1.ID)
                            {
                                _local_1 = _local_2;
                            };
                        };
                    };
                };
            };
            return ((_local_1 != null) ? _local_1.ID : -1);
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            this.rootClass.removeApop();
        }

        private function animateNPC(_arg_1:Event):void
        {
            this.mcNPC.x = (this.mcNPC.x + 10);
            if (this.mcNPC.x >= this.finalX)
            {
                this.mcNPC.x = this.finalX;
                this.removeEventListener(Event.ENTER_FRAME, this.animateNPC);
            };
        }

        public function showScene(_arg_1:int, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_4:int = -1;
            if (this.currentScene != null)
            {
                _local_4 = ((_arg_2) ? -1 : this.currentScene.ID);
                this.removeChild(this.currentScene);
            };
            this.currentScene = ((_arg_3) ? this.apopScenes[("q" + String(_arg_1))] : this.apopScenes[_arg_1]);
            if (this.currentScene != null)
            {
                this.currentScene.x = 15;
                this.currentScene.y = 60;
                this.currentScene.init(_local_4);
                this.addChild(this.currentScene);
                this.mcBG.height = (this.currentScene.mcGold.height + 80);
            }
            else
            {
                this.currentScene = this.nullScene;
                this.addChild(this.nullScene);
            };
        }

        public function questComplete(_arg_1:int):void
        {
            if (this.currentScene.ID == _arg_1)
            {
                this.currentScene.Back();
            };
        }

        public function getScene(_arg_1:int):*
        {
            return (this.apopScenes[_arg_1]);
        }

        public function getQuestScene(_arg_1:String):*
        {
            return (this.apopScenes[_arg_1]);
        }


    }
}//package 

