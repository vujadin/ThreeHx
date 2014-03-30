package com.gamestudiohx.three.textures;

import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.THREE;

/**
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class CompressedTexture extends Texture {

	public function new(mipmaps:Array<Dynamic> = null, ?width:Float, ?height:Float, ?format:Int, ?type:Int, ?mapping:Dynamic, ?wrapS:Int, ?wrapT:Int, ?magFilter:Int, ?minFilter:Int, ?anisotropy:Int) {
		super(null, mapping, wrapS, wrapT, magFilter, minFilter, format, type, anisotropy);
		
		this.image = { width: width, height: height };
		this.mipmaps = mipmaps;
		
		this.generateMipmaps = false; // WebGL currently can't generate mipmaps for compressed textures, they must be embedded in DDS file
	}
	
	override public function clone(texture:Texture = null):Texture {
		var texture = new CompressedTexture();

		texture = cast super.clone(texture);

		return texture;
	}
}