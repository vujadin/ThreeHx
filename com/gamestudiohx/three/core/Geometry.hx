package com.gamestudiohx.three.core;

import com.gamestudiohx.three.math.Box3;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Matrix3;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Sphere;
import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector4;
import com.gamestudiohx.three.THREE;
import com.gamestudiohx.three.renderers.WebGLRenderer;
import haxe.ds.StringMap;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author kile / http://kile.stravaganza.org/
 * @author alteredq / http://alteredqualia.com/
 * @author mikael emtinger / http://gomo.se/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 * @author bhouston / http://exocortex.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef GeometryGroup = {
	faces3: Array<Face3>,
	materialIndex: Int,
	vertices: Int,
	numMorphTargets: Int,
	numMorphNormals: Int
}

typedef MorphTarget = {
	name: String,
	vertices: Array<Vector3>
}

typedef Chunk = {
	start: Int,
	count: Int,
	index: Int
}

typedef BufferGeometryAttribute = {
	itemSize: Null<Int>,
	array: Null<Dynamic>,
	numItems: Null<Int>,
	//buffer: Null<GLBuffer>,
	isDynamic: Null<Bool>,
	type: Null<String>,
	value: Null<Dynamic>,
	buffer: Null<ThreeGLBuffer>,
	size: Null<Int>,
	boundTo: Null<String>,
	needsUpdate: Null<Bool>,
	__webglInitialized:Null<Bool>,
	createUniqueBuffers:Null<Bool>,
	__original:Null<Dynamic>   // should be <BufferGeometryAttribute>
}

class Geometry {
	public var id:Int;
	public var uuid:String;
	public var name:String;
	public var _vertices:Int;
	public var vertices:Array<Vector3>;
	public var colors:Array<Color>;
	public var normals:Array<Vector3>;
	
	public var faces:Array<Face3>;  
	public var faceVertexUvs:Array<Array<Array<Vector2>>>;
	
	public var morphTargets:Array<MorphTarget>;
	public var morphColors:Array<Color>;
	public var morphNormals:Array<Dynamic>;
	public var skinWeights:Array<Dynamic>;
	public var skinIndices:Array<Dynamic>;
	
	public var lineDistances:Array<Dynamic>;
	
	public var boundingBox:Box3;
	public var boundingSphere:Sphere;
	
	public var hasTangents:Bool;
	
	public var isDynamic:Bool;
	public var verticesNeedUpdate:Bool;
	public var elementsNeedUpdate:Bool;
	public var uvsNeedUpdate:Bool;
	public var normalsNeedUpdate:Bool;
	public var tangentsNeedUpdate:Bool;
	public var colorsNeedUpdate:Bool;
	public var lineDistancesNeedUpdate:Bool;
	public var buffersNeedUpdate:Bool;
	
	private var __tmpVertices:Array<Vector3>;
	
	
	// for GLRenderer
	public var __webglInit:Bool;
	
	public var __webglVertexBuffer:GLBuffer;
    public var __webglNormalBuffer:GLBuffer;
    public var __webglTangentBuffer:GLBuffer;
    public var __webglColorBuffer:GLBuffer;
    public var __webglLineDistanceBuffer:GLBuffer;
    public var __webglUVBuffer:GLBuffer;
    public var __webglUV2Buffer:GLBuffer;

    public var __webglSkinVertexABuffer:GLBuffer;
    public var __webglSkinVertexBBuffer:GLBuffer;
    public var __webglSkinIndicesBuffer:GLBuffer;
    public var __webglSkinWeightsBuffer:GLBuffer;

    public var __webglFaceBuffer:GLBuffer;
    public var __webglLineBuffer:GLBuffer;
	
	public var __webglMorphTargetsBuffers:Array<GLBuffer>;
	public var __webglMorphNormalsBuffers:Array<GLBuffer>;
	
	public var __webglCustomAttributesList:Array<BufferGeometryAttribute>;
	
	public var attributes:Map<String, BufferGeometryAttribute>;
	
