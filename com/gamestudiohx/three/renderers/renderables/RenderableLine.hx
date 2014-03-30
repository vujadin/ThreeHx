package com.gamestudiohx.three.renderers.renderables;

import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.math.Color;

/**
 * ...
 * @author Krtolica Vujadin
 */
class RenderableLine {
	
	public var id:Int;

	public var v1:RenderableVertex;
	public var v2:RenderableVertex;

	public var vertexColors:Array<Color>;
	public var material:Material;

	public var z:Float;

	public function new() {
		this.id = 0;

		this.v1 = new RenderableVertex();
		this.v2 = new RenderableVertex();

		this.vertexColors = [new Color(), new Color()];
		this.material = null;

		this.z = 0;
	}
	
}