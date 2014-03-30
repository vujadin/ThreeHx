package com.gamestudiohx.three.scenes;

import com.gamestudiohx.three.math.Color;

/**
 * ...
 * @author Krtolica Vujadin
 */
class FogExp2 {
	
	public var name:String;
	
	public var color:Color;
	
	public var density:Float;

	public function new(hex:Int = 0xaaaaaa, density:Float = 0.00025) {
		this.name = "";
		this.color = new Color(hex);
		this.density = density;
	}
	
	public function clone():FogExp2 {
		return new FogExp2(color.getHex(), density);
	}
	
}