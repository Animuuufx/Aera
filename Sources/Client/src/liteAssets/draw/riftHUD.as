package liteAssets.draw
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;

    /** Server-owned progress; buttons only request travel or material turn-in. */
    public class riftHUD extends Sprite
    {
        private var sendCommand:Function;
        private var label:TextField = new TextField();
        private var bar:Sprite = new Sprite();
        public function riftHUD(commandSender:Function)
        {
            sendCommand=commandSender;
            graphics.beginFill(0x111224,0.94);graphics.drawRoundRect(0,0,360,106,10);graphics.endFill();
            label.defaultTextFormat=new TextFormat("Arial",12,0xFFFFFF);
            label.width=350;label.height=70;label.x=8;label.y=5;label.selectable=false;
            addChild(label);bar.x=8;bar.y=72;addChild(bar);
            button("Travel to Rift",8,"join");button("Deposit materials",170,"deposit");
            x=300;y=52;visible=false;
        }
        private function button(caption:String,left:int,command:String):void
        {
            var b:Sprite=new Sprite();b.x=left;b.y=84;b.buttonMode=true;
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",12,0xE7C277,true);
            t.text=caption;t.width=175;t.height=20;t.mouseEnabled=false;b.addChild(t);
            b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
                if (sendCommand != null) sendCommand(command);
            });addChild(b);
        }
        public function update(state:Object):void
        {
            visible=Boolean(state.active);if(!visible)return;
            var pct:int=Math.max(0,Math.min(100,int(state.progress)));
            label.text=state.tier+" "+state.modifier+" RIFT — "+state.map+"\n"+
                state.phase+"  "+pct+"%  ·  "+state.players+" contributors";
            if(state.phase=="objectives")label.appendText("\nCrystals "+state.crystals+"/"+state.crystalGoal+" · Materials "+state.materials+"/"+state.materialGoal+"\n"+state.defenseFrame+": "+state.defense+"/"+state.defenseGoal+"s · Ward "+state.wardHp+"%");
            if(state.phase=="commander")label.appendText("\nCommander HP: "+state.bossHp+" / "+state.bossMax);
            bar.graphics.clear();bar.graphics.beginFill(0x353447);bar.graphics.drawRect(0,0,344,6);bar.graphics.endFill();
            bar.graphics.beginFill(state.tier=="Legendary"?0xE7C277:0xA26BEB);bar.graphics.drawRect(0,0,344*pct/100,6);bar.graphics.endFill();
        }
    }
}
