// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//selAvatarMC

package 
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    import flash.display.Loader;
import flash.net.URLLoader;
import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.utils.getDefinitionByName;
    import fl.motion.Color;

    public class selAvatarMC extends MovieClip 
    {

        public var mcChar:selmcSkel;
        public var shadow:MovieClip;
        public var fx:MovieClip;
        public var proxy:MovieClip;
        public var CT3:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0);
        public var CT2:ColorTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127, 0);
        public var CT1:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        public var strGender:String;
        internal var defaultCT:ColorTransform;
        internal var serverFilePath:String = "";
        public var pAV:Object;
        internal var strSkinLinkage:String;
        internal var weaponLoad:Boolean = true;
        internal var helmLoad:Boolean = true;
        internal var armorLoad:Boolean = true;
        internal var capeLoad:Boolean = true;
        internal var hairLoad:Boolean = true;
        public var helmEquipped:Boolean = false;
        public var r:MovieClip;
        public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        public var loaderC:LoaderContext = new LoaderContext(false, loaderD);

        public function selAvatarMC(r:MovieClip)
        {
            this.r = r;

            loaderC.checkPolicyFile = false;
            loaderC.allowCodeImport = true;
            defaultCT = MovieClip(this).transform.colorTransform;
            pAV = {};
            super();
            addFrameScript(0, frame1, 4, frame5, 7, frame8, 9, frame10, 11, frame12, 12, frame13, 13, frame14, 19, frame20, 22, frame23);
            serverFilePath = r.getFilePath();
            visible = false;
            hideOptionalParts();
        }

        public function endAction():*
        {
            this.mcChar.gotoAndPlay("Idle");
        }

        public function get loaded():Boolean
        {
            return (((((weaponLoad) && (helmLoad)) && (armorLoad)) && (capeLoad)) && (hairLoad));
        }

        private function hideOptionalParts():void
        {
            var _local_2:*;
            var _local_1:* = ["cape", "backhair", "robe", "backrobe"];
            for (_local_2 in _local_1)
            {
                if (typeof(mcChar[_local_1[_local_2]]) != undefined)
                {
                    mcChar[_local_1[_local_2]].visible = false;
                }
            }
        }

        public function getClass(assetLinkageID:String):Class
        {
            var _local_3:Class;
            var _local_4:String;
            try
            {
                _local_3 = (getDefinitionByName(assetLinkageID) as Class);
                if (_local_3 != null)
                {
                    return (_local_3);
                }
            }
            catch(e:Error)
            {
            }
            try
            {
                _local_3 = (loaderD.getDefinition(assetLinkageID) as Class);
                if (_local_3 != null)
                {
                    return (_local_3);
                }
            }
            catch(e:Error)
            {
            }

            trace("Failed to find Linkage: " + assetLinkageID);

            return null;
        }

        public function loadArmor(_arg_1:String, _arg_2:String):*
        {
            armorLoad = false;
            strSkinLinkage = _arg_2;
            r.onLoadMaster(onLoadSkinComplete, loaderC, "classes/" + pAV.objData.strGender + "/" + _arg_1, null, ioErrorHandler);
        }

        private function onLoadSkinComplete(evt:Event):*
        {
            var AssetClass:Class;
            var testMC:*;
            var child:DisplayObject;
            strGender = pAV.objData.strGender;

            try
            {
                AssetClass = (r.getChildByName(strSkinLinkage + strGender + "Head") as Class);

                child = mcChar.head.getChildByName("face");
                if (child != null)
                {
                    mcChar.head.removeChild(child);
                }
                testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
                testMC.name = "face";
            }
            catch(err:Error)
            {
                child = mcChar.head.getChildByName("face");
                if (child != null)
                {
                    mcChar.head.removeChild(child);
                }
                testMC = mcChar.head.addChildAt(r.mcHeadMale(), 0);
                testMC.name = "face";
            }

            AssetClass = (getClass(((strSkinLinkage + strGender) + "Chest")) as Class);
            mcChar.chest.removeChildAt(0);
            mcChar.chest.addChild(new (AssetClass)());
            AssetClass = (getClass(((strSkinLinkage + strGender) + "Hip")) as Class);
            mcChar.hip.removeChildAt(0);
            mcChar.hip.addChild(new (AssetClass)());
            AssetClass = (getClass(((strSkinLinkage + strGender) + "FootIdle")) as Class);
            mcChar.idlefoot.removeChildAt(0);
            mcChar.idlefoot.addChild(new (AssetClass)());
            AssetClass = (getClass(((strSkinLinkage + strGender) + "Foot")) as Class);
            mcChar.backfoot.removeChildAt(0);
            mcChar.backfoot.addChild(new (AssetClass)());
            AssetClass = (getClass(((strSkinLinkage + strGender) + "Shoulder")) as Class);
            mcChar.frontshoulder.removeChildAt(0);
            mcChar.frontshoulder.addChild(new (AssetClass)());
            mcChar.backshoulder.removeChildAt(0);
            mcChar.backshoulder.addChild(new (AssetClass)());
            AssetClass = (getClass(((strSkinLinkage + strGender) + "Hand")) as Class);
            mcChar.fronthand.removeChildAt(0);
            mcChar.fronthand.addChildAt(new (AssetClass)(), 0);
            mcChar.backhand.removeChildAt(0);
            mcChar.backhand.addChildAt(new (AssetClass)(), 0);
            var drk:Color = new Color();
            drk.brightness = -1;
            mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
            AssetClass = (getClass(((strSkinLinkage + strGender) + "Thigh")) as Class);
            mcChar.frontthigh.removeChildAt(0);
            mcChar.frontthigh.addChild(new (AssetClass)());
            mcChar.backthigh.removeChildAt(0);
            mcChar.backthigh.addChild(new (AssetClass)());
            AssetClass = (getClass(((strSkinLinkage + strGender) + "Shin")) as Class);
            mcChar.frontshin.removeChildAt(0);
            mcChar.frontshin.addChild(new (AssetClass)());
            mcChar.backshin.removeChildAt(0);
            mcChar.backshin.addChild(new (AssetClass)());
            try
            {
                AssetClass = (getClass(((strSkinLinkage + strGender) + "Robe")) as Class);
                mcChar.robe.removeChildAt(0);
                mcChar.robe.addChild(new (AssetClass)());
                mcChar.robe.visible = true;
            }
            catch(err:Error)
            {
            }
            try
            {
                AssetClass = (getClass(((strSkinLinkage + strGender) + "RobeBack")) as Class);
                mcChar.backrobe.removeChildAt(0);
                mcChar.backrobe.addChild(new (AssetClass)());
                mcChar.backrobe.visible = true;
            }
            catch(err:Error)
            {
            }
            visible = true;
            armorLoad = true;
        }

        private function ioErrorHandler(_arg_1:IOErrorEvent):void
        {
        }

        public function loadHair():void
        {
            hairLoad = false;
            r.onLoadMaster(onHairLoadComplete, loaderC, pAV.objData.strHairFilename);
        }

        private function onHairLoadComplete(event:Event):void
        {
            hairLoad = true;
            if (helmEquipped)
            {
                return;
            }
            var AssetClass:Class = getClass(((pAV.objData.strHairName + pAV.objData.strGender) + "Hair"));
            mcChar.head.hair.removeChildAt(0);
            mcChar.head.hair.addChild(new (AssetClass)());
            mcChar.backhair.visible = false;
            if (!ApplicationDomain.currentDomain.hasDefinition(((pAV.objData.strHairName + pAV.objData.strGender) + "HairBack")))
            {
                return;
            }
            try
            {
                AssetClass = (getDefinitionByName(((pAV.objData.strHairName + pAV.objData.strGender) + "HairBack")) as Class);
                if (AssetClass != null)
                {
                    if (mcChar.backhair.numChildren > 0)
                    {
                        mcChar.backhair.removeChildAt(0);
                    }
                    mcChar.backhair.addChild(new (AssetClass)());
                    mcChar.backhair.visible = true;
                }
                else
                {
                    mcChar.backhair.visible = false;
                }
            }
            catch(e)
            {
                mcChar.backhair.visible = false;
            }
        }

        public function setColor(_arg_1:MovieClip, _arg_2:String, _arg_3:String):void
        {
            var _local_4:Number = Number(pAV.objData[("intColor" + _arg_2)]);
            _arg_1.isColored = true;
            _arg_1.intColor = _local_4;
            _arg_1.strLocation = _arg_2;
            _arg_1.strShade = _arg_3;
            changeColor(_arg_1, _local_4, _arg_3);
        }

        public function changeColor(_arg_1:MovieClip, _arg_2:Number, _arg_3:String, _arg_4:String=""):void
        {
            var _local_5:ColorTransform = new ColorTransform();
            if (_arg_4 == "")
            {
                _local_5.color = _arg_2;
            }
            switch (_arg_3.toUpperCase())
            {
                case "LIGHT":
                    _local_5.redOffset = (_local_5.redOffset + 100);
                    _local_5.greenOffset = (_local_5.greenOffset + 100);
                    _local_5.blueOffset = (_local_5.blueOffset + 100);
                    break;
                case "DARK":
                    _local_5.redOffset = (_local_5.redOffset - ((_arg_1.strLocation == "Skin") ? 25 : 50));
                    _local_5.greenOffset = (_local_5.greenOffset - 50);
                    _local_5.blueOffset = (_local_5.blueOffset - 50);
                    break;
                case "DARKER":
                    _local_5.redOffset = (_local_5.redOffset - 125);
                    _local_5.greenOffset = (_local_5.greenOffset - 125);
                    _local_5.blueOffset = (_local_5.blueOffset - 125);
                    break;
            }
            if (_arg_4 == "-")
            {
                _local_5.redOffset = (_local_5.redOffset * -1);
                _local_5.greenOffset = (_local_5.greenOffset * -1);
                _local_5.blueOffset = (_local_5.blueOffset * -1);
            }
            if (((_arg_4 == "") || (!(_arg_1.transform.colorTransform.redOffset == _local_5.redOffset))))
            {
                _arg_1.transform.colorTransform = _local_5;
            }
        }

        private function addGlow(_arg_1:MovieClip):void
        {
        }

        public function loadMisc():void
        {
            r.onLoadMaster(onLoadMiscComplete, loaderC, pAV.objData.eqp["mi"].sFile);
        }

        public function onLoadMiscComplete(_arg_1:Event):void
        {
            var _local_2:*;
            try
            {
                _local_2 = (getDefinitionByName(pAV.objData.eqp["mi"].sLink) as Class);
                this.shadow.removeChildAt(0);
                this.shadow.addChild(new (_local_2)());
                this.shadow.scaleX = 1;
                this.shadow.scaleY = 1;
                this.shadow.mouseEnabled = (this.shadow.mouseChildren = false);
            }
            catch(err:Error)
            {
            }
        }

        public function loadWeapon():void
        {
            weaponLoad = false;
            r.onLoadMaster(onLoadWeaponComplete, loaderC, pAV.objData.eqp["Weapon"].sFile);
        }

        public function onLoadWeaponComplete(e:Event):void
        {
            var AssetClass:* = undefined;
            mcChar.weapon.removeChildAt(0);
            try
            {
                AssetClass = (getDefinitionByName(pAV.objData.eqp["Weapon"].sLink) as Class);
                if (pAV.objData.eqp["Weapon"].sType == "Gauntlet")
                {
                    mcChar.fronthand.addChildAt(new (AssetClass)(), 1);
                    mcChar.fronthand.getChildAt(1).scaleX = 0.8;
                    mcChar.fronthand.getChildAt(1).scaleY = 0.8;
                    mcChar.fronthand.getChildAt(1).scaleX = (mcChar.fronthand.getChildAt(1).scaleX * -1);
                    mcChar.backhand.addChildAt(new (AssetClass)(), 1);
                    mcChar.backhand.getChildAt(1).scaleX = 0.8;
                    mcChar.backhand.getChildAt(1).scaleY = 0.8;
                    mcChar.backhand.getChildAt(1).scaleX = (mcChar.backhand.getChildAt(1).scaleX * -1);
                }
                else
                {
                    mcChar.weapon.addChild(new (AssetClass)());
                }
            }
            catch(err:Error)
            {
                mcChar.weapon.addChild(e.target.content);
            }
            weaponLoad = true;
            if (pAV.objData.eqp["Weapon"].sType == "Dagger")
            {
                loadWeaponOff();
            }
        }

        public function loadWeaponOff():void
        {
            r.onLoadMaster(onLoadWeaponOffComplete, loaderC, pAV.objData.eqp["Weapon"].sFile);
        }

        public function onLoadWeaponOffComplete(e:Event):void
        {
            var AssetClass:* = undefined;
            mcChar.weaponOff.removeChildAt(0);
            try
            {
                AssetClass = (getDefinitionByName(pAV.objData.eqp["Weapon"].sLink) as Class);
                mcChar.weaponOff.addChild(new (AssetClass)());
            }
            catch(err:Error)
            {
                mcChar.weaponOff.addChild(e.target.content);
            }
            mcChar.weaponOff.visible = true;
        }

        public function loadCape():void
        {
            capeLoad = false;
            r.onLoadMaster(onLoadCapeComplete, loaderC, pAV.objData.eqp["ba"].sFile);
        }

        public function onLoadCapeComplete(_arg_1:Event):void
        {
            var _local_2:Class = (getDefinitionByName(pAV.objData.eqp["ba"].sLink) as Class);
            mcChar.cape.removeChildAt(0);
            mcChar.cape.cape = new (_local_2)();
            mcChar.cape.addChild(mcChar.cape.cape);
            mcChar.cape.visible = true;
            capeLoad = true;
        }

        public function loadHelm():void
        {
            helmLoad = false;
            r.onLoadMaster(onLoadHelmComplete, loaderC, pAV.objData.eqp["he"].sFile);
        }

        public function onLoadHelmComplete(e:Event):void
        {
            var AssetClass2:Class;
            helmLoad = true;
            helmEquipped = true;
            var AssetClass:Class = (getDefinitionByName(pAV.objData.eqp["he"].sLink) as Class);
            mcChar.head.helm.removeChildAt(0);
            mcChar.head.helm.addChild(new (AssetClass)());
            mcChar.head.helm.visible = true;
            mcChar.head.hair.visible = false;
            mcChar.backhair.visible = false;
            if (!ApplicationDomain.currentDomain.hasDefinition((pAV.objData.eqp["he"].sLink + "_backhair")))
            {
                return;
            }
            try
            {
                AssetClass2 = (getDefinitionByName((pAV.objData.eqp["he"].sLink + "_backhair")) as Class);
                if (AssetClass2 != null)
                {
                    if (mcChar.backhair.numChildren > 0)
                    {
                        mcChar.backhair.removeChildAt(0);
                    }
                    mcChar.backhair.addChild(new (AssetClass2)());
                    mcChar.backhair.visible = true;
                }
                else
                {
                    mcChar.backhair.visible = false;
                }
            }
            catch(e)
            {
                mcChar.backhair.visible = false;
            }
        }

        internal function frame1():*
        {
            mcChar.transform.colorTransform = CT1;
            mcChar.alpha = 0;
            stop();
        }

        internal function frame5():*
        {
            mcChar.transform.colorTransform = CT1;
            mcChar.alpha = 0;
        }

        internal function frame8():*
        {
            if (loaded)
            {
                gotoAndPlay("in1");
            }
            else
            {
                gotoAndPlay(8);
            }
        }

        internal function frame10():*
        {
            mcChar.alpha = 0;
        }

        internal function frame12():*
        {
            mcChar.transform.colorTransform = CT3;
        }

        internal function frame13():*
        {
            mcChar.transform.colorTransform = CT2;
        }

        internal function frame14():*
        {
            mcChar.transform.colorTransform = CT1;
        }

        internal function frame20():*
        {
            mcChar.transform.colorTransform = CT1;
        }

        internal function frame23():*
        {
            stop();
        }


    }
}//package 

