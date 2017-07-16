package;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import Player;

using flixel.util.FlxCollision;
using flixel.util.FlxSpriteUtil;

class VisionFunctions
{

    public static var pts:Array<FlxPoint> = [
            for(x in 0...360)
                {
                    FlxPoint.get(
                        Math.cos(x*Math.PI/180), 
                        Math.sin(x*Math.PI/180));
                }];

	public static inline function polar(a:FlxPoint,b:FlxPoint):Float
    {
        var x = b.x-a.x;
        var y = b.y-a.y;
        var ang = Math.atan(y/x)*(180/Math.PI);
        a.putWeak();
        b.putWeak();

        if (x == 0 || y == 0)
        {
                if (x > 0) ang=0;
                if (y > 0) ang=90;
                if (x < 0) ang=180;
                if (y < 0) ang=270;
        }
        else if (x < 0 && y > 0 || x < 0 && y < 0) ang=180+ang;
        else if (x > 0 && y < 0) ang=360+ang;
        return ang;
    }

    public static inline function exploredMap(point:FlxPoint, map:FlxTilemap)
    {
        var tileWidth = map.width/map.widthInTiles;
        var tileHeight = map.height/map.heightInTiles;
        if (map.getTile(Math.floor(point.x/tileWidth),Math.floor(point.y/tileHeight))==2)
        {
            map.setTileByIndex(
                    Math.floor(point.y/tileHeight) *
                    map.widthInTiles +
                    Math.floor(point.x/tileWidth), 3,true);
        }
        point.putWeak();
    }

    static public function extendPoint(origin:FlxPoint, point:FlxPoint, ext:Float):FlxPoint
    {
        var radius:Float    = Math.sqrt(Math.pow(point.x-origin.x,2)+Math.pow(point.y-origin.y,2))+ext;
        var angle:Float     = polar(origin,point)*(Math.PI/180);
        var extPoint        = FlxPoint.weak(
            radius*Math.cos(angle)+origin.x,
            radius*Math.sin(angle)+origin.y);
        return extPoint;
    }

    static public function insertionSortAngles(o:FlxPoint, a:Array<FlxPoint>)
    {
        for (j in 0...a.length)
        {
            var key = a[j];
            var i = j-1;
            while(i > -1 && polar(o, a[i]) > polar(o, key))
            {
                a[i+1] = a[i];
                i -= 1;
            }
            a[i+1] = key;
        }
        a.push(o);
        return(a);
    }

    static public function insertionSort(a:Array<Int>)
    {
        for (j in 0...a.length)
        {
            var key = a[j];
            var i = j-1;
            while(i > -1 && a[i] > key)
            {
                a[i+1] = a[i];
                i -= 1;
            }
            a[i+1] = key;
        }
        return(a);
    }

    static public function getIntersection(
        Start:FlxPoint, End:FlxPoint, ?Result:FlxPoint, Resolution:Float = 1, map:FlxTilemap):Bool
    {
        var _scaledTileWidth = map.width/map.widthInTiles;
        var _scaledTileHeight = map.height/map.heightInTiles;

        var step:Float = _scaledTileWidth;
        
        if (_scaledTileHeight < _scaledTileWidth)
            step = _scaledTileHeight;
        
        step /= Resolution;
        var deltaX:Float = End.x - Start.x;
        var deltaY:Float = End.y - Start.y;
        var distance:Float = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
        var steps:Int = Math.ceil(distance / step);
        var stepX:Float = deltaX / steps;
        var stepY:Float = deltaY / steps;
        var curX:Float = Start.x - stepX;
        var curY:Float = Start.y - stepY;

        var tileX:Int;
        var tileY:Int;
        var i:Int = 0;
        
        Start.putWeak();
        End.putWeak();
        
        while (i < steps)
        {
            curX += stepX;
            curY += stepY;
            
            if ((curX < 0) || (curX > map.width) || (curY < 0) || (curY > map.height))
            {
                i++;
                continue;
            }
            
            tileX = Math.floor(curX / _scaledTileWidth);
            tileY = Math.floor(curY / _scaledTileHeight);

            if ( map.getTileCollisions(
                map.getTileByIndex(tileY*map.widthInTiles+tileX)) != FlxObject.NONE)
            {
                // Some basic helper stuff
                tileX *= Std.int(_scaledTileWidth);
                tileY *= Std.int(_scaledTileHeight);
                var rx:Float = 0;
                var ry:Float = 0;
                var q:Float;
                var lx:Float = curX - stepX;
                var ly:Float = curY - stepY;
                
                // Figure out if it crosses the X boundary
                q = tileX;
                
                if (deltaX < 0)
                {
                    q += _scaledTileWidth;
                }
                
                rx = q;
                ry = ly + stepY * ((q - lx) / stepX);
                
                if ((ry >= tileY) && (ry <= tileY + _scaledTileHeight))
                {
                    if (Result == null)
                    {
                        Result = FlxPoint.get();
                    }
                    
                    Result.set(rx, ry);
                    return false;
                }
                
                // Else, figure out if it crosses the Y boundary
                q = tileY;
                
                if (deltaY < 0)
                {
                    q += _scaledTileHeight;
                }
                
                rx = lx + stepX * ((q - ly) / stepY);
                ry = q;
                
                if ((rx >= tileX) && (rx <= tileX + _scaledTileWidth))
                {
                    if (Result == null)
                    {
                        Result = FlxPoint.get();
                    }
                    
                    Result.set(rx, ry);
                    return false;
                }
                
                return true;
            }
            i++;
        }
        
        return true;
    }

    static public function entityVision(map:FlxTilemap, p:Dynamic, canvas:FlxSprite)
    {
        if (p.alive && p.exists)
        {
            var ip:FlxPoint             = FlxPoint.weak();
            var b:FlxPoint              = FlxPoint.get(p.x+p.o,p.y+p.o);
            var polygon:Array<FlxPoint> = [];
            var start:Int               = Std.int(p.ang-(p.fieldOfVision/2));

            for(x in 0...p.fieldOfVision)
            {
                    if (start >= 360) start = start - 360;
                    if (start < 0) start = 360 + start;
                    if (!getIntersection(
                        FlxPoint.weak(b.x, b.y), 
                        FlxPoint.weak(
                            pts[start].x*p.visionRange+b.x,
                            pts[start].y*p.visionRange+b.y),ip,10,map))
                    {
                        polygon.push(FlxPoint.weak(ip.x, ip.y));
                        if(Type.getClass(p) == Player) exploredMap(extendPoint(b, ip, 5), map);
                    }
                    else
                    {
                        var a = FlxPoint.weak(
                        b.x+pts[start].x*p.visionRange,
                        b.y+pts[start].y*p.visionRange);

                        polygon.push(a);

                    }
                    start++;
            }
            polygon.push(FlxPoint.weak(b.x, b.y));
            if(Type.getClass(p) == Enemy) canvas.drawPolygon(polygon, p.alert, p.lineStyle);
            else canvas.drawPolygon(polygon, FlxColor.WHITE, p.lineStyle);
            b.putWeak();
            ip.putWeak();
        }
    }
}