package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using flixel.util.FlxSpriteUtil;

class Flashlight extends FlxSprite
{
    public var lineStyle:LineStyle = { 
        color: FlxColor.WHITE, 
        thickness: 3 };

	public var ang:Float;
	public var fieldOfVision:Int = 60;
	public var visionRange:Float = 150;
	public var o:Int = 8;

	override public function kill():Void
	{
	    alive = false;
	    FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33, { ease: FlxEase.circOut, onComplete: finishKill });
	}

	private function finishKill(_):Void
	{
	    exists = false;
	}

	public function new(?X:Float=0,?Y:Float=0, ?ANGLE:Float=0)
	{
		super(X,Y);
		ang = ANGLE;
		makeGraphic(15,15,FlxColor.RED);


	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}