// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.qRewardPrev

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.net.*;
    import flash.text.*;

    public class qRewardPrev extends MovieClip 
    {

        public var cnt:MovieClip;
        public var world:MovieClip;
        public var rootClass:MovieClip;
        public var qData:Object = null;
        internal var qMode:String = null;
        internal var choiceID:int = -1;
        internal var isOpen:Boolean = false;
        internal var mc:MovieClip;
        internal var mDown:Boolean = false;
        internal var hRun:int = 0;
        internal var dRun:int = 0;
        internal var mbY:int = 0;
        internal var mhY:int = 0;
        internal var mbD:int = 0;
        internal var qly:int = 70;
        internal var qdy:int = 58;
        internal var qla:Array = [];
        internal var qlb:Array = [];
        public var qIDs:Array = [];
        public var sIDs:Array = [];
        public var tIDs:Array = [];
        private var previewArgs:Object = {};
        private var curItem:Object;
        private var sLinkArmor:String = "";
        private var sLinkCape:String = "";
        private var sLinkHelm:String = "";
        private var sLinkPet:String = "";
        private var sLinkWeapon:String = "";
        private var pLoaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        private var pLoaderC:LoaderContext = new LoaderContext(false, pLoaderD);
        private var loaderStack:Array = [];
        private var killStack:Array = [];
        internal var mcPreview:MovieClip;
        internal var rItem:Object;

        public function qRewardPrev(_arg_1:Object):void
        {
            addFrameScript(6, frame7, 11, frame12, 15, frame16);
            this.rItem = _arg_1;
            mc = MovieClip(this);
            mc.name = "qRewardPrev";
            mc.x = (377.1 - 5);
            mc.y = 65;
            mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK, xClick);
        }

        public function tryClick(_arg_1:MouseEvent):void
        {
            rootClass.xTryMe(rItem);
            fClose();
        }

        public function isDropPreview():void
        {
            mc.x = (mc.x - 75);
        }

        public function open():*
        {
            rootClass = MovieClip(this.stage.getChildAt(0));
            world = rootClass.world;
            mc = MovieClip(this);
            mc.cnt.bg.fx.visible = false;
            if (rootClass.isDialoqueUp())
            {
                mc.cnt.bg.fx.visible = true;
            };
            if (!isOpen)
            {
                isOpen = true;
                mc.cnt.gotoAndPlay("intro");
            }
            else
            {
                isOpen = false;
                fClose();
            };
            switch (rItem.sES)
            {
                case "Weapon":
                case "he":
                case "ba":
                case "pe":
                case "ar":
                case "co":
                    if (rItem.bUpg == 1)
                    {
                        if (!world.myAvatar.isUpgraded())
                        {
                            mc.cnt.bg.btnTry.visible = false;
                            break;
                        };
                    };
                    mc.cnt.bg.btnTry.visible = true;
                    break;
                case "ho":
                case "hi":
                default:
                    mc.cnt.bg.btnTry.visible = false;
            };
            mc.cnt.bg.btnPin.visible = false;
            mc.cnt.bg.btnWiki.visible = true;
            if (mc.cnt.bg.btnTry.visible)
            {
                mc.cnt.bg.btnWiki.y = 57.3;
            };
            mc.cnt.bg.btnWiki.addEventListener(MouseEvent.CLICK, onWikiClick, false, 0, true);
            mc.cnt.bg.btnTry.addEventListener(MouseEvent.CLICK, tryClick, false, 0, true);
        }

        public function onWikiClick(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(("http://aqwwiki.wikidot.com/" + rItem.sName)), "_blank");
        }

        public function showQuestList():*
        {
            buildReward();
            mc.cnt.strTitle.x = 53;
            mc.cnt.strTitle.width = 0x0100;
            mc.cnt.strTitle.htmlText = rItem.sName;
            mc.cnt.strTitle.mouseEnabled = false;
            mc.cnt.qList.visible = true;
            mc.cnt.qList.mHi.visible = false;
            mc.cnt.mouseChildren = true;
            mcPreview.mouseEnabled = (mcPreview.mouseChildren = false);
        }

        private function buildReward():*
        {
            mcPreview = mc.cnt.qList;
            var _local_1:* = mc.cnt.scr;
            var _local_2:* = mc.cnt.bMask;
            _local_1.visible = false;
            while (mcPreview.numChildren > 0)
            {
                mcPreview.removeChildAt(0);
            };
            loadPreview(rItem);
        }

        private function loadPreview(_arg_1:Object):void
        {
            if (_arg_1.sType.toLowerCase() != "enhancement")
            {
                if (curItem != _arg_1)
                {
                    curItem = _arg_1;
                    switch (_arg_1.sES)
                    {
                        case "Weapon":
                            loadWeapon(_arg_1.sFile, _arg_1.sLink);
                            break;
                        case "he":
                            loadHelm(_arg_1.sFile, _arg_1.sLink);
                            break;
                        case "ba":
                            loadCape(_arg_1.sFile, _arg_1.sLink);
                            break;
                        case "pe":
                            loadPet(_arg_1.sFile, _arg_1.sLink);
                            break;
                        case "ar":
                        case "co":
                            loadArmor(_arg_1.sFile, _arg_1.sLink);
                            break;
                        case "ho":
                            loadHouse(_arg_1.sFile);
                            break;
                        case "hi":
                            loadHouseItem(_arg_1.sFile, _arg_1.sLink);
                            break;
                        default:
                            loadBag(_arg_1);
                    };
                };
            }
            else
            {
                loadEnhancement(_arg_1);
            };
        }

        private function clearPreview():void
        {
            var _local_3:int;
            clearLoaderStack();
            var _local_1:Boolean = true;
            var _local_2:int;
            while (_local_2 < mcPreview.numChildren)
            {
                _local_1 = true;
                if (("fClose" in MovieClip(mcPreview.getChildAt(_local_2))))
                {
                    rootClass.recursiveStop(MovieClip(mcPreview.getChildAt(_local_2)));
                    _local_3 = 0;
                    while (_local_3 < killStack.length)
                    {
                        if (killStack[_local_3].mc == mcPreview.getChildAt(_local_2))
                        {
                            _local_1 = false;
                        };
                        _local_3++;
                    };
                    if (_local_1)
                    {
                        killStack.push({
                            "c":0,
                            "mc":mcPreview.getChildAt(_local_2)
                        });
                    };
                }
                else
                {
                    mcPreview.removeChildAt(_local_2);
                    _local_2--;
                };
                _local_2++;
            };
            curItem = null;
        }

        private function loadEnhancement(item:*):void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            clearPreview();
            try
            {
                AssetClass = (rootClass.world.getClass("iidesign") as Class);
                mc = new (AssetClass)();
            }
            catch(err:Error)
            {
            };
            mc.scaleX = (mc.scaleY = 3);
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        private function loadBag(_arg_1:*, _arg_2:Boolean=false):void
        {
            var _local_3:MovieClip;
            clearPreview();
            var _local_4:Class = (rootClass.world.getClass("iibag") as Class);
            if (((_arg_2) || ((((_arg_1 == null) || (!("sFile" in _arg_1))) || (String(_arg_1.sFile).length < 1)) || (rootClass.world.getClass(_arg_1.sFile) == null))))
            {
                _local_4 = (rootClass.world.getClass(_arg_1.sIcon) as Class);
            }
            else
            {
                if (((((!(_arg_1 == null)) && ("sFile" in _arg_1)) && (String(_arg_1.sFile).length > 0)) && (!(rootClass.world.getClass(_arg_1.sFile) == null))))
                {
                    _local_4 = (rootClass.world.getClass(_arg_1.sFile) as Class);
                };
            };
            try
            {
                _local_3 = new (_local_4)();
                _local_3.scaleX = (_local_3.scaleY = 3);
                mcPreview.addChild(_local_3);
                addGlow(_local_3);
            }
            catch(e:Error)
            {
            };
        }

        private function loadWeapon(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkWeapon = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.INIT, onLoadWeaponComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function loadCape(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkCape = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCapeComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function loadHelm(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkHelm = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHelmComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function loadPet(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkPet = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPetComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function loadHouse(_arg_1:*):void
        {
            var _local_2:*;
            var _local_3:*;
            try
            {
                clearPreview();
                _local_2 = (("maps/" + curItem.sFile.substr(0, -4)) + "_preview.swf");
                _local_3 = new Loader();
                _local_3.load(new URLRequest((Game.serverFilePath + _local_2)), pLoaderC);
                _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHouseComplete, false, 0, true);
                addToLoaderStack(_local_3);
            }
            catch(e)
            {
            };
        }

        private function onLoadHouseComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:* = (curItem.sFile.substr(0, -4).substr((curItem.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview");
            var _local_3:Class = (pLoaderD.getDefinition(_local_2) as Class);
            var _local_4:* = new (_local_3)();
            _local_4.x = 150;
            _local_4.y = 200;
            mcPreview.addChild(_local_4);
            addGlow(_local_4);
        }

        private function loadArmor(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkArmor = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest(((((Game.serverFilePath + "classes/") + rootClass.world.myAvatar.objData.strGender) + "/") + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.INIT, onLoadArmorComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function onLoadWeaponComplete(e:Event):void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            removeFromLoaderStack(e.target);
            try
            {
                AssetClass = (pLoaderD.getDefinition(sLinkWeapon) as Class);
                mc = new (AssetClass)();
            }
            catch(err:Error)
            {
                mc = e.target.content;
            };
            mc.scaleX = (mc.scaleY = 0.3);
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        private function onLoadCapeComplete(_arg_1:Event):void
        {
            var _local_2:Class;
            var _local_3:*;
            removeFromLoaderStack(_arg_1.target);
            try
            {
                _local_2 = (pLoaderD.getDefinition(sLinkCape) as Class);
                _local_3 = new (_local_2)();
                _local_3.scaleX = (_local_3.scaleY = 0.5);
                mcPreview.addChild(_local_3);
                addGlow(_local_3);
            }
            catch(e:Error)
            {
            };
        }

        private function onLoadHelmComplete(_arg_1:Event):void
        {
            var _local_2:Class;
            var _local_3:*;
            var _local_4:Class;
            var _local_5:*;
            removeFromLoaderStack(_arg_1.target);
            try
            {
                _local_2 = (pLoaderD.getDefinition(sLinkHelm) as Class);
                _local_3 = new (_local_2)();
                _local_3.scaleX = (_local_3.scaleY = 0.8);
                mcPreview.addChild(_local_3);
                try
                {
                    _local_4 = (pLoaderD.getDefinition((sLinkHelm + "_backhair")) as Class);
                    if (_local_4 != null)
                    {
                        _local_5 = new (_local_4)();
                        _local_5.x = (_local_3.getChildAt(0).x + 1);
                        _local_5.y = (_local_3.getChildAt(0).y - 28);
                        _local_5.scaleX = (_local_5.scaleY = 3.2);
                        _local_3.addChild(_local_5);
                        _local_3.setChildIndex(_local_5, 0);
                    };
                }
                catch(e0:Error)
                {
                };
                addGlow(_local_3);
            }
            catch(e:Error)
            {
            };
        }

        private function onLoadArmorComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:* = mcPreview.addChild(new AvatarMC());
            _local_2.visible = false;
            _local_2.strGender = rootClass.world.myAvatar.objData.strGender;
            _local_2.pAV = rootClass.world.myAvatar;
            _local_2.world = MovieClip(Game.root).world;
            _local_2.hideHPBar();
            _local_2.name = "previewMCB";
            addGlow(_local_2.mcChar, false);
            _local_2.loadArmorPiecesFromDomain(sLinkArmor, pLoaderD);
            _local_2.visible = true;
            _local_2.scaleX = (_local_2.scaleX * 2);
            _local_2.scaleY = (_local_2.scaleY * 2);
            _local_2.x = 150;
            _local_2.y = 250;
        }

        private function onLoadPetComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:Class = (pLoaderD.getDefinition(sLinkPet) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.scaleX = (_local_3.scaleY = 2);
            mcPreview.addChild(_local_3);
            addGlow(_local_3);
        }

        private function addGlow(_arg_1:MovieClip, _arg_2:Boolean=true):void
        {
            var _local_3:* = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            _arg_1.filters = [_local_3];
            _arg_1.mouseEnabled = (_arg_1.mouseChildren = false);
            if (_arg_2)
            {
                repositionPreview(_arg_1);
            };
        }

        public function repositionPreview(_arg_1:MovieClip):void
        {
            var _local_2:Rectangle = _arg_1.getBounds(mc.cnt.bMask);
            if (_local_2.height > 175)
            {
                _arg_1.scaleX = (_arg_1.scaleX * (175 / _local_2.height));
                _arg_1.scaleY = (_arg_1.scaleY * (175 / _local_2.height));
            };
            _arg_1.x = (_arg_1.x - int(((_arg_1.getBounds(mc.cnt.bMask).x + (_arg_1.getBounds(mc.cnt.bMask).width / 2)) - (mc.cnt.bMask.width / 2))));
            _arg_1.y = (_arg_1.y - int(((_arg_1.getBounds(mc.cnt.bMask).y + (_arg_1.getBounds(mc.cnt.bMask).height / 2)) - (mc.cnt.bMask.height / 2))));
        }

        private function loadHouseItem(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            var _local_3:* = new Loader();
            previewArgs.sLink = _arg_2;
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadHouseItemComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function onloadHouseItemComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:Class = (pLoaderD.getDefinition(previewArgs.sLink) as Class);
            var _local_3:* = new (_local_2)();
            mcPreview.addChild(_local_3);
            addGlow(_local_3);
        }

        private function addToLoaderStack(_arg_1:Loader):void
        {
            clearLoaderStack();
            loaderStack.push(_arg_1);
        }

        private function removeFromLoaderStack(_arg_1:Object):void
        {
            var _local_2:Loader;
            for each (_local_2 in loaderStack)
            {
                if (_local_2.contentLoaderInfo == _arg_1)
                {
                    loaderStack.splice(loaderStack.indexOf(_local_2), 1);
                };
            };
        }

        private function clearLoaderStack():void
        {
            var _local_1:Loader;
            while (loaderStack.length > 0)
            {
                _local_1 = loaderStack.shift();
                try
                {
                    _local_1.removeEventListener(Event.INIT, onLoadWeaponComplete);
                    _local_1.removeEventListener(Event.INIT, onLoadArmorComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadCapeComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadHelmComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadPetComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadHouseComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onloadHouseItemComplete);
                    _local_1.close();
                }
                catch(e:Error)
                {
                };
            };
        }

        private function onEF(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < killStack.length)
            {
                if (killStack[_local_2].c++ > 2)
                {
                    mcPreview.removeChild(killStack[_local_2].mc);
                    killStack.splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
        }

        private function xClick(_arg_1:MouseEvent):*
        {
            fClose();
        }

        public function fClose():void
        {
            mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK, xClick);
            mc.cnt.bg.btnTry.removeEventListener(MouseEvent.CLICK, tryClick);
            stage.focus = stage;
            mc.parent.removeChild(mc);
        }

        private function setCT(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = _arg_1.transform.colorTransform;
            _local_3.color = _arg_2;
            _arg_1.transform.colorTransform = _local_3;
        }

        internal function frame7():*
        {
            stop();
        }

        internal function frame12():*
        {
        }

        internal function frame16():*
        {
            fClose();
        }


    }
}//package liteAssets.draw

