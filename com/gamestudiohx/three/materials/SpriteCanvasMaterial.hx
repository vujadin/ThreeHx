package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;

/**
 * @author mrdoob / http://mrdoob.com/
 *
 * parameters = {
 *  color: <hex>,
 *  program: <function>,
 *  opacity: <float>,
 *  blending: THREE.NormalBlending
 * }
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class SpriteCanvasMaterial extends Material {

	public var color:Color;
	public var program:Dynamic;
	
	public function new(parameters:Dynamic = null) {
		super();
		
		this.color = new Color(0xffffff );
		this.program = function(context:Dynamic, color:Color) { };

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new SpriteCanvasMaterial();

		material = super.clone(material);

		cast(material, SpriteCanvasMaterial).color.copy(this.color);
		cast(material, SpriteCanvasMaterial).program = this.program;

		return material;
	}
	
}
