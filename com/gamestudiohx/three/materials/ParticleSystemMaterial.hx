package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  color: <hex>,
 *  opacity: <float>,
 *  map: new THREE.Texture( <Image> ),
 *
 *  size: <float>,
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *  depthWrite: <bool>,
 *
 *  vertexColors: <bool>,
 *
 *  fog: <bool>
 * }
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class ParticleSystemMaterial extends Material {
	
	public var color:Color;
	
	public var map:Dynamic;
	
	public var size:Float;
	public var sizeAttenuation:Bool;
	
	//public var vertexColors:Bool;
	
	public var fog:Bool;
	

	public function new(parameters:Dynamic = null) {
		super();
		
		this.color = new Color(0xffffff);

		this.map = null;

		this.size = 1;
		this.sizeAttenuation = true;

		this.vertexColors = 0; // original -> false;

		this.fog = true;

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new ParticleSystemMaterial();

		material = super.clone(material);

		cast(material, ParticleSystemMaterial).color.copy(this.color);

		cast(material, ParticleSystemMaterial).map = this.map;

		cast(material, ParticleSystemMaterial).size = this.size;
		cast(material, ParticleSystemMaterial).sizeAttenuation = this.sizeAttenuation;

		cast(material, ParticleSystemMaterial).vertexColors = this.vertexColors;

		cast(material, ParticleSystemMaterial).fog = this.fog;

		return material;
	}
}