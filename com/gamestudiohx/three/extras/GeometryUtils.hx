package com.gamestudiohx.three.extras;

import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.core.Face4;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.math.TMath;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Matrix3;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.objects.Mesh;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class GeometryUtils {

	// Merge two geometries or geometry and geometry from object (using object's transform)
	static public function merge(geometry1:Geometry, object2:Dynamic, materialIndexOffset:Int = 0)	{
		var matrix:Matrix4;
		var normalMatrix:Matrix3;
		var vertexOffset:Int = geometry1.vertices.length;
		var uvPosition:Int = geometry1.faceVertexUvs[0].length;
		var geometry2 = Std.is(object2, Mesh) ? object2.geometry : object2;
		var vertices1:Array<Vector3> = geometry1.vertices;
		var vertices2:Array<Vector3> = geometry2.vertices;
		var faces1:Array<Dynamic> = geometry1.faces;
		var faces2:Array<Dynamic> = geometry2.faces;
		var uvs1:Array<Dynamic> = geometry1.faceVertexUvs[0];
		var uvs2:Array<Dynamic> = geometry2.faceVertexUvs[0];

		if (Std.is(object2, Mesh)) {
			object2.matrixAutoUpdate && object2.updateMatrix();
			matrix = object2.matrix;
			normalMatrix = new Matrix3().getNormalMatrix(matrix);
		}

		// vertices
		for (i in 0...vertices2.length) {
			var vertex = vertices2[i];
			var vertexCopy = vertex.clone();
			if (matrix != null) vertexCopy.applyMatrix4(matrix);
			vertices1.push(vertexCopy);
		}

		// faces
		for (i in 0...faces2.length) {
			var face = faces2[i], faceCopy, normal, color;
			var faceVertexNormals = face.vertexNormals;
			var faceVertexColors = face.vertexColors;

			faceCopy = new Face3(face.a + vertexOffset, face.b + vertexOffset, face.c + vertexOffset);
			faceCopy.normal.copy(face.normal);

			if (normalMatrix != null) {
				faceCopy.normal.applyMatrix3(normalMatrix).normalize();
			}

			for (j in 0...faceVertexNormals.length) {
				normal = faceVertexNormals[j].clone();
				if (normalMatrix) {
					normal.applyMatrix3(normalMatrix).normalize();
				}

				faceCopy.vertexNormals.push(normal);			}

			faceCopy.color.copy(face.color);

			for (j in 0...faceVertexColors.length) {
				color = faceVertexColors[j];
				faceCopy.vertexColors.push(color.clone());
			}

			faceCopy.materialIndex = face.materialIndex + materialIndexOffset;
			faceCopy.centroid.copy(face.centroid);

			if (matrix) {
				faceCopy.centroid.applyMatrix4(matrix);
			}

			faces1.push(faceCopy);
		}

		// uvs
		for (i in 0...uvs2.length) {
			var uv = uvs2[i], uvCopy = [];
			for (j in 0...uv.length) {
				uvCopy.push(new Vector2(uv[j].x, uv[j].y));
			}
			uvs1.push(uvCopy);
		}
	}	
	
	// Get random point in triangle (via barycentric coordinates)
	// (uniform distribution)
	// http://www.cgafaq.info/wiki/Random_Point_In_Triangle
	public static function randomPointInTriangle(vectorA:Vector3, vectorB:Vector3, vectorC:Vector3):Vector3 {
		var vector = new Vector3();
		var point = new Vector3();

		var a = TMath.random16();
		var b = TMath.random16();

		if ((a + b) > 1) {
			a = 1 - a;
			b = 1 - b;
		}

		var c = 1 - a - b;

		point.copy(vectorA);
		point.multiplyScalar(a);

		vector.copy(vectorB);
		vector.multiplyScalar(b);

		point.add(vector);

		vector.copy(vectorC);
		vector.multiplyScalar(c);

		point.add(vector);

		return point;
	}
	
	// Get random point in face (triangle / quad)
	// (uniform distribution)
	public static function randomPointInFace(face:Dynamic, geometry:Geometry, ?useCachedAreas:Bool = false):Vector3 {
		var vA:Vector3;
		var vB:Vector3;
		var vC:Vector3;
		var vD:Vector3;

		vA = geometry.vertices[face.a];
		vB = geometry.vertices[face.b];
		vC = geometry.vertices[face.c];

		return GeometryUtils.randomPointInTriangle(vA, vB, vC);
	}
	
	// Get uniformly distributed random points in mesh
	// 	- create array with cumulative sums of face areas
	//  - pick random number from 0 to total area
	//  - find corresponding place in area array by binary search
	//	- get random point in face
	public static function randomPointsInGeometry(geometry:Geometry, n:Int) {
		// TODO
		/*var face, i,
			faces = geometry.faces,
			vertices = geometry.vertices,
			il = faces.length,
			totalArea = 0,
			cumulativeAreas = [],
			vA, vB, vC, vD;

		// precompute face areas

		for ( i = 0; i < il; i ++ ) {

			face = faces[ i ];

			vA = vertices[ face.a ];
			vB = vertices[ face.b ];
			vC = vertices[ face.c ];

			face._area = THREE.GeometryUtils.triangleArea( vA, vB, vC );

			totalArea += face._area;

			cumulativeAreas[ i ] = totalArea;

		}

		// binary search cumulative areas array

		function binarySearchIndices( value ) {

			function binarySearch( start, end ) {

				// return closest larger index
				// if exact number is not found

				if ( end < start )
					return start;

				var mid = start + Math.floor( ( end - start ) / 2 );

				if ( cumulativeAreas[ mid ] > value ) {

					return binarySearch( start, mid - 1 );

				} else if ( cumulativeAreas[ mid ] < value ) {

					return binarySearch( mid + 1, end );

				} else {

					return mid;

				}

			}

			var result = binarySearch( 0, cumulativeAreas.length - 1 )
			return result;

		}

		// pick random face weighted by face area

		var r, index,
			result = [];

		var stats = {};

		for ( i = 0; i < n; i ++ ) {

			r = THREE.Math.random16() * totalArea;

			index = binarySearchIndices( r );

			result[ i ] = THREE.GeometryUtils.randomPointInFace( faces[ index ], geometry, true );

			if ( ! stats[ index ] ) {

				stats[ index ] = 1;

			} else {

				stats[ index ] += 1;

			}

		}

		return result;*/
	}
	
	// Get triangle area (half of parallelogram)
	//	http://mathworld.wolfram.com/TriangleArea.html
	public static function triangleArea(vectorA:Vector3, vectorB:Vector3, vectorC:Vector3):Float {
		var vector1 = new Vector3();
		var vector2 = new Vector3();

		vector1.subVectors(vectorB, vectorA);
		vector2.subVectors(vectorC, vectorA);
		vector1.cross( vector2 );

		return 0.5 * vector1.length();
	}
	
	// Center geometry so that 0,0,0 is in center of bounding box
	public static function center(geometry:Geometry):Vector3 {
		geometry.computeBoundingBox();
		var bb = geometry.boundingBox;

		var offset = new Vector3();

		offset.addVectors(bb.min, bb.max);
		offset.multiplyScalar(-0.5);

		geometry.applyMatrix(new Matrix4().makeTranslation(offset.x, offset.y, offset.z));
		geometry.computeBoundingBox();

		return offset;
	}
	
	public static function triangulateQuads(geometry:Geometry):Geometry {
		var faces = [];
		var faceVertexUvs = [];

		for (i in 0...geometry.faceVertexUvs.length) {
			faceVertexUvs[i] = [];
		}

		for (i in 0...geometry.faces.length) {
			var face = geometry.faces[i];
			faces.push(face);

			for (j in 0...geometry.faceVertexUvs.length) {
				faceVertexUvs[j].push(geometry.faceVertexUvs[j][i]);
			}
		}

		geometry.faces = faces;
		geometry.faceVertexUvs = faceVertexUvs;

		geometry.computeCentroids();
		geometry.computeFaceNormals();
		geometry.computeVertexNormals();

		if (geometry.hasTangents) geometry.computeTangents();
		
		return geometry;
	}
}

