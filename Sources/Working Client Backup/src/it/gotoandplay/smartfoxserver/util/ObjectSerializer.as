// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.util.ObjectSerializer

package it.gotoandplay.smartfoxserver.util
{
    public class ObjectSerializer 
    {

        private static var instance:ObjectSerializer;

        private var debug:Boolean;
        private var eof:String;
        private var tabs:String;

        public function ObjectSerializer(_arg_1:Boolean=false)
        {
            this.tabs = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
            setDebug(_arg_1);
        }

        public static function getInstance(_arg_1:Boolean=false):ObjectSerializer
        {
            if (instance == null)
            {
                instance = new ObjectSerializer(_arg_1);
            };
            return (instance);
        }


        private function setDebug(_arg_1:Boolean):void
        {
            this.debug = _arg_1;
            if (this.debug)
            {
                this.eof = "\n";
            }
            else
            {
                this.eof = "";
            };
        }

        public function serialize(_arg_1:Object):String
        {
            var _local_2:Object = {};
            obj2xml(_arg_1, _local_2);
            return (_local_2.xmlStr);
        }

        public function deserialize(_arg_1:String):Object
        {
            var _local_2:XML = new XML(_arg_1);
            var _local_3:Object = {};
            xml2obj(_local_2, _local_3);
            return (_local_3);
        }

        private function obj2xml(_arg_1:Object, _arg_2:Object, _arg_3:int=0, _arg_4:String=""):void
        {
            var _local_5:String;
            var _local_6:String;
            var _local_7:String;
            var _local_8:*;
            if (_arg_3 == 0)
            {
                _arg_2.xmlStr = ("<dataObj>" + this.eof);
            }
            else
            {
                if (this.debug)
                {
                    _arg_2.xmlStr = (_arg_2.xmlStr + this.tabs.substr(0, _arg_3));
                };
                _local_6 = ((_arg_1 is Array) ? "a" : "o");
                _arg_2.xmlStr = (_arg_2.xmlStr + ((((("<obj t='" + _local_6) + "' o='") + _arg_4) + "'>") + this.eof));
            };
            for (_local_5 in _arg_1)
            {
                _local_7 = typeof(_arg_1[_local_5]);
                _local_8 = _arg_1[_local_5];
                if (((((_local_7 == "boolean") || (_local_7 == "number")) || (_local_7 == "string")) || (_local_7 == "null")))
                {
                    if (_local_7 == "boolean")
                    {
                        _local_8 = Number(_local_8);
                    }
                    else
                    {
                        if (_local_7 == "null")
                        {
                            _local_7 = "x";
                            _local_8 = "";
                        }
                        else
                        {
                            if (_local_7 == "string")
                            {
                                _local_8 = Entities.encodeEntities(_local_8);
                            };
                        };
                    };
                    if (this.debug)
                    {
                        _arg_2.xmlStr = (_arg_2.xmlStr + this.tabs.substr(0, (_arg_3 + 1)));
                    };
                    _arg_2.xmlStr = (_arg_2.xmlStr + ((((((("<var n='" + _local_5) + "' t='") + _local_7.substr(0, 1)) + "'>") + _local_8) + "</var>") + this.eof));
                }
                else
                {
                    if (_local_7 == "object")
                    {
                        obj2xml(_local_8, _arg_2, (_arg_3 + 1), _local_5);
                        if (this.debug)
                        {
                            _arg_2.xmlStr = (_arg_2.xmlStr + this.tabs.substr(0, (_arg_3 + 1)));
                        };
                        _arg_2.xmlStr = (_arg_2.xmlStr + ("</obj>" + this.eof));
                    };
                };
            };
            if (_arg_3 == 0)
            {
                _arg_2.xmlStr = (_arg_2.xmlStr + ("</dataObj>" + this.eof));
            };
        }

        private function xml2obj(_arg_1:XML, _arg_2:Object):void
        {
            var _local_5:String;
            var _local_6:XML;
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            var _local_10:String;
            var _local_11:String;
            var _local_3:int;
            var _local_4:XMLList = _arg_1.children();
            for each (_local_6 in _local_4)
            {
                _local_5 = _local_6.name().toString();
                if (_local_5 == "obj")
                {
                    _local_7 = _local_6.@o;
                    _local_8 = _local_6.@t;
                    if (_local_8 == "a")
                    {
                        _arg_2[_local_7] = [];
                    }
                    else
                    {
                        if (_local_8 == "o")
                        {
                            _arg_2[_local_7] = {};
                        };
                    };
                    xml2obj(_local_6, _arg_2[_local_7]);
                }
                else
                {
                    if (_local_5 == "var")
                    {
                        _local_9 = _local_6.@n;
                        _local_10 = _local_6.@t;
                        _local_11 = _local_6.toString();
                        if (_local_10 == "b")
                        {
                            _arg_2[_local_9] = ((_local_11 == "0") ? false : true);
                        }
                        else
                        {
                            if (_local_10 == "n")
                            {
                                _arg_2[_local_9] = Number(_local_11);
                            }
                            else
                            {
                                if (_local_10 == "s")
                                {
                                    _arg_2[_local_9] = _local_11;
                                }
                                else
                                {
                                    if (_local_10 == "x")
                                    {
                                        _arg_2[_local_9] = null;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function encodeEntities(_arg_1:String):String
        {
            return (_arg_1);
        }


    }
}//package it.gotoandplay.smartfoxserver.util

