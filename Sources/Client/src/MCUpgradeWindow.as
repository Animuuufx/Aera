// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//MCUpgradeWindow

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class MCUpgradeWindow extends MovieClip 
    {

        public var btnClose2:SimpleButton;
        public var btnBuy:SimpleButton;
        public var btnClose:SimpleButton;
        public var txtBody:TextField;
        public var txtHrs:TextField;
        public var rootClass:*;
        public var iDiff:Number;
        public var iHrs:int;
        public var renewDate:String;
        public var iRemain:int;

        public function MCUpgradeWindow()
        {
            addFrameScript(0, frame1, 9, frame10, 18, frame19);
        }

        internal function frame1():*
        {
            rootClass = stage.getChildAt(0);
            iDiff = ((rootClass.date_server.getTime() - rootClass.world.myAvatar.objData.dCreated.getTime()) / 1000);
            iHrs = (iDiff / (60 * 60));
            if (((iHrs < 72) && (!(rootClass.world.myAvatar.isUpgraded()))))
            {
                gotoAndPlay("DragonHero");
            }
            else
            {
                if (rootClass.world.myAvatar.hasUpgraded())
                {
                    gotoAndPlay("Renew");
                };
            };
            stop();
        }

        internal function frame10():*
        {
            renewDate = rootClass.world.myAvatar.objData.dUpgExp.toDateString();
            txtBody.htmlText = (("Your Membership expired on " + renewDate) + ". Renew your account to get full access to AdventureQuest Worlds! Your upgrade will enable chat, allow you to equip pets, and give you access to exclusive items, areas, weapons, and more.");
            stop();
        }

        internal function frame19():*
        {
            iRemain = (72 - iHrs);
            if (iRemain > 1)
            {
                txtHrs.text = (iRemain + " hours");
            }
            else
            {
                txtHrs.text = (iRemain + " hour");
            };
            stop();
        }


    }
}//package 

