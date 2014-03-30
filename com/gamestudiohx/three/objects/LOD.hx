package com.gamestudiohx.three.objects;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.cameras.Camera;
import com.gamestudiohx.three.math.Vector3;

/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef LODObject = {
	distance: Float,
	object: Object3D
}
 
class LOD extends Object3D {
	
	public var objects:Array<LODObject>;

	public function new() {
		super();
		
		objects = [];
	}
	
	public function addLevel(object:Object3D, distance:Float = 0) {
		distance = Math.abs(distance);

		var i:Int = 0;
		for (l in 0...this.objects.length) {
			if (distance < this.objects[l].distance) {
				break;
			}
			i++;
		}

		this.objects.insert(i, { distance: distance, object: object });
		this.add(object);
	}
	
	public function getObjectForDistance(distance:Float):Object3D {
		var i:Int = 1;
		for (l in 1...this.objects.length) {
			if (distance < this.objects[i].distance) {
				break;
			}
			i++;
		}

		return this.objects[i - 1].object;
	}
	
	public function update(camera:Camera) {
		var v1 = new Vector3();
		var v2 = new Vector3();	

		if (this.objects.length > 1) {
			v1.setFromMatrixPosition(camera.matrixWorld);
			v2.setFromMatrixPosition(this.matrixWorld);

			var distance = v1.distanceTo(v2);

			this.objects[0].object.visible = true;

			var i:Int = 1;
			var l:Int = this.objects.length;
			for (m in 1...this.objects.length) {
				if (distance >= this.objects[m].distance ) {
					this.objects[m-1].object.visible = false;
					this.objects[m].object.visible = true;
				} else {
					break;
				}
				i++;
			}

			while(i < l) {
				this.objects[i++].object.visible = false;
			}
		}	
	}
	
	/*override public function clone(object:Object3D):Object3D {
		// TODO_Threejs
		return null;
	}*/
}