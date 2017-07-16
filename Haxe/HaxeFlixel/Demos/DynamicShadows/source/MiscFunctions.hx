import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import Math.floor;

class MiscFunctions
{
    public static function checkCollision(map:FlxTilemap, obj:FlxObject):Void
    {
    	tileWidth = map.width / map.widthInTiles;
    	tileHeight = map.height / map.heightInTiles;
    	var x:Int = Math.floor(FlxG.mouse.x/tileWidth);
        var y:Int = Math.floor(FlxG.mouse.y/tileHeight);

        if (FlxG.mouse.justPressed)
        {
                trace(x, y);
                trace('index point: ${y*map.widthInTiles+x}');
                trace(map.getTileCollisions(map.getTileByIndex(y*map.widthInTiles+x)));
        }
    }

    public function visionSensory(map:FlxTilemap, p:Dynamic, canvas:FlxSprite)
    {
        if (p.alive && p.exists)
        {
            var ip:FlxPoint                     = FlxPoint.weak();
            var b:FlxPoint                      = FlxPoint.get(p.x+p.o,p.y+p.o);
            var polygon:Array<FlxPoint>         = [];
            var start:Int                       = Std.int(p.ang-(p.fieldOfVision/2));
            var seesPlayer                      = false;
            var detectedObjects:Array<Dynamic>  = [];
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
                        polygon.push(FlxPoint.weak(
                        b.x+pts[start].x*p.visionRange,
                        b.y+pts[start].y*p.visionRange));
                    }

                    //Detect objects
                    if(Type.getClass(p) == Enemy)
                    {
                        var radius:Float = Math.sqrt(
                            Math.pow(polygon[x].x - b.x, 2)+
                            Math.pow(polygon[x].y - b.y, 2));
                        var searchResolution:Float = 20;
                        var searchStep = radius/searchResolution;
                        var search:Float = 0;
                        var angle = start*(Math.PI/180);
                        while(search < radius)
                        {
                            var i = search * Math.cos(angle) + b.x;
                            var j = search * Math.sin(angle) + b.y;
                            search += searchStep;
                            if(FlxCollision.pixelPerfectPointCheck(
                                Std.int(i), Std.int(j), _player) == true)
                            {
                                seesPlayer = true;
                                continue;
                            }
                        }
                    }
                    start++;
            }

            if(Type.getClass(p) == Enemy)
            {
                if (seesPlayer)
                {
                    p.seesPlayer = true;
                }
                else p.seesPlayer = false;
            }

            polygon.push(FlxPoint.weak(b.x, b.y));
            if(Type.getClass(p) == Enemy) canvas.drawPolygon(polygon, p.alert, p.lineStyle);
            else canvas.drawPolygon(polygon, FlxColor.WHITE, p.lineStyle);
            
            b.putWeak();
            ip.putWeak();
        }
    }

}