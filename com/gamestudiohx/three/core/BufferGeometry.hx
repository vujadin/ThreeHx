package com.gamestudiohx.three.core;

import com.gamestudiohx.three.math.Box3;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Matrix3;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.THREE;
import openfl.gl.GLBuffer;
import openfl.utils.ArrayBufferView;

import com.gamestudiohx.three.renderers.WebGLRenderer;

import openfl.utils.Float32Array;

/**
 * ...
 * @author Krtolica Vujadin
 */

class BufferGeometry {
	
	public static var POSITION:String = "position";
	public static var NORMAL:String = "normal";
	public static var INDEX:String = "index";
	public static var UV:String = "uv";
	public static var TANGENT:String = "tangent";
	public static var COLOR:String = "color";
	
	public var id:Int;
	public var uuid:String;
	public var name:String;
	
	public var attributes:Map<String, BufferGeometryAttribute>;
		
	public var offsets:Array<Chunk>;
	
	public var isDynamic:Bool;
	
	public var boundingBox:Box3;
	public var boundingSphere:Sphere;
	
	public var morphTargets:Array<MorphTarget>;
	
	public var hasTangents:Bool;
	public var normalsNeedUpdate:Bool;
	public var verticesNeedUpdate:Bool;
	public var tangentsNeedUpdate:Bool;
		
	
	public function new() {
		attributes = new Map();
		
		isDynamic = true;
		
		offsets = [];
		
		boundingBox = null;
		boundingSphere = null;
		
		hasTangents = false;
		
		morphTargets = [];
	}
	
	public function addAttribute(name:String, ?type:String, ?numItems:Int, ?itemSize:Int) {
		//attributes.set(name, new Float32Array());
	}
	
	public function applyMatrix(matrix:Matrix4) {
		var positionArray:Array<Dynamic> = null;
		var normalArray:Array<Dynamic> = null;

		if (this.attributes.get("position") != null) positionArray = this.attributes.get("position").array;
		if ( this.attributes.get("normal") != null) normalArray = this.attributes.get("normal").array;

		if (positionArray != null) {
			matrix.multiplyVector3Array(cast positionArray);
			this.verticesNeedUpdate = true;
		}

		if (normalArray != null) {
			var normalMatrix = new Matrix3().getNormalMatrix(matrix);
			normalMatrix.multiplyVector3Array(cast normalArray);
			this.normalizeNormals();
			this.normalsNeedUpdate = true;
		}
	}
	
	public function computeBoundingBox() {
		if (this.boundingBox == null) {
			this.boundingBox = new Box3();
		}

		var positions = this.attributes.get("position").array;

		if (positions != null) {
			var bb = this.boundingBox;
			var x, y, z;

			if(positions.length >= 3) {
				bb.min.x = bb.max.x = positions[0];
				bb.min.y = bb.max.y = positions[1];
				bb.min.z = bb.max.z = positions[2];
			}

			var i:Int = 3;
			while (i < positions.length) {
				x = positions[i];
				y = positions[i + 1];
				z = positions[i + 2];

				// bounding box
				if (x < bb.min.x) {
					bb.min.x = x;
				} else if (x > bb.max.x) {
					bb.max.x = x;
				}

				if (y < bb.min.y) {
					bb.min.y = y;
				} else if (y > bb.max.y) {
					bb.max.y = y;
				}

				if (z < bb.min.z) {
					bb.min.z = z;
				} else if (z > bb.max.z) {
					bb.max.z = z;
				}
				
				i += 3;
			}
		}

		if (positions == null || positions.length == 0) {
			this.boundingBox.min.set(0, 0, 0);
			this.boundingBox.max.set(0, 0, 0);
		}
	}
	
	public function computeBoundingSphere() {
		var box = new Box3();
		var vector = new Vector3();
		
		if (this.boundingSphere == null) {
			this.boundingSphere = new Sphere();
		}

		var positions = this.attributes.get("position").array;
		if (positions != null) {
			var center = this.boundingSphere.center;

			var i:Int = 0;
			while (i < positions.length) {
				vector.set(positions[i], positions[i + 1], positions[i + 2]);
				box.addPoint(vector);
				i += 3;
			}

			box.center(center);
			var maxRadiusSq:Float = 0;
			
			i = 0;
			while (i < positions.length) {
				vector.set(positions[i], positions[i + 1], positions[i + 2]);
				maxRadiusSq = Math.max(maxRadiusSq, center.distanceToSquared(vector));
				i += 3;
			}

			this.boundingSphere.radius = Math.sqrt(maxRadiusSq);
		}
	}
	
