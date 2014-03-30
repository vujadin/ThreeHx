package com.gamestudiohx.three.core;

import com.gamestudiohx.three.cameras.Camera;
import com.gamestudiohx.three.core.Projector.RenderData;
import com.gamestudiohx.three.math.Box3;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector4;
import com.gamestudiohx.three.math.Matrix3;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Frustum;
import com.gamestudiohx.three.lights.Light;
import com.gamestudiohx.three.objects.Mesh;
import com.gamestudiohx.three.objects.Line;
import com.gamestudiohx.three.objects.Sprite;
import com.gamestudiohx.three.renderers.renderables.RenderableFace3;
import com.gamestudiohx.three.renderers.renderables.RenderableLine;
import com.gamestudiohx.three.renderers.renderables.RenderableObject;
import com.gamestudiohx.three.renderers.renderables.RenderableVertex;
import com.gamestudiohx.three.renderers.renderables.RenderableSprite;
import com.gamestudiohx.three.scenes.Scene;
import com.gamestudiohx.three.materials.MeshFaceMaterial;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author julianwa / https://github.com/julianwa
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef RenderData = {
	objects: Array<Dynamic>, 
	sprites: Array<Dynamic>, 
	lights: Array<Dynamic>, 
	elements: Array<Dynamic>
}

class Projector {
	
	var _object:RenderableObject;
	var _objectCount:Int;
	var _objectPool:Array<RenderableObject>;
	var _objectPoolLength:Int;
	
	var _vertex:RenderableVertex;
	var _vertexCount:Int;
	var _vertexPool:Array<RenderableVertex>;
	var _vertexPoolLength:Int;
	
	var	_face:RenderableFace3;
	var _face3Count:Int;
	var _face3Pool:Array<RenderableFace3>;
	var _face3PoolLength:Int;
	
	var _line:RenderableLine;
	var _lineCount:Int;
	var _linePool:Array<RenderableLine>;
	var _linePoolLength:Int;
	
	var _sprite:RenderableSprite; 
	var _spriteCount:Int;
	var _spritePool:Array<RenderableSprite>;
	var _spritePoolLength:Int;
	
	var _renderData:RenderData;
	
	var _vector3:Vector3;
	var _vector4:Vector4;
	
	var _clipBox:Box3;
	var _boundingBox:Box3;
	var _points3:Array<Vector4>;
	var _points4:Array<Vector4>;
	
	var _viewMatrix:Matrix4;
	var _viewProjectionMatrix:Matrix4;

	var _modelMatrix:Matrix4;
	var _modelViewProjectionMatrix:Matrix4;
	
	var _normalMatrix:Matrix3;
	var _normalViewMatrix:Matrix3;
	
	var _centroid:Vector3;

	var _frustum:Frustum;
	
	var _clippedVertex1PositionScreen:Vector4;
	var _clippedVertex2PositionScreen:Vector4;

	public function new() {
		_object = null;
		_objectCount = 0;
		_objectPool = [];
		_objectPoolLength = 0;
		_vertexPool = [];
		_vertexPoolLength = 0;
		_face = null;
		_face3Count = 0;
		_face3Pool = [];
		_face3PoolLength = 0;
		_line = null;
		_lineCount = 0;
		_linePool = [];
		_linePoolLength = 0;
		_sprite = null;
		_spriteCount = 0;
		_spritePool = [];
		_spritePoolLength = 0;

		_renderData = { objects: [], sprites: [], lights: [], elements: [] };

		_vector3 = new Vector3();
		_vector4 = new Vector4();

		_clipBox = new Box3(new Vector3( -1, -1, -1), new Vector3(1, 1, 1));
		_boundingBox = new Box3();
		_points3 = [];
		_points4 = [];

		_viewMatrix = new Matrix4();
		_viewProjectionMatrix = new Matrix4();

		_modelMatrix = new Matrix4();
		_modelViewProjectionMatrix = new Matrix4();

		_normalMatrix = new Matrix3();
		_normalViewMatrix = new Matrix3();

		_centroid = new Vector3();

		_frustum = new Frustum();

		_clippedVertex1PositionScreen = new Vector4();
		_clippedVertex2PositionScreen = new Vector4();
	}
	
