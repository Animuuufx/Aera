// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Chat2

package 
{
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.utils.Timer;
    import flash.net.SharedObject;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.filters.BevelFilter;
    import flash.geom.ColorTransform;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.filters.DropShadowFilter;
    import flash.text.TextFormatAlign;
    import flash.text.AntiAliasType;
    import flash.text.TextFieldAutoSize;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.geom.Point;
    import liteAssets.handlers.optionHandler;
    import flash.text.*;

    public class Chat2 
    {

        public var chn:* = {};
        public var r:MovieClip;
        public var rootClass:MovieClip;
        private var mci:MovieClip;
        private var messages:Array;
        internal var mask:Shape;
        internal var mcInvis:MovieClip;
        public var bHovering:Boolean;
        public var bMinimal:Boolean;
        internal var mcCannedChat:MovieClip;
        internal var mcHistory:MovieClip;
        internal var cmdHistory:Array = [];
        private var iChatMode:int = 0;
        public var bTall:Boolean;
        internal var upConst:Number = 51;
        internal var heightConst:Number = 83.45;
        public var regExpMultiG:RegExp = /(gg{2,})/gi;
        internal var regexEscapes:String = "[]{}()*+?|^$.\\";
        internal var lineLimit:Number = 100;
        internal var wasBottom:Boolean = false;
        public var fadeTimer:Timer;
        public var fadeQueue:Array;
        private var filterCode:int = 0;
        internal var xmlCannedOptions:XML = <CannedChat>
	<l1 display="Emotes">
		<l2 id="emote" display="Dance" text="dance"/>
		<l2 id="emote" display="Dance2" text="dance2"/>
		<l2 id="emote" display="Laugh" text="laugh"/>
		<l2 id="emote" display="Cry" text="cry"/>
		<l2 id="emote" display="Cheer" text="cheer"/>
		<l2 id="emote" display="Point" text="point"/>
		<l2 id="emote" display="Use" text="use"/>
		<l2 id="emote" display="Feign" text="feign"/>
		<l2 id="emote" display="Sleep" text="sleep"/>
		<l2 id="emote" display="Jump" text="jump"/>
		<l2 id="emote" display="Punt" text="punt"/>
		<l2 id="emote" display="Wave" text="wave"/>
		<l2 id="emote" display="Bow" text="bow"/>
		<l2 id="emote" display="Salute" text="Salute"/>
		<l2 id="emote" display="Backflip" text="backflip"/>
		<l2 id="emote" display="Swordplay" text="swordplay"/>
		<l2 id="emote" display="Unsheath" text="unsheath"/>
		<l2 id="emote" display="Facepalm" text="facepalm"/>
		<l2 id="emote" display="Air Guitar" text="airguitar"/>
		<l2 id="emote" display="Stern" text="stern"/>
	</l1>
	<l1 display="Member Emotes">
		<l2 id="emote" display="Powerup" text="powerup"/>
		<l2 id="emote" display="Kneel" text="kneel"/>
		<l2 id="emote" display="Jumpcheer" text="jumpcheer"/>
		<l2 id="emote" display="Salute2" text="salute2"/>
		<l2 id="emote" display="Cry2" text="cry2"/>
		<l2 id="emote" display="Spar" text="spar"/>
		<l2 id="emote" display="Stepdance" text="stepdance"/>
		<l2 id="emote" display="Headbang" text="headbang"/>
		<l2 id="emote" display="Dazed" text="dazed"/>
		<l2 id="emote" display="DanceWeapon" text="danceweapon"/>
	</l1>
	<l1 display="Greetings">
		<l2 id="ba" display="Hello!" text="Hello!"/>
		<l2 id="bb" display="Hi!" text="Hi!"/>
		<l2 id="bc" display="Well met!" text="Well met!"/>
		<l2 id="bd" display="Welcome!" text="Welcome!"/>
		<l2 id="be" display="Welcome back!" text="Welcome back!"/>
		<l2 id="bf" display="How are you today?" text="How are you today?"/>
	</l1>
	<l1 display="Farewells">
		<l2 id="ca" display="Bye!" text="Bye!"/>
		<l2 id="cb" display="See you later." text="See you later."/>
		<l2 id="cc" display="AFK" text="I'm going AFK"/>
		<l2 id="cd" display="I have to go now." text="I have to go now."/>
		<l2 id="ce" display="Logging out now" text="Logging out now."/>
		<l2 id="cf" display="brb" text="brb"/>
		<l2 id="cg" display="Farewell" text="Farewell"/>
	</l1>
	<l1 display="Questions">
		<l2 id="da" display="Can I add you">
			<l3 id="ea" display="to my Friends list" text="Can I add you to my Friends list?"/>
			<l3 id="eb" display="to my Party" text="Can I add you to my Party?"/>
		</l2>
		<l2 id="db" display="Do you want to battle together?" text="Do you want to battle together?"/>
	    <l2 id="dc" display="Is that a Member only...">
			<l3 id="fa" display="Helm" text=" Is that a Member only helm?"/>
			<l3 id="fb" display="Cape" text=" Is that a Member only cape?"/>
			<l3 id="fc" display="Armor" text=" Is that a Member only armor?"/>
			<l3 id="fd" display="Weapon" text=" Is that a Member only weapon?"/>
		</l2>
		<l2 id="dd" display="Where are you?" text="Where are you?"/>
		<l2 id="de" display="Are you sure?" text="Are you sure?"/>
		<l2 id="df" display="Can I help you?" text="Can I help you?"/>
		<l2 id="dg" display="What is your alignment?" text="What is your alignment?"/>
		<l2 id="dh" display="Where did you get that ...">
			<l3 id="ga" display="Helm" text="Where did you get that helm?"/>
			<l3 id="gb" display="Cape" text="Where did you get that cape?"/>
			<l3 id="gc" display="Armor" text="Where did you get that armor?"/>
			<l3 id="gd" display="Weapon" text="Where did you get that weapon?"/>
			<l3 id="ge" display="Pet" text="Where did you get that pet?"/>
			<l3 id="ge" display="Class" text="Where did you get that class?"/>
		</l2>
		<l2 id="di" display="Are you a...">
			<l3 id="ha" display="Guardian" text="Are you a Guardian?"/>
			<l3 id="hb" display="DragonLord" text="Are you a DragonLord?"/>
			<l3 id="hc" display="StarCaptain" text="Are you a StarCaptain?"/>
		</l2>
		<l2 id="dj" display="Do you play...">
			<l3 id="ia" display="AdventureQuest" text="Do you play AdventureQuest?"/>
			<l3 id="ib" display="DragonFable" text="Do you play DragonFable?"/>
			<l3 id="ic" display="MechQuest" text="Do you play MechQuest?"/>
		</l2>
		<l2 id="dl" display="What are you doing?" text="What are you doing?"/>
	</l1>
	<l1 display="Answers">
		<l2 id="ja" display="thanks/welcome">
			<l3 id="ka" display="Thanks!" text="Thanks!"/>
			<l3 id="kb" display="Thank you!" text="Thank you!"/>
			<l3 id="kc" display="Thanks for helping me." text="Thanks for helping me."/>
			<l3 id="kd" display="I owe you one." text="I owe you one.."/>
			<l3 id="ke" display="No problem!" text="No problem!"/>
			<l3 id="kf" display="You're welcome!" text="You're welcome!"/>
		</l2>
		<l2 id="jn" display="I am doing/trying to..">
			<l3 id="ma" display="Quest" text="I am doing a quest."/>
			<l3 id="mb" display="Farming" text="I am farming."/>
			<l3 id="mc" display="New" text="I am playing the new release."/>
			<l3 id="md" display="Level up." text="I am trying to level up."/>
			<l3 id="me" display="Rank up." text="I am trying to rank up."/>
		</l2>
		<l2 id="jb" display="I'm fine, thanks." text="I'm fine, thanks."/>	
		<l2 id="jc" display="Could be better." text="Could be better."/>
		<l2 id="jd" display="I don't think so." text="I don't think so."/>
		<l2 id="je" display="I don't know." text="I don't know."/>
		<l2 id="jf" display="Indeed." text="Indeed."/>
		<l2 id="jg" display="Pleased to meet you." text="Pleased to meet you."/>
		<l2 id="jh" display="Good." text="I am Good."/>
		<l2 id="ji" display="Evil." text="I am Evil."/>
		<l2 id="jj" display="Me too!" text="Me too!"/>
		<l2 id="jk" display="I got it...">
			<l3 id="la" display="as a drop." text="I got it as a drop."/>
			<l3 id="lb" display="from a shop." text="I got it from a shop."/>
		</l2>
		<l2 id="jl" display="Check the Wiki..." text="You can check the Wiki for the location."/>
		<l2 id="jm" display="Your Book of Lore will know that" text="Your Book of Lore will know that."/>
		<l2 id="jo" display="I can only use Canned Chat." text="I can only use Canned Chat."/>
	</l1>
	<l1 display="Meeting up">
		<l2 id="na" display="Follow me!" text="Follow me!"/>
		<l2 id="nb" display="Over here!" text="Over here!"/>
		<l2 id="nc" display="Goto me." text="Goto me."/>
		<l2 id="nd" display="I'll follow you." text="I'll follow you."/>
		<l2 id="ne" display="Maybe some other time." text="Maybe some other time."/>
		<l2 id="nf" display="Ok, let's go." text="Ok, let's go."/>
		<l2 id="ng" display="Come back here." text="Come back here."/>
		<l2 id="nh" display="I need to finish this first." text="I need to finish this first."/>
		<l2 id="ni" display="Seriously?" text="Seriously?"/>
		<l2 id="nj" display="*I'm going to...">
			<l3 id="oa" display="Artix" text="I'm going to the Artix Server."/>
			<l3 id="ob" display="Galanoth" text="I'm going to the Galanoth Server."/>	
			<l3 id="oh" display="Sir Ver" text="I'm going to Sir Ver."/>
			<l3 id="oi" display="Twig" text="I'm going to the Twig server."/>
			<l3 id="oj" display="Twilly" text="I'm going to the Twilly server."/>
			<l3 id="ok" display="Yorumi" text="I'm going to the Yorumi server."/>
			<l3 id="oj" display="TestingServer" text="I'm going to the TestingServer server."/>
			<l3 id="ok" display="TestingServer2" text="I'm going to the TestingServer2 server."/>
		</l2>
		<l2 id="nk" display="Sorry, I'm busy." text="Sorry, I'm busy."/>
	</l1>
	<l1 display="In Battle">
		<l2 id="pa" display="Can you..">
			<l3 id="qa" display="help with battle" text="Can you help me with this battle?"/>
			<l3 id="qb" display="help with Boss" text="Can you help me with the Boss?"/>
		</l2>
		<l2 id="pb" display="Planning...">
			<l3 id="ra" display="Let's attack now!" text="Let's attack now!"/>
			<l3 id="rb" display="I'll attack first." text="I'll attack first."/>
			<l3 id="rc" display="You go first." text="You go first."/>
			<l3 id="rd" display="I need to rest." text="I need to rest."/>
		</l2>
		<l2 id="pc" display="During the battle">
			<l3 id="sa" display="Heal, please!" text="Heal, please!"/>
			<l3 id="sb" display="MEDIC!" text="MEDIC!"/>
			<l3 id="sc" display="Help!" text="Help!"/>
			<l3 id="sd" display="I'm out of Mana." text="I'm out of Mana."/>
			<l3 id="se" display="Use your special attacks!" text="Use your special attacks!"/>
			<l3 id="sf" display="This monster is strong!" text="This monster is strong!"/>
			<l3 id="sg" display="Slay that monster!" text="Slay that monster!"/>
			<l3 id="sh" display="This is hard." text="This hard."/>
			<l3 id="si" display="This is easy." text="This easy."/>
			<l3 id="sj" display="Run away!" text="Run away!"/>
		</l2>
		<l2 id="pd" display="After battle">
			<l3 id="ta" display="Yes! I got the drop!" text="Yes! I got the drop!"/>
			<l3 id="tb" display="We did it!" text="We did it!"/>
			<l3 id="tc" display="You fight well." text="You fight well."/>
			<l3 id="td" display="Nooo! I died!" text="Nooo! I died!"/>
			<l3 id="tf" display="Let's try again!" text="Let's try again!"/>
		</l2>
	</l1>
	<l1 display="Exclamations">
		<l2 id="ua" display="Battle on!" text="Battle on!"/>
		<l2 id="uc" display="OMG!" text="OMG!"/>
		<l2 id="ud" display="lol" text="lol"/>
		<l2 id="uf" display="Woot!" text="Woot!"/>
		<l2 id="ug" display="Wow!" text="Wow"/>
		<l2 id="uh" display="High Five!" text="High Five!"/>
		<l2 id="ui" display="Congrats!" text="Congrats!"/>
		<l2 id="uj" display="Level up!" text="Level up!"/>
		<l2 id="uk" display="Rank up!" text="Rank up!"/>
		<l2 id="ul" display="LONG UN-LIVE THE SHADOWSCYTHE!!" text="LONG UN-LIVE THE SHADOWSCYTHE!!"/>
		<l2 id="um" display="Long live King Alteon the Good!!" text="Long live King Alteon the Good!!"/>
		<l2 id="un" display="This rocks!" text="This rocks!"/>
		<l2 id="uo" display="This is awesome!" text="This is awesome!"/>
		<l2 id="up" display="This is fun." text="This is fun."/>
		<l2 id="uq" display="That is really cool." text="That is really cool."/>
		<l2 id="ur" display="Cheer up!" text="Cheer up!"/>
		<l2 id="ut" display="Great!" text="Great!"/>
		<l2 id="uu" display="HaHa" text="HaHa"/>
	</l1>
	<l1 display="Stop">
		<l2 id="va" display="following me" text="Please stop following me."/>
		<l2 id="vb" display="doing that" text="Please stop doing that."/>
		<l2 id="vc" display="PMing me" text="Please stop PMing me."/>
	</l1>
	<l1 display="Smilies">
		<l2 id="wa" display=":)" text=":)"/>
		<l2 id="wb" display=":(" text=":("/>
		<l2 id="wc" display=":/" text=":/"/>
		<l2 id="wd" display=":|" text=":|"/>
		<l2 id="we" display=":O" text=":O"/>
		<l2 id="wf" display="D:" text="D:"/>
	</l1>
	<l1 id="x" display="Yes." text="Yes."/>
	<l1 id="y" display="No." text="No."/>
	<l1 id="z" display="OK." text="OK."/>
</CannedChat>
        ;
        private var profanityA:Array = ["@$$", "&&##", "anal", "arse", "ass", "a55", "a5s", "as5", "a$$", "a$s", "as$", "a5$", "a$5", "a*s", "*ss", "a**", "as*", "assclown", "assface", "asshole", "asswipe", "bastard", "beating the meat", "beef curtains", "beef flaps", "betch", "biatch", "bich", "bish", "b1ch", "b!ch", "blch", "b|ch", "bitch", "b1tch", "b!tch", "bltch", "b|tch", "bizzach", "blowjob", "boobies", "boobs", "b00bs", "buggery", "bullshit", "buttsex", "carpet muncher", "carpet munchers", "carpetlicker", "carpetlickers", "ch1nk", "chink", "chode", "clit", "cocaine", "cock", "cocks", "c0ck", "co*k", "c*ck", "cocksucker", "condom", "cracka", "cum", "cumming", "cums", "cummies", "cumguzzler", "cumlicker", "cuck", "cumsucker", "cumdrinker", "cunt", "cunts", "c*nt", "cu*t", "*unt", "cun*", "cumslut", "dicksucker", "damn", "d1ck", "dick", "di*k", "d*ck", "d**k", "d|ck", "dildo", "d1ldo", "dumbass", "dumb4ss", "dyke", "ejaculate", "f*ck", "feck", "f@g", "fag", "f4ggot", "f4gg0t", "faggot", "fap", "f4p", "fapping", "f4pping", "fatass", "fack", "feck", "felcher", "foreskin", "fhuck", "fking", "fuk", "fck", "fuck", "fuc", "fu*k", "fuuck", "fuuk", "fcuk", "fvck", "fvk", "fvvck", "fvvk", "fock", "fux0r", "fucken", "fucker", "fucking", "fudgepacker", "ganja", "gook", "h0r", "h*re", "hentai", "heroin", "h0mo", "h0m0", "homo", "horny", "injun", "jack off", "jerk off", "jackass", "j1sm", "jism", "j1zz", "jizz", "kawk", "kike", "klootzak", "knulle", "kraut", "kuk", "kunt", "kuksuger", "kurac", "kurwa", "kusi", "kyrpa", "l3+ch", "lesbo", "lez", "marijuana", "masturbate", "masturbation", "meat puppet", "merd", "milf", "molester", "m0lester", "m0l3ster", "m0l3st3r", "motherfucker", "muie", "mulkku", "nads", "nazi", "n1gga", "nigga", "nigger", "nutsack", "orospu", "orgasm", "orgy", "p0rn", "paska", "penis", "phuck", "pierdol", "pillu", "pimmel", "pimp", "piss", "poontsee", "porn", "p0rno", "p0rn0", "porno", "pr0n", "preteen", "pron", "prostitute", "pussy", "pussie", "pu$$y", "puta", "puto", "queef", "r4pe", "rape", "r4ped", "raped", "rapist", "retard", "rimjob", "schaffer", "schiess", "schlampe", "screw", "scrotum", "secks", "s3x", "sex", "s*x", "se*", "sharmuta", "sharmute", "shipal", "shit", "sh1t", "sh!t", "shlt", "sh|t", "shiz", "sh1z", "sh!z", "shlz", "sh|z", "shiit", "shi!t", "sh!it", "shilt", "shlit", "sh||t", "shi|t", "sh|it", "shiiz", "shi t", "shyt", "sh*t", "s*it", "s**t", "s***", "shlong", "skank", "skurwysyn", "slut", "sl*t", "s**t", "smartass", "smut", "spierdalaj", "splooge", "threesome", "tit", "tits", "titties", "twat", "vagina", "wank", "weed", "wetback", "whack off", "wh0re", "whore", "whoring", "wichser", "yolasite", "zabourah", "yolas1te", "y0lasite", "y0las1te", "webly", "w33bly", "web1y", "w33b1y", "anus", "4nus", "rectum", "r3ctum", "foda", "fodao", "phoda", "phodao", "Azzhole", "A$$hole", "AsshoIe", "Azzhole", "Asswipe", "Btch", "B!tch", "BItch", "BItch", "D!ck", "Dlck", "D!ldo", "Dumbass", "Dyke", "Fgt", "Faggot", "Fagget", "Fegget", "Feggit", "Feget", "Fggot", "Fggt", "Fhaggot", "F4g", "Fken", "Fkking", "fu/ck", "H#mo", "Nigga", "N|gger", "Niga", "Ngga", "Pen1s", "Rape", "Rhape", "Raep", "Buceta", "Xoxota", "Cachorra", "Cagada", "puta", "Foda-se", "Macaco", "Negrinho", "Merda", "Porra", "Merdimbuca", "Mijada", "Mijão", "Ninfeta", "Sapatao", "Cagada", "Cerote", "Chichis", "Cojer", "Cojido", "Culera", "Culero", "Culona", "Joto", "Mamahuevo", "Maricon", "Mierda", "Nachas", "Nalgas", "Nalgona", "Pendeja", "Pendejo", "Perra", "Pito", "Puta", "Puto", "Putas", "Retardado", "Tetas", "Verga", "Vergisima"];
        private var profanityB:Array = ["porn", "nigger", "slut", "dick"];
        private var profanityD:Array = ["chink", "puto", "puta", "oten"];
        private var profanityF:Array = ["nigga", "nigger", "cunt", "fag", "tranny", "shemale", "kontol", "vagina", "penis", "clitoris", "kike", "slut", "dick"];
        private var profanityC:Array = ["bitch", "b1tch", "b!tch", "bltch", "b|tch", "damn", "dick", "fag", "fuk", "fvk", "fvck", "fuck", "pussy", "shit", "sh1t", "sh!t", "shlt", "sh|t"];
        public var unsendable:* = ["@"];
        public var regExpURL:RegExp = new RegExp("\\bhttps://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]", "gi");
        public var emailWarning:String = "WARNING: Never give your email or password to anyone else. Moderators have gold names. If a player does not have a gold name they are NOT a moderator or staff member.";
        public var legalChars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*_+-=:\"?,./;'\\|<>() ";
        public var legalCharsStrict:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        public var markChars:* = "~!@#$%^&*()_+-=:\"<>?,.;'\\";
        public var strictComparisonChars:* = "~!@#$%^&*()_+-=:\"<>?,.;'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
        public var strictComparisonCharsB:* = "~!#%^&()_+-=:\"<>?,.;'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
        public var illegalStrings:* = ["&#", "www", "http", "https", "ftp", ".com", ".c0m", ".net", ".org", ".de", ".ru", ".sg", ".ph", ".tk", "dotcom", "freegold", "freecoins", "freeadventurecoins", "freelevels", "freeitems", "freeupgrades", "gmail", "yahoo", "hotmail", "aol", "formfacil", "email", "password"];
        public var modWhisperCheckList:Array = ["trade", "free", "acs", "member", "pass", "login", "user", "imamod", "iamamod", "i'mamod", "account"];
        internal var pmMode:* = 0;
        public var pmI:int = 0;
        public var myMsgsI:int = 0;
        public var t:Timer = new Timer(500, 1);
        public var pmSourceA:* = [];
        public var pmNm:String = "";
        public var iChat:int = 0;
        internal var regExpMod:RegExp = /(\(|<)mod(era(t|d)or)?(>|\))/gi;
        public var regExpA:RegExp = /(a{2,})/gi;
        public var regExpE:RegExp = /(e{2,})/gi;
        public var regExpI:RegExp = /(i{2,})/gi;
        public var regExpO:RegExp = /(o{2,})/gi;
        public var regExpU:RegExp = /(u{2,})/gi;
        public var regExpSPACE:RegExp = /(\s{2,})/gi;
        public var ignoreList:SharedObject = SharedObject.getLocal("ignoreList", "/");
        public var mute:* = {
            "ts":0,
            "cd":0,
            "timer":new Timer(0, 1)
        };

        public function Chat2(_arg_1:MovieClip)
        {
            r = _arg_1;
            rootClass = _arg_1;
            messages = [];
            initObject();
        }

        public function initObject():void
        {
            chn.world = {
                col: 0x66C2FF,
                str: "world",
                typ: "world",
                tag: "",
                rid: 0,
                act: 1
            }

            chn.cur = {};
            chn.lastPublic = {};
            chn.xt = "zm";
            chn.zone = {};
            chn.trade = {};
            chn.support = {};
            chn.moderator = {};
            chn.admin = {};
            chn.administrator = {};
            chn.gm = {};
            chn.developer = {};
            chn.owner = {};
            chn.warning = {};
            chn.server = {};
            chn.event = {};
            chn.whisper = {};
            chn.party = {};
            chn.guild = {};
            chn.wheel = {};
            chn.zone.col = 0x66C2FF;
            chn.trade.col = 13827476;
            chn.support.col = 0x2DD4BF;
            chn.moderator.col = 0xFFD166;
            chn.admin.col = 0xFF6B6B;
            chn.administrator.col = 0xFF6B6B;
            chn.gm.col = 0xC084FC;
            chn.developer.col = 0xF59E0B;
            chn.owner.col = 0xFF4FD8;
            chn.warning.col = 0xA80000;
            chn.server.col = 0xFFFF;
            chn.event.col = 0xFF00;
            chn.whisper.col = 0xFF00FF;
            chn.party.col = 52479;
            chn.guild.col = 0x99FF00;
            chn.wheel.col = 16763955;
            chn.zone.str = "zone";
            chn.trade.str = "trade";
            chn.support.str = "support";
            chn.moderator.str = "moderator";
            chn.admin.str = "admin";
            chn.administrator.str = "administrator";
            chn.gm.str = "gm";
            chn.developer.str = "developer";
            chn.owner.str = "owner";
            chn.warning.str = "warning";
            chn.server.str = "server";
            chn.event.str = "event";
            chn.whisper.str = "whisper";
            chn.party.str = "party";
            chn.guild.str = "guild";
            chn.wheel.str = "wheel";
            chn.zone.typ = "message";
            chn.trade.typ = "message";
            chn.support.typ = "message";
            chn.moderator.typ = "whisper";
            chn.admin.typ = "message";
            chn.administrator.typ = "message";
            chn.gm.typ = "message";
            chn.developer.typ = "message";
            chn.owner.typ = "message";
            chn.warning.typ = "server";
            chn.server.typ = "server";
            chn.event.typ = "event";
            chn.whisper.typ = "whisper";
            chn.party.typ = "message";
            chn.guild.typ = "message";
            chn.wheel.typ = "whisper";
            chn.zone.tag = "";
            chn.trade.tag = "";
            chn.support.tag = "Support";
            chn.moderator.tag = "Moderator";
            chn.admin.tag = "Administrator";
            chn.administrator.tag = "Administrator";
            chn.gm.tag = "Game Master";
            chn.developer.tag = "Developer";
            chn.owner.tag = "Owner";
            chn.warning.tag = "";
            chn.server.tag = "";
            chn.whisper.tag = "Whisper";
            chn.event.tag = "";
            chn.party.tag = "Party";
            chn.guild.tag = "Guild";
            chn.wheel.tag = "Wheel of Doom";
            chn.zone.rid = 0;
            chn.trade.rid = 0;
            chn.support.rid = 0;
            chn.moderator.rid = 0;
            chn.admin.rid = 0;
            chn.administrator.rid = 0;
            chn.gm.rid = 0;
            chn.developer.rid = 0;
            chn.owner.rid = 0;
            chn.warning.rid = 0;
            chn.server.rid = 0;
            chn.event.rid = 0;
            chn.whisper.rid = 0;
            chn.party.rid = 32123;
            chn.guild.rid = 0;
            chn.wheel.rid = 0;
            chn.zone.act = 1;
            chn.trade.act = 0;
            chn.support.act = 1;
            chn.moderator.act = 1;
            chn.admin.act = 1;
            chn.administrator.act = 1;
            chn.gm.act = 1;
            chn.developer.act = 1;
            chn.owner.act = 1;
            chn.warning.act = 1;
            chn.server.act = 1;
            chn.event.act = 1;
            chn.whisper.act = 1;
            chn.party.act = 0;
            chn.guild.act = 0;
            chn.wheel.act = 1;
            chn.cur = chn.zone;
            chn.lastPublic = chn.cur;
            if (ignoreList.data.users == undefined)
            {
                ignoreList.data.users = [];
            }
        }

        /**
         * Aera chat protocol compatibility.
         * Keeps rank aliases and /iay/adminyell broadcasts safe across emulator revisions.
         */
        private function normalizeChannelType(_arg_1:*):String
        {
            var _local_1:String = ((_arg_1 == null) ? "" : String(_arg_1).toLowerCase());
            var _local_2:String = _local_1.split("-").join("").split("_").join("").split(" ").join("");
            var _local_3:Boolean = ((_local_2.indexOf("iay") > -1) || (_local_2.indexOf("adminyell") > -1));

            if (_local_3)
            {
                if ((_local_2.indexOf("support") > -1) || (_local_2.indexOf("helper") > -1)) return ("support");
                if ((_local_2.indexOf("moderator") > -1) || (_local_2.indexOf("mod") > -1)) return ("moderator");
                if ((_local_2.indexOf("owner") > -1)) return ("owner");
                if ((_local_2.indexOf("developer") > -1) || (_local_2.indexOf("dev") > -1)) return ("developer");
                if ((_local_2.indexOf("gamemaster") > -1) || (_local_2.indexOf("gm") > -1)) return ("gm");
                return ("administrator");
            }

            switch (_local_2)
            {
                case "say":
                case "player":
                case "zone":
                    return ("zone");
                case "support":
                case "helper":
                    return ("support");
                case "mod":
                case "moderator":
                    return ("moderator");
                case "admin":
                case "administrator":
                    return ("administrator");
                case "gamemaster":
                case "gm":
                    return ("gm");
                case "developer":
                case "dev":
                    return ("developer");
                case "owner":
                    return ("owner");
            }

            if ((_local_1 != "") && (chn[_local_1] != null))
            {
                return (_local_1);
            }
            return ("");
        }

        private function isServerBroadcastType(_arg_1:*):Boolean
        {
            var _local_1:String = ((_arg_1 == null) ? "" : String(_arg_1).toLowerCase());
            return (((_local_1.indexOf("iay") > -1) || (_local_1.indexOf("adminyell") > -1)));
        }

        private function getAeraServerName():String
        {
            try
            {
                if (((Game.serverName != null) && (String(Game.serverName).length > 0)))
                {
                    return (String(Game.serverName));
                }
            }
            catch(e:Error)
            {
            }
            try
            {
                if (((r != null) && (r.objServerInfo != null) && (r.objServerInfo.sName != null)))
                {
                    return (String(r.objServerInfo.sName));
                }
            }
            catch(e2:Error)
            {
            }
            return ("");
        }

        private function replaceIgnoreCase(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            var _local_1:String;
            var _local_2:String;
            var _local_3:int;
            if (((_arg_1 == null) || (_arg_2 == null) || (_arg_2.length < 1)))
            {
                return ((_arg_1 == null) ? "" : _arg_1);
            }
            _local_1 = _arg_1;
            _local_2 = _local_1.toLowerCase();
            _local_3 = _local_2.indexOf(_arg_2.toLowerCase());
            while (_local_3 > -1)
            {
                _local_1 = (_local_1.substr(0, _local_3) + _arg_3 + _local_1.substr((_local_3 + _arg_2.length)));
                _local_2 = _local_1.toLowerCase();
                _local_3 = _local_2.indexOf(_arg_2.toLowerCase(), (_local_3 + _arg_3.length));
            }
            return (_local_1);
        }

        private function normalizeServerMarker(_arg_1:String):String
        {
            var _local_1:String = getAeraServerName();
            var _local_2:String = ((_arg_1 == null) ? "" : _arg_1);
            if (_local_1.length > 0)
            {
                _local_2 = replaceIgnoreCase(_local_2, ("(" + _local_1 + ")"), "(SERVER)");
                _local_2 = replaceIgnoreCase(_local_2, ("[" + _local_1 + "]"), "(SERVER)");
            }
            return (_local_2);
        }

        private function hasServerMarker(_arg_1:String):Boolean
        {
            var _local_1:String = ((_arg_1 == null) ? "" : _arg_1.toLowerCase());
            var _local_2:String = getAeraServerName();
            if (_local_1.indexOf("(server)") > -1)
            {
                return (true);
            }
            if (_local_2.length > 0)
            {
                _local_2 = _local_2.toLowerCase();
                if (((_local_1.indexOf(("(" + _local_2 + ")")) > -1) || (_local_1.indexOf(("[" + _local_2 + "]")) > -1)))
                {
                    return (true);
                }
            }
            return (false);
        }

        private function stripServerMarkerFromUser(_arg_1:String):String
        {
            var _local_1:String = ((_arg_1 == null) ? "" : _arg_1);
            var _local_2:String = getAeraServerName();
            _local_1 = replaceIgnoreCase(_local_1, "(SERVER)", "");
            if (_local_2.length > 0)
            {
                _local_1 = replaceIgnoreCase(_local_1, ("(" + _local_2 + ")"), "");
                _local_1 = replaceIgnoreCase(_local_1, ("[" + _local_2 + "]"), "");
            }
            while (_local_1.indexOf("  ") > -1)
            {
                _local_1 = _local_1.split("  ").join(" ");
            }
            return (_local_1.replace(/^\s+|\s+$/g, ""));
        }

        private function isRankedPublicChannel(_arg_1:String):Boolean
        {
            return (((((((((_arg_1 == "zone") || (_arg_1 == "world")) || (_arg_1 == "support")) || (_arg_1 == "moderator")) || (_arg_1 == "admin")) || (_arg_1 == "administrator")) || (_arg_1 == "gm")) || (_arg_1 == "developer")) || (_arg_1 == "owner"));
        }

        public function init():void
        {
            var _aeraOldMask:*;
            initProfanity();
            if (((r == null) || (r.ui == null) || (r.ui.mcInterface == null) || (r.ui.nc == null) || (r.ui.nc.ncTextLine == null)))
            {
                return;
            }
            mci = r.ui.mcInterface;

            // init() can be called again after an interface reload. Remove the old
            // runtime objects/listeners first so chat input does not fire twice.
            if (rootClass.stage != null)
            {
                rootClass.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
            }
            mci.ncSendText.removeEventListener(MouseEvent.CLICK, onBtnSendText);
            mci.ncModeChat.removeEventListener(MouseEvent.CLICK, onBtnShortTall);
            mci.ncCannedChat.removeEventListener(MouseEvent.CLICK, onCannedChat);
            mci.ncText.removeEventListener(KeyboardEvent.KEY_DOWN, r.key_ChatEntry);
            mci.ncText.removeEventListener(Event.CHANGE, checkMsgType);
            mci.ncText.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
            mci.ncText.removeEventListener(MouseEvent.MOUSE_OVER, onMinimalOver);
            mci.ncText.removeEventListener(MouseEvent.MOUSE_OUT, onMinimalOut);
            mci.ncHistory.removeEventListener(MouseEvent.CLICK, onHistoryClick);
            if (r.stage != null)
            {
                r.stage.removeEventListener(KeyboardEvent.KEY_DOWN, r.key_StageGame);
            }
            if (fadeTimer != null)
            {
                fadeTimer.stop();
                fadeTimer.removeEventListener(TimerEvent.TIMER, fadeEffect);
                fadeTimer = null;
            }
            fadeQueue = [];
            bMinimal = false;
            bHovering = false;

            if (mcCannedChat != null)
            {
                mcCannedChat.removeEventListener(MouseEvent.MOUSE_OVER, onCannedChatOver);
                mcCannedChat.removeEventListener(MouseEvent.MOUSE_OUT, onCannedChatOut);
                if (mcCannedChat.parent != null)
                {
                    mcCannedChat.parent.removeChild(mcCannedChat);
                }
            }
            t.stop();
            t.removeEventListener(TimerEvent.TIMER, closeCannedChatTimer);

            r.ui.nc.mask = null;
            _aeraOldMask = r.ui.getChildByName("ncMask");
            if (((_aeraOldMask != null) && (_aeraOldMask.parent == r.ui)))
            {
                r.ui.removeChild(_aeraOldMask);
            }

            mask = new Shape();
            mask.graphics.beginFill(0);
            mask.graphics.drawRect(0, 0, 312.7, r.ui.nc.ncTextLine.height);
            mask.graphics.endFill();
            mcInvis = new MovieClip();
            mcInvis.addChild(mask);
            r.ui.addChild(mcInvis);
            mcInvis.name = "ncMask";
            mcInvis.x = r.ui.nc.x;
            mcInvis.y = r.ui.nc.y;
            r.ui.nc.mask = mcInvis;

            if (rootClass.stage != null)
            {
                rootClass.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
            }
            mci.ncSendText.addEventListener(MouseEvent.CLICK, onBtnSendText, false, 0, true);
            mci.ncModeChat.addEventListener(MouseEvent.CLICK, onBtnShortTall, false, 0, true);
            mci.ncCannedChat.addEventListener(MouseEvent.CLICK, onCannedChat, false, 0, true);
            mcCannedChat = initCannedChat(xmlCannedOptions.children());
            t.addEventListener(TimerEvent.TIMER, closeCannedChatTimer, false, 0, true);
            r.ui.addChild(mcCannedChat);
            mcCannedChat.addEventListener(MouseEvent.MOUSE_OVER, onCannedChatOver, false, 0, true);
            mcCannedChat.addEventListener(MouseEvent.MOUSE_OUT, onCannedChatOut, false, 0, true);
            mcCannedChat.y = (495 + (-(mcCannedChat.numChildren) * 23));
            mcCannedChat.visible = false;
            if (r.stage != null)
            {
                r.stage.addEventListener(KeyboardEvent.KEY_DOWN, r.key_StageGame, false, 0, true);
            }
            mci.ncText.addEventListener(KeyboardEvent.KEY_DOWN, r.key_ChatEntry, false, 0, true);
            mci.ncText.addEventListener(Event.CHANGE, checkMsgType, false, 0, true);
            mci.ncHistory.addEventListener(MouseEvent.CLICK, onHistoryClick, false, 0, true);
            r.ui.mouseEnabled = false;
            mci.mouseEnabled = false;
            r.ui.nc.mouseEnabled = false;
            r.ui.nc.mouseChildren = false;
            r.ui.nc.ncTextLine.mouseEnabled = false;
            r.ui.nc.ncTextLine.mouseChildren = false;
            mcInvis.mouseEnabled = false;
            mcInvis.mouseChildren = false;
            clearEverything();
            setMinimalMode(Boolean(r.litePreference.data.dOptions["chatMinimal"]));
        }

        public function onMinimalOver(_arg_1:MouseEvent):void
        {
            bHovering = true;
            var _local_2:int;
            while (_local_2 < r.ui.nc.ncTextLine.numChildren)
            {
                r.ui.nc.ncTextLine.getChildAt(_local_2).alpha = ((r.ui.nc.ncTextLine.getChildAt(_local_2).isTS) ? 0.4 : 1);
                _local_2++;
            }
        }

        public function onMinimalOut(_arg_1:MouseEvent):void
        {
            bHovering = false;
            var _local_2:int;
            while (_local_2 < r.ui.nc.ncTextLine.numChildren)
            {
                r.ui.nc.ncTextLine.getChildAt(_local_2).alpha = 0;
                _local_2++;
            }
        }

        public function setMinimalMode(_arg_1:Boolean):void
        {
            var _local_2:int;
            if (((rootClass == null) || (rootClass.stage == null) || (mci == null) || (mci.ncText == null) || (r == null) || (r.ui == null) || (r.ui.nc == null) || (r.ui.nc.ncTextLine == null)))
            {
                bMinimal = false;
                return;
            }
            if (_arg_1 == bMinimal)
            {
                return;
            }
            if (_arg_1)
            {
                rootClass.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
                mci.ncText.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
                mci.ncText.removeEventListener(MouseEvent.MOUSE_OVER, onMinimalOver);
                mci.ncText.removeEventListener(MouseEvent.MOUSE_OUT, onMinimalOut);
                mci.ncText.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
                mci.ncText.addEventListener(MouseEvent.MOUSE_OVER, onMinimalOver, false, 0, true);
                mci.ncText.addEventListener(MouseEvent.MOUSE_OUT, onMinimalOut, false, 0, true);
                if (fadeTimer != null)
                {
                    fadeTimer.stop();
                    fadeTimer.removeEventListener(TimerEvent.TIMER, fadeEffect);
                }
                fadeQueue = [];
                fadeTimer = new Timer(70);
                fadeTimer.addEventListener(TimerEvent.TIMER, fadeEffect, false, 0, true);
                fadeTimer.start();
            }
            else
            {
                rootClass.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
                rootClass.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
                mci.ncText.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
                mci.ncText.removeEventListener(MouseEvent.MOUSE_OVER, onMinimalOver);
                mci.ncText.removeEventListener(MouseEvent.MOUSE_OUT, onMinimalOut);
                fadeQueue = [];
                if (fadeTimer != null)
                {
                    fadeTimer.stop();
                    fadeTimer.removeEventListener(TimerEvent.TIMER, fadeEffect);
                    fadeTimer = null;
                }
                bHovering = false;
                _local_2 = 0;
                while (_local_2 < r.ui.nc.ncTextLine.numChildren)
                {
                    r.ui.nc.ncTextLine.getChildAt(_local_2).alpha = ((r.ui.nc.ncTextLine.getChildAt(_local_2).isTS) ? 0.4 : 1);
                    _local_2++;
                }
            }
            bMinimal = _arg_1;
            if (((bMinimal) && (fadeQueue != null) && (fadeQueue.length == 0)))
            {
                _local_2 = 0;
                while (_local_2 < r.ui.nc.ncTextLine.numChildren)
                {
                    r.ui.nc.ncTextLine.getChildAt(_local_2).alpha = 0;
                    _local_2++;
                }
            }
        }

        private function rebuildHistory():void
        {
            if (cmdHistory.length < 1)
            {
                return;
            }
            if (r.ui.getChildByName("mcHistory"))
            {
                r.ui.removeChild(r.ui.getChildByName("mcHistory"));
            }
            mcHistory = initHistory();
            r.ui.addChild(mcHistory);
            mcHistory.name = "mcHistory";
            mcHistory.x = 42.95;
            mcHistory.y = (495 + (-(mcHistory.numChildren) * 23));
            mcHistory.visible = false;
        }

        private function initHistory():MovieClip
        {
            var _local_6:*;
            var _local_7:MovieClip;
            var _local_1:MovieClip = new MovieClip();
            var _local_2:Number = 0;
            var _local_3:int;
            while (_local_3 < cmdHistory.length)
            {
                _local_6 = new CannedOption();
                _local_6.y = (_local_3 * 23);
                _local_6.addEventListener(MouseEvent.ROLL_OVER, onCmdRollOver, false, 0, true);
                _local_6.addEventListener(MouseEvent.ROLL_OUT, onCmdRollOut, false, 0, true);
                _local_6.txtChat.text = cmdHistory[_local_3];
                if (_local_6.txtChat.textWidth > _local_2)
                {
                    _local_2 = _local_6.txtChat.textWidth;
                }
                _local_6.mcMore.visible = false;
                _local_6.strMsg = cmdHistory[_local_3];
                _local_1.addChild(_local_6);
                _local_6.addEventListener(MouseEvent.CLICK, onCmdMouseClick, false, 0, true);
                _local_3++;
            }
            var _local_4:int;
            while (_local_4 < _local_1.numChildren)
            {
                _local_7 = MovieClip(_local_1.getChildAt(_local_4));
                _local_7.txtChat.width = (_local_2 + 6);
                _local_7.bg.width = (_local_2 + 20);
                _local_4++;
            }
            var _local_5:BevelFilter = new BevelFilter(1, 45, 0, 1, 0, 1, 0, 0, 1, 3);
            _local_1.filters = [_local_5];
            return (_local_1);
        }

        private function onCmdRollOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 25, 25, 25, 0);
        }

        private function onCmdRollOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        }

        private function onCmdMouseClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            mci.ncText.text = _local_2.strMsg;
            mcHistory.visible = false;
            r.stage.focus = null;
        }

        public function onHistoryClick(_arg_1:MouseEvent):void
        {
            if (cmdHistory.length < 1)
            {
                return;
            }
            mcHistory.visible = (!(mcHistory.visible));
        }

        public function onCannedChat(_arg_1:MouseEvent):void
        {
            mcCannedChat.visible = (!(mcCannedChat.visible));
        }

        public function onClick(_arg_1:MouseEvent):void
        {
            if (((((_arg_1.target) && (_arg_1.target.parent)) && (_arg_1.target.parent.id)) && (_arg_1.target.parent.hasURL)))
            {
                onLinkSelected(_arg_1.target.parent.id);
            }
        }

        public function onBtnShortTall(_arg_1:MouseEvent):void
        {
            iChatMode++;
            if (iChatMode > 2)
            {
                iChatMode = 0;
            }
            r.ui.nc.visible = (!(iChatMode == 2));
            if (iChatMode == 2)
            {
                return;
            }
            bTall = (iChatMode == 1);
            r.ui.removeChild(r.ui.getChildByName("ncMask"));
            mask = new Shape();
            mask.graphics.beginFill(0);
            mask.graphics.drawRect(0, 0, 312.7, ((bTall) ? 324.6 : 118.1));
            mask.graphics.endFill();
            mcInvis = new MovieClip();
            mcInvis.addChild(mask);
            r.ui.addChild(mcInvis);
            mcInvis.name = "ncMask";
            mcInvis.x = r.ui.nc.x;
            mcInvis.y = ((bTall) ? (187.9 - 20) : 374.9);
            r.ui.nc.mask = r.ui.getChildByName("ncMask");
            mcInvis.mouseEnabled = false;
            mcInvis.mouseChildren = false;
            upConst = ((bTall) ? 187.4 : 51);
            heightConst = ((bTall) ? -132.95 : 83.45);
            rebuild();
        }

        public function onBtnSendText(_arg_1:MouseEvent):void
        {
            submitMsg(mci.ncText.text, chn.cur.typ, pmNm);
            r.stage.focus = null;
        }

        private function toBottom():void
        {
            r.ui.nc.ncTextLine.y = ((r.ui.nc.mask.height - r.ui.nc.ncTextLine.height) + heightConst);
            r.ui.nc.ncTextLine.y = (r.ui.nc.ncTextLine.y - (r.ui.nc.ncTextLine.getChildAt((r.ui.nc.ncTextLine.numChildren - 1)).height - 16.25));
        }

        private function setScrollForBottom(_arg_1:Boolean=false, _arg_2:Boolean=false):void
        {
            heightConst = ((bTall) ? -132.95 : 83.45);
            if (r.ui.nc.ncTextLine.numChildren < 1)
            {
                return;
            }
            if (r.litePreference.data.dOptions["chatScroll"])
            {
                if ((((wasBottom) && (_arg_1)) || (_arg_2)))
                {
                    toBottom();
                }
                return;
            }
            if (((_arg_1) || (_arg_2)))
            {
                toBottom();
            }
        }

        public function onScroll(_arg_1:MouseEvent):void
        {
            if (rootClass.litePreference.data.bDisChatScroll)
            {
                return;
            }
            if (!r.ui.nc.hitTestPoint(_arg_1.stageX, _arg_1.stageY))
            {
                return;
            }
            var _local_2:MovieClip = r.ui.nc.ncTextLine;
            _arg_1.delta = (_arg_1.delta * 6);
            setScrollForBottom();
            _local_2.y = (_local_2.y + _arg_1.delta);
            if (_local_2.y >= upConst)
            {
                _local_2.y = upConst;
            }
            else
            {
                if (_local_2.y <= (heightConst - (_local_2.height - r.ui.nc.mask.height)))
                {
                    toBottom();
                }
            }
        }

        public function nuProfanityCheck(_arg_1:String, _arg_2:Boolean=false):Object
        {
            var _local_5:String;
            var _local_3:* = ((_arg_2) ? profanityD : profanityA);
            var _local_4:* = ((_arg_2) ? profanityF : profanityB);
            var _local_6:int;
            var _local_7:Object = {
                "code":0,
                "term":"",
                "index":-1,
                "indeces":[]
            };
            _local_5 = ((" " + removeHTML(cleanStr(_arg_1.toLowerCase()))) + " ");
            _local_5 = rootClass.stripMarks(_local_5);
            _local_5 = rootClass.stripDuplicateVowels(_local_5);
            _local_5 = _local_5.replace(regExpMultiG, "gg");
            _local_6 = 0;
            while (_local_6 < _local_3.length)
            {
                _local_7.index = _local_5.indexOf(((" " + _local_3[_local_6]) + " "));
                if (_local_7.index > -1)
                {
                    _local_7.term = _local_3[_local_6];
                    _local_7.indeces.push({"term":_local_7.term});
                    _local_7.code = 1;
                }
                _local_6++;
            }
            _local_5 = rootClass.stripDuplicateVowels(removeHTML(cleanStr(_arg_1.toLowerCase())));
            _local_5 = rootClass.stripWhiteStrict(_local_5);
            _local_5 = _local_5.replace(regExpMultiG, "gg");
            _local_6 = 0;
            while (_local_6 < _local_4.length)
            {
                _local_7.index = _local_5.indexOf(_local_4[_local_6]);
                if (_local_7.index > -1)
                {
                    _local_7.term = _local_4[_local_6];
                    _local_7.indeces.push({"term":_local_7.term});
                    _local_7.code = 2;
                }
                _local_6++;
            }
            return (_local_7);
        }

        public function createAsterisk(_arg_1:int):*
        {
            var _local_2:* = "";
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                _local_2 = (_local_2 + "*");
                _local_3++;
            }
            return (_local_2);
        }

        public function buildRegex(_arg_1:String):String
        {
            var _local_2:* = "";
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2 = (_local_2 + ((("(" + ((regexEscapes.indexOf(_arg_1.charAt(_local_3)) > -1) ? "\\" : "")) + _arg_1.charAt(_local_3)) + ")+"));
                _local_3++;
            }
            return (_local_2);
        }

        public function forceRemove(_arg_1:String):String
        {
            var _local_2:String = _arg_1;
            var _local_3:RegExp = /\W*?(cum|faggot)\W*\b/gi;
            return (_local_2.replace(_local_3, ""));
        }

        public function maskStringBetween(_arg_1:String, _arg_2:Array):String
        {
            var _local_4:*;
            var _local_5:RegExp;
            var _local_3:String = _arg_1;
            if (_arg_2.length > 0)
            {
                for each (_local_4 in _arg_2)
                {
                    _local_5 = new RegExp(buildRegex(_local_4.term), "gi");
                    _local_3 = _local_3.replace(_local_5, createAsterisk(3));
                }
            }
            return (_local_3);
        }

        public function pushMsg(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*, _arg_5:*, _arg_6:int=0):*
        {
            var _aeraRawType:String = ((_arg_1 == null) ? "" : String(_arg_1));
            var _aeraOriginalUser:String = ((_arg_3 == null) ? "" : String(_arg_3));
            var _aeraOriginalMsg:String = ((_arg_2 == null) ? "" : String(_arg_2));
            var _aeraParsed:Object = parseEmbeddedAeraRank(_aeraRawType, _aeraOriginalMsg, _aeraOriginalUser);
            var _aeraBroadcast:Boolean = false;
            var _aeraType:String;
            if (_aeraParsed != null)
            {
                _aeraType = String(_aeraParsed.type);
                _arg_3 = String(_aeraParsed.user);
                _arg_2 = String(_aeraParsed.msg);
                _aeraBroadcast = Boolean(_aeraParsed.broadcast);
            }
            else
            {
                _aeraBroadcast = (isServerBroadcastType(_aeraRawType) || hasServerMarker(_aeraOriginalUser));
                _aeraType = normalizeChannelType(_aeraRawType);
                _arg_3 = stripServerMarkerFromUser(_aeraOriginalUser);
                _arg_2 = normalizeServerMarker(_aeraOriginalMsg);
                if (_aeraType == "")
                {
                    _aeraType = ((_arg_3 == "SERVER") ? "server" : "zone");
                }
                if (((isRankedPublicChannel(_aeraType)) && (String(_arg_2).toUpperCase().indexOf("(SERVER)") == 0)))
                {
                    _aeraBroadcast = true;
                    _arg_2 = String(_arg_2).substr(8).replace(/^\s*[:\-]?\s*/, "");
                }
            }
            _arg_1 = _aeraType;
            var _local_9:Boolean;
            var _local_10:int;
            var _local_11:*;
            var _local_12:Object;
            var _local_13:Object;
            var _local_14:*;
            var _local_15:*;
            var _local_16:Number;
            var _local_17:String;
            if (r.litePreference.data.bChatFilter)
            {
                if (((r.litePreference.data.dOptions["disRed"]) && (_arg_1 == "warning")))
                {
                    _local_9 = true;
                    if (_arg_2.indexOf("You are out of range!") > -1)
                    {
                        _local_9 = false;
                    }
                    else
                    {
                        if (_arg_2.indexOf("is not ready yet.") > -1)
                        {
                            _local_9 = false;
                        }
                        else
                        {
                            if (_arg_2.indexOf("No target selected!") > -1)
                            {
                                _local_9 = false;
                            }
                            else
                            {
                                if (_arg_2.indexOf("Not enough mana!") > -1)
                                {
                                    _local_9 = false;
                                }
                            }
                        }
                    }
                    if (!_local_9)
                    {
                        return;
                    }
                }
            }
            if (((!(ignoreList.data.users == null)) && (ignoreList.data.users.indexOf(String(_arg_3).toLowerCase()) > -1)))
            {
                return;
            }
            _arg_2 = cleanStr(_arg_2);
            var _local_7:Boolean;
            if (_arg_3 != "SERVER")
            {
                _local_10 = 0;
                _local_11 = rootClass.stripWhite(_arg_2.toLowerCase());
                _local_12 = nuProfanityCheck(_arg_2.toLowerCase());
                _local_13 = profanityCheck(_arg_2.toLowerCase());
                if (((!(_arg_3.toLowerCase() == String(rootClass.sfc.myUserName).toLowerCase())) && (_arg_6 == 0)))
                {
                    if (((strContains(_local_11, illegalStrings)) || (strContains(_local_11, unsendable))))
                    {
                        _local_10 = 1;
                    }
                    _local_11 = r.stripWhiteStrict(_arg_2.toLowerCase());
                    if (strContains(_local_11, ["email", "password"]))
                    {
                        _local_10 = 1;
                    }
                    if (((_arg_1 == "whisper") && (modWhisperCheck(_arg_2) > 0)))
                    {
                        _local_7 = true;
                    }
                    if (_local_10)
                    {
                        return;
                    }
                }
                if (((_local_12.code) && (rootClass.uoPref.bProf)))
                {
                    _arg_2 = maskStringBetween(_arg_2, _local_12.indeces);
                }
                if (!rootClass.uoPref.bProf)
                {
                    _local_12 = nuProfanityCheck(_arg_2.toLowerCase(), true);
                    if (_local_12.code)
                    {
                        _arg_2 = maskStringBetween(_arg_2, _local_12.indeces);
                    }
                }
                _arg_2 = forceRemove(_arg_2);
            }
            if (((rootClass != null) && (rootClass.sfc != null) && (rootClass.world != null) && (rootClass.world.myAvatar != null) && (rootClass.world.myAvatar.objData != null) && (_arg_3.toLowerCase() == String(rootClass.sfc.myUserName).toLowerCase()) && (rootClass.world.myAvatar.objData.intActivationFlag == 1)))
            {
                pushMsg("warning", "Confirm your email at https://nightvaults.com/ to protect your account and remove this message. ", "SERVER", "", 0);
                return;
            }
            if (((bMinimal) && (messages.length > 2)))
            {
                _local_14 = messages[(messages.length - 1)];
                _local_15 = 0;
                while (_local_15 < 2)
                {
                    if (((((((_local_14.msg == _arg_2) && ((_local_14.user == _arg_3) || ((_arg_3 == "SERVER") && (_local_14.user == "")))) && (_local_14.typ == _arg_1)) && (_local_14.rnm == _arg_4)) && (_local_14.org == _arg_5)) && (Boolean(_local_14.serverBroadcast) == _aeraBroadcast)))
                    {
                        return;
                    }
                    _local_14 = messages[(messages.length - 2)];
                    _local_15++;
                }
            }
            var _local_8:Object = {
                "id":messages.length,
                "typ":_arg_1,
                "rnm":_arg_4,
                "org":_arg_5,
                "user":_arg_3,
                "time":"0:00",
                "msg":_arg_2,
                "serverBroadcast":_aeraBroadcast,
                "tMC":null,
                "mc":null
            };
            _local_8.user = ((_arg_3 == "SERVER") ? "" : _arg_3);
            if (isChannel(_arg_1))
            {
                if (((!(_aeraBroadcast)) && (isRankedPublicChannel(String(_arg_1)))))
                {
                    _arg_3 = r.strToProperCase(_arg_3);
                    popBubble(("u:" + _arg_3), _arg_2, _arg_1);
                }
                messages.push(_local_8);
                _local_16 = (heightConst - (r.ui.nc.ncTextLine.height - r.ui.nc.mask.height));
                wasBottom = (Math.round(r.ui.nc.ncTextLine.y) == Math.round(_local_16));
                buildMessage(messages[(messages.length - 1)]);
            }
            if (_local_7)
            {
                pushMsg("warning", (_arg_3 + " IS NOT A MODERATOR.  DO NOT GIVE ACCOUNT INFORMATION TO OTHER PLAYERS."), "SERVER", "", 0);
                _local_17 = (("<font color='#FF0000'>WARNING</font><br/><font color='#FFFFFF'>" + _arg_3.toUpperCase()) + "</font><font color='#FFFFFF'> IS NOT A MODERATOR.<br/>Do not give account information to other players.<font>");
                _local_17 = (_local_17 + "<br/><a href='event:link::https://nightvaults.com/'><font color='#66CCFF'><u>Click here</u></font></a> to learn more.");
                r.ui.ToolTip.openWith({
                    "str":_local_17,
                    "lowerright":true,
                    "invert":true,
                    "closein":10000
                });
            }
        }

        public function clearMessages():void
        {
            if (((mci) && (r != null) && (r.ui != null) && (r.ui.nc != null) && (r.ui.nc.ncTextLine != null)))
            {
                while (r.ui.nc.ncTextLine.numChildren > 0)
                {
                    r.ui.nc.ncTextLine.removeChildAt(0);
                }
            }
        }

        public function clearEverything():void
        {
            clearMessages();
            filterCode = 0;
            if (((mci) && (r.ui.nc)))
            {
                messages = [];
            }
        }

        public function bMinMaxClick(_arg_1:MouseEvent):void
        {
        }

        public function format_time():String
        {
            var _local_4:String;
            var _local_1:Number = rootClass.date_server.hours;
            var _local_2:Number = rootClass.date_server.minutes;
            var _local_3:* = "PM";
            if (_local_1 < 10)
            {
                _local_4 = ("0" + _local_1);
            }
            if (_local_1 > 12)
            {
                _local_1 = (_local_1 - 12);
            }
            else
            {
                if (_local_1 == 0)
                {
                    _local_3 = "AM";
                    _local_1 = 12;
                }
                else
                {
                    if (_local_1 < 12)
                    {
                        _local_3 = "AM";
                    }
                }
            }
            _local_4 = ("" + _local_1);
            var _local_5:String = ("" + _local_2);
            if (_local_2 < 10)
            {
                _local_5 = ("0" + _local_2);
            }
            if (_local_5 == "NaN")
            {
                return ("");
            }
            return ((((_local_4 + ":") + _local_5) + " ") + _local_3);
        }

        public function buildMessage(_arg_1:Object):void
        {
            var _local_6:String;
            var _local_7:String;
            var _local_12:TextField;
            var _local_13:TextFormat;
            var _local_14:*;
            var _local_15:MovieClip;
            var _local_16:*;
            var _local_17:MovieClip;
            var _local_2:DropShadowFilter = new DropShadowFilter(0, 45, 0, 1, 3, 3, 5, 1, false, false, false);
            if (format_time() != "")
            {
                _local_12 = new TextField();
                _local_13 = new TextFormat();
                _local_13.font = "Arial";
                _local_13.size = 9;
                _local_13.color = 0xFFFFFF;
                _local_13.indent = -10;
                _local_13.leftMargin = 10;
                _local_13.align = TextFormatAlign.RIGHT;
                _local_14 = format_time();
                _local_12.text = _local_14;
                _local_12.antiAliasType = AntiAliasType.ADVANCED;
                _local_12.embedFonts = true;
                _local_12.setTextFormat(_local_13, 0, _local_12.text.length);
                _local_12.filters = [_local_2];
                _local_12.width = 44.1;
                _local_15 = new MovieClip();
                _local_15.addChild(_local_12);
                _local_15.alpha = 0.4;
                _arg_1.tMC = _local_15;
            }
            var _local_3:TextField = new TextField();
            _local_3.antiAliasType = AntiAliasType.ADVANCED;
            _local_3.embedFonts = true;
            _local_3.multiline = true;
            _local_3.wordWrap = true;
            _local_3.autoSize = TextFieldAutoSize.LEFT;
            _local_3.filters = [_local_2];
            var _local_4:TextFormat = new TextFormat();
            _local_4.font = "Arial";
            _local_4.size = 11;
            _local_4.color = (isRankedPublicChannel(String(_arg_1.typ)) ? chn[_arg_1.typ].col : 0xFFFFFF);
            var _local_5:TextFormat = new TextFormat();
            _local_5.font = "Arial";
            _local_5.size = 11;
            _local_5.color = chn[_arg_1.typ].col;
            _local_5.indent = -10;
            _local_5.leftMargin = 10;
            if (_arg_1.typ == "whisper")
            {
                if (((_arg_1.user == r.sfc.myUserName) || (isMyModHandle(_arg_1.user))))
                {
                    if (_arg_1.org == 0)
                    {
                        _local_5.color = uint(("0x" + rootClass.modColor("FF00FF", "666666", "-")));
                        _local_6 = "To ";
                    }
                    else
                    {
                        _local_6 = "From ";
                    }
                }
                else
                {
                    _local_6 = "From ";
                }
            }
            else
            {
                _local_6 = ((chn[_arg_1.typ].tag == "") ? "" : (("[" + chn[_arg_1.typ].tag) + "] "));
            }
            if (_arg_1.typ == "whisper")
            {
                if (((_arg_1.user == r.sfc.myUserName) || (isMyModHandle(_arg_1.user))))
                {
                    if (_arg_1.org == 0)
                    {
                        _local_7 = (_arg_1.rnm + ": ");
                    }
                    else
                    {
                        _local_7 = (_arg_1.user + ": ");
                    }
                }
                else
                {
                    _local_7 = (_arg_1.user + ": ");
                }
            }
            else
            {
                _local_7 = (_arg_1.user + ((_arg_1.user == "") ? "" : ((Boolean(_arg_1.serverBroadcast) ? " (SERVER): " : ": "))));
            }
            _local_3.text = ((_local_6 + _local_7) + _arg_1.msg);
            if (_local_3.text.length < 1)
            {
                messages.pop();
                return;
            }
            if (_local_6 != "")
            {
                _local_3.setTextFormat(_local_5, 0, _local_6.length);
                _local_3.setTextFormat(_local_4, _local_6.length, (_local_6.length + _local_7.length));
                _local_3.setTextFormat(_local_5, (_local_6.length + _local_7.length), _local_3.text.length);
            }
            else
            {
                if (_local_7 != "")
                {
                    _local_3.setTextFormat(_local_4, 0, (_local_7.length - 2));
                    _local_3.setTextFormat(_local_5, (_local_7.length - 2), _local_3.text.length);
                }
                else
                {
                    _local_3.setTextFormat(_local_5, 0, _local_3.text.length);
                }
            }
            _local_3.width = ((_arg_1.tMC) ? 266.5 : 314);
            var _local_8:TextFormat = new TextFormat();
            _local_8.font = "Arial";
            _local_8.size = 11;
            _local_8.color = 16777113;
            _local_8.underline = true;
            regExpURL.lastIndex = 0;
            var _local_9:Object = regExpURL.exec(_local_3.text);
            while (_local_9 != null)
            {
                _local_3.setTextFormat(_local_8, _local_9.index, (_local_9.index + _local_9[0].length));
                _local_9 = regExpURL.exec(_local_3.text);
                _arg_1.hasURL = true;
            }
            var _local_10:MovieClip = new MovieClip();
            _local_10.addChild(_local_3);
            _local_10.mouseEnabled = (_local_10.mouseChildren = false);
            _arg_1.mc = _local_10;
            if (((filterCode > 0) || (messages.length >= lineLimit)))
            {
                if (messages.length >= lineLimit)
                {
                    if ((((filterCode > 0) && (r.ui.nc.ncTextLine.numChildren >= (lineLimit * 2))) || ((filterCode == 0) && (r.ui.nc.ncTextLine.numChildren > 0))))
                    {
                        _local_16 = 0;
                        while (_local_16 < 50)
                        {
                            messages.shift();
                            if (r.ui.nc.ncTextLine.numChildren >= 2)
                            {
                                if (r.ui.nc.ncTextLine.getChildAt(0).isTS)
                                {
                                    r.ui.nc.ncTextLine.removeChildAt(0);
                                }
                                r.ui.nc.ncTextLine.removeChildAt(0);
                            }
                            _local_16++;
                        }
                    }
                }
                rebuild();
                return;
            }
            if (_arg_1.tMC)
            {
                _local_17 = r.ui.nc.ncTextLine.addChild(_arg_1.tMC);
                _local_17.mouseEnabled = false;
                _local_17.id = _arg_1.id;
                _local_17.isTS = true;
                if (messages.length > 1)
                {
                    _local_17.y = ((messages[(messages.length - 2)].mc.y + messages[(messages.length - 2)].mc.height) + 1.55);
                }
                if (((bMinimal) && (!(bHovering))))
                {
                    fadeQueue.push([_local_17, new Date().getTime()]);
                }
            }
            var _local_11:MovieClip = r.ui.nc.ncTextLine.addChild(_arg_1.mc);
            _local_11.mouseEnabled = false;
            _local_11.id = _arg_1.id;
            _local_11.hasURL = _arg_1.hasURL;
            _local_11.x = ((_arg_1.tMC) ? 47.45 : 0);
            if (messages.length > 1)
            {
                _local_11.y = (messages[(messages.length - 2)].mc.y + messages[(messages.length - 2)].mc.height);
            }
            if (((bMinimal) && (!(bHovering))))
            {
                fadeQueue.push([_local_11, new Date().getTime()]);
            }
            setScrollForBottom(true, ((_arg_1.typ == "server") && (_arg_1.msg == "Character load complete.")));
        }

        public function onLinkSelected(_arg_1:Number):void
        {
            var _local_2:*;
            var _local_3:Object;
            var _local_4:MovieClip;
            var _local_5:*;
            for each (_local_2 in messages)
            {
                if (((_local_2.id == _arg_1) && (_local_2.hasURL)))
                {
                    regExpURL.lastIndex = 0;
                    _local_3 = regExpURL.exec(_local_2.msg);
                    while (_local_3 != null)
                    {
                        _local_4 = new ModalMC();
                        _local_5 = {};
                        _local_5.strBody = (("Are you sure you want to go to " + _local_3[0]) + "?");
                        _local_5.callback = urlTraverse;
                        _local_5.params = {"url":_local_3[0]};
                        _local_5.btns = "dual";
                        r.ui.ModalStack.addChild(_local_4);
                        _local_4.init(_local_5);
                        _local_3 = regExpURL.exec(_local_2.msg);
                    }
                }
            }
        }

        public function urlTraverse(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                navigateToURL(new URLRequest(_arg_1.url), "_blank");
            }
            r.stage.focus = null;
        }

        public function fadeEffect(_arg_1:TimerEvent):void
        {
            var _local_2:*;
            var _local_3:int;
            if ((((!(r.ui)) || (!(r.ui.nc))) || (!(r.ui.nc.ncTextLine))))
            {
                return;
            }
            if (((fadeQueue == null) || (bHovering) || (fadeQueue.length < 1)))
            {
                if (bHovering)
                {
                    fadeQueue = [];
                }
                if (!bHovering)
                {
                    _local_3 = 0;
                    while (_local_3 < r.ui.nc.ncTextLine.numChildren)
                    {
                        r.ui.nc.ncTextLine.getChildAt(_local_3).alpha = 0;
                        _local_3++;
                    }
                }
                return;
            }
            for each (_local_2 in fadeQueue)
            {
                if (!_local_2[0])
                {
                    if (fadeQueue.indexOf(_local_2) != -1)
                    {
                        fadeQueue.splice(fadeQueue.indexOf(_local_2), 1);
                    }
                }
                else
                {
                    if (((new Date().getTime() - _local_2[1]) / 1000) >= 45)
                    {
                        if (_local_2[0].alpha > 0)
                        {
                            _local_2[0].alpha = (_local_2[0].alpha - 0.05);
                        }
                        if (_local_2[0].alpha <= 0)
                        {
                            if (fadeQueue.indexOf(_local_2) != -1)
                            {
                                fadeQueue.splice(fadeQueue.indexOf(_local_2), 1);
                            }
                        }
                    }
                }
            }
        }

        public function rebuild():void
        {
            var _local_1:Object;
            var _local_3:*;
            var _local_4:MovieClip;
            var _local_5:MovieClip;
            clearMessages();
            var _local_2:* = 0;
            for (;_local_2 < messages.length;_local_2++)
            {
                _local_3 = messages[_local_2];
                if (filterCode > 0)
                {
                    if (filterCode == 1)
                    {
                        if (_local_3.typ != "party") continue;
                    }
                    else
                    {
                        if (filterCode == 2)
                        {
                            if (_local_3.typ != "guild") continue;
                        }
                        else
                        {
                            if (filterCode == 3)
                            {
                                if (_local_3.typ != "zone" && _local_3.typ != "support" && _local_3.typ != "moderator" && _local_3.typ != "administrator" && _local_3.typ != "gm" && _local_3.typ != "developer" && _local_3.typ != "owner" && _local_3.typ != "whisper" && _local_3.typ != "world") continue;
                            }
                        }
                    }
                }
                if (_local_3.tMC)
                {
                    _local_5 = r.ui.nc.ncTextLine.addChild(_local_3.tMC);
                    _local_5.mouseEnabled = false;
                    _local_5.id = _local_3.id;
                    _local_5.x = 0;
                    if (_local_1)
                    {
                        _local_5.y = ((_local_1.mc.y + _local_1.mc.height) + 1.55);
                    }
                    else
                    {
                        _local_5.y = 1.55;
                    }
                }
                _local_4 = r.ui.nc.ncTextLine.addChild(_local_3.mc);
                _local_4.mouseEnabled = false;
                _local_4.id = _local_3.id;
                _local_4.hasURL = _local_3.hasURL;
                _local_4.x = ((_local_3.tMC) ? 47.45 : 0);
                if (_local_1)
                {
                    _local_4.y = (_local_1.mc.y + _local_1.mc.height);
                }
                else
                {
                    _local_4.y = 0;
                }
                _local_1 = _local_3;
            }
            setScrollForBottom(true);
        }



        /**
         * Parses Aera staff chat payloads that some emulator revisions wrap
         * inside a normal zone/server packet, e.g. "[gm] animu: hello".
         * This keeps rank text out of the message body so chat bubbles can
         * resolve the real avatar name and display only the spoken message.
         */
        private function aeraRankChannelFromLabel(_arg_1:String):String
        {
            var _local_1:String = ((_arg_1 == null) ? "" : _arg_1.toLowerCase());
            _local_1 = _local_1.split("-").join("").split("_").join("").split(" ").join("");
            switch (_local_1)
            {
                case "support":
                case "helper":
                    return ("support");
                case "mod":
                case "moderator":
                    return ("moderator");
                case "admin":
                case "administrator":
                    return ("administrator");
                case "gm":
                case "gamemaster":
                    return ("gm");
                case "dev":
                case "developer":
                    return ("developer");
                case "owner":
                    return ("owner");
            }
            return ("");
        }

        private function aeraTrim(_arg_1:String):String
        {
            return (((_arg_1 == null) ? "" : _arg_1).replace(/^\s+|\s+$/g, ""));
        }

        private function aeraLooksLikeUser(_arg_1:String):Boolean
        {
            var _local_1:String = aeraTrim(_arg_1);
            if (((_local_1.length < 1) || (_local_1.length > 32)))
            {
                return (false);
            }
            return (/^[A-Za-z0-9_\-]+$/.test(_local_1));
        }

        private function parseEmbeddedAeraRank(_arg_1:String, _arg_2:String, _arg_3:String):Object
        {
            var rawType:String = ((_arg_1 == null) ? "" : String(_arg_1));
            var rawUser:String = ((_arg_3 == null) ? "" : String(_arg_3));
            var msg:String = normalizeServerMarker(((_arg_2 == null) ? "" : String(_arg_2)));
            var rankType:String = "";
            var user:String = "";
            var body:String = msg;
            var broadcast:Boolean = (isServerBroadcastType(rawType) || hasServerMarker(rawUser));
            var s:String;
            var lower:String;
            var close:int;
            var colon:int;
            var label:String;
            var cut:int;
            var labels:Array;
            var i:int;
            var candidate:String;
            var normalizedType:String;

            // Some older packets put the rank in the sender field itself.
            s = aeraTrim(rawUser);
            if (s.charAt(0) == "[")
            {
                close = s.indexOf("]");
                if (close > 1)
                {
                    rankType = aeraRankChannelFromLabel(s.substring(1, close));
                    if (rankType != "")
                    {
                        user = aeraTrim(s.substr(close + 1));
                        if (hasServerMarker(user))
                        {
                            broadcast = true;
                        }
                        user = stripServerMarkerFromUser(user);
                        if (aeraLooksLikeUser(user))
                        {
                            return ({type:rankType, user:user, msg:msg, broadcast:broadcast});
                        }
                    }
                }
            }

            s = aeraTrim(msg);
            lower = s.toLowerCase();
            if (lower.indexOf("server: ") == 0)
            {
                broadcast = true;
                s = aeraTrim(s.substr(8));
                lower = s.toLowerCase();
            }

            // Preferred normal-chat form: [Rank] username: message
            if (s.charAt(0) == "[")
            {
                close = s.indexOf("]");
                if (close > 1)
                {
                    rankType = aeraRankChannelFromLabel(s.substring(1, close));
                    if (rankType != "")
                    {
                        s = aeraTrim(s.substr(close + 1));
                    }
                }
            }

            // Compatibility with /iay payloads such as
            // "Game Master animu: hi" or "Administrator (animu): hi".
            if (rankType == "")
            {
                labels = ["game master", "gamemaster", "administrator", "moderator", "developer", "support", "owner", "admin", "helper", "gm", "mod", "dev"];
                lower = s.toLowerCase();
                i = 0;
                while (i < labels.length)
                {
                    label = String(labels[i]);
                    if (lower.indexOf(label + " ") == 0)
                    {
                        rankType = aeraRankChannelFromLabel(label);
                        cut = label.length;
                        s = aeraTrim(s.substr(cut));
                        broadcast = true;
                        break;
                    }
                    i++;
                }
            }

            // If the emulator already supplied a staff channel but used SERVER
            // as the sender, accept a simple username: message payload.  Requiring
            // a username-shaped token prevents MOTD/system notices from becoming
            // fake Moderator messages.
            if (rankType == "")
            {
                normalizedType = normalizeChannelType(rawType);
                if (((rawUser.toUpperCase() == "SERVER") && ((normalizedType == "support") || (normalizedType == "moderator") || (normalizedType == "administrator") || (normalizedType == "gm") || (normalizedType == "developer") || (normalizedType == "owner"))))
                {
                    candidate = s;
                    if (candidate.charAt(0) == "(")
                    {
                        close = candidate.indexOf("):");
                        if (close > 1)
                        {
                            candidate = candidate.substring(1, close);
                        }
                    }
                    else
                    {
                        colon = candidate.indexOf(":");
                        if (colon > 0)
                        {
                            candidate = candidate.substring(0, colon);
                        }
                    }
                    candidate = stripServerMarkerFromUser(aeraTrim(candidate));
                    if (aeraLooksLikeUser(candidate))
                    {
                        rankType = normalizedType;
                        broadcast = true;
                    }
                }
            }

            if (rankType == "")
            {
                return (null);
            }

            // Parse (username): message or username (SERVER): message.
            if (s.charAt(0) == "(")
            {
                close = s.indexOf("):");
                if (close < 2)
                {
                    return (null);
                }
                user = s.substring(1, close);
                body = aeraTrim(s.substr(close + 2));
                broadcast = true;
            }
            else
            {
                colon = s.indexOf(":");
                if (colon < 1)
                {
                    return (null);
                }
                user = aeraTrim(s.substring(0, colon));
                body = aeraTrim(s.substr(colon + 1));
                if (((hasServerMarker(user)) || (user.toUpperCase().indexOf("(SERVER)") > -1)))
                {
                    broadcast = true;
                }
                user = stripServerMarkerFromUser(user);
            }

            if (!(aeraLooksLikeUser(user)))
            {
                return (null);
            }
            return ({type:rankType, user:user, msg:body, broadcast:broadcast});
        }

        private function initProfanity():void
        {
            var _local_4:String;
            var _local_1:Array = ["butt", "pron", "rape", "tits", "shi t", "shi t"];
            var _local_2:Array = ["as5", "a5s", "a$$", "a5$", "a$5", "as$", "fck", "fkc", "fvk", "fuck", "fvck", "fukk", "fvkk", "sh!t", "sh|t", "sh1t", "shiz"];
            var _local_3:int;
            while (_local_3 < profanityA.length)
            {
                _local_4 = rootClass.stripWhiteStrict(profanityA[_local_3]);
                if (((_local_1.indexOf(_local_4) == -1) && ((_local_4.length > 4) || (_local_2.indexOf(_local_4) > -1))))
                {
                    profanityB.push(_local_4);
                }
                else
                {
                    if (profanityA[_local_3].indexOf("*") > -1)
                    {
                        profanityB.push(profanityA[_local_3]);
                    }
                }
                _local_3++;
            }
        }

        private function initCannedChat(_arg_1:XMLList):MovieClip
        {
            var _local_7:XML;
            var _local_8:*;
            var _local_9:String;
            var _local_10:MovieClip;
            var _local_2:MovieClip = new MovieClip();
            var _local_3:Number = 0;
            var _local_4:int;
            while (_local_4 < _arg_1.length())
            {
                _local_7 = _arg_1[_local_4];
                _local_8 = new CannedOption();
                _local_8.y = (_local_4 * 23);
                _local_8.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
                _local_8.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
                _local_8.txtChat.text = _local_7.attribute("display").toString();
                if (_local_8.txtChat.textWidth > _local_3)
                {
                    _local_3 = _local_8.txtChat.textWidth;
                }
                _local_8.strMsg = _local_7.attribute("text").toString();
                _local_8.id = _local_7.attribute("id").toString();
                _local_2.addChild(_local_8);
                if (_local_7.children().length() > 0)
                {
                    _local_8.mcMoreOptions = initCannedChat(_local_7.children());
                    _local_8.addChild(_local_8.mcMoreOptions);
                    _local_8.mcMoreOptions.visible = false;
                    _local_9 = _local_8.txtChat.text;
                    if (((_local_9 == "During the battle") || (_local_9 == "*I'm going to...")))
                    {
                        _local_8.mcMoreOptions.y = (_local_8.mcMoreOptions.y - 100);
                    }
                }
                else
                {
                    _local_8.mcMore.visible = false;
                    _local_8.addEventListener(MouseEvent.CLICK, onMouseClick);
                }
                _local_4++;
            }
            var _local_5:int;
            while (_local_5 < _local_2.numChildren)
            {
                _local_10 = MovieClip(_local_2.getChildAt(_local_5));
                _local_10.txtChat.width = (_local_3 + 6);
                _local_10.bg.width = (_local_3 + 20);
                _local_10.mcMore.x = (_local_10.bg.width - 10);
                if (_local_10.mcMoreOptions != null)
                {
                    _local_10.mcMoreOptions.x = _local_10.bg.width;
                }
                _local_5++;
            }
            var _local_6:BevelFilter = new BevelFilter(1, 45, 0, 1, 0, 1, 0, 0, 1, 3);
            _local_2.filters = [_local_6];
            return (_local_2);
        }

        public function closeCannedChat():void
        {
            mcCannedChat.visible = false;
        }

        private function onRollOver(_arg_1:MouseEvent):*
        {
            var _local_3:*;
            var _local_4:Point;
            var _local_5:Point;
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 25, 25, 25, 0);
            if (_arg_1.currentTarget.mcMoreOptions != null)
            {
                _arg_1.currentTarget.mcMoreOptions.visible = true;
                _local_3 = _arg_1.currentTarget;
                _local_4 = new Point(_local_3.x, ((_local_3.y + _local_3.mcMoreOptions.y) + (_local_3.mcMoreOptions.numChildren * 23)));
                _local_5 = mcCannedChat.localToGlobal(_local_4);
                if (_local_5.y > 500)
                {
                    _local_3.mcMoreOptions.y = (_local_3.mcMoreOptions.y - (_local_5.y - 500));
                }
            }
        }

        private function onRollOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
            if (_arg_1.currentTarget.mcMoreOptions != null)
            {
                _arg_1.currentTarget.mcMoreOptions.visible = false;
            }
        }

        private function onMouseClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            if (_local_2.id == "emote")
            {
                submitMsg(("/" + _local_2.strMsg), "emote", rootClass.sfc.myUserName);
            }
            else
            {
                rootClass.sfc.sendXtMessage("zm", "cc", [_local_2.id], "str", 1);
            }
            closeCannedChat();
        }

        private function onCannedChatOver(_arg_1:MouseEvent):*
        {
            if (t != null)
            {
                t.reset();
            }
        }

        private function onCannedChatOut(_arg_1:MouseEvent):*
        {
            t.start();
        }

        private function closeCannedChatTimer(_arg_1:TimerEvent):*
        {
            closeCannedChat();
        }

        public function getCCText(_arg_1:String):String
        {
            var _local_2:XML = getCCOption(_arg_1, xmlCannedOptions.children());
            if (_local_2 != null)
            {
                return (_local_2.attribute("text").toString());
            }
            return ("");
        }

        private function getCCOption(_arg_1:String, _arg_2:XMLList):XML
        {
            var _local_4:XML;
            var _local_5:XML;
            var _local_3:int;
            while (_local_3 < _arg_2.length())
            {
                _local_4 = _arg_2[_local_3];
                if (_local_4.children().length() == 0)
                {
                    if (_local_4.attribute("id").toString() == _arg_1)
                    {
                        return (_local_4);
                    }
                }
                else
                {
                    _local_5 = getCCOption(_arg_1, _local_4.children());
                    if (_local_5 != null)
                    {
                        return (_local_5);
                    }
                }
                _local_3++;
            }
            return (null);
        }

        private function isMyModHandle(_arg_1:String):Boolean
        {
            if (((_arg_1.split("-")[0] == "Moderator") && (int((_arg_1.split("-")[1] == r.world.modID)))))
            {
                return (true);
            }
            return (false);
        }

        internal function popBubble(_arg_1:*, _arg_2:*, _arg_3:*):*
        {
            var _local_4:* = null;
            var _local_5:* = _arg_1.split(":")[0];
            _arg_1 = _arg_1.substr(2);
            switch (_local_5)
            {
                case "u":
                    _local_4 = r.world.getMCByUserName(_arg_1);
                    break;
            }
            if (_local_4 != null)
            {
                _local_4.bubble.ti.autoSize = TextFieldAutoSize.CENTER;
                _local_4.bubble.ti.wordWrap = true;
                _local_4.bubble.ti.text = _arg_2;
                _local_4.bubble.bg.width = int((_local_4.bubble.ti.textWidth + 12));
                _local_4.bubble.bg.height = int((_local_4.bubble.ti.textHeight + 8));
                _local_4.bubble.y = ((_local_4.pname.y - _local_4.bubble.bg.height) - 4);
                _local_4.bubble.bg.x = (0 - (_local_4.bubble.bg.width / 2));
                _local_4.bubble.arrow.y = ((_local_4.bubble.bg.y + _local_4.bubble.bg.height) - 2);
                _local_4.bubble.visible = true;
                _local_4.bubble.alpha = 100;
                if (_local_4.kv == null)
                {
                    _local_4.kv = new Killvis();
                    _local_4.kv.kill(_local_4.bubble, 3000);
                }
                else
                {
                    _local_4.kv.resetkill();
                }
            }
        }

        public function profanityCheck(_arg_1:String):Object
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:Object = {
                "code":0,
                "term":"",
                "index":-1,
                "indeces":[]
            };
            _local_2 = ((" " + cleanStr(_arg_1.toLowerCase())) + " ");
            _local_2 = r.stripMarks(_local_2);
            _local_2 = r.stripDuplicateVowels(_local_2);
            _local_3 = 0;
            while (_local_3 < profanityA.length)
            {
                if (profanityA[_local_3] == "weebly")
                {
                }
                _local_4.index = _local_2.indexOf(((" " + profanityA[_local_3]) + " "));
                if (_local_4.index > -1)
                {
                    _local_4.term = profanityA[_local_3];
                    _local_4.code = 1;
                    return (_local_4);
                }
                _local_3++;
            }
            _local_2 = r.stripDuplicateVowels(cleanStr(_arg_1.toLowerCase()));
            _local_2 = r.stripWhiteStrict(_local_2);
            _local_3 = 0;
            while (_local_3 < profanityB.length)
            {
                _local_4.index = _local_2.indexOf(profanityB[_local_3]);
                if (_local_4.index > -1)
                {
                    _local_4.term = profanityB[_local_3];
                    _local_4.code = 2;
                    return (_local_4);
                }
                _local_3++;
            }
            _local_2 = r.stripDuplicateVowels(cleanStr(_arg_1.toLowerCase()));
            _local_2 = r.stripWhiteStrictB(_local_2);
            _local_3 = 0;
            while (_local_3 < profanityB.length)
            {
                _local_4.index = _local_2.indexOf(profanityB[_local_3]);
                if (_local_4.index > -1)
                {
                    _local_4.term = profanityB[_local_3];
                    _local_4.code = 2;
                    return (_local_4);
                }
                _local_3++;
            }
            var _local_5:Array = [];
            var _local_6:* = "";
            var _local_7:int;
            while (_local_7 < _arg_1.length)
            {
                if (legalCharsStrict.indexOf(_arg_1.charAt(_local_7)) > -1)
                {
                    if (((_local_6.length == 0) || (!(_arg_1.charAt(_local_7) == _local_6.charAt((_local_6.length - 1))))))
                    {
                        _local_6 = (_local_6 + _arg_1.charAt(_local_7));
                        _local_5.push(_local_7);
                    }
                }
                _local_7++;
            }
            _local_3 = 0;
            while (_local_3 < profanityC.length)
            {
                _local_4.index = _local_6.indexOf(profanityC[_local_3]);
                if (_local_4.index > -1)
                {
                    _local_4.code = 3;
                    _local_4.indeces.push(_local_5[_local_4.index]);
                    _local_4.indeces.push(((_local_5[_local_4.index] + profanityC[_local_3].length) - 1));
                }
                _local_3++;
            }
            return (_local_4);
        }

        public function submitMsg(msg:String, typ:*, unm:*, isMulti:Boolean=false):*
        {
            var tuo:* = undefined;
            var uName:String;
            var rmId:int;
            var tuoNm:String;
            var parta:* = undefined;
            var partb:String;
            var i:int;
            var multiO:Object;
            var strPassword:* = undefined;
            var uoData:* = undefined;
            var modal:MovieClip;
            var modalO:* = undefined;
            var strA:String;
            var ei:int;
            var xtArr:* = undefined;
            var cmd:* = undefined;
            var params:* = undefined;
            var paramStr:* = undefined;
            var s:* = undefined;
            var bAch:* = undefined;
            var uVars:* = undefined;
            var isCellOK:Boolean;
            var cell:* = undefined;
            var avt:* = undefined;
            var guildName:String;
            var strMap:String;
            var m:uint;
            var emStr:* = undefined;
            var index:int;
            var myAvatar:Avatar;
            var profanityResult:Object;
            var iDiff:Number;
            var iHrs:int;
            var iMins:int;
            if (msg == null)
            {
                return;
            }
            msg = cleanChars(msg);
            var msgOK:Boolean = true;
            var warningModal:Boolean = true;
            var strEmail:String;
            if (((Game.loginInfo != null) && (Game.loginInfo.strPassword != null) && (String(Game.loginInfo.strPassword).length > 0)))
            {
                strPassword = String(Game.loginInfo.strPassword).toLowerCase();
                if (msg.toLowerCase().indexOf(strPassword) > -1)
                {
                    msgOK = false;
                }
            }
            if (((!(r.world == null)) && (!(r.world.myAvatar == null))))
            {
                if (((r.world.myAvatar.items == null) || (r.world.myAvatar.items.length < 1)))
                {
                    msgOK = false;
                    warningModal = false;
                    pushMsg("warning", "Character is still being loaded, please wait a moment.", "SERVER", "", 0);
                }
                if (r.world.myAvatar.objData != null)
                {
                    uoData = r.world.myAvatar.objData;
                    if (uoData.strEmail != null)
                    {
                        strEmail = uoData.strEmail.toLowerCase();
                    }
                    if (((!(strEmail == null)) && (strEmail.length > 5)))
                    {
                        if (msg.toLowerCase().indexOf(strEmail) > -1)
                        {
                            msgOK = false;
                        }
                    }
                }
            }
            if (((!(msgOK)) && (warningModal)))
            {
                modal = new ModalMC();
                modalO = {};
                modalO.strBody = "Never give your password or email to anyone. Please note that AQWorlds staff will never ask for your password or email. We do not need that information to look up your account.";
                modalO.callback = null;
                modalO.btns = "mono";
                r.ui.ModalStack.addChild(modal);
                modal.init(modalO);
                strA = "";
                ei = 0;
                if (strEmail != null)
                {
                    if (msg.indexOf(strEmail) > -1)
                    {
                        ei = 0;
                        while (ei < strEmail.length)
                        {
                            strA = (strA + ((ei == 0) ? strEmail.charAt(0) : "*"));
                            ei = (ei + 1);
                        }
                        msg = msg.split(strEmail).join(strA);
                    }
                }
                ei = 0;
                strA = "";
                if (((strPassword != null) && (strPassword.length > 0) && (msg.toLowerCase().indexOf(strPassword) > -1)))
                {
                    ei = 0;
                    while (ei < strPassword.length)
                    {
                        strA = (strA + ((ei == 0) ? strPassword.charAt(0) : "*"));
                        ei = (ei + 1);
                    }
                    msg = replaceIgnoreCase(msg, strPassword, strA);
                }
                pushMsg("warning", msg, "SERVER", "", 0);
                closeMsgEntry();
                return;
            }
            i = 0;
            var str:* = r.stripWhite(msg);
            if (str.length)
            {
                xtArr = [];
                cmd = "";
                if (msg.substr(0, 1) == "/")
                {
                    params = msg.substr(1).split(" ");
                    paramStr = params[0].toLowerCase();
                    switch (paramStr)
                    {
                        case "qv":
                            if (Game.objLogin.iAccess >= 30)
                            {
                                if (isNaN(parseInt(params[1]))) break;
                                pushMsg("server", ((("QV " + params[1]) + ": ") + rootClass.world.getQuestValue(parseInt(params[1]))), "SERVER", "", 0);
                            }
                            break;
                        case "debug":
                            if (Game.objLogin.iAccess >= 30)
                            {
                                optionHandler.cmd(rootClass, "@ Debugger");
                            }
                            break;
                        case "captest":
                            if (r.world.myAvatar.isStaff())
                            {
                                r.sfc.sendString(msg.substr((msg.indexOf(" ") + 1)));
                                pushMsg("server", ("Sent " + msg.substr((msg.indexOf(" ") + 1))), "SERVER", "", 0);
                            }
                            break;
                        case "multi":
                            msg = ("/" + msg.substr(7));
                            submitMsg(msg, typ, unm, true);
                            return;
                        case "reload":
                            cmd = null;
                            if (r.world.myAvatar.isStaff())
                            {
                                r.world.reloadCurrentMap();
                            }
                            break;
                        case "cell":
                            cmd = null;
                            if (r.world.myAvatar.objData.intAccessLevel >= 40)
                            {
                                if (params.length > 1)
                                {
                                    parta = params[1];
                                }
                                else
                                {
                                    parta = "none";
                                }
                                if (params.length > 2)
                                {
                                    partb = params[2];
                                }
                                else
                                {
                                    partb = "none";
                                }
                                isCellOK = false;
                                for each (cell in r.world.map.currentScene.labels)
                                {
                                    if (cell.name == parta)
                                    {
                                        isCellOK = true;
                                        break;
                                    }
                                }
                                if (isCellOK)
                                {
                                    r.world.moveToCell(parta, partb);
                                }
                                else
                                {
                                    r.chatF.pushMsg("warning", (("Frame '" + parta) + "' does not exist."), "SERVER", "", 0);
                                }
                            }
                            break;
                        case "shop":
                            cmd = null;
                            if (r.world.myAvatar.objData.intAccessLevel >= 40)
                            {
                                if (params.length > 1)
                                {
                                    parta = int(params[1]);
                                }
                                else
                                {
                                    parta = 1;
                                }
                                r.world.sendLoadShopRequest(parta);
                            }
                            break;
                        case "sound":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                if (params[1] == "off")
                                {
                                    r.mixer.bSoundOn = false;
                                }
                                else
                                {
                                    if (params[1] == "on")
                                    {
                                        r.mixer.bSoundOn = true;
                                    }
                                }
                            }
                            break;
                        case "ignore":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (tuoNm.toLowerCase() != r.sfc.myUserName)
                                {
                                    cmd = "cmd";
                                    ignore(tuoNm);
                                    msg = ("You are now ignoring user " + tuoNm);
                                    pushMsg("server", msg, "SERVER", "", 0);
                                }
                                else
                                {
                                    msg = "You cannot ignore yourself!";
                                    pushMsg("warning", msg, "SERVER", "", 0);
                                }
                            }
                            break;
                        case "unignore":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                cmd = "cmd";
                                unignore(tuoNm);
                                msg = (("User " + tuoNm) + " is no longer being ignored");
                                pushMsg("server", msg, "SERVER", "", 0);
                            }
                            break;
                        case "ignoreclear":
                            cmd = null;
                            ignoreList.data.users = [];
                            pushMsg("warning", "Ignore List Cleared!", "SERVER", "", 0);
                            r.sfc.sendXtMessage("zm", "cmd", ["ignoreList", "$clearAll"], "str", 1);
                            break;
                        case "report":
                        case "reportlang":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                r.ui.mcPopup.fOpen("Report", {"unm":tuoNm});
                            }
                            break;
                        case "reporthack":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                parta = params.split(":")[0];
                                partb = params.split(":")[1];
                                tuoNm = parta.slice(1).join(" ");
                                cmd = "cmd";
                                xtArr.push("reporthack");
                                xtArr.push(tuoNm);
                                xtArr.push(partb);
                            }
                            break;
                        case "modon":
                        case "modoff":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "getinfo":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(tuoNm);
                            }
                            break;
                        case "size":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                        case "getroomname":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                            }
                            break;
                        case "event":
                            if (params.length > 2)
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(params.slice(2).join(" "));
                            }
                            break;
                        case "rift":
                            cmd = "cmd";
                            xtArr.push("rift");
                            xtArr.push(params.length > 1 ? params[1] : "status");
                            break;
                        case "tfer":
                            if (((((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)) && (!(typeof(params[2]) == "undefined"))) && (params[2].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(params[2]);
                            }
                            break;
                        case "guild":
                            r.world.showGuildList();
                            break;
                        case "guildInvite":
                        case "gi":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                r.world.guildInvite(tuoNm);
                            }
                            break;
                        case "guildremove":
                        case "gr":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                avt = r.world.getAvatarByUserName(tuoNm);
                                if (((r.world.myAvatar.objData.guildRank >= 2) || (avt.isMyAvatar)))
                                {
                                    modal = new ModalMC();
                                    modalO = {};
                                    modalO.strBody = (("Do you want to remove " + tuoNm) + " from the guild?");
                                    modalO.callback = r.world.guildRemove;
                                    modalO.params = {"userName":tuoNm};
                                    modalO.btns = "dual";
                                    r.ui.ModalStack.addChild(modal);
                                    modal.init(modalO);
                                }
                            }
                            break;
                        case "guildPromote":
                        case "gp":
                            cmd = null;
                            if (r.world.myAvatar.objData.guildRank >= 2)
                            {
                                if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                                {
                                    tuoNm = params.slice(1).join(" ");
                                    r.world.guildPromote(tuoNm);
                                }
                            }
                            break;
                        case "guildDemote":
                        case "gd":
                            cmd = null;
                            if (r.world.myAvatar.objData.guildRank >= 2)
                            {
                                if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                                {
                                    tuoNm = params.slice(1).join(" ");
                                    r.world.guildDemote(tuoNm);
                                }
                            }
                            break;
                        case "motd":
                            if (msg.length == 5)
                            {
                                if (r.world.myAvatar.objData.guild != null)
                                {
                                    if (((!(r.world.myAvatar.objData.guild.MOTD == null)) && (!(String(r.world.myAvatar.objData.guild.MOTD) == "undefined"))))
                                    {
                                        pushMsg("guild", ("Message of the day: " + String(r.world.myAvatar.objData.guild.MOTD)), "SERVER", "", 0);
                                    }
                                    else
                                    {
                                        pushMsg("guild", "No Message of the day has been set.", "SERVER", "", 0);
                                    }
                                }
                            }
                            else
                            {
                                r.world.setGuildMOTD(msg.substr(5));
                            }
                            break;
                        case "gc":
                        case "guildcreate":
                            if (r.world.myAvatar.isUpgraded())
                            {
                                if (params[1].length > 0)
                                {
                                    guildName = params[1];
                                    i = 2;
                                    while (i < params.length)
                                    {
                                        guildName = ((guildName + " ") + params[i]);
                                        i = (i + 1);
                                    }
                                    if (guildName.length <= 25)
                                    {
                                        modal = new ModalMC();
                                        modalO = {};
                                        modalO.strBody = (("Do you want to create the guild " + guildName) + "?");
                                        modalO.callback = r.world.createGuild;
                                        modalO.params = {"guildName":guildName};
                                        modalO.btns = "dual";
                                        r.ui.ModalStack.addChild(modal);
                                        modal.init(modalO);
                                    }
                                    else
                                    {
                                        r.chatF.pushMsg("server", "Guild names must be 25 characters or less.", "SERVER", "", 0);
                                    }
                                }
                                else
                                {
                                    r.chatF.pushMsg("server", "Please specify a name for your guild.", "SERVER", "", 0);
                                }
                            }
                            else
                            {
                                r.chatF.pushMsg("server", "Only members may create guilds.", "SERVER", "", 0);
                            }
                            break;
                        case "renameGuild":
                        case "rg":
                            if (r.world.myAvatar.objData.guildRank == 3)
                            {
                                if (r.world.myAvatar.objData.intCoins >= 1000)
                                {
                                    if (params[1].length > 0)
                                    {
                                        guildName = params[1];
                                        i = 2;
                                        while (i < params.length)
                                        {
                                            guildName = ((String(guildName) + " ") + String(params[i]));
                                            i = (i + 1);
                                        }
                                        if (guildName.length <= 25)
                                        {
                                            modal = new ModalMC();
                                            modalO = {};
                                            modalO.strBody = (("Do you want to rename the guild to " + guildName) + "? This will cost 1000 ACs.");
                                            modalO.callback = r.world.renameGuild;
                                            modalO.params = {"guildName":guildName};
                                            modalO.btns = "dual";
                                            r.ui.ModalStack.addChild(modal);
                                            modal.init(modalO);
                                        }
                                        else
                                        {
                                            r.chatF.pushMsg("server", "Guild names must be 25 characters or less.", "SERVER", "", 0);
                                        }
                                    }
                                    else
                                    {
                                        r.chatF.pushMsg("server", "Please specify a name for your guild.", "SERVER", "", 0);
                                    }
                                }
                                else
                                {
                                    r.chatF.pushMsg("server", "You do not have enough ACs.", "SERVER", "", 0);
                                }
                            }
                            break;
                        case "addquest":
                        case "removequest":
                        case "forcestart":
                        case "forcestop":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                try
                                {
                                    r.sfc.sendXtMessage("zm", "dynamic", [paramStr, params[1], params[2]], "str", 1);
                                }
                                catch(e)
                                {
                                    r.sfc.sendXtMessage("zm", "dynamic", [paramStr, params[1]], "str", 1);
                                }
                            }
                            break;
                        case "guildreset":
                            r.sfc.sendXtMessage("zm", "guild", ["guildreset"], "str", 1);
                            break;
                        case "yuki":
                            rmId = chn.cur.rid;
                            cmd = "message";
                            msg = cleanStr(msg, false, true);
                            xtArr.push(msg.substring((msg.indexOf("//yuki ") + 6), msg.length));
                            xtArr.push(chn.cur.str);
                            xtArr.push("yuki");
                            break;
                        case "ginv":
                            cmd = null;
                            s = String(params[1]);
                            i = 2;
                            while (i < params.length)
                            {
                                s = ((s + " ") + String(params[i]));
                                i = (i + 1);
                            }
                            r.sfc.sendXtMessage("zm", "guild", ["gInv", s], "str", 1);
                            break;
                        case "invite":
                        case "pi":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (((r.world.partyMembers.length < 4) || (!(r.world.isPartyMember(tuoNm)))))
                                {
                                    r.world.partyInvite(tuoNm);
                                }
                            }
                            break;
                        case "ps":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                r.world.partySummon(tuoNm);
                            }
                            break;
                        case "pk":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                r.world.doPartyKick(tuoNm);
                            }
                            break;
                        case "duel":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                r.world.sendDuelInvite(tuoNm);
                            }
                            break;
                        case "friends":
                            cmd = null;
                            r.world.showFriendsList();
                            break;
                        case "friend":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (tuoNm.toLowerCase() != r.sfc.myUserName)
                                {
                                    r.world.requestFriend(tuoNm);
                                }
                            }
                            break;
                        case "modban":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                tuoNm = params.slice(1).join(" ");
                                xtArr.push(params[0]);
                                xtArr.push(tuoNm);
                                xtArr.push(24);
                            }
                            break;
                        case "join":
                            if (((((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)) && (!(r.world.uoTree[r.sfc.myUserName].intState == 0))) && (r.world.coolDown("tfer"))))
                            {
                                r.world.returnInfo = null;
                                cmd = "cmd";
                                uName = r.sfc.myUserName;
                                strMap = params[1];
                                if (params.length > 2)
                                {
                                    m = 2;
                                    while (m < params.length)
                                    {
                                        strMap = ((strMap + " ") + params[m]);
                                        m++;
                                    }
                                }
                                xtArr.push("tfer");
                                xtArr.push(r.sfc.myUserName);
                                xtArr.push(strMap);
                            }
                            break;
                        case "roomid":
                            cmd = "cmd";
                            xtArr.push("roomID");
                            xtArr.push(r.sfc.myUserName);
                            xtArr.push(params[1]);
                            break;
                        case "house":
                            cmd = null;
                            if (params[1] == null)
                            {
                                tuoNm = r.sfc.myUserName;
                            }
                            else
                            {
                                tuoNm = params.slice(1).join(" ");
                            }
                            r.world.gotoHouse(tuoNm);
                            break;
                        case "kick":
                        case "ipkick":
                        case "ipunmute":
                        case "unmute":
                        case "freeze":
                        case "unfreeze":
                        case "watch":
                        case "unwatch":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                tuoNm = params.slice(1).join(" ");
                                xtArr.push(params[0]);
                                xtArr.push(tuoNm);
                            }
                            break;
                        case "mute":
                        case "ban":
                        case "ipmute":
                            if ((((r.world.myAvatar.isStaff()) && (!(typeof(params[1]) == "undefined"))) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                tuoNm = params.slice(2).join(" ");
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(tuoNm);
                            }
                            break;
                        case "goto":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = null;
                                r.world._SafeStr_1(params.slice(1).join(" "));
                            }
                            break;
                        case "pull":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = null;
                                r.world.pull(params.slice(1).join(" "));
                            }
                            break;
                        case "clear":
                        case "bonus":
                        case "boost":
                            if (params.length > 1)
                            {
                                cmd = "cmd";
                                i = 0;
                                while (i < params.length)
                                {
                                    xtArr.push(params[i]);
                                    i = (i + 1);
                                }
                            }
                            break;
                        case "frostreset":
                            cmd = "cmd";
                            xtArr.push("frostreset");
                            break;
                        case "queue":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "killmap":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                            }
                            break;
                        case "item":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(params[2]);
                            }
                            break;
                        case "combat":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            xtArr.push(params[1]);
                            break;
                        case "addrep":
                        case "addxp":
                        case "addv":
                        case "hp":
                        case "level":
                        case "getevents":
                        case "getevent":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                            }
                            break;
                        case "datadump":
                        case "monitor":
                        case "resetevents":
                        case "resetlogins":
                        case "resetgrove":
                        case "resettimes":
                        case "getlogins":
                        case "gettimes":
                        case "clock":
                        case "whitelist":
                            cmd = "cmd";
                            i = 0;
                            while (i < params.length)
                            {
                                xtArr.push(params[i]);
                                i = (i + 1);
                            }
                            break;
                        case "getbreakdown":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "adminyell":
                        case "iay":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                msg = params.slice(1).join(" ");
                                msg = cleanStr(msg, false, true);
                                xtArr.push(msg);
                            }
                            break;
                        case "iteratortest":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "fps":
                            r.world.toggleFPS();
                            break;
                        case "mod":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "pmoff":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            xtArr.push(msg.substr(7));
                            break;
                        case "pmon":
                        case "partyon":
                        case "partyoff":
                        case "chaton":
                        case "chatoff":
                        case "friendon":
                        case "friendoff":
                        case "waron":
                        case "waroff":
                        case "kickall":
                        case "restart":
                        case "restartnow":
                        case "shutdown":
                        case "shutdownnow":
                        case "empty":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "roll":
                            cmd = "util";
                            xtArr.push(params[0]);
                            break;
                        case "geta":
                            if (((r.world.myAvatar.isStaff()) && (params.length == 3)))
                            {
                                pushMsg("warning", ((((("geta " + params[1]) + ",") + params[2]) + ": ") + r.world.getAchievement(params[1], params[2])), "SERVER", "", 0);
                            }
                            break;
                        case "seta":
                            if (((r.world.myAvatar.isStaff()) && (params.length == 4)))
                            {
                                r.world.setAchievement(params[1], params[2], params[3]);
                            }
                            break;
                        case "queststring":
                            if (r.world.myAvatar.isStaff())
                            {
                                r.world.loadQuestStringData();
                                cmd = "cmd";
                                i = 0;
                                while (i < params.length)
                                {
                                    xtArr.push(params[i]);
                                    i = (i + 1);
                                }
                            }
                            break;
                        case "e":
                        case "me":
                        case "em":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                emStr = params.slice(1).join(" ");
                                emStr = cleanStr(emStr, false, true);
                                rmId = chn.cur.rid;
                                cmd = "em";
                                xtArr.push(emStr);
                                xtArr.push(chn.event.str);
                            }
                            break;
                        case "who":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                xtArr.push(params.splice(1).join(" "));
                            }
                            break;
                        case "afk":
                            cmd = null;
                            r.world.afkToggle();
                            break;
                        case "rest":
                            r.world.rest();
                            break;
                        case "repairavatars":
                            cmd = null;
                            r.world.repairAvatars();
                            break;
                        case "samba":
                            bAch = r.world.getAchievement("ia0", 11);
                            if (!bAch)
                            {
                                pushMsg("warning", "You must learn this dance from Samba in Bloodtusk Ravine.", "SERVER", "", 0);
                                break;
                            }
                            if (!r.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "danceweapon":
                            if (!r.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "useweapon":
                            if (!r.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "powerup":
                        case "kneel":
                        case "jumpcheer":
                        case "salute2":
                        case "cry2":
                        case "spar":
                        case "stepdance":
                        case "headbang":
                        case "dazed":
                            if (!r.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "dance":
                        case "laugh":
                        case "lol":
                        case "point":
                        case "use":
                        case "fart":
                        case "backflip":
                        case "sleep":
                        case "jump":
                        case "punt":
                        case "dance2":
                        case "swordplay":
                        case "feign":
                        case "wave":
                        case "bow":
                        case "cry":
                        case "unsheath":
                        case "cheer":
                        case "stern":
                        case "salute":
                        case "airguitar":
                        case "facepalm":
                            uVars = {};
                            cmd = (uVars.typ = "emotea");
                            uVars.strEmote = paramStr;
                            if (uVars.strEmote == "lol")
                            {
                                uVars.strEmote = "laugh";
                            }
                            uVars.strChar = params[1];
                            break;
                        default:
                            if (((unm == "iterator") || (r.world.myAvatar.isStaff())))
                            {
                                cmd = "cmd";
                                index = 0;
                                while (index < params.length)
                                {
                                    xtArr.push(params[index]);
                                    index = (index + 1);
                                }
                            }
                    }
                    if (!r.serialCmdMode)
                    {
                        if (cmdHistory.indexOf(msg) == -1)
                        {
                            cmdHistory.push(msg);
                            if (cmdHistory.length > 10)
                            {
                                cmdHistory.shift();
                            }
                            rebuildHistory();
                        }
                    }
                }
                else
                {
                    if (typ != "whisper")
                    {
                        rmId = chn.cur.rid;
                        cmd = "message";
                        msg = cleanStr(msg, false, true);
                        xtArr.push(msg);
                        xtArr.push(chn.cur.str);
                    }
                    else
                    {
                        rmId = 1;
                        cmd = "whisper";
                        msg = cleanStr(msg, false, true);
                        xtArr.push(msg);
                        xtArr.push(unm);
                    }
                }
                if (cmd == "emotea")
                {
                    r.world.myAvatar.pMC.mcChar.gotoAndPlay(r.strToProperCase(uVars.strEmote));
                    r.sfc.sendXtMessage("zm", cmd, [uVars.strEmote], "str", 1);
                }
                else
                {
                    if (((cmd == "mod") || (cmd == "cmd")))
                    {
                        if (xtArr.length)
                        {
                            r.sfc.sendXtMessage("zm", cmd, xtArr, "str", 1);
                        }
                    }
                    else
                    {
                        if (cmd != "simple")
                        {
                            if (!((cmd == null) || (xtArr.length < 1)))
                            {
                                if (!r.serialCmdMode)
                                {
                                    r.world.afkPostpone();
                                    myAvatar = r.world.myAvatar;
                                    profanityResult = {};
                                    profanityResult = nuProfanityCheck(cleanStr(xtArr[0]));
                                    if (iChat == 0)
                                    {
                                        pushMsg("warning", "This server only allows canned chat.", "SERVER", "", 0);
                                    }
                                    else
                                    {
                                        if (((((iChat == 1) && (!(r.world.myAvatar.hasUpgraded()))) && (!(r.world.myAvatar.isVerified()))) && (!(r.world.myAvatar.isStaff()))))
                                        {
                                            pushMsg("warning", "Chat is a members-only feature at this time.", "SERVER", "", 0);
                                        }
                                        else
                                        {
                                            if (((((!(r.world.myAvatar.hasUpgraded())) && (!(r.world.myAvatar.isVerified()))) && (!(r.world.myAvatar.isStaff()))) && (!(r.world.myAvatar.isEmailVerified()))))
                                            {
                                                if (int(r.world.myAvatar.objData.iAge) < 13)
                                                {
                                                    pushMsg("warning", "Upgrade is required to chat in this server.", "SERVER", "", 0);
                                                }
                                                else
                                                {
                                                    pushMsg("warning", "Confirm your email at https://nightvaults.com/ to protect your account and enable chat.", "SERVER", "", 0);
                                                }
                                            }
                                            else
                                            {
                                                if (myAvatar.objData.bPermaMute == 1)
                                                {
                                                    pushMsg("warning", "You are mute! Chat privileges have been permanently revoked.", "SERVER", "", 0);
                                                }
                                                else
                                                {
                                                    if (((!(myAvatar.objData.dMutedTill == null)) && (myAvatar.objData.dMutedTill.getTime() > r.date_server.getTime())))
                                                    {
                                                        iDiff = ((myAvatar.objData.dMutedTill.getTime() - r.date_server.getTime()) / 1000);
                                                        iHrs = int((iDiff / (60 * 60)));
                                                        iMins = int(((iDiff - ((iHrs * 60) * 60)) / 60));
                                                        pushMsg("warning", (((("You are mute! Chat privileges have been revoked for next " + iHrs) + " h ") + iMins) + " m!"), "SERVER", "", 0);
                                                    }
                                                    else
                                                    {
                                                        if (isUnsendable(msg))
                                                        {
                                                            pushMsg("warning", "Please do not send messages that may contain private information, such as an email address.", "SERVER", "", 0);
                                                        }
                                                        else
                                                        {
                                                            if (xtArr[0].length > 0)
                                                            {
                                                                if (((profanityResult.code) && (rootClass.uoPref.bProf)))
                                                                {
                                                                    xtArr[0] = maskStringBetween(xtArr[0], profanityResult.indeces);
                                                                }
                                                                if (!rootClass.uoPref.bProf)
                                                                {
                                                                    profanityResult = nuProfanityCheck(cleanStr(xtArr[0]), true);
                                                                    if (profanityResult.code)
                                                                    {
                                                                        xtArr[0] = maskStringBetween(xtArr[0], profanityResult.indeces);
                                                                    }
                                                                }
                                                                xtArr[0] = forceRemove(xtArr[0]);
                                                                r.sfc.sendXtMessage("zm", cmd, xtArr, "str", rmId);
                                                                if (((cmd == "whisper") && (!(pmMode == 2))))
                                                                {
                                                                    formatMsgEntry("");
                                                                    updateMsgEntry();
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    r.sfc.sendXtMessage("zm", cmd, xtArr, "str", rmId);
                                }
                            }
                        }
                    }
                }
            }
            if (!r.serialCmdMode)
            {
                closeMsgEntry();
            }
        }

        public function isIgnored(_arg_1:String):Boolean
        {
            return (ignoreList.data.users.indexOf(_arg_1.toLowerCase()) >= 0);
        }

        public function ignore(strName:String):void
        {
            var mc:* = undefined;
            if (ignoreList.data.users.indexOf(strName.toLowerCase()) == -1)
            {
                ignoreList.data.users.push(strName.toLowerCase());
                try
                {
                    ignoreList.flush();
                }
                catch(e:Error)
                {
                }
                mc = rootClass.world.getAvatarByUserName(strName.toLowerCase());
                if (mc != null)
                {
                    mc.pMC.ignore.visible = true;
                }
                rootClass.sfc.sendXtMessage("zm", "cmd", ["ignoreList", ignoreList.data.users], "str", 1);
            }
            try
            {
                if (rootClass.ui.mcOFrame.fData.typ == "userListIgnore")
                {
                    rootClass.ui.mcOFrame.update();
                }
            }
            catch(e:Error)
            {
            }
        }

        public function unignore(strName:String):void
        {
            var uind:* = ignoreList.data.users.indexOf(strName.toLowerCase());
            while (uind > -1)
            {
                ignoreList.data.users.splice(uind, 1);
                uind = ignoreList.data.users.indexOf(strName.toLowerCase());
            }
            try
            {
                ignoreList.flush();
            }
            catch(e:Error)
            {
            }
            var mc:* = rootClass.world.getAvatarByUserName(strName.toLowerCase());
            if (mc != null)
            {
                mc.pMC.ignore.visible = false;
            }
            rootClass.sfc.sendXtMessage("zm", "cmd", ["ignoreList", ignoreList.data.users], "str", 1);
            try
            {
                if (rootClass.ui.mcOFrame.fData.typ == "userListIgnore")
                {
                    rootClass.ui.mcOFrame.update();
                }
            }
            catch(e:Error)
            {
            }
        }

        public function muteMe(_arg_1:int):void
        {
            var _local_2:Date = new Date();
            mute.ts = Number(_local_2.getTime());
            mute.cd = _arg_1;
            mute.timer.delay = _arg_1;
            mute.timer.start();
            pushMsg("warning", "You have been muted! Chat privileges are temporarily revoked.", "SERVER", "", 0);
        }

        public function unmuteMe(_arg_1:Event=null):void
        {
            mute.ts = 0;
            mute.cd = 0;
            mute.timer.reset();
            pushMsg("server", "You have been unmuted.  Chat privileges are restored.", "SERVER", "", 0);
        }

        public function amIMute():Boolean
        {
            var _local_2:Date;
            var _local_3:Number;
            var _local_1:Boolean;
            if (mute.ts > 0)
            {
                _local_2 = new Date();
                _local_3 = _local_2.getTime();
                if ((_local_3 - mute.ts) >= mute.cd)
                {
                    mute.ts = 0;
                    mute.cd = 0;
                }
                else
                {
                    _local_1 = true;
                }
            }
            return (_local_1);
        }

        public function cleanChars(_arg_1:String):String
        {
            _arg_1 = _arg_1.replace(regExpMod, "");
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                if (legalChars.indexOf(_arg_1.charAt(_local_2)) < 0)
                {
                    _arg_1 = _arg_1.replace(_arg_1.charAt(_local_2), "?");
                }
                _local_2++;
            }
            return (_arg_1);
        }

        public function strContains(_arg_1:String, _arg_2:Array):Boolean
        {
            var _local_3:int;
            while (_local_3 < _arg_2.length)
            {
                if (_arg_1.indexOf(_arg_2[_local_3]) > -1)
                {
                    return (true);
                }
                _local_3++;
            }
            return (false);
        }

        public function cleanStr(_arg_1:String, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:Boolean=false):*
        {
            _arg_1 = _arg_1.split("&#").join("");
            if (!_arg_4)
            {
                _arg_1 = _arg_1.split("#038:").join("");
            }
            else
            {
                _arg_1 = _arg_1.split("#038:#").join("");
            }
            if (_arg_3)
            {
                _arg_1 = removeHTML(_arg_1);
            }
            if (_arg_1.indexOf("%") > -1)
            {
                _arg_1 = _arg_1.split("%").join("#037:");
            }
            if (((_arg_2) && (_arg_1.indexOf("#037:") > -1)))
            {
                _arg_1 = _arg_1.split("#037:").join("%");
            }
            if (_arg_1.indexOf("&") > -1)
            {
                _arg_1 = _arg_1.split("&").join("#038:");
            }
            if (((_arg_2) && (_arg_1.indexOf("#038:") > -1)))
            {
                _arg_1 = _arg_1.split("#038:").join("&");
            }
            if (_arg_1.indexOf("<") > -1)
            {
                _arg_1 = _arg_1.split("<").join("#060:");
            }
            if (((_arg_2) && (_arg_1.indexOf("#060:") > -1)))
            {
                _arg_1 = _arg_1.split("#060:").join("<");
            }
            if (_arg_1.indexOf(">") > -1)
            {
                _arg_1 = _arg_1.split(">").join("#062:");
            }
            if (((_arg_2) && (_arg_1.indexOf("#062:") > -1)))
            {
                _arg_1 = _arg_1.split("#062:").join(">");
            }
            if (_arg_2)
            {
                _arg_1 = removeHTML(_arg_1);
            }
            return (_arg_1);
        }

        private function removeHTML(_arg_1:String):String
        {
            var _local_5:int;
            var _local_6:String;
            var _local_2:String = _arg_1.toLowerCase();
            var _local_3:String = ("" + _arg_1);
            var _local_4:Array = ["&nbsp;", "<br>"];
            for each (_local_6 in _local_4)
            {
                while (_local_2.indexOf(_local_6) > -1)
                {
                    _local_5 = _local_2.indexOf(_local_6);
                    _local_2 = ((_local_2.substr(0, _local_5) + " ") + _local_2.substr((_local_5 + _local_6.length), _local_2.length));
                    _local_3 = ((_local_3.substr(0, _local_5) + " ") + _local_3.substr((_local_5 + _local_6.length), _local_3.length));
                }
            }
            return (_local_3);
        }

        public function isUnsendable(_arg_1:String):Boolean
        {
            var _local_2:* = 0;
            while (_local_2 < unsendable.length)
            {
                if (_arg_1.toLowerCase().indexOf(unsendable[_local_2]) > -1)
                {
                    return (true);
                }
                _local_2++;
            }
            return (false);
        }

        private function getRoomType(_arg_1:*):*
        {
            if (_arg_1.indexOf("trade") > -1)
            {
                return ("trade");
            }
            if (_arg_1.indexOf("party") > -1)
            {
                return ("party");
            }
            return ("zone");
        }

        public function modWhisperCheck(_arg_1:String):int
        {
            var _local_3:String;
            var _local_2:String = rootClass.stripWhiteStrict(removeHTML(_arg_1.toLowerCase()));
            for each (_local_3 in modWhisperCheckList)
            {
                if (_local_2.indexOf(_local_3) > -1)
                {
                    return (1);
                }
            }
            return (0);
        }

        public function isChannel(_arg_1:String):Boolean
        {
            var _local_2:*;
            if (_arg_1 == null)
            {
                return (false);
            }
            for (_local_2 in chn)
            {
                if (_local_2.toLowerCase() == _arg_1.toLowerCase())
                {
                    return (true);
                }
            }
            return (false);
        }

        public function formatMsgEntry(_arg_1:*):*
        {
            mci.ncText.setSelection(0, 0);
            if (chn.cur != chn.whisper)
            {
                if (chn.cur == chn.zone)
                {
                    mci.ncPrefix.text = "Chat:";
                }
                else
                {
                    mci.ncPrefix.text = (chn.cur.tag + ": ");
                }
            }
            else
            {
                if (((typeof(_arg_1) == "undefined") || (_arg_1 == "")))
                {
                    mci.ncPrefix.text = "Chat:";
                }
                else
                {
                    pmNm = _arg_1;
                    mci.ncPrefix.text = (("To " + _arg_1) + ":");
                }
            }
        }

        public function updateMsgEntry():*
        {
            mci.ncPrefix.width = (mci.ncPrefix.textWidth + 1);
            mci.ncText.x = ((mci.ncPrefix.x + mci.ncPrefix.textWidth) + ((mci.ncPrefix.text.length) ? 1 : 0));
            mci.ncText.width = ((mci.bsend.x - mci.ncText.x) - 3);
        }

        internal function openPMsg(_arg_1:*):*
        {
            pmNm = _arg_1;
            chn.cur = chn.whisper;
            openMsgEntry();
        }

        internal function openMsgEntry():*
        {
            pmI = 0;
            myMsgsI = 0;
            rootClass.stage.focus = null;
            rootClass.stage.focus = mci.ncText;
            formatMsgEntry(pmNm);
            updateMsgEntry();
        }

        internal function closeMsgEntry():*
        {
            mci.ncText.text = "";
            if (pmMode != 2)
            {
                chn.cur = chn.lastPublic;
            }
            rootClass.stage.focus = null;
        }

        private function checkMsgType(_arg_1:Event):*
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_2:* = mci.ncText.text;
            var _local_3:* = _local_2.split(" ");
            if (_local_3.length > 1)
            {
                _local_4 = _local_3[0];
                _local_5 = "";
                if (_local_4.charAt(0) == "/")
                {
                    switch (_local_4.substr(1))
                    {
                        case "1":
                        case "s":
                        case "say":
                            if (chn.zone.act)
                            {
                                chn.cur = chn.zone;
                                chn.lastPublic = chn.zone;
                                mci.ncText.text = mci.ncText.text.substr((_local_4.substr(1).length + 2));
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "2":
                            if (chn.trade.act)
                            {
                                chn.cur = chn.trade;
                                chn.lastPublic = chn.trade;
                                mci.ncText.text = mci.ncText.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "p":
                            if (chn.party.act)
                            {
                                chn.cur = chn.party;
                                chn.lastPublic = chn.party;
                                mci.ncText.text = mci.ncText.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "r":
                            if (pmSourceA.length)
                            {
                                pmMode = 1;
                                chn.cur = chn.whisper;
                                mci.ncText.text = mci.ncText.text.substr(3);
                                formatMsgEntry(pmSourceA[0]);
                                updateMsgEntry();
                            }
                            break;
                        case "tell":
                        case "w":
                            if (_local_3.length > 2)
                            {
                                pmMode = 1;
                                chn.cur = chn.whisper;
                                mci.ncText.text = mci.ncText.text.substr(((_local_3[0].length + _local_3[1].length) + 1));
                                formatMsgEntry(_local_3[1]);
                                updateMsgEntry();
                            }
                            break;
                        case "c":
                            pmMode = 2;
                            chn.cur = chn.whisper;
                            mci.ncText.text = mci.ncText.text.substr(((_local_3[0].length + _local_3[1].length) + 1));
                            formatMsgEntry(pmSourceA[0]);
                            updateMsgEntry();
                            break;
                        case "g":
                            if (chn.guild.act)
                            {
                                chn.cur = chn.guild;
                                chn.lastPublic = chn.guild;
                                mci.ncText.text = mci.ncText.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                    }
                }
                if (_local_4.charAt(0) == ">")
                {
                    if (pmSourceA.length)
                    {
                        pmMode = 1;
                        chn.cur = chn.whisper;
                        mci.ncText.text = mci.ncText.text.substr(2);
                        formatMsgEntry(pmSourceA[0]);
                        updateMsgEntry();
                    }
                }
                _local_6 = [];
                if (((_local_2.indexOf(" > ") > 1) && ((_local_2.indexOf("<") == -1) || (_local_2.indexOf(" > ") < _local_2.indexOf("<")))))
                {
                    _local_7 = _local_2.split(">");
                    while (_local_7[0].charAt((_local_7[0].length - 1)) == " ")
                    {
                        _local_7[0] = _local_7[0].substr(0, (_local_7[0].length - 1));
                    }
                    pmMode = 1;
                    chn.cur = chn.whisper;
                    mci.ncText.text = _local_7[1];
                    formatMsgEntry(_local_7[0]);
                    updateMsgEntry();
                }
            }
        }


    }
}//package 

// _SafeStr_1 = "goto" (String#4022)


