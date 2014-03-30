package com.gamestudiohx.three.core;

import com.gamestudiohx.three.materials.MeshFaceMaterial;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Plane;
import com.gamestudiohx.three.math.Ray;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.math.Triangle;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.objects.Mesh;
import com.gamestudiohx.three.objects.Sprite;
import com.gamestudiohx.three.objects.LOD;
import com.gamestudiohx.three.objects.Line;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author bhouston / http://exocortex.com/
 * @author stephomi / http://stephaneginier.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */
 
class Raycaster {
	
	public var ray:Ray;
	
	public var near:Float;
	public var far:Float;
	
	public var sphere:Sphere;
	public var localRay:Ray;
	public var facePlane:Plane;
	public var intersectPoint:Vector3;
	public var matrixPosition:Vector3;
	
	public var inverseMatrix:Matrix4;
	
	var vA:Vector3;
	var vB:Vector3;
	var vC:Vector3;
		
	public var precision:Float = 0.0001;
	public var linePrecision:Float = 1;

	public function new(origin:Vector3, direction:Vector3, near:Float = 0, far:Float = null) {
		this.ray = new Ray( origin, direction );
		// direction is assumed to be normalized (for accurate distance calculations)

		this.near = near;
		this.far = far != null ? far : Math.POSITIVE_INFINITY;
	}
	
	function descSort(a:Dynamic, b:Dynamic):Int {
		return Std.int(a.distance - b.distance);
	}
	
