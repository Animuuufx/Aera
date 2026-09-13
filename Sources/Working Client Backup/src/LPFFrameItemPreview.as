// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameItemPreview

package 
{
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.net.*;
    import flash.text.*;

    public class LPFFrameItemPreview extends LPFFrame
    {

        public var btnFGender:SimpleButton;
        public var btnWiki:SimpleButton;
        public var tInfo:TextField;
        public var mcPreview:MovieClip;
        public var mcCoin:MovieClip;
        public var btnMGender:SimpleButton;
        public var mcUpgrade:MovieClip;
        public var btnDelete:SimpleButton;
        public var btnTry:SimpleButton;
        protected var iSel:Object;
        private var previewArgs:Object = {};
        protected var rootClass:MovieClip;
        protected var curItem:Object;
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
        internal var preventSpam:Boolean;

        public function LPFFrameItemPreview():void
        {
            pLoaderC.checkPolicyFile = false;
            pLoaderC.allowCodeImport = true;
            mcCoin.visible = false;
            mcUpgrade.visible = false;
            btnTry.visible = false;
            btnFGender.visible = false;
            btnMGender.visible = false;
            btnWiki.visible = false;
            btnTry.addEventListener(MouseEvent.CLICK, onBtnTryClick, false, 0, true);
            btnTry.addEventListener(MouseEvent.MOUSE_OVER, onTryTTOver, false, 0, true);
            btnTry.addEventListener(MouseEvent.MOUSE_OUT, onTryTTOut, false, 0, true);
            btnMGender.addEventListener(MouseEvent.CLICK, onBtnGender, false, 0, true);
            btnMGender.addEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver, false, 0, true);
            btnMGender.addEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut, false, 0, true);
            btnFGender.addEventListener(MouseEvent.CLICK, onBtnGender, false, 0, true);
            btnFGender.addEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver, false, 0, true);
            btnFGender.addEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut, false, 0, true);
            btnWiki.addEventListener(MouseEvent.CLICK, onBtnWiki, false, 0, true);
            btnWiki.addEventListener(MouseEvent.MOUSE_OVER, onWikiTTOver, false, 0, true);
            btnWiki.addEventListener(MouseEvent.MOUSE_OUT, onWikiTTOut, false, 0, true);
            btnDelete.addEventListener(MouseEvent.CLICK, onBtnDeleteClick, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OVER, onDeleteTTOver, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OUT, onDeleteTTOut, false, 0, true);
            mcCoin.addEventListener(MouseEvent.MOUSE_OVER, onCoinTTOver, false, 0, true);
            mcCoin.addEventListener(MouseEvent.MOUSE_OUT, onCoinTTOut, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER, onUpgradeTTOver, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT, onUpgradeTTOut, false, 0, true);
            addEventListener(Event.ENTER_FRAME, onEF, false, 0, true);
        }

        override public function fOpen(_arg_1:Object):void
        {
            rootClass = MovieClip(stage.getChildAt(0));
            positionBy(_arg_1.r);
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            btnWiki.removeEventListener(MouseEvent.CLICK, onBtnWiki);
            btnWiki.removeEventListener(MouseEvent.MOUSE_OVER, onWikiTTOver);
            btnWiki.removeEventListener(MouseEvent.MOUSE_OUT, onWikiTTOut);
            btnTry.removeEventListener(MouseEvent.CLICK, onBtnTryClick);
            btnTry.removeEventListener(MouseEvent.MOUSE_OVER, onTryTTOver);
            btnTry.removeEventListener(MouseEvent.MOUSE_OUT, onTryTTOut);
            btnMGender.removeEventListener(MouseEvent.CLICK, onBtnGender);
            btnMGender.removeEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver);
            btnMGender.removeEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut);
            btnFGender.removeEventListener(MouseEvent.CLICK, onBtnGender);
            btnFGender.removeEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver);
            btnFGender.removeEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut);
            btnDelete.removeEventListener(MouseEvent.CLICK, onBtnDeleteClick);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OVER, onDeleteTTOver);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OUT, onDeleteTTOut);
            mcCoin.removeEventListener(MouseEvent.MOUSE_OVER, onCoinTTOver);
            mcCoin.removeEventListener(MouseEvent.MOUSE_OUT, onCoinTTOut);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER, onUpgradeTTOver);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT, onUpgradeTTOut);
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        protected function onBtnTryClick(_arg_1:MouseEvent):void
        {
            if (!iSel)
            {
                return;
            }
            rootClass.xTryMe(iSel);
            if (rootClass.ui.mcPopup.currentLabel == "MergeShop")
            {
                rootClass.ui.mcPopup.getChildByName("mcShop").fClose();
            }
            else
            {
                rootClass.ui.mcPopup.getChildByName("mcShop").previewPanel.visible = false;
            }
            rootClass.ui.ToolTip.close();
        }

        protected function onBtnWiki(_arg_1:MouseEvent):void
        {
            if (!iSel)
            {
                return;
            }
            navigateToURL(new URLRequest("https://nightvaults.com/"), "_blank");
        }

        protected function onBtnGender(_arg_1:MouseEvent):void
        {
            if (((preventSpam) || (!(iSel)))) return;

            clearPreview();

            var _local_2:String = ((_arg_1.currentTarget.name == "btnMGender") ? "F" : "M");
            btnMGender.visible = (_local_2 == "M");
            btnFGender.visible = (_local_2 == "F");
            sLinkArmor = iSel.sLink;

            rootClass.onLoadMaster(this.onLoadArmorComplete, this.pLoaderC, "classes/" + _local_2 + "/" + iSel.sFile);

            preventSpam = true;
        }

        protected function fDraw():void
        {
            btnDelete.visible = false;
            var _local_1:* = "";
            var _local_2:* = "";
            var _local_3:* = "#00CCFF";
            var _local_4:Object = iSel;
            if (_local_4 != null)
            {
                btnDelete.visible = true;
                tInfo.htmlText = rootClass.getItemInfoStringB(_local_4);
                tInfo.y = ((tInfo.textHeight >= 109.8) ? int((((btnDelete.y + btnDelete.height) - tInfo.height) + 10)) : int((((btnDelete.y + btnDelete.height) - tInfo.textHeight) - 3)));
                mcUpgrade.visible = false;
                mcCoin.visible = false;
                if (_local_4.bUpg == 1)
                {
                    mcUpgrade.visible = true;
                }
                if (_local_4.bCoins == 1)
                {
                    mcUpgrade.visible = false;
                    mcCoin.visible = true;
                }
                loadPreview(_local_4);
            }
            else
            {
                tInfo.htmlText = "Please select an item to preview.";
                while (mcPreview.numChildren > 0)
                {
                    mcPreview.removeChildAt(0);
                }
                clearPreview();
            }
            btnDelete.visible = true;
            if (getLayout().sMode.toLowerCase().indexOf("shop") > -1)
            {
                btnDelete.visible = false;
            }
            if (_local_4 != null)
            {
                if (((!(btnDelete.visible)) && (!(_local_4.sType == "Enhancement"))))
                {
                    switch (_local_4.sES)
                    {
                        case "Weapon":
                        case "he":
                        case "ba":
                        case "pe":
                        case "ar":
                        case "co":
                        case "mi":
                            if (_local_4.bUpg == 1)
                            {
                                if (!rootClass.world.myAvatar.isUpgraded())
                                {
                                    btnTry.visible = false;
                                    break;
                                }
                            }
                            btnTry.visible = true;
                            break;
                        case "ho":
                        case "hi":
                        default:
                            btnTry.visible = false;
                    }
                }
                if (_local_4.sType != "Enhancement")
                {
                    switch (_local_4.sES)
                    {
                        case "ar":
                        case "co":
                            if (rootClass.world.myAvatar.objData.strGender == "M")
                            {
                                btnFGender.visible = false;
                                btnMGender.visible = true;
                            }
                            else
                            {
                                btnFGender.visible = true;
                                btnMGender.visible = false;
                            }
                            break;
                        default:
                            btnFGender.visible = false;
                            btnMGender.visible = false;
                    }
                }
                if (((!(btnFGender.visible)) && (!(btnMGender.visible))))
                {
                    btnWiki.y = btnMGender.y;
                }
                else
                {
                    btnWiki.y = 121;
                }
                if (((!(btnTry.visible)) && (!(btnDelete.visible))))
                {
                    btnWiki.y = btnTry.y;
                }
                btnWiki.visible = true;
            }
        }

        override public function notify(_arg_1:Object):void
        {
            iSel = null;
            if (_arg_1.fData.eSel != null)
            {
                iSel = _arg_1.fData.eSel;
            }
            if (_arg_1.fData.iSel != null)
            {
                iSel = _arg_1.fData.iSel;
            }
            fDraw();
        }

        protected function onBtnDeleteClick(_arg_1:Event):void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:int;
            var _local_5:int;
            rootClass.mixer.playSound("Click");
            if (((((iSel.bEquip) && (!(iSel.sType == "Wall Item"))) && (!(iSel.sType == "Floor Item"))) || (iSel.bEquip >= iSel.iQty)))
            {
                if (((iSel.sType == "Wall Item") || (iSel.sType == "Floor Item")))
                {
                    rootClass.MsgBox.notify("Item is currently placed in your house!");
                }
                else
                {
                    rootClass.MsgBox.notify("Item is currently equipped!");
                }
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
                    }
                    _local_3.callback = deleteRequest;
                    _local_4 = ((iSel.iQty != null) ? iSel.iQty : 1);
                    if (iSel.sES == "ar")
                    {
                        _local_4 = 1;
                    }
                    if (_local_4 > 1)
                    {
                        if (((iSel.sType == "Wall Item") || (iSel.sType == "Floor Item")))
                        {
                            _local_5 = (int(iSel.iQty) - int(iSel.bEquip));
                            if (_local_5 > 1)
                            {
                                _local_3.qtySel = {
                                    "min":1,
                                    "max":_local_5
                                };
                            }
                        }
                        else
                        {
                            _local_3.qtySel = {
                                "min":1,
                                "max":_local_4
                            };
                        }
                    }
                }
                _local_3.glow = "white,medium";
                _local_3.greedy = true;
                rootClass.ui.ModalStack.addChild(_local_2);
                _local_2.init(_local_3);
            }
        }

        protected function deleteRequest(_arg_1:Object):void
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
                }
            }
        }

        protected function loadPreview(_arg_1:Object):void
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
                                    }
                                }
                            }
                    }
                }
            }
            else
            {
                loadEnhancement(_arg_1);
            }
        }

        protected function clearPreview():void
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
                        }
                        _local_3++;
                    }
                    if (_local_1)
                    {
                        killStack.push({
                            "c":0,
                            "mc":mcPreview.getChildAt(_local_2)
                        });
                    }
                }
                else
                {
                    mcPreview.removeChildAt(_local_2);
                    _local_2--;
                }
                _local_2++;
            }
            curItem = null;
        }

        protected function loadEnhancement(item:*):void
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
            }
            mc.scaleX = (mc.scaleY = 3);
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        protected function loadBag(_arg_1:*, _arg_2:Boolean=false):void
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
                }
            }
            try
            {
                _local_3 = new (_local_4)();
                _local_3.scaleX = (_local_3.scaleY = 3);
                mcPreview.addChild(_local_3);
                addGlow(_local_3);
            }
            catch(e:Error)
            {
            }
        }

        protected function loadMisc(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkMisc = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.INIT, onLoadMiscComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        protected function loadWeapon(fileName:String, link:String):void
        {
            clearPreview();
            sLinkWeapon = link;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + fileName)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.INIT, onLoadWeaponComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        protected function loadCape(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkCape = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCapeComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        protected function loadHelm(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkHelm = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHelmComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        protected function loadPet(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            sLinkPet = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPetComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        protected function loadHouse(_arg_1:*):void
        {
            clearPreview();
            try
            {
                previewArgs.sFile = _arg_1;
                rootClass.onLoadMaster(this.onLoadHouseComplete, this.pLoaderC, "maps/" + _arg_1.substr(0, -4) + "_preview.swf");
            }
            catch (e:Error)
            {
                trace("loadHouse " + e);
            }
        }

        protected function onLoadHouseComplete(_arg_1:Event):void
        {
            var AssetClass:Class;
            var mc:MovieClip;
            try
            {
                AssetClass = this.pLoaderD.getDefinition(previewArgs.sFile.substr(0, -4).substr((previewArgs.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview") as Class;
                mc = new AssetClass;
                mc.x = 150;
                mc.y = 200;
                this.mcPreview.addChild(mc);
                this.addGlow(mc);
            }
            catch (e:Error)
            {
                trace("onLoadHouseComplete " + e);
            }
        }

        protected function loadArmor(fileName:String, link:String):void
        {
            clearPreview();
            sLinkArmor = link;
            rootClass.onLoadMaster(this.onLoadArmorComplete, this.pLoaderC, "classes/" + rootClass.world.myAvatar.objData.strGender + "/" + fileName);
        }

        protected function onLoadMiscComplete(e:Event):void
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
            }
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        protected function onLoadWeaponComplete(e:Event):void
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
            }
            mc.scaleX = (mc.scaleY = 0.3);
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        protected function onLoadCapeComplete(_arg_1:Event):void
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
            }
        }

        protected function onLoadHelmComplete(_arg_1:Event):void
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
                    }
                }
                catch(e0:Error)
                {
                }
                addGlow(_local_3);
            }
            catch(e:Error)
            {
            }
        }

        protected function onLoadArmorComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:* = mcPreview.addChild(new AvatarMC());
            _local_2.visible = false;
            _local_2.strGender = rootClass.world.myAvatar.objData.strGender;
            if (((btnMGender.visible) || (btnFGender.visible)))
            {
                _local_2.strGender = ((btnMGender.visible) ? "M" : "F");
            }
            _local_2.pAV = rootClass.world.myAvatar;
            _local_2.world = MovieClip(Game.root).world;
            _local_2.hideHPBar();
            _local_2.name = "previewMCB";
            addGlow(_local_2.mcChar, false);
            _local_2.loadArmorPiecesFromDomain(sLinkArmor, pLoaderD);
            _local_2.visible = true;
            preventSpam = false;
        }

        protected function onLoadPetComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:Class = (pLoaderD.getDefinition(sLinkPet) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.scaleX = (_local_3.scaleY = 2);
            mcPreview.addChild(_local_3);
            addGlow(_local_3);
        }

        protected function addGlow(_arg_1:MovieClip, _arg_2:Boolean=true):void
        {
            var _local_3:* = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            _arg_1.filters = [_local_3];
            if (_arg_2)
            {
                repositionPreview(_arg_1);
            }
        }

        public function repositionPreview(_arg_1:MovieClip):void
        {
            var _local_2:Rectangle = _arg_1.getBounds(this);
            if (_local_2.height > 175)
            {
                _arg_1.scaleX = (_arg_1.scaleX * (175 / _local_2.height));
                _arg_1.scaleY = (_arg_1.scaleY * (175 / _local_2.height));
            }
            _arg_1.x = (_arg_1.x - int(((_arg_1.getBounds(this).x + (_arg_1.getBounds(this).width / 2)) - (this.width / 2))));
            _arg_1.y = int((_arg_1.y - _arg_1.getBounds(this).y));
        }

        protected function loadHouseItem(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            previewArgs.sLink = _arg_2;

            rootClass.onLoadMaster(onloadHouseItemComplete, pLoaderC, _arg_1);
        }

        protected function onloadHouseItemComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:Class = (pLoaderD.getDefinition(previewArgs.sLink) as Class);
            var _local_3:* = new (_local_2)();
            mcPreview.addChild(_local_3);
            addGlow(_local_3);
        }

        protected function onWikiTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"Search on Wiki"});
        }

        protected function onWikiTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        protected function onGenderTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"Switch Gender"});
        }

        protected function onGenderTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        protected function onTryTTOver(_arg_1:MouseEvent):void
        {
            if (((rootClass.world.myAvatar.objData.eqp[iSel.sES]) && (iSel.sFile == rootClass.world.myAvatar.objData.eqp[iSel.sES].sFile)))
            {
                rootClass.ui.ToolTip.openWith({"str":"Revert Try Me"});
            }
            else
            {
                rootClass.ui.ToolTip.openWith({"str":"Try Me!"});
            }
        }

        protected function onTryTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        protected function onDeleteTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"Delete item"});
        }

        protected function onDeleteTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        protected function onCoinTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"This item requires Adventure Coins to purchase."});
        }

        protected function onCoinTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        protected function onUpgradeTTOver(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.openWith({"str":"This item is exclusive to upgraded members."});
        }

        protected function onUpgradeTTOut(_arg_1:MouseEvent):void
        {
            rootClass.ui.ToolTip.close();
        }

        protected function addToLoaderStack(_arg_1:Loader):void
        {
            clearLoaderStack();
            loaderStack.push(_arg_1);
        }

        protected function removeFromLoaderStack(_arg_1:Object):void
        {
            var _local_2:Loader;
            for each (_local_2 in loaderStack)
            {
                if (_local_2.contentLoaderInfo == _arg_1)
                {
                    loaderStack.splice(loaderStack.indexOf(_local_2), 1);
                }
            }
        }

        protected function clearLoaderStack():void
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
                }
            }
        }

        protected function onEF(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < killStack.length)
            {
                if (killStack[_local_2].c++ > 2)
                {
                    mcPreview.removeChild(killStack[_local_2].mc);
                    killStack.splice(_local_2, 1);
                    _local_2--;
                }
                _local_2++;
            }
        }


    }
}//package 

