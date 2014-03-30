package com.gamestudiohx.three.lights;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.cameras.Camera;


/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */
class SpotLight extends Light {
	public var target:Object3D; 

	public var intensity:Float;
	public var distance:Float;
	public var angle:Float;
	public var exponent:Float;

	public var onlyShadow:Bool;

	//

	public var shadowCameraNear:Float;
	public var shadowCameraFar:Float;
	public var shadowCameraFov:Float;

	public var shadowCameraVisible:Bool;

	public var shadowBias:Float;
	public var shadowDarkness:Float;

	public var shadowMapWidth:Int;
	public var shadowMapHeight:Int;

	//

	public var shadowMap:Dynamic; // RenderTarget;
	public var shadowMapSize:Float;
	public var shadowCamera:Camera;
	public var shadowMatrix:Matrix4;
	
	public function new(hex:Int = 0x00ff00, intensity:Float = 1, distance:Float = 0, angle:Float = 1.047197, exponent:Float = 10) {
		super(hex);
		
		this.position = new Vector3(0, 1, 0);
		this.target = new Object3D();

		this.intensity = intensity;
		this.distance = distance;
		this.angle = angle;
		this.exponent = exponent;

		this.castShadow = false;
		this.onlyShadow = false;

		//

		this.shadowCameraNear = 50;
		this.shadowCameraFar = 5000;
		this.shadowCameraFov = 50;

		this.shadowCameraVisible = false;

		this.shadowBias = 0;
		this.shadowDarkness = 0.5;

		this.shadowMapWidth = 512;
		this.shadowMapHeight = 512;

		//

		this.shadowMap = null;
		this.shadowMapSize = 0;
		this.shadowCamera = null;
		this.shadowMatrix = null;
	}
	
	public function clone(light:SpotLight = null):SpotLight {
		var light = new SpotLight();

		light = cast super._clone(light);

		light.target = this.target._clone();

		light.intensity = this.intensity;
		light.distance = this.distance;
		light.angle = this.angle;
		light.exponent = this.exponent;

		light.castShadow = this.castShadow;
		light.onlyShadow = this.onlyShadow;

		return light;
	}
}