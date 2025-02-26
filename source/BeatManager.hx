package;

import flixel.util.FlxTimer;

class BeatManager
{
	var bpm:Float;
	var beatInterval:Float;

	var beatFunction:Void -> Void;

	public var curBeat:Int;

	public var isinitialized:Bool = false;

	public function new(newbpm:Float, newBeatFunction:Void -> Void)
	{
		bpm = newbpm;
		beatFunction = newBeatFunction;

		initialize();
	}

	inline function initialize():Void{
		beatInterval = 60 / bpm;
		curBeat = 0;

		isinitialized = true;
	}

	var timer:Float = 0; //ms

	public function update(elapsed:Float){
		if(!isinitialized) return;

		var timetoadd = elapsed;

		timer += timetoadd;

		if(timer >= beatInterval){
			timer -= beatInterval;

			curBeat ++;
			
			beatFunction();
		}
	}
}