package fi.joniaromaa.adobeair.discordrpc
{
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.utils.getDefinitionByName;

    public class DiscordRpc extends EventDispatcher
    {
        private var extension:Object;
        public var initialized:Boolean = false;

        public function DiscordRpc()
        {
            initExtension();
        }

        private function initExtension():void
        {
            try
            {
                var extensionContextClass:Object = getDefinitionByName("flash.external.ExtensionContext");
                if (extensionContextClass == null)
                {
                    trace("[Aera Discord] ExtensionContext unavailable");
                    return;
                }

                // Invoke the static factory dynamically. This keeps the loader source
                // compatible with Animate's compiler while still using the AIR ANE.
                extension = extensionContextClass["createExtensionContext"](
                    "fi.joniaromaa.adobeair.discordrpc",
                    null
                );
                initialized = (extension != null);
                trace("[Aera Discord] ANE supported=" + initialized);
            }
            catch (e:Error)
            {
                initialized = false;
                extension = null;
                trace("[Aera Discord] ExtensionContext error=" + e.message);
            }
        }

        public function get isSupported():Boolean
        {
            return initialized && extension != null;
        }

        public function init(applicationId:String):void
        {
            if (!isSupported || applicationId == null || applicationId.length == 0)
                return;

            try
            {
                extension.call("init", applicationId);
                extension.addEventListener(StatusEvent.STATUS, onStatus, false, 0, true);
                trace("[Aera Discord] RPC initialized");
            }
            catch (e:Error)
            {
                trace("[Aera Discord] init error=" + e.message);
            }
        }

        private function onStatus(event:StatusEvent):void
        {
            trace("[Aera Discord] status=" + event.code + " level=" + event.level);
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
                trace("[Aera Discord] presence updated");
            }
            catch (e:Error)
            {
                trace("[Aera Discord] updatePresence error=" + e.message);
            }
        }

        public function runCallbacks():void
        {
            if (!isSupported) return;
            try { extension.call("runCallbacks"); } catch (e:Error) {}
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
