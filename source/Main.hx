package;

import Discord;
import MenuState;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState));


		var sprite = new FlxSprite().loadGraphic('assets/Cursor.png');
		FlxG.mouse.load(sprite.pixels);

		DiscordClient.initialize();
	}
}
