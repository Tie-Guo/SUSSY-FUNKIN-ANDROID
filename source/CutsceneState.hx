package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.ui.FlxSpriteButton;
import openfl.Lib;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;
import flash.text.TextField;
import flixel.addons.display.FlxGridOverlay;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CutsceneState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var firstStart:Bool = true;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	private var spr:FlxTypedGroup<Alphabet>;//

	var items:Array<String> = ['purple-imp','blow','bf'];
	
	var magenta:FlxSprite;
	var ex:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var secondbg:FlxSprite;
	var _btnPlay2:FlxButton;
	var colorTween:FlxTween;
	var txt2:FlxText;
	var title:FlxText;
	var title2:FlxText;
	var title3:FlxText;

	override function create()
	{
		//FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg2.setGraphicSize(Std.int(bg2.width * 1.175));
		bg2.scale.set(2,2);
		bg2.updateHitbox();
		bg2.scrollFactor.set(0.7, 0.7);
		bg2.screenCenter();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		bg2.alpha = 1;
		add(bg2);
		
		FlxTween.tween(bg2,{alpha:0.5},1.5,
		{
			type:       PINGPONG
		});

		secondbg = new FlxSprite().loadGraphic(Paths.image('bg_'));
		secondbg.scrollFactor.set(0, 0);
		add(secondbg);
		secondbg.screenCenter();

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		txt2 = new FlxText(0 , 20,'Select your video');
		txt2.setFormat(Paths.font("Dum-Regular.ttf"),40, FlxColor.WHITE, CENTER);
		txt2.screenCenter(X);
		txt2.scrollFactor.set(0, 0);
		add(txt2);

		title = new FlxText(0 , 600,'LetsRAP');
		title.setFormat(Paths.font("Dum-Regular.ttf"),40, FlxColor.WHITE, CENTER);
		title.screenCenter(X);
		title.scrollFactor.set(0, 0);
		add(title);

		title2 = new FlxText(0 , 600,'Shine');
		title2.setFormat(Paths.font("Dum-Regular.ttf"),40, FlxColor.WHITE, CENTER);
		title2.screenCenter(X);
		title2.scrollFactor.set(0, 0);
		add(title2);

		title3 = new FlxText(0 , 600,'LetsRAP-old');
		title3.setFormat(Paths.font("Dum-Regular.ttf"),40, FlxColor.WHITE, CENTER);
		title3.screenCenter(X);
		title3.scrollFactor.set(0, 0);
		add(title3);

		title.visible = true;
		title2.visible = false;
		title3.visible = false;

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = true;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;

		
		//add(magenta);

		// magenta.scrollFactor.set();

		_btnPlay2 = new FlxButton(10, 0, "", function()
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
			//FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		});

		_btnPlay2.loadGraphic(Paths.image('Exit'));
		add(_btnPlay2);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (item in items)
		{
			var newItem:FlxSprite = new FlxSprite((505 * items.indexOf(item))).loadGraphic(Paths.image('cut/$item'));
			newItem.ID = items.indexOf(item);
			menuItems.add(newItem);
			//newItem.screenCenter(X);
			newItem.x += 200;

		}



		FlxG.camera.follow(camFollowPos, null, 1);
		
		#if android
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (items[curSelected] == 'purple-imp')
		{
			title.visible = true;
			title2.visible = false;
			title3.visible = false;
		}

		if (items[curSelected] == 'blow')
		{
			title.visible = false;
			title2.visible = true;
			title3.visible = false;
		}

		if (items[curSelected] == 'bf')
		{
			title.visible = false;
			title2.visible = false;
			title3.visible = true;
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));



		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				//FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
			}

			if (controls.ACCEPT)
				{
					if (items[curSelected] == 'purple-imp')
					{
						selectedSomethin = true;
						FlxG.sound.pause();
						(new FlxVideo(Paths.video('LetsRAP'))).finishCallback = function()
						{
							FlxG.sound.resume();
							selectedSomethin = false;
						}
					}
					if (items[curSelected] == 'blow')
						{
							selectedSomethin = true;
							FlxG.sound.pause();
							(new FlxVideo(Paths.video('Shine'))).finishCallback = function()
							{
								FlxG.sound.resume();
								selectedSomethin = false;
							}
						}
					if (items[curSelected] == 'bf')
					{
						selectedSomethin = true;
						FlxG.sound.pause();
						(new FlxVideo(Paths.video('LetsRAP-old'))).finishCallback = function()
						{
							FlxG.sound.resume();
							selectedSomethin = false;
						}
					}

				}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
		{
			curSelected += huh;
	
			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.updateHitbox();
	
				if (spr.ID == curSelected)
				{

					var add:Float = 0;
					if(menuItems.length > 4) {
						add = menuItems.length * 8;
					}
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
					spr.centerOffsets();
				}
			});
		}
	}