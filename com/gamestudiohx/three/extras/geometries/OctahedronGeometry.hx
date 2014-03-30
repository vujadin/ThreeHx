package com.gamestudiohx.three.extras.geometries;

/**
 * @author timothypratley / https://github.com/timothypratley
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class OctahedronGeometry extends PolyhedronGeometry {

	public function new(radius:Float = 1, detail:Int = 0) {
		var vertices:Array<Array<Float>> = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]];
		var faces = [[0, 2, 4], [0, 4, 3], [0, 3, 5], [0, 5, 2], [1, 2, 5], [1, 5, 3], [1, 3, 4], [1, 4, 2]];
		super(vertices, faces, radius, detail);
	}
	
}