	public function intersectObject(object:Object3D, raycaster:Raycaster, intersects:Array<Dynamic>):Array<Dynamic> {
		if (Std.is(object, Sprite)) {
			matrixPosition.setFromMatrixPosition(object.matrixWorld);
			var distance = raycaster.ray.distanceToPoint(matrixPosition);

			if (distance > object.scale.x) {
				return intersects;
			}

			intersects.push({
				distance: distance,
				point: object.position,
				face: null,
				object: object
			});

		} else if (Std.is(object, LOD)) {
			matrixPosition.setFromMatrixPosition(object.matrixWorld);
			var distance = raycaster.ray.origin.distanceTo(matrixPosition);

			intersectObject(cast(object, LOD).getObjectForDistance(distance), raycaster, intersects);
		} else if (Std.is(object, Mesh)) {
			var geometry = cast(object, Mesh).geometry;

			// Checking boundingSphere distance to ray
			if (geometry.boundingSphere == null) geometry.computeBoundingSphere();

			sphere.copy(geometry.boundingSphere);
			sphere.applyMatrix4(object.matrixWorld);

			if (raycaster.ray.isIntersectionSphere(sphere) == false) {
				return intersects;
			}

			// Check boundingBox before continuing			
			inverseMatrix.getInverse(object.matrixWorld);  
			localRay.copy(raycaster.ray).applyMatrix4(inverseMatrix);

			if (geometry.boundingBox != null) {
				if (localRay.isIntersectionBox(geometry.boundingBox) == false) {
					return intersects;
				}
			} 

			/*if (Std.is(geometry, BufferGeometry)) {
				var material = cast(object, Mesh).material;

				if (material == null) return intersects;
				if (geometry.isDynamic == false) return intersects;

				var a, b, c;
				var precision = raycaster.precision;

				if (cast(geometry, BufferGeometry).attributes.index != null) {
					var offsets = cast(geometry, BufferGeometry).offsets;
					var indices = cast(geometry, BufferGeometry).attributes.index.array;
					var positions = cast(geometry, BufferGeometry).attributes.position.array;
					var offLength = cast(geometry, BufferGeometry).offsets.length;

					var fl = cast(geometry, BufferGeometry).attributes.index.array.length / 3;

					for (oi in 0...offLength) {
						var start = offsets[oi].start;
						var count = offsets[oi].count;
						var index = offsets[oi].index;

						var i:Int = start;
						while (i < start + count) {
							a = index + indices[i];
							b = index + indices[i + 1]; 
							c = index + indices[i + 2];

							vA.set(
								positions[a * 3],
								positions[a * 3 + 1],
								positions[a * 3 + 2]
							);
							vB.set(
								positions[b * 3],
								positions[b * 3 + 1],
								positions[b * 3 + 2]
							);
							vC.set(
								positions[c * 3],
								positions[c * 3 + 1],
								positions[c * 3 + 2]
							);
							
							if (material.side == THREE.BackSide) {							
								var intersectionPoint = localRay.intersectTriangle(vC, vB, vA, true); 
							} else {
								var intersectionPoint = localRay.intersectTriangle(vA, vB, vC, material.side != THREE.DoubleSide);
							}

							if (intersectionPoint == null) continue;

							intersectionPoint.applyMatrix4(object.matrixWorld);

							var distance = raycaster.ray.origin.distanceTo(intersectionPoint);

							if (distance < precision || distance < raycaster.near || distance > raycaster.far) continue;

							intersects.push({
								distance: distance,
								point: intersectionPoint,
								face: null,
								faceIndex: null,
								object: object
							});
							i += 3;
						}
					}
				} else {
					var offsets = geometry.offsets;
					var positions = geometry.attributes.position.array;
					var offLength = geometry.offsets.length;

					var fl = geometry.attributes.position.array.length;

					var i:Int = 0;
					while (i < fl) {
						a = i;
						b = i + 1;
						c = i + 2;

						vA.set(
							positions[a * 3],
							positions[a * 3 + 1],
							positions[a * 3 + 2]
						);
						vB.set(
							positions[b * 3],
							positions[b * 3 + 1],
							positions[b * 3 + 2]
						);
						vC.set(
							positions[c * 3],
							positions[c * 3 + 1],
							positions[c * 3 + 2]
						);
						
						if (material.side == THREE.BackSide) {							
							var intersectionPoint = localRay.intersectTriangle(vC, vB, vA, true); 
						} else {
							var intersectionPoint = localRay.intersectTriangle(vA, vB, vC, material.side != THREE.DoubleSide);
						}

						if (intersectionPoint == null) continue;

						intersectionPoint.applyMatrix4(object.matrixWorld);

						var distance = raycaster.ray.origin.distanceTo(intersectionPoint);

						if (distance < precision || distance < raycaster.near || distance > raycaster.far) continue;

						intersects.push({
							distance: distance,
							point: intersectionPoint,
							face: null,
							faceIndex: null,
							object: object
						});
					}
				}
			} else*/ if (Std.is(geometry, Geometry)) {
				var isFaceMaterial:Bool = Std.is(cast(object, Mesh).material, MeshFaceMaterial);
				var objectMaterials = isFaceMaterial == true ? cast(cast(object, Mesh).material, MeshFaceMaterial).materials : null;

				var a, b, c, d;
				var precision = raycaster.precision;

				var vertices = geometry.vertices;
				for (f in 0...geometry.faces.length) {
					var face = geometry.faces[f];
					var material = isFaceMaterial == true ? objectMaterials[face.materialIndex] : cast(object, Mesh).material;

					if (material == null) continue;

					a = vertices[face.a];
					b = vertices[face.b];
					c = vertices[face.c];
					
					var intersectionPoint:Vector3 = null;
					if (material.side == THREE.BackSide) {							
						var intersectionPoint = localRay.intersectTriangle(c, b, a, true);
					} else {								
						var intersectionPoint = localRay.intersectTriangle(a, b, c, material.side != THREE.DoubleSide);
					}

					if (intersectionPoint == null) continue;

					intersectionPoint.applyMatrix4(object.matrixWorld);

					var distance = raycaster.ray.origin.distanceTo(intersectionPoint);

					if (distance < precision || distance < raycaster.near || distance > raycaster.far) continue;

					intersects.push({
						distance: distance,
						point: intersectionPoint,
						face: face,
						faceIndex: f,
						object: object
					});
				}
			}
		} else if (Std.is(object, Line)) {
			var precision = raycaster.linePrecision;
			var precisionSq = precision * precision;

			var geometry = cast(object, Line).geometry;

			if (geometry.boundingSphere == null ) geometry.computeBoundingSphere();

			// Checking boundingSphere distance to ray
			sphere.copy(geometry.boundingSphere);
			sphere.applyMatrix4(object.matrixWorld);
			
			if (raycaster.ray.isIntersectionSphere(sphere) == false) {
				return intersects;
			}
			
			inverseMatrix.getInverse(object.matrixWorld);
			localRay.copy(raycaster.ray).applyMatrix4(inverseMatrix);

			/* if ( geometry instanceof THREE.BufferGeometry ) {
			} else */ if (Std.is(geometry, Geometry)) {
				var vertices = geometry.vertices;
				var nbVertices = vertices.length;
				var interSegment = new Vector3();
				var interRay = new Vector3();
				var step = object.type == THREE.LineStrip ? 1 : 2;

				var i:Int = 0;
				while (i < nbVertices - 1) {
					var distSq = localRay.distanceSqToSegment(vertices[i], vertices[i + 1], interRay, interSegment);

					if (distSq > precisionSq) continue;

					var distance = localRay.origin.distanceTo(interRay);

					if (distance < raycaster.near || distance > raycaster.far) continue;

					intersects.push({
						distance: distance,
						// What do we want? intersection point on the ray or on the segment??
						// point: raycaster.ray.at( distance ),
						point: interSegment.clone().applyMatrix4( object.matrixWorld ),
						face: null,
						faceIndex: null,
						object: object
					});
					i += step;
				}
			}
		}
		
		return intersects;
	}
	
	public function intersectDescendants(object:Object3D, raycaster:Raycaster, intersects:Array<Dynamic>) {
		var descendants = object.getDescendants();
		for (i in 0...descendants.length) {
			intersectObject(descendants[i], raycaster, intersects);
		}
	}
	
	public function set(origin:Vector3, direction:Vector3) {
		this.ray.set(origin, direction);
		// direction is assumed to be normalized (for accurate distance calculations)
	}
	
	public function intersectObject2(object:Object3D, recursive:Bool):Array<Dynamic> {
		var intersects:Array<Dynamic> = [];

		if (recursive == true) {
			intersectDescendants(object, this, intersects);
		}

		intersectObject(object, this, intersects);
		intersects.sort(descSort);

		return intersects;
	}
	
	public function intersectObjects(objects:Array<Object3D>, recursive:Bool):Array<Dynamic> {
		var intersects:Array<Dynamic> = [];

		for (i in 0...objects.length) {
			intersectObject(objects[i], this, intersects);

			if (recursive == true) {
				intersectDescendants(objects[i], this, intersects);
			}
		}

		intersects.sort(descSort);

		return intersects;
	}
}