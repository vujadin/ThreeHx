
package com.gamestudiohx.three.objects;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.THREE;
import openfl.utils.Float32Array;

/* 
 * 
 * @author dcm
 */

class Mesh extends Object3D {
	
	//public var geometry:Geometry;
	public var material:Material;
	
	public var morphTargetBase:Int;  
	public var morphTargetForcedOrder:Array<Int>;
	public var morphTargetInfluences:Array<Int>;
    public var morphTargetDictionary:Map<String, Int>;
	
	// for GLRenderer
	public var __webglMorphTargetInfluences:Float32Array;// :Array<Int>;
	// end for GLRenderer
	
	public function new(geometry:Geometry = null, material:Material = null) {
		super();
		
		this.geometry = geometry != null ? geometry : new Geometry();
		this.material = material != null ? material : new MeshBasicMaterial({ color: Math.random() * 0xffffff });

		this.updateMorphTargets();
	}	
	
	public function setGeometry(geometry:Geometry)	{
		this.geometry = geometry;
		if (this.geometry.boundingSphere == null) 
			this.geometry.computeBoundingSphere();
		
		updateMorphTargets();
	}	
	
	public function setMaterial(material:Material = null) {
		if (material != null) this.material = material;
		else this.material = new MeshBasicMaterial( { color: Math.random() * 0xffffff, wireframe: true } );
	}	
	
	public function updateMorphTargets():Void {		
		if (this.geometry.morphTargets.length > 0 ) {
			morphTargetBase = -1;
			morphTargetForcedOrder = new Array();
			morphTargetInfluences = new Array();
			morphTargetDictionary = new Map<String,Int>();
		
			for (m in 0...geometry.morphTargets.length) {
				morphTargetInfluences.push(0);
				morphTargetDictionary.set(geometry.morphTargets[m].name, m);
			}
		}
	}	
	
	public function getMorphTargetIndexByName(name:String):Int {		
		if (morphTargetDictionary.exists(name) != false) {
			return morphTargetDictionary.get(name);			
		}
		
		trace('Mesh.getMorphTargetIndexByName: $name does not exist!');
		return 0;
	}	
	
	public function clone(object:Mesh = null):Mesh {
		if (object == null) object = new Mesh(geometry, material);
		object = cast super._clone(object);
		return object;
	}	
	
}