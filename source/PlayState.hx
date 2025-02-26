package;

import BeatManager;
import Dancer;
import SongData;
import flash.media.Sound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import sys.FileSystem;

class PlayState extends FlxState
{
	public static var songName:String = 'Test';

	var bpmManager:BeatManager;

	var dancers:Array<Dancer> = [];

	public static var songdata:SongData;
	
	var textright:FlxText;
	var textleft:FlxText;
	
	var timebar:FlxBar;

	override public function create()
	{
		songdata = new SongData(songName);

		FlxG.autoPause = false;
		FlxG.mouse.visible = false;

		load();
		
		var timer:FlxTimer = new FlxTimer().start(.02, function(FlxTmr:FlxTimer):Void{
			playSong();
			makeCharacters();
			makeBg();
			makeText();
			makeBar();
		});

		super.create();
	}

	override public function update(elapsed:Float) 
	{
		super.update(elapsed);

		if(FlxG.keys.justReleased.ESCAPE){
			FlxG.sound.music.stop();
			FlxG.switchState(new MenuState());
		}

		if(bpmManager != null) bpmManager.update(elapsed);
	}

	function load():Void{
		resetCache();
		
		var timer:FlxTimer = new FlxTimer().start(.01, function(FlxTmr:FlxTimer):Void{
			FlxG.sound.playMusic(Sound.fromFile('songs/'  + songdata.songName + '/Song.ogg'), 1, false);
			FlxG.sound.music.pause();
			FlxG.sound.music.onComplete = endsong;
		
			var increment:Int = -1;
			var increment2:Int = -1;
			
			for(character in songdata.characters){
				increment ++;


				for(dance in songdata.danceslist[increment]){
					var increment2:Int = -1;

					increment2 ++;

					for(framecount in 0...songdata.framecounts[increment][increment2]){
						cacheGraphic('songs/$songName/dancer_' + character + '_' + dance + '_' + framecount + '.png');
					}
				}
			}
		});
	}

	function playSong():Void{
		FlxG.sound.music.resume();
		
		bpmManager = new BeatManager(songdata.bpm, function():Void{
			for(i in dancers){
				i.dance(i.startingdance);
			}
		});
	}

	function makeCharacters():Void{
		var count:Int = -1;

		for(i in songdata.characters){
			count ++;

			var dancer = new Dancer(i, songdata.danceslist[count], songdata.framecounts[count], songdata.danceslist[count][0]);
			add(dancer); 

			dancers.push(dancer);
		}

		var centerX:Float = FlxG.width / 2;
		var centerY:Float = FlxG.height / 2;

		var count:Int = dancers.length;
        if (count == 0) return;

        var spacing:Float = songdata.characterSpacing; // Adjust this value to increase/decrease spacing
	
		trace(spacing);

        // Calculate the total width of all sprites including spacing
        var totalWidth:Float = (count - 1) * spacing + dancers[0].width * count;

        // Start positioning from the leftmost point
        var startX:Float = centerX - totalWidth / 2;

        for (i in 0...count) {
            var sprite = dancers[i];
            sprite.x = startX + i * (sprite.width + spacing);
            sprite.y = centerY - sprite.height / 2; // Center vertically
        }

		var newcount = -1;

		for(i in dancers){
			newcount ++;

			var prevx = i.x;
			var prevwidth = i.width;

			i.setGraphicSize(Std.int(i.width * songdata.characterSizes[newcount]));
			i.updateHitbox();

			i.x = prevx + prevwidth / 2 - i.width / 2;
			i.screenCenter(Y);
		}
	}

	function makeBg():Void{
		bgColor = songdata.bgcolor;
	}

	function makeText():Void{
		textright = new FlxText();
		textright.text = songdata.songName + '\nby ' + songdata.composerName + '\nMapped by ' + songdata.mapperName;
		textright.size = 15;
		textright.alignment = FlxTextAlign.RIGHT;
		textright.color = songdata.barcolor;
		textright.font = 'assets/OpenDyslexic-Bold.otf';
		textright.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 4);
		textright.setPosition(FlxG.width - textright.width, FlxG.height - textright.height);
		textright.alpha = .4;
		add(textright);

