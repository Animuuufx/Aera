package
{
    import com.adobe.serialization.json.JSON;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.Socket;
    import flash.utils.Timer;

    /**
     * Small localhost bridge used by the Aera AIR launcher to publish the
     * current character and session start time to Discord.
     */
    public class DiscordPresence
    {
        private static var socket:Socket;
        private static var pendingPlayer:String = "";
        private static var startedAt:Number = 0;
        private static var lastSentPlayer:String = "";
        private static var pollTimer:Timer;
        private static var watchedGame:Object;

        public static function watchGame(game:Object):void
        {
            watchedGame = game;
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
            pendingPlayer = "";
            startedAt = 0;
            lastSentPlayer = "";
            if (pollTimer != null)
            {
                pollTimer.stop();
                pollTimer.removeEventListener(TimerEvent.TIMER, onPoll);
                pollTimer = null;
            }
            if (socket != null)
            {
                try
                {
                    if (socket.connected) socket.close();
                }
                catch (e:Error)
                {
                }
                socket = null;
            }
            watchedGame = null;
        }

        private static function onPoll(event:TimerEvent):void
        {
            if (watchedGame == null) return;
            try
            {
                if (watchedGame.world == null || watchedGame.world.myAvatar == null) return;
                var data:Object = watchedGame.world.myAvatar.objData;
                if (data == null || !("strUsername" in data)) return;
                var player:String = String(data.strUsername);
                if (player.length == 0) return;

                if (startedAt <= 0) startedAt = Math.floor(new Date().time / 1000);
                pendingPlayer = player;
                connectAndSend();
            }
            catch (e:Error)
            {
                // Discord is optional; never allow a presence failure to break the game.
            }
        }

        private static function connectAndSend():void
        {
            if (socket == null)
            {
                socket = new Socket();
                socket.addEventListener(Event.CONNECT, onConnect);
                socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketError);
                socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketError);
                try
                {
                    socket.connect("127.0.0.1", 6463);
                }
                catch (e:Error)
                {
                    socket = null;
                }
                return;
            }

            if (socket.connected && pendingPlayer.length > 0 && pendingPlayer != lastSentPlayer)
            {
                sendPresence();
            }
        }

        private static function onConnect(event:Event):void
        {
            sendPresence();
        }

        private static function sendPresence():void
        {
            if (socket == null || !socket.connected || pendingPlayer.length == 0) return;
            var payload:Object = {
                type: "presence",
                player: pendingPlayer,
                start: startedAt
            };
            try
            {
                socket.writeUTFBytes(JSON.encode(payload) + "\n");
                socket.flush();
                lastSentPlayer = pendingPlayer;
            }
            catch (e:Error)
            {
                onSocketError(null);
            }
        }

        private static function onSocketError(event:*) : void
        {
            if (socket != null)
            {
                try
                {
                    socket.close();
                }
                catch (e:Error)
                {
                }
            }
            socket = null;
            lastSentPlayer = "";
        }
    }
}
