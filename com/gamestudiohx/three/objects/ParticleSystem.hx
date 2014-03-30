package com.gamestudiohx.three.objects;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.ParticleSystemMaterial;

/**
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class ParticleSystem extends Object3D {
	
	//public var geometry:Geometry;
	public var material:ParticleSystemMaterial;
	public var sortParticles:Bool;

	public function new(geometry:Geometry = null, material:ParticleSystemMaterial = null) {
		super();
		
		this.geometry = geometry != null ? geometry : new Geometry();
		this.material = material != null ? material : new ParticleSystemMaterial( { color: Math.random() * 0xffffff } );
		
		this.sortParticles = false;
		this.frustumCulled = false;
	}
	
	public function clone(object:ParticleSystem):ParticleSystem {
		if (object == null) object = new ParticleSystem(this.geometry, this.material);

		object.sortParticles = this.sortParticles;

		object = cast super._clone(object);

		return object;
	}
	
}
