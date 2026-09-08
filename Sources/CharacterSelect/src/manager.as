// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//manager

package 
{
    import flash.display.MovieClip;
    import flash.net.SharedObject;

    public class manager extends MovieClip 
    {

        private var r:MovieClip;
        private var m:MovieClip;
        public var displayAvts:Array;
        private var characters:SharedObject;

        public function manager(_arg_1:MovieClip, _arg_2:MovieClip)
        {
            var _local_4:*;
            var _local_5:Boolean;
            var _local_6:Array;
            var _local_7:String;
            var _local_8:Object;
            var _local_9:uint;
            super();
            r = _arg_1;
            m = _arg_2;
            characters = SharedObject.getLocal("AQWChars", "/");
            var _local_3:int;
            for (_local_4 in characters.data.users)
            {
                _local_3++;
            }
            _local_5 = false;
            _local_6 = [];
            displayAvts = [];
            for (_local_7 in characters.data.users)
            {
                _local_8 = (characters.data.users[_local_7] as Object);
                if (((((!(_local_8)) || (!(_local_8.data))) || (!(_local_8.server))) || (!(_local_8.loginInfo))))
                {
                    delete characters.data.users[_local_7];
                    _local_5 = true;
                }
                else
                {
                    if (_local_8.index == -1)
                    {
                        _local_8.index = (_local_3 - 1);
                        setCharIndex(_local_7, (_local_3 - 1));
                    }
                    if (_local_6.indexOf(_local_8.index) > -1)
                    {
                        _local_5 = true;
                    }
                    displayAvts.push({
                        "index":_local_8.index,
                        "data":_local_8.data,
                        "mc":null,
                        "server":_local_8.server,
                        "loginInfo":_local_8.loginInfo
                    });
                    if (!_local_5)
                    {
                        _local_6.push(_local_8.index);
                    }
                }
            }
            if (_local_5)
            {
                _local_9 = 0;
                while (_local_9 < displayAvts.length)
                {
                    displayAvts[_local_9].index = _local_9;
                    setCharIndex(displayAvts[_local_9].data.strUsername, _local_9);
                    _local_9++;
                }
            }
            displayAvts.sortOn("index");
            m.managecharsui.init(displayAvts);
            m.charoptionsui.init((displayAvts[0].loginInfo.bAsk as Boolean));
        }

        public function get count():int
        {
            return (displayAvts.length);
        }

        public function getCharByName(_arg_1:String):*
        {
            _arg_1 = _arg_1.toLowerCase();
            return ((characters.data.users as Object)[_arg_1]);
        }

        public function save(_arg_1:String, _arg_2:*):Boolean
        {
            _arg_1 = _arg_1.toLowerCase();
            if (count < 5)
            {
                saveCharByName(_arg_1, _arg_2);
                return (true);
            }
            return (false);
        }

        public function setAsk(_arg_1:String, _arg_2:Boolean):void
        {
            _arg_1 = _arg_1.toLowerCase();
            ((characters.data.users as Object)[_arg_1] as Object).loginInfo.bAsk = _arg_2;
            characters.flush();
        }

        public function setCharIndex(_arg_1:String, _arg_2:int):void
        {
            _arg_1 = _arg_1.toLowerCase();
            ((characters.data.users as Object)[_arg_1] as Object).index = _arg_2;
            characters.flush();
        }

        public function saveCharByName(_arg_1:String, _arg_2:*):void
        {
            _arg_1 = _arg_1.toLowerCase();
            (characters.data.users as Object)[_arg_1] = _arg_2;
            characters.flush();
        }

        public function delCharByName(_arg_1:String, _arg_2:int):void
        {
            _arg_1 = _arg_1.toLowerCase();
            (characters.data.users as Object)[_arg_1] = null;
            delete (characters.data.users as Object)[_arg_1];
            characters.flush();
            displayAvts.splice(_arg_2, 1);
        }

        public function createAvt(_arg_1:*):*
        {
            var _local_4:String;
            var _local_2:* = new selAvatarMC(r);
            _local_2.gotoAndPlay("hold");
            _local_2.name = ("selavt" + Math.random());
            _local_2.pAV.objData = _arg_1;
            _local_2.pAV.pMC = _local_2;
            _local_2.strGender = _arg_1.strGender;
            if (_arg_1.strHairFilename != "undefined")
            {
                _local_2.loadHair();
            }
            var _local_3:Boolean;
            for (_local_4 in _arg_1.eqp)
            {
                switch (_local_4)
                {
                    case "Weapon":
                        if (_arg_1.eqp["Weapon"].sFile == "undefined")
                        {
                            _local_2.mcChar.weapon.visible = false;
                            _local_2.mcChar.weaponOff.visible = false;
                            break;
                        }
                        _local_2.loadWeapon();
                        if (_arg_1.eqp["Weapon"].strWeaponType == "Dagger")
                        {
                            _local_2.loadWeaponOff();
                        }
                        else
                        {
                            _local_2.mcChar.weaponOff.visible = false;
                        }
                        break;
                    case "he":
                        if (((_arg_1.eqp["he"].sFile == "undefined") || ((_arg_1.hasOwnProperty("showHelm")) && (!(_arg_1.showHelm)))))
                        {
                            _local_2.mcChar.head.helm.visible = false;
                            _local_2.mcChar.head.hair.visible = true;
                            break;
                        }
                        _local_2.loadHelm();
                        break;
                    case "ba":
                        if (((_arg_1.eqp["ba"].sFile == "undefined") || ((_arg_1.hasOwnProperty("showCloak")) && (!(_arg_1.showCloak)))))
                        {
                            _local_2.mcChar.cape.visible = false;
                            break;
                        }
                        _local_2.loadCape();
                        break;
                    case "ar":
                    case "co":
                        if (_local_4 == "co")
                        {
                            _local_3 = true;
                        }
                        if (((_local_3) && (_local_4 == "ar"))) break;
                        _local_2.loadArmor(_arg_1.eqp[_local_4].sFile, _arg_1.eqp[_local_4].sLink);
                        break;
                    case "mi":
                        if (_arg_1.eqp["mi"].sFile == "undefined") break;
                        _local_2.loadMisc();
                        break;
                }
            }
            _local_2.scaleX = (_local_2.scaleX * 3);
            _local_2.scaleY = (_local_2.scaleY * 3);
            return (_local_2);
        }


    }
}//package 

