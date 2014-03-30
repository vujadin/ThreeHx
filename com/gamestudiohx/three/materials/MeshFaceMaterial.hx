package com.gamestudiohx.three.materials;

/**
 * @author mrdoob / http://mrdoob.com/
 */

/**
* ...
* @haxeport Krtolica Vujadin - GameStudioHx.com
*/

class MeshFaceMaterial {	
	public var materials:Array<Material>;
	
	public function new(materials:Array<Material> = null) {
		if (materials == null) this.materials = new Array<Material>();
		else this.materials = materials.slice(0);
	}
	
	public function clone():MeshFaceMaterial {
		var material = new MeshFaceMaterial();

		for (i in 0...this.materials.length) {
			material.materials.push(this.materials[i].clone());
		}

		return material;
	}
}