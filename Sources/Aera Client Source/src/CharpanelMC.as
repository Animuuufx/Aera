// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//CharpanelMC

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.display.Graphics;
    import flash.text.TextField;
    import flash.text.*;

    public class CharpanelMC extends MovieClip 
    {

        public var bg:MovieClip;
        public var cnt:MovieClip;
        private var rootClass:MovieClip = (stage.getChildAt(0) as MovieClip);
        private var world:MovieClip = (rootClass.world as MovieClip);
        private var mcPopup:MovieClip = rootClass.ui.mcPopup;
        private var nextMode:String;
        private var uoLeaf:Object = world.myLeaf();
        private var uoData:Object = world.myAvatar.objData;
        private var sta:Object = uoLeaf.sta;
        private var stp:Object = new Object();
        private var stu:Object = new Object();
        private var stg:Object = new Object();
        private var pts:int = -1;
        private var upts:int = -1;
        private var spendStuC:Array = [1595286, 1470895, 1410498, 1349844, 1289447, 1229821];
        private var spendStpC:Array = [0xE66200, 0xEB7B00, 0xF08E00, 0xF4A100, 0xF9B400, 0xFFCC00];
        private var barVal:int = 150;
        private var spendStat:String = "none";
        private var spendOp:String = "";
        private var spendTicks:int = 0;
        private var spendVals:Array = [{
            "a":0,
            "b":1
        }, {
            "a":30,
            "b":3
        }, {
            "a":60,
            "b":9
        }];
        private var ttFields:Array = [];

        public function CharpanelMC():void
        {
            addFrameScript(0, frame1, 4, frame5, 11, frame12, 24, frame25);
            bg.x = 0;
            bg.btnClose.addEventListener(MouseEvent.MOUSE_DOWN, btnCloseClick, false, 0, true);
            bg.tTitle.text = "Class Overview";
        }

        public function openWith(_arg_1:Object):void
        {
            nextMode = _arg_1.typ;
            if (isValidMode(nextMode))
            {
                if (((!(this.currentLabel == "init")) && (this.currentLabel.indexOf("-out") < 0)))
                {
                    this.gotoAndPlay((this.currentLabel + "-out"));
                }
                else
                {
                    this.gotoAndPlay(nextMode);
                };
            };
        }

        public function fClose():void
        {
            var _local_1:Array;
            var _local_2:MovieClip;
            var _local_3:MovieClip;
            var _local_4:MovieClip;
            if (MovieClip(this).currentLabel.indexOf("overview") > -1)
            {
                try
                {
                    _local_1 = [cnt.abilities.a1, cnt.abilities.a2, cnt.abilities.a3, cnt.abilities.a4, cnt.abilities.p1, cnt.abilities.p2];
                    for each (_local_3 in _local_1)
                    {
                        _local_3.removeEventListener(MouseEvent.MOUSE_OVER, rootClass.actIconOver);
                        _local_3.addEventListener(MouseEvent.MOUSE_OUT, rootClass.actIconOut);
                        _local_3.actObj = null;
                    };
                }
                catch(e:Error)
                {
                };
            };
            bg.btnClose.removeEventListener(MouseEvent.MOUSE_DOWN, btnCloseClick);
            if (parent != null)
            {
                _local_4 = MovieClip(parent);
                _local_4.removeChild(this);
                _local_4.onClose();
                rootClass.stage.focus = null;
            };
        }

        private function playNextMode():void
        {
            this.gotoAndPlay(nextMode);
        }

        private function isValidMode(_arg_1:String):Boolean
        {
            var _local_2:Boolean;
            var _local_3:int;
            while (((_local_3 < this.currentLabels.length) && (!(_local_2))))
            {
                if (this.currentLabels[_local_3].name == _arg_1)
                {
                    _local_2 = true;
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function update():void
        {
            if (MovieClip(this).currentLabel.indexOf("overview") > -1)
            {
                updateNext();
            };
        }

        private function updateNext():void
        {
            var _local_7:MovieClip;
            var _local_15:*;
            var _local_1:MovieClip = MovieClip(this).cnt;
            var _local_2:Object = {};
            var _local_3:int;
            var _local_4:int;
            var _local_5:* = "";
            var _local_6:Boolean;
            _local_1.tDesc.autoSize = "left";
            _local_1.tMana.autoSize = "left";
            _local_1.tClass.text = (((uoData.strClassName + "  (Rank ") + uoData.iRank) + ")");
            _local_1.tDesc.text = uoData.sClassDesc;
            _local_1.tMana.text = "";
            for each (_local_5 in uoData.aClassMRM)
            {
                if (_local_5.charAt(0) == "-")
                {
                    _local_1.tMana.text = (_local_1.tMana.text + (" * " + _local_5.substr(1)));
                }
                else
                {
                    _local_1.tMana.text = (_local_1.tMana.text + _local_5);
                };
            };
            _local_1.tManaHeader.y = Math.round(((_local_1.tDesc.y + _local_1.tDesc.height) + 5));
            _local_1.tMana.y = Math.round(((_local_1.tManaHeader.y + _local_1.tManaHeader.height) + 2));
            _local_3 = Math.round((_local_1.tMana.y + _local_1.tMana.height));
            _local_1.abilities.y = Math.round((_local_3 + ((188 - _local_3) / 2)));
            if (_local_1.abilities.y > 188)
            {
                _local_1.abilities.y = 188;
            };
            var _local_8:* = ["aa", "a1", "a2", "a3", "a4", "p1", "p2", "p3"];
            _local_3 = 0;
            while (_local_3 < _local_8.length)
            {
                _local_2 = _local_8[_local_3];
                if (((_local_2 == "p3") && (world.actions.passive.length < 3)))
                {
                    _local_1.abilities.x = 46;
                    _local_1.abilities.getChildByName("tRank6").visible = false;
                    _local_1.abilities.getChildByName("p3").visible = false;
                }
                else
                {
                    _local_7 = (_local_1.abilities.getChildByName(_local_2) as MovieClip);
                    _local_7.actionIndex = _local_3;
                    _local_15 = rootClass.world.getActionByRef(_local_2);
                    if (_local_15 == null)
                    {
                        _local_7.visible = false;
                    }
                    else
                    {
                        _local_7.visible = true;
                        _local_7.tQty.visible = false;
                        rootClass.updateIcons([_local_7], _local_15.icon.split(","), null);
                        if (!_local_15.isOK)
                        {
                            _local_7.alpha = 0.33;
                        };
                        _local_7.actObj = _local_15;
                        _local_7.addEventListener(MouseEvent.MOUSE_OVER, rootClass.actIconOver, false, 0, true);
                        _local_7.addEventListener(MouseEvent.MOUSE_OUT, rootClass.actIconOut, false, 0, true);
                    };
                };
                _local_3++;
            };
            var _local_9:Graphics = _local_1.abilities.bg.graphics;
            _local_9.clear();
            _local_9.lineStyle(0, 0, 0);
            var _local_10:int;
            var _local_11:int;
            var _local_12:Number = 0x666666;
            var _local_13:* = "#FFFFFF";
            var _local_14:int = ((world.actions.passive.length < 3) ? 6 : 7);
            _local_10 = 0;
            while (_local_10 < _local_14)
            {
                _local_11 = (_local_10 * 51);
                _local_12 = 0x666666;
                _local_13 = "#FFFFFF";
                if (uoData.iRank < (_local_10 + 1))
                {
                    _local_12 = 0x242424;
                    _local_13 = "#999999";
                    _local_9.beginFill(_local_12);
                    _local_9.moveTo(_local_11, 19);
                    _local_9.lineTo((_local_11 + 50), 19);
                    _local_9.lineTo((_local_11 + 50), 127);
                    _local_9.lineTo(_local_11, 127);
                    _local_9.lineTo(_local_11, 19);
                    _local_9.endFill();
                };
                _local_9.beginFill(_local_12);
                _local_9.moveTo(_local_11, 0);
                _local_9.lineTo((_local_11 + 50), 0);
                _local_9.lineTo((_local_11 + 50), 18);
                _local_9.lineTo(_local_11, 18);
                _local_9.lineTo(_local_11, 0);
                _local_9.endFill();
                _local_9.beginFill(_local_12);
                _local_9.moveTo(_local_11, 128);
                _local_9.lineTo((_local_11 + 50), 128);
                _local_9.lineTo((_local_11 + 50), 132);
                _local_9.lineTo(_local_11, 132);
                _local_9.lineTo(_local_11, 128);
                _local_9.endFill();
                TextField(_local_1.abilities.getChildByName(("tRank" + (_local_10 + 1)))).htmlText = (((("<font color='" + _local_13) + "'>") + TextField(_local_1.abilities.getChildByName(("tRank" + (_local_10 + 1)))).text) + "</font>");
                _local_10++;
            };
        }

        private function btnCloseClick(_arg_1:MouseEvent):void
        {
            fClose();
        }

        internal function frame1():*
        {
            openWith(MovieClip(parent).fData);
        }

        internal function frame5():*
        {
            update();
        }

        internal function frame12():*
        {
            stop();
        }

        internal function frame25():*
        {
            playNextMode();
        }


    }
}//package 