	public var __vertexArray:Float32Array;
	public var __normalArray:Float32Array;
	public var __colorArray:Float32Array;
	public var __tangentArray:Float32Array;
	public var __uvArray:Float32Array;
	public var __uv2Array:Float32Array;
	public var __skinIndexArray:Float32Array;
	public var __skinWeightArray:Float32Array;
	public var __lineDistanceArray:Float32Array;
	public var __faceArray:Int16Array;
	public var __lineArray:Int16Array;
	public var __sortArray:Array<Float>;
	public var __webglParticleCount:Int;
	
	public var __inittedArrays:Bool;
	
	public var __morphTargetsArrays:Array<Float32Array>;
	public var __morphNormalsArrays:Array<Float32Array>;
	
	public var morphTargetsNeedUpdate:Bool;
	
	public var __webglFaceCount:Int;
	public var __webglLineCount:Int;
	
	public var materialIndex:Int;
	public var numMorphTargets:Int;
	public var numMorphNormals:Int;
	
	public var geometryGroups:Map<String, Geometry>;
	public var geometryGroupsList:Array<Geometry>;	
	
	public var faces3:Array<Int>;
	public var offsets:Array<Chunk>;
	// end for GLRenderer

	public function new() {
		this.id = THREE.GeometryIdCount++;
		this.uuid = ThreeMath.generateUUID();

		this.name = "";

		this.vertices = [];
		this.colors = [];  // one-to-one vertex colors, used in ParticleSystem and Line

		this.faces = [];

		this.faceVertexUvs = [];
		this.faceVertexUvs.push(new Array<Array<Vector2>>());

		this.morphTargets = [];
		this.morphColors = [];
		this.morphNormals = [];

		this.skinWeights = [];
		this.skinIndices = [];

		this.lineDistances = [];

		this.boundingBox = null;
		this.boundingSphere = null;

		this.hasTangents = false;

		this.isDynamic = true; // the intermediate typed arrays will be deleted when set to false

		// update flags
		this.verticesNeedUpdate = false;
		this.elementsNeedUpdate = false;
		this.uvsNeedUpdate = false;
		this.normalsNeedUpdate = false;
		this.tangentsNeedUpdate = false;
		this.colorsNeedUpdate = false;
		this.lineDistancesNeedUpdate = false;

		this.buffersNeedUpdate = false;
		
		this.__tmpVertices = null;
	}	
	
	public function applyMatrix(matrix:Matrix4)	{
		var normalMatrix = new Matrix3().getNormalMatrix(matrix);

		for (i in 0...this.vertices.length) {
			var vertex = this.vertices[i];
			vertex.applyMatrix4(matrix);
		}

		for (i in 0...this.faces.length) {
			var face = this.faces[i];
			face.normal.applyMatrix3(normalMatrix).normalize();

			for (j in 0...face.vertexNormals.length) {
				face.vertexNormals[j].applyMatrix3(normalMatrix).normalize();
			}

			face.centroid.applyMatrix4(matrix);
		}

		if (Std.is(this.boundingBox, Box3)) {
			this.computeBoundingBox();
		}

		if (Std.is(this.boundingSphere, Sphere)) {
			this.computeBoundingSphere();
		}
	}	
	
	public function computeCentroids() {
		var face:Face3;

		for (f in 0...this.faces.length) {
			face = this.faces[f];
			face.centroid.set(0, 0, 0);

			face.centroid.add(this.vertices[face.a]);
			face.centroid.add(this.vertices[face.b]);
			face.centroid.add(this.vertices[face.c]);
			face.centroid.divideScalar(3);
		}
	}	
	
	public function computeFaceNormals() {
		var cb = new Vector3();
		var ab = new Vector3();

		for (f in 0...this.faces.length) {
			var face = this.faces[f];

			var vA = this.vertices[face.a];
			var vB = this.vertices[face.b];
			var vC = this.vertices[face.c];

			cb.subVectors(vC, vB);
			ab.subVectors(vA, vB);
			cb.cross(ab);

			cb.normalize();

			face.normal.copy(cb);
		}
	}	
	
