package com.gamestudiohx.three.math;

import com.gamestudiohx.three.math.Matrix3;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author WestLangley / http://github.com/WestLangley
 * @author bhouston / http://exocortex.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

/*enum RotationOrders {
	XYZ;
	YZX;
	ZXY;
	XZY;
	YXZ;
	ZYX;
}*/

class Euler {
	
	public static var XYZ:Int = 1;
	public static var YZX:Int = 2;
	public static var ZXY:Int = 3;
	public static var XZY:Int = 4;
	public static var YXZ:Int = 5;
	public static var ZYX:Int = 6;
	
	public static var DefaultOrder:Int = 1;
	
	public var _quaternion:Quaternion;
	
	var _x:Float;
	public var x(get, set):Float;
	function get_x():Float {
		return _x;
	}
	function set_x(value:Float):Float {
		_x = value;
		this._updateQuaternion();
		return _x;
	}
	
	var _y:Float;
	public var y(get, set):Float;
	function get_y():Float {
		return _y;
	}
	function set_y(value:Float):Float {
		_y = value;
		this._updateQuaternion();
		return _y;
	}
	
	var _z:Float;
	public var z(get, set):Float;
	function get_z():Float {
		return _z;
	}
	function set_z(value:Float):Float {
		_z = value;
		this._updateQuaternion();
		return _z;
	}
	
