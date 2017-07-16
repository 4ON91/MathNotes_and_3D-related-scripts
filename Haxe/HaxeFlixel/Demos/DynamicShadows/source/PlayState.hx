package ;
import VisionFunctions.*;

import flixel.addons.editors.tiled.TiledMap;

import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.FlxObject;
import openfl.Assets;
import openfl.display.BlendMode;

import flixel.FlxBasic;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxBaseTilemap;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

using flixel.util.FlxCollision;
using flixel.util.FlxSpriteUtil;
using Lambda;

class PlayState extends FlxState
{
    private var _grpCoins:FlxTypedGroup<Coin>;
    private var _grpFlashlights:FlxTypedGroup<Flashlight>;

    private var _grpEnemies:FlxTypedGroup<Enemy>;

    private var _player:Player;
    private var _flashlight:Flashlight;

    private var _canvas:FlxSprite;

    private var _map:TiledMap;
    private var _mWalls:FlxTilemap;
    private var _mBackground:FlxTilemap;

    private var _playerMouse:FlxSprite;


    private var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 2 };

    public static var pts:Array<FlxPoint> = [
            for(x in 0...360)
                {
                    FlxPoint.get(
                        Math.cos(x*Math.PI/180), 
                        Math.sin(x*Math.PI/180));
                }];




    private function placeEntities(entityName:String, entityData:Xml):Void
    {
            var x:Float = Std.parseFloat(entityData.get("x"));
            var y:Float = Std.parseFloat(entityData.get("y"));
            var rotation:Float = Std.parseFloat(entityData.get("rotation"));

            if(entityName == "player")
            {
                    _player.x = x;
                    _player.y = y;

            }

            else if(entityName == "coin")
            {
                _grpCoins.add(new Coin(x+8, y+8));
            }

            else if(entityName == "flashlight")
            {
                _grpFlashlights.add(new Flashlight(x+8, y+8, rotation));
            }

            else if(entityName == "enemy")
            {
                _grpEnemies.add(new Enemy(x,y));
            }
    }

    private function setMapTileProperties(mapName:FlxTilemap):Void
    {
            mapName.setTileProperties(1, FlxObject.NONE);
            mapName.setTileProperties(2, FlxObject.ANY);
            mapName.setTileProperties(3, FlxObject.ANY);
    }



    override public function create():Void
    {
            super.create();

            _map = new TiledMap(AssetPaths.Test_LineIntersection__tmx);
            _mWalls = new FlxTilemap();
            _mWalls.loadMapFromArray(cast(_map.getLayer("walls"), 
                    TiledTileLayer).tileArray, 
                    _map.width,_map.height, 
                    AssetPaths.BW50by50__png,
                    _map.tileWidth,
                    _map.tileHeight,
                    FlxTilemapAutoTiling.OFF,1,1,3);

            _mBackground = new FlxTilemap();

            _mBackground.loadMapFromArray(cast(_map.getLayer("bg"), 
                    TiledTileLayer).tileArray, 
                    _map.width,_map.height, 
                    AssetPaths.BW50by50__png,
                    _map.tileWidth,
                    _map.tileHeight,
                    FlxTilemapAutoTiling.OFF,1,1,3);

            _canvas = new FlxSprite();
            _canvas.makeGraphic(
                    _map.tileWidth * _map.width, 
                    _map.tileHeight * _map.height, 
                    FlxColor.TRANSPARENT, true);
            
            setMapTileProperties(_mWalls);

            _mWalls.follow();

            _player = new Player();
            _playerMouse = new FlxSprite();
            _playerMouse.makeGraphic(
                5,5,FlxColor.YELLOW);

            
            _grpEnemies = new FlxTypedGroup<Enemy>();
            _grpFlashlights = new FlxTypedGroup<Flashlight>();
            _grpCoins = new FlxTypedGroup<Coin>();

            var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
            for (e in tmpMap.objects)
            {
                    placeEntities(e.type, e.xmlData.x);
            }


            

            add(_mBackground);

            add(_player);
            add(_grpEnemies);
            add(_grpCoins);
            add(_grpFlashlights);

            add(_canvas);


            
            add(_mWalls);
            add(_playerMouse);

            _canvas.blend      = BlendMode.MULTIPLY;            
            FlxG.mouse.visible = false;
            FlxG.camera.zoom = 1;
            FlxG.camera.follow(_player, NO_DEAD_ZONE);
    }


    private function playerTouchCoin(P:Player, C:Coin):Void
    {
        if(P.alive && P.exists && C.alive && C.exists)
        {
            P.visionRange += 1;
            C.kill();
        }
    }

    private function playerCorner(p:Player, map:FlxTilemap):Void
    {
        var tileWidth = map.width / map.widthInTiles;
        var tileHeight = map.height / map.heightInTiles;

        var x:Int = Math.floor((p.x+p.o)/tileWidth);
        var y:Int = Math.floor((p.y+p.o)/tileHeight);

        var shift:Bool = false;

        if(p.touchingUP && p.up)
        {
            if(map.getTileCollisions( map.getTileByIndex((y-1)*map.widthInTiles+(x-1))) == 0 )
            {
                if(p.x <= x*tileWidth+6 && !shift)
                {
                    p.x = x*tileWidth+6;
                    p.visionOrigin.x -= p.o;
                    p.visionOrigin.y += p.o;
                    p.left = false;
                    shift = true;
                } 
                else shift = false;
            }
            if(map.getTileCollisions( map.getTileByIndex((y-1)*map.widthInTiles+(x+1)) ) == 0)
            {
                if(p.x+27+6 >= (x+1) * tileWidth && !shift)
                {
                    p.x = ( (x+1) * tileWidth ) - 27 - 6;
                    p.visionOrigin.x += p.o;
                    p.visionOrigin.y += p.o;
                    p.right = false;
                    shift = true;
                }
                else shift = false;
            }
        }
        else if(p.touchingDOWN && p.down)
        {
            if(map.getTileCollisions( map.getTileByIndex( (y+1)*map.widthInTiles+(x-1) ) ) == 0 )
            {
                if(p.x <= x*tileWidth+6 && !shift)
                {
                    p.x = x*tileWidth+6;
                    p.visionOrigin.x -= p.o;
                    p.visionOrigin.y -= p.o;
                    p.left = false;
                    shift = true;
                }
                else shift = false;
            }
            if(map.getTileCollisions( map.getTileByIndex((y+1)*map.widthInTiles+(x+1)) ) == 0)
            {
                if(p.x+27+6 >= (x+1) * tileWidth && !shift)
                {
                    p.x = ( (x+1) * tileWidth ) - 27 - 6;
                    p.visionOrigin.x += p.o;
                    p.visionOrigin.y -= p.o;
                    p.right = false;
                    shift = true;
                }
                else shift = false;
            }
        }
        else if(p.touchingLEFT && p.left)
        {
            if(map.getTileCollisions( map.getTileByIndex( (y-1) * map.widthInTiles+(x-1))) == 0)
            {
                if(p.y <= y*tileHeight+6 && !shift)
                {
                    p.y = y*tileHeight+6;
                    p.visionOrigin.y -= p.o;
                    p.visionOrigin.x += p.o;
                    p.up = false;
                    shift =true;
                }
                else shift = false;
            }
            if(map.getTileCollisions( map.getTileByIndex( (y+1) * map.widthInTiles+(x-1))) == 0)
            {
                if(p.y+27+6 >= (y+1) * tileHeight && !shift)
                {
                    p.y = (( y+1 ) * tileHeight) - 27 - 6;
                    p.visionOrigin.y += p.o;
                    p.visionOrigin.x += p.o;
                    p.down = false;
                    shift = true;
                }
                else shift = false;
            }
        }

        else if(p.touchingRIGHT && p.right)
        {
            if(map.getTileCollisions( map.getTileByIndex( (y-1) * map.widthInTiles+(x+1))) == 0)
            {
                if(p.y <= y*tileHeight+6 && !shift)
                {
                    p.y = y*tileHeight+6;
                    p.visionOrigin.y -= p.o;
                    p.visionOrigin.x -= p.o;
                    p.up = false;
                    shift = true;
                }
                else shift = false;
            }
            if(map.getTileCollisions( map.getTileByIndex( (y+1) * map.widthInTiles+(x+1))) == 0)
            {
                if(p.y+27+6 >= (y+1) * tileHeight && !shift)
                {
                    p.y = ( (y+1) * tileHeight ) - 27 -6;
                    p.visionOrigin.y += p.o;
                    p.visionOrigin.x -= p.o;
                    p.down = false;
                    shift = true;
                }
                else shift = false;
            }
        }
        else p.visionOrigin = FlxPoint.get(p.x+p.o, p.y+p.o);
    }

    private function playerTouchFlashlight(P:Player, F:Flashlight):Void
    {
        if(P.hasFlashlight == false)
        {
            if(P.alive && P.exists && F.alive && F.exists)
            {
                P.hasFlashlight = true;
                F.kill();
            }
        }
    }

    public function processLights()
    {
        _canvas.fill(FlxColor.BLACK);
        visionSensory(_player);
        _grpEnemies.forEachAlive(visionSensory);
        _grpFlashlights.forEachAlive(visionSensory);
    }

    public function visionSensory(p:Dynamic)
    {
        if (Type.getClass(p) == Player)
        {
            if(!p.hasFlashlight) return;
        }

        if (p.alive && p.exists)
        {
            var ip:FlxPoint                     = FlxPoint.weak();

            var b:FlxPoint                      = FlxPoint.get(p.x+p.o,p.y+p.o);
            var polygon:Array<FlxPoint>         = [];
            var start:Int                       = Std.int(p.ang-(p.fieldOfVision/2));
            var seesPlayer                      = false;

            if(Type.getClass(p) == Player)
            {
                b = p.visionOrigin;
            }

            for(x in 0...p.fieldOfVision)
            {
                if (start >= 360) start = start - 360;
                if (start < 0) start = 360 + start;
                if (!getIntersection(
                    FlxPoint.weak(b.x, b.y), 
                    FlxPoint.weak(
                        pts[start].x*p.visionRange+b.x,
                        pts[start].y*p.visionRange+b.y),ip,10,_mWalls))
                {
                    polygon.push(FlxPoint.weak(ip.x, ip.y));
                    if(Type.getClass(p) == Player) exploredMap(extendPoint(b, ip, 5), _mWalls);
                }
                else
                {
                    polygon.push(FlxPoint.weak(
                    b.x+pts[start].x*p.visionRange,
                    b.y+pts[start].y*p.visionRange));
                }

                if(Type.getClass(p) == Enemy)
                {
                    var radius:Float = Math.sqrt(
                        Math.pow(polygon[x].x - b.x, 2)+
                        Math.pow(polygon[x].y - b.y, 2));
                    var searchResolution:Float = 20;
                    var searchStep = radius/searchResolution;
                    var search:Float = 0;
                    var angle = start*(Math.PI/180);
                    var i:Float = 0;
                    var j:Float = 0;
                    while(search < radius)
                    {
                        i = search * Math.cos(angle) + b.x;
                        j = search * Math.sin(angle) + b.y;
                        search += searchStep;

                        if(Type.getClass(p) == Enemy)
                        {
                            if( FlxCollision.pixelPerfectPointCheck(
                                Std.int(i), Std.int(j), _player ) == true)
                            {
                                seesPlayer = true;
                            }
                        }
                    }
                }
                start++;
            }

            if(Type.getClass(p) == Enemy)
            {
                if (seesPlayer) p.seesPlayer = true;
                else p.seesPlayer = false;
            }

            polygon.push(FlxPoint.weak(b.x, b.y));
            if(Type.getClass(p) == Enemy)
            {
                if(p.tagged) _canvas.drawPolygon(polygon, p.alert, p.lineStyle);
            }
            else _canvas.drawPolygon(polygon, FlxColor.WHITE, p.lineStyle);
            b.putWeak();
            ip.putWeak();
        }
    }

    public function checkEnemyVision(e:Enemy):Void
    {
        if(e.chasingPlayer)
        {
            e.playerPos.copyFrom(_player.getMidpoint());
        }
    }

    public function extendView()
    {
        var cursorOffset = -(5/2);
        var playerPosition  = _player.visionOrigin;
        var mousePosition   = FlxPoint.weak(FlxG.mouse.x, FlxG.mouse.y);
        var radius = Math.sqrt(
            Math.pow(mousePosition.x-playerPosition.x, 2)+
            Math.pow(mousePosition.y-playerPosition.y, 2));
        var angle = polar(playerPosition, mousePosition) * (Math.PI/180);
        var limit = _player.visionRange;
        if(radius > limit)
        {
            _playerMouse.x = playerPosition.x + (limit * Math.cos(angle)) + cursorOffset;
            _playerMouse.y = playerPosition.y + (limit * Math.sin(angle)) + cursorOffset;
        }
        else
        {
            _playerMouse.x = playerPosition.x + (radius * Math.cos(angle)) + cursorOffset;
            _playerMouse.y = playerPosition.y + (radius * Math.sin(angle)) + cursorOffset;
        }
        if(FlxG.mouse.pressedRight) FlxG.camera.follow(_playerMouse, TOPDOWN);
        else FlxG.camera.follow(_player, NO_DEAD_ZONE);
    }
    public function tagEnemies(a:Dynamic, b:Dynamic)
    {
        var origin:FlxPoint = _player.visionOrigin;
        var target:FlxPoint = FlxPoint.weak(FlxG.mouse.x - (5/2), FlxG.mouse.y - (5/2));
        var radius = Math.sqrt(
            Math.pow(target.x-origin.x, 2)+
            Math.pow(target.y-origin.y, 2));

        if (_mWalls.ray(origin, target))
        {
            if(radius <= _player.visionRange)
            {
                if(FlxG.mouse.justPressed)
                {
                    if(Type.getClass(b) == Enemy)
                    {
                        if(b.tagged == false)
                        {
                            b.tagged = true;
                        }
                    }
                }
            }
        }
    }
    override public function update(elapsed:Float):Void
    {
            super.update(elapsed);

            playerCorner(_player, _mWalls);


            processLights();
            _grpEnemies.forEachAlive(checkEnemyVision);
            extendView();

            

            FlxG.collide(_grpEnemies, _mWalls);
            FlxG.collide(_player,_mWalls);
            FlxG.overlap(_playerMouse, _grpEnemies, tagEnemies);
            FlxG.overlap(_player, _grpCoins, playerTouchCoin);
            FlxG.overlap(_player, _grpFlashlights, playerTouchFlashlight);

    }
}
