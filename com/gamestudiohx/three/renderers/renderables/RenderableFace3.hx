package com.gamestudiohx.three.renderers.renderables;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.materials.Material;

/**
 * ...
 * @author Krtolica Vujadin
 */
class RenderableFace3 {
	
	public var id:Int;
	
	public var v1:RenderableVertex;
	public var v2:RenderableVertex;
	public var v3:RenderableVertex;
	
	public var centroidModel:Vector3;
	
	public var normalModel:Vector3;
	public var normalModelView:Vector3;
	
	public var vertexNormalsLength:Int;
	public var vertexNormalsModel:Array<Vector3>;
	public var vertexNormalsModelView:Array<Vector3>;
	
	public var color:Color;
	public var material:Material;
	public var uvs:Array<Array<Vector2>>;
	
	public var z:Float;

	public function new() {
		this.id = 0;

		this.v1 = new RenderableVertex();
		this.v2 = new RenderableVertex();
		this.v3 = new RenderableVertex();

		this.centroidModel = new Vector3();

		this.normalModel = new Vector3();
		this.normalModelView = new Vector3();

		this.vertexNormalsLength = 0;
		this.vertexNormalsModel = [new Vector3(), new Vector3(), new Vector3()];
		this.vertexNormalsModelView = [new Vector3(), new Vector3(), new Vector3()];

		this.color = null;
		this.material = null;
		this.uvs = new Array<Array<Vector2>>();
		uvs.push(new Array<Vector2>());

		this.z = 0;
	}
	
}