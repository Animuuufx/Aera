package
{
    import fi.joniaromaa.adobeair.discordrpc.DiscordRpc;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class AeraDiscordPresence
    {
        private static const APPLICATION_ID:String = "1546639234113343639";
        private static var rpc:DiscordRpc;
        private static var timer:Timer;
        private static var game:Object;
        private static var startedAt:uint = 0;
        private static var player:String = "";
        private static var room:String = "";

        public static function start(target:Object):void
        {
            game = target;

            if (rpc == null)
            {
                try
                {
                    rpc = new DiscordRpc();
                    trace("[Aera Discord] supported=" + rpc.isSupported);
                    if (rpc.isSupported)
                    {
                        rpc.init(APPLICATION_ID);
                        trace("[Aera Discord] initialized application=" + APPLICATION_ID);
                    }
                }
                catch (e:Error)
                {
                    trace("[Aera Discord] init error=" + e.message);
                }
            }

            if (timer == null)
            {
                timer = new Timer(1000);
                timer.addEventListener(TimerEvent.TIMER, update);
                timer.start();
            }

            update(null);
        }

        public static function stop():void
        {
            if (timer != null)
            {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, update);
                timer = null;
            }

            if (rpc != null && rpc.isSupported)
            {
                try { rpc.updatePresence("", "", 0, 0, "", "", "", "", "", 0, 0, "", ""); } catch (e:Error) {}
            }
        }

        private static function update(event:TimerEvent):void
        {
            if (rpc == null || !rpc.isSupported || game == null)
            {
                return;
            }

            try
            {
                rpc.runCallbacks();

                if (game.world == null || game.world.myAvatar == null)
                {
                    return;
                }

                var data:Object = game.world.myAvatar.objData;
                if (data == null || !("strUsername" in data))
                {
                    return;
                }

                var nextPlayer:String = String(data.strUsername);
                var nextRoom:String = "Aera";

                if ("strMapName" in game.world && game.world.strMapName != null && String(game.world.strMapName).length > 0)
                {
                    nextRoom = String(game.world.strMapName);
                }
                else if ("strAreaName" in game.world && game.world.strAreaName != null && String(game.world.strAreaName).length > 0)
                {
                    nextRoom = String(game.world.strAreaName);
                }

                if (startedAt == 0)
                {
                    startedAt = uint(Math.floor(new Date().time / 1000));
                }

                if (nextPlayer != player || nextRoom != room)
                {
                    player = nextPlayer;
                    room = nextRoom;
                    rpc.updatePresence(
                        "Room: " + room,
                        "Playing as " + player,
                        startedAt,
                        0,
                        "",
                        "",
                        "",
                        "",
                        "",
                        0,
                        0,
                        "",
                        ""
                    );
                    trace("[Aera Discord] presence=" + player + " @ " + room);
                }
            }
            catch (e:Error)
            {
                trace("[Aera Discord] update error=" + e.message);
            }
        }
    }
}
