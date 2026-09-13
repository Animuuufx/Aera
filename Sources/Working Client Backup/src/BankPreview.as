// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//BankPreview

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.text.*;

    public class BankPreview extends MovieClip 
    {

        public var tInfo:TextField;
        public var mcPreview:MovieClip;
        public var mcCoin:MovieClip;
        public var mcUpgrade:MovieClip;
        public var btnDelete:SimpleButton;
        private var iSel:Object;
        private var previewArgs:Object = {};
        private var rootClass:MovieClip;
        private var curItem:Object;
        private var sLinkArmor:String = "";
        private var sLinkCape:String = "";
        private var sLinkHelm:String = "";
        private var sLinkPet:String = "";
        private var sLinkWeapon:String = "";
        private var sLinkMisc:String = "";
        private var pLoaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        private var pLoaderC:LoaderContext = new LoaderContext(false, pLoaderD);
        private var loaderStack:Array = [];
        private var killStack:Array = [];

        public function BankPreview():void
        {
            mcCoin.visible = false;
            mcUpgrade.visible = false;
            btnDelete.addEventListener(MouseEvent.CLICK, onBtnDeleteClick, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OVER, onDeleteTTOver, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OUT, onDeleteTTOut, false, 0, true);
            mcCoin.addEventListener(MouseEvent.MOUSE_OVER, onCoinTTOver, false, 0, true);
            mcCoin.addEventListener(MouseEvent.MOUSE_OUT, onCoinTTOut, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER, onUpgradeTTOver, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT, onUpgradeTTOut, false, 0, true);
            addEventListener(Event.ENTER_FRAME, onEF, false, 0, true);
        }

        public function Open(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            this.x = _arg_1.r.x;
            this.y = _arg_1.r.y;
            this.width = _arg_1.r.w;
            this.height = _arg_1.r.h;
            iSel = _arg_1.item;
            fDraw();
        }

        public function fClose():void
        {
            btnDelete.removeEventListener(MouseEvent.CLICK, onBtnDeleteClick);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OVER, onDeleteTTOver);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OUT, onDeleteTTOut);
            mcCoin.removeEventListener(MouseEvent.MOUSE_OVER, onCoinTTOver);
            mcCoin.removeEventListener(MouseEvent.MOUSE_OUT, onCoinTTOut);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER, onUpgradeTTOver);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT, onUpgradeTTOut);
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        public function Show(_arg_1:Object):void
        {
            if (_arg_1 == null)
            {
                Hide();
                return;
            };
            iSel = _arg_1;
            fDraw();
            this.visible = true;
        }

        public function Hide():void
        {
            this.visible = false;
        }

        protected function fDraw():void
        {
            var _local_4:Object;
            btnDelete.visible = false;
            var _local_1:* = "";
            var _local_2:* = "";
            var _local_3:* = "#00CCFF";
            _local_4 = iSel;
            if (_local_4 != null)
            {
                btnDelete.visible = true;
                tInfo.htmlText = rootClass.getItemInfoStringB(_local_4);
                tInfo.y = int((((btnDelete.y + btnDelete.height) - tInfo.textHeight) - 3));
                mcUpgrade.visible = false;
                mcCoin.visible = false;
                if (_local_4.bUpg == 1)
                {
                    mcUpgrade.visible = true;
                };
                if (_local_4.bCoins == 1)
                {
                    mcUpgrade.visible = false;
                    mcCoin.visible = true;
                };
                loadPreview(_local_4);
            }
            else
            {
                while (mcPreview.numChildren > 0)
                {
                    mcPreview.removeChildAt(0);
                };
                clearPreview();
            };
            btnDelete.visible = false;
        }

        private function onBtnDeleteClick(_arg_1:Event):void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:int;
            rootClass.mixer.playSound("Click");
            if (iSel.bEquip)
            {
                rootClass.MsgBox.notify("Item is currently equipped!");
            }
            else
            {
                _local_2 = new ModalMC();
                _local_3 = {};
                _local_3.params = {};
                if ((((!(iSel.bCoins == null)) && (iSel.bCoins == 1)) && ((iSel.iQty > 0) || (iSel.sES == "ar"))))
                {
                    _local_3.strBody = "<font color='#FF0000'><b>AC items can not be deleted!</b></font>\n\nYou may sell the item if you really want, but there is no limit on AC item storage!";
                    _local_3.btns = "mono";
                }
                else
                {
                    if (iSel.sES == "ar")
                    {
                        _local_3.strBody = (("Are you sure you want to delete '" + iSel.sName) + "' and the rank associated with it?");
                    }
                    else
                    {
                        _local_3.strBody = (("Are you sure you want to delete '" + iSel.sName) + "'?");
                    };
                    _local_3.callback = deleteRequest;
                    _local_4 = ((iSel.iQty != null) ? iSel.iQty : 1);
                    if (iSel.sES == "ar")
                    {
                        _local_4 = 1;
                    };
                    if (_local_4 > 1)
                    {
                        _local_3.qtySel = {
                            "min":1,
                            "max":_local_4
                        };
                    };
                };
                _local_3.glow = "white,medium";
                _local_3.greedy = true;
                rootClass.ui.ModalStack.addChild(_local_2);
                _local_2.init(_local_3);
            };
        }

        public function deleteRequest(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                if (_arg_1.iQty != null)
                {
                    rootClass.world.sendRemoveItemRequest(iSel, _arg_1.iQty);
                }
                else
                {
                    rootClass.world.sendRemoveItemRequest(iSel);
                };
            };
        }

        private function loadPreview(_arg_1:Object):void
        {
            if (_arg_1.sType.toLowerCase() != "enhancement")
            {
                if (curItem != _arg_1)
                {
                    curItem = _arg_1;
                    switch (_arg_1.sType)
                    {
                        case "House":
                            loadHouse(_arg_1.sFile);
                            return;
                        case "Wall Item":
                        case "Floor Item":
                            loadHouseItem(_arg_1.sFile, _arg_1.sLink);
                            return;
                    };
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
                        case "mi":
                            loadMisc(_arg_1.sFile, _arg_1.sLink);
                            break;
                        default:
                            if (((_arg_1.sType.toLowerCase() == "item") && (!(String(_arg_1.sLink).toLowerCase() == "none"))))
                            {
                                loadBag(_arg_1);
                            }
                            else
                            {
                                if (_arg_1.sES == "am")
                                {
                                    loadBag(_arg_1, true);
                                }
                                else
                                {
                                    if (((_arg_1.sType.toLowerCase() == "serveruse") || (_arg_1.sType.toLowerCase() == "clientuse")))
                                    {
                                        loadBag(_arg_1);
                                    }
                                    else
                                    {
                                        clearPreview();
                                    };
                                };
                            };
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

        private function loadMisc(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkMisc = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.INIT, onLoadMiscComplete, false, 0, true);
            addToLoaderStack(_local_3);
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
            clearPreview();
            var _local_2:* = (("maps/" + _arg_1.substr(0, -4)) + "_preview.swf");
            previewArgs.sFile = _arg_1;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _local_2)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHouseComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function onLoadHouseComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:* = (previewArgs.sFile.substr(0, -4).substr((previewArgs.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview");
            var _local_3:Class = (pLoaderD.getDefinition(_local_2) as Class);
            var _local_4:* = new (_local_3)();
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

        private function onLoadMiscComplete(e:Event):void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            removeFromLoaderStack(e.target);
            try
            {
                AssetClass = (pLoaderD.getDefinition(sLinkMisc) as Class);
                mc = new (AssetClass)();
            }
            catch(err:Error)
            {
                mc = e.target.content;
            };
            mcPreview.addChild(mc);
            addGlow(mc);
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
            removeFromLoaderStack(_arg_1.target);
            try
            {
                _local_2 = (pLoaderD.getDefinition(sLinkHelm) as Class);
                _local_3 = new (_local_2)();
                _local_3.scaleX = (_local_3.scaleY = 0.8);
                mcPreview.addChild(_local_3);
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
            if (_arg_2)
            {
                repositionPreview(_arg_1);
            };
        }

        public function repositionPreview(_arg_1:MovieClip):void
        {
            var _local_2:Rectangle = _arg_1.getBounds(this);
            if (_local_2.height > 175)
            {
                _arg_1.scaleX = (_arg_1.scaleX * (175 / _local_2.height));
                _arg_1.scaleY = (_arg_1.scaleY * (175 / _local_2.height));
            };
            _arg_1.x = (_arg_1.x - int(((_arg_1.getBounds(this).x + (_arg_1.getBounds(this).width / 2)) - (this.width / 2))));
            _arg_1.y = int((_arg_1.y - _arg_1.getBounds(this).y));
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

        private function onDeleteTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"Delete item"});
        }

        private function onDeleteTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        private function onCoinTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"This item requires Adventure Coins to purchase."});
        }

        private function onCoinTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        private function onUpgradeTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"This item is exclusive to upgraded members."});
        }

        private function onUpgradeTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
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


    }
}//package 

