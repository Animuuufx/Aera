package
{
    import fi.joniaromaa.adobeair.discordrpc.DiscordRpc;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * Aera Rich Presence backed directly by the Adobe AIR Discord RPC ANE.
     * No PowerShell process or localhost bridge is required.
     */
    public class DiscordPresence
    {
        private static const APPLICATION_ID:String = "1546639234113343639";

        private static var rpc:DiscordRpc;
        private static var pollTimer:Timer;
        private static var watchedGame:Object;
        private static var startedAt:uint = 0;
        private static var lastPlayer:String = "";
        private static var lastRoom:String = "";
        private static var active:Boolean = false;

        public static function watchGame(game:Object):void
        {
            watchedGame = game;

            if (rpc == null)
            {
                try
                {
                    rpc = new DiscordRpc();
                    if (rpc.isSupported)
                    {
                        rpc.init(APPLICATION_ID);
                        active = true;
                    }
                }
                catch (e:Error)
                {
                    active = false;
                    rpc = null;
                }
            }

            if (pollTimer == null)
            {
                pollTimer = new Timer(2000);
                pollTimer.addEventListener(TimerEvent.TIMER, onPoll);
                pollTimer.start();
            }

            onPoll(null);
        }

        public static function clear():void
        {
            if (pollTimer != null)
            {
                pollTimer.stop();
                pollTimer.removeEventListener(TimerEvent.TIMER, onPoll);
                pollTimer = null;
            }

            if (rpc != null && active)
            {
                try
                {
                    rpc.updatePresence("", "", 0, 0, "", "", "", "", "", 0, 0, "", "");
                }
                catch (e:Error)
                {
                }
            }

            watchedGame = null;
            startedAt = 0;
            lastPlayer = "";
            lastRoom = "";
        }

        private static function onPoll(event:TimerEvent):void
        {
            if (!active || rpc == null || watchedGame == null) return;

            try
            {
                if (watchedGame.world == null || watchedGame.world.myAvatar == null) return;

                var data:Object = watchedGame.world.myAvatar.objData;
                if (data == null || !("strUsername" in data)) return;

                var player:String = String(data.strUsername);
                if (player.length == 0) return;

                var room:String = "";
                if ("strMapName" in watchedGame.world && watchedGame.world.strMapName != null)
                {
                    room = String(watchedGame.world.strMapName);
                }
                if (room.length == 0 && "strAreaName" in watchedGame.world && watchedGame.world.strAreaName != null)
                {
                    room = String(watchedGame.world.strAreaName);
                }
                if (room.length == 0) room = "Aera";

                if (startedAt == 0)
                {
                    startedAt = uint(Math.floor(new Date().time / 1000));
                }

                if (player != lastPlayer || room != lastRoom)
                {
                    lastPlayer = player;
                    lastRoom = room;
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
                }

                rpc.runCallbacks();
            }
            catch (e:Error)
            {
                // Rich Presence is optional and must never interrupt gameplay.
            }
        }
    }
}
