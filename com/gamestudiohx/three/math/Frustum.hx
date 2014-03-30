package com.gamestudiohx.three.math;

import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.objects.Mesh;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author bhouston / http://exocortex.com
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class Frustum {
	
	public var planes:Array<Plane>;
	
	public function new(p0:Plane = null, p1:Plane = null, p2:Plane = null, p3:Plane = null, p4:Plane = null, p5:Plane = null) {
		planes = new Array<Plane>();
		planes.push((p0 != null ? p0 : new Plane()));
		planes.push((p1 != null ? p1 : new Plane()));
		planes.push((p2 != null ? p2 : new Plane()));
		planes.push((p3 != null ? p3 : new Plane()));
		planes.push((p4 != null ? p4 : new Plane()));
		planes.push((p5 != null ? p5 : new Plane()));
	}	
	
	public function set(p0:Plane, p1:Plane, p2:Plane, p3:Plane, p4:Plane, p5:Plane):Frustum {
		planes[0].copy(p0);
		planes[1].copy(p1);
		planes[2].copy(p2);
		planes[3].copy(p3);
		planes[4].copy(p4);
		planes[5].copy(p5);
		return this;
	}	
	
	public function copy (frustum:Frustum):Frustum {
		for(i in 0...6) {
			planes[i].copy(frustum.planes[i]);
		}
		return this;
	}	
	
	public function setFromMatrix(m:Matrix4):Frustum {
		var planes = this.planes;
		var me = m.elements;
		var me0 = me[0], me1 = me[1], me2 = me[2], me3 = me[3];
		var me4 = me[4], me5 = me[5], me6 = me[6], me7 = me[7];
		var me8 = me[8], me9 = me[9], me10 = me[10], me11 = me[11];
		var me12 = me[12], me13 = me[13], me14 = me[14], me15 = me[15];

		planes[0].setComponents(me3 - me0, me7 - me4, me11 - me8, me15 - me12).normalize();
		planes[1].setComponents(me3 + me0, me7 + me4, me11 + me8, me15 + me12).normalize();
		planes[2].setComponents(me3 + me1, me7 + me5, me11 + me9, me15 + me13).normalize();
		planes[3].setComponents(me3 - me1, me7 - me5, me11 - me9, me15 - me13).normalize();
		planes[4].setComponents(me3 - me2, me7 - me6, me11 - me10, me15 - me14).normalize();
		planes[5].setComponents(me3 + me2, me7 + me6, me11 + me10, me15 + me14).normalize();

		return this;
	}	
	
	public function intersectsObject(object:Object3D):Bool {
		var sphere = new Sphere();

		var geometry:Geometry = object.geometry;
		if (geometry.boundingSphere == null) geometry.computeBoundingSphere();

		sphere.copy(geometry.boundingSphere);
		sphere.applyMatrix4(object.matrixWorld);

		return this.intersectsSphere(sphere);
	}	
	
	public function intersectsSphere(sphere:Sphere):Bool {
		var planes = this.planes;
		var center = sphere.center;
		var negRadius = -sphere.radius;

		for (i in 0...6) {
			var distance = planes[i].distanceToPoint(center);
			if (distance < negRadius) {
				return false;
			}
		}

		return true;
	}	
	
	public function intersectsBox(box:Box3):Bool {
		var p1 = new Vector3();
		var	p2 = new Vector3();
		
		for (i in 0...6) {		
			var plane = planes[i];
			
			p1.x = plane.normal.x > 0 ? box.min.x : box.max.x;
			p2.x = plane.normal.x > 0 ? box.max.x : box.min.x;
			p1.y = plane.normal.y > 0 ? box.min.y : box.max.y;
			p2.y = plane.normal.y > 0 ? box.max.y : box.min.y;
			p1.z = plane.normal.z > 0 ? box.min.z : box.max.z;
			p2.z = plane.normal.z > 0 ? box.max.z : box.min.z;

			var d1 = plane.distanceToPoint(p1);
			var d2 = plane.distanceToPoint(p2);
			
			// if both outside plane, no intersection
			if (d1 < 0 && d2 < 0) {				
				return false;	
			}
		}

		return true;		
	}
	
	public function containsPoint(point:Vector3):Bool {
		for (i in 0...6) {
			if (planes[i].distanceToPoint(point) < 0) {
				return false;
			}
		}

		return true;
	}	
	
	public function clone():Frustum {
		return new Frustum().copy(this);
	}	
	
}

