package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.core.Face3;

/**
 * @author oosmoxiecode
 * @author mrdoob / http://mrdoob.com/
 * based on http://code.google.com/p/away3d/source/browse/trunk/fp10/Away3DLite/src/away3dlite/primitives/Torus.as?r=2888
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class TorusGeometry extends Geometry {

	var radius:Float; 
	var tube:Float;
	var radialSegments:Int;
	var tubularSegments:Int;
	var arc:Float;
	
	public function new(radius:Float = 100, tube:Float = 40, radialSegments:Int = 8, tubularSegments:Int = 6, arc:Float = null) {
		super();
		
		this.radius = radius;
		this.tube = tube;
		this.radialSegments = radialSegments;
		this.tubularSegments = tubularSegments;
		this.arc = arc == null ? ThreeMath.PI2 : arc;
		
		var center = new Vector3();
		var uvs:Array<Vector2> = [];
		var normals:Array<Vector3> = [];
		
		for (j in 0...this.radialSegments+1) {
			for (i in 0...this.tubularSegments+1) {
				var u = i / this.tubularSegments * this.arc;
				var v = j / this.radialSegments * Math.PI * 2;

				center.x = this.radius * Math.cos(u);
				center.y = this.radius * Math.sin(u);

				var vertex = new Vector3();
				vertex.x = (this.radius + this.tube * Math.cos(v)) * Math.cos(u);
				vertex.y = (this.radius + this.tube * Math.cos(v)) * Math.sin(u);
				vertex.z = this.tube * Math.sin(v);

				this.vertices.push(vertex);

				uvs.push(new Vector2(i / this.tubularSegments, j / this.radialSegments));
				normals.push(vertex.clone().sub(center).normalize());
			}
		}
		
		for (j in 1...this.radialSegments+1) {
			for (i in 1...this.tubularSegments+1) {
				var a = (this.tubularSegments + 1) * j + i - 1;
				var b = (this.tubularSegments + 1) * (j - 1) + i - 1;
				var c = (this.tubularSegments + 1) * (j - 1) + i;
				var d = (this.tubularSegments + 1) * j + i;

				var face = new Face3(a, b, d, [normals[a], normals[b], normals[d]]);
				face.normal.add(normals[a]);
				face.normal.add(normals[b]);
				face.normal.add(normals[d]);
				face.normal.normalize();
				this.faces.push(face);

				this.faceVertexUvs[0].push([uvs[a].clone(), uvs[b].clone(), uvs[d].clone()]);

				face = new Face3(b, c, d, [normals[b], normals[c], normals[d]]);
				face.normal.add(normals[b]);
				face.normal.add(normals[c]);
				face.normal.add(normals[d]);
				face.normal.normalize();

				this.faces.push(face);

				this.faceVertexUvs[0].push([uvs[b].clone(), uvs[c].clone(), uvs[d].clone()]);
			}
		}

		this.mergeVertices();
		this.computeCentroids();
	}
	
}