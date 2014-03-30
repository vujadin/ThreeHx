package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.math.ThreeMath;

/**
 * @author hughes
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */


class CircleGeometry extends Geometry {

	public var radius:Float;
	public var segments:Int;
	
	public var thetaStart:Float;
	public var thetaLength:Float;
	
	public function new(radius:Float = 50, segments:Int = 8, thetaStart:Float = 0, thetaLength:Float = null):Void {
		super();
		
		this.radius = radius;
		this.segments = Std.int(Math.max(3, segments));

		this.thetaStart = thetaStart;
		this.thetaLength = thetaLength == null ? ThreeMath.PI2 : thetaLength;
		
		var uvs:Array<Vector2> = [];
		var center:Vector3 = new Vector3();
		var centerUV:Vector2 = new Vector2(.5, .5);
		
		this.vertices.push(center);
		uvs.push(centerUV);
		
		for(i in 0...segments+1) {
			var vertex = new Vector3();
			var segment = thetaStart + i / segments * thetaLength;

			vertex.x = radius * Math.cos(segment);
			vertex.y = radius * Math.sin(segment);

			vertices.push(vertex);
			uvs.push(new Vector2((vertex.x / radius + 1) / 2, (vertex.y / radius + 1) / 2));
		}
		
		var n = new Vector3(0, 0, 1);
		
		for(i in 1...segments+1) {
			var v1 = i;
			var v2 = i + 1;
			var v3 = 0;

			this.faces.push(new Face3(v1, v2, v3, [n.clone(), n.clone(), n.clone()]));			
			this.faceVertexUvs[0].push([uvs[i].clone(), uvs[i + 1].clone(), centerUV.clone()]);
		}
		
		this.computeCentroids();
		this.computeFaceNormals();

		this.boundingSphere = new Sphere(new Vector3(), radius);
	}

}
