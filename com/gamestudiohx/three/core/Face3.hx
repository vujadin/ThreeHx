package com.gamestudiohx.three.core;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector4;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */
 
class Face3 {
	
	public var a:Int;
	public var b:Int;
	public var c:Int;
	
	public var normal:Vector3;
	public var vertexNormals:Array<Vector3>;
	
	public var color:Color;
	public var vertexColors:Array<Color>;
	
	public var vertexTangents:Array<Vector4>;
	
	public var materialIndex:Int;
	
	public var centroid:Vector3;
	
	// Geometry.computeMorphNormals
	public var __originalFaceNormal:Vector3;
	public var __originalVertexNormals:Array<Vector3>;

	// normal can be Vector3 or Array<Vector3>
	// color can be Color or Array<Color>
	public function new(a:Int, b:Int, c:Int, normal:Dynamic = null, color:Dynamic = null, materialIndex:Int = 0) {
		this.a = a;
		this.b = b;
		this.c = c;
		
		this.normal = Std.is(normal, Vector3) ? normal : new Vector3();
		this.vertexNormals = (normal != null && !Std.is(normal, Vector3)) ? normal : [];		// TODO - check for better solution

		this.color = Std.is(color, Color) ? color : new Color();
		this.vertexColors = (color != null && !Std.is(color, Color)) ? color : [];				// TODO - check for better solution

		this.vertexTangents = [];

		this.materialIndex = materialIndex;

		this.centroid = new Vector3();
	}	
	
	public function clone():Face3 {
		var face = new Face3(this.a, this.b, this.c);

		face.normal.copy(this.normal);
		face.color.copy(this.color);
		face.centroid.copy(this.centroid);

		face.materialIndex = this.materialIndex;

		for (i in 0...this.vertexNormals.length) {
			face.vertexNormals[i] = this.vertexNormals[i].clone();
		}
		for (i in 0...this.vertexColors.length) {
			face.vertexColors[i] = this.vertexColors[i].clone();
		}
		for (i in 0...this.vertexTangents.length) {
			face.vertexTangents[i] = this.vertexTangents[i].clone();
		}

		return face;
	}	
	
}

