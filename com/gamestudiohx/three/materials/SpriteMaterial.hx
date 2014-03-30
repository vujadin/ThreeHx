package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.materials.SpriteMaterial.SMParameters;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.THREE;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  color: <hex>,
 *  opacity: <float>,
 *  map: new THREE.Texture( <Image> ),
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *  depthWrite: <bool>,
 *
 *	uvOffset: new THREE.Vector2(),
 *	uvScale: new THREE.Vector2(),
 *
 *  fog: <bool>
 * }
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef SMParameters = {
    color: Null<Int>,
    opacity: Null<Float>,
	map: Null<Texture>,
  
    blending: Null<Int>,
    depthTest: Null<Bool>,
    depthWrite: Null<Bool>,
  
    uvOffset: Null<Vector2>,
	uvScale: Null<Vector2>,
 
    fog: Null<Bool>
}

class SpriteMaterial extends Material
{

	public var map:Texture;
	public var rotation:Float;
	
	public var fog:Bool;
	
	public var uvOffset:Vector2;
	public var uvScale:Vector2;
	
	public var color:Color;
	
	public function new(parameters:SMParameters = null) {
		super();
		
		// defaults
		this.color = new Color(0xffffff);
		this.map = null;

		this.rotation = 0;

		this.fog = false;

		this.uvOffset = new Vector2(0, 0);
		this.uvScale  = new Vector2(1, 1);

		// set parameters
		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new SpriteMaterial();

		material = super.clone(material);

		cast(material, SpriteMaterial).color.copy( this.color );
		cast(material, SpriteMaterial).map = this.map;

		cast(material, SpriteMaterial).rotation = this.rotation;

		cast(material, SpriteMaterial).uvOffset.copy( this.uvOffset );
		cast(material, SpriteMaterial).uvScale.copy( this.uvScale );

		cast(material, SpriteMaterial).fog = this.fog;

		return material;
	}
	
}