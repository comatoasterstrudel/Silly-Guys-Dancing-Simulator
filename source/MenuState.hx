package;

import BeatManager;
import Dancer;
import SongData;
import flash.media.Sound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import sys.FileSystem;

class MenuState extends FlxState
{	
	var logo:FlxSprite;
	var textright:FlxText;
	var textleft:FlxText;

	var songs:Array<String>;

	var arrowleft:FlxSprite;
	var arrowright:FlxSprite;

	var play:FlxSprite;

	var songText1:FlxText;
	var songText2:FlxText;
	var songText3:FlxText;

	public static var curselected:Int = 0;

	override public function create()
	{
		getsonglist();

		bgColor = FlxColor.WHITE;

		FlxG.autoPause = true;
		FlxG.mouse.visible = true;

		logo = new FlxSprite().loadGraphic('assets/Logo.png');
		logo.setGraphicSize(Std.int(logo.width * .3));
		logo.updateHitbox();
		logo.screenCenter(X);
		logo.y = 30;
		logo.angle = 20;
		add(logo);

		textright = new FlxText();
		textright.text = 'For Loooogi, Laurie,\nPlayer and Me :-)';
		textright.size = 15;
		textright.alignment = FlxTextAlign.RIGHT;
		textright.color = FlxColor.BLACK;
		textright.font = 'assets/OpenDyslexic-Bold.otf';
		textright.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 4);
		textright.setPosition(FlxG.width - textright.width, 0);
		textright.alpha = .4;
		add(textright);

		textleft = new FlxText();
		textleft.text = 'Programmed by ComaToast\nCursor by Loooogi\nApp Icon by Player\nLogo by Witherings';
		textleft.size = 15;
		textleft.alignment = FlxTextAlign.LEFT;
		textleft.color = FlxColor.BLACK;
		textleft.font = 'assets/OpenDyslexic-Bold.otf';
		textleft.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 4);
		textleft.setPosition(0, 0);
		textleft.alpha = .4;
		add(textleft);

		arrowleft = new FlxSprite().loadGraphic('assets/Arrow.png');
		arrowleft.y = 400;
		arrowleft.screenCenter(X);
		arrowleft.x -= 280;
		add(arrowleft);

		arrowright = new FlxSprite().loadGraphic('assets/Arrow.png');
		arrowright.y = 400;
		arrowright.screenCenter(X);
		arrowright.x += 280;
		arrowright.flipX = true;
		add(arrowright);

		play = new FlxSprite().loadGraphic('assets/Play.png');
		play.screenCenter(X);
		play.y = FlxG.height - play.height;
		add(play);

		songText1 = new FlxText();
		songText1.text = 'Song Name';
		songText1.size = 35;
		songText1.alignment = FlxTextAlign.CENTER;
		songText1.color = FlxColor.BLACK;
		songText1.font = 'assets/OpenDyslexic-Bold.otf';
		songText1.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 4);
		songText1.screenCenter(X);
		songText1.y = 315;
		add(songText1);

		songText2 = new FlxText();
		songText2.text = 'Composer, Mapper';
		songText2.size = 18;
		songText2.alignment = FlxTextAlign.CENTER;
		songText2.color = FlxColor.BLACK;
		songText2.font = 'assets/OpenDyslexic-Bold.otf';
		songText2.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 4);
		songText2.screenCenter(X);
		songText2.y = songText1.y + songText1.height;
		add(songText2);

		trace(songs.length);

		var incrimatatt:Int = 0;
		var fuck:Bool = false;

		for(i in songs){
			incrimatatt ++;

			if(!FileSystem.exists('songs/$i/Data.json')){
				fuck = true;
			}
		}

		if(fuck){
			remove(arrowleft);
			remove(arrowright);
			remove(songText2);
			remove(play);

			songText1.text = 'Error with Song(s)';
			songText1.screenCenter(X);
			songText1.y += 50;
			songText1.alpha = .4;
		} else {
			changeselect(0);
		}

		super.create();
	}

	override public function update(elapsed:Float) 
	{
		if(FlxG.mouse.overlaps(arrowleft) && FlxG.mouse.justReleased){
			trace('left');

			changeselect(-1);
		}

		if(FlxG.mouse.overlaps(arrowright) && FlxG.mouse.justReleased){
			trace('right');

			changeselect(1);
		}

		if(FlxG.mouse.overlaps(play) && FlxG.mouse.justReleased){
			trace('SONG: ' + songs[curselected]);

			PlayState.songName = songs[curselected];

			FlxG.switchState(new PlayState());
		}

		if(FlxG.keys.justReleased.R){
			FlxG.switchState(new MenuState());
		}

		super.update(elapsed);
	}

	function changeselect(amount:Int = 0):Void{
		curselected += amount;

		if(curselected >= songs.length){
			curselected = 0;
		}

		if(curselected < 0){
			curselected = songs.length - 1;
		}

		var data = new SongData(songs[curselected]);

		songText1.text = data.songName;
		songText2.text = 'by ' + data.composerName + '\n(Mapped by ' + data.mapperName + ')';
		songText1.screenCenter(X);
		songText2.screenCenter(X);
	}

	function getsonglist():Void{
		songs = Utilities.getListFromArray(Utilities.dataFromTextFile('songs/songlist.txt'));

		trace(songs);
	}
}
