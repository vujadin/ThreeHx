package com.gamestudiohx.three.lights;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.cameras.Camera;

/**
 * ...
 * @author Krtolica Vujadin
 */
class HemisphereLight extends Light {

	var groundColor:Color;
	var intensity:Float;

	public function new(skyColorHex:Int = 0xffffff, groundColorHex:Int = 0xffffff, intensity:Float = 1) {
		super(skyColorHex);
		
		this.position = new Vector3( 0, 100, 0 );

		this.groundColor = new Color(groundColorHex);
		this.intensity = intensity;
	}
	
	public function clone(object:HemisphereLight = null):HemisphereLight {
		var light:HemisphereLight = new HemisphereLight();

		light = cast super.__clone(light);

		light.groundColor = this.groundColor.copy(groundColor);
		light.intensity = this.intensity;

		return light;
	}
}