	public function projectVector(vector:Vector3, camera:Camera):Vector3 {
		camera.matrixWorldInverse.getInverse(camera.matrixWorld);
		_viewProjectionMatrix.multiplyMatrices(camera.projectionMatrix, camera.matrixWorldInverse);
		return vector.applyProjection(_viewProjectionMatrix);
	}
	
	public function unprojectVector(vector:Vector3, camera:Camera):Vector3 {
		camera.projectionMatrixInverse.getInverse(camera.projectionMatrix);
		_viewProjectionMatrix.multiplyMatrices(camera.matrixWorld, camera.projectionMatrixInverse);
		return vector.applyProjection(_viewProjectionMatrix);
	}
	
	public function pickingRay(vector:Vector3, camera:Camera):Raycaster {
		// set two vectors with opposing z values
		vector.z = -1.0;
		var end = new Vector3(vector.x, vector.y, 1.0);

		this.unprojectVector(vector, camera);
		this.unprojectVector(end, camera);

		// find direction from vector to end
		end.sub(vector).normalize();

		return new Raycaster(vector, end);
	}
	
	public function getObject(object:Object3D):RenderableObject {
		_object = getNextObjectInPool();
		_object.id = object.id;
		_object.object = object;

		if (object.renderDepth != null) {
			_object.z = object.renderDepth;
		} else {
			_vector3.setFromMatrixPosition(object.matrixWorld);
			_vector3.applyProjection(_viewProjectionMatrix);
			_object.z = _vector3.z;
		}

		return _object;
	}
	
	public function projectObject(object:Dynamic) {
		if (!object.visible) return;
		
		//trace(object.children);

		if (Std.is(object, Light)) {
			_renderData.lights.push(object);
		} else if (Std.is(object, Mesh) || Std.is(object, Line)) {
			//trace(object.frustumCulled);
			//trace(_frustum.intersectsObject(object));
			if (object.frustumCulled == false || _frustum.intersectsObject(object) == true) {
				_renderData.objects.push(getObject(object));
			}
		} else if (Std.is(object, Sprite)) {
			_renderData.sprites.push(getObject(object));
		}

		for (key in cast(object, Object3D).children.keys()) {
			projectObject(object.children.get(key));
		}
	}
	
	public function projectGraph(root:Dynamic, sortObjects:Bool) {
		_objectCount = 0;

		_renderData.objects = [];
		_renderData.sprites = [];
		_renderData.lights = [];

		projectObject(root);

		if (sortObjects) {
			_renderData.objects.sort(painterSort);
		}
	}
	
