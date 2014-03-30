package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.ThreeMath;

/**
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */
 
class SphereGeometry extends Geometry {
	
	public var radius:Float;
	
	public var widthSegments:Int;
	public var heightSegments:Int;
	
	public var phiStart:Float;
	public var phiLength:Float;
	
	public var thetaStart:Float;
	public var thetaLength:Float;

	public function new(radius:Float = 50, widthSegments:Int = 8, heightSegments:Int = 6, phiStart:Float = 0, phiLength:Float = null, thetaStart:Float = 0, thetaLength:Float = null) {
		super();
		
		this.radius = radius;
		this.widthSegments = widthSegments;
		this.heightSegments = heightSegments;
		this.phiLength = phiLength == null ? ThreeMath.PI2 : phiLength;
		this.thetaLength = thetaLength == null ? Math.PI : thetaLength;
		
		var _vertices = [];
		var _uvs = [];
		
		for (y in 0...heightSegments+1) {
			var verticesRow = [];
			var uvsRow = [];

			for (x in 0...widthSegments+1) {
				var u = x / widthSegments;
				var v = y / heightSegments;

				var vertex = new Vector3();
				vertex.x = -radius * Math.cos(phiStart + u * phiLength) * Math.sin(thetaStart + v * thetaLength);
				vertex.y = radius * Math.cos(thetaStart + v * thetaLength);
				vertex.z = radius * Math.sin(phiStart + u * phiLength) * Math.sin(thetaStart + v * thetaLength);

				this.vertices.push(vertex);

				verticesRow.push(this.vertices.length - 1);
				uvsRow.push(new Vector2(u, 1 - v));
			}

			_vertices.push(verticesRow);
			_uvs.push(uvsRow);
		}
		
		for (y in 0...this.heightSegments) {
			for (x in 0...this.widthSegments) {
				var v1 = _vertices[y][x + 1];
				var v2 = _vertices[y][x];
				var v3 = _vertices[y + 1][x];
				var v4 = _vertices[y + 1][x + 1];

				var n1 = this.vertices[v1].clone().normalize();
				var n2 = this.vertices[v2].clone().normalize();
				var n3 = this.vertices[v3].clone().normalize();
				var n4 = this.vertices[v4].clone().normalize();

				var uv1 = _uvs[y][x + 1].clone();
				var uv2 = _uvs[y][x].clone();
				var uv3 = _uvs[y + 1][x].clone();
				var uv4 = _uvs[y + 1][x + 1].clone();

				if (Math.abs(this.vertices[v1].y) == this.radius) {
					uv1.x = (uv1.x + uv2.x) / 2;
					this.faces.push(new Face3(v1, v3, v4, [n1, n3, n4]));
					this.faceVertexUvs[0].push([uv1, uv3, uv4]);

				} else if (Math.abs(this.vertices[v3].y) == this.radius) {
					uv3.x = (uv3.x + uv4.x) / 2;
					this.faces.push(new Face3(v1, v2, v3, [n1, n2, n3]));
					this.faceVertexUvs[0].push([uv1, uv2, uv3]);
				} else {
					this.faces.push(new Face3(v1, v2, v4, [n1, n2, n4]));
					this.faceVertexUvs[0].push([uv1, uv2, uv4]);

					this.faces.push(new Face3(v2, v3, v4, [n2.clone(), n3, n4.clone()]));
					this.faceVertexUvs[0].push([uv2.clone(), uv3, uv4.clone()]);
				}
			}
		}

		this.computeCentroids();
		this.computeFaceNormals();

		this.boundingSphere = new Sphere(new Vector3(), radius);
	}
	
}
