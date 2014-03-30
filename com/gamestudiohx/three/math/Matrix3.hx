package com.gamestudiohx.three.math;

//import openfl.utils.Float32Array;

/**
 * @author alteredq / http://alteredqualia.com/
 * @author WestLangley / http://github.com/WestLangley
 * @author bhouston / http://exocortex.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Matrix3 {
		
	//public var elements:openfl.utils.Float32Array;
	public var elements:Array<Float>;	
	
	public function new (
		n11:Float = 1, n12:Float = 0, n13:Float = 0,
		n21:Float = 0, n22:Float = 1, n23:Float = 0,
		n31:Float = 0, n32:Float = 0, n33:Float = 1) {
		elements = new Array<Float>();
		this.set(n11, n12, n13,	n21, n22, n23, n31, n32, n33);
	}	
	
	public function set(
		n11:Float = 1, n12:Float = 0, n13:Float = 0,
		n21:Float = 0, n22:Float = 1, n23:Float = 0,
		n31:Float = 0, n32:Float = 0, n33:Float = 1):Matrix3 {
		var te = this.elements;

		te[0] = n11; te[3] = n12; te[6] = n13;
		te[1] = n21; te[4] = n22; te[7] = n23;
		te[2] = n31; te[5] = n32; te[8] = n33;

		return this;
	}	
	
	public function identity():Matrix3 {
		this.set(
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
		);
		return this;
	}	
	
	public function copy(m:Matrix3):Matrix3 {
		var me = m.elements;
		this.set(
			me[0], me[3], me[6],
			me[1], me[4], me[7],
			me[2], me[5], me[8]
		);
		return this;
	}	
	
	public function multiplyVector3(vector:Vector3):Vector3 {
		trace("DEPRECATED: Matrix3\'s .multiplyVector3() has been removed. Use vector.applyMatrix3( matrix ) instead.");
		return vector.applyMatrix3(this);
	}	
	
	public function multiplyVector3Array(a:Array<Float>):Array<Float> {
		var v1 = new Vector3();
		var i = 0;
		while (i < a.length) {
			v1.x = a[i];
			v1.y = a[i + 1];
			v1.z = a[i + 2];

			v1.applyMatrix3(this);

			a[i]     = v1.x;
			a[i + 1] = v1.y;
			a[i + 2] = v1.z;
			i += 3;
		}
		return a;
	}	
	
	public function multiplyScalar(s:Float):Matrix3 {
		var te = this.elements;

		te[0] *= s; te[3] *= s; te[6] *= s;
		te[1] *= s; te[4] *= s; te[7] *= s;
		te[2] *= s; te[5] *= s; te[8] *= s;

		return this;
	}	
	
	public function determinant():Float {
		var te = this.elements;

		var a = te[0], b = te[1], c = te[2],
			d = te[3], e = te[4], f = te[5],
			g = te[6], h = te[7], i = te[8];

		return a * e * i - a * f * h - b * d * i + b * f * g + c * d * h - c * e * g;
	}	
	
	public function getInverse(matrix:Matrix4, throwOnInvertible:Bool = false):Matrix3 {
		// input: THREE.Matrix4
		// ( based on http://code.google.com/p/webgl-mjs/ )
		var me = matrix.elements;
		var te = this.elements;

		te[0] =   me[10] * me[5] - me[6] * me[9];
		te[1] = - me[10] * me[1] + me[2] * me[9];
		te[2] =   me[6] * me[1] - me[2] * me[5];
		te[3] = - me[10] * me[4] + me[6] * me[8];
		te[4] =   me[10] * me[0] - me[2] * me[8];
		te[5] = - me[6] * me[0] + me[2] * me[4];
		te[6] =   me[9] * me[4] - me[5] * me[8];
		te[7] = - me[9] * me[0] + me[1] * me[8];
		te[8] =   me[5] * me[0] - me[1] * me[4];

		var det = me[0] * te[0] + me[1] * te[3] + me[2] * te[6];

		// no inverse
		if (det == 0) {
			var msg = "Matrix3.getInverse(): can't invert matrix, determinant is 0";

			if (throwOnInvertible) {
				throw(msg); 
			} else {
				trace(msg);
			}

			this.identity();

			return this;
		}

		this.multiplyScalar(1.0 / det);

		return this;
	}	
	
	public function transpose():Matrix3 {
		var tmp:Float;
		var m = this.elements;

		tmp = m[1]; m[1] = m[3]; m[3] = tmp;
		tmp = m[2]; m[2] = m[6]; m[6] = tmp;
		tmp = m[5]; m[5] = m[7]; m[7] = tmp;

		return this;
	}	
	
	public function getNormalMatrix(m:Matrix4):Matrix3 {
		// input: THREE.Matrix4
		this.getInverse(m).transpose();

		return this;
	}	
	
	// WHAT ?
	public function transposeIntoArray(r:Array<Float>):Matrix3 {
		var m = this.elements;
		r[0] = m[0];
		r[1] = m[3];
		r[2] = m[6];
		r[3] = m[1];
		r[4] = m[4];
		r[5] = m[7];
		r[6] = m[2];
		r[7] = m[5];
		r[8] = m[8];
		return this;
	}	
	
	public function clone():Matrix3 {
		var e = this.elements;
		return new Matrix3(
			e[0], e[3], e[6],
			e[1], e[4], e[7],
			e[2], e[5], e[8]
		);
	}
	
}
