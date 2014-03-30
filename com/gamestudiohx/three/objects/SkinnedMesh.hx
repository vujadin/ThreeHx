package com.gamestudiohx.three.objects;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.THREE;
import com.gamestudiohx.three.math.Matrix4;
//import openfl.utils.Float32Array;

/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class SkinnedMesh extends Mesh
{
	public var useVertexTexture:Bool;

	// init bones
	public var identityMatrix:Matrix4;

	public var bones:Array<Bone>;
	//public var boneMatrices:Array<Float32Array>;
	public var boneInverses:Array<Matrix4>;

	public function new(geometry:Geometry = null, material:Dynamic = null, useVertexTexture:Bool = false) {
		super(geometry, material);
		
		this.useVertexTexture = useVertexTexture;

		// init bones
		this.identityMatrix = new Matrix4();

		this.bones = [];
		//this.boneMatrices = [];
	}
	
	public function addBone(bone:Bone = null):Bone {
		if (bone == null) {
			bone = new Bone(this);
		}

		this.bones.push(bone);

		return bone;
	}
	
	override public function updateMatrixWorld(force:Bool = false):Void {
		var offsetMatrix = new Matrix4();
		
		if (matrixAutoUpdate) updateMatrix();
		
		// update matrixWorld
		if (this.matrixWorldNeedsUpdate || force) {
			if (this.parent != null) {
				this.matrixWorld.multiplyMatrices(this.parent.matrixWorld, this.matrix);
			} else {
				this.matrixWorld.copy(this.matrix);
			}

			this.matrixWorldNeedsUpdate = false;

			force = true;
		}
		
		// update children
		for (key in this.children.keys()) {
			var child = this.children.get(key);
			if (Std.is(child, Bone)) {
				cast(child, Bone).update(this.identityMatrix, false);
			} else {
				child.updateMatrixWorld(true);
			}
		}

		// make a snapshot of the bones' rest position
		if (this.boneInverses == null) {
			this.boneInverses = [];

			for (b in 0...this.bones.length) {
				var inverse:Matrix4 = new Matrix4();
				inverse = inverse.getInverse(this.bones[b].skinMatrix);
				this.boneInverses.push( inverse );
			}
		}

		// flatten bone matrices to array
		for (b in 0...this.bones.length) {
			// compute the offset between the current and the original transform;

			// TODO: we could get rid of this multiplication step if the skinMatrix
			// was already representing the offset; however, this requires some
			// major changes to the animation system
			offsetMatrix.multiplyMatrices(this.bones[b].skinMatrix, this.boneInverses[b]);
			//offsetMatrix.flattenToArrayOffset(this.boneMatrices, b * 16);
		}

		if (this.useVertexTexture) {
			//this.boneTexture.needsUpdate = true;
		}
	}
	
	public function pose():Void {
		this.updateMatrixWorld( true );
		this.normalizeSkinWeights();
	}
	
	public function normalizeSkinWeights():Void {
		if (Std.is(geometry, Geometry)) {
			for (i in 0...this.geometry.skinIndices.length) {
				var sw = this.geometry.skinWeights[ i ];
				var scale = 1.0 / sw.lengthManhattan();
				if (scale != Math.POSITIVE_INFINITY) {
					sw.multiplyScalar( scale );
				} else {
					sw.set(1); // this will be normalized by the shader anyway
				}
			}
		} else {
			// skinning weights assumed to be normalized for THREE.BufferGeometry
		}
	}
	
}