package com.gamestudiohx.three.objects;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.THREE;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.materials.LineBasicMaterial;

/**
 * ...
 * @author Krtolica Vujadin
 */
class Line extends Object3D {

	//public var geometry:Geometry;
	public var material:LineBasicMaterial;
	
	public function new(geometry:Geometry = null, material:LineBasicMaterial = null, type:Int = 0) {
		super();
		
		this.geometry = geometry != null ? geometry : new Geometry();
		this.material = material != null ? material : new LineBasicMaterial({ color: Std.int(Math.random() * 0xffffff), opacity: null, blending: null, depthTest: null, depthWrite: null, linewidth: null, linecap: null, linejoin: null, vertexColors: null, fog: null });

		this.type = type;
	}
	
	public function clone(object:Line = null):Line {
		if (object == null) {
			object = new Line(this.geometry, this.material, this.type);
		}
		object = cast super._clone(object);
		return object;
	}
	
}