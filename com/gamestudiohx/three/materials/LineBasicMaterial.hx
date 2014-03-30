package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  color: <hex>,
 *  opacity: <float>,
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *  depthWrite: <bool>,
 *
 *  linewidth: <float>,
 *  linecap: "round",
 *  linejoin: "round",
 *
 *  vertexColors: <bool>
 *
 *  fog: <bool>
 * }
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef LBMParameters = {
    color: Null<Int>,
    opacity: Null<Float>,
  
    blending: Null<Int>,
    depthTest: Null<Bool>,
    depthWrite: Null<Bool>,
  
    linewidth: Null<Float>,
    linecap: Null<String>,
    linejoin: Null<String>,
  
    vertexColors: Null<Bool>,
 
    fog: Null<Bool>
}

class LineBasicMaterial extends Material {
	public var linewidth:Float;
	public var linecap:String;
	public var linejoin:String;

	//public var vertexColors:Int;

	public var fog:Bool;
	
	public var color:Color;

	public function new(parameters:LBMParameters) {
		super();
		
		this.color = new Color(0xffffff);

		this.linewidth = 1;
		this.linecap = 'round';
		this.linejoin = 'round';

		this.vertexColors = 0;

		this.fog = true;

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new LineBasicMaterial({ color: 0xffffff, opacity: 1, blending: THREE.NormalBlending, depthTest: true, depthWrite: true, linewidth: 1, linecap: "round", linejoin: "round", vertexColors: true, fog: true });

		material = cast super.clone(material);

		cast(material, LineBasicMaterial).color.copy(this.color);

		cast(material, LineBasicMaterial).linewidth = this.linewidth;
		cast(material, LineBasicMaterial).linecap = this.linecap;
		cast(material, LineBasicMaterial).linejoin = this.linejoin;

		cast(material, LineBasicMaterial).vertexColors = this.vertexColors;

		cast(material, LineBasicMaterial).fog = this.fog;

		return material;
	}
	
}