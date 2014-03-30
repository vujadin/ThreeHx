package com.gamestudiohx.three.cameras;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Vector3;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se/
 * @author WestLangley / http://github.com/WestLangley
*/

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Camera extends Object3D {
	
	public var matrixWorldInverse:Matrix4;
	public var projectionMatrix:Matrix4;
	public var projectionMatrixInverse:Matrix4;
		
	public function new() {
		super();

		matrixWorldInverse = new Matrix4();

		projectionMatrix = new Matrix4();
		projectionMatrixInverse = new Matrix4();
	}
	
	
	override public function lookAt(v:Vector3) {
		// This routine does not support cameras with rotated and/or translated parent(s)
		var m1 = new Matrix4();
		m1.lookAt(this.position, v, this.up);
		this.quaternion.setFromRotationMatrix(m1);
	}
	
	public function __clone(camera:Camera = null):Camera {
		if (camera == null) camera = new Camera();

		camera = cast super._clone(camera);

		camera.matrixWorldInverse.copy(matrixWorldInverse);
		camera.projectionMatrix.copy(projectionMatrix);
		camera.projectionMatrixInverse.copy(projectionMatrixInverse);

		return camera;
	}
}

