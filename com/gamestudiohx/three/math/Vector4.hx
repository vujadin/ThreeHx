package com.gamestudiohx.three.math;

/**
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author philogb / http://blog.thejit.org/
 * @author mikael emtinger / http://gomo.se/
 * @author egraether / http://egraether.com/
 * @author WestLangley / http://github.com/WestLangley
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Vector4 {
	
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1)	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public function set(x:Float, y:Float, z:Float, w:Float):Vector4 {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}
		
	public function setX(x:Float = 0):Vector4 {
		this.x = x;
		return this;
	}
	
	
	public function setY(y:Float = 0):Vector4 {
		this.y = y;
		return this;
	}
	
	
	public function setZ(z:Float = 0):Vector4 {
		this.z = z;
		return this;
	}
	
	
	public function setW(w:Float = 0):Vector4 {
		this.w = w;
		return this;
	}
	
	
	public function setComponent(index:Int, value:Float):Vector4 {
		switch (index) {
			case 0: 
				this.x = value;
			case 1: 
				this.y = value;
			case 2: 
				this.z = value;
			case 3: 
				this.w = value;
			default: 
				throw("index is out of range: " + index);
		}
		return this;
	}
	
	public function getComponent(index:Int):Float {
		switch (index) {
			case 0: 
				return x;
			case 1: 
				return y;
			case 2: 
				return z;
			case 3: 
				return w;
			default:
				throw("index is out of range: " + index);
		}
	}
	
	// v could be Vector3 or Vector4
	public function copy(v:Dynamic):Vector4	{
		x = v.x;
		y = v.y;
		z = v.z;
		w = (v.w != null) ? v.w : 1;
		return this;
	}
	
	public function add(v:Vector4, w:Vector4 = null):Vector4 {
		if (w != null) {
			trace("DEPRECATED: Vector4\'s .add() now only accepts one argument. Use .addVectors( a, b ) instead.");
			return this.addVectors(v, w);
		}

		this.x += v.x;
		this.y += v.y;
		this.z += v.z;
		this.w += v.w;

		return this;
	}	
	
	public function addScalar(s:Float):Vector4 {
		x += s;
		y += s;
		z += s;
		w += w;
		return this;
	}	
	
	public function addVectors(a:Vector4, b:Vector4):Vector4 {
		x = a.x + b.x;
		y = a.y + b.y;
		z = a.z + b.z;
		w = a.w + b.w;
		return this;
	}	
	
	public function sub(v:Vector4, w:Vector4 = null):Vector4 {
		if (w != null) {
			trace("DEPRECATED: Vector4\'s .sub() now only accepts one argument. Use .subVectors( a, b ) instead.");
			return this.subVectors(v, w);
		}

		this.x -= v.x;
		this.y -= v.y;
		this.z -= v.z;
		this.w -= v.w;

		return this;
	}	
	
	public function subVectors(a:Vector4, b:Vector4):Vector4 {
		x = a.x - b.x;
		y = a.y - b.y;
		z = a.z - b.z;
		w = a.w - b.w;
		return this;
	}
		
	public function multiplyScalar(scalar:Float):Vector4 {
		x *= scalar;
		y *= scalar;
		z *= scalar;
		w *= scalar;
		return this;
	}
	
	public function applyMatrix4(m:Matrix4):Vector4 {
		var x = this.x;
		var y = this.y;
		var z = this.z;
		var w = this.w;
		
		var e = m.elements;
		
		this.x = e[0] * x + e[4] * y + e[8] * z + e[12] * w;
		this.y = e[1] * x + e[5] * y + e[9] * z + e[13] * w;
		this.z = e[2] * x + e[6] * y + e[10] * z + e[14] * w;
		this.w = e[3] * x + e[7] * y + e[11] * z + e[15] * w;
		return this;
	}
		
	public function divideScalar(scalar:Float):Vector4 {
		if (scalar != 0) {
			var invScalar = 1 / scalar;

			this.x *= invScalar;
			this.y *= invScalar;
			this.z *= invScalar;
			this.w *= invScalar;
		} else {
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 1;
		}

		return this;
	}
	
	public function setAxisAngleFromQuaternion(q:Quaternion):Vector4 {
		// http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/index.htm
		// q is assumed to be normalized
		w = 2 * Math.acos(q.w);
		var s = Math.sqrt(1 - q.w * q.w);
		
		if (s < 0.0001) {
			x = 1;
			y = 0;
			z = 0;
		} else {
			x = q.x / s;
			y = q.y / s;
			z = q.z / s;
		}
		
		return this;
	}	
	
	public function setAxisAngleFromRotationMatrix(m:Matrix4):Vector4 {
		// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle/index.htm
		// assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
		var angle:Float;   		// variables for result
		var	epsilon = 0.01;		// margin to allow for rounding errors
		var	epsilon2 = 0.1;		// margin to distinguish between 0 and 180 degrees

		var	te = m.elements;

		var	m11 = te[0], m12 = te[4], m13 = te[8];
		var	m21 = te[1], m22 = te[5], m23 = te[9];
		var	m31 = te[2], m32 = te[6], m33 = te[10];

		if ((Math.abs(m12 - m21) < epsilon)
		  && (Math.abs(m13 - m31) < epsilon)
		  && (Math.abs(m23 - m32) < epsilon)) {
			// singularity found
			// first check for identity matrix which must have +1 for all terms
			// in leading diagonal and zero in other terms
			if ((Math.abs(m12 + m21) < epsilon2)
			  && (Math.abs(m13 + m31) < epsilon2)
			  && (Math.abs(m23 + m32) < epsilon2)
			  && (Math.abs(m11 + m22 + m33 - 3) < epsilon2)) {
				// this singularity is identity matrix so angle = 0
				this.set(1, 0, 0, 0);
				return this; // zero angle, arbitrary axis
			}

			// otherwise this singularity is angle = 180
			angle = Math.PI;

			var xx = (m11 + 1) / 2;
			var yy = (m22 + 1) / 2;
			var zz = (m33 + 1) / 2;
			var xy = (m12 + m21) / 4;
			var xz = (m13 + m31) / 4;
			var yz = (m23 + m32) / 4;

			if ((xx > yy) && (xx > zz)) { // m11 is the largest diagonal term
				if (xx < epsilon) {
					x = 0;
					y = 0.707106781;
					z = 0.707106781;
				} else {
					x = Math.sqrt(xx);
					y = xy / x;
					z = xz / x;
				}
			} else if (yy > zz) { // m22 is the largest diagonal term
				if (yy < epsilon) {
					x = 0.707106781;
					y = 0;
					z = 0.707106781;
				} else {
					y = Math.sqrt(yy);
					x = xy / y;
					z = yz / y;
				}
			} else { // m33 is the largest diagonal term so base result on this
				if (zz < epsilon) {
					x = 0.707106781;
					y = 0.707106781;
					z = 0;
				} else {
					z = Math.sqrt(zz);
					x = xz / z;
					y = yz / z;
				}
			}

			this.set(x, y, z, angle);

			return this; // return 180 deg rotation
		}

		// as we have reached here there are no singularities so we can handle normally
		var s = Math.sqrt((m32 - m23) * (m32 - m23)
						 + (m13 - m31) * (m13 - m31)
						 + (m21 - m12) * (m21 - m12)); // used to normalize

		if (Math.abs(s) < 0.001) s = 1;

		// prevent divide by zero, should not happen if matrix is orthogonal and should be
		// caught by singularity test above, but I've left it in just in case
		this.x = (m32 - m23) / s;
		this.y = (m13 - m31) / s;
		this.z = (m21 - m12) / s;
		this.w = Math.acos((m11 + m22 + m33 - 1) / 2);

		return this;
	}	
	
	public function min (v:Vector4):Vector4	{
		if (this.x > v.x) {
			this.x = v.x;
		}

		if (this.y > v.y) {
			this.y = v.y;
		}

		if (this.z > v.z) {
			this.z = v.z;
		}

		if (this.w > v.w) {
			this.w = v.w;
		}

		return this;
	}	
	
	public function max(v:Vector4):Vector4 {
		if (this.x < v.x) {
			this.x = v.x;
		}

		if (this.y < v.y) {
			this.y = v.y;
		}

		if (this.z < v.z) {
			this.z = v.z;
		}

		if (this.w < v.w) {
			this.w = v.w;
		}

		return this;
	}	
	
	public function clamp(min:Vector4, max:Vector4):Vector4 {
		// This function assumes min < max, if this assumption isn't true it will not operate correctly
		if (this.x < min.x) {
			this.x = min.x;
		} else if (this.x > max.x) {
			this.x = max.x;
		}

		if (this.y < min.y) {
			this.y = min.y;
		} else if (this.y > max.y) {
			this.y = max.y;
		}

		if (this.z < min.z) {
			this.z = min.z;
		} else if (this.z > max.z) {
			this.z = max.z;
		}

		if (this.w < min.w) {
			this.w = min.w;
		} else if (this.w > max.w) {
			this.w = max.w;
		}

		return this;
	}	
	
	public function negate():Vector4 {
		return multiplyScalar(-1);
	}	
	
	public function dot(v:Vector4):Float {
		return x * v.x + y * v.y + z * v.z + w * v.w;
	}	
	
	public function lengthSq():Float {
		return x * x + y * y + z * z + w * w;
	}	
	
	public function length():Float {
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}	
	
	public function lengthManhattan():Float {
		return Math.abs(x) + Math.abs(y) + Math.abs(z) + Math.abs(w);
	}	
	
	public function normalize():Vector4 {
		return divideScalar(length());
	}	
	
	public function setLength(l:Float):Vector4 {
		var oldLength = length();
		if (oldLength != 0 && l != oldLength) {
			multiplyScalar(l / oldLength);
		}
		return this;
	}	
	
	public function lerp(v:Vector4, alpha:Float):Vector4 {
		x += (v.x - x) * alpha;
		y += (v.y - y) * alpha;
		z += (v.z - z) * alpha;
		w += (v.w - w) * alpha;
		return this;
	}	
	
	public function equals(v:Vector4):Bool {
		return ((x == v.x) && (y == v.y) && (z == v.z) && (w == v.w));
	}	
	
	public function fromArray(array:Array<Float>):Vector4 {
		this.x = array[0];
		this.y = array[1];
		this.z = array[2];
		this.w = array[3];
		
		return this;
	}	
	
	public function toArray():Array<Float> {
		return [this.x, this.y, this.z, this.w];
	}	
	
	public function clone():Vector4 {
		return new Vector4(x, y, z, w);
	}	

}
