package com.gamestudiohx.three.cameras;

/**
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class OrthographicCamera extends Camera {
	
	public var left:Float;
	public var right:Float;
	public var top:Float;
	public var bottom:Float;
	public var near:Float;
	public var far:Float;

	
	public function new(left:Float, right:Float, top:Float, bottom:Float, near:Float = 0.1, far:Float = 2000) {
		super();
		
		this.left = left;
		this.right = right;
		this.top = top;
		this.bottom = bottom;
		this.near = near;
		this.far = far;
		updateProjectionMatrix();
	}	
	
	public function updateProjectionMatrix() {
		projectionMatrix.makeOrthographic(left, right, top, bottom, near, far);
	}
	
	public function clone():OrthographicCamera {
		var camera:OrthographicCamera = new OrthographicCamera();

		camera = cast super.__clone(camera);

		camera.left = this.left;
		camera.right = this.right;
		camera.top = this.top;
		camera.bottom = this.bottom;

		camera.near = this.near;
		camera.far = this.far;

		return camera;
	}
	
}
