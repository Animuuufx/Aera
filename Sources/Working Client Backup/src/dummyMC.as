// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//dummyMC

package 
{
    import flash.display.MovieClip;
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
    import flash.desktop.*;
    import flash.globalization.*;
    import flash.net.drm.*;
    import flash.sensors.*;
    import flash.text.ime.*;
    import flash.text.engine.*;

    public dynamic class dummyMC extends MovieClip 
    {

        public var idlefoot:MovieClip;
        public var chest:MovieClip;
        public var frontthigh:MovieClip;
        public var cape:MovieClip;
        public var frontshoulder:MovieClip;
        public var head:MovieClip;
        public var backshoulder:MovieClip;
        public var hip:MovieClip;
        public var backthigh:MovieClip;
        public var backhair:MovieClip;
        public var backshin:MovieClip;
        public var robe:MovieClip;
        public var weapon:MovieClip;
        public var frontshin:MovieClip;
        public var backfoot:MovieClip;
        public var backrobe:MovieClip;
        public var frontfoot:MovieClip;
        public var backhand:MovieClip;
        public var fronthand:MovieClip;
        public var avtMC:*;
        public var rootClass:*;
        public var AssetClass:*;
        public var spellFX:*;
        public var rand:int;
        public var strSpell:String;
        public var spells:Array;

        public function dummyMC()
        {
            addFrameScript(0, this.frame1, 14, this.frame15, 19, this.frame20, 31, this.frame32, 40, this.frame41, 47, this.frame48, 59, this.frame60, 72, this.frame73, 84, this.frame85, 96, this.frame97, 111, this.frame112, 127, this.frame128, 136, this.frame137, 150, this.frame151);
        }

        public function showIdleFoot():*
        {
            this.frontfoot.visible = false;
            this.idlefoot.visible = true;
        }

        public function showFrontFoot():*
        {
            this.idlefoot.visible = false;
            this.frontfoot.visible = true;
        }

        internal function frame1():*
        {
            this.spells = new Array("sp_ea2", "sp_ea3", "sp_ed1", "sp_ee1", "sp_ee2", "sp_ef2", "sp_ef3", "sp_ef5", "sp_eh2", "sp_ei3", "sp_el2", "sp_ice2", "sp_sp1");
            this.showIdleFoot();
            stop();
        }

        internal function frame15():*
        {
            stop();
        }

        internal function frame20():*
        {
            if (this.onMove)
            {
                gotoAndPlay("Walk");
            };
        }

        internal function frame32():*
        {
            this.avtMC = MovieClip(parent);
            this.rootClass = this.avtMC.pAV.rootClass;
            this.rand = Math.round((Math.random() * 11));
            if (((this.rand > 0) && (this.rand < 4)))
            {
                this.AssetClass = (this.rootClass.world.getClass(("sp_chaos" + this.rand)) as Class);
                if (this.AssetClass != null)
                {
                    this.spellFX = new this.AssetClass();
                    this.spellFX.spellDur = 0;
                    this.rootClass.world.CHARS.addChild(this.spellFX);
                    this.spellFX.mouseEnabled = false;
                    this.spellFX.mouseChildren = false;
                    this.spellFX.visible = true;
                    this.spellFX.world = this.rootClass.world;
                    this.spellFX.strl = "sp_chaos1";
                    this.spellFX.tMC = this.avtMC.pAV.target.pMC;
                    this.spellFX.x = this.spellFX.tMC.x;
                    this.spellFX.y = (this.spellFX.tMC.y + 3);
                    if (this.spellFX.tMC.x < this.avtMC.x)
                    {
                        this.spellFX.scaleX = (this.spellFX.scaleX * -1);
                    };
                };
            };
        }

        internal function frame41():*
        {
            stop();
        }

        internal function frame48():*
        {
            this.avtMC = MovieClip(parent);
            this.rootClass = this.avtMC.pAV.rootClass;
            this.rand = Math.round((Math.random() * 11));
            if (((this.rand > 0) && (this.rand < 4)))
            {
                this.AssetClass = (this.rootClass.world.getClass(("sp_chaos" + this.rand)) as Class);
                if (this.AssetClass != null)
                {
                    this.spellFX = new this.AssetClass();
                    this.spellFX.spellDur = 0;
                    this.rootClass.world.CHARS.addChild(this.spellFX);
                    this.spellFX.mouseEnabled = false;
                    this.spellFX.mouseChildren = false;
                    this.spellFX.visible = true;
                    this.spellFX.world = this.rootClass.world;
                    this.spellFX.strl = "sp_chaos1";
                    this.spellFX.tMC = this.avtMC.pAV.target.pMC;
                    this.spellFX.x = this.spellFX.tMC.x;
                    this.spellFX.y = (this.spellFX.tMC.y + 3);
                    if (this.spellFX.tMC.x < this.avtMC.x)
                    {
                        this.spellFX.scaleX = (this.spellFX.scaleX * -1);
                    };
                };
            };
        }

        internal function frame60():*
        {
            stop();
        }

        internal function frame73():*
        {
            this.avtMC = MovieClip(parent);
            this.rootClass = this.avtMC.pAV.rootClass;
            this.strSpell = this.spells[Math.round((Math.random() * (this.spells.length - 1)))];
            this.AssetClass = (this.rootClass.world.getClass(this.strSpell) as Class);
            if (this.AssetClass != null)
            {
                this.spellFX = new this.AssetClass();
                this.spellFX.spellDur = 0;
                this.rootClass.world.CHARS.addChild(this.spellFX);
                this.spellFX.mouseEnabled = false;
                this.spellFX.mouseChildren = false;
                this.spellFX.visible = true;
                this.spellFX.world = this.rootClass.world;
                this.spellFX.strl = this.strSpell;
                this.spellFX.tMC = this.avtMC.pAV.target.pMC;
                this.spellFX.x = this.spellFX.tMC.x;
                this.spellFX.y = (this.spellFX.tMC.y + 3);
                if (this.spellFX.tMC.x < this.avtMC.x)
                {
                    this.spellFX.scaleX = (this.spellFX.scaleX * -1);
                };
            };
        }

        internal function frame85():*
        {
            stop();
        }

        internal function frame97():*
        {
            this.avtMC = MovieClip(parent);
            this.rootClass = this.avtMC.pAV.rootClass;
            this.strSpell = this.spells[Math.round((Math.random() * (this.spells.length - 1)))];
            this.AssetClass = (this.rootClass.world.getClass(this.strSpell) as Class);
            if (this.AssetClass != null)
            {
                this.spellFX = new this.AssetClass();
                this.spellFX.spellDur = 0;
                this.rootClass.world.CHARS.addChild(this.spellFX);
                this.spellFX.mouseEnabled = false;
                this.spellFX.mouseChildren = false;
                this.spellFX.visible = true;
                this.spellFX.world = this.rootClass.world;
                this.spellFX.strl = this.strSpell;
                this.spellFX.tMC = this.avtMC.pAV.target.pMC;
                this.spellFX.x = this.spellFX.tMC.x;
                this.spellFX.y = (this.spellFX.tMC.y + 3);
                if (this.spellFX.tMC.x < this.avtMC.x)
                {
                    this.spellFX.scaleX = (this.spellFX.scaleX * -1);
                };
            };
        }

        internal function frame112():*
        {
            stop();
        }

        internal function frame128():*
        {
            stop();
        }

        internal function frame137():*
        {
            stop();
        }

        internal function frame151():*
        {
            stop();
        }


    }
}//package 

