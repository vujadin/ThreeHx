package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;

/**
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
 *
 *  scale: <float>,
 *  dashSize: <float>,
 *  gapSize: <float>,
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

typedef LDMParameters = {
	color: Null<Int>,
    opacity: Null<Float>,
  
    blending: Null<Int>,
    depthTest: Null<Bool>,
    depthWrite: Null<Bool>,
  
    linewidth: Null<Float>,
	
	scale: Null<Float>,
	dashSize: Null<Float>,
	gapSize: Null<Float>,
  
    vertexColors: Null<Bool>,
 
    fog: Null<Bool>
}
 
class LineDashedMaterial extends Material {
	
	public var color:Color;
	
	public var linewidth:Float;
	public var linecap:String;
	public var linejoin:String;

	public var scale:Float;
	public var dashSize:Float;
	public var gapSize:Float;

	//public var vertexColors:Float;

	public var fog:Bool;

	public function new(parameters:LineDashedMaterial = null) {
		super();

		this.color = new Color(0xffffff);

		this.linewidth = 1;
		this.linecap = 'round';
		this.linejoin = 'round';

		this.scale = 1;
		this.dashSize = 3;
		this.gapSize = 1;

		this.vertexColors = 0;

		this.fog = true;

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new LineDashedMaterial();

		material = super.clone(material);

		cast(material, LineDashedMaterial).color.copy(this.color);

		cast(material, LineDashedMaterial).linewidth = this.linewidth;

		cast(material, LineDashedMaterial).scale = this.scale;
		cast(material, LineDashedMaterial).dashSize = this.dashSize;
		cast(material, LineDashedMaterial).gapSize = this.gapSize;

		cast(material, LineDashedMaterial).vertexColors = this.vertexColors;

		cast(material, LineDashedMaterial).fog = this.fog;

		return material;
	}
}