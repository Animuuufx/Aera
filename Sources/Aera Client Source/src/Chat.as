// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Chat

package 
{
    import flash.display.MovieClip;
    import flash.net.SharedObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.filters.BevelFilter;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.events.TextEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import liteAssets.handlers.optionHandler;
    import flash.display.DisplayObject;
    import flash.text.TextField;
    import flash.geom.Rectangle;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.display.DisplayObjectContainer;
    import flash.text.*;

    public class Chat 
    {

        public var rootClass:*;
        public var iChat:int = 0;
        internal var pmMode:* = 0;
        private var chatArray:Array = [];
        private var t1Arr:* = [];
        private var t2Arr:* = [];
        private var tl:MovieClip;
        private var silentMute:* = 0;
        private var lineLimit:int = 100;
        private var mci:MovieClip;
        public var pmSourceA:* = [];
        public var pmI:int = 0;
        public var pmNm:String = "";
        public var ignoreList:SharedObject = SharedObject.getLocal("ignoreList", "/");
        public var mute:* = {
            "ts":0,
            "cd":0,
            "timer":new Timer(0, 1)
        };
        public var myMsgs:* = [];
        public var myMsgsI:int = 0;
        public var chn:* = new Object();
        public var emailWarning:String = "WARNING: Never give your email or password to anyone else. Moderators have gold names. If a player does not have a gold name they are NOT a moderator or staff member.";
        public var legalChars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*_+-=:\"?,./;'\\|<>() ";
        public var legalCharsStrict:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        public var markChars:* = "~!@#$%^&*()_+-=:\"<>?,.;'\\";
        public var strictComparisonChars:* = "~!@#$%^&*()_+-=:\"<>?,.;'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
        public var strictComparisonCharsB:* = "~!#%^&()_+-=:\"<>?,.;'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
        public var illegalStrings:* = ["&#", "www", "http", "https", "ftp", ".com", ".c0m", ".net", ".org", ".de", ".ru", ".sg", ".ph", ".tk", "dotcom", "freegold", "freecoins", "freeadventurecoins", "freelevels", "freeitems", "freeupgrades", "gmail", "yahoo", "hotmail", "aol", "formfacil", "email", "password"];
        public var modWhisperCheckList:Array = ["trade", "free", "acs", "member", "pass", "login", "user", "imamod", "iamamod", "i'mamod", "account"];
        public var regExpA:RegExp = /(a{2,})/gi;
        public var regExpE:RegExp = /(e{2,})/gi;
        public var regExpI:RegExp = /(i{2,})/gi;
        public var regExpO:RegExp = /(o{2,})/gi;
        public var regExpU:RegExp = /(u{2,})/gi;
        public var regExpSPACE:RegExp = /(\s{2,})/gi;
        internal var regExpMod:RegExp = /(\(|<)mod(era(t|d)or)?(>|\))/gi;
        public var regExpURL:RegExp = new RegExp("\\bhttps?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]", "i");
        public var unsendable:* = ["@"];
        private var whichField:* = 0;
        private var msgFields:* = ["t1:", "t2:say,zone,trade,moderator"];
        private var drawnA:Array = [];
        private var tfHeight:int = 126;
        private var t1Shorty:int = -137;
        private var t1Tally:int = -378;
        private var tfdH:int = Math.abs((t1Tally - t1Shorty));
        public var panelIndex:int = 0;
        private var msgID:int = 0;
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
        private var profanityA:Array = new Array("@$$", "&&##", "anal", "arse", "ass", "a55", "a5s", "as5", "a$$", "a$s", "as$", "a5$", "a$5", "a*s", "*ss", "a**", "as*", "assclown", "assface", "asshole", "asswipe", "bastard", "beating the meat", "beef curtains", "beef flaps", "betch", "biatch", "bich", "bish", "b1ch", "b!ch", "blch", "b|ch", "bitch", "b1tch", "b!tch", "bltch", "b|tch", "bizzach", "blowjob", "boobies", "boobs", "b00bs", "buggery", "bullshit", "buttsex", "carpet muncher", "carpet munchers", "carpetlicker", "carpetlickers", "ch1nk", "chink", "chode", "clit", "cocaine", "cock", "cocks", "c0ck", "co*k", "c*ck", "cocksucker", "condom", "cracka", "cum", "cumming", "cums", "cummies", "cumguzzler", "cumlicker", "cuck", "cumsucker", "cumdrinker", "cunt", "cunts", "c*nt", "cu*t", "*unt", "cun*", "cumslut", "dicksucker", "damn", "d1ck", "dick", "di*k", "d*ck", "d**k", "d|ck", "dildo", "d1ldo", "dumbass", "dumb4ss", "dyke", "ejaculate", "f*ck", "feck", "f@g", "fag", "f4ggot", "f4gg0t", "faggot", "fap", "f4p", "fapping", "f4pping", "fatass", "fack", "feck", "felcher", "foreskin", "fhuck", "fking", "fuk", "fck", "fuck", "fuc", "fu*k", "fuuck", "fuuk", "fcuk", "fvck", "fvk", "fvvck", "fvvk", "fock", "fux0r", "fucken", "fucker", "fucking", "fudgepacker", "ganja", "gook", "h0r", "h*re", "hentai", "heroin", "h0mo", "h0m0", "homo", "horny", "injun", "jack off", "jerk off", "jackass", "j1sm", "jism", "j1zz", "jizz", "kawk", "kike", "klootzak", "knulle", "kraut", "kuk", "kunt", "kuksuger", "kurac", "kurwa", "kusi", "kyrpa", "l3+ch", "lesbo", "lez", "marijuana", "masturbate", "masturbation", "meat puppet", "merd", "milf", "molester", "m0lester", "m0l3ster", "m0l3st3r", "motherfucker", "muie", "mulkku", "nads", "nazi", "n1gga", "nigga", "nigger", "nutsack", "orospu", "orgasm", "orgy", "p0rn", "paska", "penis", "phuck", "pierdol", "pillu", "pimmel", "pimp", "piss", "poontsee", "porn", "p0rno", "p0rn0", "porno", "pr0n", "preteen", "pron", "prostitute", "pussy", "pussie", "pu$$y", "puta", "puto", "queef", "r4pe", "rape", "r4ped", "raped", "rapist", "retard", "rimjob", "schaffer", "schiess", "schlampe", "screw", "scrotum", "secks", "s3x", "sex", "s*x", "se*", "sharmuta", "sharmute", "shipal", "shit", "sh1t", "sh!t", "shlt", "sh|t", "shiz", "sh1z", "sh!z", "shlz", "sh|z", "shiit", "shi!t", "sh!it", "shilt", "shlit", "sh||t", "shi|t", "sh|it", "shiiz", "shi t", "shyt", "sh*t", "s*it", "s**t", "s***", "shlong", "skank", "skurwysyn", "slut", "sl*t", "s**t", "smartass", "smut", "spierdalaj", "splooge", "threesome", "tit", "tits", "titties", "twat", "vagina", "wank", "weed", "wetback", "whack off", "wh0re", "whore", "whoring", "wichser", "yolasite", "zabourah", "yolas1te", "y0lasite", "y0las1te", "webly", "w33bly", "web1y", "w33b1y", "anus", "4nus", "rectum", "r3ctum", "foda", "fodao", "phoda", "phodao", "Azzhole", "A$$hole", "AsshoIe", "Azzhole", "Asswipe", "Btch", "B!tch", "BItch", "BItch", "D!ck", "Dlck", "D!ldo", "Dumbass", "Dyke", "Fgt", "Faggot", "Fagget", "Fegget", "Feggit", "Feget", "Fggot", "Fggt", "Fhaggot", "F4g", "Fken", "Fkking", "fu/ck", "H#mo", "Nigga", "N|gger", "Niga", "Ngga", "Pen1s", "Rape", "Rhape", "Raep", "Buceta", "Xoxota", "Cachorra", "Cagada", "puta", "Foda-se", "Macaco", "Negrinho", "Merda", "Porra", "Merdimbuca", "Mijada", "Mijão", "Ninfeta", "Sapatao", "Cagada", "Cerote", "Chichis", "Cojer", "Cojido", "Culera", "Culero", "Culona", "Joto", "Mamahuevo", "Maricon", "Mierda", "Nachas", "Nalgas", "Nalgona", "Pendeja", "Pendejo", "Perra", "Pito", "Puta", "Puto", "Putas", "Retardado", "Tetas", "Verga", "Vergisima");
        private var profanityB:Array = ["porn", "nigger", "slut", "dick"];
        private var profanityD:Array = ["chink", "puto", "puta", "oten"];
        private var profanityF:Array = ["nigga", "nigger", "cunt", "fag", "tranny", "shemale", "kontol", "vagina", "penis", "clitoris", "kike", "slut", "dick"];
        private var profanityC:Array = ["bitch", "b1tch", "b!tch", "bltch", "b|tch", "damn", "dick", "fag", "fuk", "fvk", "fvck", "fuck", "pussy", "shit", "sh1t", "sh!t", "shlt", "sh|t"];
        private var mcCannedChat:MovieClip;
        public var t:Timer = new Timer(500, 1);
        public var windowTimer:Timer = new Timer(60000, 1);
        public var regExpMultiG:RegExp = /(gg{2,})/gi;
        internal var regexEscapes:String = "[]{}()*+?|^$.\\";

        public function Chat()
        {
            chn.world = {
                col: "00FFFF",
                str: "world",
                typ: "world",
                tag: "World",
                rid: 0,
                act: 1
            }

            chn.cur = {};
            chn.lastPublic = {};
            chn.xt = "zm";
            chn.zone = {};
            chn.trade = {};
            chn.moderator = {};
            chn.admin = {};
            chn.administrator = {};
            chn.gm = {};
            chn.warning = {};
            chn.server = {};
            chn.event = {};
            chn.whisper = {};
            chn.party = {};
            chn.guild = {};
            chn.wheel = {};
            chn.zone.col = "9CCAFD";
            chn.trade.col = "D2FD94";
            chn.moderator.col = "FFCC33";
            chn.admin.col = "00BFFF";
            chn.administrator.col = "00BFFF";
            chn.gm.col = "FF1493";
            chn.warning.col = "A80000";
            chn.server.col = "00FFFF";
            chn.event.col = "00FF00";
            chn.whisper.col = "FF00FF";
            chn.party.col = "00CCFF";
            chn.guild.col = "99FF00";
            chn.wheel.col = "FFCC33";
            chn.zone.str = "zone";
            chn.trade.str = "trade";
            chn.moderator.str = "moderator";
            chn.admin.str = "admin";
            chn.administrator.str = "administrator";
            chn.gm.str = "gm";
            chn.warning.str = "warning";
            chn.server.str = "server";
            chn.event.str = "event";
            chn.whisper.str = "whisper";
            chn.party.str = "party";
            chn.guild.str = "guild";
            chn.wheel.str = "wheel";
            chn.zone.typ = "message";
            chn.trade.typ = "message";
            chn.moderator.typ = "whisper";
            chn.admin.typ = "message";
            chn.administrator.typ = "message";
            chn.gm.typ = "message";
            chn.warning.typ = "server";
            chn.server.typ = "server";
            chn.event.typ = "event";
            chn.whisper.typ = "whisper";
            chn.party.typ = "message";
            chn.guild.typ = "message";
            chn.wheel.typ = "whisper";
            chn.zone.tag = "";
            chn.trade.tag = "";
            chn.moderator.tag = "Moderator";
            chn.admin.tag = "Administrator";
            chn.administrator.tag = "Administrator";
            chn.gm.tag = "GameMaster";
            chn.warning.tag = "";
            chn.server.tag = "";
            chn.whisper.tag = "Whisper";
            chn.event.tag = "";
            chn.party.tag = "Party";
            chn.guild.tag = "Guild";
            chn.wheel.tag = "Wheel of Doom";
            chn.zone.rid = 0;
            chn.trade.rid = 0;
            chn.moderator.rid = 0;
            chn.admin.rid = 0;
            chn.administrator.rid = 0;
            chn.gm.rid = 0;
            chn.warning.rid = 0;
            chn.server.rid = 0;
            chn.event.rid = 0;
            chn.whisper.rid = 0;
            chn.party.rid = 32123;
            chn.guild.rid = 0;
            chn.wheel.rid = 0;
            chn.zone.act = 1;
            chn.trade.act = 0;
            chn.moderator.act = 1;
            chn.admin.act = 1;
            chn.administrator.act = 1;
            chn.gm.act = 1;
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
                ignoreList.data.users = new Array();
            }
        }

        private function initProfanity():void
        {
            var _local_4:String;
            var _local_1:Array = new Array("butt", "pron", "rape", "tits", "shi t", "shi t");
            var _local_2:Array = new Array("as5", "a5s", "a$$", "a5$", "a$5", "as$", "fck", "fkc", "fvk", "fuck", "fvck", "fukk", "fvkk", "sh!t", "sh|t", "sh1t", "shiz");
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

        internal function init():*
        {
            mci = rootClass.ui.mcInterface;
            chatArray = [];
            t1Arr = [];
            drawnA = [];
            msgID = 0;
            panelIndex = 0;
            tfHeight = 126;
            t1Shorty = -137;
            t1Tally = -378;
            tfdH = Math.abs((t1Tally - t1Shorty));
            initProfanity();
            mute.timer.addEventListener(TimerEvent.TIMER, unmuteMe, false, 0, true);
            if (mcCannedChat == null)
            {
                mcCannedChat = initCannedChat(xmlCannedOptions.children());
            }
            mci.tt.mouseEnabled = false;
            tl = (mci.textLine as MovieClip);
            tl.ti.htmlText = "";
            tl.ti.autoSize = "left";
            tl.visible = false;
            mci.bMinMax.buttonMode = true;
            mci.bMinMax.a2.visible = false;
            mci.bShortTall.buttonMode = true;
            mci.bShortTall.a2.visible = false;
            mci.te.text = "";
            mci.te.visible = false;
            mci.tt.text = "";
            mci.tt.visible = false;
            mci.te.maxChars = 150;
            mci.bCannedChat.removeEventListener(MouseEvent.CLICK, onCannedChatClick);
            mci.bsend.removeEventListener(MouseEvent.CLICK, chat_btnSend);
            mci.tebg.removeEventListener(MouseEvent.CLICK, chat_tebgClick);
            mci.bMinMax.removeEventListener(MouseEvent.CLICK, bMinMaxClick);
            mci.bMinMax.removeEventListener(MouseEvent.MOUSE_OVER, bMinMaxMouseOver);
            mci.bMinMax.removeEventListener(MouseEvent.MOUSE_OUT, bMinMaxMouseOut);
            mci.bShortTall.removeEventListener(MouseEvent.CLICK, bShortTallClick);
            mci.bShortTall.removeEventListener(MouseEvent.MOUSE_OVER, bShortTallMouseOver);
            mci.bShortTall.removeEventListener(MouseEvent.MOUSE_OUT, bShortTallMouseOut);
            rootClass.stage.removeEventListener(KeyboardEvent.KEY_DOWN, rootClass.key_StageLogin);
            rootClass.stage.removeEventListener(KeyboardEvent.KEY_DOWN, rootClass.key_StageGame);
            mci.te.removeEventListener(KeyboardEvent.KEY_DOWN, rootClass.key_ChatEntry);
            mci.te.removeEventListener(Event.CHANGE, checkMsgType);
            rootClass.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
            mcCannedChat.removeEventListener(MouseEvent.MOUSE_OVER, onCannedChatOver);
            mcCannedChat.removeEventListener(MouseEvent.MOUSE_OUT, onCannedChatOut);
            t.removeEventListener(TimerEvent.TIMER, closeCannedChatTimer);
            windowTimer.removeEventListener(TimerEvent.TIMER, timedWindowHide);
            mci.bCannedChat.addEventListener(MouseEvent.CLICK, onCannedChatClick);
            mci.bsend.addEventListener(MouseEvent.CLICK, chat_btnSend);
            mci.tebg.addEventListener(MouseEvent.CLICK, chat_tebgClick);
            mci.bMinMax.addEventListener(MouseEvent.CLICK, bMinMaxClick);
            mci.bMinMax.addEventListener(MouseEvent.MOUSE_OVER, bMinMaxMouseOver);
            mci.bMinMax.addEventListener(MouseEvent.MOUSE_OUT, bMinMaxMouseOut);
            mci.bShortTall.addEventListener(MouseEvent.CLICK, bShortTallClick);
            mci.bShortTall.addEventListener(MouseEvent.MOUSE_OVER, bShortTallMouseOver);
            mci.bShortTall.addEventListener(MouseEvent.MOUSE_OUT, bShortTallMouseOut);
            rootClass.stage.addEventListener(KeyboardEvent.KEY_DOWN, rootClass.key_StageGame);
            mci.te.addEventListener(KeyboardEvent.KEY_DOWN, rootClass.key_ChatEntry);
            mci.te.addEventListener(Event.CHANGE, checkMsgType);
            rootClass.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
            rootClass.ui.mouseEnabled = false;
            mci.mouseEnabled = false;
            mci.t1.mouseEnabled = false;
            mci.addChild(mcCannedChat);
            mcCannedChat.addEventListener(MouseEvent.MOUSE_OVER, onCannedChatOver);
            mcCannedChat.addEventListener(MouseEvent.MOUSE_OUT, onCannedChatOut);
            mcCannedChat.y = (-(mcCannedChat.numChildren) * 23);
            mcCannedChat.visible = false;
            t.addEventListener(TimerEvent.TIMER, closeCannedChatTimer);
            windowTimer.addEventListener(TimerEvent.TIMER, timedWindowHide);
        }

        private function timedWindowHide(_arg_1:Event):void
        {
            mci.t1.visible = false;
        }

        private function startWindowTimer():void
        {
            var _local_1:MovieClip = mci.bMinMax;
            if (!mci.t1.visible)
            {
            }
        }

        private function bMinMaxMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (!mci.t1.visible)
            {
                rootClass.ui.ToolTip.openWith({"str":"Show the chat pane"});
            }
            else
            {
                rootClass.ui.ToolTip.openWith({"str":"Hide the chat pane"});
            }
        }

        private function bMinMaxMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            rootClass.closeToolTip();
        }

        private function bMinMaxClick(_arg_1:MouseEvent):void
        {
            toggleChatPane();
        }

        public function toggleChatPane(_arg_1:Boolean=true):*
        {
            var _local_2:MovieClip = mci.bMinMax;
            if (!mci.t1.visible)
            {
                mci.t1.visible = true;
                _local_2.a1.visible = true;
                _local_2.a2.visible = false;
                if (_arg_1)
                {
                    rootClass.ui.ToolTip.openWith({"str":"Hide the chat pane"});
                }
            }
            else
            {
                mci.t1.visible = false;
                _local_2.a1.visible = false;
                _local_2.a2.visible = true;
                if (_arg_1)
                {
                    rootClass.ui.ToolTip.openWith({"str":"Show the chat pane"});
                }
            }
        }

        private function bShortTallMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (mci.t1.y == t1Shorty)
            {
                rootClass.ui.ToolTip.openWith({"str":"Set the chat pane to full height"});
            }
            else
            {
                rootClass.ui.ToolTip.openWith({"str":"Return the chat pane to normal height"});
            }
        }

        private function bShortTallMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            rootClass.closeToolTip();
        }

        public function bShortTallClick(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = mci.bShortTall;
            if (mci.t1.y == t1Tally)
            {
                mci.t1.y = t1Shorty;
                tfHeight = (tfHeight - tfdH);
                _local_2.a1.visible = true;
                _local_2.a2.visible = false;
                rootClass.ui.ToolTip.openWith({"str":"Set the chat pane to full height"});
            }
            else
            {
                mci.t1.y = t1Tally;
                tfHeight = (tfHeight + tfdH);
                _local_2.a1.visible = false;
                _local_2.a2.visible = true;
                rootClass.ui.ToolTip.openWith({"str":"Return the chat pane to normal height"});
            }
            writeText(panelIndex);
        }

        private function onCannedChatClick(_arg_1:MouseEvent):void
        {
            mcCannedChat.visible = (!(mcCannedChat.visible));
        }

        public function closeCannedChat():void
        {
            mcCannedChat.visible = false;
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

        private function chat_btnSend(_arg_1:MouseEvent):*
        {
            submitMsg(mci.te.text, chn.cur.typ, pmNm);
            rootClass.stage.focus = null;
        }

        private function chat_tebgClick(_arg_1:MouseEvent):*
        {
            if (rootClass.stage.focus != mci.te)
            {
                openMsgEntry();
            }
        }

        private function chat_linkHandler(_arg_1:TextEvent):*
        {
            var _local_2:String;
            var _local_3:String;
            _local_2 = String(_arg_1.text.split(",")[0]);
            switch (_local_2)
            {
                case "openPMsg":
                    pmMode = 1;
                    _local_3 = String(_arg_1.text.split(",")[1]);
                    openPMsg(_local_3);
                    return;
            }
        }

        internal function onMouseWheelEvent(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            if (rootClass.litePreference.data.bDisChatScroll)
            {
                return;
            }
            if (mci.t1.hitTestPoint(_arg_1.stageX, _arg_1.stageY))
            {
                _local_2 = t1Arr.length;
                if (_arg_1.delta > 0)
                {
                    if (panelIndex > 0)
                    {
                        panelIndex--;
                    }
                }
                else
                {
                    if (panelIndex < (t1Arr.length - 1))
                    {
                        panelIndex++;
                    }
                }
                writeText(panelIndex);
            }
        }

        internal function resetAreaChannels():*
        {
            chn.zone.act = 0;
            chn.trade.act = 0;
        }

        public function mapChannels(_arg_1:*):*
        {
            var _local_3:*;
            resetAreaChannels();
            var _local_2:* = 0;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = _arg_1[_local_2].split(",")[0].toString();
                if (_local_3.indexOf("trade") > -1)
                {
                    chn.trade.rid = rootClass.sfc.getRoom(_local_3).getId();
                    chn.trade.act = 1;
                }
                _local_2++;
            }
            chn.zone.act = 1;
        }

        internal function popBubble(_arg_1:*, _arg_2:*, _arg_3:*):*
        {
            // Aera v30.13: staff rank is a display-name prefix, not message text.
            // Strip it only from the avatar lookup key so text chat can render
            // `[Admin] Name: message` while the bubble remains `message`.
            _arg_1 = String(_arg_1).replace("u:[Admin] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[Mod] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[GM] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[Administrator] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[Moderator] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[GameMaster] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[Game Master] ", "u:");
            // strToProperCase() lowercases the prefixed avatar lookup before
            // popBubble() is called, so strip those runtime forms too.
            _arg_1 = String(_arg_1).replace("u:[admin] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[mod] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[gm] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[administrator] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[moderator] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[gamemaster] ", "u:");
            _arg_1 = String(_arg_1).replace("u:[game master] ", "u:");
            // Aera v30.11: keep staff rank in the text-chat line only.
            // The server prefixes staff zone messages for Chat2 compatibility,
            // but speech bubbles should contain only the player's actual text.
            if (String(_arg_2).indexOf("(Administrator) ") == 0)
            {
                _arg_2 = String(_arg_2).substr(16);
            }
            else if (String(_arg_2).indexOf("(Moderator) ") == 0)
            {
                _arg_2 = String(_arg_2).substr(12);
            }
            else if (String(_arg_2).indexOf("(Game Master) ") == 0)
            {
                _arg_2 = String(_arg_2).substr(14);
            }
            var _local_4:* = null;
            var _local_5:* = _arg_1.split(":")[0];
            _arg_1 = _arg_1.substr(2);
            switch (_local_5)
            {
                case "u":
                    _local_4 = rootClass.world.getMCByUserName(_arg_1);
                    break;
            }
            if (_local_4 != null)
            {
                _local_4.bubble.ti.autoSize = TextFieldAutoSize.CENTER;
                _local_4.bubble.ti.wordWrap = true;
                _local_4.bubble.ti.htmlText = _arg_2;
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

        public function formatMsgEntry(_arg_1:*):*
        {
            mci.te.setSelection(0, 0);
            if (chn.cur != chn.whisper)
            {
                if (chn.cur == chn.zone)
                {
                    mci.tt.text = "";
                    mci.tt.visible = false;
                }
                else
                {
                    mci.tt.text = (chn.cur.tag + ": ");
                    mci.tt.visible = true;
                }
            }
            else
            {
                if (((typeof(_arg_1) == "undefined") || (_arg_1 == "")))
                {
                    mci.tt.text = "";
                    mci.tt.visible = false;
                }
                else
                {
                    pmNm = _arg_1;
                    mci.tt.text = (("To " + _arg_1) + ": ");
                    mci.tt.visible = true;
                }
            }
        }

        public function updateMsgEntry():*
        {
            mci.te.x = ((mci.tt.x + mci.tt.textWidth) + ((mci.tt.text.length) ? 1 : 0));
            mci.te.width = ((mci.bsend.x - mci.te.x) - 3);
            mci.te.textColor = "0xFFFFFF";
            mci.tt.textColor = "0xFFFFFF";
        }

        private function checkMsgType(_arg_1:Event):*
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_2:* = mci.te.text;
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
                                mci.te.text = mci.te.text.substr((_local_4.substr(1).length + 2));
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "2":
                            if (chn.trade.act)
                            {
                                chn.cur = chn.trade;
                                chn.lastPublic = chn.trade;
                                mci.te.text = mci.te.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "p":
                            if (chn.party.act)
                            {
                                chn.cur = chn.party;
                                chn.lastPublic = chn.party;
                                mci.te.text = mci.te.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "r":
                            if (pmSourceA.length)
                            {
                                pmMode = 1;
                                chn.cur = chn.whisper;
                                mci.te.text = mci.te.text.substr(3);
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
                                mci.te.text = mci.te.text.substr(((_local_3[0].length + _local_3[1].length) + 1));
                                formatMsgEntry(_local_3[1]);
                                updateMsgEntry();
                            }
                            break;
                        case "c":
                            pmMode = 2;
                            chn.cur = chn.whisper;
                            mci.te.text = mci.te.text.substr(((_local_3[0].length + _local_3[1].length) + 1));
                            formatMsgEntry(pmSourceA[0]);
                            updateMsgEntry();
                            break;
                        case "g":
                            if (chn.guild.act)
                            {
                                chn.cur = chn.guild;
                                chn.lastPublic = chn.guild;
                                mci.te.text = mci.te.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "world":
                            if (chn.world.act)
                            {
                                chn.cur = chn.world;
                                chn.lastPublic = chn.world;
                                mci.te.text = mci.te.text.substr(7);
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
                        mci.te.text = mci.te.text.substr(2);
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
                    mci.te.text = _local_7[1];
                    formatMsgEntry(_local_7[0]);
                    updateMsgEntry();
                }
            }
        }

        internal function openMsgEntry():*
        {
            pmI = 0;
            myMsgsI = 0;
            mci.tebg.addEventListener(MouseEvent.CLICK, chat_tebgClick);
            mci.te.visible = true;
            mci.te.type = TextFieldType.INPUT;
            rootClass.stage.focus = null;
            rootClass.stage.focus = mci.te;
            formatMsgEntry(pmNm);
            updateMsgEntry();
        }

        internal function openPMsg(_arg_1:*):*
        {
            pmNm = _arg_1;
            chn.cur = chn.whisper;
            openMsgEntry();
        }

        internal function closeMsgEntry():*
        {
            mci.tebg.addEventListener(MouseEvent.CLICK, chat_tebgClick);
            mci.te.text = "";
            mci.tt.text = "";
            mci.te.visible = false;
            mci.tt.visible = false;
            if (pmMode != 2)
            {
                chn.cur = chn.lastPublic;
            }
            mci.te.type = TextFieldType.DYNAMIC;
            rootClass.stage.focus = null;
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
                _arg_1 = _arg_1.split("#060:").join("&lt;");
            }
            if (_arg_1.indexOf(">") > -1)
            {
                _arg_1 = _arg_1.split(">").join("#062:");
            }
            if (((_arg_2) && (_arg_1.indexOf("#062:") > -1)))
            {
                _arg_1 = _arg_1.split("#062:").join("&gt;");
            }
            if (_arg_2)
            {
                _arg_1 = removeHTML(_arg_1);
            }
            return (_arg_1);
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
            msg = cleanChars(msg);
            var msgOK:Boolean = true;
            var warningModal:Boolean = true;
            var strEmail:String;
            if (Game.loginInfo.strPassword != null)
            {
                strPassword = Game.loginInfo.strPassword.toLowerCase();
                if (msg.toLowerCase().indexOf(strPassword) > -1)
                {
                    msgOK = false;
                }
            }
            if (((!(rootClass.world == null)) && (!(rootClass.world.myAvatar == null))))
            {
                if (((rootClass.world.myAvatar.items == null) || (rootClass.world.myAvatar.items.length < 1)))
                {
                    msgOK = false;
                    warningModal = false;
                    pushMsg("warning", "Character is still being loaded, please wait a moment.", "SERVER", "", 0);
                }
                if (rootClass.world.myAvatar.objData != null)
                {
                    uoData = rootClass.world.myAvatar.objData;
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
                rootClass.ui.ModalStack.addChild(modal);
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
                if (msg.indexOf(strPassword) > -1)
                {
                    ei = 0;
                    while (ei < strPassword.length)
                    {
                        strA = (strA + ((ei == 0) ? strPassword.charAt(0) : "*"));
                        ei = (ei + 1);
                    }
                    msg = msg.split(strPassword).join(strA);
                }
                pushMsg("warning", msg, "SERVER", "", 0);
                closeMsgEntry();
                return;
            }
            i = 0;
            var str:* = rootClass.stripWhite(msg);
            if (str.length)
            {
                myMsgs.push(msg);
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
                            if (rootClass.world.myAvatar.isStaff())
                            {
                                rootClass.sfc.sendString(msg.substr((msg.indexOf(" ") + 1)));
                                pushMsg("server", ("Sent " + msg.substr((msg.indexOf(" ") + 1))), "SERVER", "", 0);
                            }
                            break;
                        case "multi":
                            msg = ("/" + msg.substr(7));
                            submitMsg(msg, typ, unm, true);
                            return;
                        case "reload":
                            cmd = null;
                            if (rootClass.world.myAvatar.isStaff())
                            {
                                rootClass.world.reloadCurrentMap();
                            }
                            break;
                        case "cell":
                            cmd = null;
                            if (rootClass.world.myAvatar.objData.intAccessLevel >= 40)
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
                                for each (cell in rootClass.world.map.currentScene.labels)
                                {
                                    if (cell.name == parta)
                                    {
                                        isCellOK = true;
                                        break;
                                    }
                                }
                                if (isCellOK)
                                {
                                    rootClass.world.moveToCell(parta, partb);
                                }
                                else
                                {
                                    rootClass.chatF.pushMsg("warning", (("Frame '" + parta) + "' does not exist."), "SERVER", "", 0);
                                }
                            }
                            break;
                        case "shop":
                            cmd = null;
                            if (rootClass.world.myAvatar.objData.intAccessLevel >= 40)
                            {
                                if (params.length > 1)
                                {
                                    parta = int(params[1]);
                                }
                                else
                                {
                                    parta = 1;
                                }
                                rootClass.world.sendLoadShopRequest(parta);
                            }
                            break;
                        case "sound":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                if (params[1] == "off")
                                {
                                    rootClass.mixer.bSoundOn = false;
                                }
                                else
                                {
                                    if (params[1] == "on")
                                    {
                                        rootClass.mixer.bSoundOn = true;
                                    }
                                }
                            }
                            break;
                        case "ignore":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (tuoNm.toLowerCase() != rootClass.sfc.myUserName)
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
                            ignoreList.data.users = new Array();
                            pushMsg("warning", "Ignore List Cleared!", "SERVER", "", 0);
                            rootClass.sfc.sendXtMessage("zm", "cmd", ["ignoreList", "$clearAll"], "str", 1);
                            break;
                        case "report":
                        case "reportlang":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                rootClass.ui.mcPopup.fOpen("Report", {"unm":tuoNm});
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
                            rootClass.world.showGuildList();
                            break;
                        case "guildInvite":
                        case "gi":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                rootClass.world.guildInvite(tuoNm);
                            }
                            break;
                        case "guildremove":
                        case "gr":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                avt = rootClass.world.getAvatarByUserName(tuoNm);
                                if (((rootClass.world.myAvatar.objData.guildRank >= 2) || (avt.isMyAvatar)))
                                {
                                    modal = new ModalMC();
                                    modalO = {};
                                    modalO.strBody = (("Do you want to remove " + tuoNm) + " from the guild?");
                                    modalO.callback = rootClass.world.guildRemove;
                                    modalO.params = {"userName":tuoNm};
                                    modalO.btns = "dual";
                                    rootClass.ui.ModalStack.addChild(modal);
                                    modal.init(modalO);
                                }
                            }
                            break;
                        case "guildPromote":
                        case "gp":
                            cmd = null;
                            if (rootClass.world.myAvatar.objData.guildRank >= 2)
                            {
                                if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                                {
                                    tuoNm = params.slice(1).join(" ");
                                    rootClass.world.guildPromote(tuoNm);
                                }
                            }
                            break;
                        case "guildDemote":
                        case "gd":
                            cmd = null;
                            if (rootClass.world.myAvatar.objData.guildRank >= 2)
                            {
                                if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                                {
                                    tuoNm = params.slice(1).join(" ");
                                    rootClass.world.guildDemote(tuoNm);
                                }
                            }
                            break;
                        case "motd":
                            if (msg.length == 5)
                            {
                                if (rootClass.world.myAvatar.objData.guild != null)
                                {
                                    if (((!(rootClass.world.myAvatar.objData.guild.MOTD == null)) && (!(String(rootClass.world.myAvatar.objData.guild.MOTD) == "undefined"))))
                                    {
                                        pushMsg("guild", ("Message of the day: " + String(rootClass.world.myAvatar.objData.guild.MOTD)), "SERVER", "", 0);
                                    }
                                    else
                                    {
                                        pushMsg("guild", "No Message of the day has been set.", "SERVER", "", 0);
                                    }
                                }
                            }
                            else
                            {
                                rootClass.world.setGuildMOTD(msg.substr(5));
                            }
                            break;
                        case "gc":
                        case "guildcreate":
                            if (rootClass.world.myAvatar.isUpgraded())
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
                                        modalO.callback = rootClass.world.createGuild;
                                        modalO.params = {"guildName":guildName};
                                        modalO.btns = "dual";
                                        rootClass.ui.ModalStack.addChild(modal);
                                        modal.init(modalO);
                                    }
                                    else
                                    {
                                        rootClass.chatF.pushMsg("server", "Guild names must be 25 characters or less.", "SERVER", "", 0);
                                    }
                                }
                                else
                                {
                                    rootClass.chatF.pushMsg("server", "Please specify a name for your guild.", "SERVER", "", 0);
                                }
                            }
                            else
                            {
                                rootClass.chatF.pushMsg("server", "Only members may create guilds.", "SERVER", "", 0);
                            }
                            break;
                        case "renameGuild":
                        case "rg":
                            if (rootClass.world.myAvatar.objData.guildRank == 3)
                            {
                                if (rootClass.world.myAvatar.objData.intCoins >= 1000)
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
                                            modalO.callback = rootClass.world.renameGuild;
                                            modalO.params = {"guildName":guildName};
                                            modalO.btns = "dual";
                                            rootClass.ui.ModalStack.addChild(modal);
                                            modal.init(modalO);
                                        }
                                        else
                                        {
                                            rootClass.chatF.pushMsg("server", "Guild names must be 25 characters or less.", "SERVER", "", 0);
                                        }
                                    }
                                    else
                                    {
                                        rootClass.chatF.pushMsg("server", "Please specify a name for your guild.", "SERVER", "", 0);
                                    }
                                }
                                else
                                {
                                    rootClass.chatF.pushMsg("server", "You do not have enough ACs.", "SERVER", "", 0);
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
                                    rootClass.sfc.sendXtMessage("zm", "dynamic", [paramStr, params[1], params[2]], "str", 1);
                                }
                                catch(e)
                                {
                                    rootClass.sfc.sendXtMessage("zm", "dynamic", [paramStr, params[1]], "str", 1);
                                }
                            }
                            break;
                        case "guildreset":
                            rootClass.sfc.sendXtMessage("zm", "guild", ["guildreset"], "str", 1);
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
                            rootClass.sfc.sendXtMessage("zm", "guild", ["gInv", s], "str", 1);
                            break;
                        case "invite":
                        case "pi":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (((rootClass.world.partyMembers.length < 4) || (!(rootClass.world.isPartyMember(tuoNm)))))
                                {
                                    rootClass.world.partyInvite(tuoNm);
                                }
                            }
                            break;
                        case "ps":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                rootClass.world.partySummon(tuoNm);
                            }
                            break;
                        case "pk":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                rootClass.world.doPartyKick(tuoNm);
                            }
                            break;
                        case "duel":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                rootClass.world.sendDuelInvite(tuoNm);
                            }
                            break;
                        case "friends":
                            cmd = null;
                            rootClass.world.showFriendsList();
                            break;
                        case "friend":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (tuoNm.toLowerCase() != rootClass.sfc.myUserName)
                                {
                                    rootClass.world.requestFriend(tuoNm);
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
                            if (((((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)) && (!(rootClass.world.uoTree[rootClass.sfc.myUserName].intState == 0))) && (rootClass.world.coolDown("tfer"))))
                            {
                                rootClass.world.returnInfo = null;
                                cmd = "cmd";
                                uName = rootClass.sfc.myUserName;
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
                                xtArr.push(rootClass.sfc.myUserName);
                                xtArr.push(strMap);
                            }
                            break;
                        case "roomid":
                            cmd = "cmd";
                            xtArr.push("roomID");
                            xtArr.push(rootClass.sfc.myUserName);
                            xtArr.push(params[1]);
                            break;
                        case "house":
                            cmd = null;
                            if (params[1] == null)
                            {
                                tuoNm = rootClass.sfc.myUserName;
                            }
                            else
                            {
                                tuoNm = params.slice(1).join(" ");
                            }
                            rootClass.world.gotoHouse(tuoNm);
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
                            if ((((rootClass.world.myAvatar.isStaff()) && (!(typeof(params[1]) == "undefined"))) && (params[1].length > 0)))
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
                                rootClass.world._SafeStr_1(params.slice(1).join(" "));
                            }
                            break;
                        case "pull":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = null;
                                rootClass.world.pull(params.slice(1).join(" "));
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
                            cmd = null;
                            rootClass.world.toggleFPS();
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
                            if (((rootClass.world.myAvatar.isStaff()) && (params.length == 3)))
                            {
                                pushMsg("warning", ((((("geta " + params[1]) + ",") + params[2]) + ": ") + rootClass.world.getAchievement(params[1], params[2])), "SERVER", "", 0);
                            }
                            break;
                        case "seta":
                            if (((rootClass.world.myAvatar.isStaff()) && (params.length == 4)))
                            {
                                rootClass.world.setAchievement(params[1], params[2], params[3]);
                            }
                            break;
                        case "queststring":
                            if (rootClass.world.myAvatar.isStaff())
                            {
                                rootClass.world.loadQuestStringData();
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
                            rootClass.world.afkToggle();
                            break;
                        case "rest":
                            rootClass.world.rest();
                            break;
                        case "repairavatars":
                            cmd = null;
                            rootClass.world.repairAvatars();
                            break;
                        case "samba":
                            bAch = rootClass.world.getAchievement("ia0", 11);
                            if (!bAch)
                            {
                                pushMsg("warning", "You must learn this dance from Samba in Bloodtusk Ravine.", "SERVER", "", 0);
                                break;
                            }
                            if (!rootClass.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "danceweapon":
                            if (!rootClass.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "useweapon":
                            if (!rootClass.world.myAvatar.isUpgraded())
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
                            if (!rootClass.world.myAvatar.isUpgraded())
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
                            if (((unm == "iterator") || (rootClass.world.myAvatar.isStaff())))
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
                    rootClass.world.myAvatar.pMC.mcChar.gotoAndPlay(rootClass.strToProperCase(uVars.strEmote));
                    rootClass.sfc.sendXtMessage("zm", cmd, [uVars.strEmote], "str", 1);
                }
                else
                {
                    if (((cmd == "mod") || (cmd == "cmd")))
                    {
                        if (xtArr.length)
                        {
                            rootClass.sfc.sendXtMessage("zm", cmd, xtArr, "str", 1);
                        }
                    }
                    else
                    {
                        if (cmd != "simple")
                        {
                            if (!((cmd == null) || (xtArr.length < 1)))
                            {
                                if (!rootClass.serialCmdMode)
                                {
                                    rootClass.world.afkPostpone();
                                    myAvatar = rootClass.world.myAvatar;
                                    profanityResult = {};
                                    profanityResult = nuProfanityCheck(cleanStr(xtArr[0]));
                                    if (iChat == 0)
                                    {
                                        pushMsg("warning", "This server only allows canned chat.", "SERVER", "", 0);
                                    }
                                    else
                                    {
                                        if (((((iChat == 1) && (!(rootClass.world.myAvatar.hasUpgraded()))) && (!(rootClass.world.myAvatar.isVerified()))) && (!(rootClass.world.myAvatar.isStaff()))))
                                        {
                                            pushMsg("warning", "Chat is a members-only feature at this time.", "SERVER", "", 0);
                                        }
                                        else
                                        {
                                            if (((((!(rootClass.world.myAvatar.hasUpgraded())) && (!(rootClass.world.myAvatar.isVerified()))) && (!(rootClass.world.myAvatar.isStaff()))) && (!(rootClass.world.myAvatar.isEmailVerified()))))
                                            {
                                                if (int(rootClass.world.myAvatar.objData.iAge) < 13)
                                                {
                                                    pushMsg("warning", "Upgrade is required to chat in this server.", "SERVER", "", 0);
                                                }
                                                else
                                                {
                                                    pushMsg("warning", "Confirm your email at https://account.aq.com/ to protect your account and enable chat.", "SERVER", "", 0);
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
                                                    if (((!(myAvatar.objData.dMutedTill == null)) && (myAvatar.objData.dMutedTill.getTime() > rootClass.date_server.getTime())))
                                                    {
                                                        iDiff = ((myAvatar.objData.dMutedTill.getTime() - rootClass.date_server.getTime()) / 1000);
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
                                                                rootClass.sfc.sendXtMessage("zm", cmd, xtArr, "str", rmId);
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
                                    rootClass.sfc.sendXtMessage("zm", cmd, xtArr, "str", rmId);
                                }
                            }
                        }
                    }
                }
            }
            if (!rootClass.serialCmdMode)
            {
                closeMsgEntry();
            }
        }

        private function checkFieldsVPos():*
        {
            var _local_1:* = mci.t1;
            _local_1.resetVPos = 0;
            if (panelIndex == (t1Arr.length - 1))
            {
                _local_1.resetVPos = 1;
            }
        }

        private function setFieldsVPos():*
        {
            var _local_1:* = mci.t1;
            if (_local_1.resetVPos)
            {
                panelIndex = (t1Arr.length - 1);
            }
            panelIndex = Math.min(panelIndex, (t1Arr.length - 1));
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

        private function html2Fields(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):*
        {
            var _local_5:* = mci.t1;
            switch (_arg_2)
            {
                case "=":
                default:
                    t1Arr = [{
                        "s":_arg_1,
                        "id":_arg_4
                    }];
                    return;
                case "+=":
                    t1Arr.push({
                        "s":_arg_1,
                        "id":_arg_4
                    });
            }
        }

        public function writeText(_arg_1:int):void
        {
            var _local_2:DisplayObject;
            var _local_3:MovieClip;
            var _local_6:int;
            var _local_4:* = true;
            var _local_5:Array = [];
            var _local_7:int;
            var _local_8:int;
            _local_7 = (t1Arr.length - 1);
            while (_local_7 > -1)
            {
                if (((_local_7 <= _arg_1) && (_local_4)))
                {
                    _local_8 = t1Arr[_local_7].id;
                    tl.ti.htmlText = t1Arr[_local_7].s;
                    formatWithoutTextLinks(tl.ti);
                    _local_6 = checkPos(tl, _local_7, _local_8, _arg_1);
                    if (_local_6 <= 0)
                    {
                        _local_4 = false;
                    }
                    else
                    {
                        _local_5.push(_local_8);
                        if (drawnA.indexOf(_local_8) > -1)
                        {
                            _local_2 = getBitmapByIndex(_local_8, mci.t1);
                        }
                        else
                        {
                            _local_2 = buildTextLinks(tl.ti, t1Arr[_local_7].s, mci.t1, drawnA, _local_8);
                        }
                        _local_2.y = _local_6;
                        MovieClip(_local_2).mouseEnabled = false;
                    }
                }
                _local_7--;
            }
            _local_7 = 0;
            while (_local_7 < drawnA.length)
            {
                if (_local_5.indexOf(drawnA[_local_7]) < 0)
                {
                    _local_2 = getBitmapByIndex(drawnA[_local_7], mci.t1);
                    if (_local_2 != null)
                    {
                        mci.t1.removeChild(_local_2);
                        drawnA.splice(_local_7, 1);
                        _local_7--;
                    }
                }
                _local_7++;
            }
        }

        private function formatWithoutTextLinks(_arg_1:TextField):void
        {
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            var _local_10:String;
            var _local_11:Array;
            var _local_12:String;
            var _local_13:String;
            var _local_14:int;
            var _local_15:String;
            var _local_16:String;
            var _local_2:* = "$({";
            var _local_3:* = "})$";
            var _local_4:* = '<font color="#';
            var _local_5:* = '">';
            var _local_6:* = "</font>";
            while (((_arg_1.htmlText.indexOf(_local_2) > -1) && (_arg_1.htmlText.indexOf(_local_3) > -1)))
            {
                _local_7 = _arg_1.htmlText;
                _local_8 = _local_7.substr(0, _local_7.indexOf(_local_2));
                _local_9 = _local_7.substr((_local_7.indexOf(_local_3) + _local_3.length));
                _local_10 = _local_7.substr((_local_7.indexOf(_local_2) + _local_2.length));
                _local_11 = _local_10.substr(0, _local_10.indexOf(_local_3)).split(",");
                _local_12 = _local_11[0];
                _local_13 = _local_11[1];
                _local_14 = _arg_1.text.indexOf(_local_2);
                switch (_local_12)
                {
                    case "url":
                        _local_16 = _local_13;
                        _local_15 = ((((((_local_4 + "FFFF99") + _local_5) + "<u>") + _local_16) + "</u>") + _local_6);
                        break;
                    case "user":
                        _local_16 = _local_13;
                        _local_15 = ((((_local_4 + "FFFFFF") + _local_5) + _local_16) + _local_6);
                        break;
                    case "item":
                    case "quest":
                        _local_16 = (("[" + _local_13) + "]");
                        _local_15 = ((((_local_4 + "00CCFF") + _local_5) + _local_16) + _local_6);
                        break;
                }
                _arg_1.htmlText = ((_local_8 + _local_15) + _local_9);
            }
        }

        private function buildTextLinks(_arg_1:TextField, _arg_2:String, _arg_3:MovieClip, _arg_4:Array, _arg_5:int):DisplayObject
        {
            var _local_13:String;
            var _local_14:String;
            var _local_15:String;
            var _local_16:String;
            var _local_17:Array;
            var _local_18:String;
            var _local_19:String;
            var _local_20:int;
            var _local_21:String;
            var _local_22:String;
            var _local_23:Object;
            var _local_24:*;
            var _local_25:*;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:*;
            var _local_30:Rectangle;
            var _local_31:Rectangle;
            var _local_32:MovieClip;
            var _local_33:*;
            var _local_34:String;
            var _local_6:MovieClip = new MovieClip();
            _local_6.name = ("b" + _arg_5);
            var _local_7:* = "$({";
            var _local_8:* = "})$";
            var _local_9:* = '<font color="#';
            var _local_10:* = '">';
            var _local_11:* = "</font>";
            _arg_1.htmlText = _arg_2;
            while (((_arg_1.htmlText.indexOf(_local_7) > -1) && (_arg_1.htmlText.indexOf(_local_8) > -1)))
            {
                _local_13 = _arg_1.htmlText;
                _local_14 = _local_13.substr(0, _local_13.indexOf(_local_7));
                _local_15 = _local_13.substr((_local_13.indexOf(_local_8) + _local_8.length));
                _local_16 = _local_13.substr((_local_13.indexOf(_local_7) + _local_7.length));
                _local_17 = _local_16.substr(0, _local_16.indexOf(_local_8)).split(",");
                _local_18 = _local_17[0];
                _local_19 = _local_17[1];
                _local_19 = _local_19.split("&amp;").join("&");
                _local_20 = _arg_1.text.indexOf(_local_7);
                _local_23 = {};
                switch (_local_18)
                {
                    case "url":
                        _local_22 = _local_19;
                        _local_21 = ((((((_local_9 + "FFFF99") + _local_10) + "<u>") + _local_22) + "</u>") + _local_11);
                        _local_23.callback = urlClick;
                        break;
                    case "user":
                        _local_22 = _local_19;
                        _local_21 = ((((_local_9 + "FFFFFF") + _local_10) + _local_22) + _local_11);
                        _local_23.callback = pmClick;
                        break;
                    case "item":
                        _local_22 = (("[" + _local_19) + "]");
                        _local_21 = ((((_local_9 + "00CCFF") + _local_10) + _local_22) + _local_11);
                        _local_23.callback = null;
                        break;
                    case "quest":
                        _local_23.sName = _local_17[1];
                        _local_23.QuestID = _local_17[2];
                        _local_23.iLvl = _local_17[3];
                        _local_23.unm = _local_17[4];
                        _local_22 = (("[" + _local_19) + "]");
                        _local_21 = ((((_local_9 + "00CCFF") + _local_10) + _local_22) + _local_11);
                        _local_23.callback = rootClass.world.doCTAClick;
                        break;
                }
                _arg_1.htmlText = ((_local_14 + _local_21) + _local_15);
                _local_24 = _local_20;
                _local_25 = ((_local_20 + _local_22.length) - 1);
                _local_26 = _arg_1.getLineIndexOfChar(_local_24);
                _local_27 = _arg_1.getLineIndexOfChar(_local_25);
                _local_28 = _local_26;
                while (_local_28 <= _local_27)
                {
                    if (_local_28 == _local_26)
                    {
                        _local_29 = _arg_1.getCharBoundaries(_local_24);
                    }
                    else
                    {
                        _local_29 = _arg_1.getCharBoundaries(_arg_1.getLineOffset(_local_28));
                    }
                    if (_local_28 == _local_27)
                    {
                        _local_30 = _arg_1.getCharBoundaries(_local_25);
                    }
                    else
                    {
                        _local_30 = _arg_1.getCharBoundaries((_arg_1.getLineOffset((_local_28 + 1)) - 1));
                    }
                    _local_31 = new Rectangle(_local_29.x, _local_29.y, ((_local_30.x - _local_29.x) + _local_30.width), ((_local_30.y - _local_29.y) + _local_30.height));
                    _local_32 = new MovieClip();
                    _local_32.graphics.beginFill(52479);
                    _local_32.graphics.drawRect(0, 0, _local_31.width, _local_31.height);
                    _local_32.graphics.endFill();
                    _local_33 = _local_6.addChild(_local_32);
                    _local_33.alpha = 0;
                    _local_33.x = (_arg_1.x + _local_29.x);
                    _local_33.y = (_arg_1.y + _local_29.y);
                    for (_local_34 in _local_23)
                    {
                        if (_local_34 != "callback")
                        {
                            _local_33[_local_34] = _local_23[_local_34];
                        }
                    }
                    _local_33.str = _local_19;
                    _local_33.buttonMode = true;
                    _local_33.addEventListener(MouseEvent.CLICK, _local_23.callback, false, 0, true);
                    _local_28++;
                }
            }
            var _local_12:* = new uiTextLine();
            _local_12.ti.htmlText = tl.ti.htmlText;
            _local_12.ti.autoSize = "left";
            _local_12.ti.multiline = true;
            MovieClip(_local_12).mouseEnabled = false;
            MovieClip(_local_12).mouseChildren = false;
            _local_12.name = "bmp";
            if (_local_6.numChildren > 0)
            {
                _local_6.swapChildren(_local_6.getChildAt(0), _local_6.addChildAt(_local_12, 0));
            }
            else
            {
                _local_6.addChild(_local_12);
            }
            _arg_4.push(_arg_5);
            return (_arg_3.addChild(_local_6));
        }

        private function checkPos(_arg_1:MovieClip, _arg_2:int, _arg_3:int, _arg_4:int):int
        {
            var _local_5:DisplayObject = getBitmapByIndex((_arg_3 + 1), mci.t1);
            if (((!(_local_5 == null)) && (_arg_2 < _arg_4)))
            {
                return ((_local_5.y - _arg_1.height) + 2);
            }
            return (Math.round((tfHeight - _arg_1.height)));
        }

        private function pmClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            if (_arg_1.shiftKey)
            {
                _local_2 = (_arg_1.currentTarget as MovieClip);
                openPMsg(_local_2.str);
            }
            else
            {
                rootClass.world.onWalkClick();
            }
        }

        private function urlClick(_arg_1:MouseEvent):void
        {
            var _local_2:* = (_arg_1.currentTarget as MovieClip);
            navigateToURL(new URLRequest(_local_2.str), "_blank");
        }

        private function getBitmapByIndex(_arg_1:int, _arg_2:DisplayObjectContainer):DisplayObject
        {
            var _local_3:DisplayObject;
            var _local_4:int;
            while (_local_4 < _arg_2.numChildren)
            {
                if (int(_arg_2.getChildAt(_local_4).name.substr(1)) == _arg_1)
                {
                    return (_arg_2.getChildAt(_local_4));
                }
                _local_4++;
            }
            return (null);
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


        // Aera v2.4.2 staff chat presentation.
        // Normal staff map chat and /iay are intentionally different:
        //   normal: [Administrator] Animu: message
        //   /iay:   [Administrator] Server: (Animu): message
        // Only the [Rank] label is rank-colored; the rest stays white.

        // Aera v30.61 dedicated /iay presentation.  Game.as calls this only for
        // the structured raw `iay` packet sent by the PHP emulator.
        public function pushAeraIAY(_rank:String, _username:String, _message:String):void
        {
            var rank:String = String(_rank);
            var lower:String = rank.toLowerCase();
            if (((lower == "administrator") || (lower == "admin")))
            {
                rank = "Administrator";
            }
            else if (((lower == "game master") || (lower == "gamemaster") || (lower == "gm")))
            {
                rank = "GameMaster";
            }
            else
            {
                rank = "Moderator";
            }
            pushMsg("server", ((((("__AERA_IAY__" + rank) + "::") + String(_username)) + "::") + String(_message)), "SERVER", "", 0);
        }

        private function aeraIAYMarkerInfo(_value:String):Object
        {
            var s:String = String(_value);
            var prefix:String = "__AERA_IAY__";
            var p1:int;
            var p2:int;
            var rank:String;
            var lower:String;
            var user:String;
            var body:String;
            var colorHex:String;
            var color:uint;
            if (s.indexOf(prefix) != 0)
            {
                return null;
            }
            s = s.substr(prefix.length);
            p1 = s.indexOf("::");
            if (p1 < 1)
            {
                return null;
            }
            p2 = s.indexOf("::", (p1 + 2));
            if (p2 < (p1 + 2))
            {
                return null;
            }
            rank = s.substring(0, p1);
            user = s.substring((p1 + 2), p2);
            body = s.substr((p2 + 2));
            lower = rank.toLowerCase();
            if (((lower == "administrator") || (lower == "admin")))
            {
                rank = "Administrator";
                colorHex = "00BFFF";
                color = 0x00BFFF;
            }
            else if (((lower == "game master") || (lower == "gamemaster") || (lower == "gm")))
            {
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
            }
            else
            {
                rank = "Moderator";
                colorHex = "FFCC33";
                color = 0xFFCC33;
            }
            user = rootClass.strToProperCase(user);
            return {rank:rank, user:user, msg:body, colorHex:colorHex, color:color};
        }

        private function aeraStaffNameInfo(_arg_1:String):Object
        {
            var s:String = String(_arg_1);
            var lower:String = s.toLowerCase();
            var cut:int = 0;
            var rank:String = "";
            var colorHex:String = "";
            var color:uint = 0;
            if (lower.indexOf("[administrator] ") == 0)
            {
                cut = 16;
                rank = "Administrator";
                colorHex = "00BFFF";
                color = 0x00BFFF;
            }
            else if (lower.indexOf("[admin] ") == 0)
            {
                cut = 8;
                rank = "Administrator";
                colorHex = "00BFFF";
                color = 0x00BFFF;
            }
            else if (lower.indexOf("[game master] ") == 0)
            {
                cut = 14;
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
            }
            else if (lower.indexOf("[gamemaster] ") == 0)
            {
                cut = 13;
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
            }
            else if (lower.indexOf("[gm] ") == 0)
            {
                cut = 5;
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
            }
            else if (lower.indexOf("[moderator] ") == 0)
            {
                cut = 12;
                rank = "Moderator";
                colorHex = "FFCC33";
                color = 0xFFCC33;
            }
            else if (lower.indexOf("[mod] ") == 0)
            {
                cut = 6;
                rank = "Moderator";
                colorHex = "FFCC33";
                color = 0xFFCC33;
            }
            if (cut == 0)
            {
                return null;
            }
            s = s.substr(cut);
            if (s.length > 0)
            {
                s = rootClass.strToProperCase(s);
            }
            return {rank:rank, user:s, msg:"", colorHex:colorHex, color:color};
        }

        // Compatibility for the currently deployed Aera emulator and older
        // /iay packets which arrive through the raw moderator channel as e.g.
        // "Server: Administrator animu: hi" or "Game Master animu: hi".
        private function aeraStaffServerInfo(_arg_1:String, _arg_2:String):Object
        {
            var channel:String = String(_arg_1).toLowerCase();
            var s:String = String(_arg_2);
            var lower:String;
            var rank:String = "";
            var colorHex:String = "";
            var color:uint = 0;
            var cut:int = 0;
            var colon:int;
            var closeParen:int;
            var user:String;
            var body:String;

            if (s.toLowerCase().indexOf("server: ") == 0)
            {
                s = s.substr(8);
            }
            lower = s.toLowerCase();

            if (lower.indexOf("administrator ") == 0)
            {
                rank = "Administrator";
                colorHex = "00BFFF";
                color = 0x00BFFF;
                cut = 14;
            }
            else if (lower.indexOf("game master ") == 0)
            {
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
                cut = 12;
            }
            else if (lower.indexOf("gamemaster ") == 0)
            {
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
                cut = 11;
            }
            else if (lower.indexOf("moderator ") == 0)
            {
                rank = "Moderator";
                colorHex = "FFCC33";
                color = 0xFFCC33;
                cut = 10;
            }
            else if (channel == "administrator" || channel == "admin")
            {
                rank = "Administrator";
                colorHex = "00BFFF";
                color = 0x00BFFF;
            }
            else if (channel == "gm" || channel == "gamemaster")
            {
                rank = "GameMaster";
                colorHex = "FF1493";
                color = 0xFF1493;
            }
            else if (channel == "moderator")
            {
                // Do not restyle ordinary moderator system notices.  A staff
                // announcement must contain an explicit rank or Server:(user).
                if (lower.indexOf("(") != 0)
                {
                    return null;
                }
                rank = "Moderator";
                colorHex = "FFCC33";
                color = 0xFFCC33;
            }
            else
            {
                return null;
            }

            if (cut > 0)
            {
                s = s.substr(cut);
            }

            // Already normalized form: Server: (username): message
            if (s.indexOf("(") == 0)
            {
                closeParen = s.indexOf("):");
                if (closeParen < 2)
                {
                    return null;
                }
                user = s.substring(1, closeParen);
                body = s.substr(closeParen + 2);
                while (body.length > 0 && body.charAt(0) == " ")
                {
                    body = body.substr(1);
                }
            }
            else
            {
                colon = s.indexOf(":");
                if (colon < 1)
                {
                    return null;
                }
                user = s.substr(0, colon);
                body = s.substr(colon + 1);
                while (body.length > 0 && body.charAt(0) == " ")
                {
                    body = body.substr(1);
                }
            }

            while (user.length > 0 && user.charAt(0) == " ")
            {
                user = user.substr(1);
            }
            while (user.length > 0 && user.charAt(user.length - 1) == " ")
            {
                user = user.substr(0, user.length - 1);
            }
            if (user.length < 1)
            {
                return null;
            }
            user = rootClass.strToProperCase(user);
            return {rank:rank, user:user, msg:body, colorHex:colorHex, color:color};
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
            var _local_10:Boolean;
            var _local_11:int;
            var _local_12:*;
            var _local_13:Object;
            var _local_14:String;
            var _local_15:*;
            var _local_16:*;
            var _local_17:*;
            var _local_18:*;
            var _local_19:*;
            var _local_20:*;
            var _local_21:*;
            var _local_22:*;
            var _local_23:*;
            var _local_24:*;
            var _local_25:*;
            var _local_26:*;
            var _local_27:*;
            var _local_28:*;
            var _local_29:String;
            var _local_30:Object;
            var _local_31:Boolean;
            var _local_32:int;
            if (rootClass.litePreference.data.bChatFilter)
            {
                if (((rootClass.litePreference.data.dOptions["disRed"]) && (_arg_1 == "warning")))
                {
                    _local_10 = true;
                    if (_arg_2.indexOf("You are out of range!") > -1)
                    {
                        _local_10 = false;
                    }
                    else
                    {
                        if (_arg_2.indexOf("is not ready yet.") > -1)
                        {
                            _local_10 = false;
                        }
                        else
                        {
                            if (_arg_2.indexOf("No target selected!") > -1)
                            {
                                _local_10 = false;
                            }
                            else
                            {
                                if (_arg_2.indexOf("Not enough mana!") > -1)
                                {
                                    _local_10 = false;
                                }
                            }
                        }
                    }
                    if (!_local_10)
                    {
                        return;
                    }
                }
            }
            var _local_7:Boolean;
            if (((!(ignoreList.data.users == null)) && (ignoreList.data.users.indexOf(_arg_3) > -1)))
            {
                return;
            }
            if (_arg_3 != "SERVER")
            {
                _local_11 = 0;
                _local_12 = rootClass.stripWhite(_arg_2.toLowerCase());
                _local_13 = nuProfanityCheck(_arg_2.toLowerCase());
                if (((!(_arg_3.toLowerCase() == rootClass.sfc.myUserName)) && (_arg_6 == 0)))
                {
                    _local_14 = _arg_2.replace(new RegExp("[^a-z]", "gi"), "");
                    if (strContains(_local_14.toLowerCase(), ["aqwtrade", "qwtrade", "qwtrde", "qwtrd", "aqwtrad", "aqwtrde", "aqwtrd", "edartwqa", "aqwpirate", "aqwolf"]))
                    {
                        return;
                    }
                    if (((strContains(_local_12, illegalStrings)) || (strContains(_local_12, unsendable))))
                    {
                        _local_11 = 1;
                    }
                    _local_12 = rootClass.stripWhiteStrict(_arg_2.toLowerCase());
                    if (strContains(_local_12, ["email", "password"]))
                    {
                        _local_11 = 1;
                    }
                    if (((_arg_1 == "whisper") && (modWhisperCheck(_arg_2) > 0)))
                    {
                        _local_7 = true;
                    }
                    if (_local_11)
                    {
                        return;
                    }
                }
                if (((_local_13.code) && (rootClass.uoPref.bProf)))
                {
                    _arg_2 = maskStringBetween(_arg_2, _local_13.indeces);
                }
                if (!rootClass.uoPref.bProf)
                {
                    _local_13 = nuProfanityCheck(_arg_2.toLowerCase(), true);
                    if (_local_13.code)
                    {
                        _arg_2 = maskStringBetween(_arg_2, _local_13.indeces);
                    }
                }
                _arg_2 = forceRemove(_arg_2);
            }
            var _local_8:* = "$({";
            var _local_9:* = "})$";
            startWindowTimer();
            if (((_arg_3.toLowerCase() == rootClass.sfc.myUserName) && (rootClass.world.myAvatar.objData.intActivationFlag == 1)))
            {
                pushMsg("warning", "Confirm your email at https://account.aq.com/ to protect your account and remove this message. ", "SERVER", "", 0);
            }
            if (isChannel(_arg_1))
            {
                if (_arg_1 == "zone" || _arg_1 == "world" || _arg_1 == "moderator" || _arg_1 == "admin" || _arg_1 == "administrator" || _arg_1 == "gm")
                {
                    _arg_3 = rootClass.strToProperCase(_arg_3);
                    if (((_arg_3 == "Eienyuki") && (_arg_6 == 1)))
                    {
                        popBubble("u:yorumi", ("Eienyuki: " + _arg_2), _arg_1);
                    }
                    else
                    {
                        popBubble(("u:" + _arg_3), _arg_2, _arg_1);
                    }
                }
                checkFieldsVPos();
                chatArray.push([_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, msgID, (('<font size="11" style="font-family:Arial;">' + format_time()) + "</font> ")]);
                msgID++;
                if (chatArray.length > lineLimit)
                {
                    chatArray.splice(0, (chatArray.length - lineLimit));
                }
                html2Fields("", "=", "server", 0);
                t1Arr = [];
                _local_15 = 0;
                while (_local_15 < chatArray.length)
                {
                    _local_16 = chatArray[_local_15][0];
                    _local_17 = chatArray[_local_15][1];
                    _local_18 = chatArray[_local_15][2];
                    _local_19 = chatArray[_local_15][3];
                    _local_20 = chatArray[_local_15][4];
                    _local_21 = int(chatArray[_local_15][5]);
                    _local_22 = (((rootClass.litePreference.data.bChatFilter) && (rootClass.litePreference.data.dOptions["timeStamps"])) ? chatArray[_local_15][6] : "");
                    _local_23 = '<font color="#';
                    _local_24 = '">';
                    _local_25 = "</font>";
                    _local_26 = ((chn[_local_16].tag == "") ? "" : (("[" + chn[_local_16].tag) + "] "));
                    _local_27 = _local_18;
                    _local_17 = _local_17.replace(regExpURL, "$({url,$&})$");
                    if (((!(_local_18 == null)) && (!(_local_18 == "SERVER"))))
                    {
                        _local_28 = ((((_local_8 + "user,") + _local_27) + _local_9) + ": ");
                    }
                    if (_local_18 == "SERVER")
                    {
                        _local_28 = "";
                    }
                    _local_30 = null;
                    _local_31 = false;
                    _local_32 = 0;

                    // Dedicated /iay marker created only by pushAeraIAY().
                    // It uses the neutral server channel, so normal moderator/admin
                    // chat can never be mistaken for an announcement.
                    if (((_local_16 == "server") && (String(_local_17).indexOf("__AERA_IAY__") == 0)))
                    {
                        _local_30 = aeraIAYMarkerInfo(String(_local_17));
                        if (_local_30 != null)
                        {
                            _local_26 = (("[" + _local_30.rank) + "] ");
                            _local_28 = (("Server: (" + _local_30.user) + "): ");
                            _local_17 = _local_30.msg;
                            _local_31 = true;
                            _local_32 = 3;
                        }
                    }

                    // Normal staff room chat.  Keep the original player-chat shape:
                    // [Rank] Username: message
                    if (((_local_16 == "zone") && (!(_local_18 == null)) && (!(_local_18 == "SERVER"))))
                    {
                        _local_30 = aeraStaffNameInfo(String(_local_18));
                        if (_local_30 != null)
                        {
                            _local_30.msg = _local_17;
                            _local_26 = (("[" + _local_30.rank) + "] ");
                            _local_27 = _local_30.user;
                            _local_28 = ((((_local_8 + "user,") + _local_27) + _local_9) + ": ");
                            _local_17 = _local_30.msg;
                            _local_31 = true;
                            _local_32 = 1;
                        }
                    }

                    // /iay is sent as a SERVER-authored raw moderator/admin message.
                    // Render only that path as [Rank] Server: (Username): message.
                    if (((_local_30 == null) && (_local_18 == "SERVER")))
                    {
                        _local_30 = aeraStaffServerInfo(String(_local_16), String(_local_17));
                        if (_local_30 != null)
                        {
                            _local_26 = (("[" + _local_30.rank) + "] ");
                            _local_28 = (("Server: (" + _local_30.user) + "): ");
                            _local_17 = _local_30.msg;
                            _local_31 = true;
                            _local_32 = 2;
                        }
                    }
                    if (_local_16 != "whisper")
                    {
                        if (_local_16 != "event")
                        {
                            if (_local_31)
                            {
                                html2Fields((_local_22 + '<font color="#' + _local_30.colorHex + '">' + _local_26 + '</font><font color="#FFFFFF">' + _local_28 + _local_17 + '</font><br>'), "+=", _local_16, _local_21);
                            }
                            else
                            {
                                html2Fields(((((((((_local_22 + _local_23) + chn[_local_16].col) + _local_24) + _local_26) + _local_28) + _local_17) + _local_25) + "<br>"), "+=", _local_16, _local_21);
                            }
                        }
                        else
                        {
                            html2Fields(((((((((((((((((_local_22 + _local_23) + "CCCCCC") + _local_24) + "*") + _local_23) + "FFFFFF") + _local_24) + _local_27) + _local_25) + _local_23) + "CCCCCC") + _local_24) + " ") + _local_17) + _local_25) + "*<br>"), "+=", _local_16, _local_21);
                        }
                    }
                    else
                    {
                        if (((_local_18 == rootClass.sfc.myUserName) || (isMyModHandle(_local_18))))
                        {
                            if (_local_20 == 0)
                            {
                                html2Fields(((((((((_local_22 + '<font color="#') + rootClass.modColor(chn[_local_16].col, "666666", "-")) + '">') + "To ") + _local_19) + ": ") + _local_17) + "</font><br>"), "+=", _local_16, _local_21);
                            }
                            else
                            {
                                html2Fields(((((((_local_22 + '<font color="#') + chn[_local_16].col) + '">From ') + _local_28) + _local_17) + "</font><br>"), "+=", _local_16, _local_21);
                            }
                        }
                        else
                        {
                            html2Fields(((((((_local_22 + '<font color="#') + chn[_local_16].col) + '">From ') + _local_28) + _local_17) + "</font><br>"), "+=", _local_16, _local_21);
                        }
                    }
                    _local_15++;
                }
                setFieldsVPos();
                writeText(panelIndex);
            }
            if (_local_7)
            {
                pushMsg("warning", (("<font color='#FFFFFF'>" + _arg_3) + "</font> IS NOT A MODERATOR.  DO NOT GIVE ACCOUNT INFORMATION TO OTHER PLAYERS."), "SERVER", "", 0);
                _local_29 = (("<font color='#FF0000'>WARNING</font><br/><font color='#FFFFFF'>" + _arg_3.toUpperCase()) + "</font><font color='#FFFFFF'> IS NOT A MODERATOR.<br/>Do not give account information to other players.<font>");
                _local_29 = (_local_29 + "<br/><a href='event:link::https://aq.com/safety.asp'><font color='#66CCFF'><u>Click here</u></font></a> to learn more.");
                rootClass.ui.ToolTip.openWith({
                    "str":_local_29,
                    "lowerright":true,
                    "invert":true,
                    "closein":10000
                });
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
            _local_2 = ((" " + removeHTML(cleanStr(_arg_1.toLowerCase()))) + " ");
            _local_2 = rootClass.stripMarks(_local_2);
            _local_2 = rootClass.stripDuplicateVowels(_local_2);
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
            _local_2 = rootClass.stripDuplicateVowels(removeHTML(cleanStr(_arg_1.toLowerCase())));
            _local_2 = rootClass.stripWhiteStrict(_local_2);
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
            _local_2 = rootClass.stripDuplicateVowels(removeHTML(cleanStr(_arg_1.toLowerCase())));
            _local_2 = rootClass.stripWhiteStrictB(_local_2);
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

        public function isChannel(_arg_1:String):Boolean
        {
            var _local_2:*;
            for (_local_2 in chn)
            {
                if (_local_2.toLowerCase() == _arg_1.toLowerCase())
                {
                    return (true);
                }
            }
            return (false);
        }

        private function isMyModHandle(_arg_1:String):Boolean
        {
            if (((_arg_1.split("-")[0] == "Moderator") && (int((_arg_1.split("-")[1] == rootClass.world.modID)))))
            {
                return (true);
            }
            return (false);
        }


    }
}//package 

// _SafeStr_1 = "goto" (String#4022)


