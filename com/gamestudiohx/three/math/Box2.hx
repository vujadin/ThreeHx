package com.gamestudiohx.three.math;

/**
 * @author bhouston / http://exocortex.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Box2 {
	
	public var min:Vector2;
	public var max:Vector2;
	
	public function new(min:Vector2 = null, max:Vector2 = null) {
		this.min = min != null ? min : new Vector2(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
		this.max = max != null ? max : new Vector2(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
	}	
	
	public function set(min:Vector2, max:Vector2):Box2 {
		this.min.copy(min);
		this.max.copy(max);
		
		return this;
	}	
	
	public function setFromPoints(points:Array<Vector2>):Box2 {
		if (points.length > 0) {
			var point = points[0];

			this.min.copy(point);
			this.max.copy(point);

			for (i in 1...points.length) {
				point = points[i];

				if (point.x < this.min.x) {
					this.min.x = point.x;
				} else if (point.x > this.max.x) {
					this.max.x = point.x;
				}

				if (point.y < this.min.y) {
					this.min.y = point.y;
				} else if (point.y > this.max.y) {
					this.max.y = point.y;
				}
			}
		} else {
			this.makeEmpty();
		}

		return this;
	}	
	
	public function setFromCenterAndSize(center:Vector2, size:Vector2):Box2 {
		var v1 = new Vector2();
		var halfSize = v1.copy(size).multiplyScalar(0.5);
		this.min.copy(center).sub(halfSize);
		this.max.copy(center).add(halfSize);
		
		return this;
	}	
	
	public function copy(box:Box2):Box2 {
		this.min.copy(box.min);
		this.max.copy(box.max);
		
		return this;
	}	
	
	public function makeEmpty():Box2 {
		this.min.x = this.min.y = Math.POSITIVE_INFINITY;
		this.max.x = this.max.y = -Math.POSITIVE_INFINITY;
		
		return this;
	}	
	
	public function empty():Bool {
		// this is a more robust check for empty than ( volume <= 0 ) because volume can get positive with two negative axes
		return (this.max.x < this.min.x) || (this.max.y < this.min.y);
	}	
	
	public function center(optionalTarget:Vector2 = null):Vector2 {
		var result = optionalTarget != null ? optionalTarget : new Vector2();
		return result.addVectors(this.min, this.max).multiplyScalar(0.5);
	}	
	
	public function size(optionalTarget = null):Vector2 {
		var result = optionalTarget != null ? optionalTarget : new Vector2();
		return result.subVectors(this.max, this.min);
	}	
	
	public function expandByPoint(point:Vector2):Box2 {
		this.min.min(point);
		this.max.max(point);
		
		return this;
	}	
	
	public function expandByVector(vector:Vector2):Box2 {
		this.min.sub(vector);
		this.max.add(vector);
		return this;
	}	
	
	public function expandByScalar(scalar:Float):Box2 {
		this.min.addScalar(-scalar);
		this.max.addScalar(scalar);
		return this;
	}	
	
	public function containsPoint(point:Vector2):Bool {
		if (point.x < this.min.x || point.x > this.max.x ||
		    point.y < this.min.y || point.y > this.max.y) {

			return false;
		}

		return true;
	}	
	
	public function containsBox(box:Box2):Bool {
		if ((this.min.x <= box.min.x) && (box.max.x <= this.max.x) &&
		    (this.min.y <= box.min.y) && (box.max.y <= this.max.y)) {

			return true;
		}

		return false;
	}	
	
	public function getParameter(point:Vector2, optionalTarget:Vector2):Vector2 {
		// This can potentially have a divide by zero if the box
		// has a size dimension of 0.
		var result = optionalTarget != null ? optionalTarget : new Vector2();

		return result.set(
			(point.x - this.min.x) / (this.max.x - this.min.x),
			(point.y - this.min.y) / (this.max.y - this.min.y)
		);
	}	
	
	public function isIntersectionBox(box:Box2):Bool {
		// using 6 splitting planes to rule out intersections.
		if (box.max.x < this.min.x || box.min.x > this.max.x ||
		    box.max.y < this.min.y || box.min.y > this.max.y) {

			return false;
		}

		return true;
	}	
	
	public function clampPoint(point:Vector2, optionalTarget:Vector2 = null):Vector2 {
		var result = optionalTarget != null ? optionalTarget : new Vector2();
		return result.copy(point).clamp(this.min, this.max);
	}	
	
	public function distanceToPoint(point:Vector2):Float {
		var v1 = new Vector2();
		var clampedPoint = v1.copy(point).clamp(this.min, this.max);
			return clampedPoint.sub(point).length();
	}
		
	public function intersect(box:Box2):Box2 {
		this.min.max(box.min);
		this.max.min(box.max);

		return this;
	}	
	
	public function union(box:Box2):Box2 {
		this.min.min(box.min);
		this.max.max(box.max);

		return this;
	}	
	
	public function translate(offset:Vector2):Box2 {
		this.min.add(offset);
		this.max.add(offset);

		return this;
	}	
	
	public function equals(box:Box2):Bool {
		return box.min.equals(this.min) && box.max.equals(this.max);
	}
		
	public function clone():Box2 {
		return new Box2().copy(this);
	}	
	
}