		textleft = new FlxText();
		textleft.text = 'Silly Guys Dancing Simulator';
		textleft.size = 15;
		textleft.alignment = FlxTextAlign.LEFT;
		textleft.color = songdata.barcolor;
		textleft.font = 'assets/OpenDyslexic-Bold.otf';
		textleft.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 4);
		textleft.setPosition(0, FlxG.height - textleft.height);
		textleft.alpha = .4;
		add(textleft);

		textright.x += textright.width;
		FlxTween.tween(textright, {x: textright.x - textright.width}, 1, {ease:FlxEase.quartOut});
		textleft.x -= textleft.width;
		FlxTween.tween(textleft, {x: textleft.x + textleft.width}, 1, {ease:FlxEase.quartOut});
	}

	function makeBar():Void{
		timebar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, 20, FlxG.sound.music, 'time', 0, FlxG.sound.music.length, false);
		timebar.createColoredFilledBar(songdata.barcolor, false, FlxColor.WHITE);
		timebar.createColoredEmptyBar(FlxColor.TRANSPARENT, false, FlxColor.WHITE);
		timebar.numDivisions = FlxG.width * 4;
		timebar.alpha = 0;
		add(timebar);

		FlxTween.tween(timebar, {alpha: 1}, 3);
	}

		//CACHE SHIT

		public static var cachedAssets:Map<String, FlxGraphic> = [];
		public static var cachedAssetsList:Array<String> = [];
	
		public static var cachedSoundsList:Array<String> = [];
	
		public static function cacheGraphic(key:String, permanent:Bool = false):Void{
			if (FileSystem.exists(key))
			{
				if (cachedAssets.exists(key))
					return;
	
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(key), false, key, true);
				if (graphic != null)
				{
					graphic.persist = true;
					cachedAssets.set(key, graphic);
				}
	
				//FlxG.bitmap.add
				if (!permanent) cachedAssetsList.push(key);
	
				trace((permanent ? '[PERMANENT] ' : '') + 'Successfully Cached Image Asset: ' + key);
			} else {
				trace('INVALID IMAGE ASSET: ' + key);
			}
		}
	
		public static function cacheAudio(key:String, permanent:Bool = false):Void{
			if(FileSystem.exists(key)){
				if(cachedSoundsList.contains(key)) 
					return;
				
				FlxG.sound.cache(key);
	
				if (!permanent) cachedSoundsList.push(key);
	
				trace((permanent ? '[PERMANENT] ' : '') + 'Successfully Cached Audio Asset: ' + key);
			} else {
				trace('INVALID AUDIO ASSET: ' + key);
			}
		}
	
		public static function resetCache(destroy:Bool = false):Void{ 
			var cachedshitbefore:Bool = false;
	
			for(i in cachedAssetsList){
				var graphic = cachedAssets.get(i);
				FlxG.bitmap.remove(graphic);
				if(graphic != null) { if (destroy) graphic.destroy(); else graphic.persist = false; }
				cachedAssets.remove(i);
	
				cachedshitbefore = true;
			}
	
			cachedSoundsList = [];
			cachedAssetsList = [];
	
			//idfk ??
			
			if (cachedshitbefore) FlxG.bitmap.dumpCache();
			if (cachedshitbefore) FlxG.bitmap.clearUnused();
	
			trace('RESET CACHE');
		}

	function endsong():Void{
		var barspr = new FlxSprite().makeGraphic(FlxG.width, 20, songdata.barcolor, false);
		add(barspr);

		bpmManager.isinitialized = false;

		var fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE, false);
		add(fade);
		
		fade.alpha = 0;

		FlxTween.tween(fade, {alpha: 1}, 2, {onComplete: function(flxtwn):Void{
			FlxG.switchState(new MenuState());
		}});
	}
}
