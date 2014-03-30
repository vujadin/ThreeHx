package com.gamestudiohx.three.extras.geometries;

/**
 * @author timothypratley / https://github.com/timothypratley
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class TetrahedronGeometry extends PolyhedronGeometry {

	public function new(radius:Float = 1, detail:Int = 0) {
		var vertices:Array<Array<Float>> = [[1, 1, 1], [-1, -1, 1], [-1, 1, -1], [1, -1, -1]];
		var faces = [[2, 1, 0], [0, 3, 2], [1, 3, 0], [2, 3, 1]];
		super(vertices, faces, radius, detail);
	}
	
}