	public function projectScene(scene:Scene, camera:Camera, sortObjects:Bool, sortElements:Bool):RenderData {
		var visible = false;
		var object:Dynamic;
		var geometry:Geometry;
		var vertices:Dynamic;
		var faces:Array<Face3>;
		var face:Face3;
		var faceVertexNormals:Array<Dynamic>;
		var faceVertexUvs:Array<Dynamic>;
		var uvs:Array<Vector2>;
		var v1, v2, v3, v4, isFaceMaterial, objectMaterials;

		_face3Count = 0;
		_lineCount = 0;
		_spriteCount = 0;
				
		_renderData.elements = [];
		
		if (scene.autoUpdate) scene.updateMatrixWorld();
		if (camera.parent == null) camera.updateMatrixWorld();

		_viewMatrix.copy(camera.matrixWorldInverse.getInverse(camera.matrixWorld));
		_viewProjectionMatrix.multiplyMatrices(camera.projectionMatrix, _viewMatrix);

		_normalViewMatrix.getNormalMatrix(_viewMatrix);

		_frustum.setFromMatrix(_viewProjectionMatrix);

		projectGraph(scene, sortObjects);

		for (o in 0..._renderData.objects.length) {
			object = _renderData.objects[o].object;
			_modelMatrix = object.matrixWorld;
			_vertexCount = 0;

			if (Std.is(object, Mesh)) {
				//trace(object);
				geometry = object.geometry;

				vertices = geometry.vertices;
				faces = geometry.faces;
				faceVertexUvs = geometry.faceVertexUvs;

				_normalMatrix.getNormalMatrix(_modelMatrix);

				isFaceMaterial = Std.is(object.material, MeshFaceMaterial);
				objectMaterials = isFaceMaterial ? object.material : null;

				for (v in 0...vertices.length) {
					_vertex = getNextVertexInPool();

					_vertex.positionWorld.copy(vertices[v]).applyMatrix4(_modelMatrix);
					_vertex.positionScreen.copy(_vertex.positionWorld).applyMatrix4(_viewProjectionMatrix);

					var invW = 1 / _vertex.positionScreen.w;

					_vertex.positionScreen.x *= invW;
					_vertex.positionScreen.y *= invW;
					_vertex.positionScreen.z *= invW;

					_vertex.visible = !(_vertex.positionScreen.x < -1 || _vertex.positionScreen.x > 1 ||
							      _vertex.positionScreen.y < -1 || _vertex.positionScreen.y > 1 ||
							      _vertex.positionScreen.z < -1 || _vertex.positionScreen.z > 1);
				}

				for (f in 0...faces.length) {
					face = faces[f];

					var material = isFaceMaterial ? objectMaterials.materials[face.materialIndex] : object.material;

					if (material == null) continue;

					var side = material.side;

					v1 = _vertexPool[face.a];
					v2 = _vertexPool[face.b];
					v3 = _vertexPool[face.c];

					_points3[0] = v1.positionScreen;
					_points3[1] = v2.positionScreen;
					_points3[2] = v3.positionScreen;

					if (v1.visible || v2.visible || v3.visible || _clipBox.isIntersectionBox(_boundingBox.setFromPoints(_points3))) {
						visible = ((v3.positionScreen.x - v1.positionScreen.x) *
							    (v2.positionScreen.y - v1.positionScreen.y) -
							    (v3.positionScreen.y - v1.positionScreen.y) *
							    (v2.positionScreen.x - v1.positionScreen.x)) < 0;

						if (side == THREE.DoubleSide || visible == (side == THREE.FrontSide)) {
							_face = getNextFace3InPool();

							_face.id = object.id;
							_face.v1.copy(v1);
							_face.v2.copy(v2);
							_face.v3.copy(v3);
						} else {
							continue;
						}
					} else {
						continue;
					}

					_face.normalModel.copy(face.normal);

					if (visible == false && (side == THREE.BackSide || side == THREE.DoubleSide)) {
						_face.normalModel.negate();
					}

					_face.normalModel.applyMatrix3(_normalMatrix).normalize();
					_face.normalModelView.copy(_face.normalModel).applyMatrix3(_normalViewMatrix);
					_face.centroidModel.copy(face.centroid).applyMatrix4(_modelMatrix);
					faceVertexNormals = face.vertexNormals;

					for (n in 0...Std.int(Math.min(faceVertexNormals.length, 3))) {
						var normalModel = _face.vertexNormalsModel[n];
						normalModel.copy(faceVertexNormals[n]);

						if (visible == false && (side == THREE.BackSide || side == THREE.DoubleSide)) {
							normalModel.negate();
						}

						normalModel.applyMatrix3(_normalMatrix).normalize();

						var normalModelView = _face.vertexNormalsModelView[n];
						normalModelView.copy(normalModel).applyMatrix3(_normalViewMatrix);
					}

					_face.vertexNormalsLength = faceVertexNormals.length;

					for (c in 0...Std.int(Math.min(faceVertexUvs.length, 3))) {
						uvs = faceVertexUvs[c][f];
						if (uvs == null || uvs.length == 0) continue;						
						for (u in 0...uvs.length) {
							_face.uvs[c].push(uvs[u]);
						}
					}

					_face.color = cast face.color;
					_face.material = cast material;

					_centroid.copy(_face.centroidModel).applyProjection(_viewProjectionMatrix);
					_face.z = _centroid.z;
					_renderData.elements.push(_face);
				}

			} else if (Std.is(object, Line)) {
				_modelViewProjectionMatrix.multiplyMatrices(_viewProjectionMatrix, _modelMatrix);

				vertices = object.geometry.vertices;

				v1 = getNextVertexInPool();
				v1.positionScreen.copy(vertices[0]).applyMatrix4(_modelViewProjectionMatrix);

				// Handle LineStrip and LinePieces
				var step = object.type == THREE.LinePieces ? 2 : 1;

				for (v in 1...vertices.length) {
					v1 = getNextVertexInPool();
					v1.positionScreen.copy(vertices[v]).applyMatrix4(_modelViewProjectionMatrix);

					if ((v + 1) % step > 0) continue;

					v2 = _vertexPool[_vertexCount - 2];

					_clippedVertex1PositionScreen.copy(v1.positionScreen);
					_clippedVertex2PositionScreen.copy(v2.positionScreen);

					if (clipLine(_clippedVertex1PositionScreen, _clippedVertex2PositionScreen) == true) {
						// Perform the perspective divide
						_clippedVertex1PositionScreen.multiplyScalar(1 / _clippedVertex1PositionScreen.w);
						_clippedVertex2PositionScreen.multiplyScalar(1 / _clippedVertex2PositionScreen.w);

						_line = getNextLineInPool();

						_line.id = object.id;
						_line.v1.positionScreen.copy(_clippedVertex1PositionScreen);
						_line.v2.positionScreen.copy(_clippedVertex2PositionScreen);

						_line.z = Std.int(Math.max(_clippedVertex1PositionScreen.z, _clippedVertex2PositionScreen.z));

						_line.material = object.material;

						if (object.material.vertexColors == THREE.VertexColors) {
							_line.vertexColors[0].copy(object.geometry.colors[v]);
							_line.vertexColors[1].copy(object.geometry.colors[v - 1]);
						}

						_renderData.elements.push(_line);
					}
				}
			}
		}

		for (o in 0..._renderData.sprites.length) {
			object = _renderData.sprites[o].object;

			_modelMatrix = object.matrixWorld;

			_vector4.set(_modelMatrix.elements[12], _modelMatrix.elements[13], _modelMatrix.elements[14], 1);
			_vector4.applyMatrix4(_viewProjectionMatrix);

			var invW = 1 / _vector4.w;

			_vector4.z *= invW;

			if (_vector4.z >= -1 && _vector4.z <= 1) {
				_sprite = getNextSpriteInPool();
				_sprite.id = object.id;
				_sprite.x = _vector4.x * invW;
				_sprite.y = _vector4.y * invW;
				_sprite.z = _vector4.z;
				_sprite.object = object;

				_sprite.rotation = object.rotation;

				_sprite.scale.x = object.scale.x * Math.abs(_sprite.x - (_vector4.x + camera.projectionMatrix.elements[0] ) / (_vector4.w + camera.projectionMatrix.elements[12]));
				_sprite.scale.y = object.scale.y * Math.abs(_sprite.y - (_vector4.y + camera.projectionMatrix.elements[5] ) / (_vector4.w + camera.projectionMatrix.elements[13]));

				_sprite.material = object.material;

				_renderData.elements.push(_sprite);
			}
		}
		
		//trace(_renderData);

		if (sortElements) _renderData.elements.sort(painterSort);

		return _renderData;
	}
	
