package;

import flixel.util.FlxColor;
import haxe.Json;
import sys.io.File;

class SongData{
	var data:Dynamic;

    public var songName:String = '';
    public var composerName:String = '';
    public var mapperName:String = '';
    public var bpm:Float = 0;
    public var characters:Array<String> = [];
    public var danceslist:Array<Array<String>> = [[]];
    public var framecounts:Array<Array<Int>> = [[]];
    public var characterSizes:Array<Float> = [];
    public var characterSpacing:Float = 100;
    public var bgcolor:FlxColor = FlxColor.WHITE;
    public var barcolor:FlxColor = FlxColor.BLACK;

    public function new(name:String){
        data = Json.parse(File.getContent('songs/$name/Data.json'));

        songName = data.songName;
        composerName = data.composerName;
        mapperName = data.mapperName;
        bpm = data.bpm;
        characters = data.characters;
        danceslist = data.danceslist;
        framecounts = data.framecounts;
        characterSizes = data.characterSizes;
        characterSpacing = data.characterSpacing;
        bgcolor = FlxColor.fromRGB(data.bgcolor[0], data.bgcolor[1], data.bgcolor[2]);
        barcolor = FlxColor.fromRGB(data.barcolor[0], data.barcolor[1], data.barcolor[2]);
    }
}