package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

import openfl.display.BlendMode;
import VisionFunctions.polar;
import FSM.*;

import flixel.math.FlxVelocity;

using flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite
{
    private var _brain:FSM;
    private var _idleTimer:Float;
    private var _chaseTimer:Float;
    private var _searchTimer:Float;
    private var _waitTimer:Float;

    

    

    private var _moveDir:Float;

    private var phase:Int = 0;
    private var turnSpeed:Float = 75;

    public var tagged:Bool = false;
    public var chasingPlayer:Bool = false;
    public var seesPlayer:Bool = false;
    public var playerPos(default, null):FlxPoint;

    public var lineStyle:LineStyle = { 
        color: FlxColor.TRANSPARENT, 
        thickness: 0 };

    public var ang:Float = 0;
    public var speed:Float = 375;
    public var o:Int = 14;
    public var fieldOfVision:Int = 60;
    public var visionRange:Float = 150;
    public var hasFlashlight:Bool = false;

    public var alert:FlxColor;


    public function idle():Void
    {
        alert = FlxColor.GRAY;
        if(seesPlayer) foundPlayer();
        else
        {
            var rngTurn = FlxG.random.int(1,15);
            var turn = FlxG.elapsed * turnSpeed * rngTurn;
            if(phase == 0) 
            {
                _moveDir = FlxG.random.int(0,8)*45;
                phase += 1;
                _waitTimer = 1;
            }
            if(phase == 1)
            {
                if(ang > _moveDir-30) ang -= turn;
                else phase++;
            }
            if(phase == 2)
            {
                if(ang < _moveDir+30) ang += turn;
                else phase++;
            }
            if(phase == 3)
            {
                if(ang > _moveDir) ang -= turn;
                else phase++;
            }
            if(phase == 4)
            {
                velocity.set(speed*1, 0);
                velocity.rotate(FlxPoint.weak(), _moveDir);
                phase++;
            }
            if(phase == 5)
            {
                if(_waitTimer > 0) _waitTimer -= FlxG.elapsed;
                else phase = 0;
            }
        }
    }

    public function foundPlayer():Void
    {
        alert =FlxColor.RED;
        _brain.activeState = chase;
    }

    public function chase():Void
    {
        if(!seesPlayer && _chaseTimer <= 0)
        {
            chasingPlayer = false;
            _brain.activeState = idle;
        }
        else
        {
            if(seesPlayer)
            {
                _chaseTimer = 2;
                chasingPlayer = true;
            }
            else if(!seesPlayer)
            {
                _chaseTimer -= FlxG.elapsed;
            }
            ang = polar(FlxPoint.weak(this.x, this.y), playerPos);
            FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
        }
    }

    public function new(?X:Float=0,?Y:Float=0)
    {
        super(X,Y);
        makeGraphic(27,27,FlxColor.RED);
        drag.x = drag.y = 5000;

        
        _brain = new FSM(idle);
        _idleTimer = 0;

        playerPos = FlxPoint.get();
    }

    override public function update(elapsed:Float):Void
    {
        _brain.update();
        super.update(elapsed);
    }
}