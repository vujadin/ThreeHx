package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.THREE;
import haxe.ds.StringMap;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Material /*implements IEventDispatcher*/{
	
	public var id:Int;
	public var uuid:String;
	public var name:String;
	public var side:Int;
		
	public var opacity:Float;
	public var transparent:Bool;
	
	public var blending:Int;
	
	public var blendSrc:Int;
	public var blendDst:Int;
	public var blendEquation:Int;
	
	public var depthTest:Bool;
	public var depthWrite:Bool;
	
	public var polygonOffset:Bool;
	public var polygonOffsetFactor:Float;
	public var polygonOffsetUnits:Float;
	
	public var alphaTest:Float;
	
	public var overdraw:Float; // Overdrawn pixels (typically between 0 and 1) for fixing antialiasing gaps in CanvasRenderer
		
	public var visible:Bool = true;
	public var needsUpdate:Bool = true;
	
	// for GLRenderer
	public var program:Dynamic;		// this is probably a structure with GLProgram and some additional fields....
	public var shading:Int;
	public var morphNormals:Bool;
	public var vertexColors:Int;
	public var wireframe:Bool;
	public var defaultAttributeValues:Dynamic;// Map<String, Float32Array>;
	public var morphTargets:Dynamic;// Array<MorphTarget>;
	public var numSupportedMorphNormals:Int;
	// end for GLRenderer
	
	
	public function new() {
		this.id = THREE.MaterialIdCount++;
		this.uuid = ThreeMath.generateUUID();

		this.name = "";

		this.side = THREE.FrontSide;

		this.opacity = 1;
		this.transparent = false;

		this.blending = THREE.NormalBlending;

		this.blendSrc = THREE.SrcAlphaFactor;
		this.blendDst = THREE.OneMinusSrcAlphaFactor;
		this.blendEquation = THREE.AddEquation;

		this.depthTest = true;
		this.depthWrite = true;

		this.polygonOffset = false;
		this.polygonOffsetFactor = 0;
		this.polygonOffsetUnits = 0;

		this.alphaTest = 0;

		this.overdraw = 0; // Overdrawn pixels (typically between 0 and 1) for fixing antialiasing gaps in CanvasRenderer

		this.visible = true;

		this.needsUpdate = true;
		
	}	
	
	public function setValues(values:Dynamic = null):Void {
		if (values == null) return;
		var fields = Reflect.fields(values);
		
		for (key in fields) {
			if (Reflect.hasField(this, key) == false) {
				trace("THREE.Material: \'" + key + "\' parameter is undefined.");
				continue;
			}
			
			var newValue = Reflect.getProperty(values, key);
			var currentValue = Reflect.getProperty(this, key);
			
			if (Std.is(currentValue, Color)) {
				currentValue.set(newValue);

			} else if (Std.is(currentValue, Vector3) && Std.is(newValue, Vector3)) {
				currentValue.copy(newValue);
			} else if (key == "overdraw") {
				// ensure overdraw is backwards-compatable with legacy boolean type
				Reflect.setProperty(this, key, cast(newValue, Float));
			} else {
				Reflect.setProperty(this, key, newValue);
			}
		}
	}	
	
	public function clone(material:Material = null):Material {
		if (material == null) material = new Material();
		
		material.name = name;
		
		material.side = side;
		
		material.opacity = opacity;
		material.transparent = transparent;
		
		material.blending = blending;
		
		material.blendSrc = blendSrc;
		material.blendDst = blendDst;
		material.blendEquation = blendEquation;
		
		material.depthTest = depthTest;
		material.depthWrite = depthWrite;
		
		material.polygonOffset = polygonOffset;
		material.polygonOffsetFactor = polygonOffsetFactor;
		material.polygonOffsetUnits = polygonOffsetUnits;
		
		material.alphaTest = alphaTest;
		
		material.overdraw = overdraw;
		
		material.visible = visible;
		
		return material;
	}
		
	public function dispose() {
		//
	}	
	
}