	public function computeVertexNormals(areaWeighted:Bool = false) {
		var face:Face3;
		
		// create internal buffers for reuse when calling this method repeatedly
		// (otherwise memory allocation / deallocation every frame is big resource hog)
		if (this.__tmpVertices == null) {
			this.__tmpVertices = [];

			for (v in 0...this.vertices.length) {
				this.__tmpVertices[v] = new Vector3();
			}

			for (f in 0...this.faces.length) {
				face = this.faces[f];
				face.vertexNormals = [new Vector3(), new Vector3(), new Vector3()];
			}
		} else {
			for (v in 0...this.vertices.length) {
				this.__tmpVertices[v].set(0, 0, 0);
			}
		}

		if (areaWeighted) {
			// vertex normals weighted by triangle areas
			// http://www.iquilezles.org/www/articles/normals/normals.htm
			var vA:Vector3;
			var vB:Vector3;
			var vC:Vector3;
			var vD:Vector3;
			var cb = new Vector3();
			var ab = new Vector3();
			var	db = new Vector3(); 
			var dc = new Vector3();
			var bc = new Vector3();

			for (f in 0...this.faces.length) {
				face = this.faces[f];

				vA = this.vertices[face.a];
				vB = this.vertices[face.b];
				vC = this.vertices[face.c];

				cb.subVectors(vC, vB);
				ab.subVectors(vA, vB);
				cb.cross(ab);

				this.__tmpVertices[face.a].add(cb);
				this.__tmpVertices[face.b].add(cb);
				this.__tmpVertices[face.c].add(cb);
			}
		} else {
			for (f in 0...this.faces.length) {
				face = this.faces[f];
				this.__tmpVertices[face.a].add(face.normal);
				this.__tmpVertices[face.b].add(face.normal);
				this.__tmpVertices[face.c].add(face.normal);
			}
		}

		for (v in 0...this.vertices.length) {
			this.__tmpVertices[v].normalize();
		}

		for (f in 0...this.faces.length) {
			face = this.faces[f];

			face.vertexNormals[0].copy(this.__tmpVertices[face.a]);
			face.vertexNormals[1].copy(this.__tmpVertices[face.b]);
			face.vertexNormals[2].copy(this.__tmpVertices[face.c]);
		}		
	}	
	
	public function computeMorphNormals() {
		var face:Face3;

		// save original normals
		// - create temp variables on first access
		//   otherwise just copy (for faster repeated calls)
		for (f in 0...this.faces.length) {
			face = this.faces[f];

			if (face.__originalFaceNormal == null) {
				face.__originalFaceNormal = face.normal.clone();
			} else {
				face.__originalFaceNormal.copy(face.normal);
			}

			if (face.__originalVertexNormals == null) {
				face.__originalVertexNormals = [];
			}

			for (i in 0...face.vertexNormals.length) {
				if (face.__originalVertexNormals[i] != null) {
					face.__originalVertexNormals[i] = face.vertexNormals[i].clone();
				} else {
					face.__originalVertexNormals[i].copy(face.vertexNormals[i]);
				}
			}
		}

		// use temp geometry to compute face and vertex normals for each morph
		var tmpGeo = new Geometry();
		tmpGeo.faces = this.faces;

		for (i in 0...this.morphTargets.length) {
			// create on first access
			if (this.morphNormals.length >= i && this.morphNormals[i] != null) {
				this.morphNormals[i] = {};
				this.morphNormals[i].faceNormals = [];
				this.morphNormals[i].vertexNormals = [];

				var dstNormalsFace = this.morphNormals[i].faceNormals;
				var dstNormalsVertex = this.morphNormals[i].vertexNormals;

				var faceNormal, vertexNormals;

				for (f in 0...this.faces.length) {
					face = this.faces[f];

					faceNormal = new Vector3();
					vertexNormals = { a: new Vector3(), b: new Vector3(), c: new Vector3() };

					dstNormalsFace.push(faceNormal);
					dstNormalsVertex.push(vertexNormals);
				}
			}

			var _morphNormals = this.morphNormals[i];

			// set vertices to morph target
			tmpGeo.vertices = this.morphTargets[i].vertices;

			// compute morph normals
			tmpGeo.computeFaceNormals();
			tmpGeo.computeVertexNormals();

			// store morph normals
			var faceNormal, vertexNormals;
			for (f in 0...this.faces.length) {
				face = this.faces[f];

				faceNormal = _morphNormals.faceNormals[f];
				vertexNormals = _morphNormals.vertexNormals[f];

				faceNormal.copy(face.normal);

				vertexNormals.a.copy(face.vertexNormals[0]);
				vertexNormals.b.copy(face.vertexNormals[1]);
				vertexNormals.c.copy(face.vertexNormals[2]);
			}
		}

		// restore original normals
		for (f in 0...this.faces.length) {
			face = this.faces[f];

			face.normal = face.__originalFaceNormal;
			face.vertexNormals = face.__originalVertexNormals;
		}
	}	
	
