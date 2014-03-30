package com.gamestudiohx.three.renderers.renderables;

import com.gamestudiohx.three.core.Object3D;

/**
 * ...
 * @author Krtolica Vujadin
 */
class RenderableObject {

	public var id:Int;
	public var object:Object3D;
	public var z:Float;
	
	public function new() {
		this.id = 0;

		this.object = null;
		this.z = 0;
	}
	
}