// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game

package 
{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.display.Loader;
import flash.net.URLLoaderDataFormat;
import flash.system.ApplicationDomain;
    import it.gotoandplay.smartfoxserver.SmartFoxClient;
    import flash.net.SharedObject;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import liteAssets.draw.bankFilters;
    import liteAssets.draw.packetlogger;
    import liteAssets.draw.cellMenu;
    import liteAssets.draw.customDrops;
    import liteAssets.draw.playerAuras;
    import liteAssets.draw.targetAuras;
    import liteAssets.draw.battleAnalyzer;
    import liteAssets.draw.cameraTool;
    import flash.system.LoaderContext;
    import flash.net.URLLoader;
    import it.gotoandplay.smartfoxserver.SFSEvent;
    import flash.media.SoundMixer;
    import fl.motion.Color;
    import flash.utils.getTimer;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.utils.getDefinitionByName;
    import flash.system.Security;
    import flash.external.ExternalInterface;
    import flash.filters.ColorMatrixFilter;
    import flash.net.URLRequest;
    import flash.events.ProgressEvent;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import liteAssets.draw.worldCamera;
    import liteAssets.handlers.optionHandler;
    import flash.events.TimerEvent;
    import flash.utils.describeType;
    import flash.utils.ByteArray;
    import flash.filters.GlowFilter;
    import flash.net.URLRequestMethod;
    import com.adobe.serialization.json.JSON;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.display.StageDisplayState;
    import flash.events.FocusEvent;
    import flash.net.navigateToURL;
    import flash.net.URLVariables;
    import flash.net.URLRequestHeader;
    import flash.media.SoundTransform;
    import flash.geom.Matrix;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.utils.getQualifiedClassName;
    import liteAssets.draw.statsPanel;
    import flash.text.*;
    import it.gotoandplay.smartfoxserver.*;
    import liteAssets.draw.*;
    import flash.external.*;

    public class Game extends MovieClip 
    {
        private var aeraRiftHUD:liteAssets.draw.riftHUD;
        private var aeraRiftPanel:liteAssets.draw.riftPanel;


        public static var ISWEB:Boolean = true;
        public static var root:Game;
        public static var serverName:String;
        public static var serverPort:int = 5588;
        public static var serverIP:String = "";
        public static var serverGamePath:String = "";
        public static var serverFilePath:String = "";
        public static var serverURL:String = "";
        public static var cLoginZone:String = "zone_master";
        public static var clientToken:String = "SPIDER#0001";
        public static var bPTR:Boolean = false;
        public static var loginInfo:Object = {};
        public static var objLogin:Object;
        public static var mcUpgradeWindow:MovieClip;
        public static var mcACWindow:MovieClip;
        public static var strToken:String;
        public static const ASSETS_LOADED:String = "main_assets_loaded";
        public static var ASSETS_READY:String = "";
        public static const FB_APP_NAME:String = "AQW";
        public static const FB_APP_URL:String = "nightvaults.com";
        public static const FB_APP_ID:String = "51356733862";
        public static const FB_APP_SEC:String = "This should never be stored in the client";

        public var MsgBox:MovieClip;
        public var mcAccount:MovieClip;
        public var ctr_watermark:MovieClip;
        public var mcExtSWF:MovieClip;
        public var ui:MovieClip;
        public var mcLogin:MovieClip;
        public var loader:*;
        public var csLoader:URLLoader;
        public var csbLoaded:Number;
        public var csbTotal:Number;
        public var clientVersion:Number = 3.01;
        public var sToken:String;
        public var world:World;
        public var bagSpace:String = "interface/spiderbagr2.swf";
        public var iMaxBagSlots:* = 400;
        public var iMaxBankSlots:* = 450;
        public var iMaxHouseSlots:* = 250;
        public var iMaxFriends:* = 225;
        public var iMaxLoadoutSlots:* = 20;
        private var swfObj:String = "AQWGame";
        public var showFB:Boolean = false;
        public var fbL:fbLinkWindow;
        public var titleDomain:ApplicationDomain;
        public var mcO:MovieClip;
        public var elmType:String;
        public var handleSessionEvent:Function;
        public var sfc:SmartFoxClient;
        public var chatF:*;
        public var sFilePath:String = "";
        public var userPreference:SharedObject;
        public var litePreference:SharedObject;
        public var objServerInfo:Object;
        public var sfcSocial:Boolean = false;
        public var ldrMC:LoaderMC;
        public var mcConnDetail:ConnDetailMC;
        public var querystring:Object;
        public var ts_login_server:Number;
        public var ts_login_client:Number;
        public var aaaloop:int = 0;
        public var totalPingTime:Number = 0;
        public var pingCount:int = 0;
        public var arrRanks:Array;
        public var iRankMax:int = 10;
        public var arrHP:Array;
        private var aswc:Apop;
        public var hasPreviewed:Boolean;
        public var intLevelCap:int;
        public var PCstBase:int;
        public var PCstRatio:Number;
        public var PCstGoal:int;
        public var GstBase:int;
        public var GstRatio:Number;
        public var GstGoal:int;
        public var PChpBase1:int;
        public var PChpBase100:int;
        public var PChpGoal1:int;
        public var PChpGoal100:int;
        public var PChpDelta:int;
        public var intHPperEND:int;
        public var intAPtoDPS:int;
        public var intSPtoDPS:int;
        public var bigNumberBase:int;
        public var resistRating:Number;
        public var modRating:Number;
        public var baseDodge:Number;
        public var baseBlock:Number;
        public var baseParry:Number;
        public var baseCrit:Number;
        public var baseHit:Number;
        public var baseHaste:Number;
        public var baseMiss:Number;
        public var baseResist:Number;
        public var baseCritValue:Number;
        public var baseBlockValue:Number;
        public var baseResistValue:Number;
        public var baseEventValue:Number;
        public var PCDPSMod:Number = 0.85;
        public var curveExponent:Number = 0.66;
        public var statsExponent:Number = 1.33;
        public var stats:Array;
        public var orderedStats:Array;
        public var ratiosBySlot:Object;
        public var I0pct:Number = 0.8;
        public var I2pct:Number = 1.25;
        public var classCatMap:Object;
        private var coreValues:Object;
        private var travelMapData:Object;
        private var WorldMapData:worldMap;
        private var skipR2:Boolean = false;
        private var apop_:apopCore;
        public var apopTree:Object;
        public var curID:String;
        public var serialCmdMode:Boolean = false;
        public var serialCmd:Object;
        private var conn:*;
        public var confirmTime:int = 0;
        public var quests:Boolean = false;
        public var bits:Array;
        private var fbc:MovieClip;
        public var mcGameMenu:MovieClip;
        public var firstMenu:Boolean = true;
        public var bPassword:Boolean = true;
        public var pDash:Boolean;
        internal var cancelTargetTimer:Timer;
        public var keyDict:Dictionary;

        // Smooth held-key movement / database NPC interaction.
        // W=87, A=65, S=83, D=68, E=69.
        private var movementKeys:Object = {};
        private var npcInteractHeld:Boolean = false;
        private static const DASH_STAMINA_COST:int = 50;
        private var travelLoaderMC:*;
        public var TRAVEL_DATA_READY:Boolean = false;
        private var bLoaded:Number = 0;
        private var bTotal:Number = 0;
        private var weakPass:Array;
        public var extCall:ExternalCalls;
        public var FBConnectCallback:Function;
        public var sBG:String = "generic2.swf";
        public var IsEU:Boolean = false;
        public var TempLoginName:* = "";
        public var TempLoginPass:* = "";
        public var mtcidNow:Number;
        public var intChatMode:int;
        public var serverPath:String;
        public var playerPollData:Object;
        private var characters:SharedObject;
        public var csShowServers:Boolean = false;
        public var mcCharSelect:*;
        internal var interfaceQueue:Array;
        internal var visualLoader:*;
        public var interfaceRef:Object;
        internal var interfaceLoaded:Number = 0;
        internal var interfaceTotal:Number = 0;
        public var newInstance:Boolean = false;
        public var BOOK_DATA_READY:* = null;
        public var bolLoader:Loader;
        public var bolContent:MovieClip;
        public var equipPotionOnSeia:Boolean;
        public var lastPing:Number = 0;
        public var lastPingTime:uint = 0;
        public var lastPingValues:Array;
        public var bankFiltersMC:bankFilters;
        public var pLoggerUI:packetlogger;
        public var cMenuUI:cellMenu;
        public var cDropsUI:customDrops;
        public var pAurasUI:playerAuras;
        public var tAurasUI:targetAuras;
        public var bAnalyzer:battleAnalyzer;
        public var cameraToolMC:cameraTool;
        internal var petDisable:Timer;
        public var portraitsCnt:Array;
        public var pinnedQuests:String;
        internal var disableTimer:Timer;
        public var regExLineSpace:RegExp;
        public var showServers:Boolean = false;
        public var baseClassStats:Object;
        private var statsNewClass:Boolean = false;
        private var mcStatsPanel:MovieClip;

        public var cVersion:String = String(clientVersion);
        public var failedServers:* = {};
        private var rn:RandomNumber = new RandomNumber();
        public var assetsDomain:ApplicationDomain;
        public var assetsContext:LoaderContext;
        public var interfaceDomain:ApplicationDomain;
        public var interfaceContext:LoaderContext;
        public const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
        public var mixer:SoundFX;
        public var params:Object = {};
        public var uoPref:Object = {};
        public var litePref:Array = [];
        public var loginLoader:URLLoader = new URLLoader();
        public var ctrlTrade:MovieClip;
        public var tradeItem1:MovieClip;
        public var tradeItem2:MovieClip;
        public var tradeItem3:MovieClip;
        public var auctionItem1:MovieClip;
        public var auctionItem2:MovieClip;
        public var auctionItem3:MovieClip;
        public var auctionLayout:MovieClip;
        public var auctionPanel:MovieClip;
        public var auctionTabs:MovieClip;

        {
            MovieClip.prototype.removeAllChildren = function ():void
            {
                var _local_1:* = (this.numChildren - 1);
                while (_local_1 >= 0)
                {
                    this.removeChildAt(_local_1);
                    _local_1--;
                }
            };
        }

        public function Game()
        {
            var isNewClass:Boolean;
            var onExtensionResponseHandler:Function;

            assetsDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            assetsContext = new LoaderContext(false, assetsDomain);
            assetsContext.checkPolicyFile = false;
            assetsContext.allowCodeImport = true;

            interfaceDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            interfaceContext = new LoaderContext(false, interfaceDomain);
            interfaceContext.checkPolicyFile = false;
            interfaceContext.allowCodeImport = true;

            mixer = new SoundFX(assetsDomain);
            ldrMC = new LoaderMC(this);
            querystring = {};
            arrRanks = [0];
            arrHP = [];
            stats = ["STR", "END", "DEX", "INT", "WIS", "LCK"];
            orderedStats = ["STR", "INT", "DEX", "WIS", "END", "LCK"];
            ratiosBySlot = {"he":0.25, "ar":0.25, "ba":0.2, "Weapon":0.33 };
            classCatMap = {"M1":{}, "M2":{}, "M3":{}, "M4":{}, "C1":{}, "C2":{}, "C3":{}, "S1":{}};
            coreValues = {
                "PCstRatio":7.47,
                "PChpDelta":1640,
                "PChpBase1":360,
                "baseHit":0,
                "intSPtoDPS":10,
                "resistRating":17,
                "curveExponent":0.66,
                "baseCritValue":1.5,
                "PChpGoal100":4000,
                "intLevelCap":100,
                "baseMiss":0.1,
                "baseParry":0.03,
                "GstBase":12,
                "modRating":3,
                "baseResistValue":0.7,
                "baseBlockValue":0.7,
                "intHPperEND":5,
                "baseHaste":0,
                "baseBlock":0,
                "statsExponent":1,
                "PChpBase100":2000,
                "intAPtoDPS":10,
                "PCstBase":15,
                "baseCrit":0.05,
                "baseEventValue":0.05,
                "GstGoal":572,
                "PChpGoal1":400,
                "GstRatio":5.6,
                "intLevelMax":100,
                "bigNumberBase":8,
                "PCstGoal":762,
                "baseDodge":0.04,
                "PCDPSMod":0.85
            };
            apopTree = {};
            serialCmd = {
                "cmd":"",
                "si":0,
                "servers":[],
                "callBack":serialCmdDone,
                "active":false
            };
            bits = [1, 2, 4, 8, 16, 32, 64, 128, 0x0100, 0x0200, 0x0400, 0x0800, 0x1000, 0x2000, 0x4000, 0x8000, 0x10000, 0x20000, 0x40000, 0x80000, 0x100000, 0x200000, 0x400000, 0x800000, 0x1000000, 0x2000000, 0x4000000, 0x8000000, 0x10000000, 0x20000000, 0x40000000, 0x80000000];
            cancelTargetTimer = new Timer(5000, 1);
            weakPass = ["0", "1111", "11111", "111111", "11111111", "112233", "1212", "121212", "123123", "1234", "12345", "123456", "1234567", "12345678", "1313", "131313", "2000", "2112", "2222", "232323", "3333", "4128", "4321", "4444", "5150", "5555", "654321", "6666", "666666", "6969", "696969", "7777", "777777", "7777777", "8675309", "987654", "aaaa", "aaaaaa", "abc123", "abgrtyu", "access", "access14", "action", "albert", "alex", "alexis", "amanda", "amateur", "andrea", "andrew", "angel", "angela", "angels", "animal", "anthony", "apollo", "apple", "apples", "arsenal", "arthur", "asdf", "asdfgh", "ashley", "asshole", "august", "austin", "baby", "badboy", "bailey", "banana", "barney", "baseball", "batman", "beach", "bear", "beaver", "beavis", "beer", "bigcock", "bigdaddy", "bigdick", "bigdog", "bigtits", "bill", "billy", "birdie", "bitch", "bitches", "biteme", "black", "blazer", "blonde", "blondes", "blowjob", "blowme", "blue", "bond007", "bonnie", "booboo", "boobs", "booger", "boomer", "booty", "boston", "brandon", "brandy", "braves", "brazil", "brian", "bronco", "broncos", "bubba", "buddy", "bulldog", "buster", "butter", "butthead", "calvin", "camaro", "cameron", "canada", "captain", "carlos", "carter", "casper", "charles", "charlie", "cheese", "chelsea", "chester", "chevy", "chicago", "chicken", "chris", "cocacola", "cock", "coffee", "college", "compaq", "computer", "cookie", "cool", "cooper", "corvette", "cowboy", "cowboys", "cream", "crystal", "cumming", "cumshot", "cunt", "dakota", "dallas", "daniel", "danielle", "dave", "david", "debbie", "dennis", "diablo", "diamond", "dick", "dirty", "doctor", "doggie", "dolphin", "dolphins", "donald", "dragon", "dreams", "driver", "eagle", "eagle1", "eagles", "edward", "einstein", "enjoy", "enter", "eric", "erotic", "extreme", "falcon", "fender", "ferrari", "fire", "firebird", "fish", "fishing", "florida", "flower", "flyers", "football", "ford", "forever", "frank", "fred", "freddy", "freedom", "fuck", "fucked", "fucker", "fucking", "fuckme", "fuckyou", "gandalf", "gateway", "gators", "gemini", "george", "giants", "ginger", "girl", "girls", "golden", "golf", "golfer", "gordon", "great", "green", "gregory", "guitar", "gunner", "hammer", "hannah", "happy", "hardcore", "harley", "heather", "hello", "helpme", "hentai", "hockey", "hooters", "horney", "horny", "hotdog", "house", "hunter", "hunting", "iceman", "iloveyou", "internet", "iwantu", "jack", "jackie", "jackson", "jaguar", "jake", "james", "japan", "jasmine", "jason", "jasper", "jennifer", "jeremy", "jessica", "john", "johnny", "johnson", "jordan", "joseph", "joshua", "juice", "junior", "justin", "kelly", "kevin", "killer", "king", "kitty", "knight", "ladies", "lakers", "lauren", "leather", "legend", "letmein", "little", "london", "love", "lover", "lovers", "lucky", "maddog", "madison", "maggie", "magic", "magnum", "marine", "mark", "marlboro", "martin", "marvin", "master", "matrix", "matt", "matthew", "maverick", "maxwell", "melissa", "member", "mercedes", "merlin", "michael", "michelle", "mickey", "midnight", "mike", "miller", "mine", "mistress", "money", "monica", "monkey", "monster", "morgan", "mother", "mountain", "movie", "muffin", "murphy", "music", "mustang", "naked", "nascar", "nathan", "naughty", "ncc1701", "newyork", "nicholas", "nicole", "nipple", "nipples", "oliver", "orange", "ou812", "packers", "panther", "panties", "paris", "parker", "pass", "password", "patrick", "paul", "peaches", "peanut", "penis", "pepper", "peter", "phantom", "phoenix", "player", "please", "pookie", "porn", "porno", "porsche", "power", "prince", "princess", "private", "purple", "pussies", "pussy", "qazwsx", "qwert", "qwerty", "qwertyui", "rabbit", "rachel", "pokemon", "racing", "raiders", "rainbow", "ranger", "rangers", "rebecca", "redskins", "redsox", "redwings", "richard", "robert", "rock", "rocket", "rosebud", "runner", "rush2112", "russia", "samantha", "sammy", "samson", "sandra", "saturn", "scooby", "scooter", "scorpio", "scorpion", "scott", "secret", "sexsex", "sexy", "shadow", "shannon", "shaved", "shit", "sierra", "silver", "skippy", "slayer", "slut", "smith", "smokey", "snoopy", "soccer", "sophie", "spanky", "sparky", "spider", "squirt", "srinivas", "star", "stars", "startrek", "starwars", "steelers", "steve", "steven", "sticky", "stupid", "success", "suckit", "summer", "sunshine", "super", "superman", "surfer", "swimming", "sydney", "taylor", "teens", "tennis", "teresa", "test", "tester", "testing", "theman", "thomas", "thunder", "thx1138", "tiffany", "tiger", "tigers", "tigger", "time", "tits", "tomcat", "topgun", "toyota", "travis", "trouble", "trustno1", "tucker", "turtle", "united", "vagina", "victor", "victoria", "video", "viking", "viper", "voodoo", "voyager", "walter", "warrior", "welcome", "whatever", "white", "william", "willie", "wilson", "winner", "winston", "winter", "wizard", "wolf", "women", "xavier", "xxxx", "xxxxx", "xxxxxx", "xxxxxxxx", "yamaha", "yankee", "yankees", "yellow", "young", "zxcvbn", "zxcvbnm", "zzzzzz", "artix", "aqworlds", "adventure", "mechquest", "dragonfable", "123456789", "1234567890", "987654321", "0123456789", "12345678910", "qwertyuiop", "123123123", "asdfghjkl", "123321", "0987654321", "147258369", "789456123", "159753", "741852963", "minecraft", "147852369", "0123456", "qwerty123", "123654789", "naruto", "9876543210", "12341234", "123qwe", "159357", "123654", "gabriel", "123456789a"];
            characters = SharedObject.getLocal("AQWChars", "/");
            interfaceQueue = [];
            interfaceRef = {};
            lastPingValues = [];
            petDisable = new Timer(0);
            portraitsCnt = [];
            disableTimer = new Timer(50, 1);
            regExLineSpace = /(\r\n)/gi;
            super();
            var onConnectionHandler:Function = function (_arg_1:SFSEvent)
            {
                if (_arg_1.params.success)
                {
                    sfc.login(cLoginZone, ((((clientToken + "~") + loginInfo.strUsername) + "~") + clientVersion), loginInfo.strToken);
                    if (world != null)
                    {
                        world.uiLock = true;
                    }
                }
                else
                {
                    if (serialCmdMode)
                    {
                        serialCmdNext();
                    }
                }
            };
            var isWarned:Function = function ():Boolean
            {
                var curTS:Number;
                var iDiff:Number;
                if (("logoutWarningTS" in userPreference.data))
                {
                    curTS = new Date().getTime();
                    iDiff = ((userPreference.data.logoutWarningTS + (userPreference.data.logoutWarningDur * 1000)) - curTS);
                    if (iDiff > 60000)
                    {
                        userPreference.data.logoutWarningDur = 60;
                        userPreference.data.logoutWarningTS = curTS;
                        try
                        {
                            userPreference.flush();
                        }
                        catch(e:Error)
                        {
                        }
                    }
                    if (iDiff > 1000)
                    {
                        return (true);
                    }
                }
                return (false);
            };
            var onConnectionLostHandler:Function = function (_arg_1:SFSEvent)
            {
                if (aeraRiftPanel != null) aeraRiftPanel.reset();
                var _local_2:Boolean;
                if (!serialCmdMode)
                {
                    if (world != null)
                    {
                        cleanupInterfaces();
                        world.exitCombat();
                        world.setTarget(null);
                        world.killTimers();
                        world.killListeners();
                        world.clearLoaders(true);
                        try
                        {
                            world.removeChild(world.map);
                        }
                        catch(e)
                        {
                        }
                        removeChild(world);
                        world = null;
                        SoundMixer.stopAll();
                        firstMenu = true;
                        if (mcCharSelect)
                        {
                            if (mcCharSelect.parent != null)
                            {
                                MovieClip(mcCharSelect.parent).removeChild(mcCharSelect);
                            }
                            mcCharSelect = null;
                        }
                    }
                    if (sfc.isConnected)
                    {
                        sfc.disconnect();
                    }
                    if (_arg_1.params != null)
                    {
                        if (_arg_1.params.disconnect == true)
                        {
                            mcConnDetail.showDisconnect("Communication with server has been lost. Please check your internet connection and try again.");
                            _local_2 = true;
                        }
                    }
                    if (!_local_2)
                    {
                        if (showServers)
                        {
                            gotoAndPlay("Login");
                        }
                        else
                        {
                            gotoAndPlay(((((charCount() > 0) && (litePreference.data.bCharSelect)) && (!(isWarned()))) ? "Select" : "Login"));
                        }
                    }
                }
                newInstance = true;
            };
            var onLoginHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onLogoutHandler:Function = function (_arg_1:SFSEvent)
            {
                if (aeraRiftPanel != null) aeraRiftPanel.reset();
                if (!serialCmdMode)
                {
                    if (world != null)
                    {
                        cleanupInterfaces();
                        world.exitCombat();
                        world.setTarget(null);
                        world.killTimers();
                        world.killListeners();
                        world.clearLoaders(true);
                        try
                        {
                            world.removeChild(world.map);
                        }
                        catch(e)
                        {
                        }
                        removeChild(world);
                        world = null;
                        SoundMixer.stopAll();
                        firstMenu = true;
                        if (mcCharSelect)
                        {
                            if (mcCharSelect.parent != null)
                            {
                                MovieClip(mcCharSelect.parent).removeChild(mcCharSelect);
                            }
                            mcCharSelect = null;
                        }
                    }
                    if (sfc.isConnected)
                    {
                        sfc.disconnect();
                    }
                    if (FacebookConnect.isLoggedIn)
                    {
                        FacebookConnect.Logout();
                    }
                    if (showServers)
                    {
                        gotoAndPlay("Login");
                    }
                    else
                    {
                        gotoAndPlay(((((charCount() > 0) && (litePreference.data.bCharSelect)) && (!(isWarned()))) ? "Select" : "Login"));
                    }
                }
                else
                {
                    if (sfc.isConnected)
                    {
                        sfc.disconnect();
                    }
                    serialCmdNext();
                }
                newInstance = true;
            };
            var onMultiConnectionHandler:Function = function (_arg_1:SFSEvent)
            {
                if (_arg_1.params.success)
                {
                    this.sfc.login(cLoginZone, ((clientToken + "~")), loginInfo.strToken);
                }
            };
            var onMultiConnectionLostHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onMultiLogoutHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onMultiLoginHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onJoinRoomHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onUserEnterRoomHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onUserLeaveRoomHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onUserVariablesUpdateHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onRoomListUpdateHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onRoomVariablesUpdateHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onRoomAddedHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onPublicMessageHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onPrivateMessageHandler:Function = function (_arg_1:SFSEvent)
            {
            };
            var onModeratorMessage:Function = function (_arg_1:SFSEvent)
            {
                var _local_2:* = _arg_1.params.message;
                var _local_3:* = _arg_1.params.sender;
            };
            var onObjectReceivedHandler:Function = function (_arg_1:SFSEvent)
            {
                var _local_2:*;
                var _local_3:*;
                var _local_4:MovieClip;
                var _local_5:*;
                var _local_6:*;
                if (sfcSocial)
                {
                    _local_2 = _arg_1.params.sender;
                    _local_3 = _arg_1.params.obj;
                    switch (_local_3.typ)
                    {
                        case "flourish":
                            if (world.CHARS.getChildByName(_local_3.oName) != null)
                            {
                                MovieClip(world.CHARS.getChildByName(_local_3.oName)).userName = _local_2.getName();
                                MovieClip(world.CHARS.getChildByName(_local_3.oName)).gotoAndPlay(_local_3.oFrame);
                            }
                            return;
                        case "danceRequest":
                            if (_local_3.cell == world.strFrame)
                            {
                                _local_5 = new ModalMC();
                                _local_6 = {};
                                _local_6.strBody = "Would you care to dance?";
                                _local_6.params = {};
                                _local_6.params.emote1 = "/dance";
                                _local_6.params.sender = _local_2;
                                _local_6.callback = world.danceRequest;
                                ui.ModalStack.addChild(_local_5);
                                _local_5.init(_local_6);
                            }
                            return;
                        case "danceDenied":
                            if (_local_3.cell == world.strFrame)
                            {
                                chatF.submitMsg("/cry", "emotea", sfc.myUserName);
                            }
                            return;
                    }
                }
            };
            var onRoundTripResponseHandler:Function = function (_arg_1:SFSEvent):void
            {
                var _local_2:int = _arg_1.params.elapsed;
                if (mcO)
                {
                    mcO.averageLatency((_local_2 / 2));
                }
            };
            onExtensionResponseHandler = function (e:SFSEvent)
            {
                var resObj:* = undefined;
                var protocol:* = undefined;
                var i:int;
                var s:String;
                var j:int;
                var o:Object;
                var a:Array;
                var b:Array;
                var mc:MovieClip;
                var tuo:* = undefined;
                var typ:String;
                var nam:String;
                var val:* = undefined;
                var msg:String;
                var msgT:String;
                var snd:String;
                var rcp:String;
                var org:* = undefined;
                var cmd:String;
                var anims:Array;
                var animIndex:uint;
                var monAvt:Avatar;
                var avtAvt:Avatar;
                var Mon:Avatar;
                var avt:Avatar;
                var pMC:MovieClip;
                var unm:String;
                var uid:int;
                var rmId:int;
                var MonMapID:int;
                var MonID:int;
                var prop:String;
                var uoName:* = undefined;
                var uoLeaf:Object;
                var monLeaf:Object;
                var cLeaf:Object;
                var tLeaf:Object;
                var actObj:Object;
                var cell:String;
                var st:int;
                var sta:String;
                var evt:String;
                var modal:MovieClip;
                var modalO:Object;
                var modalRR:* = undefined;
                var modalORR:Object;
                var silentMute:int;
                var filter:int;
                var updateID:String;
                var updateA:Array;
                var updateN:String;
                var updateO:Object;
                var iSel:Object;
                var eSel:Object;
                var now:Number;
                var res:* = undefined;
                var newmon:Object;
                var cluster:* = undefined;
                var strMsg:* = undefined;
                var strLabel:* = undefined;
                var str:* = undefined;
                var slots:int;
                var dest:* = undefined;
                var dt:* = undefined;
                var motd:* = undefined;
                var vars:Array;
                var MonMapIDs:* = undefined;
                var id:* = undefined;
                var strMonName:String;
                var rand:int;
                var clMon:* = undefined;
                var tAvt:Avatar;
                var cAvt:Avatar;
                var strF:String;
                var intf:* = undefined;
                var mcQFrame:* = undefined;
                var ulo:* = undefined;
                var myLeaf:* = undefined;
                var adShown:Boolean;
                var testDate:Date;
                var dropItem:* = undefined;
                var anim:Object;
                var updateCtr:int;
                var ai:int;
                var slot:int;
                var supressMupltiples:* = undefined;
                var isYou:* = undefined;
                var sMsg:* = undefined;
                var arrWearableSpots:* = undefined;
                var spot:String;
                var costumeItem:* = undefined;
                var bi:int;
                var branchA:Object;
                var mID:String;
                var psES:* = undefined;
                var deltaXP:int;
                var xp:* = undefined;
                var xpB:* = undefined;
                var deltaGold:int;
                var gold:* = undefined;
                var deltaCoins:int;
                var coins:* = undefined;
                var deltaCP:int;
                var iRank:* = undefined;
                var txtBonusCP:String;
                var flo:* = undefined;
                var friend:* = undefined;
                var fct:Function;
                var item:* = undefined;
                var sMeta:String;
                var dID:* = undefined;
                var dItem:* = undefined;
                var iData:* = undefined;
                var isOK:Boolean;
                var bItem:* = undefined;
                var dropitem:* = undefined;
                var ItemID:* = undefined;
                var itemObj:* = undefined;
                var fi:* = undefined;
                var iobj:* = undefined;
                var itemArr:* = undefined;
                var dropindex:* = undefined;
                var dropID:* = undefined;
                var dropQty:int;
                var qi:String;
                var qr:String;
                var qj:String;
                var qk:String;
                var qat:Array;
                var ri:* = undefined;
                var fgWin:* = undefined;
                var m:* = undefined;
                var k:* = undefined;
                var bpObj:* = undefined;
                var oldActions:* = undefined;
                var blanki:* = undefined;
                var actBar:* = undefined;
                var delIcon:* = undefined;
                var pseudoAI:int;
                var actIconClass:Class;
                var actIcon:* = undefined;
                var actIconMC:* = undefined;
                var blankMC:* = undefined;
                var isNotUnlocked:Boolean;
                var existing:* = undefined;
                var c:Color;
                var stuS:String;
                var hasteCoeff:Number;
                var cd:* = undefined;
                var stu:String;
                var mcPath:* = undefined;
                resObj = ((e != null && e.params != null) ? e.params.dataObj : null);
                protocol = ((e != null && e.params != null) ? e.params.type : null);
                if (((protocol == null) || (resObj == null)))
                {
                    return;
                }
                i = 0;
                s = "";
                j = 0;
                prop = "";
                var updated:Object = {};
                silentMute = 0;
                filter = 0;
                var cInf:String = "";
                var tInf:String = "";
                var cTyp:String = "";
                var cID:int = -1;
                var tTyp:String = "";
                var tID:int = -1;
                var ul:Array = [];
                var dat:Date = new Date();
                now = dat.getTime();
                if (protocol == "str")
                {
                    cmd = resObj[0];
                    switch (cmd)
                    {
                        default:
                            break;
                        case "dungeonCompleted":
                            if (("eventTrigger" in MovieClip(world.map)))
                            {
                                world.map.eventTrigger({"cmd":"DungeonComplete"});
                            }
                            break;
                        case "dungeonMTC":
                            res = (resObj[2] == "true");
                            if (res)
                            {
                                dest = String(resObj[3]).split(",");
                                world.moveToCell(dest[0], dest[1], true);
                            }
                            break;
                        case "hi":
                            if (mcO)
                            {
                                mcO.latency = (mcO.latency - new Date().getTime());
                                mcO.latency = Math.ceil((Math.abs(mcO.latency) / 2));
                                mcO.updateLatency();
                            }
                            break;
                        case "loginResponse":
                            showTracking("5");
                            if (resObj[2] == 1 || resObj[2] == "true" || resObj[2] == "True")
                            {
                                ctr_watermark.visible = (objServerInfo.sName == "Class Test Realm");
                                mcConnDetail.showConn("Loading Character Data...");
                                sfc.myUserId = Number(resObj[3]);
                                sfc.myUserName = String(resObj[4]);
                                ts_login_client = now;
                                dt = stringToDate(resObj[6]);
                                ts_login_server = dt.getTime();
                                motd = "Message of The Day: Staff will never ask for your password! If someone asks for your password, report them for Griefing. NEVER share your password!";
                                chatF.pushMsg("moderator", motd, "SERVER", "", 0);
                                chatF.pushMsg("server", ("The server time is now " + dt.toString()), "SERVER", "", 0);
                                vars = (((resObj.length > 7) && (resObj[7] != null)) ? String(resObj[7]).split(",") : []);
                                retrieveInfo(vars);
                                confirmTime = getTimer();
                            }
                            else
                            {
                                mcConnDetail.showError(resObj[5]);
                            }
                            break;
                        case "loginIterator":
                            if (((resObj[2] == 1) || (resObj[2] == "true")))
                            {
                                sfc.myUserId = Number(resObj[3]);
                                sfc.myUserName = String(resObj[4]);
                                chatF.submitMsg(serialCmd.cmd, "serialCmd", ((serialCmdMode) ? "iterator" : sfc.myUserName));
                            }
                            else
                            {
                                mcConnDetail.showError("Login Failed!");
                            }
                            break;
                        case "iterator":
                            sfc.logout();
                            break;
                        case "loginMulti":
                            if (!((resObj[2] == 1) || (resObj[2] == "true")))
                            {
                                mcConnDetail.showError("Login Failed!");
                            }
                            break;
                        case "notify":
                            typ = "server";
                            msg = resObj[2];
                            msg = chatF.cleanChars(msg);
                            msg = chatF.cleanStr(msg);
                            chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            MsgBox.notify(msg);
                            break;
                        case "logoutWarning":
                            userPreference.data.logoutWarning = String(resObj[2]);
                            userPreference.data.logoutWarningDur = Number(resObj[3]);
                            userPreference.data.logoutWarningTS = now;
                            try
                            {
                                userPreference.flush();
                            }
                            catch(e:Error)
                            {
                            }
                            break;
                        case "multiLoginWarning":
                            mcConnDetail.showError("Your AQWorlds game account has been logged on from another window session or computer, or you made changes in Manage Account.");
                            break;
                        case "server":
                            if (serialCmdMode)
                            {
                                msg = resObj[2];
                                mcLogin.il.cmd.msgBox.text = (mcLogin.il.cmd.msgBox.text + (((("[" + serialCmd.servers[(serialCmd.si - 1)].sName) + "]: ") + msg) + "\n"));
                                mcLogin.il.cmd.msgBox.scrollV = mcLogin.il.cmd.msgBox.maxScrollV;
                                break;
                            }
                            typ = "server";
                            msg = resObj[2];
                            msg = chatF.cleanChars(msg);
                            msg = chatF.cleanStr(msg);
                            chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            break;
                        case "serverf":
                            msg = String(resObj[2]);
                            typ = "server";
                            str = chatF.cleanStr(msg);
                            unm = String(resObj[3]);
                            uid = int(resObj[4]);
                            rmId = int(resObj[5]);
                            msg = chatF.cleanChars(msg);
                            msgT = stripWhite(msg.toLowerCase());
                            if (chatF.strContains(msgT, chatF.illegalStrings))
                            {
                                silentMute = 1;
                            }
                            msgT = stripWhiteStrict(msg.toLowerCase());
                            if (chatF.strContains(msgT, ["email", "password"]))
                            {
                                silentMute = 1;
                            }
                            if (!silentMute)
                            {
                                chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            }
                            break;
                        case "popup":
                            switch (resObj[2])
                            {
                                case "support":
                                case "moderator":
                                case "admin":
                                case "administrator":
                                case "gm":
                                case "developer":
                                case "owner":
                                case "warning":
                                case "server":
                                    typ = resObj[2];
                                    msg = resObj[3];
                                    msg = chatF.cleanChars(msg);
                                    msg = chatF.cleanStr(msg);
                                    chatF.pushMsg(typ, msg, "SERVER", "", 0);
                                    break;
                                case "blackbanner":
                                    MsgBox.notify(resObj[3]);
                                    break;
                                case "update":
                                    addUpdate(resObj[3]);
                                    break;
                                case "messagebox":
                                    showMessageBox(resObj[3]);
                                    break;
                            }
                            break;
                        case "moderator":
                            typ = "moderator";
                            msg = resObj[2];
                            msg = chatF.cleanChars(msg);
                            msg = chatF.cleanStr(msg);
                            chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            break;
                        case "wheel":
                            if (sfcSocial)
                            {
                                typ = "wheel";
                                msg = resObj[2];
                                msg = chatF.cleanChars(msg);
                                msg = chatF.cleanStr(msg);
                                chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            }
                            break;
                        case "gsupdate":
                            try
                            {
                                world.map.killCount(resObj[2]);
                            }
                            catch(e)
                            {
                            }
                            break;
                        case "frostupdate":
                            try
                            {
                                world.map.frostWar(resObj[2], resObj[3]);
                            }
                            catch(e)
                            {
                            }
                            break;
                        case "warning":
                            typ = "warning";
                            msg = resObj[2];
                            msg = chatF.cleanChars(msg);
                            msg = chatF.cleanStr(msg);
                            chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            break;
                        case "respawnMon":
                            if (((world.strMapName == "caroling") && (world.CarolingMonsterKillCount >= 5))) break;
                            if (sfcSocial)
                            {
                                MonMapIDs = resObj[2].split(",");
                                for (id in MonMapIDs)
                                {
                                    Mon = world.getMonster(MonMapIDs[id]);
                                    monLeaf = world.monTree[MonMapIDs[id]];
                                    if ((((!(monLeaf == null)) && (!(Mon == null)) && (!(Mon.objData == null))) && (Mon.objData.strFrame == world.strFrame)))
                                    {
                                        monLeaf.targets = {};
                                        strMonName = "";
                                        if (Number(world.objExtra["bMonName"]) == 1)
                                        {
                                            rand = int(Math.round((Math.random() * (world.chaosNames.length - 1))));
                                            if (world.chaosNames[rand] == world.myAvatar.objData.strUsername)
                                            {
                                                rand = ((rand == 0) ? ((rand = (rand + 1)), rand) : ((rand = (rand - 1)), rand));
                                            }
                                            strMonName = world.chaosNames[rand];
                                        }
                                        Mon.pMC.respawn(strMonName);
                                        Mon.pMC.x = Mon.pMC.ox;
                                        Mon.pMC.y = Mon.pMC.oy;
                                        if (((Mon.objData.bRed == 1) && (world.myAvatar.dataLeaf.intState > 0)))
                                        {
                                            world.aggroMon(MonMapIDs[id]);
                                        }
                                    }
                                }
                            }
                            break;
                        case "resTimed":
                            if ((((resObj.length > 2) && (!(String(resObj[2]) == null))) && (!(String(resObj[3]) == null))))
                            {
                                world.moveToCell(String(resObj[2]), String(resObj[3]));
                            }
                            else
                            {
                                world.moveToCell(world.spawnPoint.strFrame, world.spawnPoint.strPad);
                            }
                            world.map.transform.colorTransform = world.defaultCT;
                            world.CHARS.transform.colorTransform = world.defaultCT;
                            break;
                        case "exitArea":
                            uid = int(resObj[2]);
                            unm = String(resObj[3]);
                            world.manageAreaUser(String(resObj[3]), "-");
                            avt = world.avatars[uid];
                            if (avt != null)
                            {
                                if (avt == world.myAvatar.target)
                                {
                                    world.setTarget(null);
                                }
                                if (((!(avt.objData == null)) && (world.isPartyMember(avt.objData.strUsername))))
                                {
                                    world.updatePartyFrame({
                                        "unm":avt.objData.strUsername,
                                        "range":false
                                    });
                                }
                                world.destroyAvatar(uid);
                                delete world.uoTree[unm];
                                if (ui.mcInterface.areaList.currentLabel == "hold")
                                {
                                    areaListGet();
                                }
                            }
                            break;
                        case "uotls":
                            o = {};
                            a = resObj[3].split(",");
                            i = 0;
                            while (i < a.length)
                            {
                                o[a[i].split(":")[0]] = a[i].split(":")[1];
                                i = (i + 1);
                            }
                            userTreeWrite(String(resObj[2]), o);
                            if (ui.mcInterface.areaList.currentLabel == "hold")
                            {
                                areaListGet();
                            }
                            break;
                        case "mtls":
                            o = {};
                            a = resObj[3].split(",");
                            i = 0;
                            while (i < a.length)
                            {
                                o[a[i].split(":")[0]] = a[i].split(":")[1];
                                i = (i + 1);
                            }
                            monsterTreeWrite(int(resObj[2]), o);
                            break;
                        case "spcs":
                            MonMapID = int(resObj[2]);
                            MonID = int(resObj[3]);
                            monLeaf = world.monTree[MonMapID];
                            if (monLeaf == null)
                            {
                                break;
                            }
                            newmon = {};
                            i = 0;
                            while (i < world.mondef.length)
                            {
                                if (world.mondef[i].MonID == MonID)
                                {
                                    newmon = world.mondef[i];
                                    i = world.mondef.length;
                                }
                                i = (i + 1);
                            }
                            if ((newmon == null) || (newmon.MonID == null))
                            {
                                break;
                            }
                            monLeaf.intHP = 0;
                            monLeaf.intMP = 0;
                            monLeaf.intHPMax = newmon.intHPMax;
                            monLeaf.intMPMax = newmon.intMPMax;
                            monLeaf.intState = 0;
                            monLeaf.iLvl = newmon.iLvl;
                            monLeaf.MonID = MonID;
                            cluster = world.getMonsterCluster(MonMapID);
                            i = 0;
                            while (i < cluster.length)
                            {
                                clMon = cluster[i];
                                if (monLeaf.MonID == clMon.objData.MonID)
                                {
                                    if (monLeaf.strFrame == world.strFrame)
                                    {
                                        world.CHARS.addChild(clMon.pMC);
                                    }
                                    clMon.dataLeaf = monLeaf;
                                }
                                else
                                {
                                    if (monLeaf.strFrame == world.strFrame)
                                    {
                                        world.TRASH.addChild(clMon.pMC);
                                    }
                                    clMon.dataLeaf = null;
                                }
                                i = (i + 1);
                            }
                            break;
                        case "cc":
                            strMsg = chatF.getCCText(resObj[2]);
                            unm = String(resObj[3]);
                            if (chatF.ignoreList.data.users != undefined)
                            {
                                if (chatF.ignoreList.data.users.indexOf(unm) > -1)
                                {
                                    filter = 1;
                                }
                            }
                            if (filter == 0)
                            {
                                chatF.pushMsg("zone", strMsg, unm, "", 0);
                            }
                            break;
                        case "emotea":
                            strLabel = String(resObj[2]);
                            uid = int(resObj[3]);
                            pMC = world.getMCByUserID(uid);
                            if (pMC != null)
                            {
                                pMC.mcChar.gotoAndPlay(strToProperCase(strLabel));
                            }
                            break;
                        case "em":
                            unm = String(resObj[2]);
                            msg = chatF.cleanStr(String(resObj[3]));
                            while (msg.indexOf("  ") > -1)
                            {
                                msg = msg.split("  ").join(" ");
                            }
                            msg = chatF.cleanChars(msg);
                            msgT = stripWhiteStrict(msg.toLowerCase());
                            if (chatF.strContains(msgT, chatF.illegalStrings))
                            {
                                silentMute = 1;
                            }
                            if (!silentMute)
                            {
                                chatF.pushMsg("event", msg, unm, "", 0);
                            }
                            break;
                        case "chatm":
                            if (((resObj.length < 4) || (resObj[2] == null) || (resObj[3] == null)))
                            {
                                break;
                            }
                            str = String(resObj[2]);
                            if (str.indexOf("~") < 1)
                            {
                                break;
                            }
                            str = chatF.cleanStr(str, true, false, Boolean(int(resObj[6])));
                            unm = String(resObj[3]);
                            uid = int(resObj[4]);
                            rmId = int(resObj[5]);
                            typ = str.substr(0, str.indexOf("~"));
                            msg = str.substr((str.indexOf("~") + 1));
                            msg = chatF.cleanChars(msg);
                            if (chatF.ignoreList.data.users != undefined)
                            {
                                if (chatF.ignoreList.data.users.indexOf(unm.toLowerCase()) > -1)
                                {
                                    filter = 1;
                                }
                            }
                            if (!filter)
                            {
                                chatF.pushMsg(typ, msg, ((unm.toLowerCase() == unm) ? (unm.charAt(0).toUpperCase() + unm.slice(1)) : unm), uid, 0, int(resObj[6]));
                            }
                            break;
                        case "whisper":
                            if (((resObj.length < 5) || (resObj[2] == null) || (resObj[3] == null) || (resObj[4] == null)))
                            {
                                break;
                            }
                            typ = "whisper";
                            msg = resObj[2];
                            snd = String(resObj[3]);
                            rcp = String(resObj[4]);
                            org = resObj[5];
                            msg = chatF.cleanStr(msg);
                            msg = chatF.cleanChars(msg);
                            silentMute = 0;
                            if (msg.indexOf(":=sm") > -1)
                            {
                                msg = msg.substr(0, msg.indexOf(":=sm"));
                                if (snd.toLowerCase() != String(sfc.myUserName).toLowerCase())
                                {
                                    silentMute = 1;
                                }
                            }
                            if (chatF.ignoreList.data.users != undefined)
                            {
                                if (chatF.ignoreList.data.users.indexOf(snd.toLowerCase()) > -1)
                                {
                                    filter = 1;
                                }
                            }
                            if (((!(filter)) && ((!(silentMute)) || ((silentMute) && (snd == rcp)))))
                            {
                                if (snd.toLowerCase() != sfc.myUserName.toLowerCase())
                                {
                                    chatF.pmSourceA = [snd];
                                    if (chatF.pmSourceA.length > 20)
                                    {
                                        chatF.pmSourceA.splice(0, (chatF.pmSourceA.length - 20));
                                    }
                                }
                                if (org == 1)
                                {
                                    chatF.pushMsg(typ, msg, snd, rcp, 0);
                                    chatF.pushMsg(typ, msg, snd, rcp, 1);
                                }
                                else
                                {
                                    chatF.pushMsg(typ, msg, snd, rcp, org, int(resObj[6]));
                                }
                            }
                            break;
                        case "mute":
                            chatF.muteMe(int(resObj[2]));
                            break;
                        case "unmute":
                            chatF.unmuteMe();
                            break;
                        case "mvna":
                            if (((world.uoTree[sfc.myUserName].freeze == null) || (!(world.uoTree[sfc.myUserName].freeze))))
                            {
                                world.uoTree[sfc.myUserName].freeze = true;
                            }
                            break;
                        case "mvnb":
                            if (world.uoTree[sfc.myUserName].freeze != null)
                            {
                                delete world.uoTree[sfc.myUserName].freeze;
                            }
                            break;
                        case "gtc":
                            if (((!(String(resObj[2]) == null)) && (!(String(resObj[3]) == null))))
                            {
                                world.moveToCell(String(resObj[2]), String(resObj[3]));
                            }
                            break;
                        case "mtcid":
                            if (resObj.length > 2)
                            {
                                world.moveToCellByIDb(Number(resObj[2]));
                            }
                            if (resObj[3] != null)
                            {
                                mtcidNow = Number(resObj[3]);
                            }
                            break;
                        case "hi":
                            world.connMsgOut = false;
                            world.connTestTimer.reset();
                            world.unlockActions();
                            break;
                        case "Dragon Buff":
                            world.map.doDragonBuff();
                            break;
                        case "trap door":
                            world.map.doTrapDoor(resObj[2]);
                            break;
                        case "gMOTD":
                            world.myAvatar.objData.guild.MOTD = resObj[2];
                            break;
                        case "buyGSlots":
                            slots = int(resObj[2]);
                            if (!isNaN(slots))
                            {
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - (slots * 200));
                            }
                            if (world.myAvatar.objData != null)
                            {
                                world.myAvatar.updateGuildInfo();
                            }
                            break;
                        case "gRename":
                            world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - 1000);
                            break;
                        case "fbRes":
                            if (resObj[4] != null)
                            {
                                typ = "warning";
                                msg = resObj[4];
                                msg = chatF.cleanChars(msg);
                                msg = chatF.cleanStr(msg);
                                chatF.pushMsg(typ, msg, "SERVER", "", 0);
                            }
                            break;
                        case "elmSwitch":
                            try
                            {
                                world.map.setupElement(String(resObj[2]));
                            }
                            catch(e)
                            {
                            }
                    }
                }
                if (protocol == "json")
                {
                    cmd = resObj.cmd;
                    strF = "";
                    switch (cmd)
                    {
                        default:
                            break;
                        case "friendshipStats":
                            intf = getInterface("friendship_ui");
                            if (intf != null)
                            {
                                intf = intf.getChildAt(0);
                                intf.InitInterface(resObj);
                            }
                            break;
                        case "friendshipInfo":
                            intf = getInterface("friendship_engine");
                            if (intf != null)
                            {
                                intf = intf.getChildAt(0);
                                intf.FinalizeConvo(resObj);
                            }
                            break;
                        case "friendshipGift":
                            intf = getInterface("friendship_engine");
                            if (intf != null)
                            {
                                intf = intf.getChildAt(0);
                                intf.FinalizeGift(resObj);
                            }
                            break;
                        case "friendshipTalk":
                            intf = getInterface("friendship_engine");
                            if (intf != null)
                            {
                                intf = intf.getChildAt(0);
                                intf.FinalizeTalk(resObj);
                            }
                            break;
                        case "friendshipChoice":
                            intf = getInterface("friendship_engine");
                            if (intf != null)
                            {
                                intf = intf.getChildAt(0);
                                intf.FinalizeChoice(resObj);
                            }
                            break;
                        case "addLoadout":
                            if (!resObj.success)
                            {
                                MsgBox.notify(resObj.msg);
                            }
                            else
                            {
                                intf = getInterface("outfitSets");
                                if (intf != null)
                                {
                                    intf = intf.getChildAt(0);
                                    intf.onServerResponseUpdate();
                                }
                            }
                            break;
                        case "removeLoadout":
                            if (!resObj.success)
                            {
                                MsgBox.notify(resObj.msg);
                            }
                            else
                            {
                                intf = getInterface("outfitSets");
                                if (intf != null)
                                {
                                    intf = intf.getChildAt(0);
                                    intf.onServerResponseRemove(resObj.setName);
                                }
                            }
                            break;
                        case "wearItem":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (avt != null)
                            {
                                if (((!(avt.pMC == null)) && (!(avt.objData == null))))
                                {
                                    if (!avt.objData.eqp[resObj.sES])
                                    {
                                        avt.objData.eqp[resObj.sES] = {};
                                    }
                                    avt.objData.eqp[resObj.sES].sFile = ((resObj.sFile == "undefined") ? "" : resObj.sFile);
                                    avt.objData.eqp[resObj.sES].sLink = resObj.sLink;
                                    avt.objData.eqp[resObj.sES].sType = (((resObj.ItemID == 156) || (resObj.ItemID == 12583)) ? "Unarmed" : resObj.sType);
                                    avt.loadMovieAtES(resObj.sES, avt.objData.eqp[resObj.sES].sFile, avt.objData.eqp[resObj.sES].sLink);
                                }
                                if (avt.isMyAvatar)
                                {
                                    if (!resObj.success)
                                    {
                                        MsgBox.notify(resObj.msg);
                                    }
                                    avt.wearItem(resObj.ItemID);
                                    if (MovieClip(ui.mcPopup.getChildByName("mcInventory")) != null)
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                    }
                                }
                            }
                            break;
                        case "unwearItem":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (avt != null)
                            {
                                if (((!(avt.pMC == null)) && (!(avt.objData == null))))
                                {
                                    if (avt.isMyAvatar)
                                    {
                                        avt.unwearItem(resObj.ItemID);
                                    }
                                    if (resObj.hasOwnProperty("bRemove"))
                                    {
                                        delete avt.objData.eqp[resObj.sES];
                                        avt.unloadMovieAtES(resObj.sES);
                                    }
                                    else
                                    {
                                        avt.objData.eqp[resObj.sES].sFile = ((resObj.sFile == "undefined") ? "" : resObj.sFile);
                                        avt.objData.eqp[resObj.sES].sLink = resObj.sLink;
                                        avt.objData.eqp[resObj.sES].sType = resObj.sType;
                                        avt.loadMovieAtES(resObj.sES, avt.objData.eqp[resObj.sES].sFile, avt.objData.eqp[resObj.sES].sLink);
                                    }
                                }
                                if (avt.isMyAvatar)
                                {
                                    if (!resObj.success)
                                    {
                                        MsgBox.notify(resObj.msg);
                                    }
                                    if (MovieClip(ui.mcPopup.getChildByName("mcInventory")) != null)
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                    }
                                }
                            }
                            break;
                        case "wearLoadout":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (avt != null)
                            {
                                if (((!(avt.pMC == null)) && (!(avt.objData == null))))
                                {
                                    arrWearableSpots = ["Weapon", "he", "ba", "co"];
                                    for each (spot in arrWearableSpots)
                                    {
                                        if (avt.isMyAvatar)
                                        {
                                            avt.unwearItemAtES(spot);
                                        }
                                        costumeItem = resObj.costume[spot];
                                        if (costumeItem)
                                        {
                                            if (!avt.objData.eqp[spot])
                                            {
                                                avt.objData.eqp[spot] = {};
                                            }
                                            avt.objData.eqp[spot].sFile = ((costumeItem.sFile == "undefined") ? "" : costumeItem.sFile);
                                            avt.objData.eqp[spot].sLink = costumeItem.sLink;
                                            avt.objData.eqp[spot].sType = costumeItem.sType;
                                            avt.loadMovieAtES(spot, avt.objData.eqp[spot].sFile, avt.objData.eqp[spot].sLink);
                                            if (avt.isMyAvatar)
                                            {
                                                avt.wearItem(costumeItem.ItemID);
                                            }
                                        }
                                    }
                                }
                                if (avt.isMyAvatar)
                                {
                                    if (!resObj.success)
                                    {
                                        MsgBox.notify(resObj.msg);
                                    }
                                }
                            }
                            break;
                        case "savePrefs":
                            if (resObj.msg != "")
                            {
                                MsgBox.notify(resObj.msg);
                            }
                            switch (resObj.section)
                            {
                                case "boosts":
                                    break;
                                case "loadouts":
                                    break;
                                case "prefs":
                                    break;
                            }
                            break;
                        case "loadPrefs":
                            if (resObj.success)
                            {
                                world.objInfo["customs"] = resObj.result;
                            }
                            break;
                        case "acceptQuest":
                            mcQFrame = getInstanceFromModalStack("QFrameMC");
                            if (!resObj.bSuccess)
                            {
                                MsgBox.notify(resObj.msg);
                                world.abandonQuest(resObj.QuestID);
                                mcQFrame = getInstanceFromModalStack("QFrameMC");
                                if (mcQFrame)
                                {
                                    mcQFrame.mc.cnt.gotoAndPlay("intro");
                                }
                            }
                            else
                            {
                                if (mcQFrame)
                                {
                                    mcQFrame.mc.cnt.gotoAndPlay("back");
                                }
                            }
                            break;
                        case "afkGameResponse":
                            world.objResponse["afkGameResponse"] = resObj;
                            world.dispatchEvent(new Event("afkGameResponse"));
                            break;
                        case "who":
                            ulo = {};
                            ulo.typ = "userListA";
                            ulo.ul = resObj.users;
                            ui.mcOFrame.fOpenWith(ulo);
                            break;
                        case "al":
                            areaListShow(resObj);
                            break;
                        case "getinfo":
                            for (prop in resObj)
                            {
                                if (prop != "cmd")
                                {
                                }
                            }
                            break;
                        case "reloadmap":
                            if (world.strMapName == resObj.sName)
                            {
                                world.setMapEvents(null);
                                world.strMapFileName = resObj.sFileName;
                                world.reloadCurrentMap();
                            }
                            break;
                        case "moveToArea":
                            if (((resObj.areaName.toLowerCase().indexOf("battleodium") == 0) || (resObj.areaName.toLowerCase().indexOf("greyguard") == 0)))
                            {
                                if (getInterface("friendship_engine") == null)
                                {
                                    requestInterface("friendship/friendship_engine.swf", "friendship_engine");
                                }
                            }
                            if (((resObj.areaName.toLowerCase().indexOf("magicmeadow") == 0) || (resObj.areaName.toLowerCase().indexOf("magicmeaderp") == 0)))
                            {
                                if (getInterface("pony_engine") == null)
                                {
                                    requestInterface("ponyvspony/pony_engine.swf", "pony_engine");
                                }
                                else
                                {
                                    world.myAvatar.swapMorphs(true);
                                }
                            }
                            else
                            {
                                if (getInterface("pony_engine") != null)
                                {
                                    world.myAvatar.swapMorphs(false);
                                }
                            }
                            if (((resObj.areaName.indexOf("battleon") > -1) && (resObj.areaName.indexOf("battleontown") < 0)))
                            {
                                world.rootClass.openMenu();
                                world.rootClass.firstMenu = false;
                            }
                            else
                            {
                                if (!world.rootClass.firstMenu)
                                {
                                    world.rootClass.menuClose();
                                }
                            }
                            if (resObj.strMapName == "trickortreat")
                            {
                                world.TrickOrTreatMonsterDead = false;
                            }
                            else
                            {
                                if (resObj.strMapName == "caroling")
                                {
                                    world.CarolingMonsterKillCount = 0;
                                }
                            }
                            world.mapLoadInProgress = true;
                            world.strAreaName = resObj.areaName;
                            world.initObjExtra(resObj.sExtra);
                            world.areaUsers = [];
                            myLeaf = null;
                            world.modID = -1;
                            if (world.uoTreeLeaf(sfc.myUserName) != null)
                            {
                                myLeaf = copyObj(world.uoTreeLeaf(sfc.myUserName));
                            }
                            world.uoTree = {};
                            if (myLeaf != null)
                            {
                                world.uoTree[sfc.myUserName] = myLeaf;
                            }
                            if (resObj.monName != null)
                            {
                                world.chaosNames = resObj.monName.split(",");
                            }
                            if (resObj.pvpTeam != null)
                            {
                                myLeaf.pvpTeam = resObj.pvpTeam;
                                world.bPvP = true;
                                ui.mcPortrait.pvpIcon.visible = true;
                                ui.mcPortrait.partyLead.y = 18;
                                world.setPVPFactionData(resObj.PVPFactions);
                                if (world.objExtra["bChaos"] == null)
                                {
                                    updatePVPScore(resObj.pvpScore);
                                    showPVPScore();
                                }
                            }
                            else
                            {
                                ui.mcPortrait.pvpIcon.visible = false;
                                ui.mcPortrait.partyLead.y = 0;
                                delete myLeaf.pvpTeam;
                                world.bPvP = false;
                                hidePVPScore();
                                world.setPVPFactionData(null);
                            }
                            if (resObj.pvpScore != null)
                            {
                                updatePVPScore(resObj.pvpScore);
                            }
                            bi = 0;
                            while (bi < resObj.uoBranch.length)
                            {
                                branchA = resObj.uoBranch[bi];
                                unm = branchA.uoName;
                                uoLeaf = {};
                                for (s in branchA)
                                {
                                    nam = s;
                                    val = branchA[s];
                                    if ((((((nam.toLowerCase().indexOf("int") > -1) || (nam.toLowerCase() == "tx")) || (nam.toLowerCase() == "ty")) || (nam.toLowerCase() == "sp")) || (nam.toLowerCase() == "pvpTeam")))
                                    {
                                        val = int(val);
                                    }
                                    uoLeaf[nam] = val;
                                }
                                if (unm != sfc.myUserName)
                                {
                                    uoLeaf.auras = [];
                                }
                                uoLeaf.targets = {};
                                world.uoTreeLeafSet(unm, uoLeaf);
                                world.manageAreaUser(unm, "+");
                                bi = (bi + 1);
                            }
                            world.monTree = {};
                            world.monsters = [];
                            bi = 0;
                            while (bi < resObj.monBranch.length)
                            {
                                branchA = resObj.monBranch[bi];
                                monLeaf = {};
                                mID = "1";
                                for (s in branchA)
                                {
                                    nam = s;
                                    val = branchA[s];
                                    if (nam.toLowerCase().indexOf("monmapid") > -1)
                                    {
                                        mID = val;
                                    }
                                    if ((((nam.toLowerCase().indexOf("int") > -1) || (nam.toLowerCase().indexOf("monid") > -1)) || (nam.toLowerCase().indexOf("monmapid") > -1)))
                                    {
                                        val = Number(val);
                                    }
                                    monLeaf[nam] = val;
                                }
                                monLeaf.auras = [];
                                monLeaf.targets = {};
                                monLeaf.strBehave = "walk";
                                world.monTree[mID] = monLeaf;
                                bi = (bi + 1);
                            }
                            if (("event" in resObj))
                            {
                                world.setMapEvents(resObj.event);
                            }
                            else
                            {
                                world.setMapEvents(null);
                            }
                            if (("cellMap" in resObj))
                            {
                                world.setCellMap(resObj.cellMap);
                            }
                            else
                            {
                                world.setCellMap(null);
                            }
                            if (world.strFrame != "")
                            {
                                world.exitCell();
                            }
                            world.killLoaders();
                            world.clearMonstersAndProps();
                            world.clearAllAvatars();
                            world.avatars[sfc.myUserId] = world.myAvatar;
                            world.strMapName = resObj.strMapName;
                            world.strMapFileName = resObj.strMapFileName;
                            world.intType = resObj.intType;
                            world.intKillCount = resObj.intKillCount;
                            world.objLock = ((resObj.objLock != null) ? resObj.objLock : null);
                            world.mondef = resObj.mondef;
                            world.monmap = resObj.monmap;
                            // Database NPCs are supplied by the Aera emulator from npcs/maps_npc.
                            world.npcBranch = (("npcBranch" in resObj) && (resObj.npcBranch != null)) ? resObj.npcBranch : [];
                            world.npcdef = (("npcdef" in resObj) && (resObj.npcdef != null)) ? resObj.npcdef : [];
                            world.npcmap = (("npcmap" in resObj) && (resObj.npcmap != null)) ? resObj.npcmap : [];
                            // Database room/map arrows are supplied by the emulator from the map-arrow data.
                            world.mapArrows = (("mapArrows" in resObj) && (resObj.mapArrows != null)) ? resObj.mapArrows : [];
                            world.curRoom = Number(resObj.areaId);
                            world.actionResultsMon = [];
                            world.actionResults = [];
                            world.actionResultsAura = [];
                            world.mapBoundsMC = null;
                            chatF.chn.zone.rid = world.curRoom;
                            if (("houseData" in resObj))
                            {
                                world.initHouseData(resObj.houseData);
                            }
                            else
                            {
                                world.initHouseData(null);
                            }
                            world.updatePartyFrame();
                            world.clearLoaders();
                            s = resObj.strMapFileName.toLowerCase();
                            world.loadMap(s);
                            elmType = resObj.elmType;

                            if (world.rootClass.hasPreviewed)
                            {
                                for (psES in world.myAvatar.objData.eqp)
                                {
                                    if (world.myAvatar.objData.eqp[psES].wasCreated)
                                    {
                                        delete world.myAvatar.objData.eqp[psES];
                                        world.myAvatar.unloadMovieAtES(psES);
                                    }
                                    else
                                    {
                                        if (world.myAvatar.objData.eqp[psES].isPreview)
                                        {
                                            if (psES == "pe")
                                            {
                                                if (world.myAvatar.objData.eqp["pe"])
                                                {
                                                    world.myAvatar.unloadPet();
                                                }
                                            }
                                            world.myAvatar.objData.eqp[psES].sType = world.myAvatar.objData.eqp[psES].oldType;
                                            world.myAvatar.objData.eqp[psES].sFile = world.myAvatar.objData.eqp[psES].oldFile;
                                            world.myAvatar.objData.eqp[psES].sLink = world.myAvatar.objData.eqp[psES].oldLink;
                                            world.myAvatar.loadMovieAtES(psES, world.myAvatar.objData.eqp[psES].oldFile, world.myAvatar.objData.eqp[psES].oldLink);
                                            world.myAvatar.objData.eqp[psES].isPreview = null;
                                        }
                                    }
                                }
                                world.rootClass.hasPreviewed = false;
                            }
                            if (((((world.myAvatar) && (world.myAvatar.items)) && (world.myAvatar.items.length > 0)) && (litePreference.data.bCharSelect)))
                            {
                                saveChar();
                            }
                            break;
                        case "initUserData":
                            try
                            {
                                avt = world.getAvatarByUserID(resObj.uid);
                                uoLeaf = avt.dataLeaf;
                                if (((!(avt == null)) && (!(uoLeaf == null))))
                                {
                                    avt.initAvatar({"data":resObj.data});
                                    if (avt.isMyAvatar)
                                    {
                                        loadGameMenu();
                                        avt.objData.strHomeTown = avt.objData.strMapName;
                                        if (avt.objData.guild != null)
                                        {
                                            chatF.chn.guild.act = 1;
                                            if (String(avt.objData.guild.MOTD) != "undefined")
                                            {
                                                chatF.pushMsg("guild", ("Message of the day: " + String(avt.objData.guild.MOTD)), "SERVER", "", 0);
                                            }
                                        }
                                        if (Game.serverFilePath.indexOf("content.aq.com") == -1)
                                        {
                                            world.rootClass.extCall.showIt("login");
                                        }
                                        if (avt.objData.iUpg > 0)
                                        {
                                            if (avt.objData.iUpgDays < 0)
                                            {
                                                chatF.pushMsg("moderator", "Your membership has expired. Please visit our website to renew your membership.", "SERVER", "", 0);
                                            }
                                            else
                                            {
                                                if (avt.objData.iUpgDays < 7)
                                                {
                                                    chatF.pushMsg("moderator", (("Your membership will expire in " + (Number(avt.objData.iUpgDays) + 1)) + " days. Please visit our website to renew your membership."), "SERVER", "", 0);
                                                }
                                            }
                                        }
                                        updateXPBar();
                                        ui.mcInterface.mcGold.strGold.text = avt.objData.intGold;
                                        if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                        {
                                            MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                        }
                                        world.getInventory(resObj.uid);
                                        world.initAchievements();
                                        readIA1Preferences();
                                    }
                                }
                            }
                            catch(e:Error)
                            {
                            }
                            break;
                        case "initUserDatas":
                            a = resObj.a;
                            i = 0;
                            while (i < a.length)
                            {
                                o = a[i];
                                try
                                {
                                    avt = world.getAvatarByUserID(o.uid);
                                    uoLeaf = avt.dataLeaf;
                                    if (((!(avt == null)) && (!(uoLeaf == null))))
                                    {
                                        avt.initAvatar({"data":o.data});
                                        if (((avt.isMyAvatar) && ((avt.items == null) || (avt.items.length < 1))))
                                        {
                                            loadGameMenu();
                                            avt.objData.strHomeTown = avt.objData.strMapName;
                                            if (avt.objData.guild != null)
                                            {
                                                chatF.chn.guild.act = 1;
                                                if (String(avt.objData.guild.MOTD) != "undefined")
                                                {
                                                    chatF.pushMsg("guild", ("Message of the day: " + String(avt.objData.guild.MOTD)), "SERVER", "", 0);
                                                }
                                            }
                                            if (Game.serverFilePath.indexOf("content.aq.com") == -1)
                                            {
                                                world.rootClass.extCall.showIt("login");
                                            }
                                            if (avt.objData.iUpg > 0)
                                            {
                                                if (avt.objData.iUpgDays < 0)
                                                {
                                                    chatF.pushMsg("moderator", "Your membership has expired. Please visit our website to renew your membership.", "SERVER", "", 0);
                                                }
                                                else
                                                {
                                                    if (avt.objData.iUpgDays < 7)
                                                    {
                                                        chatF.pushMsg("moderator", (("Your membership will expire in " + (Number(avt.objData.iUpgDays) + 1)) + " days. Please visit our website to renew your membership."), "SERVER", "", 0);
                                                    }
                                                }
                                            }
                                            if (((!(avt.objData.dRefReset == null)) && ((avt.objData.iRefGold > 0) || (avt.objData.iRefExp > 0))))
                                            {
                                                modalRR = new ModalMC();
                                                modalORR = {};
                                                modalORR.strBody = (((("You earned <font color='#FFCC00'><b>" + Math.ceil(avt.objData.iRefGold)) + " Gold</b></font> and <font color='#990099'><b>") + Math.ceil(avt.objData.iRefExp)) + " XP</b></font><br/> from Referred Friends.");
                                                modalORR.callback = world.sendRewardReferralRequest;
                                                modalORR.btns = "mono";
                                                ui.ModalStack.addChild(modalRR);
                                                modalRR.init(modalORR);
                                            }
                                            updateXPBar();
                                            ui.mcInterface.mcGold.strGold.text = avt.objData.intGold;
                                            if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                            {
                                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                            }
                                            world.getInventory(o.uid);
                                            world.initAchievements();
                                            readIA1Preferences();
                                        }
                                    }
                                }
                                catch(e:Error)
                                {

                                }
                                i = (i + 1);
                            }
                            break;
                        case "changeColor":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (((!(avt == null)) && (avt.bitData)))
                            {
                                if (avt.isMyAvatar)
                                {
                                    showPortrait(avt);
                                }
                                if (resObj.HairID != null)
                                {
                                    avt.objData.HairID = resObj.HairID;
                                    avt.objData.strHairName = resObj.strHairName;
                                    avt.objData.strHairFilename = resObj.strHairFilename;
                                    if (((!(avt.pMC == null)) && (!(avt.pMC.stage == null))))
                                    {
                                        avt.pMC.loadHair();
                                    }
                                }
                                avt.objData.intColorSkin = resObj.intColorSkin;
                                avt.objData.intColorHair = resObj.intColorHair;
                                avt.objData.intColorEye = resObj.intColorEye;
                                if (((!(avt.pMC == null)) && (!(avt.pMC.stage == null))))
                                {
                                    avt.pMC.updateColor();
                                }
                            }
                            break;
                        case "changeArmorColor":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (((!(avt == null)) && (avt.bitData)))
                            {
                                avt.objData.intColorBase = resObj.intColorBase;
                                avt.objData.intColorTrim = resObj.intColorTrim;
                                avt.objData.intColorAccessory = resObj.intColorAccessory;
                                if (((!(avt.pMC == null)) && (!(avt.pMC.stage == null))))
                                {
                                    avt.pMC.updateColor();
                                }
                            }
                            break;
                        case "popupmsg":
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = resObj.strMsg;
                            modalO.params = {};
                            modalO.glow = resObj.strGlow;
                            modalO.btns = "mono";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            break;
                        case "loadOffer":
                            if (resObj.bitSuccess){
                                if (((!((resObj.itemsA == null))) && (!((resObj.itemsA == "undefined"))))){
                                    world.addItemsToTradeA(resObj.itemsA);
                                }
                                if (((!((resObj.itemsB == null))) && (!((resObj.itemsB == "undefined"))))){
                                    world.addItemsToTradeB(resObj.itemsB);
                                }
                                if (ui.mcPopup.currentLabel == "Trade"){
                                    MovieClip(ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshBank"});
                                }
                                else {
                                    ui.mcPopup.fOpen("Trade");
                                }
                            }
                            else {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = "Error loading trade items!  Try logging out and back in to fix this problem.";
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "tradeDeal":
                            if (resObj.bitSuccess) {
                                if (("onHold" in resObj) && (resObj.onHold == 1)) {
                                    ctrlTrade.btnDeal.alpha = 0.5;
                                    ctrlTrade.btnDeal.mouseEnabled = false;
                                } else {
                                    if (ui.mcPopup.currentLabel == "Trade") {
                                        MovieClip(ui.mcPopup.getChildByName("mcTrade")).notify = false;
                                        MovieClip(ui.mcPopup.getChildByName("mcTrade")).fClose();
                                    }
                                }
                            }
                            else {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = resObj.msg;
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "tradeCancel":

                            if (resObj.bitSuccess) {
                                world.myAvatar.tradeToInvReset();
                                if (ui.mcPopup.currentLabel == "Trade") {
                                    MovieClip(ui.mcPopup.getChildByName("mcTrade")).notify = false;
                                    MovieClip(ui.mcPopup.getChildByName("mcTrade")).fClose();
                                }
                            }
                            break;
                        case "tradeLock":
                            if (resObj.bitSuccess){
                                ctrlTrade.txtTargetGold.text = resObj.gold;
                                ctrlTrade.txtTargetCoins.text = resObj.coins;

                                if (("Deal" in resObj) && (resObj.Deal == 1)) {
                                    ctrlTrade.btnDeal.alpha = 1;
                                    ctrlTrade.btnDeal.mouseEnabled = true;
                                }
                                if (("Self" in resObj) && (resObj.Self == 1)) {
                                    ctrlTrade.txtMyGold.mouseEnabled = false;
                                    ctrlTrade.txtMyCoins.mouseEnabled = false;
                                    ctrlTrade.txtLock.text = "Unlock";
                                    tradeItem1.alpha = 0.5;
                                } else  {
                                    tradeItem2.alpha = 0.5;
                                }
                            }
                            else {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = resObj.msg;
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "tradeUnlock":
                            if (resObj.bitSuccess){
                                ctrlTrade.txtLock.text = "Lock";
                                ctrlTrade.btnDeal.alpha = 0.5;
                                ctrlTrade.btnDeal.mouseEnabled = false;
                                ctrlTrade.txtMyGold.mouseEnabled = true;
                                ctrlTrade.txtMyCoins.mouseEnabled = true;
                                tradeItem1.alpha = 1;
                                tradeItem2.alpha = 1;
                            }
                            break;
                        case "tradeFromInv":
                            if (((("bSuccess" in resObj)) && ((resObj.bSuccess == 1)))){
                                world.myAvatar.tradeFromInv(resObj.ItemID, resObj.Type, resObj.Quantity);
                                world.checkAllQuestStatus();
                                if (ui.mcPopup.currentLabel == "Trade"){
                                    MovieClip(ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshItems"});
                                }
                            }
                            else {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = resObj.msg;
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "tradeToInv":
                            if (resObj.Type == 1) {
                                world.myAvatar.tradeToInvA(resObj.ItemID);
                            } else {
                                world.myAvatar.tradeToInvB(resObj.ItemID);
                            }
                            world.checkAllQuestStatus();
                            if (ui.mcPopup.currentLabel == "Trade"){
                                MovieClip(ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshItems"});
                            }
                            break;
                        case "tradeSwapInv":
                            world.myAvatar.tradeSwapInv(resObj.invItemID, resObj.tradeItemID);
                            world.checkAllQuestStatus();
                            if (ui.mcPopup.currentLabel == "Trade"){
                                MovieClip(ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshItems"});
                            }
                            break;
                        case "buyAuctionItem":
                            if (resObj.bitSuccess) {
                                item = copyObj(resObj.item);
                                item.CharItemID = resObj.CharItemID;

                                showItemDrop(item, false);
                                world.invTree[item.ItemID] = item;

                                world.myAvatar.auctionToInv(item);

                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshBank"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshInventory"});

                                world.updateQuestProgress("item", item);
                            } else {
                                MsgBox.notify(resObj.strMessage);
                            }
                            break;
                        case "sellAuctionItem":
                            if (resObj.bitSuccess) {
                                world.myAvatar.removeItem({
                                    "CharItemID":resObj.CharItemID,
                                    "iQty":resObj.Quantity
                                });
                                world.checkAllQuestStatus();

                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshBank"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshInventory"});
                            } else {
                                MsgBox.notify(resObj.strMessage);
                            }
                            break;
                        case "retrieveAuctionItem":
                            if (resObj.bitSuccess) {
                                if ("item" in resObj) {
                                    item = copyObj(resObj.item);
                                    item.CharItemID = resObj.CharItemID;

                                    showItemDrop(item, false);
                                    world.invTree[item.ItemID] = item;
                                    world.myAvatar.addItem(item);
                                    world.updateQuestProgress("item", item);
                                }

                                world.myAvatar.removeRetrieve(resObj.AuctionID);
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshBank"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshInventory"});
                            } else {
                                MsgBox.notify(resObj.strMessage);
                            }
                            break;
                        case "retrieveAuctionItems":
                            if (resObj.bitSuccess) {
                                i = 0;
                                while (i < resObj.items.length) {
                                    iobj = copyObj(resObj.items[i]);

                                    world.invTree[iobj.ItemID] = copyObj(iobj);
                                    if (!("bSold" in resObj.items[i])) {
                                        world.myAvatar.addItem(iobj);
                                        showItemDrop(iobj, false);
                                    }

                                    world.updateQuestProgress("item", iobj);
                                    world.myAvatar.removeRetrieve(resObj.items[i].AuctionID);

                                    i = (i + 1);
                                }

                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshBank"});
                                MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshInventory"});
                            } else {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = resObj.strMessage;
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "loadAuction":
                            if (resObj.bitSuccess){
                                if (((!((resObj.items == null))) && (!((resObj.items == "undefined"))))){
                                    world.addItemsToAuction(resObj.items);
                                }
                                if (ui.mcPopup.currentLabel == "Auction"){
                                    MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
                                    MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshBank"});
                                    MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshInventory"});
                                }
                                else {
                                    ui.mcPopup.fOpen("Auction");
                                }
                                world.rootClass.auctionTabs.onSearch = false;
                            }
                            else {
                                MsgBox.notify(resObj.strMessage);
                            }
                            break;
                        case "loadRetrieve":
                            if (resObj.bitSuccess){
                                if (((!((resObj.items == null))) && (!((resObj.items == "undefined"))))){
                                    world.addItemsToRetrieve(resObj.items);
                                }
                                if (ui.mcPopup.currentLabel == "Auction"){
                                    MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshItems"});
                                    MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshBank"});
                                    MovieClip(ui.mcPopup.getChildByName("mcAuction")).update({eventType:"refreshInventory"});
                                }
                                else {
                                    ui.mcPopup.fOpen("Auction");
                                }
                            }
                            else {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = "Error loading auction items!  Try logging out and back in to fix this problem.";
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "balance":
                            if (resObj.intExp != null)
                            {
                                world.myAvatar.objData.intExp = resObj.intExp;
                                updateXPBar();
                            }
                            if (resObj.intGold != null)
                            {
                                world.myAvatar.objData.intGold = resObj.intGold;
                                ui.mcInterface.mcGold.strGold.text = world.myAvatar.objData.intGold;
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                }
                            }
                            if (resObj.intCoins != null)
                            {
                                world.myAvatar.objData.intCoins = resObj.intCoins;
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                }
                            }
                            break;
                        case "addGoldExp":
                            if (((!(resObj.intExp == null)) && (resObj.intExp > 0)))
                            {
                                if (bAnalyzer)
                                {
                                    if (bAnalyzer.isRunning())
                                    {
                                        bAnalyzer.addExp(resObj.intExp);
                                    }
                                }
                                deltaXP = resObj.intExp;
                                world.myAvatar.objData.intExp = (world.myAvatar.objData.intExp + deltaXP);
                                updateXPBar();
                                xp = new xpDisplay();
                                xp.t.ti.text = (deltaXP + " xp");
                                xpB = null;
                                if (("bonusExp" in resObj))
                                {
                                    xpB = new xpDisplayBonus();
                                    xpB.t.ti.text = String((("+ " + resObj.bonusExp) + " xp!"));
                                    xp.t.ti.text = ((deltaXP - resObj.bonusExp) + " xp");
                                }
                                if (((!(resObj.typ == null)) && (resObj.typ == "m")))
                                {
                                    Mon = world.getMonster(resObj.id);
                                    xp.x = Mon.pMC.mcChar.x;
                                    xp.y = (Mon.pMC.mcChar.y - 40);
                                    Mon.pMC.addChild(xp);
                                    if (xpB != null)
                                    {
                                        xpB.x = xp.x;
                                        xpB.y = xp.y;
                                        Mon.pMC.addChild(xpB);
                                    }
                                }
                                else
                                {
                                    xp.x = world.myAvatar.pMC.mcChar.x;
                                    xp.y = (world.myAvatar.pMC.pname.y + 10);
                                    world.myAvatar.pMC.addChild(xp);
                                    if (xpB != null)
                                    {
                                        xpB.x = xp.x;
                                        xpB.y = xp.y;
                                        world.myAvatar.pMC.addChild(xpB);
                                    }
                                }
                            }
                            if (resObj.intGold != null && resObj.intGold > 0)
                            {
                                if (bAnalyzer)
                                {
                                    if (bAnalyzer.isRunning())
                                    {
                                        bAnalyzer.addGold(resObj.intGold);
                                    }
                                }
                                mixer.playSound("Coins");
                                deltaGold = resObj.intGold;
                                world.myAvatar.objData.intGold = (world.myAvatar.objData.intGold + resObj.intGold);
                                ui.mcInterface.mcGold.strGold.text = world.myAvatar.objData.intGold;
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                }
                                gold = new goldDisplay();
                                gold.t.ti.text = (deltaGold + " g");
                                gold.tMask.ti.text = (deltaGold + " g");
                                if (((!(resObj.typ == null)) && (resObj.typ == "m")))
                                {
                                    Mon = world.getMonster(resObj.id);
                                    gold.x = Mon.pMC.mcChar.x;
                                    gold.y = (Mon.pMC.mcChar.y - 20);
                                    Mon.pMC.addChild(gold);
                                }
                                else
                                {
                                    gold.x = world.myAvatar.pMC.mcChar.x;
                                    gold.y = (world.myAvatar.pMC.pname.y - 30);
                                    world.myAvatar.pMC.addChild(gold);
                                }
                            }
                            if (resObj.intCoins != null && resObj.intCoins > 0)
                            {
                                mixer.playSound("Coins");
                                deltaCoins = resObj.intCoins;
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins + resObj.intCoins);
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                }
                                coins = new goldDisplay();
                                coins.t.ti.textColor = "0xFF9900";
                                coins.t.ti.text = (deltaCoins + " c");
                                coins.tMask.ti.text = (deltaCoins + " c");
                                if (((!(resObj.typ == null)) && (resObj.typ == "m")))
                                {
                                    Mon = world.getMonster(resObj.id);
                                    coins.x = Mon.pMC.mcChar.x;
                                    coins.y = (Mon.pMC.mcChar.y);
                                    Mon.pMC.addChild(coins);
                                }
                                else
                                {
                                    coins.x = world.myAvatar.pMC.mcChar.x;
                                    coins.y = (world.myAvatar.pMC.pname.y);
                                    world.myAvatar.pMC.addChild(coins);
                                }
                            }
                            if (resObj.iCP != null)
                            {
                                deltaCP = resObj.iCP;
                                world.myAvatar.objData.iCP = (world.myAvatar.objData.iCP + deltaCP);
                                world.myAvatar.updateArmorRep();
                                iRank = world.myAvatar.objData.iRank;
                                world.myAvatar.updateRep();
                                if (iRank != world.myAvatar.objData.iRank)
                                {
                                    world.myAvatar.rankUp(world.myAvatar.objData.strClassName, world.myAvatar.objData.iRank);
                                    FB_showFeedDialog("Rank Up!", (((("reached Rank " + world.myAvatar.objData.iRank) + " ") + world.myAvatar.objData.strClassName) + " in AQWorlds!"), "aqw-rankup.jpg");
                                }
                                txtBonusCP = "";
                                if (resObj.bonusCP == null)
                                {
                                    resObj.bonusCP = 0;
                                }
                                else
                                {
                                    txtBonusCP = ((" + " + resObj.bonusCP) + "(Bonus)");
                                }
                                chatF.pushMsg("server", ((((("Class Points for " + world.myAvatar.objData.strClassName) + " increased by ") + (deltaCP - resObj.bonusCP)) + txtBonusCP) + "."), "SERVER", "", 0);
                            }
                            if (resObj.FactionID != null)
                            {
                                if (resObj.bonusRep == null)
                                {
                                    resObj.bonusRep = 0;
                                }
                                world.myAvatar.addRep(resObj.FactionID, resObj.iRep, resObj.bonusRep);
                            }
                            break;
                        case "levelUp":
                            world.myAvatar.objData.intLevel = resObj.intLevel;
                            world.myAvatar.objData.intExpToLevel = resObj.intExpToLevel;
                            world.myAvatar.objData.intExp = resObj.xp;
                            // Aera awards +3 persistent stat points per level. Prefer the
                            // emulator's authoritative balance so existing/unspent points stack.
                            if (resObj.StatPoints != null)
                            {
                                syncAeraStatPointData(resObj.StatPoints, null, false);
                            }
                            else if (resObj.StatPointsAwarded != null)
                            {
                                addAeraStatPoints(int(resObj.StatPointsAwarded));
                            }
                            updateXPBar();
//                            showPortraitBox(world.myAvatar, ui.mcPortrait);
                            world.myAvatar.levelUp();
                            if (resObj.intLevel == 10)
                            {
                                world.rootClass.extCall.showIt("level10");
                            }
                            if (("updatePStats" in world.map))
                            {
                                world.map.updatePStats();
                            }
                            break;
                        case "loadInventoryBig":
                            world.myAvatar.iBankCount = int(resObj.bankCount);
                            world.myAvatar.initInventory(resObj.items);
                            world.initHouseInventory({
                                "sHouseInfo":world.myAvatar.objData.sHouseInfo,
                                "items":resObj.hitems
                            });
                            world.myAvatar.initFactions(resObj.factions);
                            world.myAvatar.initGuild(resObj.guild);
                            world.uiLock = false;
                            world.myAvatar.invLoaded = true;
                            world.myAvatar.calculateIntoBoosts();
                            try
                            {
                                if (("eventTrigger" in MovieClip(world.map)))
                                {
                                    world.map.eventTrigger({"cmd":"userLoaded"});
                                }
                            }
                            catch(e)
                            {
                            }
                            world.myAvatar.checkItemAnimation();
                            adShown = false;
                            testDate = new Date();
                            if (!FacebookConnect.isLoggedIn)
                            {
                            }
                            if (((world.myAvatar.objData.iUpg < 1) && (!(world.map.noPopup == true))))
                            {
                                testDate.setDate((testDate.getDate() - 3));
                                if ((((world.myAvatar.objData.dCreated > testDate) && (world.myAvatar.objData.intHits > 1)) && (Math.random() < 0.2)))
                                {
                                    adShown = true;
                                    world.loadMovieFront("interface/DragonHeroOffer-28Feb13.swf", "Inline Asset");
                                }
                            }
                            if ((((world.myAvatar.objData.intActivationFlag == 1) && (world.myAvatar.objData.intHits < 16)) && (!(world.map.noPopup == true))))
                            {
                                if (((world.myAvatar.objData.intHits == 5) || (world.myAvatar.objData.intHits == 15)))
                                {
                                    world.loadMovieFront("interface/ConfirmedEmailPopup.swf", "Inline Asset");
                                }
                            }
                            break;
                        case "friends":
                            world.myAvatar.initFriendsList(resObj.friends);
                            if (resObj.showList)
                            {
                                flo = {};
                                flo.typ = "userListFriends";
                                for each (friend in world.myAvatar.friends)
                                {
                                    friend.bOffline = ((friend.sServer == objServerInfo.sName) ? 0 : ((friend.sServer == "Offline") ? 2 : 1));
                                }
                                world.myAvatar.friends.sortOn("sName", Array.CASEINSENSITIVE);
                                world.myAvatar.friends.sortOn(["bOffline", "sServer", "sName"], [Array.NUMERIC, Array.CASEINSENSITIVE, Array.CASEINSENSITIVE]);
                                flo.ul = world.myAvatar.friends;
                                ui.mcOFrame.fOpenWith(flo);
                                mcO.fClose();
                            }
                            break;
                        case "initInventory":
                            world.myAvatar.initInventory(resObj.items);
                            if (("eventTrigger" in MovieClip(world.map)))
                            {
                                world.map.eventTrigger({"cmd":"userLoaded"});
                            }
                            break;
                        case "loadHouseInventory":
                            world.initHouseInventory(resObj);
                            break;
                        case "house":
                            MsgBox.notify(resObj.msg);
                            break;
                        case "buyBagSlots":
                            world.dispatchEvent(new Event("buyBagSlots"));
                            if (resObj.bitSuccess == 1)
                            {
                                mixer.playSound("Heal");
                                world.myAvatar.objData.iBagSlots = (world.myAvatar.objData.iBagSlots + Number(resObj.iSlots));
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - (Number(resObj.iSlots) * 200));
                                MsgBox.notify((("You now have " + world.myAvatar.objData.iBagSlots) + " inventory spaces!"));
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshSlots"});
                                }
                                if (((ui.mcPopup.currentLabel == "Shop") || (ui.mcPopup.currentLabel == "HouseShop")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshSlots"});
                                }
                            }
                            break;
                        case "buyBankSlots":
                            world.dispatchEvent(new Event("buyBankSlots"));
                            if (resObj.bitSuccess == 1)
                            {
                                mixer.playSound("Heal");
                                world.myAvatar.objData.iBankSlots = (world.myAvatar.objData.iBankSlots + Number(resObj.iSlots));
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - (Number(resObj.iSlots) * 200));
                                MsgBox.notify((("You now have " + world.myAvatar.objData.iBankSlots) + " bank spaces!"));
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshSlots"});
                                }
                                if (((ui.mcPopup.currentLabel == "Shop") || (ui.mcPopup.currentLabel == "HouseShop")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshSlots"});
                                }
                            }
                            break;
                        case "buyHouseSlots":
                            world.dispatchEvent(new Event("buyHouseSlots"));
                            if (resObj.bitSuccess == 1)
                            {
                                mixer.playSound("Heal");
                                world.myAvatar.objData.iHouseSlots = (world.myAvatar.objData.iHouseSlots + Number(resObj.iSlots));
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - (Number(resObj.iSlots) * 200));
                                MsgBox.notify((("You now have " + world.myAvatar.objData.iHouseSlots) + " house inventory spaces!"));
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshSlots"});
                                }
                                if (((ui.mcPopup.currentLabel == "Shop") || (ui.mcPopup.currentLabel == "HouseShop")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshSlots"});
                                }
                            }
                            break;
                        case "buyLoadoutSlots":
                            if (resObj.bitSuccess == 1)
                            {
                                mixer.playSound("Heal");
                                world.myAvatar.objData.iLoadoutSlots = (world.myAvatar.objData.iLoadoutSlots + Number(resObj.iSlots));
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - (Number(resObj.iSlots) * 200));
                                world.dispatchEvent(new Event("buyLoadoutSlots"));
                            }
                            break;
                        case "callfct":
                            try
                            {
                                fct = world.map[resObj.fctNam];
                                (fct(resObj.fctParams));
                            }
                            catch(e)
                            {
                            }
                            break;
                        case "genderSwap":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (((!(avt == null)) && (avt.bitData)))
                            {
                                if (resObj.bitSuccess == 1)
                                {
                                    if (avt.isMyAvatar)
                                    {
                                        MsgBox.notify("Your gender has been successfully changed.");
                                        avt.objData.intCoins = (avt.objData.intCoins - resObj.intCoins);
                                    }
                                    avt.objData.strGender = resObj.gender;
                                    avt.objData.HairID = resObj.HairID;
                                    avt.objData.strHairName = resObj.strHairName;
                                    avt.objData.strHairFilename = resObj.strHairFilename;
                                    avt.initAvatar({"data":avt.objData});
                                }
                            }
                            break;
                        case "loadBank":
                            if (resObj.bitSuccess)
                            {
                                if (((!(resObj.items == null)) && (!(resObj.items == "undefined"))))
                                {
                                    world.addItemsToBank(resObj.items);
                                }
                                if (ui.mcPopup.currentLabel == "Bank")
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                                }
                                else
                                {
                                    ui.mcPopup.fOpen("Bank");
                                }
                            }
                            else
                            {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = "Error loading bank items!  Try logging out and back in to fix this problem.";
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "bankFromInv":
                            if ((("bSuccess" in resObj) && (resObj.bSuccess == 1)))
                            {
                                world.myAvatar.bankFromInv(resObj.ItemID);
                                world.checkAllQuestStatus();
                                if (((ui.mcPopup.currentLabel == "Bank") || (ui.mcPopup.currentLabel == "HouseBank")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
                                }
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                }
                            }
                            else
                            {
                                modal = new ModalMC();
                                modalO = {};
                                modalO.strBody = resObj.msg;
                                modalO.params = {};
                                modalO.glow = "red,medium";
                                modalO.btns = "mono";
                                ui.ModalStack.addChild(modal);
                                modal.init(modalO);
                            }
                            break;
                        case "bankToInv":
                            world.myAvatar.bankToInv(resObj.ItemID);
                            world.checkAllQuestStatus();
                            if (((ui.mcPopup.currentLabel == "Bank") || (ui.mcPopup.currentLabel == "HouseBank")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
                            }
                            if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                            }
                            break;
                        case "bankSwapInv":
                            world.myAvatar.bankSwapInv(resObj.invItemID, resObj.bankItemID);
                            world.checkAllQuestStatus();
                            if (((ui.mcPopup.currentLabel == "Bank") || (ui.mcPopup.currentLabel == "HouseBank")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
                            }
                            if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                            }
                            break;
                        case "loadShop":
                            if ((((((!(world.shopinfo == null)) && ("ShopID" in world.shopinfo)) && (world.shopinfo.ShopID == resObj.shopinfo.ShopID)) && ("bLimited" in world.shopinfo)) && (world.shopinfo.bLimited)))
                            {
                                i = 0;
                                while (i < resObj.shopinfo.items.length)
                                {
                                    world.shopinfo.items.push(resObj.shopinfo.items[i]);
                                    world.shopinfo.items.shift();
                                    i = (i + 1);
                                }
                                if (((ui.mcPopup.currentLabel == "Shop") || (ui.mcPopup.currentLabel == "HouseShop")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                                }
                                else
                                {
                                    ui.mcPopup.fOpen("Shop");
                                }
                            }
                            else
                            {
                                world.shopinfo = resObj.shopinfo;
                                if (resObj.shopinfo.bHouse == 1)
                                {
                                    ui.mcPopup.fOpen("HouseShop");
                                }
                                else
                                {
                                    if (isMergeShop(resObj.shopinfo))
                                    {
                                        ui.mcPopup.fOpen("MergeShop");
                                    }
                                    else
                                    {
                                        ui.mcPopup.fOpen("Shop");
                                    }
                                }
                            }
                            break;
                        case "loadEnhShop":
                            world.enhShopID = resObj.shopinfo.ShopID;
                            world.enhShopItems = resObj.shopinfo.items;
                            ui.mcPopup.fOpen("EnhShop");
                            break;
                        case "enhanceItemShop":
                            if (resObj.iCost != null)
                            {
                                world.myAvatar.objData.intGold = (world.myAvatar.objData.intGold - Number(resObj.iCost));
                                ui.mcInterface.mcGold.strGold.text = world.myAvatar.objData.intGold;
                                if (ui.mcPopup.currentLabel == "Inventory")
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                }
                                if (ui.mcPopup.currentLabel == "Shop")
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                                }
                            }
                            for each (o in world.myAvatar.items)
                            {
                                if (resObj.ItemIDs.indexOf(Number(o.ItemID)) != -1)
                                {
                                    o.iEnh = resObj.EnhID;
                                    o.EnhID = resObj.EnhID;
                                    o.EnhPatternID = resObj.EnhPID;
                                    o.EnhLvl = resObj.EnhLvl;
                                    o.EnhDPS = resObj.EnhDPS;
                                    o.EnhRng = resObj.EnhRng;
                                    o.EnhRty = resObj.EnhRty;
                                    o.ProcID = resObj.ProcID;
                                }
                            }
                            mixer.playSound("Good");
                            if (ui.mcPopup.currentLabel == "Inventory")
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                                    "eventType":"refreshItems",
                                    "sInstruction":"previewEquipOnly"
                                });
                            }
                            if (ui.mcPopup.currentLabel == "Shop")
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                    "eventType":"refreshItems",
                                    "sInstruction":"closeWindows"
                                });
                            }
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (((("You have upgraded your items with <b>" + resObj.EnhName) + "</b>, level <b>") + resObj.EnhLvl) + "</b>!");
                            modalO.params = {};
                            modalO.glow = "white,medium";
                            modalO.btns = "mono";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            break;
                        case "enhanceItemLocal":
                            iSel = null;
                            eSel = null;
                            for each (o in world.myAvatar.items)
                            {
                                if (o.ItemID == resObj.ItemID)
                                {
                                    iSel = o;
                                }
                            }
                            iSel.iEnh = resObj.EnhID;
                            iSel.EnhID = resObj.EnhID;
                            iSel.EnhPatternID = resObj.EnhPID;
                            iSel.EnhLvl = resObj.EnhLvl;
                            iSel.EnhDPS = resObj.EnhDPS;
                            iSel.EnhRng = resObj.EnhRng;
                            iSel.EnhRty = resObj.EnhRty;
                            iSel.ProcID = resObj.ProcID;
                            mixer.playSound("Good");
                            if (ui.mcPopup.currentLabel == "Inventory")
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                                    "eventType":"refreshItems",
                                    "sInstruction":"previewEquipOnly"
                                });
                            }
                            if (ui.mcPopup.currentLabel == "Shop")
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                    "eventType":"refreshItems",
                                    "sInstruction":"closeWindows"
                                });
                            }
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (((((("You have upgraded " + iSel.sName) + " with ") + resObj.EnhName) + ", level ") + resObj.EnhLvl) + "!");
                            modalO.params = {};
                            modalO.glow = "white,medium";
                            modalO.btns = "mono";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            break;
                        case "loadHairShop":
                            world.hairshopinfo = resObj;
                            openCharacterCustomize();
                            break;
                        case "buyItem":
                            if (resObj.bitSuccess == 0)
                            {
                                if ((("bSoldOut" in resObj) && (resObj.bSoldOut)))
                                {
                                    if (world.shopinfo.bLimited)
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                            "eventType":"refreshShop",
                                            "sInstruction":"closeWindows"
                                        });
                                    }
                                    modal = new ModalMC();
                                    modalO = {};
                                    modalO.strBody = (resObj.strMessage + " is no longer in stock.");
                                    modalO.params = {};
                                    modalO.glow = "red,medium";
                                    modalO.btns = "mono";
                                    ui.ModalStack.addChild(modal);
                                    modal.init(modalO);
                                }
                                else
                                {
                                    if (resObj.strMessage != null)
                                    {
                                        MsgBox.notify(resObj.strMessage);
                                    }
                                }
                            }
                            else
                            {
                                if (resObj.strMessage != null)
                                {
                                    MsgBox.notify(resObj.strMessage);
                                }
                                item = copyObj(world.shopBuyItem);
                                item.iQty = resObj.iQty;
                                item.CharItemID = resObj.CharItemID;
                                item.bBank = resObj.bBank;
                                if (item.bCoins == 0)
                                {
                                    world.myAvatar.objData.intGold = (world.myAvatar.objData.intGold - Number((item.iCost * resObj.iQty)));
                                    ui.mcInterface.mcGold.strGold.text = world.myAvatar.objData.intGold;
                                    if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                    }
                                }
                                else
                                {
                                    item.iHrs = 0;
                                    world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins - Number((item.iCost * resObj.iQty)));
                                }
                                if (resObj.virtual)
                                {
                                    item.virtual = resObj.virtual;
                                }
                                showItemDrop(item, false);
                                if (world.invTree[item.ItemID] == null)
                                {
                                    world.invTree[item.ItemID] = copyObj(resObj);
                                    world.invTree[item.ItemID].iQty = 0;
                                }
                                if (!resObj.virtual)
                                {
                                    world.myAvatar.addItem(item);
                                }
                                if (item.bHouse == 1)
                                {
                                    if (((item.sType == "House") && (!(world.isHouseEquipped()))))
                                    {
                                        world.sendEquipItemRequest(item);
                                        world.myAvatar.getItemByID(item.ItemID).bEquip = 1;
                                    }
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                        "eventType":"refreshItems",
                                        "sInstruction":"closeWindows"
                                    });
                                    if (world.shopinfo.bLimited)
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshShop"});
                                    }
                                    if (ui.mcPopup.currentLabel == "HouseInventory")
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                                            "eventType":"refreshItems",
                                            "sInstruction":"closeWindows"
                                        });
                                    }
                                }
                                else
                                {
                                    if (ui.mcPopup.currentLabel == "Shop")
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                            "eventType":"refreshItems",
                                            "sInstruction":"closeWindows"
                                        });
                                        if (world.shopinfo.bLimited)
                                        {
                                            MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshShop"});
                                        }
                                    }
                                    else
                                    {
                                        if (ui.mcPopup.currentLabel == "MergeShop")
                                        {
                                            MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                                            MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                                        }
                                        else
                                        {
                                            if (ui.mcPopup.currentLabel == "Inventory")
                                            {
                                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                                                    "eventType":"refreshItems",
                                                    "sInstruction":"closeWindows"
                                                });
                                            }
                                        }
                                    }
                                }
                                world.updateQuestProgress("item", item);
                                if (item.sType == "Item")
                                {
                                    updateItemSkill();
                                }
                            }
                            break;
                        case "sellItem":
                            world.myAvatar.removeItem({
                                "CharItemID":resObj.CharItemID,
                                "iQty":resObj.iQty
                            });
                            if (resObj.bCoins == 1)
                            {
                                world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins + resObj.intAmount);
                            }
                            else
                            {
                                if (world.myAvatar.objData.intGold < 100000000)
                                {
                                    world.myAvatar.objData.intGold = (world.myAvatar.objData.intGold + resObj.intAmount);
                                    ui.mcInterface.mcGold.strGold.text = world.myAvatar.objData.intGold;
                                }
                            }
                            if (((ui.mcPopup.currentLabel == "Shop") || (ui.mcPopup.currentLabel == "HouseShop")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                                MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                    "eventType":"refreshItems",
                                    "sInstruction":"closeWindows"
                                });
                            }
                            else
                            {
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                                        "eventType":"refreshItems",
                                        "sInstruction":"closeWindows"
                                    });
                                }
                            }
                            world.checkAllQuestStatus();
                            break;
                        case "removeItem":
                            world.myAvatar.removeItem(resObj);
                            if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                            }
                            if (((ui.mcPopup.currentLabel == "Bank") || (ui.mcPopup.currentLabel == "HouseBank")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                            }
                            world.checkAllQuestStatus();
                            break;
                        case "updateClass":
                            isNewClass = true;
                            statsNewClass = true;
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (((!(avt == null)) && (!(avt.objData == null))))
                            {
                                avt.objData.strClassName = resObj.sClassName;
                                avt.objData.iCP = resObj.iCP;
                                avt.objData.sClassCat = resObj.sClassCat;
                                avt.updateRep();
                                if (resObj.uid == sfc.myUserId)
                                {
                                    if (("sDesc" in resObj))
                                    {
                                        avt.objData.sClassDesc = resObj.sDesc;
                                    }
                                    if (("sStats" in resObj))
                                    {
                                        avt.objData.sClassStats = resObj.sStats;
                                    }
                                    if (("aMRM" in resObj))
                                    {
                                        avt.objData.aClassMRM = resObj.aMRM;
                                    }
                                }
                            }
                            break;
                        case "equipItem":
                            avt = world.getAvatarByUserID(resObj.uid);
                            tLeaf = world.getUoLeafById(resObj.uid);
                            if (avt != null)
                            {
                                if (avt.isMyAvatar)
                                {
                                    sMeta = ((world.myAvatar.getItemByEquipSlot(resObj.strES)) ? world.myAvatar.getItemByEquipSlot(resObj.strES).sMeta : "");
                                    if (((sMeta) && (sMeta.length > 0)))
                                    {
                                        if (world.myAvatar.invLoaded)
                                        {
                                            avt.calculateIntoBoosts();
                                        }
                                    }
                                }
                                if (((!(avt.pMC == null)) && (!(avt.objData == null))))
                                {
                                    avt.objData.eqp[resObj.strES] = {};
                                    avt.objData.eqp[resObj.strES].sFile = ((resObj.sFile == "undefined") ? "" : resObj.sFile);
                                    avt.objData.eqp[resObj.strES].sLink = resObj.sLink;
                                    if (("sType" in resObj))
                                    {
                                        avt.objData.eqp[resObj.strES].sType = resObj.sType;
                                    }
                                    if (("ItemID" in resObj))
                                    {
                                        avt.objData.eqp[resObj.strES].ItemID = resObj.ItemID;
                                    }
                                    if (("sMeta" in resObj))
                                    {
                                        avt.objData.eqp[resObj.strES].sMeta = resObj.sMeta;
                                    }
                                    avt.loadMovieAtES(resObj.strES, resObj.sFile, resObj.sLink);
                                }
                                if (avt.isMyAvatar)
                                {
                                    avt.equipItem(resObj.ItemID);
                                    if (MovieClip(ui.mcPopup.getChildByName("mcInventory")) != null)
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                    }
                                    if (ui.mcPopup.mcTempInventory != null)
                                    {
                                        ui.mcPopup.mcTempInventory.mcItemList.refreshList();
                                        ui.mcPopup.mcTempInventory.refreshDetail();
                                    }
                                    if ((("sMeta" in resObj) && (String(resObj.sMeta).length > 0)))
                                    {
                                        if (world.myAvatar.invLoaded)
                                        {
                                            avt.calculateIntoBoosts();
                                        }
                                    }
                                }
                            }
                            break;
                        case "unequipItem":
                            avt = world.getAvatarByUserID(resObj.uid);
                            if (avt != null)
                            {
                                if (((!(avt.pMC == null)) && (resObj.bUnload)))
                                {
                                    delete avt.objData.eqp[resObj.strES];
                                    avt.unloadMovieAtES(resObj.strES);
                                }
                                if (avt.isMyAvatar)
                                {
                                    avt.unequipItem(resObj.ItemID);
                                    if (ui.mcPopup.currentLabel == "Inventory")
                                    {
                                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                    }
                                    if (ui.mcPopup.mcTempInventory != null)
                                    {
                                        ui.mcPopup.mcTempInventory.mcItemList.refreshList();
                                        ui.mcPopup.mcTempInventory.refreshDetail();
                                    }
                                    sMeta = ((world.myAvatar.getItemByID(resObj.ItemID)) ? world.myAvatar.getItemByID(resObj.ItemID).sMeta : "");
                                    if (((sMeta) && (sMeta.length > 0)))
                                    {
                                        if (world.myAvatar.invLoaded)
                                        {
                                            avt.calculateIntoBoosts();
                                        }
                                    }
                                }
                            }
                            break;
                        case "dropItem":
                            for (dID in resObj.items)
                            {
                                dItem = null;
                                if (world.invTree[dID] == null)
                                {
                                    world.invTree[dID] = copyObj(resObj.items[dID]);
                                    world.invTree[dID].iQty = 0;
                                    dItem = resObj.items[dID];
                                }
                                else
                                {
                                    dItem = copyObj(world.invTree[dID]);
                                    for (iData in resObj.items[dID])
                                    {
                                        if (resObj.items[dID][iData] != dItem[iData])
                                        {
                                            dItem[iData] = resObj.items[dID][iData];
                                            if (iData != "iQty")
                                            {
                                                world.invTree[dID][iData] = resObj.items[dID][iData];
                                            }
                                        }
                                    }
                                }
                                if (resObj.Wheel != null)
                                {
                                    try
                                    {
                                        ui.mcPopup.mcWheel.doWheelDrop(dItem);
                                    }
                                    catch(e)
                                    {
                                    }
                                }
                                else
                                {
                                    dItem.dID = dID;
                                    dItem.dQty = int(resObj.items[dID].iQty);
                                    isOK = true;
                                    if (litePreference.data.blackList)
                                    {
                                        for each (bItem in litePreference.data.blackList)
                                        {
                                            if (isNaN(parseInt(bItem.value)))
                                            {
                                                litePreference.data.blackList.splice(litePreference.data.blackList.indexOf(bItem.value), 1);
                                            }
                                            else
                                            {
                                                if (dItem.ItemID == parseInt(bItem.value))
                                                {
                                                    isOK = false;
                                                }
                                            }
                                        }
                                        litePreference.flush();
                                    }
                                    if (isOK)
                                    {
                                        showItemDrop(dItem, true);
                                    }
                                }
                            }
                            break;
                        case "referralReward":
                            for (dID in resObj.items)
                            {
                                dItem = null;
                                if (world.invTree[dID] == null)
                                {
                                    world.invTree[dID] = copyObj(resObj.items[dID]);
                                    world.invTree[dID].iQty = 0;
                                    dItem = resObj.items[dID];
                                }
                                else
                                {
                                    dItem = copyObj(world.invTree[dID]);
                                    dItem.iQty = int(resObj.items[dID].iQty);
                                }
                            }
                            dropItem = new DFrameMC(dItem);
                            ui.dropStack.addChild(dropItem);
                            dropItem.init();
                            dropItem.fY = (dropItem.y = -(dropItem.fHeight + 8));
                            dropItem.fX = (dropItem.x = -(dropItem.fWidth / 2));
                            cleanDropStack();
                            break;
                        case "getDrop":
                            i = 0;
                            while (i < ui.dropStack.numChildren)
                            {
                                mc = (ui.dropStack.getChildAt(i) as MovieClip);
                                if (((!(mc.fData == null)) && (mc.fData.ItemID == resObj.ItemID)))
                                {
                                    if (resObj.bSuccess == 1)
                                    {
                                        mc.gotoAndPlay("out");
                                    }
                                    else
                                    {
                                        modal = new ModalMC();
                                        modalO = {};
                                        modalO.strBody = "Item could not be added to your inventory! Please make sure your inventory is not full or the item is already present in your inventory/bank.";
                                        modalO.params = {};
                                        modalO.glow = "red,medium";
                                        modalO.btns = "mono";
                                        ui.ModalStack.addChild(modal);
                                        modal.init(modalO);
                                        mc.cnt.ybtn.mouseEnabled = true;
                                        mc.cnt.ybtn.mouseChildren = true;
                                    }
                                }
                                i = (i + 1);
                            }
                            if (resObj.bSuccess == 1)
                            {
                                dropitem = copyObj(world.invTree[resObj.ItemID]);
                                dropitem.CharItemID = resObj.CharItemID;
                                dropitem.bBank = resObj.bBank;
                                dropitem.iQty = int(resObj.iQty);
                                if (resObj.EnhID != null)
                                {
                                    dropitem.EnhID = int(resObj.EnhID);
                                    dropitem.EnhLvl = int(resObj.EnhLvl);
                                    dropitem.EnhPatternID = int(resObj.EnhPatternID);
                                    dropitem.EnhRty = int(resObj.EnhRty);
                                }
                                world.myAvatar.addItem(dropitem);
                                world.updateQuestProgress("item", dropitem);
                                if (resObj.showDrop == 1)
                                {
                                    showItemDrop(dropitem, false);
                                }
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                }
                                if (((ui.mcPopup.currentLabel == "Bank") || (ui.mcPopup.currentLabel == "HouseBank")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                                }
                                if ((((ui.mcPopup.currentLabel == "HouseShop") || (ui.mcPopup.currentLabel == "Shop")) || (ui.mcPopup.currentLabel == "MergeShop")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                                }
                                if (dropitem.sType == "Item")
                                {
                                    updateItemSkill();
                                }
                                if (resObj.pendingID != null)
                                {
                                    world.myAvatar.updatePending(int(resObj.pendingID));
                                }
                                if (((cDropsUI) && (litePreference.data.bCustomDrops)))
                                {
                                    cDropsUI.acceptDrop(dropitem);
                                }
                            }
                            break;
                        case "addItems":
                            for (ItemID in resObj.items)
                            {
                                if (world.invTree[ItemID] == null)
                                {
                                    itemObj = copyObj(resObj.items[ItemID]);
                                }
                                else
                                {
                                    itemObj = copyObj(world.invTree[ItemID]);
                                    for (iData in resObj.items[ItemID])
                                    {
                                        if (resObj.items[ItemID][iData] != itemObj[iData])
                                        {
                                            itemObj[iData] = resObj.items[ItemID][iData];
                                            if (iData != "iQty")
                                            {
                                                world.invTree[ItemID][iData] = resObj.items[ItemID][iData];
                                            }
                                        }
                                    }
                                }
                                showItemDrop(itemObj, false);
                                if (Number(itemObj.bTemp) == 0)
                                {
                                    world.myAvatar.addItem(itemObj);
                                }
                                else
                                {
                                    world.myAvatar.addTempItem(itemObj);
                                }
                                world.updateQuestProgress("item", itemObj);
                                if (itemObj.sMeta == "doUpdate")
                                {
                                    try
                                    {
                                        world.map.doUpdate();
                                    }
                                    catch(e)
                                    {
                                    }
                                }
                                if (itemObj.sType == "Item")
                                {
                                    updateItemSkill();
                                }
                                if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                                }
                                if (((ui.mcPopup.currentLabel == "Bank") || (ui.mcPopup.currentLabel == "HouseBank")))
                                {
                                    MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                                }
                            }
                            break;
                        case "Wheel":
                            if (resObj.hasOwnProperty("charItem1"))
                            {
                                dropItem = copyObj(resObj.dropItems["3"]); // BOOSTS
                                dropItem.CharItemID = resObj.charItem1;
                                if (world.invTree["3"] == null)
                                {
                                    dropItem.bBank = 0;
                                }
                                dropItem.iQty = ((resObj.dropQty != null) ? Number(resObj.dropQty) : 1);
                                world.myAvatar.addItem(dropItem);
                            }

                            if (resObj.hasOwnProperty("charItem2"))
                            {
                                dropItem = copyObj(resObj.dropItems["11"]); // POTION
                                dropItem.CharItemID = resObj.charItem2;
                                if (world.invTree["11"] == null)
                                {
                                    dropItem.bBank = 0;
                                }
                                dropItem.iQty = 1;
                                world.myAvatar.addItem(dropItem);
                            }

                            if (resObj.Item != null)
                            {
                                dropItem = copyObj(resObj.Item);
                                dropItem.CharItemID = resObj.CharItemID;
                                dropItem.bBank = 0;
                                dropItem.iQty = 1;
                                world.myAvatar.addItem(dropItem);
                            }
                            if (((ui.mcPopup.currentLabel == "Inventory") || (ui.mcPopup.currentLabel == "HouseInventory")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                            }
                            try
                            {
                                trace("CMD > Wheel");
                                ui.mcPopup.mcWheel.doWheelDrop(resObj.Item);
                            }
                            catch(e)
                            {
                                trace("CMD > Wheel > LAG LOOPING HERE!");
                                trace("Exception Message: " + e);
                            }
                        case "powerGem":
                            for (ItemID in resObj.items)
                            {
                                if (world.invTree[ItemID] == null)
                                {
                                    itemObj = copyObj(resObj.items[ItemID]);
                                }
                                else
                                {
                                    itemObj = copyObj(world.invTree[ItemID]);
                                    itemObj.iQty = int(resObj.items[ItemID].iQty);
                                }
                                showItemDrop(itemObj, false);
                                world.myAvatar.addItem(itemObj);
                            }
                            break;
                        case "forceAddItem":
                            for (fi in resObj.items)
                            {
                                iobj = copyObj(resObj.items[fi]);
                                world.myAvatar.addItem(iobj);
                            }
                            break;
                        case "warvalues":
                            world.map.updateWarValues(resObj.wars);
                            break;
                        case "turnIn":
                            if (((!(resObj.sItems == null)) && (resObj.sItems.length >= 3)))
                            {
                                itemArr = resObj.sItems.split(",");
                                dropindex = 0;
                                while (dropindex < itemArr.length)
                                {
                                    dropID = itemArr[dropindex].split(":")[0];
                                    dropQty = int(itemArr[dropindex].split(":")[1]);
                                    if (world.invTree[dropID].bTemp == 0)
                                    {
                                        world.myAvatar.removeItemByID(dropID, dropQty);
                                    }
                                    else
                                    {
                                        world.myAvatar.removeTempItem(dropID, dropQty);
                                    }
                                    dropindex++;
                                }
                            }
                            if (((ui.mcPopup.currentLabel == "HouseInventory") || (ui.mcPopup.currentLabel == "Inventory")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                            }
                            break;
                        case "getQuest":
                            break;
                        case "getQuests":
                            for (qi in resObj.quests)
                            {
                                if (world.questTree[qi] == null)
                                {
                                    o = resObj.quests[qi];
                                    world.questTree[qi] = o;
                                    for (qr in o.oReqd)
                                    {
                                        if (world.invTree[qr] == null)
                                        {
                                            world.invTree[qr] = o.oReqd[qr];
                                            world.invTree[qr].iQty = 0;
                                        }
                                    }
                                    for (qj in o.oItems)
                                    {
                                        if (world.invTree[qj] == null)
                                        {
                                            world.invTree[qj] = o.oItems[qj];
                                            world.invTree[qj].iQty = 0;
                                        }
                                    }
                                    qk = "";
                                    qat = ["itemsS", "itemsC", "itemsR", "itemsrand"];
                                    i = 0;
                                    while (i < qat.length)
                                    {
                                        s = qat[i];
                                        if (o.oRewards[s] != null)
                                        {
                                            for (ri in o.oRewards[s])
                                            {
                                                if (isNaN(ri))
                                                {
                                                    qk = ri.ItemID;
                                                }
                                                else
                                                {
                                                    qk = o.oRewards[s][ri].ItemID;
                                                }
                                                if (world.invTree[qk] == null)
                                                {
                                                    world.invTree[qk] = copyObj(o.oRewards[s][ri]);
                                                    world.invTree[qk].iQty = 0;
                                                }
                                            }
                                        }
                                        i = (i + 1);
                                    }
                                }
                            }
                            if (ui.ModalStack.numChildren > 0)
                            {
                                MovieClip(ui.ModalStack.getChildAt(0)).open();
                            }
                            break;
                        case "getQuests2":
                            for (qi in resObj.quests)
                            {
                                if (world.questTree[qi] == null)
                                {
                                    o = resObj.quests[qi];
                                    world.questTree[qi] = o;
                                    for (qr in o.oReqd)
                                    {
                                        if (world.invTree[qr] == null)
                                        {
                                            world.invTree[qr] = o.oReqd[qr];
                                            world.invTree[qr].iQty = 0;
                                        }
                                    }
                                    for (qj in o.oItems)
                                    {
                                        if (world.invTree[qj] == null)
                                        {
                                            world.invTree[qj] = o.oItems[qj];
                                            world.invTree[qj].iQty = 0;
                                        }
                                    }
                                    qk = "";
                                    qat = ["itemsS", "itemsC", "itemsR", "itemsrand"];
                                    i = 0;
                                    while (i < qat.length)
                                    {
                                        s = qat[i];
                                        if (o.oRewards[s] != null)
                                        {
                                            for (ri in o.oRewards[s])
                                            {
                                                if (isNaN(ri))
                                                {
                                                    qk = ri.ItemID;
                                                }
                                                else
                                                {
                                                    qk = o.oRewards[s][ri].ItemID;
                                                }
                                                if (world.invTree[qk] == null)
                                                {
                                                    world.invTree[qk] = copyObj(o.oRewards[s][ri]);
                                                    world.invTree[qk].iQty = 0;
                                                }
                                            }
                                        }
                                        i = (i + 1);
                                    }
                                }
                            }
                            createApop();
                            break;
                        case "ccqr":
                            if (resObj.bSuccess == 0)
                            {
                                if (((resObj.hasOwnProperty("msg")) && (!(resObj.msg == null))))
                                {
                                    MsgBox.notify(("Quest Complete Failed: " + resObj.msg));
                                }
                                else
                                {
                                    MsgBox.notify("Quest Complete Failed!");
                                }
                            }
                            else
                            {
                                if (("eventTrigger" in MovieClip(world.map)))
                                {
                                    world.map.eventTrigger({
                                        "cmd":"questComplete",
                                        "args":resObj.QuestID
                                    });
                                }
                                world.completeQuest(resObj.QuestID);
                                if (ui.ModalStack.numChildren)
                                {
                                    fgWin = ui.ModalStack.getChildAt(0);
                                    if (((!(fgWin == null)) && (fgWin.toString().indexOf("QFrameMC") > -1)))
                                    {
                                        fgWin.turninResult(resObj.QuestID);
                                    }
                                }
                                showQuestpopup(resObj);
                                if (apop_ != null)
                                {
                                    apop_.questComplete(int(resObj.QuestID));
                                }
                                if (world.rootClass.litePreference.data.bReaccept)
                                {
                                    if (world.questTree[resObj.QuestID])
                                    {
                                        if (world.questTree[resObj.QuestID].hasOwnProperty("bOnce"))
                                        {
                                            if (world.questTree[resObj.QuestID].bOnce > 0) break;
                                        }
                                        if (getQuestValidationString(world.questTree[resObj.QuestID]) == "")
                                        {
                                            world.acceptQuest(int(resObj.QuestID));
                                        }
                                    }
                                }
                            }
                            break;
                        case "updateQuest":
                            world.setQuestValue(resObj.iIndex, resObj.iValue);
                            break;
                        case "showQuestLink":
                            world.showQuestLink(resObj);
                            break;
                        case "dailylogin":
                            break;
                        case "initMonData":
                            for (m in resObj.mon)
                            {
                                world.updateMonster(resObj.mon[m]);
                            }
                            break;
                        case "aura+":
                        case "aura*":
                        case "aura-":
                        case "aura--":
                        case "aura++":
                        case "aura+p":
                            world.handleAuraEvent(cmd, resObj);
                            break;
                        case "clearAuras":
                            tAvt = world.myAvatar;
                            tLeaf = tAvt.dataLeaf;
                            world.showAuraChange({
                                "cmd":"aura-",
                                "auras":tLeaf.auras
                            }, tAvt, tLeaf);
                            tLeaf.auras = [];
                            break;
                        case "riftState":
                            updateRiftHUD(resObj);
                            break;
                        case "riftPanel":
                            if (aeraRiftPanel != null) aeraRiftPanel.update(resObj);
                            break;
                        case "riftPurchase":
                            if (aeraRiftPanel != null) aeraRiftPanel.purchaseResult(resObj);
                            if (resObj.ok && world != null) world.getInventory(sfc.myUserId);
                            break;
                        case "uotls":
                            userTreeWrite(resObj.unm, resObj.o);
                            break;
                        case "mtls":
                            monsterTreeWrite(resObj.id, resObj.o, resObj.targets);
                            break;
                        case "cb":
                            if (resObj.m != null)
                            {
                                for (updateID in resObj.m)
                                {
                                    monsterTreeWrite(int(updateID), resObj.m[updateID]);
                                }
                            }
                            if (resObj.p != null)
                            {
                                for (updateID in resObj.p)
                                {
                                    userTreeWrite(updateID, resObj.p[updateID]);
                                }
                            }
                            if (resObj.anims != null)
                            {
                                if (sfcSocial)
                                {
                                    for each (o in resObj.anims)
                                    {
                                        if (resObj.isProc)
                                        {
                                            doAnim(o, resObj.isProc);
                                        }
                                        else
                                        {
                                            doAnim(o);
                                        }
                                    }
                                }
                            }
                            if (resObj.a != null)
                            {
                                i = 0;
                                while (i < resObj.a.length)
                                {
                                    world.handleAuraEvent(resObj.a[i].cmd, resObj.a[i]);
                                    i = (i + 1);
                                }
                            }
                            break;
                        case "ct":
                            anim = {};
                            if (resObj.m != null)
                            {
                                for (updateID in resObj.m)
                                {
                                    monsterTreeWrite(int(updateID), resObj.m[updateID]);
                                }
                            }
                            if (resObj.p != null)
                            {
                                for (updateID in resObj.p)
                                {
                                    userTreeWrite(updateID, resObj.p[updateID]);
                                }
                            }
                            if (resObj.a != null)
                            {
                                j = 0;
                                while (j < resObj.a.length)
                                {
                                    try
                                    {
                                        k = 0;
                                        while (k < resObj.a[j].auras.length)
                                        {
                                            if (resObj.a[j].auras[k].spellOn != null)
                                            {
                                                anim[resObj.a[j].auras[k].spellOn] = resObj.a[j].auras[k].dur;
                                            }
                                            k++;
                                        }
                                    }
                                    catch(e)
                                    {
                                    }
                                    world.handleAuraEvent(resObj.a[j].cmd, resObj.a[j]);
                                    j = (j + 1);
                                }
                            }
                            if (resObj.sara != null)
                            {
                                for each (o in resObj.sara)
                                {
                                    world.handleSAR(o);
                                }
                            }
                            if (resObj.sarsa != null)
                            {
                                for each (o in resObj.sarsa)
                                {
                                    world.handleSARS(o);
                                }
                            }
                            if (resObj.anims != null)
                            {
                                if (sfcSocial)
                                {
                                    for each (o in resObj.anims)
                                    {
                                        if (resObj.isProc)
                                        {
                                            doAnim(o, resObj.isProc, anim[o.strl]);
                                        }
                                        else
                                        {
                                            doAnim(o, false, anim[o.strl]);
                                        }
                                    }
                                }
                            }
                            if (resObj.pvp != null)
                            {
                                switch (resObj.pvp.cmd)
                                {
                                    case "PVPS":
                                        updatePVPScore(resObj.pvp.pvpScore);
                                        break;
                                    case "PVPC":
                                        world.PVPResults.pvpScore = resObj.pvp.pvpScore;
                                        world.PVPResults.team = resObj.pvp.team;
                                        updatePVPScore(resObj.pvp.pvpScore);
                                        togglePVPPanel("results");
                                        break;
                                }
                            }
                            if (((world.myAvatar.objData.eqp["pe"]) && (world.rootClass.litePreference.data.bBattlepet)))
                            {
                                for each (bpObj in resObj.anims)
                                {
                                    if (((bpObj.tInf.indexOf("m:") > -1) && (bpObj.cInf.indexOf("p:") > -1)))
                                    {
                                        if (world.getAvatarByUserID(Number(bpObj.cInf.split(":")[1])).isMyAvatar)
                                        {
                                            if (bpObj.animStr == world.actions.active[0].anim)
                                            {
                                                world.myAvatar.pMC.queueAnim("PetAttack");
                                            }
                                        }
                                    }
                                }
                            }
                            if (litePreference.data.bAuras)
                            {
                                pAurasUI.handleAura(resObj);
                                tAurasUI.handleAura(resObj);
                            }
                            break;
                        case "sar":
                            world.handleSAR(resObj);
                            break;
                        case "sars":
                            world.handleSARS(resObj);
                            break;
                        case "showAuraResult":
                            world.showAuraImpact(resObj);
                            break;
                        case "anim":
                            if (sfcSocial)
                            {
                                doAnim(resObj);
                            }
                            break;
                        case "sAct":
                            if (isNewClass)
                            {
                                oldActions = null;
                                if (((!(world.actions == null)) && (!(world.actions.active == null))))
                                {
                                    for each (actObj in world.actions.active)
                                    {
                                        if (actObj != null)
                                        {
                                            if (actObj.ref == "i1")
                                            {
                                                oldActions = copyObj(actObj);
                                            }
                                        }
                                    }
                                }
                                world.actions = {};
                                world.actions.active = ((oldActions != null) ? [null, null, null, null, null, oldActions] : []);
                                world.actions.passive = [];
                                world.actionMap = [null, null, null, null, null, world.actionMap[5]];
                                blanki = 0;
                                while (blanki < 5)
                                {
                                    ui.mcInterface.actBar.getChildByName(("blank" + blanki)).visible = true;
                                    actBar = ui.mcInterface.actBar;
                                    delIcon = actBar.getChildByName(("i" + (blanki + 1)));
                                    if (delIcon != null)
                                    {
                                        delIcon.removeEventListener(MouseEvent.CLICK, actIconClick);
                                        delIcon.removeEventListener(MouseEvent.MOUSE_OVER, actIconOver);
                                        delIcon.removeEventListener(MouseEvent.MOUSE_OUT, actIconOut);
                                        if (delIcon.icon2 != null)
                                        {
                                            delIcon.removeEventListener(Event.ENTER_FRAME, world.countDownAct);
                                            if (delIcon.icon2.mask != null)
                                            {
                                                actBar.removeChild(delIcon.icon2.mask);
                                                delIcon.icon2.mask = null;
                                            }
                                            actBar.removeChild(delIcon.icon2);
                                        }
                                        actBar.removeChild(delIcon);
                                    }
                                    ui.mcInterface.actBar.getChildByName(("txtCD" + blanki)).visible = false;
                                    ui.mcInterface.actBar.getChildByName(("txtCD" + blanki)).mouseEnabled = false;
                                    blanki++;
                                }
                            }
                            updateCtr = resObj.actions.active.length;
                            if (world.actions.active[5] != null)
                            {
                                updateCtr = (updateCtr - 1);
                                delIcon = ui.mcInterface.actBar.getChildByName("i6");
                                if (delIcon)
                                {
                                    if (delIcon.icon2 != null)
                                    {
                                        delIcon.ts = 0;
                                    }
                                    delIcon.actObj = world.actions.active[5];
                                }
                                world.actions.active[5].ts = 0;
                                world.lockdownPots = false;
                            }
                            ai = 0;
                            slot = 0;
                            ai = 0;
                            while (ai < updateCtr)
                            {
                                actObj = resObj.actions.active[ai];
                                pseudoAI = ((actObj.ref == "i1") ? 5 : ai);
                                if (!isNewClass)
                                {
                                    isNotUnlocked = (ui.mcInterface.actBar.getChildByName(("i" + (pseudoAI + 1))).cnt.transform.colorTransform.toString().indexOf("0.09765625") > -1);
                                    if (((resObj.actions.active[pseudoAI].isOK) && (isNotUnlocked)))
                                    {
                                        existing = ui.mcInterface.actBar.getChildByName(("i" + (pseudoAI + 1)));
                                        existing.addEventListener(MouseEvent.CLICK, actIconClick, false, 0, true);
                                        existing.buttonMode = true;
                                        existing.cnt.transform.colorTransform = new ColorTransform();
                                        world.getActionByRef(world.actionMap[pseudoAI]).isOK = true;
                                    }
                                }
                                else
                                {
                                    actObj.sArg1 = "";
                                    actObj.sArg2 = "";
                                    world.actions.active[pseudoAI] = actObj;
                                    actObj.ts = 0;
                                    actObj.actID = -1;
                                    actObj.lock = false;
                                    world.actionMap[pseudoAI] = actObj.ref;
                                    actIconClass = (getDefinitionByName("ib2") as Class);
                                    actIcon = new (actIconClass)();
                                    actIconMC = ui.mcInterface.actBar.addChild(actIcon);
                                    slot = ((ai < (resObj.actions.active.length - 1)) ? ai : 5);
                                    blankMC = ui.mcInterface.actBar.getChildByName(("blank" + slot));
                                    actIconMC.x = blankMC.x;
                                    actIconMC.width = 42;
                                    actIconMC.height = 39;
                                    actIconMC.name = String(("i" + (pseudoAI + 1)));
                                    actIconMC.actionIndex = pseudoAI;
                                    actIconMC.actObj = actObj;
                                    actIconMC.icon2 = null;
                                    actIconMC.tQty.visible = false;
                                    actIconMC.y = (actIconMC.y - 6);
                                    updateIcons([actIconMC], actObj.icon.split(","), null);
                                    blankMC.visible = false;
                                    actIconMC.addEventListener(MouseEvent.MOUSE_OVER, actIconOver, false, 0, true);
                                    actIconMC.addEventListener(MouseEvent.MOUSE_OUT, actIconOut, false, 0, true);
                                    actIconMC.mouseChildren = false;
                                    if (((!(actObj.auto == null)) && (actObj.auto == true)))
                                    {
                                        world.actions.auto = world.actions.active[pseudoAI];
                                    }
                                    else
                                    {
                                        world.actions.active[pseudoAI].auto = false;
                                    }
                                    if (actObj.isOK)
                                    {
                                        actIconMC.addEventListener(MouseEvent.CLICK, actIconClick, false, 0, true);
                                        actIconMC.buttonMode = true;
                                    }
                                    else
                                    {
                                        c = new Color();
                                        c.setTint(0x333333, 0.9);
                                        actIconMC.cnt.transform.colorTransform = c;
                                    }
                                }
                                ai = (ai + 1);
                            }
                            world.myAvatar.dataLeaf.passives = [];
                            if (resObj.actions.passive != null)
                            {
                                ai = 0;
                                while (ai < resObj.actions.passive.length)
                                {
                                    actObj = copyObj(resObj.actions.passive[ai]);
                                    actObj.sArg1 = "";
                                    actObj.sArg2 = "";
                                    world.actions.passive.push(actObj);
                                    if (actObj.auras != null)
                                    {
                                        i = 0;
                                        while (i < actObj.auras.length)
                                        {
                                            world.myAvatar.dataLeaf.passives.push(actObj.auras[i]);
                                            i = (i + 1);
                                        }
                                    }
                                    ai = (ai + 1);
                                }
                            }
                            if (litePreference.data.bAuras)
                            {
                                pAurasUI.classChanged();
                                tAurasUI.classChanged();
                            }
                            isNewClass = false;
                            break;
                        case "seia":
                            if (resObj.iRes == 1)
                            {
                                ai = 0;
                                while (ai < world.actions.active.length)
                                {
                                    o = world.actions.active[ai];
                                    if (o)
                                    {
                                        if (o.ref == "i1")
                                        {
                                            if (("tgtMax" in o))
                                            {
                                                delete o.tgtMax;
                                            }
                                            if (("tgtMin" in o))
                                            {
                                                delete o.tgtMin;
                                            }
                                            if (("auras" in o))
                                            {
                                                delete o.auras;
                                            }
                                            if (!world.actionTimeCheck(o, true))
                                            {
                                                if (o.OldCD == null)
                                                {
                                                    o.OldCD = o.cd;
                                                }
                                            }
                                            else
                                            {
                                                if (world.actionTimeCheck(o, true))
                                                {
                                                    o.ts = 0;
                                                }
                                            }
                                            for (s in resObj.o)
                                            {
                                                if (((((!(s == "nam")) && (!(s == "ref"))) && (!(s == "desc"))) && (!(s == "typ"))))
                                                {
                                                    o[s] = resObj.o[s];
                                                }
                                            }
                                            world.lockdownPots = false;
                                        }
                                    }
                                    ai = (ai + 1);
                                }
                            }
                            if (equipPotionOnSeia)
                            {
                                world.testAction(world.getActionByRef(world.actionMap[5]));
                                equipPotionOnSeia = false;
                            }
                            break;
                        case "stu":
                            avt = world.myAvatar;
                            unm = sfc.myUserName;
                            uoLeaf = world.uoTreeLeaf(unm);
                            // Current Aera emulator includes the persistent users_stats data
                            // in every derived-stat packet. Keep it on Avatar.objData so the
                            // FLA stat-point panel can open with the database values immediately.
                            syncAeraStatPointData(resObj.statPoints, resObj.allocatedStats, false);

                            // Aera live-stat sync: a relog rebuilds BOTH Avatar.objData and the
                            // uo/data leaf. The old live STU path only refreshed the leaf, which
                            // left parts of the active avatar on the pre-save values until relog.
                            // Mirror the authoritative server packet into both runtime views now.
                            if (resObj.intHP != null)
                            {
                                uoLeaf.intHP = int(resObj.intHP);
                                if (avt != null && avt.objData != null) avt.objData.intHP = int(resObj.intHP);
                            }
                            if (resObj.intHPMax != null)
                            {
                                uoLeaf.intHPMax = int(resObj.intHPMax);
                                if (avt != null && avt.objData != null) avt.objData.intHPMax = int(resObj.intHPMax);
                            }
                            if (resObj.intMP != null)
                            {
                                uoLeaf.intMP = int(resObj.intMP);
                                if (avt != null && avt.objData != null) avt.objData.intMP = int(resObj.intMP);
                            }
                            if (resObj.intMPMax != null)
                            {
                                uoLeaf.intMPMax = int(resObj.intMPMax);
                                if (avt != null && avt.objData != null) avt.objData.intMPMax = int(resObj.intMPMax);
                            }
                            if (resObj.intState != null)
                            {
                                uoLeaf.intState = int(resObj.intState);
                                if (avt != null && avt.objData != null) avt.objData.intState = int(resObj.intState);
                            }
                            if (resObj.wDPS != null)
                            {
                                uoLeaf.wDPS = Number(resObj.wDPS);
                                if (avt != null && avt.objData != null) avt.objData.wDPS = Number(resObj.wDPS);
                            }
                            if (resObj.mDPS != null)
                            {
                                uoLeaf.mDPS = Number(resObj.mDPS);
                                if (avt != null && avt.objData != null) avt.objData.mDPS = Number(resObj.mDPS);
                            }
                            if (uoLeaf.sta == null)
                            {
                                uoLeaf.sta = {};
                            }
                            for (stuS in resObj.sta)
                            {
                                uoLeaf.sta[stuS] = resObj.sta[stuS];
                                if (stats.indexOf(stuS.substr(1)) > -1)
                                {
                                    uoLeaf.sta[stuS] = int(uoLeaf.sta[stuS]);
                                }
                                else
                                {
                                    uoLeaf.sta[stuS] = Number(uoLeaf.sta[stuS]);
                                }
                                if (stuS.toLowerCase().indexOf("$tha") > -1)
                                {
                                    actObj = world.getAutoAttack();
                                    if ((((!(actObj == null)) && (!(uoLeaf == null))) && (!(uoLeaf.sta == null))))
                                    {
                                        cd = Math.round((actObj.cd * (1 - Math.min(Math.max(uoLeaf.sta.$tha, -1), 0.5))));
                                        if (world.autoActionTimer.running)
                                        {
                                            world.autoActionTimer.delay = (world.autoActionTimer.delay - (world.autoActionTimer.delay - cd));
                                            world.autoActionTimer.delay = (world.autoActionTimer.delay + 100);
                                            world.autoActionTimer.reset();
                                            world.autoActionTimer.start();
                                        }
                                        else
                                        {
                                            world.autoActionTimer.delay = cd;
                                        }
                                    }
                                    hasteCoeff = (1 - Math.min(Math.max(uoLeaf.sta.$tha, -1), 0.5));
                                    world.GCD = Math.round((hasteCoeff * world.GCDO));
                                    // Aera: the stat packet can beat action/class initialization.
                                    // Only refresh action cooldowns after actions.active exists.
                                    if (((world.actions != null) && (world.actions.active != null)))
                                    {
                                        for each (actObj in world.actions.active)
                                        {
                                            if (actObj != null)
                                            {
                                                if (((((actObj.isOK) && (!(world.getActIcons(actObj)[0] == null))) && (world.getActIcons(actObj)[0].icon2 == null)) && ((now - actObj.ts) < (actObj.cd * hasteCoeff))))
                                                {
                                                    world.coolDownAct(actObj, ((actObj.cd * hasteCoeff) - (now - actObj.ts)), now);
                                                }
                                            }
                                        }
                                    }
                                }
                                if (stuS.toLowerCase().indexOf("$cmc") > -1)
                                {
                                    world.updateActBar();
                                }
                            }
                            // Keep the derived stat table visible from Avatar.objData too.
                            // Some legacy AQW paths read objData while combat/action UI reads
                            // dataLeaf, so both must change in the same frame.
                            if (avt != null && avt.objData != null)
                            {
                                avt.objData.sta = uoLeaf.sta;
                            }
                            if (resObj.tempSta != null)
                            {
                                uoLeaf.tempSta = resObj.tempSta;
                                if (avt != null && avt.objData != null) avt.objData.tempSta = resObj.tempSta;
                                if (((world.map != null) && ("updatePStats" in world.map)))
                                {
                                    world.map.updatePStats();
                                }
                            }

                            // Refresh mana-cost/action availability after the WHOLE authoritative
                            // stat packet has been installed, rather than depending on field order.
                            world.updateActBar();
                            if (avt != null)
                            {
                                world.updatePortrait(avt);
                            }
                            if (statsNewClass)
                            {
                                baseClassStats = {};
                                for (stu in resObj.sta)
                                {
                                    baseClassStats[stu] = resObj.sta[stu];
                                }
                                if (mcStatsPanel)
                                {
                                    mcStatsPanel.updateBase();
                                }
                                statsNewClass = false;
                            }
                            if (mcStatsPanel)
                            {
                                mcStatsPanel.update();
                            }
                            break;
                        case "saveStatPoints":
                        case "resetStatPoints":
                        case "spendStatPoints":
                            // Save/reset acknowledgements contain the authoritative users_stats
                            // row. Clear staged +/- edits only after the server answers.
                            syncAeraStatPointData(resObj.Points, resObj.allocatedStats, true);
                            if (!aeraStatResponseSucceeded(resObj) && resObj.msg != null)
                            {
                                MsgBox.notify(String(resObj.msg));
                            }
                            break;
                        case "event":
                            world.map.eventTrigger(resObj);
                            break;
                        case "modinfo":
                            world.map.showModInfo(resObj);
                            break;
                        case "modinc":
                            if (resObj.bSuccess)
                            {
                                world.map.hideLoading();
                                world.map.show(resObj.events);
                                world.modID = int(resObj.mID);
                            }
                            else
                            {
                                chatF.pushMsg("warning", resObj.msg, "SERVER", "", 0);
                            }
                            break;
                        case "ia":
                            if (("iaPathMC" in resObj))
                            {
                                try
                                {
                                    mc = world;
                                    mcPath = resObj.iaPathMC.split(".");
                                    while (mcPath.length > 0)
                                    {
                                        s = String(mcPath.shift());
                                        if (mc.getChildByName(s) != null)
                                        {
                                            mc = (mc.getChildByName(s) as MovieClip);
                                        }
                                        else
                                        {
                                            mc = mc[s];
                                        }
                                    }
                                }
                                catch(e:Error)
                                {
                                }
                            }
                            else
                            {
                                if (resObj.str != null)
                                {
                                    avt = world.getAvatarByUserID(int(resObj.str));
                                    if (avt != null)
                                    {
                                        mc = avt.pMC;
                                    }
                                }
                                else
                                {
                                    mc = MovieClip(world.CHARS.getChildByName(resObj.oName));
                                }
                            }
                            if (((!(mc == null)) && (!(mc == world))))
                            {
                                try
                                {
                                    switch (resObj.typ)
                                    {
                                        case "rval":
                                            mc.userName = resObj.unm;
                                            mc.iaF(resObj);
                                            break;
                                        case "str":
                                            if (resObj.str == null)
                                            {
                                                mc.userName = resObj.unm;
                                            }
                                            mc.iaF(resObj);
                                            break;
                                        case "flourish":
                                            mc.userName = resObj.unm;
                                            mc.gotoAndPlay(resObj.oFrame);
                                            break;
                                    }
                                }
                                catch(e:Error)
                                {
                                }
                            }
                            break;
                        case "siau":
                            world.updateCellMap(resObj);
                            break;
                        case "umsg":
                            addUpdate(resObj.s);
                            break;
                        case "gi":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (((resObj.owner + " has invited you to join the guild ") + resObj.gName) + ". Do you accept?");
                            modalO.callback = world.doGuildAccept;
                            modalO.params = {
                                "guildID":resObj.guildID,
                                "owner":resObj.owner
                            };
                            modalO.btns = "dual";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            chatF.pushMsg("server", ((resObj.owner + " has invited you to join the guild ") + resObj.gName), "SERVER", "", 0);
                            break;
                        case "gd":
                            chatF.pushMsg("server", (resObj.unm + " has declined your invitation."), "SERVER", "", 0);
                            break;
                        case "ga":
                            avt = world.getAvatarByUserName(resObj.unm);
                            if (avt != null)
                            {
                                avt.updateGuild(resObj.guild);
                                if (avt.isMyAvatar)
                                {
                                    chatF.chn.guild.act = 1;
                                    chatF.pushMsg("server", "You have joined the guild.", "SERVER", "", 0);
                                }
                                else
                                {
                                    if (world.myAvatar.objData.guild.Name == avt.objData.guild.Name)
                                    {
                                        chatF.pushMsg("server", (avt.pnm + " has joined the guild."), "SERVER", "", 0);
                                        world.myAvatar.updateGuild(resObj.guild);
                                    }
                                }
                            }
                            else
                            {
                                if (resObj.guild.Name == world.myAvatar.objData.guild.Name)
                                {
                                    chatF.pushMsg("server", (resObj.unm + " has joined the guild."), "SERVER", "", 0);
                                    world.myAvatar.updateGuild(resObj.guild);
                                }
                            }
                            break;
                        case "gr":
                            avt = world.getAvatarByUserName(resObj.unm);
                            if (avt != null)
                            {
                                avt.updateGuild(null);
                                if (avt.isMyAvatar)
                                {
                                    chatF.chn.guild.act = 0;
                                    chatF.pushMsg("server", "You have been removed from the guild.", "SERVER", "", 0);
                                }
                                else
                                {
                                    if (world.myAvatar.objData.guild.Name == avt.objData.guild.Name)
                                    {
                                        chatF.pushMsg("server", (avt.pnm + " has been removed from the guild."), "SERVER", "", 0);
                                        world.myAvatar.updateGuild(resObj.guild);
                                    }
                                }
                            }
                            if (world.myAvatar.objData.guild != null)
                            {
                                if (world.myAvatar.objData.guild.Name == resObj.guild.Name)
                                {
                                    chatF.pushMsg("server", (resObj.unm + " has been removed from the guild."), "SERVER", "", 0);
                                    world.myAvatar.updateGuild(resObj.guild);
                                }
                            }
                            break;
                        case "guildDelete":
                            avt = world.getAvatarByUserName(resObj.unm);
                            if (avt != null)
                            {
                                avt.updateGuild(null);
                                if (avt.isMyAvatar)
                                {
                                    chatF.pushMsg("server", resObj.msg, "SERVER", "", 0);
                                }
                            }
                            break;
                        case "gMOTD":
                            world.myAvatar.objData.guild.MOTD = resObj.MOTD[0];
                            break;
                        case "updateGuild":
                            try
                            {
                                if (world.myAvatar.objData != null)
                                {
                                    world.myAvatar.updateGuild(resObj.guild);
                                }
                            }
                            catch(e)
                            {
                            }
                            if (resObj.msg != null)
                            {
                                chatF.pushMsg("server", resObj.msg, "SERVER", "", 0);
                            }
                            break;
                        case "startTrade":
                            toggleTradePanel(resObj.userid);
                            world.tradeinfo = {
                                itemsA:[],
                                itemsB:[],
                                hasRequested:{}
                            };
                            break;
                        case "ti":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (resObj.owner + " has requested you to trade. Do you accept?");
                            modalO.callback = world.doTradeAccept;
                            modalO.params = {unm:resObj.owner};
                            modalO.btns = "dual";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            chatF.pushMsg("server", (resObj.owner + " has requested you to trade."), "SERVER", "", 0);
                            break;
                        case "gc":
                            avt = world.getAvatarByUserID(resObj.uid);
                            avt.initGuild(resObj.guild);
                            break;
                        case "interior":
                            break;
                        case "guildhall":
                            break;
                        case "guildinv":
                            break;
                        case "pi":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (resObj.owner + " has invited you to join their group.  Do you accept?");
                            modalO.callback = world.doPartyAccept;
                            modalO.params = {"pid":resObj.pid};
                            modalO.btns = "dual";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            chatF.pushMsg("server", (resObj.owner + " has invited you to a group."), "SERVER", "", 0);
                            break;
                        case "pa":
                            if (world.partyOwner == "")
                            {
                                world.partyOwner = resObj.owner;
                            }
                            supressMupltiples = false;
                            if (world.partyID == -1)
                            {
                                world.partyID = resObj.pid;
                                chatF.chn.party.act = 1;
                                if (resObj.owner.toLowerCase() != sfc.myUserName)
                                {
                                    chatF.pushMsg("server", "You have joined the party.", "SERVER", "", 0);
                                    supressMupltiples = true;
                                }
                            }
                            i = 0;
                            while (i < resObj.ul.length)
                            {
                                unm = resObj.ul[i];
                                if (unm.toLowerCase() != sfc.myUserName)
                                {
                                    world.addPartyMember(unm);
                                    if (!supressMupltiples)
                                    {
                                        chatF.pushMsg("server", (unm + " has joined the party."), "SERVER", "", 0);
                                    }
                                }
                                i = (i + 1);
                            }
                            break;
                        case "pr":
                            isYou = false;
                            nam = world.partyOwner;
                            world.partyOwner = resObj.owner;
                            if (nam != world.partyOwner)
                            {
                                chatF.pushMsg("server", (world.partyOwner + " is now the party leader."), "SERVER", "", 0);
                            }
                            if (resObj.unm.toLowerCase() == sfc.myUserName.toLowerCase())
                            {
                                isYou = true;
                                chatF.chn.party.act = 0;
                            }
                            if (resObj.typ == "k")
                            {
                                if (isYou)
                                {
                                    chatF.pushMsg("server", "You have been removed from the party", "SERVER", "", 0);
                                }
                                else
                                {
                                    chatF.pushMsg("server", (resObj.unm + " has been removed from the party"), "SERVER", "", 0);
                                }
                            }
                            else
                            {
                                if (resObj.typ == "l")
                                {
                                    if (isYou)
                                    {
                                        chatF.pushMsg("server", "You have left the party", "SERVER", "", 0);
                                    }
                                    else
                                    {
                                        chatF.pushMsg("server", (resObj.unm + " has left the party"), "SERVER", "", 0);
                                    }
                                }
                            }
                            world.removePartyMember(String(resObj.unm).toLowerCase());
                            break;
                        case "pp":
                            nam = world.partyOwner;
                            world.partyOwner = resObj.owner;
                            if (nam != world.partyOwner)
                            {
                                chatF.pushMsg("server", (world.partyOwner + " is now the party leader."), "SERVER", "", 0);
                            }
                            world.updatePartyFrame();
                            break;
                        case "ps":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (resObj.unm + " wants to summon you to them.  Do you accept?");
                            modalO.callback = world.acceptPartySummon;
                            modalO.params = resObj;
                            modalO.btns = "dual";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            chatF.pushMsg("server", (resObj.unm + " is trying to summon you to them."), "SERVER", "", 0);
                            break;
                        case "pd":
                            chatF.pushMsg("server", (resObj.unm + " has declined your invitation."), "SERVER", "", 0);
                            break;
                        case "pc":
                            if (world.partyID > -1)
                            {
                                chatF.pushMsg("server", "Your party has been disbanded", "SERVER", "", 0);
                            }
                            world.partyID = -1;
                            world.partyOwner = "";
                            world.partyMembers = [];
                            world.updatePartyFrame();
                            chatF.chn.party.act = 0;
                            if (chatF.chn.cur == chatF.chn.party)
                            {
                                chatF.chn.cur = chatF.chn.zone;
                            }
                            if (chatF.chn.lastPublic == chatF.chn.party)
                            {
                                chatF.chn.lastPublic = chatF.chn.zone;
                            }
                            break;
                        case "PVPQ":
                            world.handlePVPQueue(resObj);
                            break;
                        case "PVPI":
                            world.receivePVPInvite(resObj);
                            break;
                        case "PVPE":
                            relayPVPEvent(resObj);
                            break;
                        case "PVPS":
                            updatePVPScore(resObj.pvpScore);
                            break;
                        case "PVPC":
                            world.PVPResults.pvpScore = resObj.pvpScore;
                            world.PVPResults.team = resObj.team;
                            updatePVPScore(resObj.pvpScore);
                            togglePVPPanel("results");
                            break;
                        case "pvpbreakdown":
                            break;
                        case "di":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (resObj.owner + " has challenged you to a duel.  Do you accept?");
                            modalO.callback = world.doDuelAccept;
                            modalO.params = {"unm":resObj.owner};
                            modalO.btns = "dual";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            chatF.pushMsg("server", (resObj.owner + " has challenged you to a duel."), "SERVER", "", 0);
                            break;
                        case "DuelEX":
                            world.duelExpire();
                            break;
                        case "loadFactions":
                            world.myAvatar.initFactions(resObj.factions);
                            break;
                        case "addFaction":
                            world.myAvatar.addFaction(resObj.faction);
                            break;
                        case "loadFriendsList":
                            world.myAvatar.initFriendsList(resObj.friends);
                            break;
                        case "requestFriend":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.strBody = (resObj.unm + " has invited you to be friends. Do you accept?");
                            modalO.callback = world.addFriend;
                            modalO.params = {
                                "ID":resObj.ID,
                                "unm":resObj.unm
                            };
                            modalO.btns = "dual";
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            chatF.pushMsg("server", (resObj.unm + " has invited you to be friends."), "SERVER", "", 0);
                            break;
                        case "addFriend":
                            world.myAvatar.addFriend(resObj.friend);
                            break;
                        case "updateFriend":
                            world.myAvatar.updateFriend(resObj.friend);
                            break;
                        case "deleteFriend":
                            world.myAvatar.deleteFriend(resObj.ID);
                            break;
                        case "isModerator":
                            modal = null;
                            modalO = null;
                            modal = new ModalMC();
                            modalO = {};
                            modalO.btns = "mono";
                            if (resObj.val)
                            {
                                modalO.strBody = (resObj.unm + " is staff!");
                                modalO.glow = "gold,medium";
                                chatF.pushMsg("server", (resObj.unm + " is staff!"), "SERVER", "", 0);
                            }
                            else
                            {
                                modalO.strBody = (resObj.unm + " is NOT staff!");
                                modalO.glow = "red,medium";
                                chatF.pushMsg("warning", (resObj.unm + " is NOT staff!"), "SERVER", "", 0);
                            }
                            ui.ModalStack.addChild(modal);
                            modal.init(modalO);
                            break;
                        case "loadWarVars":
                            world.objResponse["loadWarVars"] = resObj;
                            world.dispatchEvent(new Event("loadWarVars"));
                            break;
                        case "setAchievement":
                            world.updateAchievement(resObj.field, resObj.index, resObj.value);
                            break;
                        case "loadQuestStringData":
                            world.objQuestString = resObj.obj;
                            world.dispatchEvent(new Event("QuestStringData_Complete"));
                            break;
                        case "getAdData":
                            if (resObj.bSuccess == 1)
                            {
                                world.adData = resObj.bh;
                                world.dispatchEvent(new Event("getAdData"));
                            }
                            break;
                        case "getAdReward":
                            world.myAvatar.objData.iDailyAds = (world.myAvatar.objData.iDailyAds + 1);
                            world.adData = null;
                            if (world.myAvatar.objData.iDailyAds < world.myAvatar.objData.iDailyAdCap)
                            {
                                world.sendGetAdDataRequest();
                            }
                            world.myAvatar.objData.intGold = (world.myAvatar.objData.intGold + int(resObj.iGold));
                            ui.mcInterface.mcGold.strGold.text = world.myAvatar.objData.intGold;
                            if (((ui.mcPopup.currentLabel == "HouseInventory") || (ui.mcPopup.currentLabel == "Inventory")))
                            {
                                MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                            }
                            world.myAvatar.objData.intCoins = (world.myAvatar.objData.intCoins + int(resObj.iCoins));
                            sMsg = (("Congratulations! You just received <font color='#FFCC00'><b>" + resObj.iGold) + " Gold</b></font>");
                            if (resObj.iCoins > 0)
                            {
                                sMsg = (sMsg + ((" and <font color='#990099'><b>" + resObj.iCoins) + " Adventure Coins</b></font>"));
                            }
                            sMsg = (sMsg + " from Ballyhoo.");
                            showMessageBox(sMsg);
                            break;
                        case "xpboost":
                            manageXPBoost(resObj);
                            break;
                        case "gboost":
                            manageGBoost(resObj);
                            break;
                        case "repboost":
                            manageRepBoost(resObj);
                            break;
                        case "cpboost":
                            manageCPBoost(resObj);
                            break;
                        case "gettimes":
                            a = [];
                            for (s in resObj.o)
                            {
                                o = resObj.o[s];
                                o.s = s;
                                a.push(o);
                            }
                            a.sortOn("t", (Array.NUMERIC | Array.DESCENDING));
                            i = 0;
                            while (i < a.length)
                            {
                                o = a[i];
                                i = (i + 1);
                            }
                            break;
                        case "clockTick":
                            if (("eventTrigger" in MovieClip(world.map)))
                            {
                                world.map.eventTrigger(resObj);
                            }
                            break;
                        case "castWait":
                            try
                            {
                                world.map.fishGame.castingWait(resObj.wait, resObj.derp);
                            }
                            catch(e)
                            {
                            }
                            break;
                        case "CatchResult":
                            world.myAvatar.addRep(20, resObj.catchResult.myRep);
                            try
                            {
                                world.map.fishGame.showCatch(resObj);
                            }
                            catch(e)
                            {
                            }
                            break;
                        case "alchOnStart":
                            world.map.alchemyGame.onStart(resObj);
                            break;
                        case "alchComplete":
                            world.map.alchemyGame.checkComplete(resObj);
                            break;
                        case "spellOnStart":
                            world.map.mcGame.spellOnStart(resObj);
                            break;
                        case "spellComplete":
                            world.map.mcGame.spellComplete(resObj);
                            break;
                        case "spellWaitTimer":
                            world.map.mcGame.spellWaitTimer(resObj);
                            break;
                        case "playerDeath":
                            if (("eventTrigger" in MovieClip(world.map)))
                            {
                                world.map.eventTrigger(resObj);
                            }
                            break;
                        case "getScrolls":
                            try
                            {
                                world.scrollData = resObj.scrolls;
                                world.map.initScrollData();
                            }
                            catch(e)
                            {
                            }
                            break;
                        case "turninscroll":
                            if (resObj.IDs != null)
                            {
                                i = 0;
                                while (i < resObj.IDs.length)
                                {
                                    world.myAvatar.updateScrolls(int(resObj.IDs[i]));
                                    i = (i + 1);
                                }
                                s = "";
                                i = 0;
                                while (i < 500)
                                {
                                    s = (s + String.fromCharCode(0));
                                    i = (i + 1);
                                }
                                world.myAvatar.objData.pending = s;
                                try
                                {
                                    world.map.displayTurnins(resObj.IDs);
                                }
                                catch(e)
                                {
                                }
                            }
                            break;
                        case "getapop":
                            if (resObj.apopData != null)
                            {
                                apopTree[String(resObj.apopData.apopID)] = resObj.apopData;
                                if (!resObj.bQuests)
                                {
                                    createApop();
                                }
                            }
                            break;
                        case "loadTitles":
                            if (resObj.success)
                            {
                                ui.mcPopup.mcTitles.data = resObj.lists;
                                ui.mcPopup.mcTitles.initLists();
                            }
                            break;
                        case "updateTitle":
                            if (!resObj.success) return;

                            avt = world.getAvatarByUserID(int(resObj.uid));

                            if (avt != null) {
                                switch (resObj.type) {
                                    case "equip":
                                        avt.pMC.pname.tt.text = resObj.title.Name;
                                        avt.pMC.pname.tt.textColor = resObj.title.Color;
                                        avt.objData.title = resObj.title;
                                        MsgBox.notify("Your title has been successfully changed.");
                                        break;
                                    case "unequip":
                                        avt.pMC.pname.tt.text = "";
                                        avt.objData.title = null;
                                        MsgBox.notify("Successfully unequipped the title.");
                                        break;
                                }

                                ui.mcPopup.mcTitles.updateActionText();
                            }
                            break;
                    }
                }
                try
                {
                    if (world.map.Events != null)
                    {
                        if (world.map.Events[cmd] != null)
                        {
                            world.map.responseEvent(cmd, resObj);
                        }
                    }
                }
                catch(e)
                {
                }
            };
            addFrameScript(0, frame1, 11, frame12, 12, frame13, 21, frame22, 31, frame32, 42, frame43);
//            Security.allowDomain("*.aq.com");
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            sfc = new SmartFoxClient();
            sfc.debug = true;
            sfc.smartConnect = false;
            sfc.addEventListener(SFSEvent.onConnection, onConnectionHandler);
            sfc.addEventListener(SFSEvent.onConnectionLost, onConnectionLostHandler);
            sfc.addEventListener(SFSEvent.onLogin, onLoginHandler);
            sfc.addEventListener(SFSEvent.onLogout, onLogoutHandler);
            sfc.addEventListener(SFSEvent.onObjectReceived, onObjectReceivedHandler);
            sfc.addEventListener(SFSEvent.onRoundTripResponse, onRoundTripResponseHandler);
            sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
            classCatMap.M1.ratios = [0.27, 0.3, 0.22, 0.05, 0.1, 0.06];
            classCatMap.M2.ratios = [0.2, 0.22, 0.33, 0.05, 0.1, 0.1];
            classCatMap.M3.ratios = [0.24, 0.2, 0.2, 0.24, 0.07, 0.05];
            classCatMap.M4.ratios = [0.3, 0.18, 0.3, 0.02, 0.06, 0.14];
            classCatMap.C1.ratios = [0.06, 0.2, 0.11, 0.33, 0.15, 0.15];
            classCatMap.C2.ratios = [0.08, 0.27, 0.1, 0.3, 0.1, 0.15];
            classCatMap.C3.ratios = [0.06, 0.23, 0.05, 0.28, 0.28, 0.1];
            classCatMap.S1.ratios = [0.22, 0.18, 0.21, 0.08, 0.08, 0.23];
            userPreference = SharedObject.getLocal("AQWUserPref", "/");
            litePreference = SharedObject.getLocal("AQLite_Data", "/");
            inituoPref();
            initlitePref();
            initKeybindPref();
            if (userPreference.data.quality == null)
            {
                userPreference.data.quality = "AUTO";
            }
            initArrRep();
            if (litePreference.data.bChatUI)
            {
                chatF = new Chat2(this);
                intChatMode = 1;
            }
            else
            {
                chatF = new Chat();
                chatF.rootClass = this;
                intChatMode = 0;
            }
        }

        private function updateRiftHUD(state:Object):void
        {
            if(world!=null)world.registerRiftArea(state);
            if (aeraRiftHUD == null)
            {
                aeraRiftHUD = new liteAssets.draw.riftHUD(sendRiftCommand);
                addChild(aeraRiftHUD);
            }
            aeraRiftHUD.update(state);
            if (aeraRiftPanel != null) aeraRiftPanel.updateActive(state);
        }

        public function toggleRiftPanel():void
        {
            if (aeraRiftPanel == null)
            {
                aeraRiftPanel = new liteAssets.draw.riftPanel(sendRiftPanelCommand);
                addChild(aeraRiftPanel);
            }
            else if (aeraRiftPanel.visible) { aeraRiftPanel.visible = false; return; }
            aeraRiftPanel.visible = true;
            setChildIndex(aeraRiftPanel, numChildren - 1);
            aeraRiftPanel.refresh();
        }

        private function sendRiftPanelCommand(args:Array):void
        {
            if (sfc == null || world == null) return;
            sfc.sendXtMessage("zm", "cmd", ["rift"].concat(args), "str", world.curRoom);
        }

        private function sendRiftCommand(command:String):void
        {
            if (sfc == null || world == null) return;
            sfc.sendXtMessage("zm", "cmd", ["rift", command], "str", world.curRoom);
        }

        public static function gTrace(_arg_1:*):*
        {
            if (Game.ISWEB)
            {
                if (!ExternalInterface.available)
                {
                    return;
                }
                ExternalInterface.call("console.log", _arg_1);
            }
        }

        public static function trim(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            }
            return (_arg_1.replace(/^\s+|\s+$/g, ""));
        }

        public static function XMLtoObject(_arg_1:XML):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_2:* = {};
            for (_local_3 in _arg_1.attributes())
            {
                _local_2[String(_arg_1.attributes()[_local_3].name())] = String(_arg_1.attributes()[_local_3]);
            }
            for (_local_4 in _arg_1.children())
            {
                _local_5 = _arg_1.children()[_local_4].name();
                if (_local_2[_local_5] == undefined)
                {
                    _local_2[_local_5] = [];
                }
                _local_2[_local_5].push(XMLtoObject(_arg_1.children()[_local_4]));
            }
            return (_local_2);
        }

        public static function convertXMLtoObject(_arg_1:XML):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:XML;
            var _local_6:*;
            var _local_2:* = {};
            for (_local_3 in _arg_1.attributes())
            {
                _local_2[String(_arg_1.attributes()[_local_3].name())] = String(_arg_1.attributes()[_local_3]);
            }
            for (_local_4 in _arg_1.children())
            {
                _local_5 = _arg_1.children()[_local_4];
                if (_local_5.nodeKind() == "text")
                {
                    if (_local_5 == parseFloat(_local_5).toString())
                    {
                        return (parseFloat(_local_5));
                    }
                    return (_local_5);
                }
                if (_local_5.nodeKind() == "element")
                {
                    _local_6 = _arg_1.children()[_local_4].name();
                    if (_local_2[_local_6] == null)
                    {
                        _local_2[_local_6] = convertXMLtoObject(_arg_1.children()[_local_4]);
                    }
                    else
                    {
                        if (!(_local_2[_local_6] is Array))
                        {
                            _local_2[_local_6] = [_local_2[_local_6]];
                        }
                        _local_2[_local_6].push(convertXMLtoObject(_arg_1.children()[_local_4]));
                    }
                }
            }
            return (_local_2);
        }

        public function onRemoveChildrens(param1:MovieClip) : * {
            if (param1 == null)
            {
                return;
            }
            var _loc2_:* = param1.numChildren - 1;
            while(_loc2_ >= 0) {
                param1.removeChildAt(_loc2_);
                _loc2_--;
            }
        }

        private static function makeGrayscale(_arg_1:DisplayObject, _arg_2:int=0, _arg_3:Number=0.33):void
        {
            var _local_6:Color;
            if (_arg_1 == null)
            {
                return;
            }
            var _local_4:Array = [_arg_3, _arg_3, _arg_3, 0, 0, _arg_3, _arg_3, _arg_3, 0, 0, _arg_3, _arg_3, _arg_3, 0, 0, _arg_3, _arg_3, _arg_3, 1, 0];
            var _local_5:ColorMatrixFilter = new ColorMatrixFilter(_local_4);
            _arg_1.filters = [_local_5];
            if (_arg_2 != 0)
            {
                _local_6 = new Color();
                _local_6.brightness = -(_arg_2 / 100);
                _arg_1.transform.colorTransform = _local_6;
            }
        }

        public function onLoadMaster(onComplete:Function, context:LoaderContext, file:String, onProgress:Function = null, onError:Function = null):Function
        {
            var loader:URLLoader;
            var request:URLRequest;
            if (((file == null) || (file.length < 1)))
            {
                return (null);
            }
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            if (onComplete != null) loader.addEventListener(Event.COMPLETE, this.onLoadToBytes(onComplete, context), false, 0, true);
            if (onProgress != null) loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            if (onError != null) loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            request = new URLRequest(getFilePath() + file);
            try
            {
                loader.load(request);
            }
            catch(e:Error)
            {
                if (onError != null)
                {
                    try
                    {
                        onError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.message));
                    }
                    catch(callbackError:Error)
                    {
                    }
                }
            }
            return (null);
        }

        public function onLoadToBytes(onComplete:Function, context:LoaderContext):Function {
            return function (event:Event):void {
                var data:ByteArray = URLLoader(event.target).data as ByteArray;
                var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
                loader.loadBytes(data, context);
            };
        }

        public function loadAccountCreation(_arg_1:String):*
        {
            if (((mcAccount == null) || (_arg_1 == null) || (_arg_1.length < 1)))
            {
                return;
            }
            while (mcAccount.numChildren > 0)
            {
                mcAccount.removeChildAt(0);
            }
            var _local_2:Loader = new Loader();
            _local_2.load(new URLRequest((Game.serverFilePath + _arg_1)), new LoaderContext(false, new ApplicationDomain(null)));
            mcAccount.addChild(_local_2);
        }

        public function onCSComplete(event:Event):void
        {
            mcCharSelect = event.currentTarget.content;
            this.addChildAt(mcCharSelect, 1);
//            csLoader.removeEventListener(Event.COMPLETE, onCSComplete);
//            csLoader.removeEventListener(ProgressEvent.PROGRESS, onCSProgress);
//            csLoader.removeEventListener(IOErrorEvent.IO_ERROR, onCSError);
        }

        public function onCSProgress(_arg_1:ProgressEvent):void
        {
            if (_arg_1 == null)
            {
                return;
            }
            csbLoaded = _arg_1.bytesLoaded;
            csbTotal = _arg_1.bytesTotal;
            if (csbTotal <= 0)
            {
                return;
            }
            var _local_2:int = int(((csbLoaded / csbTotal) * 100));
            var _local_3:Number = (csbLoaded / csbTotal);
            if (((loader != null) && (loader.mcPct != null)))
            {
                loader.mcPct.text = (_local_2 + "%");
            }
            if (csbLoaded >= csbTotal)
            {
                if (((loader != null) && (loader.parent != null)))
                {
                    loader.parent.removeChild(loader);
                }
                loader = null;
            }
        }

        public function onCSError(_arg_1:IOErrorEvent):void
        {
            if (loader)
            {
                loader.parent.removeChild(loader);
                loader = null;
            }
            gotoAndPlay("Login");
        }

        public function monsterTreeWrite(_arg_1:int, _arg_2:Object, _arg_3:*=null):void
        {
            trace("MONSTER TREE WRITE");
            var _local_5:String;
            var _local_6:String;
            var _local_7:*;
            var _local_8:Avatar;
            var _local_9:Avatar;
            var _local_10:Avatar;
            var _local_11:Avatar;
            var _local_12:MovieClip;
            var _local_16:int;
            var _local_17:String;
            var _local_18:int;
            var _local_19:String;
            var _local_20:*;
            var _local_21:*;
            var _local_4:int;
            var _local_13:* = "";
            var _local_14:Object = {};
            var _local_15:Object = world.monTree[_arg_1];
            if (_local_15 != null)
            {
                _local_16 = -1;
                if (((!(_local_15 == null)) && (!(_local_15.intState == null))))
                {
                    _local_16 = _local_15.intState;
                }
                for (_local_17 in _arg_2)
                {
                    _local_6 = _local_17;
                    _local_7 = _arg_2[_local_17];
                    _local_14[_local_6] = _local_7;
                    if (_local_6.toLowerCase().indexOf("int") > -1)
                    {
                        _local_7 = Number(_local_7);
                    }
                    if (_local_6 == "react")
                    {
                        _local_7 = _local_7.split(",");
                        _local_18 = 0;
                        while (_local_18 < _local_7.length)
                        {
                            _local_7[_local_18] = Number(_local_7[_local_18]);
                            _local_18++;
                        }
                    }
                    _local_15[_local_6] = _local_7;
                }
                _local_13 = "";
                for (_local_13 in _local_14)
                {
                    _local_6 = _local_13;
                    _local_7 = _local_14[_local_13];
                    if (_local_6.toLowerCase().indexOf("evt:") < 0)
                    {
                        _local_10 = world.getMonster(_arg_1);
                        if (_local_10 != null)
                        {
                            if (_local_6.toLowerCase().indexOf("hp") > -1)
                            {
                                if (((!(_local_10 == null)) && (!(_local_10.objData == null))))
                                {
                                    _local_7 = Number(_local_7);
                                    _local_10.objData[_local_13] = _local_7;
                                    if (world.myAvatar.target == _local_10)
                                    {
                                        world.updatePortrait(_local_10);
                                    }
                                    if (((!(world.objLock == null)) && ((_local_6 == "intHP") && (_local_7 <= 0))))
                                    {
                                        world.intKillCount++;
                                        world.updatePadNames();
                                    }
                                    if (((!(_local_10.objData == null)) && ("boolean")))
                                    {
                                        if (_local_10.objData.strFrame == world.strFrame)
                                        {
                                            if (_local_7 <= 0)
                                            {
                                                if (((bAnalyzer) && ((_arg_3) || (_local_14["targets"].length > 0))))
                                                {
                                                    if (bAnalyzer.isRunning())
                                                    {
                                                        for each (_local_19 in ((_arg_3) ? _arg_3 : _local_14["targets"]))
                                                        {
                                                            if (world.myAvatar.objData.strUsername.toLowerCase() == _local_19.toLowerCase())
                                                            {
                                                                bAnalyzer.addKill();
                                                            }
                                                        }
                                                    }
                                                }
                                                // Always release a monster once it dies. Keeping a dead monster
                                                // selected makes auto-attack and the target portrait feel stuck.
                                                if (world.myAvatar.target == _local_10)
                                                {
                                                    world.cancelTarget();
                                                }
                                                _local_10.pMC.stopWalking();
                                                world.removeAuraFX(_local_10.pMC, "all");
                                                _local_10.pMC.die();
                                                _local_15.auras = [];
                                                _local_15.targets = {};
                                                _local_10.target = null;
                                                if (("eventTrigger" in MovieClip(world.map)))
                                                {
                                                    world.map.eventTrigger({
                                                        "cmd":"monDeath",
                                                        "args":_arg_1,
                                                        "targets":_arg_2.targets
                                                    });
                                                }
                                                if (world.myAvatar.dataLeaf.targets[_local_10.objData.MonMapID] != null)
                                                {
                                                    delete world.myAvatar.dataLeaf.targets[_local_10.objData.MonMapID];
                                                }
                                                if (((world.strMapName == "trickortreat") && (world.strFrame == "Enter")))
                                                {
                                                    world.TrickOrTreatMonsterDead = true;
                                                    world.loadPlayerNPC();
                                                }
                                                if (((world.strMapName == "caroling") && (world.strFrame == "Enter")))
                                                {
                                                    world.CarolingMonsterKillCount = (world.CarolingMonsterKillCount + 1);
                                                    if (world.CarolingMonsterKillCount >= 5)
                                                    {
                                                        world.setTarget(null);
                                                        world.loadPlayerNPC();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if (_local_6.toLowerCase().indexOf("state") > -1)
                            {
                                if (((!(_local_10 == null)) && (!(_local_10.objData == null))))
                                {
                                    _local_7 = Number(_local_7);
                                    _local_10.objData[_local_13] = _local_7;
                                    if (_local_7 != 2)
                                    {
                                        _local_10.dataLeaf.auras = [];
                                    }
                                    if (((!(_local_10.objData.strFrame == null)) && (_local_10.objData.strFrame == world.strFrame)))
                                    {
                                        if ((((_local_7 == 1) && (!(_local_10.pMC == null))) && ((!(_local_10.pMC.x == _local_10.pMC.ox)) || (!(_local_10.pMC.y == _local_10.pMC.oy)))))
                                        {
                                            trace("STATE > WAKTO");
                                            _local_10.pMC.walkTo(_local_10.pMC.ox, _local_10.pMC.oy, world.WALKSPEED);
                                        }
                                    }
                                    if (_local_7 != 2)
                                    {
                                        _local_15.targets = {};
                                    }
                                }
                            }
                            if (_local_6.toLowerCase().indexOf("dx") > -1)
                            {
                                _local_7 = Number(_local_7);
                                if ((((!(_local_10.objData == null)) && (!(_local_10.objData.strFrame == null))) && (_local_10.objData.strFrame == world.strFrame)))
                                {
                                    _local_20 = int(world.monTree[_arg_1].dx);
                                    _local_21 = int(world.monTree[_arg_1].dy);
                                    trace("DX > WAKTO");
                                    _local_10.pMC.walkTo(_local_20, _local_21, world.WALKSPEED);
                                }
                            }
                        }
                    }
                }
            }
        }

        public function userTreeWrite(_arg_1:String, _arg_2:Object):void
        {
            var _local_4:String;
            var _local_5:String;
            var _local_6:*;
            var _local_7:Avatar;
            var _local_8:Avatar;
            var _local_9:Avatar;
            var _local_10:Avatar;
            var _local_11:MovieClip;
            var _local_16:String;
            var _local_17:int;
            var _local_3:int;
            var _local_12:* = "";
            var _local_13:Object = {};
            var _local_14:Object = {};
            var _local_15:Object = world.uoTree[_arg_1.toLowerCase()];
            _local_10 = world.getAvatarByUserName(_arg_1);
            for (_local_16 in _arg_2)
            {
                _local_5 = _local_16;
                _local_6 = _arg_2[_local_16];
                if ((((((_local_5.toLowerCase().indexOf("int") > -1) || (_local_5.toLowerCase() == "tx")) || (_local_5.toLowerCase() == "ty")) || (_local_5.toLowerCase() == "sp")) || (_local_5.toLowerCase() == "pvpTeam")))
                {
                    _local_6 = int(_local_6);
                }
                if ((((((((((sfcSocial) && (!(_local_15 == null))) && (!(world.myAvatar.dataLeaf == null))) && (_local_5.toLowerCase() == "inthp")) && (!(_arg_1.toLowerCase() == sfc.myUserName))) && (_local_15.strFrame == world.myAvatar.dataLeaf.strFrame)) && ((!(world.bPvP)) || (_local_15.pvpTeam == world.myAvatar.dataLeaf.pvpTeam))) && (_local_6 > 0)) && (!(world.getFirstHeal() == null))))
                {
                    if (((_local_6 <= _local_15.intHP) && (((_local_15.intHP - _local_6) >= (_local_15.intHPMax * 0.15)) || (_local_6 <= (_local_15.intHPMax * 0.5)))))
                    {
                        try
                        {
                            _local_10.pMC.showHealIcon();
                        }
                        catch(e:Error)
                        {
                        }
                    }
                    if (_local_6 > Math.round((_local_15.intHPMax * 0.5)))
                    {
                        try
                        {
                            if (_local_10.pMC.getChildByName("HealIconMC") != null)
                            {
                                MovieClip(_local_10.pMC.getChildByName("HealIconMC")).fClose();
                            }
                        }
                        catch(e:Error)
                        {
                        }
                    }
                }
                if (_local_5.toLowerCase() == "afk")
                {
                    _local_6 = (_local_6 == "true");
                }
                _local_13[_local_5] = _local_6;
                _local_14[_local_5] = _local_6;
            }
            _local_17 = -1;
            if (world.uoTree[_arg_1.toLowerCase()] != null)
            {
                _local_17 = world.uoTree[_arg_1.toLowerCase()].intState;
            }
            world.uoTreeLeafSet(_arg_1, _local_14);
            _local_15 = world.uoTree[_arg_1.toLowerCase()];
            if (world.isPartyMember(_arg_1))
            {
                world.updatePartyFrame({"unm":_local_15.strUsername});
            }
            _local_12 = "";
            for (_local_12 in _local_13)
            {
                _local_6 = _local_13[_local_12];
                if (_local_12.toLowerCase() == "strframe")
                {
                    world.manageAreaUser(_arg_1, "+");
                    if (_local_13[_local_12] != world.strFrame)
                    {
                        _local_11 = world.getMCByUserID(world.getUserByName(_arg_1).getId());
                        if (((!(_local_11 == null)) && (!(_local_11.stage == null))))
                        {
                            if (world.bPvP)
                            {
                                _local_11.px = _local_13.px;
                                _local_11.py = _local_13.py;
                                _local_11.mvtd = _local_13.mvtd;
                                _local_11.mvts = _local_13.mvts;
                                _local_11.sp = _local_13.sp;
                                _local_11.walkTo(_local_13.tx, _local_13.ty, _local_13.sp);
                            }
                            _local_11.pAV.hideMC();
                            if (_local_11.pAV == world.myAvatar.target)
                            {
                                world.setTarget(null);
                            }
                        }
                    }
                    else
                    {
                        if (_local_13.sp != null)
                        {
                            _local_11 = world.getMCByUserID(world.getUserByName(_arg_1).getId());
                            if (_local_11 != null)
                            {
                                _local_11.walkTo(_local_13.tx, _local_13.ty, _local_13.sp);
                            }
                        }
                        else
                        {
                            world.objectByID(_local_15.entID);
                        }
                    }
                }
                if (_local_12.toLowerCase() == "sp")
                {
                    if (_local_13.strFrame == world.strFrame)
                    {
                    }
                }
                if (_local_10 != null)
                {
                    if (((_local_12.toLowerCase().indexOf("inthp") > -1) || (_local_12.toLowerCase().indexOf("intmp") > -1)))
                    {
                        _local_6 = Number(_local_6);
                        if (_local_10.objData != null)
                        {
                            _local_10.objData[_local_12] = _local_6;
                        }
                        if (((_local_10.isMyAvatar) || (world.myAvatar.target == _local_10)))
                        {
                            world.updatePortrait(_local_10);
                        }
                        if (_local_10.isMyAvatar)
                        {
                            world.updateActBar();
                        }
                        if (((!(_local_10.pMC == null)) && (world.showHPBar)))
                        {
                            _local_10.pMC.updateHPBar();
                        }
                    }
                    if (_local_10.isMyAvatar)
                    {
                        if (_local_12.toLowerCase().indexOf("intsp") > -1)
                        {
                            _local_6 = Number(_local_6);
                            if (_local_10.objData != null)
                            {
                                _local_10.objData[_local_12] = _local_6;
                            }
                            if (((_local_10.isMyAvatar) || (world.myAvatar.target == _local_10)))
                            {
                                world.updatePortrait(_local_10);
                            }
                            if (_local_10.isMyAvatar)
                            {
                                world.updateActBar();
                            }
                            if (((!(_local_10.pMC == null)) && (world.showHPBar)))
                            {
                                _local_10.pMC.updateHPBar();
                            }
                        }
                    }
                    if (_local_12.toLowerCase().indexOf("intlevel") > -1)
                    {
                        _local_6 = Number(_local_6);
                        if (_local_10.objData != null)
                        {
                            _local_10.objData[_local_12] = _local_6;
                            if (((!(_local_10.isMyAvatar)) && (world.myAvatar.target == _local_10)))
                            {
                                showPortraitBox(_local_10, ui.mcPortraitTarget);
                            }
                        }
                    }
                    if (_local_12.toLowerCase().indexOf("intstate") > -1)
                    {
                        _local_6 = int(_local_6);
                        if (((!(_local_10.objData == null)) && (world.uoTree[_arg_1.toLowerCase()].strFrame == world.strFrame)))
                        {
                            if (((_local_6 == 1) && (_local_17 == 0)))
                            {
                                _local_10.pMC.gotoAndStop("Idle");
                                _local_10.pMC.scale(world.SCALE);
                            }
                            if (((_local_6 == 1) && (_local_17 == 2)))
                            {
                                if (("eventTrigger" in MovieClip(world.map)))
                                {
                                }
                            }
                        }
                        if (_local_10.objData != null)
                        {
                            _local_10.objData[_local_12] = _local_6;
                        }
                        if ((((_local_6 == 0) && (world.uoTree[_arg_1.toLowerCase()].strFrame == world.strFrame)) && (!(_local_10.pMC == null))))
                        {
                            _local_10.pMC.stopWalking();
                            _local_10.pMC.mcChar.gotoAndPlay("Feign");
                            world.removeAuraFX(_local_10.pMC, "all");
                            if (_local_10.pMC.getChildByName("HealIconMC") != null)
                            {
                                MovieClip(_local_10.pMC.getChildByName("HealIconMC")).fClose();
                            }
                            if (_local_10.isMyAvatar)
                            {
                                world.cancelAutoAttack();
                                world.actionReady = false;
                                world.bitWalk = false;
                                world.map.transform.colorTransform = world.deathCT;
                                world.CHARS.transform.colorTransform = world.deathCT;
                                _local_10.pMC.transform.colorTransform = world.defaultCT;
                                world.showResCounter();
                            }
                        }
                        if (_local_6 != 2)
                        {
                            _local_15.targets = {};
                        }
                    }
                    if (_local_12.toLowerCase().indexOf("afk") > -1)
                    {
                        if (_local_10.pMC != null)
                        {
                            _local_10.pMC.updateName();
                        }
                    }
                    if (_local_12 == "showCloak")
                    {
                        if (_local_10.pMC != null)
                        {
                            _local_10.pMC.setCloakVisibility(_local_6);
                        }
                    }
                    if (_local_12 == "showHelm")
                    {
                        if (_local_10.pMC != null)
                        {
                            _local_10.pMC.setHelmVisibility(_local_6);
                        }
                    }
                    if (_local_12.toLowerCase().indexOf("cast") > -1)
                    {
                        if (_local_10.pMC != null)
                        {
                            if (_local_6.t > -1)
                            {
                                _local_10.pMC.stopWalking();
                                _local_10.pMC.queueAnim("Use");
                            }
                            else
                            {
                                _local_10.pMC.endAction();
                                if (_local_10 == world.myAvatar)
                                {
                                    ui.mcCastBar.fClose();
                                }
                            }
                        }
                    }
                }
            }
        }

        public function doAnim(anim:Object, isProc:Boolean=false, dur:*=null):void
        {
            var anims:Array;
            var animIndex:uint;
            var animStr:String;
            var pMC:MovieClip;
            var cLeaf:Object;
            var tLeaf:Object;
            var tAvt:Avatar;
            var cAvt:Avatar;
            var aura:Object;
            var buffer:* = undefined;
            var xBuffer:* = undefined;
            var yBuffer:* = undefined;
            var animString:String;
            var i:int;
            var cTyp:String = "";
            var cID:int = -1;
            var tTyp:String = "";
            var tID:int = -1;
            var tAvts:Array = [];
            var tInfA:Array = [];
            var strF:String = "";
            cAvt = null;
            tAvt = null;
            var cReg:Point = new Point(0, 0);
            var tReg:Point = new Point(0, 0);
            if (((!(anim.cInf == null)) && (!(anim.tInf == null))))
            {
                cTyp = String(anim.cInf.split(":")[0]);
                cID = int(anim.cInf.split(":")[1]);
                switch (cTyp)
                {
                    case "p":
                        cAvt = world.getAvatarByUserID(cID);
                        cLeaf = world.getUoLeafById(cID);
                        break;
                    case "m":
                        cAvt = world.getMonster(cID);
                        cLeaf = world.monTree[cID];
                        if (anim.msg != null)
                        {
                            if (anim.msg.indexOf("<mon>") > -1)
                            {
                                anim.msg = anim.msg.split("<mon>").join(cAvt.objData.strMonName);
                            }
                            addUpdate(anim.msg);
                        }
                        break;
                }
                tInfA = anim.tInf.split(",");
                i = 0;
                while (i < tInfA.length)
                {
                    tTyp = String(tInfA[i].split(":")[0]);
                    tID = int(tInfA[i].split(":")[1]);
                    switch (tTyp)
                    {
                        case "p":
                            tAvt = world.getAvatarByUserID(tID);
                            tLeaf = world.getUoLeafById(tID);
                            break;
                        case "m":
                            tAvt = world.getMonster(tID);
                            tLeaf = world.monTree[tID];
                            break;
                    }
                    tAvts.push(tAvt);
                    i = (i + 1);
                }
                if (tAvts[0] != null)
                {
                    tAvt = tAvts[0];
                }
                if (tAvt != null)
                {
                    tLeaf = tAvt.dataLeaf;
                }
                if (((((((!(cAvt == null)) && (!(cAvt.pMC == null))) && (!(tAvt == null))) && (!(tAvt.pMC == null))) && (!(cLeaf == null))) && (!(tLeaf == null))))
                {
                    aura = {};
                    for each (aura in cLeaf.auras)
                    {
                        try
                        {
                            if (aura.cat != null)
                            {
                                if (aura.cat == "stun")
                                {
                                    return;
                                }
                                if (aura.cat == "stone")
                                {
                                    return;
                                }
                                if (aura.cat == "disabled")
                                {
                                    return;
                                }
                            }
                        }
                        catch(e:Error)
                        {
                        }
                    }
                    animStr = anim.animStr;
                    switch (cTyp)
                    {
                        case "p":
                            if (cAvt.objData != null)
                            {
                                if (cAvt != world.myAvatar)
                                {
                                    cAvt.target = tAvt;
                                }
                                strF = String(cLeaf.strFrame);
                                if ((((!(strF == null)) && (strF == world.strFrame)) && (cLeaf.intState > 0)))
                                {
                                    if (cAvt != tAvt)
                                    {
                                        if ((tAvt.pMC.x - cAvt.pMC.x) >= 0)
                                        {
                                            cAvt.pMC.turn("right");
                                        }
                                        else
                                        {
                                            cAvt.pMC.turn("left");
                                        }
                                    }
                                    cAvt.pMC.queueSpFX({
                                        "strl":anim.strl,
                                        "fx":anim.fx,
                                        "avts":tAvts
                                    });
                                    if (!isNaN(dur))
                                    {
                                        cAvt.pMC.spellDur = dur;
                                    }
                                    if (animStr != null)
                                    {
                                        if (animStr.indexOf(",") > -1)
                                        {
                                            animStr = animStr.split(",")[Math.round((Math.random() * (animStr.split(",").length - 1)))];
                                        }
                                        if (((!(animStr == "Thrash")) || (!(cAvt.pMC.mcChar.currentLabel == "Thrash"))))
                                        {
                                            cAvt.pMC.queueAnim(animStr);
                                        }
                                        if (((isProc) && (cAvt.pMC.mcChar.weapon.mcWeapon.isProc)))
                                        {
                                            cAvt.pMC.mcChar.weapon.mcWeapon.gotoAndPlay("Proc");
                                        }
                                    }
                                }
                            }
                            return;
                        case "m":
                            if (cAvt.objData != null)
                            {
                                if (cAvt != world.myAvatar)
                                {
                                    cAvt.target = tAvt;
                                }
                                strF = String(cLeaf.strFrame);
                                cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                                tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                                cReg = world.CHARS.globalToLocal(cReg);
                                tReg = world.CHARS.globalToLocal(tReg);
                                if ((((!(strF == null)) && (strF == world.strFrame)) && (cLeaf.intState > 0)))
                                {
                                    if (cAvt != tAvt)
                                    {
                                        if ((tReg.x - cReg.x) >= 0)
                                        {
                                            cAvt.pMC.turn("right");
                                        }
                                        else
                                        {
                                            cAvt.pMC.turn("left");
                                        }
                                    }
                                    if (((((!(anim.fx == "p")) && (!(anim.fx == "w"))) && (!(anim.fx == ""))) && (((Math.abs((cReg.x - tReg.x)) * world.SCALE) > 160) || ((Math.abs((cReg.y - tReg.y)) * world.SCALE) > 15))))
                                    {
                                        buffer = int((110 + (Math.random() * 50)));
                                        xBuffer = (((tReg.x - cReg.x) >= 0) ? -(buffer) : buffer);
                                        xBuffer = int((xBuffer * world.SCALE));
                                        if ((((tReg.x + xBuffer) < 0) || ((tReg.x + xBuffer) > 960)))
                                        {
                                            xBuffer = (xBuffer * -1);
                                        }
                                        buffer = int(((Math.random() * 30) - 15));
                                        yBuffer = (((tReg.y - cReg.y) >= 0) ? -(buffer) : buffer);
                                        yBuffer = int((yBuffer * world.SCALE));
                                        cAvt.pMC.walkTo((tReg.x + xBuffer), (tReg.y + yBuffer), 32);
                                    }
                                    if (cAvt.pMC.spFX != null)
                                    {
                                        cAvt.pMC.spFX.avt = cAvt.target;
                                    }
                                    cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                                    tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                                    if (cAvt != tAvt)
                                    {
                                        if ((tReg.x - cReg.x) >= 0)
                                        {
                                            cAvt.pMC.turn("right");
                                        }
                                        else
                                        {
                                            cAvt.pMC.turn("left");
                                        }
                                    }
                                    if (litePreference.data.bDisMonAnim)
                                    {
                                        return;
                                    }
                                    if (animStr.length > 1)
                                    {
                                        if (animStr.indexOf(",") > -1)
                                        {
                                            if (world.objExtra["bChar"] == 1)
                                            {
                                                animString = cAvt.pMC.Animation;
                                                MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animString);
                                            }
                                            else
                                            {
                                                anims = animStr.split(",");
                                                animIndex = uint(Math.round((Math.random() * (anims.length - 1))));
                                                MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(anims[animIndex]);
                                            }
                                        }
                                        else
                                        {
                                            if (world.objExtra["bChar"] == 1)
                                            {
                                                animString = cAvt.pMC.Animation;
                                                MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animString);
                                            }
                                            else
                                            {
                                                MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animStr);
                                            }
                                        }
                                    }
                                }
                            }
                            return;
                    }
                }
            }
        }

        public function key_StageLogin(_arg_1:KeyboardEvent):*
        {
            if (_arg_1.target == stage)
            {
                if ((_arg_1.keyCode == Keyboard.ENTER))
                {
                    stage.focus = mcLogin.ni;
                }
            }
        }

        public function isSpecificItem(_arg_1:String):Boolean
        {
            switch (_arg_1)
            {
                case "Lucky Suit Treasure Chest":
                case "Unlucky Suit Treasure Chest":
                case "Apocalyptic LichMoglin on your Back":
                    return (true);
            }
            return (false);
        }

        public function hasBankItem():Boolean
        {
            var _local_1:*;
            for each (_local_1 in world.myAvatar.items)
            {
                if (((((_local_1.sName.indexOf(" Bank") > -1) || ((_local_1.sType == "Pet") && (_local_1.sName.indexOf(" Moglin Plush Pet") > -1))) || (_local_1.sDesc.indexOf(" Bank Pet ") > -1)) || (isSpecificItem(_local_1.sName))))
                {
                    return (true);
                }
            }
            return (false);
        }

        private function gameplayKeyboardAvailable(event:KeyboardEvent=null):Boolean
        {
            if (((world == null) || (world.myAvatar == null) || (world.myAvatar.pMC == null)))
            {
                return false;
            }
            if (((event != null) && (event.target is TextField)))
            {
                return false;
            }
            try
            {
                if (((stage != null) && (stage.focus is TextField)))
                {
                    return false;
                }
            }
            catch(e:Error)
            {
            }
            return true;
        }

        private function clearMovementKeys():void
        {
            movementKeys = {};
            npcInteractHeld = false;
            if (world != null)
            {
                world.stopKeyboardMovement();
            }
        }

        private function key_StageGameUp(event:KeyboardEvent):void
        {
            if (((((event.keyCode == 87) || (event.keyCode == 65)) || (event.keyCode == 83)) || (event.keyCode == 68)))
            {
                delete movementKeys[event.keyCode];
                if (
                    world != null &&
                    !movementKeys[87] &&
                    !movementKeys[65] &&
                    !movementKeys[83] &&
                    !movementKeys[68]
                )
                {
                    world.stopKeyboardMovement();
                }
            }

            // E is edge-triggered so keyboard auto-repeat cannot reopen the NPC panel.
            if (event.keyCode == 69)
            {
                npcInteractHeld = false;
            }
        }

        private function keyboardMovementFrame(event:Event):void
        {
            var dx:Number = 0;
            var dy:Number = 0;

            if (!gameplayKeyboardAvailable())
            {
                if (world != null)
                {
                    world.stopKeyboardMovement();
                }
                return;
            }

            if (((world == null) || (!(world.bitWalk))))
            {
                if (world != null)
                {
                    world.stopKeyboardMovement();
                }
                return;
            }

            if (movementKeys[65]) dx = (dx - 1); // A
            if (movementKeys[68]) dx = (dx + 1); // D
            if (movementKeys[87]) dy = (dy - 1); // W
            if (movementKeys[83]) dy = (dy + 1); // S

            if (((dx == 0) && (dy == 0)))
            {
                world.stopKeyboardMovement();
                return;
            }

            world.movePlayerByKeyboard(dx, dy);
        }

        public function key_StageGame(_arg_1:KeyboardEvent):*
        {
            var _local_2:Array;
            var _local_3:String;
            var _local_4:uint;
            var _local_5:MovieClip;
            var _local_6:MovieClip;
            var _local_7:int;
            if (((_arg_1.target) && (_arg_1.target.name == "btnSetKeybindActive")))
            {
                return;
            }
            if (!((_arg_1.target is TextField) || (_arg_1.currentTarget is TextField)))
            {
                // ESC closes the database NPC popup first.
                if (
                    (_arg_1.keyCode == Keyboard.ESCAPE) &&
                    world != null &&
                    world.closeDatabaseNPCPanel()
                )
                {
                    return;
                }

                // Smooth WASD movement and E-to-talk.
                if (gameplayKeyboardAvailable(_arg_1))
                {
                    if ((((_arg_1.keyCode == 87) || (_arg_1.keyCode == 65)) || ((_arg_1.keyCode == 83) || (_arg_1.keyCode == 68))))
                    {
                        movementKeys[_arg_1.keyCode] = true;
                    }

                    if (_arg_1.keyCode == 69)
                    {
                        if (!npcInteractHeld)
                        {
                            npcInteractHeld = true;
                            if (world != null)
                            {
                                world.openNearestDatabaseNPC(150);
                            }
                        }
                    }
                }

                // W is reserved for movement now; do not use the old staff Trade hotkey.
                if ((String.fromCharCode(_arg_1.charCode) == "m") && (world.myAvatar.isStaff())){
                    if ((((stage.focus == null)) || (((!((stage.focus == null))) && (!(("text" in stage.focus))))))){
                        toggleAuctionPanel();
                    }
                }
                if (((_arg_1.keyCode == Keyboard.ENTER) || (String.fromCharCode(_arg_1.charCode) == "/")))
                {
                    chatF.openMsgEntry();
                }
                if (isNumpadKey(_arg_1.keyCode))
                {
                    _arg_1.keyCode = (_arg_1.keyCode - 48);
                }
                if (_arg_1.keyCode == litePreference.data.keys["Target Random Monster"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        _local_2 = world.getMonstersByCell(world.strFrame);
                        _local_3 = world.strFrame;
                        if (_local_2.length > 0)
                        {
                            _local_4 = uint(Math.round((Math.random() * (_local_2.length - 1))));
                            while ((((((_local_2.length > 1) && (!(_local_2[_local_4]))) && (!(_local_2[_local_4].pMC))) && (_local_2[_local_4].dataLeaf.intState == 0)) && (world.myAvatar.target == _local_2[_local_4])))
                            {
                                if (world.strFrame != _local_3) break;
                                _local_4 = uint(Math.round((Math.random() * (_local_2.length - 1))));
                            }
                            if (world.strFrame == _local_3)
                            {
                                if (((((_local_2[_local_4]) && (_local_2[_local_4].pMC)) && (_local_2[_local_4].dataLeaf.strFrame == world.strFrame)) && (!(_local_2[_local_4].dataLeaf.intState == 0))))
                                {
                                    world.setTarget(_local_2[_local_4]);
                                }
                            }
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Travel Menu's Travel"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (ui.getChildByName("mcTravelMenu"))
                        {
                            (ui.getChildByName("mcTravelMenu") as MovieClip).dispatchTravel();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Camera Tool"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (((stage.getChildByName("worldCameraMC")) || (getChildByName("cameraToolMC"))))
                        {
                            return;
                        }
                        _local_5 = new cameraTool(this);
                        _local_5.name = "cameraToolMC";
                        _local_5.x = -7;
                        addChild(_local_5);
                        world.visible = false;
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["World Camera"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (((stage.getChildByName("worldCameraMC")) || (getChildByName("cameraToolMC"))))
                        {
                            if (stage.getChildByName("worldCameraMC"))
                            {
                                MovieClip(stage.getChildByName("worldCameraMC")).dispatchExit();
                            }
                            return;
                        }
                        _local_6 = new worldCamera(this);
                        _local_6.name = "worldCameraMC";
                        stage.addChild(_local_6);
                    }
                }
                if ((String.fromCharCode(_arg_1.charCode) == ">"))
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (((!(chatF.pmSourceA[0] == null)) && (chatF.pmSourceA[0].length >= 1)))
                        {
                            chatF.openPMsg(chatF.pmSourceA[0]);
                            if (intChatMode)
                            {
                                ui.mcInterface.ncText.text = "> ";
                            }
                            else
                            {
                                ui.mcInterface.te.text = "> ";
                            }
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Inventory"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        ui.mcInterface.mcMenu.toggleInventory();
                    }
                }
                if (((_arg_1.keyCode == litePreference.data.keys["Bank"]) && ((world.myAvatar.isStaff()) || (hasBankItem()))))
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        world.toggleBank();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Quest Log"])
                {
                    if ((((!(stage.focus == ui.mcInterface.te)) && (!(stage.focus == ui.mcInterface.ncText))) && (!(stage.focus == ui.mcInterface.ncText))))
                    {
                        world.toggleQuestLog();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Friends List"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (ui.mcOFrame.isOpen)
                        {
                            ui.mcOFrame.fClose();
                        }
                        else
                        {
                            world.showFriendsList();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Character Panel"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        toggleCharpanel("overview");
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Player HP Bar"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        world.toggleHPBar();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Options"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (ui.mcPopup.currentLabel == "Option")
                        {
                            ui.mcPopup.onClose();
                        }
                        else
                        {
                            ui.mcPopup.fOpen("Option");
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Area List"])
                {
                    if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
                    {
                        if (!ui.mcOFrame.isOpen)
                        {
                            world.sendWhoRequest();
                        }
                        else
                        {
                            ui.mcOFrame.fClose();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Jump"])
                {
                    if (((!(stage.focus == ui.mcInterface.te)) && (!(stage.focus == ui.mcInterface.ncText))))
                    {
                        world.myAvatar.pMC.mcChar.gotoAndPlay("Jump");
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Rest"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        world.rest();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Hide Monsters"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        world.toggleMonsters();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Hide Players"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        optionHandler.cmd(MovieClip(this), "Hide Players");
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Cancel Target"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (cancelTargetTimer.running)
                        {
                            return;
                        }
                        if (((!(world.autoActionTimer == null)) && (world.autoActionTimer.running)))
                        {
                            world.cancelAutoAttack();
                            world.myAvatar.pMC.mcChar.gotoAndStop("Idle");
                        }
                        if (world.myAvatar.target != null)
                        {
                            world.setTarget(null);
                        }
                        if (!cancelTargetTimer.hasEventListener(TimerEvent.TIMER))
                        {
                            cancelTargetTimer.addEventListener(TimerEvent.TIMER, hasCanceledAlready, false, 0, true);
                        }
                        _local_7 = parseInt(world.getActionByRef(world.actionMap[0]).cd);
                        cancelTargetTimer.delay = ((_local_7 < 2000) ? 2000 : _local_7);
                        cancelTargetTimer.start();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Hide UI"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        optionHandler.cmd(MovieClip(this), "Hide UI");
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Battle Analyzer"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        optionHandler.cmd(MovieClip(this), "Battle Analyzer");
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Decline All Drops"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        optionHandler.cmd(MovieClip(this), "Decline All Drops");
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Stats Overview"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        toggleStatspanel();
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Battle Analyzer Toggle"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (bAnalyzer)
                        {
                            bAnalyzer.toggle();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Custom Drops UI"])
                {
                    if (((!(_arg_1.target == ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (((ui.mcPortrait.iconDrops) && (ui.mcPortrait.iconDrops.visible)))
                        {
                            ui.mcPortrait.iconDrops.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["@ Debugger - Cell Menu"])
                {
                    if ((((((ui) && (ui.mcInterface)) && (ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.te))) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (cMenuUI)
                        {
                            cMenuUI.toggle();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["@ Debugger - Packet Logger"])
                {
                    if ((((((ui) && (ui.mcInterface)) && (ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.te))) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (((pLoggerUI) && (litePreference.data.dOptions["debugPacket"])))
                        {
                            pLoggerUI.visible = (!(pLoggerUI.visible));
                            pLoggerUI.toggle();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Dash"])
                {
                    if ((((((ui) && (ui.mcInterface)) && (ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.te))) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        // Aera Space/Dash costs 50 stamina. Always overwrite the
                        // legacy 100-cost value so a player at 50 stamina can dash again.
                        world.uoTree[world.myAvatar.pnm].sta.$dsh = DASH_STAMINA_COST;
                        if (world.myAvatar.dataLeaf.intSP >= DASH_STAMINA_COST)
                        {
                            pDash = true;
                        }
                        else
                        {
                            pDash = false;
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Outfits"])
                {
                    if ((((((ui) && (ui.mcInterface)) && (ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.te))) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (!getInterface("outfitSets"))
                        {
                            toggleOutfits();
                        }
                    }
                }
                if (_arg_1.keyCode == litePreference.data.keys["Friendships UI"])
                {
                    if ((((((ui) && (ui.mcInterface)) && (ui.mcInterface.te)) && (!(_arg_1.target == ui.mcInterface.te))) && (!(_arg_1.target == ui.mcInterface.ncText))))
                    {
                        if (!getInterface("Friendships UI"))
                        {
                            showFriendshipUI();
                        }
                    }
                }
            }
        }

        private function hasCanceledAlready(_arg_1:TimerEvent):void
        {
            cancelTargetTimer.removeEventListener(TimerEvent.TIMER, hasCanceledAlready);
            stage.focus = null;
        }

        public function key_TextLogin(_arg_1:KeyboardEvent):*
        {
            if (_arg_1.target != stage)
            {
                if ((_arg_1.keyCode == Keyboard.ENTER))
                {
                    onLoginClick(null);
                }
            }
        }

        public function key_ChatEntry(_arg_1:KeyboardEvent):*
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                chatF.submitMsg(((intChatMode) ? ui.mcInterface.ncText.text : ui.mcInterface.te.text), chatF.chn.cur.typ, chatF.pmNm);
            }
            if (_arg_1.keyCode == Keyboard.ESCAPE)
            {
                chatF.closeMsgEntry();
            }
        }

        public function talk(_arg_1:*):*
        {
            if (_arg_1.accept)
            {
                chatF.submitMsg(_arg_1.emote1, "emote", sfc.myUserName);
            }
            else
            {
                chatF.submitMsg(_arg_1.emote2, "emote", sfc.myUserName);
            }
        }

        public function isNumpadKey(_arg_1:uint):Boolean
        {
            return ((_arg_1 >= 96) && (_arg_1 <= 105));
        }

        public function key_actBar(_arg_1:KeyboardEvent):*
        {
            var _local_2:int;
            var _local_3:String;
            var _local_4:*;
            if (((_arg_1.target) && (_arg_1.target.name == "btnSetKeybindActive")))
            {
                return;
            }
            if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus)))))
            {
                if (isNumpadKey(_arg_1.keyCode))
                {
                    _arg_1.keyCode = (_arg_1.keyCode - 48);
                }
                switch (_arg_1.keyCode)
                {
                    case litePreference.data.keys["Auto Attack"]:
                        _local_2 = 0;
                        world.approachTarget();
                        return;
                    case litePreference.data.keys["Skill 1"]:
                        _local_2 = 1;
                        if (world.actionMap[_local_2] != null)
                        {
                            _local_4 = world.getActionByRef(world.actionMap[_local_2]);
                            if (_local_4.isOK)
                            {
                                world.testAction(_local_4);
                            }
                        }
                        return;
                    case litePreference.data.keys["Skill 2"]:
                        _local_2 = 2;
                        if (world.actionMap[_local_2] != null)
                        {
                            _local_4 = world.getActionByRef(world.actionMap[_local_2]);
                            if (_local_4.isOK)
                            {
                                world.testAction(_local_4);
                            }
                        }
                        return;
                    case litePreference.data.keys["Skill 3"]:
                        _local_2 = 3;
                        if (world.actionMap[_local_2] != null)
                        {
                            _local_4 = world.getActionByRef(world.actionMap[_local_2]);
                            if (_local_4.isOK)
                            {
                                world.testAction(_local_4);
                            }
                        }
                        return;
                    case litePreference.data.keys["Skill 4"]:
                        _local_2 = 4;
                        if (world.actionMap[_local_2] != null)
                        {
                            _local_4 = world.getActionByRef(world.actionMap[_local_2]);
                            if (_local_4.isOK)
                            {
                                world.testAction(_local_4);
                            }
                        }
                        return;
                    case litePreference.data.keys["Skill 5"]:
                        _local_2 = 5;
                        if (world.actionMap[_local_2] != null)
                        {
                            _local_4 = world.getActionByRef(world.actionMap[_local_2]);
                            if (_local_4.isOK)
                            {
                                world.testAction(_local_4);
                            }
                        }
                        return;
                }
            }
        }

        public function getKeyboardDict():Dictionary
        {
            var _local_6:String;
            var _local_1:XML = describeType(Keyboard);
            var _local_2:XMLList = _local_1.constant.@name;
            var _local_3:Dictionary = new Dictionary();
            var _local_4:int = _local_2.length();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = _local_2[_local_5];
                if ((((_local_2[_local_5].indexOf("NUMBER_") > -1) || (_local_2[_local_5].indexOf("STRING_") > -1)) || (_local_2[_local_5].indexOf("KEYNAME_") > -1)))
                {
                    _local_6 = _local_2[_local_5].split("_")[1];
                }
                _local_3[Keyboard[_local_2[_local_5]]] = _local_6;
                _local_5++;
            }
            return (_local_3);
        }

        public function decHex(_arg_1:*):*
        {
            return (_arg_1.toString(16));
        }

        public function hexDec(_arg_1:*):*
        {
            return (parseInt(_arg_1, 16));
        }

        public function modColor(_arg_1:*, _arg_2:*, _arg_3:*):String
        {
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_4:* = "";
            var _local_8:* = 0;
            while (_local_8 < 3)
            {
                _local_5 = hexDec(_arg_1.substr((_local_8 * 2), 2));
                _local_6 = hexDec(_arg_2.substr((_local_8 * 2), 2));
                switch (_arg_3)
                {
                    case "-":
                    default:
                        _local_7 = (_local_5 - _local_6);
                        if (_local_7 < 0)
                        {
                            _local_7 = 0;
                        }
                        _local_7 = decHex(_local_7);
                        break;
                    case "+":
                        _local_7 = (_local_5 + _local_6);
                        if (_local_7 > 0xFF)
                        {
                            _local_7 = 0xFF;
                        }
                        _local_7 = decHex(_local_7);
                }
                _local_4 = (_local_4 + String(((_local_7.length < 2) ? ("0" + _local_7) : _local_7)));
                _local_8++;
            }
            return (_local_4);
        }

        internal function replaceString(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            var _local_4:Number = 0;
            var _local_5:Number = 0;
            var _local_6:* = "";
            while ((_local_4 = _arg_1.indexOf(_arg_2, _local_4)) != -1)
            {
                _local_6 = (_local_6 + (_arg_1.substring(_local_5, _local_4) + _arg_3));
                _local_5 = (_local_4 = (_local_4 + _arg_2.length));
            }
            return ((_local_6 == "") ? _arg_1 : _local_6);
        }

        public function stripWhite(_arg_1:String):String
        {
            _arg_1 = _arg_1.split("\r").join("");
            _arg_1 = _arg_1.split("\t").join("");
            return (_arg_1.split(" ").join(""));
        }

        public function stripWhiteStrict(_arg_1:String):String
        {
            _arg_1 = stripWhite(_arg_1);
            var _local_2:int;
            while (_local_2 < chatF.strictComparisonChars.length)
            {
                _arg_1 = _arg_1.split(chatF.strictComparisonChars.substr(_local_2, 1)).join("");
                _local_2++;
            }
            return (_arg_1);
        }

        public function stripWhiteStrictB(_arg_1:String):String
        {
            _arg_1 = stripWhite(_arg_1);
            var _local_2:int;
            while (_local_2 < chatF.strictComparisonCharsB.length)
            {
                _arg_1 = _arg_1.split(chatF.strictComparisonCharsB.substr(_local_2, 1)).join("");
                _local_2++;
            }
            return (_arg_1);
        }

        public function stripMarks(_arg_1:String):String
        {
            var _local_2:int;
            while (_local_2 < chatF.markChars.length)
            {
                _arg_1 = _arg_1.split(chatF.markChars.substr(_local_2, 1)).join("");
                _local_2++;
            }
            return (_arg_1);
        }

        public function stripDuplicateVowels(_arg_1:String):String
        {
            _arg_1 = _arg_1.replace(chatF.regExpA, "a");
            _arg_1 = _arg_1.replace(chatF.regExpE, "e");
            _arg_1 = _arg_1.replace(chatF.regExpI, "i");
            _arg_1 = _arg_1.replace(chatF.regExpO, "o");
            _arg_1 = _arg_1.replace(chatF.regExpU, "u");
            return (_arg_1.replace(chatF.regExpSPACE, " "));
        }

        public function maskStringBetween(_arg_1:String, _arg_2:Array):String
        {
            var _local_4:int;
            var _local_5:int;
            var _local_3:* = "";
            if (((_arg_2.length > 0) && ((_arg_2.length % 2) == 0)))
            {
                _local_4 = 0;
                _local_5 = 0;
                while (_local_5 < _arg_1.length)
                {
                    if (((_local_5 >= _arg_2[_local_4]) && (_local_5 <= _arg_2[(_local_4 + 1)])))
                    {
                        if (_arg_1.charAt(_local_5) == " ")
                        {
                            _local_3 = (_local_3 + " ");
                        }
                        else
                        {
                            _local_3 = (_local_3 + "*");
                        }
                        if (_local_5 == _arg_2[(_local_4 + 1)])
                        {
                            _local_4 = (_local_4 + 2);
                        }
                    }
                    else
                    {
                        _local_3 = (_local_3 + _arg_1.charAt(_local_5));
                    }
                    _local_5++;
                }
            }
            return (_local_3);
        }

        public function arraySort(_arg_1:String, _arg_2:String):int
        {
            if (_arg_1 > _arg_2)
            {
                return (1);
            }
            if (_arg_1 < _arg_2)
            {
                return (-1);
            }
            return (0);
        }

        public function convertBubbleText(_arg_1:String):String
        {
            var _local_2:String;
            _local_2 = world.myAvatar.objData.strUsername;
            if (_arg_1.indexOf("@name"))
            {
                _arg_1 = _arg_1.split("@name").join(_local_2);
            }
            _local_2 = String(world.myAvatar.objData.intLevel);
            if (_arg_1.indexOf("@level"))
            {
                _arg_1 = _arg_1.split("@level").join(_local_2);
            }
            _local_2 = world.myAvatar.objData.strClassName;
            if (_arg_1.indexOf("@class"))
            {
                _arg_1 = _arg_1.split("@class").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "Mr." : "Mrs.");
            if (_arg_1.indexOf("@prefix"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "He" : "She");
            if (_arg_1.indexOf("@He"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "Him" : "Her");
            if (_arg_1.indexOf("@Him"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "His" : "Her");
            if (_arg_1.indexOf("@His"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "he" : "she");
            if (_arg_1.indexOf("@he"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "him" : "her");
            if (_arg_1.indexOf("@him"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "his" : "her");
            if (_arg_1.indexOf("@his"))
            {
                _arg_1 = _arg_1.split("@prefix").join(_local_2);
            }
            return (_arg_1);
        }

        public function strToProperCase(_arg_1:String):String
        {
            return (_arg_1.slice(0, 1).toUpperCase() + _arg_1.slice(1, _arg_1.length).toLowerCase());
        }

        public function strSetCharAt(_arg_1:String, _arg_2:int, _arg_3:String):String
        {
            return ((_arg_1.substring(0, _arg_2) + _arg_3) + _arg_1.substring((_arg_2 + 1), _arg_1.length));
        }

        public function strNumWithCommas(_arg_1:Number):String
        {
            var _local_2:* = "";
            var _local_3:String = _arg_1.toString();
            var _local_4:int;
            var _local_5:int;
            _local_4 = (_local_3.length - 1);
            while (_local_4 > -1)
            {
                if (_local_5 == 3)
                {
                    _local_5 = 0;
                    _local_2 = ((_local_3.charAt(_local_4) + ",") + _local_2);
                }
                else
                {
                    _local_2 = (_local_3.charAt(_local_4) + _local_2);
                }
                _local_5++;
                _local_4--;
            }
            return (_local_2);
        }

        public function numToStr(_arg_1:Number, _arg_2:int=2):String
        {
            var _local_3:String = _arg_1.toString();
            if (_local_3.indexOf(".") == -1)
            {
                _local_3 = (_local_3 + ".");
            }
            var _local_4:Array = _local_3.split(".");
            while (_local_4[1].length < _arg_2)
            {
                _local_4[1] = (_local_4[1] + "0");
            }
            if (_local_4[1].length > _arg_2)
            {
                _local_4[1] = _local_4[1].substr(0, _arg_2);
            }
            if (_arg_2 > 0)
            {
                _local_3 = ((_local_4[0] + ".") + _local_4[1]);
            }
            else
            {
                _local_3 = _local_4[0];
            }
            return (_local_3);
        }

        public function copyObj(_arg_1:Object):Object
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeObject(_arg_1);
            _local_2.position = 0;
            return (_local_2.readObject());
        }

        public function copyConstructor(_arg_1:*):*
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeObject(_arg_1);
            _local_2.position = 0;
            return (_local_2.readObject() as Class);
        }

        public function distanceO(_arg_1:*, _arg_2:*):Number
        {
            return (Math.sqrt((Math.pow(int((_arg_2.x - _arg_1.x)), 2) + Math.pow(int((_arg_2.y - _arg_1.y)), 2))));
        }

        public function distanceP(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Number
        {
            return (Math.sqrt((Math.pow((_arg_3 - _arg_1), 2) + Math.pow((_arg_4 - _arg_2), 2))));
        }

        public function distanceXY(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Object
        {
            return ({
                "dx":(_arg_3 - _arg_1),
                "dy":(_arg_4 - _arg_2)
            });
        }

        public function isHouseItem(_arg_1:Object):Boolean
        {
            return (((_arg_1.sType == "House") || (_arg_1.sType == "Floor Item")) || (_arg_1.sType == "Wall Item"));
        }

        internal function validateArmor(_arg_1:*):*
        {
            var _local_10:uint;
            var _local_11:uint;
            var _local_2:Array = [];
            var _local_3:Object = {};
            var _local_4:int;
            var _local_5:int = 10;
            var _local_6:Boolean = true;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:int = _arg_1.ItemID;
            switch (_local_9)
            {
                default:
                    break;
                case 319:
                case 2083:
                    _local_7 = true;
                    _local_2 = [16, 15654, 407, 20, 15651, 409];
                    break;
                case 409:
                    _local_8 = true;
                    _local_2 = [20, 15651];
                    break;
                case 408:
                    _local_8 = true;
                    _local_2 = [17, 15653];
                    break;
                case 410:
                    _local_8 = true;
                    _local_2 = [18, 15652];
                    break;
                case 407:
                    _local_8 = true;
                    _local_2 = [16, 15654];
            }
            if (_local_7)
            {
                _local_10 = 0;
                while (_local_10 < _local_2.length)
                {
                    if (world.myAvatar.getCPByID(_local_2[_local_10]) < 302500)
                    {
                        _local_6 = false;
                    }
                    else
                    {
                        _local_6 = true;
                        if (_local_10 < 2)
                        {
                            _local_10 = 2;
                        }
                        if (((_local_10 < 5) && (_local_10 > 2))) break;
                    }
                    _local_10++;
                }
                return (_local_6);
            }
            if (_local_8)
            {
                _local_11 = 0;
                while (_local_11 < _local_2.length)
                {
                    if (world.myAvatar.getCPByID(_local_2[_local_11]) >= _arg_1.iReqCP)
                    {
                        return (true);
                    }
                    _local_11++;
                }
                return (false);
            }
            return (!((Number(_arg_1.iClass) > 0) && (world.myAvatar.getCPByID(_arg_1.iClass) < _arg_1.iReqCP)));
        }

        public function getItemInfoString(_arg_1:Object):String
        {
            var _local_3:int;
            var _local_4:*;
            var _local_5:int;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:*;
            var _local_12:*;
            var _local_13:*;
            var _local_14:*;
            var _local_15:*;
            var _local_2:* = (("<font size='14'><b>" + _arg_1.sName) + "</b></font><br>");
            if (((!(validateArmor(_arg_1))) && (_arg_1.iClass > 0)))
            {
                _local_2 = (_local_2 + "<font size='11' color='#CC0000'>");
                _local_3 = getRankFromPoints(_arg_1.iReqCP);
                _local_4 = (_arg_1.iReqCP - arrRanks[(_local_3 - 1)]);
                if (_local_4 > 0)
                {
                    _local_2 = (_local_2 + (((((("Requires " + _local_4) + " Class Points on ") + _arg_1.sClass) + ", Rank ") + _local_3) + "."));
                }
                else
                {
                    _local_2 = (_local_2 + (((("Requires " + _arg_1.sClass) + ", Rank ") + _local_3) + "."));
                }
                _local_2 = (_local_2 + "</font><br>");
            }
            if (((_arg_1.FactionID > 1) && (world.myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep)))
            {
                _local_2 = (_local_2 + "<font size='11' color='#CC0000'>");
                _local_5 = getRankFromPoints(_arg_1.iReqRep);
                _local_6 = (_arg_1.iReqRep - arrRanks[(_local_3 - 1)]);
                if (_local_6 > 0)
                {
                    _local_2 = (_local_2 + (((((("Requires " + _local_6) + " Reputation on ") + _arg_1.sFaction) + ", Rank ") + _local_5) + "."));
                }
                else
                {
                    _local_2 = (_local_2 + (((("Requires " + _arg_1.sFaction) + ", Rank ") + _local_5) + "."));
                }
                _local_2 = (_local_2 + "</font><br>");
            }
            if (((_arg_1.iQSindex >= 0) && (world.getQuestValue(_arg_1.iQSindex) < int(_arg_1.iQSvalue))))
            {
                _local_2 = (_local_2 + (("<font size='11' color='#CC0000'>Requires completion of quest \"" + _arg_1.sQuest) + '".</font><br>'));
            }
            _local_2 = (_local_2 + ("<font color='#009900'><b>" + getDisplaysType(_arg_1)));
            if ((((!(_arg_1.sES == "None")) && (!(_arg_1.sES == "co"))) && (!(_arg_1.sES == "mi"))))
            {
                if (_arg_1.EnhID > 0)
                {
                    _local_2 = (_local_2 + (", Lvl " + _arg_1.EnhLvl));
                    if (_arg_1.sES == "Weapon")
                    {
                        _local_7 = getBaseHPByLevel(_arg_1.EnhLvl);
                        _local_8 = 20;
                        _local_9 = 1;
                        _local_10 = (_arg_1.iRng / 100);
                        _local_11 = 2;
                        _local_12 = Math.round(((_local_7 / _local_8) * _local_9));
                        _local_13 = Math.round((_local_12 * _local_11));
                        _local_14 = Math.floor((_local_13 - (_local_13 * _local_10)));
                        _local_15 = Math.ceil((_local_13 + (_local_13 * _local_10)));
                        _local_2 = (_local_2 + ((((("<br>" + _local_14) + " - ") + _local_15) + " ") + _arg_1.sElmt));
                    }
                }
                else
                {
                    _local_2 = (_local_2 + " Design");
                }
            }
            _arg_1.sDesc = _arg_1.sDesc.replace(regExLineSpace, "\n");
            return (_local_2 + (((("</b></font>" + ((litePreference.data.bDebugger) ? (("Item ID: " + _arg_1.ItemID) + "<br>") : "")) + "<br>") + _arg_1.sDesc) + "<br>"));
        }

        public function getItemInfoStringB(_arg_1:Object):String
        {
            var _local_3:int;
            var _local_4:*;
            var _local_5:int;
            var _local_6:*;
            var _local_2:* = (("<font size='12'><b>" + _arg_1.sName) + "</b></font><br>");
            if (((!(validateArmor(_arg_1))) && (_arg_1.iClass > 0)))
            {
                _local_2 = (_local_2 + "<font size='10' color='#CC0000'>");
                _local_3 = getRankFromPoints(_arg_1.iReqCP);
                _local_4 = (_arg_1.iReqCP - arrRanks[(_local_3 - 1)]);
                if (_local_4 > 0)
                {
                    _local_2 = (_local_2 + (((((("Requires " + _local_4) + " Class Points on ") + _arg_1.sClass) + ", Rank ") + _local_3) + "."));
                }
                else
                {
                    _local_2 = (_local_2 + (((("Requires " + _arg_1.sClass) + ", Rank ") + _local_3) + "."));
                }
                _local_2 = (_local_2 + "</font><br>");
            }
            if (((_arg_1.FactionID > 1) && (world.myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep)))
            {
                _local_2 = (_local_2 + "<font size='10' color='#CC0000'>");
                _local_5 = getRankFromPoints(_arg_1.iReqRep);
                _local_6 = (_arg_1.iReqRep - arrRanks[(_local_3 - 1)]);
                if (_local_6 > 0)
                {
                    _local_2 = (_local_2 + (((((("Requires " + _local_6) + " Reputation on ") + _arg_1.sFaction) + ", Rank ") + _local_5) + "."));
                }
                else
                {
                    _local_2 = (_local_2 + (((("Requires " + _arg_1.sFaction) + ", Rank ") + _local_5) + "."));
                }
                _local_2 = (_local_2 + "</font><br>");
            }
            if (((_arg_1.iQSindex >= 0) && (world.getQuestValue(_arg_1.iQSindex) < int(_arg_1.iQSvalue))))
            {
                _local_2 = (_local_2 + (("<font size='11' color='#CC0000'>Requires completion of quest \"" + _arg_1.sQuest) + '".</font><br>'));
            }
            if ((((!(_arg_1.sMeta == null)) && (getDisplaysType(_arg_1) == "Pet")) && (_arg_1.sMeta.indexOf("Necromancer") > -1)))
            {
                _local_2 = (_local_2 + ("<font color='#00CCFF'><b>Battle " + getDisplaysType(_arg_1)));
            }
            else
            {
                _local_2 = (_local_2 + ("<font color='#00CCFF'><b>" + getDisplaysType(_arg_1)));
            }
            if (_arg_1.sType.toLowerCase() == "enhancement")
            {
                _local_2 = (_local_2 + (", Level " + _arg_1.iLvl));
            }
            if (((((!(_arg_1.sES == "None")) && (!(_arg_1.sES == "co"))) && (!(_arg_1.sES == "pe"))) && (!(_arg_1.sES == "mi"))))
            {
                if (_arg_1.EnhID > 0)
                {
                    _local_2 = (_local_2 + (", Level " + _arg_1.EnhLvl));
                    if (_arg_1.sES == "ar")
                    {
                        _local_2 = (_local_2 + ("<br>Rank " + getRankFromPoints(_arg_1.iQty)));
                    }
                }
                else
                {
                    if (_arg_1.sType.toLowerCase() != "enhancement")
                    {
                        _local_2 = (_local_2 + " Design");
                    }
                }
            }
            if (_arg_1.iStk > 1)
            {
                _local_2 = (_local_2 + (((" - " + _arg_1.iQty) + "/") + _arg_1.iStk));
            }
            if ((((((((((_arg_1.sES == "Weapon") || (_arg_1.sES == "co")) || (_arg_1.sES == "he")) || (_arg_1.sES == "ba")) || (_arg_1.sES == "pe")) || (_arg_1.sES == "am")) || (_arg_1.sES == "mi")) || (_arg_1.sES == "hi")) || (_arg_1.sES == "ho")))
            {
                if (_arg_1.sType.toLowerCase() != "enhancement")
                {
                    _local_2 = (_local_2 + (("<br>" + getRarityString(_arg_1.iRty)) + " Rarity"));
                }
            }
            if (_arg_1.sType.toLowerCase() != "enhancement")
            {
                _arg_1.sDesc = _arg_1.sDesc.replace(regExLineSpace, "\n");
                _local_2 = (_local_2 + ((("</b></font><br><font size='10' color='#FFFFFF'>" + ((litePreference.data.bDebugger) ? (("Item ID: " + _arg_1.ItemID) + "<br>") : "")) + _arg_1.sDesc) + "<br></font>"));
            }
            else
            {
                _local_2 = (_local_2 + "</b></font><br><font size='10' color='#FFFFFF'>");
                _local_2 = (_local_2 + "Enhancements are special items which can apply stats to your weapons and armor. Select a weapon or armor item from the list on the right, and click the <font color='#00CCFF'>\"Enhancements\"</font> button that appears below its preview.");
            }
            return (_local_2);
        }

        public function getIconByType(_arg_1:String):String
        {
            var _local_2:* = "";
            switch (_arg_1.toLowerCase())
            {
                case "axe":
                case "bow":
                case "dagger":
                case "gun":
                case "mace":
                case "polearm":
                case "staff":
                case "sword":
                case "wand":
                case "armor":
                    _local_2 = ("iw" + _arg_1.toLowerCase());
                    break;
                case "cape":
                case "helm":
                case "pet":
                case "class":
                    _local_2 = ("ii" + _arg_1.toLowerCase());
                    break;
                default:
                    _local_2 = "iibag";
            }
            return (_local_2);
        }

        public function getIconBySlot(_arg_1:String):String
        {
            var _local_2:* = "";
            switch (_arg_1.toLowerCase())
            {
                case "weapon":
                    _local_2 = "iwsword";
                    break;
                case "back":
                case "ba":
                    _local_2 = "iicape";
                    break;
                case "head":
                case "he":
                    _local_2 = "iihelm";
                    break;
                case "armor":
                case "ar":
                    _local_2 = "iiclass";
                    break;
                case "class":
                    _local_2 = "iiclass";
                    break;
                case "pet":
                case "pe":
                    _local_2 = "iipet";
                    break;
                default:
                    _local_2 = "iibag";
            }
            return (_local_2);
        }

        public function getDisplaysType(_arg_1:Object):*
        {
            var _local_2:String = ((_arg_1.sType != null) ? _arg_1.sType : "Unknown");
            var _local_3:String = _local_2.toLowerCase();
            if (((_local_3 == "clientuse") || (_local_3 == "serveruse")))
            {
                _local_2 = "Item";
            }
            if (_local_3 == "misc")
            {
                _local_2 = "Ground";
            }
            return (_local_2);
        }

        public function stringToDate(_arg_1:String):Date
        {
            var _local_2:* = Number(_arg_1.substr(0, 4));
            var _local_3:* = (Number(_arg_1.substr(5, 2)) - 1);
            var _local_4:* = Number(_arg_1.substr(8, 2));
            var _local_5:* = Number(_arg_1.substr(11, 2));
            var _local_6:* = Number(_arg_1.substr(14, 2));
            var _local_7:* = Number(_arg_1.substr(17));
            return (new Date(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7));
        }

        internal function traceObject(_arg_1:*, _arg_2:*=1):*
        {
            var _local_4:*;
            var _local_5:*;
            var _local_3:* = "";
            while (_local_3.length < _arg_2)
            {
                _local_3 = (_local_3 + " ");
            }
            _arg_2++;
            if (((typeof(_arg_1) == "object") && (!(_arg_1.length == null))))
            {
                _local_4 = 0;
                while (_local_4 < _arg_1.length)
                {
                    _local_4++;
                }
            }
            else
            {
                for (_local_5 in _arg_1)
                {
                    if (typeof(_arg_1[_local_5]) == "object")
                    {
                        traceObject(_arg_1[_local_5], _arg_2);
                    }
                }
            }
        }

        public function max(_arg_1:int, _arg_2:int):int
        {
            if (_arg_1 > _arg_2)
            {
                return (_arg_1);
            }
            return (_arg_2);
        }

        public function clamp(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            if (_arg_1 < _arg_2)
            {
                return (_arg_2);
            }
            if (_arg_1 > _arg_3)
            {
                return (_arg_3);
            }
            return (_arg_1);
        }

        public function isValidEmail(_arg_1:String):Boolean
        {
            return (Boolean(_arg_1.match(EMAIL_REGEX)));
        }

        public function closeToolTip():void
        {
            var _local_1:*;
            try
            {
                _local_1 = MovieClip(stage.getChildAt(0)).ui.ToolTip;
                _local_1.close();
            }
            catch(e:Error)
            {
            }
        }

        public function updateIcons(_arg_1:Array, _arg_2:Array, _arg_3:Object=null):*
        {
            var _local_6:MovieClip;
            var _local_7:Class;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:*;
            var _local_12:*;
            var _local_13:*;
            var _local_4:int;
            var _local_5:int;
            _local_4 = 0;
            while (_local_4 < _arg_1.length)
            {
                _local_6 = _arg_1[_local_4];
                _local_6.cnt.removeChildAt(0);
                _local_6.item = _arg_3;
                if (_local_6.item == null)
                {
                    _local_6.tQty.visible = false;
                }
                while (_local_5 < _arg_2.length)
                {
                    _local_7 = (world.getClass(_arg_2[_local_5]) as Class);
                    _local_8 = new (_local_7)();
                    _local_9 = _local_6.cnt.addChild(_local_8);
                    _local_10 = int(((42 - 8) + (4 * _local_5)));
                    _local_11 = int(((39 - 8) + (4 * _local_5)));
                    _local_12 = _local_9.width;
                    _local_13 = _local_9.height;
                    if (_local_12 > _local_13)
                    {
                        _local_9.scaleX = (_local_9.scaleY = (_local_10 / _local_12));
                    }
                    else
                    {
                        _local_9.scaleX = (_local_9.scaleY = (_local_11 / _local_13));
                    }
                    _local_9.x = ((_local_6.bg.width / 2) - (_local_9.width / 2));
                    _local_9.y = ((_local_6.bg.height / 2) - (_local_9.height / 2));
                    _local_5++;
                }
                _local_4++;
            }
        }

        public function updateItemSkill():void
        {
            var _local_1:int;
            while (_local_1 < world.actions.active.length)
            {
                if (((world.actions.active[_local_1]) && (world.actions.active[_local_1].ref == "i1")))
                {
                    updateActionObjIcon(world.actions.active[_local_1]);
                    return;
                }
                _local_1++;
            }
        }

        public function updateActionObjIcon(_arg_1:Object):void
        {
            var _local_3:MovieClip;
            var _local_4:Object;
            var _local_6:int;
            var _local_7:int;
            var _local_2:Array = world.getActIcons(_arg_1);
            var _local_5:* = 0;
            while (_local_5 < _local_2.length)
            {
                _local_3 = _local_2[_local_5];
                _local_4 = _local_3.item;
                if (_local_4 != null)
                {
                    _local_6 = 0;
                    while (_local_7 < world.myAvatar.items.length)
                    {
                        if (world.myAvatar.items[_local_7].ItemID == _local_4.ItemID)
                        {
                            _local_6 = int(world.myAvatar.items[_local_7].iQty);
                        }
                        _local_7++;
                    }
                    if (_local_6 > 0)
                    {
                        _local_3.tQty.visible = true;
                        _local_3.tQty.text = _local_6;
                    }
                    else
                    {
                        world.unequipUseableItem(_local_4);
                    }
                }
                _local_5++;
            }
        }

        public function drawChainsSmooth(_arg_1:Array, _arg_2:int, _arg_3:MovieClip):void
        {
            var _local_4:Point;
            var _local_5:Point;
            var _local_6:int;
            var _local_7:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:Point;
            var _local_12:Array;
            var _local_13:MovieClip;
            var _local_14:int;
            var _local_15:int;
            _local_6 = 1;
            while (_local_6 < _arg_1.length)
            {
                _local_4 = new Point(0, 0);
                _local_5 = new Point(0, 0);
                _local_4 = _arg_1[(_local_6 - 1)].localToGlobal(_local_4);
                _local_5 = _arg_1[_local_6].localToGlobal(_local_5);
                _local_7 = [];
                _local_8 = 0;
                _local_9 = 0;
                _local_10 = int(Math.ceil((Point.distance(_local_4, _local_5) / _arg_2)));
                if ((_local_10 % 2) == 1)
                {
                    _local_10 = (_local_10 + 1);
                }
                _local_11 = new Point();
                _local_12 = [_arg_3.fx0, _arg_3.fx1, _arg_3.fx2];
                _local_14 = -1;
                _local_8 = 0;
                while (_local_8 < _local_12.length)
                {
                    _local_7 = [];
                    _local_14 = int(((Math.random() > 0.5) ? 1 : -1));
                    _local_15 = 0;
                    _local_9 = 1;
                    while (_local_9 < _local_10)
                    {
                        _local_11 = Point.interpolate(_local_4, _local_5, (1 - (_local_9 / _local_10)));
                        if ((++_local_15 % 2) == 1)
                        {
                            _local_11.x = (_local_11.x + (_local_14 * Math.round((Math.random() * 30))));
                            _local_11.y = (_local_11.y + (_local_14 * Math.round((Math.random() * 30))));
                            _local_14 = -(_local_14);
                        }
                        _local_7.push(_local_11);
                        _local_9++;
                    }
                    _local_7.push(_local_5);
                    _local_13 = _local_12[_local_8];
                    _local_13.graphics.lineStyle(2, 0xFFFFFF, 1);
                    _local_13.graphics.moveTo(_local_4.x, _local_4.y);
                    _local_9 = 0;
                    while (_local_9 < _local_7.length)
                    {
                        _local_13.graphics.curveTo(_local_7[_local_9].x, _local_7[_local_9].y, _local_7[(_local_9 + 1)].x, _local_7[(_local_9 + 1)].y);
                        _local_9 = (_local_9 + 2);
                    }
                    _local_8++;
                }
                _local_6++;
            }
        }

        public function drawChainsLinear(_arg_1:Array, _arg_2:int, _arg_3:MovieClip):void
        {
            var _local_4:Point;
            var _local_5:Point;
            var _local_6:MovieClip;
            var _local_7:MovieClip;
            var _local_8:int;
            var _local_9:Array;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:Point;
            var _local_14:Array;
            var _local_15:MovieClip;
            _local_8 = 1;
            while (_local_8 < _arg_1.length)
            {
                _local_6 = _arg_1[(_local_8 - 1)];
                _local_7 = _arg_1[_local_8];
                _local_4 = new Point(0, (-(_local_6.height) * 0.5));
                _local_5 = new Point(0, (-(_local_7.height) * 0.5));
                _local_4 = _local_6.localToGlobal(_local_4);
                _local_5 = _local_7.localToGlobal(_local_5);
                _local_9 = [];
                _local_10 = 0;
                _local_11 = 0;
                _local_12 = int(Math.ceil((Point.distance(_local_4, _local_5) / _arg_2)));
                _local_13 = new Point();
                _local_14 = [_arg_3.fx0, _arg_3.fx1, _arg_3.fx2];
                _local_10 = 0;
                while (_local_10 < _local_14.length)
                {
                    _local_9 = [];
                    _local_11 = 1;
                    while (_local_11 < _local_12)
                    {
                        _local_13 = Point.interpolate(_local_4, _local_5, (1 - (_local_11 / (_local_12 + 1))));
                        _local_13.x = (_local_13.x + Math.round(((Math.random() * 25) - 13)));
                        _local_13.y = (_local_13.y + Math.round(((Math.random() * 25) - 13)));
                        _local_9.push(_local_13);
                        _local_11++;
                    }
                    _local_15 = _local_14[_local_10];
                    _local_15.graphics.lineStyle(5, 0xFFFFFF, 1);
                    _local_15.graphics.moveTo(_local_4.x, _local_4.y);
                    _local_11 = 0;
                    while (_local_11 < _local_9.length)
                    {
                        _local_15.graphics.lineTo(_local_9[_local_11].x, _local_9[_local_11].y);
                        _local_11++;
                    }
                    _local_15.graphics.lineTo(_local_5.x, _local_5.y);
                    _local_10++;
                }
                _local_8++;
            }
        }

        public function drawFunnel(_arg_1:Array, _arg_2:MovieClip):void
        {
            var _local_3:MovieClip;
            _arg_2.numLines = 3;
            _arg_2.lineThickness = 3;
            _arg_2.lineColors = [0x9900AA, 0, 0x220066];
            _arg_2.glowColors = [0];
            _arg_2.glowStrength = 4;
            _arg_2.glowSize = 4;
            _arg_2.dur = 500;
            _arg_2.del = 100;
            _arg_2.p1StartingValue = 0.12;
            _arg_2.p2StartingValue = 0.24;
            _arg_2.p3StartingValue = 0.36;
            _arg_2.p1EndingValue = 0.66;
            _arg_2.p2EndingValue = 0.825;
            _arg_2.p3EndingValue = 0.99;
            _arg_2.p1ScaleFactor = 0.5;
            _arg_2.p3ScaleFactor = 0.5;
            _arg_2.easingExponent = 1.5;
            _arg_2.targetMCs = _arg_1;
            _arg_2.filterArr = [];
            _arg_2.fxArr = [];
            _arg_2.ts = new Date().getTime();
            var _local_4:int;
            var _local_5:int;
            _local_4 = 0;
            while (_local_4 < _arg_2.glowColors.length)
            {
                _arg_2.filterArr.push([new GlowFilter(_arg_2.glowColors[_local_4], 1, _arg_2.glowSize, _arg_2.glowSize, _arg_2.glowStrength, 1, false, false)]);
                _local_4++;
            }
            _local_4 = 0;
            _local_5 = 0;
            var _local_6:int;
            while (_local_6 < _arg_2.numLines)
            {
                _local_3 = (_arg_2.addChild(new MovieClip()) as MovieClip);
                _local_3.filters = _arg_2.filterArr[_local_4];
                if (++_local_4 >= _arg_2.glowColors.length)
                {
                    _local_4 = 0;
                }
                _local_3.lineColor = _arg_2.lineColors[_local_5];
                if (++_local_5 >= _arg_2.lineColors.length)
                {
                    _local_5 = 0;
                }
                _arg_2.fxArr.push(_local_3);
                _local_6++;
            }
            _arg_2.addEventListener(Event.ENTER_FRAME, funnelEF, false, 0, true);
        }

        internal function funnelEF(_arg_1:Event):void
        {
            var _local_3:MovieClip;
            var _local_8:Number;
            var _local_9:Number;
            var _local_17:Point;
            var _local_18:Point;
            var _local_19:Point;
            var _local_20:Point;
            var _local_21:Point;
            var _local_22:Point;
            var _local_26:Number;
            var _local_29:Number;
            var _local_30:Number;
            var _local_2:MovieClip = MovieClip(_arg_1.currentTarget);
            var _local_4:Number = new Date().getTime();
            var _local_5:Point = new Point();
            var _local_6:Point = new Point();
            var _local_7:Point = new Point();
            var _local_10:int = 1;
            var _local_11:MovieClip = _local_2.targetMCs[0];
            var _local_12:MovieClip = _local_2.targetMCs[1];
            var _local_13:Point = _local_11.localToGlobal(new Point(0, (-(_local_11.height) / 2)));
            var _local_14:Point = _local_12.localToGlobal(new Point(0, (-(_local_12.height) / 2)));
            var _local_15:* = _local_12.width;
            var _local_16:* = _local_12.height;
            var _local_23:int = -1;
            var _local_24:int;
            var _local_25:int;
            var _local_27:Number = Math.atan2((_local_13.y - _local_14.y), (_local_13.x - _local_14.x));
            _local_27 = (_local_27 - (Math.PI / 2));
            var _local_28:int;
            while (_local_28 < _local_2.fxArr.length)
            {
                _local_3 = _local_2.fxArr[_local_28];
                _local_9 = _local_2.ts;
                _local_8 = (_local_4 - (_local_28 * _local_2.del));
                if (_local_8 > (_local_9 + _local_2.dur))
                {
                    if (_local_3.visible)
                    {
                        _local_3.visible = false;
                        _local_3.graphics.clear();
                    }
                    if (_local_28 == (_local_2.fxArr.length - 1))
                    {
                        _local_2.removeEventListener(Event.ENTER_FRAME, funnelEF);
                        if (_local_2.parent != null)
                        {
                            _local_2.parent.removeChild(_local_2);
                        }
                    }
                }
                else
                {
                    if (_local_8 >= _local_2.ts)
                    {
                        _local_29 = ((_local_8 - _local_9) / _local_2.dur);
                        _local_29 = Math.pow((1 - _local_29), _local_2.easingExponent);
                        _local_10 = (((_local_28 % 2) == 0) ? 1 : -1);
                        _local_17 = new Point((Point.interpolate(_local_13, _local_14, _local_2.p1StartingValue).x + Point.polar((_local_10 * (_local_12.height / _local_2.p1ScaleFactor)), _local_27).x), (Point.interpolate(_local_13, _local_14, _local_2.p1StartingValue).y + Point.polar((_local_10 * (_local_12.height / _local_2.p1ScaleFactor)), _local_27).y));
                        _local_18 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p1EndingValue).x, Point.interpolate(_local_13, _local_14, _local_2.p1EndingValue).y);
                        _local_19 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p2StartingValue).x, _local_14.y);
                        _local_20 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p2EndingValue).x, Point.interpolate(_local_13, _local_14, _local_2.p2EndingValue).y);
                        _local_21 = new Point((Point.interpolate(_local_13, _local_14, _local_2.p3StartingValue).x + Point.polar((-(_local_10) * (_local_12.height / _local_2.p3ScaleFactor)), _local_27).x), (Point.interpolate(_local_13, _local_14, _local_2.p3StartingValue).y + Point.polar((-(_local_10) * (_local_12.height / _local_2.p3ScaleFactor)), _local_27).y));
                        _local_22 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p3EndingValue).x, Point.interpolate(_local_13, _local_14, _local_2.p3EndingValue).y);
                        _local_5 = Point.interpolate(_local_17, _local_18, _local_29);
                        _local_6 = Point.interpolate(_local_19, _local_20, _local_29);
                        _local_7 = Point.interpolate(_local_21, _local_22, _local_29);
                        _local_26 = _local_3.lineColor;
                        _local_3.graphics.clear();
                        _local_3.graphics.lineStyle(_local_2.lineThickness, _local_26, 1);
                        _local_3.graphics.moveTo(_local_14.x, _local_14.y);
                        _local_3.graphics.curveTo(_local_5.x, _local_5.y, _local_6.x, _local_6.y);
                        _local_3.graphics.curveTo(_local_7.x, _local_7.y, _local_13.x, _local_13.y);
                        _local_30 = Math.cos(((((_local_8 - _local_9) / _local_2.dur) * Math.PI) * 2));
                        _local_30 = ((_local_30 / 2) + 0.5);
                        _local_30 = (1 - _local_30);
                        _local_3.alpha = _local_30;
                    }
                }
                _local_28++;
            }
        }

        public function updateCoreValues(_arg_1:Object):void
        {
            if (_arg_1.intLevelCap != null)
            {
                intLevelCap = _arg_1.intLevelCap;
            }
            if (_arg_1.PCstBase != null)
            {
                PCstBase = _arg_1.PCstBase;
            }
            if (_arg_1.PCstRatio != null)
            {
                PCstRatio = _arg_1.PCstRatio;
            }
            if (_arg_1.PCstGoal != null)
            {
                PCstGoal = _arg_1.PCstGoal;
            }
            if (_arg_1.GstBase != null)
            {
                GstBase = _arg_1.GstBase;
            }
            if (_arg_1.GstRatio != null)
            {
                GstRatio = _arg_1.GstRatio;
            }
            if (_arg_1.GstGoal != null)
            {
                GstGoal = _arg_1.GstGoal;
            }
            if (_arg_1.PChpBase1 != null)
            {
                PChpBase1 = _arg_1.PChpBase1;
            }
            if (_arg_1.PChpBase100 != null)
            {
                PChpBase100 = _arg_1.PChpBase100;
            }
            if (_arg_1.PChpGoal1 != null)
            {
                PChpGoal1 = _arg_1.PChpGoal1;
            }
            if (_arg_1.PChpGoal100 != null)
            {
                PChpGoal100 = _arg_1.PChpGoal100;
            }
            if (_arg_1.PChpDelta != null)
            {
                PChpDelta = _arg_1.PChpDelta;
            }
            if (_arg_1.intHPperEND != null)
            {
                intHPperEND = _arg_1.intHPperEND;
            }
            if (_arg_1.intAPtoDPS != null)
            {
                intAPtoDPS = _arg_1.intAPtoDPS;
            }
            if (_arg_1.intSPtoDPS != null)
            {
                intSPtoDPS = _arg_1.intSPtoDPS;
            }
            if (_arg_1.bigNumberBase != null)
            {
                bigNumberBase = _arg_1.bigNumberBase;
            }
            if (_arg_1.resistRating != null)
            {
                resistRating = _arg_1.resistRating;
            }
            if (_arg_1.modRating != null)
            {
                modRating = _arg_1.modRating;
            }
            if (_arg_1.baseDodge != null)
            {
                baseDodge = _arg_1.baseDodge;
            }
            if (_arg_1.baseBlock != null)
            {
                baseBlock = _arg_1.baseBlock;
            }
            if (_arg_1.baseParry != null)
            {
                baseParry = _arg_1.baseParry;
            }
            if (_arg_1.baseCrit != null)
            {
                baseCrit = _arg_1.baseCrit;
            }
            if (_arg_1.baseHit != null)
            {
                baseHit = _arg_1.baseHit;
            }
            if (_arg_1.baseHaste != null)
            {
                baseHaste = _arg_1.baseHaste;
            }
            if (_arg_1.baseMiss != null)
            {
                baseMiss = _arg_1.baseMiss;
            }
            if (_arg_1.baseResist != null)
            {
                baseResist = _arg_1.baseResist;
            }
            if (_arg_1.baseCritValue != null)
            {
                baseCritValue = _arg_1.baseCritValue;
            }
            if (_arg_1.baseBlockValue != null)
            {
                baseBlockValue = _arg_1.baseBlockValue;
            }
            if (_arg_1.baseResistValue != null)
            {
                baseResistValue = _arg_1.baseResistValue;
            }
            if (_arg_1.baseEventValue != null)
            {
                baseEventValue = _arg_1.baseEventValue;
            }
            if (_arg_1.PCDPSMod != null)
            {
                PCDPSMod = _arg_1.PCDPSMod;
            }
            if (_arg_1.curveExponent != null)
            {
                curveExponent = _arg_1.curveExponent;
            }
            if (_arg_1.statsExponent != null)
            {
                statsExponent = _arg_1.statsExponent;
            }
        }

        internal function spaceBy(_arg_1:int, _arg_2:int):String
        {
            var _local_3:String = String(_arg_1);
            while (_local_3.length < _arg_2)
            {
                _local_3 = (_local_3 + " ");
            }
            return (_local_3);
        }

        internal function spaceNumBy(_arg_1:Number, _arg_2:int):String
        {
            var _local_3:String = _arg_1.toString();
            _local_3 = _local_3.substr(0, _arg_2);
            while (_local_3.length < _arg_2)
            {
                _local_3 = (_local_3 + " ");
            }
            return (_local_3);
        }

        internal function showRatings():void
        {
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:*;
            var _local_12:*;
            var _local_13:*;
            var _local_14:*;
            var _local_15:*;
            var _local_16:*;
            var _local_1:* = world.myAvatar.dataLeaf;
            var _local_2:* = "";
            var _local_3:* = 1;
            var _local_4:* = 0;
            var _local_5:* = 0;
            _local_3 = 1;
            while (_local_3 <= 35)
            {
                if (_local_3 == 0)
                {
                    _local_3 = 1;
                }
                _local_6 = getInnateStats(_local_3);
                _local_7 = getIBudget(_local_3, 1);
                _local_8 = -1;
                _local_9 = -1;
                _local_10 = -1;
                _local_11 = -1;
                _local_12 = _local_1.sCat;
                _local_13 = copyObj(_local_1.sta);
                resetTableValues(_local_13);
                _local_14 = getBaseHPByLevel(_local_3);
                _local_15 = ((_local_14 / 20) * 0.7);
                _local_16 = (((2.25 * _local_15) / (100 / intAPtoDPS)) / 2);
                _local_4 = 0;
                while (_local_4 < stats.length)
                {
                    _local_2 = stats[_local_4];
                    _local_11 = _local_13[("$" + _local_2)];
                    switch (_local_2)
                    {
                        case "STR":
                            _local_8 = _local_16;
                            _local_13.$ap = (_local_13.$ap + (_local_11 * 2));
                            _local_13.$tcr = (_local_13.$tcr + (((_local_11 / _local_8) / 100) * 0.4));
                            break;
                    }
                    _local_4++;
                }
                _local_3 = (_local_3 + 1);
            }
        }

        public function applyCoreStatRatings(_arg_1:Object, _arg_2:Object):void
        {
            var _local_3:int = 1;
            var _local_4:* = 100;
            var _local_5:Object = world.myAvatar.getEquippedItemBySlot("Weapon");
            if (_local_5 != null)
            {
                if (_local_5.EnhLvl != null)
                {
                    _local_3 = _local_5.EnhLvl;
                }
                if (_local_5.EnhDPS != null)
                {
                    _local_4 = Number(_local_5.EnhDPS);
                }
                if (_local_4 == 0)
                {
                    _local_4 = 100;
                }
            }
            _local_4 = (_local_4 / 100);
            var _local_6:int = _arg_2.intLevel;
            var _local_7:* = "";
            var _local_8:int = getInnateStats(_local_6);
            var _local_9:Number = -1;
            var _local_10:Number = -1;
            var _local_11:Number = -1;
            var _local_12:int = -1;
            var _local_13:String = world.myAvatar.objData.sClassCat;
            var _local_14:int = getBaseHPByLevel(_local_6);
            var _local_15:int = 20;
            var _local_16:* = ((_local_14 / 20) * 0.7);
            var _local_17:Number = (((2.25 * _local_16) / (100 / intAPtoDPS)) / 2);
            resetTableValues(_arg_1);
            var _local_18:int;
            while (_local_18 < stats.length)
            {
                _local_7 = stats[_local_18];
                _local_12 = (_arg_1[("_" + _local_7)] + _arg_1[("^" + _local_7)]);
                switch (_local_7)
                {
                    case "STR":
                        _local_9 = _local_17;
                        if (_local_13 == "M1")
                        {
                            _arg_1.$sbm = (_arg_1.$sbm - (((_local_12 / _local_9) / 100) * 0.3));
                        }
                        if (_local_13 == "S1")
                        {
                            _arg_1.$ap = (_arg_1.$ap + Math.round((_local_12 * 1.4)));
                        }
                        else
                        {
                            _arg_1.$ap = (_arg_1.$ap + (_local_12 * 2));
                        }
                        if ((((((_local_13 == "M1") || (_local_13 == "M2")) || (_local_13 == "M3")) || (_local_13 == "M4")) || (_local_13 == "S1")))
                        {
                            if (_local_13 == "M4")
                            {
                                _arg_1.$tcr = (_arg_1.$tcr + (((_local_12 / _local_9) / 100) * 0.7));
                            }
                            else
                            {
                                _arg_1.$tcr = (_arg_1.$tcr + (((_local_12 / _local_9) / 100) * 0.4));
                            }
                        }
                        break;
                    case "INT":
                        _local_9 = _local_17;
                        _arg_1.$cmi = (_arg_1.$cmi - ((_local_12 / _local_9) / 100));
                        if (((_local_13.substr(0, 1) == "C") || (_local_13 == "M3")))
                        {
                            _arg_1.$cmo = (_arg_1.$cmo + ((_local_12 / _local_9) / 100));
                        }
                        if (_local_13 == "S1")
                        {
                            _arg_1.$sp = (_arg_1.$sp + Math.round((_local_12 * 1.4)));
                        }
                        else
                        {
                            _arg_1.$sp = (_arg_1.$sp + (_local_12 * 2));
                        }
                        if ((((((_local_13 == "C1") || (_local_13 == "C2")) || (_local_13 == "C3")) || (_local_13 == "M3")) || (_local_13 == "S1")))
                        {
                            if (_local_13 == "C2")
                            {
                                _arg_1.$tha = (_arg_1.$tha + (((_local_12 / _local_9) / 100) * 0.5));
                            }
                            else
                            {
                                _arg_1.$tha = (_arg_1.$tha + (((_local_12 / _local_9) / 100) * 0.3));
                            }
                        }
                        break;
                    case "DEX":
                        _local_9 = _local_17;
                        if ((((((_local_13 == "M1") || (_local_13 == "M2")) || (_local_13 == "M3")) || (_local_13 == "M4")) || (_local_13 == "S1")))
                        {
                            if (_local_13.substr(0, 1) != "C")
                            {
                                _arg_1.$thi = (_arg_1.$thi + (((_local_12 / _local_9) / 100) * 0.2));
                            }
                            if (((_local_13 == "M2") || (_local_13 == "M4")))
                            {
                                _arg_1.$tha = (_arg_1.$tha + (((_local_12 / _local_9) / 100) * 0.5));
                            }
                            else
                            {
                                _arg_1.$tha = (_arg_1.$tha + (((_local_12 / _local_9) / 100) * 0.3));
                            }
                            if (_local_13 == "M1")
                            {
                                if (_arg_1._tbl > 0.01)
                                {
                                    _arg_1.$tbl = (_arg_1.$tbl + (((_local_12 / _local_9) / 100) * 0.5));
                                }
                            }
                        }
                        if (((!(_local_13 == "M2")) && (!(_local_13 == "M3"))))
                        {
                            _arg_1.$tdo = (_arg_1.$tdo + (((_local_12 / _local_9) / 100) * 0.3));
                        }
                        else
                        {
                            _arg_1.$tdo = (_arg_1.$tdo + (((_local_12 / _local_9) / 100) * 0.5));
                        }
                        break;
                    case "WIS":
                        _local_9 = _local_17;
                        if (((((_local_13 == "C1") || (_local_13 == "C2")) || (_local_13 == "C3")) || (_local_13 == "S1")))
                        {
                            if (_local_13 == "C1")
                            {
                                _arg_1.$tcr = (_arg_1.$tcr + (((_local_12 / _local_9) / 100) * 0.7));
                            }
                            else
                            {
                                _arg_1.$tcr = (_arg_1.$tcr + (((_local_12 / _local_9) / 100) * 0.4));
                            }
                            _arg_1.$thi = (_arg_1.$thi + (((_local_12 / _local_9) / 100) * 0.2));
                        }
                        _arg_1.$tdo = (_arg_1.$tdo + (((_local_12 / _local_9) / 100) * 0.3));
                        break;
                    case "LCK":
                        _local_9 = _local_17;
                        _arg_1.$sem = (_arg_1.$sem + (((_local_12 / _local_9) / 100) * 2));
                        if (_local_13 == "S1")
                        {
                            _arg_1.$ap = (_arg_1.$ap + Math.round((_local_12 * 1)));
                            _arg_1.$sp = (_arg_1.$sp + Math.round((_local_12 * 1)));
                            _arg_1.$tcr = (_arg_1.$tcr + (((_local_12 / _local_9) / 100) * 0.3));
                            _arg_1.$thi = (_arg_1.$thi + (((_local_12 / _local_9) / 100) * 0.1));
                            _arg_1.$tha = (_arg_1.$tha + (((_local_12 / _local_9) / 100) * 0.3));
                            _arg_1.$tdo = (_arg_1.$tdo + (((_local_12 / _local_9) / 100) * 0.25));
                            _arg_1.$scm = (_arg_1.$scm + (((_local_12 / _local_9) / 100) * 2.5));
                        }
                        else
                        {
                            if (((((_local_13 == "M1") || (_local_13 == "M2")) || (_local_13 == "M3")) || (_local_13 == "M4")))
                            {
                                _arg_1.$ap = (_arg_1.$ap + Math.round((_local_12 * 0.7)));
                            }
                            if (((((_local_13 == "C1") || (_local_13 == "C2")) || (_local_13 == "C3")) || (_local_13 == "M3")))
                            {
                                _arg_1.$sp = (_arg_1.$sp + Math.round((_local_12 * 0.7)));
                            }
                            _arg_1.$tcr = (_arg_1.$tcr + (((_local_12 / _local_9) / 100) * 0.2));
                            _arg_1.$thi = (_arg_1.$thi + (((_local_12 / _local_9) / 100) * 0.1));
                            _arg_1.$tha = (_arg_1.$tha + (((_local_12 / _local_9) / 100) * 0.1));
                            _arg_1.$tdo = (_arg_1.$tdo + (((_local_12 / _local_9) / 100) * 0.1));
                            _arg_1.$scm = (_arg_1.$scm + (((_local_12 / _local_9) / 100) * 5));
                        }
                        break;
                }
                _local_18++;
            }
            _arg_1.wDPS = (Math.round((((getBaseHPByLevel(_local_3) / _local_15) * _local_4) * PCDPSMod)) + Math.round((_arg_1.$ap / intAPtoDPS)));
            _arg_1.mDPS = (Math.round((((getBaseHPByLevel(_local_3) / _local_15) * _local_4) * PCDPSMod)) + Math.round((_arg_1.$sp / intSPtoDPS)));
        }

        public function coeffToPct(_arg_1:Number):String
        {
            return (Number((_arg_1 * 100)).toFixed(2));
        }

        public function getIBudget(_arg_1:int, _arg_2:int):int
        {
            if (_arg_1 < 1)
            {
                _arg_1 = 1;
            }
            if (_arg_1 > intLevelCap)
            {
                _arg_1 = intLevelCap;
            }
            if (_arg_2 < 1)
            {
                _arg_2 = 1;
            }
            _arg_1 = Math.round(((_arg_1 + _arg_2) - 1));
            return (Math.round((GstBase + (Math.pow(((_arg_1 - 1) / (intLevelCap - 1)), statsExponent) * (GstGoal - GstBase)))));
        }

        public function getInnateStats(_arg_1:int):int
        {
            if (_arg_1 < 1)
            {
                _arg_1 = 1;
            }
            if (_arg_1 > intLevelCap)
            {
                _arg_1 = intLevelCap;
            }
            return (Math.round((PCstBase + (Math.pow(((_arg_1 - 1) / (intLevelCap - 1)), statsExponent) * (PCstGoal - PCstBase)))));
        }

        public function getBaseHPByLevel(_arg_1:*):*
        {
            if (_arg_1 < 1)
            {
                _arg_1 = 1;
            }
            if (_arg_1 > intLevelCap)
            {
                _arg_1 = intLevelCap;
            }
            return (Math.round((PChpBase1 + (Math.pow(((_arg_1 - 1) / (intLevelCap - 1)), curveExponent) * PChpDelta))));
        }

        public function catCodeToName(_arg_1:String):String
        {
            switch (_arg_1)
            {
                case "M1":
                    return ("Fighter");
                case "M2":
                    return ("Thief");
                case "M3":
                    return ("Hybrid");
                case "M4":
                    return ("Armsman");
                case "C1":
                    return ("Wizard");
                case "C2":
                    return ("Healer");
                case "C3":
                    return ("spellbreaker");
                case "S1":
                    return ("Lucky");
                default:
                    return (null);
            }
        }

        public function resetTableValues(_arg_1:Object):void
        {
            _arg_1._ap = 0;
            _arg_1.$ap = 0;
            _arg_1._sp = 0;
            _arg_1.$sp = 0;
            _arg_1._tbl = 0;
            _arg_1._tpa = 0;
            _arg_1._tdo = 0;
            _arg_1._tcr = 0;
            _arg_1._thi = 0;
            _arg_1._tha = 0;
            _arg_1._tre = 0;
            _arg_1.$tbl = baseBlock;
            _arg_1.$tpa = baseParry;
            _arg_1.$tdo = baseDodge;
            _arg_1.$tcr = baseCrit;
            _arg_1.$thi = baseHit;
            _arg_1.$tha = baseHaste;
            _arg_1.$tre = baseResist;
            _arg_1._cpo = 1;
            _arg_1._cpi = 1;
            _arg_1._cao = 1;
            _arg_1._cai = 1;
            _arg_1._cmo = 1;
            _arg_1._cmi = 1;
            _arg_1._cdo = 1;
            _arg_1._cdi = 1;
            _arg_1._cho = 1;
            _arg_1._chi = 1;
            _arg_1._cmc = 1;
            _arg_1.$cpo = 1;
            _arg_1.$cpi = 1;
            _arg_1.$cao = 1;
            _arg_1.$cai = 1;
            _arg_1.$cmo = 1;
            _arg_1.$cmi = 1;
            _arg_1.$cdo = 1;
            _arg_1.$cdi = 1;
            _arg_1.$cho = 1;
            _arg_1.$chi = 1;
            _arg_1.$cmc = 1;
            _arg_1._scm = baseCritValue;
            _arg_1._sbm = baseBlockValue;
            _arg_1._srm = baseResistValue;
            _arg_1._sem = baseEventValue;
            _arg_1.$scm = baseCritValue;
            _arg_1.$sbm = baseBlockValue;
            _arg_1.$srm = baseResistValue;
            _arg_1.$sem = baseEventValue;
            _arg_1._shb = 0;
            _arg_1._smb = 0;
            _arg_1.$shb = 0;
            _arg_1.$smb = 0;
        }

        public function getCategoryStats(_arg_1:String, _arg_2:int):Object
        {
            var _local_3:* = getInnateStats(_arg_2);
            var _local_4:* = classCatMap[_arg_1].ratios;
            var _local_5:* = {};
            var _local_6:* = "";
            var _local_7:int;
            while (_local_7 < stats.length)
            {
                _local_6 = stats[_local_7];
                _local_5[_local_6] = Math.round((_local_4[_local_7] * _local_3));
                _local_7++;
            }
            return (_local_5);
        }

        public function applyAuraEffect(_arg_1:*, _arg_2:*):*
        {
            switch (_arg_1.typ)
            {
                case "+":
                    _arg_2[("$" + _arg_1.sta)] = (_arg_2[("$" + _arg_1.sta)] + Number(_arg_1.val));
                    return;
                case "-":
                    _arg_2[("$" + _arg_1.sta)] = (_arg_2[("$" + _arg_1.sta)] - Number(_arg_1.val));
                    return;
                case "*":
                    _arg_2[("$" + _arg_1.sta)] = Math.round((_arg_2[("$" + _arg_1.sta)] * Number(_arg_1.val)));
                    return;
            }
        }

        public function removeAuraEffect(_arg_1:*, _arg_2:*):*
        {
            switch (_arg_1.typ)
            {
                case "+":
                    _arg_2[("$" + _arg_1.sta)] = (_arg_2[("$" + _arg_1.sta)] - Number(_arg_1.val));
                    return;
                case "-":
                    _arg_2[("$" + _arg_1.sta)] = (_arg_2[("$" + _arg_1.sta)] + Number(_arg_1.val));
                    return;
                case "*":
                    _arg_2[("$" + _arg_1.sta)] = Math.round((_arg_2[("$" + _arg_1.sta)] / Number(_arg_1.val)));
            }
        }

        public function getStatsA(_arg_1:Object, _arg_2:String):Object
        {
            var _local_6:Object;
            var _local_3:int = ((_arg_1.sType.toLowerCase() == "enhancement") ? _arg_1.iLvl : _arg_1.EnhLvl);
            var _local_4:int = ((_arg_1.sType.toLowerCase() == "enhancement") ? _arg_1.iRty : _arg_1.EnhRty);
            var _local_5:int = Math.round((getIBudget(_local_3, _local_4) * ratiosBySlot[_arg_2]));
            var _local_7:* = -1;
            var _local_8:* = ["iEND", "iSTR", "iINT", "iDEX", "iWIS", "iLCK"];
            var _local_9:* = 0;
            var _local_10:* = "";
            var _local_11:* = {};
            var _local_12:* = 0;
            var _local_13:int;
            var _local_14:Object = {};
            world.initPatternTree();
            if (_arg_1.PatternID != null)
            {
                _local_6 = world.enhPatternTree[_arg_1.PatternID];
            }
            if (_arg_1.EnhPatternID != null)
            {
                _local_6 = world.enhPatternTree[_arg_1.EnhPatternID];
            }
            if (_local_6 != null)
            {
                _local_13 = 0;
                while (_local_13 < stats.length)
                {
                    _local_10 = ("i" + stats[_local_13]);
                    if (_local_6[_local_10] != null)
                    {
                        _local_11[_local_10] = Math.round(((_local_5 * _local_6[_local_10]) / 100));
                        _local_12 = (_local_12 + _local_11[_local_10]);
                    }
                    _local_13++;
                }
                _local_9 = 0;
                while (_local_12 < _local_5)
                {
                    _local_10 = _local_8[_local_9];
                    if (_local_11[_local_10] != null)
                    {
                        _local_11[_local_10]++;
                        _local_12++;
                    }
                    if (++_local_9 > (_local_8.length - 1))
                    {
                        _local_9 = 0;
                    }
                }
                _local_13 = 0;
                while (_local_13 < stats.length)
                {
                    _local_7 = _local_11[("i" + stats[_local_13])];
                    if (((!(_local_7 == null)) && (!(_local_7 == "0"))))
                    {
                        _local_14[("$" + stats[_local_13])] = _local_7;
                    }
                    _local_13++;
                }
            }
            return (_local_14);
        }

        public function getDisplayEnhName(_arg_1:Object):String
        {
            if (((_arg_1) && (_arg_1.hasOwnProperty("DIS"))))
            {
                switch (_arg_1.sName)
                {
                    case "Vim":
                    case "Examen":
                    case "Pneuma":
                    case "Anima":
                        return (_arg_1.sName);
                    case "Hearty":
                        return ("Grimskull");
                    default:
                        return ("Forge");
                }
            }
            if (_arg_1)
            {
                return (_arg_1.sName);
            }
            return ("");
        }

        public function getDisplayEnhTraitName(_arg_1:Object):String
        {
            switch (_arg_1.sName)
            {
                case "Vim":
                case "Examen":
                    return ("Ether");
                case "Pneuma":
                case "Anima":
                    return ("Clairvoyance");
                default:
                    return (_arg_1.sName);
            }
        }

        public function getFullStatName(_arg_1:String):String
        {
            var _local_2:* = "";
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1.indexOf("str") > -1)
            {
                _local_2 = "Strength";
            }
            if (_arg_1.indexOf("int") > -1)
            {
                _local_2 = "Intellect";
            }
            if (_arg_1.indexOf("dex") > -1)
            {
                _local_2 = "Dexterity";
            }
            if (_arg_1.indexOf("wis") > -1)
            {
                _local_2 = "Wisdom";
            }
            if (_arg_1.indexOf("end") > -1)
            {
                _local_2 = "Endurance";
            }
            if (_arg_1.indexOf("lck") > -1)
            {
                _local_2 = "Luck";
            }
            if (_arg_1.indexOf("tha") > -1)
            {
                _local_2 = "Haste";
            }
            if (_arg_1.indexOf("thi") > -1)
            {
                _local_2 = "Hit";
            }
            if (_arg_1.indexOf("tcr") > -1)
            {
                _local_2 = "Critcal Hit";
            }
            if (_arg_1.indexOf("tcm") > -1)
            {
                _local_2 = "Crit Value";
            }
            if (_arg_1.indexOf("tdo") > -1)
            {
                _local_2 = "Evasion";
            }
            return (_local_2);
        }

        public function getRarityString(_arg_1:int):String
        {
            var _local_3:Object;
            var _local_2:Array = [{
                "val":0,
                "sName":"Unknown"
            }, {
                "val":10,
                "sName":"Unknown"
            }, {
                "val":11,
                "sName":"Common"
            }, {
                "val":12,
                "sName":"Weird"
            }, {
                "val":13,
                "sName":"Awesome"
            }, {
                "val":14,
                "sName":"1% Drop"
            }, {
                "val":15,
                "sName":"5% Drop"
            }, {
                "val":16,
                "sName":"Boss Drop"
            }, {
                "val":17,
                "sName":"Secret"
            }, {
                "val":18,
                "sName":"Junk"
            }, {
                "val":19,
                "sName":"Impossible"
            }, {
                "val":20,
                "sName":"Artifact"
            }, {
                "val":21,
                "sName":"Limited Time Drop"
            }, {
                "val":68,
                "sName":"New Collection Chest"
            }, {
                "val":23,
                "sName":"Crazy"
            }, {
                "val":24,
                "sName":"Expensive"
            }, {
                "val":30,
                "sName":"Rare"
            }, {
                "val":35,
                "sName":"Epic"
            }, {
                "val":40,
                "sName":"Import Item"
            }, {
                "val":50,
                "sName":"Seasonal Item"
            }, {
                "val":55,
                "sName":"Seasonal Rare"
            }, {
                "val":60,
                "sName":"Event Item"
            }, {
                "val":65,
                "sName":"Event Rare"
            }, {
                "val":70,
                "sName":"Limited Rare"
            }, {
                "val":75,
                "sName":"Collector's Rare"
            }, {
                "val":80,
                "sName":"Promotional Item"
            }, {
                "val":90,
                "sName":"Ultra Rare"
            }, {
                "val":95,
                "sName":"Super Mega Ultra Rare"
            }, {
                "val":100,
                "sName":"Legendary Item"
            }];
            var _local_4:int = (_local_2.length - 1);
            while (_local_4 > -1)
            {
                _local_3 = _local_2[_local_4];
                if (_arg_1 >= _local_3.val)
                {
                    return (_local_3.sName);
                }
                _local_4--;
            }
            return ("Common");
        }

        public function toggleItemEquip(_arg_1:Object):Boolean
        {
            var _local_2:* = world.getUoLeafById(world.myAvatar.uid);
            var _local_3:Boolean;
            if (_local_2.intState != 1)
            {
                MsgBox.notify("Action cannot be performed during combat!");
            }
            else
            {
                if (world.bPvP)
                {
                    MsgBox.notify("Items may not be equipped or unequipped during a PvP match!");
                }
                else
                {
                    if (_arg_1.bEquip == 1)
                    {
                        if (((_arg_1.sES == "Weapon") || (_arg_1.sES == "ar")))
                        {
                            MsgBox.notify("Selected Item cannot be unequipped!");
                        }
                        else
                        {
                            _local_3 = true;
                            if (_arg_1.sType.toLowerCase() != "item")
                            {
                                world.sendUnequipItemRequest(_arg_1);
                            }
                            else
                            {
                                world.unequipUseableItem(_arg_1);
                            }
                        }
                    }
                    else
                    {
                        if (((_arg_1.bUpg == 1) && (!(world.myAvatar.isUpgraded()))))
                        {
                            showUpgradeWindow();
                        }
                        else
                        {
                            if (int(_arg_1.EnhLvl) > int(world.myAvatar.objData.intLevel))
                            {
                                MsgBox.notify("Level requirement not met!");
                            }
                            else
                            {
                                if (((!(_arg_1.sType.toLowerCase() == "item")) && (((((!(_arg_1.sES == "mi")) && (!(_arg_1.sES == "co"))) && (!(_arg_1.sES == "pe"))) && (!(_arg_1.sES == "am"))) && (!(_arg_1.EnhID > 0)))))
                                {
                                    MsgBox.notify("Selected item requires enhancement!");
                                }
                                else
                                {
                                    if (_arg_1.sType.toLowerCase() != "item")
                                    {
                                        _local_3 = world.sendEquipItemRequest(_arg_1);
                                    }
                                    else
                                    {
                                        _local_3 = true;
                                        world.equipUseableItem(_arg_1);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return (_local_3);
        }

        public function tryEnhance(_arg_1:Array, _arg_2:Object, _arg_3:Boolean=false):void
        {
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                if (_arg_2.iLvl > world.myAvatar.objData.intLevel)
                {
                    MsgBox.notify("Level requirement not met!");
                }
                else
                {
                    if (_arg_1.EnhID == _arg_2.ItemID)
                    {
                        MsgBox.notify("Selected Enhancement already applied to item!");
                    }
                    else
                    {
                        if (_arg_3)
                        {
                            world.sendEnhItemRequestShop(_arg_1, _arg_2);
                        }
                        else
                        {
                            world.sendEnhItemRequestLocal(_arg_1, _arg_2);
                        }
                    }
                }
            }
        }

        public function doIHaveEnhancements():Boolean
        {
            var _local_1:Object;
            for each (_local_1 in world.myAvatar.items)
            {
                if (_local_1.sType.toLowerCase() == "enhancement")
                {
                    return (true);
                }
            }
            return (false);
        }

        public function isItemEnhanceable(_arg_1:Object):Boolean
        {
            return (["Weapon", "he", "ba", "pe", "ar"].indexOf(_arg_1.sES) >= 0);
        }

        public function resetInvTreeByItemID(ItemID:int):*
        {
            var item:Object;
            try
            {
                item = world.invTree[ItemID];
                if (("EnhID" in item))
                {
                    item.EnhID = -1;
                }
                if (("EnhRty" in item))
                {
                    item.EnhRty = -1;
                }
                if (("EnhDPS" in item))
                {
                    item.EnhDPS = -1;
                }
                if (("EnhRng" in item))
                {
                    item.EnhRng = -1;
                }
                if (("EnhLvl" in item))
                {
                    item.EnhLvl = -1;
                }
                if (("EnhPatternID" in item))
                {
                    item.EnhPatternID = -1;
                }
            }
            catch(e:Error)
            {
            }
        }

        public function isMergeShop(_arg_1:Object):Boolean
        {
            var _local_2:Object;
            for each (_local_2 in _arg_1.items)
            {
                if (("turnin" in _local_2))
                {
                    return (true);
                }
            }
            return (false);
        }

        public function recursiveStop(_arg_1:MovieClip):void
        {
            var _local_2:DisplayObject;
            var _local_3:int;
            var _local_4:MovieClip;
            if (_arg_1 == null)
            {
                return;
            }
            while (_local_3 < _arg_1.numChildren)
            {
                _local_2 = _arg_1.getChildAt(_local_3);
                if ((_local_2 is MovieClip))
                {
                    _local_4 = MovieClip(_local_2);
                    if (_local_4.totalFrames > 1)
                    {
                        _local_4.gotoAndStop(_local_4.totalFrames);
                    }
                    else
                    {
                        _local_4.stop();
                    }
                    recursiveStop(_local_4);
                }
                _local_3++;
            }
        }

        public function getTravelMapData():void
        {
            var _local_4:Class;
            if (((ui == null) || (world == null) || (world.objInfo == null)))
            {
                return;
            }
            if (ui.getChildByName("travelLoaderMC"))
            {
                return;
            }
            try
            {
                _local_4 = (world.getClass("mcLoader") as Class);
                if (_local_4 != null)
                {
                    travelLoaderMC = new _local_4();
                    travelLoaderMC.x = 400;
                    travelLoaderMC.y = 211;
                    travelLoaderMC.name = "travelLoaderMC";
                    ui.addChild(travelLoaderMC);
                }
            }
            catch(e:Error)
            {
                travelLoaderMC = null;
            }
            var _local_1:String = ("api/data/travelmap?v=" + ((world.objInfo["sVersion"] == null) ? "0" : world.objInfo["sVersion"]));
            var _local_2:URLLoader = new URLLoader();
            if ((((this.loaderInfo.url.toLowerCase().indexOf("file://") >= 0) || (this.loaderInfo.url.toLowerCase().indexOf("cdn.aq.com") >= 0)) || (this.loaderInfo.url.toLowerCase().indexOf("aqworldscdn.aq.com") >= 0)))
            {
                _local_1 = ("https://game.aq.com/game/" + _local_1);
            }
            else
            {
                _local_1 = (params.sURL + _local_1);
            }
            var _local_3:URLRequest = new URLRequest(_local_1);
            _local_3.method = URLRequestMethod.GET;
            _local_2.addEventListener(Event.COMPLETE, onTravelMapComplete, false, 0, true);
            _local_2.addEventListener(ProgressEvent.PROGRESS, onTravelMapProgress, false, 0, true);
            _local_2.addEventListener(IOErrorEvent.IO_ERROR, onTravelError, false, 0, true);
            try
            {
                _local_2.load(_local_3);
            }
            catch(loadError:Error)
            {
                onTravelError(null);
            }
        }

        private function onTravelMapComplete(_arg_1:Event):void
        {
            var _local_2:String;
            var _local_3:Object;
            var _local_4:Loader;
            try
            {
                if (((_arg_1 == null) || (_arg_1.target == null) || (_arg_1.target.data == null) || (ui == null) || (ui.mcPopup == null) || (ui.mcPopup.mcMap == null) || (world == null) || (world.objInfo == null)))
                {
                    throw new Error("Invalid travel map response");
                }
                _local_2 = String(_arg_1.target.data);
                _local_3 = com.adobe.serialization.json.JSON.decode(_local_2);
                if (_local_3 == null)
                {
                    throw new Error("Invalid travel map JSON");
                }
                travelMapData = _local_3;
                WorldMapData = new worldMap(travelMapData);
                TRAVEL_DATA_READY = true;
                while (ui.mcPopup.mcMap.numChildren > 0)
                {
                    ui.mcPopup.mcMap.removeChildAt(0);
                }
                if (((world.objInfo.sMap == null) || (String(world.objInfo.sMap).length < 1)))
                {
                    throw new Error("Missing travel map asset");
                }
                _local_4 = new Loader();
                _local_4.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onTravelAssetError, false, 0, true);
                _local_4.load(new URLRequest((serverFilePath + world.objInfo.sMap)), new LoaderContext(false, ApplicationDomain.currentDomain));
                ui.mcPopup.mcMap.addChild(_local_4);
            }
            catch(e:Error)
            {
                onTravelError(null);
            }
        }

        private function onTravelAssetError(_arg_1:IOErrorEvent):void
        {
            onTravelError(_arg_1);
        }

        private function onTravelMapProgress(_arg_1:ProgressEvent):void
        {
            if (((_arg_1 == null) || (_arg_1.bytesTotal <= 0)))
            {
                return;
            }
            bLoaded = _arg_1.bytesLoaded;
            bTotal = _arg_1.bytesTotal;
            var _local_2:int = int(((bLoaded / bTotal) * 100));
            if (((travelLoaderMC != null) && (travelLoaderMC.mcPct != null)))
            {
                travelLoaderMC.mcPct.text = (_local_2 + "%");
            }
            if (((bLoaded >= bTotal) && (travelLoaderMC != null)))
            {
                if (travelLoaderMC.parent != null)
                {
                    travelLoaderMC.parent.removeChild(travelLoaderMC);
                }
                travelLoaderMC = null;
            }
        }

        private function onTravelError(_arg_1:IOErrorEvent):void
        {
            if (travelLoaderMC != null)
            {
                if (travelLoaderMC.parent != null)
                {
                    travelLoaderMC.parent.removeChild(travelLoaderMC);
                }
                travelLoaderMC = null;
            }
            if (mcConnDetail != null)
            {
                mcConnDetail.showConn("Error loading travel map");
            }
        }

        public function checkPasswordStrength(_arg_1:String):int
        {
            var _local_2:Number = 0;
            var _local_3:Array = _arg_1.split("");
            var _local_4:Array = [];
            var _local_5:uint;
            var _local_6:String = _local_3[0];
            var _local_7:Boolean;
            var _local_8:String = _arg_1.toLowerCase();
            var _local_9:uint;
            while (_local_9 < weakPass.length)
            {
                if (_local_8 == weakPass[_local_9])
                {
                    return (-1);
                }
                _local_9++;
            }
            var _local_10:uint;
            while (_local_10 < _local_3.length)
            {
                if (((!(_local_7)) && (!(_local_6 == _local_3[_local_10]))))
                {
                    _local_7 = true;
                }
                if (_local_10 == 0)
                {
                    _local_2 = (_local_2 + 4);
                    _local_4.push(_local_3[_local_10]);
                }
                else
                {
                    if (_local_10 < 8)
                    {
                        if (!isRepeat(_local_4, _local_3[_local_10]))
                        {
                            _local_4.push(_local_3[_local_10]);
                            _local_2 = (_local_2 + 2);
                        }
                        else
                        {
                            _local_2 = (_local_2 + 2);
                        }
                    }
                    else
                    {
                        if (_local_10 < 21)
                        {
                            if (!isRepeat(_local_4, _local_3[_local_10]))
                            {
                                _local_4.push(_local_3[_local_10]);
                                _local_2 = (_local_2 + 1.5);
                            }
                            else
                            {
                                _local_2 = (_local_2 + 1.5);
                            }
                        }
                        else
                        {
                            if (!isRepeat(_local_4, _local_3[_local_10]))
                            {
                                _local_4.push(_local_3[_local_10]);
                                _local_2 = (_local_2 + 1);
                            }
                            else
                            {
                                _local_2 = (_local_2 + 1);
                            }
                        }
                    }
                }
                if (((_local_5 < 6) && (!(isAlphaChar(_local_3[_local_10])))))
                {
                    _local_2++;
                    _local_5++;
                }
                _local_10++;
            }
            return ((_local_7) ? _local_2 : -1);
        }

        private function isAlphaChar(_arg_1:String):Boolean
        {
            var _local_2:uint = _arg_1.charCodeAt(0);
            return ((((_local_2 >= 65) && (_local_2 < 123)) || ((_local_2 >= 48) && (_local_2 < 58))) ? true : false);
        }

        private function isRepeat(_arg_1:Array, _arg_2:String):Boolean
        {
            var _local_3:uint;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3] == _arg_2)
                {
                    return (true);
                }
                _local_3++;
            }
            return (false);
        }

        public function loadGameMenu():void
        {
            onLoadMaster(gameMenuCallBack, assetsContext, "gameMenu/" + world.objInfo.gMenu, null, gameMenuErrorHandler);
        }

        public function MenuShow():void
        {
            try
            {
                if (!mcGameMenu)
                {
                    return;
                }
                if (mcGameMenu.currentLabel == "Open")
                {
                    mcGameMenu.gotoAndPlay("Close");
                }
                else
                {
                    mcGameMenu.gotoAndStop("Open");
                }
            }
            catch(e)
            {
            }
        }

        private function gameMenuCallBack(_arg_1:Event):void
        {
            try
            {
                ui.removeChild(mcGameMenu);
            }
            catch(e)
            {
            }
            mcGameMenu = null;
            var _local_2:* = (assetsDomain.getDefinition("GameMenu") as Class);
            mcGameMenu = MovieClip(new (_local_2)());
            mcGameMenu.name = "gameMenu";
            mcGameMenu.visible = (!(world.strMapName == "reenstest"));
            mcGameMenu.x = 750;
            ui.addChild(mcGameMenu);
        }

        private function gameMenuErrorHandler(_arg_1:IOErrorEvent):void
        {
        }

        public function menuClose():void
        {
            try
            {
                if (firstMenu)
                {
                    firstMenu = false;
                }
                else
                {
                    if (mcGameMenu.currentLabel != "Close")
                    {
                        mcGameMenu.gotoAndPlay("Close");
                    }
                }
            }
            catch(e)
            {
            }
        }

        public function openMenu():void
        {
            try
            {
                if (mcGameMenu.currentLabel != "Open")
                {
                    mcGameMenu.gotoAndPlay("Open");
                }
            }
            catch(e)
            {
            }
        }

        public function getFilePath():String
        {
            return (serverFilePath);
        }

        public function getGamePath():String
        {
            return (serverGamePath);
        }

        public function initWorld():void
        {
            if (world != null)
            {
                world.killTimers();
                world.killListeners();
                this.removeChild(world);
                world = null;
            }
            world = new World(this);
            this.addChildAt(world, getChildIndex(ui));
        }

        public function grayAll(_arg_1:DisplayObjectContainer):void
        {
            var _local_2:DisplayObjectContainer;
            var _local_3:int;
            var _local_4:int;
            if (_arg_1 == null)
            {
                return;
            }
            if (((_arg_1 is MovieClip) && (!(_arg_1 == this))))
            {
                (_arg_1 as MovieClip).stop();
            }
            if (_arg_1.numChildren)
            {
                _local_4 = _arg_1.numChildren;
                while (_local_3 < _local_4)
                {
                    if ((_arg_1.getChildAt(_local_3) is DisplayObjectContainer))
                    {
                        _local_2 = (_arg_1.getChildAt(_local_3) as DisplayObjectContainer);
                        if (_local_2.numChildren)
                        {
                            makeGrayscale(_local_2);
                        }
                        else
                        {
                            if ((_local_2 is MovieClip))
                            {
                                makeGrayscale((_local_2 as MovieClip));
                            }
                        }
                    }
                    _local_3++;
                }
            }
        }

        public function testJSCallback():void
        {
        }

        public function onAddedToStage(_arg_1:Event):void
        {
            Game.root = this;
            this.stage.showDefaultContextMenu = false;
            stage.stageFocusRect = false;
            mcConnDetail = new ConnDetailMC(this);

            serverGamePath = "https://nightvaults.com/";
            serverFilePath = serverGamePath + "gamefiles/";
            sFilePath = serverFilePath;

            gotoAndPlay((((charCount() > 0) && (litePreference.data.bCharSelect)) ? "Select" : "Login"));
            if (userPreference.data.quality != "AUTO")
            {
                stage.quality = userPreference.data.quality;
            }
        }

        public function init():void
        {
            var _local_1:*;
            ISWEB = params.isWeb;
            extCall = new ExternalCalls(true, params.strSourceID, (this as MovieClip));
            for (_local_1 in params)
            {
            }
            if (MsgBox)
            {
                MsgBox.visible = false;
            }
            IsEU = params.isEU;
            readQueryString();
            if (((mcLogin) && (mcLogin.fbConnect)))
            {
                mcLogin.fbConnect.visible = showFB;
            }
            extCall.setGameObject(swfObj);
            if (params.sURL == null)
            {
                params.sURL = "https://nightvaults.com/";
            }
            serverPath = params.sURL;
            FacebookConnect.RegisterGame(this);
            if (params.doSignup)
            {
                params.doSignup = false;
                gotoAndPlay("Account");
            }
        }

        public function FBMessage(_arg_1:*, _arg_2:*):*
        {
            FacebookConnect.handleFBMessage(_arg_1, _arg_2);
        }

        public function SendMessage(_arg_1:*, _arg_2:*):*
        {
        }

        public function FB_showFeedDialog(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            if (ISWEB)
            {
                extCall.showFeedDialog(_arg_1, _arg_2, _arg_3);
            }
        }

        public function toggleFullScreen():void
        {
            var _local_1:Rectangle;
            if (stage["displayState"] == StageDisplayState.NORMAL)
            {
                _local_1 = new Rectangle(0, 0, 960, 550);
                try
                {
                    stage["fullScreenSourceRect"] = _local_1;
                    stage["displayState"] = StageDisplayState.FULL_SCREEN;
                }
                catch(error:Error)
                {
                }
            }
            else
            {
                stage["displayState"] = StageDisplayState.NORMAL;
            }
        }

        public function showBallyhooAd(_arg_1:String):void
        {
            stage["displayState"] = StageDisplayState.NORMAL;
            extCall.showIt(_arg_1);
        }

        public function callJSFunction(_arg_1:String):void
        {
            extCall.callJSFunction(_arg_1);
        }

        private function readQueryString():*
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:Array;
            var _local_4:*;
            var _local_5:*;
            var _local_6:String;
            var _local_7:String;
            var _local_8:String;
            try
            {
                _local_1 = "";
                if (ISWEB)
                {
                    _local_1 = extCall.getQueryString();
                }
                if (_local_1)
                {
                    _local_3 = _local_1.split("&");
                    _local_4 = 0;
                    _local_5 = -1;
                    while (_local_4 < _local_3.length)
                    {
                        _local_6 = _local_3[_local_4];
                        if ((_local_5 = _local_6.indexOf("=")) > 0)
                        {
                            _local_7 = _local_6.substring(0, _local_5);
                            _local_8 = _local_6.substring((_local_5 + 1));
                            querystring[_local_7] = _local_8;
                        }
                        _local_4++;
                    }
                }
                for (_local_2 in querystring)
                {
                }
            }
            catch(e:Error)
            {
            }
        }

        public function initLogin():void
        {
            var curTS:Number;
            var iDiff:Number;
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_StageLogin);
            mcLogin.ni.tabIndex = 1;
            mcLogin.pi.tabIndex = 2;
            mcLogin.ni.removeEventListener(FocusEvent.FOCUS_IN, onUserFocus);
            mcLogin.ni.removeEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
            mcLogin.pi.removeEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
            mcLogin.btnLogin.removeEventListener(MouseEvent.CLICK, onLoginClick);
            mcLogin.btnFBLogin.removeEventListener(MouseEvent.CLICK, onFBLoginClick);
            mcLogin.mcForgotPassword.removeEventListener(MouseEvent.CLICK, onForgotPassword);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, key_StageLogin);
            mcLogin.ni.addEventListener(FocusEvent.FOCUS_IN, onUserFocus);
            mcLogin.ni.addEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
            mcLogin.pi.addEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
            mcLogin.btnLogin.addEventListener(MouseEvent.CLICK, onLoginClick);
            mcLogin.btnFBLogin.addEventListener(MouseEvent.CLICK, onFBLoginClick);
            mcLogin.mcForgotPassword.addEventListener(MouseEvent.CLICK, onForgotPassword);
            mcLogin.mcManageAccount.addEventListener(MouseEvent.CLICK, onManageClick);
            loadUserPreference();
            mcLogin.warning.s = String("Sorry! You have been disconnected. \n You will be able to login after $s seconds.");
            mcLogin.warning.visible = false;
            mcLogin.warning.alpha = 0;
            if (params.sURL != null)
            {
                mcLogin.mcLogo.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + params.sTitle);
            }
            if (("logoutWarningTS" in userPreference.data))
            {
                curTS = new Date().getTime();
                iDiff = ((userPreference.data.logoutWarningTS + (userPreference.data.logoutWarningDur * 1000)) - curTS);
                if (iDiff > 60000)
                {
                    userPreference.data.logoutWarningDur = 60;
                    userPreference.data.logoutWarningTS = curTS;
                    try
                    {
                        userPreference.flush();
                    }
                    catch(e:Error)
                    {
                    }
                }
                if (iDiff > 1000)
                {
                    initLoginWarning();
                }
            }
        }

        public function onBtnDn(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            _local_2 = "https://nightvaults.com/";
            navigateToURL(new URLRequest(_local_2), "_blank");
        }

        public function loadTitle():void
        {
            var _local_1:String;
            var _local_2:String;
            var _local_3:String;
            _local_1 = "Generic2.swf";
            _local_2 = "The Skyguard";
            _local_3 = "https://www.aq.com/game/";
            if (params.sURL != null)
            {
                _local_3 = params.sURL;
                _local_1 = params.sBG;
                _local_2 = params.sTitle;
            }
            else
            {
                params.sURL = _local_3;
            }
            BGLoader.LoadBG(_local_3, mcLogin, _local_1, _local_2);
            mcLogin.testClientAssets.visible = false;
            mcLogin.testClientAssets.cVersion.text = ("Version " + cVersion);
            mcLogin.testClientAssets.dnBtn.addEventListener(MouseEvent.CLICK, onBtnDn, false, 0, true);
            mcLogin.testClientAssets.banner.visible = (params.test as Boolean);
        }

        private function initLoginWarning():void
        {
            var _local_1:MovieClip;
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            _local_1 = (mcLogin.warning as MovieClip);
            _local_1.visible = true;
            _local_1.alpha = 100;
            mcLogin.btnLogin.visible = false;
            mcLogin.mcOr.visible = false;
            mcLogin.btnFBLogin.visible = false;
            mcLogin.mcForgotPassword.visible = false;
            mcLogin.mcPassword.visible = false;
            _local_2 = new Date().getTime();
            _local_3 = userPreference.data.logoutWarningTS;
            _local_4 = userPreference.data.logoutWarningDur;
            _local_1.n = Math.round((((_local_3 + (_local_4 * 1000)) - _local_2) / 1000));
            _local_1.ti.text = ((_local_1.s.split("$s")[0] + _local_1.n) + _local_1.s.split("$s")[1]);
            _local_1.timer = new Timer(1000);
            _local_1.timer.addEventListener(TimerEvent.TIMER, loginWarningTimer, false, 0, true);
            _local_1.timer.start();
        }

        private function loginWarningTimer(_arg_1:TimerEvent):void
        {
            var _local_2:MovieClip;
            _local_2 = (mcLogin.warning as MovieClip);
            if (_local_2.n-- < 1)
            {
                _local_2.visible = false;
                _local_2.alpha = 0;
                mcLogin.mcPassword.visible = true;
                mcLogin.btnLogin.visible = true;
                mcLogin.mcOr.visible = true;
                mcLogin.btnFBLogin.visible = true;
                mcLogin.mcForgotPassword.visible = true;
                _local_2.timer.removeEventListener(TimerEvent.TIMER, loginWarningTimer);
            }
            else
            {
                _local_2.ti.text = ((_local_2.s.split("$s")[0] + _local_2.n) + _local_2.s.split("$s")[1]);
                _local_2.timer.reset();
                _local_2.timer.start();
            }
        }

        private function onStageLeave(_arg_1:Event):void
        {
            clearMovementKeys();
            stage.focus = null;
        }

        private function initInterface():*
        {
            var _local_1:int;
            var _local_2:*;
            updateCoreValues(coreValues);
            ctr_watermark.visible = false;
            ctr_watermark.mouseEnabled = (ctr_watermark.mouseChildren = false);
            ui.mcFPS.visible = false;
            ui.mcRes.visible = false;
            ui.mcPopup.visible = false;
            ui.mcPortrait.visible = false;
            ui.mcPortrait.iconBoostXP.visible = false;
            ui.mcPortrait.iconBoostG.visible = false;
            ui.mcPortrait.iconBoostRep.visible = false;
            ui.mcPortrait.iconBoostCP.visible = false;
            ui.mcPopup.visible = false;
            hidePortraitTarget();
            ui.visible = false;
            ui.mcInterface.mcXPBar.mcXP.scaleX = 0;
            ui.mcInterface.mcRepBar.mcRep.scaleX = 0;
            ui.mcUpdates.uproto.visible = false;
            ui.mcUpdates.uproto.y = -400;
            ui.mcUpdates.mouseChildren = (ui.mcUpdates.mouseEnabled = false);
            hideMCPVPQueue();
            stage.removeEventListener(Event.MOUSE_LEAVE, onStageLeave);
            stage.removeEventListener(KeyboardEvent.KEY_UP, key_actBar);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_StageGame);
            stage.removeEventListener(KeyboardEvent.KEY_UP, key_StageGameUp);
            stage.removeEventListener(Event.ENTER_FRAME, keyboardMovementFrame);
            clearMovementKeys();
            ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OVER, xpBarMouseOver);
            ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OUT, xpBarMouseOut);
            ui.mcInterface.mcRepBar.removeEventListener(MouseEvent.MOUSE_OVER, onRepBarMouseOver);
            ui.mcInterface.mcRepBar.removeEventListener(MouseEvent.MOUSE_OUT, onRepBarMouseOut);
            ui.mcPortraitTarget.removeEventListener(MouseEvent.CLICK, portraitClick);
            ui.mcPortrait.removeEventListener(MouseEvent.CLICK, portraitClick);
            ui.mcPortrait.iconBoostXP.removeEventListener(MouseEvent.MOUSE_OVER, oniconBoostXPOver);
            ui.mcPortrait.iconBoostXP.removeEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.mcPortrait.iconBoostG.removeEventListener(MouseEvent.MOUSE_OVER, oniconBoostGoldOver);
            ui.mcPortrait.iconBoostG.removeEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.mcPortrait.iconBoostRep.removeEventListener(MouseEvent.MOUSE_OVER, oniconBoostRepOver);
            ui.mcPortrait.iconBoostRep.removeEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.mcPortrait.iconBoostCP.removeEventListener(MouseEvent.MOUSE_OVER, oniconBoostCPOver);
            ui.mcPortrait.iconBoostCP.removeEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.btnTargetPortraitClose.removeEventListener(MouseEvent.CLICK, onTargetPortraitCloseClick);
            ui.btnMonster.removeEventListener(MouseEvent.CLICK, onBtnMonsterClick);
            ui.mcPVPQueue.removeEventListener(MouseEvent.CLICK, onMCPVPQueueClick);
            ui.mcInterface.tl.mouseEnabled = false;
            chatF.init();
            stage.addEventListener(Event.MOUSE_LEAVE, onStageLeave);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, key_StageGame, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, key_StageGameUp, false, 0, true);
            stage.addEventListener(Event.ENTER_FRAME, keyboardMovementFrame, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, key_actBar);
            ui.mcInterface.mcXPBar.strXP.visible = false;
            ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OVER, xpBarMouseOver);
            ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OUT, xpBarMouseOut);
            ui.mcInterface.mcRepBar.strRep.visible = false;
            ui.mcInterface.mcRepBar.addEventListener(MouseEvent.MOUSE_OVER, onRepBarMouseOver);
            ui.mcInterface.mcRepBar.addEventListener(MouseEvent.MOUSE_OUT, onRepBarMouseOut);
            ui.mcPortraitTarget.addEventListener(MouseEvent.CLICK, portraitClick);
            ui.mcPortrait.addEventListener(MouseEvent.CLICK, portraitClick);
            ui.mcPortrait.iconBoostXP.addEventListener(MouseEvent.MOUSE_OVER, oniconBoostXPOver);
            ui.mcPortrait.iconBoostXP.addEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.mcPortrait.iconBoostG.addEventListener(MouseEvent.MOUSE_OVER, oniconBoostGoldOver);
            ui.mcPortrait.iconBoostG.addEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.mcPortrait.iconBoostRep.addEventListener(MouseEvent.MOUSE_OVER, oniconBoostRepOver);
            ui.mcPortrait.iconBoostRep.addEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.mcPortrait.iconBoostCP.addEventListener(MouseEvent.MOUSE_OVER, oniconBoostCPOver);
            ui.mcPortrait.iconBoostCP.addEventListener(MouseEvent.MOUSE_OUT, oniconBoostOut);
            ui.btnTargetPortraitClose.addEventListener(MouseEvent.CLICK, onTargetPortraitCloseClick);
            ui.btnMonster.addEventListener(MouseEvent.CLICK, onBtnMonsterClick);
            ui.mcPVPQueue.addEventListener(MouseEvent.CLICK, onMCPVPQueueClick);
            ui.iconQuest.visible = false;
            ui.iconQuest.buttonMode = true;
            ui.iconQuest.addEventListener(MouseEvent.CLICK, oniconQuestClick);
            ui.mcInterface.tl.mouseEnabled = false;
            ui.mcInterface.areaList.mouseEnabled = false;
            ui.mcInterface.areaList.title.mouseEnabled = false;
            ui.mcInterface.areaList.title.bMinMax.addEventListener(MouseEvent.CLICK, areaListClick);
            if (litePreference.data.bCustomDrops)
            {
                if (cDropsUI)
                {
                    cDropsUI.cleanup();
                }
                cDropsUI = new customDrops(this);
            }
            if (litePreference.data.bDebugger)
            {
                if (cMenuUI)
                {
                    cMenuUI.cleanup();
                }
                cMenuUI = new cellMenu(this);
                if (pLoggerUI)
                {
                    pLoggerUI.cleanup();
                }
                if (litePreference.data.dOptions["debugPacket"])
                {
                    pLoggerUI = new packetlogger(this);
                }
            }
            if (((litePreference.data.bAuras) && (!(ui.mcInterface.getChildByName("playerAuras")))))
            {
                pAurasUI = new playerAuras(this);
                ui.mcPortrait.addChild(pAurasUI);
                tAurasUI = new targetAuras(this);
                ui.mcPortraitTarget.addChild(tAurasUI);
            }
            if (intChatMode)
            {
                ui.mcInterface.bMinMax.visible = false;
                ui.mcInterface.bShortTall.visible = false;
                ui.mcInterface.bCannedChat.visible = false;
                ui.mcInterface.tt.visible = false;
                ui.mcInterface.tebg.visible = false;
                ui.mcInterface.bsend.visible = false;
                ui.nc.visible = true;
                ui.mcInterface.ncModeChat.visible = true;
                ui.mcInterface.ncCannedChat.visible = true;
                ui.mcInterface.ncHistory.visible = true;
                ui.mcInterface.ncTxtBG.visible = true;
                ui.mcInterface.ncPrefix.visible = true;
                ui.mcInterface.ncText.visible = true;
                ui.mcInterface.ncSendText.visible = true;
            }
            else
            {
                ui.mcInterface.bMinMax.visible = true;
                ui.mcInterface.bShortTall.visible = true;
                ui.mcInterface.bCannedChat.visible = true;
                ui.mcInterface.tt.visible = true;
                ui.mcInterface.tebg.visible = true;
                ui.mcInterface.bsend.visible = true;
                ui.nc.visible = false;
                ui.mcInterface.ncModeChat.visible = false;
                ui.mcInterface.ncCannedChat.visible = false;
                ui.mcInterface.ncHistory.visible = false;
                ui.mcInterface.ncTxtBG.visible = false;
                ui.mcInterface.ncPrefix.visible = false;
                ui.mcInterface.ncText.visible = false;
                ui.mcInterface.ncSendText.visible = false;
            }
            keyDict = getKeyboardDict();
            _local_1 = 0;
            while (_local_1 < 6)
            {
                _local_2 = ui.mcInterface.getChildByName(("keyA" + _local_1));
                if (_local_1 == 0)
                {
                    _local_2.text = ((litePreference.data.keys["Auto Attack"]) ? keyDict[litePreference.data.keys["Auto Attack"]] : " ");
                }
                else
                {
                    _local_2.text = ((litePreference.data.keys[("Skill " + _local_1)]) ? keyDict[litePreference.data.keys[("Skill " + _local_1)]] : " ");
                }
                _local_2.mouseEnabled = false;
                _local_1++;
            }
        }

        public function traceHack(_arg_1:String):void
        {
            chatF.pushMsg("server", _arg_1, "SERVER", "", 0);
        }

        private function onUserFocus(_arg_1:FocusEvent):*
        {
            if (mcLogin.ni.text == "click here")
            {
                mcLogin.ni.text = "";
            }
        }

        private function loadUserPreference():*
        {
            if (userPreference.data.bitCheckedUsername)
            {
                mcLogin.ni.text = ((TempLoginName != "") ? TempLoginName : userPreference.data.strUsername);
                mcLogin.chkUserName.bitChecked = true;
            }
            if (userPreference.data.bitCheckedPassword)
            {
                mcLogin.pi.text = ((TempLoginPass != "") ? TempLoginPass : userPreference.data.strPassword);
                mcLogin.chkPassword.bitChecked = true;
            }
            mcLogin.chkUserName.checkmark.visible = mcLogin.chkUserName.bitChecked;
            mcLogin.chkPassword.checkmark.visible = mcLogin.chkPassword.bitChecked;
        }

        private function saveUserPreference():*
        {
            userPreference.data.bitCheckedUsername = mcLogin.chkUserName.bitChecked;
            userPreference.data.bitCheckedPassword = mcLogin.chkPassword.bitChecked;
            if (mcLogin.chkUserName.bitChecked)
            {
                userPreference.data.strUsername = mcLogin.ni.text;
            }
            else
            {
                userPreference.data.strUsername = "";
            }
            if (mcLogin.chkPassword.bitChecked)
            {
                userPreference.data.strPassword = mcLogin.pi.text;
            }
            else
            {
                userPreference.data.strPassword = "";
            }
            try
            {
                userPreference.flush();
            }
            catch(e:Error)
            {
            }
        }

        private function onCreateNewAccount(_arg_1:MouseEvent):void
        {
            mixer.playSound("Click");
            gotoAndPlay("Account");
        }

        private function onForgotPassword(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://nightvaults.com/"));
        }

        private function onManageClick(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://nightvaults.com/"));
        }

        private function onAccountRecovery(_arg_1:MouseEvent):void
        {
            mixer.playSound("Click");
            navigateToURL(new URLRequest("https://nightvaults.com/"));
        }

        private function onLoginClick(_arg_1:MouseEvent):void
        {
            if ((("btnLogin" in mcLogin) && (mcLogin.btnLogin.visible)))
            {
                if (((!(mcLogin.ni.text == "")) && (!(mcLogin.pi.text == ""))))
                {
                    try
                    {
                        saveUserPreference();
                    }
                    catch(e)
                    {
                    }
                    if (FacebookConnect.isLoggedIn)
                    {
                        FacebookConnect.Logout();
                    }
                    login(mcLogin.ni.text.toLowerCase(), mcLogin.pi.text);
                }
            }
        }

        public function CallFBConnect(_arg_1:Function):void
        {
            this.addEventListener(FacebookConnectEvent.ONCONNECT, FBLoginCreate);
            FBConnectCallback = _arg_1;
            FacebookConnect.RequestFBConnect();
        }

        public function GetFBMe():Object
        {
            return (FacebookConnect.Me);
        }

        public function isFBLoggedIn():Boolean
        {
            return (FacebookConnect.isLoggedIn);
        }

        public function FBIP():String
        {
            return (FacebookConnect.IPAddr);
        }

        public function GetFBToken():String
        {
            return (FacebookConnect.AccessToken);
        }

        private function onFBLoginClick(_arg_1:MouseEvent):void
        {
            if ((("btnLogin" in mcLogin) && (mcLogin.btnLogin.visible)))
            {
                mcConnDetail.showConn("Connecting to Facebook");
                this.addEventListener(FacebookConnectEvent.ONCONNECT, FBLogin);
                FacebookConnect.RequestFBConnect();
            }
        }

        public function FBLogin(_arg_1:FacebookConnectEvent):void
        {
            var _local_2:Number;
            var _local_3:URLRequest;
            var _local_4:URLVariables;
            var _local_5:URLLoader;
            this.removeEventListener(FacebookConnectEvent.ONCONNECT, FBLogin);
            if (_arg_1.params.success)
            {
                params.FBID = FacebookConnect.Me.id;
                params.token = FacebookConnect.AccessToken;
                _local_2 = rn.rand();
                mcConnDetail.showConn("Loading Server List...");
                _local_3 = new URLRequest(params.loginURL);
                _local_4 = new URLVariables();
                _local_4.fbid = FacebookConnect.Me.id;
                _local_4.fbtoken = FacebookConnect.AccessToken;
                FacebookConnect.isLoggedIn = true;
                _local_3.data = _local_4;
                _local_3.method = URLRequestMethod.POST;
                _local_5 = new URLLoader();
                _local_5.addEventListener(Event.COMPLETE, onLoginComplete);
                _local_5.load(_local_3);
            }
            else
            {
                mcConnDetail.showError(_arg_1.params.message);
            }
        }

        public function FBLoginCreate(fbevt:FacebookConnectEvent):void
        {
            this.removeEventListener(FacebookConnectEvent.ONCONNECT, FBLoginCreate);
            if (this.FBConnectCallback != null)
            {
                try
                {
                    FBConnectCallback();
                }
                catch(e:Error)
                {
                }
            }
            FBConnectCallback = null;
        }

        public function getFBUser():void
        {
            if (ISWEB)
            {
                extCall.getFBUser();
            }
        }

        public function login(strUsername:String, strPassword:String):*
        {
            var rand:Number;
            var request:URLRequest;
            var variables:URLVariables;
            mcConnDetail.showConn("Authenticating Account Info...");
            loginInfo.strUsername = strUsername;
            loginInfo.strPassword = strPassword;
            rand = rn.rand();
            request = new URLRequest(params.loginURL + "?ran=" + rand);
            variables = new URLVariables();
            variables.user = strUsername;
            variables.pass = strPassword;
            variables.option = ((ISWEB) ? "0" : "1");
            if (checkPasswordStrength(strPassword) < 18)
            {
                bPassword = false;
            }
            if (params.strSourceID == "FACEBOOK")
            {
                variables.strSourceID = params.strSourceID;
                variables.fbid = params.FBID;
                variables.fbtoken = params.token;
            }
            else
            {
                if (params.strSourceID == "TAGGED")
                {
                    variables.strSourceID = params.strSourceID;
                    variables.SrcUserID = params.SrcUserID;
                    variables.token = params.token;
                }
            }
            request.data = variables;
            request.method = URLRequestMethod.POST;
            loginLoader.removeEventListener(Event.COMPLETE, onLoginComplete);
            loginLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoginError);
            loginLoader.addEventListener(Event.COMPLETE, onLoginComplete, false, 0, true);
            loginLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoginError, false, 0, true);
            try
            {
                loginLoader.load(request);
            }
            catch(error:Error)
            {
                onLoginError(null);
            }
        }

        public function onLoginError(_arg_1:Event):void
        {
            loginLoader.removeEventListener(Event.COMPLETE, onLoginComplete);
            loginLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoginError);
            if (mcConnDetail != null)
            {
                mcConnDetail.showError("Unable to reach the login server. Please try again.");
            }
        }

        public function onLoginComplete(event:Event):void
        {
            var _obj:Object;
            loginLoader.removeEventListener(Event.COMPLETE, onLoginComplete);
            loginLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoginError);
            try
            {
                if (((event == null) || (event.target == null) || (event.target.data == null)))
                {
                    throw new Error("Empty login response");
                }
                _obj = com.adobe.serialization.json.JSON.decode(String(event.target.data));
                if (_obj == null)
                {
                    throw new Error("Invalid login response");
                }
                if (_obj.login)
                {
                    objLogin = _obj.login;
                    objLogin.servers = _obj.servers;
                    playerPollData = _obj.polldata;
                }
                else
                {
                    objLogin = _obj;
                }
                if (objLogin.bSuccess == 1)
                {
                    try
                    {
                        loginInfo.strUsername = objLogin.unm.toLowerCase();
                    }
                    catch(e)
                    {
                    }
                    if (loginInfo.strUsername != null)
                    {
                        if (((((loginInfo.strUsername.toLowerCase() == "iterator") || (loginInfo.strUsername.toLowerCase() == "iterator2")) || (loginInfo.strUsername.toLowerCase() == "iterator3")) || (loginInfo.strUsername.toLowerCase() == "iterator4")))
                        {
                            serialCmdMode = true;
                        }
                        else
                        {
                            serialCmdMode = false;
                        }
                    }
                    else
                    {
                        serialCmdMode = false;
                    }
                    if (objLogin.FBID != null)
                    {
                        if (FacebookConnect.Me == null)
                        {
                            FacebookConnect.Me = {};
                        }
                        FacebookConnect.Me.id = objLogin.FBID;
                        if (objLogin.FBName != null)
                        {
                            FacebookConnect.Me.name = objLogin.FBName;
                        }
                    }
                    if (fbL != null)
                    {
                        fbL.destroy();
                    }
                    if (ISWEB)
                    {
                        extCall.getFBUser();
                    }
                    mcConnDetail.hideConn();
                    loginInfo.strToken = objLogin.sToken;
                    sToken = loginInfo.strToken;
                    strToken = loginInfo.strToken;
                    if (ISWEB)
                    {
                        extCall.setToken(loginInfo);
                    }
                    if (serialCmdMode)
                    {
                        mcLogin.testClientAssets.visible = false;
                        mcLogin.gotoAndStop("Iterator");
                    }
                    else
                    {
                        mcLogin.gotoAndStop("Servers");
                    }
                }
                else
                {
                    if (objLogin.sMsg.indexOf("Facebook") > -1)
                    {
                        mcConnDetail.hideConn();
                        fbL = new fbLinkWindow(mcLogin.fbConnect, (this as MovieClip));
                        mcLogin.fbConnect.visible = true;
                    }
                    else
                    {
                        mcConnDetail.showError(objLogin.sMsg);
                    }
                }
            }
            catch(e:Error)
            {
                if (mcConnDetail != null)
                {
                    mcConnDetail.showError("The login server returned an invalid response. Please try again.");
                }
                return;
            }
            resetsOnNewSession();
        }

        public function resetsOnNewSession():void
        {
            if (((litePreference != null) && (litePreference.data != null) && (litePreference.data.bDebugger) && (objLogin != null) && (Number(objLogin.iAccess) < 30)))
            {
                optionHandler.cmd(MovieClip(this), "@ Debugger");
            }
        }

        public function deepCopy(_arg_1:*, _arg_2:*):void
        {
            var _local_3:*;
            var _local_4:*;
            if (((_arg_1 == null) || (_arg_2 == null)))
            {
                return;
            }
            for (_local_3 in _arg_2)
            {
                _local_4 = (_arg_2 as Object)[_local_3];
                if (((_local_4 != null) && (typeof(_local_4) == "object")))
                {
                    (_arg_1 as Object)[_local_3] = ((_local_4 is Array) ? [] : {});
                    deepCopy((_arg_1 as Object)[_local_3], _local_4);
                }
                else
                {
                    (_arg_1 as Object)[_local_3] = _local_4;
                }
            }
        }

        public function deepCopyArr(_arg_1:*, _arg_2:*):void
        {
            var _local_3:*;
            for each (_local_3 in _arg_2)
            {
                _arg_1.push(_local_3);
            }
        }

        public function saveChar():void
        {
            var _local_1:Object;
            var _local_2:int;
            var _local_3:*;
            var _local_4:Object;
            if (((world == null) || (world.myAvatar == null) || (world.myAvatar.objData == null) || (world.myAvatar.dataLeaf == null) || (characters == null) || (litePreference == null) || (litePreference.data == null)))
            {
                return;
            }
            if (((FacebookConnect.isLoggedIn) || (!(litePreference.data.bCharSelect))))
            {
                return;
            }
            _local_1 = {};
            _local_1["strGender"] = world.myAvatar.objData.strGender;
            _local_1["strHairFilename"] = world.myAvatar.objData.strHairFilename;
            _local_1["strHairName"] = world.myAvatar.objData.strHairName;
            _local_1["eqp"] = {};
            deepCopy(_local_1["eqp"], world.myAvatar.objData.eqp);
            _local_1["intGold"] = world.myAvatar.objData.intGold;
            _local_1["intCoins"] = world.myAvatar.objData.intCoins;
            _local_1["strClassName"] = world.myAvatar.objData.strClassName;
            _local_1["iCP"] = world.myAvatar.objData.iCP;
            _local_1["intLevel"] = world.myAvatar.objData.intLevel;
            _local_1["strUsername"] = world.myAvatar.objData.strUsername;
            _local_1["intAccessLevel"] = world.myAvatar.objData.intAccessLevel;
            _local_1["iUpgDays"] = world.myAvatar.objData.iUpgDays;
            _local_1["intColorSkin"] = world.myAvatar.objData.intColorSkin;
            _local_1["intColorHair"] = world.myAvatar.objData.intColorHair;
            _local_1["intColorEye"] = world.myAvatar.objData.intColorEye;
            _local_1["intColorBase"] = world.myAvatar.objData.intColorBase;
            _local_1["intColorTrim"] = world.myAvatar.objData.intColorTrim;
            _local_1["intColorAccessory"] = world.myAvatar.objData.intColorAccessory;
            if (world.myAvatar.objData.guild != null)
            {
                _local_1["guild"] = {};
                _local_1["guild"]["Name"] = world.myAvatar.objData.guild.Name;
            }
            _local_1["showHelm"] = world.myAvatar.dataLeaf.showHelm;
            _local_1["showCloak"] = world.myAvatar.dataLeaf.showCloak;
            if (((characters.data.users) && (characters.data.users[world.myAvatar.pnm.toLowerCase()])))
            {
                (characters.data.users[world.myAvatar.pnm.toLowerCase()] as Object).data = _local_1;
                (characters.data.users[world.myAvatar.pnm.toLowerCase()] as Object).server = objServerInfo.sName;
            }
            else
            {
                _local_2 = 0;
                for (_local_3 in characters.data.users)
                {
                    _local_2++;
                }
                if (_local_2 >= 5)
                {
                    return;
                }
                (loginInfo as Object).bAsk = false;
                _local_4 = {};
                deepCopy(_local_4, loginInfo);
                characters.data.users[world.myAvatar.pnm.toLowerCase()] = {
                    "index":-1,
                    "data":_local_1,
                    "server":objServerInfo.sName,
                    "loginInfo":_local_4
                };
            }
            characters.flush();
        }

        public function charCount():int
        {
            var _local_1:int;
            var _local_2:*;
            if (!characters.data.users)
            {
                characters.data.users = {};
                characters.data.retro = true;
                characters.flush();
                return (0);
            }
            _local_1 = 0;
            for (_local_2 in characters.data.users)
            {
                _local_1++;
            }
            return (_local_1);
        }

        public function retroLowercase():void
        {
            var _local_1:Boolean;
            var _local_2:*;
            var _local_3:int;
            if (charCount() == 0)
            {
                return;
            }
            if (characters.data.retro)
            {
                return;
            }
            _local_1 = false;
            for (_local_2 in characters.data.users)
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (_local_2.charAt(_local_3) != _local_2.charAt(_local_3).toLowerCase())
                    {
                        _local_1 = true;
                        break;
                    }
                    _local_3++;
                }
                if (_local_1) break;
            }
            if (_local_1)
            {
                resetChars();
            }
            else
            {
                characters.data.retro = true;
            }
        }

        public function resetChars():void
        {
            characters.data.users = null;
            delete characters.data.users;
            characters.flush();
        }

        private function loadExternalAssets():void
        {
            mcConnDetail.showConn("Initializing Client...");
            onLoadMaster(assetsLoaderCallback, assetsContext, "interface/Assets/" + world.objInfo.sAssets, null, assetsLoaderErrorHandler);
        }

        private function assetsLoaderCallback(_arg_1:Event):void
        {
            ASSETS_READY = world.objInfo.sAssets;
            resumeOnLoginResponse();
        }

        private function resumeOnLoginResponse():void
        {
            var _local_1:int;
            mcConnDetail.showConn("Joining Lobby..");
            sfc.sendXtMessage("zm", "firstJoin", [], "str", 1);
            if (chatF.ignoreList.data.users.length > 0)
            {
                _local_1 = 0;
                while (_local_1 < chatF.ignoreList.data.users.length)
                {
                    if (chatF.ignoreList.data.users[_local_1].toLowerCase() == loginInfo.strUsername.toLowerCase())
                    {
                        chatF.ignoreList.data.users.splice(_local_1, 1);
                        break;
                    }
                    _local_1++;
                }
                sfc.sendXtMessage("zm", "cmd", ["ignoreList", chatF.ignoreList.data.users], "str", 1);
            }
            else
            {
                sfc.sendXtMessage("zm", "cmd", ["ignoreList", "$clearAll"], "str", 1);
            }
        }

        private function assetsLoaderErrorHandler(_arg_1:IOErrorEvent):void
        {
            mcConnDetail.showError("Client Initialization Failed!");
        }

        public function connectTo(_arg_1:String, _arg_2:int=5588):*
        {
            if (((_arg_1 == null) || (_arg_1.length < 1)))
            {
                if (mcConnDetail != null)
                {
                    mcConnDetail.showError("Invalid game server address.");
                }
                return;
            }
            if (((_arg_2 < 1) || (_arg_2 > 65535)))
            {
                _arg_2 = serverPort;
            }
            serverIP = _arg_1;
            if (mixer != null)
            {
                mixer.playSound("ClickBig");
            }
            if (mcConnDetail != null)
            {
                mcConnDetail.showConn("Connecting to game server...");
            }
            if (sfc == null)
            {
                if (mcConnDetail != null)
                {
                    mcConnDetail.showError("Game connection is not initialized.");
                }
                return;
            }
            if (sfc.isConnected)
            {
                sfc.disconnect();
            }
            sfc.connect(_arg_1, _arg_2);
            gotoAndPlay("Game");
        }

        public function displayCharPage(_arg_1:String):void
        {
            var _local_2:charPage;
            if (((ui == null) || (_arg_1 == null) || (_arg_1.length < 1)))
            {
                return;
            }
            _local_2 = new charPage(this, _arg_1);
            ui.addChild(_local_2);
        }

        public function togglePolls():void
        {
            requestInterface("polls/pollingsystem.swf", "pollingSystem");
        }

        public function requestInterface(_arg_1:String, _arg_2:String):void
        {
            var _local_1:Object;
            if (((_arg_1 == null) || (_arg_1.length < 1) || (_arg_2 == null) || (_arg_2.length < 1)))
            {
                return;
            }
            removeDeadInterfaces();
            if (((interfaceRef[_arg_2] != null) && (interfaceRef[_arg_2].parent != null)))
            {
                return;
            }
            for each (_local_1 in interfaceQueue)
            {
                if (((_local_1 != null) && (_local_1.nam == _arg_2)))
                {
                    return;
                }
            }
            interfaceQueue.push({
                "nam":_arg_2,
                "intrf":_arg_1
            });
            if (interfaceQueue.length == 1)
            {
                checkInterfaceQueue();
            }
        }

        public function checkInterfaceQueue():void
        {
            var _local_1:Loader;
            var _local_2:String = "0";
            if (interfaceQueue.length < 1)
            {
                return;
            }
            if (((world != null) && (world.objInfo != null) && (world.objInfo["sVersion"] != null)))
            {
                _local_2 = String(world.objInfo["sVersion"]);
            }
            if (visualLoader == null)
            {
                visualLoader = new mcLoader();
                visualLoader.x = 400;
                visualLoader.y = 211;
                this.addChild(visualLoader);
            }
            onLoadMaster(onInterfaceComplete, interfaceContext, "interface/" + interfaceQueue[0].intrf + "?v=" + _local_2, onInterfaceProgress, onInterfaceError);
        }

        public function onInterfaceComplete(_arg_1:Event):void
        {
            var _local_2:*;
            var _local_3:*;
            if (((_arg_1 == null) || (interfaceQueue.length < 1)))
            {
                return;
            }
            try
            {
                _local_2 = new MovieClip();
                _local_2.addChild(MovieClip(Loader(_arg_1.target.loader).content));
            }
            catch(e:Error)
            {
                onInterfaceError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.message));
                return;
            }
            _local_2.name = interfaceQueue[0].nam;
            _local_3 = this.addChild(_local_2);
            if (interfaceRef.hasOwnProperty(interfaceQueue[0].nam))
            {
                if (interfaceRef[interfaceQueue[0].nam])
                {
                    if (interfaceRef[interfaceQueue[0].nam].parent)
                    {
                        MovieClip(interfaceRef[interfaceQueue[0].nam].parent).removeChild(interfaceRef[interfaceQueue[0].nam]);
                    }
                }
            }
            interfaceRef[interfaceQueue[0].nam] = _local_3;
            interfaceQueue.shift();
            if (((visualLoader != null) && (visualLoader.parent != null)))
            {
                visualLoader.parent.removeChild(visualLoader);
            }
            visualLoader = null;
            checkInterfaceQueue();
            if (((MsgBox != null) && (MsgBox.parent == this)))
            {
                this.setChildIndex(MsgBox, (numChildren - 1));
            }
            if (((_local_2.name == "pony_engine") && (world != null) && (world.myAvatar != null)))
            {
                world.myAvatar.swapMorphs(true);
            }
        }

        public function cleanupInterfaces():void
        {
            var _local_1:*;
            for each (_local_1 in interfaceRef)
            {
                if (_local_1)
                {
                    if (_local_1.parent)
                    {
                        MovieClip(_local_1.parent).removeChild(_local_1);
                    }
                }
            }
            interfaceRef = {};
        }

        public function removeDeadInterfaces():void
        {
            var _local_1:String;
            var _local_2:Array;
            var _local_3:*;
            _local_2 = [];
            for (_local_1 in interfaceRef)
            {
                _local_3 = interfaceRef[_local_1];
                if (_local_3)
                {
                    if (!_local_3.parent)
                    {
                        _local_2.push(_local_1);
                    }
                }
            }
            for each (_local_1 in _local_2)
            {
                delete interfaceRef[_local_1];
            }
        }

        public function getInterface(_arg_1:String):*
        {
            var _local_2:*;
            _local_2 = interfaceRef[_arg_1];
            if (_local_2)
            {
                if (!_local_2.parent)
                {
                    delete interfaceRef[_arg_1];
                }
                else
                {
                    return (_local_2);
                }
            }
            return (null);
        }

        public function onInterfaceProgress(_arg_1:ProgressEvent):void
        {
            var _local_2:int;
            if (_arg_1 == null)
            {
                return;
            }
            interfaceLoaded = _arg_1.bytesLoaded;
            interfaceTotal = _arg_1.bytesTotal;
            if (interfaceTotal <= 0)
            {
                return;
            }
            _local_2 = int(((interfaceLoaded / interfaceTotal) * 100));
            var _local_3:Number = (interfaceLoaded / interfaceTotal);
            if (((visualLoader != null) && (visualLoader.mcPct != null)))
            {
                visualLoader.mcPct.text = (_local_2 + "%");
            }
        }

        public function onInterfaceError(_arg_1:IOErrorEvent):void
        {
            if (((visualLoader != null) && (visualLoader.parent != null)))
            {
                visualLoader.parent.removeChild(visualLoader);
            }
            visualLoader = null;
            if (interfaceQueue.length > 0)
            {
                interfaceQueue.shift();
            }
            if (interfaceQueue.length > 0)
            {
                checkInterfaceQueue();
            }
            else
            {
                addUpdate("Unable to load that interface. Please try again.");
            }
        }

        public function requestAPI(_arg_1:String, _arg_2:*, _arg_3:*, _arg_4:*, _arg_5:Boolean=false):void
        {
            var _local_6:URLLoader;
            var _local_7:Array;
            var _local_8:URLVariables;
            var _local_9:URLRequest;
            var _local_10:*;
            if (((_arg_1 == null) || (_arg_1.length < 1) || (world == null) || (world.myAvatar == null) || (world.myAvatar.objData == null)))
            {
                addUpdate("Character data is not ready yet. Please try again.");
                return;
            }
            _local_6 = new URLLoader();
            _local_6.addEventListener(Event.COMPLETE, _arg_3, false, 0, true);
            _local_6.addEventListener(IOErrorEvent.IO_ERROR, _arg_4, false, 0, true);
            _local_7 = [new URLRequestHeader("ccid", world.myAvatar.objData.CharID), new URLRequestHeader("token", loginInfo.strToken)];
            _local_8 = new URLVariables();
            if (_arg_2 != null)
            {
                for (_local_10 in _arg_2)
                {
                    _local_8[_local_10] = ((_local_10 == "layout") ? com.adobe.serialization.json.JSON.encode(_arg_2[_local_10]) : _arg_2[_local_10]);
                }
            }
            _local_9 = new URLRequest((((serverGamePath + "api/char/") + _arg_1) + ((_arg_5) ? ("?v=" + Math.random()) : "")));
            _local_9.requestHeaders = _local_7;
            if (_arg_2 != null)
            {
                _local_9.data = _local_8;
            }
            _local_9.method = URLRequestMethod.POST;
            try
            {
                _local_6.load(_local_9);
            }
            catch(e:Error)
            {
                if (_arg_4 != null)
                {
                    try
                    {
                        _arg_4(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.message));
                    }
                    catch(callbackError:Error)
                    {
                    }
                }
            }
        }

        public function getBank():void
        {
            requestAPI("bank", {"layout":{"cat":"all"}}, onBankComplete, onBankError, true);
        }

        public function onBankComplete(_arg_1:Event):void
        {
            var _local_2:Object;
            try
            {
                if (((world == null) || (_arg_1 == null) || (_arg_1.target == null) || (_arg_1.target.data == null)))
                {
                    throw new Error("Empty bank response");
                }
                _local_2 = com.adobe.serialization.json.JSON.decode(String(_arg_1.target.data));
                if (_local_2 == null)
                {
                    throw new Error("Invalid bank response");
                }
                world.addItemsToBank(_local_2);
            }
            catch(e:Error)
            {
                if (mcConnDetail != null)
                {
                    mcConnDetail.showConn("Error loading bank information");
                }
            }
        }

        public function onBankError(_arg_1:IOErrorEvent):void
        {
            if (mcConnDetail != null)
            {
                mcConnDetail.showConn("Error loading bank information");
            }
        }

        public function retrieveInfo(_arg_1:Array):void
        {
            var urlLoader:URLLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, onInfoComplete, false, 0, true);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onInfoError, false, 0, true);
            urlLoader.load(new URLRequest(serverGamePath + "api/game/clientvars?v=" + Math.random()));

//            var _local_2:URLLoader;
//            var _local_3:*;
//            if (serverGamePath.indexOf("content.aq") == -1)
//            {
//                for each (_local_3 in _arg_1)
//                {
//                    world.objInfo[_local_3.split("=")[0]] = _local_3.substr((_local_3.indexOf("=") + 1));
//                }
//                iMaxBagSlots = Number(world.objInfo["iMaxBagSlots"]);
//                iMaxBankSlots = Number(world.objInfo["iMaxBankSlots"]);
//                iMaxHouseSlots = Number(world.objInfo["iMaxHouseSlots"]);
//                iMaxFriends = Number(world.objInfo["iMaxFriends"]);
//                iMaxLoadoutSlots = Number(world.objInfo["iMaxLoadoutSlots"]);
//                if (ASSETS_READY == _arg_1["sAssets"])
//                {
//                    BOOK_DATA_READY = null;
//                    resumeOnLoginResponse();
//                }
//                else
//                {
//                    BOOK_DATA_READY = null;
//                    loadExternalAssets();
//                }
//                return;
//            }
//
//            _local_2 = new URLLoader();
//            _local_2.addEventListener(Event.COMPLETE, onInfoComplete, false, 0, true);
//            _local_2.addEventListener(IOErrorEvent.IO_ERROR, onInfoError, false, 0, true);
//            _local_2.load(new URLRequest(((serverGamePath + "api/game/clientvars?v=") + Math.random())));
        }

        public function retrieveBook():void
        {
            var _local_1:URLLoader;
            if (ui.getChildByName("travelLoaderMC"))
            {
                return;
            }
            travelLoaderMC = new ((world.getClass("mcLoader") as Class))();
            travelLoaderMC.x = 400;
            travelLoaderMC.y = 211;
            travelLoaderMC.name = "travelLoaderMC";
            ui.addChild(travelLoaderMC);
            _local_1 = new URLLoader();
            _local_1.addEventListener(Event.COMPLETE, onBoLComplete, false, 0, true);
            _local_1.addEventListener(ProgressEvent.PROGRESS, onBoLProgress, false, 0, true);
            _local_1.addEventListener(IOErrorEvent.IO_ERROR, onBoLError, false, 0, true);
            _local_1.load(new URLRequest(((serverGamePath + "api/data/booklore?v=") + world.objInfo["sVersion"])));
        }

        public function onInfoComplete(_arg_1:Event):void
        {
            var _local_2:Object;
            var _local_3:*;
            try
            {
                if (((world == null) || (world.objInfo == null) || (_arg_1 == null) || (_arg_1.target == null) || (_arg_1.target.data == null)))
                {
                    throw new Error("Empty client vars response");
                }
                _local_2 = com.adobe.serialization.json.JSON.decode(String(_arg_1.target.data));
                if (_local_2 == null)
                {
                    throw new Error("Invalid client vars response");
                }
                for (_local_3 in _local_2)
                {
                    world.objInfo[_local_3] = _local_2[_local_3];
                }

                world.jsonStringy(_local_2);

                if (!isNaN(Number(_local_2["iMaxBagSlots"]))) iMaxBagSlots = Number(_local_2["iMaxBagSlots"]);
                if (!isNaN(Number(_local_2["iMaxBankSlots"]))) iMaxBankSlots = Number(_local_2["iMaxBankSlots"]);
                if (!isNaN(Number(_local_2["iMaxHouseSlots"]))) iMaxHouseSlots = Number(_local_2["iMaxHouseSlots"]);
                if (!isNaN(Number(_local_2["iMaxFriends"]))) iMaxFriends = Number(_local_2["iMaxFriends"]);
                if (!isNaN(Number(_local_2["iMaxLoadoutSlots"]))) iMaxLoadoutSlots = Number(_local_2["iMaxLoadoutSlots"]);
                if (ASSETS_READY == _local_2["sAssets"])
                {
                    BOOK_DATA_READY = null;
                    resumeOnLoginResponse();
                }
                else
                {
                    BOOK_DATA_READY = null;
                    loadExternalAssets();
                }
            }
            catch(e:Error)
            {
                if (mcConnDetail != null)
                {
                    mcConnDetail.showConn("Error loading client vars");
                }
            }
        }

        public function onInfoError(_arg_1:IOErrorEvent):void
        {
            if (mcConnDetail != null)
            {
                mcConnDetail.showConn("Error loading client vars");
            }
        }

        public function onBoLComplete(_arg_1:Event):void
        {
            var _local_2:Object;
            try
            {
                if (((world == null) || (ui == null) || (ui.mcPopup == null) || (ui.mcPopup.mcBook == null) || (_arg_1 == null) || (_arg_1.target == null) || (_arg_1.target.data == null)))
                {
                    throw new Error("Empty Book of Lore response");
                }
                _local_2 = com.adobe.serialization.json.JSON.decode(String(_arg_1.target.data));
                if (_local_2 == null)
                {
                    throw new Error("Invalid Book of Lore response");
                }
                world.bookData = _local_2;
                BOOK_DATA_READY = _local_2;
                while (ui.mcPopup.mcBook.numChildren > 0)
                {
                    ui.mcPopup.mcBook.removeChildAt(0);
                }
                if (bolContent)
                {
                    if (newInstance)
                    {
                        newInstance = false;
                        bolContent.gotoAndStop("NavMenu");
                    }
                    ui.mcPopup.mcBook.addChild(bolContent);
                    return;
                }
                if (((world.objInfo == null) || (world.objInfo.sBook == null) || (String(world.objInfo.sBook).length < 1)))
                {
                    throw new Error("Missing Book of Lore asset");
                }
                bolLoader = new Loader();
                bolLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBoLContentComplete, false, 0, true);
                bolLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onBoLContentError, false, 0, true);
                bolLoader.load(new URLRequest((Game.serverFilePath + world.objInfo.sBook)), new LoaderContext(false, ApplicationDomain.currentDomain));
            }
            catch(e:Error)
            {
                onBoLError(null);
            }
        }

        public function onBoLContentComplete(_arg_1:Event):void
        {
            try
            {
                if (((_arg_1 == null) || (_arg_1.currentTarget == null) || (_arg_1.currentTarget.content == null) || (ui == null) || (ui.mcPopup == null) || (ui.mcPopup.mcBook == null)))
                {
                    throw new Error("Invalid Book of Lore asset");
                }
                bolContent = _arg_1.currentTarget.content;
                ui.mcPopup.mcBook.addChild(bolContent);
            }
            catch(e:Error)
            {
                onBoLError(null);
            }
        }

        private function onBoLContentError(_arg_1:IOErrorEvent):void
        {
            onBoLError(_arg_1);
        }

        private function onBoLProgress(_arg_1:ProgressEvent):void
        {
            var _local_2:int;
            if (((_arg_1 == null) || (_arg_1.bytesTotal <= 0)))
            {
                return;
            }
            bLoaded = _arg_1.bytesLoaded;
            bTotal = _arg_1.bytesTotal;
            _local_2 = int(((bLoaded / bTotal) * 100));
            if (((travelLoaderMC != null) && (travelLoaderMC.mcPct != null)))
            {
                travelLoaderMC.mcPct.text = (_local_2 + "%");
            }
            if (((bLoaded >= bTotal) && (travelLoaderMC != null)))
            {
                if (travelLoaderMC.parent != null)
                {
                    travelLoaderMC.parent.removeChild(travelLoaderMC);
                }
                travelLoaderMC = null;
            }
        }

        private function onBoLError(_arg_1:IOErrorEvent):void
        {
            if (travelLoaderMC != null)
            {
                if (travelLoaderMC.parent != null)
                {
                    travelLoaderMC.parent.removeChild(travelLoaderMC);
                }
                travelLoaderMC = null;
            }
            if (mcConnDetail != null)
            {
                mcConnDetail.showConn("Error loading Book of Lore data");
            }
        }

        public function serialCmdInit(_arg_1:String):void
        {
            var _local_2:*;
            var _local_3:*;
            _local_2 = mcLogin.il;
            _local_3 = _local_2.cmd;
            _local_3.btnUnselectAll.visible = false;
            _local_3.btnSelectAll.visible = false;
            _local_3.btnGo.visible = false;
            serialCmd.si = 0;
            serialCmd.cmd = _arg_1;
            serialCmd.active = true;
            serialCmdNext();
        }

        private function serialCmdNext():void
        {
            var _local_1:Date;
            var _local_2:*;
            var _local_4:*;
            _local_1 = new Date();
            _local_2 = mcLogin.il.iClass;
            var _local_3:* = mcLogin.il.cmd;
            if (serialCmd.si > 0)
            {
                _local_4 = _local_2.getServerItemByIP(serialCmd.servers[(serialCmd.si - 1)].sIP, serialCmd.servers[(serialCmd.si - 1)].iPort);
                if (_local_4 != null)
                {
                    _local_2.serverOn(_local_4);
                    _local_4.t3.text = (((_local_1.getTime() - serialCmd.ts) / 1000) + " s");
                    _local_4.t3.visible = true;
                }
            }
            if (serialCmd.si < serialCmd.servers.length)
            {
                sfc.connect(serialCmd.servers[serialCmd.si].sIP, serialCmd.servers[serialCmd.si].iPort);
                serialCmd.si++;
                serialCmd.ts = _local_1.getTime();
            }
            else
            {
                serialCmdDone();
            }
        }

        private function serialCmdDone():void
        {
            var _local_1:*;
            var _local_2:*;
            _local_1 = mcLogin.il;
            _local_2 = _local_1.cmd;
            _local_2.btnUnselectAll.visible = true;
            _local_2.btnSelectAll.visible = true;
            _local_2.btnGo.visible = true;
            serialCmd.active = false;
        }

        public function readIA1Preferences():void
        {
            uoPref.bCloak = (world.getAchievement("ia1", 0) == 0);
            uoPref.bHelm = (world.getAchievement("ia1", 1) == 0);
            uoPref.bPet = (world.getAchievement("ia1", 2) == 0);
            uoPref.bWAnim = (world.getAchievement("ia1", 3) == 0);
            uoPref.bGoto = (world.getAchievement("ia1", 4) == 0);
            uoPref.bMusicOn = (world.getAchievement("ia1", 6) == 0);
            uoPref.bFriend = (world.getAchievement("ia1", 7) == 0);
            uoPref.bParty = (world.getAchievement("ia1", 8) == 0);
            uoPref.bGuild = (world.getAchievement("ia1", 9) == 0);
            uoPref.bWhisper = (world.getAchievement("ia1", 10) == 0);
            uoPref.bTT = (world.getAchievement("ia1", 11) == 0);
            uoPref.bFBShare = (world.getAchievement("ia1", 12) == 1);
            uoPref.bDuel = (world.getAchievement("ia1", 13) == 0);
            world.hideAllCapes = (world.getAchievement("ia1", 14) == 1);
            world.hideOtherPets = (world.getAchievement("ia1", 15) == 1);
            world.showAnimations = (world.getAchievement("ia1", 17) == 0);
            uoPref.bProf = (world.getAchievement("ia1", 18) == 0);
            uoPref.bFBShard = false;
            mixer.stf = new SoundTransform(((litePreference.data.dOptions["iSoundFX"] != null) ? litePreference.data.dOptions["iSoundFX"] : 1));
            SoundMixer.soundTransform = new SoundTransform(((litePreference.data.dOptions["iSoundAll"] != null) ? litePreference.data.dOptions["iSoundAll"] : 1));
        }

        public function inituoPref():void
        {
            uoPref.bCloak = true;
            uoPref.bHelm = true;
            uoPref.bPet = true;
            uoPref.bWAnim = true;
            uoPref.bGoto = true;
            uoPref.bMusicOn = true;
            uoPref.bFriend = true;
            uoPref.bParty = true;
            uoPref.bGuild = true;
            uoPref.bWhisper = true;
            uoPref.bTT = true;
            uoPref.bFBShare = false;
            uoPref.bDuel = true;
        }

        public function initKeybindPref(_arg_1:Boolean=false):void
        {
            if (((litePreference.data.keys) && (!(litePreference.data.keys["Dash"]))))
            {
                litePreference.data.keys["Dash"] = 32;
                litePreference.data.keys["Jump"] = null;
            }
            if (((litePreference.data.keys) && (!(_arg_1))))
            {
                return;
            }
            litePreference.data.keys = {};
            litePreference.data.keys["Camera Tool"] = 219;
            litePreference.data.keys["World Camera"] = 221;
            litePreference.data.keys["Target Random Monster"] = 84;
            litePreference.data.keys["Inventory"] = 73;
            litePreference.data.keys["Bank"] = 66;
            litePreference.data.keys["Quest Log"] = 76;
            litePreference.data.keys["Friends List"] = 70;
            litePreference.data.keys["Character Panel"] = 67;
            litePreference.data.keys["Player HP Bar"] = 86;
            litePreference.data.keys["Options"] = 79;
            litePreference.data.keys["Area List"] = 85;
            litePreference.data.keys["Jump"] = null;
            litePreference.data.keys["Auto Attack"] = 49;
            litePreference.data.keys["Skill 1"] = 50;
            litePreference.data.keys["Skill 2"] = 51;
            litePreference.data.keys["Skill 3"] = 52;
            litePreference.data.keys["Skill 4"] = 53;
            litePreference.data.keys["Skill 5"] = 54;
            litePreference.data.keys["Travel Menu's Travel"] = 89;
            litePreference.data.keys["World Camera's Hide"] = 72;
            litePreference.data.keys["Rest"] = 88;
            litePreference.data.keys["Hide Monsters"] = null;
            litePreference.data.keys["Hide Players"] = null;
            litePreference.data.keys["Cancel Target"] = 27;
            litePreference.data.keys["Hide UI"] = null;
            litePreference.data.keys["Battle Analyzer"] = null;
            litePreference.data.keys["Decline All Drops"] = null;
            litePreference.data.keys["Stats Overview"] = null;
            litePreference.data.keys["Battle Analyzer Toggle"] = null;
            litePreference.data.keys["Custom Drops UI"] = null;
            litePreference.data.keys["@ Debugger - Cell Menu"] = 192;
            litePreference.data.keys["@ Debugger - Packet Logger"] = null;
            litePreference.data.keys["Dash"] = 32;
            litePreference.data.keys["Outfits"] = null;
            litePreference.data.keys["Friendships UI"] = null;
        }

        public function debugMessage(_arg_1:String):void
        {
            if (!litePreference.data.bDebugger)
            {
                return;
            }
            chatF.pushMsg("warning", _arg_1, "SERVER", "", 0);
        }

        public function initlitePref():void
        {
            if (litePreference.data.dOptions == null)
            {
                litePreference.data.dOptions = {};
            }
            if (litePreference.data.dOptions["termsAgree"] == null)
            {
                litePreference.data.dOptions["termsAgree"] = true;
            }
            litePref = [{
                "strName":"@ Debugger",
                "bEnabled":litePreference.data.bDebugger,
                "sDesc":"Debug Mode!\nPress ` (Changeable in Keybinds) to hide/show the cell & pads menu!",
                "minAccess":30,
                "extra":[{
                    "strName":"Disable Linkage Errors",
                    "bEnabled":litePreference.data.dOptions["debugLinkage"],
                    "sDesc":"Avoid receiving linkage error messages"
                }, {
                    "strName":"Disable Color Coded Items",
                    "bEnabled":litePreference.data.dOptions["debugColor"],
                    "sDesc":"Prevents color coding of item entries\nRed item = costs 0 ac/gold\nRed item = item is AC and > 12k\nYellow item = is staff"
                }, {
                    "strName":"Packet Logger",
                    "bEnabled":litePreference.data.dOptions["debugPacket"],
                    "sDesc":"View all packets sent to the client.\nMust be enabled to use.\nSet a keybind to hide/show the packet logger window."
                }]
            }, {
                "strName":"Allow Quest Log Turn-Ins",
                "bEnabled":litePreference.data.bQuestLog,
                "sDesc":"Allows you to turn-in quests using your quest log on the bottom right screen!"
            }, {
                "strName":"Auto-Untarget Dead Targets",
                "bEnabled":litePreference.data.bUntargetDead,
                "sDesc":"This will untarget targets that are dead."
            }, {
                "strName":"Auto-Untarget Self",
                "bEnabled":litePreference.data.bUntargetSelf,
                "sDesc":"This will prevent you from targetting yourself."
            }, {
                "strName":"Battle Analyzer",
                "extra":"btn",
                "sDesc":"This will allow you to monitor your damage dealt, gold earned, and many more!"
            }, {
                "strName":"Battlepets",
                "bEnabled":litePreference.data.bBattlepet,
                "sDesc":"Allows your battlepet to fight alongside you without a battlepet class equipped."
            }, {
                "strName":"Static Player Art",
                "bEnabled":litePreference.data.bCachePlayers,
                "sDesc":"Reduces the graphics of other players. \n!WARNING! Having this enabled may or may not show some of the other player's colors. You will not be able to see their equipment changes with this enabled either.\nYou must change rooms after turning this feature off in order for changes to take effect"
            }, {
                "strName":"Char Page",
                "special":1,
                "sDesc":"Search Character Pages"
            }, {
                "strName":"Character Select Screen",
                "bEnabled":litePreference.data.bCharSelect,
                "sDesc":"Allows you to replace the login screen with a character select screen."
            }, {
                "strName":"Chat Settings",
                "bEnabled":litePreference.data.bChatFilter,
                "sDesc":"Allow the customization of the game's chat window with the options below!",
                "extra":[{
                    "strName":"Timestamps",
                    "bEnabled":litePreference.data.dOptions["timeStamps"],
                    "sDesc":"Adding timestamps to chat messages (Server Time)\nOnly works on the old chat ui!"
                }, {
                    "strName":"Disable Red Messages",
                    "bEnabled":litePreference.data.dOptions["disRed"],
                    "sDesc":"Avoid receiving combat warning messages in chat"
                }]
            }, {
                "strName":"Chat UI",
                "bEnabled":litePreference.data.bChatUI,
                "sDesc":"If enabled, you will switch to the new Chat UI.",
                "extra":[{
                    "strName":"Minimal Mode",
                    "bEnabled":litePreference.data.dOptions["chatMinimal"],
                    "sDesc":"Less intrusive on your gameplay!\nHover over the message box to make the messages visible\nScroll over the message box to scroll!"
                }, {
                    "strName":"Disable AutoScroll to Bottom",
                    "bEnabled":litePreference.data.dOptions["chatScroll"],
                    "sDesc":"The Chat UI will not automatically scroll to the bottom on a new message"
                }]
            }, {
                "strName":"Class Actives/Auras UI",
                "bEnabled":litePreference.data.bAuras,
                "sDesc":"Work in Progress. No proper stack limit and icons yet.\nAllows you to view your buffs/auras underneath your player portrait and for your enemies as well!",
                "extra":[{
                    "strName":"Disable ToolTips",
                    "bEnabled":litePreference.data.dOptions["disAuraTips"],
                    "sDesc":"Prevents you from seeing tooltips when hovering over an aura."
                }, {
                    "strName":"Disable Aura Text",
                    "bEnabled":litePreference.data.dOptions["disAuraText"],
                    "sDesc":"Prevents you from seeing the yellow aura text on you or other players."
                }]
            }, {
                "strName":"Color Sets",
                "bEnabled":litePreference.data.bColorSets,
                "sDesc":"Save your colors with this tool that appears when you go customizing your hair or armor colors!"
            }, {
                "strName":"Custom Drops UI",
                "bEnabled":litePreference.data.bCustomDrops,
                "sDesc":"Shift+Click to block an item drop!\nYour bank items must be loaded to detect if you already have an item",
                "extra":[{
                    "strName":"Invert Menu",
                    "bEnabled":litePreference.data.dOptions["invertMenu"],
                    "sDesc":"The drop menu will appear at the top of the screen rather than appearing at the bottom"
                }, {
                    "strName":"Warn When Declining A Drop",
                    "bEnabled":litePreference.data.dOptions["warnDecline"],
                    "sDesc":"A confirmation box will appear to confirm if you want to decline an item drop"
                }, {
                    "strName":"Hide Drop Notifications",
                    "bEnabled":litePreference.data.dOptions["hideDrop"],
                    "sDesc":"This will hide regular drop notifications"
                }, {
                    "strName":"Hide Temporary Drop Notifications",
                    "bEnabled":litePreference.data.dOptions["hideTemp"],
                    "sDesc":"This will hide temporary drop notifications"
                }, {
                    "strName":"Opened Menu",
                    "bEnabled":litePreference.data.dOptions["openMenu"],
                    "sDesc":"The Custom Drops UI will start up opened rather than closed"
                }, {
                    "strName":"Draggable Mode",
                    "bEnabled":litePreference.data.dOptions["dragMode"],
                    "sDesc":"The Custom Drops UI will be draggable rather than being attached to the screen"
                }, {
                    "strName":"Lock Position",
                    "bEnabled":litePreference.data.dOptions["lockMode"],
                    "sDesc":"The draggable Custom Drops UI will not be moved from where it was last placed"
                }, {
                    "strName":"Reset Position",
                    "extra":"btn",
                    "sDesc":"If the Drop UI somehow goes off-screen and you can't see it, then use this to get it back!\nWorks only for \"Draggable Mode\""
                }, {
                    "strName":"Quantity Warnings",
                    "bEnabled":litePreference.data.dOptions["termsAgree"],
                    "sDesc":"By disabling this feature you understand help from player support for unaccepted drops will be limited"
                }]
            }, {
                "strName":"Disable Chat Scrolling",
                "bEnabled":litePreference.data.bDisChatScroll,
                "sDesc":"Prevents you from scrolling the chat\nOnly works on the old chat ui!"
            }, {
                "strName":"Disable Damage Numbers",
                "bEnabled":litePreference.data.bDisDmgDisplay,
                "sDesc":"Disables all damage numbers from showing as well as the white flash/strobe effect"
            }, {
                "strName":"Disable Damage Strobe",
                "bEnabled":litePreference.data.bDisDmgStrobe,
                "sDesc":"Prevents the white flash/strobe effect whenever a monster or player is damaged!"
            }, {
                "strName":"Disable Monster Animations",
                "bEnabled":litePreference.data.bDisMonAnim,
                "sDesc":"Disables monster animations with the benefit of performance"
            }, {
                "strName":"Disable Self Animations",
                "bEnabled":litePreference.data.bDisSelfMAnim,
                "sDesc":"Disables your player's movement animations except for walking for the benefit of performance"
            }, {
                "strName":"Disable Skill Animations",
                "bEnabled":litePreference.data.bDisSkillAnim,
                "sDesc":'There are two types of animations: Class Skill Animations & Player Movement Animations\nThis feature disables Class Skill Animations only while the regular "Animations" setting will disable both Class Skill Animations & Player Movement Animations',
                "extra":[{
                    "strName":"Show Your Skill Animations Only",
                    "bEnabled":litePreference.data.dOptions["animSelf"],
                    "sDesc":'Only works if "Disable Skill Animations" is enabled!\nAdds an exception to "Disable Skill Animations" to show your skill animations only'
                }]
            }, {
                "strName":"Disable Quest Popup",
                "bEnabled":litePreference.data.bDisQPopup,
                "sDesc":"Prevent the Quest Complete Popup if it becomes too intrusive"
            }, {
                "strName":"Disable Quest Tracker",
                "bEnabled":litePreference.data.bDisQTracker,
                "sDesc":"Prevent the Quest Tracker from opening"
            }, {
                "strName":"Disable Weapon Animations",
                "bEnabled":litePreference.data.bDisWepAnim,
                "sDesc":"Disables weapon animations\nYou can disable a specific player's weapon animations by targetting them and clicking on their portrait!",
                "extra":[{
                    "strName":"Keep Your Weapon Animations Only",
                    "bEnabled":litePreference.data.dOptions["wepSelf"],
                    "sDesc":'Only works if "Disable Weapon Animation" is enabled!\nHaving this enabled will allow your weapon animations to continue working while others have theirs disabled'
                }]
            }, {
                "strName":"Decline All Drops",
                "extra":"btn",
                "sDesc":"Declines all the drops on your screen"
            }, {
                "strName":"Display FPS",
                "extra":"btn",
                "sDesc":"Toggles the Frames Per Second Display"
            }, {
                "strName":"Draggable Drops",
                "bEnabled":litePreference.data.bDraggable,
                "sDesc":'Allows you to drag, or move around, the drops on your screen\nToggling this on with drops already on your screen will not make those drops draggable\nOnly works if "Custom Drops UI" is not enabled'
            }, {
                "strName":"Freeze / Lock Monster Position",
                "bEnabled":litePreference.data.bFreezeMons,
                "sDesc":"This will freeze monsters on the map in place to prevent players from luring/dragging monsters all over the map"
            }, {
                "strName":"Invisible Monsters",
                "bEnabled":litePreference.data.bHideMons,
                "sDesc":"Make monsters invisible. You can target them by clicking on their shadow"
            }, {
                "strName":"Hide Players",
                "bEnabled":litePreference.data.bHidePlayers,
                "sDesc":"This will hide players on the map\nYou can hide specific players by clicking on their portraits (targetting them)!",
                "extra":[{
                    "strName":"Show Name Tags",
                    "bEnabled":litePreference.data.dOptions["showNames"],
                    "sDesc":"Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see name tags of players even though they're hidden."
                }, {
                    "strName":"Show Shadows",
                    "bEnabled":litePreference.data.dOptions["showShadows"],
                    "sDesc":'Only works if "Hide Players" is enabled!\nHaving this enabled will allow you to still see player shadows and clicking on the shadows will target them.'
                }]
            }, {
                "strName":"Hide Player Names",
                "bEnabled":litePreference.data.bHideNames,
                "sDesc":"Hides player names\nHover over a player to reveal their name & guild",
                "extra":[{
                    "strName":"Hide Guild Names Only",
                    "bEnabled":litePreference.data.dOptions["hideGuild"],
                    "sDesc":"Player names will be visible, and guild names will be hidden"
                }, {
                    "strName":"Hide Your Name Only",
                    "bEnabled":litePreference.data.dOptions["hideSelf"],
                    "sDesc":'Only your name will be hidden.\nEnabling this setting will not make "Hide Guild Names Only" work.'
                }]
            }, {
                "strName":"Hide UI",
                "bEnabled":litePreference.data.bHideUI,
                "sDesc":"Hides player & target portraits located on the top left as well as the map name & area list located on the bottom right"
            }, {
                "strName":"Item Drops Block List",
                "extra":"btn",
                "sDesc":'Shift+Click dropped items while using "Custom Drops UI" to add items to block!'
            }, {
                "strName":"Keybinds",
                "extra":"btn",
                "sDesc":"Customize game keybinds.\nYou can not bind ENTER or /.\nUse BACKSPACE to delete a bind."
            }, {
                "strName":"Reaccept Quest After Turn-In",
                "bEnabled":litePreference.data.bReaccept,
                "sDesc":"After turning in a quest, it will try to reaccept the quest if possible"
            }, {
                "strName":"Show Monster Type",
                "bEnabled":litePreference.data.bMonsType,
                "sDesc":"Display the monster's type as a tag under their name"
            }, {
                "strName":"Smooth Background",
                "bEnabled":litePreference.data.bSmoothBG,
                "sDesc":"Removes map background pixelation\nYou must reload the map or move to a new area to see changes take affect"
            }, {
                "strName":"Travel Menu",
                "extra":"btn",
                "sDesc":'Jump between multiple maps with a press of a button!\nThe keybind to jump maps is rebindable within "Keybinds"!'
            }, {
                "strName":"Quest Pinner",
                "bEnabled":litePreference.data.bQuestPin,
                "sDesc":'1. Open quests from any NPC\n2. Press the "Pin Quests" button (left)\n3. You can now access it from anywhere by clicking on the yellow (!) quest log icon at the top left!\nShift+Click the yellow (!) quest log icon to open the Quest Tracker!\nShift+Click the quest pinner icon to clear your pinned quests!'
            }, {
                "strName":"Quest Progress Notifications",
                "bEnabled":litePreference.data.bQuestNotif,
                "sDesc":"Quest Progress will continue to notify/update you even when you've completed the quest"
            }, {
                "strName":"Visual Skill CDs",
                "bEnabled":litePreference.data.bSkillCD,
                "sDesc":"Visual skill cooldowns!"
            }, {
                "strName":"Hide Ground Items",
                "bEnabled":litePreference.data.bDisGround,
                "sDesc":"Hides the item type 'Ground' from other players",
                "extra":[{
                    "strName":"Show Your Ground Item Only",
                    "bEnabled":litePreference.data.dOptions["groundSelf"],
                    "sDesc":"Other players' ground items will be hidden, while yours remains visible"
                }]
            }, {
                "strName":"Hide Healing Bubbles",
                "bEnabled":litePreference.data.bDisHealBubble,
                "sDesc":"Hides the green healing bubbles above players when they're low on health"
            }];
        }

        public function isTestClient():Boolean
        {
            var _local_1:Array;
            var _local_2:*;
            _local_1 = ["Dev Grotto", "Dev04"];
            for each (_local_2 in _local_1)
            {
                if (objServerInfo.sName.toLowerCase() == _local_2.toLowerCase())
                {
                    return (true);
                }
            }
            return (false);
        }

        public function castSpellFX(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):*
        {
            cameraToolMC.castSpellFX();
        }

        public function movieClipStopAll(_arg_1:MovieClip):void
        {
            var _local_2:uint;
            _local_2 = 0;
            while (_local_2 < _arg_1.numChildren)
            {
                if ((_arg_1.getChildAt(_local_2) is MovieClip))
                {
                    try
                    {
                        (_arg_1.getChildAt(_local_2) as MovieClip).gotoAndStop(0);
                        movieClipStopAll((_arg_1.getChildAt(_local_2) as MovieClip));
                    }
                    catch(exception)
                    {
                    }
                }
                _local_2++;
            }
        }

        public function rasterizePart(_arg_1:DisplayObject):Bitmap
        {
            var _local_2:Matrix;
            var _local_3:Rectangle;
            var _local_4:Point;
            var _local_5:BitmapData;
            var _local_6:Bitmap;
            _local_2 = _arg_1.transform.matrix;
            _local_3 = _arg_1.getBounds(_arg_1.parent);
            _local_4 = new Point((_arg_1.x - _local_3.left), (_arg_1.y - _local_3.top));
            _local_2.tx = _local_4.x;
            _local_2.ty = _local_4.y;
            _local_5 = new BitmapData(_local_3.width, _local_3.height, true, 0);
            _local_5.draw(_arg_1, _local_2, _arg_1.transform.colorTransform, null, null, true);
            _local_6 = new Bitmap(_local_5);
            _local_6.smoothing = true;
            _local_6.x = (_local_6.x - _local_4.x);
            _local_6.y = (_local_6.y - _local_4.y);
            return (_local_6);
        }

        public function rasterize(_arg_1:MovieClip):void
        {
            movieClipRasterizeInner(_arg_1);
        }

        public function movieClipRasterizeInner(_arg_1:MovieClip):void
        {
            var _local_2:uint;
            var _local_3:MovieClip;
            var _local_4:Sprite;
            var _local_5:*;
            _local_2 = 0;
            for (;_local_2 < _arg_1.numChildren;_local_2++)
            {
                if ((_arg_1.getChildAt(_local_2) is MovieClip))
                {
                    try
                    {
                        _local_3 = (_arg_1.getChildAt(_local_2) as MovieClip);
                        if (_local_3.visible == false) continue;
                        _local_3.getChildAt(0).visible = false;
                        _local_4 = new Sprite();
                        _local_4.addChild(rasterizePart(_local_3.getChildAt(0)));
                        _local_5 = _local_3.addChildAt(_local_4, 0);
                        movieClipRasterizeInner((_arg_1.getChildAt(_local_2) as MovieClip));
                    }
                    catch(exception)
                    {
                    }
                }
            }
        }

        public function getQuestValidationString(_arg_1:Object):String
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:int;
            var _local_5:*;
            var _local_6:String;
            var _local_7:int;
            var _local_8:Object;
            var _local_9:int;
            var _local_10:int;
            var _local_11:*;
            if (((!(_arg_1.sField == null)) && (!(world.getAchievement(_arg_1.sField, _arg_1.iIndex) == 0))))
            {
                if (_arg_1.sField == "im0")
                {
                    return ("Monthly Quests are only available once per month.");
                }
                if (_arg_1.sField == "iw0")
                {
                    return ("Weekly Quests are only available once per week.");
                }
                return ("Daily Quests are only available once per day.");
            }
            if (((_arg_1.bUpg == 1) && (!(world.myAvatar.isUpgraded()))))
            {
                return ("Upgrade is required for this quest!");
            }
            if (((_arg_1.iSlot >= 0) && (world.getQuestValue(_arg_1.iSlot) < (_arg_1.iValue - 1))))
            {
                return ("Quest has not been unlocked!");
            }
            if (_arg_1.iLvl > world.myAvatar.objData.intLevel)
            {
                return (("Unlocks at Level " + _arg_1.iLvl) + ".");
            }
            if (((_arg_1.iClass > 0) && (world.myAvatar.getCPByID(_arg_1.iClass) < _arg_1.iReqCP)))
            {
                _local_2 = getRankFromPoints(_arg_1.iReqCP);
                _local_3 = (_arg_1.iReqCP - arrRanks[(_local_2 - 1)]);
                if (_local_3 > 0)
                {
                    return (((((("Requires " + _local_3) + " Class Points on ") + _arg_1.sClass) + ", Rank ") + _local_2) + ".");
                }
                return (((("Requires " + _arg_1.sClass) + ", Rank ") + _local_2) + ".");
            }
            if (((_arg_1.FactionID > 1) && (world.myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep)))
            {
                _local_4 = getRankFromPoints(_arg_1.iReqRep);
                _local_5 = (_arg_1.iReqRep - arrRanks[(_local_4 - 1)]);
                if (_local_5 > 0)
                {
                    return (((((("Requires " + _local_5) + " Reputation for ") + _arg_1.sFaction) + ", Rank ") + _local_4) + ".");
                }
                return (((("Requires " + _arg_1.sFaction) + ", Rank ") + _local_4) + ".");
            }
            if (((!(_arg_1.reqd == null)) && (!(hasRequiredItemsForQuest(_arg_1)))))
            {
                _local_6 = "Required Item(s): ";
                _local_7 = 0;
                while (_local_7 < _arg_1.reqd.length)
                {
                    _local_8 = world.invTree[_arg_1.reqd[_local_7].ItemID];
                    _local_9 = _arg_1.reqd[_local_7].iQty;
                    if (_local_8.sES == "ar")
                    {
                        _local_10 = getRankFromPoints(_local_9);
                        _local_11 = (_local_9 - arrRanks[(_local_10 - 1)]);
                        if (_local_11 > 0)
                        {
                            _local_6 = (_local_6 + (_local_11 + " Class Points on "));
                        }
                        _local_6 = (_local_6 + ((_local_8.sName + ", Rank ") + _local_10));
                    }
                    else
                    {
                        _local_6 = (_local_6 + _local_8.sName);
                        if (_local_9 > 1)
                        {
                            _local_6 = (_local_6 + ("x" + _local_9));
                        }
                    }
                    _local_6 = (_local_6 + ", ");
                    _local_7++;
                }
                _local_6 = (_local_6.substr(0, (_local_6.length - 2)) + ".");
                return (_local_6);
            }
            return ("");
        }

        private function hasRequiredItemsForQuest(_arg_1:Object):Boolean
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:int;
            if (((!(_arg_1.reqd == null)) && (_arg_1.reqd.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < _arg_1.reqd.length)
                {
                    _local_3 = _arg_1.reqd[_local_2].ItemID;
                    _local_4 = int(_arg_1.reqd[_local_2].iQty);
                    if (((world.invTree[_local_3] == null) || (int(world.invTree[_local_3].iQty) < _local_4)))
                    {
                        return (false);
                    }
                    _local_2++;
                }
            }
            return (true);
        }

        public function xTryMe(_arg_1:Object):*
        {
            var _local_2:String;
            switch (_arg_1.sES)
            {
                case "Weapon":
                case "he":
                case "ba":
                case "pe":
                case "ar":
                case "co":
                case "mi":
                    _local_2 = _arg_1.sES;
                    _local_2 = ((_local_2 == "ar") ? "co" : _local_2);
                    if (_local_2 == "pe")
                    {
                        if (world.myAvatar.objData.eqp["pe"])
                        {
                            world.myAvatar.unloadPet();
                        }
                    }
                    if (!world.myAvatar.objData.eqp[_local_2])
                    {
                        world.myAvatar.objData.eqp[_local_2] = {};
                        world.myAvatar.objData.eqp[_local_2].wasCreated = true;
                    }
                    if (((world.myAvatar.objData.eqp[_local_2].isPreview) || (world.myAvatar.objData.eqp[_local_2].wasCreated)))
                    {
                        if (((world.myAvatar.objData.eqp[_local_2].sFile == _arg_1.sFile) && (world.myAvatar.objData.eqp[_local_2].sType == _arg_1.sType)))
                        {
                            if (world.myAvatar.objData.eqp[_local_2].wasCreated)
                            {
                                delete world.myAvatar.objData.eqp[_local_2];
                                world.myAvatar.unloadMovieAtES(_local_2);
                            }
                            else
                            {
                                if (world.myAvatar.objData.eqp[_local_2].isPreview)
                                {
                                    if (_local_2 == "pe")
                                    {
                                        if (world.myAvatar.objData.eqp["pe"])
                                        {
                                            world.myAvatar.unloadPet();
                                        }
                                    }
                                    world.myAvatar.objData.eqp[_local_2].sType = world.myAvatar.objData.eqp[_local_2].oldType;
                                    world.myAvatar.objData.eqp[_local_2].sFile = world.myAvatar.objData.eqp[_local_2].oldFile;
                                    world.myAvatar.objData.eqp[_local_2].sLink = world.myAvatar.objData.eqp[_local_2].oldLink;
                                    world.myAvatar.loadMovieAtES(_local_2, world.myAvatar.objData.eqp[_local_2].oldFile, world.myAvatar.objData.eqp[_local_2].oldLink);
                                    world.myAvatar.objData.eqp[_local_2].isPreview = null;
                                }
                            }
                            return;
                        }
                    }
                    if (!world.myAvatar.objData.eqp[_local_2].isPreview)
                    {
                        world.myAvatar.objData.eqp[_local_2].isPreview = true;
                        if (!world.myAvatar.objData.eqp[_local_2].isShowable)
                        {
                            if (("sType" in _arg_1))
                            {
                                world.myAvatar.objData.eqp[_local_2].oldType = world.myAvatar.objData.eqp[_local_2].sType;
                            }
                            world.myAvatar.objData.eqp[_local_2].oldFile = world.myAvatar.objData.eqp[_local_2].sFile;
                            world.myAvatar.objData.eqp[_local_2].oldLink = world.myAvatar.objData.eqp[_local_2].sLink;
                        }
                    }
                    if (("sType" in _arg_1))
                    {
                        world.myAvatar.objData.eqp[_local_2].sType = _arg_1.sType;
                    }
                    world.myAvatar.objData.eqp[_local_2].sFile = ((_arg_1.sFile == "undefined") ? "" : _arg_1.sFile);
                    world.myAvatar.objData.eqp[_local_2].sLink = _arg_1.sLink;
                    world.myAvatar.loadMovieAtES(_local_2, _arg_1.sFile, _arg_1.sLink);
                    if (((_local_2 == "pe") && (!(_arg_1.sName.indexOf("Bank Pet") == -1))))
                    {
                        petDisable.addEventListener(TimerEvent.TIMER, onPetDisable, false, 0, true);
                        petDisable.start();
                    }
                    hasPreviewed = true;
                    return;
            }
        }

        internal function onPetDisable(_arg_1:TimerEvent):void
        {
            if (!world.myAvatar.petMC.mcChar)
            {
                return;
            }
            world.myAvatar.petMC.mcChar.mouseEnabled = false;
            world.myAvatar.petMC.mcChar.mouseChildren = false;
            world.myAvatar.petMC.mcChar.enabled = false;
            petDisable.reset();
            petDisable.removeEventListener(TimerEvent.TIMER, onPetDisable);
        }

        public function showPortrait(_arg_1:Avatar):*
        {
            if (litePreference.data.bHideUI)
            {
                return;
            }
            showPortraitBox(_arg_1, ui.mcPortrait);
            world.updatePortrait(_arg_1);
            ui.iconQuest.visible = true;
            ui.monsterIcon.visible = true;
        }

        public function hidePortrait():void
        {
            ui.monsterIcon.visible = false;
            ui.mcPortrait.visible = false;
            ui.iconQuest.visible = false;
        }

        public function showPortraitTarget(_arg_1:Avatar):*
        {
            if (litePreference.data.bHideUI)
            {
                return;
            }
            showPortraitBox(((Number(world.objExtra["bChar"]) == 1) ? world.myAvatar : _arg_1), ui.mcPortraitTarget);
            ui.mcPortraitTarget.pvpIcon.visible = world.bPvP;
            world.updatePortrait(_arg_1);
            ui.btnTargetPortraitClose.visible = true;
        }

        public function hidePortraitTarget():void
        {
            var _local_1:MovieClip;
            var _local_2:DisplayObject;
            _local_1 = (ui.mcPortraitTarget.mcHead as MovieClip);
            _local_2 = _local_1.head.getChildByName("face");
            if (_local_2 != null)
            {
                _local_1.head.removeChild(_local_2);
            }
            while (_local_1.backhair.numChildren > 0)
            {
                _local_1.backhair.removeChildAt(0);
            }
            while (_local_1.head.hair.numChildren > 0)
            {
                _local_1.head.hair.removeChildAt(0);
            }
            while (_local_1.head.helm.numChildren > 0)
            {
                _local_1.head.helm.removeChildAt(0);
            }
            ui.mcPortraitTarget.visible = false;
            ui.btnTargetPortraitClose.visible = false;
        }

        public function showPortraitBox(avt:Avatar, mcPortraitBox:MovieClip):*
        {
            var AssetClass:Class;
            var mc:MovieClip;
            var child:DisplayObject;
            var bBackHair:Boolean;
            var sSkinLink:String;
            var AssetClass2:Class;
            mc = (mcPortraitBox.mcHead as MovieClip);
            bBackHair = false;
            mcPortraitBox.pAV = avt;
            if (avt.npcType == "monster")
            {
                AssetClass = world.getClass(("mcHead" + avt.objData.strLinkage));
                child = mc.head.getChildByName("face");
                if (child != null)
                {
                    mc.head.removeChild(child);
                }
                mc.head.addChildAt(new (AssetClass)(), 0).name = "face";
                mc.head.hair.visible = false;
                mc.head.helm.visible = false;
                mc.backhair.visible = false;
            }
            else
            {
                try
                {
                    sSkinLink = avt.objData.eqp.ar.sLink;
                    if (avt.objData.eqp.co != null)
                    {
                        sSkinLink = avt.objData.eqp.co.sLink;
                    }
                    AssetClass = world.getClass(((sSkinLink + avt.objData.strGender) + "Head"));
                    child = mc.head.getChildByName("face");
                    if (child != null)
                    {
                        mc.head.removeChild(child);
                    }
                    mc.head.addChildAt(new (AssetClass)(), 0).name = "face";
                }
                catch(err:Error)
                {
                    AssetClass = world.getClass(("mcHead" + avt.objData.strGender));
                    child = mc.head.getChildByName("face");
                    if (child != null)
                    {
                        mc.head.removeChild(child);
                    }
                    mc.head.addChildAt(new (AssetClass)(), 0).name = "face";
                }

                AssetClass = world.getClass(avt.objData.strHairName + avt.objData.strGender + "Hair");
                onRemoveChildrens(mc.head.hair);

                try
                {
                    mc.head.hair.addChild(new AssetClass());
                    mc.head.hair.cacheAsBitmap = true;
                }
                catch(e:Error)
                {

                }

                mc.head.hair.visible = true;

                try
                {
                    AssetClass = world.getClass(((avt.objData.strHairName + avt.objData.strGender) + "HairBack"));
                    while (mc.backhair.numChildren > 0)
                    {
                        mc.backhair.removeChildAt(0);
                    }
                    mc.backhair.addChild(new (AssetClass)());
                    mc.backhair.visible = true;
                    bBackHair = true;
                }
                catch(err:Error)
                {
                    mc.backhair.visible = false;
                }
                if (((!(avt.objData.eqp.he == null)) && (!(avt.objData.eqp.he.sLink == null))))
                {
                    try
                    {
                        AssetClass = world.getClass(avt.objData.eqp.he.sLink);
                        AssetClass2 = (world.getClass((avt.objData.eqp.he.sLink + "_backhair")) as Class);
                        while (mc.head.helm.numChildren > 0)
                        {
                            mc.head.helm.removeChildAt(0);
                        }
                        mc.head.helm.addChild(new (AssetClass)());
                        mc.head.helm.visible = avt.dataLeaf.showHelm;
                        mc.head.hair.visible = (!(mc.head.helm.visible));
                        if (AssetClass2 != null)
                        {
                            if (avt.dataLeaf.showHelm)
                            {
                                if (mc.backhair.numChildren > 0)
                                {
                                    mc.backhair.removeChildAt(0);
                                }
                                mc.backhair.visible = true;
                                mc.backhair.addChild(new (AssetClass2)());
                            }
                        }
                        else
                        {
                            mc.backhair.visible = ((mc.head.hair.visible) && (bBackHair));
                        }
                    }
                    catch(err:Error)
                    {
                        mc.head.helm.visible = false;
                    }
                }
                else
                {
                    mc.head.helm.visible = false;
                }
            }
            mcPortraitBox.visible = true;
            ui.mcPortrait.iconDrops.initRoot(this);
            ui.mcPortrait.iconDrops.visible = litePreference.data.bCustomDrops;
        }

        public function oniconQuestClick(_arg_1:MouseEvent):void
        {
            if (litePreference.data.bQuestPin)
            {
                if (_arg_1.shiftKey)
                {
                    ui.mcQTracker.toggle();
                    return;
                }
                world.showQuests(pinnedQuests, "q");
            }
            else
            {
                ui.mcQTracker.toggle();
            }
        }

        public function manageXPBoost(_arg_1:Object):void
        {
            var _local_2:*;
            var _local_3:*;
            ui.mcPortrait.iconBoostXP.visible = (_arg_1.op == "+");
            if (_arg_1.op == "+")
            {
                world.myAvatar.objData.iBoostXP = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostXP.boostTS = new Date().getTime();
                ui.mcPortrait.iconBoostXP.iBoostXP = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostXP.bShowShop = _arg_1.bShowShop;
                addUpdate("You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds.");
                chatF.pushMsg("server", (("You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds. " + Math.ceil((_arg_1.iSecsLeft / 60))) + " minute(s) remaining."), "SERVER", "", 0);
            }
            else
            {
                delete world.myAvatar.objData.iBoostXP;
                delete ui.mcPortrait.iconBoostXP.boostTS;
                delete ui.mcPortrait.iconBoostXP.iBoostXP;
                addUpdate("The Experience Boost has faded!  Experience rewards are no longer doubled.");
                chatF.pushMsg("server", "The Experience Boost has faded!  Experience rewards are no longer doubled.", "SERVER", "", 0);
                if (((!(ui.mcPortrait.iconBoostXP.bShowShop == null)) && (ui.mcPortrait.iconBoostXP.bShowShop)))
                {
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "Your Experience Boost has faded!\tExperience rewards are no longer doubled.  Would you like to purchase a new Experience Boost?";
                    _local_3.params = {};
                    _local_3.callback = openExpBoostStore;
                    _local_3.glow = "red,medium";
                    ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                }
            }
        }

        public function manageGBoost(_arg_1:Object):void
        {
            var _local_2:*;
            var _local_3:*;
            ui.mcPortrait.iconBoostG.visible = (_arg_1.op == "+");
            if (_arg_1.op == "+")
            {
                world.myAvatar.objData.iBoostG = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostG.boostTS = new Date().getTime();
                ui.mcPortrait.iconBoostG.iBoostG = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostG.bShowShop = _arg_1.bShowShop;
                addUpdate("You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds.");
                chatF.pushMsg("server", (("You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds. " + Math.ceil((_arg_1.iSecsLeft / 60))) + " minute(s) remaining."), "SERVER", "", 0);
            }
            else
            {
                delete world.myAvatar.objData.iBoostG;
                delete ui.mcPortrait.iconBoostG.boostTS;
                delete ui.mcPortrait.iconBoostG.iBoostG;
                addUpdate("The Gold Boost has faded!  Gold rewards are no longer doubled.");
                chatF.pushMsg("server", "The Gold Boost has faded!  Gold rewards are no longer doubled.", "SERVER", "", 0);
                if (((!(ui.mcPortrait.iconBoostG.bShowShop == null)) && (ui.mcPortrait.iconBoostG.bShowShop)))
                {
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "Your Gold Boost has faded!  Gold rewards are no longer doubled.  Would you like to purchase a new Gold Boost?";
                    _local_3.params = {};
                    _local_3.callback = openExpBoostStore;
                    _local_3.glow = "red,medium";
                    ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                }
            }
        }

        public function manageRepBoost(_arg_1:Object):void
        {
            var _local_2:*;
            var _local_3:*;
            ui.mcPortrait.iconBoostRep.visible = (_arg_1.op == "+");
            if (_arg_1.op == "+")
            {
                world.myAvatar.objData.iBoostRep = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostRep.boostTS = new Date().getTime();
                ui.mcPortrait.iconBoostRep.iBoostRep = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostRep.bShowShop = _arg_1.bShowShop;
                addUpdate("You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds.");
                chatF.pushMsg("server", (("You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds. " + Math.ceil((_arg_1.iSecsLeft / 60))) + " minute(s) remaining."), "SERVER", "", 0);
            }
            else
            {
                delete world.myAvatar.objData.iBoostRep;
                delete ui.mcPortrait.iconBoostRep.boostTS;
                delete ui.mcPortrait.iconBoostRep.iBoostRep;
                addUpdate("The Reputation Boost has faded!  Reputation rewards are no longer doubled.");
                chatF.pushMsg("server", "The Reputation Boost has faded!  Reputation rewards are no longer doubled.", "SERVER", "", 0);
                if (((!(ui.mcPortrait.iconBoostRep.bShowShop == null)) && (ui.mcPortrait.iconBoostRep.bShowShop)))
                {
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "Your Reputation Boost has faded!\tReputation rewards are no longer doubled.  Would you like to purchase a new Reputation Boost?";
                    _local_3.params = {};
                    _local_3.callback = openExpBoostStore;
                    _local_3.glow = "red,medium";
                    ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                }
            }
        }

        public function manageCPBoost(_arg_1:Object):void
        {
            var _local_2:*;
            var _local_3:*;
            ui.mcPortrait.iconBoostCP.visible = (_arg_1.op == "+");
            if (_arg_1.op == "+")
            {
                world.myAvatar.objData.iBoostCP = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostCP.boostTS = new Date().getTime();
                ui.mcPortrait.iconBoostCP.iBoostCP = _arg_1.iSecsLeft;
                ui.mcPortrait.iconBoostCP.bShowShop = _arg_1.bShowShop;
                addUpdate("You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds.");
                chatF.pushMsg("server", (("You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds. " + Math.ceil((_arg_1.iSecsLeft / 60))) + " minute(s) remaining."), "SERVER", "", 0);
            }
            else
            {
                delete world.myAvatar.objData.iBoostCP;
                delete ui.mcPortrait.iconBoostCP.boostTS;
                delete ui.mcPortrait.iconBoostCP.iBoostCP;
                addUpdate("The ClassPoint Boost has faded!  ClassPoint rewards are no longer doubled.");
                chatF.pushMsg("server", "The ClassPoint Boost has faded!  ClassPoint rewards are no longer doubled.", "SERVER", "", 0);
                if (((!(ui.mcPortrait.iconBoostCP.bShowShop == null)) && (ui.mcPortrait.iconBoostCP.bShowShop)))
                {
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "Your ClassPoint Boost has faded!\tClassPoint rewards are no longer doubled.  Would you like to purchase a new ClassPoint Boost?";
                    _local_3.params = {};
                    _local_3.callback = openExpBoostStore;
                    _local_3.glow = "red,medium";
                    ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                }
            }
        }

        public function oniconBoostXPOver(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:String;
            _local_2 = MovieClip(_arg_1.currentTarget);
            _local_3 = new Date().getTime();
            _local_4 = Math.max(((_local_2.boostTS + (_local_2.iBoostXP * 1000)) - _local_3), 0);
            _local_5 = 0;
            _local_6 = "All Experience gains are doubled.\n";
            if (_local_4 < 120000)
            {
                _local_5 = int(Math.floor((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minute(s), ")));
                _local_5 = int(Math.round(((_local_4 % 60000) / 1000)));
                _local_6 = (_local_6 + String((_local_5 + " second(s) remaining.")));
            }
            else
            {
                _local_5 = int(Math.round((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minutes remaining.")));
            }
            ui.ToolTip.openWith({"str":_local_6});
        }

        public function oniconBoostGoldOver(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:String;
            _local_2 = MovieClip(_arg_1.currentTarget);
            _local_3 = new Date().getTime();
            _local_4 = Math.max(((_local_2.boostTS + (_local_2.iBoostG * 1000)) - _local_3), 0);
            _local_5 = 0;
            _local_6 = "All Gold gains are doubled.\n";
            if (_local_4 < 120000)
            {
                _local_5 = int(Math.floor((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minute(s), ")));
                _local_5 = int(Math.round(((_local_4 % 60000) / 1000)));
                _local_6 = (_local_6 + String((_local_5 + " second(s) remaining.")));
            }
            else
            {
                _local_5 = int(Math.round((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minutes remaining.")));
            }
            ui.ToolTip.openWith({"str":_local_6});
        }

        public function oniconBoostRepOver(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:String;
            _local_2 = MovieClip(_arg_1.currentTarget);
            _local_3 = new Date().getTime();
            _local_4 = Math.max(((_local_2.boostTS + (_local_2.iBoostRep * 1000)) - _local_3), 0);
            _local_5 = 0;
            _local_6 = "All Reputation gains are doubled.\n";
            if (_local_4 < 120000)
            {
                _local_5 = int(Math.floor((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minute(s), ")));
                _local_5 = int(Math.round(((_local_4 % 60000) / 1000)));
                _local_6 = (_local_6 + String((_local_5 + " second(s) remaining.")));
            }
            else
            {
                _local_5 = int(Math.round((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minutes remaining.")));
            }
            ui.ToolTip.openWith({"str":_local_6});
        }

        public function oniconBoostCPOver(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:String;
            _local_2 = MovieClip(_arg_1.currentTarget);
            _local_3 = new Date().getTime();
            _local_4 = Math.max(((_local_2.boostTS + (_local_2.iBoostCP * 1000)) - _local_3), 0);
            _local_5 = 0;
            _local_6 = "All ClassPoint gains are doubled.\n";
            if (_local_4 < 120000)
            {
                _local_5 = int(Math.floor((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minute(s), ")));
                _local_5 = int(Math.round(((_local_4 % 60000) / 1000)));
                _local_6 = (_local_6 + String((_local_5 + " second(s) remaining.")));
            }
            else
            {
                _local_5 = int(Math.round((_local_4 / 60000)));
                _local_6 = (_local_6 + String((_local_5 + " minutes remaining.")));
            }
            ui.ToolTip.openWith({"str":_local_6});
        }

        public function openExpBoostStore(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                world.sendLoadShopRequest(184);
            }
        }

        public function oniconBoostOut(_arg_1:MouseEvent):void
        {
            ui.ToolTip.close();
        }

        public function updateXPBar():void
        {
            var _local_1:Number;
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            _local_1 = (world.myAvatar.objData.intExp / world.myAvatar.objData.intExpToLevel);
            ui.mcInterface.mcXPBar.mcXP.scaleX = ((_local_1 > 1) ? 1 : _local_1);
            _local_2 = world.myAvatar.objData;
            _local_3 = _local_2.intExp;
            _local_4 = _local_2.intExpToLevel;
            _local_5 = int(((_local_3 / _local_4) * 100));
            if (_local_5 >= 100)
            {
                _local_5 = 100;
            }
            ui.mcInterface.mcXPBar.strXP.text = (((((((("Level " + world.myAvatar.objData.intLevel) + " : ") + _local_3) + " / ") + _local_4) + "  (") + _local_5) + "%)");
        }

        public function xpBarMouseOver(_arg_1:MouseEvent):*
        {
            MovieClip(_arg_1.currentTarget).strXP.visible = true;
        }

        public function xpBarMouseOut(_arg_1:MouseEvent):*
        {
            MovieClip(_arg_1.currentTarget).strXP.visible = false;
        }

        public function updateRepBar():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            _local_1 = world.myAvatar.objData.iCurCP;
            _local_2 = world.myAvatar.objData.iCPToRank;
            if (_local_2 <= 0)
            {
                ui.mcInterface.mcRepBar.mcRep.scaleX = 0.1;
                ui.mcInterface.mcRepBar.mcRep.visible = false;
                ui.mcInterface.mcRepBar.strRep.text = ((world.myAvatar.objData.strClassName + ", Rank ") + world.myAvatar.objData.iRank);
            }
            else
            {
                _local_3 = int(((_local_1 / _local_2) * 100));
                if (_local_3 >= 100)
                {
                    _local_3 = 100;
                }
                ui.mcInterface.mcRepBar.mcRep.scaleX = (_local_1 / _local_2);
                ui.mcInterface.mcRepBar.mcRep.visible = true;
                ui.mcInterface.mcRepBar.strRep.text = (((((((((world.myAvatar.objData.strClassName + ", Rank ") + world.myAvatar.objData.iRank) + " : ") + _local_1) + "/") + _local_2) + "  (") + _local_3) + "%)");
            }
        }

        public function onRepBarMouseOver(_arg_1:MouseEvent):*
        {
            MovieClip(_arg_1.currentTarget).strRep.visible = true;
        }

        public function onRepBarMouseOut(_arg_1:MouseEvent):*
        {
            MovieClip(_arg_1.currentTarget).strRep.visible = false;
        }

        public function disabledDelay(_arg_1:TimerEvent):void
        {
        }

        public function actIconClick(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            _local_2 = MovieClip(_arg_1.currentTarget).actObj;
            if (((!(_local_2.auto == null)) && (_local_2.auto == true)))
            {
                world.approachTarget();
            }
            else
            {
                world.testAction(_local_2);
            }
        }

        public function determineIndex(_arg_1:Number):Number
        {
            var _local_2:Number;
            _local_2 = 10;
            if (_arg_1 <= 3)
            {
                _local_2 = _arg_1;
            }
            else
            {
                if (_arg_1 == 4)
                {
                    _local_2 = 5;
                }
                else
                {
                    if (_arg_1 <= 6)
                    {
                        _local_2 = 4;
                    }
                }
            }
            return (_local_2);
        }

        public function actIconOver(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip;
            var _local_3:*;
            var _local_4:String;
            _local_2 = MovieClip(_arg_1.currentTarget);
            if (((uoPref.bTT) || (!(world.myAvatar.dataLeaf.intState == 2))))
            {
                if (_local_2.item == null)
                {
                    _local_3 = _local_2.actObj;
                    if (_local_3 != null)
                    {
                        _local_3.desc = _local_3.desc.replace(regExLineSpace, "\n");
                        _local_4 = (("<b>" + _local_3.nam) + "</b>\n");
                        if (!_local_3.isOK)
                        {
                            _local_4 = (_local_4 + (("<font color='#FF0000'>Unlocks at Rank " + String(determineIndex(_local_2.actionIndex))) + "!</font>\n"));
                        }
                        if (_local_3.typ != "passive")
                        {
                            if (_local_3.mp > 0)
                            {
                                _local_4 = (_local_4 + (("<font color='#0033AA'>" + _local_3.mp) + "</font> mana, "));
                            }
                            _local_4 = (_local_4 + ((("<font color='#AA3300'>" + (_local_3.cd / 1000)) + "</font> sec cooldown") + "\n"));
                        }
                        switch (_local_3.typ)
                        {
                            case "p":
                            case "ph":
                            case "aa":
                                _local_4 = (_local_4 + "Physical");
                                break;
                            case "m":
                                _local_4 = (_local_4 + "Magical");
                                break;
                            case "ma":
                                _local_4 = (_local_4 + "True Damage");
                                break;
                            case "pm":
                            case "mp":
                                _local_4 = (_local_4 + "Hybrid");
                                break;
                            case "passive":
                                _local_4 = (_local_4 + "<font color='#0033AA'>Passive Ability</font>");
                                break;
                        }
                        _local_4 = (_local_4 + "\n");
                        if (_local_3.typ != "passive")
                        {
                            if (_local_3.range <= 301)
                            {
                                _local_4 = (_local_4 + "A <font color='#AA3300'>short range</font> ");
                            }
                            else
                            {
                                if (_local_3.range >= 3000)
                                {
                                    _local_4 = (_local_4 + "An <font color='#0033AA'>infinite range</font> ");
                                }
                                else
                                {
                                    if (_local_3.range >= 808)
                                    {
                                        _local_4 = (_local_4 + "A <font color='#0033AA'>long range</font> ");
                                    }
                                    else
                                    {
                                        _local_4 = (_local_4 + "A <font color='#AA3300'>medium range</font> ");
                                    }
                                }
                            }
                            if (!_local_3.damage)
                            {
                                _local_4 = (_local_4 + "status skill that applies to ");
                            }
                            else
                            {
                                _local_4 = (_local_4 + ((((_local_3.damage < 0) ? "skill" : "attack") + " that ") + ((_local_3.damage < 0) ? "heals " : "deals damage to ")));
                            }
                            if (_local_3.tgt == "f")
                            {
                                _local_4 = (_local_4 + ("<font color='#0033AA'>" + ((_local_3.tgtMax) || (1))));
                                _local_4 = (_local_4 + ((_local_3.tgtMax > 1) ? " friendly targets.</font>" : " target.</font>"));
                            }
                            else
                            {
                                if (_local_3.tgt == "s")
                                {
                                    _local_4 = (_local_4 + "<font color='#0033AA'>yourself.</font>");
                                }
                                else
                                {
                                    _local_4 = (_local_4 + ("<font color='#AA3300'>" + ((_local_3.tgtMax) || (1))));
                                    _local_4 = (_local_4 + ((_local_3.tgtMax > 1) ? " hostile targets.</font>" : " target.</font>"));
                                }
                            }
                            _local_4 = (_local_4 + "\n\n");
                        }
                        if (_local_3.sArg2 != "")
                        {
                            _local_4 = (_local_4 + _local_3.sArg2);
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_3.desc);
                        }
                        ui.ToolTip.openWith({
                            "str":_local_4,
                            "lowerright":true
                        });
                    }
                }
                else
                {
                    ui.ToolTip.openWith({
                        "str":(((((_local_2.item.sName + "\n") + "<font color='#AA3300'>") + (_local_2.actObj.cd / 1000)) + "</font> sec cooldown\n") + _local_2.item.sDesc),
                        "lowerright":true
                    });
                }
            }
        }

        public function actIconOut(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            _local_2 = MovieClip(stage.getChildAt(0)).ui.ToolTip;
            _local_2.close();
        }

        public function portraitClick(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            var _local_3:*;
            _local_2 = MovieClip(_arg_1.currentTarget);
            if (_local_2.pAV.npcType == "player")
            {
                _local_3 = {};
                _local_3.ID = _local_2.pAV.objData.CharID;
                _local_3.strUsername = _local_2.pAV.objData.strUsername;
                if (_local_2.pAV != world.myAvatar)
                {
                    ui.cMenu.fOpenWith("user", _local_3);
                }
                else
                {
                    ui.cMenu.fOpenWith("self", _local_3);
                }
            }
            else
            {
                if (_local_2.pAV.npcType == "monster")
                {
                    _local_3 = {};
                    _local_3.ID = _local_2.pAV.objData.MonMapID;
                    _local_3.strUsername = _local_2.pAV.objData.strMonName;
                    _local_3.target = world.getMonster(_local_3.ID).pMC;
                    ui.cMenu.fOpenWith("mons", _local_3);
                }
            }
        }

        private function onTargetPortraitCloseClick(_arg_1:MouseEvent):void
        {
            world.cancelTarget();
        }

        private function onBtnMonsterClick(_arg_1:MouseEvent):void
        {
            world.toggleMonsters();
        }

        public function showMap():void
        {
            ui.mcInterface.mcMenu.mcMenuButtons.visible = true;
            ui.mcPopup.fOpen("Map");
        }

        public function logout():void
        {
            if (aeraRiftPanel != null) aeraRiftPanel.reset();
            if (aeraRiftHUD != null) aeraRiftHUD.visible = false;
            if (((intChatMode) && (chatF.bTall)))
            {
                ui.mcInterface.ncModeChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            if (litePreference.data.bCharSelect)
            {
                saveChar();
            }
            sfc.sendXtMessage("zm", "cmd", ["logout"], "str", 1);
        }

        public function showServerList():void
        {
            if (((intChatMode) && (chatF.bTall)))
            {
                ui.mcInterface.ncModeChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            if (litePreference.data.bCharSelect)
            {
                saveChar();
            }
            showServers = true;
            sfc.sendXtMessage("zm", "cmd", ["logout"], "str", 1);
        }

        public function showUpgradeWindow(_arg_1:Object=null):void
        {
            var _local_2:MovieClip;
            if (mcUpgradeWindow == null)
            {
                mcUpgradeWindow = new MCUpgradeWindow();
            }
            _local_2 = (mcUpgradeWindow as MovieClip);
            var _local_3:* = ((_arg_1 != null) ? _arg_1 : world.myAvatar.objData);
            _local_2.btnClose.addEventListener(MouseEvent.CLICK, hideUpgradeWindow, false, 0, true);
            _local_2.btnClose2.addEventListener(MouseEvent.CLICK, hideUpgradeWindow, false, 0, true);
            _local_2.btnBuy.addEventListener(MouseEvent.CLICK, onUpgradeClick, false, 0, true);
            addChild(mcUpgradeWindow);
            try
            {
                ui.mouseChildren = false;
                world.mouseChildren = false;
            }
            catch(e:Error)
            {
            }
            try
            {
                mcLogin.sl.mouseChildren = false;
            }
            catch(e:Error)
            {
            }
        }

        public function hideUpgradeWindow(_arg_1:MouseEvent):void
        {
            removeChild(mcUpgradeWindow);
            try
            {
                ui.mouseChildren = true;
                world.mouseChildren = true;
            }
            catch(e:Error)
            {
            }
            try
            {
                mcLogin.sl.mouseChildren = true;
            }
            catch(e:Error)
            {
            }
        }

        public function onUpgradeClick(_arg_1:Event):void
        {
            var _local_2:String;
            mixer.playSound("Click");
            if (ISWEB)
            {
                extCall.setUpPayment(sToken);
            }
            else
            {
                _local_2 = "https://nightvaults.com/";
                navigateToURL(new URLRequest(_local_2), "_blank");
            }
        }

        public function showACWindow():void
        {
            var _local_1:MovieClip;
            if (mcACWindow == null)
            {
                mcACWindow = new MCACWindow();
            }
            _local_1 = (mcACWindow as MovieClip);
            _local_1.btnClose.addEventListener(MouseEvent.CLICK, hideACWindow, false, 0, true);
            _local_1.btnClose2.addEventListener(MouseEvent.CLICK, hideACWindow, false, 0, true);
            _local_1.btnBuy.addEventListener(MouseEvent.CLICK, onUpgradeClick, false, 0, true);
            _local_1.btnUpgrade.addEventListener(MouseEvent.CLICK, onUpgradeClick, false, 0, true);
            addChild(mcACWindow);
            try
            {
                ui.mouseChildren = false;
                world.mouseChildren = false;
            }
            catch(e:Error)
            {
            }
            try
            {
                mcLogin.sl.mouseChildren = false;
            }
            catch(e:Error)
            {
            }
        }

        public function hideACWindow(_arg_1:MouseEvent):void
        {
            removeChild(mcACWindow);
            try
            {
                ui.mouseChildren = true;
                world.mouseChildren = true;
            }
            catch(e:Error)
            {
            }
            try
            {
                mcLogin.sl.mouseChildren = true;
            }
            catch(e:Error)
            {
            }
        }

        public function initArrHP():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Number;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Number;
            var _local_11:*;
            _local_1 = 100;
            _local_2 = 550;
            _local_3 = 275;
            _local_4 = 0.8;
            _local_5 = 720;
            _local_6 = 200;
            _local_7 = 0.92;
            _local_8 = 350;
            _local_9 = 3650;
            _local_10 = 1.1;
            _local_11 = 0;
            while (_local_11 < _local_1)
            {
                if (_local_11 > 19)
                {
                    arrHP.push(Math.round((_local_8 + (Math.pow((_local_11 / _local_1), _local_10) * _local_9))));
                }
                else
                {
                    if (_local_11 > 7)
                    {
                        arrHP.push(Math.round((_local_5 + (Math.pow((_local_11 / 20), _local_7) * _local_6))));
                    }
                    else
                    {
                        arrHP.push(Math.round((_local_2 + (Math.pow((_local_11 / 8), _local_4) * _local_3))));
                    }
                }
                _local_11++;
            }
        }

        public function initArrRep():void
        {
            var _local_1:int;
            var _local_2:*;
            _local_1 = 0;
            _local_2 = 1;
            while (_local_2 < 10)
            {
                _local_1 = (Math.pow((_local_2 + 1), 3) * 100);
                if (_local_2 > 1)
                {
                    arrRanks.push((_local_1 + arrRanks[(_local_2 - 1)]));
                }
                else
                {
                    arrRanks.push((_local_1 + 100));
                }
                _local_2++;
            }
        }

        public function getRankFromPoints(_arg_1:int):int
        {
            var _local_2:int;
            var _local_3:*;
            _local_2 = 1;
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            }
            _local_3 = 1;
            while (_local_3 < arrRanks.length)
            {
                if (_arg_1 < arrRanks[_local_3])
                {
                    return (_local_2);
                }
                _local_2++;
                _local_3++;
            }
            return (_local_2);
        }

        public function attachOnModalStack(_arg_1:String):MovieClip
        {
            var _local_2:MovieClip;
            var _local_3:Class;
            var _local_4:*;
            var _local_5:*;
            _local_3 = (world.getClass(_arg_1) as Class);
            _local_4 = true;
            if (ui.ModalStack.numChildren)
            {
                _local_2 = MovieClip(ui.ModalStack.getChildAt(0));
                _local_5 = (_local_2.constructor as Class);
                if (_local_5 == _local_3)
                {
                    _local_4 = false;
                }
            }
            if (_local_4)
            {
                clearModalStack();
                _local_2 = MovieClip(ui.ModalStack.addChild(new (_local_3)()));
                ui.ModalStack.mouseChildren = true;
            }
            return (_local_2);
        }

        public function getInstanceFromModalStack(_arg_1:String):MovieClip
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < ui.ModalStack.numChildren)
            {
                if (getQualifiedClassName((ui.ModalStack.getChildAt(_local_2) == _arg_1)))
                {
                    return (ui.ModalStack.getChildAt(_local_2));
                }
                _local_2++;
            }
            return (null);
        }

        public function isDialoqueUp():Boolean
        {
            var _local_1:int;
            var _local_2:*;
            var _local_3:*;
            _local_1 = 0;
            while (_local_1 < world.FG.numChildren)
            {
                _local_2 = world.FG.getChildAt(_local_1);
                _local_3 = String((_local_2 as MovieClip));
                if (_local_3.indexOf("dlg_") > -1)
                {
                    return (true);
                }
                _local_1++;
            }
            return (false);
        }

        public function clearModalStack():Boolean
        {
            var _local_1:int;
            if (isGreedyModalInStack())
            {
                return (false);
            }
            _local_1 = 0;
            while (((ui.ModalStack.numChildren > 0) && (_local_1 < 100)))
            {
                _local_1++;
                ui.ModalStack.removeChildAt(0);
            }
            stage.focus = null;
            return (true);
        }

        public function closeModalByStrBody(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:MovieClip;
            _local_2 = 0;
            _local_2 = 0;
            while (_local_2 < ui.ModalStack.numChildren)
            {
                _local_3 = (ui.ModalStack.getChildAt(_local_2) as MovieClip);
                if (((_local_3.cnt.strBody.htmlText.indexOf(_arg_1) > -1) && (!(_local_3.currentLabel == "out"))))
                {
                    _local_3.fClose();
                }
                _local_2++;
            }
        }

        public function isGreedyModalInStack():Boolean
        {
            var _local_1:int;
            var _local_2:MovieClip;
            _local_1 = 0;
            _local_1 = 0;
            while (_local_1 < ui.ModalStack.numChildren)
            {
                _local_2 = (ui.ModalStack.getChildAt(_local_1) as MovieClip);
                if (((("greedy" in _local_2) && (!(_local_2.greedy == null))) && (_local_2.greedy == true)))
                {
                    return (true);
                }
                _local_1++;
            }
            return (false);
        }

        public function clearPopups(_arg_1:Array=null):void
        {
            if (ui.mcPopup.currentLabel == "House")
            {
                ui.mcPopup.mcHouseMenu.hideItemHandle();
            }
            if (((_arg_1 == null) || (_arg_1.indexOf(ui.mcPopup.currentLabel) < 0)))
            {
                ui.mcPopup.onClose();
            }
            world.removeMovieFront();
            clearModalStack();
        }

        public function clearPopupsQ():void
        {
            if (((!(ui.mcPopup.currentLabel == "House")) && (!(ui.mcPopup.currentLabel == "HouseShop"))))
            {
                ui.mcPopup.onClose();
            }
        }

        public function addUpdate(_arg_1:String, _arg_2:Boolean=false):void
        {
            var _local_3:MovieClip;
            var _local_4:MovieClip;
            var _local_5:int;
            _local_3 = ui.mcUpdates;
            _local_4 = (_local_3.addChildAt(new uProto(), 1) as MovieClip);
            _local_4.y = 0;
            _local_4.x = _local_3.uproto.x;
            _local_4.t1.ti.text = _arg_1;
            if (_arg_2)
            {
                _local_4.t1.ti.textColor = 0xFF0000;
            }
            _local_4.gotoAndPlay("in");
            _local_5 = 2;
            if (_local_3.numChildren > 2)
            {
                _local_5 = 2;
                while (_local_5 < _local_3.numChildren)
                {
                    if (_local_5 < 4)
                    {
                        _local_3.getChildAt(_local_5).y = (_local_3.getChildAt(_local_5).y - 18);
                    }
                    else
                    {
                        MovieClip(_local_3.getChildAt(_local_5)).stop();
                        _local_3.removeChildAt(_local_5);
                        _local_5--;
                    }
                    _local_5++;
                }
            }
        }

        public function clearUpdates():void
        {
            var _local_1:MovieClip;
            _local_1 = ui.mcUpdates;
            while (_local_1.numChildren > 1)
            {
                _local_1.removeChildAt(1);
            }
        }

        public function showItemDrop(_arg_1:*, _arg_2:*):void
        {
            var _local_3:*;
            if (((litePreference.data.bCustomDrops) && ((_arg_1.bTemp == 0) && (_arg_2))))
            {
                cDropsUI.showItem(_arg_1);
                return;
            }
            if ((((litePreference.data.dOptions["hideDrop"]) && (litePreference.data.bCustomDrops)) && (_arg_1.bTemp == 0)))
            {
                return;
            }
            if ((((litePreference.data.dOptions["hideTemp"]) && (litePreference.data.bCustomDrops)) && (!(_arg_1.bTemp == 0))))
            {
                return;
            }
            if (((litePreference.data.bCustomDrops) && ((_arg_1.bTemp == 0) && (!(_arg_2)))))
            {
                _local_3 = new DFrameMC(_arg_1);
                ui.dropStack.addChild(_local_3);
                _local_3.init();
                _local_3.fY = (_local_3.y = -(_local_3.fHeight + 8));
                _local_3.fX = (_local_3.x = -(_local_3.fWidth / 2));
                cleanDropStack();
                return;
            }
            if (((!(_arg_1.bTemp == 0)) || (!(_arg_2))))
            {
                _local_3 = new DFrameMC(_arg_1);
            }
            else
            {
                _local_3 = new DFrame2MC(_arg_1);
            }
            ui.dropStack.addChild(_local_3);
            _local_3.init();
            _local_3.fY = (_local_3.y = -(_local_3.fHeight + 8));
            _local_3.fX = (_local_3.x = -(_local_3.fWidth / 2));
            cleanDropStack();
        }

        public function cleanDropStack():void
        {
            var _local_1:MovieClip;
            var _local_2:MovieClip;
            var _local_3:*;
            _local_1 = null;
            _local_2 = null;
            _local_3 = (ui.dropStack.numChildren - 2);
            while (_local_3 > -1)
            {
                _local_1 = (ui.dropStack.getChildAt(_local_3) as MovieClip);
                _local_2 = (ui.dropStack.getChildAt((_local_3 + 1)) as MovieClip);
                _local_1.fY = (_local_1.y = (_local_2.fY - (_local_2.fHeight + 8)));
                _local_3--;
            }
        }

        public function dropStackBoost():void
        {
            ui.dropStack.y = 438;
        }

        public function dropStackReset():void
        {
            ui.dropStack.y = 493;
        }

        public function showAchievement(_arg_1:String, _arg_2:int):void
        {
            var _local_3:mcAchievement;
            var _local_4:MovieClip;
            _local_3 = new mcAchievement();
            _local_4 = (ui.dropStack.addChild(_local_3) as MovieClip);
            _local_4.cnt.tBody.text = _arg_1;
            _local_4.cnt.tPts.text = _arg_2;
            _local_4.fWidth = 348;
            _local_4.fHeight = 90;
            _local_4.fX = (_local_4.x = -(_local_4.fWidth / 2));
            _local_4.fY = (_local_4.y = -(_local_4.fHeight + 8));
            cleanDropStack();
        }

        public function showQuestpopup(_arg_1:Object):void
        {
            var _local_2:mcQuestpopup;
            var _local_3:MovieClip;
            var _local_4:String;
            var _local_5:Object;
            var _local_6:int;
            if (litePreference.data.bDisQPopup)
            {
                return;
            }
            _local_2 = new mcQuestpopup();
            _local_2.cnt.mcAC.visible = false;
            _local_3 = (ui.dropStack.addChild(_local_2) as MovieClip);
            _local_3.cnt.tName.text = _arg_1.sName;
            _local_3.cnt.rewards.tRewards.htmlText = "";
            _local_4 = "";
            _local_5 = _arg_1.rewardObj;
            if ((("intCoins" in _local_5) && (_local_5.intCoins > 0)))
            {
                _local_4 = (("<font color='#FFFFFF'>" + _local_5.intCoins) + "</font>");
                _local_4 = (_local_4 + "<font color='#FFCC00'>ac</font>");
            }
            if ((("intGold" in _local_5) && (_local_5.intGold > 0)))
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + "<font color='#FFFFFF'>, </font>");
                }
                _local_4 = (_local_4 + (("<font color='#FFFFFF'>" + _local_5.intGold) + "</font>"));
                _local_4 = (_local_4 + "<font color='#FFCC00'>g</font>");
            }
            if ((("intExp" in _local_5) && (_local_5.intExp > 0)))
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + "<font color='#FFFFFF'>, </font>");
                }
                _local_4 = (_local_4 + (("<font color='#FFFFFF'>" + _local_5.intExp) + "</font>"));
                _local_4 = (_local_4 + "<font color='#FF00FF'>xp</font>");
            }
            if ((("iRep" in _local_5) && (_local_5.iRep > 0)))
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + "<font color='#FFFFFF'>, </font>");
                }
                _local_4 = (_local_4 + (("<font color='#FFFFFF'>" + _local_5.iRep) + "</font>"));
                _local_4 = (_local_4 + "<font color='#00CCFF'>rep</font>");
            }
            if ((("guildRep" in _local_5) && (_local_5.guildRep > 0)))
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + "<font color='#FFFFFF'>, </font>");
                }
                _local_4 = (_local_4 + (("<font color='#FFFFFF'>" + _local_5.guildRep) + "</font>"));
                _local_4 = (_local_4 + "<font color='#00CCFF'>guild rep</font>");
            }
            _local_3.cnt.rewards.tRewards.htmlText = _local_4;
            _local_3.fWidth = 240;
            _local_3.fHeight = 70;
            _local_6 = (_local_3.cnt.rewards.tRewards.x + _local_3.cnt.rewards.tRewards.textWidth);
            _local_3.cnt.rewards.x = Math.round(((_local_3.fWidth / 2) - (_local_6 / 2)));
            _local_3.fX = (_local_3.x = -(_local_3.fWidth / 2));
            _local_3.fY = (_local_3.y = -(_local_3.fHeight + 8));
            mixer.playSound("Good");
            cleanDropStack();
        }

        public function toggleCharpanel(_arg_1:String=""):void
        {
            var _local_2:MovieClip;
            _local_2 = ui.mcPopup;
            if (!isGreedyModalInStack())
            {
                if (_local_2.currentLabel != "Charpanel")
                {
                    clearPopups();
                    clearPopupsQ();
                    _local_2.fData = {"typ":_arg_1};
                    _local_2.visible = true;
                    _local_2.gotoAndPlay("Charpanel");
                }
                else
                {
                    _local_2.mcCharpanel.fClose();
                }
            }
        }

        /** Keep the persistent users_stats row on the local avatar and open panel. */
        private function syncAeraStatPointData(points:*, allocatedStats:Object=null, clearPending:Boolean=false):void
        {
            var data:Object;
            var statsData:Object;
            var key:String;
            var keys:Array = ["Strength", "Intellect", "Dexterity", "Endurance", "Wisdom", "Luck"];

            if (((world == null) || (world.myAvatar == null) || (world.myAvatar.objData == null)))
            {
                return;
            }

            data = world.myAvatar.objData;
            if (((!("stats" in data)) || (data.stats == null)))
            {
                data.stats = {};
            }
            statsData = data.stats;

            if (points != null)
            {
                statsData.StatPoints = Math.max(0, int(points));
            }
            else if (statsData.StatPoints == null)
            {
                statsData.StatPoints = 0;
            }

            if (allocatedStats != null)
            {
                for each (key in keys)
                {
                    if ((key in allocatedStats) && (allocatedStats[key] != null))
                    {
                        statsData[key] = Math.max(0, int(allocatedStats[key]));
                    }
                    else if (statsData[key] == null)
                    {
                        statsData[key] = 0;
                    }
                }
            }

            if (((mcStatsPanel != null) && ("syncStatPointData" in mcStatsPanel)))
            {
                try
                {
                    mcStatsPanel.syncStatPointData(statsData.StatPoints, allocatedStats, clearPending);
                }
                catch(e:Error)
                {
                    trace("Aera stats panel sync error: " + e.message);
                }
            }
        }

        /** Fallback for older level-up packets that only send the +3 award. */
        private function addAeraStatPoints(amount:int):void
        {
            var current:int = 0;
            if (((world != null) && (world.myAvatar != null) && (world.myAvatar.objData != null)))
            {
                if ((("stats" in world.myAvatar.objData) && (world.myAvatar.objData.stats != null) && (world.myAvatar.objData.stats.StatPoints != null)))
                {
                    current = int(world.myAvatar.objData.stats.StatPoints);
                }
            }
            syncAeraStatPointData((current + Math.max(0, amount)), null, false);
        }

        private function aeraStatResponseSucceeded(resObj:Object):Boolean
        {
            if (resObj == null)
            {
                return false;
            }
            if (resObj.bitSuccess === true)
            {
                return true;
            }
            return (String(resObj.bitSuccess) == "1");
        }

        public function toggleStatspanel(_arg_1:String=""):void
        {
            if (ui.getChildByName("mcStatsPanel"))
            {
                mcStatsPanel.cleanup();
                mcStatsPanel = null;
                return;
            }
            mcStatsPanel = new statsPanel(this);
            ui.addChild(mcStatsPanel);
            mcStatsPanel.name = "mcStatsPanel";
            mcStatsPanel.x = 474;
            mcStatsPanel.y = 240;
        }

        public function toggleTradePanel(_arg1:String=""):void{
            var _local2:MovieClip;
            _local2 = ui.mcPopup;
            if (!isGreedyModalInStack()){
                if (_local2.currentLabel != "Trade"){
                    clearPopups();
                    clearPopupsQ();
                    (_local2.tradeId = _arg1);
                    (_local2.visible = true);
                    _local2.gotoAndPlay("Trade");
                }
                else {
                    _local2.onClose();
                }
            }
        }

        public function toggleAuctionPanel(_arg1:String=""):void{
            var mc:MovieClip;
            mc = ui.mcPopup;
            if (!isGreedyModalInStack()){
                if (mc.currentLabel != "Auction"){
                    clearPopups();
                    clearPopupsQ();
                    (mc.fData = {typ:_arg1});
                    (mc.visible = true);
                    mc.gotoAndPlay("Auction");
                }
                else {
                    mc.onClose();
                }
            }
        }

        public function toggleRedeemCode():void
        {
            var _local_2:MovieClip;
            _local_2 = ui.mcPopup;
            if (!isGreedyModalInStack())
            {
                if (_local_2.currentLabel != "RedeemCode")
                {
                    clearPopups();
                    clearPopupsQ();
                    _local_2.visible = true;
                    _local_2.gotoAndPlay("RedeemCode");
                }
                else
                {
                    _local_2.onClose();
                }
            }
        }

        public function toggleWheel():void
        {
            var _local_2:MovieClip;
            _local_2 = ui.mcPopup;
            if (!isGreedyModalInStack())
            {
                if (_local_2.currentLabel != "Wheel")
                {
                    clearPopups();
                    clearPopupsQ();
                    _local_2.visible = true;
                    _local_2.gotoAndPlay("Wheel");
                }
                else
                {
                    _local_2.onClose();
                }
            }
        }

        public function toggleTitles():void
        {
            var _local_2:MovieClip;
            _local_2 = ui.mcPopup;
            if (!isGreedyModalInStack())
            {
                if (_local_2.currentLabel != "Titles")
                {
                    clearPopups();
                    clearPopupsQ();
                    _local_2.visible = true;
                    _local_2.gotoAndPlay("Titles");
                }
                else
                {
                    _local_2.onClose();
                }
            }
        }

        public function toggleOutfits(_arg_1:String=""):void
        {
            if (world.myAvatar.dataLeaf.intState != 1)
            {
                return;
            }
            if (world.bPvP)
            {
                return;
            }
            requestInterface(params.sLoadout, "outfitSets");
        }

        public function showFriendshipUI(_arg_1:String=""):void
        {
            if (!world.coolDown("friendshipStats"))
            {
                return;
            }
            requestInterface("friendship/friendship_ui.swf", "friendship_ui");
        }

        public function togglePVPPanel(_arg_1:String=""):void
        {
            var _local_2:MovieClip;
            _local_2 = ui.mcPopup;
            if (!isGreedyModalInStack())
            {
                if (_local_2.currentLabel != "PVPPanel")
                {
                    clearPopups();
                    clearPopupsQ();
                    _local_2.fData = {"typ":_arg_1};
                    _local_2.visible = true;
                    _local_2.gotoAndPlay("PVPPanel");
                }
                else
                {
                    _local_2.onClose();
                }
            }
        }

        public function showPVPScore():void
        {
            var bar:MovieClip;
            var i:int;
            var o:Object;
            var a:Array;
            var bx:int;
            ui.mcPVPScore.visible = true;
            ui.mcPVPScore.y = 2;
            i = 0;
            a = [{"sName":"Team A"}, {"sName":"Team B"}];
            bx = 200;
            if (world.PVPFactions.length > 0)
            {
                a = world.PVPFactions;
            }
            i = 0;
            while (i < a.length)
            {
                o = a[i];
                try
                {
                    bar = ui.mcPVPScore.getChildByName(("bar" + i));
                    bar.tTeam.text = o.sName;
                    if ((((bar.tTeam.x + bar.tTeam.width) - bar.tTeam.textWidth) - 6) < bx)
                    {
                        bx = Math.round((((bar.tTeam.x + bar.tTeam.width) - bar.tTeam.textWidth) - 6));
                    }
                }
                catch(e:Error)
                {
                }
                i = (i + 1);
            }
            i = 0;
            while (i < a.length)
            {
                o = a[i];
                try
                {
                    bar = ui.mcPVPScore.getChildByName(("bar" + i));
                    bar.cap.x = bx;
                }
                catch(e:Error)
                {
                }
                i = (i + 1);
            }
        }

        public function hidePVPScore():void
        {
            ui.mcPVPScore.visible = false;
            ui.mcPVPScore.y = -300;
        }

        public function showMCPVPQueue():void
        {
            var _local_1:Object;
            _local_1 = world.getWarzoneByWarzoneName(world.PVPQueue.warzone);
            ui.mcPVPQueue.t1.text = _local_1.nam;
            ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME, MCPVPQueueEF);
            ui.mcPVPQueue.t2label.visible = false;
            ui.mcPVPQueue.t2.visible = false;
            if (world.PVPQueue.avgWait > -1)
            {
                ui.mcPVPQueue.t2label.visible = true;
                ui.mcPVPQueue.t2.visible = true;
                ui.mcPVPQueue.addEventListener(Event.ENTER_FRAME, MCPVPQueueEF, false, 0, true);
            }
            ui.mcPVPQueue.visible = true;
            ui.mcPVPQueue.y = 84;
        }

        public function hideMCPVPQueue():void
        {
            ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME, MCPVPQueueEF);
            ui.mcPVPQueue.visible = false;
            ui.mcPVPQueue.y = -300;
        }

        public function onMCPVPQueueClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            _local_2 = {};
            try
            {
                _local_2.strUsername = world.myAvatar.objData.strUsername;
                ui.cMenu.fOpenWith("pvpqueue", _local_2);
            }
            catch(e:Error)
            {
            }
        }

        public function MCPVPQueueEF(_arg_1:Event):void
        {
            var _local_2:Number;
            var _local_3:*;
            _local_2 = new Date().getTime();
            _local_3 = Math.ceil(((((world.PVPQueue.avgWait * 1000) - (_local_2 - world.PVPQueue.ts)) / 1000) / 60));
            ui.mcPVPQueue.t2.htmlText = (('<font color="#FFFFFF"' + _local_3) + '</font><font color="#999999"m</font>');
            if (_local_3 <= 1)
            {
                ui.mcPVPQueue.t2.htmlText = ("<" + ui.mcPVPQueue.t2.htmlText);
            }
        }

        public function updatePVPScore(_arg_1:Array):void
        {
            var _local_2:Object;
            var _local_3:MovieClip;
            var _local_4:int;
            var _local_5:int;
            _local_2 = {};
            _local_4 = 0;
            while (_local_4 < _arg_1.length)
            {
                _local_2 = _arg_1[_local_4];
                _local_3 = (ui.mcPVPScore.getChildByName(("bar" + _local_4)) as MovieClip);
                if (_local_3 != null)
                {
                    _local_3.ti.text = (_local_2.v + "/1000");
                    _local_5 = int(int(((_local_2.v / 1000) * _local_3.bar.width)));
                    _local_5 = Math.max(Math.min(_local_5, _local_3.bar.width), 0);
                    _local_3.bar.x = (-(_local_3.bar.width) + _local_5);
                }
                _local_4++;
            }
        }

        public function relayPVPEvent(_arg_1:Object):void
        {
            if (_arg_1.typ == "kill")
            {
                if (_arg_1.team == world.myAvatar.dataLeaf.pvpTeam)
                {
                    if (_arg_1.val == "Restorer")
                    {
                        addUpdate(getPVPMessage(_arg_1.val, true));
                    }
                    if (_arg_1.val == "Brawler")
                    {
                        addUpdate(getPVPMessage(_arg_1.val, true));
                    }
                    if (_arg_1.val == "Captain")
                    {
                        addUpdate(getPVPMessage(_arg_1.val, true));
                    }
                    if (_arg_1.val == "General")
                    {
                        addUpdate("Victory! The enemy general has been defeated!");
                    }
                    if (_arg_1.val == "Knight")
                    {
                        addUpdate("A knight of the enemy has fallen! Victory draws closer!");
                    }
                }
                else
                {
                    if (_arg_1.val == "Restorer")
                    {
                        addUpdate(getPVPMessage(_arg_1.val, false), true);
                    }
                    if (_arg_1.val == "Brawler")
                    {
                        addUpdate(getPVPMessage(_arg_1.val, false), true);
                    }
                    if (_arg_1.val == "Captain")
                    {
                        addUpdate(getPVPMessage(_arg_1.val, false), true);
                    }
                    if (_arg_1.val == "General")
                    {
                        addUpdate("Oh no!  Our general has been defeated!", true);
                    }
                    if (_arg_1.val == "Knight")
                    {
                        addUpdate("A knight has fallen to the enemy!");
                    }
                }
            }
        }

        private function getPVPMessage(_arg_1:String, _arg_2:Boolean):String
        {
            switch (_arg_1)
            {
                case "Restorer":
                    if (_arg_2)
                    {
                        return ((world.strMapName == "dagepvp") ? "An enemy Blade Master has been defeated! Dage's healing powers are waning!" : "An enemy Restorer has been defeated! The Captain's healing powers are waning!");
                    }
                    else
                    {
                        return ((world.strMapName == "dagepvp") ? "A Blade Master has been defeated!\t Dage's healing powers are waning!" : "A Restorer has been defeated!\t Our Captain's healing powers are waning!");
                    }
                case "Brawler":
                    if (_arg_2)
                    {
                        return ((world.strMapName == "dagepvp") ? "An enemy Legion Guard has been defeated!  Dage's attacks grow weaker!" : "An enemy Brawler has been defeated!  The Captain's attacks grow weaker!");
                    }
                    else
                    {
                        return ((world.strMapName == "dagepvp") ? "A Legion Guard has been defeated!\tRally to Dage's defense!" : "A Brawler has been defeated!\tRally to the Captain's defense!");
                    }
                case "Captain":
                    if (_arg_2)
                    {
                        return ((world.strMapName == "dagepvp") ? "Dage has been defeated!" : "The enemy captain has been defeated!");
                    }
                    else
                    {
                        return ((world.strMapName == "dagepvp") ? "Dage has been fallen to the enemy!" : "Our Captain has been fallen to the enemy!");
                    }
            }
            return ("");
        }

        public function mcSetColor(_arg_1:MovieClip, _arg_2:String, _arg_3:String):*
        {
            var _local_4:MovieClip;
            var _local_6:String;
            if (currentLabel == "Select")
            {
                mcCharSelect.mcSetColor(_arg_1, _arg_2, _arg_3);
                return;
            }
            _local_4 = _arg_1;
            var _local_5:Boolean;
            _local_6 = "none";
            while ((((!(_local_4 == null)) && (!(_local_4.parent == null))) && (!(_local_4.parent == _local_4.stage))))
            {
                if (("pAV" in _local_4))
                {
                    if (_local_4.name.indexOf("previewMC") > -1)
                    {
                        _local_6 = "e";
                    }
                    else
                    {
                        if (_local_4.name.indexOf("Dummy") > -1)
                        {
                            _local_6 = "d";
                        }
                        else
                        {
                            if (_local_4.name.indexOf("mcPortraitTarget") > -1)
                            {
                                _local_6 = "c";
                            }
                            else
                            {
                                if (_local_4.name.indexOf("mcPortrait") > -1)
                                {
                                    _local_6 = "b";
                                }
                                else
                                {
                                    _local_6 = "a";
                                }
                            }
                        }
                    }
                    break;
                }
                _local_4 = MovieClip(_local_4.parent);
            }
            if (_local_6 != "none")
            {
                _local_4.pAV.pMC.setColor(_arg_1, _local_6, _arg_2, _arg_3);
            }
        }

        public function registerAttackFrame(_arg_1:MovieClip):*
        {
            var _local_2:MovieClip;
            _local_2 = _arg_1;
            while ((((!(_local_2 == null)) && (!(_local_2.parent == null))) && (!(_local_2.parent == _local_2.stage))))
            {
                if (("pAV" in _local_2)) break;
                _local_2 = MovieClip(_local_2.parent);
            }
            if (("pAV" in _local_2))
            {
                if (!("attackFrames" in _local_2.pAV.pMC))
                {
                    return;
                }
                if (((_local_2.pAV.pMC.attackFrames) && (!(_local_2.pAV.pMC.attackFrames.indexOf(_arg_1) == -1))))
                {
                    _local_2.pAV.pMC.attackFrames.splice(_local_2.pAV.pMC.attackFrames.indexOf(_arg_1), 1);
                }
                _local_2.pAV.pMC.attackFrames.push(_arg_1);
            }
        }

        public function areaListClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            _local_2 = MovieClip(_arg_1.currentTarget.parent.parent);
            switch (_local_2.currentLabel)
            {
                case "init":
                    _local_2.gotoAndPlay("in");
                    return;
                case "hold":
                    _local_2.gotoAndPlay("out");
                    return;
            }
        }

        public function updateAreaName():void
        {
            var _local_1:String;
            _local_1 = (String(world.areaUsers.length) + " player");
            if (world.areaUsers.length > 1)
            {
                _local_1 = (_local_1 + "(s)");
            }
            _local_1 = (_local_1 + " in <font color ='#FFFF00'>");
            if (world.strAreaName.indexOf(":") > -1)
            {
                _local_1 = (_local_1 + (world.strAreaName.split(":")[0] + " (party)"));
            }
            else
            {
                _local_1 = (_local_1 + world.strAreaName);
            }
            _local_1 = (_local_1 + "</font>");
            ui.mcInterface.areaList.title.t1.htmlText = _local_1;
        }

        public function areaListGet():void
        {
            var _local_1:Object;
            var _local_2:Object;
            var _local_3:String;
            var _local_4:*;
            _local_1 = {};
            _local_2 = sfc.getRoom(world.curRoom).getUserList();
            for (_local_3 in _local_2)
            {
                _local_4 = world.uoTree[_local_2[_local_3].getName()];
                if (_local_4 != null)
                {
                    _local_1[_local_3] = {
                        "strUsername":_local_4.strUsername,
                        "intLevel":_local_4.intLevel
                    };
                }
            }
            areaListShow(_local_1);
        }

        public function areaListNameClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            var _local_3:*;
            _local_2 = MovieClip(_arg_1.currentTarget);
            _local_3 = {};
            _local_3.ID = _local_2.objData.ID;
            _local_3.strUsername = _local_2.objData.strUsername;
            if (_local_2.objData.strUsername == world.myAvatar.objData.strUsername)
            {
                ui.cMenu.fOpenWith("self", _local_3);
            }
            else
            {
                ui.cMenu.fOpenWith("user", _local_3);
            }
        }

        public function areaListShow(_arg_1:Object):void
        {
            var _local_2:MovieClip;
            var _local_3:int;
            var _local_4:String;
            var _local_5:*;
            _local_2 = ui.mcInterface.areaList;
            if (_local_2.currentLabel == "hold")
            {
                while (_local_2.cnt.numChildren > 0)
                {
                    _local_2.cnt.removeChildAt(0);
                }
            }
            _local_3 = 0;
            for (_local_4 in _arg_1)
            {
                _local_5 = _local_2.cnt.addChild(new aProto());
                _local_5.objData = _arg_1[_local_4];
                _local_5.txtName.text = _arg_1[_local_4].strUsername;
                _local_5.txtLevel.text = _arg_1[_local_4].intLevel;
                _local_5.addEventListener(MouseEvent.CLICK, areaListNameClick, false, 0, true);
                _local_5.buttonMode = true;
                _local_5.y = -(int((_local_3 * 14)));
                _local_3++;
            }
            _local_2.cnt.iproto.visible = (_local_2.currentLabel == "hold");
            _local_2.visible = true;
        }

        public function showFBShare(o:Object):void
        {
            var fbTab:FacebookTabMC;
            var mc:MovieClip = MovieClip(o.parent);
            var FBShareTabClass:Class = (getDefinitionByName("FacebookTabMC") as Class);
            if (((uoPref.bFBShare) && (o.isActive)))
            {
                try
                {
                    fbTab = (o.parent.getChildByName("fbTab") as FacebookTabMC);
                }
                catch(error:Error)
                {
                }
                if (fbTab == null)
                {
                    fbTab = new (FBShareTabClass)();
                    fbTab.name = "fbTab";
                    fbTab.filters = [new GlowFilter(12892822, 1, 10, 10, 2, 2, false, false)];
                    o.parent.addChild(fbTab);
                }
                fbTab.init(o);
                fbTab.visible = true;
                if (("position" in o))
                {
                    fbTab.positionBy(o);
                }
            }
            else
            {
                try
                {
                    o.parent.getChildByName("fbTab").visible = false;
                }
                catch(error:Error)
                {
                }
            }
        }

        public function closeFBC():void
        {
            if (fbc != null)
            {
                fbc.fClose();
            }
        }

        public function getAppName():String
        {
            return (Game.FB_APP_NAME);
        }

        public function getAppID():String
        {
            return (Game.FB_APP_ID);
        }

        public function getAppSec():String
        {
            return (Game.FB_APP_SEC);
        }

        public function getAppURL():String
        {
            return (Game.FB_APP_URL);
        }

        public function getUserName():String
        {
            if (((((!(world == null)) && (!(world.myAvatar == null))) && (!(world.myAvatar.objData == null))) && ("strUserName" in world.myAvatar.objData)))
            {
                return (world.myAvatar.objData.strUserName);
            }
            return ("");
        }

        public function toggleFaction():void
        {
            if (ui.mcPopup.currentLabel != "Faction")
            {
                ui.mcPopup.fOpen("Faction");
            }
            else
            {
                if (("cnt" in MovieClip(ui.mcPopup)))
                {
                    MovieClip(MovieClip(ui.mcPopup).cnt).xClick();
                }
            }
        }

        public function hideInterface():void
        {
            ui.visible = false;
        }

        public function showInterface():void
        {
            ui.visible = true;
        }

        public function loadExternalSWF(_arg_1:String):void
        {
            if (((_arg_1.indexOf("https://") == -1) || (_arg_1.indexOf("https://") == -1)))
            {
                if (((_arg_1.length > 1) && (_arg_1.charAt(0) == "/")))
                {
                    _arg_1 = _arg_1.substr(1, (_arg_1.length - 1));
                }
                _arg_1 = ("maps/" + _arg_1);
            }
            ldrMC.loadFile(mcExtSWF, _arg_1, "Game Files");
            hideInterface();
            world.visible = false;
        }

        public function clearExternamSWF():void
        {
            while (mcExtSWF.numChildren > 0)
            {
                mcExtSWF.removeChildAt(0);
            }
            world.visible = true;
            showInterface();
        }

        public function openCharacterCustomize():void
        {
            ui.mcPopup.fOpen("Customize");
        }

        public function openArmorCustomize():void
        {
            ui.mcPopup.fOpen("ArmorColor");
        }

        public function showFactionInterface():void
        {
            ui.mcPopup.fOpen("Faction");
        }

        public function showConfirmtaionBox(sMsg:String, fHandler:Function):void
        {
            var modal:* = undefined;
            var modalO:* = undefined;
            modal = new ModalMC();
            modalO = {};
            modalO.strBody = sMsg;
            modalO.btns = "dual";
            modalO.params = {};
            modalO.callback = function (_arg_1:Object):*
            {
                fHandler(_arg_1.accept);
            };
            ui.ModalStack.addChild(modal);
            modal.init(modalO);
        }

        public function showMessageBox(sMsg:String, fHandler:Function=null):void
        {
            var modal:* = undefined;
            var modalO:* = undefined;
            modal = new ModalMC();
            modalO = {};
            modalO.strBody = sMsg;
            modalO.btns = "mono";
            modalO.params = {};
            modalO.callback = function (_arg_1:Object):*
            {
                if (fHandler != null)
                {
                    fHandler();
                }
            };
            ui.ModalStack.addChild(modal);
            modal.init(modalO);
        }

        public function getServerTime():Date
        {
            var _local_1:Date;
            var _local_2:*;
            _local_1 = new Date();
            _local_2 = (ts_login_server + (_local_1.getTime() - ts_login_client));
            return (new Date(_local_2));
        }

        public function get date_server():Date
        {
            return (getServerTime());
        }

        public function showTracking(_arg_1:String):void
        {
            var _local_2:*;
            try
            {
                _local_2 = ((objLogin.userid != null) ? objLogin.userid : 0);
                extCall.logQuestProgress(_local_2, _arg_1);
            }
            catch(e)
            {
            }
        }

        public function removeApop():void
        {
            if (apop == null)
            {
                return;
            }
            apop_ = null;
            world.removeMovieFront();
        }

        public function createApop():void
        {
            if (apop_ != null)
            {
                removeApop();
            }
            apop_ = new apopCore((this as MovieClip), apopTree[curID]);
            apop_.x = 270;
            apop_.y = 20;
            world.FG.addChild(apop_);
            world.FG.mouseChildren = true;
        }

        public function rand(_arg_1:Number=0, _arg_2:Number=1):Number
        {
            return (rn.rand(_arg_1, _arg_2));
        }

        public function mcHeadMale() : mcHeadM
        {
            return (new mcHeadM());
        }

        public function mcHeadFemale() : mcHeadF
        {
            return (new mcHeadF());
        }

        public function get TravelMap():Object
        {
            return (travelMapData);
        }

        public function get apop():apopCore
        {
            return (apop_);
        }

        public function get objWorldMap():*
        {
            return (WorldMapData);
        }

        public function getLogin():Object
        {
            return (objLogin);
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame12():*
        {
            init();
            showTracking("2");
        }

        internal function frame13():*
        {
            loadTitle();
            if (showServers)
            {
                if ((((FacebookConnect.isLoggedIn) && (loginInfo.strPassword == null)) && (ISWEB)))
                {
                    extCall.fbLogin();
                }
                else
                {
                    login(loginInfo.strUsername, loginInfo.strPassword);
                }
                showServers = false;
            }
            else
            {
                if (csShowServers)
                {
                    mcLogin.gotoAndPlay("Servers");
                    csShowServers = false;
                }
            }
            stop();
        }

        internal function frame22():*
        {
            initInterface();
            initWorld();
            stop();
        }

        internal function frame32():*
        {
            if (params.vars != null)
            {
                loadAccountCreation(("newuser/" + params.vars.sCharCreate));
            }
            else
            {
                loadAccountCreation("newuser/AQW-Landing-MERGETEST.swf");
            }
            stop();
        }

        internal function frame43():*
        {
            init();
            if (mcCharSelect)
            {
                mcCharSelect = null;
            }
            loader = new mcLoader();
            loader.x = 400;
            loader.y = 211;
            this.addChild(loader);

            onLoadMaster(onCSComplete, assetsContext, params.sCharSelect + "?v=" + params.vars.sVersion, onCSProgress, onCSError);

            csbLoaded = 0;
            csbTotal = 0;
            stop();
        }

    }
}//package 