	public function computeTangents() {
		// based on http://www.terathon.com/code/tangent.html
		// tangents go to vertices
		var vertexIndex:Int;
		var face:Face3;
		var uv:Array<Vector2> = [], vA, vB, vC, uvA, uvB, uvC;
		var	x1:Float, x2:Float, y1:Float, y2:Float, z1:Float, z2:Float;
		var	s1:Float, s2:Float, t1:Float, t2:Float, r, t, test;
		var	tan1:Array<Vector3> = [], tan2:Array<Vector3> = [];
		var	sdir = new Vector3(), tdir = new Vector3();
		var	tmp = new Vector3(), tmp2 = new Vector3();
		var	n = new Vector3(), w;

		for (v in 0...this.vertices.length) {
			tan1[v] = new Vector3();
			tan2[v] = new Vector3();
		}

		function handleTriangle(context:Geometry, a:Int, b:Int, c:Int, ua:Int, ub:Int, uc:Int){
			vA = context.vertices[a];
			vB = context.vertices[b];
			vC = context.vertices[c];

			uvA = uv[ua];
			uvB = uv[ub];
			uvC = uv[uc];

			x1 = vB.x - vA.x;
			x2 = vC.x - vA.x;
			y1 = vB.y - vA.y;
			y2 = vC.y - vA.y;
			z1 = vB.z - vA.z;
			z2 = vC.z - vA.z;

			s1 = uvB.x - uvA.x;
			s2 = uvC.x - uvA.x;
			t1 = uvB.y - uvA.y;
			t2 = uvC.y - uvA.y;

			r = 1.0 / ( s1 * t2 - s2 * t1 );
			sdir.set( ( t2 * x1 - t1 * x2 ) * r,
					  ( t2 * y1 - t1 * y2 ) * r,
					  ( t2 * z1 - t1 * z2 ) * r );
			tdir.set( ( s1 * x2 - s2 * x1 ) * r,
					  ( s1 * y2 - s2 * y1 ) * r,
					  ( s1 * z2 - s2 * z1 ) * r );

			tan1[a].add(sdir);
			tan1[b].add(sdir);
			tan1[c].add(sdir);

			tan2[a].add(tdir);
			tan2[b].add(tdir);
			tan2[c].add(tdir);
		}

		for (f in 0...this.faces.length) {
			face = this.faces[f];
			uv = this.faceVertexUvs[0][f]; // use UV layer 0 for tangents

			handleTriangle(this, face.a, face.b, face.c, 0, 1, 2);
		}

		var faceIndex = ['a', 'b', 'c', 'd'];

		for (f in 0...this.faces.length) {
			face = this.faces[f];

			for (i in 0...Std.int(Math.min(face.vertexNormals.length, 3))) {
				n.copy(face.vertexNormals[i] );

				vertexIndex = switch(i) { case 0: face.a; case 1: face.b; case 2: face.c; default: }

				t = tan1[vertexIndex];

				// Gram-Schmidt orthogonalize
				tmp.copy(t);
				tmp.sub(n.multiplyScalar(n.dot(t))).normalize();

				// Calculate handedness
				tmp2.crossVectors(face.vertexNormals[i], t);
				test = tmp2.dot(tan2[vertexIndex]);
				w = (test < 0.0) ? -1.0 : 1.0;

				face.vertexTangents[i] = new Vector4(tmp.x, tmp.y, tmp.z, w);
			}
		}

		this.hasTangents = true;
	}	
	
