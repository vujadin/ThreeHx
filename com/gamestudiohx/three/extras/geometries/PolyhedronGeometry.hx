package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.core.Face3;


/**
 * @author clockworkgeek / https://github.com/clockworkgeek
 * @author timothypratley / https://github.com/timothypratley
 * @author WestLangley / http://github.com/WestLangley
*/

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class PolyhedronGeometry extends Geometry
{
	public var radius:Float;
	public var detail:Int;
	
	public function new(vertices:Array<Array<Float>>, faces:Array<Array<Int>>, radius:Float = 1, detail:Int = 0) {
		super();
		
		this.radius = radius;
		this.detail = detail;
		
		for (i in 0...vertices.length) {
			this.vertices[i] = prepare(new Vector3(vertices[i][0], vertices[i][1], vertices[i][2]));
		}
		
		var midpoints = [], p = this.vertices;
		
		var f:Array<Face3> = [];
		for (i in 0...faces.length) {
			var v1:PolyhedronVertex = cast p[faces[i][0]];
			var v2:PolyhedronVertex = cast p[faces[i][1]];
			var v3:PolyhedronVertex = cast p[faces[i][2]];
			f.push(new Face3(v1.index, v2.index, v3.index, [v1.clone(), v2.clone(), v3.clone()]));
			trace(f[i]);
		}
		
		for (i in 0...f.length) {
			subdivide(f[i], detail);
		}
		
		// Handle case when face straddles the seam
		for (i in 0...this.faceVertexUvs[0].length) {
			var uvs = this.faceVertexUvs[0][i];

			var x0 = uvs[0].x;
			var x1 = uvs[1].x;
			var x2 = uvs[2].x;

			var max = Math.max(x0, Math.max(x1, x2));
			var min = Math.min(x0, Math.min(x1, x2));

			if (max > 0.9 && min < 0.1) { // 0.9 is somewhat arbitrary
				if (x0 < 0.2) uvs[0].x += 1;
				if (x1 < 0.2) uvs[1].x += 1;
				if (x2 < 0.2) uvs[2].x += 1;
			}
		}

		// Apply radius
		for (i in 0...this.vertices.length) {
			this.vertices[i].multiplyScalar(radius);
		}

		// Merge vertices
		this.mergeVertices();
		this.computeCentroids();
		this.computeFaceNormals();

		this.boundingSphere = new Sphere(new Vector3(), radius);
	}
	
	// Project vector onto sphere's surface
	private function prepare(vector:Vector3):PolyhedronVertex {
		var vertex:PolyhedronVertex = cast vector.normalize().clone();
		vertex.index = vertices.push(vertex) - 1;

		// Texture coords are equivalent to map coords, calculate angle and convert to fraction of a circle.
		var u = azimuth(vector) / 2 / Math.PI + 0.5;
		var v = inclination(vector) / Math.PI + 0.5;
		vertex.uv = new Vector2(u, 1 - v);

		return vertex;
	}
	
	// Approximate a curved face with recursively sub-divided triangles.
	function make(v1:PolyhedronVertex, v2:PolyhedronVertex, v3:PolyhedronVertex) {
		var face:Face3 = new Face3(v1.index, v2.index, v3.index, [v1.clone(), v2.clone(), v3.clone()]);
		face.centroid.add(v1).add(v2).add(v3).divideScalar(3);
		faces.push(face);

		var azi = azimuth(face.centroid);

		faceVertexUvs[0].push([
			correctUV(v1.uv, v1, azi),
			correctUV(v2.uv, v2, azi),
			correctUV(v3.uv, v3, azi)
		]);
	}
	
	// Analytically subdivide a face to the required detail level.
	function subdivide(face:Face3, detail:Int) {
		var cols:Int = Std.int(Math.pow(2, detail));
		var cells:Int = Std.int(Math.pow(4, detail));
		var a = prepare(vertices[face.a]);
		var b = prepare(vertices[face.b]);
		var c = prepare(vertices[face.c]);
		var v:Array<Array<PolyhedronVertex>> = [];

		// Construct all of the vertices for this subdivision.
		for (i in 0...cols+1) {
			v[i] = new Array<PolyhedronVertex>();

			var aj = prepare(a.clone().lerp(c, i / cols));
			var bj = prepare(b.clone().lerp(c, i / cols));
			var rows:Int = cols - i;

			for (j in 0...rows+1) {
				if (j == 0 && i == cols) {
					v[i][j] = aj;
				} else {
					v[i][j] = prepare(aj.clone().lerp(bj, j / rows));
				}
			}
		}

		// Construct all of the faces.
		for (i in 0...cols) {
			var __t = (2 * (cols - i) - 1);
			for (j in 0...__t) {
				var k = Math.floor(j / 2);
				if (j % 2 == 0) {
					make(v[i][k + 1], v[i + 1][k], v[i][k]);
				} else {
					make(v[i][k + 1], v[i + 1][k + 1], v[i + 1][k]);
				}
			}
		}
	}

	// Angle around the Y axis, counter-clockwise when looking from above.
	function azimuth(vector:Vector3) {
		return Math.atan2(vector.z, -vector.x);
	}

	// Angle above the XZ plane.
	function inclination(vector:Vector3) {
		return Math.atan2(-vector.y, Math.sqrt((vector.x * vector.x) + (vector.z * vector.z)));
	}

	// Texture fixing helper. Spheres have some odd behaviours.
	function correctUV(uv:Vector2, vector:Vector3, azimuth:Float):Vector2 {
		if ((azimuth < 0) && (uv.x == 1)) uv = new Vector2(uv.x - 1, uv.y);
		if ((vector.x == 0) && (vector.z == 0)) uv = new Vector2(azimuth / 2 / Math.PI + 0.5, uv.y);
		return uv.clone();
	}
}

class PolyhedronVertex extends Vector3 {
	public var index:Int;
	public var uv:Vector2;
	
	public function new(x:Float, y:Float, z:Float) {
		super(x, y, z);
	}
}