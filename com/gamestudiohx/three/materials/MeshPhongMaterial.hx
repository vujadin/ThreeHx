package com.gamestudiohx.three.materials;

import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * parameters = {
 *  color: <hex>,
 *  ambient: <hex>,
 *  emissive: <hex>,
 *  specular: <hex>,
 *  shininess: <float>,
 *  opacity: <float>,
 *
 *  map: new THREE.Texture( <Image> ),
 *
 *  lightMap: new THREE.Texture( <Image> ),
 *
 *  bumpMap: new THREE.Texture( <Image> ),
 *  bumpScale: <float>,
 *
 *  normalMap: new THREE.Texture( <Image> ),
 *  normalScale: <Vector2>,
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

class MeshPhongMaterial extends Material {

	public var color:Color; // diffuse
	public var ambient:Color;
	public var emissive:Color;
	public var specular:Color;
	public var shininess:Float;

	public var metal:Bool;
	public var perPixel:Bool;

	public var wrapAround:Bool;
	public var wrapRGB:Vector3;

	public var map:Texture;

	public var lightMap:Texture;

	public var bumpMap:Texture;
	public var bumpScale:Float;

	public var normalMap:Texture;
	public var normalScale:Vector2;

	public var specularMap:Texture;

	public var envMap:Dynamic;
	public var combine:Int;
	public var reflectivity:Float;
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
		this.specular = new Color(0x111111);
		this.shininess = 30;

		this.metal = false;
		this.perPixel = true;

		this.wrapAround = false;
		this.wrapRGB = new Vector3(1, 1, 1);

		this.map = null;

		this.lightMap = null;

		this.bumpMap = null;
		this.bumpScale = 1;

		this.normalMap = null;
		this.normalScale = new Vector2( 1, 1 );

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

		this.setValues( parameters );
	}
	
	override public function clone(material:Material = null):Material {
		material = new MeshPhongMaterial();

		material = super.clone(material);

		cast(material, MeshPhongMaterial).color.copy(this.color);
		cast(material, MeshPhongMaterial).ambient.copy(this.ambient);
		cast(material, MeshPhongMaterial).emissive.copy(this.emissive);
		cast(material, MeshPhongMaterial).specular.copy(this.specular);
		cast(material, MeshPhongMaterial).shininess = this.shininess;

		cast(material, MeshPhongMaterial).metal = this.metal;
		cast(material, MeshPhongMaterial).perPixel = this.perPixel;

		cast(material, MeshPhongMaterial).wrapAround = this.wrapAround;
		cast(material, MeshPhongMaterial).wrapRGB.copy(this.wrapRGB);

		cast(material, MeshPhongMaterial).map = this.map;

		cast(material, MeshPhongMaterial).lightMap = this.lightMap;

		cast(material, MeshPhongMaterial).bumpMap = this.bumpMap;
		cast(material, MeshPhongMaterial).bumpScale = this.bumpScale;

		cast(material, MeshPhongMaterial).normalMap = this.normalMap;
		cast(material, MeshPhongMaterial).normalScale.copy(this.normalScale);

		cast(material, MeshPhongMaterial).specularMap = this.specularMap;

		cast(material, MeshPhongMaterial).envMap = this.envMap;
		cast(material, MeshPhongMaterial).combine = this.combine;
		cast(material, MeshPhongMaterial).reflectivity = this.reflectivity;
		cast(material, MeshPhongMaterial).refractionRatio = this.refractionRatio;

		cast(material, MeshPhongMaterial).fog = this.fog;

		cast(material, MeshPhongMaterial).shading = this.shading;

		cast(material, MeshPhongMaterial).wireframe = this.wireframe;
		cast(material, MeshPhongMaterial).wireframeLinewidth = this.wireframeLinewidth;
		cast(material, MeshPhongMaterial).wireframeLinecap = this.wireframeLinecap;
		cast(material, MeshPhongMaterial).wireframeLinejoin = this.wireframeLinejoin;

		cast(material, MeshPhongMaterial).vertexColors = this.vertexColors;

		cast(material, MeshPhongMaterial).skinning = this.skinning;
		cast(material, MeshPhongMaterial).morphTargets = this.morphTargets;
		cast(material, MeshPhongMaterial).morphNormals = this.morphNormals;

		return material;
	}
	
}