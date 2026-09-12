package liteAssets.draw
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class expeditionPanel extends Sprite
    {
        private var sender:Function;
        private var data:Object;
        private var compact:Boolean=false;
        private var notice:String="Loading expeditions...";
        public function expeditionPanel(send:Function)
        {
            sender=send;x=140;y=40;
            addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void { e.stopPropagation(); });
            render();
        }
        public function reset():void { visible=false;data=null;notice=""; }
        public function open():void { compact=false;visible=true;sender(["panel"]);render(); }
        public function update(packet:Object):void
        {
            var oldPhase:String=data!=null&&data.run!=null?String(data.run.phase):"";
            data=packet;notice=String(packet.message||"");
            if(data.run==null)compact=false;
            if(data.run!=null&&String(data.run.phase)!=oldPhase){compact=data.run.phase=="combat";visible=true;}
            if(notice.length>0){compact=false;visible=true;}
            render();
        }
        public function error(message:String):void { notice=message;compact=false;visible=true;render(); }
        private function text(value:String,left:int,top:int,width:int,height:int,size:int=13):void
        {
            var f:TextField=new TextField();f.defaultTextFormat=new TextFormat("Arial",size,0xEEE0C8);
            f.text=value;f.x=left;f.y=top;f.width=width;f.height=height;f.wordWrap=true;f.selectable=false;f.mouseEnabled=false;addChild(f);
        }
        private function button(label:String,left:int,top:int,width:int,action:Function):void
        {
            var b:Sprite=new Sprite();b.x=left;b.y=top;b.buttonMode=true;
            b.graphics.beginFill(0x3A3345);b.graphics.lineStyle(1,0xAC8E58);b.graphics.drawRoundRect(0,0,width,30,5);b.graphics.endFill();
            var f:TextField=new TextField();f.defaultTextFormat=new TextFormat("Arial",12,0xFFE2AB,true);f.text=label;f.width=width;f.height=25;f.y=5;f.mouseEnabled=false;b.addChild(f);
            b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void { action(); });addChild(b);
        }
        private function act(action:String,key:String=""):void
        {
            if(data==null||data.run==null)return;
            sender([action,data.run.id,data.run.depth,key]);
        }
        private function blessingButton(offer:Object,y:int):void
        {
            text(String(offer.text),20,y,500,39);
            button("Choose",550,y,105,function():void { act("choose",String(offer.key)); });
        }
        private function render():void
        {
            while(numChildren>0)removeChildAt(0);graphics.clear();
            graphics.beginFill(0x111521,0.97);graphics.lineStyle(1,0xAC8E58);graphics.drawRoundRect(0,0,680,compact?44:450,10);graphics.endFill();
            var r:Object=data!=null?data.run:null;
            if(compact){
                text("EXPEDITION | Room "+r.depth+" "+r.kind+" | "+r.modifier+" | "+r.bank+" Marks",12,10,555,28);
                button("Open",580,7,85,function():void { compact=false;render(); });return;
            }
            text("AERA EXPEDITIONS",20,12,450,32,22);
            button("Refresh",480,12,90,function():void { sender(["panel"]); });
            button(r!=null?"Minimize":"Close",580,12,80,function():void { if(r!=null){compact=true;render();}else visible=false; });
            if(data==null){text(notice,20,70,630,90);return;}
            text("Marks: "+data.marks+"  |  Weekly challenge: "+data.week,20,55,630,28);
            if(r==null){
                text("Clear randomized rooms, choose temporary powers and cash out your Marks.\nSolo / party: 10 rooms. Endless / weekly: survive as far as you can.\nDefeat, leaving or disconnecting pays half. All blessings expire on exit.",20,88,640,70);
                button("Solo",20,164,145,function():void { sender(["start","solo"]); });
                button("Party lobby",180,164,145,function():void { sender(["start","party"]); });
                button("Endless",340,164,145,function():void { sender(["start","endless"]); });
                button("Weekly solo",500,164,155,function():void { sender(["start","weekly"]); });
                button("Join party lobby",20,203,160,function():void { sender(["join"]); });
                text("WEEKLY LEADERS — deepest room, then fastest time",20,243,640,23,14);
                var rows:Array=data.leaders as Array;
                for(var i:int=0;rows!=null&&i<Math.min(5,rows.length);i++)text((i+1)+". "+rows[i].Name+"   Room "+rows[i].Depth+"   "+Math.round(Number(rows[i].ElapsedMs)/1000)+"s",20,270+i*23,640,23);
                if(rows==null||rows.length==0)text("No weekly results yet.",20,277,620,30);
            }else{
                text(String(r.mode).toUpperCase()+" | Room "+r.depth+" | "+r.kind+" | "+r.modifier,20,88,640,30,17);
                text("Bank: "+r.bank+" Marks each | Defeat / leave: "+r.failureMarks+" each\nParty: "+r.members.join(", "),20,121,640,47);
                if(r.phase=="lobby"){
                    text("Members opt in using Join party lobby. Up to four players.\nLaunch locks the roster. Any member can cash out; everyone must vote to continue.",20,177,640,60);
                    if(r.leader)button("Launch",20,260,160,function():void { act("launch"); });
                }else if(r.phase=="blessing"){
                    var offers:Array=r.offers as Array;
                    if(offers.length==0)text("Waiting for other players to choose their blessing...",20,177,640,50);
                    for(var j:int=0;j<offers.length;j++)blessingButton(offers[j],174+j*48);
                }else if(r.phase=="decision"){
                    text("Continue votes: "+r.votes+" / "+r.members.length+"\nThe next room increases difficulty and adds more Marks to the bank.",20,177,640,60);
                    button("Continue",20,260,160,function():void { act("continue"); });
                }else text("Defeat every enemy in this room. Fallen party members return after a surviving teammate clears it.\n"+modifierText(String(r.modifier)),20,177,640,95);
                if(r.phase=="blessing"||r.phase=="decision")button("Cash out party",200,326,170,function():void { act("cashout"); });
                button(r.phase=="lobby"?"Cancel lobby":"Leave (half Marks)",20,326,170,function():void { act("leave"); });
                var powers:String="";for(var key:String in r.blessings)powers+=key+" x"+r.blessings[key]+"   ";
                text("Your blessings: "+(powers.length>0?powers:"none yet"),20,367,640,40,12);
            }
            text(notice,20,412,640,34,12);
        }
        private function modifierText(value:String):String
        {
            if(value=="Blood Moon")return "Enemies deal 30% more damage.";
            if(value=="Titan")return "Enemies have twice their normal health.";
            if(value=="Glass Cannon")return "Players and enemies deal 50% more damage.";
            if(value=="Swarm")return "Normal and elite rooms contain twice as many enemies.";
            if(value=="Mana Drought")return "Lose 2% maximum mana each second.";
            return "No additional room modifier.";
        }
    }
}
