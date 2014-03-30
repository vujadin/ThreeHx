package com.gamestudiohx.three.cameras;

//import com.gamestudiohx.three.extras.MathUtils;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.math.ThreeMath;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author greggman / http://games.greggman.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class PerspectiveCamera extends Camera {

	public var fov:Float;
	public var aspect:Float;
	public var near:Float;
	public var far:Float;
	
	public var fullWidth:Float;
	public var fullHeight:Float;
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;	
	
	public function new(fov:Float = 50, aspect:Float = 1, near:Float = 0.1, far:Float = 2000) {
		super();
		this.fov = fov;
		this.aspect = aspect;
		this.near = near;
		this.far = far;
		
		this.fullWidth = this.fullHeight = 0;
		
		updateProjectionMatrix();
	}
	
	/**
	 * Uses Focal Length (in mm) to estimate and set FOV
	 * 35mm (fullframe) camera is used if frame size is not specified;
	 * Formula based on http://www.bobatkins.com/photography/technical/field_of_view.html
	 */
	public function setLens (focalLength:Float, frameHeight:Float = 24) {
		fov = 2 * ThreeMath.radToDeg(Math.atan(frameHeight / (focalLength * 2)));
		updateProjectionMatrix();
	}
	
	/**
	 * Sets an offset in a larger frustum. This is useful for multi-window or
	 * multi-monitor/multi-machine setups.
	 *
	 * For example, if you have 3x2 monitors and each monitor is 1920x1080 and
	 * the monitors are in grid like this
	 *
	 *   +---+---+---+
	 *   | A | B | C |
	 *   +---+---+---+
	 *   | D | E | F |
	 *   +---+---+---+
	 *
	 * then for each monitor you would call it like this
	 *
	 *   var w = 1920;
	 *   var h = 1080;
	 *   var fullWidth = w * 3;
	 *   var fullHeight = h * 2;
	 *
	 *   --A--
	 *   camera.setOffset( fullWidth, fullHeight, w * 0, h * 0, w, h );
	 *   --B--
	 *   camera.setOffset( fullWidth, fullHeight, w * 1, h * 0, w, h );
	 *   --C--
	 *   camera.setOffset( fullWidth, fullHeight, w * 2, h * 0, w, h );
	 *   --D--
	 *   camera.setOffset( fullWidth, fullHeight, w * 0, h * 1, w, h );
	 *   --E--
	 *   camera.setOffset( fullWidth, fullHeight, w * 1, h * 1, w, h );
	 *   --F--
	 *   camera.setOffset( fullWidth, fullHeight, w * 2, h * 1, w, h );
	 *
	 *   Note there is no reason monitors have to be the same size or in a grid.
	 */
	public function setViewOffset (fullWidth:Float, fullHeight:Float, x:Float, y:Float, width:Float, height:Float) {
		this.fullWidth = fullWidth;
		this.fullHeight = fullHeight;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		updateProjectionMatrix();
	}
	
	
	public function updateProjectionMatrix() {
		if (fullWidth != 0) {
			var aspect = fullWidth / fullHeight;
			var top = Math.tan(ThreeMath.degToRad(fov * 0.5)) * near;
			var bottom = -top;
			var left = aspect * bottom;
			var right = aspect * top;
			var width = Math.abs(right - left);
			var height = Math.abs(top - bottom);

			projectionMatrix.makeFrustum(
				left + x * width / fullWidth,
				left + (x + width ) * width / fullWidth,
				top - (y + height) * height / fullHeight,
				top - y * height / fullHeight,
				near,
				far
			);

		} else {
			projectionMatrix.makePerspective(fov, aspect, near, far);
		}		
	}
	
	public function clone(camera:PerspectiveCamera = null):PerspectiveCamera {
		if (camera == null) camera = new PerspectiveCamera();

		camera = cast super.__clone(camera);

		camera.fov = fov;
		camera.aspect = aspect;
		camera.near = near;
		camera.far = far;

		return camera;
	}
}