	public function computeLineDistances(){
		var d:Float = 0;

		for (i in 0...this.vertices.length) {
			if (i > 0) {
				d += this.vertices[i].distanceTo(this.vertices[i - 1]);
			}
			this.lineDistances[i] = d;
		}
	}	
	
	public function computeBoundingBox() {
		if (this.boundingBox == null) this.boundingBox = new Box3();
		this.boundingBox.setFromPoints(this.vertices);
	}	
	
	public function computeBoundingSphere() {
		if (this.boundingSphere == null) {
			this.boundingSphere = new Sphere();
		}

		this.boundingSphere.setFromPoints(this.vertices);
	}
	
	/*
	 * Checks for duplicate vertices with hashmap.
	 * Duplicated vertices are removed
	 * and faces' vertices are updated.
	 */
	public function mergeVertices():Int {		
		// Hashmap for looking up vertice by position coordinates (and making sure they are unique)
		var verticesMap:Map<String,Int> = new Map<String,Int>();	
		
		var unique:Array<Vector3> = [];
		var changes:Array<Int> = [];
		
		var v:Vector3, key:String;
		var precisionPoints = 4;	// number of decimal points, eg. 4 for epsilon of 0.0001
		var precision = Math.pow(10, precisionPoints);
		var face:Face3;
		var indices:Array<Int> = [];
		
		__tmpVertices = null; //reset cache of vertices as it will now be changing
		
		//Make the map of vertices -> indices
		// reset cache of vertices as it now will be changing.
		for (i in 0...this.vertices.length) {
			v = this.vertices[i];
			key = Math.round(v.x * precision) + '_' + Math.round(v.y * precision) + '_' + Math.round(v.z * precision);
			
			if (verticesMap.exists(key) == false) {
				verticesMap.set(key, i);
				unique.push(vertices[i]);
				changes[i] = unique.length - 1;
			} else {
				changes[i] = changes[verticesMap.get(key)];
			}
		}
		
		// if faces are completely degenerate after merging vertices, we
		// have to remove them from the geometry.
		var faceIndicesToRemove:Array<Int> = [];
		for (i in 0...faces.length) {
			face = this.faces[i];

			face.a = changes[face.a];
			face.b = changes[face.b];
			face.c = changes[face.c];

			indices = [face.a, face.b, face.c];

			var dupIndex = -1;

			// if any duplicate vertices are found in a Face3
			// we have to remove the face as nothing can be saved
			for (n in 0...3) {
				if (indices[n] == indices[(n + 1) % 3]) {
					dupIndex = n;
					faceIndicesToRemove.push(i);
					break;
				}
			}			
		}
		
		var i:Int = faceIndicesToRemove.length - 1;
		while(i >= 0) {
			var idx = faceIndicesToRemove[i];
			
			this.faces.splice(idx, 1);

			for (j in 0...this.faceVertexUvs.length) {
				this.faceVertexUvs[j].splice(idx, 1);
			}
			i--;
		}

		// Use unique set of vertices
		var diff:Int = this.vertices.length - unique.length;
		this.vertices = unique;
		return diff;
	}	
	
	public function clone():Geometry {
		var geometry = new Geometry();

		for (i in 0...vertices.length) {
			geometry.vertices.push(vertices[i].clone());
		}

		for (i in 0...faces.length) {
			geometry.faces.push(faces[i].clone());
		}

		var uvs = this.faceVertexUvs[0];

		for (i in 0...uvs.length) {
			var uv = uvs[i], uvCopy:Array<Vector2> = [];

			for (j in 0...uv.length) {
				uvCopy.push(new Vector2(uv[j].x, uv[j].y));
			}

			geometry.faceVertexUvs[0].push(uvCopy);
		}

		return geometry;
	}	
	
	public function dispose() {
		
	}	
	
}
