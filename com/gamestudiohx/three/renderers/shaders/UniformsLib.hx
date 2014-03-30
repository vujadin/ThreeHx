package com.gamestudiohx.three.renderers.shaders;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector4;
import com.gamestudiohx.three.math.Vector2;

/**
 * Uniforms library for shared webgl shaders
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef ULTypeValue = {
	type: String,
	value: Dynamic
}

class UniformsLib {

	public static var common:Map<String, ULTypeValue> = [

		"diffuse" => { type: "c", value: new Color(0xeeeeee) },
		"opacity" => { type: "f", value: 1.0 },

		"map" => { type: "t", value: null },
		"offsetRepeat" => { type: "v4", value: new Vector4(0, 0, 1, 1) },

		"lightMap" => { type: "t", value: null },
		"specularMap" => { type: "t", value: null },

		"envMap" => { type: "t", value: null },
		"flipEnvMap" => { type: "f", value: -1 },
		"useRefract" => { type: "i", value: 0 },
		"reflectivity" => { type: "f", value: 1.0 },
		"refractionRatio" => { type: "f", value: 0.98 },
		"combine" => { type: "i", value: 0 },

		"morphTargetInfluences" => { type: "f", value: 0 }

	];

	public static var bump:Map<String, ULTypeValue> = [

		"bumpMap" => { type: "t", value: null },
		"bumpScale" => { type: "f", value: 1 }

	];

	public static var normalmap:Map<String, ULTypeValue> = [

		"normalMap" => { type: "t", value: null },
		"normalScale" => { type: "v2", value: new Vector2(1, 1) }
	];

	public static var fog:Map<String, ULTypeValue> = [

		"fogDensity" => { type: "f", value: 0.00025 },
		"fogNear" => { type: "f", value: 1 },
		"fogFar" => { type: "f", value: 2000 },
		"fogColor" => { type: "c", value: new Color(0xffffff) }

	];

	public static var lights:Map<String, ULTypeValue> = [

		"ambientLightColor" => { type: "fv", value: [] },

		"directionalLightDirection" => { type: "fv", value: [] },
		"directionalLightColor" => { type: "fv", value: [] },

		"hemisphereLightDirection" => { type: "fv", value: [] },
		"hemisphereLightSkyColor" => { type: "fv", value: [] },
		"hemisphereLightGroundColor" => { type: "fv", value: [] },

		"pointLightColor" => { type: "fv", value: [] },
		"pointLightPosition" => { type: "fv", value: [] },
		"pointLightDistance" => { type: "fv1", value: [] },

		"spotLightColor" => { type: "fv", value: [] },
		"spotLightPosition" => { type: "fv", value: [] },
		"spotLightDirection" => { type: "fv", value: [] },
		"spotLightDistance" => { type: "fv1", value: [] },
		"spotLightAngleCos" => { type: "fv1", value: [] },
		"spotLightExponent" => { type: "fv1", value: [] }

	];

	public static var particle:Map<String, ULTypeValue> = [

		"psColor" => { type: "c", value: new Color(0xeeeeee) },
		"opacity" => { type: "f", value: 1.0 },
		"size" => { type: "f", value: 1.0 },
		"scale" => { type: "f", value: 1.0 },
		"map" => { type: "t", value: null },

		"fogDensity" => { type: "f", value: 0.00025 },
		"fogNear" => { type: "f", value: 1 },
		"fogFar" => { type: "f", value: 2000 },
		"fogColor" => { type: "c", value: new Color(0xffffff) }

	];

	public static var shadowmap:Map<String, ULTypeValue> = [

		"shadowMap" => { type: "tv", value: [] },
		"shadowMapSize" => { type: "v2v", value: [] },

		"shadowBias" => { type: "fv1", value: [] },
		"shadowDarkness" => { type: "fv1", value: [] },

		"shadowMatrix" => { type: "m4v", value: [] }

	];
	
}