package com.gamestudiohx.three.math;

/**
 * @author bhouston / http://exocortex.com
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Triangle {
	
	public var a:Vector3;
	public var b:Vector3;
	public var c:Vector3;	

	public function new(a:Vector3 = null, b:Vector3 = null, c:Vector3 = null) {
		this.a = a != null ? a : new Vector3();
		this.b = b != null ? b : new Vector3();
		this.c = c != null ? c : new Vector3();
	}	
	
	static public function normal(a:Vector3, b:Vector3, c:Vector3, optionalTarget:Vector3 = null):Vector3 {
		var v0 = new Vector3();
		
		var result = optionalTarget != null ? optionalTarget : new Vector3();

		result.subVectors(c, b);
		v0.subVectors(a, b);
		result.cross(v0);

		var resultLengthSq = result.lengthSq();
		if(resultLengthSq > 0) {
			return result.multiplyScalar(1 / Math.sqrt(resultLengthSq));
		}

		return result.set(0, 0, 0);
	}	
	
	static public function barycoordFromPoint(point:Vector3, a:Vector3, b:Vector3, c:Vector3, optionalTarget:Vector3 = null):Vector3 {
		var v0 = new Vector3();
		var v1 = new Vector3();
		var v2 = new Vector3();
		
		v0.subVectors(c, a);
		v1.subVectors(b, a);
		v2.subVectors(point, a);

		var dot00 = v0.dot(v0);
		var dot01 = v0.dot(v1);
		var dot02 = v0.dot(v2);
		var dot11 = v1.dot(v1);
		var dot12 = v1.dot(v2);

		var denom = (dot00 * dot11 - dot01 * dot01);

		var result = optionalTarget != null ? optionalTarget : new Vector3();

		// colinear or singular triangle
		if( denom == 0 ) {
			// arbitrary location outside of triangle?
			// not sure if this is the best idea, maybe should be returning undefined
			return result.set(-2, -1, -1);
		}

		var invDenom = 1 / denom;
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		// barycoordinates must always sum to 1
		return result.set(1 - u - v, v, u);
	}	
	
	static public function containsPoint(point:Vector3, a:Vector3, b:Vector3, c:Vector3):Bool {
		var v1 = new Vector3();
		var result = barycoordFromPoint(point, a, b, c, v1);

		return (result.x >= 0) && (result.y >= 0) && ((result.x + result.y) <= 1);
	}	
	
	public function set(a:Vector3, b:Vector3, c:Vector3):Triangle {
		this.a.copy(a);
		this.b.copy(b);
		this.c.copy(c);

		return this;
	}	
	
	public function setFromPointsAndIndices(points:Array<Vector3>, i0:Int, i1:Int, i2:Int):Triangle {
		this.a.copy(points[i0]);
		this.b.copy(points[i1]);
		this.c.copy(points[i2]);
		
		return this;
	}	
	
	public function copy(triangle:Triangle):Triangle {
		this.a.copy(triangle.a);
		this.b.copy(triangle.b);
		this.c.copy(triangle.c);
		
		return this;
	}	
	
	public function area():Float	{
		var v0 = new Vector3();
		var v1 = new Vector3();
		
		v0.subVectors(c, b);
		v1.subVectors(a, b);
		
		return v0.cross(v1).length() * 0.5;
	}	
	
	public function midpoint(optionalTarget:Vector3 = null):Vector3 {
		var result = optionalTarget != null ? optionalTarget : new Vector3();
		return result.addVectors(this.a, this.b).add(this.c).multiplyScalar(1/3); 
	}	
	
	public function normal2(optionalTarget:Vector3 = null):Vector3 {
		return Triangle.normal(a, b, c, optionalTarget);
	}	
	
	public function plane(optionalTarget:Plane = null):Plane {
		var result = optionalTarget != null ? optionalTarget : new Plane();
		return result.setFromCoplanarPoints(this.a, this.b, this.c);
	}	
	
	public function barycoordFromPoint2(point:Vector3, optionalTarget:Vector3 = null):Vector3 {
		return Triangle.barycoordFromPoint(point, this.a, this.b, this.c, optionalTarget);
	}	
	
	public function containsPoint2(point:Vector3):Bool {
		return Triangle.containsPoint(point, this.a, this.b, this.c);
	}	
	
	public function equals(triangle:Triangle):Bool {
		return triangle.a.equals(this.a) && triangle.b.equals(this.b) && triangle.c.equals(this.c);
	}	
	
	public function clone():Triangle {
		return new Triangle().copy(this);
	}	

}
