package;

import flixel.util.FlxColor;
import flixel.system.FlxAssets;

import haxe.Json;
import haxe.io.Path;

import lime.app.Application;
#if linux
import lime.graphics.Image;
#end

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

import debug.FPSCounter;

import flixel.FlxG;

import funkin.utils.MacroUtil;

import flixel.system.frontEnds.SoundFrontEnd;
import flixel.system.ui.FlxSoundTray;

import openfl.display.BitmapData;
import openfl.display.Bitmap;

import flixel.FlxGame;
import flixel.FlxState;

import funkin.backend.ClientPrefs;

#if COPYSTATE_ALLOWED
import funkin.states.CopyState;
#end

import lime.system.System as LimeSystem;

class Main extends Sprite
{
	public static final game =
		{
			width: 1280, // WINDOW width
			height: 720, // WINDOW height
			initialState: funkin.states.MainMenuState, // initial game state
			framerate: 60, // default framerate
			skipSplash: true, // if the default flixel splash screen should be skipped
			startFullscreen: false // if the game should start at fullscreen mode
		};
		
	public static function main():Void
	{
		Lib.current.addChild(new Main());
		#if cpp
        cpp.NativeGc.enable(true);
        cpp.NativeGc.run(true);
        #end
	}
	
	public function new()
	{
		super();
		
		#if mobile
		#if android
		StorageUtil.requestPermissions();
		#end
		Sys.setCwd(StorageUtil.getStorageDirectory());
		#end
		funkin.backend.CrashHandler.init();
		
		#if (windows && cpp && !debug)
		funkin.backend.system.Windows.setDpiAware();
		#end
		
		ClientPrefs.tryBindingSave('funkin');
		addChild(new FNFGame(game.width, game.height, #if COPYSTATE_ALLOWED !CopyState.checkExistingFiles() ? CopyState : #end InitState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));
		
		FPSCounter.init();
		
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		#if mobile
		LimeSystem.allowScreenTimeout = ClientPrefs.data.screensaver;
		#end
		
		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end
		
		#if DISCORD_ALLOWED DiscordClient.prepare(); #end
	}
}

class FNFGame extends FlxGame
{
	override function create(_:Event)
	{
		_customSoundTray = CustomSoundTray;
		super.create(_);
		
		FlxG.sound.soundTray.volumeDownSound = 'assets/sounds/soundTrayMinus';
		FlxG.sound.soundTray.volumeUpSound = 'assets/sounds/soundTrayPlus';
		
		// // KILL EVERYONE
		// // atleast we arent shadowing flixel classes yahoo!
		// #if FLX_SOUND_SYSTEM
		// untyped FlxG.sound = new BaldiSoundFrontEnd();
		// #end
	}
}

class CustomSoundTray extends FlxSoundTray
{
	public var volumeMaxSound:String = 'assets/sounds/SoundTrayMax';
	
	var _barsDithered:Array<Bitmap>;
	
	public function new()
	{
		super();
		
		removeChildren();
		
		_defaultScale = 0.35;
		
		_bars = [];
		_barsDithered = [];
		
		final PADDING:Int = 5;
		var x:Float = 10;
		for (i in 0...10)
		{
			var tmp = new Bitmap(BitmapData.fromFile('assets/images/ui/volumeFill.png'));
			tmp.x = x;
			tmp.y = 10;
			
			addChild(tmp);
			_bars.push(tmp);
			
			x += tmp.width + PADDING;
		}
		
		var bg = new Bitmap(new BitmapData(1, 1, true, FlxColor.BLACK));
		bg.alpha = 0.25;
		addChildAt(bg, 0);
		
		bg.width = Std.int(_bars[0].x + _bars[_bars.length - 1].x + _bars[_bars.length - 1].width);
		bg.height = _bars[0].height + 20;
		
		_minWidth = Std.int(bg.width);
		
		y = 15;
	}
	
	override function update(MS:Float)
	{
		// Animate sound tray thing
		if (_timer > 0)
		{
			_timer -= (MS / 1000);
		}
		else if (alpha > 0)
		{
			alpha -= (MS / 1000) * 2;
			
			if (alpha <= 0)
			{
				visible = false;
				active = false;
				
				#if FLX_SAVE
				// Save sound preferences
				if (FlxG.save.isBound)
				{
					FlxG.save.data.mute = FlxG.sound.muted;
					FlxG.save.data.volume = FlxG.sound.volume;
					FlxG.save.flush();
				}
				#end
			}
		}
	}
	
	override function screenCenter()
	{
		final scale = _defaultScale * FlxG.scaleMode.scale.x;
		scaleX = scale;
		scaleY = scale;
		
		x = (0.5 * (Lib.current.stage.stageWidth - _minWidth * scale) - FlxG.game.x);
	}
	
	override function updateSize()
	{
		screenCenter();
	}
	
	override function showAnim(volume:Float, ?sound:FlxSoundAsset, duration:Float = 1.0, label:String = "VOLUME")
	{
		alpha = 1;
		super.showAnim(volume, sound, duration, label);
	}
	
	override function showIncrement()
	{
		final volume = FlxG.sound.muted ? 0 : FlxG.sound.volume;
		showAnim(volume, silent ? null : volume == 1 ? volumeMaxSound : volumeUpSound);
	}
}
