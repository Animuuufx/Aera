// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//spider_fla.mcReport_390

package spider_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.events.Event;
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

    public dynamic class mcReport_390 extends MovieClip 
    {

        public var submit:MovieClip;
        public var btnClose:SimpleButton;
        public var tDesc:TextField;
        public var bg:MovieClip;
        public var i0:MovieClip;
        public var i1:MovieClip;
        public var ti:TextField;
        public var i2:MovieClip;
        public var i3:MovieClip;
        public var iSel:*;
        public var mc:*;
        public var defaultDesc:String;
        public var tDetailTemplate:*;
        public var rootClass:MovieClip;

        public function mcReport_390()
        {
            addFrameScript(0, frame1, 4, frame5, 9, frame10, 14, frame15, 19, frame20);
        }

        public function itemClick(_arg_1:MouseEvent):*
        {
            iSel = int(MovieClip(_arg_1.currentTarget).name.substr(1));
            var _local_2:* = 0;
            while (_local_2 < 4)
            {
                if (mc[("i" + _local_2)] != null)
                {
                    mc[("i" + _local_2)].d.f1.visible = (_local_2 == iSel);
                };
                _local_2++;
            };
            mc.submit.visible = true;
            if (((((tDetailTemplate.indexOf(tDesc.text) > -1) || (tDesc.text == defaultDesc)) || (tDesc.text == " ")) || (tDesc.text == "")))
            {
                tDesc.text = tDetailTemplate[iSel];
            };
        }

        public function submitClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(stage.getChildAt(0));
            var _local_3:* = MovieClip(parent);
            var _local_4:* = " ";
            if (((tDesc.text.length > 3) && (!(tDesc.text == defaultDesc))))
            {
                _local_4 = tDesc.text;
            };
            _local_2.world.sendReport(["reportlang", _local_3.fData.unm, iSel, _local_4]);
            _local_3.onClose(null);
        }

        public function onClose(_arg_1:Event=null):void
        {
            if (MovieClip(parent).currentLabel != "Init")
            {
                rootClass.mixer.playSound("Click");
                MovieClip(parent).gotoAndPlay("Init");
            };
        }

        internal function frame1():*
        {
            iSel = -1;
            mc = MovieClip(this);
            defaultDesc = "Type reason for report here.";
            tDetailTemplate = [defaultDesc, defaultDesc, defaultDesc, defaultDesc];
            rootClass = (stage.getChildAt(0) as MovieClip);
            gotoAndPlay("full");
        }

        internal function frame5():*
        {
            i0.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
            i1.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
            i2.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
            i3.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
            submit.addEventListener(MouseEvent.CLICK, submitClick, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            i0.buttonMode = true;
            i1.buttonMode = true;
            i2.buttonMode = true;
            i3.buttonMode = true;
            submit.buttonMode = true;
            i0.d.f1.visible = false;
            i1.d.f1.visible = false;
            i2.d.f1.visible = false;
            i3.d.f1.visible = false;
            submit.visible = false;
            ti.text = MovieClip(parent).fData.unm;
        }

        internal function frame10():*
        {
            stop();
        }

        internal function frame15():*
        {
            i1.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
            submit.addEventListener(MouseEvent.CLICK, submitClick, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            i1.buttonMode = true;
            submit.buttonMode = true;
            i1.d.f1.visible = false;
            submit.visible = false;
            ti.text = MovieClip(parent).fData.unm;
        }

        internal function frame20():*
        {
            stop();
        }


    }
}//package spider_fla

