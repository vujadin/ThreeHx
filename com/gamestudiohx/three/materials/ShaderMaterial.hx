package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.THREE;
import com.gamestudiohx.three.renderers.shaders.UniformsUtils;
import com.gamestudiohx.three.renderers.shaders.UniformsLib.ULTypeValue;
import openfl.utils.Float32Array;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  fragmentShader: <string>,
 *  vertexShader: <string>,
 *
 *  uniforms: { "parameter1": { type: "f", value: 1.0 }, "parameter2": { type: "i" value2: 2 } },
 *
 *  defines: { "label" : "value" },
 *
 *  shading: THREE.SmoothShading,
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *  depthWrite: <bool>,
 *
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>,
 *
 *  lights: <bool>,
 *
 *  vertexColors: THREE.NoColors / THREE.VertexColors / THREE.FaceColors,
 *
 *  skinning: <bool>,
 *  morphTargets: <bool>,
 *  morphNormals: <bool>,
 *
 *	fog: <bool>
 * }
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class ShaderMaterial extends Material {
	
	public var fragmentShader:String;
	public var vertexShader:String;
	public var uniforms:Map<String, ULTypeValue>;
	public var defines:Dynamic;
	public var attributes:Map<String, Dynamic>;
	
	//public var shading:Int;
	
	public var lineWidht:Float;
	
	//public var wireframe:Bool;
	public var wireframeLinewidth:Float;
	
	public var fog:Bool;
	
	public var lights:Bool;
	
	//public var vertexColors:Int;
	
	public var skinning:Bool;
	
	public var _shadowPass:Bool;
	
	//public var morphTargets:Bool;
	//public var morphNormals:Bool;
	
	//public var defaultAttributeValues:Map<String, Array<Dynamic>>;
	
	public var index0AttributeName:String;

	public function new(parameters:Dynamic = null) {
		super();
		
		this.fragmentShader = "void main() {}";
		this.vertexShader = "void main() {}";
		this.uniforms = new Map<String, ULTypeValue>();
		this.defines = {};
		this.attributes = null;

		this.shading = THREE.SmoothShading;

		//this.linewidth = 1;

		this.wireframe = false;
		//this.wireframeLinewidth = 1;

		this.fog = false; // set to use scene fog

		this.lights = false; // set to use scene lights

		this.vertexColors = THREE.NoColors; // set to use "color" attribute stream

		this.skinning = false; // set to use skinning attribute streams

		//this.morphTargets = false; // set to use morph targets
		this.morphNormals = false; // set to use morph normals

		// When rendered geometry doesn't include these attributes but the material does,
		// use these default values in WebGL. This avoids errors when buffer data is missing.
		this.defaultAttributeValues.set("color", new Float32Array([1, 1, 1]));// = { "color" => [1, 1, 1], "uv" => [0, 0], "uv2" => [0, 0] };
		this.defaultAttributeValues.set("uv", new Float32Array([0, 0]));
		this.defaultAttributeValues.set("uv2", new Float32Array([0, 0]));

		// By default, bind position to attribute index 0. In WebGL, attribute 0
		// should always be used to avoid potentially expensive emulation.
		this.index0AttributeName = "position";

		this.setValues(parameters);
	}
	
	override public function clone(mat:Material = null):Material {
		var material = new ShaderMaterial();

		material = cast super.clone(material);

		material.fragmentShader = this.fragmentShader;
		material.vertexShader = this.vertexShader;

		material.uniforms = UniformsUtils.clone(this.uniforms);

		material.attributes = this.attributes;
		material.defines = this.defines;

		material.shading = this.shading;

		material.wireframe = this.wireframe;
		material.wireframeLinewidth = this.wireframeLinewidth;

		material.fog = this.fog;

		material.lights = this.lights;

		material.vertexColors = this.vertexColors;

		material.skinning = this.skinning;

		material.morphTargets = this.morphTargets;
		material.morphNormals = this.morphNormals;

		return material;
	}
	
}