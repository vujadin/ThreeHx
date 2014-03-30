package com.gamestudiohx.three.math;

/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 * @author WestLangley / http://github.com/WestLangley
 * @author bhouston / http://exocortex.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Quaternion {
	
	private var _x:Float;
	public var x(get, set):Float;
	function get_x():Float {
		return _x;
	}
	function set_x(value:Float):Float {
		_x = value;
		return _x;
	}
	
	private var _y:Float;
	public var y(get, set):Float;
	function get_y():Float {
		return _y;
	}
	function set_y(value:Float):Float {
		_y = value;
		return _y;
	}
	
	private var _z:Float;
	public var z(get, set):Float;
	function get_z():Float {
		return _z;
	}
	function set_z(value:Float):Float {
		_z = value;
		return _z;
	}
	
	private var _w:Float;
	public var w(get, set):Float;
	function get_w():Float {
		return _w;
	}
	function set_w(value:Float):Float {
		_w = value;
		return _w;
	}
	
	public var _euler:Euler;	
	
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		
		_euler = null;
	}
	
	public function _updateEuler() {
		if (this._euler != null) {
			this._euler.setFromQuaternion(this, 0, false);
		}
	}	
	
	public function set(x:Float, y:Float, z:Float, w:Float):Quaternion {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		
		this._updateEuler();
		
		return this;
	}
	
	
	public function copy(q:Quaternion):Quaternion {
		this.x = q.x;
		this.y = q.y;
		this.z = q.z;
		this.w = q.w;
		
		this._updateEuler();
		
		return this;
	}
	
	
	public function setFromEuler(euler:Euler, update:Bool):Quaternion {
		// http://www.mathworks.com/matlabcentral/fileexchange/
		// 	20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/
		//	content/SpinCalc.m
		var c1 = Math.cos(euler.x / 2);
		var c2 = Math.cos(euler.y / 2);
		var c3 = Math.cos(euler.z / 2);
		var s1 = Math.sin(euler.x / 2);
		var s2 = Math.sin(euler.y / 2);
		var s3 = Math.sin(euler.z / 2);

		if (euler.order == Euler.XYZ) {
			this._x = s1 * c2 * c3 + c1 * s2 * s3;
			this._y = c1 * s2 * c3 - s1 * c2 * s3;
			this._z = c1 * c2 * s3 + s1 * s2 * c3;
			this._w = c1 * c2 * c3 - s1 * s2 * s3;
		} else if (euler.order == Euler.YXZ) {
			this._x = s1 * c2 * c3 + c1 * s2 * s3;
			this._y = c1 * s2 * c3 - s1 * c2 * s3;
			this._z = c1 * c2 * s3 - s1 * s2 * c3;
			this._w = c1 * c2 * c3 + s1 * s2 * s3;
		} else if (euler.order == Euler.ZXY) {
			this._x = s1 * c2 * c3 - c1 * s2 * s3;
			this._y = c1 * s2 * c3 + s1 * c2 * s3;
			this._z = c1 * c2 * s3 + s1 * s2 * c3;
			this._w = c1 * c2 * c3 - s1 * s2 * s3;
		} else if (euler.order == Euler.ZYX) {
			this._x = s1 * c2 * c3 - c1 * s2 * s3;
			this._y = c1 * s2 * c3 + s1 * c2 * s3;
			this._z = c1 * c2 * s3 - s1 * s2 * c3;
			this._w = c1 * c2 * c3 + s1 * s2 * s3;
		} else if (euler.order == Euler.YZX) {
			this._x = s1 * c2 * c3 + c1 * s2 * s3;
			this._y = c1 * s2 * c3 + s1 * c2 * s3;
			this._z = c1 * c2 * s3 - s1 * s2 * c3;
			this._w = c1 * c2 * c3 - s1 * s2 * s3;
		} else if (euler.order == Euler.XZY) {
			this._x = s1 * c2 * c3 - c1 * s2 * s3;
			this._y = c1 * s2 * c3 - s1 * c2 * s3;
			this._z = c1 * c2 * s3 + s1 * s2 * c3;
			this._w = c1 * c2 * c3 + s1 * s2 * s3;
		}

		if (update) this._updateEuler();

		return this;
	}
	
	
	public function setFromAxisAngle(axis:Vector3, angle:Float):Quaternion {
		var halfAngle = angle / 2;
		var s = Math.sin(halfAngle);
		this.x = axis.x * s;
		this.y = axis.y * s;
		this.z = axis.z * s;
		this.w = Math.cos(halfAngle);
		
		this._updateEuler();
		
		return this;
	}
	
	
	public function setFromRotationMatrix(m:Matrix4):Quaternion {
		var e = m.elements;
		var m11 = e[0], m12 = e[4], m13 = e[8];
		var m21 = e[1], m22 = e[5], m23 = e[9];
		var m31 = e[2], m32 = e[6], m33 = e[10];
		var tr = m11 + m22 + m33, s:Float;
		
		if (tr > 0) {
			s = 0.5 / Math.sqrt(tr + 1.0);
			this.w = 0.25 / s;
			this.x = (m32 - m23) * s;
			this.y = (m13 - m31) * s;
			this.z = (m21 - m12) * s;			
		} else if (m11 > m22 && m11 > m33) {
			s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);
			this.w = (m32 - m23) / s;
			this.x = 0.25 * s;
			this.y = (m12 + m21) / s;
			this.z = (m13 + m31) / s;			
		} else if (m22 > m33) {
			s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);
			this.w = (m13 - m31) / s;
			this.x = (m12 + m21) / s;
			this.y = 0.25 * s;
			this.z = (m23 + m32) / s;			
		} else {
			s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);
			this.w = (m21 - m12) / s;
			this.x = (m13 + m31) / s;
			this.y = (m23 + m32) / s;
			this.z = 0.25 * s;
		}
		
		this._updateEuler();
		
		return this;
	}
	
	
	public function inverse():Quaternion {
		this.conjugate().normalize();
		return this;
	}
	
	
	public function conjugate():Quaternion {
		this.x *= -1;
		this.y *= -1;
		this.z *= -1;
		
		this._updateEuler();
		
		return this;
	}

	
	public function lengthSq():Float {
		return x * x + y * y + z * z + w * w;
	}
	
	
	public function length():Float {
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}
	
	
	public function normalize():Quaternion {
		var l = length();
		if (l == 0) {
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 1;
		} else {
			l = 1 / l;
			this.x *= l;
			this.y *= l;
			this.z *= l;
			this.w *= l;
		}
		return this;
	}
	
	
	public function multiply(q:Quaternion, p:Quaternion = null):Quaternion {
		if (p != null) {
			trace("DEPRECATED: Quaternion\'s .multiply() now only accepts one argument. Use .multiplyQuaternions( a, b ) instead.");
			return this.multiplyQuaternions(q, p);
		}
		return this.multiplyQuaternions(this, q);
	}
	
	
	public function multiplyQuaternions(a:Quaternion, b:Quaternion):Quaternion {
		// from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm
		var qax = a.x, qay = a.y, qaz = a.z, qaw = a.w;
		var qbx = b.x, qby = b.y, qbz = b.z, qbw = b.w;
		
		this.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
		this.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
		this.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
		this.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;
		
		this._updateEuler();
		
		return this;
	}	
	
	public function multiplyVector3(vector:Vector3):Vector3 {
		trace("DEPRECATED: Quaternion\'s .multiplyVector3() has been removed. Use is now vector.applyQuaternion( quaternion ) instead.");
		return vector.applyQuaternion(this);
	}	
	
	// private
	public function _slerp(qb:Quaternion, t:Float):Quaternion {
		var x = this._x, y = this._y, z = this._z, w = this._w;
		// http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/
		var cosHalfTheta = w * qb._w + x * qb._x + y * qb._y + z * qb._z;
		
		if (cosHalfTheta < 0) {
			this._w = -qb._w;
			this._x = -qb._x;
			this._y = -qb._y;
			this._z = -qb._z;

			cosHalfTheta = -cosHalfTheta;
		} else {
			this.copy(qb);
		}

		if (cosHalfTheta >= 1.0) {
			this._w = w;
			this._x = x;
			this._y = y;
			this._z = z;

			return this;
		}

		var halfTheta = Math.acos(cosHalfTheta);
		var sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

		if (Math.abs(sinHalfTheta) < 0.001) {
			this._w = 0.5 * ( w + this._w );
			this._x = 0.5 * ( x + this._x );
			this._y = 0.5 * ( y + this._y );
			this._z = 0.5 * ( z + this._z );

			return this;

		}

		var ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta;
		var ratioB = Math.sin(t * halfTheta) / sinHalfTheta;

		this._w = (w * ratioA + this._w * ratioB);
		this._x = (x * ratioA + this._x * ratioB);
		this._y = (y * ratioA + this._y * ratioB);
		this._z = (z * ratioA + this._z * ratioB);

		this._updateEuler();

		return this;
	}
	
	public function slerp(qa:Quaternion, qb:Quaternion, qm:Quaternion, t:Float):Quaternion {
		return qm.copy(qa)._slerp(qb, t);
	}
	
	public function equals(quaternion:Quaternion):Bool {
		return ((quaternion.x == x) && (quaternion.y == y) && (quaternion.z == z) && (quaternion.w == w));
	}
	
	public function fromArray(a:Array<Float>):Quaternion {
		this.x = a[0];
		this.y = a[1];
		this.z = a[2];
		this.w = a[3];
		
		this._updateEuler();
		
		return this;
	}	
	
	public function toArray():Array<Float> {
		return [this._x, this._y, this._z, this._w];
	}	
	
	public function clone():Quaternion {
		return new Quaternion(this.x, this.y, this.z, this.w);
	}	
}

