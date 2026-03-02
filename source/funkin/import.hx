#if !macro
// Psych
#if LUA_ALLOWED
import llua.*;

import llua.Lua;
#end

//Mobile Controls
import funkin.mobile.objects.MobileControls;
import funkin.mobile.objects.IMobileControls;
import funkin.mobile.objects.Hitbox;
import funkin.mobile.objects.TouchPad;
import funkin.mobile.objects.TouchButton;
import funkin.mobile.input.MobileInputID;
import funkin.mobile.input.MobileInputManager;
import funkin.mobile.backend.TouchUtil;

// Android
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
import android.os.BatteryManager as AndroidBatteryManager;
#end

#if ACHIEVEMENTS_ALLOWED
import funkin.backend.Achievements;
#end
import funkin.backend.MTCacher;
import funkin.backend.Controls;
import funkin.backend.MusicBeatState;
import funkin.backend.MusicBeatSubstate;
import funkin.backend.ClientPrefs;
import funkin.backend.Conductor;
import funkin.backend.BaseStage;
import funkin.backend.Difficulty;
import funkin.backend.Mods;
import funkin.objects.Alphabet;
import funkin.objects.BGSprite;
import funkin.states.PlayState;
import funkin.objects.BaldiText;
import funkin.utils.CoolUtil;
import funkin.utils.MathUtil;
import funkin.backend.FunkinCache;
import funkin.FunkinAssets;
import funkin.Constants;

#if flixel_animate
import animate.FlxAnimate;
#end

#if VIDEOS_ALLOWED
import hxvlc.flixel.*;
import hxvlc.openfl.*;
#end

import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxShader;
import funkin.shaders.flixel.system.FlxShader;
#end
