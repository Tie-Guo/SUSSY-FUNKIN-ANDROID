#if VIDEOS_ALLOWED
import VideoHandler as MP4Handler;
#end
import flixel.FlxBasic;
import flixel.FlxG;

class FlxVideo extends FlxBasic {

	public var finishCallback:Void->Void = null;
	
	public function new(name:String) {
		super();
		
		var video:MP4Handler = new MP4Handler();
		video.playVideo(name);
		video.finishCallback = function()
		{
			FlxG.resetState();
			FlxG.sound.resume();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
			finishCallback();
			return;
		}
	}
}