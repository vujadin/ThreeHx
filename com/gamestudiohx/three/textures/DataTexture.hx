package com.gamestudiohx.three.textures;

import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.THREE;

/**
 * ...
 * @author Krtolica Vujadin
 */
class DataTexture extends Texture {

	public function new(?data:Dynamic, ?width:Float, ?height:Float, ?format:Int, ?type:Int, ?mapping:Dynamic, ?wrapS:Int, ?wrapT:Int, ?magFilter:Int, ?minFilter:Int, ?anisotropy:Int) {
		super(null, mapping, wrapS, wrapT, magFilter, minFilter, format, type, anisotropy);
		
		image = { data: data, width: width, height: height };
	}
	
	override public function clone(texture:Texture = null):Texture {
		var texture = new DataTexture();

		texture = cast super.clone(texture );

		return texture;
	}
	
}