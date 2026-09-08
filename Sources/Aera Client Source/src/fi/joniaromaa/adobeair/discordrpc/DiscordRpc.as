package fi.joniaromaa.adobeair.discordrpc
{
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.utils.getDefinitionByName;

    public class DiscordRpc extends EventDispatcher
    {
        private var extension:Object;
        public var initialized:Boolean;

        public function DiscordRpc()
        {
            initExtension();
        }

        public function initExtension():void
        {
            try
            {
                // Resolve ExtensionContext dynamically so the client SWF can compile
                // without requiring the AIR-only ExtensionContext class at compile time.
                var extensionContextClass:Class = getDefinitionByName("flash.external.ExtensionContext") as Class;
                if (extensionContextClass == null)
                {
                    initialized = false;
                    return;
                }

                extension = extensionContextClass.createExtensionContext("fi.joniaromaa.adobeair.discordrpc", null);
                initialized = (extension != null);
            }
            catch (e:Error)
            {
                initialized = false;
                extension = null;
            }
        }

        public function get isSupported():Boolean
        {
            return initialized && extension != null;
        }

        public function init(applicationId:String):void
        {
            if (!isSupported || applicationId == null || applicationId.length == 0) return;

            try
            {
                extension.call("init", applicationId);
                extension.addEventListener(StatusEvent.STATUS, statusEvent, false, 0, true);
            }
            catch (e:Error)
            {
                initialized = false;
            }
        }

        private function statusEvent(event:StatusEvent):void
        {
            // Join/spectate callbacks are intentionally unused by Aera.
        }

        public function updatePresence(state:String, details:String, startTime:uint, endTime:uint, largeImage:String, largeImageDesc:String, smallImage:String, smallImageDesc:String, partyId:String, partySize:int, partyMax:int, joinSecret:String, specSecret:String):void
        {
            if (!isSupported) return;

            try
            {
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
            catch (e:Error)
            {
                // Rich Presence must never interrupt gameplay.
            }
        }

        public function runCallbacks():void
        {
            if (!isSupported) return;

            try
            {
                extension.call("runCallbacks");
            }
            catch (e:Error)
            {
            }
        }

        public function respond(userId:String, reply:int):void
        {
            if (!isSupported || userId == null) return;

            try
            {
                extension.call("respond", userId, reply);
            }
            catch (e:Error)
            {
            }
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
