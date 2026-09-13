package {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

public class mcRedeem extends MovieClip {

    private var rootClass:Game = Game.root;
    public var btnRedeem:SimpleButton;
    public var btnClose:SimpleButton;
    public var tCode:TextField;

    public function mcRedeem() {
        btnRedeem.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private function fClose() : void {
        var mc:MovieClip;
        if (parent != null){
            mc = MovieClip(parent);
            mc.removeChild(this);
            mc.onClose();
        }
    }

    private function onClick(event:MouseEvent) : void {
        switch (event.currentTarget.name) {
            case "btnRedeem":
                if (tCode.text.length < 1) {
                    rootClass.MsgBox.notify("Please insert a code!");
                } else {
                    rootClass.sfc.sendXtMessage("zm", "redeemCode", [tCode.text], "str", rootClass.world.curRoom);
                    fClose();
                }
                break;
            case "btnClose":
                fClose();
                break;
        }
    }

}

}
