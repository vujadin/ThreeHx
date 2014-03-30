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
 * based on http://code.google.com/p/away3d/source/browse/trunk/fp10/Away3D/src/away3d/primitives/TorusKnot.as?spec=svn2473&r=2473
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class TorusKnotGeometry extends Geometry {

	var radius:Float; 
	var tube:Float;
	var radialSegments:Int;
	var tubularSegments:Int;
	var p:Int;
	var q:Int;
	var heightScale:Float;
	var grid:Array<Array<Int>>;
	
	public function new(radius:Float = 100, tube:Float = 40, radialSegments:Int = 64, tubularSegments:Int = 8, p:Int = 2, q:Int = 3, heightScale:Float = 1) {
		super();
		
		this.radius = radius;
		this.tube = tube;
		this.radialSegments = radialSegments;
		this.tubularSegments = tubularSegments;
		this.p = p;
		this.q = q;
		this.heightScale = heightScale;
		this.grid = [];
		
		var tang = new Vector3();
		var n = new Vector3();
		var bitan = new Vector3();
		
		for (i in 0...this.radialSegments) {
			this.grid[i] = [];
			var u = i / this.radialSegments * 2 * this.p * Math.PI;
			var p1 = getPos(u, this.q, this.p, this.radius, this.heightScale);
			var p2 = getPos(u + 0.01, this.q, this.p, this.radius, this.heightScale);
			tang.subVectors(p2, p1);
			n.addVectors(p2, p1);

			bitan.crossVectors(tang, n);
			n.crossVectors(bitan, tang);
			bitan.normalize();
			n.normalize();

			for (j in 0...this.tubularSegments) {
				var v = j / this.tubularSegments * 2 * Math.PI;
				var cx = -this.tube * Math.cos(v); // TODO: Hack: Negating it so it faces outside.
				var cy = this.tube * Math.sin(v);

				var pos = new Vector3();
				pos.x = p1.x + cx * n.x + cy * bitan.x;
				pos.y = p1.y + cx * n.y + cy * bitan.y;
				pos.z = p1.z + cx * n.z + cy * bitan.z;

				this.grid[i][j] = this.vertices.push(pos) - 1;
			}
		}

		for (i in 0...this.radialSegments) {
			for (j in 0...this.tubularSegments) {
				var ip = (i + 1) % this.radialSegments;
				var jp = (j + 1) % this.tubularSegments;

				var a = this.grid[i][j];
				var b = this.grid[ip][j];
				var c = this.grid[ip][jp];
				var d = this.grid[i][jp];

				var uva = new Vector2(i / this.radialSegments, j / this.tubularSegments);
				var uvb = new Vector2((i + 1) / this.radialSegments, j / this.tubularSegments);
				var uvc = new Vector2((i + 1) / this.radialSegments, (j + 1) / this.tubularSegments);
				var uvd = new Vector2(i / this.radialSegments, (j + 1) / this.tubularSegments);
				
				this.faces.push(new Face3(a, b, d));
				this.faceVertexUvs[0].push([uva, uvb, uvd]);

				this.faces.push(new Face3(b, c, d));
				this.faceVertexUvs[0].push([uvb.clone(), uvc, uvd.clone()]);
			}
		}

		this.computeCentroids();
		this.computeFaceNormals();
		this.computeVertexNormals();
	}
	
	function getPos(u:Float, in_q:Int, in_p:Int, radius:Float, heightScale:Float) {
		var cu = Math.cos(u);
		var su = Math.sin(u);
		var quOverP = in_q / in_p * u;
		var cs = Math.cos(quOverP);

		var tx = radius * (2 + cs) * 0.5 * cu;
		var ty = radius * (2 + cs) * su * 0.5;
		var tz = heightScale * radius * Math.sin(quOverP) * 0.5;

		return new Vector3(tx, ty, tz);
	}
	
}