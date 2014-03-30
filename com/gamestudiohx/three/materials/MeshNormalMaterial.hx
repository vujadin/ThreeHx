package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 *
 * parameters = {
 *  opacity: <float>,
 *
 *  shading: THREE.FlatShading,
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

class MeshNormalMaterial extends Material {

	//public var shading:Int;

	//public var wireframe:Bool;
	public var wireframeLinewidth:Float;
	public var wireframeLinecap:String;
	public var wireframeLinejoin:String;

	//public var morphTargets:Bool;
	
	public function new(parameters:Dynamic = null) {
		super();
		
		this.shading = THREE.FlatShading;

		this.wireframe = false;
		this.wireframeLinewidth = 1;
		this.wireframeLinecap = 'round';
		this.wireframeLinejoin = 'round';

		this.morphTargets = false;

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new MeshNormalMaterial();

		material = super.clone(material);

		cast(material, MeshNormalMaterial).shading = this.shading;

		cast(material, MeshNormalMaterial).wireframe = this.wireframe;
		cast(material, MeshNormalMaterial).wireframeLinewidth = this.wireframeLinewidth;

		return material;
	}
	
}