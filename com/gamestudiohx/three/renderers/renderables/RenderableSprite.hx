package com.gamestudiohx.three.renderers.renderables;

import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.materials.Material;

/**
 * ...
 * @author Krtolica Vujadin
 */
class RenderableSprite {
	
	public var id:Int;

	public var object:Object3D;

	public var x:Float;
	public var y:Float;
	public var z:Float;

	public var rotation:Float;
	public var scale:Vector2;

	public var material:Material;

	public function new() {
		this.id = 0;

		this.object = null;

		this.x = 0;
		this.y = 0;
		this.z = 0;

		this.rotation = 0;
		this.scale = new Vector2();

		this.material = null;
	}
	
}