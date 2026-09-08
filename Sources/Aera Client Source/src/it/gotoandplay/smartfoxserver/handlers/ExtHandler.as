// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//it.gotoandplay.smartfoxserver.handlers.ExtHandler

package it.gotoandplay.smartfoxserver.handlers
{
    import it.gotoandplay.smartfoxserver.SmartFoxClient;
    import it.gotoandplay.smartfoxserver.SFSEvent;
    import it.gotoandplay.smartfoxserver.util.ObjectSerializer;

    public class ExtHandler implements IMessageHandler 
    {

        private var sfs:SmartFoxClient;

        public function ExtHandler(_arg_1:SmartFoxClient)
        {
            this.sfs = _arg_1;
        }

        public function handleMessage(_arg_1:Object, _arg_2:String):void
        {
            var _local_3:Object;
            var _local_4:SFSEvent;
            var _local_5:XML;
            var _local_6:String;
            var _local_7:int;
            var _local_8:String;
            var _local_9:Object;
            if (_arg_2 == SmartFoxClient.XTMSG_TYPE_XML)
            {
                _local_5 = (_arg_1 as XML);
                _local_6 = _local_5.body.@action;
                _local_7 = int(_local_5.body.@id);
                if (_local_6 == "xtRes")
                {
                    _local_8 = _local_5.body.toString();
                    _local_9 = ObjectSerializer.getInstance().deserialize(_local_8);
                    _local_3 = {};
                    _local_3.dataObj = _local_9;
                    _local_3.type = _arg_2;
                    _local_4 = new SFSEvent(SFSEvent.onExtensionResponse, _local_3);
                    sfs.dispatchEvent(_local_4);
                };
            }
            else
            {
                if (_arg_2 == SmartFoxClient.XTMSG_TYPE_JSON)
                {
                    _local_3 = {};
                    _local_3.dataObj = _arg_1.o;
                    _local_3.type = _arg_2;
                    _local_4 = new SFSEvent(SFSEvent.onExtensionResponse, _local_3);
                    sfs.dispatchEvent(_local_4);
                }
                else
                {
                    if (_arg_2 == SmartFoxClient.XTMSG_TYPE_STR)
                    {
                        _local_3 = {};
                        _local_3.dataObj = _arg_1;
                        _local_3.type = _arg_2;
                        _local_4 = new SFSEvent(SFSEvent.onExtensionResponse, _local_3);
                        sfs.dispatchEvent(_local_4);
                    };
                };
            };
        }


    }
}//package it.gotoandplay.smartfoxserver.handlers

