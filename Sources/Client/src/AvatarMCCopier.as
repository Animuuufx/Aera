// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//AvatarMCCopier

package 
{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class AvatarMCCopier 
    {

        private var world:*;
        private var rootClass:*;
        private var mcChar:MovieClip;
        private var objLinks:Object = {};
        private var pAV:Avatar;
        private var strGender:String;
        private var helmEquipped:Boolean = false;

        public function AvatarMCCopier(_arg_1:MovieClip):void
        {
            world = _arg_1;
        }

        public function copyTo(_arg_1:MovieClip):void
        {
            var _local_3:*;
            var _local_4:*;
            mcChar = _arg_1;
            MovieClip(mcChar.parent).pAV = world.myAvatar;
            pAV = world.myAvatar;
            strGender = pAV.objData.strGender;
            var _local_2:* = ["cape", "backhair", "robe", "backrobe"];
            for (_local_3 in _local_2)
            {
                if (typeof(mcChar[_local_2[_local_3]]) != undefined)
                {
                    mcChar[_local_2[_local_3]].visible = false;
                };
            };
            if (((!(pAV.dataLeaf.showHelm)) || ((!("he" in pAV.objData.eqp)) && (pAV.objData.eqp.he == null))))
            {
                onHairLoadComplete(null);
            };
            for (_local_4 in world.myAvatar.objData.eqp)
            {
                switch (_local_4)
                {
                    case "Weapon":
                        world.queueLoad({
                            "strFile":(world.rootClass.getFilePath() + pAV.objData.eqp[_local_4].sFile),
                            "callBackA":onLoadWeaponComplete
                        });
                        break;
                    case "he":
                        if (pAV.dataLeaf.showHelm)
                        {
                            onLoadHelmComplete(null);
                        };
                        break;
                    case "ba":
                        if (pAV.dataLeaf.showCloak)
                        {
                            onLoadCapeComplete(null);
                        };
                        break;
                    case "ar":
                        if (world.myAvatar.objData.eqp.co == null)
                        {
                            objLinks.ar = pAV.objData.eqp.ar.sLink;
                            onLoadArmorComplete(null);
                        };
                        break;
                    case "co":
                        objLinks.ar = pAV.objData.eqp.co.sLink;
                        onLoadArmorComplete(null);
                        break;
                };
            };
        }

        public function loadArmorPieces(strSkinLinkage:String):void
        {
            var AssetClass:Class;
            var child:DisplayObject;
            try
            {
                AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Head")) as Class);
                mcChar.head.addChildAt(new (AssetClass)(), 0);
                mcChar.head.removeChildAt(1);
            }
            catch(err:Error)
            {
                AssetClass = (world.getClass(("mcHead" + strGender)) as Class);
                mcChar.head.addChildAt(new (AssetClass)(), 0);
                mcChar.head.removeChildAt(1);
            };
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Chest")) as Class);
            mcChar.chest.removeChildAt(0);
            mcChar.chest.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Hip")) as Class);
            mcChar.hip.removeChildAt(0);
            mcChar.hip.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "FootIdle")) as Class);
            mcChar.idlefoot.removeChildAt(0);
            mcChar.idlefoot.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Foot")) as Class);
            mcChar.frontfoot.removeChildAt(0);
            mcChar.frontfoot.addChild(new (AssetClass)());
            mcChar.frontfoot.visible = false;
            mcChar.backfoot.removeChildAt(0);
            mcChar.backfoot.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Shoulder")) as Class);
            mcChar.frontshoulder.removeChildAt(0);
            mcChar.frontshoulder.addChild(new (AssetClass)());
            mcChar.backshoulder.removeChildAt(0);
            mcChar.backshoulder.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Hand")) as Class);
            mcChar.fronthand.removeChildAt(0);
            mcChar.fronthand.addChild(new (AssetClass)());
            mcChar.backhand.removeChildAt(0);
            mcChar.backhand.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Thigh")) as Class);
            mcChar.frontthigh.removeChildAt(0);
            mcChar.frontthigh.addChild(new (AssetClass)());
            mcChar.backthigh.removeChildAt(0);
            mcChar.backthigh.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Shin")) as Class);
            mcChar.frontshin.removeChildAt(0);
            mcChar.frontshin.addChild(new (AssetClass)());
            mcChar.backshin.removeChildAt(0);
            mcChar.backshin.addChild(new (AssetClass)());
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Robe")) as Class);
            if (AssetClass != null)
            {
                mcChar.robe.removeChildAt(0);
                mcChar.robe.addChild(new (AssetClass)());
                mcChar.robe.visible = true;
            }
            else
            {
                mcChar.robe.visible = false;
            };
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "RobeBack")) as Class);
            if (AssetClass != null)
            {
                mcChar.backrobe.removeChildAt(0);
                mcChar.backrobe.addChild(new (AssetClass)());
                mcChar.backrobe.visible = true;
            }
            else
            {
                mcChar.backrobe.visible = false;
            };
        }

        public function onLoadArmorComplete(_arg_1:Event):void
        {
            loadArmorPieces(objLinks.ar);
        }

        public function onHairLoadComplete(_arg_1:Event):void
        {
            var _local_2:Class;
            if (helmEquipped)
            {
                return;
            };
            _local_2 = (world.getClass(((pAV.objData.strHairName + pAV.objData.strGender) + "Hair")) as Class);
            if (_local_2 != null)
            {
                if (mcChar.head.hair.numChildren > 0)
                {
                    mcChar.head.hair.removeChildAt(0);
                };
                mcChar.head.hair.addChild(new (_local_2)());
                mcChar.head.hair.visible = true;
            }
            else
            {
                mcChar.head.hair.visible = false;
            };
            _local_2 = (world.getClass(((pAV.objData.strHairName + pAV.objData.strGender) + "HairBack")) as Class);
            if (_local_2 != null)
            {
                if (mcChar.backhair.numChildren > 0)
                {
                    mcChar.backhair.removeChildAt(0);
                };
                mcChar.backhair.addChild(new (_local_2)());
                mcChar.backhair.visible = true;
            }
            else
            {
                mcChar.backhair.visible = false;
            };
        }

        public function loadWeapon(_arg_1:*, _arg_2:*):void
        {
            world.queueLoad({
                "strFile":(world.rootClass.getFilePath() + _arg_1),
                "callBackA":onLoadWeaponComplete,
                "avt":pAV,
                "sES":"weapon"
            });
        }

        public function onLoadWeaponComplete(e:Event):void
        {
            var AssetClass:Class;
            mcChar.weapon.removeChildAt(0);
            try
            {
                AssetClass = (world.getClass(pAV.objData.eqp.Weapon.sLink) as Class);
                if (pAV.objData.eqp.Weapon.sType == "Gauntlet")
                {
                    mcChar.fronthand.addChildAt(new (AssetClass)(), 1);
                    mcChar.fronthand.getChildAt(1).scaleX = 0.8;
                    mcChar.fronthand.getChildAt(1).scaleY = 0.8;
                    mcChar.fronthand.getChildAt(1).scaleX = (mcChar.fronthand.getChildAt(1).scaleX * -1);
                    mcChar.weapon.mcWeapon = new MovieClip();
                }
                else
                {
                    mcChar.weapon.addChild(new (AssetClass)());
                };
            }
            catch(err:Error)
            {
                mcChar.weapon.addChild(e.target.content);
            };
            mcChar.weapon.visible = true;
            if (("eventTrigger" in MovieClip(world.map)))
            {
                world.map.eventTrigger({"cmd":"copyAvatarMCCompleted"});
            };
        }

        public function onLoadCapeComplete(_arg_1:Event):void
        {
            var _local_2:Class = (world.getClass(pAV.objData.eqp.ba.sLink) as Class);
            mcChar.cape.removeChildAt(0);
            mcChar.cape.cape = new (_local_2)();
            mcChar.cape.addChild(mcChar.cape.cape);
            mcChar.cape.visible = true;
        }

        public function onLoadHelmComplete(_arg_1:Event):void
        {
            var _local_2:Class = (world.getClass(pAV.objData.eqp.he.sLink) as Class);
            var _local_3:Class = (world.getClass((pAV.objData.eqp.he.sLink + "_backhair")) as Class);
            if (_local_2 != null)
            {
                if (mcChar.head.helm.numChildren > 0)
                {
                    mcChar.head.helm.removeChildAt(0);
                };
                mcChar.head.helm.visible = pAV.dataLeaf.showHelm;
                mcChar.head.hair.visible = (!(mcChar.head.helm.visible));
                if (_local_3 != null)
                {
                    if (pAV.dataLeaf.showHelm)
                    {
                        mcChar.backhair.visible = true;
                        mcChar.backhair.addChild(new (_local_3)());
                    }
                    else
                    {
                        mcChar.backhair.visible = ((mcChar.head.hair.visible) && (pAV.pMC.bBackHair));
                    };
                }
                else
                {
                    mcChar.backhair.visible = ((mcChar.head.hair.visible) && (pAV.pMC.bBackHair));
                };
                mcChar.head.helm.addChild(new (_local_2)());
                helmEquipped = true;
            }
            else
            {
                world.rootClass.chatF.pushMsg("warning", "Could not resolve Helm definition.", "SERVER", "", 0);
            };
        }


    }
}//package 

