package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class CubeGeometry extends Geometry {
	
	public var width:Float;
	public var height:Float;
	public var depth:Float;
	
	public var widthSegments:Int;
	public var heightSegments:Int;
	public var depthSegments:Int;
	
	public function new(width:Float = 10, height:Float = 10, depth:Float = 10, widthSegments:Int = 1, heightSegments:Int = 1, depthSegments:Int = 1) {
		super();

		this.width = width;
		this.height = height;
		this.depth = depth;

		this.widthSegments = widthSegments;
		this.heightSegments = heightSegments;
		this.depthSegments = depthSegments;

		var width_half = this.width / 2;
		var height_half = this.height / 2;
		var depth_half = this.depth / 2;

		buildPlane( 'z', 'y', - 1, - 1, this.depth, this.height, width_half, 0 ); // px
		buildPlane( 'z', 'y',   1, - 1, this.depth, this.height, - width_half, 1 ); // nx
		buildPlane( 'x', 'z',   1,   1, this.width, this.depth, height_half, 2 ); // py
		buildPlane( 'x', 'z',   1, - 1, this.width, this.depth, - height_half, 3 ); // ny
		buildPlane( 'x', 'y',   1, - 1, this.width, this.height, depth_half, 4 ); // pz
		buildPlane( 'x', 'y', - 1, - 1, this.width, this.height, - depth_half, 5 ); // nz
		
		this.mergeVertices();
		this.computeCentroids();			
	}

	function buildPlane(u:String, v:String, udir:Int, vdir:Int, width:Float, height:Float, depth:Float, materialIndex:Int) {
		var w:String;
		var gridX = this.widthSegments;
		var gridY = this.heightSegments;
		var width_half = this.width / 2;
		var height_half = this.height / 2;
		var offset = this.vertices.length;

		if ((u == 'x' && v == 'y') || (u == 'y' && v == 'x')) {
			w = 'z';
		} else if ((u == 'x' && v == 'z') || (u == 'z' && v == 'x')) {
			w = 'y';
			gridY = depthSegments;
		} else if ((u == 'z' && v == 'y') || (u == 'y' && v == 'z')) {
			w = 'x';
			gridX = depthSegments;
		}

		var gridX1 = gridX + 1;
		var gridY1 = gridY + 1;
		var segment_width = width / gridX;
		var segment_height = height / gridY;
		var normal:Vector3 = new Vector3();

		normal.w = depth > 0 ? 1 : - 1;

		for (iy in 0...gridY1) {
			for (ix in 0...gridX1) {
				var vector = new Vector3();
				vector.u = (ix * segment_width - width_half) * udir;
				vector.v = (iy * segment_height - height_half) * vdir;
				vector.w = depth;

				this.vertices.push(vector);
			}
		}

		for (iy in 0...gridY) {
			for (ix in 0...gridX) {
				var a = ix + gridX1 * iy;
				var b = ix + gridX1 * (iy + 1);
				var c = (ix + 1) + gridX1 * (iy + 1);
				var d = (ix + 1) + gridX1 * iy;

				var uva = new Vector2(ix / gridX, 1 - iy / gridY);
				var uvb = new Vector2(ix / gridX, 1 - (iy + 1) / gridY);
				var uvc = new Vector2((ix + 1) / gridX, 1 - (iy + 1) / gridY);
				var uvd = new Vector2((ix + 1) / gridX, 1 - iy / gridY);

				var face = new Face3(a + offset, b + offset, d + offset);
				face.normal.copy(normal);
				face.vertexNormals.push(normal.clone());
				face.vertexNormals.push(normal.clone());
				face.vertexNormals.push(normal.clone());
				face.materialIndex = materialIndex;

				this.faces.push(face);
				this.faceVertexUvs[0].push([uva, uvb, uvd]);

				face = new Face3(b + offset, c + offset, d + offset);
				face.normal.copy(normal);
				face.vertexNormals.push(normal.clone());
				face.vertexNormals.push(normal.clone());
				face.vertexNormals.push(normal.clone());
				face.materialIndex = materialIndex;

				this.faces.push(face);
				this.faceVertexUvs[0].push([uvb.clone(), uvc, uvd.clone()]);
			}
		}
	}
	
}