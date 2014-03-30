package com.gamestudiohx.three.renderers.shaders;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector4;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.renderers.shaders.UniformsLib.ULTypeValue;
import com.gamestudiohx.three.textures.Texture;

/**
 * Uniform Utilities
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class UniformsUtils {

	public static function merge(uniforms:Array<Map<String, ULTypeValue>>):Map<String, ULTypeValue> {
		var merged:Map<String, ULTypeValue> = new Map<String, ULTypeValue>();
		
		for(item in uniforms) {
			for (u in item.keys()) {
				var tmp = item.get(u);
				
				if (Std.is(tmp.value, Color) ||
					Std.is(tmp.value, Vector2) ||
					Std.is(tmp.value, Vector3) ||
					Std.is(tmp.value, Vector4) ||
					Std.is(tmp.value, Matrix4) ||
					Std.is(tmp.value, Texture)) {
					merged.set(u, { type: tmp.type, value: tmp.value.clone() } );

				} else if (Std.is(tmp.value, Array)) {
					merged.set(u, { type: tmp.type, value: tmp.value/*._clone()*/ } );

				} else {
					merged.set(u, { type: tmp.type, value: tmp.value } );
				}			
			}
		}

		return merged;
	}
	
	public static function clone(uniforms_src:Map<String, ULTypeValue>):Map<String, ULTypeValue> {
		var parameter_src:Dynamic;
		var uniforms_dst = new Map<String, ULTypeValue>();

		for (u in uniforms_src.keys()) {			
			var p = uniforms_src.get(u);
			parameter_src = p.value;

			if (Std.is(parameter_src, Color) ||
				Std.is(parameter_src, Vector2) ||
				Std.is(parameter_src, Vector3) ||
				Std.is(parameter_src, Vector4) ||
				Std.is(parameter_src, Matrix4) ||
				Std.is(parameter_src, Texture)) {
				uniforms_dst.set(u, { type: p.type, value: parameter_src.clone() } );

			} else if (Std.is(parameter_src, Array)) {
				uniforms_dst.set(u, { type: p.type, value: parameter_src.copy() } );

			} else {
				uniforms_dst.set(u, { type: p.type, value: parameter_src } );
			}			
		}

		return uniforms_dst;
	}
	
}
