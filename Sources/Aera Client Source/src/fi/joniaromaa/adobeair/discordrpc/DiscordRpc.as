package fi.joniaromaa.adobeair.discordrpc
{
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;

    public class DiscordRpc extends EventDispatcher
    {
        private var extension:ExtensionContext;
        public var initialized:Boolean;

        public function DiscordRpc()
        {
            initExtension();
        }

        public function initExtension():void
        {
            try
            {
                extension = ExtensionContext.createExtensionContext("fi.joniaromaa.adobeair.discordrpc", null);
                initialized = (extension != null);
            }
            catch (e:Error)
            {
                initialized = false;
            }
        }

        public function get isSupported():Boolean
        {
            return initialized;
        }

        public function init(applicationId:String):void
        {
            if (!isSupported || applicationId == null || applicationId.length == 0) return;
            extension.call("init", applicationId);
            extension.addEventListener(StatusEvent.STATUS, statusEvent, false, 0, true);
        }

        private function statusEvent(event:StatusEvent):void
        {
            // Join/spectate callbacks are intentionally unused by Aera.
        }

        public function updatePresence(state:String, details:String, startTime:uint, endTime:uint, largeImage:String, largeImageDesc:String, smallImage:String, smallImageDesc:String, partyId:String, partySize:int, partyMax:int, joinSecret:String, specSecret:String):void
        {
            if (!isSupported) return;
            extension.call(
                "updatePresence",
                state == null ? "" : state,
                details == null ? "" : details,
                startTime,
                endTime,
                largeImage == null ? "" : largeImage,
                largeImageDesc == null ? "" : largeImageDesc,
                smallImage == null ? "" : smallImage,
                smallImageDesc == null ? "" : smallImageDesc,
                partyId == null ? "" : partyId,
                partySize,
                partyMax,
                joinSecret == null ? "" : joinSecret,
                specSecret == null ? "" : specSecret
            );
        }

        public function runCallbacks():void
        {
            if (!isSupported) return;
            extension.call("runCallbacks");
        }

        public function respond(userId:String, reply:int):void
        {
            if (!isSupported || userId == null) return;
            extension.call("respond", userId, reply);
        }

        public function dispose():void
        {
            if (extension != null)
            {
                try { extension.dispose(); } catch (e:Error) {}
                extension = null;
            }
            initialized = false;
        }
    }
}
