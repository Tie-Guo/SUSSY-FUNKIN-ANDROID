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
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKey;
//import Controls;

class AccountState extends MusicBeatState
{

    function click():Void
    {
        FlxG.sound.play(Paths.sound('cancelMenu'));
		FlxG.switchState(new MainMenuState());
    }

	override public function create()
	{	

		FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('MainBG'));
		bg.scale.set(1,1);
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var space:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		space.scale.set(0.7,0.77);
		add(space);

		var card:FlxSprite = new FlxSprite().loadGraphic(Paths.image('accountMenu/IDcard'));
		card.screenCenter();
		card.scale.set(0.7,0.7);
		add(card);

		//info start
		var line:FlxText = new FlxText(0, 135, '_');
		line.screenCenter(X);
		line.scale.set(155,2);
		add(line);

		var bf:FlxSprite = new FlxSprite(430, 300).loadGraphic(Paths.image('accountMenu/bf'));
		//bf.screenCenter();
		add(bf);

		var txt2:FlxText = new FlxText(710, 200, 'USER NAME\nBoyfriend\nAge: ?      level:1\nAccount ID:\n35107395');
		txt2.setFormat(Paths.font("AMGUS.ttf"),40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
		add(txt2);
		//info over

        var out:FlxSprite = new FlxSprite().loadGraphic(Paths.image('MainOut'));
        out.screenCenter();
        //out.scale.set();
        add(out);

		var txt1:FlxText = new FlxText(0, 100, 'MY ACCOUNT');
		txt1.screenCenter(X);
		txt1.setFormat(Paths.font("AMGUS.ttf"),40, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
		add(txt1);

        var button:FlxButton = new FlxButton(10, 10, '' , click);
		button.loadGraphic(Paths.image('Exit'));
		//button.screenCenter();
		add(button);
		
		#if android
		addVirtualPad(NONE, B);
		#end

		super.create();
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
}