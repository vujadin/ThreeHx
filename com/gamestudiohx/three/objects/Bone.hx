package com.gamestudiohx.three.objects;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.THREE;
import com.gamestudiohx.three.math.Matrix4;

/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Bone extends Object3D {

	public var skin:SkinnedMesh;
	public var skinMatrix:Matrix4;
	
	public function new(belongsToSkin:SkinnedMesh) {
		super();
		
		this.skin = belongsToSkin;
		this.skinMatrix = new Matrix4();
	}
	
	public function update(parentSkinMatrix:Matrix4 = null, forceUpdate:Bool = false) {
		// update local
		if (this.matrixAutoUpdate) {
			if(forceUpdate) this.updateMatrix();
		}

		// update skin matrix
		if (forceUpdate || this.matrixWorldNeedsUpdate) {
			if(parentSkinMatrix != null) {
				this.skinMatrix.multiplyMatrices(parentSkinMatrix, this.matrix);
			} else {
				this.skinMatrix.copy(this.matrix);
			}

			this.matrixWorldNeedsUpdate = false;
			forceUpdate = true;
		}

		// update children
		for (key in this.children.keys()) {
			cast(this.children.get(key), Bone).update(this.skinMatrix, forceUpdate);
		}
	}
	
}