	public function computeVertexNormals() {
		if ( this.attributes.get("position") != null) {
			var nVertexElements = this.attributes.get("position").array.length;

			if (this.attributes.get("normal") == null) {
				this.attributes.set("normal", {
					itemSize: 3,
					array: new Float32Array(nVertexElements),
					__original: null,
					__webglInitialized: null,
					buffer: null,
					boundTo: null,
					createUniqueBuffers: null,
					isDynamic: null,
					needsUpdate: null,
					numItems: null,
					size: null,
					type: null,
					value: null
				});
			} else {
				// reset existing normals to zero
				for (i in 0...this.attributes.get("normal").array.length) {
					this.attributes.get("normal").array[i] = 0;
				}
			}

			var positions = this.attributes.get("position").array;
			var normals = this.attributes.get("normal").array;

			var vA:Int, vB:Int, vC:Int, x:Float, y:Float, z:Float;

			var pA = new Vector3();
			var pB = new Vector3();
			var pC = new Vector3();

			var cb = new Vector3();
			var ab = new Vector3();

			// indexed elements
			if (this.attributes.get("index") != null) {
				var indices:Array<Int> = this.attributes.get("index").array;
				var offsets = this.offsets;

				for (j in 0...offsets.length) {
					var start = offsets[j].start;
					var count = offsets[j].count;
					var index = offsets[j].index;

					var i:Int = start;
					while (i < start + count) {
						vA = index + indices[i];
						vB = index + indices[i + 1];
						vC = index + indices[i + 2];

						x = positions[vA * 3];
						y = positions[vA * 3 + 1];
						z = positions[vA * 3 + 2];
						pA.set(x, y, z);

						x = positions[vB * 3];
						y = positions[vB * 3 + 1];
						z = positions[vB * 3 + 2];
						pB.set(x, y, z);

						x = positions[vC * 3];
						y = positions[vC * 3 + 1];
						z = positions[vC * 3 + 2];
						pC.set(x, y, z);

						cb.subVectors(pC, pB);
						ab.subVectors(pA, pB);
						cb.cross(ab);

						normals[vA * 3]     += cb.x;
						normals[vA * 3 + 1] += cb.y;
						normals[vA * 3 + 2] += cb.z;

						normals[vB * 3]     += cb.x;
						normals[vB * 3 + 1] += cb.y;
						normals[vB * 3 + 2] += cb.z;

						normals[vC * 3]     += cb.x;
						normals[vC * 3 + 1] += cb.y;
						normals[vC * 3 + 2] += cb.z;
						i += 3;
					}
				}

			// non-indexed elements (unconnected triangle soup)
			} else {
				var i:Int = 0;
				while (i < positions.length) {
					x = positions[i];
					y = positions[i + 1];
					z = positions[i + 2];
					pA.set(x, y, z);

					x = positions[i + 3];
					y = positions[i + 4];
					z = positions[i + 5];
					pB.set(x, y, z);

					x = positions[i + 6];
					y = positions[i + 7];
					z = positions[i + 8];
					pC.set(x, y, z);

					cb.subVectors(pC, pB);
					ab.subVectors(pA, pB);
					cb.cross(ab);

					normals[i] 	 = cb.x;
					normals[i + 1] = cb.y;
					normals[i + 2] = cb.z;

					normals[i + 3] = cb.x;
					normals[i + 4] = cb.y;
					normals[i + 5] = cb.z;

					normals[i + 6] = cb.x;
					normals[i + 7] = cb.y;
					normals[i + 8] = cb.z;
					i += 9;
				}
			}

			this.normalizeNormals();
			this.normalsNeedUpdate = true;
		}
	}
	
	public function normalizeNormals() {
		var normals = this.attributes.get("normal").array;

		var x, y, z, n;
		var i:Int = 0;
		while (i < normals.length) {
			x = normals[i];
			y = normals[i + 1];
			z = normals[i + 2];

			n = 1.0 / Math.sqrt( x * x + y * y + z * z );

			normals[i] 	 *= n;
			normals[i + 1] *= n;
			normals[i + 2] *= n;
			i += 3;
		}
	}
	
