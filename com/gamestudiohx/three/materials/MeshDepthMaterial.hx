package com.gamestudiohx.three.materials;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  opacity: <float>,
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *  depthWrite: <bool>,
 *
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>
 * }
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class MeshDepthMaterial extends Material {

	//public var wireframe:Bool;
	public var wireframeLinewidth:Float;
	
	public function new(parameters:Dynamic = null) {
		super();
		
		this.wireframe = false;
		this.wireframeLinewidth = 1;

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new MeshDepthMaterial();

		material = super.clone(material);

		cast(material, MeshDepthMaterial).wireframe = this.wireframe;
		cast(material, MeshDepthMaterial).wireframeLinewidth = this.wireframeLinewidth;

		return material;
	}
}