	// Pools
	function getNextObjectInPool():RenderableObject {
		if (_objectCount == _objectPoolLength) {
			var object = new RenderableObject();
			_objectPool.push(object);
			_objectPoolLength++;
			_objectCount++;
			return object;
		}

		return _objectPool[_objectCount++];
	}
	
	function getNextVertexInPool():RenderableVertex {
		if (_vertexCount == _vertexPoolLength) {
			var vertex = new RenderableVertex();
			_vertexPool.push(vertex);
			_vertexPoolLength++;
			_vertexCount++;
			return vertex;
		}

		return _vertexPool[_vertexCount++];
	}
	
	function getNextFace3InPool():RenderableFace3 {
		if (_face3Count == _face3PoolLength) {
			var face = new RenderableFace3();
			_face3Pool.push(face);
			_face3PoolLength++;
			_face3Count++;
			return face;
		}

		return _face3Pool[_face3Count++];
	}
	
	function getNextLineInPool():RenderableLine {
		if (_lineCount == _linePoolLength) {
			var line = new RenderableLine();
			_linePool.push(line);
			_linePoolLength++;
			_lineCount++;
			return line;
		}

		return _linePool[_lineCount++];
	}
	
	function getNextSpriteInPool():RenderableSprite {
		if (_spriteCount == _spritePoolLength) {
			var sprite = new RenderableSprite();
			_spritePool.push(sprite);
			_spritePoolLength++;
			_spriteCount++;
			return sprite;
		}

		return _spritePool[_spriteCount++];
	}
	
