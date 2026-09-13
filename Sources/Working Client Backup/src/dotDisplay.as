// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//dotDisplay

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

    public dynamic class dotDisplay extends MovieClip 
    {

        public var t:MovieClip;
        public var hpDisplay:int;
        public var randNum:Number;

        public function dotDisplay()
        {
            addFrameScript(0, this.frame1, 2, this.frame3, 18, this.frame19, 24, this.frame25, 46, this.frame47, 50, this.frame51, 69, this.frame70, 74, this.frame75, 95, this.frame96, 99, this.frame100, 125, this.frame126, 129, this.frame130, 150, this.frame151, 155, this.frame156, 184, this.frame185, 190, this.frame191, 211, this.frame212, 216, this.frame217, 242, this.frame243, 246, this.frame247, 267, this.frame268);
        }

        public function init():void
        {
            if (this.randNum < 0)
            {
                this.randNum = Math.random();
            };
            if (this.randNum <= 0.1)
            {
                gotoAndPlay("dot1");
            }
            else
            {
                if (((this.randNum <= 0.2) && (this.randNum > 0.1)))
                {
                    gotoAndPlay("dot2");
                }
                else
                {
                    if (((this.randNum <= 0.3) && (this.randNum > 0.2)))
                    {
                        gotoAndPlay("dot3");
                    }
                    else
                    {
                        if (((this.randNum <= 0.4) && (this.randNum > 0.3)))
                        {
                            gotoAndPlay("dot4");
                        }
                        else
                        {
                            if (((this.randNum <= 0.5) && (this.randNum > 0.4)))
                            {
                                gotoAndPlay("dot5");
                            }
                            else
                            {
                                if (((this.randNum <= 0.6) && (this.randNum > 0.5)))
                                {
                                    gotoAndPlay("dot6");
                                }
                                else
                                {
                                    if (((this.randNum <= 0.7) && (this.randNum > 0.6)))
                                    {
                                        gotoAndPlay("dot7");
                                    }
                                    else
                                    {
                                        if (((this.randNum <= 0.8) && (this.randNum > 0.7)))
                                        {
                                            gotoAndPlay("dot8");
                                        }
                                        else
                                        {
                                            if (((this.randNum <= 0.9) && (this.randNum > 0.8)))
                                            {
                                                gotoAndPlay("dot9");
                                            }
                                            else
                                            {
                                                if (((this.randNum <= 1) && (this.randNum > 0.9)))
                                                {
                                                    gotoAndPlay("dot10");
                                                }
                                                else
                                                {
                                                    gotoAndPlay("dot1");
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function setText():void
        {
            if (this.hpDisplay > 0)
            {
                this.t.ti.textColor = 0xEE9900;
            };
            this.t.ti.text = Math.abs(this.hpDisplay);
        }

        internal function frame1():*
        {
            this.randNum = -1;
            stop();
        }

        internal function frame3():*
        {
            this.setText();
        }

        internal function frame19():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame25():*
        {
            this.setText();
        }

        internal function frame47():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame51():*
        {
            this.setText();
        }

        internal function frame70():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame75():*
        {
            this.setText();
        }

        internal function frame96():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame100():*
        {
            this.setText();
        }

        internal function frame126():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame130():*
        {
            this.setText();
        }

        internal function frame151():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame156():*
        {
            this.setText();
        }

        internal function frame185():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame191():*
        {
            this.setText();
        }

        internal function frame212():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame217():*
        {
            this.setText();
        }

        internal function frame243():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }

        internal function frame247():*
        {
            this.setText();
        }

        internal function frame268():*
        {
            try
            {
                MovieClip(parent).removeChild(this);
            }
            catch(e)
            {
            };
            stop();
        }


    }
}//package 

