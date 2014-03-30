package com.gamestudiohx.three.renderers;

/**
 * @author alteredq / http://alteredqualia.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class WebGLRenderTargetCube extends WebGLRenderTarget {
	
	public var activeCubeFace:Int;

	public function new(width:Float = null, height:Float = null, options:Dynamic = null) {
		super(width, height, options);
		
		this.activeCubeFace = 0; // PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5
	}
	
	/*public function clone():WebGLRenderTargetCube {
		var tmp = new WebGLRenderTargetCube();
		
		tmp.activeCubeFace = this.activeCubeFace;
		
		return tmp;
	}*/
	
}
