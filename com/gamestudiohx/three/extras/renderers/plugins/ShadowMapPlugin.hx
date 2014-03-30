package com.gamestudiohx.three.extras.renderers.plugins;

import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.lights.Light;
import com.gamestudiohx.three.lights.DirectionalLight;
import com.gamestudiohx.three.cameras.Camera;
import com.gamestudiohx.three.materials.ShaderMaterial;
import com.gamestudiohx.three.math.Frustum;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.renderers.WebGLRenderer;
import com.gamestudiohx.three.renderers.shaders.ShaderLib;
import com.gamestudiohx.three.renderers.shaders.UniformsUtils;
import com.gamestudiohx.three.scenes.Fog;
import com.gamestudiohx.three.scenes.Scene;
import com.gamestudiohx.three.THREE;

import openfl.gl.GL;

/**
 * @author alteredq / http://alteredqualia.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class ShadowMapPlugin {
	
	public var _renderer:WebGLRenderer;
	public var _depthMaterial:ShaderMaterial;
	public var _depthMaterialMorph:ShaderMaterial;
	public var _depthMaterialSkin:ShaderMaterial;
	public var _depthMaterialMorphSkin:ShaderMaterial;

	public var _frustum:Frustum;
	public var _projScreenMatrix:Matrix4;

	public var _min:Vector3;
	public var _max:Vector3;

	public var _matrixPosition:Vector3;

	public function new(renderer:WebGLRenderer) {
		init(renderer);
	}
	
	public function init(renderer:WebGLRenderer) {
		_renderer = renderer;

		var depthShader = ShaderLib.depthRGBA;
		var depthUniforms = UniformsUtils.clone(depthShader.uniforms);

		_depthMaterial = new ShaderMaterial( { fragmentShader: depthShader.fragmentShader, vertexShader: depthShader.vertexShader, uniforms: depthUniforms } );
		_depthMaterialMorph = new ShaderMaterial( { fragmentShader: depthShader.fragmentShader, vertexShader: depthShader.vertexShader, uniforms: depthUniforms, morphTargets: true } );
		_depthMaterialSkin = new ShaderMaterial( { fragmentShader: depthShader.fragmentShader, vertexShader: depthShader.vertexShader, uniforms: depthUniforms, skinning: true } );
		_depthMaterialMorphSkin = new ShaderMaterial( { fragmentShader: depthShader.fragmentShader, vertexShader: depthShader.vertexShader, uniforms: depthUniforms, morphTargets: true, skinning: true } );

		_depthMaterial._shadowPass = true;
		_depthMaterialMorph._shadowPass = true;
		_depthMaterialSkin._shadowPass = true;
		_depthMaterialMorphSkin._shadowPass = true;
		
		_frustum = new Frustum();
		_projScreenMatrix = new Matrix4();

		_min = new Vector3();
		_max = new Vector3();

		_matrixPosition = new Vector3();
	}
	
	public function render(scene:Scene, camera:Camera) {
		if (!(_renderer.shadowMapEnabled && _renderer.shadowMapAutoUpdate)) return;
		this.update(scene, camera);
	}
	
	public function update(scene:Scene, camera:Camera) {
		var i, il, j, jl, n;

		var shadowMap, shadowMatrix, shadowCamera;
		var program, buffer, material;
		var webglObject:Object3D , object, light:Light;
		var renderList;

		var lights = [];
		var k = 0;

		var fog:Fog = null;

		// set GL state for depth map

		GL.clearColor(1, 1, 1, 1);
		GL.disable(GL.BLEND);

		GL.enable(GL.CULL_FACE);
		GL.frontFace(GL.CCW);

		if (_renderer.shadowMapCullFace == THREE.CullFaceFront) {
			GL.cullFace(GL.FRONT);
		} else {
			GL.cullFace(GL.BACK);
		}

		_renderer.setDepthTest(1);	// originaly true is passed

		// preprocess lights
		// 	- skip lights that are not casting shadows
		//	- create virtual lights for cascaded shadow maps

		/*for (i in 0...scene.__lights.length) {
			light = scene.__lights[i];

			if (!light.castShadow) continue;

			if (Std.is(light, DirectionalLight) && cast(light, DirectionalLight).shadowCascade) {
				for (n in 0...cast(light, DirectionalLight).shadowCascadeCount) {

					var virtualLight;

					if ( ! light.shadowCascadeArray[ n ] ) {

						virtualLight = createVirtualLight( light, n );
						virtualLight.originalCamera = camera;

						var gyro = new THREE.Gyroscope();
						gyro.position = light.shadowCascadeOffset;

						gyro.add( virtualLight );
						gyro.add( virtualLight.target );

						camera.add( gyro );

						light.shadowCascadeArray[ n ] = virtualLight;

						console.log( "Created virtualLight", virtualLight );

					} else {

						virtualLight = light.shadowCascadeArray[ n ];

					}

					updateVirtualLight( light, n );

					lights[ k ] = virtualLight;
					k ++;

				}

			} else {

				lights[ k ] = light;
				k ++;

			}

		}

		// render depth map

		for ( i = 0, il = lights.length; i < il; i ++ ) {

			light = lights[ i ];

			if ( ! light.shadowMap ) {

				var shadowFilter = THREE.LinearFilter;

				if ( _renderer.shadowMapType === THREE.PCFSoftShadowMap ) {

					shadowFilter = THREE.NearestFilter;

				}

				var pars = { minFilter: shadowFilter, magFilter: shadowFilter, format: THREE.RGBAFormat };

				light.shadowMap = new THREE.WebGLRenderTarget( light.shadowMapWidth, light.shadowMapHeight, pars );
				light.shadowMapSize = new THREE.Vector2( light.shadowMapWidth, light.shadowMapHeight );

				light.shadowMatrix = new THREE.Matrix4();

			}

			if ( ! light.shadowCamera ) {

				if ( light instanceof THREE.SpotLight ) {

					light.shadowCamera = new THREE.PerspectiveCamera( light.shadowCameraFov, light.shadowMapWidth / light.shadowMapHeight, light.shadowCameraNear, light.shadowCameraFar );

				} else if ( light instanceof THREE.DirectionalLight ) {

					light.shadowCamera = new THREE.OrthographicCamera( light.shadowCameraLeft, light.shadowCameraRight, light.shadowCameraTop, light.shadowCameraBottom, light.shadowCameraNear, light.shadowCameraFar );

				} else {

					console.error( "Unsupported light type for shadow" );
					continue;

				}

				scene.add( light.shadowCamera );

				if ( scene.autoUpdate === true ) scene.updateMatrixWorld();

			}

			if ( light.shadowCameraVisible && ! light.cameraHelper ) {

				light.cameraHelper = new THREE.CameraHelper( light.shadowCamera );
				light.shadowCamera.add( light.cameraHelper );

			}

			if ( light.isVirtual && virtualLight.originalCamera == camera ) {

				updateShadowCamera( camera, light );

			}

			shadowMap = light.shadowMap;
			shadowMatrix = light.shadowMatrix;
			shadowCamera = light.shadowCamera;

			shadowCamera.position.setFromMatrixPosition( light.matrixWorld );
			_matrixPosition.setFromMatrixPosition( light.target.matrixWorld );
			shadowCamera.lookAt( _matrixPosition );
			shadowCamera.updateMatrixWorld();

			shadowCamera.matrixWorldInverse.getInverse( shadowCamera.matrixWorld );

			if ( light.cameraHelper ) light.cameraHelper.visible = light.shadowCameraVisible;
			if ( light.shadowCameraVisible ) light.cameraHelper.update();

			// compute shadow matrix

			shadowMatrix.set( 0.5, 0.0, 0.0, 0.5,
							  0.0, 0.5, 0.0, 0.5,
							  0.0, 0.0, 0.5, 0.5,
							  0.0, 0.0, 0.0, 1.0 );

			shadowMatrix.multiply( shadowCamera.projectionMatrix );
			shadowMatrix.multiply( shadowCamera.matrixWorldInverse );

			// update camera matrices and frustum

			_projScreenMatrix.multiplyMatrices( shadowCamera.projectionMatrix, shadowCamera.matrixWorldInverse );
			_frustum.setFromMatrix( _projScreenMatrix );

			// render shadow map

			_renderer.setRenderTarget( shadowMap );
			_renderer.clear();

			// set object matrices & frustum culling

			renderList = scene.__webglObjects;

			for ( j = 0, jl = renderList.length; j < jl; j ++ ) {

				webglObject = renderList[ j ];
				object = webglObject.object;

				webglObject.render = false;

				if ( object.visible && object.castShadow ) {

					if ( ! ( object instanceof THREE.Mesh || object instanceof THREE.ParticleSystem ) || ! ( object.frustumCulled ) || _frustum.intersectsObject( object ) ) {

						object._modelViewMatrix.multiplyMatrices( shadowCamera.matrixWorldInverse, object.matrixWorld );

						webglObject.render = true;

					}

				}

			}

			// render regular objects

			var objectMaterial, useMorphing, useSkinning;

			for ( j = 0, jl = renderList.length; j < jl; j ++ ) {

				webglObject = renderList[ j ];

				if ( webglObject.render ) {

					object = webglObject.object;
					buffer = webglObject.buffer;

					// culling is overriden globally for all objects
					// while rendering depth map

					// need to deal with MeshFaceMaterial somehow
					// in that case just use the first of material.materials for now
					// (proper solution would require to break objects by materials
					//  similarly to regular rendering and then set corresponding
					//  depth materials per each chunk instead of just once per object)

					objectMaterial = getObjectMaterial( object );

					useMorphing = object.geometry.morphTargets.length > 0 && objectMaterial.morphTargets;
					useSkinning = object instanceof THREE.SkinnedMesh && objectMaterial.skinning;

					if ( object.customDepthMaterial ) {

						material = object.customDepthMaterial;

					} else if ( useSkinning ) {

						material = useMorphing ? _depthMaterialMorphSkin : _depthMaterialSkin;

					} else if ( useMorphing ) {

						material = _depthMaterialMorph;

					} else {

						material = _depthMaterial;

					}

					if ( buffer instanceof THREE.BufferGeometry ) {

						_renderer.renderBufferDirect( shadowCamera, scene.__lights, fog, material, buffer, object );

					} else {

						_renderer.renderBuffer( shadowCamera, scene.__lights, fog, material, buffer, object );

					}

				}

			}

			// set matrices and render immediate objects

			renderList = scene.__webglObjectsImmediate;

			for ( j = 0, jl = renderList.length; j < jl; j ++ ) {

				webglObject = renderList[ j ];
				object = webglObject.object;

				if ( object.visible && object.castShadow ) {

					object._modelViewMatrix.multiplyMatrices( shadowCamera.matrixWorldInverse, object.matrixWorld );

					_renderer.renderImmediateObject( shadowCamera, scene.__lights, fog, _depthMaterial, object );

				}

			}

		}

		// restore GL state

		var clearColor = _renderer.getClearColor(),
		clearAlpha = _renderer.getClearAlpha();

		_gl.clearColor( clearColor.r, clearColor.g, clearColor.b, clearAlpha );
		_gl.enable( _gl.BLEND );

		if ( _renderer.shadowMapCullFace === THREE.CullFaceFront ) {

			_gl.cullFace( _gl.BACK );

		}*/
	}
	
}