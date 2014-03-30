package com.gamestudiohx.three.scenes;

import com.gamestudiohx.three.math.Color;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Fog {

	public var name:String;
	
	public var color:Color;
	
	public var near:Float;
	public var far:Float;
	
	public function new(hex:Int = 0xaaaaaa, near:Float = 1, far:Float = 100) {
		name = '';

		color = new Color(hex);

		this.near = near;
		this.far = far;
	}
	
	public function clone():Fog {
		return new Fog( color.getHex(), near, far );
	}
	
}