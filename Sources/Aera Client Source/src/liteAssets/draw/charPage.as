// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//liteAssets.draw.charPage

package liteAssets.draw
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import characterA_fla.movFaction_73;
    import flash.net.URLLoader;
    import flash.net.URLVariables;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import fl.data.*;
    import flash.utils.*;
    import fl.events.*;
    import flash.filters.*;

    public class charPage extends MovieClip 
    {

        public var txtClassName:TextField;
        public var btClose:SimpleButton;
        public var mcCharUI:MovieClip;
        public var txtWeapon:TextField;
        public var movFaction:movFaction_73;
        public var txtArmor:TextField;
        public var btCharPage:MovieClip;
        public var txtGuildName:TextField;
        public var txtHelm:TextField;
        public var txtLvl:TextField;
        public var txtPet:TextField;
        public var txtAlignment:TextField;
        public var txtUserName:TextField;
        public var txtCape:TextField;
        public var txtMisc:TextField;
        internal var charPageLoader:URLLoader;
        internal var userName:String;
        internal var rootClass:MovieClip;
        internal var flashvars:URLVariables;
        internal var _tempMC:AvatarMC;
        private var petMC:PetMC;

        public function charPage(_arg_1:MovieClip, _arg_2:String)
        {
            rootClass = _arg_1;
            this.x = 205;
            this.y = 80;
            this.visible = false;
            userName = _arg_2;
            charPageLoader = new URLLoader();
            charPageLoader.addEventListener(Event.COMPLETE, onCharPage, false, 0, true);
            charPageLoader.load(new URLRequest(((rootClass.getGamePath() + "api/charpage/fvars?id=") + userName)));
            this.btCharPage.addEventListener(MouseEvent.CLICK, onBtCharPage, false, 0, true);
            this.btClose.addEventListener(MouseEvent.CLICK, onBtClose, false, 0, true);
            txtClassName.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            txtWeapon.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            txtArmor.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            txtHelm.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            txtCape.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            txtPet.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
            txtMisc.addEventListener(MouseEvent.CLICK, onWiki, false, 0, true);
        }

        public function onWiki(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.text == "None")
            {
                return;
            };
            navigateToURL(new URLRequest(("http://aqwwiki.wikidot.com/" + _arg_1.currentTarget.text)), "_blank");
        }

        public function onDrag(_arg_1:MouseEvent):void
        {
            this.startDrag();
        }

        public function onStopDrag(_arg_1:MouseEvent):void
        {
            this.stopDrag();
        }

        public function onCharPage(_arg_1:Event):void
        {
            var _local_3:Class;
            var _local_4:*;
            var _local_5:*;
            if (((_arg_1.target.data == "Hidden") || (_arg_1.target.data == "Empty")))
            {
                _local_3 = rootClass.world.getClass("ModalMC");
                _local_4 = new (_local_3)();
                _local_5 = {};
                _local_5.strBody = ("User not found: " + userName);
                _local_5.params = {};
                _local_5.glow = "red,medium";
                _local_5.btns = "mono";
                rootClass.stage.addChild(_local_4);
                _local_4.init(_local_5);
                return;
            };
            flashvars = new URLVariables(_arg_1.target.data.substring(1).replace("+", "%2B"));
            this.txtUserName.text = flashvars.strName;
            this.txtLvl.text = flashvars.intLevel.split(" -")[0];
            if (flashvars.intLevel.indexOf(" Guild") > -1)
            {
                this.txtGuildName.text = flashvars.intLevel.split("--- ")[1].substring(0, (flashvars.intLevel.split("--- ")[1].length - 6));
            }
            else
            {
                this.txtGuildName.text = "None";
            };
            this.txtClassName.text = flashvars.strClassName;
            if (this.txtClassName.text == "")
            {
                this.txtClassName.text = "None";
            };
            this.txtWeapon.text = flashvars.strWeaponName;
            if (this.txtWeapon.text == "")
            {
                this.txtWeapon.text = "None";
            };
            this.txtArmor.text = flashvars.strArmorName;
            if (this.txtArmor.text == "")
            {
                this.txtArmor.text = "None";
            };
            this.txtHelm.text = flashvars.strHelmName;
            if (this.txtHelm.text == "")
            {
                this.txtHelm.text = "None";
            };
            this.txtCape.text = flashvars.strCapeName;
            if (this.txtCape.text == "")
            {
                this.txtCape.text = "None";
            };
            this.txtPet.text = flashvars.strPetName;
            if (this.txtPet.text == "")
            {
                this.txtPet.text = "None";
            };
            if (flashvars.strMiscName)
            {
                this.txtMisc.text = flashvars.strMiscName;
                if (this.txtMisc.text == "")
                {
                    this.txtMisc.text = "None";
                };
            }
            else
            {
                this.txtMisc.text = "None";
            };
            var _local_2:String = flashvars.strFaction;
            this.txtAlignment.text = _local_2;
            if (_local_2 == "Neutral")
            {
                this.movFaction.gotoAndStop(2);
            };
            if (_local_2 == "Good")
            {
                this.movFaction.gotoAndStop(3);
            };
            if (_local_2 == "Evil")
            {
                this.movFaction.gotoAndStop(4);
            };
            if (_local_2 == "Chaos")
            {
                this.movFaction.gotoAndStop(5);
            };
            _tempMC = new AvatarMC();
            _tempMC.world = rootClass.world;
            this.copyTo(_tempMC.mcChar);
            _tempMC.hideHPBar();
            _tempMC.name = "DisplayMC";
            this.mcCharUI.mcBG.addChild(_tempMC);
            _tempMC.x = 250;
            _tempMC.y = -30;
            _tempMC.scaleX = (_tempMC.scaleX * -3);
            _tempMC.scaleY = (_tempMC.scaleY * 3);
            this.visible = true;
        }

        public function getAchievement(_arg_1:int):int
        {
            if (((_arg_1 < 0) || (_arg_1 > 31)))
            {
                return (-1);
            };
            var _local_2:* = flashvars.ia1;
            if (_local_2 == null)
            {
                return (-1);
            };
            return (((_local_2 & Math.pow(2, _arg_1)) == 0) ? 0 : 1);
        }

        public function copyTo(_arg_1:MovieClip):void
        {
            var _local_5:*;
            var _local_6:*;
            var _local_2:* = undefined;
            var _local_3:Avatar = new Avatar(rootClass);
            _local_3.isCharPage = true;
            _local_3.pnm = rootClass.world.myAvatar.pnm;
            _local_3.objData = rootClass.copyObj(rootClass.world.myAvatar.objData);
            _tempMC.pAV = _local_3;
            _tempMC.pAV.pMC = _tempMC;
            _tempMC.pAV.objData.intColorHair = flashvars.intColorHair;
            _tempMC.pAV.objData.intColorSkin = flashvars.intColorSkin;
            _tempMC.pAV.objData.intColorEye = flashvars.intColorEye;
            _tempMC.pAV.objData.intColorBase = flashvars.intColorBase;
            _tempMC.pAV.objData.intColorTrim = flashvars.intColorTrim;
            _tempMC.pAV.objData.intColorAccessory = flashvars.intColorAccessory;
            _tempMC.pAV.objData.strHairFilename = flashvars.strHairFile;
            _tempMC.pAV.objData.strHairName = flashvars.strHairName;
            _tempMC.pAV.objData.eqp = {};
            _tempMC.pAV.objData.eqp.co = {};
            _tempMC.pAV.objData.eqp.co["sFile"] = flashvars.strClassFile;
            _tempMC.pAV.objData.eqp.co["sLink"] = flashvars.strClassLink;
            _tempMC.pAV.objData.eqp.Weapon = {};
            _tempMC.pAV.objData.eqp.Weapon["sFile"] = flashvars.strWeaponFile;
            _tempMC.pAV.objData.eqp.Weapon["sLink"] = flashvars.strWeaponLink;
            _tempMC.pAV.objData.eqp.Weapon["sType"] = flashvars.strWeaponType;
            _tempMC.pAV.objData.eqp.ba = {};
            _tempMC.pAV.objData.eqp.ba["sFile"] = flashvars.strCapeFile;
            _tempMC.pAV.objData.eqp.ba["sLink"] = flashvars.strCapeLink;
            _tempMC.pAV.objData.eqp.he = {};
            _tempMC.pAV.objData.eqp.he["sFile"] = flashvars.strHelmFile;
            _tempMC.pAV.objData.eqp.he["sLink"] = flashvars.strHelmLink;
            _tempMC.pAV.objData.eqp.mi = {};
            _tempMC.pAV.objData.eqp.mi["sFile"] = flashvars.strMiscFile;
            _tempMC.pAV.objData.eqp.mi["sLink"] = flashvars.strMiscLink;
            _tempMC.pAV.objData.strGender = flashvars.strGender;
            _tempMC.strGender = flashvars.strGender;
            _tempMC.pAV.dataLeaf.showHelm = ((!(flashvars.strHelmFile == "none")) && (this.getAchievement(1) == 0));
            _tempMC.pAV.dataLeaf.showCloak = ((!(flashvars.strCapeFile == "none")) && (this.getAchievement(0) == 0));
            _tempMC.pAV.isCharPage = true;
            var _local_4:* = ["cape", "backhair", "robe", "backrobe"];
            for (_local_2 in _local_4)
            {
                if (typeof(_arg_1[_local_4[_local_2]]) != undefined)
                {
                    _arg_1[_local_4[_local_2]].visible = false;
                };
            };
            if (((!(_tempMC.pAV.dataLeaf.showHelm)) || (_tempMC.pAV.objData.eqp.he.sFile == "none")))
            {
                _tempMC.loadHair();
            };
            for (_local_5 in _tempMC.pAV.objData.eqp)
            {
                _local_6 = _tempMC.pAV.objData.eqp[_local_5];
                switch (_local_5)
                {
                    case "Weapon":
                        _tempMC.loadWeapon(_local_6.sFile, _local_6.sLink);
                        break;
                    case "he":
                        if (((_tempMC.pAV.dataLeaf.showHelm) && (!(_tempMC.pAV.objData.eqp.he.sFile == "none"))))
                        {
                            _tempMC.loadHelm(_local_6.sFile, _local_6.sLink);
                        };
                        break;
                    case "ba":
                        if (((_tempMC.pAV.dataLeaf.showCloak) && (!(_tempMC.pAV.objData.eqp.ba.sFile == "none"))))
                        {
                            _tempMC.loadCape(_local_6.sFile, _local_6.sLink);
                        };
                        break;
                    case "co":
                        _tempMC.loadArmor(_local_6.sFile, _local_6.sLink);
                        break;
                    case "mi":
                        _tempMC.loadMisc(_local_6.sFile, _local_6.sLink);
                        break;
                };
            };
            if (((!(flashvars.strPetFile == "none")) && (this.getAchievement(2) == 0)))
            {
                petMC = new PetMC();
                petMC.mouseEnabled = (petMC.mouseChildren = false);
                petMC.pAV = _tempMC.pAV;
                rootClass.world.queueLoad({
                    "strFile":(rootClass.getFilePath() + flashvars.strPetFile),
                    "callBackA":onLoadPetComplete,
                    "avt":_tempMC.pAV,
                    "sES":"Pet"
                });
            };
        }

        public function onLoadPetComplete(_arg_1:Event):void
        {
            var _local_2:Class = (rootClass.world.getClass(flashvars.strPetLink) as Class);
            petMC.removeChildAt(1);
            petMC.mcChar = MovieClip(petMC.addChildAt(new (_local_2)(), 1));
            mcCharUI.mcBG.addChild(petMC);
            petMC.scale(2);
            petMC.turn("left");
            petMC.x = 50;
            petMC.y = -150;
            petMC.shadow.visible = false;
            mcCharUI.mcBG.setChildIndex(petMC, (mcCharUI.mcBG.numChildren - 2));
        }

        public function ioErrorHandler(_arg_1:*):void
        {
            var _local_2:Class;
            var _local_3:*;
            var _local_4:*;
            _local_2 = rootClass.world.getClass("ModalMC");
            _local_3 = new (_local_2)();
            _local_4 = {};
            _local_4.strBody = "Connection Error";
            _local_4.params = {};
            _local_4.glow = "red,medium";
            _local_4.btns = "mono";
            rootClass.stage.addChild(_local_3);
            _local_3.init(_local_4);
        }

        public function onBtCharPage(_arg_1:*):void
        {
            navigateToURL(new URLRequest(("https://account.aq.com/CharPage?id=" + userName)), "_blank");
        }

        public function onBtClose(_arg_1:*):void
        {
            this.parent.removeChild(this);
        }


    }
}//package liteAssets.draw