	//

	function painterSort(a:Dynamic, b:Dynamic):Int {
		if (a.z != b.z) {
			return Std.int(b.z - a.z);
		} else if (a.id != b.id) {
			return Std.int(a.id - b.id);
		} else {
			return 0;
		}
	}
	
	function clipLine(s1:Dynamic, s2:Dynamic):Bool {
		var alpha1:Float = 0, alpha2:Float = 1,

		// Calculate the boundary coordinate of each vertex for the near and far clip planes,
		// Z = -1 and Z = +1, respectively.
		bc1near = s1.z + s1.w,
		bc2near = s2.z + s2.w,
		bc1far = -s1.z + s1.w,
		bc2far = -s2.z + s2.w;

		if (bc1near >= 0 && bc2near >= 0 && bc1far >= 0 && bc2far >= 0) {
			// Both vertices lie entirely within all clip planes.
			return true;
		} else if ((bc1near < 0 && bc2near < 0) || (bc1far < 0 && bc2far < 0)) {
			// Both vertices lie entirely outside one of the clip planes.
			return false;
		} else {
			// The line segment spans at least one clip plane.
			if (bc1near < 0) {
				// v1 lies outside the near plane, v2 inside
				alpha1 = Math.max(alpha1, bc1near / (bc1near - bc2near));
			} else if (bc2near < 0) {
				// v2 lies outside the near plane, v1 inside
				alpha2 = Math.min(alpha2, bc1near / (bc1near - bc2near));
			}

			if (bc1far < 0) {
				// v1 lies outside the far plane, v2 inside
				alpha1 = Math.max(alpha1, bc1far / (bc1far - bc2far));
			} else if (bc2far < 0) {
				// v2 lies outside the far plane, v2 inside
				alpha2 = Math.min(alpha2, bc1far / (bc1far - bc2far));
			}

			if (alpha2 < alpha1) {
				// The line segment spans two boundaries, but is outside both of them.
				// (This can't happen when we're only clipping against just near/far but good
				//  to leave the check here for future usage if other clip planes are added.)
				return false;
			} else {
				// Update the s1 and s2 vertices to match the clipped line segment.
				s1.lerp(s2, alpha1);
				s2.lerp(s1, 1 - alpha2);

				return true;
			}
		}
	}
	
}
