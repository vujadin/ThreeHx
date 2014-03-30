
package com.gamestudiohx.three.core;

import com.gamestudiohx.three.math.Euler;
import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Matrix3;
import com.gamestudiohx.three.math.Quaternion;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.scenes.Scene;
import com.gamestudiohx.three.THREE;
import openfl.gl.GLBuffer;
import openfl.utils.ArrayBufferView;
import openfl.utils.Float32Array;
import haxe.Json;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 * @author WestLangley / http://github.com/WestLangley
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Object3D {
		
	public var type:Int;
	public var id:Int;
	public var uuid:String;
	public var name:String;
	public var parent:Object3D;
	public var children:Map<String, Object3D>;
	
	public var up:Vector3;
	public var position:Vector3;
	public var scale:Vector3;
	
	private var _rotation:Euler;
	public var rotation(get, set):Euler;
	function get_rotation():Euler {
		return _rotation;
	}
	function set_rotation(value:Euler):Euler {
		this._rotation = value;
		this._rotation._quaternion = this._quaternion;
		this._quaternion._euler = this._rotation;
		this._rotation._updateQuaternion();
		return value;
	}
	
	private var _quaternion:Quaternion;
	public var quaternion(get, set):Quaternion;
	function get_quaternion():Quaternion {
		return _quaternion;
	}
	function set_quaternion(value:Quaternion):Quaternion {
		_quaternion = value;
		return _quaternion;
	}
	
	public var eulerOrder(get, set):Int;
	function get_eulerOrder():Int {
		trace("DEPRECATED: Object3D\'s .eulerOrder has been moved to Object3D\'s .rotation.order.");
		return rotation.order;
	}
	function set_eulerOrder(value:Int):Int {
		trace("DEPRECATED: Object3D\'s .eulerOrder has been moved to Object3D\'s .rotation.order.");
		rotation.order = value;
		return value;
	}	
	
	public var renderDepth:Dynamic;
	
	public var rotationAutoUpdate:Bool;
	
	public var matrix:Matrix4;
	public var matrixWorld:Matrix4;
	
	public var matrixAutoUpdate:Bool;
	public var matrixWorldNeedsUpdate:Bool;
		
	public var visible:Bool;	
	
	public var castShadow:Bool;
	public var receiveShadow:Bool;
	
	public var frustumCulled:Bool;
	
	public var shadowCascadeArray:Array<Object3D>;
	
	public var userData:Dynamic;
	
	// for GLRendererpu
	public var __webglInit:Bool;
	public var __webglActive:Bool;
	public var hasPositions:Bool;
	public var hasNormals:Bool;
	public var hasUvs:Bool;
	public var hasColors:Bool;
	public var __webglVertexBuffer:GLBuffer;
	public var __webglNormalBuffer:GLBuffer;
	public var __webglUvBuffer:GLBuffer;
	public var __webglColorBuffer:GLBuffer;
	public var _modelViewMatrix:Matrix4;
	public var _normalMatrix:Matrix3;
	public var positionArray:ArrayBufferView;
	public var normalArray:Float32Array;
	public var geometry:Geometry;
	public var count:Int;
	public var immediateRenderCallback:Dynamic;		// function ... TODO
	//public var morphTargetBase:Dynamic;		// defined in subclasses (Mesh ....)
	// end for GLRenderer
	
	public function new() {
		id = THREE.Object3DIdCount++;
		uuid = ThreeMath.generateUUID();
		
		name = '';
		
		parent = null;
		children = new Map<String, Object3D>();
		
		up = new Vector3(0, 1, 0);
		
		position = new Vector3();
		_rotation = new Euler();
		_quaternion = new Quaternion();
		scale = new Vector3(1, 1, 1);
		
		// keep rotation and quaternion in sync
		this._rotation._quaternion = this.quaternion;
		this._quaternion._euler = this.rotation;
		
		renderDepth = null;
		
		rotationAutoUpdate = true;
		
		matrix = new Matrix4();
		matrixWorld = new Matrix4();
		
		matrixAutoUpdate = true;
		matrixWorldNeedsUpdate = true;
				
		visible = true;
		
		castShadow = false;
		receiveShadow = false;
		
		frustumCulled = true;
	}	
	
	public function applyMatrix(m:Matrix4) {
		var m1 = new Matrix4();
		matrix.multiplyMatrices(m, matrix);
		position.setFromMatrixPosition(matrix);
		scale.setFromMatrixScale(matrix);
		m1.extractRotation(matrix);
		quaternion.setFromRotationMatrix(m1);
	}
	
	public function setRotationFromAxisAngle(axis:Vector3, angle:Float) {
		// assumes axis is normalized
		this.quaternion.setFromAxisAngle(axis, angle);
	}
	
	public function setRotationFromEuler(euler:Euler) {
		this.quaternion.setFromEuler(euler, true);
	}
	
	public function setRotationFromMatrix(m:Matrix4) {
		// assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
		this.quaternion.setFromRotationMatrix(m);
	}
	
	public function setRotationFromQuaternion(q:Quaternion) {
		// assumes q is normalized
		this.quaternion.copy(q);
	}
	
	public function rotateOnAxis(axis:Vector3, angle:Float):Object3D {
		// rotate object on axis in object space
		// axis is assumed to be normalized
		var q1 = new Quaternion();
		q1.setFromAxisAngle(axis, angle);
		quaternion.multiply(q1);		
		return this;
	}	
	
	public function rotateX(angle:Float):Object3D {
		return rotateOnAxis(new Vector3(1, 0, 0), angle);
	}
	
	public function rotateY(angle:Float):Object3D {
		return rotateOnAxis(new Vector3(0, 1, 0), angle);
	}
	
	public function rotateZ(angle:Float):Object3D {
		return rotateOnAxis(new Vector3(0, 0, 1), angle);
	}
	
	public function translateOnAxis(axis:Vector3, distance:Float):Object3D {
		// translate object by distance along axis in object space
		// axis is assumed to be normalized
		var v1 = new Vector3();
		v1.copy(axis);
		v1.applyQuaternion(quaternion);
		position.add(v1.multiplyScalar(distance));
		return this;
	}	
	
	public function translate(distance:Float, axis:Vector3):Object3D {
		trace("DEPRECATED: Object3D\'s .translate() has been removed. Use .translateOnAxis( axis, distance ) instead. Note args have been changed.");
		return translateOnAxis(axis, distance);
	}	
	
	public function translateX(distance:Float):Object3D {
		return translateOnAxis(new Vector3(1, 0, 0), distance);
	}
		
	public function translateY(distance:Float):Object3D {
		return translateOnAxis(new Vector3(0, 1, 0), distance);
	}	
	
	public function translateZ(distance:Float):Object3D {
		return translateOnAxis(new Vector3(0, 0, 1), distance);
	}	
	
	public function localToWorld(vector:Vector3):Vector3 {
		return vector.applyMatrix4(matrixWorld);
	}	
	
	public function worldToLocal(vector:Vector3):Vector3 {
		var m1 = new Matrix4();
		return vector.applyMatrix4(m1.getInverse(matrixWorld));
	}	
	
	public function lookAt(v:Vector3) {
		// This routine does not support objects with rotated and/or translated parent(s)
		var m1 = new Matrix4();
		m1.lookAt(v, position, up);
		quaternion.setFromRotationMatrix(m1);
	}	
	
	public function add(object:Object3D):Void {
		if (object == this) {
			trace('Object3D.add: An object cant be added as a child of itself.');
			return;
		}
		
		if (object.parent != null) {
			object.parent.remove(object);
		}
		
		object.parent = this;
		
		if (!children.exists(object.uuid)) children.set(object.uuid, object);
		
		var scene = this;
		while (scene.parent != null) { 
			scene = scene.parent;
		}
		
		if (scene != null && Std.is(scene, Scene)) {
			cast(scene, Scene).__addObject(object);
		}
	}	
	
	public function remove(object:Object3D):Void {
		if (children.exists(object.uuid)) {		
			object.parent = null;
			children.remove(object.uuid);
			
			// remove from scene
			var scene = this;
			while (scene.parent != null) {
				scene = scene.parent;
			}
			
			if (scene != null && Std.is(scene, Scene)) {
				cast(scene, Scene).__removeObject(object);
			}		
		}
	}	
	
	public function traverse(fnCallback:Dynamic) {
		fnCallback(this);
		for (key in children.keys()) {
			children.get(key).traverse(fnCallback);
		}
	}	
	
	public function getObjectById(id:Int, recursive:Bool = false):Object3D {
		for (key in children.keys()) {
			var child = children.get(key);
			if (child.id == id) return child;
			if (recursive == true) {
				if (child.getObjectById(id, recursive) != null) {
					return child;
				}
			}
		}
		return null;
	}	
	
	public function getObjectByName(name:String, recursive:Bool = false):Object3D {
		for (key in children.keys()) {
			var child = children.get(key);
			if (child.name == name) return child;
			if (recursive == true) {
				if (child.getObjectByName(name, recursive) != null) {
					return child;
				}
			}
		}
		return null;
	}	
	
	public function getChildByName(name:String, recursive:Bool = false):Object3D {
		trace("DEPRECATED: Object3D\'s .getChildByName() has been renamed to .getObjectByName().");
		return getObjectByName(name, recursive);
	}	
	
	public function getDescendants(array:Array<Object3D> = null):Array<Object3D> {
		if (array == null) array = [];
		
		var _tmpArray:Array<Object3D> = [];
		for (key in children.keys()) {
			_tmpArray.push(children.get(key));
		}
		array = array.concat(_tmpArray);

		for (key in this.children.keys()) {
			children.get(key).getDescendants(array);
		}

		return array;
	}	
	
	public function updateMatrix() {
		matrix.compose(position, quaternion, scale);
		matrixWorldNeedsUpdate = true;
	}
	
	
	public function updateMatrixWorld(force:Bool = false) {
		if (matrixAutoUpdate == true) updateMatrix();
		
		if (matrixWorldNeedsUpdate == true || force == true) {
			if (parent == null) matrixWorld.copy(matrix);
			else matrixWorld.multiplyMatrices(parent.matrixWorld, matrix);
			
			matrixWorldNeedsUpdate = false;
			force = true;
		}
		
		for (key in children.keys()) {
			children.get(key).updateMatrixWorld(force);
		}
	}
	
	
	public function _clone(object:Object3D = null):Object3D {
		if (object == null) object = new Object3D();
		
		object.name = name;
		object.up.copy(up);
		object.position.copy(position);
		object.rotation.copy(rotation);
		object.eulerOrder = eulerOrder;
		object.scale.copy(scale);
		
		object.renderDepth = renderDepth;
		object.rotationAutoUpdate = rotationAutoUpdate;
		
		object.matrix.copy(matrix);
		object.matrixWorld.copy(matrixWorld);
		
		object.matrixAutoUpdate = matrixAutoUpdate;
		object.matrixWorldNeedsUpdate = matrixWorldNeedsUpdate;
		
		object.quaternion.copy(quaternion);
		
		object.visible = visible;
		
		object.castShadow = castShadow;
		object.receiveShadow = receiveShadow;
		
		object.frustumCulled = frustumCulled;
		
		object.userData = Json.parse(Json.stringify(userData));
		
		for (key in children.keys()) {
			object.add(children.get(key)._clone());
		}
		
		return object;
	}	
	
}
