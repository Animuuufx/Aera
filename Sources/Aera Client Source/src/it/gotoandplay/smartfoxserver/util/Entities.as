// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.util.Entities

package it.gotoandplay.smartfoxserver.util
{
    public class Entities 
    {

        private static var ascTab:Array = [];
        private static var ascTabRev:Array = [];
        private static var hexTable:Array = new Array();

        {
            ascTab[">"] = "&gt;";
            ascTab["<"] = "&lt;";
            ascTab["&"] = "&amp;";
            ascTab["'"] = "&apos;";
            ascTab['"'] = "&quot;";
            ascTabRev["&gt;"] = ">";
            ascTabRev["&lt;"] = "<";
            ascTabRev["&amp;"] = "&";
            ascTabRev["&apos;"] = "'";
            ascTabRev["&quot;"] = '"';
            hexTable["0"] = 0;
            hexTable["1"] = 1;
            hexTable["2"] = 2;
            hexTable["3"] = 3;
            hexTable["4"] = 4;
            hexTable["5"] = 5;
            hexTable["6"] = 6;
            hexTable["7"] = 7;
            hexTable["8"] = 8;
            hexTable["9"] = 9;
            hexTable["A"] = 10;
            hexTable["B"] = 11;
            hexTable["C"] = 12;
            hexTable["D"] = 13;
            hexTable["E"] = 14;
            hexTable["F"] = 15;
        }


        public static function encodeEntities(_arg_1:String):String
        {
            var _local_4:String;
            var _local_5:int;
            var _local_2:* = "";
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = _arg_1.charAt(_local_3);
                _local_5 = _arg_1.charCodeAt(_local_3);
                if ((((_local_5 == 9) || (_local_5 == 10)) || (_local_5 == 13)))
                {
                    _local_2 = (_local_2 + _local_4);
                }
                else
                {
                    if (((_local_5 >= 32) && (_local_5 <= 126)))
                    {
                        if (ascTab[_local_4] != null)
                        {
                            _local_2 = (_local_2 + ascTab[_local_4]);
                        }
                        else
                        {
                            _local_2 = (_local_2 + _local_4);
                        };
                    }
                    else
                    {
                        _local_2 = (_local_2 + _local_4);
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        public static function decodeEntities(_arg_1:String):String
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            var _local_7:int;
            _local_2 = "";
            while (_local_7 < _arg_1.length)
            {
                _local_3 = _arg_1.charAt(_local_7);
                if (_local_3 == "&")
                {
                    _local_4 = _local_3;
                    do 
                    {
                        _local_5 = _arg_1.charAt(++_local_7);
                        _local_4 = (_local_4 + _local_5);
                    } while (((!(_local_5 == ";")) && (_local_7 < _arg_1.length)));
                    _local_6 = ascTabRev[_local_4];
                    if (_local_6 != null)
                    {
                        _local_2 = (_local_2 + _local_6);
                    }
                    else
                    {
                        _local_2 = (_local_2 + String.fromCharCode(getCharCode(_local_4)));
                    };
                }
                else
                {
                    _local_2 = (_local_2 + _local_3);
                };
                _local_7++;
            };
            return (_local_2);
        }

        public static function getCharCode(_arg_1:String):Number
        {
            var _local_2:String = _arg_1.substr(3, _arg_1.length);
            _local_2 = _local_2.substr(0, (_local_2.length - 1));
            return (Number(("0x" + _local_2)));
        }


    }
}//package it.gotoandplay.smartfoxserver.util