	var _order:Int;
	public var order(get, set):Int;
	function get_order():Int {
		return _order;
	}
	function set_order(value:Int):Int {
		_order = value;
		this._updateQuaternion();
		return _order;
	}

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, order:Int = 1) {
		this._x = x;
		this._y = y;
		this._z = z;
		this._order = order;
		_quaternion = null;
	}
	
	public function set(x:Float, y:Float, z:Float, order:Int = 0):Euler {
		this._x = x;
		this._y = y;
		this._z = z;
		this._order = order == 0 ? this._order : order;

		this._updateQuaternion();

		return this;
	}
	
	public function copy(euler:Euler):Euler {
		this._x = euler._x;
		this._y = euler._y;
		this._z = euler._z;
		this._order = euler._order;

		this._updateQuaternion();

		return this;
	}
	
	public function _updateQuaternion() {
		if (this._quaternion != null) {
			this._quaternion.setFromEuler(this, false);
		}
	}
	
	public function setFromRotationMatrix(m:Matrix3, order:Int = 0):Euler {
		// assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
		// clamp, to handle numerical problems
		function clamp(x:Float):Float {
			return Math.min(Math.max(x, -1), 1);
		}

		var te = m.elements;
		var m11 = te[0], m12 = te[4], m13 = te[8];
		var m21 = te[1], m22 = te[5], m23 = te[9];
		var m31 = te[2], m32 = te[6], m33 = te[10];

		order = order == 0 ? this._order : order;

		if (order == XYZ) {
			this._y = Math.asin(clamp(m13));
			if (Math.abs(m13) < 0.99999) {
				this._x = Math.atan2(-m23, m33);
				this._z = Math.atan2(-m12, m11);
			} else {
				this._x = Math.atan2(m32, m22);
				this._z = 0;
			}

		} else if (order == YXZ) {
			this._x = Math.asin(-clamp(m23));
			if (Math.abs(m23) < 0.99999) {
				this._y = Math.atan2(m13, m33);
				this._z = Math.atan2(m21, m22);
			} else {
				this._y = Math.atan2(-m31, m11);
				this._z = 0;
			}
		} else if (order == ZXY) {
			this._x = Math.asin(clamp(m32));
			if (Math.abs(m32) < 0.99999) {
				this._y = Math.atan2(-m31, m33);
				this._z = Math.atan2(-m12, m22);
			} else {
				this._y = 0;
				this._z = Math.atan2(m21, m11);
			}
		} else if (order == ZYX) {
			this._y = Math.asin(-clamp(m31));

			if (Math.abs(m31) < 0.99999) {
				this._x = Math.atan2(m32, m33);
				this._z = Math.atan2(m21, m11);
			} else {
				this._x = 0;
				this._z = Math.atan2(-m12, m22);
			}
		} else if (order == YZX) {
			this._z = Math.asin(clamp(m21));
			if (Math.abs(m21) < 0.99999) {
				this._x = Math.atan2(-m23, m22);
				this._y = Math.atan2(-m31, m11);
			} else {
				this._x = 0;
				this._y = Math.atan2(m13, m33);
			}
		} else if (order == XZY) {
			this._z = Math.asin(-clamp(m12));
			if (Math.abs(m12) < 0.99999) {
				this._x = Math.atan2(m32, m22);
				this._y = Math.atan2(m13, m11);
			} else {
				this._x = Math.atan2(-m23, m33);
				this._y = 0;
			}
		} else {
			trace("WARNING: Euler.setFromRotationMatrix() given unsupported order: " + order);
		}

		this._order = order;

		this._updateQuaternion();

		return this;
	}
	
	public function setFromQuaternion(q:Quaternion, order:Int = 0, update:Bool = true):Euler {
		// q is assumed to be normalized
		// clamp, to handle numerical problems
		function clamp(x:Float):Float {
			return Math.min(Math.max(x, -1), 1);
		}

		// http://www.mathworks.com/matlabcentral/fileexchange/20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/content/SpinCalc.m

		var sqx = q.x * q.x;
		var sqy = q.y * q.y;
		var sqz = q.z * q.z;
		var sqw = q.w * q.w;

		order = order == 0 ? this._order : order;

		if (order == XYZ) {
			this._x = Math.atan2(2 * (q.x * q.w - q.y * q.z ), (sqw - sqx - sqy + sqz));
			this._y = Math.asin(clamp(2 * (q.x * q.z + q.y * q.w)));
			this._z = Math.atan2(2 * (q.z * q.w - q.x * q.y), (sqw + sqx - sqy - sqz));
		} else if (order == YXZ) {
			this._x = Math.asin(clamp(2 * (q.x * q.w - q.y * q.z)));
			this._y = Math.atan2(2 * (q.x * q.z + q.y * q.w), (sqw - sqx - sqy + sqz));
			this._z = Math.atan2(2 * (q.x * q.y + q.z * q.w), (sqw - sqx + sqy - sqz));
		} else if (order == ZXY) {
			this._x = Math.asin(clamp(2 * (q.x * q.w + q.y * q.z)));
			this._y = Math.atan2(2 * (q.y * q.w - q.z * q.x), (sqw - sqx - sqy + sqz));
			this._z = Math.atan2(2 * (q.z * q.w - q.x * q.y), (sqw - sqx + sqy - sqz));
		} else if (order == ZYX) {
			this._x = Math.atan2(2 * (q.x * q.w + q.z * q.y), (sqw - sqx - sqy + sqz));
			this._y = Math.asin(clamp(2 * (q.y * q.w - q.x * q.z)));
			this._z = Math.atan2(2 * (q.x * q.y + q.z * q.w), (sqw + sqx - sqy - sqz));
		} else if (order == YZX) {
			this._x = Math.atan2(2 * (q.x * q.w - q.z * q.y), (sqw - sqx + sqy - sqz));
			this._y = Math.atan2(2 * (q.y * q.w - q.x * q.z), (sqw + sqx - sqy - sqz));
			this._z = Math.asin(clamp(2 * (q.x * q.y + q.z * q.w)));
		} else if (order == XZY) {
			this._x = Math.atan2(2 * (q.x * q.w + q.y * q.z), (sqw - sqx + sqy - sqz));
			this._y = Math.atan2(2 * (q.x * q.z + q.y * q.w), (sqw + sqx - sqy - sqz));
			this._z = Math.asin(clamp(2 * (q.z * q.w - q.x * q.y)));
		} else {
			trace("WARNING: Euler.setFromQuaternion() given unsupported order: " + order);
		}

		this._order = order;

		if (update) this._updateQuaternion();

		return this;
	}
	
	public function reorder(newOrder:Int) {
		// WARNING: this discards revolution information -bhouston
		var q = new Quaternion();
		
		q.setFromEuler(this, false);
		setFromQuaternion(q, newOrder);
	}
	
	public function fromArray(array:Array<Float>):Euler {
		this._x = array[0];
		this._y = array[1];
		this._z = array[2];
		if (array.length > 3) this._order = Std.int(array[3]);

		this._updateQuaternion();

		return this;
	}
	
	public function toArray():Array<Float> {
		return [this._x, this._y, this._z, this._order];
	}
	
	public function equals(euler:Euler):Bool {
		return (euler._x == this._x) && (euler._y == this._y) && (euler._z == this._z) && (euler._order == this._order);
	}
	
	public function clone():Euler {
		return new Euler(this._x, this._y, this._z, this._order);
	}
}