package com.gamestudiohx.three.scenes;

import com.gamestudiohx.three.renderers.WebGLRenderer;

import com.gamestudiohx.three.cameras.Camera;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.lights.Light;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.objects.Bone;


import openfl.gl.GLObject;

/**
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Scene extends Object3D {

	public var fog:Fog; 
	public var overrideMaterial:Material;
	
	public var autoUpdate:Bool;   // checked by the renderer	
	
	public var __lights:Array<Light>;
	
	public var __objectsAdded:Array<Object3D>;
	public var __objectsRemoved:Array<Object3D>;
	
	// for GLRenderer
	public var __webglObjects:Array<ThreeGLObject>;
	public var __webglObjectsImmediate:Array<ThreeGLObject>;
	public var __webglSprites:Array<Dynamic>;
	public var __webglFlares:Array<Dynamic>;
	// end for GLRenderer
	
	
	public function new() {
		super();
		
		fog = null;
		overrideMaterial = null;
		
		autoUpdate = true;
		matrixAutoUpdate = false;
		
		__lights = new Array<Light>();
		__objectsAdded = new Array<Object3D>();
		__objectsRemoved = new Array<Object3D>();		
	}
	
	
	public function __addObject (object:Object3D) {
		if (Std.is(object, Light)) {			
			if (Lambda.indexOf(__lights, cast object) == -1) {
				__lights.push(cast object);
			}
			
			//if (object.target != null && object.target.parent == null) {
				//add(object.target);
			//}
			
		} else if (!Std.is(object, Camera) && !Std.is(object, Bone)) {
			this.__objectsAdded.push(object);

			// check if previously removed
			if (Lambda.indexOf(this.__objectsRemoved, object) != -1) {
				this.__objectsRemoved.remove(object);
			}
		}
		
		for (key in object.children.keys()) {
			__addObject(object.children.get(key));
		}
	}	
	
	public function __removeObject(object:Object3D) {		
		if (Std.is(object, Light)) {
			if (Lambda.indexOf(__lights, cast object) != -1) {
				__lights.remove(cast object);
			}
			
			if (object.shadowCascadeArray != null) {
				for (x in 0...object.shadowCascadeArray.length) {
					this.__removeObject(object.shadowCascadeArray[x]);
				}
			}
			
		} else if (!Std.is(object, Camera)) {
			this.__objectsRemoved.push(object);

			// check if previously added
			if (Lambda.indexOf(this.__objectsAdded, object) != -1) {
				this.__objectsAdded.remove(object);
			}
		}
		
		for (key in object.children.keys()) {
			__removeObject(object.children.get(key));
		}
	}
	
	public function clone(object:Scene = null):Scene {
		if (object == null ) object = new Scene();

		object = cast super._clone(object);

		if (fog != null) object.fog = fog.clone();
		if (overrideMaterial != null) object.overrideMaterial = overrideMaterial.clone();

		object.autoUpdate = autoUpdate;
		object.matrixAutoUpdate = matrixAutoUpdate;

		return object;
	}
	
}