	public function computeTangents() {
		// based on http://www.terathon.com/code/tangent.html
		// (per vertex tangents)
		if ( this.attributes.get("index") == null ||
			 this.attributes.get("position") == null ||
			 this.attributes.get("normal") == null ||
			 this.attributes.get("uv") == null ) {

			trace("Missing required attributes (index, position, normal or uv) in BufferGeometry.computeTangents()");
			return;

		}

		var indices:Array<Int> = this.attributes.get("index").array;
		var positions = this.attributes.get("position").array;
		var normals = this.attributes.get("normal").array;
		var uvs = this.attributes.get("uv").array;

		var nVertices:Int = Std.int(positions.length / 3);

		if (this.attributes.get("tangent") == null) {
			var nTangentElements:Int = 4 * nVertices;
			this.attributes.set("tangent", {
				itemSize: 4,
				array: new Float32Array(nTangentElements),
				__original: null,
				__webglInitialized: null,
				buffer: null,
				boundTo: null,
				createUniqueBuffers: null,
				isDynamic: null,
				needsUpdate: null,
				numItems: null,
				size: null,
				type: null,
				value: null
			});
		}

		var tangents = this.attributes.get("tangent").array;

		var tan1:Array<Vector3> = [];
		var tan2:Array<Vector3> = [];

		for (k in 0...nVertices) {
			tan1[k] = new Vector3();
			tan2[k] = new Vector3();
		}

		var xA, yA, zA;
		var	xB, yB, zB;
		var	xC, yC, zC;

		var	uA, vA;
		var	uB, vB;
		var	uC, vC;

		var	x1, x2, y1, y2, z1, z2;
		var	s1, s2, t1, t2, r;

		var sdir:Vector3 = new Vector3();
		var tdir:Vector3 = new Vector3();

		function handleTriangle(a:Int, b:Int, c:Int) {
			xA = positions[a * 3];
			yA = positions[a * 3 + 1];
			zA = positions[a * 3 + 2];

			xB = positions[b * 3];
			yB = positions[b * 3 + 1];
			zB = positions[b * 3 + 2];

			xC = positions[c * 3];
			yC = positions[c * 3 + 1];
			zC = positions[c * 3 + 2];

			uA = uvs[a * 2];
			vA = uvs[a * 2 + 1];

			uB = uvs[b * 2];
			vB = uvs[b * 2 + 1];

			uC = uvs[c * 2];
			vC = uvs[c * 2 + 1];

			x1 = xB - xA;
			x2 = xC - xA;

			y1 = yB - yA;
			y2 = yC - yA;

			z1 = zB - zA;
			z2 = zC - zA;

			s1 = uB - uA;
			s2 = uC - uA;

			t1 = vB - vA;
			t2 = vC - vA;

			r = 1.0 / (s1 * t2 - s2 * t1);

			sdir.set(
				(t2 * x1 - t1 * x2) * r,
				(t2 * y1 - t1 * y2) * r,
				(t2 * z1 - t1 * z2) * r
			);

			tdir.set(
				(s1 * x2 - s2 * x1) * r,
				(s1 * y2 - s2 * y1) * r,
				(s1 * z2 - s2 * z1) * r
			);

			tan1[a].add(sdir);
			tan1[b].add(sdir);
			tan1[c].add(sdir);

			tan2[a].add(tdir);
			tan2[b].add(tdir);
			tan2[c].add(tdir);
		}

		var iA:Int, iB:Int, iC:Int;
		var offsets = this.offsets;

		for (j in 0...offsets.length) {
			var start = offsets[j].start;
			var count = offsets[j].count;
			var index = offsets[j].index;

			var i:Int = start;
			while (i < start + count) {
				iA = index + indices[i];
				iB = index + indices[i + 1];
				iC = index + indices[i + 2];

				handleTriangle(iA, iB, iC);
				i += 3;
			}
		}

		var tmp = new Vector3();
		var tmp2 = new Vector3();
		var n = new Vector3();
		var n2 = new Vector3();
		var w, t, test;

		function handleVertex(v:Int) {
			n.x = normals[v * 3];
			n.y = normals[v * 3 + 1];
			n.z = normals[v * 3 + 2];

			n2.copy(n);

			t = tan1[v];

			// Gram-Schmidt orthogonalize
			tmp.copy(t);
			tmp.sub(n.multiplyScalar(n.dot(t))).normalize();

			// Calculate handedness
			tmp2.crossVectors(n2, t);
			test = tmp2.dot(tan2[v]);
			w = (test < 0.0) ? -1.0 : 1.0;

			tangents[v * 4]     = tmp.x;
			tangents[v * 4 + 1] = tmp.y;
			tangents[v * 4 + 2] = tmp.z;
			tangents[v * 4 + 3] = w;
		}

		for (j in 0...offsets.length) {
			var start = offsets[j].start;
			var count = offsets[j].count;
			var index = offsets[j].index;

			var i:Int = start;
			while (i < start + count) {
				iA = index + indices[i];
				iB = index + indices[i + 1];
				iC = index + indices[i + 2];

				handleVertex(iA);
				handleVertex(iB);
				handleVertex(iC);
				i += 3;
			}
		}

		this.hasTangents = true;
		this.tangentsNeedUpdate = true;
	}
	
	// TODO
	public function clone():BufferGeometry {
		var geometry = new BufferGeometry();

		/*var types = [ Int8Array, Uint8Array, Uint8ClampedArray, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array ];

		for (attr in this.attributes.keys()) {
			var sourceAttr = this.attributes.get(attr);
			var sourceArray = sourceAttr.array;

			var attribute = {
				itemSize: sourceAttr.itemSize,
				numItems: sourceAttr.numItems,
				array: null
			};

			for ( var i = 0, il = types.length; i < il; i ++ ) {

				var type = types[ i ];

				if ( sourceArray instanceof type ) {

					attribute.array = new type( sourceArray );
					break;

				}

			}

			geometry.attributes[ attr ] = attribute;

		}

		for ( var i = 0, il = this.offsets.length; i < il; i ++ ) {

			var offset = this.offsets[ i ];

			geometry.offsets.push( {

				start: offset.start,
				index: offset.index,
				count: offset.count

			} );

		}*/

		return geometry;
	}
	
}
