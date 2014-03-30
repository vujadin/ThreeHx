package com.gamestudiohx.three.extras.objects;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.extras.objects.LensFlare.ThreeLensFlares;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.THREE;

/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef ThreeLensFlares = {
	texture: Null<Texture>, 						// THREE.Texture
	size: Null<Int>,    							// size in pixels (-1 = use texture.width)
	distance: Null<Float>,      					// distance (0-1) from light source (0=at light source)
	x: Null<Float>, y: Null<Float>, z: Null<Float>,	// screen position (-1 => 1) z = 0 is ontop z = 1 is back
	scale: Null<Float>,				 				// scale
	rotation: Null<Float>,							// rotation
	opacity: Null<Float>,				 			// opacity
	color: Null<Color>,								// color
	blending: Null<Int>,
	wantedRotation: Null<Float>
}

class LensFlare extends Object3D {
	
	public var lensFlares:Array<ThreeLensFlares>;
	public var positionScreen:Vector3;
	public var customUpdateCallback:Dynamic;		// function ?  TODO

	public function new(texture:Texture = null, size:Int = null, distance:Float = null, blending:Int = null, color:Color = null) {
		super();
		
		this.positionScreen = new Vector3();
		this.customUpdateCallback = null;
		
		this.lensFlares = [];
		
		if (texture != null) {
			_add(texture, size, distance, blending, color);
		}
	}
	
	/*
	 * Add: adds another flare
	 */
	public function _add(texture:Texture = null, size:Int = -1, distance:Float = 0, blending:Int = 1, color:Color = null, opacity:Float = 1) {
		if(color == null) color = new Color(0xffffff);

		distance = Math.min(distance, Math.max(0, distance));

		this.lensFlares.push( { texture: texture, 			// THREE.Texture
								size: size, 				// size in pixels (-1 = use texture.width)
								distance: distance, 		// distance (0-1) from light source (0=at light source)
								x: 0, y: 0, z: 0,			// screen position (-1 => 1) z = 0 is ontop z = 1 is back
								scale: 1, 					// scale
								rotation: 1, 				// rotation
								opacity: opacity,			// opacity
								color: color,				// color
								blending: blending,
								wantedRotation: null } );		// blending
	}
	
	/*
	 * Update lens flares update positions on all flares based on the screen position
	 * Set myLensFlare.customUpdateCallback to alter the flares in your project specific way.
	 */
	public function updateLensFlares() {
		var fl = this.lensFlares.length;
		var flare:ThreeLensFlares = null;
		var vecX = -this.positionScreen.x * 2;
		var vecY = -this.positionScreen.y * 2;

		for(f in 0...fl) {
			flare = this.lensFlares[f];

			flare.x = this.positionScreen.x + vecX * flare.distance;
			flare.y = this.positionScreen.y + vecY * flare.distance;

			flare.wantedRotation = flare.x * Math.PI * 0.25;
			flare.rotation += (flare.wantedRotation - flare.rotation) * 0.25;
		}
	}
	
}