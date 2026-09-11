package liteAssets
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /** Uses map floor geometry rather than monster pads. The server seed keeps players in sync. */
    public class RiftSpawnPoint
    {
        public static function floors(map:DisplayObjectContainer):Array
        {
            var result:Array=[];
            if(map==null)return result;
            for(var i:int=0;i<map.numChildren;i++){
                var child:DisplayObject=map.getChildAt(i);
                if(child is MovieClip && "isFloor" in child && Boolean(Object(child).isFloor))result.push(child);
            }
            return result;
        }
        public static function choose(map:DisplayObjectContainer,space:DisplayObjectContainer,seed:uint):Point
        {
            var surfaces:Array=floors(map);
            if(surfaces.length==0||space==null)return null;
            var state:uint=seed==0?1:seed;
            var nextSeededValue:Function=function():Number { state^=state<<13;state^=state>>>17;state^=state<<5;return Number(state)/4294967296; };
            for(var attempt:int=0;attempt<256;attempt++){
                var surface:DisplayObject=surfaces[int(nextSeededValue()*surfaces.length)];
                var bounds:Rectangle=surface.getBounds(space);
                var point:Point=new Point(bounds.x+nextSeededValue()*bounds.width,bounds.y+nextSeededValue()*bounds.height);
                var global:Point=space.localToGlobal(point);
                if(surface.hitTestPoint(global.x,global.y,true))return point;
            }
            // Do not put an unreachable monster at arbitrary coordinates if a map has no usable floor.
            return null;
        }
    }
}
