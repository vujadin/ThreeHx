package com.gamestudiohx.three.renderers.renderables;

import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector4;

/**
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class RenderableVertex {
	
	public var positionWorld:Vector3;
	public var positionScreen:Vector4;

	public var visible:Bool;

	public function new() {
		this.positionWorld = new Vector3();
		this.positionScreen = new Vector4();

		this.visible = true;
	}
	
	public function copy(vertex:RenderableVertex) {
		this.positionWorld.copy(vertex.positionWorld);
		this.positionScreen.copy(vertex.positionScreen);
	}
	
}