package;

import flixel.FlxSprite;
import openfl.display.BitmapData;

class Dancer extends FlxSprite{
    public var name:String = '';
    public var dances:Array<String> = [];
    public var maxframes:Array<Int> = [];
    public var startingdance:String = '';

    public function new(name:String, dances:Array<String>, maxframes:Array<Int>, startingdance:String){
        super();

        this.name = name;
        this.dances = dances;
        this.maxframes = maxframes;
        this.startingdance = startingdance;
        
        trace('NEW DANCER ADDED: ' + name);
        trace('DANCES: ' + dances);

        loadGraphic('songs/' + PlayState.songdata.songName + '/dancer_' + name + '_' + startingdance + '_0.png');

        curanim = startingdance;
    }   

    var curanim:String = '';
    var currentFrame:Int = 0;
	var maxFrames:Int = 1;

    public function dance(anim:String):Void{
        for(i in 0...dances.length){
            if(dances[i] == anim){
                maxFrames = maxframes[i];
            }
        }

        if(curanim != anim) currentFrame = maxFrames;

        curanim = anim;

        currentFrame ++;

        if(currentFrame > maxFrames){
            currentFrame = 0;
        }

        loadGraphic(BitmapData.fromFile('songs/' + PlayState.songdata.songName + '/dancer_' + name + '_' + curanim + '_$currentFrame.png'));
    }
}