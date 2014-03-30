package com.gamestudiohx.three.textures;

import com.gamestudiohx.three.math.ThreeMath;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.THREE;
import openfl.gl.GLTexture;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author szimek / https://github.com/szimek/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */


class Texture {
	public var id:Int;
	public var uuid:String;
	public var name:String;
	public var image:Dynamic; 		   // Array<Dynamic>
	
	public var mipmaps:Array<Dynamic>; //??
	public var mapping:Dynamic;
	
	public var wrapS:Int;
	public var wrapT:Int;
	
	public var magFilter:Int;
	public var minFilter:Int;
	
	public var anisotropy:Int = 1;
	
	public var format:Int;
	public var type:Int;
	
	public var offset:Vector2;
	public var repeat:Vector2;
	
	public var generateMipmaps:Bool = true;
	public var premultiplyAlpha:Bool = false;
	public var flipY:Bool = true;
	public var unpackAlignment:Int = 4;
	
	public var needsUpdate:Bool = false;
	public var onUpdate:Dynamic = null; //callback function checked+called by renderers after loading texture
	
	// for GLRenderer
	public var __webglInit:Bool;	
	public var __oldAnisotropy:Int;
	public var __webglTexture:GLTexture;
	// end for GLRenderer
	
	
	public function new(image:Dynamic = null, ?mapping:Dynamic, ?wrapS:Int, ?wrapT:Int,
						?magFilter:Int, ?minFilter:Int, ?format:Int, ?type:Int, ?anisotropy:Int) {
		
		this.id = THREE.GeometryIdCount++;
		this.uuid = ThreeMath.generateUUID();
		//Default constants
		this.mapping = THREE.UVMapping;
		this.wrapS = THREE.ClampToEdgeWrapping;
		this.wrapT = THREE.ClampToEdgeWrapping;
		this.magFilter = THREE.LinearFilter;
		this.minFilter = THREE.LinearMipMapLinearFilter;
		this.format = THREE.RGBAFormat;
		this.type = THREE.UnsignedByteType;
		
		this.image = image;
		this.mipmaps = new Array<Dynamic>();
		
		if (wrapS != null) this.wrapS = wrapS; else this.wrapS = THREE.ClampToEdgeWrapping;
		if (wrapT != null) this.wrapT = wrapT; else this.wrapT = THREE.ClampToEdgeWrapping;
		
		if (magFilter != null) this.magFilter = magFilter; else this.magFilter = THREE.LinearFilter;
		if (minFilter != null) this.minFilter = minFilter; else this.minFilter = THREE.LinearMipMapLinearFilter;
		if (anisotropy != null) this.anisotropy = anisotropy;
		
		if (format != null) this.format = format; else this.format = THREE.RGBAFormat;
		if (type != null) this.type = type; else this.type = THREE.UnsignedByteType;
		
		offset = new Vector2(0, 0);
		repeat = new Vector2(1, 1);
		
		if (image != null) needsUpdate = true;
	}
	
	
	public function clone(texture:Texture = null):Texture {
		if (texture == null) texture = new Texture();
		texture.image = image;
		texture.mipmaps = mipmaps.copy();
		
		texture.mapping = mapping;
		texture.wrapS = wrapS;
		texture.wrapT = wrapT;
		
		texture.magFilter = magFilter;
		texture.minFilter = minFilter;
		
		texture.anisotropy = anisotropy;
		
		texture.format = format;
		texture.type = type;
		
		texture.offset.copy(offset);
		texture.repeat.copy(repeat);
		
		texture.generateMipmaps = generateMipmaps;
		texture.premultiplyAlpha = premultiplyAlpha;
		texture.flipY = flipY;
		texture.unpackAlignment = unpackAlignment;
		return texture;
	}

	
}