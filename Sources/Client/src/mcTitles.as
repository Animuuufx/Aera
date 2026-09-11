package {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

import utils.ScrollHandler;

public class mcTitles extends MovieClip {

    private var rootClass:Game = Game.root;
    public var selected:TitleListItem;

    public var data:Object = {};

    public var btnClose:SimpleButton;
    public var btnAction:SimpleButton;

    public var displayLists:MovieClip;
    public var cntMask:MovieClip;

    public var tLoading:TextField;
    public var tTitleDesc:TextField;
    public var tStats:TextField;
    public var tAction:TextField;

    public var scr:MovieClip;
    public var scrollHandler:ScrollHandler;

    public function mcTitles() {
        selected = null;

        tLoading.visible = true;

        tLoading.mouseEnabled = false;
        tAction.mouseEnabled = false;
        tTitleDesc.mouseEnabled = false;
        tStats.mouseEnabled = false;

        tAction.visible = false;
        btnAction.visible = false;

        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnAction.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        rootClass.sfc.sendXtMessage("zm", "loadTitles", [], "str");
    }

    public function initLists() : void {
        rootClass.onRemoveChildrens(displayLists);

        for each (var o:Object in data) {
            var item:TitleListItem = new TitleListItem();
            item.name = "title-" + o.id;
            item.tTitle.text = o.Name;

//          HERE YOU CAN USE THE TITLE COLOR
//            item.tTitle.textColor = o.Color;

            item.tTitle.textColor = 0x999999;
            item.data = o;
            item.buttonMode = true;
            item.addEventListener(MouseEvent.CLICK, onTitleClick, false, 0, true);
            item.y = item.height * displayLists.numChildren;
            displayLists.addChild(item);
        }

        if (displayLists.numChildren < 1) {
            tLoading.text = "No Titles";
            tLoading.visible = true;
        } else {
            scrollHandler = new ScrollHandler(cntMask, displayLists, scr, 120);
            scrollHandler.open();
            tLoading.visible = false;
        }
    }

    public function updateActionText() : void {
        tAction.text = rootClass.world.myAvatar.objData.title != null && rootClass.world.myAvatar.objData.title.id == selected.data.id ? "Unequip" : "Equip";
    }

    private function onTitleClick (event:MouseEvent) : void {
        if (selected != null)  selected.tTitle.textColor = 0x999999;

        selected = TitleListItem(event.currentTarget);
        selected.tTitle.textColor = 0xFFFFFF;

        var data:Object = selected.data;
        tTitleDesc.text = data.Description;
        tStats.htmlText = "Strength: " + data.Strength + "\nIntellect: " + data.Intellect + "\nEndurance: " + data.Endurance + "\nDexterity: " + data.Dexterity + "\nLuck: " + data.Luck;

        tAction.visible = true;
        btnAction.visible = true;

        updateActionText();
    }

    private function onClick(event:MouseEvent) : void {
        switch (event.currentTarget.name) {
            case "btnAction":
                if (selected == null || !rootClass.world.coolDown("updateTitle")) return;
                rootClass.sfc.sendXtMessage("zm", "updateTitle", [selected.data.id, tAction.text.toLowerCase()], "str");
                break;
            case "btnClose":
                if (scrollHandler != null) scrollHandler.close();
                MovieClip(parent).onClose();
                break;
        }
    }

}

}
