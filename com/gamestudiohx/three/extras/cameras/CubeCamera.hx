package com.gamestudiohx.three.extras.cameras;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.cameras.PerspectiveCamera;
import com.gamestudiohx.three.math.Vector3

/**
 * Camera for rendering cube maps
 *	- renders scene into axis-aligned cube
 *
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class CubeCamera extends Object3D {

	public function new(near:Float, far:Float, cubeResolution:Float) {
		super();
		
		var fov:Float = 90, aspect:Float = 1;
		
		var cameraPX = new PerspectiveCamera( fov, aspect, near, far );
		cameraPX.up.set( 0, -1, 0 );
		cameraPX.lookAt( new Vector3( 1, 0, 0 ) );
		this.add( cameraPX );
		
		var cameraNX = new PerspectiveCamera( fov, aspect, near, far );
		cameraNX.up.set( 0, -1, 0 );
		cameraNX.lookAt( new Vector3( -1, 0, 0 ) );
		this.add( cameraNX );

		var cameraPY = new PerspectiveCamera( fov, aspect, near, far );
		cameraPY.up.set( 0, 0, 1 );
		cameraPY.lookAt( new Vector3( 0, 1, 0 ) );
		this.add( cameraPY );

		var cameraNY = new PerspectiveCamera( fov, aspect, near, far );
		cameraNY.up.set( 0, 0, -1 );
		cameraNY.lookAt( new Vector3( 0, -1, 0 ) );
		this.add( cameraNY );

		var cameraPZ = new PerspectiveCamera( fov, aspect, near, far );
		cameraPZ.up.set( 0, -1, 0 );
		cameraPZ.lookAt( new Vector3( 0, 0, 1 ) );
		this.add( cameraPZ );

		var cameraNZ = new PerspectiveCamera( fov, aspect, near, far );
		cameraNZ.up.set( 0, -1, 0 );
		cameraNZ.lookAt( new Vector3( 0, 0, -1 ) );
		this.add( cameraNZ );
		
		// TODO
		/*this.renderTarget = new THREE.WebGLRenderTargetCube( cubeResolution, cubeResolution, { format: THREE.RGBFormat, magFilter: THREE.LinearFilter, minFilter: THREE.LinearFilter } );

		this.updateCubeMap = function ( renderer, scene ) {

			var renderTarget = this.renderTarget;
			var generateMipmaps = renderTarget.generateMipmaps;

			renderTarget.generateMipmaps = false;

			renderTarget.activeCubeFace = 0;
			renderer.render( scene, cameraPX, renderTarget );

			renderTarget.activeCubeFace = 1;
			renderer.render( scene, cameraNX, renderTarget );

			renderTarget.activeCubeFace = 2;
			renderer.render( scene, cameraPY, renderTarget );

			renderTarget.activeCubeFace = 3;
			renderer.render( scene, cameraNY, renderTarget );

			renderTarget.activeCubeFace = 4;
			renderer.render( scene, cameraPZ, renderTarget );

			renderTarget.generateMipmaps = generateMipmaps;

			renderTarget.activeCubeFace = 5;
			renderer.render( scene, cameraNZ, renderTarget );

		};*/
	}
	
}