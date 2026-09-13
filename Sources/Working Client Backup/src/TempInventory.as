// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//TempInventory

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class TempInventory extends MovieClip 
    {

        public var strGold:TextField;
        public var mcItemList:ItemList;
        public var txtEquip:TextField;
        public var strInfo:TextField;
        public var btnEquip:SimpleButton;
        public var bg1:MovieClip;
        public var strCoins:TextField;
        internal var rootClass:MovieClip = MovieClip(parent.parent.parent);

        public function TempInventory()
        {
            bg1.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            btnEquip.addEventListener(MouseEvent.CLICK, onEquipClick, false, 0, true);
            txtEquip.mouseEnabled = false;
            init();
        }

        public function onDeleteClick(_arg_1:Event):void
        {
        }

        public function onEquipClick(_arg_1:Event):*
        {
            rootClass.mixer.playSound("Click");
            var _local_2:* = rootClass.world.getUoLeafById(rootClass.world.myAvatar.uid);
            if (_local_2.intState != 1)
            {
                rootClass.MsgBox.notify("Action cannot be performed during combat!");
            }
            else
            {
                if (mcItemList.selectedItem.bEquip == 1)
                {
                    if (((mcItemList.selectedItem.sES == "Weapon") || (mcItemList.selectedItem.sES == "ar")))
                    {
                        rootClass.MsgBox.notify("Selected Item cannot be unequipped!");
                    }
                    else
                    {
                        rootClass.world.sendUnequipItemRequest(mcItemList.selectedItem);
                    };
                }
                else
                {
                    if (((mcItemList.selectedItem.bUpg == 1) && (!(rootClass.world.myAvatar.isUpgraded()))))
                    {
                        rootClass.showUpgradeWindow();
                    }
                    else
                    {
                        if (int(mcItemList.selectedItem.iEnhLvl) > int(rootClass.world.myAvatar.objData.intLevel))
                        {
                            rootClass.MsgBox.notify("Level requirement not met!");
                        }
                        else
                        {
                            if ((((!(mcItemList.selectedItem.sES == "mi")) && (!(mcItemList.selectedItem.sES == "co"))) && (!(mcItemList.selectedItem.EnhID > 0))))
                            {
                                rootClass.MsgBox.notify("Selected item requires enhancement!");
                            }
                            else
                            {
                                rootClass.world.sendEquipItemRequest(mcItemList.selectedItem);
                            };
                        };
                    };
                };
            };
        }

        internal function onCloseClick(_arg_1:Event):*
        {
            MovieClip(parent).onClose();
        }

        public function toggleInventory():void
        {
            this.visible = (!(this.visible));
        }

        public function refreshDetail():void
        {
            if (selectedItem == null)
            {
                strInfo.htmlText = "Please select an item to view details.";
                btnEquip.visible = (txtEquip.visible = false);
            }
            else
            {
                if (selectedItem.bEquip == 1)
                {
                    txtEquip.text = "Unequip";
                }
                else
                {
                    txtEquip.text = "Equip";
                };
                btnEquip.visible = (txtEquip.visible = (selectedItem.sES == "co"));
                strInfo.htmlText = getItemInfoString(selectedItem);
            };
        }

        public function get selectedItem():Object
        {
            return (mcItemList.selectedItem);
        }

        public function init():void
        {
            mcItemList.init(MovieClip(parent.parent.parent).world.myAvatar.tempitems);
            updateGold();
            refreshDetail();
        }

        public function updateGold():void
        {
            strGold.text = MovieClip(parent.parent.parent).world.myAvatar.objData.intGold;
            strCoins.text = MovieClip(parent.parent.parent).world.myAvatar.objData.intCoins;
        }

        internal function getItemInfoString(_arg_1:Object):String
        {
            var _local_4:Number;
            var _local_2:* = (("<font size='14'><b>" + _arg_1.sName) + "</b></font><br>");
            var _local_3:* = "#009900";
            _local_2 = (_local_2 + ((("<font color='" + _local_3) + "'><b>") + _arg_1.sType));
            if (_arg_1.iStk > 1)
            {
                _local_2 = (_local_2 + (((" - " + _arg_1.iQty) + "/") + _arg_1.iStk));
            };
            if (_arg_1.sES == "Weapon")
            {
                if (_arg_1.iEnh > 0)
                {
                    _local_2 = (_local_2 + ((", Lvl " + _arg_1.iLvl) + "<br>"));
                    _local_4 = (((Math.sqrt(_arg_1.iLvl) * 20) * _arg_1.iDPS) / 100);
                    _local_2 = (_local_2 + ((((Math.ceil(((_local_4 * (100 - Number(_arg_1.iRng))) / 100)) + " - ") + Math.ceil(((_local_4 * (100 + Number(_arg_1.iRng))) / 100))) + " ") + _arg_1.sElmt));
                }
                else
                {
                    _local_2 = (_local_2 + " Design");
                };
            };
            return (_local_2 + (("</b></font><br>" + _arg_1.sDesc) + "<br>"));
        }


    }
}//package 

