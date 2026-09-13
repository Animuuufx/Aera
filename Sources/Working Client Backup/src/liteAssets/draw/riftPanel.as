package liteAssets.draw
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class riftPanel extends Sprite
    {
        private var sendCommand:Function;
        private var content:Sprite = new Sprite();
        private var data:Object;
        private var tab:int=0;
        private var historyPage:int=0;
        private var shopPage:int=0;
        private var selected:int=0;
        private var pending:Boolean=false;
        private var notice:String="Loading your Rift data...";
        private var timer:Timer = new Timer(5000);

        public function riftPanel(sender:Function)
        {
            sendCommand=sender;x=160;y=50;
            graphics.beginFill(0x10141E,0.98);graphics.lineStyle(1,0xA68547);
            graphics.drawRoundRect(0,0,640,430,12);graphics.endFill();
            // Keep clicks on the panel from reaching map click handlers.
            addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void { e.stopPropagation(); });
            addChild(content);
            timer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void { if(visible&&!pending)requestData(); });
            render();
        }
        public function refresh():void
        {
            pending=false;selected=0;timer.start();requestData();
        }
        private function requestData():void { if(sendCommand!=null)sendCommand(["panel",historyPage,shopPage]); }
        public function reset():void
        {
            timer.stop();visible=false;data=null;tab=0;historyPage=0;shopPage=0;selected=0;pending=false;
            notice="Loading your Rift data...";render();
        }
        public function update(packet:Object):void
        {
            data=packet;
            if(data.available){historyPage=int(data.historyPage);shopPage=int(data.shopPage);if(notice=="Loading your Rift data...")notice="";}
            else notice="Rifts are not available on this server yet.";
            if(visible)render();
        }
        public function updateActive(state:Object):void
        {
            if(data==null)return;
            data.active=state;
            if(visible&&tab==0)render();
        }
        public function purchaseResult(result:Object):void
        {
            pending=false;selected=0;notice=String(result.message);if(visible)render();
        }
        private function text(value:String,left:int,top:int,width:int,height:int,size:int=13,color:uint=0xDDDDDD):void
        {
            var f:TextField=new TextField();f.defaultTextFormat=new TextFormat("Arial",size,color);
            f.text=value;f.x=left;f.y=top;f.width=width;f.height=height;f.wordWrap=true;f.selectable=false;f.mouseEnabled=false;content.addChild(f);
        }
        private function button(label:String,left:int,top:int,width:int,action:Function,enabled:Boolean=true):void
        {
            var b:Sprite=new Sprite();b.x=left;b.y=top;b.buttonMode=enabled;
            b.graphics.beginFill(enabled?0x42342A:0x242731);b.graphics.lineStyle(1,enabled?0xAB864A:0x40434C);b.graphics.drawRoundRect(0,0,width,27,4);b.graphics.endFill();
            var f:TextField=new TextField();f.defaultTextFormat=new TextFormat("Arial",12,enabled?0xFFE0A0:0x888888,true);f.text=label;f.width=width;f.height=23;f.y=4;f.selectable=false;f.mouseEnabled=false;b.addChild(f);
            if(enabled)b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void { action(); });content.addChild(b);
        }
        private function number(value:*):String { return String(value==null?0:value).replace(/\B(?=(\d{3})+(?!\d))/g,","); }
        private function chooseTab(value:int):void { tab=value;selected=0;notice="";render();requestData(); }
        private function render():void
        {
            while(content.numChildren>0)content.removeChildAt(0);
            text("AERA RIFTS",20,12,300,30,22,0xE7C277);
            button("Refresh",462,15,80,function():void { requestData(); },!pending);
            button("Close",550,15,70,function():void { visible=false;timer.stop(); });
            button("Overview",20,55,115,function():void { chooseTab(0); },!pending);
            button("History",145,55,115,function():void { chooseTab(1); },!pending);
            button("Rift Shop",270,55,115,function():void { chooseTab(2); },!pending);
            text("Shards: "+number(data!=null&&data.available?data.wallet.Shards:0),410,55,215,26,17,0xE7C277);
            if(data==null||!data.available){text(notice,20,105,600,80);return;}
            if(tab==0)overview();else if(tab==1)history();else shop();
            text(pending?"Purchasing...":notice,20,386,600,38,12,0xE7C277);
        }
        private function overview():void
        {
            var w:Object=data.wallet;var t:Object=data.totals;var c:Object=data.contribution;var a:Object=data.active;
            text("YOUR RECORD",20,98,280,24,14,0xE7C277);
            text("Rifts closed: "+number(w.RiftsClosed)+"\nLegendary Rifts closed: "+number(w.LegendaryClosed)+"\nCommanders defeated: "+number(w.BossesDefeated)+"\nHighest contribution: "+number(w.HighestContribution)+"\nShards earned: "+number(t.Earned)+"   Spent: "+number(data.spent),20,127,305,110);
            text("COMPLETED EVENT TOTALS",335,98,280,24,14,0xE7C277);
            text("Damage dealt: "+number(t.Damage)+"\nMonsters killed: "+number(t.Kills)+"\nObjective contributions: "+number(t.Objectives),335,127,285,100);
            text("CURRENT RIFT",20,242,600,24,14,0xE7C277);
            if(a.active){
                text(a.tier+" "+a.modifier+" — "+a.map+" | "+a.phase+" "+a.progress+"%\nYour damage: "+number(c.damage)+" | Kills: "+number(c.kills)+" | Objectives: "+number(c.objectives)+"\nMaterials carried: "+number(c.materials)+" | Defense cell: "+a.defenseFrame,20,267,600,68);
                button("Travel to Rift",20,346,150,function():void { sendCommand(["join"]); });
                button("Deposit materials",185,346,160,function():void { sendCommand(["deposit"]);requestData(); });
            }else text("No active Rift. Your records and shard shop are always available.",20,270,600,60);
        }
        private function history():void
        {
            text("YOUR COMPLETED RIFTS",20,96,600,25,14,0xE7C277);
            var rows:Array=data.history as Array;
            if(rows.length==0)text("Defeat a Rift Commander to earn your first contribution reward.",20,140,600,60);
            for(var i:int=0;i<rows.length;i++){
                var r:Object=rows[i];var y:int=126+i*35;
                text(r.Map+" · "+r.Tier+" "+r.Modifier+" · "+r.Medal+" · +"+number(r.Shards)+" shards",20,y,600,19,12,0xE7C277);
                text(String(r.EndedAt)+" | Score "+number(r.Score)+" | Damage "+number(r.Damage)+" | Kills "+number(r.Kills)+" | Objectives "+number(r.Objectives),20,y+17,600,18,11);
            }
            button("Previous",20,346,95,function():void { historyPage--;requestData(); },historyPage>0);
            text("Page "+(historyPage+1)+" / "+data.historyPages,130,349,150,24);
            button("Next",285,346,95,function():void { historyPage++;requestData(); },historyPage+1<int(data.historyPages));
        }
        private function shop():void
        {
            text("SPEND RIFT SHARDS",20,96,600,25,14,0xE7C277);
            var rows:Array=data.shop as Array;
            if(rows.length==0)text("No rewards have been listed yet. Check back soon.",20,140,600,60);
            for(var i:int=0;i<rows.length;i++)shopRow(rows[i],126+i*35);
            button("Previous",20,346,95,function():void { shopPage--;selected=0;requestData(); },!pending&&shopPage>0);
            text("Page "+(shopPage+1)+" / "+data.shopPages,130,349,150,24);
            button("Next",285,346,95,function():void { shopPage++;selected=0;requestData(); },!pending&&shopPage+1<int(data.shopPages));
        }
        private function shopRow(row:Object,top:int):void
        {
            text(row.Name+" ×"+row.Quantity,20,top,315,20,13);
            text(row.Type+" · Lv "+row.Level,20,top+17,315,17,11,0xAAAAAA);
            text(number(row.Cost)+" shards",338,top+5,165,24,13,0xE7C277);
            button(selected==int(row.id)?"Confirm":"Buy",510,top,105,function():void {
                if(selected!=int(row.id)){selected=int(row.id);notice="Confirm purchase of "+row.Name+" for "+number(row.Cost)+" shards.";render();return;}
                pending=true;render();sendCommand(["buy",row.id,data.token,historyPage,shopPage]);
            },!pending&&Number(data.wallet.Shards)>=Number(row.Cost));
        }
    }
}
