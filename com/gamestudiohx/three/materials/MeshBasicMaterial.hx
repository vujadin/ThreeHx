package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  color: <hex>,
 *  opacity: <float>,
 *  map: new THREE.Texture( <Image> ),
 *
 *  lightMap: new THREE.Texture( <Image> ),
 *
 *  specularMap: new THREE.Texture( <Image> ),
 *
 *  envMap: new THREE.TextureCube( [posx, negx, posy, negy, posz, negz] ),
 *  combine: THREE.Multiply,
 *  reflectivity: <float>,
 *  refractionRatio: <float>,
 *
 *  shading: THREE.SmoothShading,
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *  depthWrite: <bool>,
 *
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>,
 *
 *  vertexColors: THREE.NoColors / THREE.VertexColors / THREE.FaceColors,
 *
 *  skinning: <bool>,
 *  morphTargets: <bool>,
 *
 *  fog: <bool>
 * }
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class MeshBasicMaterial extends Material {
	
	public var color:Color;
	
	public var map:Texture;
	
	public var lightMap:Texture; 
	
	public var specularMap:Texture;
	
	public var envMap:Texture;
	public var combine:Int;
	public var reflectivity:Float = 1.0;
	public var refractionRatio:Float = 0.98;
	
	public var fog:Bool = true;
	
	//public var shading:Int;
	
	//public var wireframe:Bool;
	public var wireframeLinewidth:Float;
	public var wireframeLinecap:String;
	public var wireframeLinejoin:String;
	
	//public var vertexColors:Int;
	
	public var skinning:Bool = false;
	//public var morphTargets:Bool = false;

	
	public function new(parameters:Dynamic = null) {
		super();
		
		this.color = new Color(0xffffff); // emissive

		this.map = null;

		this.lightMap = null;

		this.specularMap = null;

		this.envMap = null;
		this.combine = THREE.MultiplyOperation;
		this.reflectivity = 1;
		this.refractionRatio = 0.98;

		this.fog = true;

		this.shading = THREE.SmoothShading;

		this.wireframe = false;
		this.wireframeLinewidth = 1;
		this.wireframeLinecap = 'round';
		this.wireframeLinejoin = 'round';

		this.vertexColors = THREE.NoColors;

		this.skinning = false;
		this.morphTargets = false;

		this.setValues(parameters);
	}	
	
	override public function clone(material:Material = null):Material {
		var material = new MeshBasicMaterial();

		material = cast super.clone(material);
		
		material.color.copy(this.color);

		material.map = this.map;

		material.lightMap = this.lightMap;

		material.specularMap = this.specularMap;

		material.envMap = this.envMap;
		material.combine = this.combine;
		material.reflectivity = this.reflectivity;
		material.refractionRatio = this.refractionRatio;

		material.fog = this.fog;

		material.shading = this.shading;

		material.wireframe = this.wireframe;
		material.wireframeLinewidth = this.wireframeLinewidth;
		material.wireframeLinecap = this.wireframeLinecap;
		material.wireframeLinejoin = this.wireframeLinejoin;

		material.vertexColors = this.vertexColors;

		material.skinning = this.skinning;
		material.morphTargets = this.morphTargets;

		return material;
	}
}