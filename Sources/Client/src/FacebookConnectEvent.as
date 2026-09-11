// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//FacebookConnectEvent

package 
{
    import flash.events.Event;

    public class FacebookConnectEvent extends Event 
    {

        public static const DEFAULT_NAME:String = "FacebookConnectEvent";
        public static const ONCONNECT:String = "onConnect";

        public var params:Object;

        public function FacebookConnectEvent(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.params = _arg_2;
        }

        override public function clone():Event
        {
            return (new FacebookConnectEvent(type, this.params, bubbles, cancelable));
        }

        override public function toString():String
        {
            return (formatToString("FacebookConnectEvent", "params", "type", "bubbles", "cancelable"));
        }


    }
}//package 

