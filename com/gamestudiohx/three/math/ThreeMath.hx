package com.gamestudiohx.three.math;

/**
 * ...
 * @author Krtolica Vujadin
 */
class ThreeMath {

	public static var PI2:Float = Math.PI * 2;
	public static var degreeToRadiansFactor:Float = Math.PI / 180;
	public static var radianToDegreesFactor:Float = 180 / Math.PI;
	
	public function new() {
		
	}
	
	public static function generateUUID(?charactersToUse = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"):String {
		function randomBetween(from:Int, to:Int):Int {
			return from + Math.floor(((to - from + 1) * Math.random()));
		}
		
		var str = "";
		
		for (i in 0...36) {
			if (i == 8 || i == 13 || i == 18 || i == 23) {		
				str += '-';		
			} else if (i == 14) {		
				str += '4';		
			} else {		
				str += charactersToUse.charAt(randomBetween(0, charactersToUse.length - 1));
			}
		}
	
		return str.substr(0, str.length - 1);
	}
	
	// Clamp value to range <a, b>
	public static function clamp(x:Float, a:Float, b:Float):Float {
		return (x < a) ? a : ((x > b) ? b : x);
	}
	
	// Clamp value to range <a, inf>
	public static function clampBottom(x:Float, a:Float):Float {
		return x < a ? a : x;
	}
	
	// Linear mapping from range <a1, a2> to range <b1, b2>
	public static function mapLinear(x:Float, a1:Float, a2:Float, b1:Float, b2:Float):Float {
		return b1 + (x - a1) * (b2 - b1) / (a2 - a1);
	}
	
	// http://en.wikipedia.org/wiki/Smoothstep
	public static function smoothstep(x:Float, min:Float, max:Float):Float {
		if (x <= min) return 0;
		if (x >= max) return 1;

		x = (x - min) / (max - min);

		return x * x * (3 - 2 * x);
	}
	
	public static function smootherstep(x:Float, min:Float, max:Float):Float {
		if (x <= min) return 0;
		if (x >= max) return 1;

		x = (x - min) / (max - min);

		return x * x * x * (x * (x * 6 - 15) + 10);
	}
	
	// Random float from <0, 1> with 16 bits of randomness
	// (standard Math.random() creates repetitive patterns when applied over larger space)
	public static function random16():Float {
		return (65280 * Math.random() + 255 * Math.random()) / 65535;
	}
	
	// Random integer from <low, high> interval
	public static function randInt(low:Int, high:Int):Int {
		return Std.int(low + Math.floor(Math.random() * (high - low + 1)));
	}
	
	// Random float from <low, high> interval
	public static function randFloat(low:Float, high:Float):Float {
		return low + Math.random() * (high - low);
	}
	
	// Random float from <-range/2, range/2> interval
	public static function randFloatSpread(range:Float):Float {
		return range * (0.5 - Math.random());
	}
	
	public static function sign(x:Float):Int {
		return (x < 0) ? -1 : ((x > 0) ? 1 : 0);
	}
	
	public static function degToRad(degrees:Float):Float {
		return degrees * degreeToRadiansFactor;
	}
	
	public static function radToDeg(radians:Float):Float {
		return radians * radianToDegreesFactor;
	}
}
