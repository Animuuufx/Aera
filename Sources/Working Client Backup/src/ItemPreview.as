// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ItemPreview

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.events.MouseEvent;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.filters.GlowFilter;

    public class ItemPreview extends MovieClip 
    {

        public var btnClose:SimpleButton;
        internal var rootClass:MovieClip = MovieClip(Game.root);
        internal var mcStage:MovieClip;
        internal var curItem:Object;
        internal var sLinkArmor:String = "";
        internal var sLinkCape:String = "";
        internal var sLinkHelm:String = "";
        internal var sLinkPet:String = "";
        internal var sLinkWeapon:String = "";
        internal var pLoaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        internal var pLoaderC:LoaderContext = new LoaderContext(false, pLoaderD);

        public function ItemPreview():void
        {
            this.x = 50;
            this.y = 90;
            this.btnClose.addEventListener(MouseEvent.CLICK, xClick, false, 0, true);
            mcStage = MovieClip(this.addChild(new MovieClip()));
        }

        private function xClick(_arg_1:MouseEvent):*
        {
            this.btnClose.removeEventListener(MouseEvent.CLICK, xClick);
            rootClass.clearModalStack();
        }

        public function loadItem(_arg_1:Object):void
        {
            if (curItem != _arg_1)
            {
                curItem = _arg_1;
                switch (_arg_1.sES)
                {
                    case "Weapon":
                        loadWeapon(_arg_1.sFile, _arg_1.sLink);
                        return;
                    case "he":
                        loadHelm(_arg_1.sFile, _arg_1.sLink);
                        return;
                    case "ba":
                        loadCape(_arg_1.sFile, _arg_1.sLink);
                        return;
                    case "pe":
                        loadPet(_arg_1.sFile, _arg_1.sLink);
                        return;
                    case "ar":
                    case "co":
                        loadArmor(_arg_1.sFile, _arg_1.sLink);
                        return;
                    case "ho":
                        loadHouse(_arg_1.sFile);
                        return;
                    case "hi":
                        loadItemFile();
                        return;
                };
            };
        }

        private function clearStage():void
        {
            var _local_1:int = (mcStage.numChildren - 1);
            while (_local_1 >= 0)
            {
                mcStage.removeChildAt(_local_1);
                _local_1--;
            };
        }

        private function loadWeapon(_arg_1:*, _arg_2:*):void
        {
            clearStage();
            sLinkWeapon = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.INIT, onLoadWeaponComplete, false, 0, true);
        }

        private function loadCape(_arg_1:*, _arg_2:*):void
        {
            clearStage();
            sLinkCape = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCapeComplete, false, 0, true);
        }

        private function loadHelm(_arg_1:*, _arg_2:*):void
        {
            clearStage();
            sLinkHelm = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHelmComplete, false, 0, true);
        }

        private function loadPet(_arg_1:*, _arg_2:*):void
        {
            clearStage();
            sLinkPet = _arg_2;
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPetComplete, false, 0, true);
        }

        private function loadHouse(_arg_1:*):void
        {
            clearStage();
            var _local_2:* = (("maps/" + curItem.sFile.substr(0, -4)) + "_preview.swf");
            var _local_3:* = new Loader();
            _local_3.load(new URLRequest((Game.serverFilePath + _local_2)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHouseComplete, false, 0, true);
        }

        internal function onLoadHouseComplete(_arg_1:Event):void
        {
            var _local_2:* = (curItem.sFile.substr(0, -4).substr((curItem.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview");
            var _local_3:Class = (pLoaderD.getDefinition(_local_2) as Class);
            var _local_4:* = new (_local_3)();
            _local_4.x = 150;
            _local_4.y = 200;
            mcStage.addChild(_local_4);
            addGlow(_local_4);
        }

        private function loadArmor(_arg_1:*, _arg_2:*):void
        {
            clearStage();
            sLinkArmor = _arg_2;
            var _local_3:* = mcStage.addChild(new AvatarMC());
            _local_3.strGender = rootClass.world.myAvatar.objData.strGender;
            _local_3.x = 150;
            _local_3.y = 250;
            _local_3.scaleX = (_local_3.scaleY = 1.65);
            _local_3.pAV = rootClass.world.myAvatar;
            _local_3.world = MovieClip(Game.root).world;
            _local_3.hideHPBar();
            _local_3.name = "previewMC";
            _local_3.loadArmor(_arg_1, _arg_2);
            addGlow(_local_3.mcChar);
        }

        internal function onLoadWeaponComplete(e:Event):void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            try
            {
                AssetClass = (pLoaderD.getDefinition(sLinkWeapon) as Class);
                mc = new (AssetClass)();
            }
            catch(err:Error)
            {
                mc = e.target.content;
            };
            mc.x = 150;
            mc.y = 180;
            mc.scaleX = (mc.scaleY = 0.3);
            mcStage.addChild(mc);
            addGlow(mc);
        }

        internal function onLoadCapeComplete(_arg_1:Event):void
        {
            var _local_2:Class = (pLoaderD.getDefinition(sLinkCape) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.x = 150;
            _local_3.y = 150;
            _local_3.scaleX = (_local_3.scaleY = 0.5);
            mcStage.addChild(_local_3);
            addGlow(_local_3);
        }

        internal function onLoadHelmComplete(_arg_1:Event):void
        {
            var _local_2:Class = (pLoaderD.getDefinition(sLinkHelm) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.x = 170;
            _local_3.y = 200;
            mcStage.addChild(_local_3);
            addGlow(_local_3);
        }

        internal function onLoadPetComplete(_arg_1:Event):void
        {
            var _local_2:Class = (pLoaderD.getDefinition(sLinkPet) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.x = 150;
            _local_3.y = 250;
            _local_3.scaleX = (_local_3.scaleY = 2);
            mcStage.addChild(_local_3);
            addGlow(_local_3);
        }

        private function addGlow(_arg_1:MovieClip):void
        {
            var _local_2:* = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            _arg_1.filters = [_local_2];
        }

        private function loadItemFile():void
        {
            clearStage();
            var _local_1:* = new Loader();
            _local_1.load(new URLRequest((Game.serverFilePath + curItem.sFile)), pLoaderC);
            _local_1.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadItemFileComplete, false, 0, true);
        }

        internal function onLoadItemFileComplete(_arg_1:Event):void
        {
            var _local_2:Class = (pLoaderD.getDefinition(curItem.sLink) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.x = 150;
            _local_3.y = 250;
            if (_local_3.height > 225)
            {
                _local_3.height = 225;
                _local_3.scaleX = _local_3.scaleY;
            };
            if (_local_3.width > 275)
            {
                _local_3.width = 275;
                _local_3.scaleY = _local_3.scaleX;
            };
            mcStage.addChild(_local_3);
            addGlow(_local_3);
        }


    }
}//package 

