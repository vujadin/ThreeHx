package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  color: <hex>,
 *  ambient: <hex>,
 *  emissive: <hex>,
 *  opacity: <float>,
 *
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
 *  morphNormals: <bool>,
 *
 *	fog: <bool>
 * }
 */

/**
 * ...
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class MeshLambertMaterial extends Material {
	
	public var color:Color; // diffuse
	public var ambient:Color;
	public var emissive:Color;

	public var wrapAround:Bool;
	public var wrapRGB:Vector3;

	public var map:Dynamic;

	public var lightMap:Dynamic;

	public var specularMap:Dynamic;

	public var envMap:Dynamic;
	public var combine:Int;
	public var reflectivity:Int;
	public var refractionRatio:Float;

	public var fog:Bool;

	//public var shading:Int;

	//public var wireframe:Bool;
	public var wireframeLinewidth:Float;
	public var wireframeLinecap:String;
	public var wireframeLinejoin:String;

	//public var vertexColors:Int;

	public var skinning:Bool;
	//public var morphTargets:Bool;
	//public var morphNormals:Bool;

	public function new(parameters:Dynamic = null) {
		super();
		
		this.color = new Color(0xffffff); // diffuse
		this.ambient = new Color(0xffffff);
		this.emissive = new Color(0x000000);

		this.wrapAround = false;
		this.wrapRGB = new Vector3(1, 1, 1);

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
		this.morphNormals = false;

		this.setValues(parameters);
	}
	
	override public function clone(material:Material = null):Material {
		material = new MeshLambertMaterial();

		material = cast super.clone(material);

		cast(material, MeshLambertMaterial).color.copy(this.color);
		cast(material, MeshLambertMaterial).ambient.copy(this.ambient);
		cast(material, MeshLambertMaterial).emissive.copy(this.emissive);

		cast(material, MeshLambertMaterial).wrapAround = this.wrapAround;
		cast(material, MeshLambertMaterial).wrapRGB.copy(this.wrapRGB);

		cast(material, MeshLambertMaterial).map = this.map;

		cast(material, MeshLambertMaterial).lightMap = this.lightMap;

		cast(material, MeshLambertMaterial).specularMap = this.specularMap;

		cast(material, MeshLambertMaterial).envMap = this.envMap;
		cast(material, MeshLambertMaterial).combine = this.combine;
		cast(material, MeshLambertMaterial).reflectivity = this.reflectivity;
		cast(material, MeshLambertMaterial).refractionRatio = this.refractionRatio;

		cast(material, MeshLambertMaterial).fog = this.fog;

		cast(material, MeshLambertMaterial).shading = this.shading;

		cast(material, MeshLambertMaterial).wireframe = this.wireframe;
		cast(material, MeshLambertMaterial).wireframeLinewidth = this.wireframeLinewidth;
		cast(material, MeshLambertMaterial).wireframeLinecap = this.wireframeLinecap;
		cast(material, MeshLambertMaterial).wireframeLinejoin = this.wireframeLinejoin;

		cast(material, MeshLambertMaterial).vertexColors = this.vertexColors;

		cast(material, MeshLambertMaterial).skinning = this.skinning;
		cast(material, MeshLambertMaterial).morphTargets = this.morphTargets;
		cast(material, MeshLambertMaterial).morphNormals = this.morphNormals;

		return material;
	}
}