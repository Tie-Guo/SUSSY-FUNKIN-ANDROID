package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouse;
import flixel.ui.FlxButton;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import FunkinLua;
import sys.FileSystem;
//import Controls;
//import flixel.FlxCamera;

class ShopState extends MusicBeatState
{
	var _btnPlay:FlxButton;
	var _btnPlay2:FlxButton;
	var colorTween:FlxTween;
	var shopitem1:FlxButton;
	var txt2:FlxText;

	//stupid lua things
	public var luaArray:Array<FunkinLua> = [];

	override public function create():Void
	{

		FlxG.mouse.visible = true;

		function clickPlay2():Void
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scale.set(1,1);
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		FlxTween.tween(bg,{alpha:0.5},1.5,
		{
			type:       PINGPONG
		});

		var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bg_'));
		//bg2.scale.set(1,1);
		bg2.screenCenter();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2);

		var bean:FlxSprite = new FlxSprite(870, -190).loadGraphic(Paths.image('bean'));
		bean.scale.set(0.1,0.1);
		add(bean);

		var beanNum:FlxText = new FlxText(1165,10,'0');
		beanNum.setFormat(Paths.font("AMGUS.ttf"), 40, FlxColor.RED, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.RED);
		add(beanNum);

		var txt:FlxText = new FlxText(0,100,/*'SONG PACKS'*/'Notings here');
		txt.setFormat(Paths.font("Dum-Regular.ttf"),80, FlxColor.WHITE, CENTER);
		txt.screenCenter(X);
		add(txt);

		txt2 = new FlxText(0 , 20,'There are not enough beans to buy this item');
		txt2.setFormat(Paths.font("Dum-Regular.ttf"),40, FlxColor.RED, CENTER);
		txt2.screenCenter(X);

		 function OnClickButton():Void
    {
        FlxG.sound.play(Paths.sound('cancelMenu'));
		add(txt2);
    }
		//_btnPlay = new FlxButton(0, 550, "FREE", clickPlay);
		//_btnPlay.scale.set(2.5, 2.5);
		//_btnPlay.screenCenter(X);
		//add(_btnPlay);

		_btnPlay2 = new FlxButton(10, 0, "", clickPlay2);
		_btnPlay2.loadGraphic(Paths.image('Exit'));
		//_btnPlay2.scale.set(2, 2);
		//_btnPlay2.screenCenter(X);
		add(_btnPlay2);

		super.create();

		shopitem1 = new FlxButton(135, 120, "", OnClickButton);

        shopitem1.loadGraphic(Paths.image('shopItem1'));
		shopitem1.scale.set(0.8,0.8);
		shopitem1.antialiasing = true;
		//shopitem1.screenCenter(X);
        //add(shopitem1);

		var shopitem2:FlxButton = new FlxButton(155 + 569 - 125, 120, "", 
		function()
		{
			startSong([
				'credits',
			]);
			startLuasOnFolder('assets/credits-things/LoadSecondJson.lua');
			//I hate code
		}
		);

        shopitem2.loadGraphic(Paths.image('shopitem2'));
		shopitem2.scale.set(0.8,0.8);
		shopitem2.antialiasing = true;
		//shopitem1.screenCenter(X);
        //add(shopitem2);
	}

	function startSong(songlist:Array<String>, difficulty:Int = 1)
		{
			PlayState.storyPlaylist = songlist;
			PlayState.isStoryMode = false;
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
			LoadingState.loadAndSwitchState(new PlayState());
		}


	override public function update(elapsed:Float)
	{
				
		if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
			
		super.update(elapsed);
	}

	public function startLuasOnFolder(luaFile:String)
	{
		for (script in luaArray)
		{
			if(script.scriptName == luaFile) return false;
		}

		#if MODS_ALLOWED
		var luaToLoad:String = Paths.modFolders(luaFile);
		if(FileSystem.exists(luaToLoad))
		{
			luaArray.push(new FunkinLua(luaToLoad));
			return true;
		}
		else
		{
			luaToLoad = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
				return true;
			}
		}
		#elseif sys
		var luaToLoad:String = Paths.getPreloadPath(luaFile);
		if(OpenFlAssets.exists(luaToLoad))
		{
			luaArray.push(new FunkinLua(luaToLoad));
			return true;
		}
		#end
		return false;
	}
	
}