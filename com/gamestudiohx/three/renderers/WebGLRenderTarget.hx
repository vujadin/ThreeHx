package com.gamestudiohx.three.renderers;

import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.THREE;
import com.gamestudiohx.three.math.Vector2;
import haxe.ds.StringMap.StringMap;
import openfl.gl.GLTexture;

/**
 * @author szimek / https://github.com/szimek/
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class WebGLRenderTarget extends Texture{
	
	public var width:Int;
	public var height:Int;

	public var depthBuffer:Bool;
	public var stencilBuffer:Bool;

	public var shareDepthFrom:WebGLRenderTarget;	// is it ?
	
	// for GLRenderer
	public var __webglFramebuffer:Dynamic;		// GLFramebuffer or Array<GLFramebuffer>
	public var __webglRenderbuffer:Dynamic;		// GLFramebuffer or Array<GLFramebuffer>
	// end for GLRenderer

	public function new(width:Float = 0, height:Float = 0, options:Dynamic = null) {
		super();
		
		this.width = Std.int(width);
		this.height = Std.int(height);
		
		options = options == null ? { } : options;

		this.wrapS = options.wrapS != null ? options.wrapS : THREE.ClampToEdgeWrapping;
		this.wrapT = options.wrapT != null ? options.wrapT : THREE.ClampToEdgeWrapping;

		this.magFilter = options.magFilter != null ? options.magFilter : THREE.LinearFilter;
		this.minFilter = options.minFilter != null ? options.minFilter : THREE.LinearMipMapLinearFilter;

		this.anisotropy = options.anisotropy != null ? options.anisotropy : 1;

		this.offset = new Vector2(0, 0);
		this.repeat = new Vector2(1, 1);

		this.format = options.format != null ? options.format : THREE.RGBAFormat;
		this.type = options.type != null ? options.type : THREE.UnsignedByteType;

		this.depthBuffer = options.depthBuffer != null ? options.depthBuffer : true;
		this.stencilBuffer = options.stencilBuffer != null ? options.stencilBuffer : true;

		this.generateMipmaps = true;

		this.shareDepthFrom = null;		
	}
	
	override public function clone(texture:Texture = null):Texture {
		var tmp = new WebGLRenderTarget(this.width, this.height);
		
		tmp = cast super.clone(tmp);

		tmp.wrapS = this.wrapS;
		tmp.wrapT = this.wrapT;

		tmp.depthBuffer = this.depthBuffer;
		tmp.stencilBuffer = this.stencilBuffer;

		tmp.shareDepthFrom = this.shareDepthFrom;

		return tmp;
	}
}
