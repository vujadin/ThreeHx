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

class DirectionalLight extends Light {
	
	var target:Object3D;

	var intensity:Float;

	var onlyShadow:Bool;

	//

	var shadowCameraNear:Float;
	var shadowCameraFar:Float;

	var shadowCameraLeft:Float;
	var shadowCameraRight:Float;
	var shadowCameraTop:Float;
	var shadowCameraBottom:Float;

	var shadowCameraVisible:Bool;

	var shadowBias:Float;
	var shadowDarkness:Float;

	var shadowMapWidth:Int;
	var shadowMapHeight:Int;

	//

	var shadowCascade:Bool;

	var shadowCascadeOffset:Vector3;
	var shadowCascadeCount:Int;

	var shadowCascadeBias:Array<Float>;
	var shadowCascadeWidth:Array<Int>;
	var shadowCascadeHeight:Array<Int>;

	var shadowCascadeNearZ:Array<Float>;
	var shadowCascadeFarZ:Array<Float>;

	//

	var shadowMap:Dynamic; // RenderTarget;
	var shadowMapSize:Float;
	var shadowCamera:Camera;
	var shadowMatrix:Matrix4;

	public function new(hex:Int = 0xffffff, intensity:Float = 1) {
		super(hex);
		
		this.position.set(0, 1, 0);
		this.target = new Object3D();

		this.intensity = intensity;

		this.castShadow = false;
		this.onlyShadow = false;

		//

		this.shadowCameraNear = 50;
		this.shadowCameraFar = 5000;

		this.shadowCameraLeft = -500;
		this.shadowCameraRight = 500;
		this.shadowCameraTop = 500;
		this.shadowCameraBottom = -500;

		this.shadowCameraVisible = false;

		this.shadowBias = 0;
		this.shadowDarkness = 0.5;

		this.shadowMapWidth = 512;
		this.shadowMapHeight = 512;

		//

		this.shadowCascade = false;

		this.shadowCascadeOffset = new Vector3( 0, 0, -1000 );
		this.shadowCascadeCount = 2;

		this.shadowCascadeBias = [ 0, 0, 0 ];
		this.shadowCascadeWidth = [ 512, 512, 512 ];
		this.shadowCascadeHeight = [ 512, 512, 512 ];

		this.shadowCascadeNearZ = [ -1.000, 0.990, 0.998 ];
		this.shadowCascadeFarZ  = [  0.990, 0.998, 1.000 ];

		this.shadowCascadeArray = [];

		//

		this.shadowMap = null;
		this.shadowMapSize = 0;
		this.shadowCamera = null;
		this.shadowMatrix = null;
	}
	
	public function clone(light:DirectionalLight = null):DirectionalLight {
		if(light == null) light = new DirectionalLight();

		light = cast super._clone(light);

		light.target = this.target._clone();
		light.intensity = this.intensity;
		light.castShadow = this.castShadow;
		light.onlyShadow = this.onlyShadow;

		return light;
	}
	
}