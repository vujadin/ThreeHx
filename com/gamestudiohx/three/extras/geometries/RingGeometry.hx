package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Sphere;

/**
 * @author Kaleb Murphy
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class RingGeometry extends Geometry {

	public function new(innerRadius:Float = 0, outerRadius:Float = 50, thetaSegments:Int = 8, phiSegments:Int = 8, thetaStart:Float = 0, thetaLength:Float = 6.28318) {
		super();
		
		var tmpUvs = [];
		var radius = innerRadius;
		var radiusStep = ((outerRadius - innerRadius) / phiSegments);
		
		for (i in 0...phiSegments+1) { // concentric circles inside ring
			for (o in 0...thetaSegments+1) { // number of segments per circle
				var vertex = new Vector3();
				var segment = thetaStart + o / thetaSegments * thetaLength;

				vertex.x = radius * Math.cos( segment );
				vertex.y = radius * Math.sin( segment );

				this.vertices.push( vertex );
				tmpUvs.push(new Vector2((vertex.x / outerRadius + 1) / 2, (vertex.y / outerRadius + 1) / 2));
			}

			radius += radiusStep;
		}

		var n = new Vector3(0, 0, 1);

		for (i in 0...phiSegments) { // concentric circles inside ring
			var thetaSegment = i * thetaSegments;
			for (o in 0...thetaSegments+1) { // number of segments per circle
				var segment = o + thetaSegment;

				var v1 = segment + i;
				var v2 = segment + thetaSegments + i;
				var v3 = segment + thetaSegments + 1 + i;

				this.faces.push(new Face3( v1, v2, v3, [n.clone(), n.clone(), n.clone()]));
				this.faceVertexUvs[0].push([tmpUvs[v1].clone(), tmpUvs[v2].clone(), tmpUvs[v3].clone()]);

				v1 = segment + i;
				v2 = segment + thetaSegments + 1 + i;
				v3 = segment + 1 + i;

				this.faces.push(new Face3(v1, v2, v3, [n.clone(), n.clone(), n.clone()]));
				this.faceVertexUvs[0].push([tmpUvs[v1].clone(), tmpUvs[v2].clone(), tmpUvs[v3].clone()]);
			}
		}

		this.computeCentroids();
		this.computeFaceNormals();

		this.boundingSphere = new Sphere( new Vector3(), radius );
	}
	
}