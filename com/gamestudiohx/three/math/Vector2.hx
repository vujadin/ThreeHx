package com.gamestudiohx.three.math;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author philogb / http://blog.thejit.org/
 * @author egraether / http://egraether.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Vector2 {
	
	public var x:Float;
	public var y:Float;
	
	
	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}
		
	public function set(x:Float, y:Float):Vector2 {
		this.x = x;
		this.y = y;
		return this;
	}	
	
	public function setX(x:Float):Vector2 {
		this.x = x;
		return this;
	}
		
	public function setY(y:Float):Vector2 {
		this.y = y;
		return this;
	}
		
	public function setComponent(index:Int, value:Float):Vector2 {
		switch (index) {
			case 0: 
				x = value;
			case 1: 
				y = value;
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
			default:
				throw("index is out of range: " + index);
		}
		return 0;
	}	
	
	public function copy(v:Vector2):Vector2 {
		x = v.x;
		y = v.y;
		return this;
	}
		
	public function add(v:Vector2, w:Vector2 = null):Vector2 {
		if (w != null) {
			trace("DEPRECATED: Vector2\'s .add() now only accepts one argument. Use .addVectors( a, b ) instead.");
			return addVectors(v, w);
		}
		x += v.x;
		y += v.y;
		return this;
	}	
	
	public function addVectors(a:Vector2, b:Vector2):Vector2 {
		x = a.x + b.x;
		y = a.y + b.y;
		return this;
	}
		
	public function addScalar(s:Float):Vector2 {
		x += s;
		y += s;
		return this;
	}	
	
	public function sub(v:Vector2, w:Vector2 = null):Vector2 {
		if (w != null) {
			trace("DEPRECATED: Vector2\'s .sub() now only accepts one argument. Use .subVectors( a, b ) instead.");
			return subVectors(v, w);
		}
		x -= v.x;
		y -= v.y;
		return this;
	}	
	
	public function subVectors(a:Vector2, b:Vector2):Vector2 {
		x = a.x - b.x;
		y = a.y - b.y;
		return this;
	}	
	
	public function multiplyScalar(s:Float):Vector2 {
		x *= s;
		y *= s;
		return this;
	}
		
	public function divideScalar(scalar:Float):Vector2 {
		if (scalar != 0) {
			var invScalar = 1 / scalar;

			this.x *= invScalar;
			this.y *= invScalar;
		} else {
			this.x = 0;
			this.y = 0;
		}

		return this;
	}
		
	public function min(v:Vector2):Vector2 {
		if (this.x > v.x) {
			this.x = v.x;
		}

		if (this.y > v.y) {
			this.y = v.y;
		}

		return this;
	}	
	
	public function max(v:Vector2):Vector2 {
		if (this.x < v.x) {
			this.x = v.x;
		}

		if (this.y < v.y) {
			this.y = v.y;
		}

		return this;
	}	
	
	public function clamp(min:Vector2, max:Vector2):Vector2 {
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

		return this;
	}	
	
	public function negate():Vector2 {
		return multiplyScalar( -1);
	}	
	
	public function dot(v:Vector2):Float {
		return x * v.x + y * v.y;
	}	
	
	public function lengthSq():Float {
		return x * x + y * y;
	}	
	
	public function length():Float {
		return Math.sqrt(x * x + y * y);
	}	
	
	public function normalize():Vector2 {
		return divideScalar(length());
	}	
	
	public function distanceTo(v:Vector2):Float {
		return Math.sqrt(distanceToSquared(v));
	}	
	
	public function distanceToSquared(v:Vector2):Float {
		var dx = x - v.x;
		var dy = y - v.y;
		return dx * dx + dy * dy;
	}	
	
	public function setLength(l:Float):Vector2 {
		var oldLength = this.length();
		if (oldLength != 0 && l != oldLength) {
			this.multiplyScalar(l / oldLength);
		}

		return this;
	}	
	
	public function lerp(v:Vector2, alpha:Float):Vector2 {
		x += (v.x - x) * alpha;
		y += (v.y - y) * alpha;
		return this;
	}	
	
	public function equals(v:Vector2):Bool {
		return (( v.x == x ) && ( v.y == y ));
	}	
	
	public function fromArray(array:Array<Float>):Vector2 {
		this.x = array[0];
		this.y = array[1];

		return this;
	}	
	
	public function toArray():Array<Float> {
		return [x, y];
	}	
	
	public function clone():Vector2 {
		return new Vector2(x, y);
	}	
	
}


