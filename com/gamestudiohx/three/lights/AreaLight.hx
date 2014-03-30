package com.gamestudiohx.three.lights;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.cameras.Camera;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class AreaLight extends Light {

	public var normal:Vector3;
	public var right:Vector3;

	public var intensity:Float;

	public var width:Float;
	public var height:Float;

	public var constantAttenuation:Float;
	public var linearAttenuation:Float;
	public var quadraticAttenuation:Float;
	
	public function new(hex:Int = 0xffffff, intensity:Float = 1) {
		super(hex);
		
		this.normal = new Vector3( 0, -1, 0 );
		this.right = new Vector3( 1, 0, 0 );

		this.intensity = intensity;

		this.width = 1.0;
		this.height = 1.0;

		this.constantAttenuation = 1.5;
		this.linearAttenuation = 0.5;
		this.quadraticAttenuation = 0.1;
	}
	
}