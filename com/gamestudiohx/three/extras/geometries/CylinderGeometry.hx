package com.gamestudiohx.three.extras.geometries;

import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector2;

/**
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class CylinderGeometry extends Geometry {
	
	public var radiusTop:Float;
	public var radiusBottom:Float;
	public var height:Float;
	
	public var radialSegments:Int;
	public var heightSegments:Int;
	public var openEnded:Bool;

	public function new(radiusTop:Float = 20, radiusBottom:Float = 20, height:Float = 100, radialSegments:Int = 8, heightSegments:Int = 1, openEnded:Bool = false) {
		super();
		
		this.radiusTop = radiusTop;
		this.radiusBottom = radiusBottom;
		this.height = height;

		this.radialSegments = radialSegments;
		this.heightSegments = heightSegments;

		this.openEnded = openEnded;

		var heightHalf:Float = height / 2;

		var tmpVertices:Array<Array<Int>> = [];
		var tmpUvs:Array<Array<Vector2>> = [];
		
		var x:Int = 0;
		var y:Int = 0;
		
		while (y <= heightSegments) {
			var verticesRow:Array<Int> = [];
			var uvsRow:Array<Vector2> = [];

			var v = y / heightSegments;
			var radius = v * ( radiusBottom - radiusTop ) + radiusTop;

			x = 0;
			while (x <= radialSegments+1) {
				var u = x / radialSegments;

				var vertex = new Vector3();
				vertex.x = radius * Math.sin( u * Math.PI * 2 );
				vertex.y = - v * height + heightHalf;
				vertex.z = radius * Math.cos( u * Math.PI * 2 );

				vertices.push( vertex );

				verticesRow.push( this.vertices.length - 1 );
				uvsRow.push( new Vector2( u, 1 - v ) );
				x++;
			}

			tmpVertices.push( verticesRow );
			tmpUvs.push( uvsRow );
			y++;
		}
		
		var tanTheta = ( radiusBottom - radiusTop ) / height;
		var na:Vector3 = new Vector3();
		var nb:Vector3 = new Vector3();

		x = 0;
		while (x < radialSegments) {
			if ( radiusTop != 0 ) {
				na = vertices[ tmpVertices[ 0 ][ x ] ].clone();
				nb = vertices[ tmpVertices[ 0 ][ x + 1 ] ].clone();
			} else {
				na = vertices[ tmpVertices[ 1 ][ x ] ].clone();
				nb = vertices[ tmpVertices[ 1 ][ x + 1 ] ].clone();
			}

			na.setY( Math.sqrt( na.x * na.x + na.z * na.z ) * tanTheta ).normalize();
			nb.setY( Math.sqrt( nb.x * nb.x + nb.z * nb.z ) * tanTheta ).normalize();

			y = 0;
			while (y < heightSegments) {
				var v1 = tmpVertices[ y ][ x ];
				var v2 = tmpVertices[ y + 1 ][ x ];
				var v3 = tmpVertices[ y + 1 ][ x + 1 ];
				var v4 = tmpVertices[ y ][ x + 1 ];

				var n1 = na.clone();
				var n2 = na.clone();
				var n3 = nb.clone();
				var n4 = nb.clone();

				var uv1 = tmpUvs[ y ][ x ].clone();
				var uv2 = tmpUvs[ y + 1 ][ x ].clone();
				var uv3 = tmpUvs[ y + 1 ][ x + 1 ].clone();
				var uv4 = tmpUvs[ y ][ x + 1 ].clone();

				faces.push( new Face3( v1, v2, v4, [ n1, n2, n4 ] ) );
				faceVertexUvs[ 0 ].push( [ uv1, uv2, uv4 ] );

				faces.push( new Face3( v2, v3, v4, [ n2.clone(), n3, n4.clone() ] ) );
				faceVertexUvs[ 0 ].push( [ uv2.clone(), uv3, uv4.clone() ] );
				y++;
			}
			x++;
		}
		
		// top cap
		if ( openEnded == false && radiusTop > 0 ) {
			vertices.push( new Vector3( 0, heightHalf, 0 ) );

			x = 0;
			while (x < radialSegments) {
				var v1 = tmpVertices[ 0 ][ x ];
				var v2 = tmpVertices[ 0 ][ x + 1 ];
				var v3 = vertices.length - 1;

				var n1 = new Vector3( 0, 1, 0 );
				var n2 = new Vector3( 0, 1, 0 );
				var n3 = new Vector3( 0, 1, 0 );

				var uv1 = tmpUvs[ 0 ][ x ].clone();
				var uv2 = tmpUvs[ 0 ][ x + 1 ].clone();
				var uv3 = new Vector2( uv2.x, 0 );

				faces.push( new Face3( v1, v2, v3, [ n1, n2, n3 ] ) );
				faceVertexUvs[ 0 ].push( [ uv1, uv2, uv3 ] );
				x++;
			}

		}

		// bottom cap
		if ( openEnded == false && radiusBottom > 0 ) {
			this.vertices.push( new Vector3( 0, - heightHalf, 0 ) );
			x = 0;
			while (x < radialSegments) {
				var v1 = tmpVertices[ y ][ x + 1 ];
				var v2 = tmpVertices[ y ][ x ];
				var v3 = vertices.length - 1;

				var n1 = new Vector3( 0, - 1, 0 );
				var n2 = new Vector3( 0, - 1, 0 );
				var n3 = new Vector3( 0, - 1, 0 );

				var uv1 = tmpUvs[ y ][ x + 1 ].clone();
				var uv2 = tmpUvs[ y ][ x ].clone();
				var uv3 = new Vector2( uv2.x, 1 );

				faces.push( new Face3( v1, v2, v3, [ n1, n2, n3 ] ) );
				faceVertexUvs[ 0 ].push( [ uv1, uv2, uv3 ] );
				x++;
			}
		}
		
		this.mergeVertices();
		this.computeCentroids();
		this.computeFaceNormals();
	}
	
}