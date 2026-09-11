// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//org.sepy.ColorPicker.NoColorButton

package org.sepy.ColorPicker
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;

    public class NoColorButton extends MovieClip 
    {

        public function NoColorButton()
        {
            addFrameScript(0, frame1);
            useHandCursor = false;
            this.addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OUT, onRollOut, false, 0, true);
            this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onRollOver(_arg_1:MouseEvent):void
        {
            gotoAndStop(2);
        }

        private function onRollOut(_arg_1:MouseEvent):void
        {
            gotoAndStop(1);
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            MovieClip(parent.parent).click(this);
        }

        internal function frame1():*
        {
            stop();
        }


    }
}//package org.sepy.ColorPicker

