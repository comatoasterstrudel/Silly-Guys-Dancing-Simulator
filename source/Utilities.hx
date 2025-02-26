package;

/**
 * A class that has basic functions that makes
 * other code easier to write. - Coma
 */

import sys.FileSystem;
import sys.io.File;

using StringTools;

class Utilities
{
	public static var randomshit:Map<String, Dynamic> = [];

	public static function dataFromTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];

		if (FileSystem.exists(path))
			daList = File.getContent(path).split('\n');

		return daList;
	}

	public static function getListFromArray(array:Array<String>):Array<String>{
		var returnThis = [];

		var data = array;

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");

			returnThis.push(stuff[0]);
		}

		return returnThis;
	}

	public static function grabThingFromText(thingtoget:String, filename:String, theonetosend:Int):String
	{
		var data = Utilities.dataFromTextFile(filename);
		var thingToSend:String = '';

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");
			if (stuff[0] == thingtoget)
			{
				thingToSend = stuff[theonetosend];
			}
		}

		return thingToSend;
	}

	public static function findFilesInPath(path:String, extns:Array<String>, ?filePath:Bool = false, ?deepSearch:Bool = true):Array<String>
	{
		var files:Array<String> = [];

		if (FileSystem.exists(path))
		{
			for (file in FileSystem.readDirectory(path))
			{
				var path = haxe.io.Path.join([path, file]);
				if (!FileSystem.isDirectory(path))
				{
					for (extn in extns)
					{
						if (file.endsWith(extn))
						{
							if (filePath)
								files.push(path);
							else
								files.push(file);
						}
					}
				}
				else if (deepSearch) // ! YAY !!!! -lunar
				{
					var pathsFiles:Array<String> = findFilesInPath(path, extns, deepSearch);

					for (_ in pathsFiles)
						files.push(_);
				}
			}
		}
		return files;
	}
	
}