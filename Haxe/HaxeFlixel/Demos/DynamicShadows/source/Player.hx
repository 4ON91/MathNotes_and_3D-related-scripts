package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import VisionFunctions.polar;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{

    public var lineStyle:LineStyle = { 
        color: FlxColor.TRANSPARENT, 
        thickness: 0 };

    public var stamina:Float = 10;
	public var ang:Float;
	public var speed:Float;
	public var o:Int = 14;
	public var fieldOfVision:Int = 60;
	public var visionRange:Float = 250;
	public var hasFlashlight:Bool = false;

	public var up:Bool 			= false;
	public var down:Bool 		= false;
	public var left:Bool 		= false;
	public var right:Bool 		= false;
	public var shift:Bool 		= false;
	public var f:Bool 			= false;
	public var alt:Bool 		= false;

	public var touchingUP:Bool 		= false;
	public var touchingDOWN:Bool 	= false;
	public var touchingLEFT:Bool 	= false;
	public var touchingRIGHT:Bool 	= false;

	public var visionOrigin:FlxPoint;


	private function movement():Void
	{
		var a:FlxPoint = FlxPoint.weak(FlxG.mouse.x - (5/2), FlxG.mouse.y - (5/2));
		var b:FlxPoint = FlxPoint.weak(x+o,y+o);

        ang = polar(b,a);
        
        visionOrigin 		= FlxPoint.get(x+o, y+o);

		up 					= FlxG.keys.anyPressed([W]);
		down 				= FlxG.keys.anyPressed([S]);
		left 				= FlxG.keys.anyPressed([A]);
		right 				= FlxG.keys.anyPressed([D]);
		shift 				= FlxG.keys.anyPressed([SHIFT]);
		f 					= FlxG.keys.anyPressed([F]);
		alt 				= FlxG.keys.anyPressed([ALT]);

		touchingUP 			= isTouching(FlxObject.UP);
		touchingDOWN 		= isTouching(FlxObject.DOWN);
		touchingLEFT 		= isTouching(FlxObject.LEFT);
		touchingRIGHT 		= isTouching(FlxObject.RIGHT);


		if(up && down) 		up 		= down 		= false;
		if(left && right) 	left 	= right 	= false;
		if(alt && shift)	alt 	= shift 	= false;

		if (up || down || left || right)
		{
			if(alt) 		speed = 100;
			else if(shift) 	speed = 500;
			else 			speed = 300;

			var mA:Float = 0;
			if(up)
			{
				mA = -90;
				if(left)
					mA -= 45;
				if(right)
					mA += 45;
			}
			else if(down)
			{
				mA = 90;
				if(left)
					mA += 45;
				if(right)
					mA -= 45;
			}
			else if(left)
			{
				mA = 180;
			}
			else if(right)
			{
				mA = 0;
			}
			velocity.set(speed,0);
			velocity.rotate(FlxPoint.weak(0,0),mA);
		}
	}


	public function new(?X:Float=0,?Y:Float=0)
	{
		super(X,Y);
		makeGraphic(27,27,FlxColor.BLUE);

		visionOrigin = FlxPoint.get(this.x, this.y);

		drag.x = drag.y = 5000;
	}

	override public function update(elapsed:Float):Void
	{
		movement();
		super.update(elapsed);
	}
}