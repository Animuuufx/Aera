// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//World

package 
{
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.display.BitmapData;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.utils.getDefinitionByName;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import flash.utils.getQualifiedClassName;
    import flash.geom.Matrix;
    import flash.media.Sound;
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;

    public class World extends MovieClip 
    {

        public static var currentInstance:World;

        private const TICK_MAX:* = 24;

        public var uiLock:Boolean = false;
        public var objSession:Object = {};
        public var objResponse:Object = {};
        public var objQuestString:*;
        public var objInfo:Object = {};
        internal var FEATURE_COLLISION:Boolean = true;
        internal var CELL_MODE:String = "normal";
        public var SCALE:Number = 1;
        public var WALKSPEED:Number = 8;
        public var bitWalk:Boolean = false;
        internal var lastWalk:Date = new Date();
        public var strAreaName:String;
        public var strMapName:String;
        public var strMapFileName:String;
        public var intType:int;
        public var intKillCount:int;
        public var objLock:*;
        public var objExtra:*;
        public var objHouseData:*;
        public var objGuildData:*;
        public var returnInfo:Object;
        public var strFrame:String = "";
        public var strPad:String = "";
        public var spawnPoint:Object = {};
        public var FG:MovieClip;
        public var CHARS:MovieClip;
        public var TRASH:MovieClip;
        public var map:MovieClip;
        public var mapBoundsMC:MovieClip = null;
        public var zSortArr:Array = [];
        internal var preLMC:*;
        internal var zManager:MovieClip;
        public var EFAO:Object = {
            "zc":0,
            "zn":1,
            "xpc":0,
            "xpn":50,
            "xpb":false
        };
        public var arrEvent:Array;
        public var arrEventR:Array;
        public var arrSolid:Array;
        public var arrSolidR:Array;
        public var avatars:Object = {};
        public var myAvatar:Avatar;
        public var mondef:Array;
        public var monswf:Array;
        public var monmap:Array;
        public var monsters:Array = [];

        // Database-driven NPC protocol data. The PHP emulator sends these with
        // moveToArea; the renderer materializes only entries for the active frame.
        public var npcBranch:Array = [];
        public var npcdef:Array = [];
        public var npcmap:Array = [];
        public var npcAvatars:Object = {};

        // Optional image-backed NPC visuals. The normal Avatar/AvatarMC wrapper is
        // preserved so name/job text, E interaction, clicks, popup buttons, quests,
        // shops, and all existing database NPC behavior continue to use Aera's
        // current client code. Only mcChar is hidden after the image loads.
        private var databaseNPCImageContexts:Dictionary = new Dictionary(true);
        private var databaseNPCImageOwners:Dictionary = new Dictionary(true);
        // Database-driven map transition arrows sent with moveToArea.
        public var mapArrows:Array = [];
        private var databaseMapArrowActors:Array = [];
        private var legacyMapArrowSweepFrames:int = 0;
        private var legacyMapArrowSweepActive:Boolean = false;
        public var combatAnims:Array = ["Attack1", "Attack2", "Attack3", "Attack4", "Hit", "Knockout", "Getup", "Stab", "Thrash", "Castgood", "Cast1", "Cast2", "Cast3", "Sword/ShieldFight", "Sword/ShieldAttack1", "Sword/ShieldAttack2", "ShieldBlock", "DuelWield/DaggerFight", "DuelWield/DaggerAttack1", "DuelWield/DaggerAttack2", "FistweaponFight", "FistweaponAttack1", "FistweaponAttack2", "PolearmFight", "PolearmAttack1", "PolearmAttack2", "RangedFight", "RangedAttack1", "UnarmedFight", "UnarmedAttack1", "UnarmedAttack2", "KickAttack", "FlipAttack", "Dodge"];
        public var staticAnims:Array = ["Fall", "Knockout", "Die"];
        public var bankController:BankController;
        public var shopinfo:Object;
        public var shopBuyItem:Object;
        public var enhShopID:int = -1;
        public var enhShopItems:Array;
        public var enhItem:Object;
        public var hairshopinfo:Object;
        public var mapEvents:Object;
        public var adData:Object;
        public var cellMap:Object;
        private var tbmd:BitmapData;
        public var scrollData:Object;
        public var tradeinfo:Object;
        public var auctioninfo:Object;
        public var retrieveinfo:Object;
        public var SCROLL:Boolean = false;

        public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        public var loaderC:LoaderContext = new LoaderContext(false, loaderD);

        public var loaderContents:* = [];
        public var loaderContentsFileNames:* = [];
        public var loaderQueue:Array = [];
        public var playerDomains:Object = {};
        public var loaderManager:Object = {
            "i0":{
                "n":"i0",
                "loaderData":null,
                "timer":new Timer(5000, 1),
                "ldr":new URLLoader(),
                "free":true,
                "url":""
            },
            "i1":{
                "n":"i1",
                "loaderData":null,
                "timer":new Timer(5000, 1),
                "ldr":new URLLoader(),
                "free":true,
                "url":""
            },
            "i2":{
                "n":"i2",
                "loaderData":null,
                "timer":new Timer(5000, 1),
                "ldr":new URLLoader(),
                "free":true,
                "url":""
            },
            "i3":{
                "n":"i3",
                "loaderData":null,
                "timer":new Timer(5000, 1),
                "ldr":new URLLoader(),
                "free":true,
                "url":""
            },
            "i4":{
                "n":"i4",
                "loaderData":null,
                "timer":new Timer(5000, 1),
                "ldr":new URLLoader(),
                "free":true,
                "url":""
            },
            "i5":{
                "n":"i5",
                "loaderData":null,
                "timer":new Timer(5000, 1),
                "ldr":new URLLoader(),
                "free":true,
                "url":""
            }
        };
        public var mapLoadInProgress:Boolean = false;
        private var mapW:int = 960;
        private var mapH:int = 550;
        private var mapNW:int = mapW;
        private var mapNH:int = mapH;
        private var mapBmps:Array = [];
        private var mapTimer:Timer = new Timer(2000);
        public var actions:Object = {active:[], passive:[]};
        internal var restTimer:Timer = new Timer(2000, 1);
        internal var AATestTimer:Timer = new Timer(700, 1);
        internal var connTestTimer:Timer = new Timer(5000, 1);
        internal var autoActionTimer:Timer = new Timer(2000, 1);
        internal var mvTimer:Timer = new Timer(500, 1);
        internal var mvTimerObj:Object;

        // Smooth held-key movement state. WASD uses a long look-ahead target
        // instead of repeatedly restarting AvatarMC.walkTo every few frames.
        private var keyboardMoveActive:Boolean = false;
        private var keyboardMoveDX:Number = 0;
        private var keyboardMoveDY:Number = 0;
        private var keyboardMoveLastRetarget:Number = 0;
        private const KEYBOARD_LOOKAHEAD:Number = 560;
        private const KEYBOARD_RETARGET_DISTANCE:Number = 150;
        private const KEYBOARD_RETARGET_DELAY:Number = 90;
        internal var actionTimer:Timer;
        internal var actionMap:Array = [];
        internal var autoAction:Object;
        internal var actionReady:Boolean = false;
        internal var actionResults:Array = [];
        internal var actionResultsAura:Array = [];
        internal var actionResultsMon:Array = [];
        internal var actionID:Number = 0;
        internal var actionIDLimit:Number = 30;
        internal var actionDamage:*;
        internal var actionRangeSpamTS:Number = 0;
        internal var minLatencyOneWay:* = 20;
        internal var TcpAckDel:* = 170;
        internal var connMsgOut:* = false;
        public var mData:mapData;
        public var cHandle:cutsceneHandler;
        public var sController:soundController;
        public var chaosNames:Array = [];
        public var hideAllCapes:Boolean = false;
        public var hideOtherPets:Boolean = false;
        public var showAnimations:Boolean = true;
        public var showMonsters:Boolean = true;
        public var charMonster:MovieClip;
        public var lock:Object = {
			"wheel":{
                "cd":2500,
                "ts":0
            },
            "updateTitle":{
                "cd":1500,
                "ts":0
            },
            "loadShop":{
                "cd":3000,
                "ts":0
            },
            "loadEnhShop":{
                "cd":3000,
                "ts":0
            },
            "loadHairShop":{
                "cd":3000,
                "ts":0
            },
            "equipItem":{
                "cd":1500,
                "ts":0
            },
            "unequipItem":{
                "cd":1500,
                "ts":0
            },
            "buyItem":{
                "cd":1000,
                "ts":0
            },
            "sellItem":{
                "cd":1000,
                "ts":0
            },
            "getMapItem":{
                "cd":1000,
                "ts":0
            },
            "tryQuestComplete":{
                "cd":1250,
                "ts":0
            },
            "acceptQuest":{
                "cd":1000,
                "ts":0
            },
            "doIA":{
                "cd":1000,
                "ts":0
            },
            "rest":{
                "cd":1900,
                "ts":0
            },
            "who":{
                "cd":3000,
                "ts":0
            },
            "tfer":{
                "cd":3000,
                "ts":0
            },
            "wearItem":{
                "cd":1500,
                "ts":0
            },
            "unwearItem":{
                "cd":1500,
                "ts":0
            },
            "addLoadout":{
                "cd":1500,
                "ts":0
            },
            "removeLoadout":{
                "cd":1500,
                "ts":0
            },
            "wearLoadout":{
                "cd":3000,
                "ts":0
            },
            "equipLoadout":{
                "cd":3000,
                "ts":0
            },
            "friendshipTalk":{
                "cd":1000,
                "ts":0
            },
            "friendshipChoice":{
                "cd":1000,
                "ts":0
            },
            "friendshipInfo":{
                "cd":1500,
                "ts":0
            },
            "friendshipGift":{
                "cd":1500,
                "ts":0
            },
            "friendshipStats":{
                "cd":3000,
                "ts":0
            },
            "dungeonQueue":{
                "cd":5000,
                "ts":0
            },
            "dungeonRejoin":{
                "cd":5000,
                "ts":0
            },
            "dungeonMTC":{
                "cd":1000,
                "ts":0
            }
        };
        public var invTree:Object = {};
        public var uoTree:Object = {};
        public var monTree:Object = {};
        public var waveTree:Object = {};
        public var questTree:Object = {};
        public var enhPatternTree:Object;
        public var enhp:Array = [{
            "ID":1,
            "sName":"Adventurer",
            "sDesc":"none",
            "iSTR":16,
            "iDEX":16,
            "iEND":18,
            "iINT":16,
            "iWIS":16,
            "iLCK":0
        }, {
            "ID":2,
            "sName":"Fighter",
            "sDesc":"M1",
            "iSTR":44,
            "iDEX":13,
            "iEND":43,
            "iINT":0,
            "iWIS":0,
            "iLCK":0
        }, {
            "ID":3,
            "sName":"Thief",
            "sDesc":"M2",
            "iSTR":30,
            "iDEX":45,
            "iEND":25,
            "iINT":0,
            "iWIS":0,
            "iLCK":0
        }, {
            "ID":4,
            "sName":"Armsman",
            "sDesc":"M4",
            "iSTR":38,
            "iDEX":36,
            "iEND":26,
            "iINT":0,
            "iWIS":0,
            "iLCK":0
        }, {
            "ID":5,
            "sName":"Hybrid",
            "sDesc":"M3",
            "iSTR":28,
            "iDEX":20,
            "iEND":25,
            "iINT":27,
            "iWIS":0,
            "iLCK":0
        }, {
            "ID":6,
            "sName":"Wizard",
            "sDesc":"C1",
            "iSTR":0,
            "iDEX":0,
            "iEND":10,
            "iINT":50,
            "iWIS":20,
            "iLCK":20
        }, {
            "ID":7,
            "sName":"Healer",
            "sDesc":"C2",
            "iSTR":0,
            "iDEX":0,
            "iEND":40,
            "iINT":45,
            "iWIS":15,
            "iLCK":0
        }, {
            "ID":8,
            "sName":"Spellbreaker",
            "sDesc":"C3",
            "iSTR":0,
            "iDEX":0,
            "iEND":20,
            "iINT":40,
            "iWIS":30,
            "iLCK":10
        }, {
            "ID":9,
            "sName":"Lucky",
            "sDesc":"S1",
            "iSTR":10,
            "iDEX":10,
            "iEND":10,
            "iINT":10,
            "iWIS":10,
            "iLCK":50
        }, {
            "ID":23,
            "sName":"Depths",
            "sDesc":"S1",
            "iSTR":0,
            "iDEX":0,
            "iEND":0,
            "iINT":50,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 132, 133, 131, 0)
        }, {
            "ID":10,
            "sName":"Forge",
            "sDesc":"Blacksmith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 0xFF, 103, 0, 0)
        }, {
            "ID":11,
            "sName":"Absolution",
            "sDesc":"Smith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 0xFF, 103, 0, 0),
            "DIS":true
        }, {
            "ID":12,
            "sName":"Avarice",
            "sDesc":"Smith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 0xFF, 103, 0, 0),
            "DIS":true
        }, {
            "ID":24,
            "sName":"Vainglory",
            "sDesc":"Smith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 0xFF, 103, 0, 0),
            "DIS":true
        }, {
            "ID":25,
            "sName":"Vim",
            "sDesc":"SmithP2",
            "iSTR":10,
            "iDEX":130,
            "iEND":-90,
            "iINT":0,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 57, 0xFF, 20, 0),
            "DIS":true
        }, {
            "ID":26,
            "sName":"Examen",
            "sDesc":"SmithP2",
            "iSTR":0,
            "iDEX":0,
            "iEND":-90,
            "iINT":10,
            "iWIS":130,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 181, 145, 2, 0),
            "DIS":true
        }, {
            "ID":27,
            "sName":"Pneuma",
            "sDesc":"SmithP2",
            "iSTR":24,
            "iDEX":24,
            "iEND":-90,
            "iINT":118,
            "iWIS":24,
            "iLCK":0,
            "COLOR":new ColorTransform(1, 1, 1, 1, 3, 150, 161, 0),
            "DIS":true
        }, {
            "ID":28,
            "sName":"Anima",
            "sDesc":"SmithP2",
            "iSTR":134,
            "iDEX":24,
            "iEND":-90,
            "iINT":16,
            "iWIS":16,
            "iLCK":0,
            "COLOR":new ColorTransform(1, 1, 1, 1, 254, 34, 0, 0),
            "DIS":true
        }, {
            "ID":29,
            "sName":"Penitence",
            "sDesc":"SmithP2",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 0xFF, 103, 0, 0),
            "DIS":true
        }, {
            "ID":30,
            "sName":"Lament",
            "sDesc":"SmithP2",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1, 1, 1, 1, 0xFF, 103, 0, 0),
            "DIS":true
        }, {
            "ID":32,
            "sName":"Hearty",
            "sDesc":"Grimskull Troll Enhancement",
            "iSTR":-20,
            "iDEX":-20,
            "iEND":150,
            "iINT":-20,
            "iWIS":-20,
            "iLCK":-20,
            "COLOR":new ColorTransform(1, 1, 1, 1, 220, 0, 220, 0),
            "DIS":true
        }];
        public var defaultCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        public var whiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0);
        public var iconCT:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, -50, -50, -50, 0);
        public var rarityCA:Array = [0x666666, 0xFFFFFF, 0x66FF00, 2663679, 0xFF00FF, 0xFFCC00, 0xFF0000];
        public var deathCT:ColorTransform = new ColorTransform(0.7, 0.7, 1, 1, -20, -20, 20, 0);
        public var monCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 30, 0, 0, 0);
        public var avtCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 40, 40, 70, 0);
        public var avtWCT:ColorTransform = new ColorTransform(0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0);
        public var avtMCT:ColorTransform = new ColorTransform(0, 0, 0, 0, 30, 0, 0, 0);
        public var avtPCT:ColorTransform = new ColorTransform(0, 0, 0, 0, 40, 40, 70, 0);
        public var statusPoisonCT:ColorTransform = new ColorTransform(-0.3, -0.3, -0.3, 0, 0, 20, 0, 0);
        public var statusStoneCT:ColorTransform = new ColorTransform(-1.3, -1.3, -1.3, 0, 100, 100, 100, 0);
        public var GCD:int = 1500;
        public var GCDO:int = 1500;
        public var GCDTS:Number = 0;
        public var curRoom:int = 1;
        public var modID:int = -1;
        public var partyID:int = -1;
        public var guildID:int = -1;
        public var bPvP:Boolean = false;
        public var partyMembers:Array = [];
        public var partyOwner:String = "";
        public var areaUsers:Array = [];
        public var showHPBar:Boolean = false;
        public var rootClass:Game;
        public var PVPMaps:Array = [{
            "nam":"It's Us Or Them",
            "desc":"This cozy PvP map is ideal for players new to PvP in AQW.",
            "warzone":"usorthem",
            "label":"usorthem",
            "icon":"tower",
            "hidden":true
        }, {
            "nam":"Bludrut Brawl!",
            "desc":"A larger map requiring communication, coordination, and a whole lot of DPS.",
            "warzone":"bludrutbrawl",
            "label":"bludrutbrawl",
            "icon":"swords",
            "hidden":false
        }, {
            "nam":"Chaos Brawl!",
            "desc":"A larger map requiring communication, coordination, and a whole lot of DPS.",
            "warzone":"chaosbrawl",
            "label":"chaosbrawl",
            "icon":"swords",
            "hidden":false
        }, {
            "nam":"Frost Brawl!",
            "desc":"A larger map requiring communication, coordination, and a whole lot of DPS.",
            "warzone":"frostbrawl",
            "label":"frostbrawl",
            "icon":"swords",
            "hidden":false
        }, {
            "nam":"Darkovia Brawl!",
            "desc":"Join in the ancient war between werewolves and vampires!",
            "warzone":"darkoviapvp",
            "label":"darkoviapvp",
            "icon":"swords",
            "hidden":true
        }, {
            "nam":"Dage PVP!",
            "desc":"Needs Description!",
            "warzone":"dagepvp",
            "label":"dagepvp",
            "icon":"swords",
            "hidden":true
        }, {
            "nam":"Dage 1V1!",
            "desc":"Needs Description!",
            "warzone":"dage1v1",
            "label":"dage1v1",
            "icon":"swords",
            "hidden":true
        }, {
            "nam":"Doomwood Arena",
            "desc":"This arena is for one on one duels.",
            "warzone":"doomarena",
            "label":"doomarena",
            "icon":"swords",
            "hidden":true
        }];
        public var PVPQueue:Object = {
            "warzone":"",
            "ts":-1,
            "avgWait":-1
        };
        public var PVPResults:Object = {
            "pvpScore":[],
            "team":0
        };
        public var PVPFactions:Array = [];
        public var bookData:Object;
        public var lockdownPots:Boolean = false;
        private var speed:Number;
        private var clickPts:int = 0;
        private var mva:Array = [new Date().getTime()];
        private var justRan:Boolean;
        // Aera v30.75: one dash always costs exactly half of the 100 stamina bar.
        // Keep this as a client constant instead of trusting class stat metadata ($dsh),
        // because many existing class stat packets still carry the legacy value 100.
        private static const DASH_STAMINA_COST:int = 50;
        public var CarolingMonsterKillCount:Number = 0;
        public var CarolingPad:String;
        public var TrickOrTreatMonsterDead:Boolean = false;
        public var TrickOrTreatPad:String;
        private var player_npc_pos:Point;
        public var hasModified:Boolean = false;
        public var frameCopy:Array;
        private var houseFrame:String = "";
        private var imbalancedHouseCells:Array = [];
        private var houseJson:Object;
        private var finishedCells:Array;
        private var convertTimer:Timer;
        private var activeCell:String;
        public var arrHouseItemQueue:* = [];
        private var ticksum:Number = 0;
        private var ticklist:* = [];
        private var bfps:Boolean = false;
        private var fpsTS:Number = 0;
        private var fpsQualityCounter:int = 0;
        private var fpsArrayQuality:Array = [];
        internal var arrQuality:Array = ["LOW", "MEDIUM", "HIGH"];
        private var combatDisplayTime:uint;

        public function World(main:Game)
        {
            loaderC.checkPolicyFile = false;
            loaderC.allowCodeImport = true;
            rootClass = main;
            currentInstance = this;
            auctioninfo = {
                items: [],
                hasRequested: {}
            };
            retrieveinfo = {
                items: [],
                hasRequested: {}
            };
            tradeinfo = {
                itemsA: [],
                itemsB: [],
                hasRequested: {}
            };
            bankController = new BankController();
            map = new MovieClip();
            this.addChild(map);
            CHARS = new MovieClip();
            var _local_2:DisplayObject = this.addChild(CHARS);
            CHARS.mouseEnabled = false;
            _local_2.x = 0;
            _local_2.y = 0;
            rootClass.ui.monsterIcon.redX.visible = false;
            TRASH = new MovieClip();
            this.addChild(TRASH);
            TRASH.mouseEnabled = false;
            TRASH.visible = false;
            TRASH.y = -1000;
            zManager = new MovieClip();
            this.addChild(zManager);
            FG = new MovieClip();
            this.addChild(FG);
            zManager.removeEventListener(Event.ENTER_FRAME, onZmanagerEnterFrame);
            autoActionTimer.removeEventListener("timer", autoActionHandler);
            restTimer.removeEventListener("timer", restRequest);
            AATestTimer.removeEventListener("timer", AATest);
            connTestTimer.removeEventListener("timer", connTest);
            mvTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, mvTimerHandler);
            mapTimer.removeEventListener(TimerEvent.TIMER, mapResizeCheck);
            zManager.addEventListener(Event.ENTER_FRAME, onZmanagerEnterFrame, false, 0, true);
            autoActionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoActionHandler);
            restTimer.addEventListener("timer", restRequest);
            AATestTimer.addEventListener("timer", AATest);
            connTestTimer.addEventListener("timer", connTest);
            mvTimer.addEventListener(TimerEvent.TIMER_COMPLETE, mvTimerHandler);
            mapTimer.addEventListener(TimerEvent.TIMER, mapResizeCheck, false, 0, true);
            mapTimer.start();
            initLoaders();
            initCutscenes();
        }

        public static function get GameRoot():MovieClip
        {
            return (currentInstance.rootClass);
        }

        public static function get Bank():BankController
        {
            return (currentInstance.bankController);
        }


        public function initPatternTree():void
        {
            var _local_1:*;
            enhPatternTree = {};
            for each (_local_1 in enhp)
            {
                enhPatternTree[_local_1.ID] = _local_1;
            }
        }

        public function initGuildhallData(_arg_1:Array):void
        {
            var _local_3:*;
            var _local_2:uint;
            while (_local_2 < _arg_1.length)
            {
                for (_local_3 in _arg_1[_local_2])
                {
                }
                _local_2++;
            }
        }

        public function killTimers():void
        {
            autoActionTimer.reset();
            restTimer.reset();
            AATestTimer.reset();
            connTestTimer.reset();
            rootClass.chatF.mute.timer.reset();
            autoActionTimer.removeEventListener("timer", autoActionHandler);
            restTimer.removeEventListener("timer", restRequest);
            AATestTimer.removeEventListener("timer", AATest);
            connTestTimer.removeEventListener("timer", connTest);
            mvTimer.removeEventListener("timer", mvTimerHandler);
            rootClass.chatF.mute.timer.removeEventListener("timer", rootClass.chatF.unmuteMe);
        }

        public function killListeners():void
        {
            zManager.removeEventListener(Event.ENTER_FRAME, onZmanagerEnterFrame);
            removeChild(zManager);
        }

        public function queueLoad(_arg_1:*):* {
            _arg_1.retries = 1;
            loaderQueue.push(_arg_1);
            var _local_2:* = getFreeLoader();
            if (_local_2 != null) {
                loadNext(_local_2);
            }
        }

        public function loaderCallback(e:Event):* {
            var ldr:* = e.target;
            var l:* = getLoaderHost(ldr);
            if (l != null) {
                if (l.callBackA != null) {
                    l.callBackA(e);
                }
            }
            closeLoader(l, true);
        }

        public function loaderHTTP(e:HTTPStatusEvent):void {
            var l:*;
            var str:String;
            if (e.status != 200) {
                l = getLoaderHostByLoaderInfo(e.currentTarget);
                trace(((("Loader queue http request: " + l.url) + ";") + e.status));
                str = ((("Queue: " + l.url) + ";") + e.status);
                trace(str);
                closeLoader(l, false, false);
            }
        }

        public function loaderErrorHandler(_arg_1:IOErrorEvent):*
        {
            trace("loaderErrorHandler => " + _arg_1);
            var _local_2:String = _arg_1.toString();
            var _local_3:String = _local_2.substr((_local_2.indexOf("URL: ") + 5));
            _local_3 = _local_3.substr(0, (_local_3.length - 1));
            var _local_4:* = getLoaderHostByURL(_local_3);
            rootClass.debugMessage(((("Failed to load, Linkage: " + _local_4.loaderData.sES) + ", File: ") + _local_4.loaderData.sFile));
            if (_local_4 != null)
            {
                if (_local_4.callBackB != null)
                {
                    _local_4.callBackB(_arg_1);
                }
            }
            closeLoader(_local_4, false, false);
        }

        private function loaderProgressHandler(_arg_1:Event):*
        {
            var _local_2:* = _arg_1.currentTarget;
            var _local_3:* = getLoaderHostByLoaderInfo(_local_2);
            if (_local_3 != null)
            {
                _local_3.isOpen = true;
            }
        }

        private function loaderTimerComplete(e:TimerEvent):void {
            var l:* = getLoaderHostByTimer(Timer(e.currentTarget));
            if (l != null) {
                l.timer.reset();
                if (!l.isOpen) {
                    if (l.loaderData.retries-- > 0) {
                        loaderQueue.push(l.loaderData);
                    }
                    closeLoader(l, false, true);
                }
            }
        }

        public function getLoaderHost(ldr:*):* {
            var i:*;
            for (i in loaderManager) {
                if (loaderManager[i].ldr == ldr) {
                    return (loaderManager[i]);
                }
            }
            return null;
        }

        public function getLoaderHostByLoaderInfo(_loaderInfo:*):Object {
            var i:*;
            for (i in loaderManager) {
                if (loaderManager[i].ldr == _loaderInfo) {
                    return (loaderManager[i]);
                }
            }
            return null;
        }

        public function getLoaderHostByTimer(t:Timer):Object {
            var i:*;
            for (i in loaderManager) {
                if (loaderManager[i].timer == t) {
                    return (loaderManager[i]);
                }
            }
            return null;
        }

        public function getLoaderHostByURL(u:String):Object {
            var i:*;
            for (i in loaderManager) {
                if (u.indexOf(loaderManager[i].url) > -1) {
                    return (loaderManager[i]);
                }
            }
            return null;
        }

        public function getFreeLoader():Object {
            var i:*;
            if (loaderQueue.length > 0) {
                for (i in loaderManager) {
                    if (loaderManager[i].free) {
                        loaderManager[i].free = false;
                        return (loaderManager[i]);
                    }
                }
                return null;
            }
            return null;
        }

        public function closeLoader(_arg_1:Object, _arg_2:Boolean=true, _arg_3:Boolean=true, _arg_4:Boolean=true):void
        {
            if (_arg_3)
            {
                try
                {
                    _arg_1.ldr.unload();
                }
                catch(e:Error)
                {
                }
            }
            _arg_1.free = true;
            _arg_1.isOpen = false;
            _arg_1.loaderData = null;
            _arg_1.timer.reset();
            var _local_5:* = getFreeLoader();
            if (((!(_local_5 == null)) && (_arg_4)))
            {
                loadNext(_local_5);
            }
        }

        public function initLoaders():void {
            var lmi:Object;
            var i:*;
            for (i in loaderManager) {
                lmi = loaderManager[i];
                lmi.timer.addEventListener(TimerEvent.TIMER_COMPLETE, loaderTimerComplete, false, 0, true);
                lmi.ldr.addEventListener(Event.COMPLETE, loaderCallback, false, 0, true);
                lmi.ldr.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
                lmi.ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHTTP, false, 0, true);
                lmi.ldr.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler, false, 0, true);
            }
        }

        public function clearLoaders(clearPlayerDomains:Boolean = false):* {
            var lmi:Object;
            var i:* = undefined;
            for (i in loaderManager) {
                lmi = loaderManager[i];
                try {
                    lmi.ldr.close();
                } catch (e:Error) {
                }
                try {
                    lmi.ldr.unload();
                } catch (e:Error) {
                }
                lmi.free = true;
                lmi.isOpen = false;
                lmi.loaderData = null;
                lmi.timer.reset();
                lmi.callBackA = null;
                lmi.callBackB = null;
            }
            if (clearPlayerDomains) {
                playerDomains = {};
            }
            loaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
            loaderC = new LoaderContext(false, loaderD);
            loaderC.checkPolicyFile = false;
            loaderC.allowCodeImport = true;
            loaderQueue = [];
        }

        public function killLoaders():void {
            var lmi:Object;
            var i:*;
            for (i in loaderManager) {
                lmi = loaderManager[i];
                lmi.free = true;
                lmi.isOpen = false;
                lmi.loaderData = null;
                lmi.timer.reset();
                lmi.callBackA = null;
                lmi.callBackB = null;
            }
            loaderQueue = [];
        }

        public function loadNext(_arg_1:Object):* {
            if (loaderQueue.length > 0) {
                loadNextWith(_arg_1, loaderQueue.shift());
            }
        }

        private function loadNextWith(l:Object, loaderData:Object):void {
            var u:URLRequest;
            var c:LoaderContext = loaderC;
            c.checkPolicyFile = false;
            c.allowCodeImport = true;
            if (l != null) {
                l.free = false;
                l.callBackA = loaderData.callBackA != null ? loaderData.callBackA : null;
                l.callBackB = loaderData.callBackB != null ? loaderData.callBackB : null;

                if (loaderData.avt != null && loaderData.avt == myAvatar && loaderData.sES != null)
                {
                    mapPlayerAssetClass(loaderData.sES);
                }

                u = new URLRequest(loaderData.strFile);
                l.ldr.dataFormat = URLLoaderDataFormat.BINARY;
                l.ldr.load(u);
                l.url = u.url;
                l.isOpen = false;
                l.loaderData = loaderData;
                l.timer.reset();
                l.timer.start();
            }
        }

        private function mapPlayerAssetClass(sES:String):LoaderContext
        {
            if (playerDomains[sES] == null)
            {
                playerDomains[sES] = {};
                playerDomains[sES].loaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
                playerDomains[sES].loaderC = new LoaderContext(false, playerDomains[sES].loaderD);
                playerDomains[sES].loaderC.checkPolicyFile = false;
                playerDomains[sES].loaderC.allowCodeImport = true;
            }

            return (playerDomains[sES].loaderC);
        }

        public function getClass(assetLinkageID:String):Class
        {
            var _local_3:Class;
            var _local_4:String;
            try
            {
                _local_3 = (getDefinitionByName(assetLinkageID) as Class);
                if (_local_3 != null)
                {
                    return (_local_3);
                }
            }
            catch(e:Error)
            {
            }
            try
            {
                _local_3 = (rootClass.assetsDomain.getDefinition(assetLinkageID) as Class);
                if (_local_3 != null)
                {
                    return (_local_3);
                }
            }
            catch(e:Error)
            {
            }
            try
            {
                _local_3 = (loaderD.getDefinition(assetLinkageID) as Class);
                if (_local_3 != null)
                {
                    return (_local_3);
                }
            }
            catch(e:Error)
            {
            }

            for (_local_4 in playerDomains) {
                if (playerDomains[_local_4].loaderD.hasDefinition(assetLinkageID)) {
                    return (playerDomains[_local_4].loaderD.getDefinition(assetLinkageID) as Class);
                }
            }

            if (!rootClass.litePreference.data.dOptions["debugLinkage"])
            {
                rootClass.debugMessage(("Failed to find Linkage: " + assetLinkageID));
            }

            return null;
        }

        public function loadMap(strFilename:String):*
        {
            rootClass.mcConnDetail.showConn("Loading Map Files...");

            if (map != null)
            {
                map.gotoAndStop("Wait");
                removeChild(map);
                map = null;
            }

            rootClass.onLoadMaster(onMapLoadComplete, loaderC, "maps/" + strFilename, onMapLoadProgress, onMapLoadError);
            rootClass.clearPopups();
        }

        private function onMapLoadProgress(_arg_1:ProgressEvent):void
        {
            var _local_2:int = int(Math.floor(((_arg_1.bytesLoaded / _arg_1.bytesTotal) * 100)));
            rootClass.mcConnDetail.showConn((("Loading Map... " + _local_2) + "%"));
        }

        private function onMapLoadError(_arg_1:IOErrorEvent):*
        {
            mapLoadInProgress = false;
            if (rootClass.litePreference.data.bDebugger)
            {
                rootClass.debugMessage(("Failed to load Map: " + _arg_1));
            }
            else
            {
                rootClass.mcConnDetail.showError("Loading Map Files... Failed!");
            }
        }

        private function onMapLoadComplete(event:Event) : void
        {
            rootClass.ui.visible = true;
            mapLoadInProgress = false;
            map = MovieClip(Loader(event.target.loader).content);
            addChildAt(map, 0).x = 0;

            // Keep legacy map classes alive but suppress their old arrow art.
            scheduleLegacyMapArrowSweep();

            CHARS.x = 0;
            resetSpawnPoint();
            if (((!(mondef == null)) && (mondef.length)))
            {
                initMonsters(mondef, monmap);
            }
            else
            {
                enterMap();
            }
            if (isMyHouse())
            {
                rootClass.ui.mcPopup.fOpen("House");
            }
            if (((rootClass.cMenuUI) && (rootClass.cMenuUI.isMenuOpen())))
            {
                rootClass.cMenuUI.reDraw();
            }
        }

        public function reloadCurrentMap():void
        {
            clearMonstersAndProps();
            loadMap(((strMapFileName + "?") + Math.random()));
        }

        public function enterMap():void
        {
            var _local_1:* = uoTreeLeaf(rootClass.sfc.myUserName);
            if (((intType == 0) || (returnInfo == null)))
            {
                moveToCell(_local_1.strFrame, _local_1.strPad);
            }
            else
            {
                moveToCell(returnInfo.strCell, returnInfo.strPad);
                returnInfo = null;
            }
            initMapEvents();
            rootClass.mcConnDetail.hideConn();
            if (!rootClass.litePreference.data.bHideUI)
            {
                rootClass.ui.mcInterface.areaList.visible = true;
            }
            if (isMyHouse())
            {
                initMassConvert();
            }
        }

        public function setReturnInfo(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            returnInfo = {};
            returnInfo.strMap = _arg_1;
            returnInfo.strCell = _arg_2;
            returnInfo.strPad = _arg_3;
        }

        public function exitCell():void
        {
            mvTimerKill();
            exitCombat();
            rootClass.clearPopups(["House"]);
            if (myAvatar != null)
            {
                myAvatar.targets = {};
                if (myAvatar.pMC != null)
                {
                    myAvatar.pMC.stopWalking();
                }
                if (myAvatar.petMC != null)
                {
                    myAvatar.petMC.stopWalking();
                }
                if (myAvatar.target != null)
                {
                    setTarget(null);
                }
            }
            if (strFrame != "Wait")
            {
                clearDatabaseMapArrows();
                clearMonstersAndProps();
                hideAllAvatars();
            }
            rootClass.sfcSocial = false;
            rootClass.ui.mcInterface.areaList.gotoAndStop("init");
        }

        public function moveToCell(_arg_1:String, _arg_2:String, _arg_3:Boolean=false):void
        {
            var _local_4:*;
            var _local_5:*;
            if (((strMapName == "trickortreat") && (!(_arg_1 == "Enter"))))
            {
                if (!TrickOrTreatMonsterDead)
                {
                    return;
                }
            }
            if (((strMapName == "caroling") && (!(_arg_1 == "Enter"))))
            {
                if (CarolingMonsterKillCount < 5)
                {
                    return;
                }
            }
            afkPostpone();
            if ((((objLock == null) || (objLock[_arg_1] == null)) || (objLock[_arg_1] <= intKillCount)))
            {
                if (uoTree[rootClass.sfc.myUserName].freeze == null)
                {
                    _local_4 = [];
                    actionReady = false;
                    bitWalk = false;
                    _local_5 = {};
                    _local_5.strFrame = _arg_1;
                    _local_5.strPad = _arg_2;
                    if (_arg_2.toLowerCase() != "none")
                    {
                        _local_5.tx = 0;
                        _local_5.ty = 0;
                    }
                    uoTreeLeafSet(rootClass.sfc.myUserName, _local_5);
                    strFrame = _arg_1;
                    strPad = _arg_2;
                    if (((strAreaName.indexOf("battleon") < 0) || (strAreaName.indexOf("battleontown") > -1)))
                    {
                        rootClass.menuClose();
                    }
                    if (!_arg_3)
                    {
                        rootClass.sfc.sendXtMessage("zm", "moveToCell", [_arg_1, _arg_2], "str", curRoom);
                    }
                    exitCell();
                    map.gotoAndPlay("Blank");
                    if (((rootClass.cMenuUI) && (rootClass.cMenuUI.isMenuOpen())))
                    {
                        rootClass.cMenuUI.reDraw();
                    }
                    if ((((strMapName == "house") && (isMyHouse())) && (!(rootClass.ui.mcPopup.currentLabel == "House"))))
                    {
                        rootClass.ui.mcPopup.fOpen("House");
                    }
                }
            }
        }

        public function moveToCellByIDa(_arg_1:int):void
        {
            if (((bPvP) && (!(isMoveOK(myAvatar.dataLeaf)))))
            {
                return;
            }
            rootClass.sfc.sendXtMessage("zm", "mtcid", [_arg_1], "str", curRoom);
        }

        public function moveToCellByIDb(_arg_1:int):void
        {
            var _local_2:MovieClip;
            var _local_3:int;
            while (_local_3 < arrEvent.length)
            {
                _local_2 = (arrEvent[_local_3] as MovieClip);
                if (((("tID" in _local_2) && (_local_2.tID == _arg_1)) || ((_local_2.name.indexOf("ia") == 0) && (int(_local_2.name.substr(2)) == _arg_1))))
                {
                    moveToCell(_local_2.tCell, _local_2.tPad, true);
                }
                _local_3++;
            }
        }

        public function hideAllAvatars():void
        {
            var _local_1:*;
            for (_local_1 in avatars)
            {
                if (((!(avatars[_local_1] == null)) && (!(avatars[_local_1].pMC == null))))
                {
                    avatars[_local_1].hideMC();
                }
            }
        }

        public function clearAllAvatars():void
        {
            var _local_1:String;
            for (_local_1 in avatars)
            {
                destroyAvatar(Number(_local_1));
            }
            avatars = {};
        }

        public function clearMonstersAndProps():void
        {
            // NPCs are frame-scoped just like monsters/props. Remove the current
            // frame's database actors before rebuilding the next cell/map.
            clearDatabaseNPCs();
            var _local_2:DisplayObject;
            var _local_3:*;
            var _local_1:int;
            _local_1 = 0;
            while (_local_1 < CHARS.numChildren)
            {
                _local_2 = CHARS.getChildAt(_local_1);
                if (((_local_2.hasOwnProperty("isProp")) && (MovieClip(_local_2).isProp)))
                {
                    CHARS.removeChild(_local_2);
                    _local_1--;
                }
                else
                {
                    if (((_local_2.hasOwnProperty("isHouseItem")) && (MovieClip(_local_2).isHouseItem)))
                    {
                        _local_2.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick);
                        CHARS.removeChild(_local_2);
                        _local_1--;
                    }
                    else
                    {
                        if (((_local_2.hasOwnProperty("isMonster")) && (MovieClip(_local_2).isMonster)))
                        {
                            MovieClip(_local_2).fClose();
                            _local_1--;
                        }
                    }
                }
                _local_1++;
            }
            _local_1 = 0;
            while (_local_1 < TRASH.numChildren)
            {
                _local_2 = TRASH.getChildAt(_local_1);
                if (((_local_2.hasOwnProperty("isMonster")) && (MovieClip(_local_2).isMonster)))
                {
                    MovieClip(_local_2).fClose();
                    _local_1--;
                }
                _local_1++;
            }
            _local_1 = 0;
            while (_local_1 < monsters.length)
            {
                monsters[_local_1].pMC = null;
                _local_1++;
            }
            while (rootClass.ui.mcPadNames.numChildren)
            {
                _local_3 = rootClass.ui.mcPadNames.getChildAt(0);
                MovieClip(_local_3).stop();
                rootClass.ui.mcPadNames.removeChild(_local_3);
            }
        }

        public function setMapEvents(_arg_1:Object):void
        {
            mapEvents = _arg_1;
        }

        public function initMapEvents():void
        {
            if ((("eventUpdate" in map) && (!(mapEvents == null))))
            {
                map.eventUpdate({
                    "cmd":"event",
                    "args":mapEvents
                });
            }
            mapEvents = null;
        }

        public function setCellMap(_arg_1:Object):void
        {
            cellMap = _arg_1;
        }

        public function updateCellMap(_arg_1:Object):void
        {
            var _local_3:String;
            var _local_4:MovieClip;
            var _local_5:String;
            var _local_2:Object = {};
            for (_local_3 in cellMap)
            {
                _local_2 = cellMap[_local_3];
                if (((!(_local_2.ias == null)) && (!(_local_2.ias[_arg_1.ID] == null))))
                {
                    for (_local_5 in _arg_1)
                    {
                        _local_2.ias[_arg_1.ID][_local_5] = _arg_1[_local_5];
                    }
                }
            }
            try
            {
                _local_4 = MovieClip(CHARS.getChildByName(("ia" + _arg_1.ID)));
                _local_4.update();
                return;
            }
            catch(e:Error)
            {
            }
            try
            {
                _local_4 = MovieClip(map.getChildByName(("ia" + _arg_1.ID)));
                _local_4.update();
            }
            catch(e:Error)
            {
            }
        }

        /**
         * Smooth continuous WASD movement.
         *
         * The old implementation called walkTo() every ~85ms with a tiny target,
         * which repeatedly reset AvatarMC's interpolation timer and caused the
         * visible start/stop/jitter feeling.
         *
         * This version gives AvatarMC one long target in the held direction and
         * only retargets when:
         *   - direction changes,
         *   - the current walk finishes, or
         *   - the player gets close to the current target.
         *
         * Collision, walk animation, map events and network movement still use
         * the normal client movement pipeline.
         */
        public function movePlayerByKeyboard(dx:Number, dy:Number):void
        {
            var aura:Object;
            var length:Number;
            var directionChanged:Boolean;
            var remaining:Number = 0;
            var now:Number;
            var targetX:Number;
            var targetY:Number;
            var mvPT:Point;
            var currentPoint:Point;

            if (((!(bitWalk)) || (myAvatar == null) || (myAvatar.pMC == null)))
            {
                stopKeyboardMovement();
                return;
            }

            // Keep stock movement locks.
            if (((myAvatar.dataLeaf != null) && (myAvatar.dataLeaf.auras != null)))
            {
                for each (aura in myAvatar.dataLeaf.auras)
                {
                    try
                    {
                        if (((aura != null) && (aura.cat != null)))
                        {
                            if ((((aura.cat == "stun") || (aura.cat == "stone")) || (aura.cat == "disabled")))
                            {
                                stopKeyboardMovement();
                                return;
                            }
                        }
                    }
                    catch(e:Error)
                    {
                    }
                }
            }

            length = Math.sqrt(((dx * dx) + (dy * dy)));
            if (length <= 0)
            {
                stopKeyboardMovement();
                return;
            }

            // Normalize diagonals so W+D is the same speed as W.
            dx = (dx / length);
            dy = (dy / length);

            directionChanged = (
                !keyboardMoveActive ||
                Math.abs(dx - keyboardMoveDX) > 0.01 ||
                Math.abs(dy - keyboardMoveDY) > 0.01
            );

            if (myAvatar.pMC.tp != null)
            {
                currentPoint = new Point(myAvatar.pMC.x, myAvatar.pMC.y);
                remaining = Point.distance(currentPoint, myAvatar.pMC.tp);
            }

            // Keep the current interpolation running untouched while there is
            // plenty of distance left in the same direction.
            if (
                !directionChanged &&
                myAvatar.pMC.mcChar.onMove &&
                myAvatar.pMC.tp != null &&
                remaining > KEYBOARD_RETARGET_DISTANCE
            )
            {
                return;
            }

            now = new Date().getTime();

            // At a wall, avoid hammering simulateTo every rendered frame.
            if (
                !directionChanged &&
                ((now - keyboardMoveLastRetarget) < KEYBOARD_RETARGET_DELAY)
            )
            {
                return;
            }

            afkPostpone();
            speed = WALKSPEED;

            targetX = (myAvatar.pMC.x + (dx * KEYBOARD_LOOKAHEAD));
            targetY = (myAvatar.pMC.y + (dy * KEYBOARD_LOOKAHEAD));

            mvPT = myAvatar.pMC.simulateTo(
                Math.round(targetX),
                Math.round(targetY),
                speed
            );

            keyboardMoveLastRetarget = now;

            if (
                mvPT == null ||
                Point.distance(new Point(myAvatar.pMC.x, myAvatar.pMC.y), mvPT) < 1
            )
            {
                // If the requested direction changed directly into a wall,
                // cancel the old target instead of drifting along it.
                if (directionChanged)
                {
                    stopKeyboardMovement();
                }
                return;
            }

            keyboardMoveDX = dx;
            keyboardMoveDY = dy;
            keyboardMoveActive = true;

            myAvatar.pMC.walkTo(mvPT.x, mvPT.y, speed);

            // Send the long destination once. The local avatar interpolates
            // smoothly toward it and remote clients use the same movement path.
            if (bPvP)
            {
                pushMove(myAvatar.pMC, mvPT.x, mvPT.y, speed);
            }
            else if (clickOnEventTest(mvPT.x, mvPT.y))
            {
                pushMove(myAvatar.pMC, mvPT.x, mvPT.y, speed);
            }
            else
            {
                moveRequest({
                    "mc":myAvatar.pMC,
                    "tx":mvPT.x,
                    "ty":mvPT.y,
                    "sp":speed
                });
            }
        }

        /**
         * Stop held-key movement exactly where the player currently is.
         * A final movement packet prevents other clients from continuing toward
         * the previous long look-ahead target after the key is released.
         */
        public function stopKeyboardMovement():void
        {
            var wasActive:Boolean = keyboardMoveActive;

            keyboardMoveActive = false;
            keyboardMoveDX = 0;
            keyboardMoveDY = 0;
            keyboardMoveLastRetarget = 0;

            if (((myAvatar == null) || (myAvatar.pMC == null)))
            {
                mvTimerKill();
                return;
            }

            if (!wasActive)
            {
                return;
            }

            // Never let the delayed mouse-movement timer send the old WASD target.
            mvTimerKill();

            try
            {
                myAvatar.pMC.destroyWalkFrame();
            }
            catch(e:Error)
            {
                try
                {
                    myAvatar.pMC.stopWalking();
                }
                catch(e2:Error)
                {
                }
            }

            if (bitWalk)
            {
                pushMove(
                    myAvatar.pMC,
                    Math.round(myAvatar.pMC.x),
                    Math.round(myAvatar.pMC.y),
                    WALKSPEED
                );
            }
        }


        public function onWalkClick():void
        {
            var aura:Object;
            var p:Point;
            var now:* = undefined;
            var mvPT:* = undefined;
            var fellDown:Array;
            var cLeaf:Object = myAvatar.dataLeaf;
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
            p = new Point(mouseX, mouseY);
            if (bitWalk)
            {
                afkPostpone();
                if (((((mouseX >= 0) && (mouseX <= 960)) && (mouseY >= 0)) && (mouseY <= 500)))
                {
                    p = CHARS.globalToLocal(p);
                    p.x = Math.round(p.x);
                    p.y = Math.round(p.y);
                    speed = WALKSPEED;
                    now = new Date().getTime();
                    if (((rootClass.pDash) && (!(justRan))))
                    {
                        // Reassert the dash cost immediately before the click is converted
                        // into movement. The original AQW pushMove bytecode reads sta.$dsh;
                        // doing this here also protects against a later stat update restoring
                        // the legacy $dsh=100 between key-down and the movement click.
                        if (myAvatar.dataLeaf.sta == null)
                        {
                            myAvatar.dataLeaf.sta = {};
                        }
                        myAvatar.dataLeaf.sta["$dsh"] = DASH_STAMINA_COST;
                        try
                        {
                            if (uoTree[myAvatar.pnm] != null)
                            {
                                if (uoTree[myAvatar.pnm].sta == null)
                                {
                                    uoTree[myAvatar.pnm].sta = {};
                                }
                                uoTree[myAvatar.pnm].sta["$dsh"] = DASH_STAMINA_COST;
                            }
                        }
                        catch(dashCostErr:Error)
                        {
                        }
                        if (myAvatar.dataLeaf.intSP >= DASH_STAMINA_COST)
                        {
                            speed = (speed * 3);
                            justRan = true;
                        }
                        rootClass.pDash = false;
                    }
                    mvPT = myAvatar.pMC.simulateTo(p.x, p.y, speed);
                    if (mvPT != null)
                    {
                        if (!bPvP)
                        {
                            if (clickPts >= 5)
                            {
                                fellDown = ["Feign", "Dazed"];
                                myAvatar.pMC.gotoAndPlay(fellDown[Math.floor((Math.random() * 2))]);
                                return;
                            }
                            myAvatar.pMC.walkTo(mvPT.x, mvPT.y, speed);
                        }
                        if (bPvP)
                        {
                            if ((now - mva[0]) <= (300 * mva.length))
                            {
                                myAvatar.pMC.walkTo(myAvatar.pMC.tp.x, myAvatar.pMC.tp.y, speed);
                                return;
                            }
                            mva.push(now);
                            if (mva.length > 5)
                            {
                                mva.shift();
                            }
                            myAvatar.pMC.walkTo(mvPT.x, mvPT.y, speed);
                            pushMove(myAvatar.pMC, mvPT.x, mvPT.y, speed);
                        }
                        else
                        {
                            if (clickOnEventTest(mvPT.x, mvPT.y))
                            {
                                pushMove(myAvatar.pMC, mvPT.x, mvPT.y, speed);
                            }
                            else
                            {
                                clickPts++;
                                moveRequest({
                                    "mc":myAvatar.pMC,
                                    "tx":mvPT.x,
                                    "ty":mvPT.y,
                                    "sp":speed
                                });
                            }
                        }
                    }
                }
            }
        }

        public function clickOnEventTest(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:Rectangle = myAvatar.pMC.shadow.getBounds(this);
            var _local_4:Rectangle = new Rectangle();
            _local_3.x = (_arg_1 - (_local_3.width / 2));
            _local_3.y = (_arg_2 - (_local_3.height / 2));
            var _local_5:int;
            while (_local_5 < arrEvent.length)
            {
                _local_4 = arrEvent[_local_5].shadow.getBounds(this);
                if (_local_3.intersects(_local_4))
                {
                    return true;
                }
                _local_5++;
            }
            return false;
        }

        public function moveRequest(_arg_1:Object):void
        {
            if (!mvTimer.running)
            {
                pushMove(_arg_1.mc, _arg_1.tx, _arg_1.ty, _arg_1.sp);
                mvTimer.reset();
                mvTimer.start();
            }
            else
            {
                mvTimerObj = _arg_1;
            }
        }

        public function mvTimerHandler(_arg_1:TimerEvent):void
        {
            var _local_2:Object = {};
            if (mvTimerObj != null)
            {
                pushMove(mvTimerObj.mc, mvTimerObj.tx, mvTimerObj.ty, mvTimerObj.sp);
                mvTimerObj = null;
            }
        }

        public function mvTimerKill():void
        {
            mvTimer.reset();
            mvTimerObj = null;
        }

        public function pushMove(_arg_1:MovieClip, _arg_2:int, _arg_3:int, _arg_4:int):*
        {
            var _local_6:*;
            var dashMove:Boolean;
            clickPts = 0;
            var _local_5:* = {};
            _local_5.tx = int(_arg_2);
            _local_5.ty = int(_arg_3);
            _local_5.sp = int(_arg_4);
            uoTreeLeafSet(rootClass.sfc.myUserName, _local_5);

            // Aera v30.75: force both copies of the stat leaf to the real dash
            // cost immediately before the original movement/dash logic can read it.
            if (myAvatar.dataLeaf.sta == null)
            {
                myAvatar.dataLeaf.sta = {};
            }
            myAvatar.dataLeaf.sta["$dsh"] = DASH_STAMINA_COST;
            try
            {
                if (uoTree[myAvatar.pnm] != null)
                {
                    if (uoTree[myAvatar.pnm].sta == null)
                    {
                        uoTree[myAvatar.pnm].sta = {};
                    }
                    uoTree[myAvatar.pnm].sta["$dsh"] = DASH_STAMINA_COST;
                }
            }
            catch(dashMoveErr:Error)
            {
            }

            if (justRan)
            {
                if (myAvatar.dataLeaf.intSP < DASH_STAMINA_COST)
                {
                    speed = WALKSPEED;
                    justRan = false;
                }
            }
            else
            {
                speed = WALKSPEED;
            }

            dashMove = justRan;
            if (bitWalk)
            {
                rootClass.sfc.sendXtMessage("zm", "mv", [_arg_2, _arg_3, speed, (dashMove ? 1 : 0)], "str", curRoom);
            }
            if (dashMove)
            {
                _local_6 = Math.max(0, (myAvatar.dataLeaf.intSP - DASH_STAMINA_COST));
                myAvatar.dataLeaf.intSP = _local_6;
                myAvatar.objData["intSP"] = _local_6;
                updatePortrait(myAvatar);
                updateActBar();
                justRan = false;
            }
        }

        public function monstersToPads():*
        {
            var _local_1:*;
            var _local_2:*;
            for (_local_1 in monsters)
            {
                _local_2 = monsters[_local_1];
                if (((!(_local_2.objData == null)) && (_local_2.objData.strFrame == strFrame)))
                {
                    _local_2.pMC.walkTo(_local_2.pMC.ox, _local_2.pMC.oy, (WALKSPEED * 1.4));
                }
            }
        }

        public function updatePadNames():*
        {
            var _local_2:*;
            var _local_1:int;
            while (_local_1 < rootClass.ui.mcPadNames.numChildren)
            {
                _local_2 = MovieClip(rootClass.ui.mcPadNames.getChildAt(_local_1));
                if ((((objLock == null) || (objLock[_local_2.tCell] == null)) || (objLock[_local_2.tCell] <= intKillCount)))
                {
                    _local_2.cnt.lock.visible = false;
                }
                else
                {
                    _local_2.cnt.lock.visible = true;
                }
                _local_1++;
            }
        }

        public function cellSetup(_arg_1:Number, _arg_2:Number, _arg_3:String, _arg_4:Boolean = false):void
        {
            var _local_4:Bitmap;
            var _local_9:DisplayObject;
            var _local_10:uint;
            var _local_11:DisplayObject;
            var _local_12:*;
            var _local_13:Array;
            var _local_14:Avatar;
            var _local_15:*;
            var _local_16:int;
            var _local_17:MovieClip;
            CELL_MODE = _arg_3;
            SCALE = _arg_1;
            SCROLL = _arg_4;
            WALKSPEED = _arg_2;
            arrSolid = [];
            arrEvent = [];

            // Aera DB arrows are runtime MovieClips added to the map after cell setup.
            // A repeated map/cell setup can otherwise scan an old DatabaseMapArrow as
            // if it were a legacy map-authored MovieClip and read fields such as
            // hasPads/isSolid/isEvent that the runtime arrow does not define.
            // Remove the previous runtime arrows before scanning the map children.
            try
            {
                clearDatabaseMapArrows();
            }
            catch (dbArrowClearError:Error)
            {
            }

            var _local_5:BitmapData = new BitmapData(960, 550, true, 0);
            var _local_6:Array = [];
            var _local_7:* = (Number(objExtra["bMonName"]) == 1);
            var _local_8:int;
            while (_local_8 < map.numChildren)
            {
                _local_9 = map.getChildAt(_local_8);
                if ((_local_9 is MovieClip))
                {
                    if ((("hasPads" in _local_9) && Boolean(MovieClip(_local_9).hasPads)))
                    {
                        _local_10 = 0;
                        while (_local_10 < MovieClip(_local_9).numChildren)
                        {
                            _local_11 = MovieClip(_local_9).getChildAt(_local_10);
                            if (((((_local_11 is MovieClip) && ("isEvent" in _local_11)) && Boolean(MovieClip(_local_11).isEvent)) && (!(("isProp" in _local_11) && Boolean(MovieClip(_local_11).isProp)))))
                            {
                                arrEvent.push(MovieClip(_local_11));
                            }
                            if ((((_local_11 is MovieClip) && ("isSolid" in _local_11)) && Boolean(MovieClip(_local_11).isSolid)))
                            {
                                arrSolid.push(MovieClip(_local_9));
                            }
                            _local_10++;
                        }
                    }
                }
                if ((((_local_9 is MovieClip) && ("isSolid" in _local_9)) && Boolean(MovieClip(_local_9).isSolid)))
                {
                    arrSolid.push(MovieClip(_local_9));
                }
                if ((((_local_9 is MovieClip) && ("walk" in _local_9)) && ("btnWalkingArea" in _local_9)))
                {
                    MovieClip(_local_9).btnWalkingArea.useHandCursor = false;
                }
                if (((((_local_9 is MovieClip) && ("isEvent" in _local_9)) && Boolean(MovieClip(_local_9).isEvent)) && (!(("isProp" in _local_9) && Boolean(MovieClip(_local_9).isProp)))))
                {
                    arrEvent.push(MovieClip(_local_9));
                }
                if (((!(strMapName == "trickortreat")) && (!(strMapName == "caroling"))))
                {
                    if ((((_local_9 is MovieClip) && ("isMonster" in _local_9)) && Boolean(MovieClip(_local_9).isMonster)))
                    {
                        _local_12 = [];
                        _local_13 = getMonsters(MovieClip(_local_9).MonMapID);
                        for each (_local_14 in _local_13)
                        {
                            if (((_local_14 != null) && (!(monsterUsesDatabasePosition(_local_14)))))
                            {
                                _local_14.pMC = createMonsterMC(MovieClip(_local_9), _local_14.objData.MonID, _local_7);
                                _local_14.pMC.scale(SCALE);
                                _local_14.pMC.pAV = _local_14;
                                _local_14.pMC.setData();
                                if (_local_14.dataLeaf == null)
                                {
                                    TRASH.addChild(_local_14.pMC);
                                }
                                else
                                {
                                    if (rootClass.litePreference.data.bMonsType)
                                    {
                                        _local_14.pMC.pname.typ.text = (("< " + _local_14.pMC.pAV.objData.sRace) + " >");
                                        _local_14.pMC.pname.typ.visible = (!(_local_14.pMC.pAV.objData.sRace == "None"));
                                    }
                                    else
                                    {
                                        _local_14.pMC.pname.typ.visible = false;
                                    }
                                }
                            }
                        }
                    }
                }
                if ((((_local_9 is MovieClip) && ("isProp" in _local_9)) && Boolean(MovieClip(_local_9).isProp)))
                {
                    _local_15 = CHARS.addChild(_local_9);
                    if (((_local_15 is MovieClip) && ("isEvent" in _local_15) && Boolean(MovieClip(_local_15).isEvent)))
                    {
                        arrEvent.push(MovieClip(_local_15));
                        MovieClip(_local_15).isEvent = false;
                    }
                    _local_8--;
                }
                if ((((((_local_9 is MovieClip) && (_local_9.width > 700)) && (!("isSolid" in _local_9))) && (!("walk" in _local_9))) && (!("btnSkip" in _local_9))))
                {
                    MovieClip(_local_9).mouseEnabled = false;
                    MovieClip(_local_9).mouseChildren = false;
                }
                if ((((((_local_9 is MovieClip) && (_local_9.width >= 960)) && (!("isSolid" in _local_9))) && (!("walk" in _local_9))) && (!("btnSkip" in _local_9))))
                {
                }
                _local_8++;
            }
            // Database-positioned monster instances do not need an isMonster /
            // MonMapID marker inside the map SWF. Their exact spawn location comes
            // from maps_monsters.X/Y and the old marker path above is skipped.
            spawnDatabaseMonstersForCurrentFrame(_local_7);

            if (((strFrame == "Enter") && (strMapName == "trickortreat")))
            {
                if (((TrickOrTreatMonsterDead) && (!(CHARS.getChildByName("mcPlayerNPCTrickOrTreat")))))
                {
                    loadPlayerNPC();
                }
                else
                {
                    TrickOrTreatPad = "Spawn";
                    _local_16 = 0;
                    while (_local_16 < map.numChildren)
                    {
                        _local_17 = (map.getChildAt(_local_16) as MovieClip);
                        if (((!(_local_17 == null)) && (!(_local_17.toString().indexOf("Pad") == -1))))
                        {
                            if (_local_17.name != "Spawn")
                            {
                                TrickOrTreatPad = _local_17.name;
                                break;
                            }
                        }
                        _local_16++;
                    }
                    _local_12 = [];
                    _local_13 = getMonsters(1);
                    for each (_local_14 in _local_13)
                    {
                        _local_14.pMC = createMonsterMC(map[TrickOrTreatPad], _local_14.objData.MonID, _local_7);
                        _local_14.pMC.scale(SCALE);
                        _local_14.pMC.pAV = _local_14;
                        _local_14.pMC.setData();
                        if (_local_14.dataLeaf == null)
                        {
                            TRASH.addChild(_local_14.pMC);
                        }
                        else
                        {
                            if (rootClass.litePreference.data.bMonsType)
                            {
                                _local_14.pMC.pname.typ.text = (("< " + _local_14.pMC.pAV.objData.sRace) + " >");
                                _local_14.pMC.pname.typ.visible = (!(_local_14.pMC.pAV.objData.sRace == "None"));
                            }
                            else
                            {
                                _local_14.pMC.pname.typ.visible = false;
                            }
                        }
                    }
                    player_npc_pos = new Point(map[TrickOrTreatPad].x, map[TrickOrTreatPad].y);
                }
            }
            if (((strFrame == "Enter") && (strMapName == "caroling")))
            {
                if (((CarolingMonsterKillCount >= 5) && (!(CHARS.getChildByName("mcPlayerNPCCaroling")))))
                {
                    loadPlayerNPC();
                }
                else
                {
                    CarolingPad = "Spawn";
                    _local_16 = 0;
                    while (_local_16 < map.numChildren)
                    {
                        _local_17 = (map.getChildAt(_local_16) as MovieClip);
                        if (((!(_local_17 == null)) && (!(_local_17.toString().indexOf("Pad") == -1))))
                        {
                            if (_local_17.name != "Spawn")
                            {
                                CarolingPad = _local_17.name;
                                break;
                            }
                        }
                        _local_16++;
                    }
                    _local_12 = [];
                    _local_13 = getMonsters(1);
                    for each (_local_14 in _local_13)
                    {
                        _local_14.pMC = createMonsterMC(map[CarolingPad], _local_14.objData.MonID, _local_7);
                        _local_14.pMC.scale(SCALE);
                        _local_14.pMC.pAV = _local_14;
                        _local_14.pMC.setData();
                        if (_local_14.dataLeaf == null)
                        {
                            TRASH.addChild(_local_14.pMC);
                        }
                        else
                        {
                            if (rootClass.litePreference.data.bMonsType)
                            {
                                _local_14.pMC.pname.typ.text = (("< " + _local_14.pMC.pAV.objData.sRace) + " >");
                                _local_14.pMC.pname.typ.visible = (!(_local_14.pMC.pAV.objData.sRace == "None"));
                            }
                            else
                            {
                                _local_14.pMC.pname.typ.visible = false;
                            }
                        }
                        break;
                    }
                    player_npc_pos = new Point(map[CarolingPad].x, map[CarolingPad].y);
                }
            }
            buildBoundingRects();
            if (map.bounds != null)
            {
                mapBoundsMC = (map.getChildByName("bounds") as MovieClip);
            }
            if (!rootClass.litePreference.data.bSmoothBG)
            {
                rebuildMapBMP(map);
            }
            playerInit();
            updateMonsters();
            updateDatabaseNPCs();
            scheduleLegacyMapArrowSweep();
            updateDatabaseMapArrows();
            updatePadNames();
            mapScrollCheck();
            if (objHouseData != null)
            {
                updateHouseItems();
            }
        }

        private function scheduleLegacyMapArrowSweep():void
        {
            legacyMapArrowSweepFrames = 16;
            hideLegacyMapArrows();

            if (!legacyMapArrowSweepActive)
            {
                legacyMapArrowSweepActive = true;
                addEventListener(Event.ENTER_FRAME, onLegacyMapArrowSweep, false, 0, true);
            }
        }

        private function onLegacyMapArrowSweep(event:Event):void
        {
            hideLegacyMapArrows();
            legacyMapArrowSweepFrames--;

            if (legacyMapArrowSweepFrames <= 0)
            {
                legacyMapArrowSweepActive = false;
                removeEventListener(Event.ENTER_FRAME, onLegacyMapArrowSweep);
            }
        }

        private function hideLegacyMapArrows():void
        {
            if (map == null)
            {
                return;
            }
            hideLegacyMapArrowsRecursive(map);
        }

        private function hideLegacyMapArrowsRecursive(container:DisplayObjectContainer):void
        {
            var i:int;
            var child:DisplayObject;
            var className:String;

            if (container == null)
            {
                return;
            }

            for (i = container.numChildren - 1; i >= 0; i--)
            {
                child = container.getChildAt(i);
                if (child == null)
                {
                    continue;
                }

                try
                {
                    className = getQualifiedClassName(child);
                    if (isLegacyMapArrowClass(className))
                    {
                        child.visible = false;
                        child.alpha = 0;
                        child.mouseEnabled = false;

                        if (child is DisplayObjectContainer)
                        {
                            DisplayObjectContainer(child).mouseChildren = false;
                        }
                        continue;
                    }
                }
                catch (classError:Error)
                {
                }

                if (child is DisplayObjectContainer)
                {
                    hideLegacyMapArrowsRecursive(DisplayObjectContainer(child));
                }
            }
        }

        private function isLegacyMapArrowClass(className:String):Boolean
        {
            if (className == null)
            {
                return false;
            }

            className = className.toLowerCase();

            return (
                className.indexOf("mcarrow_1446") >= 0 ||
                className.indexOf("mcarrowdisplay_1445") >= 0 ||
                className.indexOf("plate_232") >= 0 ||
                className.indexOf("plate_234") >= 0
            );
        }


        /** Build database-driven transition arrows for the active map frame. */
        public function updateDatabaseMapArrows():void
        {
            var row:Object;
            var arrow:DatabaseMapArrow;

            clearDatabaseMapArrows();
            if (mapArrows == null || map == null)
            {
                return;
            }

            for each (row in mapArrows)
            {
                if (row == null || String(row.strFrame).toLowerCase() != String(strFrame).toLowerCase())
                {
                    continue;
                }

                try
                {
                    arrow = new DatabaseMapArrow(this, row);
                    arrow.x = Number(row.X);
                    arrow.y = Number(row.Y);
                    map.addChild(arrow);
                    databaseMapArrowActors.push(arrow);
                }
                catch (arrowError:Error)
                {
                    trace("Database map arrow error: " + arrowError.message);
                }
            }
        }

        public function clearDatabaseMapArrows():void
        {
            var arrow:DatabaseMapArrow;
            while (databaseMapArrowActors.length > 0)
            {
                arrow = databaseMapArrowActors.pop() as DatabaseMapArrow;
                if (arrow == null)
                {
                    continue;
                }
                try
                {
                    arrow.dispose();
                    if (arrow.parent != null)
                    {
                        arrow.parent.removeChild(arrow);
                    }
                }
                catch (arrowError:Error)
                {
                }
            }
        }

        /**
         * Build database NPC actors for the active map frame.
         *
         * Protocol contract:
         *  npcBranch: NpcID, NpcMapID, runtime HP/MP/state/level
         *  npcdef:    NpcID definition values
         *  npcmap:    strUsername, NpcID, NpcMapID, strFrame, X/Y, strTurn,
         *             strDialog, strJob, strGender, colors, eqp, buttons
         */
        public function updateDatabaseNPCs():void
        {
            var row:Object;
            var branch:Object;
            var def:Object;
            var avt:Avatar;
            var mc:AvatarMC;
            var key:String;
            var uid:int;
            var mapID:int;
            var npcID:int;
            var gender:String;
            var leaf:Object;
            var data:Object;
            var eqp:Object;

            clearDatabaseNPCs();

            if (((npcmap == null) || (npcmap.length == 0)))
            {
                return;
            }

            for each (row in npcmap)
            {
                if (row == null)
                {
                    continue;
                }
                if ((("strFrame" in row) && (String(row.strFrame) != strFrame)))
                {
                    continue;
                }

                mapID = int(("NpcMapID" in row) ? row.NpcMapID : 0);
                npcID = int(("NpcID" in row) ? row.NpcID : 0);
                if (mapID <= 0)
                {
                    continue;
                }

                branch = getDatabaseNPCBranch(mapID);
                def = getDatabaseNPCDefinition(npcID);
                uid = -(1000000 + mapID);
                key = ("__dbnpc_" + mapID);

                leaf = {};
                leaf.uoName = key;
                leaf.entID = uid;
                leaf.entType = "n";
                leaf.strFrame = (("strFrame" in row) ? String(row.strFrame) : strFrame);
                leaf.strPad = "none";
                leaf.tx = Number(("X" in row) ? row.X : 0);
                leaf.ty = Number(("Y" in row) ? row.Y : 0);
                leaf.px = leaf.tx;
                leaf.py = leaf.ty;
                leaf.sp = 0;
                leaf.mvts = 0;
                leaf.mvtd = 0;
                leaf.intState = int(((branch != null) && ("intState" in branch)) ? branch.intState : 1);
                leaf.intLevel = int(((branch != null) && ("iLvl" in branch)) ? branch.iLvl : (((def != null) && ("intLevel" in def)) ? def.intLevel : 1));
                leaf.intHP = int(((branch != null) && ("intHP" in branch)) ? branch.intHP : 0);
                leaf.intHPMax = int(((branch != null) && ("intHPMax" in branch)) ? branch.intHPMax : leaf.intHP);
                leaf.intMP = int(((branch != null) && ("intMP" in branch)) ? branch.intMP : 0);
                leaf.intMPMax = int(((branch != null) && ("intMPMax" in branch)) ? branch.intMPMax : leaf.intMP);
                leaf.showHelm = true;
                leaf.showCloak = true;
                leaf.afk = false;
                leaf.targets = {};
                leaf.auras = [];
                uoTree[key] = leaf;

                avt = new Avatar(rootClass);
                avt.uid = uid;
                avt.pnm = key;
                avt.npcType = "npc";
                avt.npcData = row;
                avt.dataLeaf = leaf;

                mc = createAvatarMC(uid);
                mc.pAV = avt;
                mc.world = this;
                avt.pMC = mc;
                npcAvatars[String(mapID)] = avt;

                CHARS.addChild(mc);
                mc.x = Number(("X" in row) ? row.X : 0);
                mc.y = Number(("Y" in row) ? row.Y : 0);
                mc.px = mc.x;
                mc.py = mc.y;
                mc.tx = mc.x;
                mc.ty = mc.y;
                mc.sp = 0;
                mc.scale(SCALE);

                gender = String(("strGender" in row) ? row.strGender : "M").toUpperCase();
                gender = ((gender.charAt(0) == "F") ? "F" : "M");
                eqp = (("eqp" in row) && (row.eqp != null)) ? row.eqp : {};

                data = {};
                data.strUsername = String(("strUsername" in row) ? row.strUsername : ("NPC " + npcID));
                data.strGender = gender;
                data.strHairFilename = String(("strHairFilename" in row) ? row.strHairFilename : "");
                data.strHairName = String(("strHairName" in row) ? row.strHairName : "");
                data.strClassName = String(("strJob" in row) ? row.strJob : "NPC");
                data.intLevel = leaf.intLevel;
                data.intAccessLevel = 1;
                data.iCP = 0;
                data.iRank = 1;
                data.iUpg = 0;
                data.iUpgDays = 0;
                data.intColorHair = databaseNPCColor(row, "intColorHair", 0);
                data.intColorSkin = databaseNPCColor(row, "intColorSkin", 0xE2C3A3);
                data.intColorEye = databaseNPCColor(row, "intColorEye", 0);
                data.intColorBase = databaseNPCColor(row, "intColorBase", 0);
                data.intColorTrim = databaseNPCColor(row, "intColorTrim", 0);
                data.intColorAccessory = databaseNPCColor(row, "intColorAccessory", 0);
                data.eqp = eqp;
                data.guild = null;
                data.title = null;
                data.dbNPC = true;
                data.dbNpcMapID = mapID;
                data.dbNpcID = npcID;
                data.dbDialog = String(("strDialog" in row) ? row.strDialog : "");
                data.dbJob = String(("strJob" in row) ? row.strJob : "");
                data.dbButtons = (("buttons" in row) && (row.buttons != null)) ? row.buttons : [];
                data.dbImage = String(
                    (("strImage" in row) && (row.strImage != null) && (String(row.strImage) != ""))
                        ? row.strImage
                        : ((("Image" in row) && (row.Image != null)) ? row.Image : "")
                );
                data.dbImageScale = databaseNPCNumber(row, "ImageScale", 1);
                data.dbImageOffsetX = databaseNPCNumber(row, "ImageOffsetX", 0);
                data.dbImageOffsetY = databaseNPCNumber(row, "ImageOffsetY", 0);

                avt.initAvatar({"data":data});

                // NPC job replaces the guild line in the regular AvatarMC name plate.
                if (data.dbJob != "")
                {
                    mc.pname.tg.text = (("< " + data.dbJob) + " >");
                }
                else
                {
                    mc.pname.tg.text = "";
                }
                mc.pname.tt.text = "";
                mc.hpBar.visible = false;

                if (("strTurn" in row))
                {
                    mc.turn(String(row.strTurn).toLowerCase());
                }
                else if (("Turn" in row))
                {
                    mc.turn(String(row.Turn).toLowerCase());
                }
                else
                {
                    mc.turn("right");
                }

                // Blank Image = use the normal SWF/equipment NPC exactly as before.
                // A valid PNG/JPG/JPEG/GIF replaces only the visible character body.
                if (data.dbImage != "" && databaseNPCIsStaticImagePath(data.dbImage))
                {
                    loadDatabaseNPCImage(avt, row);
                }
            }

        }

        /** Numeric database NPC helper with a safe fallback. */
        private function databaseNPCNumber(row:Object, field:String, fallback:Number):Number
        {
            var value:Number;
            if (((row == null) || (!(field in row)) || (row[field] == null) || (String(row[field]) == "")))
            {
                return fallback;
            }
            value = Number(row[field]);
            if (isNaN(value))
            {
                return fallback;
            }
            return value;
        }

        /** Static-image mode must never consume an SWF-backed NPC. */
        private function databaseNPCIsStaticImagePath(value:String):Boolean
        {
            var path:String = ((value == null) ? "" : String(value).toLowerCase());
            var q:int;
            var hash:int;
            if (path == "")
            {
                return false;
            }
            q = path.indexOf("?");
            if (q >= 0)
            {
                path = path.substr(0, q);
            }
            hash = path.indexOf("#");
            if (hash >= 0)
            {
                path = path.substr(0, hash);
            }
            return (path.lastIndexOf(".png") == path.length - 4 ||
                    path.lastIndexOf(".jpg") == path.length - 4 ||
                    path.lastIndexOf(".jpeg") == path.length - 5 ||
                    path.lastIndexOf(".gif") == path.length - 4);
        }

        /** Resolve a database NPC image path relative to gamefiles/. */
        private function databaseNPCImageURL(value:String):String
        {
            var url:String = (value == null) ? "" : value.replace(/\\/g, "/");
            var lower:String;
            while (url.length > 0 && url.charAt(0) == "/")
            {
                url = url.substr(1);
            }
            lower = url.toLowerCase();
            if (lower.indexOf("http://") == 0 || lower.indexOf("https://") == 0)
            {
                return url;
            }
            if (lower.indexOf("gamefiles/") == 0)
            {
                url = url.substr(10);
            }
            return (rootClass.getFilePath() + url);
        }

        /**
         * Load a normal bitmap image as the database NPC's visible body.
         *
         * The actual Avatar and AvatarMC stay alive. That is important because the
         * rest of this current Aera World.as already uses them for proximity checks,
         * NPC popup ownership, name/job plates, buttons, quests, and shops.
         */
        private function loadDatabaseNPCImage(avt:Avatar, row:Object):void
        {
            var mc:AvatarMC;
            var holder:Sprite;
            var loader:Loader;
            var imagePath:String;
            var imageURL:String;
            var mapID:int;

            if (((avt == null) || (avt.pMC == null) || (row == null)))
            {
                return;
            }

            imagePath = String(
                (("strImage" in row) && (row.strImage != null) && (String(row.strImage) != ""))
                    ? row.strImage
                    : ((("Image" in row) && (row.Image != null)) ? row.Image : "")
            );
            if (imagePath == "" || !databaseNPCIsStaticImagePath(imagePath))
            {
                return;
            }

            imageURL = databaseNPCImageURL(imagePath);
            if (imageURL == "")
            {
                return;
            }

            mc = avt.pMC;
            mapID = int(("NpcMapID" in row) ? row.NpcMapID : 0);

            holder = new Sprite();
            holder.name = ("dbNpcImage_" + mapID);
            holder.mouseEnabled = true;
            holder.mouseChildren = false;
            holder.buttonMode = true;
            holder.useHandCursor = true;

            loader = new Loader();
            loader.name = ("dbNpcImageLoader_" + mapID);
            loader.mouseEnabled = false;
            holder.addChild(loader);

            try
            {
                // Put the image in the character visual band while keeping the
                // existing Aera name/job plate and other AvatarMC UI above it.
                mc.addChildAt(holder, mc.getChildIndex(mc.mcChar));
            }
            catch (depthError:Error)
            {
                mc.addChild(holder);
            }

            databaseNPCImageOwners[holder] = avt;
            databaseNPCImageContexts[loader.contentLoaderInfo] = {
                "avt":avt,
                "row":row,
                "holder":holder,
                "loader":loader
            };

            holder.addEventListener(MouseEvent.CLICK, onDatabaseNPCImageClick, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDatabaseNPCImageComplete, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onDatabaseNPCImageError, false, 0, true);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDatabaseNPCImageError, false, 0, true);

            try
            {
                loader.load(new URLRequest(imageURL));
            }
            catch (e:Error)
            {
                databaseNPCImageFailed(loader.contentLoaderInfo);
                trace(("[DatabaseNPC] Image load failed: " + imageURL + " :: " + e.message));
            }
        }

        private function onDatabaseNPCImageComplete(evt:Event):void
        {
            var info:Object = databaseNPCImageContexts[evt.currentTarget];
            var avt:Avatar;
            var row:Object;
            var holder:Sprite;
            var loader:Loader;
            var mc:AvatarMC;
            var imageScale:Number;
            var offsetX:Number;
            var offsetY:Number;
            var turn:String;
            var bodyWidth:Number;
            var bodyHeight:Number;
            var topY:Number;

            if (info == null)
            {
                return;
            }

            avt = info.avt as Avatar;
            row = info.row;
            holder = info.holder as Sprite;
            loader = info.loader as Loader;

            if (((avt == null) || (avt.pMC == null) || (holder == null) || (loader == null)))
            {
                databaseNPCImageFailed(evt.currentTarget);
                return;
            }

            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDatabaseNPCImageComplete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onDatabaseNPCImageError);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDatabaseNPCImageError);

            if (loader.content is Bitmap)
            {
                Bitmap(loader.content).smoothing = true;
            }

            bodyWidth = loader.contentLoaderInfo.width;
            bodyHeight = loader.contentLoaderInfo.height;
            if (bodyWidth <= 0 || bodyHeight <= 0)
            {
                databaseNPCImageFailed(evt.currentTarget);
                return;
            }

            delete databaseNPCImageContexts[evt.currentTarget];

            imageScale = databaseNPCNumber(row, "ImageScale", 1);
            if (imageScale < 0.05)
            {
                imageScale = 0.05;
            }
            if (imageScale > 10)
            {
                imageScale = 10;
            }
            offsetX = databaseNPCNumber(row, "ImageOffsetX", 0);
            offsetY = databaseNPCNumber(row, "ImageOffsetY", 0);

            // AQW-style foot registration: center X, bottom Y at the database X/Y.
            loader.x = -(bodyWidth / 2);
            loader.y = -bodyHeight;
            holder.x = offsetX;
            holder.y = offsetY;
            holder.scaleY = imageScale;

            turn = String(("strTurn" in row) ? row.strTurn : (("Turn" in row) ? row.Turn : "Right")).toLowerCase();
            holder.scaleX = ((turn.indexOf("left") >= 0) ? -imageScale : imageScale);

            mc = avt.pMC;
            if (mc.mcChar != null)
            {
                mc.mcChar.visible = false;
            }

            // Keep the name/job plate above taller image NPCs.
            try
            {
                topY = (offsetY - (bodyHeight * imageScale) - 12);
                if (((mc.pname != null) && (mc.pname.y > topY)))
                {
                    mc.pname.y = topY;
                }
            }
            catch (nameError:Error)
            {
            }
        }

        private function onDatabaseNPCImageError(evt:Event):void
        {
            trace(("[DatabaseNPC] Image load error: " + evt));
            databaseNPCImageFailed(evt.currentTarget);
        }

        private function databaseNPCImageFailed(loaderInfo:Object):void
        {
            var info:Object = databaseNPCImageContexts[loaderInfo];
            var holder:Sprite;
            var loader:Loader;
            if (info == null)
            {
                return;
            }

            delete databaseNPCImageContexts[loaderInfo];
            holder = info.holder as Sprite;
            loader = info.loader as Loader;

            if (loader != null)
            {
                try
                {
                    loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDatabaseNPCImageComplete);
                    loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onDatabaseNPCImageError);
                    loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDatabaseNPCImageError);
                    loader.close();
                }
                catch (listenerError:Error)
                {
                }
            }

            if (holder != null)
            {
                holder.removeEventListener(MouseEvent.CLICK, onDatabaseNPCImageClick);
                delete databaseNPCImageOwners[holder];
                if (holder.parent != null)
                {
                    holder.parent.removeChild(holder);
                }
            }
            // The regular SWF/equipment avatar remains visible as fallback.
        }

        private function disposeDatabaseNPCImage(avt:Avatar):void
        {
            var loaderInfo:Object;
            var info:Object;
            var holder:Sprite;
            var loader:Loader;

            for (loaderInfo in databaseNPCImageContexts)
            {
                info = databaseNPCImageContexts[loaderInfo];
                if (((info == null) || (info.avt != avt)))
                {
                    continue;
                }

                holder = info.holder as Sprite;
                loader = info.loader as Loader;
                delete databaseNPCImageContexts[loaderInfo];

                if (loader != null)
                {
                    try
                    {
                        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDatabaseNPCImageComplete);
                        loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onDatabaseNPCImageError);
                        loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDatabaseNPCImageError);
                        loader.close();
                        loader.unload();
                    }
                    catch (loadError:Error)
                    {
                    }
                }

                if (holder != null)
                {
                    holder.removeEventListener(MouseEvent.CLICK, onDatabaseNPCImageClick);
                    delete databaseNPCImageOwners[holder];
                    if (holder.parent != null)
                    {
                        holder.parent.removeChild(holder);
                    }
                }
            }

            // Completed loaders are no longer in the context dictionary. Remove
            // their holder by name from this NPC's current AvatarMC as well.
            if (((avt != null) && (avt.pMC != null) && (avt.npcData != null)))
            {
                holder = avt.pMC.getChildByName("dbNpcImage_" + int(("NpcMapID" in avt.npcData) ? avt.npcData.NpcMapID : 0)) as Sprite;
                if (holder != null)
                {
                    holder.removeEventListener(MouseEvent.CLICK, onDatabaseNPCImageClick);
                    delete databaseNPCImageOwners[holder];
                    if (holder.parent != null)
                    {
                        holder.parent.removeChild(holder);
                    }
                }
            }
        }

        private function onDatabaseNPCImageClick(evt:MouseEvent):void
        {
            var holder:Sprite = evt.currentTarget as Sprite;
            var avt:Avatar;
            if (holder == null)
            {
                return;
            }
            avt = databaseNPCImageOwners[holder] as Avatar;
            if (avt != null)
            {
                openDatabaseNPC(avt);
            }
        }

        private function databaseNPCColor(row:Object, field:String, fallback:int):int
        {
            var value:*;
            var text:String;
            if (((row == null) || (!(field in row)) || (row[field] == null) || (String(row[field]) == "")))
            {
                return fallback;
            }
            value = row[field];
            if ((value is Number))
            {
                return int(value);
            }
            text = String(value);
            if (((text.indexOf("0x") == 0) || (text.indexOf("0X") == 0)))
            {
                return int(parseInt(text.substr(2), 16));
            }
            if (text.charAt(0) == "#")
            {
                return int(parseInt(text.substr(1), 16));
            }
            return int(Number(text));
        }

        private function getDatabaseNPCBranch(mapID:int):Object
        {
            var row:Object;
            if (npcBranch == null)
            {
                return null;
            }
            for each (row in npcBranch)
            {
                if (((row != null) && (int(row.NpcMapID) == mapID)))
                {
                    return row;
                }
            }
            return null;
        }

        private function getDatabaseNPCDefinition(npcID:int):Object
        {
            var row:Object;
            if (npcdef == null)
            {
                return null;
            }
            for each (row in npcdef)
            {
                if (((row != null) && (int(row.NpcID) == npcID)))
                {
                    return row;
                }
            }
            return null;
        }

        public function clearDatabaseNPCs():void
        {
            var id:String;
            var avt:Avatar;
            for (id in npcAvatars)
            {
                avt = (npcAvatars[id] as Avatar);
                if (avt == null)
                {
                    continue;
                }
                disposeDatabaseNPCImage(avt);
                if (((avt.pMC != null) && (avt.pMC.parent != null)))
                {
                    try
                    {
                        avt.pMC.fClose();
                    }
                    catch(e:Error)
                    {
                        try
                        {
                            avt.pMC.parent.removeChild(avt.pMC);
                        }
                        catch(e2:Error)
                        {
                        }
                    }
                }
                if (((avt.pnm != null) && (avt.pnm in uoTree)))
                {
                    delete uoTree[avt.pnm];
                }
            }
            npcAvatars = {};
        }

        /**
         * Press-E interaction for database NPCs.
         * Returns true when a nearby NPC was found/opened.
         */
        public function openNearestDatabaseNPC(maxDistance:Number=150):Boolean
        {
            var id:String;
            var avt:Avatar;
            var nearest:Avatar = null;
            var best:Number = (maxDistance * maxDistance);
            var dx:Number;
            var dy:Number;
            var distanceSquared:Number;

            if (((myAvatar == null) || (myAvatar.pMC == null) || (npcAvatars == null)))
            {
                return false;
            }

            if (databaseNPCPanelIsOpen())
            {
                return true;
            }

            for (id in npcAvatars)
            {
                avt = (npcAvatars[id] as Avatar);
                if (((avt == null) || (avt.pMC == null) || (avt.pMC.parent == null)))
                {
                    continue;
                }
                if (((avt.dataLeaf != null) && ("strFrame" in avt.dataLeaf) && (String(avt.dataLeaf.strFrame) != strFrame)))
                {
                    continue;
                }

                dx = (avt.pMC.x - myAvatar.pMC.x);
                dy = (avt.pMC.y - myAvatar.pMC.y);
                distanceSquared = ((dx * dx) + (dy * dy));

                if (distanceSquared <= best)
                {
                    best = distanceSquared;
                    nearest = avt;
                }
            }

            if (nearest == null)
            {
                return false;
            }

            openDatabaseNPC(nearest);
            return true;
        }

        private function databaseNPCPanelIsOpen():Boolean
        {
            var i:int;
            var container:*;

            try
            {
                if (((rootClass != null) && (rootClass.ui != null) && (rootClass.ui.ModalStack != null)))
                {
                    container = rootClass.ui.ModalStack;
                    i = 0;
                    while (i < container.numChildren)
                    {
                        if (container.getChildAt(i) is DatabaseNPCPanel)
                        {
                            return true;
                        }
                        i++;
                    }
                }
            }
            catch(e:Error)
            {
            }

            return false;
        }

        /**
         * Close the currently open database NPC panel.
         * Used by the Escape key.
         */
        public function closeDatabaseNPCPanel():Boolean
        {
            var i:int;
            var container:*;
            var panel:DatabaseNPCPanel;

            try
            {
                if (((rootClass == null) || (rootClass.ui == null) || (rootClass.ui.ModalStack == null)))
                {
                    return false;
                }

                container = rootClass.ui.ModalStack;
                i = (container.numChildren - 1);

                while (i >= 0)
                {
                    if (container.getChildAt(i) is DatabaseNPCPanel)
                    {
                        panel = (container.getChildAt(i) as DatabaseNPCPanel);
                        panel.close();
                        return true;
                    }
                    i--;
                }
            }
            catch(e:Error)
            {
            }

            return false;
        }

        public function openDatabaseNPC(avt:Avatar):void
        {
            var panel:DatabaseNPCPanel;
            if (((avt == null) || (avt.npcType != "npc") || (avt.objData == null)))
            {
                return;
            }
            if (databaseNPCPanelIsOpen())
            {
                return;
            }
            rootClass.menuClose();
            if (rootClass.ui == null)
            {
                return;
            }
            panel = new DatabaseNPCPanel(rootClass, avt);
            if (rootClass.ui.ModalStack != null)
            {
                rootClass.ui.ModalStack.addChild(panel);
            }
            else
            {
                rootClass.addChild(panel);
            }
        }

        /** Execute a database NPC button using stock client APIs. */
        public function executeDatabaseNPCButton(button:Object, avt:Avatar):void
        {
            var action:String;
            var value:String;
            var parts:Array;
            var mapName:String;
            var cell:String;
            var pad:String;
            if (button == null)
            {
                return;
            }
            action = String(("strAction" in button) ? button.strAction : (("Action" in button) ? button.Action : "")).toLowerCase();
            value = String(("strValue" in button) ? button.strValue : (("Value" in button) ? button.Value : ""));

            switch (action)
            {
                case "shop":
                    sendLoadShopRequest(int(value));
                    break;
                case "hairshop":
                case "hair shop":
                    sendLoadHairShopRequest(int(value));
                    break;
                case "enhancement":
                case "enhanceshop":
                case "enhancementshop":
                    sendLoadEnhShopRequest(int(value));
                    break;
                case "quest":
                case "quests":
                    showQuests(value, "q");
                    break;
                case "join":
                    // Accept map, map|cell|pad, map,cell,pad, or map:cell:pad.
                    parts = value.split("|");
                    if (parts.length < 2)
                    {
                        parts = value.split(",");
                    }
                    if (parts.length < 2)
                    {
                        parts = value.split(":");
                    }
                    mapName = ((parts.length > 0) ? String(parts[0]) : value);
                    cell = ((parts.length > 1) ? String(parts[1]) : "Enter");
                    pad = ((parts.length > 2) ? String(parts[2]) : "Spawn");
                    gotoTown(mapName, cell, pad);
                    break;
                case "bank":
                    sendLoadBankRequest(["*"]);
                    break;
                case "auction":
                    sendLoadAuctionRequest(["*"]);
                    break;
                case "guildlist":
                case "guild list":
                    showGuildList();
                    break;
                case "redeem":
                    rootClass.toggleRedeemCode();
                    break;
                case "outfits":
                    rootClass.toggleOutfits();
                    break;
                case "dailylogin":
                case "daily login":
                case "worldboss":
                case "world boss":
                case "battlepass":
                case "battle pass":
                    // These labels existed in legacy NPC editors, but this Aera
                    // client/server build has no matching request/UI contract.
                    // Keep the button visible without fabricating an unsupported XT request.
                    rootClass.MsgBox.notify(("NPC action is not enabled in this client build: " + action));
                    break;
                default:
                    rootClass.MsgBox.notify(("Unknown NPC action: " + String(("strAction" in button) ? button.strAction : button.Action)));
                    break;
            }
        }

        public function loadPlayerNPC():void
        {
            if (strMapName == "caroling")
            {
                if (loaderD.hasDefinition("PlayerNPCCaroling"))
                {
                    onPlayerNPCComplete();
                    return;
                }
            }
            else
            {
                if (loaderD.hasDefinition("PlayerNPCTrickOrTreat"))
                {
                    onPlayerNPCComplete();
                    return;
                }
            }
            var _local_1:Loader = new Loader();
            _local_1.contentLoaderInfo.addEventListener(Event.COMPLETE, onPlayerNPCComplete, false, 0, true);
            if (strMapName == "caroling")
            {
                _local_1.load(new URLRequest((rootClass.getFilePath() + "items/house/PlayerNPC_Caroling.swf")), loaderC);
            }
            else
            {
                _local_1.load(new URLRequest((rootClass.getFilePath() + "items/house/PlayerNPC_TrickOrTreat.swf")), loaderC);
            }
        }

        private function onPlayerNPCComplete(_arg_1:Event=null):void
        {
            var _local_2:Class;
            if (strMapName == "caroling")
            {
                _local_2 = (loaderD.getDefinition("PlayerNPCCaroling") as Class);
            }
            else
            {
                _local_2 = (loaderD.getDefinition("PlayerNPCTrickOrTreat") as Class);
            }
            var _local_3:* = new (_local_2)();
            _local_3.x = player_npc_pos.x;
            _local_3.y = player_npc_pos.y;
            if (_local_3.x > myAvatar.pMC.x)
            {
                _local_3.scaleX = (_local_3.scaleX * -1);
            }
            var _local_4:MovieClip = (CHARS.addChild(_local_3) as MovieClip);
            _local_4.name = ("mc" + getQualifiedClassName(_local_4));
            _local_4.isProp = true;
        }

        private function buildBoundingRects():void
        {
            var _local_2:Rectangle;
            var _local_3:MovieClip;
            var _local_1:int;
            arrEventR = [];
            arrSolidR = [];
            _local_1 = 0;
            while (_local_1 < arrEvent.length)
            {
                _local_3 = arrEvent[_local_1];
                _local_2 = _local_3.getBounds(rootClass.stage);
                arrEventR.push(_local_2);
                _local_1++;
            }
            _local_1 = 0;
            while (_local_1 < arrSolid.length)
            {
                _local_3 = arrSolid[_local_1];
                _local_2 = _local_3.getBounds(rootClass.stage);
                arrSolidR.push(_local_2);
                _local_1++;
            }
        }

        public function killWalkObjects():void
        {
            var _local_2:DisplayObject;
            var _local_1:int;
            while (_local_1 < map.numChildren)
            {
                _local_2 = map.getChildAt(_local_1);
                if (((_local_2 is MovieClip) && (MovieClip(_local_2).isEvent)))
                {
                    removeEventListener("enter", MovieClip(_local_2).onEnter);
                }
                _local_1++;
            }
        }

        public function exitQuest():void
        {
            if (returnInfo != null)
            {
                rootClass.sfc.sendXtMessage("zm", "cmd", ["tfer", rootClass.sfc.myUserName, returnInfo.strMap, returnInfo.strCell, returnInfo.strPad], "str", curRoom);
            }
        }

        public function gotoTown(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            var _local_4:* = uoTree[rootClass.sfc.myUserName];
            if (_local_4.intState == 0)
            {
                rootClass.chatF.pushMsg("warning", "You are dead!", "SERVER", "", 0);
            }
            else
            {
                if (((!(rootClass.world.myAvatar.invLoaded)) || (!(rootClass.world.myAvatar.pMC.artLoaded()))))
                {
                    rootClass.MsgBox.notify("Character still being loaded.");
                }
                else
                {
                    if (coolDown("tfer"))
                    {
                        rootClass.MsgBox.notify(("Joining " + _arg_1));
                        setReturnInfo(_arg_1, _arg_2, _arg_3);
                        rootClass.sfc.sendXtMessage("zm", "cmd", ["tfer", rootClass.sfc.myUserName, _arg_1, _arg_2, _arg_3], "str", curRoom);
                        if (((strAreaName.indexOf("battleon") < 0) || (strAreaName.indexOf("battleontown") > -1)))
                        {
                            rootClass.menuClose();
                        }
                    }
                    else
                    {
                        rootClass.MsgBox.notify("You must wait 5 seconds before joining another map.");
                    }
                }
            }
        }

        public function gotoQuest(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            gotoTown(_arg_1, _arg_2, _arg_3);
        }

        public function openApop(_arg_1:*):*
        {
            var _local_2:MovieClip;
            if (((isMovieFront("Apop")) || ((!("frame" in _arg_1)) || (("frame" in _arg_1) && ("cnt" in _arg_1)))))
            {
                rootClass.menuClose();
                _local_2 = attachMovieFront("Apop");
                _local_2.update(_arg_1);
            }
        }

        public function setSpawnPoint(_arg_1:*, _arg_2:*):void
        {
            spawnPoint.strFrame = _arg_1;
            spawnPoint.strPad = _arg_2;
        }

        public function resetSpawnPoint():void
        {
            spawnPoint.strFrame = "Enter";
            spawnPoint.strPad = "Spawn";
        }

        public function initObjExtra(_arg_1:String):void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Array;
            objExtra = {};
            if (((!(_arg_1 == null)) && (!(_arg_1 == ""))))
            {
                _local_2 = _arg_1.split(",");
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _local_4 = _local_2[_local_3].split("=");
                    objExtra[_local_4[0]] = _local_4[1];
                    _local_3++;
                }
            }
        }

        public function initObjInfo(_arg_1:String):void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Array;
            objInfo = {};
            if (((!(_arg_1 == null)) && (!(_arg_1 == ""))))
            {
                _local_2 = _arg_1.split(",");
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _local_4 = _local_2[_local_3].split("=");
                    objInfo[_local_4[0]] = _local_4[1];
                    _local_3++;
                }
            }
        }

        private function rasterize(_arg_1:Array, _arg_2:Boolean=false):void
        {
            var _local_5:Object;
            var _local_6:Point;
            var _local_7:Matrix;
            var _local_8:String;
            var _local_9:DisplayObject;
            mapNW = rootClass.stage.stageWidth;
            var _local_3:Number = (mapNW / mapW);
            var _local_4:int;
            mapNH = Math.round((mapH * _local_3));
            for each (_local_5 in _arg_1)
            {
                _local_5.child.x = _local_5.x;
                if (_local_5.bmd != null)
                {
                    _local_5.bmd.dispose();
                }
                _local_5.bmd = new BitmapData(mapNW, mapNH, true, 0x999999);
                _local_6 = new Point(0, 0);
                _local_6 = _local_5.child.globalToLocal(_local_6);
                _local_7 = new Matrix((_local_3 * _local_5.child.transform.matrix.a), 0, 0, (_local_3 * _local_5.child.transform.matrix.d), -((_local_6.x * _local_3) * _local_5.child.transform.matrix.a), -((_local_6.y * _local_3) * _local_5.child.transform.matrix.d));
                _local_5.bmd.draw(_local_5.child, _local_7, _local_5.child.transform.colorTransform, null, new Rectangle(0, 0, mapNW, mapNH), false);
                _local_5.bm = new Bitmap(_local_5.bmd);
                _local_8 = String(("bmp" + _local_4));
                _local_9 = _local_5.child.parent.getChildByName(_local_8);
                if (_local_9 != null)
                {
                    _local_5.child.parent.removeChild(_local_9);
                }
                _local_5.bmDO = _local_5.child.parent.addChildAt(_local_5.bm, (_local_5.child.parent.getChildIndex(_local_5.child) + 1));
                _local_5.bmDO.name = _local_8;
                _local_5.bmDO.width = mapW;
                _local_5.bmDO.height = mapH;
                _local_5.child.visible = false;
                if (_arg_2)
                {
                    _local_5.child.x = (_local_5.child.x + 1200);
                }
                _local_4++;
            }
        }

        private function rebuildMapBMP(_arg_1:MovieClip):void
        {
            var _local_2:MovieClip;
            var _local_3:int;
            clearMapBmps();
            _local_3 = 0;
            while (_local_3 < _arg_1.numChildren)
            {
                _local_2 = (_arg_1.getChildAt(_local_3) as MovieClip);
                if (((((((((((((_local_2 is MovieClip) && (_local_2.width >= 960)) && (_local_2.name.toLowerCase().indexOf("bmp") == -1)) && (_local_2.name.toLowerCase().indexOf("cs") == -1)) && (_local_2.name.toLowerCase().indexOf("bounds") == -1)) && (((_local_2 as MovieClip) == null) || (MovieClip(_local_2).totalFrames < 15))) && (!("isSolid" in _local_2))) && (!("isFloor" in _local_2))) && (!("isWall" in _local_2))) && (!("walk" in _local_2))) && (!("btnSkip" in _local_2))) && (!("noBmp" in _local_2))))
                {
                    mapBmps.push({
                        "child":_local_2,
                        "x":_local_2.x,
                        "bmDO":null
                    });
                }
                _local_3++;
            }
            rasterize(mapBmps);
        }

        private function mapResizeCheck(_arg_1:TimerEvent):void
        {
            if (((!(map == null)) && (mapBmps.length > 0)))
            {
                if (mapNW != rootClass.stage.stageWidth)
                {
                    rasterize(mapBmps);
                }
            }
        }

        private function clearMapBmps():void
        {
            var _local_1:Object;
            if (mapBmps.length > 0)
            {
                for each (_local_1 in mapBmps)
                {
                    _local_1.bmDO.parent.removeChild(_local_1.bmDO);
                    if (_local_1.bmd != null)
                    {
                        _local_1.bmd.dispose();
                    }
                    _local_1.child = null;
                    _local_1.bmd = null;
                    _local_1.bm = null;
                }
            }
            mapBmps = [];
        }

        public function initMap():mapData
        {
            mData = new mapData(rootClass);
            return (mData);
        }

        public function initCutscenes():cutsceneHandler
        {
            cHandle = new cutsceneHandler(rootClass);
            return (cHandle);
        }

        public function initSound(_arg_1:Sound):soundController
        {
            sController = new soundController(_arg_1, rootClass);
            return (sController);
        }

        public function gotoHouse(_arg_1:String):void
        {
            _arg_1 = _arg_1.toLowerCase();
            if ((((!(objHouseData == null)) && (objHouseData.unm == _arg_1)) && (strMapName == "house")))
            {
                return;
            }
            rootClass.sfc.sendXtMessage("zm", "house", [_arg_1], "str", 1);
        }

        public function isHouseEquipped():Boolean
        {
            var _local_1:int;
            while (_local_1 < myAvatar.houseitems.length)
            {
                if (myAvatar.houseitems[_local_1].bEquip)
                {
                    return true;
                }
                _local_1++;
            }
            return false;
        }

        public function isMyHouse():*
        {
            return (((!(objHouseData == null)) && (objHouseData.unm == myAvatar.objData.strUsername.toLowerCase())) && (strMapName == "house"));
        }

        public function showHouseOptions(_arg_1:String):void
        {
            var _local_2:MovieClip = rootClass.ui.mcPopup.mcHouseOptions;
            switch (_arg_1)
            {
                case "default":
                case "save":
                default:
                    _local_2.visible = true;
                    _local_2.bg.x = 0;
                    _local_2.cnt.x = 0;
                    _local_2.tTitle.x = 5;
                    _local_2.bExpand.x = 190;
                    _local_2.bg.visible = true;
                    _local_2.cnt.visible = true;
                    _local_2.tTitle.visible = true;
                    _local_2.bExpand.visible = false;
                    return;
                case "hide":
                    _local_2.visible = true;
                    _local_2.bg.x = 181;
                    _local_2.cnt.x = 181;
                    _local_2.tTitle.x = 186;
                    _local_2.bExpand.x = 120;
                    _local_2.bg.visible = false;
                    _local_2.cnt.visible = false;
                    _local_2.tTitle.visible = false;
                    _local_2.bExpand.visible = true;
            }
        }

        public function hideHouseOptions():void
        {
            var _local_2:int;
            var _local_1:MovieClip = rootClass.ui.mcPopup.mcHouseOptions;
            if (_local_1.visible)
            {
                _local_2 = 0;
                while (_local_2 < _local_1.numChildren)
                {
                    _local_1.getChildAt(_local_2).x = 190;
                    _local_2++;
                }
            }
            _local_1.visible = false;
        }

        public function onHouseOptionsDesignClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            toggleHouseEdit();
        }

        public function onHouseOptionsSaveClick(_arg_1:MouseEvent):void
        {
//            if (hasModified)
//            {
//                rootClass.mixer.playSound("Click");
//                saveHouseSetup();
//            }

            rootClass.mixer.playSound("Click");
            saveHouseSetup();
        }

        public function onHouseOptionsHideClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            showHouseOptions("hide");
        }

        public function onHouseOptionsExpandClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            showHouseOptions("default");
        }

        public function onHouseOptionsFloorClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            showHouseInventory(70);
        }

        public function onHouseOptionsWallClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            showHouseInventory(72);
        }

        public function onHouseOptionsMiscClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            showHouseInventory(73);
        }

        public function onHouseOptionsHouseReset(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            var _local_2:* = new ModalMC();
            var _local_3:* = {};
            _local_3.params = {};
            _local_3.strBody = "Are you sure you want to reset the entire house?";
            _local_3.callback = confirmClear;
            _local_3.btns = "dual";
            rootClass.ui.ModalStack.addChild(_local_2);
            _local_2.init(_local_3);
        }

        public function confirmClear(_arg_1:Object):void
        {
            var _local_2:int;
            var _local_3:DisplayObject;
            if (_arg_1.accept)
            {
                _local_2 = 0;
                while (_local_2 < CHARS.numChildren)
                {
                    _local_3 = CHARS.getChildAt(_local_2);
                    if (((_local_3.hasOwnProperty("isHouseItem")) && (MovieClip(_local_3).isHouseItem)))
                    {
                        CHARS.removeChild(_local_3);
                        _local_2--;
                    }
                    _local_2++;
                }
                objHouseData.sHouseInfo = "";
                objHouseData.arrPlacement = [];
                initEquippedItems(objHouseData.arrPlacement);
                sendSaveHouseSetup(objHouseData.sHouseInfo);
                rootClass.requestAPI("HouseSaveRoom", {"frame":"*"}, callbackC, callbackB, true);
            }
        }

        public function callbackC(_arg_1:Event):void
        {
            if (_arg_1.target.data == "cleared")
            {
                rootClass.addUpdate("House cleared successfully.");
                rootClass.chatF.pushMsg("server", "House cleared successfully.", "SERVER", "", 0);
                cleanEverything();
            }
            else
            {
                rootClass.chatF.pushMsg("warning", (("Error clearing your house. (CODE: " + _arg_1.target.data) + ")"), "SERVER", "", 0);
            }
        }

        public function cleanEverything():void
        {
            var _local_2:DisplayObject;
            var _local_1:int;
            while (_local_1 < CHARS.numChildren)
            {
                _local_2 = CHARS.getChildAt(_local_1);
                if (((_local_2.hasOwnProperty("isHouseItem")) && (MovieClip(_local_2).isHouseItem)))
                {
                    CHARS.removeChild(_local_2);
                    _local_1--;
                }
                _local_1++;
            }
            objHouseData.sHouseInfo = "";
            objHouseData.sData = {};
            objHouseData.arrPlacement = [];
            initEquippedItems(objHouseData.arrPlacement);
        }

        public function onHouseOptionsHouseClick(_arg_1:MouseEvent):void
        {
            rootClass.mixer.playSound("Click");
            gotoTown("buyhouse", "Enter", "Spawn");
        }

        public function showHouseInventory(_arg_1:int):*
        {
            if (myAvatar.houseitems != null)
            {
                sendLoadShopRequest(_arg_1);
            }
        }

        public function discardHouseChanges(_arg_1:Object):*
        {
            var _local_2:DisplayObject;
            var _local_3:int;
            var _local_4:*;
            var _local_5:int;
            if (_arg_1.accept)
            {
                saveHouseSetup();
            }
            else
            {
                hasModified = false;
                if (rootClass.ui.mcPopup.mcHouseItemHandle.visible)
                {
                    rootClass.ui.mcPopup.mcHouseItemHandle.tgt = null;
                    rootClass.ui.mcPopup.mcHouseItemHandle.x = 1000;
                    rootClass.ui.mcPopup.mcHouseItemHandle.visible = false;
                }
                _local_3 = 0;
                while (_local_3 < CHARS.numChildren)
                {
                    _local_2 = CHARS.getChildAt(_local_3);
                    if (((_local_2.hasOwnProperty("isHouseItem")) && (MovieClip(_local_2).isHouseItem)))
                    {
                        CHARS.removeChild(_local_2);
                        _local_3--;
                    }
                    _local_3++;
                }
                if (isLegacy())
                {
                    _local_3 = 0;
                    while (_local_3 < objHouseData.arrPlacement.length)
                    {
                        if (strFrame == objHouseData.arrPlacement[_local_3].c)
                        {
                            objHouseData.arrPlacement.splice(_local_3, 1);
                            _local_3--;
                        }
                        _local_3++;
                    }
                    for each (_local_4 in frameCopy)
                    {
                        objHouseData.arrPlacement.push(_local_4);
                    }
                }
                else
                {
                    objHouseData.arrPlacement[strFrame] = {};
                    objHouseData.arrPlacement[strFrame]["xi"] = [];
                    _local_5 = 0;
                    for each (_local_4 in frameCopy)
                    {
                        objHouseData.arrPlacement[strFrame]["xi"].push(_local_4);
                        _local_5++;
                    }
                    if (_local_5 == 0)
                    {
                        objHouseData.arrPlacement[strFrame] = null;
                    }
                }
                updateHouseItems();
            }
            if (((!(hasModified)) && (rootClass.ui.mcPopup.mcHouseMenu.visible)))
            {
                toggleHouseEdit();
            }
        }

        public function toggleHouseEdit():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:int;
            var _local_4:DisplayObject;
            var _local_5:*;

            if (((isMyHouse()) && (!(myAvatar.houseitems == null))))
            {
                if (rootClass.ui.mcPopup.mcHouseMenu.visible)
                {
                    if (hasModified)
                    {
                        _local_1 = new ModalMC();
                        _local_2 = {};
                        _local_2.params = {};
                        _local_2.strBody = "Do you want to Save (Yes) or Undo (No) the room?";
                        _local_2.callback = discardHouseChanges;
                        _local_2.btns = "dual";
                        rootClass.ui.ModalStack.addChild(_local_1);
                        _local_1.init(_local_2);
                        return;
                    }
                    rootClass.ui.mcPopup.mcHouseMenu.hideEditMenu();
                    setEditMode(false);
                }
                else
                {
                    if (arrHouseItemQueue.length > 0)
                    {
                        rootClass.showMessageBox("Please wait for your house items to finish loading on your screen before being able to edit them.");
                        return;
                    }
                    if (isLegacy())
                    {
                        frameCopy = [];
                        _local_3 = 0;
                        while (_local_3 < CHARS.numChildren)
                        {
                            _local_4 = CHARS.getChildAt(_local_3);
                            if (((_local_4.hasOwnProperty("isHouseItem")) && (MovieClip(_local_4).isHouseItem)))
                            {
                                if (MovieClip(_local_4).isStable)
                                {
                                    frameCopy.push({
                                        "c":strFrame,
                                        "ID":MovieClip(_local_4).ItemID,
                                        "x":_local_4.x,
                                        "y":_local_4.y
                                    });
                                }
                            }
                            _local_3++;
                        }
                    }
                    else
                    {
                        frameCopy = [];

                        if (objHouseData.arrPlacement[strFrame])
                        {
                            for each (_local_5 in objHouseData.arrPlacement[strFrame]["xi"])
                            {
                                frameCopy.push(_local_5);
                            }
                        }
                    }
                    rootClass.ui.mcPopup.mcHouseMenu.showEditMenu();
                    setEditMode(true);
                }
            }
            else
            {
                if (strMapName == "buyhouse")
                {
                    if (!rootClass.ui.mcPopup.mcHouseMenu.visible)
                    {
                        rootClass.ui.mcPopup.mcHouseMenu.showEditMenu();
                    }
                    else
                    {
                        rootClass.ui.mcPopup.mcHouseMenu.hideEditMenu();
                    }
                }
            }
        }

        private function houseBounds(_arg_1:Event):void
        {
            if (((((!(isMyHouse())) || (!(strFrame == houseFrame))) || (bitWalk)) || (!(strMapName == "house"))))
            {
                houseFrame = "";
                this.removeEventListener(Event.ENTER_FRAME, houseBounds);
                toggleHouseEdit();
                setEditMode(false);
            }
        }

        public function setEditMode(_arg_1:Boolean):*
        {
            var _local_2:*;
            if (_arg_1)
            {
                houseFrame = strFrame;
                for each (_local_2 in avatars)
                {
                    if (_local_2.pMC)
                    {
                        _local_2.pMC.visible = false;
                        _local_2.unloadPet();
                    }
                }
                myAvatar.isWorldCamera = true;
                bitWalk = false;
                this.addEventListener(Event.ENTER_FRAME, houseBounds, false, 0, true);
            }
            else
            {
                for each (_local_2 in avatars)
                {
                    if (_local_2.pMC)
                    {
                        _local_2.pMC.visible = true;
                        _local_2.loadPet();
                    }
                }
                myAvatar.isWorldCamera = false;
                bitWalk = true;
            }
        }

        public function loadHouseInventory():*
        {
            rootClass.sfc.sendXtMessage("zm", "loadHouseInventory", [], "str", curRoom);
        }

        public function updateHouseItems():void
        {
            var _local_1:int;
            var _local_2:Object;
            var _local_3:*;
            if (objHouseData != null)
            {
                if (isMyHouse())
                {
                    initEquippedItems(objHouseData.arrPlacement);
                }
                arrHouseItemQueue = [];
                if (isLegacy())
                {
                    _local_1 = 0;
                    while (_local_1 < objHouseData.arrPlacement.length)
                    {
                        if (strFrame == objHouseData.arrPlacement[_local_1].c)
                        {
                            _local_2 = getHouseItem(objHouseData.arrPlacement[_local_1].ID);
                            if (_local_2 != null)
                            {
                                loadHouseItem(_local_2, objHouseData.arrPlacement[_local_1].x, objHouseData.arrPlacement[_local_1].y);
                            }
                        }
                        _local_1++;
                    }
                }
                else
                {
                    for (_local_3 in objHouseData.arrPlacement)
                    {
                        if (strFrame == _local_3)
                        {
                            if (objHouseData.arrPlacement[_local_3])
                            {
                                _local_1 = 0;
                                while (_local_1 < objHouseData.arrPlacement[_local_3]["xi"].length)
                                {
                                    _local_2 = getHouseItem(objHouseData.arrPlacement[_local_3]["xi"][_local_1]["ID"]);
                                    if (_local_2 != null)
                                    {
                                        loadHouseItem(_local_2, objHouseData.arrPlacement[_local_3]["xi"][_local_1]["x"], objHouseData.arrPlacement[_local_3]["xi"][_local_1]["y"], objHouseData.arrPlacement[_local_3]["xi"][_local_1]["f"]);
                                    }
                                    _local_1++;
                                }
                            }
                        }
                    }
                }
            }
        }

        public function attachHouseItem(_arg_1:Object):void
        {
            var _local_2:Class = (loaderD.getDefinition(_arg_1.item.sLink) as Class);
            var _local_3:* = new (_local_2)();
            _local_3.f = _arg_1.f;
            _local_3.x = _arg_1.x;
            _local_3.y = _arg_1.y;
            _local_3.ItemID = _arg_1.item.ItemID;
            _local_3.item = _arg_1.item;
            _local_3.isHouseItem = true;
            _local_3.isStable = false;
            _local_3.addEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick, false, 0, true);
            if (_local_3.f)
            {
                _local_3.scaleX = (_local_3.scaleX * -1);
            }
            var _local_4:MovieClip = (CHARS.addChild(_local_3) as MovieClip);
            _local_4.name = ("mc" + getQualifiedClassName(_local_4));
            houseItemValidate(_local_3);
        }

        public function onHouseItemClick(_arg_1:Event):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (((isMyHouse()) && (rootClass.ui.mcPopup.mcHouseMenu.visible)))
            {
                rootClass.ui.mcPopup.mcHouseMenu.drawItemHandle(MovieClip(_arg_1.currentTarget));
                rootClass.ui.mcPopup.mcHouseMenu.onHandleMoveClick(_arg_1.clone());
            }
            else
            {
                if (((_local_2.btnButton == null) || (!(_local_2.btnButton.hasEventListener(MouseEvent.CLICK)))))
                {
                    onWalkClick();
                }
            }
        }

        public function houseItemValidate(_arg_1:MovieClip):void
        {
            var _local_3:int;
            var _local_4:DisplayObject;
            var _local_2:* = getHouseItem(_arg_1.ItemID);
            if (_local_2 == null)
            {
                MovieClip(_arg_1.parent).removeChild(_arg_1);
                return;
            }
            if (_local_2.sType == "Floor Item")
            {
                _arg_1.isStable = false;
                _arg_1.addEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame, false, 0, true);
            }
            else
            {
                if (_local_2.sType == "Wall Item")
                {
                    _arg_1.isStable = true;
                    _local_3 = 0;
                    while (_local_3 < map.numChildren)
                    {
                        _local_4 = map.getChildAt(_local_3);
                        if ((((_local_4 is MovieClip) && (MovieClip(_local_4).isFloor)) && (MovieClip(_local_4).hitTestObject(_arg_1))))
                        {
                            _arg_1.isStable = false;
                            break;
                        }
                        _local_3++;
                    }
                    if (!_arg_1.isStable)
                    {
                        _arg_1.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 150, 0, 0, 0);
                    }
                    else
                    {
                        _arg_1.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
                    }
                }
            }
        }

        public function onHouseItemEnterFrame(_arg_1:Event):void
        {
            var _local_4:DisplayObject;
            var _local_5:Rectangle;
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (!_local_2)
            {
                _local_2.removeEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame);
            }
            var _local_3:int;
            while (_local_3 < map.numChildren)
            {
                _local_4 = map.getChildAt(_local_3);
                if ((((_local_4 is MovieClip) && (MovieClip(_local_4).isFloor)) && (MovieClip(_local_4).hitTestPoint(_local_2.x, _local_2.y))))
                {
                    _local_2.removeEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame);
                    _local_2.isStable = true;
                    break;
                }
                _local_3++;
            }
            if (!_local_2.isStable)
            {
                _local_5 = _local_2.getBounds(rootClass.stage);
                if ((_local_5.y + (_local_5.height / 2)) > 495)
                {
                    _local_2.isStable = true;
                    _local_2.y = Math.ceil((_local_5.y - (_local_5.y - _local_2.y)));
                    _local_2.removeEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame);
                }
                else
                {
                    _local_2.y = (_local_2.y + 10);
                }
                if (((rootClass.ui.mcPopup.mcHouseMenu) && (rootClass.ui.mcPopup.mcHouseMenu.visible)))
                {
                    rootClass.ui.mcPopup.mcHouseMenu.drawItemHandle(_local_2);
                }
            }
        }

        public function isLegacy():Boolean
        {
            if (((!(objHouseData == null)) && ((objHouseData.sData == "") && (objHouseData.sHouseInfo == ""))))
            {
                return false;
            }
            return (!((!(objHouseData == null)) && (!(objHouseData.sData == ""))));
        }

        public function initHouseData(_arg_1:Object):void
        {
            objHouseData = _arg_1;

            if (objHouseData != null)
            {
                if (!isLegacy())
                {
                    if (isMyHouse())
                    {
                        searchForInequalities();
                    }

                    objHouseData.arrPlacement = objHouseData.sData;
                    if (!objHouseData.hasOwnProperty("sData") || objHouseData.sData == "")
                    {
                        objHouseData.arrPlacement = {};
                    }

                    if (isMyHouse())
                    {
                        rootClass.chatF.pushMsg("server", "Your house data has been upgraded.", "SERVER", "", 0);
                    }
                }
                else
                {
                    objHouseData.arrPlacement = createItemPlacementArray(objHouseData.sHouseInfo);
                    if (isMyHouse())
                    {
                        rootClass.chatF.pushMsg("server", "Your house data needs to be upgraded. Upgrading will start shortly.", "SERVER", "", 0);
                    }
                }
                verifyItemQty();
            }
            if (((isMyHouse()) && (imbalancedHouseCells.length > 0)))
            {
                massAutoSave();
            }
        }

        public function massAutoSave():void
        {
            convertTimer = new Timer(500, 1);
            convertTimer.addEventListener(TimerEvent.TIMER, onAutoSave, false, 0, true);
            convertTimer.start();
        }

        public function onAutoSave(_arg_1:TimerEvent):void
        {
            var _local_2:String = imbalancedHouseCells.shift();
            rootClass.mcConnDetail.showConn((("Upgrading room " + _local_2) + "..."), false, true);
            rootClass.chatF.pushMsg("server", (("Saving room " + _local_2) + "..."), "SERVER", "", 0);
            rootClass.requestAPI("HouseSaveRoom", {
                "frame":_local_2,
                "layout":objHouseData.sData[_local_2]
            }, callbackA, callbackB, true);
            if (imbalancedHouseCells.length < 1)
            {
                rootClass.mcConnDetail.hideConn();
                convertTimer.removeEventListener(TimerEvent.TIMER, onSendConvert);
                convertTimer.reset();
                convertTimer = null;
            }
        }

        public function searchForInequalities():void
        {
            var _local_2:*;
            var _local_3:Array;
            var _local_4:int;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:int;
            var _local_1:* = {};
            for (_local_2 in objHouseData.sData)
            {
                if (objHouseData.sData[_local_2])
                {
                    _local_4 = 0;
                    while (_local_4 < objHouseData.sData[_local_2]["xi"].length)
                    {
                        _local_7 = objHouseData.sData[_local_2]["xi"][_local_4]["ID"];
                        if (_local_1[_local_7] == null)
                        {
                            _local_1[_local_7] = 1;
                        }
                        else
                        {
                            _local_1[_local_7]++;
                        }
                        _local_4++;
                    }
                }
            }
            _local_3 = [];
            _local_4 = 0;
            while (_local_4 < myAvatar.houseitems.length)
            {
                _local_8 = myAvatar.houseitems[_local_4];
                if (Number(_local_1[_local_8.ItemID]) > Number(_local_8.iQty))
                {
                    _local_3.push(_local_8.ItemID);
                }
                _local_4++;
            }
            if (_local_3.length == 0)
            {
                return;
            }
            imbalancedHouseCells = [];
            var _local_5:Boolean;
            for (_local_6 in objHouseData.sData)
            {
                _local_5 = false;
                _local_9 = 0;
                while (_local_9 < objHouseData.sData[_local_6]["xi"].length)
                {
                    if (_local_3.indexOf(objHouseData.sData[_local_6]["xi"][_local_9]["ID"]) > -1)
                    {
                        objHouseData.sData[_local_6]["xi"].splice(_local_9, 1);
                        _local_9--;
                        _local_5 = true;
                    }
                    _local_9++;
                }
                if (_local_5)
                {
                    imbalancedHouseCells.push(_local_6);
                }
            }
        }

        public function initMassConvert():void
        {
            if (objHouseData != null)
            {
                if (objHouseData.sHouseInfo != "")
                {
                    if (isLegacy())
                    {
                        massConvert();
                    }
                }
            }
        }

        public function verifyItemQty():void
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:*;
            var _local_1:* = {};
            if (isLegacy())
            {
                _local_2 = 0;
                while (_local_2 < objHouseData.arrPlacement.length)
                {
                    _local_3 = objHouseData.arrPlacement[_local_2].ID;
                    if (_local_1[_local_3] == null)
                    {
                        _local_1[_local_3] = 1;
                    }
                    else
                    {
                        _local_1[_local_3]++;
                    }
                    _local_2++;
                }
            }
            else
            {
                for (_local_4 in objHouseData.arrPlacement)
                {
                    if (_local_4 == strFrame)
                    {
                        if (objHouseData.arrPlacement[_local_4])
                        {
                            _local_2 = 0;
                            while (_local_2 < objHouseData.arrPlacement[_local_4]["xi"].length)
                            {
                                _local_3 = objHouseData.arrPlacement[_local_4]["xi"][_local_2]["ID"];
                                if (_local_1[_local_3] == null)
                                {
                                    _local_1[_local_3] = 1;
                                }
                                else
                                {
                                    _local_1[_local_3]++;
                                }
                                _local_2++;
                            }
                        }
                    }
                }
            }
        }

        public function getHouseItem(_arg_1:int):Object
        {
            var _local_2:int;
            var _local_3:int;
            if (isMyHouse())
            {
                _local_2 = 0;
                while (_local_2 < myAvatar.houseitems.length)
                {
                    if (myAvatar.houseitems[_local_2].ItemID == _arg_1)
                    {
                        return (myAvatar.houseitems[_local_2]);
                    }
                    _local_2++;
                }
            }
            else
            {
                _local_3 = 0;
                while (_local_3 < objHouseData.items.length)
                {
                    if (objHouseData.items[_local_3].ItemID == _arg_1)
                    {
                        return (objHouseData.items[_local_3]);
                    }
                    _local_3++;
                }
            }
            return null;
        }

        public function removeSelectedItem():void
        {
            var _local_1:MovieClip;
            if (objHouseData.selectedMC == null)
            {
                rootClass.MsgBox.notify("Please selected an item to be removed.");
            }
            else
            {
                _local_1 = objHouseData.selectedMC;
                _local_1.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick);
                unequipHouseItem(_local_1.ItemID);
                CHARS.removeChild(_local_1);
                delete objHouseData.selectedMC;
            }
        }

        public function equipHouse(_arg_1:Object):void
        {
            var _local_2:* = new ModalMC();
            var _local_3:* = {};
            _local_3.strBody = (("Are you sure you want to equip '" + _arg_1.sName) + "'?");
            _local_3.params = {"item":_arg_1};
            _local_3.callback = equipHouseRequest;
            rootClass.ui.ModalStack.addChild(_local_2);
            _local_2.init(_local_3);
        }

        public function equipHouseRequest(_arg_1:*):void
        {
            if (_arg_1.accept)
            {
                rootClass.world.sendEquipItemRequest(_arg_1.item);
                rootClass.world.equipHouseByID(_arg_1.item.ItemID);
            }
        }

        public function equipHouseByID(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < myAvatar.houseitems.length)
            {
                myAvatar.houseitems[_local_2].bEquip = ((myAvatar.houseitems[_local_2].ItemID == _arg_1) ? 1 : 0);
                _local_2++;
            }
            if (rootClass.ui.mcPopup.currentLabel == "HouseInventory")
            {
                MovieClip(rootClass.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
            }
        }

        public function massConvert():void
        {
            var _local_1:*;
            houseJson = {};
            for each (_local_1 in createItemPlacementArray(objHouseData.sHouseInfo))
            {
                if (_local_1.c)
                {
                    if (frameExists(_local_1.c))
                    {
                        if (!houseJson.hasOwnProperty(_local_1.c))
                        {
                            houseJson[_local_1.c] = {};
                            houseJson[_local_1.c]["xi"] = [];
                        }
                        houseJson[_local_1.c]["xi"].push({
                            "ID":parseInt(_local_1.ID),
                            "x":parseInt(_local_1.x),
                            "y":parseInt(_local_1.y)
                        });
                    }
                }
            }
            finishedCells = [];
            retrieveUnsentCell();
            convertTimer = new Timer(500, 1);
            convertTimer.addEventListener(TimerEvent.TIMER, onSendConvert, false, 0, true);
            convertTimer.start();
        }

        public function retrieveUnsentCell():void
        {
            var _local_1:*;
            for (_local_1 in houseJson)
            {
                if (finishedCells.indexOf(_local_1) == -1)
                {
                    activeCell = _local_1;
                    finishedCells.push(_local_1);
                    return;
                }
            }
            rootClass.mcConnDetail.hideConn();
            if (convertTimer)
            {
                convertTimer.removeEventListener(TimerEvent.TIMER, onSendConvert);
                convertTimer.reset();
                convertTimer = null;
            }
        }

        public function onSendConvert(_arg_1:TimerEvent):void
        {
            var _local_2:*;
            rootClass.mcConnDetail.showConn((("Converting frame " + activeCell) + " from legacy house data..."), false, true);
            rootClass.chatF.pushMsg("server", (("Saving room " + activeCell) + "..."), "SERVER", "", 0);
            rootClass.requestAPI("HouseSaveRoom", {
                "frame":activeCell,
                "layout":houseJson[activeCell]
            }, callbackA, callbackB, true);
            for each (_local_2 in houseJson[activeCell]["xi"])
            {
            }
            retrieveUnsentCell();
        }

        public function saveHouseSetup():void
        {
            var _local_1:int;
            var _local_3:DisplayObject;
            var _local_4:*;
            _local_1 = 0;
            while (_local_1 < CHARS.numChildren)
            {
                _local_3 = CHARS.getChildAt(_local_1);
                if (((_local_3.hasOwnProperty("isHouseItem")) && (MovieClip(_local_3).isHouseItem)))
                {
                    if (!MovieClip(_local_3).isStable)
                    {
                        rootClass.showMessageBox((MovieClip(_local_3).item.sName + " is not properly placed!"));
                        return;
                    }
                }
                _local_1++;
            }
            var _local_2:Object = {};
            _local_2["xi"] = [];
            _local_1 = 0;
            while (_local_1 < CHARS.numChildren)
            {
                _local_3 = CHARS.getChildAt(_local_1);
                if (((_local_3.hasOwnProperty("isHouseItem")) && (MovieClip(_local_3).isHouseItem)))
                {
                    if (MovieClip(_local_3).isStable)
                    {
                        _local_4 = {
                            "ID":int(MovieClip(_local_3).ItemID),
                            "x":int(_local_3.x),
                            "y":int(_local_3.y)
                        };
                        if (MovieClip(_local_3).scaleX < 0)
                        {
                            _local_4["f"] = 1;
                        }
                        _local_2["xi"].push(_local_4);
                    }
                    else
                    {
                        rootClass.chatF.pushMsg("warning", (MovieClip(_local_3).item.sName + " was removed for being in an invalid position."), "SERVER", "", 0);
                        unequipHouseItem(MovieClip(_local_3).ItemID);
                        _local_3.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick);
                        CHARS.removeChild(_local_3);
                    }
                }
                _local_1++;
            }
            objHouseData.arrPlacement[strFrame] = _local_2;

            rootClass.requestAPI("HouseSaveRoom", {
                "frame":strFrame,
                "layout":_local_2
            }, callbackA, callbackB, true);
            hasModified = false;
        }

        public function callbackA(_arg_1:Event):void
        {
            if (_arg_1.target.data == "success")
            {
                rootClass.addUpdate("House saved successfully.");
                rootClass.chatF.pushMsg("server", "House saved successfully.", "SERVER", "", 0);
                if (convertTimer)
                {
                    convertTimer.start();
                }
            }
            else
            {
                rootClass.chatF.pushMsg("warning", (("Error saving your house. (CODE: " + _arg_1.target.data) + ")"), "SERVER", "", 0);
                convertTimer.removeEventListener(TimerEvent.TIMER, onSendConvert);
                convertTimer.reset();
                convertTimer = null;
                rootClass.mcConnDetail.hideConn();
            }
        }

        public function callbackB(_arg_1:IOErrorEvent):void
        {
            rootClass.chatF.pushMsg("warning", "IOError occurred.", "SERVER", "", 0);
        }

        public function createItemPlacementString(_arg_1:Array):String
        {
            var _local_3:int;
            var _local_4:*;
            var _local_2:* = "";
            if (_arg_1.length > 0)
            {
                _local_3 = 0;
                while (_local_3 < _arg_1.length)
                {
                    for (_local_4 in _arg_1[_local_3])
                    {
                        _local_2 = ((((_local_2 + _local_4) + ":") + _arg_1[_local_3][_local_4]) + ",");
                    }
                    _local_2 = _local_2.substring(0, (_local_2.length - 1));
                    _local_2 = (_local_2 + "|");
                    _local_3++;
                }
                _local_2 = _local_2.substring(0, (_local_2.length - 1));
            }
            return (_local_2);
        }

        public function createItemPlacementArray(_arg_1:String):Array
        {
            var _local_3:*;
            var _local_4:int;
            var _local_5:*;
            var _local_6:*;
            var _local_7:int;
            var _local_2:Array = [];
            if (_arg_1.length > 0)
            {
                _local_3 = _arg_1.split("|");
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    _local_5 = {};
                    _local_6 = _local_3[_local_4].split(",");
                    _local_7 = 0;
                    while (_local_7 < _local_6.length)
                    {
                        _local_5[_local_6[_local_7].split(":")[0]] = _local_6[_local_7].split(":")[1];
                        _local_7++;
                    }
                    if (getHouseItem(parseInt(_local_5["ID"])) != null)
                    {
                        _local_2.push(_local_5);
                    }
                    _local_4++;
                }
            }
            return (_local_2);
        }

        public function sendSaveHouseSetup(_arg_1:*):void
        {
            rootClass.sfc.sendXtMessage("zm", "housesave", [_arg_1], "str", 1);
        }

        public function frameExists(_arg_1:String):Boolean
        {
            var _local_2:*;
            if (!_arg_1)
            {
                return false;
            }
            for each (_local_2 in rootClass.world.map.currentScene.labels)
            {
                if (_local_2.name == _arg_1)
                {
                    return true;
                }
            }
            return false;
        }

        public function initEquippedItems(_arg_1:*):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:*;
            if (!objHouseData)
            {
                return;
            }
            if (isLegacy())
            {
                _local_2 = 0;
                while (_local_2 < myAvatar.houseitems.length)
                {
                    if (myAvatar.houseitems[_local_2].sType != "House")
                    {
                        myAvatar.houseitems[_local_2].bEquip = 0;
                        _local_3 = 0;
                        while (_local_3 < _arg_1.length)
                        {
                            if (((myAvatar.houseitems[_local_2].ItemID == _arg_1[_local_3].ID) && (frameExists(_arg_1[_local_3].c))))
                            {
                                myAvatar.houseitems[_local_2].bEquip = (myAvatar.houseitems[_local_2].bEquip + 1);
                            }
                            _local_3++;
                        }
                    }
                    _local_2++;
                }
            }
            else
            {
                _local_2 = 0;
                while (_local_2 < myAvatar.houseitems.length)
                {
                    if (myAvatar.houseitems[_local_2].sType != "House")
                    {
                        myAvatar.houseitems[_local_2].bEquip = 0;
                        for (_local_4 in _arg_1)
                        {
                            if (frameExists(_local_4))
                            {
                                if (_arg_1[_local_4])
                                {
                                    _local_3 = 0;
                                    while (_local_3 < _arg_1[_local_4]["xi"].length)
                                    {
                                        if (myAvatar.houseitems[_local_2].ItemID == _arg_1[_local_4]["xi"][_local_3].ID)
                                        {
                                            myAvatar.houseitems[_local_2].bEquip = (myAvatar.houseitems[_local_2].bEquip + 1);
                                        }
                                        _local_3++;
                                    }
                                }
                            }
                        }
                    }
                    _local_2++;
                }
            }
        }

        public function initHouseInventory(_arg_1:*):void
        {
            myAvatar.houseitems = ((_arg_1.items == null) ? [] : _arg_1.items);
            initEquippedItems(createItemPlacementArray(_arg_1.sHouseInfo));
            var houseItems:Array = myAvatar.houseitems;
            var i:int = 0;
            while (i < houseItems.length)
            {
                houseItems[i].iQty = int(houseItems[i].iQty);
                rootClass.world.invTree[houseItems[i].ItemID] = houseItems[i];
                i++;
            }
        }

        public function unequipHouseItem(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < myAvatar.houseitems.length)
            {
                if (myAvatar.houseitems[_local_2].ItemID == _arg_1)
                {
                    myAvatar.houseitems[_local_2].bEquip--;
                }
                _local_2++;
            }
        }

        public function loadHouseItem(item:Object, x:int, y:int, f:int=0):void
        {
            try
            {
                attachHouseItem({
                    "item":item,
                    "x":x,
                    "y":y,
                    "f":f
                });
            }
            catch(err:Error)
            {
                arrHouseItemQueue.push({
                    "item":item,
                    "typ":"A",
                    "x":x,
                    "y":y,
                    "f":f
                });
                if (arrHouseItemQueue.length > 0)
                {
                    loadNextHouseItem();
                }
            }
        }

        public function loadNextHouseItem():void
        {
            rootClass.onLoadMaster(onHouseItemComplete, loaderC, arrHouseItemQueue[0].item.sFile, null, onHouseItemError);
        }

        public function onHouseItemError(_arg_1:IOErrorEvent):void
        {
            rootClass.debugMessage(_arg_1.text);
            var _local_2:* = arrHouseItemQueue[0];
            if (_local_2.typ == "A")
            {
                arrHouseItemQueue.splice(0, 1);
                if (arrHouseItemQueue.length > 0)
                {
                    loadNextHouseItem();
                }
            }
            else
            {
                arrHouseItemQueue.splice(0, 1);
                if (arrHouseItemQueue.length > 0)
                {
                    loadNextHouseItemB();
                }
            }
        }

        public function onHouseItemComplete(_arg_1:Event):void
        {
            var _local_2:* = arrHouseItemQueue[0];
            if (_local_2.typ == "A")
            {
                attachHouseItem(_local_2);
                arrHouseItemQueue.splice(0, 1);
                if (arrHouseItemQueue.length > 0)
                {
                    loadNextHouseItem();
                }
            }
            else
            {
                rootClass.ui.mcPopup.mcHouseMenu.previewHouseItem(_local_2);
                arrHouseItemQueue.splice(0, 1);
                if (arrHouseItemQueue.length > 0)
                {
                    loadNextHouseItemB();
                }
            }
        }

        public function loadHouseItemB(item:Object):void
        {
            try
            {
                rootClass.ui.mcPopup.mcHouseMenu.previewHouseItem({"item":item});
            }
            catch(err:Error)
            {
                rootClass.ui.mcPopup.mcHouseMenu.preview.t2.visible = true;
                rootClass.ui.mcPopup.mcHouseMenu.preview.cnt.visible = false;
                rootClass.ui.mcPopup.mcHouseMenu.preview.bAdd.visible = false;
                arrHouseItemQueue.push({
                    "item":item,
                    "typ":"B"
                });
                if (arrHouseItemQueue.length > 0)
                {
                    loadNextHouseItemB();
                }
            }
        }

        public function loadNextHouseItemB():void
        {
            var item:Object = arrHouseItemQueue[0].item;
            var file:String = item.sFile;

            if (item.sType == "House") {
                file = "maps/" + item.sFile.substr(0, -4) + "_preview.swf";
            }

            rootClass.onLoadMaster(onHouseItemComplete, loaderC, file);
        }

        public function playerInit():*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:Array;
            var _local_6:int;
            var _local_1:* = rootClass.sfc.getAllRooms();
            for (_local_2 in _local_1)
            {
            }
            _local_3 = rootClass.sfc.getRoom(curRoom).getUserList();
            _local_5 = [];
            _local_6 = 0;
            for (_local_4 in _local_3)
            {
                _local_5.push(_local_3[_local_4].getId());
            }
            if (_local_5.length > 0)
            {
                objectByIDArray(_local_5);
            }
            myAvatar = avatars[rootClass.sfc.myUserId];
            myAvatar.isMyAvatar = true;
            myAvatar.pMC.disablePNameMouse();
            rootClass.sfcSocial = true;
        }

        public function objectByIDArray(_arg_1:Array):*
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:*;
            var _local_5:String;
            var _local_6:Object;
            var _local_7:String;
            var _local_8:Array = [];
            _local_2 = 0;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = _arg_1[_local_2];
                _local_6 = getUoLeafById(_local_3);
                if (_local_6 != null)
                {
                    _local_5 = _local_6.uoName;
                    _local_7 = String(_local_6.strFrame);
                    if (_local_3 == rootClass.sfc.myUserId)
                    {
                        _local_7 = strFrame;
                    }
                    if (avatars[_local_3] == null)
                    {
                        avatars[_local_3] = new Avatar(rootClass);
                        avatars[_local_3].uid = _local_3;
                        avatars[_local_3].pnm = _local_5;
                    }
                    avatars[_local_3].dataLeaf = _local_6;
                    if (((avatars[_local_3].pMC == null) && (_local_7 == strFrame)))
                    {
                        avatars[_local_3].pMC = createAvatarMC(_local_3);
                        _local_8.push(_local_3);
                    }
                    updateUserDisplay(_local_3);
                }
                _local_2++;
            }
            if (_local_8.length > 0)
            {
                getUserDataByIds(_local_8);
            }
        }

        public function objectByID(_arg_1:Number):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_2:* = getUoLeafById(_arg_1);
            if (_local_2 != null)
            {
                _local_3 = _local_2.uoName;
                _local_4 = String(_local_2.strFrame);
                if (_arg_1 == rootClass.sfc.myUserId)
                {
                    _local_4 = strFrame;
                }
                if (avatars[_arg_1] == null)
                {
                    avatars[_arg_1] = new Avatar(rootClass);
                    avatars[_arg_1].uid = _arg_1;
                    avatars[_arg_1].pnm = _local_3;
                }
                avatars[_arg_1].dataLeaf = _local_2;
                if (((avatars[_arg_1].pMC == null) && (_local_4 == strFrame)))
                {
                    avatars[_arg_1].pMC = createAvatarMC(_arg_1);
                    getUserDataById(_arg_1);
                }
                updateUserDisplay(_arg_1);
            }
        }

        public function createAvatarMC(_arg_1:Number):AvatarMC
        {
            var _local_2:AvatarMC = new AvatarMC();
            _local_2.name = ("a" + _arg_1);
            _local_2.x = -600;
            _local_2.y = 0;
            _local_2.pAV = avatars[_arg_1];
            _local_2.world = this;
            return (_local_2);
        }

        public function destroyAvatar(_arg_1:Number):*
        {
            if (avatars[_arg_1] != null)
            {
                if (avatars[_arg_1].pMC != null)
                {
                    if (!avatars[_arg_1].isMyAvatar)
                    {
                        avatars[_arg_1].pMC.fClose();
                        delete avatars[_arg_1];
                    }
                }
            }
        }

        public function updateUserDisplay(_arg_1:Number):*
        {
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_2:* = getMCByUserID(_arg_1);
            var _local_3:* = getUoLeafById(_arg_1);
            var _local_4:* = String(_local_3.strFrame);
            if (_local_4 == strFrame)
            {
                _local_2.mvts = Number(_local_3.mvts);
                _local_2.mvtd = Number(_local_3.mvtd);
                _local_2.px = int(_local_3.px);
                _local_2.py = int(_local_3.py);
                _local_2.tx = int(_local_3.tx);
                _local_2.ty = int(_local_3.ty);
                _local_2.sp = int(_local_3.sp);
                _local_5 = int(_local_3.intState);
                _local_6 = null;
                if (((("strPad" in _local_3) && (!(_local_3.strPad.toLowerCase() == "none"))) && (_local_3.strPad in map)))
                {
                    _local_6 = map[_local_3.strPad];
                }
                if (((!(_local_2.tx == 0)) || (!(_local_2.ty == 0))))
                {
                    if (bPvP)
                    {
                        _local_2.mcChar.onMove = true;
                    }
                    else
                    {
                        if (!testTxTy(new Point(_local_2.tx, _local_2.ty), _local_2))
                        {
                            _local_7 = solveTxTy(new Point(_local_2.tx, _local_2.ty), _local_2);
                            if (_local_7 != null)
                            {
                                _local_2.x = _local_7.x;
                                _local_2.y = _local_7.y;
                            }
                            else
                            {
                                _local_2.x = int((960 / 2));
                                _local_2.y = int((550 / 2));
                            }
                        }
                        else
                        {
                            _local_2.x = _local_2.tx;
                            _local_2.y = _local_2.ty;
                        }
                    }
                }
                else
                {
                    if (bPvP)
                    {
                        _local_2.destroyWalkFrame();
                        _local_2.resetSyncVars();
                    }
                    if (_local_6 != null)
                    {
                        _local_2.x = int(((_local_6.x + int((Math.random() * 10))) - 5));
                        _local_2.y = int(((_local_6.y + int((Math.random() * 10))) - 5));
                    }
                    else
                    {
                        _local_2.x = int((960 / 2));
                        _local_2.y = int((550 / 2));
                    }
                }
                _local_2.scale(SCALE);
                if (_local_5)
                {
                    _local_2.mcChar.gotoAndStop("Idle");
                }
                else
                {
                    _local_2.mcChar.gotoAndStop("Dead");
                }
                if (showHPBar)
                {
                    _local_2.showHPBar();
                }
                else
                {
                    _local_2.hideHPBar();
                }
                if (_arg_1 == rootClass.sfc.myUserId)
                {
                    bitWalk = true;
                }
                if (((CELL_MODE == "normal") || (_arg_1 == rootClass.sfc.myUserId)))
                {
                    _local_2.pAV.showMC();
                }
                else
                {
                    _local_2.pAV.hideMC();
                }
                if ((((bPvP) && (!(_local_3.pvpTeam == null))) && (_local_3.pvpTeam > -1)))
                {
                    _local_2.mcChar.pvpFlag.visible = true;
                    _local_2.mcChar.pvpFlag.gotoAndStop(["a", "b", "c"][_local_3.pvpTeam]);
                }
                else
                {
                    _local_2.mcChar.pvpFlag.visible = false;
                }
                if (_local_2.isLoaded)
                {
                    _local_2.gotoAndPlay("in2");
                }
                else
                {
                    _local_2.gotoAndPlay("hold");
                }
                if (_local_2.isLoaded)
                {
                    _local_2.pAV.isMyAvatar = (_arg_1 == rootClass.sfc.myUserId);
                    _local_2.handleAfterAvatarLoad();
                }
            }
        }

        public function repairAvatars():void
        {
            var _local_1:Avatar;
            rootClass.chatF.pushMsg("server", "Attempting to repair incomplete Avatars...", "SERVER", "", 0);
            var _local_2:Boolean;
            for each (_local_1 in avatars)
            {
                if (!_local_1.pMC.isLoaded)
                {
                    _local_2 = true;
                    if (_local_1.objData != null)
                    {
                        rootClass.chatF.pushMsg("server", (" > repairing " + _local_1.objData.strUsername), "SERVER", "", 0);
                        _local_1.initAvatar(_local_1.objData);
                    }
                    else
                    {
                        if (_local_1.pnm != null)
                        {
                            rootClass.chatF.pushMsg("warning", ((" *> Data load incomplete for " + _local_1.pnm) + ", repair cannot continue."), "SERVER", "", 0);
                        }
                        else
                        {
                            rootClass.chatF.pushMsg("warning", " *> Avatar instantiated but no data exists at all!", "SERVER", "", 0);
                        }
                    }
                }
            }
            if (!_local_2)
            {
                rootClass.chatF.pushMsg("server", " > No incomplete Avatars found!", "SERVER", "", 0);
            }
        }

        private function solveTxTy(_arg_1:Point, _arg_2:MovieClip):Point
        {
            var _local_6:Point;
            var _local_7:Point;
            var _local_10:int;
            var _local_3:int = 20;
            var _local_4:int = int((960 / _local_3));
            var _local_5:int = int((550 / _local_3));
            var _local_8:Array = [];
            var _local_9:int;
            while (_local_9 <= _local_4)
            {
                _local_10 = 0;
                while (_local_10 <= _local_5)
                {
                    _local_6 = new Point((_local_9 * _local_3), (_local_10 * _local_3));
                    if (testTxTy(_local_6, _arg_2))
                    {
                        _local_8.push({
                            "x":_local_6.x,
                            "y":_local_6.y,
                            "d":Math.abs(Point.distance(_arg_1, _local_6))
                        });
                    }
                    _local_10++;
                }
                _local_9++;
            }
            if (_local_8.length)
            {
                _local_8.sortOn(["d"], [Array.NUMERIC]);
                _local_7 = new Point(((_local_8[0].x + int((Math.random() * 10))) - 5), ((_local_8[0].y + int((Math.random() * 10))) - 5));
                while ((!(testTxTy(_local_7, _arg_2))))
                {
                    _local_7 = new Point(((_local_8[0].x + int((Math.random() * 10))) - 5), ((_local_8[0].y + int((Math.random() * 10))) - 5));
                }
                return (_local_7);
            }
            return null;
        }

        private function testTxTy(_arg_1:Point, _arg_2:MovieClip):Boolean
        {
            var _local_3:int = _arg_2.shadow.width;
            var _local_4:int = _arg_2.shadow.height;
            var _local_5:int = int((_arg_1.x - (_local_3 / 2)));
            var _local_6:int = int((_arg_1.y - (_local_4 / 2)));
            var _local_7:Rectangle = new Rectangle(_local_5, _local_6, _local_3, _local_4);
            var _local_8:Rectangle;
            var _local_9:MovieClip;
            var _local_10:Boolean;
            var _local_11:int;
            while (_local_11 < arrSolid.length)
            {
                _local_9 = MovieClip(arrSolid[_local_11].shadow);
                _local_8 = new Rectangle(_local_9.x, _local_9.y, _local_9.width, _local_9.height);
                _local_10 = (!(_local_8.intersects(_local_7)));
                _local_11++;
            }
            return (_local_10);
        }

        public function updatePortrait(_arg_1:Avatar):*
        {
            var _local_2:Array;
            var _local_3:MovieClip;
            var _local_6:int;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_4:int;
            var _local_5:int;
            if (_arg_1 != myAvatar)
            {
                _local_2 = [rootClass.ui.mcPortraitTarget];
            }
            else
            {
                if (_arg_1 == myAvatar.target)
                {
                    _local_2 = [rootClass.ui.mcPortraitTarget, rootClass.ui.mcPortrait];
                }
                else
                {
                    _local_2 = [rootClass.ui.mcPortrait];
                }
            }
            _local_4 = 0;
            while (_local_4 < _local_2.length)
            {
                _local_7 = {};
                _local_3 = _local_2[_local_4];
                _local_3.strName.mouseEnabled = false;
                _local_3.strClass.mouseEnabled = false;
                if (_arg_1.npcType == "monster")
                {
                    _local_7 = monTree[_arg_1.objData.MonMapID];
                    _local_3.strName.text = _arg_1.objData.strMonName.toUpperCase();
                    _local_3.strClass.text = _arg_1.objData.hasOwnProperty("sRace") && _arg_1.objData.sRace != "None" ? _arg_1.objData.sRace : "Monster";
                    if (("stars" in _local_3))
                    {
                        _local_6 = int(Math.round((Math.pow((_arg_1.objData.intLevel * 1.3), 0.5) / 2)));
                        _local_5 = 1;
                        while (_local_5 < 6)
                        {
                            if (_local_5 <= _local_6)
                            {
                                _local_3.stars.getChildByName(("s" + _local_5)).visible = true;
                            }
                            else
                            {
                                _local_3.stars.getChildByName(("s" + _local_5)).visible = false;
                            }
                            _local_5++;
                        }
                    }
                }
                if (_arg_1.npcType == "player")
                {
                    _local_7 = uoTree[_arg_1.pnm];
                    _local_3.strName.text = _arg_1.objData.strUsername.toUpperCase();
                    _local_3.strClass.text = ((_arg_1.objData.strClassName + ", Rank ") + _arg_1.objData.iRank);
                    if (("stars" in _local_3))
                    {
                        _local_5 = 1;
                        while (_local_5 < 6)
                        {
                            _local_3.stars.getChildByName(("s" + _local_5)).visible = false;
                            _local_5++;
                        }
                    }
                }
                if (((_arg_1.npcType == "monster") || (_arg_1.npcType == "player")))
                {
                    _local_3.strLevel.text = _arg_1.objData.intLevel;
                    _local_8 = 0;
                    _local_9 = 0;
                    _local_10 = null;
                    _local_8 = _local_7.intHP;
                    _local_9 = _local_7.intHPMax;
                    _local_10 = _local_3.HP;
                    if (_local_7.intHP >= 0)
                    {
                        _local_10.strIntHP.text = String(_local_7.intHP);
                    }
                    else
                    {
                        _local_10.strIntHP.text = "X";
                    }
                    if (_local_8 < 0)
                    {
                        _local_8 = 0;
                    }
                    if (_local_8 > _local_9)
                    {
                        _local_8 = _local_9;
                    }
                    _local_10.intHPbar.x = Math.min(-(_local_10.intHPbar.width * (1 - (_local_8 / _local_9))), 0);
                    _local_8 = _local_7.intMP;
                    _local_9 = _local_7.intMPMax;
                    _local_10 = _local_3.MP;
                    if (_local_7.intMP >= 0)
                    {
                        _local_10.strIntMP.text = String(_local_7.intMP);
                    }
                    else
                    {
                        _local_10.strIntMP.text = "X";
                    }
                    if (_local_8 < 0)
                    {
                        _local_8 = 0;
                    }
                    if (_local_8 > _local_9)
                    {
                        _local_8 = _local_9;
                    }
                    _local_10.intMPbar.x = Math.min(-(_local_10.intMPbar.width * (1 - (_local_8 / _local_9))), 0);
                    if (((_arg_1.isMyAvatar) && (_local_3.SP)))
                    {
                        _local_8 = _local_7.intSP;
                        _local_9 = 100;
                        _local_10 = _local_3.SP;
                        if (_local_7.intSP >= 0)
                        {
                            _local_10.strIntSP.text = String(_local_7.intSP);
                        }
                        else
                        {
                            _local_10.strIntSP.text = "100";
                        }
                        if (_local_8 < 0)
                        {
                            _local_8 = 0;
                        }
                        if (_local_8 > _local_9)
                        {
                            _local_8 = _local_9;
                        }
                        _local_10.intSPbar.x = Math.min(-(_local_10.intSPbar.width * (1 - (_local_8 / _local_9))), 0);
                    }
                }
                _local_4++;
            }
        }

        public function getAvatarByUserID(_arg_1:int):Avatar
        {
            var _local_2:String = String(_arg_1);
            if ((_local_2 in avatars))
            {
                return (avatars[_local_2]);
            }
            return null;
        }

        public function getAvatarByUserName(_arg_1:String):Avatar
        {
            var _local_2:String;
            for (_local_2 in avatars)
            {
                if ((((!(avatars[_local_2] == null)) && (!(avatars[_local_2].pnm == null))) && (avatars[_local_2].pnm.toLowerCase() == _arg_1.toLowerCase())))
                {
                    return (avatars[_local_2]);
                }
            }
            return null;
        }

        public function getMCByUserName(_arg_1:*):AvatarMC
        {
            var _local_2:String;
            for (_local_2 in avatars)
            {
                if ((((!(avatars[_local_2] == null)) && (!(avatars[_local_2].pnm == null))) && (avatars[_local_2].pnm.toLowerCase() == _arg_1.toLowerCase())))
                {
                    if (avatars[_local_2].pMC != null)
                    {
                        return (avatars[_local_2].pMC);
                    }
                }
            }
            return null;
        }

        public function getMCByUserID(_arg_1:*):AvatarMC
        {
            if (((!(avatars[_arg_1] == undefined)) && (!(avatars[_arg_1].pMC == null))))
            {
                return (avatars[_arg_1].pMC);
            }
            return null;
        }

        public function getUserByName(_arg_1:*):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_2:Array = rootClass.sfc.getAllRooms();
            for (_local_3 in _local_2)
            {
                _local_4 = _local_2[_local_3];
                for (_local_5 in _local_4.getUserList())
                {
                    _local_6 = _local_4.getUserList()[_local_5];
                    if (String(_local_6.getName()) == _arg_1)
                    {
                        return (_local_6);
                    }
                }
            }
            return null;
        }

        public function getUserById(_arg_1:Number):*
        {
            return (rootClass.sfc.getRoom(curRoom).getUser(Number(_arg_1)));
        }

        public function getUoLeafById(_arg_1:*):Object
        {
            var _local_2:Object;
            for each (_local_2 in uoTree)
            {
                if (_local_2.entID == _arg_1)
                {
                    return (_local_2);
                }
            }
            return null;
        }

        public function getUoLeafByName(_arg_1:String):Object
        {
            var _local_2:Object;
            _arg_1 = _arg_1.toLowerCase();
            for each (_local_2 in uoTree)
            {
                if (_local_2.uoName == _arg_1)
                {
                    return (_local_2);
                }
            }
            return null;
        }

        public function getUserDataById(_arg_1:*):*
        {
            rootClass.sfc.sendXtMessage("zm", "retrieveUserData", [_arg_1], "str", curRoom);
        }

        public function getUserDataByIds(_arg_1:Array):*
        {
            rootClass.sfc.sendXtMessage("zm", "retrieveUserDatas", _arg_1, "str", curRoom);
        }

        public function getUsersByCell(_arg_1:String):Array
        {
            var _local_3:String;
            var _local_2:Array = [];
            for (_local_3 in avatars)
            {
                if (avatars[_local_3].dataLeaf.strFrame == _arg_1)
                {
                    _local_2.push(avatars[_local_3]);
                }
            }
            return (_local_2);
        }

        public function getAllAvatarsInCell():Array
        {
            var _local_1:Array = [];
            _local_1 = getMonstersByCell(myAvatar.dataLeaf.strFrame);
            return (_local_1.concat(getUsersByCell(myAvatar.dataLeaf.strFrame)));
        }

        private function lookAtValue(_arg_1:String, _arg_2:int):Number
        {
            return (parseInt(_arg_1.charAt(_arg_2), 36));
        }

        private function updateValue(_arg_1:*, _arg_2:int, _arg_3:Number):String
        {
            var _local_4:String;
            if (((_arg_3 >= 0) && (_arg_3 < 10)))
            {
                _local_4 = String(_arg_3);
            }
            else
            {
                if (((_arg_3 >= 10) && (_arg_3 < 36)))
                {
                    _local_4 = String.fromCharCode((_arg_3 + 55));
                }
                else
                {
                    _local_4 = "0";
                }
            }
            return (rootClass.strSetCharAt(_arg_1, _arg_2, _local_4));
        }

        public function getQuestValue(_arg_1:Number):Number
        {
            var _local_2:int;
            var _local_3:String;
            if (((!(myAvatar == null)) && (!(myAvatar.objData == null))))
            {
                _local_2 = int((_arg_1 / 100));
                _local_3 = ((_local_2 > 0) ? ("strQuests" + (_local_2 + 1)) : "strQuests");
                if (myAvatar.objData[_local_3] == null)
                {
                    return (-1);
                }
                return (lookAtValue(myAvatar.objData[_local_3], (_arg_1 - (_local_2 * 100))));
            }
            return (-1);
        }

        public function setQuestValue(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:int = int((_arg_1 / 100));
            var _local_4:String = ((_local_3 > 0) ? ("strQuests" + (_local_3 + 1)) : "strQuests");
            if ((_local_4 in myAvatar.objData))
            {
                myAvatar.objData[_local_4] = updateValue(myAvatar.objData[_local_4], (_arg_1 - (_local_3 * 100)), _arg_2);
            }
        }

        public function sendUpdateQuestRequest(_arg_1:Number, _arg_2:Number):void
        {
            rootClass.sfc.sendXtMessage("zm", "updateQuest", [_arg_1, _arg_2], "str", curRoom);
        }

        public function setHomeTownCurrent():void
        {
            rootClass.sfc.sendXtMessage("zm", "setHomeTown", [], "str", curRoom);
            myAvatar.objData.strHomeTown = myAvatar.objData.strMapName;
        }

        public function setHomeTown(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "setHomeTown", [_arg_1], "str", curRoom);
            myAvatar.objData.strHomeTown = _arg_1;
        }

        private function isHouseOrRegularFull():Boolean
        {
            return (((rootClass.ui.mcPopup.currentLabel == "Bank") && (myAvatar.items.length >= myAvatar.objData.iBagSlots)) || ((rootClass.ui.mcPopup.currentLabel == "HouseBank") && (myAvatar.houseitems.length >= myAvatar.objData.iHouseSlots)));
        }

        public function sendBankFromInvRequest(_arg_1:Object):*
        {
            var _local_2:ModalMC;
            var _local_3:Object;
            if (_arg_1.bEquip)
            {
                _local_2 = new ModalMC();
                _local_3 = {};
                _local_3.strBody = "You must unequip the item before storing it in the bank!";
                _local_3.params = {};
                _local_3.glow = "red,medium";
                _local_3.btns = "mono";
                rootClass.ui.ModalStack.addChild(_local_2);
                _local_2.init(_local_3);
            }
            else
            {
                if (((_arg_1.bCoins == 0) && (myAvatar.iBankCount >= myAvatar.objData.iBankSlots)))
                {
                    _local_2 = new ModalMC();
                    _local_3 = {};
                    _local_3.strBody = "You have exceeded your maximum bank storage for non-AC items!";
                    _local_3.params = {};
                    _local_3.glow = "red,medium";
                    _local_3.btns = "mono";
                    rootClass.ui.ModalStack.addChild(_local_2);
                    _local_2.init(_local_3);
                }
                else
                {
                    rootClass.sfc.sendXtMessage("zm", "bankFromInv", [_arg_1.ItemID, _arg_1.CharItemID], "str", curRoom);
                }
            }
        }

        public function sendBankToInvRequest(_arg_1:Object):*
        {
            var _local_2:*;
            var _local_3:*;
            if (isHouseOrRegularFull())
            {
                _local_2 = new ModalMC();
                _local_3 = {};
                _local_3.strBody = "You have exceeded your maximum inventory storage!";
                _local_3.params = {};
                _local_3.glow = "red,medium";
                _local_3.btns = "mono";
                rootClass.ui.ModalStack.addChild(_local_2);
                _local_2.init(_local_3);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "bankToInv", [_arg_1.ItemID, _arg_1.CharItemID], "str", curRoom);
            }
        }

        public function sendBankSwapInvRequest(_arg_1:Object, _arg_2:Object):*
        {
            var _local_3:ModalMC;
            var _local_4:Object;
            if (_arg_2.bEquip)
            {
                _local_3 = new ModalMC();
                _local_4 = {};
                _local_4.strBody = "You must unequip the item before storing it in the bank!";
                _local_4.params = {};
                _local_4.glow = "red,medium";
                _local_4.btns = "mono";
                rootClass.ui.ModalStack.addChild(_local_3);
                _local_3.init(_local_4);
            }
            else
            {
                if ((((_arg_2.bCoins == 0) && (_arg_1.bCoins == 1)) && (myAvatar.iBankCount >= myAvatar.objData.iBankSlots)))
                {
                    _local_3 = new ModalMC();
                    _local_4 = {};
                    _local_4.strBody = "You have exceeded your maximum bank storage for non-AC items!";
                    _local_4.params = {};
                    _local_4.glow = "red,medium";
                    _local_4.btns = "mono";
                    rootClass.ui.ModalStack.addChild(_local_3);
                    _local_3.init(_local_4);
                }
                else
                {
                    rootClass.sfc.sendXtMessage("zm", "bankSwapInv", [_arg_2.ItemID, _arg_2.CharItemID, _arg_1.ItemID, _arg_1.CharItemID], "str", curRoom);
                }
            }
        }

        public function getInventory(_arg_1:*):*
        {
            rootClass.sfc.sendXtMessage("zm", "retrieveInventory", [_arg_1], "str", curRoom);
        }

        public function sendChangeColorRequest(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "changeColor", [_arg_1, _arg_2, _arg_3, _arg_4, hairshopinfo.HairShopID], "str", curRoom);
        }

        public function sendChangeArmorColorRequest(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "changeArmorColor", [_arg_1, _arg_2, _arg_3], "str", curRoom);
        }

        public function sendLoadBankRequest(_arg_1:Array=null):void
        {
            if (_arg_1[0] == "*")
            {
                _arg_1 = ["All"];
            }
            bankinfo.addRequestedTypes(_arg_1);
            rootClass.sfc.sendXtMessage("zm", "loadBank", _arg_1, "str", curRoom);
        }

        public function sendLoadAuctionRequest(sTypes:Array = null):void{
            var _local2: String;
            if (sTypes[0] == "*") {
                sTypes = ["All"];
            }
            for each (_local2 in sTypes) {
                this.auctioninfo.hasRequested[_local2] = true;
            }
            this.rootClass.sfc.sendXtMessage("zm", "loadAuction", sTypes, "str", this.curRoom);
        }

        public function sendLoadRetrieveRequest(sTypes:Array = null):void{
            var _local2: String;
            if (sTypes[0] == "*") {
                sTypes = ["All"];
            }
            for each (_local2 in sTypes) {
                this.retrieveinfo.hasRequested[_local2] = true;
            }
            this.rootClass.sfc.sendXtMessage("zm", "loadRetrieve", sTypes, "str", this.curRoom);
        }

        public function sendReloadShopRequest(_arg_1:int):void
        {
            if ((((!(shopinfo == null)) && (shopinfo.ShopID == _arg_1)) && (!(shopinfo.bLimited == null))))
            {
                rootClass.sfc.sendXtMessage("zm", "reloadShop", [_arg_1], "str", curRoom);
            }
        }

        public function sendLoadShopRequest(_arg_1:int):void
        {
            if (((shopinfo == null) || ((!(shopinfo.ShopID == _arg_1)) || (shopinfo.bLimited))))
            {
                if (coolDown("loadShop"))
                {
                    rootClass.menuClose();
                    rootClass.sfc.sendXtMessage("zm", "loadShop", [_arg_1], "str", curRoom);
                }
            }
            else
            {
                rootClass.menuClose();
                if (shopinfo.bHouse == 1)
                {
                    rootClass.ui.mcPopup.fOpen("HouseShop");
                }
                else
                {
                    if (rootClass.isMergeShop(shopinfo))
                    {
                        rootClass.ui.mcPopup.fOpen("MergeShop");
                    }
                    else
                    {
                        rootClass.ui.mcPopup.fOpen("Shop");
                    }
                }
            }
        }

        public function sendLoadHairShopRequest(_arg_1:int):void
        {
            if (((hairshopinfo == null) || (!(hairshopinfo.HairShopID == _arg_1))))
            {
                rootClass.sfc.sendXtMessage("zm", "loadHairShop", [_arg_1], "str", curRoom);
            }
            else
            {
                rootClass.openCharacterCustomize();
            }
        }

        public function sendLoadEnhShopRequest(_arg_1:int):void
        {
            var _local_2:ModalMC = new ModalMC();
            var _local_3:Object = {};
            _local_3.strBody = "Old enhancement shops are disabled on the PTR.  Please visit Battleon for the new shops.";
            _local_3.params = {};
            _local_3.btns = "mono";
            rootClass.ui.ModalStack.addChild(_local_2);
            _local_2.init(_local_3);
        }

        public function sendEnhItemRequest(_arg_1:Object):void
        {
            enhItem = _arg_1;
            rootClass.sfc.sendXtMessage("zm", "enhanceItem", [_arg_1.ItemID, _arg_1.EnhID, enhShopID], "str", curRoom);
        }

        public function sendEnhItemRequestShop(_arg_1:Array, _arg_2:Object):void
        {
            var _local_3:*;
            var _local_4:*;
            if (coolDown("buyItem"))
            {
                enhItem = _arg_1;
                if (myAvatar.objData.intGold < (_arg_2.iCost * _arg_1.length))
                {
                    rootClass.MsgBox.notify("Insufficient Funds!");
                    return;
                }
                _local_3 = new ModalMC();
                _local_4 = {};
                _local_4.params = {
                    "item":_arg_1,
                    "enh":_arg_2
                };
                _local_4.strBody = (((("Are you sure you want to enhance " + _arg_1.length) + " item(s) for ") + rootClass.strNumWithCommas((_arg_2.iCost * _arg_1.length))) + " gold?");
                _local_4.callback = confirmSendEnhItemRequestShop;
                _local_4.glow = "white,medium";
                _local_4.greedy = true;
                rootClass.ui.ModalStack.addChild(_local_3);
                _local_3.init(_local_4);
            }
        }

        public function confirmSendEnhItemRequestShop(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "enhanceItemShop", [_arg_1.item, _arg_1.enh.ItemID, shopinfo.ShopID], "str", curRoom);
            }
        }

        public function sendEnhItemRequestLocal(_arg_1:Array, _arg_2:Object):void
        {
            if (coolDown("buyItem"))
            {
                enhItem = _arg_1;
                rootClass.sfc.sendXtMessage("zm", "enhanceItemLocal", [_arg_1[0], _arg_2.ItemID], "str", curRoom);
            }
        }

        public function sendBuyItemRequest(_arg_1:Object):void
        {
            if (coolDown("buyItem"))
            {
                if (((_arg_1.bStaff == 1) && (myAvatar.objData.intAccessLevel < 40)))
                {
                    rootClass.MsgBox.notify("Test Item: Cannot be purchased yet!");
                }
                else
                {
                    if (((!(shopinfo.sField == "")) && (!(getAchievement(shopinfo.sField, shopinfo.iIndex) == 1))))
                    {
                        rootClass.MsgBox.notify("Item Locked: Special requirement not met.");
                    }
                    else
                    {
                        if (((_arg_1.bUpg == 1) && (!(myAvatar.isUpgraded()))))
                        {
                            rootClass.showUpgradeWindow();
                        }
                        else
                        {
                            if (((_arg_1.FactionID > 1) && (myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep)))
                            {
                                rootClass.MsgBox.notify("Item Locked: Reputation Requirement not met.");
                            }
                            else
                            {
                                if (!rootClass.validateArmor(_arg_1))
                                {
                                    rootClass.MsgBox.notify("Item Locked: Class Requirement not met.");
                                }
                                else
                                {
                                    if (((_arg_1.iQSindex >= 0) && (getQuestValue(_arg_1.iQSindex) < int(_arg_1.iQSvalue))))
                                    {
                                        rootClass.MsgBox.notify("Item Locked: Quest Requirement not met.");
                                    }
                                    else
                                    {
                                        if ((((myAvatar.isItemInInventory(_arg_1.ItemID)) || (myAvatar.isItemInBank(_arg_1.ItemID))) && (myAvatar.isItemStackMaxed(_arg_1.ItemID))))
                                        {
                                            rootClass.MsgBox.notify((("You cannot have more than " + _arg_1.iStk) + " of that item!"));
                                        }
                                        else
                                        {
                                            if (((_arg_1.bCoins == 0) && (_arg_1.iCost > myAvatar.objData.intGold)))
                                            {
                                                rootClass.MsgBox.notify("Insufficient Funds!");
                                            }
                                            else
                                            {
                                                if (((_arg_1.bCoins == 1) && (_arg_1.iCost > myAvatar.objData.intCoins)))
                                                {
                                                    rootClass.MsgBox.notify("Insufficient Funds!");
                                                }
                                                else
                                                {
                                                    if ((((!(rootClass.isHouseItem(_arg_1))) && (myAvatar.items.length >= myAvatar.objData.iBagSlots)) || ((rootClass.isHouseItem(_arg_1)) && (myAvatar.houseitems.length >= myAvatar.objData.iHouseSlots))))
                                                    {
                                                        rootClass.MsgBox.notify("Inventory Full!");
                                                    }
                                                    else
                                                    {
                                                        if (((shopBuyItem == null) || (!(shopBuyItem.ShopItemID == _arg_1.ShopItemID))))
                                                        {
                                                            shopBuyItem = _arg_1;
                                                        }
                                                        rootClass.sfc.sendXtMessage("zm", "buyItem", [shopBuyItem.ItemID, shopinfo.ShopID, shopBuyItem.ShopItemID], "str", curRoom);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public function sendBuyAuctionItemRequest(_arg1: Object): void {
            var _local2: int;
            if (this.coolDown("buyItem")) {
                if ((((_arg1.bStaff == 1)) && ((this.myAvatar.objData.intAccessLevel < 40)))) {
                    this.rootClass.MsgBox.notify("Test Item: Cannot be purchased yet!");
                } else {
                    if ((((_arg1.bUpg == 1)) && (!(this.myAvatar.isUpgraded())))) {
                        this.rootClass.showUpgradeWindow();
                    } else {
                        if ((((_arg1.FactionID >= 1)) && ((this.myAvatar.getRep(_arg1.FactionID) < _arg1.iReqRep)))) {
                            this.rootClass.MsgBox.notify("Item Locked: Reputation Requirement not met.");
                        } else {
                            if (!this.rootClass.validateArmor(_arg1)) {
                                this.rootClass.MsgBox.notify("Item Locked: Class Requirement not met.");
                            } else {
                                if ((((_arg1.iQSindex >= 0)) && ((this.getQuestValue(_arg1.iQSindex) < int(_arg1.iQSvalue))))) {
                                    this.rootClass.MsgBox.notify("Item Locked: Quest Requirement not met.");
                                } else {
                                    if (((((this.myAvatar.isItemInInventory(_arg1.ItemID)) || (this.myAvatar.isItemInBank(_arg1.ItemID)))) && (this.myAvatar.isItemStackMaxed(_arg1.ItemID)))) {
                                        this.rootClass.MsgBox.notify((("You cannot have more than " + _arg1.iStk) + " of that item!"));
                                    } else {
                                        if (((((!(this.rootClass.isHouseItem(_arg1))) && ((this.myAvatar.items.length >= this.myAvatar.objData.iBagSlots)))) || (((this.rootClass.isHouseItem(_arg1)) && ((this.myAvatar.houseitems.length >= this.myAvatar.objData.iHouseSlots)))))) {
                                            this.rootClass.MsgBox.notify("Inventory Full!");
                                        } else {
                                            this.rootClass.sfc.sendXtMessage("zm", "buyAuctionItem", [_arg1.AuctionID], "str", this.curRoom);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public function sendBuyItemRequestWithQuantity(_arg_1:Object):*
        {
            if (_arg_1.accept)
            {
                shopBuyItem = _arg_1.iSel;
                rootClass.sfc.sendXtMessage("zm", "buyItem", [_arg_1.iSel.ItemID, shopinfo.ShopID, _arg_1.iSel.ShopItemID, _arg_1.iQty], "str", curRoom);
            }
        }

        public function maximumShopBuys(_arg_1:Object):int
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            if (_arg_1 == null)
            {
                return (0);
            }
            var _local_2:* = myAvatar.getItemByID(_arg_1.ItemID);
            if (_arg_1.sES == "ar")
            {
                return (1);
            }
            var _local_3:Number = ((_local_2 != null) ? (_arg_1.iStk - _local_2.iQty) : _arg_1.iStk);
            if (_local_3 < 1)
            {
                return (0);
            }
            if (_arg_1.iCost > 0)
            {
                _local_4 = ((_arg_1.bCoins == 1) ? Math.floor((myAvatar.objData.intCoins / _arg_1.iCost)) : Math.floor((myAvatar.objData.intGold / _arg_1.iCost)));
                _local_3 = Math.min(_local_4, _local_3);
            }
            if (_arg_1.turnin != null)
            {
                _local_5 = 0;
                while (_local_5 < _arg_1.turnin.length)
                {
                    _local_6 = _arg_1.turnin[_local_5];
                    _local_7 = myAvatar.getItemByID(_local_6.ItemID);
                    if (_local_7 == null)
                    {
                        return (0);
                    }
                    _local_8 = Math.floor((_local_7.iQty / _local_6.iQty));
                    if (_local_8 == 0)
                    {
                        return (0);
                    }
                    _local_3 = Math.min(_local_3, _local_8);
                    _local_5++;
                }
                _local_3 = (_local_3 * _arg_1.iQty);
            }
            _local_3 = Math.min(_local_3, 100000);
            return (Math.min(_local_3, ((_local_2 != null) ? (_arg_1.iStk - _local_2.iQty) : _arg_1.iStk)));
        }

        public function sendSellItemRequest(_arg_1:Object):void
        {
            if (coolDown("sellItem"))
            {
                rootClass.sfc.sendXtMessage("zm", "sellItem", [_arg_1.ItemID, _arg_1.iQty, _arg_1.CharItemID], "str", curRoom);
            }
        }

        public function sendSellItemRequestWithQuantity(_arg_1:Object):*
        {
            if (_arg_1.accept)
            {
                if (coolDown("sellItem"))
                {
                    rootClass.sfc.sendXtMessage("zm", "sellItem", [_arg_1.iSel.ItemID, _arg_1.iQty, _arg_1.iSel.CharItemID], "str", curRoom);
                }
            }
        }

        public function maximumShopSells(_arg_1:Object):int
        {
            if (_arg_1.sES == "ar")
            {
                return (1);
            }
            var _local_2:* = myAvatar.getItemByID(_arg_1.ItemID);
            return ((_local_2 == null) ? 0 : _local_2.iQty);
        }

        public function sendRemoveItemRequest(_arg_1:Object, _arg_2:int=1):void
        {
            if (_arg_1 == null)
            {
                return;
            }
            if (_arg_2 == 1)
            {
                rootClass.sfc.sendXtMessage("zm", "removeItem", [_arg_1.ItemID, _arg_1.CharItemID], "str", curRoom);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "removeItem", [_arg_1.ItemID, _arg_1.CharItemID, _arg_2], "str", curRoom);
            }
        }

        public function sendRemoveTempItemRequest(_arg_1:int, _arg_2:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "removeTempItem", [_arg_1, _arg_2], "str", curRoom);
            myAvatar.removeTempItem(_arg_1, _arg_2);
        }

        public function sendEquipItemRequest(_arg_1:Object):Boolean
        {
            var _local_2:Boolean = true;
            if (((!(_arg_1 == null)) && (!(myAvatar.isItemEquipped(_arg_1.ItemID)))))
            {
                if (coolDown("equipItem"))
                {
                    rootClass.sfc.sendXtMessage("zm", "equipItem", [_arg_1.ItemID], "str", curRoom);
                }
                else
                {
                    _local_2 = false;
                }
            }
            else
            {
                _local_2 = false;
            }
            return (_local_2);
        }

        public function sendForceEquipRequest(_arg_1:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "forceEquipItem", [_arg_1], "str", curRoom);
        }

        public function sendUnequipItemRequest(_arg_1:Object):void
        {
            if (((!(_arg_1 == null)) && (myAvatar.isItemEquipped(_arg_1.ItemID))))
            {
                if (coolDown("unequipItem"))
                {
                    rootClass.sfc.sendXtMessage("zm", "unequipItem", [_arg_1.ItemID], "str", curRoom);
                }
            }
        }

        public function sendChangeClassRequest(_arg_1:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "changeClass", [_arg_1], "str", curRoom);
        }

        public function selfMute(_arg_1:int=1):void
        {
            rootClass.sfc.sendXtMessage("zm", "cmd", ["mute", _arg_1, myAvatar.objData.strUsername.toLowerCase()], "str", rootClass.world.curRoom);
        }

        public function equipUseableItem(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_4:Object;
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < actions.active.length)
            {
                if (((actions.active[_local_3]) && (actions.active[_local_3].ref == "i1")))
                {
                    _local_2 = actions.active[_local_3];
                }
                _local_3++;
            }
            _local_2.sArg1 = String(_arg_1.ItemID);
            _local_2.sArg2 = String(_arg_1.sDesc);
            rootClass.updateIcons(getActIcons(_local_2), [_arg_1.sFile], _arg_1);
            rootClass.updateActionObjIcon(_local_2);
            _local_3 = 0;
            while (_local_3 < myAvatar.items.length)
            {
                _local_4 = myAvatar.items[_local_3];
                if (((_local_4.sType.toLowerCase() == "item") && (!(_local_4.sLink.toLowerCase() == "none"))))
                {
                    if (_local_4.ItemID == _arg_1.ItemID)
                    {
                        _local_4.bEquip = 1;
                        lockdownPots = true;
                        rootClass.sfc.sendXtMessage("zm", "geia", [_local_4.sLink, _local_4.sMeta, _arg_1.ItemID], "str", rootClass.world.curRoom);
                    }
                    else
                    {
                        _local_4.bEquip = 0;
                    }
                }
                _local_3++;
            }
            if (rootClass.ui.mcPopup.mcInventory != null)
            {
                rootClass.ui.mcPopup.mcInventory.mcItemList.refreshList();
                rootClass.ui.mcPopup.mcInventory.refreshDetail();
            }
        }

        public function unequipUseableItem(_arg_1:Object=null):void
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_4:int;
            _local_4 = 0;
            while (_local_4 < actions.active.length)
            {
                if (((actions.active[_local_4]) && (actions.active[_local_4].ref == "i1")))
                {
                    _local_2 = actions.active[_local_4];
                }
                _local_4++;
            }
            _local_2.sArg1 = "";
            _local_2.sArg2 = "";
            rootClass.updateIcons(getActIcons(_local_2), ["icu1"], null);
            if (_arg_1 == null)
            {
                _local_4 = 0;
                while (_local_4 < myAvatar.items.length)
                {
                    _local_3 = myAvatar.items[_local_4];
                    if (String(_local_3.ItemID) == _local_2.sArg1)
                    {
                        _arg_1 = _local_3;
                    }
                    _local_4++;
                }
            }
            _arg_1.bEquip = 0;
            if (rootClass.ui.mcPopup.mcInventory != null)
            {
                rootClass.ui.mcPopup.mcInventory.mcItemList.refreshList();
                rootClass.ui.mcPopup.mcInventory.refreshDetail();
            }
        }

        public function tryUseItem(_arg_1:Object):void
        {
            if (_arg_1.sType.toLowerCase() == "clientuse")
            {
                switch (_arg_1.sLink)
                {
                }
            }
            else
            {
                if (_arg_1.sType.toLowerCase() == "serveruse")
                {
                    sendUseItemRequest(_arg_1);
                }
            }
        }

        public function sendUseItemRequest(_arg_1:Object):void
        {
            rootClass.sfc.sendXtMessage("zm", "serverUseItem", ["+", _arg_1.ItemID], "str", -1);
        }

        public function sendUseItemArrayRequest(_arg_1:Array):void
        {
            rootClass.sfc.sendXtMessage("zm", "serverUseItem", _arg_1, "str", -1);
        }

        public function bankHasRequested(_arg_1:Array):Boolean
        {
            return (bankinfo.hasRequested(_arg_1));
        }

        public function tradeHasRequested(_arg1: Array): Boolean {
            var _local2: String;
            for each(_local2 in _arg1) {
                if (!(_local2 in this.tradeinfo.hasRequested)) {
                    return false;
                }
            }
            return true;
        }

        public function auctionHasRequested(_arg1:Array):Boolean{
            var _local2: String;
            for each(_local2 in _arg1) {
                if (!(_local2 in this.auctioninfo.hasRequested)){
                    return false;
                }
            }
            return true;
        }

        public function retrieveHasRequested(_arg1:Array):Boolean{
            var _local2: String;
            for each(_local2 in _arg1) {
                if (!(_local2 in this.retrieveinfo.hasRequested)){
                    return false;
                }
            }
            return true;
        }

        public function addItemsToBank(_arg_1:Array):void
        {
            bankinfo.addItemsToBank(_arg_1);
        }

        public function addItemsToTradeA(_arg1: Array): void {
            var _local3: Object;
            var _local4: Object;
            var _local2: Boolean = true;
            for each(_local3 in _arg1) {
                _local2 = true;
                for each(_local4 in this.tradeinfo.itemsA) {
                    if (_local4.ItemID == _local3.ItemID) {
                        _local4.iQty = _local3.iQty;
                        _local2 = false;
                        break;
                    }
                }
                if (_local2) {
                    this.tradeinfo.itemsA.push(_local3);
                }
            }
        }

        public function addItemsToTradeB(_arg1: Array): void {
            var _local3: Object;
            var _local4: Object;
            var _local2: Boolean = true;
            for each(_local3 in _arg1) {
                _local2 = true;
                for each(_local4 in this.tradeinfo.itemsB) {
                    if (_local4.ItemID == _local3.ItemID) {
                        _local2 = false;
                        break;
                    }
                }
                if (_local2) {
                    this.tradeinfo.itemsB.push(_local3);
                }
            }
        }

        public function addItemsToAuction(_arg1:Array):void{
            var _local3: Object;
            var _local4: Object;
            var _local2: Boolean = true;
            for each(_local3 in _arg1){
                _local2 = true;
                for each(_local4 in this.auctioninfo.items){
                    if (_local4.AuctionID == _local3.AuctionID){
                        _local2 = false;
                        break;
                    }
                }
                if (_local2){
                    this.auctioninfo.items.push(_local3);
                }
            }
        }

        public function addItemsToRetrieve(_arg1:Array): void{
            var _local3: Object;
            var _local4: Object;
            var _local2: Boolean = true;
            for each(_local3 in _arg1) {
                _local2 = true;
                for each(_local4 in this.retrieveinfo.items){
                    if (_local4.AuctionID == _local3.AuctionID){
                        _local2 = false;
                        break;
                    }
                }
                if (_local2) {
                    this.retrieveinfo.items.push(_local3);
                }
            }
        }

        public function toggleBank():void
        {
            if (myAvatar.bank == null)
            {
                rootClass.getBank();
            }
            if (!uiLock)
            {
                if (rootClass.ui.mcPopup.currentLabel == "Bank")
                {
                    MovieClip(rootClass.ui.mcPopup.getChildByName("mcBank")).fClose();
                }
                else
                {
                    rootClass.ui.mcPopup.fOpen("Bank");
                }
            }
        }

        public function toggleHouseBank():void
        {
            if (myAvatar.bank == null)
            {
                rootClass.getBank();
            }
            if (!uiLock)
            {
                if (rootClass.ui.mcPopup.currentLabel == "HouseBank")
                {
                    MovieClip(rootClass.ui.mcPopup.getChildByName("mcBank")).fClose();
                }
                else
                {
                    rootClass.ui.mcPopup.fOpen("HouseBank");
                }
            }
        }

        public function sendReport(_arg_1:Array):void
        {
            rootClass.sfc.sendXtMessage("zm", "cmd", _arg_1, "str", rootClass.world.curRoom);
        }

        public function sendWhoRequest():void
        {
            if (coolDown("who"))
            {
                rootClass.sfc.sendXtMessage("zm", "cmd", ["who"], "str", curRoom);
            }
        }

        public function sendRewardReferralRequest(_arg_1:*):void
        {
            rootClass.sfc.sendXtMessage("zm", "rewardReferral", [], "str", curRoom);
        }

        public function sendGetAdDataRequest():void
        {
            if (rootClass.world.myAvatar.objData.iDailyAds < rootClass.world.myAvatar.objData.iDailyAdCap)
            {
                rootClass.sfc.sendXtMessage("zm", "getAdData", [], "str", curRoom);
            }
        }

        public function sendGetAdRewardRequest():void
        {
            if (rootClass.world.myAvatar.objData.iDailyAds < rootClass.world.myAvatar.objData.iDailyAdCap)
            {
                rootClass.sfc.sendXtMessage("zm", "getAdReward", [], "str", curRoom);
            }
        }

        public function sendWarVarsRequest():void
        {
            rootClass.sfc.sendXtMessage("zm", "loadWarVars", [], "str", curRoom);
        }

        public function loadQuestStringData():void
        {
            rootClass.sfc.sendXtMessage("zm", "loadQuestStringData", [], "str", curRoom);
        }

        public function buyBagSlots(_arg_1:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "buyBagSlots", [_arg_1], "str", curRoom);
        }

        public function buyBankSlots(_arg_1:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "buyBankSlots", [_arg_1], "str", curRoom);
        }

        public function buyHouseSlots(_arg_1:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "buyHouseSlots", [_arg_1], "str", curRoom);
        }

        public function sendLoadFriendsListRequest():*
        {
            rootClass.sfc.sendXtMessage("zm", "loadFriendsList", [], "str", curRoom);
        }

        public function sendLoadFactionRequest():*
        {
            rootClass.sfc.sendXtMessage("zm", "loadFactions", [], "str", curRoom);
        }

        public function initAchievements():void
        {
            var _local_2:* = myAvatar.objData;
            with (_local_2)
            {
                ip0 = uint(ip0);
                ia0 = uint(ia0);
                ia1 = uint(ia1);
                id0 = uint(id0);
                id1 = uint(id1);
                id2 = uint(id2);
                im0 = uint(im0);
                iq0 = uint(iq0);
            }
        }

        public function getAchievement(_arg_1:String, _arg_2:int):int
        {
            if (((_arg_2 < 0) || (_arg_2 > 31)))
            {
                return (-1);
            }
            var _local_3:* = myAvatar.objData[_arg_1];
            if (_local_3 == null)
            {
                return (-1);
            }
            return (((_local_3 & Math.pow(2, _arg_2)) == 0) ? 0 : 1);
        }

        public function setAchievement(_arg_1:String, _arg_2:int, _arg_3:int=1):void
        {
            var _local_4:* = ["ia0", "iq0"];
            if (((((_local_4.indexOf(_arg_1) >= 0) && (_arg_2 >= 0)) && (_arg_2 < 32)) && (!(getAchievement(_arg_1, _arg_2) == _arg_3))))
            {
                rootClass.sfc.sendXtMessage("zm", "setAchievement", [_arg_1, _arg_2, _arg_3], "str", curRoom);
            }
        }

        public function updateAchievement(_arg_1:String, _arg_2:int, _arg_3:int):void
        {
            if (_arg_3 == 0)
            {
                myAvatar.objData[_arg_1] = (myAvatar.objData[_arg_1] & (~(Math.pow(2, _arg_2))));
            }
            else
            {
                if (_arg_3 == 1)
                {
                    myAvatar.objData[_arg_1] = (myAvatar.objData[_arg_1] | Math.pow(2, _arg_2));
                }
            }
            rootClass.readIA1Preferences();
        }

        public function showFriendsList():void
        {
            var _local_1:*;
            var _local_2:*;
            if ((((!(myAvatar.friends == null)) && (myAvatar.friendsLoaded)) && (((new Date().getTime() - myAvatar.friendsLoaded) / 1000) < 30)))
            {
                _local_1 = {};
                _local_1.typ = "userListFriends";
                for each (_local_2 in myAvatar.friends)
                {
                    _local_2.bOffline = ((_local_2.sServer == rootClass.objServerInfo.sName) ? 0 : ((_local_2.sServer == "Offline") ? 2 : 1));
                }
                myAvatar.friends.sortOn("sName", Array.CASEINSENSITIVE);
                myAvatar.friends.sortOn(["bOffline", "sServer", "sName"], [Array.NUMERIC, Array.CASEINSENSITIVE, Array.CASEINSENSITIVE]);
                _local_1.ul = myAvatar.friends;
                rootClass.ui.mcOFrame.fOpenWith(_local_1);
            }
            else
            {
                myAvatar.friendsLoaded = new Date().getTime();
                rootClass.sfc.sendXtMessage("zm", "getfriendlist", [], "str", -1);
            }
        }

        public function showGuildList():void
        {
            if (myAvatar.objData.guild != null)
            {
                rootClass.ui.mcPopup.fOpen("GuildPanelNew");
            }
            else
            {
                rootClass.MsgBox.notify("You need to create or join a guild first.");
            }
        }

        public function showIgnoreList():void
        {
            var _local_1:Object;
            if (((!(rootClass.chatF.ignoreList.data.users == null)) && (rootClass.chatF.ignoreList.data.users.length > 0)))
            {
                _local_1 = {};
                _local_1.typ = "userListIgnore";
                rootClass.ui.mcOFrame.fOpenWith(_local_1);
            }
            else
            {
                rootClass.chatF.pushMsg("warning", "Your ignore list is empty.", "SERVER", "", 0);
            }
        }

        public function isModerator(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "isModerator", [_arg_1], "str", -1);
        }

        public function toggleName(_arg_1:*, _arg_2:String):*
        {
            if (_arg_2 == "on")
            {
                getMCByUserID(_arg_1).pname.visible = true;
            }
            if (_arg_2 == "off")
            {
                getMCByUserID(_arg_1).pname.visible = false;
            }
        }

        public function toggleHPBar():void
        {
            var _local_1:String;
            var _local_2:MovieClip;
            var _local_3:Avatar;
            showHPBar = (!(showHPBar));
            for (_local_1 in avatars)
            {
                _local_3 = avatars[_local_1];
                if (_local_3.pMC != null)
                {
                    _local_2 = _local_3.pMC;
                    if (showHPBar)
                    {
                        _local_2.showHPBar();
                    }
                    else
                    {
                        _local_2.hideHPBar();
                    }
                }
            }
        }

        public function resPlayer():*
        {
            afkPostpone();
            rootClass.sfc.sendXtMessage("zm", "resPlayerTimed", [rootClass.sfc.myUserId], "str", curRoom);
        }

        public function showResCounter():*
        {
            var _local_1:* = MovieClip(rootClass.ui.mcRes);
            if (_local_1.currentLabel == "in")
            {
                return;
            }
            _local_1.gotoAndPlay("in");
            _local_1.resC = 10;
            if (_local_1.resTimer == null)
            {
                _local_1.resTimer = new Timer(1000);
                _local_1.resTimer.addEventListener("timer", resTimer);
            }
            else
            {
                _local_1.resTimer.reset();
            }
            _local_1.resTimer.start();
        }

        public function resTimer(_arg_1:TimerEvent):*
        {
            var _local_2:* = MovieClip(rootClass.ui.mcRes);
            _local_2.resC--;
            if (_local_2.resC > 0)
            {
                _local_2.mcTomb.ti.text = ("0" + _local_2.resC);
            }
            else
            {
                _local_2.mcTomb.ti.text = "00";
                _arg_1.target.reset();
                _local_2.visible = false;
                _local_2.gotoAndStop(1);
                resPlayer();
            }
        }

        public function danceRequest(_arg_1:*):*
        {
            var _local_2:*;
            if (_arg_1.accept)
            {
                rootClass.chatF.submitMsg(_arg_1.emote1, "emote", rootClass.sfc.myUserName);
            }
            else
            {
                _local_2 = {};
                _local_2.typ = "danceDenied";
                _local_2.cell = strFrame;
                rootClass.sfc.sendObjectToGroup(_local_2, [_arg_1.sender.getId()], curRoom);
            }
        }

        public function rest():void
        {
            if (myAvatar.dataLeaf.intState != 1)
            {
                return;
            }
            if (!restTimer.running)
            {
                rootClass.sfc.sendXtMessage("zm", "restRequest", [""], "str", 1);
                myAvatar.pMC.mcChar.gotoAndPlay("Rest");
                rootClass.sfc.sendXtMessage("zm", "emotea", ["rest"], "str", 1);
                restStart();
            }
        }

        public function restStart():*
        {
            afkPostpone();
            restTimer.reset();
            restTimer.start();
        }

        public function restRequest(_arg_1:TimerEvent):*
        {
            var _local_2:* = getUoLeafById(myAvatar.uid);
            if ((((((!(_local_2.intHP == _local_2.intHPMax)) || (!(_local_2.intMP == _local_2.intMPMax))) || (!(_local_2.intSP == 100))) && (myAvatar.pMC.mcChar.currentLabel == "Rest")) && (_local_2.intState == 1)))
            {
                if (coolDown("rest"))
                {
                    restTimer.reset();
                }
                else
                {
                    restStart();
                }
            }
            else
            {
                restTimer.reset();
            }
        }

        public function afkToggle():void
        {
            var _local_1:* = uoTree[rootClass.sfc.myUserName];
            if (_local_1 != null)
            {
                rootClass.sfc.sendXtMessage("zm", "afk", [(!(_local_1.afk))], "str", 1);
            }
        }

        public function afkTimerHandler(_arg_1:Event):void
        {
            var _local_2:* = uoTree[rootClass.sfc.myUserName];
            if (_local_2 != null)
            {
                rootClass.sfc.sendXtMessage("zm", "afk", [true], "str", 1);
            }
        }

        public function afkPostpone():void
        {
            var _local_1:* = new Date().getTime();
            var _local_2:* = uoTree[rootClass.sfc.myUserName];
            if ((((!(_local_2 == null)) && (_local_2.afk)) && ((_local_2.afkts == null) || (_local_1 > (_local_2.afkts + 500)))))
            {
                rootClass.sfc.sendXtMessage("zm", "afk", [false], "str", 1);
                _local_2.afkts = _local_1;
            }
        }

        public function hideAllPets(_arg_1:Boolean=true):void
        {
            var _local_2:*;
            for (_local_2 in avatars)
            {
                if (!((!(_arg_1)) && (avatars[_local_2] == myAvatar)))
                {
                    if (avatars[_local_2] != null)
                    {
                        avatars[_local_2].unloadPet();
                    }
                }
            }
        }

        public function showAllPets(_arg_1:Boolean=true):void
        {
            var _local_2:*;
            var _local_3:Object;
            var _local_4:*;
            for (_local_2 in avatars)
            {
                if (!((!(_arg_1)) && (avatars[_local_2] == myAvatar)))
                {
                    _local_3 = getUoLeafById(_local_2);
                    _local_4 = String(_local_3.strFrame);
                    if (_local_4 == strFrame)
                    {
                        avatars[_local_2].loadPet();
                    }
                }
            }
        }

        private function monsterUsesDatabasePosition(avt:Avatar):Boolean
        {
            return (
                avt != null &&
                avt.objData != null &&
                ("dbSpawn" in avt.objData) &&
                int(avt.objData.dbSpawn) == 1 &&
                ("X" in avt.objData) &&
                ("Y" in avt.objData)
            );
        }

        private function spawnDatabaseMonstersForCurrentFrame(showMonsterName:Boolean):void
        {
            var avt:Avatar;
            var point:MovieClip;

            if (monsters == null)
            {
                return;
            }

            for each (avt in monsters)
            {
                if (((avt == null) || (!(monsterUsesDatabasePosition(avt)))))
                {
                    continue;
                }
                if (String(avt.objData.strFrame) != strFrame)
                {
                    continue;
                }
                if (avt.pMC != null)
                {
                    continue;
                }

                // createMonsterMC only needs a display object carrying x/y.
                // A small runtime point lets database monsters use the exact
                // same MonsterMC pipeline as legacy map-marker monsters.
                point = new MovieClip();
                point.x = Number(avt.objData.X);
                point.y = Number(avt.objData.Y);

                avt.pMC = createMonsterMC(point, avt.objData.MonID, showMonsterName);
                avt.pMC.scale(SCALE);
                avt.pMC.pAV = avt;
                avt.pMC.setData();

                if (avt.dataLeaf == null)
                {
                    TRASH.addChild(avt.pMC);
                }
                else
                {
                    if (rootClass.litePreference.data.bMonsType)
                    {
                        avt.pMC.pname.typ.text = (("< " + avt.pMC.pAV.objData.sRace) + " >");
                        avt.pMC.pname.typ.visible = (!(avt.pMC.pAV.objData.sRace == "None"));
                    }
                    else
                    {
                        avt.pMC.pname.typ.visible = false;
                    }
                }
            }
        }

        public function updateMonsters():*
        {
            var _local_1:int;
            if (monmap != null)
            {
                _local_1 = 0;
                while (_local_1 < monmap.length)
                {
                    if (monmap[_local_1].strFrame == strFrame)
                    {
                        updateMonster(monmap[_local_1]);
                    }
                    _local_1++;
                }
            }
        }

        public function updateMonster(_arg_1:Object):void
        {
            var _local_2:* = getMonsterDefinition(_arg_1.MonID);
            var _local_3:* = getMonster(_arg_1.MonMapID);
            if (_local_3.pMC == null)
            {
                return;
            }
            _local_3.objData.intMPMax = int(_local_3.objData.intMPMax);
            _local_3.objData.intHPMax = int(_local_3.objData.intMPMax);
            var _local_4:* = monTree[_arg_1.MonMapID];
            if (((!(_local_4.MonID == _local_3.objData.MonID)) || (_local_4.intState == 0)))
            {
                _local_3.pMC.visible = false;
            }
            if (((_local_3.pMC.x < myAvatar.pMC.x) && (_local_4.intState == 1)))
            {
                _local_3.pMC.turn("right");
            }
            else
            {
                if (_local_4.intState == 1)
                {
                    _local_3.pMC.turn("left");
                }
            }
            _local_3.pMC.updateNamePlate();
        }

        public function createMonsterMC(_arg_1:MovieClip, _arg_2:int, _arg_3:Boolean=false):MonsterMC
        {
            var _local_5:MonsterMC;
            var _local_6:int;
            var _local_7:Class;
            var _local_4:* = getMonsterDefinition(_arg_2);
            if (_arg_3)
            {
                _local_6 = int(Math.round((Math.random() * (chaosNames.length - 1))));
                if (chaosNames[_local_6] != rootClass.world.myAvatar.objData.strUsername)
                {
                    _local_5 = new MonsterMC(chaosNames[_local_6]);
                }
                else
                {
                    _local_6 = ((_local_6 == 0) ? ++_local_6 : --_local_6);
                    _local_5 = new MonsterMC(chaosNames[_local_6]);
                }
            }
            else
            {
                if (Number(objExtra["bChar"]) == 1)
                {
                    _local_5 = new MonsterMC(myAvatar.objData.strUsername);
                }
                else
                {
                    _local_5 = new MonsterMC(_local_4.strMonName);
                }
            }
            CHARS.addChild(_local_5);
            _local_5.x = _arg_1.x;
            _local_5.y = _arg_1.y;
            _local_5.ox = _local_5.x;
            _local_5.oy = _local_5.y;
            if (Number(objExtra["bChar"]) == 1)
            {
                _local_5.removeChildAt(1);
                _local_5.addChildAt((new dummyMC() as MovieClip), 1);
                copyAvatarMC((_local_5.getChildAt(1) as MovieClip));
            }
            else
            {
                _local_7 = (loaderD.getDefinition(_local_4.strLinkage) as Class);
                _local_5.removeChildAt(1);
                _local_5.addChildAt(new (_local_7)(), 1);
            }
            _local_5.mouseEnabled = false;
            _local_5.bubble.mouseEnabled = (_local_5.bubble.mouseChildren = false);
            _local_5.init();
            if (("strDir" in _arg_1))
            {
                if (_arg_1.strDir.toLowerCase() == "static")
                {
                    _local_5.isStatic = true;
                }
            }
            if (("noMove" in _arg_1))
            {
                _local_5.noMove = _arg_1.noMove;
            }
            if (rootClass.litePreference.data.bFreezeMons)
            {
                _local_5.noMove = true;
            }
            if (rootClass.litePreference.data.bMonsType)
            {
                _local_5.pname.typ.text = (("< " + _local_4.sRace) + " >");
                _local_5.pname.typ.visible = (!(_local_4.sRace == "None"));
            }
            else
            {
                _local_5.pname.typ.visible = false;
            }
            return (_local_5);
        }

        public function getMonDataById():*
        {
        }

        public function retrieveMonData():*
        {
            rootClass.sfc.sendXtMessage("zm", "retrieveMonData", [], "str", 1);
        }

        private function getMonID(_arg_1:int):int
        {
            var _local_2:String;
            var _local_3:*;
            for (_local_2 in monTree)
            {
                _local_3 = monTree[_local_2];
                if (_local_3.MonMapID == _arg_1)
                {
                    return (_local_3.MonID);
                }
            }
            return (-1);
        }

        private function getMonsterDefinition(_arg_1:int):Object
        {
            var _local_2:int;
            while (_local_2 < mondef.length)
            {
                if (mondef[_local_2].MonID == _arg_1)
                {
                    return (mondef[_local_2]);
                }
                _local_2++;
            }
            return null;
        }

        public function getMonster(_arg_1:int):Avatar
        {
            var _local_2:int;
            while (_local_2 < monsters.length)
            {
                if (((monsters[_local_2].objData.MonMapID == _arg_1) && (monsters[_local_2].objData.MonID == monTree[_arg_1].MonID)))
                {
                    return (monsters[_local_2]);
                }
                _local_2++;
            }
            return null;
        }

        public function getMonsters(_arg_1:int):Array
        {
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < monsters.length)
            {
                if (monsters[_local_3].objData.MonMapID == _arg_1)
                {
                    _local_2.push(monsters[_local_3]);
                }
                _local_3++;
            }
            if (_local_2.length > 0)
            {
                return (_local_2);
            }
            return null;
        }

        public function getMonsterCluster(_arg_1:int):Array
        {
            var _local_2:* = [];
            var _local_3:int;
            while (_local_3 < monsters.length)
            {
                if (monsters[_local_3].objData.MonMapID == _arg_1)
                {
                    _local_2.push(monsters[_local_3]);
                }
                _local_3++;
            }
            return (_local_2);
        }

        public function getMonstersByCell(_arg_1:String):Array
        {
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < monsters.length)
            {
                if (((!(monsters[_local_3].dataLeaf == null)) && (monsters[_local_3].dataLeaf.strFrame == _arg_1)))
                {
                    _local_2.push(monsters[_local_3]);
                }
                _local_3++;
            }
            return (_local_2);
        }

        public function initMonsters(_arg_1:Array, _arg_2:Array):*
        {
            var _local_4:Object;
            var _local_5:int;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_3:int;
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                monswf = [];
                monsters = [];
                _local_4 = null;
                _local_3 = 0;
                while (_local_3 < _arg_2.length)
                {
                    _local_5 = 0;
                    while (_local_5 < _arg_1.length)
                    {
                        if (_arg_2[_local_3].MonID == _arg_1[_local_5].MonID)
                        {
                            _local_4 = _arg_1[_local_5];
                        }
                        _local_5++;
                    }
                    monsters.push(new Avatar(rootClass));
                    _local_6 = monsters[(monsters.length - 1)];
                    _local_6.npcType = "monster";
                    if (_local_6.objData == null)
                    {
                        _local_6.objData = {};
                    }
                    for (_local_7 in _local_4)
                    {
                        _local_6.objData[_local_7] = _local_4[_local_7];
                    }
                    for (_local_7 in _arg_2[_local_3])
                    {
                        _local_6.objData[_local_7] = _arg_2[_local_3][_local_7];
                    }
                    _local_8 = monTree[String(_local_6.objData.MonMapID)];
                    _local_8.strFrame = String(_local_6.objData.strFrame);
                    if (_local_8.MonID == _local_6.objData.MonID)
                    {
                        _local_6.dataLeaf = monTree[_local_6.objData.MonMapID];
                    }
                    else
                    {
                        _local_6.dataLeaf = null;
                    }
                    _local_3++;
                }
                _local_3 = 0;
                while (_local_3 < _arg_1.length)
                {
                    var monFileName:String = "mon/" + _arg_1[_local_3].strMonFileName;

                    queueLoad({
                        "strFile": rootClass.getFilePath() + monFileName,
                        "callBackA":rootClass.onLoadMaster(onMonLoadComplete, loaderC, monFileName)
                    });
                    _local_3++;
                }
            }
        }

        private function onMonLoadComplete(_arg_1:Event):*
        {
            monswf.push(MovieClip(Loader(_arg_1.target.loader).content));
            if (monswf.length == mondef.length)
            {
                enterMap();
            }
        }

        public function toggleMonsters():*
        {
            var _local_1:DisplayObject;
            rootClass.ui.monsterIcon.redX.visible = showMonsters;
            showMonsters = (!(showMonsters));
            var _local_2:int;
            while (_local_2 < CHARS.numChildren)
            {
                _local_1 = CHARS.getChildAt(_local_2);
                if (((_local_1.hasOwnProperty("isMonster")) && (MovieClip(_local_1).isMonster)))
                {
                    MovieClip(_local_1).setVisible();
                }
                _local_2++;
            }
        }

        public function setTarget(_arg_1:*):*
        {
            if (((strMapName == "caroling") && (CarolingMonsterKillCount >= 5)))
            {
                if (((!(_arg_1 == null)) && (!(_arg_1.npcType == "player"))))
                {
                    return;
                }
            }
            if (((((!(myAvatar == null)) && (!(_arg_1 == null))) && (_arg_1.npcType == "player")) && (_arg_1.isMyAvatar)))
            {
                if (rootClass.litePreference.data.bUntargetSelf)
                {
                    return;
                }
            }
            if (((!(myAvatar == null)) && (!(myAvatar.target == _arg_1))))
            {
                if (myAvatar.target != null)
                {
                    if (myAvatar.target.npcType == "monster")
                    {
                        if ((((bPvP) && (!(myAvatar.target.dataLeaf.react == null))) && (myAvatar.target.dataLeaf.react[myAvatar.dataLeaf.pvpTeam] == 1)))
                        {
                            myAvatar.target.pMC.modulateColor(avtPCT, "-");
                        }
                        else
                        {
                            myAvatar.target.pMC.modulateColor(avtMCT, "-");
                        }
                    }
                    if (myAvatar.target.npcType == "player")
                    {
                        if (((bPvP) && (!(myAvatar.target.dataLeaf.pvpTeam == myAvatar.dataLeaf.pvpTeam))))
                        {
                            myAvatar.target.pMC.modulateColor(avtMCT, "-");
                        }
                        else
                        {
                            myAvatar.target.pMC.modulateColor(avtPCT, "-");
                        }
                    }
                }
                if (_arg_1 != null)
                {
                    if (((!(bPvP)) && (_arg_1.npcType == "player")))
                    {
                        if (autoActionTimer != null)
                        {
                            cancelAutoAttack();
                        }
                    }
                    myAvatar.target = _arg_1;
                    if (myAvatar.target.npcType == "monster")
                    {
                        if ((((bPvP) && (!(myAvatar.target.dataLeaf.react == null))) && (myAvatar.target.dataLeaf.react[myAvatar.dataLeaf.pvpTeam] == 1)))
                        {
                            myAvatar.target.pMC.modulateColor(avtPCT, "+");
                        }
                        else
                        {
                            myAvatar.target.pMC.modulateColor(avtMCT, "+");
                        }
                    }
                    if (myAvatar.target.npcType == "player")
                    {
                        if (((bPvP) && (!(myAvatar.target.dataLeaf.pvpTeam == myAvatar.dataLeaf.pvpTeam))))
                        {
                            myAvatar.target.pMC.modulateColor(avtMCT, "+");
                        }
                        else
                        {
                            myAvatar.target.pMC.modulateColor(avtPCT, "+");
                        }
                    }
                    rootClass.showPortraitTarget(_arg_1);
                }
                else
                {
                    rootClass.hidePortraitTarget();
                    if (myAvatar.dataLeaf.intState > 0)
                    {
                        exitCombat();
                    }
                    myAvatar.target = null;
                }
            }
        }

        public function cancelTarget():void
        {
            if (((!(autoActionTimer == null)) && (autoActionTimer.running)))
            {
                cancelAutoAttack();
                myAvatar.pMC.mcChar.gotoAndStop("Idle");
                return;
            }
            if (myAvatar.target != null)
            {
                setTarget(null);

            }
        }

        public function approachTarget():*
        {
            var _local_3:Object;
            var _local_5:Boolean;
            var _local_6:Point;
            var _local_7:Point;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:String;
            var _local_17:*;
            var _local_18:*;
            var _local_19:*;
            var _local_20:int;
            var _local_21:int;
            var _local_22:Array;
            var _local_23:Array;
            var _local_1:Boolean = true;
            var _local_2:Object = uoTree[rootClass.sfc.myUserName];
            var _local_4:Object = getAutoAttack();
            if (_local_4 == null)
            {
                return;
            }
            if (myAvatar.target != null)
            {
                if (myAvatar.target.npcType == "monster")
                {
                    _local_3 = monTree[myAvatar.target.objData.MonMapID];
                }
                else
                {
                    if (myAvatar.target.npcType == "player")
                    {
                        _local_3 = myAvatar.target.dataLeaf;
                    }
                }
                if ((((_local_3 == null) || (_local_2.intState == 0)) || (_local_3.intState == 0)))
                {
                    _local_1 = false;
                }
                if ((((bPvP) && (((!(_local_3.react == null)) && (_local_3.react[_local_2.pvpTeam] == 1)) || (_local_2.pvpTeam == _local_3.pvpTeam))) || ((!(bPvP)) && (myAvatar.target.npcType == "player"))))
                {
                    _local_1 = false;
                }
                if (_local_1)
                {
                    if (_local_4 != null)
                    {
                        if (actionRangeCheck(_local_4))
                        {
                            testAction(_local_4);
                        }
                        else
                        {
                            actionReady = true;
                            _local_5 = false;
                            _local_6 = myAvatar.pMC.mcChar.localToGlobal(new Point(0, 0));
                            _local_7 = myAvatar.target.pMC.mcChar.localToGlobal(new Point(0, 0));
                            if (_local_4.range > 301)
                            {
                                _local_8 = Point.distance(_local_6, _local_7);
                                _local_9 = (_local_4.range * SCALE);
                                _local_9 = (_local_9 * 0.9);
                                if (_local_9 < _local_8)
                                {
                                    _local_7 = Point.interpolate(_local_6, _local_7, (_local_9 / _local_8));
                                }
                                _local_5 = (!(padHit(_local_7.x, _local_7.y, myAvatar.pMC.shadow.getBounds(rootClass.stage))));
                            }
                            else
                            {
                                _local_10 = 0;
                                while (((_local_10 < 100) && (!(_local_5))))
                                {
                                    _local_11 = int(int((50 + (Math.random() * 110))));
                                    if (_local_10 > 50)
                                    {
                                        _local_11 = (_local_11 * -1);
                                    }
                                    _local_12 = (((_local_7.x - _local_6.x) >= 0) ? -(_local_11) : _local_11);
                                    _local_13 = int(((Math.random() * 40) - 20));
                                    _local_12 = Math.ceil((_local_12 * SCALE));
                                    _local_13 = Math.floor((_local_13 * SCALE));
                                    _local_14 = (_local_7.x + _local_12);
                                    _local_15 = (_local_7.y + _local_13);
                                    _local_5 = (!(padHit(_local_14, _local_15, myAvatar.pMC.shadow.getBounds(rootClass.stage))));
                                    _local_10++;
                                }
                                _local_7.x = (_local_7.x + _local_12);
                                _local_7.y = (_local_7.y + _local_13);
                            }
                            if (_local_5)
                            {
                                _local_16 = myAvatar.objData.strClassName.toLowerCase();
                                if (((_local_16.indexOf("archmage") == 0) || (_local_16.indexOf("deathknight") == 0)))
                                {
                                    rootClass.mixer.playSound("ClickBig");
                                }
                                if (bPvP)
                                {
                                    myAvatar.pMC.walkTo(_local_7.x, _local_7.y, WALKSPEED);
                                    pushMove(myAvatar.pMC, _local_7.x, _local_7.y, WALKSPEED);
                                }
                                else
                                {
                                    myAvatar.pMC.walkTo(_local_7.x, _local_7.y, (WALKSPEED * 2));
                                    pushMove(myAvatar.pMC, _local_7.x, _local_7.y, (WALKSPEED * 2));
                                }
                            }
                            else
                            {
                                rootClass.chatF.pushMsg("server", "No path found!", "SERVER", "", 0);
                            }
                        }
                    }
                }
            }
            else
            {
                _local_17 = myAvatar;
                _local_18 = null;
                _local_19 = null;
                _local_20 = (("tgtMin" in _local_4) ? _local_4.tgtMin : 1);
                _local_21 = (("tgtMax" in _local_4) ? _local_4.tgtMax : 1);
                _local_22 = [];
                _local_23 = getAllAvatarsInCell();
                for each (_local_18 in _local_23)
                {
                    _local_3 = _local_18.dataLeaf;
                    if ((((!(_local_3 == null)) && ((((!(bPvP)) && (_local_18.npcType == "monster")) || (((bPvP) && (_local_18.npcType == "player")) && (!(_local_2.pvpTeam == _local_3.pvpTeam)))) || ((((bPvP) && (_local_18.npcType == "monster")) && (!(_local_3.react == null))) && (_local_3.react[_local_2.pvpTeam] == 0)))) && (actionRangeCheck(_local_4, _local_18))))
                    {
                        setTarget(_local_18);
                        testAction(_local_4);
                        return;
                    }
                }
                rootClass.chatF.pushMsg("warning", "No target selected!", "SERVER", "", 0);
            }
        }

        public function padHit(_arg_1:int, _arg_2:int, _arg_3:Rectangle):Boolean
        {
            var _local_5:Rectangle;
            var _local_6:MovieClip;
            var _local_4:int;
            if (((((_arg_1 < 0) || (_arg_1 > 960)) || (_arg_2 < 10)) || (_arg_2 > 530)))
            {
                return false;
            }
            _arg_3.x = int((_arg_1 - (_arg_3.width / 2)));
            _arg_3.y = int((_arg_2 - (_arg_3.height / 2)));
            _local_4 = 0;
            while (_local_4 < arrEvent.length)
            {
                _local_6 = arrEvent[_local_4];
                if ((("strSpawnCell" in _local_6) || ("tCell" in _local_6)))
                {
                    _local_5 = arrEventR[_local_4];
                    if (_arg_3.intersects(_local_5))
                    {
                        return true;
                    }
                }
                _local_4++;
            }
            return false;
        }

        public function drawRects(_arg_1:Array):void
        {
            var _local_5:Rectangle;
            var _local_2:Array = [0xFF0000, 0xFF00, 0xFF];
            var _local_3:Sprite = new Sprite();
            var _local_4:Graphics = _local_3.graphics;
            var _local_6:int;
            _local_6 = 0;
            while (_local_6 < _arg_1.length)
            {
                _local_5 = _arg_1[_local_6];
                _local_4.moveTo(_local_5.x, _local_5.y);
                _local_4.beginFill(_local_2[_local_6], 0.3);
                _local_4.lineTo((_local_5.x + _local_5.width), _local_5.y);
                _local_4.lineTo((_local_5.x + _local_5.width), (_local_5.y + _local_5.height));
                _local_4.lineTo(_local_5.x, (_local_5.y + _local_5.height));
                _local_4.lineTo(_local_5.x, _local_5.y);
                _local_4.endFill();
                _local_6++;
            }
        }

        public function testAction(actionObj:Object, forceAARangeError:Boolean=false):*
        {
            // Aera: action packets can arrive out of order while entering a map
            // or immediately after changing class. Ignore a missing action until
            // sAct has rebuilt the action bar.
            if (actionObj == null)
            {
                return;
            }
            var a:int;
            var b:int;
            var c:int;
            var cLeaf:Object;
            var tLeaf:Object;
            var cAvt:* = undefined;
            var tAvt:* = undefined;
            var pAvt:* = undefined;
            var tgtMin:int;
            var tgtMax:int;
            var targets:Array;
            var scan:Array;
            var errMsg:String;
            var forceAAloop:Boolean;
            var aura:Object;
            var pet:* = undefined;
            var tgtOK:Boolean;
            var sAvt:Avatar;
            var to:Object;
            var now:Number;
            if (((strMapName == "caroling") && (CarolingMonsterKillCount >= 5)))
            {
                return;
            }
            a = 0;
            b = 0;
            c = 0;
            cLeaf = uoTreeLeaf(rootClass.sfc.myUserName);
            cAvt = myAvatar;
            tAvt = null;
            pAvt = null;
            tgtMin = (("tgtMin" in actionObj) ? actionObj.tgtMin : 1);
            tgtMax = (("tgtMax" in actionObj) ? actionObj.tgtMax : 1);
            targets = [];
            scan = getAllAvatarsInCell();
            a = 0;
            while (a < scan.length)
            {
                tAvt = scan[a];
                if (tAvt.dataLeaf == null || tAvt.dataLeaf.intState == 0 || tAvt.pMC == null || tAvt.pMC.x == null)
                {
                    scan.splice(a, 1);
                    a = (a - 1);
                    if (tAvt == myAvatar.target)
                    {
                        setTarget(null);
                    }
                }
                a = (a + 1);
            }
            a = 0;
            tAvt = null;
            if (((!(myAvatar.target == null)) && (scan.indexOf(myAvatar.target) > -1)))
            {
                scan.unshift(scan.splice(scan.indexOf(myAvatar.target), 1)[0]);
            }
            afkPostpone();
            errMsg = "none";
            forceAAloop = false;
            if (((actionObj.ref == "i1") && (lockdownPots)))
            {
                errMsg = "The potion is not quite ready yet.";
            }
            if (!actionTimeCheck(actionObj))
            {
                errMsg = (("Ability '" + actionObj.nam) + "' is not ready yet.");
            }
            if ((((errMsg == "none") && (!(actionObj.mp == null))) && (Math.round((actionObj.mp * cLeaf.sta["$cmc"])) > cLeaf.intMP)))
            {
                errMsg = "Not enough mana!";
            }
            if (((errMsg == "none") && (!(actionObj.sp == null))))
            {
                if (!checkSP(actionObj.sp, cLeaf))
                {
                    errMsg = "Not Enough Spirit Power!";
                }
            }
            if ((((errMsg == "none") && (actionObj.ref == "i1")) && (actionObj.sArg1 == "")))
            {
                errMsg = "No item assigned to that slot!";
            }
            if ((((((errMsg == "none") && (!(myAvatar.target == null))) && ("filter" in actionObj)) && ("sRace" in myAvatar.target.objData)) && (!(myAvatar.target.objData.sRace.toLowerCase() == actionObj.filter.toLowerCase()))))
            {
                errMsg = (("Target is not a " + actionObj.filter) + "!");
            }
            if (errMsg == "none")
            {
                for each (aura in cLeaf.auras)
                {
                    try
                    {
                        if (aura.cat != null)
                        {
                            if (aura.cat == "stun")
                            {
                                errMsg = "Cannot act while stunned!";
                            }
                            if (aura.cat == "stone")
                            {
                                errMsg = "Cannot act while petrified!";
                            }
                            if (aura.cat == "disabled")
                            {
                                errMsg = "Cannot act while disabled!";
                            }
                            if (errMsg != "none")
                            {
                                forceAAloop = true;
                            }
                        }
                    }
                    catch(e:Error)
                    {
                    }
                }
            }
            if (errMsg == "none")
            {
                if (actionObj.pet != null)
                {
                    pet = cAvt.getItemByEquipSlot("pe");
                    if (cAvt.getItemByEquipSlot("pe") == null)
                    {
                        if (cAvt.checkTempItem(actionObj.pet, 1))
                        {
                            summonPet(actionObj.pet, true);
                        }
                        else
                        {
                            summonPet(actionObj.pet, false);
                        }
                    }
                }
                else
                {
                    if (actionObj.checkPet != null)
                    {
                        if (cAvt.getItemByEquipSlot("pe").sMeta.indexOf(actionObj.checkPet) == -1)
                        {
                            errMsg = "No battle pet equipped.";
                        }
                    }
                }
            }
            if (((errMsg == "none") || (forceAAloop)))
            {
                if (myAvatar.target != null)
                {
                    tAvt = myAvatar.target;
                    if (myAvatar.target.npcType == "monster")
                    {
                        tLeaf = monTree[tAvt.objData.MonMapID];
                    }
                    else
                    {
                        if (tAvt.npcType == "player")
                        {
                            tLeaf = tAvt.dataLeaf;
                        }
                    }
                }
                switch (actionObj.tgt)
                {
                    case "h":
                        if (tAvt == null)
                        {
                            if (tgtMin > 0)
                            {
                                for each (tAvt in scan)
                                {
                                    tLeaf = tAvt.dataLeaf;
//                                    if ((((!(tLeaf == null)) && ((((!(bPvP)) && (tAvt.npcType == "monster")) || (((bPvP) && (tAvt.npcType == "player")) && (!(cLeaf.pvpTeam == tLeaf.pvpTeam)))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 0)))) && (actionRangeCheck(actionObj, tAvt))))
                                    if (
                                            tLeaf != null &&
                                            (
                                                    (!bPvP && tAvt.npcType == "monster") ||
                                                    (bPvP && tAvt.npcType == "player" && cLeaf.pvpTeam != tLeaf.pvpTeam) ||
                                                    (bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 0)
                                            ) &&
                                            actionRangeCheck(actionObj, tAvt)
                                    )
                                    {
                                        setTarget(tAvt);
                                        testAction(actionObj);
                                        return;
                                    }
                                }
                                errMsg = "No target selected!";
                                if (actionObj.typ == "aa")
                                {
                                    cancelAutoAttack();
                                }
                            }
                        }
                        else
                        {
                            if (((((!(bPvP)) && (tAvt.npcType == "player")) || (((bPvP) && (tAvt.npcType == "player")) && (cLeaf.pvpTeam == tLeaf.pvpTeam))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1))))
                            {
                                errMsg = "Can't attack that target!";
                                if (actionObj.typ == "aa")
                                {
                                    cancelAutoAttack();
                                }
                            }
                            if (((tgtMin > 0) && (tAvt.dataLeaf.intState == 0)))
                            {
                                errMsg = "Your target is dead!";
                            }
                        }
                        break;
                    case "f":
                        if (tAvt == null)
                        {
                            setTarget(myAvatar);
                            tAvt = myAvatar;
                            tLeaf = tAvt.dataLeaf;
                        }
                        if (((((!(bPvP)) && (tAvt.npcType == "monster")) || ((bPvP) && (!(cLeaf.pvpTeam == tLeaf.pvpTeam)))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1))))
                        {
                            tAvt = myAvatar;
                        }
                        tLeaf = tAvt.dataLeaf;
                        break;
                    case "s":
                        if (tAvt == null)
                        {
                            setTarget(myAvatar);
                            tAvt = myAvatar;
                        }
                        if (((!(tAvt == null)) && (!(tAvt == myAvatar))))
                        {
                            tAvt = myAvatar;
                        }
                        tLeaf = tAvt.dataLeaf;
                        break;
                }
                pAvt = tAvt;
                if ((((errMsg == "none") && (!(actionRangeCheck(actionObj, pAvt)))) || (forceAAloop)))
                {
                    if (!forceAAloop)
                    {
                        errMsg = "You are out of range!  Move closer to your target!";
                    }
                    if (actionObj.typ == "aa")
                    {
                        autoActionTimer.delay = 500;
                        autoActionTimer.reset();
                        autoActionTimer.start();
                    }
                }
                tgtOK = true;
                if (errMsg == "none")
                {
                    while (scan.length > 0)
                    {
                        tAvt = scan[0];
                        tLeaf = tAvt.dataLeaf;
                        tgtOK = true;
                        if (tLeaf.intState == 0)
                        {
                            tgtOK = false;
                        }
                        if ((((!(tAvt == null)) && ("filter" in actionObj)) && ("sRace" in tAvt.objData)))
                        {
                            if (tAvt.objData.sRace.toLowerCase() != actionObj.filter.toLowerCase())
                            {
                                tgtOK = false;
                            }
                        }
                        switch (actionObj.tgt)
                        {
                            case "h":
                                if (((((!(bPvP)) && (tAvt.npcType == "player")) || (((bPvP) && (tAvt.npcType == "player")) && (cLeaf.pvpTeam == tLeaf.pvpTeam))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1))))
                                {
                                    tgtOK = false;
                                }
                                break;
                            case "f":
                                if (((((!(bPvP)) && (tAvt.npcType == "monster")) || ((bPvP) && (!(cLeaf.pvpTeam == tLeaf.pvpTeam)))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1))))
                                {
                                    tgtOK = false;
                                }
                                break;
                            case "s":
                                if (((!(tAvt == null)) && (!(tAvt == myAvatar))))
                                {
                                    tgtOK = false;
                                }
                                break;
                        }
                        if (tgtOK)
                        {
                            sAvt = myAvatar;
                            if (((actionObj.fx == "c") && (targets.length > 0)))
                            {
                                sAvt = targets[(targets.length - 1)].avt;
                            }
                            a = Math.abs((tAvt.pMC.x - sAvt.pMC.x));
                            b = Math.abs((tAvt.pMC.y - sAvt.pMC.y));
                            c = Math.pow(((a * a) + (b * b)), 0.5);
                            if (actionRangeCheck(actionObj, tAvt))
                            {
                                targets.push({
                                    "avt":tAvt,
                                    "d":c,
                                    "hp":tLeaf.intHP
                                });
                            }
                        }
                        scan.shift();
                    }
                }
                targets.sortOn("hp", Array.NUMERIC);
                if (pAvt != null)
                {
                    a = 0;
                    while (a < targets.length)
                    {
                        to = targets[a];
                        if (to.avt == pAvt)
                        {
                            targets.unshift(targets.splice(a, 1)[0]);
                        }
                        a = (a + 1);
                    }
                }
                if (targets.length > tgtMax)
                {
                    targets = targets.splice(0, tgtMax);
                }
                if (targets.length > 0)
                {
                    if (pAvt != null)
                    {
                        if (((!(targets[0].avt == null)) && (!(targets[0].avt.dataLeaf == null))))
                        {
                            tAvt = targets[0].avt;
                            tLeaf = tAvt.dataLeaf;
                        }
                        else
                        {
                            tAvt = null;
                            tLeaf = null;
                        }
                    }
                    else
                    {
                        tAvt = null;
                        tLeaf = null;
                    }
                }
            }
            if (errMsg == "none")
            {
                if (cLeaf.intState != 0)
                {
                    if ((((!(actionObj.lock)) && ((tLeaf == null) || (!(tLeaf.intState == 0)))) && (targets.length >= tgtMin)))
                    {
                        doAction(actionObj, targets);
                    }
                    if (((myAvatar.target == null) || ((tLeaf == null) || (tLeaf.intState == 0))))
                    {
                        exitCombat();
                    }
                }
            }
            else
            {
                now = new Date().getTime();
                if (((errMsg == "You are out of range!  Move closer to your target!") && ((!(actionObj.typ == "aa")) || (forceAARangeError))))
                {
                    if ((now - actionRangeSpamTS) > 3000)
                    {
                        actionRangeSpamTS = now;
                        rootClass.chatF.pushMsg("warning", errMsg, "SERVER", "", 0);
                    }
                }
                else
                {
                    if (actionObj.typ != "aa")
                    {
                        rootClass.chatF.pushMsg("warning", errMsg, "SERVER", "", 0);
                    }
                }
            }
        }

        public function summonPet(_arg_1:int, _arg_2:Boolean):*
        {
            if (_arg_2)
            {
                rootClass.sfc.sendXtMessage("zm", "equipItem", [_arg_1], "str", curRoom);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "summonPet", [_arg_1], "str", curRoom);
            }
        }

        public function autoActionHandler(_arg_1:TimerEvent):*
        {
            if (myAvatar.target != null &&
                !myAvatar.target.isMyAvatar &&
                myAvatar.target.dataLeaf != null &&
                myAvatar.target.dataLeaf.intState == 0)
            {
                cancelTarget();
                return;
            }
            if ((((((!(myAvatar.dataLeaf == null)) && (!(myAvatar.dataLeaf.intState == 0))) && (!(myAvatar.target == null))) && (!(myAvatar.target.dataLeaf == null))) && (!(myAvatar.target.dataLeaf.intState == 0))))
            {
                testAction(getAutoAttack(), true);
            }
            else
            {
                exitCombat();
            }
        }

        public function getAutoAttack():Object
        {
            var _local_1:*;
            // Aera: SmartFox can deliver stat/combat packets before the sAct
            // packet has populated the action bar. Treat that short window as
            // "no auto attack yet" instead of dereferencing actions.active.
            if (((actions == null) || (actions.active == null)))
            {
                return null;
            }
            _local_1 = 0;
            while (_local_1 < actions.active.length)
            {
                if ((((!(actions.active[_local_1] == null)) && (!(actions.active[_local_1].auto == null))) && actions.active[_local_1].auto))
                {
                    return (actions.active[_local_1]);
                }
                _local_1++;
            }
            return null;
        }

        public function exitCombat():*
        {
            var _local_1:int;
            actionReady = false;
            if (((!(actions == null)) && (!(actions.active == null))))
            {
                _local_1 = 0;
                while (_local_1 < actions.active.length)
                {
                    if (actions.active[_local_1])
                    {
                        actions.active[_local_1].lock = false;
                    }
                    _local_1++;
                }
            }
            if (myAvatar != null)
            {
                if (((((!(myAvatar.pMC == null)) && (!(myAvatar.pMC.mcChar == null))) && (!(myAvatar.pMC.mcChar.onMove))) && (!(myAvatar.pMC.mcChar.currentLabel == "Rest"))))
                {
                    myAvatar.pMC.mcChar.gotoAndStop("Idle");
                }
                if (myAvatar.dataLeaf != null)
                {
                    myAvatar.dataLeaf.targets = {};
                }
                cancelAutoAttack();
                myAvatar.pMC.clearQueue();
            }
        }

        public function cancelAutoAttack():*
        {
            var icon:MovieClip;
            var i:* = undefined;
            if (autoActionTimer != null)
            {
                autoActionTimer.reset();
            }
            if (AATestTimer != null)
            {
                AATestTimer.reset();
            }
            i = 0;
            while (i < actionMap.length)
            {
                try
                {
                    if (actionMap[i] == "aa")
                    {
                        icon = MovieClip(rootClass.ui.mcInterface.actBar.getChildByName(("i" + (i + 1))));
                        icon.bg.gotoAndStop(1);
                    }
                }
                catch(e:Error)
                {
                }
                i++;
            }
        }

        public function doAction(_arg_1:*, _arg_2:*):*
        {
            var _local_3:Avatar;
            var _local_4:int;
            afkPostpone();
            if (_arg_2.length > 0)
            {
                _local_3 = _arg_2[0].avt;
                if (_local_3 != myAvatar)
                {
                    if ((_local_3.pMC.x - myAvatar.pMC.x) >= 0)
                    {
                        myAvatar.pMC.turn("right");
                    }
                    else
                    {
                        myAvatar.pMC.turn("left");
                    }
                }
            }
            _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                _local_3 = _arg_2[_local_4].avt;
                switch (_local_3.npcType)
                {
                    case "monster":
                        if (myAvatar.dataLeaf.targets[_local_3.objData.MonMapID] == null)
                        {
                            myAvatar.dataLeaf.targets[_local_3.objData.MonMapID] = "m";
                        }
                        break;
                    case "player":
                        if (myAvatar.dataLeaf.targets[_local_3.objData.uid] == null)
                        {
                            myAvatar.dataLeaf.targets[_local_3.objData.uid] = "p";
                        }
                        break;
                }
                _local_4++;
            }
            getActionResult(_arg_1, _arg_2);
        }

        public function aggroMap(_arg_1:String, _arg_2:String, _arg_3:*):void
        {
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            var _local_7:String;
            var _local_10:Object;
            var _local_11:Object;
            var _local_12:*;
            var _local_13:*;
            _local_4 = _arg_1.split(":")[0];
            _local_5 = _arg_1.split(":")[1];
            _local_6 = _arg_2.split(":")[0];
            _local_7 = _arg_2.split(":")[1];
            var _local_8:* = "";
            var _local_9:* = "";
            _local_10 = {};
            _local_11 = {};
            if (_local_4 == "p")
            {
                _local_10 = getUoLeafById(_local_5);
            }
            else
            {
                _local_10 = monTree[_local_5];
            }
            if (_local_6 == "p")
            {
                _local_11 = getUoLeafById(_local_7);
            }
            else
            {
                _local_11 = monTree[_local_7];
            }
            if (!("targets" in _local_10))
            {
                _local_10.targets = {};
            }
            if (!("targets" in _local_11))
            {
                _local_11.targets = {};
            }
            if (_local_6 == "m")
            {
                if (!(_local_7 in _local_10.targets))
                {
                    _local_10.targets[_local_7] = _local_6;
                }
                if (!(_local_5 in _local_11.targets))
                {
                    _local_11.targets[_local_5] = _local_4;
                }
            }
            if ((((_local_4 == "p") && (_local_6 == "p")) && (_arg_3)))
            {
                for (_local_12 in monTree)
                {
                    _local_13 = monTree[_local_12];
                    if (((!(_local_13.targets[_local_7] == null)) && (!(_local_5 in _local_13.targets))))
                    {
                        _local_13.targets[_local_5] = _local_4;
                    }
                }
            }
        }

        public function actionTimeCheck(_arg_1:*, _arg_2:Boolean=false):Boolean
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            _local_3 = new Date().getTime();
            _local_4 = (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5));
            if (_arg_1.auto)
            {
                if (autoActionTimer.running)
                {
                    return false;
                }
                return true;
            }
            if (!_arg_2)
            {
                if ((_local_3 - GCDTS) < GCD)
                {
                    return false;
                }
            }
            if (_arg_1.OldCD != null)
            {
                _local_5 = Math.round((_arg_1.OldCD * _local_4));
            }
            else
            {
                _local_5 = Math.round((_arg_1.cd * _local_4));
            }
            if ((_local_3 - _arg_1.ts) >= _local_5)
            {
                delete _arg_1.OldCD;
                return true;
            }
            return false;
        }

        private function actionRangeCheck(actionData:*, target:Avatar = null):Boolean
        {
            var myPos:Point;
            var targetPos:Point;
            var distanceX:Number;
            var distanceY:Number;
            var distance:Number;
            var actionRange:Number;

            if (target == null && myAvatar.target != null) target = myAvatar.target;
            if (target == myAvatar) return true;
            if ("tgtMin" in actionData && actionData.tgtMin == 0) return true;
            if (target == null) return false;

            myPos = myAvatar.pMC.mcChar.localToGlobal(new Point(0, 0));
            targetPos = target.pMC.mcChar.localToGlobal(new Point(0, 0));

            distanceX = Math.abs(targetPos.x - myPos.x);
            distanceY = Math.abs(targetPos.y - myPos.y);
            distance = Math.sqrt((distanceX * distanceX) + (distanceY * distanceY));

            actionRange = actionData.range * SCALE;

            if (actionData.range <= 301)
            {
                if ((bPvP && distanceX <= (actionRange * 1.15) && distanceY <= ((30 * 1.15) * SCALE)) || (!bPvP && distanceX <= actionRange && distanceY <= (30 * SCALE)))
                {
                    return true;
                }
                return false;
            }

            // For long range actions
            if (distance <= actionRange)
            {
                return true;
            }

            return false;
        }

//        private function actionRangeCheck(_arg_1:*, _arg_2:Avatar=null):Boolean
//        {
//            var _local_3:Point;
//            var _local_4:Point;
//            var _local_5:*;
//            var _local_6:*;
//            var _local_7:*;
//            var _local_8:*;
//            if (((_arg_2 == null) && (!(myAvatar.target == null))))
//            {
//                _arg_2 = myAvatar.target;
//            }
//            if (_arg_2 == myAvatar)
//            {
//                return true;
//            }
//            if ((("tgtMin" in _arg_1) && (_arg_1.tgtMin == 0)))
//            {
//                return true;
//            }
//            if (_arg_2 == null)
//            {
//                return false;
//            }
//            _local_3 = myAvatar.pMC.mcChar.localToGlobal(new Point(0, 0));
//            _local_4 = _arg_2.pMC.mcChar.localToGlobal(new Point(0, 0));
//            _local_5 = Math.abs((_local_4.x - _local_3.x));
//            _local_6 = Math.abs((_local_4.y - _local_3.y));
//            _local_7 = Math.pow(((_local_5 * _local_5) + (_local_6 * _local_6)), 0.5);
//            _local_8 = (_arg_1.range * SCALE);
//            if (_arg_1.range <= 301)
//            {
//                if (((((bPvP) && (_local_5 <= (_local_8 * 1.15))) && (_local_6 <= ((30 * 1.15) * SCALE))) || (((!(bPvP)) && (_local_5 <= _local_8)) && (_local_6 <= (30 * SCALE)))))
//                {
//                    return true;
//                }
//                return false;
//            }
//            if (_local_7 <= _local_8)
//            {
//                return true;
//            }
//            return false;
//        }

        public function aggroAllMon():*
        {
            var _local_1:*;
            var _local_2:*;
            _local_1 = [];
            for (_local_2 in monTree)
            {
                if (monTree[_local_2].strFrame == strFrame)
                {
                    _local_1.push(_local_2);
                }
            }
            aggroMons(_local_1);
        }

        public function aggroMon(_arg_1:*):*
        {
            var _local_2:*;
            _local_2 = [];
            _local_2.push(_arg_1);
            aggroMons(_local_2);
        }

        public function aggroMons(_arg_1:*):*
        {
            if (_arg_1.length)
            {
                rootClass.sfc.sendXtMessage("zm", "aggroMon", _arg_1, "str", curRoom);
            }
        }

        public function castSpellFX(cAvt:*, spFX:*, spell:*, dur:int=0):*
        {
            var tAvt:Avatar;
            var AssetClass:Class;
            var spellFX:* = undefined;
            var targetMCs:Array;
            var i:int;
            try
            {
                if (((cAvt) && (cAvt.isCameraTool)))
                {
                    cAvt.pMC.clearSpFXQueue();
                    return;
                }
                if (((!(showAnimations)) || (((cAvt) && (!(cAvt.isMyAvatar))) && (!(cAvt.pMC.mcChar.visible)))))
                {
                    cAvt.pMC.clearSpFXQueue();
                    return;
                }
                if (rootClass.litePreference.data.bDisSkillAnim)
                {
                    if (((!(rootClass.litePreference.data.dOptions["animSelf"])) || (((rootClass.litePreference.data.dOptions["animSelf"]) && (cAvt)) && (!(cAvt.isMyAvatar)))))
                    {
                        cAvt.pMC.clearSpFXQueue();
                        return;
                    }
                }
                if ((((!(spFX.strl == null)) && (!(spFX.strl == ""))) && (!(spFX.avts == null))))
                {
                    targetMCs = [];
                    i = 0;
                    if (spFX.fx == "c")
                    {
                        if (spFX.strl == "lit1")
                        {
                            targetMCs.push(cAvt.pMC.mcChar);
                            i = 0;
                            while (i < spFX.avts.length)
                            {
                                tAvt = spFX.avts[i];
                                if ((((!(tAvt == null)) && (!(tAvt.pMC == null))) && (!(tAvt.pMC.mcChar == null))))
                                {
                                    targetMCs.push(tAvt.pMC.mcChar);
                                }
                                i = (i + 1);
                            }
                            if (targetMCs.length > 1)
                            {
                                AssetClass = (getClass("sp_C1") as Class);
                                if (AssetClass != null)
                                {
                                    spellFX = new (AssetClass)();
                                    spellFX.mouseEnabled = false;
                                    spellFX.mouseChildren = false;
                                    spellFX.visible = true;
                                    spellFX.world = MovieClip(this);
                                    spellFX.strl = spFX.strl;
                                    rootClass.drawChainsLinear(targetMCs, 33, MovieClip(CHARS.addChild(spellFX)));
                                }
                            }
                        }
                    }
                    else
                    {
                        if (spFX.fx == "f")
                        {
                            targetMCs.push(cAvt.pMC.mcChar);
                            tAvt = spFX.avts[0];
                            if ((((!(tAvt == null)) && (!(tAvt.pMC == null))) && (!(tAvt.pMC.mcChar == null))))
                            {
                                targetMCs.push(tAvt.pMC.mcChar);
                            }
                            if (targetMCs.length > 1)
                            {
                                spellFX = new MovieClip();
                                spellFX.mouseEnabled = false;
                                spellFX.mouseChildren = false;
                                spellFX.visible = true;
                                spellFX.world = MovieClip(this);
                                spellFX.strl = spFX.strl;
                                rootClass.drawFunnel(targetMCs, MovieClip(CHARS.addChild(spellFX)));
                            }
                        }
                        else
                        {
                            i = 0;
                            while (i < spFX.avts.length)
                            {
                                tAvt = spFX.avts[i];
                                if (tAvt != null)
                                {
                                    if (tAvt.pMC != null)
                                    {
                                        AssetClass = (getClass(spFX.strl) as Class);
                                        if (AssetClass != null)
                                        {
                                            spellFX = new (AssetClass)();
                                            spellFX.spellDur = dur;
                                            if (spell != null)
                                            {
                                                spellFX.transform = spell.transform;
                                            }
                                            CHARS.addChild(spellFX);
                                            spellFX.mouseEnabled = false;
                                            spellFX.mouseChildren = false;
                                            spellFX.visible = true;
                                            spellFX.world = MovieClip(this);
                                            spellFX.strl = spFX.strl;
                                            spellFX.tMC = tAvt.pMC;
                                            switch (spFX.fx)
                                            {
                                                case "p":
                                                    spellFX.x = cAvt.pMC.x;
                                                    spellFX.y = (cAvt.pMC.y - (cAvt.pMC.mcChar.height * 0.5));
                                                    spellFX.dir = (((tAvt.pMC.x - cAvt.pMC.x) >= 0) ? 1 : -1);
                                                    break;
                                                case "w":
                                                    spellFX.x = spellFX.tMC.x;
                                                    spellFX.y = (spellFX.tMC.y + 3);
                                                    if (cAvt != null)
                                                    {
                                                        if (spellFX.tMC.x < cAvt.pMC.x)
                                                        {
                                                            spellFX.scaleX = (spellFX.scaleX * -1);
                                                        }
                                                    }
                                                    break;
                                            }
                                        }
                                    }
                                }
                                i = (i + 1);
                            }
                        }
                    }
                }
                if (cAvt)
                {
                    cAvt.pMC.spFX.strl = "";
                    cAvt.pMC.canCastSpFX();
                }
            }
            catch(e)
            {
                cAvt.pMC.clearSpFXQueue();
            }
        }

        public function showSpellFXHit(_arg_1:*):*
        {
            var _local_2:*;
            _local_2 = {};
            switch (_arg_1.strl)
            {
                case "sp_ice1":
                    _local_2.strl = "sp_ice2";
                    break;
                case "sp_el3":
                    _local_2.strl = "sp_el2";
                    break;
                case "sp_ed3":
                    _local_2.strl = "sp_ed1";
                    break;
                case "sp_ef1":
                case "sp_ef6":
                    _local_2.strl = "sp_ef2";
                    break;
            }
            _local_2.fx = "w";
            _local_2.avts = [_arg_1.tMC.pAV];
            castSpellFX(null, _local_2, null);
        }

        public function doCastIA(_arg_1:Object):void
        {
        }

        public function getActionByActID(_arg_1:int):Object
        {
            var _local_2:Object;
            var _local_3:int;
            _local_2 = null;
            _local_3 = 0;
            while (_local_3 < actions.active.length)
            {
                if (((actions.active[_local_3]) && (actions.active[_local_3].actID == _arg_1)))
                {
                    _local_2 = actions.active[_local_3];
                }
                _local_3++;
            }
            return (_local_2);
        }

        public function getActionByRef(_arg_1:String):Object
        {
            var _local_2:*;
            for each (_local_2 in actions.active)
            {
                if (((_local_2) && (_local_2.ref == _arg_1)))
                {
                    return (_local_2);
                }
            }
            for each (_local_2 in actions.passive)
            {
                if (_local_2.ref == _arg_1)
                {
                    return (_local_2);
                }
            }
            return null;
        }

        public function handleSAR(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:String;
            var _local_4:int;
            var _local_7:*;
            var _local_8:*;
            _local_2 = {};
            _local_3 = "";
            _local_4 = -1;
            var _local_5:* = "";
            var _local_6:int = -1;
            if (_arg_1.iRes == 1)
            {
                if (rootClass.bAnalyzer)
                {
                    if (rootClass.bAnalyzer.isRunning())
                    {
                        _local_7 = _arg_1.actionResult.cInf.split(":");
                        _local_8 = _arg_1.actionResult.tInf.split(":");
                        if (_local_7[0] == "p")
                        {
                            if (_local_7[1] == rootClass.sfc.myUserId)
                            {
                                if (_arg_1.actionResult.hp >= 0)
                                {
                                    rootClass.bAnalyzer.addDamage(_arg_1.actionResult.hp);
                                }
                                else
                                {
                                    rootClass.bAnalyzer.addHeal((_arg_1.actionResult.hp * -1));
                                }
                            }
                        }
                        else
                        {
                            if (_local_8[0] == "p")
                            {
                                if (_local_8[1] == rootClass.sfc.myUserId)
                                {
                                    if (_arg_1.actionResult.hp >= 0)
                                    {
                                        rootClass.bAnalyzer.addReceived(_arg_1.actionResult.hp);
                                    }
                                    else
                                    {
                                        rootClass.bAnalyzer.addHeal((_arg_1.actionResult.hp * -1));
                                    }
                                }
                            }
                        }
                    }
                }
                if (_arg_1.actionResult.typ == "d")
                {
                    actionResultsAura.push(_arg_1.actionResult);
                    _local_2 = rootClass.copyObj(_arg_1.actionResult);
                    _local_2.a = [rootClass.copyObj(_arg_1.actionResult)];
                }
                else
                {
                    aggroMap(_arg_1.actionResult.cInf, _arg_1.actionResult.tInf, (_arg_1.actionResult.hp >= 0));
                    _local_3 = _arg_1.actionResult.cInf.split(":")[0];
                    _local_4 = int(_arg_1.actionResult.cInf.split(":")[1]);
                    _local_5 = _arg_1.actionResult.tInf.split(":")[0];
                    _local_6 = int(_arg_1.actionResult.tInf.split(":")[1]);
                    _local_2 = rootClass.copyObj(_arg_1.actionResult);
                    _local_2.a = [rootClass.copyObj(_arg_1.actionResult)];
                    if (((_local_3 == "p") && (_local_4 == rootClass.sfc.myUserId)))
                    {
                        showActionResult(_local_2, _local_2.actID);
                    }
                    else
                    {
                        showIncomingAttackResult(_local_2);
                    }
                }
            }
            if (_arg_1.iRes == 0)
            {
                switch (_arg_1.actionResult.cInf.split(":")[0])
                {
                    case "p":
                        showActionResult(null, _arg_1.actID);
                        return;
                }
            }
        }

        public function handleSARS(_arg_1:Object):void
        {
            var _local_3:String;
            var _local_4:int;
            var _local_7:String;
            var _local_8:Object;
            var _local_9:Array;
            var _local_10:int;
            var _local_2:Object = {};
            _local_3 = "";
            _local_4 = -1;
            var _local_5:* = "";
            var _local_6:int = -1;
            _local_7 = _arg_1.cInf;
            _local_7 = _arg_1.cInf;
            _local_3 = _local_7.split(":")[0];
            _local_4 = int(_local_7.split(":")[1]);
            _local_8 = {};
            if (_arg_1.iRes == 1)
            {
                _local_9 = [];
                _local_10 = 0;
                while (_local_10 < _arg_1.a.length)
                {
                    if (rootClass.bAnalyzer)
                    {
                        if (rootClass.bAnalyzer.isRunning())
                        {
                            if (_local_3 == "p")
                            {
                                if (_local_4 == rootClass.sfc.myUserId)
                                {
                                    if (_arg_1.a[_local_10].hp >= 0)
                                    {
                                        rootClass.bAnalyzer.addDamage(_arg_1.a[_local_10].hp);
                                    }
                                    else
                                    {
                                        rootClass.bAnalyzer.addHeal((_arg_1.a[_local_10].hp * -1));
                                    }
                                }
                            }
                            else
                            {
                                if (_arg_1.a[_local_10].tInf.split(":")[0] == "p")
                                {
                                    if (_arg_1.a[_local_10].tInf.split(":")[1] == rootClass.sfc.myUserId)
                                    {
                                        if (_arg_1.a[_local_10].hp >= 0)
                                        {
                                            rootClass.bAnalyzer.addReceived(_arg_1.a[_local_10].hp);
                                        }
                                        else
                                        {
                                            rootClass.bAnalyzer.addHeal((_arg_1.a[_local_10].hp * -1));
                                        }
                                    }
                                }
                            }
                        }
                    }
                    _local_8 = _arg_1.a[_local_10];
                    aggroMap(_local_7, _local_8.tInf, (_local_8.hp >= 0));
                    _local_10++;
                }
                if (((_local_3 == "p") && (_local_4 == rootClass.sfc.myUserId)))
                {
                    showActionResult(rootClass.copyObj(_arg_1), _arg_1.actID);
                }
                else
                {
                    showIncomingAttackResult(rootClass.copyObj(_arg_1));
                }
            }
            if (_arg_1.iRes == 0)
            {
                switch (_local_7.split(":")[0])
                {
                    case "p":
                        showActionResult(null, _arg_1.actID);
                        return;
                }
            }
        }

        public function getActionResult(_arg_1:*, _arg_2:*):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:String;
            var _local_6:Avatar;
            var _local_7:int;
            var _local_8:Number;
            var _local_9:*;
            _local_3 = [];
            _local_4 = "gar";
            _local_5 = "";
            _local_7 = 0;
            _local_3.push(actionID);
            if (_arg_2.length > 0)
            {
                _local_7 = 0;
                while (_local_7 < _arg_2.length)
                {
                    _local_6 = _arg_2[_local_7].avt;
                    if (_local_7 > 0)
                    {
                        _local_5 = (_local_5 + ",");
                    }
                    _local_5 = (_local_5 + (_arg_1.ref + ">"));
                    if (_local_6.npcType == "monster")
                    {
                        _local_5 = (_local_5 + ("m:" + _local_6.objData.MonMapID));
                    }
                    if (_local_6.npcType == "player")
                    {
                        _local_5 = (_local_5 + ("p:" + _local_6.uid));
                    }
                    _local_7++;
                }
            }
            else
            {
                _local_5 = (_local_5 + (_arg_1.ref + ">"));
            }
            _local_3.push(_local_5);
            if (_arg_1.ref == "i1")
            {
                _local_3.push(_arg_1.sArg1);
            }
            _local_3.push("wvz");
            rootClass.sfc.sendXtMessage("zm", _local_4, _local_3, "str", 1);
            if (((!(map.getAction == null)) && map.getAction))
            {
                try
                {
                    map.sendAction(_arg_1.ref);
                }
                catch(e)
                {
                }
            }
            _local_8 = new Date().getTime();
            _arg_1.lock = true;
            _arg_1.actID = actionID;
            actionID++;
            if (actionID > actionIDLimit)
            {
                actionID = 0;
            }
            _arg_1.lastTS = _arg_1.ts;
            _arg_1.ts = _local_8;
            if (_arg_1.typ != "aa")
            {
                coolDownAct(_arg_1);
                globalCoolDownExcept(_arg_1);
                if (((!(autoActionTimer.running)) && (_arg_1.tgt == "h")))
                {
                    testAction(getAutoAttack());
                }
            }
            else
            {
                if (rootClass.litePreference.data.bSkillCD)
                {
                    coolDownAct(_arg_1);
                }
                else
                {
                    _local_7 = 0;
                    while (_local_7 < actionMap.length)
                    {
                        if (actionMap[_local_7] == _arg_1.ref)
                        {
                            _local_9 = MovieClip(rootClass.ui.mcInterface.actBar.getChildByName(("i" + (_local_7 + 1))));
                            if (_local_9.bg.currentLabel != "pulse")
                            {
                                _local_9.bg.gotoAndPlay("pulse");
                            }
                        }
                        _local_7++;
                    }
                }
                actionReady = false;
            }
        }

        public function showActionResult(_arg_1:*, _arg_2:*):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            _local_3 = new Date();
            _local_4 = getActionByActID(_arg_2);
            if (_local_4 != null)
            {
                _local_4.lock = false;
                _local_4.actID = -1;
                _local_5 = _local_4.ts;
                _local_6 = _local_3.getTime();
                _local_7 = int(((_local_6 - _local_5) / 2));
                if (_local_4.typ == "aa")
                {
                    _local_8 = Math.round((_local_4.cd * (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5))));
                    _local_9 = (_local_8 - int((_local_6 - _local_5)));
                    if (_local_9 > _local_8)
                    {
                        _local_9 = _local_8;
                    }
                    if (_local_9 < (_local_8 - 100))
                    {
                        _local_9 = (_local_8 - 100);
                    }
                    autoActionTimer.delay = _local_9;
                    autoActionTimer.reset();
                    autoActionTimer.start();
                }
                if (_arg_1 == null)
                {
                    _local_4.ts = _local_4.lastTS;
                }
                else
                {
                    _local_4.ts = Math.max(int((_local_6 - _local_7)), (_local_5 + minLatencyOneWay));
                    unlockActionsExcept(_local_4);
                    rootClass.updateActionObjIcon(_local_4);
                }
            }
            if (_arg_1 != null)
            {
                playActionSound(_arg_1);
                if (_arg_1.type != "none")
                {
                    try
                    {
                        if (actionResults.length > 30)
                        {
                            actionResults.shift();
                        }
                    }
                    catch(e)
                    {
                    }
                    actionResults.push(_arg_1);
                }
            }
        }

        public function showIncomingAttackResult(_arg_1:Object):void
        {
            playActionSound(_arg_1);
            actionResultsMon.push(_arg_1);
        }

        public function playActionSound(_arg_1:Object):void
        {
            var _local_2:Object;
            if (((_arg_1.a.length > 0) && (!(_arg_1.a[0].type == null))))
            {
                _local_2 = _arg_1.a[0];
                switch (_local_2.type)
                {
                    case "hit":
                        if (_local_2.hp >= 0)
                        {
                            if (Math.random() < 0.5)
                            {
                                rootClass.mixer.playSound("Hit1");
                            }
                            else
                            {
                                rootClass.mixer.playSound("Hit2");
                            }
                        }
                        else
                        {
                            rootClass.mixer.playSound("Heal");
                        }
                        return;
                    case "crit":
                        if (_local_2.hp >= 0)
                        {
                            rootClass.mixer.playSound("Hit3");
                        }
                        else
                        {
                            rootClass.mixer.playSound("Heal");
                        }
                        return;
                    case "miss":
                        rootClass.mixer.playSound("Miss");
                        return;
                    case "none":
                        rootClass.mixer.playSound("Good");
                        return;
                }
            }
        }

        public function showActionImpact(_arg_1:*):*
        {
            var _local_2:MovieClip;
            var _local_3:*;
            var _local_4:*;
            var _local_5:String;
            var _local_6:int;
            var _local_8:Array;
            var _local_10:int;
            var _local_11:TextFormat;
            var _local_12:int;
            var _local_13:Array;
            var _local_14:Object;
            if (rootClass.litePreference.data.bDisDmgDisplay)
            {
                return;
            }
            _local_3 = null;
            _local_4 = null;
            _local_5 = "";
            _local_6 = 0;
            var _local_7:Array = ["GOOD", "GREAT!", "MASSIVE!!"];
            _local_8 = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
            var _local_9:Array = [2381688, 0, 0];
            _local_10 = 0;
            _local_11 = new TextFormat();
            _local_12 = 0;
            _local_13 = _arg_1.a;
            _local_14 = {};
            _local_12 = 0;
            while (_local_12 < _local_13.length)
            {
                _local_14 = _local_13[_local_12];
                _local_5 = _local_14.tInf.split(":")[0];
                _local_6 = int(_local_14.tInf.split(":")[1]);
                switch (_local_5)
                {
                    case "p":
                        _local_2 = avatars[_local_6].pMC;
                        break;
                    case "m":
                        _local_2 = getMonster(_local_6).pMC;
                        break;
                }
                if ((((!(_local_2 == null)) && (!(_local_2.pAV == null))) && (!(_local_2.pAV.dataLeaf == null))))
                {
                    switch (_local_14.type)
                    {
                        case "hit":
                            _local_4 = new hitDisplay();
                            _local_4.t.ti.autoSize = "center";
                            if (_local_14.hp >= 0)
                            {
                                _local_10 = 0;
                                _local_4.t.ti.text = _local_14.hp;
                                _local_4.t.ti.textColor = _local_8[_local_10];
                                _local_4.t.ti.filters = [new GlowFilter(0, 1, 5, 5, 5, 1, false, false)];
                                _local_4.t.ti.setTextFormat(_local_11);
                            }
                            else
                            {
                                _local_4.t.ti.text = (("+" + -(_local_14.hp)) + "+");
                                _local_4.t.ti.textColor = 65450;
                            }
                            wound(_local_2, "damage");
                            break;
                        case "crit":
                            _local_4 = new critDisplay();
                            _local_4.t.ti.autoSize = "center";
                            if (_local_14.hp > 0)
                            {
                                _local_4.t.ti.text = _local_14.hp;
                                _local_4.t.ti.textColor = 16750916;
                                _local_4.t.ti.filters = [new GlowFilter(0x330000, 1, 5, 5, 5, 1, false, false)];
                            }
                            else
                            {
                                _local_4.t.ti.text = -(_local_14.hp);
                                _local_4.t.ti.textColor = 65450;
                            }
                            wound(_local_2, "damage");
                            break;
                        case "miss":
                            _local_4 = new avoidDisplay();
                            _local_4.t.ti.text = "Miss!";
                            break;
                        case "dodge":
                            _local_4 = new avoidDisplay();
                            _local_4.t.ti.text = "Dodge!";
                            if (isMoveOK(_local_2.pAV.dataLeaf))
                            {
                                _local_2.queueAnim("Dodge");
                            }
                            break;
                        case "parry":
                            _local_4 = new avoidDisplay();
                            _local_4.t.ti.text = "Parry!";
                            if (isMoveOK(_local_2.pAV.dataLeaf))
                            {
                                _local_2.queueAnim("Dodge");
                            }
                            break;
                        case "block":
                            _local_4 = new avoidDisplay();
                            _local_4.t.ti.text = "Block!";
                            if (isMoveOK(_local_2.pAV.dataLeaf))
                            {
                                _local_2.queueAnim("Block");
                            }
                            break;
                        case "none":
                    }
                    if (_local_4 != null)
                    {
                        _local_2.addChild(_local_4);
                        _local_4.x = _local_2.mcChar.x;
                        _local_4.y = (_local_2.pname.y + 10);
                    }
                    if (_local_3 != null)
                    {
                        _local_2.addChild(_local_3);
                        _local_3.x = _local_2.mcChar.x;
                        _local_3.y = (_local_2.pname.y + (_local_2.mcChar.height / 2));
                    }
                }
                _local_12++;
            }
        }

        public function showAuraImpact(_arg_1:*):*
        {
            var _local_2:MovieClip;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            if (rootClass.litePreference.data.bDisDmgDisplay)
            {
                return;
            }
            _local_3 = _arg_1.tInf.split(":")[0];
            _local_4 = int(_arg_1.tInf.split(":")[1]);
            _local_5 = null;
            switch (_local_3)
            {
                case "p":
                    if ((((!(avatars[_local_4] == null)) && ("pMC" in avatars[_local_4])) && (!(avatars[_local_4].pMC == null))))
                    {
                        _local_2 = avatars[_local_4].pMC;
                    }
                    break;
                case "m":
                    if ((((!(getMonster(_local_4) == null)) && ("pMC" in getMonster(_local_4))) && (!(getMonster(_local_4).pMC == null))))
                    {
                        _local_2 = getMonster(_local_4).pMC;
                    }
                    break;
            }
            if (_local_2 != null)
            {
                _local_5 = new dotDisplay();
                _local_5.hpDisplay = _arg_1.hp;
                _local_5.init();
                _local_2.addChild(_local_5);
                _local_5.x = _local_2.mcChar.x;
                _local_5.y = (_local_2.pname.y + 10);
            }
        }

        public function showAuraChange(resObj:Object, tAvt:Avatar, tLeaf:Object):*
        {
            var tMC:MovieClip;
            var actionDamage:* = undefined;
            var cLeaf:Object;
            var i:int;
            var nc:int;
            var gap:int;
            var child:DisplayObject;
            var cTyp:String;
            var cID:int;
            var tTyp:String;
            var tID:int;
            var aura:Object;
            var existingAura:Object;
            var dateObj:Date;
            var isOK:Boolean;
            var tFilters:Array;
            var tFilter:* = undefined;
            var auras:* = undefined;
            var ai:* = undefined;
            var actObj:* = undefined;
            var icon1:* = undefined;
            var filterIndex:int;
            tMC = tAvt.pMC;
            actionDamage = null;
            var cAvt:Avatar;
            cLeaf = null;
            if (tMC != null)
            {
                i = 0;
                nc = tMC.numChildren;
                gap = 1;
                if (resObj.cInf != null)
                {
                    cTyp = String(resObj.cInf.split(":")[0]);
                    cID = int(resObj.cInf.split(":")[1]);
                    switch (cTyp)
                    {
                        case "p":
                            cAvt = getAvatarByUserID(cID);
                            cLeaf = getUoLeafById(cID);
                            break;
                        case "m":
                            cAvt = getMonster(cID);
                            cLeaf = monTree[cID];
                            break;
                    }
                }
                if (resObj.auras != null)
                {
                    gap = resObj.auras.length;
                }
                i = 0;
                while (i < nc)
                {
                    child = tMC.getChildAt(i);
                    if ((((!(child == null)) && (!(child.toString() == null))) && (child.toString().indexOf("auraDisplay") > -1)))
                    {
                        child.y = (child.y - (int((child.height + 3)) * gap));
                    }
                    i = (i + 1);
                }
                aura = {};
                existingAura = {};
                dateObj = new Date();
                isOK = true;
                if (tLeaf.auras == null)
                {
                    tLeaf.auras = [];
                }
                if (tLeaf.passives == null)
                {
                    tLeaf.passives = [];
                }
                switch (resObj.cmd)
                {
                    case "aura+":
                    case "aura++":
                    case "aura+p":
                        i = 0;
                        while (i < resObj.auras.length)
                        {
                            aura = resObj.auras[i];
                            aura.cLeaf = cLeaf;
                            if (resObj.cmd == "aura+p")
                            {
                                aura.passive = true;
                            }
                            else
                            {
                                aura.passive = false;
                            }
                            if (!aura.passive)
                            {
                                if (aura.t != null)
                                {
                                    aura.ts = dateObj.getTime();
                                }
                                if (((((tAvt == myAvatar) || (tAvt == myAvatar.target)) || ((!(tLeaf.targets == null)) && (!(tLeaf.targets[rootClass.sfc.myUserId] == null)))) || (resObj.cmd == "aura++")))
                                {
                                    if (aura.potionType != null)
                                    {
                                        if (aura.potionType.toLowerCase() == "tonic")
                                        {
                                            tAvt.objData.Tonic = true;
                                        }
                                        if (aura.potionType.toLowerCase() == "elixir")
                                        {
                                            tAvt.objData.Elixir = true;
                                        }
                                    }
                                    if (aura.nam == "Skill Locked")
                                    {
                                        ai = 0;
                                        while (ai < actions.active.length)
                                        {
                                            actObj = actions.active[ai];
                                            if (actObj)
                                            {
                                                if (actObj.nam == aura.val)
                                                {
                                                    icon1 = rootClass.ui.mcInterface.actBar.getChildByName(("i" + (ai + 1)));
                                                    icon1.actObj.skillLock = true;
                                                }
                                            }
                                            ai++;
                                        }
                                    }
                                    if (!((rootClass.litePreference.data.bAuras) && (rootClass.litePreference.data.dOptions["disAuraText"])))
                                    {
                                        actionDamage = new auraDisplay();
                                        actionDamage.t.ti.text = (aura.nam + "!");
                                        if (aura.nam == "Spirit Power")
                                        {
                                            actionDamage.t.ti.text = ((aura.nam + " ") + aura.val);
                                        }
                                        tMC.addChild(actionDamage);
                                        actionDamage.x = ((tMC.mcChar.scaleX < 0) ? 35 : (-(actionDamage.t.ti.textWidth) - 35));
                                        actionDamage.y = ((tMC.pname.y + 25) + ((actionDamage.height + 3) * i));
                                    }
                                    if (aura.fx != null)
                                    {
                                        addAuraFX(tMC, aura.fx);
                                    }
                                }
                                if (aura.s != null)
                                {
                                    switch (aura.s)
                                    {
                                        case "s":
                                            if (tMC.mcChar.currentLabel != "Fall")
                                            {
                                                tMC.clearQueue();
                                                tMC.mcChar.gotoAndPlay("Fall");
                                            }
                                            break;
                                    }
                                }
                                if (aura.cat != null)
                                {
                                    isOK = true;
                                    for each (existingAura in tLeaf.auras)
                                    {
                                        try
                                        {
                                            if (((!(existingAura.cat == null)) && (existingAura.cat == aura.cat)))
                                            {
                                                isOK = false;
                                            }
                                        }
                                        catch(e:Error)
                                        {
                                        }
                                    }
                                    if (isOK)
                                    {
                                        switch (aura.cat)
                                        {
                                            case "paralyze":
                                            case "stone":
                                                tMC.modulateColor(statusStoneCT, "+");
                                                tMC.mcChar.stop();
                                                break;
                                            case "clean":
                                                tFilters = tMC.mcChar.filters;
                                                tFilters.push(new GlowFilter(0xFFFFFF, 1, 30, 30, 2, 2));
                                                tMC.mcChar.filters = tFilters;
                                                break;
                                        }
                                    }
                                }
                                if (((!(aura.animOn == null)) && ((cLeaf == null) || (cLeaf.intState == 2))))
                                {
                                    if (aura.animOn.indexOf("fadeFX:") > -1)
                                    {
                                        removeAuraFX(tMC, aura.animOn.split(":")[1], "fade");
                                    }
                                    else
                                    {
                                        if (aura.animOn.indexOf("useFX:") > -1)
                                        {
                                            removeAuraFX(tMC, aura.animOn.split(":")[1], "use");
                                        }
                                        else
                                        {
                                            if (aura.animOn.indexOf("removeFX:") > -1)
                                            {
                                                removeAuraFX(tMC, aura.animOn.split(":")[1]);
                                            }
                                            else
                                            {
                                                tMC.mcChar.gotoAndPlay(aura.animOn);
                                            }
                                        }
                                    }
                                }
                                if (aura.msgOn != null)
                                {
                                    if (aura.msgOn.charAt(0) == "@")
                                    {
                                        if (tAvt == myAvatar)
                                        {
                                            rootClass.addUpdate(aura.msgOn.substr(1));
                                        }
                                    }
                                    else
                                    {
                                        rootClass.addUpdate(aura.msgOn);
                                    }
                                }
                                if (aura.isNew)
                                {
                                    tLeaf.auras.push(aura);
                                }
                                else
                                {
                                    updateAuraData(cLeaf, aura, tLeaf);
                                }
                            }
                            else
                            {
                                tLeaf.passives.push(aura);
                            }
                            i = (i + 1);
                        }
                        return;
                    case "aura-":
                    case "aura--":
                        auras = [];
                        if (resObj.auras != null)
                        {
                            auras = resObj.auras;
                        }
                        else
                        {
                            if (resObj.aura != null)
                            {
                                auras = [resObj.aura];
                            }
                        }
                        i = 0;
                        while (i < auras.length)
                        {
                            aura = auras[i];
                            if (removeAura(aura, tLeaf, tMC))
                            {
                                if (((((tAvt == myAvatar) || (tAvt == myAvatar.target)) || ((!(tLeaf.targets == null)) && (!(tLeaf.targets[rootClass.sfc.myUserId] == null)))) || (resObj.cmd == "aura--")))
                                {
                                    if (!((rootClass.litePreference.data.bAuras) && (rootClass.litePreference.data.dOptions["disAuraText"])))
                                    {
                                        actionDamage = new auraDisplay();
                                        actionDamage.t.ti.text = (("*" + aura.nam) + " fades*");
                                        actionDamage.t.ti.textColor = 0x999999;
                                        tMC.addChild(actionDamage);
                                        actionDamage.x = ((tMC.mcChar.scaleX < 0) ? 35 : (-(actionDamage.t.ti.textWidth) - 35));
                                        actionDamage.y = (tMC.pname.y + 25);
                                    }
                                }
                                if (aura.potionType != null)
                                {
                                    if (aura.potionType.toLowerCase() == "tonic")
                                    {
                                        tAvt.objData.Tonic = false;
                                    }
                                    if (aura.potionType.toLowerCase() == "elixir")
                                    {
                                        tAvt.objData.Elixir = false;
                                    }
                                }
                                if (aura.s != null)
                                {
                                    switch (aura.s)
                                    {
                                        case "s":
                                            if (tMC.mcChar.currentLabel == "Fall")
                                            {
                                                if (isStatusGone("s", tLeaf))
                                                {
                                                    tMC.mcChar.gotoAndPlay("Getup");
                                                }
                                            }
                                            break;
                                    }
                                }
                                if (aura.cat != null)
                                {
                                    isOK = true;
                                    for each (existingAura in tLeaf.auras)
                                    {
                                        try
                                        {
                                            if (((!(existingAura.cat == null)) && (existingAura.cat == aura.cat)))
                                            {
                                                isOK = false;
                                            }
                                        }
                                        catch(e:Error)
                                        {
                                        }
                                    }
                                    if (isOK)
                                    {
                                        switch (aura.cat)
                                        {
                                            case "stone":
                                                tMC.modulateColor(statusStoneCT, "-");
                                                tMC.mcChar.play();
                                                break;
                                            case "clean":
                                                tFilters = tMC.mcChar.filters;
                                                filterIndex = 0;
                                                while (filterIndex < tFilters.length)
                                                {
                                                    tFilter = tFilters[filterIndex];
                                                    if (((tFilter is GlowFilter) && (GlowFilter(tFilter).color == 0xFFFFFF)))
                                                    {
                                                        tFilters.splice(filterIndex, 1);
                                                        filterIndex = (filterIndex - 1);
                                                    }
                                                    filterIndex = (filterIndex + 1);
                                                }
                                                tMC.mcChar.filters = tFilters;
                                                break;
                                        }
                                    }
                                }
                                if (aura.nam == "Skill Locked")
                                {
                                    ai = 0;
                                    while (ai < actions.active.length)
                                    {
                                        actObj = actions.active[ai];
                                        if (actObj)
                                        {
                                            if (actObj.nam == aura.val)
                                            {
                                                icon1 = rootClass.ui.mcInterface.actBar.getChildByName(("i" + (ai + 1)));
                                                icon1.actObj.skillLock = false;
                                                icon1.cnt.alpha = 1;
                                            }
                                        }
                                        ai++;
                                    }
                                }
                                if (aura.animOff != null)
                                {
                                    tMC.mcChar.gotoAndPlay(aura.animOff);
                                }
                                if (aura.msgOff != null)
                                {
                                    if (aura.msgOff.charAt(0) == "@")
                                    {
                                        if (tAvt == myAvatar)
                                        {
                                            rootClass.addUpdate(aura.msgOff.substr(1));
                                        }
                                    }
                                    else
                                    {
                                        rootClass.addUpdate(aura.msgOff);
                                    }
                                }
                            }
                            i = (i + 1);
                        }
                        return;
                    case "aura*":
                        actionDamage = new auraDisplay();
                        actionDamage.t.ti.text = "* IMMUNE *";
                        tMC.addChild(actionDamage);
                        actionDamage.x = ((tMC.mcChar.scaleX < 0) ? 35 : (-(actionDamage.t.ti.textWidth) - 35));
                        actionDamage.y = ((tMC.pname.y + 25) + ((actionDamage.height + 3) * i));
                        return;
                }
            }
        }

        public function updateAuraData(_arg_1:Object, _arg_2:Object, _arg_3:Object):void
        {
            var _local_4:Object;
            for each (_local_4 in _arg_3.auras)
            {
                if (((_local_4.nam == _arg_2.nam) && (_local_4.cLeaf == _arg_1)))
                {
                    _local_4.dur = _arg_2.dur;
                    _local_4.val = _arg_2.val;
                }
            }
        }

        public function handleAuraEvent(cmd:String, resObj:Object):void
        {
            var cLeaf:Object;
            var tLeaf:Object;
            var cAvt:Avatar;
            var tAvt:Avatar;
            var cTyp:String;
            var cID:int;
            var tTyp:String;
            var tID:int;
            var forceAura:Boolean;
            if (rootClass.sfcSocial)
            {
                forceAura = false;
                if (((cmd.indexOf("++") > -1) || (cmd.indexOf("--") > -1)))
                {
                    forceAura = true;
                }
                cAvt = null;
                tAvt = null;
                if (resObj.cInf != null)
                {
                    cTyp = String(resObj.cInf.split(":")[0]);
                    cID = int(resObj.cInf.split(":")[1]);
                    switch (cTyp)
                    {
                        case "p":
                            cAvt = getAvatarByUserID(cID);
                            cLeaf = getUoLeafById(cID);
                            break;
                        case "m":
                            cAvt = getMonster(cID);
                            cLeaf = monTree[cID];
                            break;
                    }
                }
                if (resObj.tInf != null)
                {
                    tTyp = String(resObj.tInf.split(":")[0]);
                    tID = int(resObj.tInf.split(":")[1]);
                    switch (tTyp)
                    {
                        case "p":
                            try
                            {
                                tAvt = getAvatarByUserID(tID);
                                tLeaf = getUoLeafById(tID);
                                if (((forceAura) || (tLeaf.strFrame == strFrame)))
                                {
                                    if (rootClass.sfcSocial)
                                    {
                                        showAuraChange(resObj, tAvt, tLeaf);
                                    }
                                }
                            }
                            catch(e:Error)
                            {
                            }
                            return;
                        case "m":
                            try
                            {
                                tAvt = getMonster(tID);
                                tLeaf = monTree[tID];
                                if (((forceAura) || ((cLeaf == null) || ((!(cLeaf.targets[tID] == null)) && (tLeaf.strFrame == strFrame)))))
                                {
                                    if (rootClass.sfcSocial)
                                    {
                                        showAuraChange(resObj, tAvt, tLeaf);
                                    }
                                }
                            }
                            catch(e:Error)
                            {
                            }
                            return;
                    }
                }
            }
        }

        public function removeAura(_arg_1:Object, _arg_2:Object, _arg_3:MovieClip):Boolean
        {
            var _local_4:Boolean;
            var _local_5:int;
            if (rootClass.sfcSocial)
            {
                _local_4 = false;
                _local_5 = 0;
                _local_5 = 0;
                while (_local_5 < _arg_2.auras.length)
                {
                    if (_arg_2.auras[_local_5].nam == _arg_1.nam)
                    {
                        if (((!(_arg_3 == null)) && (!(_arg_2.auras[_local_5].fx == null))))
                        {
                            removeAuraFX(_arg_3, _arg_2.auras[_local_5].fx, "fade");
                        }
                        _arg_2.auras.splice(_local_5, 1);
                        _local_5 = _arg_2.auras.length;
                        _local_4 = true;
                    }
                    _local_5++;
                }
                _local_5 = 0;
                while (_local_5 < _arg_2.passives.length)
                {
                    if (_arg_2.passives[_local_5].nam == _arg_1.nam)
                    {
                        _arg_2.passives.splice(_local_5, 1);
                        _local_5 = _arg_2.passives.length;
                        _local_4 = false;
                    }
                    _local_5++;
                }
                return (_local_4);
            }
            return false;
        }

        public function addAuraFX(tMC:MovieClip, fxName:String):void
        {
            var c:Class;
            var fx:MovieClip;
            try
            {
                if (tMC.fx.getChildByName(fxName) == null)
                {
                    c = getClass(fxName);
                    fx = MovieClip(tMC.fx.addChild(new (c)()));
                    fx.name = fxName;
                    fx.y = -30;
                }
            }
            catch(e:Error)
            {
            }
        }

        public function removeAuraFX(tMC:MovieClip, fxName:String, fxLabel:String=null):void
        {
            var i:int;
            var fx:MovieClip;
            i = 0;
            i = 0;
            while (i < tMC.fx.numChildren)
            {
                fx = MovieClip(tMC.fx.getChildAt(i));
                if (((fxName == "all") || (fx.name == fxName)))
                {
                    if (fxLabel != null)
                    {
                        try
                        {
                            MovieClip(fx.getChildByName("inner")).gotoAndPlay(fxLabel);
                        }
                        catch(fxe:Error)
                        {
                        }
                    }
                    else
                    {
                        MovieClip(tMC.fx.removeChildAt(i)).stop();
                        i = (i - 1);
                    }
                }
                i = (i + 1);
            }
        }

        public function isStatusGone(_arg_1:String, _arg_2:Object):Boolean
        {
            var _local_3:*;
            _local_3 = 0;
            while (_local_3 < _arg_2.auras.length)
            {
                if (((!(_arg_2.auras[_local_3].s == null)) && (_arg_2.auras[_local_3].s == _arg_1)))
                {
                    return false;
                }
                _local_3++;
            }
            return true;
        }

        public function isMoveOK(tLeaf:Object):Boolean
        {
            var isOK:Boolean;
            var aura:Object;
            isOK = true;
            aura = {};
            if (tLeaf.auras != null)
            {
                for each (aura in tLeaf.auras)
                {
                    try
                    {
                        if (aura.cat != null)
                        {
                            if (aura.cat == "stun")
                            {
                                isOK = false;
                            }
                            if (aura.cat == "stone")
                            {
                                isOK = false;
                            }
                            if (aura.cat == "disabled")
                            {
                                isOK = false;
                            }
                        }
                    }
                    catch(e:Error)
                    {
                    }
                }
                return (isOK);
            }
            return false;
        }

        public function wound(_arg_1:*, _arg_2:*):*
        {
            var _local_3:*;
            if (rootClass.litePreference.data.bDisDmgStrobe)
            {
                return;
            }
            if (_arg_2 == "damage")
            {
                _local_3 = new MovieClip();
                _local_3.name = "flickermc";
                _local_3.maxF = 3;
                _local_3.curF = 0;
                _local_3.addEventListener(Event.ENTER_FRAME, flickerFrame);
                if (_arg_1.contains(_local_3))
                {
                    _arg_1.flickermc.removeEventListener(Event.ENTER_FRAME, flickerFrame);
                    _arg_1.removeChild(_local_3);
                }
                _arg_1.addChild(_local_3);
            }
        }

        public function flickerFrame(_arg_1:Event):*
        {
            var _local_2:*;
            _local_2 = MovieClip(_arg_1.currentTarget);
            if (((!(_local_2.parent == null)) && (!(_local_2.parent.stage == null))))
            {
                if (_local_2.curF == 0)
                {
                    _local_2.parent.modulateColor(avtWCT, "+");
                }
                if (_local_2.curF == 1)
                {
                    _local_2.parent.modulateColor(avtWCT, "-");
                }
                if (_local_2.curF == 2)
                {
                    _local_2.parent.modulateColor(avtWCT, "+");
                }
                if (_local_2.curF >= _local_2.maxF)
                {
                    _local_2.parent.modulateColor(avtWCT, "-");
                    _local_2.removeEventListener(Event.ENTER_FRAME, flickerFrame);
                    _local_2.parent.removeChild(_local_2);
                }
                _local_2.curF++;
            }
            else
            {
                _local_2.removeEventListener(Event.ENTER_FRAME, flickerFrame);
            }
        }

        public function unlockActionsExcept(_arg_1:*):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            _local_2 = [];
            _local_3 = 0;
            _local_3 = 0;
            while (_local_3 < actions.active.length)
            {
                _local_5 = actions.active[_local_3];
                if (_local_5)
                {
                    if ((((!(_local_5.ref == _arg_1.ref)) && _local_5.lock) && (_local_5.ts < _arg_1.ts)))
                    {
                        _local_6 = 0;
                        while (_local_6 < actionMap.length)
                        {
                            if (actionMap[_local_6] == _local_5.ref)
                            {
                                _local_2.push(("i" + (_local_6 + 1)));
                            }
                            _local_6++;
                        }
                    }
                }
                _local_3++;
            }
            _local_4 = 0;
            while (_local_4 < _local_2.length)
            {
                _local_7 = rootClass.ui.mcInterface.actBar.getChildByName(_local_2[_local_4]);
                if (_local_7.actObj != null)
                {
                    _local_7.actObj.lock = false;
                }
                _local_4++;
            }
        }

        public function unlockActions():*
        {
            var _local_1:*;
            var _local_2:*;
            _local_1 = 0;
            while (_local_1 < actions.active.length)
            {
                _local_2 = actions.active[_local_1];
                if (_local_2)
                {
                    _local_2.lock = false;
                }
                _local_1++;
            }
        }

        public function updateActBar():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            if ((((!(myAvatar == null)) && (!(myAvatar.dataLeaf == null))) && (!(myAvatar.dataLeaf.sta == null))))
            {
                _local_1 = 0;
                while (_local_1 < rootClass.ui.mcInterface.actBar.numChildren)
                {
                    _local_2 = rootClass.ui.mcInterface.actBar.getChildAt(_local_1);
                    if ((("actObj" in _local_2) && (!(_local_2.actObj == null))))
                    {
                        _local_3 = _local_2.actObj.skillLock;
                        _local_3 = ((_local_3 == null) ? false : _local_3);
                        if (((myAvatar.dataLeaf.intMP >= Math.round((_local_2.actObj.mp * myAvatar.dataLeaf.sta["$cmc"]))) && (!(_local_3))))
                        {
                            if (_local_2.cnt.alpha < 1)
                            {
                                _local_2.cnt.alpha = 1;
                            }
                        }
                        else
                        {
                            if (_local_2.cnt.alpha == 1)
                            {
                                _local_2.cnt.alpha = 0.4;
                            }
                        }
                    }
                    _local_1++;
                }
            }
        }

        public function getActIcons(_arg_1:Object):Array
        {
            var _local_2:Array;
            var _local_3:MovieClip;
            var _local_4:*;
            _local_2 = [];
            _local_4 = 0;
            while (_local_4 < actionMap.length)
            {
                if (actionMap[_local_4] == _arg_1.ref)
                {
                    _local_3 = (rootClass.ui.mcInterface.actBar.getChildByName(("i" + (_local_4 + 1))) as MovieClip);
                    if (_local_3 != null)
                    {
                        _local_2.push(_local_3);
                    }
                }
                _local_4++;
            }
            return (_local_2);
        }

        public function globalCoolDownExcept(_arg_1:Object):void
        {
            var _local_2:Number;
            var _local_3:MovieClip;
            var _local_4:Object;
            var _local_5:*;
            _local_2 = new Date().getTime();
            for each (_local_4 in actions.active)
            {
                if (_local_4)
                {
                    _local_3 = getActIcons(_local_4)[0];
                    if (_local_3 != null)
                    {
                        try
                        {
                            _local_5 = Math.round((_local_4.cd * (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5))));
                            if ((((!(_local_4 == _arg_1)) && (!(_local_4.ref == "aa"))) && (((!("icon2" in _local_3)) || (_local_3.icon2 == null)) || (((_local_4.ts + _local_5) > _local_2) && (((_local_4.ts + _local_5) - _local_2) < GCD)))))
                            {
                                coolDownAct(_local_4, (GCD + 300), _local_2);
                            }
                        }
                        catch(e:Error)
                        {
                        }
                    }
                }
            }
            GCDTS = _local_2;
        }

        public function checkCooldown(_arg_1:Object):*
        {
            var _local_2:Array;
            var _local_3:MovieClip;
            var _local_4:int;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            _local_2 = getActIcons(_arg_1);
            while (_local_4 < _local_2.length)
            {
                _local_3 = _local_2[_local_4];
                if (_local_3.icon2 != null)
                {
                    _local_3.bitmapData.dispose();
                    _local_5 = new BitmapData(50, 50, true, 0);
                    _local_5.draw(_local_3, null, iconCT);
                    _local_6 = new Bitmap(_local_5);
                    _local_7 = rootClass.ui.mcInterface.actBar.addChild(_local_6);
                    _local_3.icon2 = _local_7;
                }
                _local_4++;
            }
        }

        public function coolDownAct(_arg_1:Object, _arg_2:int=-1, _arg_3:Number=-1):*
        {
            var _local_4:Array;
            var _local_5:MovieClip;
            var _local_6:int;
            var _local_7:*;
            var _local_8:MovieClip;
            var _local_9:*;
            var _local_10:*;
            var _local_11:int;
            var _local_12:DisplayObject;
            _local_4 = getActIcons(_arg_1);
            _local_6 = 0;
            while (_local_6 < _local_4.length)
            {
                _local_5 = _local_4[_local_6];
                _local_7 = null;
                _local_8 = null;
                if (_local_5.icon2 == null)
                {
                    _local_9 = new BitmapData(50, 50, true, 0);
                    _local_9.draw(_local_5, null, iconCT);
                    _local_10 = new Bitmap(_local_9);
                    _local_7 = rootClass.ui.mcInterface.actBar.addChild(_local_10);
                    _local_5.icon2 = _local_7;
                    if (_arg_2 == -1)
                    {
                        _local_12 = rootClass.ui.mcInterface.actBar.addChild(new iconFlare());
                        _local_7.transform = (_local_12.transform = _local_5.transform);
                        _local_5.ts = _arg_1.ts;
                        _local_5.cd = _arg_1.cd;
                    }
                    else
                    {
                        _local_7.transform = _local_5.transform;
                        _local_5.ts = _arg_3;
                        _local_5.cd = _arg_2;
                    }
                    _local_8 = (rootClass.ui.mcInterface.actBar.addChild(new ActMask()) as MovieClip);
                    _local_8.scaleX = 0.33;
                    _local_8.scaleY = 0.33;
                    _local_8.x = int(((_local_7.x + (_local_7.width / 2)) - (_local_8.width / 2)));
                    _local_8.y = int(((_local_7.y + (_local_7.height / 2)) - (_local_8.height / 2)));
                    _local_11 = 0;
                    while (_local_11 < 4)
                    {
                        _local_8[(("e" + _local_11) + "oy")] = _local_8[("e" + _local_11)].y;
                        _local_11++;
                    }
                    _local_7.mask = _local_8;
                }
                else
                {
                    _local_7 = _local_5.icon2;
                    _local_8 = _local_7.mask;
                    if (_arg_2 == -1)
                    {
                        _local_5.ts = _arg_1.ts;
                        _local_5.cd = _arg_1.cd;
                    }
                    else
                    {
                        _local_5.ts = _arg_3;
                        _local_5.cd = _arg_2;
                    }
                }
                if (((_arg_2 == -1) && (rootClass.litePreference.data.bSkillCD)))
                {
                    switch (_arg_1.ref)
                    {
                        case "aa":
                            _local_5.ref = "txtCD0";
                            break;
                        case "i1":
                            _local_5.ref = "txtCD5";
                            break;
                        default:
                            _local_5.ref = ("txtCD" + _arg_1.ref.slice(1));
                    }
                    rootClass.ui.mcInterface.actBar.setChildIndex(rootClass.ui.mcInterface.actBar.getChildByName(_local_5.ref), (rootClass.ui.mcInterface.actBar.numChildren - 1));
                    rootClass.ui.mcInterface.actBar.getChildByName(_local_5.ref).text = String(Number((_local_5.cd / 1000)).toFixed(1));
                    rootClass.ui.mcInterface.actBar.getChildByName(_local_5.ref).visible = true;
                }
                _local_8.e0.stop();
                _local_8.e1.stop();
                _local_8.e2.stop();
                _local_8.e3.stop();
                _local_5.removeEventListener(Event.ENTER_FRAME, countDownAct);
                _local_5.addEventListener(Event.ENTER_FRAME, countDownAct, false, 0, true);
                _local_6++;
            }
        }

        public function countDownAct(_arg_1:Event):void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:*;
            _local_2 = new Date();
            _local_3 = _local_2.getTime();
            _local_4 = MovieClip(_arg_1.target);
            _local_5 = _local_4.icon2;
            _local_6 = Math.round((_local_4.cd * (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5))));
            _local_7 = ((_local_3 - _local_4.ts) / _local_6);
            _local_8 = Math.floor((_local_7 * 4));
            _local_9 = (int(((_local_7 * 360) % 90)) + 1);
            if (!_local_4.actObj.lock)
            {
                if (_local_7 < 0.99)
                {
                    if (_local_4.ref)
                    {
                        rootClass.ui.mcInterface.actBar.getChildByName(_local_4.ref).text = String(Number((Number((1 - _local_7)) * (_local_6 / 1000))).toFixed(1));
                    }
                    _local_10 = 0;
                    while (_local_10 < 4)
                    {
                        if (_local_10 < _local_8)
                        {
                            _local_5.mask[("e" + _local_10)].y = -300;
                        }
                        else
                        {
                            _local_5.mask[("e" + _local_10)].y = _local_5.mask[(("e" + _local_10) + "oy")];
                            if (_local_10 > _local_8)
                            {
                                _local_5.mask[("e" + _local_10)].gotoAndStop(0);
                            }
                        }
                        _local_10++;
                    }
                    MovieClip(_local_5.mask[("e" + _local_8)]).gotoAndStop(_local_9);
                }
                else
                {
                    if (_local_4.ref)
                    {
                        rootClass.ui.mcInterface.actBar.getChildByName(_local_4.ref).visible = false;
                    }
                    _local_11 = _local_5.mask;
                    _local_5.mask = null;
                    _local_5.parent.removeChild(_local_11);
                    _local_4.removeEventListener(Event.ENTER_FRAME, countDownAct);
                    _local_5.parent.removeChild(_local_5);
                    _local_5.bitmapData.dispose();
                    _local_4.icon2 = null;
                }
            }
        }

        public function healByIcon(_arg_1:Avatar):void
        {
            var _local_2:Object;
            _local_2 = getFirstHeal();
            if (_local_2 != null)
            {
                setTarget(_arg_1);
                testAction(_local_2);
            }
        }

        public function getFirstHeal():Object
        {
            var _local_1:*;
            try
            {
                _local_1 = 0;
                while (_local_1 < actions.active.length)
                {
                    if (((((!(actions.active[_local_1] == null)) && (!(actions.active[_local_1].damage == null))) && (actions.active[_local_1].damage < 0)) && (actions.active[_local_1].isOK)))
                    {
                        return (actions.active[_local_1]);
                    }
                    _local_1++;
                }
            }
            catch(e:Error)
            {
            }
            return null;
        }

        public function AATest(_arg_1:Event):*
        {
        }

        public function connTest(_arg_1:Event):*
        {
        }

        internal function checkSP(_arg_1:int, _arg_2:Object):Boolean
        {
            var _local_3:*;
            _local_3 = 0;
            while (_local_3 < _arg_2.auras.length)
            {
                if (_arg_2.auras[_local_3].nam == "Spirit Power")
                {
                    if (_arg_1 <= _arg_2.auras[_local_3].val)
                    {
                        return true;
                    }
                    return false;
                }
                _local_3++;
            }
            return false;
        }

        public function acceptQuest(_arg_1:int):void
        {
            if (questTree[_arg_1] == null)
            {
                getQuests([_arg_1]);
            }
            if (questTree[_arg_1].status == null)
            {
                questTree[_arg_1].status = "p";
                rootClass.ui.mcQTracker.updateQuest();
            }
            if (!rootClass.ui.mcQTracker.visible)
            {
                rootClass.ui.mcQTracker.toggle();
            }
            rootClass.sfc.sendXtMessage("zm", "acceptQuest", [_arg_1], "str", curRoom);
        }

        public function tryQuestComplete(_arg_1:int, _arg_2:int=-1, _arg_3:Boolean=false, _arg_4:int=1):void
        {
            rootClass.sfc.sendXtMessage("zm", "tryQuestComplete", [_arg_1, _arg_2, _arg_3, _arg_4, "wvz"], "str", curRoom);
        }

        public function getMapItem(_arg_1:int):void
        {
            if (coolDown("getMapItem"))
            {
                rootClass.sfc.sendXtMessage("zm", "getMapItem", [_arg_1], "str", curRoom);
            }
        }

        public function isQuestInProgress(_arg_1:int):Boolean
        {
            return ((!(questTree[_arg_1] == null)) && (!(questTree[_arg_1].status == null)));
        }

        public function getQuests(_arg_1:Array):void
        {
            rootClass.sfc.sendXtMessage("zm", "getQuests", _arg_1, "str", curRoom);
        }

        public function getQuest(_arg_1:int):void
        {
        }

        public function showQuestList(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:String;
            if (!rootClass.isGreedyModalInStack())
            {
                rootClass.clearPopupsQ();
                _local_4 = rootClass.attachOnModalStack("QFrameMC");
                _local_5 = _arg_2.split(",");
                _local_6 = _arg_3.split(",");
                _local_4.sIDs = _local_5;
                _local_4.tIDs = _local_6;
                _local_4.world = this;
                _local_4.rootClass = rootClass;
                _local_4.qMode = _arg_1;
                _local_7 = [];
                _local_8 = 0;
                while (_local_8 < _local_5.length)
                {
                    _local_9 = _local_5[_local_8];
                    if (questTree[_local_9] == null)
                    {
                        _local_7.push(_local_9);
                    }
                    else
                    {
                        if (questTree[_local_9].strDynamic != null)
                        {
                            questTree[_local_9] = null;
                            delete questTree[_local_9];
                            _local_7.push(_local_9);
                        }
                    }
                    _local_8++;
                }
                if (((_local_7.length > 0) && (!(_arg_2 == ""))))
                {
                    getQuests(_local_7);
                }
                else
                {
                    _local_4.open();
                }
            }
        }

        public function getApop(_arg_1:String):void
        {
            var _local_2:Object;
            var _local_3:*;
            var _local_4:Object;
            var _local_5:uint;
            var _local_6:Array;
            var _local_7:uint;
            if (int(_arg_1) < 1)
            {
                return;
            }
            if (rootClass.curID != _arg_1)
            {
                rootClass.curID = _arg_1;
                rootClass.sfc.sendXtMessage("zm", "getApop", [_arg_1], "str", curRoom);
                return;
            }
            _local_2 = rootClass.apopTree[_arg_1];
            _local_3 = [];
            _local_5 = 0;
            for (;_local_5 < _local_2.arrScenes.length;_local_5++)
            {
                _local_4 = _local_2.arrScenes[_local_5];
                if (_local_4.qID == null)
                {
                    if (_local_4.arrQuests != null)
                    {
                        _local_6 = String(_local_4.arrQuests).split(",");
                        _local_7 = 0;
                        while (_local_7 < _local_6.length)
                        {
                            if (questTree[_local_6[_local_7]] == null)
                            {
                                _local_3.push(_local_6[_local_7]);
                                rootClass.quests = true;
                            }
                            else
                            {
                                if (questTree[_local_6[_local_7]].strDynamic != null)
                                {
                                    questTree[_local_6[_local_7]] = null;
                                    delete questTree[_local_6[_local_7]];
                                    _local_3.push(_local_6[_local_7]);
                                    rootClass.quests = true;
                                }
                            }
                            _local_7++;
                        }

                    }
                }
                else
                {
                    if (questTree[_local_4.qID] == null)
                    {
                        _local_3.push(_local_4.qID);
                        rootClass.quests = true;
                    }
                    else
                    {
                        if (questTree[_local_4.qID].strDynamic != null)
                        {
                            questTree[_local_4.qID] = null;
                            delete questTree[_local_4.qID];
                            _local_3.push(_local_4.qID);
                            rootClass.quests = true;
                        }
                    }
                }
            }
            if (_local_3.length > 0)
            {
                rootClass.quests = true;
                rootClass.sfc.sendXtMessage("zm", "getQuests2", _local_3, "str", curRoom);
            }
            else
            {
                rootClass.quests = false;
                rootClass.createApop();
            }
        }

        public function showQuests(_arg_1:String, _arg_2:String):void
        {
            showQuestList(_arg_2, _arg_1, _arg_1);
        }

        public function showQuestLink(_arg_1:Object):void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:String;
            _local_2 = "$({";
            _local_3 = "})$";
            _local_4 = "";
            if (_arg_1.unm.toLowerCase() != rootClass.sfc.myUserName)
            {
                _local_4 = (_local_4 + ((_arg_1.unm + " issues a Call to Arms for ") + _local_2));
                _local_4 = (_local_4 + ["quest", _arg_1.quest.sName, _arg_1.quest.QuestID, _arg_1.quest.iLvl, _arg_1.unm].toString());
                _local_4 = (_local_4 + (_local_3 + "!"));
            }
            else
            {
                _local_4 = (_local_4 + (("You issue a Call to Arms for " + _arg_1.quest.sName) + "!"));
            }
            rootClass.chatF.pushMsg("event", _local_4, "SERVER", "", 0);
        }

        public function getActiveQuests():String
        {
            var _local_1:String;
            var _local_2:*;
            var _local_3:*;
            _local_1 = "";
            for (_local_2 in questTree)
            {
                _local_3 = questTree[_local_2];
                if (_local_3.status != null)
                {
                    if (_local_1.length)
                    {
                        _local_1 = (_local_1 + ("," + _local_2));
                    }
                    else
                    {
                        _local_1 = (_local_1 + _local_2);
                    }
                }
            }
            return (_local_1);
        }

        public function checkAllQuestStatus(_arg_1:*=null):*
        {
            var _local_2:Array;
            var _local_3:String;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:int;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            _local_2 = [];
            if (_arg_1 != null)
            {
                _local_2 = [String(_arg_1)];
            }
            else
            {
                for (_local_3 in questTree)
                {
                    _local_2.push(_local_3);
                }
            }
            for each (_local_3 in _local_2)
            {
                _local_4 = questTree[_local_3];
                _local_5 = {};
                if (_local_4.status != null)
                {
                    if (((!(_local_4.turnin == null)) && (_local_4.turnin.length > 0)))
                    {
                        _local_5.sItems = true;
                        _local_7 = 0;
                        while (_local_7 < _local_4.turnin.length)
                        {
                            _local_8 = _local_4.turnin[_local_7].ItemID;
                            _local_9 = _local_4.turnin[_local_7].iQty;
                            if (((invTree[_local_8] == null) || (invTree[_local_8].iQty < _local_9)))
                            {
                                _local_5.sItems = false;
                                break;
                            }
                            _local_7++;
                        }
                    }
                    if (_local_4.iTime != null)
                    {
                        _local_5.iTime = false;
                        if (_local_4.ts != null)
                        {
                            _local_10 = new Date();
                            if ((_local_10.getTime() - _local_4.ts) <= _local_4.iTime)
                            {
                                _local_5.iTime = true;
                            }
                        }
                    }
                    _local_4.status = "c";
                    for (_local_6 in _local_5)
                    {
                        if (!_local_5[_local_6])
                        {
                            _local_4.status = "p";
                        }
                    }
                }
            }
            rootClass.ui.mcQTracker.updateQuest();
        }

        public function updateQuestProgress(_arg_1:String, _arg_2:Object):void
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:int;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            for (_local_3 in questTree)
            {
                _local_4 = questTree[_local_3];
                _local_5 = {};
                if (_local_4.status != null)
                {
                    if (rootClass.litePreference.data.bQuestNotif)
                    {
                        if ((((_arg_1 == "item") && (!(_local_4.turnin == null))) && (_local_4.turnin.length > 0)))
                        {
                            _local_5.sItems = true;
                            _local_6 = 0;
                            while (_local_6 < _local_4.turnin.length)
                            {
                                _local_7 = _local_4.turnin[_local_6].ItemID;
                                _local_8 = _local_4.turnin[_local_6].iQty;
                                if ((((_arg_2.ItemID == _local_7) && (!(invTree[_local_7] == null))) && (invTree[_local_7].iQty > _local_8)))
                                {
                                    _local_9 = invTree[_local_7];
                                    rootClass.ui.mcQTracker.updateQuest();
                                    rootClass.addUpdate(((((((_local_4.sName + ": ") + _local_9.sName) + " ") + invTree[_local_7].iQty) + "/") + _local_8));
                                }
                                _local_6++;
                            }
                        }
                    }
                }
                if (((!(_local_4.status == null)) && (_local_4.status == "p")))
                {
                    if ((((_arg_1 == "item") && (!(_local_4.turnin == null))) && (_local_4.turnin.length > 0)))
                    {
                        _local_5.sItems = true;
                        _local_6 = 0;
                        while (_local_6 < _local_4.turnin.length)
                        {
                            _local_7 = _local_4.turnin[_local_6].ItemID;
                            _local_8 = _local_4.turnin[_local_6].iQty;
                            if ((((_arg_2.ItemID == _local_7) && (!(invTree[_local_7] == null))) && (invTree[_local_7].iQty <= _local_8)))
                            {
                                _local_9 = invTree[_local_7];
                                rootClass.addUpdate(((((((_local_4.sName + ": ") + _local_9.sName) + " ") + invTree[_local_7].iQty) + "/") + _local_8));
                            }
                            _local_6++;
                        }
                    }
                    checkAllQuestStatus(_local_3);
                    if (_local_4.status == "c")
                    {
                        rootClass.addUpdate((_local_4.sName + " complete!"));
                        rootClass.mixer.playSound("Good");
                    }
                }
            }
        }

        public function canTurnInQuest(_arg_1:int):Boolean
        {
            var _local_2:*;
            var _local_3:int;
            var _local_4:*;
            var _local_5:*;
            _local_2 = questTree[_arg_1];
            if (((!(_local_2.turnin == null)) && (_local_2.turnin.length > 0)))
            {
                _local_3 = 0;
                while (_local_3 < _local_2.turnin.length)
                {
                    _local_4 = _local_2.turnin[_local_3].ItemID;
                    _local_5 = _local_2.turnin[_local_3].iQty;
                    if (((invTree[_local_4] == null) || (invTree[_local_4].iQty < _local_5)))
                    {
                        return false;
                    }
                    if (myAvatar.isItemEquipped(_local_4))
                    {
                        rootClass.MsgBox.notify("Cannot turn in equipped item(s)!");
                        return false;
                    }
                    _local_3++;
                }
            }
            return true;
        }

        public function maximumQuestTurnIns(_arg_1:int):int
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:int;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            _local_2 = -1;
            _local_3 = questTree[_arg_1];
            if (((!(_local_3.turnin == null)) && (_local_3.turnin.length > 0)))
            {
                _local_4 = 0;
                while (_local_4 < _local_3.turnin.length)
                {
                    _local_5 = _local_3.turnin[_local_4].ItemID;
                    _local_6 = _local_3.turnin[_local_4].iQty;
                    if (((invTree[_local_5] == null) || (invTree[_local_5].iQty < _local_6)))
                    {
                        return (0);
                    }
                    if (myAvatar.isItemEquipped(_local_5))
                    {
                        rootClass.MsgBox.notify("Cannot turn in equipped item(s)!");
                        return (0);
                    }
                    _local_7 = Math.floor((invTree[_local_5].iQty / _local_6));
                    if (((_local_2 == -1) || (_local_2 > _local_7)))
                    {
                        _local_2 = _local_7;
                    }
                    _local_4++;
                }
            }
            return (Math.min(_local_2, 250));
        }

        public function abandonQuest(_arg_1:int):void
        {
            questTree[_arg_1].status = null;
            rootClass.ui.mcQTracker.updateQuest();
        }

        public function completeQuest(_arg_1:int):void
        {
            if (questTree[_arg_1] != null)
            {
                questTree[_arg_1].status = null;
                rootClass.ui.mcQTracker.updateQuest();
            }
        }

        public function toggleQuestLog():void
        {
            var _local_1:*;
            _local_1 = rootClass.getInstanceFromModalStack("QFrameMC");
            if (_local_1 == null)
            {
                if (rootClass.litePreference.data.bQuestLog)
                {
                    showQuests(getActiveQuests(), "q");
                }
                else
                {
                    showQuests("", "l");
                }
            }
            else
            {
                _local_1.open();
            }
        }

        public function isPartyMember(_arg_1:String):Boolean
        {
            var _local_2:int;
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 != rootClass.sfc.myUserName)
            {
                _local_2 = 0;
                while (_local_2 < partyMembers.length)
                {
                    if (partyMembers[_local_2].toLowerCase() == _arg_1)
                    {
                        return true;
                    }
                    _local_2++;
                }
            }
            return false;
        }

        public function doPartyAccept(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "gp", ["pa", _arg_1.pid], "str", 1);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "gp", ["pd", _arg_1.pid], "str", 1);
            }
        }

        public function doCTAAccept(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "gp", ["ctaa", _arg_1.unm], "str", 1);
                showQuests(_arg_1.QuestID, "q");
            }
        }

        public function doCTAClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            var _local_3:ModalMC;
            var _local_4:Object;
            _local_2 = (_arg_1.currentTarget as MovieClip);
            _local_3 = new ModalMC();
            _local_4 = {};
            _local_4.strBody = (("Would you like to join the next avabilable party for " + _local_2.sName) + "?");
            _local_4.callback = doCTAAccept;
            _local_4.params = {
                "QuestID":_local_2.QuestID,
                "unm":_local_2.unm
            };
            _local_4.btns = "dual";
            rootClass.ui.ModalStack.addChild(_local_3);
            _local_3.init(_local_4);
        }

        public function addPartyMember(_arg_1:String):*
        {
            partyMembers.push(_arg_1.toLowerCase());
            updatePartyFrame();
        }

        public function removePartyMember(_arg_1:String):*
        {
            var _local_2:*;
            if (_arg_1.toLowerCase() != rootClass.sfc.myUserName.toLowerCase())
            {
                _local_2 = partyMembers.indexOf(_arg_1.toLowerCase());
                if (_local_2 > -1)
                {
                    partyMembers.splice(_local_2, 1);
                }
            }
            else
            {
                partyID = -1;
                partyOwner = "";
                partyMembers = [];
            }
            updatePartyFrame();
        }

        public function updatePartyFrame(_arg_1:Object=null):*
        {
            var _local_2:MovieClip;
            var _local_3:int;
            var _local_4:int;
            var _local_5:MovieClip;
            var _local_6:int;
            var _local_7:Object;
            var _local_8:Array;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:String;
            var _local_12:*;
            var _local_13:*;
            _local_2 = null;
            _local_3 = 0;
            _local_4 = 0;
            _local_5 = null;
            _local_6 = 0;
            _local_7 = null;
            _local_8 = [];
            _local_9 = true;
            _local_10 = false;
            if ((((!(_arg_1 == null)) && (!(_arg_1.range == null))) && !_arg_1.range))
            {
                _local_9 = false;
            }
            if (_arg_1 != null)
            {
                _local_8 = [_arg_1.unm.toLowerCase()];
            }
            else
            {
                _local_10 = true;
                _local_8 = partyMembers;
            }
            if (_local_8.length > 0)
            {
                _local_11 = "";
                if (_arg_1 == null)
                {
                    _local_12 = [];
                    _local_6 = 0;
                    _local_6 = 0;
                    while (_local_6 < rootClass.ui.mcPartyFrame.numChildren)
                    {
                        _local_12.push(MovieClip(rootClass.ui.mcPartyFrame.getChildAt(_local_6)));
                        _local_6++;
                    }
                    _local_6 = 0;
                    _local_6 = 0;
                    while (_local_6 < _local_12.length)
                    {
                        _local_2 = _local_12[_local_6];
                        _local_13 = _local_2.strName.text;
                        if (partyMembers.indexOf(_local_13) == -1)
                        {
                            _local_2.removeEventListener(MouseEvent.CLICK, onPartyPanelClick);
                            rootClass.ui.mcPartyFrame.removeChild(_local_2);
                        }
                        _local_6++;
                    }
                }
                _local_6 = 0;
                while (_local_6 < _local_8.length)
                {
                    _local_11 = _local_8[_local_6];
                    _local_2 = getPartyPanelByName(_local_11);
                    _local_7 = uoTree[_local_11.toLowerCase()];
                    if (_local_7 == null)
                    {
                        _local_2.HP.visible = false;
                        _local_2.MP.visible = false;
                        _local_2.txtRange.visible = true;
                    }
                    else
                    {
                        if (_local_9)
                        {
                            _local_3 = _local_7.intHP;
                            _local_4 = _local_7.intHPMax;
                            _local_5 = _local_2.HP;
                            if (_local_3 >= 0)
                            {
                                _local_5.strIntHP.text = String(_local_7.intHP);
                            }
                            else
                            {
                                _local_5.strIntHP.text = "X";
                            }
                            if (_local_3 < 0)
                            {
                                _local_3 = 0;
                            }
                            _local_5.intHPbar.x = -(_local_5.intHPbar.width * (1 - (_local_3 / _local_4)));
                            _local_3 = _local_7.intMP;
                            _local_4 = _local_7.intMPMax;
                            _local_5 = _local_2.MP;
                            if (_local_3 >= 0)
                            {
                                _local_5.strIntMP.text = String(_local_7.intMP);
                            }
                            else
                            {
                                _local_5.strIntMP.text = "X";
                            }
                            if (_local_3 < 0)
                            {
                                _local_3 = 0;
                            }
                            _local_5.intMPbar.x = -(_local_5.intMPbar.width * (1 - (_local_3 / _local_4)));
                            _local_2.HP.visible = true;
                            _local_2.MP.visible = true;
                            _local_2.txtRange.visible = false;
                        }
                        else
                        {
                            _local_2.HP.visible = false;
                            _local_2.MP.visible = false;
                            _local_2.txtRange.visible = true;
                        }
                    }
                    if (_local_10)
                    {
                        _local_2.y = int(((_local_2.height + 2) * _local_6));
                    }
                    _local_2.partyLead.visible = (_local_11.toLowerCase() == partyOwner.toLowerCase());
                    _local_6++;
                }
            }
            else
            {
                _local_6 = 0;
                while (((rootClass.ui.mcPartyFrame.numChildren > 0) && (_local_6 < 10)))
                {
                    _local_2 = MovieClip(rootClass.ui.mcPartyFrame.getChildAt(0));
                    _local_2.removeEventListener(MouseEvent.CLICK, onPartyPanelClick);
                    rootClass.ui.mcPartyFrame.removeChildAt(0);
                    _local_6++;
                }
            }
            rootClass.ui.mcPortrait.partyLead.visible = (partyOwner.toLowerCase() == rootClass.sfc.myUserName);
        }

        public function createPartyPanel(_arg_1:Object):MovieClip
        {
            var _local_3:*;
            var _local_2:* = (rootClass.ui.mcPartyFrame.numChildren + 1);
            _local_3 = MovieClip(rootClass.ui.mcPartyFrame.addChild(new PartyPanel()));
            _local_3.strName.text = _arg_1.unm;
            _local_3.HP.visible = false;
            _local_3.MP.visible = false;
            _local_3.txtRange.visible = false;
            _local_3.addEventListener(MouseEvent.CLICK, onPartyPanelClick, false, 0, true);
            _local_3.buttonMode = true;
            return (_local_3);
        }

        public function getPartyPanelByName(_arg_1:String):MovieClip
        {
            var _local_2:*;
            var _local_3:MovieClip;
            var _local_4:int;
            _local_2 = rootClass.ui.mcPartyFrame.numChildren;
            _local_3 = null;
            _local_4 = 0;
            while (_local_4 < _local_2)
            {
                _local_3 = MovieClip(rootClass.ui.mcPartyFrame.getChildAt(_local_4));
                if (_local_3.strName.text == _arg_1.toLowerCase())
                {
                    return (_local_3);
                }
                _local_4++;
            }
            return (createPartyPanel({"unm":_arg_1.toLowerCase()}));
        }

        public function onPartyPanelClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:Avatar;
            _local_2 = MovieClip(_arg_1.currentTarget);
            _local_3 = {};
            _local_3.strUsername = _local_2.strName.text;
            if (_arg_1.shiftKey)
            {
                _local_4 = getAvatarByUserName(_local_3.strUsername.toLowerCase());
                if (((((!(_local_4 == null)) && (!(_local_4.pMC == null))) && (!(_local_4.dataLeaf == null))) && (_local_4.dataLeaf.strFrame == myAvatar.dataLeaf.strFrame)))
                {
                    setTarget(_local_4);
                }
            }
            else
            {
                rootClass.ui.cMenu.fOpenWith("party", _local_3);
            }
        }

        public function partyInvite(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "gp", ["pi", _arg_1], "str", 1);
        }

        public function partyKick(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "gp", ["pk", _arg_1], "str", 1);
        }

        public function partyLeave():void
        {
            rootClass.sfc.sendXtMessage("zm", "gp", ["pl"], "str", 1);
        }

        public function partySummon(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "gp", ["ps", _arg_1], "str", 1);
        }

        public function acceptPartySummon(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "gp", ["psa"], "str", 1);
                if (_arg_1.strF == null)
                {
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["goto", _arg_1.unm], "str", 1);
                }
                else
                {
                    moveToCell(_arg_1.strF, _arg_1.strP);
                }
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "gp", ["psd", _arg_1.unm], "str", 1);
            }
        }

        public function partyUpdate(_arg_1:String, _arg_2:String):void
        {
        }

        public function partyPromote(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "gp", ["pp", _arg_1], "str", 1);
        }

        public function _SafeStr_1(_arg_1:*):*
        {
            var _local_2:*;
            var _local_3:*;
            _arg_1 = _arg_1.toLowerCase();
            _local_2 = uoTree[rootClass.sfc.myUserName];
            _local_3 = uoTree[String(_arg_1).toLowerCase()];
            if (((_local_2.intState == 1) && ((_local_2.pvpTeam == null) || (_local_2.pvpTeam == -1))))
            {
                if (((!(_local_3 == null)) && (!(_local_2.uoName == _local_3.uoName))))
                {
                    if ((("nogoto" in map) && (map.nogoto)))
                    {
                        rootClass.chatF.pushMsg("warning", "/goto can't target players within this map.", "SERVER", "", 0);
                        return;
                    }
                    if (_local_2.strFrame != _local_3.strFrame)
                    {
                        moveToCell(_local_3.strFrame, _local_3.strPad);
                    }
                }
                else
                {
                    rootClass.sfc.sendXtMessage("zm", "cmd", ["goto", _arg_1], "str", 1);
                }
            }
        }

        public function pull(_arg_1:*):*
        {
            _arg_1 = _arg_1.toLowerCase();
            rootClass.sfc.sendXtMessage("zm", "cmd", ["pull", _arg_1], "str", 1);
        }

        public function requestFriend(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "requestFriend", [_arg_1], "str", 1);
        }

        public function addFriend(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "addFriend", [_arg_1.unm], "str", 1);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "declineFriend", [_arg_1.unm], "str", 1);
            }
        }

        public function deleteFriend(_arg_1:int, _arg_2:*):void
        {
            rootClass.sfc.sendXtMessage("zm", "deleteFriend", [_arg_1, _arg_2], "str", 1);
        }

        public function guildInvite(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "guild", ["gi", _arg_1], "str", 1);
        }

        public function guildRemove(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "guild", ["gr", _arg_1.userName], "str", 1);
            }
        }

        public function guildPromote(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "guild", ["gp", _arg_1], "str", 1);
        }

        public function guildDemote(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "guild", ["gd", _arg_1], "str", 1);
        }

        public function doGuildAccept(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "guild", ["ga", _arg_1.guildID, _arg_1.owner], "str", 1);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "guild", ["gdi", _arg_1.guildID, _arg_1.owner], "str", 1);
            }
        }

        public function setGuildMOTD(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "guild", ["motd", _arg_1], "str", 1);
        }

        public function createGuild(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "guild", ["gc", _arg_1.guildName], "str", 1);
            }
        }

        public function addMemSlots(_arg_1:int):void
        {
            rootClass.sfc.sendXtMessage("zm", "guild", ["slots", _arg_1], "str", 1);
        }

        public function renameGuild(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "guild", ["rename", _arg_1.guildName], "str", 1);
            }
        }

        public function requestPVPQueue(_arg_1:String, _arg_2:int=-1):void
        {
            rootClass.sfc.sendXtMessage("zm", "PVPQr", [_arg_1, _arg_2], "str", rootClass.world.curRoom);
        }

        public function handlePVPQueue(_arg_1:Object):void
        {
            var _local_2:MovieClip;
            if (_arg_1.bitSuccess == 1)
            {
                PVPQueue.warzone = _arg_1.warzone;
                PVPQueue.ts = new Date().getTime();
                PVPQueue.avgWait = _arg_1.avgWait;
                rootClass.showMCPVPQueue();
            }
            else
            {
                PVPQueue.warzone = "";
                PVPQueue.ts = -1;
                PVPQueue.avgWait = -1;
                rootClass.hideMCPVPQueue();
            }
            _local_2 = rootClass.ui.mcPopup;
            if (((_local_2.currentLabel == "PVPPanel") && (!(_local_2.mcPVPPanel == null))))
            {
                _local_2.mcPVPPanel.updateBody();
            }
            rootClass.closeModalByStrBody("A new Warzone battle has started!");
        }

        public function updatePVPAvgWait(_arg_1:int):void
        {
            PVPQueue.avgWait = _arg_1;
        }

        public function duelExpire():*
        {
            rootClass.closeModalByStrBody("has challenged you to a duel.");
        }

        public function receivePVPInvite(_arg_1:Object):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            _local_2 = new ModalMC();
            _local_3 = {};
            _local_4 = getWarzoneByWarzoneName(_arg_1.warzone);
            _local_3.strBody = (("A new Warzone battle has started!  Will you join " + _local_4.nam) + "?");
            _local_3.greedy = true;
            _local_3.params = {};
            _local_3.callback = replyToPVPInvite;
            rootClass.ui.ModalStack.addChild(_local_2);
            rootClass.ui.mcPopup.onClose();
            rootClass.hideMCPVPQueue();
            _local_2.init(_local_3);
        }

        public function replyToPVPInvite(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                sendPVPInviteAccept();
            }
            else
            {
                sendPVPInviteDecline();
            }
        }

        public function sendPVPInviteAccept():void
        {
            rootClass.sfc.sendXtMessage("zm", "PVPIr", ["1"], "str", rootClass.world.curRoom);
        }

        public function sendPVPInviteDecline():void
        {
            rootClass.sfc.sendXtMessage("zm", "PVPIr", ["0"], "str", rootClass.world.curRoom);
        }

        public function sendDuelInvite(_arg_1:String):void
        {
            rootClass.sfc.sendXtMessage("zm", "duel", [_arg_1], "str", 1);
        }

        public function doDuelAccept(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                rootClass.sfc.sendXtMessage("zm", "da", [_arg_1.unm], "str", 1);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "dd", [_arg_1.unm], "str", 1);
            }
        }

        public function getWarzoneByName(_arg_1:String):*
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < PVPMaps.length)
            {
                if (PVPMaps[_local_2].nam == _arg_1)
                {
                    return (PVPMaps[_local_2]);
                }
                _local_2++;
            }
            return null;
        }

        public function getWarzoneByWarzoneName(_arg_1:String):*
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < PVPMaps.length)
            {
                if (PVPMaps[_local_2].warzone == _arg_1)
                {
                    return (PVPMaps[_local_2]);
                }
                _local_2++;
            }
            return null;
        }

        public function setPVPFactionData(_arg_1:Array):void
        {
            if (_arg_1 != null)
            {
                PVPFactions = _arg_1;
            }
            else
            {
                PVPFactions = [];
            }
        }

        public function attachMovieFront(strLinkage:*):MovieClip
        {
            var mc:MovieClip;
            var AssetClass:Class;
            var addOK:*;
            var tempClass:*;

            AssetClass = (getClass(strLinkage) as Class);
            addOK = true;

            if (FG.numChildren)
            {
                mc = MovieClip(FG.getChildAt(0));
                tempClass = (mc.constructor as Class);
                if (tempClass == AssetClass)
                {
                    addOK = false;
                }
            }
            if (addOK)
            {
                removeMovieFront();
                mc = MovieClip(FG.addChild(new (AssetClass)()));
                FG.mouseChildren = true;
            }
            return (mc);
        }

        public function attachMovieFrontMenu(_arg_1:*):MovieClip
        {
            var _local_2:MovieClip;
            var _local_3:Class;
            var _local_4:*;
            var _local_5:*;
            _local_3 = (getClass(_arg_1) as Class);
            _local_4 = true;
            if (FG.numChildren)
            {
                _local_2 = MovieClip(FG.getChildAt(0));
                _local_5 = (_local_2.constructor as Class);
                if (_local_5 == _local_3)
                {
                    _local_4 = false;
                }
            }
            if (_local_4)
            {
                removeMovieFront();
                _local_2 = MovieClip(FG.addChild(new (_local_3)()));
                FG.mouseChildren = true;
            }
            return (_local_2);
        }

        public function removeMovieFront():*
        {
            var _local_1:int;
            _local_1 = 0;
            while (((FG.numChildren > 0) && (_local_1 < 100)))
            {
                _local_1++;
                FG.removeChildAt(0);
            }
            rootClass.ldrMC.closeHistory();
            rootClass.stage.focus = null;
        }

        public function getMovieFront():*
        {
            if (((FG.numChildren > 0) && (!(FG.getChildAt(0) == null))))
            {
                return (FG.getChildAt(0));
            }
            return null;
        }

        public function isMovieFront(strLinkage:String):Boolean
        {
            var mc:MovieClip;
            var AssetClass:Class;
            var isMF:*;
            var tempClass:*;
            AssetClass = (this.getClass(strLinkage) as Class);
            isMF = false;
            if (FG.numChildren)
            {
                mc = MovieClip(FG.getChildAt(0));
                tempClass = (mc.constructor as Class);
                if (tempClass == AssetClass)
                {
                    isMF = true;
                }
            }
            return (isMF);
        }

        public function loadMovieFront(_arg_1:String, _arg_2:String="Game Files"):void
        {
            removeMovieFront();
            rootClass.ldrMC.loadFile(FG, _arg_1, _arg_2);
        }

        public function replyToTradeInvite(_arg1: Object): void {
            if (_arg1.accept) {
                this.sendTradeInviteAccept();
            } else {
                this.sendTradeInviteDecline();
            }
        }

        public function sendTradeInviteAccept(): void {
            this.rootClass.sfc.sendXtMessage("zm", "ti", ["1"], "str", this.rootClass.world.curRoom);
        }

        public function sendTradeInviteDecline(): void {
            this.rootClass.sfc.sendXtMessage("zm", "ti", ["0"], "str", this.rootClass.world.curRoom);
        }

        public function sendTradeInvite(_arg1: String): void {
            this.rootClass.sfc.sendXtMessage("zm", "ti", [_arg1], "str", 1);
        }

        public function doTradeAccept(_arg1: Object): void {
            if (_arg1.accept) {
                this.rootClass.sfc.sendXtMessage("zm", "tia", [_arg1.unm], "str", 1);
            } else {
                this.rootClass.sfc.sendXtMessage("zm", "tid", [_arg1.unm], "str", 1);
            }
        }

        public function sendLoadOfferRequest(_arg1: Array = null): void {
            var _local2: String;
            if (_arg1[0] == "*") {
                _arg1 = ["All"];
            }
            for each(_local2 in _arg1) {
                this.tradeinfo.hasRequested[_local2] = true;
            }
            this.rootClass.sfc.sendXtMessage("zm", "loadOffer", _arg1, "str", this.curRoom);
        }

        public function sendTradeFromInvRequest(_arg1: Object) : void {
            var _local2: ModalMC;
            var _local3: Object;
            if (_arg1.bEquip == 1) {
                _local2 = new ModalMC();
                _local3 = {};
                _local3.strBody = "You must unequip the item before offering it!";
                _local3.params = {};
                _local3.glow = "red,medium";
                _local3.btns = "mono";
                this.rootClass.ui.ModalStack.addChild(_local2);
                _local2.init(_local3);
            } else {
                this.rootClass.sfc.sendXtMessage("zm", "tradeFromInv", [_arg1.ItemID, _arg1.CharItemID, _arg1.TradeID, _arg1.Quantity], "str", this.curRoom);
            }
        }

        public function sendTradeToInvRequest(_arg1: Object) : void {
            this.rootClass.sfc.sendXtMessage("zm", "tradeToInv", [_arg1.ItemID, _arg1.CharItemID, _arg1.TradeID], "str", this.curRoom);
        }

        public function sendTradeSwapInvRequest(_arg1: Object, _arg2: Object) : void {
            var _local3: ModalMC;
            var _local4: Object;
            if (_arg2.bEquip == 1) {
                _local3 = new ModalMC();
                _local4 = {};
                _local4.strBody = "You must unequip the item before offering it!";
                _local4.params = {};
                _local4.glow = "red,medium";
                _local4.btns = "mono";
                this.rootClass.ui.ModalStack.addChild(_local3);
                _local3.init(_local4);
            } else {
                this.rootClass.sfc.sendXtMessage("zm", "tradeSwapInv", [_arg2.ItemID, _arg2.CharItemID, _arg1.ItemID, _arg1.CharItemID, _arg1.TradeID], "str", this.curRoom);
            }
        }

        public function showPreL():*
        {
            if (((preLMC == null) || (!(MovieClip(this).contains(preLMC)))))
            {
                preLMC = new PreL();
                addChild(preLMC);
                preLMC.x = ((960 / 2) - (preLMC.width / 2));
                preLMC.y = ((550 / 2) - (preLMC.height / 2));
            }
        }

        public function toggleFPS():void
        {
            rootClass.ui.mcFPS.visible = (!(rootClass.ui.mcFPS.visible));
        }

        private function calculateFPS():void
        {
            var _local_1:Number;
            var _local_2:int;
            var _local_3:int;
            var _local_4:*;
            var _local_5:Number;
            var _local_6:int;
            var _local_7:Number;
            var _local_8:int;
            try
            {
                if (fpsTS != 0)
                {
                    _local_1 = new Date().getTime();
                    _local_2 = (_local_1 - fpsTS);
                    _local_3 = 0;
                    if (ticklist.length == TICK_MAX)
                    {
                        _local_3 = ticklist.shift();
                    }
                    ticklist.push(_local_2);
                    ticksum = ((ticksum + _local_2) - _local_3);
                    _local_4 = (1000 / (ticksum / ticklist.length));
                    if (rootClass.ui.mcFPS.visible)
                    {
                        rootClass.ui.mcFPS.txtFPS.text = _local_4.toPrecision(4);
                    }
                    if ((((rootClass.userPreference.data.quality == "AUTO") && (ticklist.length == TICK_MAX)) && ((++fpsQualityCounter % 24) == 0)))
                    {
                        fpsArrayQuality.push(_local_4);
                        if (fpsArrayQuality.length == 5)
                        {
                            _local_5 = 0;
                            _local_6 = 0;
                            while (_local_6 < fpsArrayQuality.length)
                            {
                                _local_5 = (_local_5 + fpsArrayQuality[_local_6]);
                                _local_6++;
                            }
                            _local_7 = (_local_5 / fpsArrayQuality.length);
                            _local_8 = arrQuality.indexOf(rootClass.stage.quality);
                            if (((_local_7 < 12) && (_local_8 > 0)))
                            {
                                rootClass.stage.quality = arrQuality[(_local_8 - 1)];
                            }
                            if (((_local_7 >= 12) && (_local_8 < 2)))
                            {
                                rootClass.stage.quality = arrQuality[(_local_8 + 1)];
                            }
                            fpsArrayQuality = [];
                        }
                    }
                }
                fpsTS = new Date().getTime();
            }
            catch(e)
            {
            }
        }

        public function onZmanagerEnterFrame(_arg_1:Event):*
        {
            var _local_2:MovieClip;
            var _local_3:int;
            var _local_4:int;
            var _local_5:uint;
            var _local_6:Boolean;
            var _local_7:int;
            var _local_8:*;
            var _local_9:*;
            var _local_10:Number;
            calculateFPS();
            zSortArr = [];
            _local_3 = 0;
            while (_local_3 < CHARS.numChildren)
            {
                _local_2 = MovieClip(CHARS.getChildAt(_local_3));
                zSortArr.push({
                    "mc":_local_2,
                    "oy":_local_2.y
                });
                _local_3++;
            }
            zSortArr.sortOn("oy", Array.NUMERIC);
            _local_4 = 0;
            while (_local_4 < zSortArr.length)
            {
                _local_2 = zSortArr[_local_4].mc;
                _local_7 = CHARS.getChildIndex(_local_2);
                if (_local_7 != _local_4)
                {
                    CHARS.swapChildrenAt(_local_7, _local_4);
                }
                _local_4++;
            }
            if (((strMapName == "trickortreat") && (strFrame == "Enter")))
            {
                if (CHARS.getChildByName("mcPlayerNPCTrickOrTreat"))
                {
                    CHARS.setChildIndex(CHARS.getChildByName("mcPlayerNPCTrickOrTreat"), (CHARS.numChildren - 1));
                }
                else
                {
                    try
                    {
                        _local_8 = getMonsters(1)[0].pMC;
                        if (_local_8)
                        {
                            CHARS.setChildIndex(_local_8, (CHARS.numChildren - 1));
                        }
                    }
                    catch(e)
                    {
                    }
                }
            }
            else
            {
                if (((strMapName == "caroling") && (strFrame == "Enter")))
                {
                    if (CHARS.getChildByName("mcPlayerNPCCaroling"))
                    {
                        CHARS.setChildIndex(CHARS.getChildByName("mcPlayerNPCCaroling"), (CHARS.numChildren - 1));
                    }
                    else
                    {
                        try
                        {
                            _local_9 = getMonsters(1)[0].pMC;
                            if (_local_9)
                            {
                                CHARS.setChildIndex(_local_9, (CHARS.numChildren - 1));
                            }
                        }
                        catch(e)
                        {
                        }
                    }
                }
            }
            if (EFAO.xpc++ > EFAO.xpn)
            {
                EFAO.xpc = 0;
                try
                {
                    if (rootClass.stage == null)
                    {
                        killTimers();
                        killListeners();
                        return;
                    }
                    _local_10 = new Date().getTime();
                    if (((!(rootClass.stage == null)) && (!(myAvatar.objData.iBoostXP == null))))
                    {
                        if ((rootClass.ui.mcPortrait.iconBoostXP.boostTS + (rootClass.ui.mcPortrait.iconBoostXP.iBoostXP * 1000)) < (_local_10 + 1000))
                        {
                            rootClass.sfc.sendXtMessage("zm", "serverUseItem", ["-", "xpboost"], "str", -1);
                        }
                    }
                    if (((!(rootClass.stage == null)) && (!(myAvatar.objData.iBoostG == null))))
                    {
                        if ((rootClass.ui.mcPortrait.iconBoostG.boostTS + (rootClass.ui.mcPortrait.iconBoostG.iBoostG * 1000)) < (_local_10 + 1000))
                        {
                            rootClass.sfc.sendXtMessage("zm", "serverUseItem", ["-", "gboost"], "str", -1);
                        }
                    }
                    if (((!(rootClass.stage == null)) && (!(myAvatar.objData.iBoostRep == null))))
                    {
                        if ((rootClass.ui.mcPortrait.iconBoostRep.boostTS + (rootClass.ui.mcPortrait.iconBoostRep.iBoostRep * 1000)) < (_local_10 + 1000))
                        {
                            rootClass.sfc.sendXtMessage("zm", "serverUseItem", ["-", "repboost"], "str", -1);
                        }
                    }
                    if (((!(rootClass.stage == null)) && (!(myAvatar.objData.iBoostCP == null))))
                    {
                        if ((rootClass.ui.mcPortrait.iconBoostCP.boostTS + (rootClass.ui.mcPortrait.iconBoostCP.iBoostCP * 1000)) < (_local_10 + 1000))
                        {
                            rootClass.sfc.sendXtMessage("zm", "serverUseItem", ["-", "cpboost"], "str", -1);
                        }
                    }
                }
                catch(e:Error)
                {
                }
            }
            if (!combatDisplayTime)
            {
                combatDisplayTime = new Date().time;
            }
            _local_5 = new Date().time;
            _local_6 = false;
            if ((_local_5 - combatDisplayTime) >= 250)
            {
                if (actionResults.length > 0)
                {
                    showActionImpact(actionResults.shift());
                    _local_6 = true;
                }
                if (actionResultsAura.length > 0)
                {
                    showAuraImpact(actionResultsAura.shift());
                    _local_6 = true;
                }
                if (actionResultsMon.length > 0)
                {
                    showActionImpact(actionResultsMon.shift());
                    _local_6 = true;
                }
                if (_local_6)
                {
                    combatDisplayTime = new Date().time;
                }
            }
        }

        public function iaTrigger(_arg_1:MovieClip):*
        {
            var _local_2:*;
            var _local_3:int;
            if (coolDown("doIA"))
            {
                _local_2 = [];
                _local_2.push(_arg_1.iaType);
                _local_2.push(_arg_1.name);
                if (("iaPathMC" in _arg_1))
                {
                    _local_2.push(myAvatar.dataLeaf.strFrame);
                }
                else
                {
                    _local_2.push(_arg_1.iaFrame);
                }
                if (("iaStr" in _arg_1))
                {
                    _local_2.push(_arg_1.iaStr);
                }
                if (("iaPathMC" in _arg_1))
                {
                    _local_2.push(_arg_1.iaPathMC);
                }
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _local_3++;
                }
                rootClass.sfc.sendXtMessage("zm", "ia", _local_2, "str", 1);
            }
        }

        public function actCastTrigger(_arg_1:Object):void
        {
            switch (_arg_1.typ)
            {
                case "sia":
                    siaTrigger(_arg_1);
                    return;
            }
        }

        public function siaTrigger(_arg_1:Object):void
        {
            rootClass.sfc.sendXtMessage("zm", "castt", [], "str", 1);
        }

        public function uoTreeLeaf(_arg_1:*):Object
        {
            if (uoTree[_arg_1.toLowerCase()] == null)
            {
                uoTree[_arg_1.toLowerCase()] = {};
            }
            return (uoTree[_arg_1.toLowerCase()]);
        }

        public function myLeaf():Object
        {
            return (uoTreeLeaf(rootClass.sfc.myUserName));
        }

        public function uoTreeLeafSet(_arg_1:*, _arg_2:Object):*
        {
            var _local_3:*;
            var _local_5:*;
            var _local_6:*;
            if (uoTree[_arg_1.toLowerCase()] == null)
            {
                uoTree[_arg_1.toLowerCase()] = {};
            }
            _local_3 = uoTree[_arg_1.toLowerCase()];
            var _local_4:* = [];
            for (_local_5 in _arg_2)
            {
                _local_3[_local_5] = _arg_2[_local_5];
                _local_6 = getAvatarByUserName(_arg_1);
                if (((!(_local_6 == null)) && (!(_local_6.objData == null))))
                {
                    _local_6.objData[_local_5] = _arg_2[_local_5];
                }
            }
        }

        public function manageAreaUser(_arg_1:String, _arg_2:String):void
        {
            var _local_3:int;
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_2 == "+")
            {
                if (areaUsers.indexOf(_arg_1) == -1)
                {
                    areaUsers.push(_arg_1);
                }
            }
            else
            {
                _local_3 = areaUsers.indexOf(_arg_1);
                if (_local_3 > -1)
                {
                    areaUsers.splice(_local_3, 1);
                }
            }
            rootClass.updateAreaName();
        }

        public function updateAreaUserCount():void
        {
        }

        public function setAllCloakVisibility():void
        {
            var _local_1:Array;
            var _local_2:Avatar;
            _local_1 = getUsersByCell(myAvatar.dataLeaf.strFrame);
            for each (_local_2 in _local_1)
            {
                _local_2.pMC.setCloakVisibility(_local_2.dataLeaf.showCloak);
            }
        }

        public function queueDungeon(_arg_1:String):void
        {
            if (coolDown("dungeonQueue"))
            {
                rootClass.sfc.sendXtMessage("zm", "dungeonQueue", [_arg_1], "str", curRoom);
            }
        }

        public function rejoinDungeon():void
        {
            if (coolDown("dungeonRejoin"))
            {
                rootClass.sfc.sendXtMessage("zm", "dungeonRejoin", [], "str", curRoom);
            }
        }

        public function coolDown(_arg_1:String):Boolean
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            _local_2 = lock[_arg_1];
            _local_3 = new Date();
            _local_4 = _local_3.getTime();
            _local_5 = (_local_4 - _local_2.ts);
            if (_local_5 < _local_2.cd)
            {
                rootClass.chatF.pushMsg("warning", "Action taken too quickly, try again in a moment.", "SERVER", "", 0);
                return false;
            }
            _local_2.ts = _local_4;
            return true;
        }

        public function copyAvatarMC(_arg_1:MovieClip):void
        {
            var _local_2:AvatarMCCopier;
            _local_2 = new AvatarMCCopier(this);
            _local_2.copyTo(_arg_1);
        }

        public function doLoadPet(_arg_1:Avatar):Boolean
        {
            if (((!(rootClass.uoPref.bPet)) && (_arg_1 == myAvatar)))
            {
                return false;
            }
            if (((!(_arg_1 == myAvatar)) && (hideOtherPets)))
            {
                return false;
            }
            return true;
        }

        public function get Scale():Number
        {
            return (SCALE);
        }

        public function get bankinfo():BankController
        {
            return (bankController);
        }

        public function jsonStringy(arr:*) : void {
            trace(JSON.stringify(arr));
        }

        public function mapScrollCheck() : void {
            if (!SCROLL) return;

            const HALF_SCREEN_WIDTH:int = 960 / 2;
            const HALF_SCREEN_HEIGHT:int = (550 / 2) - 50;
            const SCREEN_HEIGHT:int = 550;

            var avatarPosition:Point = myAvatar.pMC.location;
            var mapBounds:Rectangle = map.walk.getRect(stage);

            if (avatarPosition.x > HALF_SCREEN_WIDTH && avatarPosition.x < (mapBounds.width - HALF_SCREEN_WIDTH)) {
                var xOffset:int = Math.round(HALF_SCREEN_WIDTH - (mapBounds.x + avatarPosition.x));
                if (xOffset != 0) {
                    map.x += xOffset;
                    CHARS.x += xOffset;
                }
            } else {
                var mapX:int = (avatarPosition.x < HALF_SCREEN_WIDTH) ? 0 : Math.round(960 - mapBounds.width);
                map.x = mapX;
                CHARS.x = mapX;
            }

            if (avatarPosition.y > HALF_SCREEN_HEIGHT && avatarPosition.y < (mapBounds.height - (SCREEN_HEIGHT - HALF_SCREEN_HEIGHT))) {
                var yOffset:int = Math.round(HALF_SCREEN_HEIGHT - (mapBounds.y + avatarPosition.y));
                if (yOffset != 0) {
                    map.y += yOffset;
                    CHARS.y += yOffset;
                }
            } else {
                var mapY:int = (avatarPosition.y < HALF_SCREEN_HEIGHT) ? 0 : Math.floor(SCREEN_HEIGHT - mapBounds.height);
                map.y = mapY;
                CHARS.y = mapY;
            }
        }

    }
}//package 

// _SafeStr_1 = "goto" (String#4022)


