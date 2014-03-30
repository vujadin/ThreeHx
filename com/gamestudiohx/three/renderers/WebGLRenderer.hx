package com.gamestudiohx.three.renderers;

import com.gamestudiohx.three.renderers.shaders.UniformsLib.ULTypeValue;
import com.gamestudiohx.three.renderers.shaders.ShaderLib;
import com.gamestudiohx.three.extras.objects.ImmediateRenderObject;
import com.gamestudiohx.three.extras.objects.LensFlare;
import com.gamestudiohx.three.math.Vector4;
import com.gamestudiohx.three.renderers.shaders.UniformsUtils;
import com.gamestudiohx.three.renderers.WebGLRenderer.Lights;
import com.gamestudiohx.three.renderers.WebGLRenderer.ThreeGLMaterial;
import com.gamestudiohx.three.renderers.WebGLRenderer.ThreeGLProgram;
import com.gamestudiohx.three.scenes.Fog;
import com.gamestudiohx.three.scenes.FogExp2;
import com.gamestudiohx.three.lights.Light;
import com.gamestudiohx.three.lights.AmbientLight;
import com.gamestudiohx.three.lights.SpotLight;
import com.gamestudiohx.three.lights.DirectionalLight;
import com.gamestudiohx.three.lights.HemisphereLight;
import com.gamestudiohx.three.lights.PointLight;
import com.gamestudiohx.three.lights.AreaLight;
import com.gamestudiohx.three.extras.renderers.plugins.ShadowMapPlugin;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.ParticleSystemMaterial;
import com.gamestudiohx.three.materials.LineBasicMaterial;
import com.gamestudiohx.three.materials.LineDashedMaterial;
import com.gamestudiohx.three.materials.MeshNormalMaterial;
import com.gamestudiohx.three.materials.MeshFaceMaterial;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.materials.MeshDepthMaterial;
import com.gamestudiohx.three.materials.MeshLambertMaterial;
import com.gamestudiohx.three.materials.MeshPhongMaterial;
import com.gamestudiohx.three.materials.ShaderMaterial;
import com.gamestudiohx.three.cameras.Camera;
import com.gamestudiohx.three.core.BufferGeometry;
import com.gamestudiohx.three.core.Geometry;
import com.gamestudiohx.three.core.Object3D;
import com.gamestudiohx.three.core.Face3;
import com.gamestudiohx.three.objects.Mesh;
import com.gamestudiohx.three.objects.SkinnedMesh;
import com.gamestudiohx.three.objects.Bone;
import com.gamestudiohx.three.objects.Sprite;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Frustum;
import com.gamestudiohx.three.math.Matrix4;
import com.gamestudiohx.three.math.Matrix3;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.scenes.Scene;
import com.gamestudiohx.three.objects.ParticleSystem;
import com.gamestudiohx.three.objects.Line;
import com.gamestudiohx.three.renderers.WebGLRenderTarget;
import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.textures.CompressedTexture;
import com.gamestudiohx.three.textures.DataTexture;
import com.gamestudiohx.three.THREE;
import haxe.ds.StringMap;
import openfl.display.OpenGLView;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLObject;
import openfl.gl.GLProgram;
import openfl.gl.GLRenderbuffer;
import openfl.gl.GLShader;
import openfl.gl.GLTexture;
import openfl.utils.ArrayBuffer;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;
import openfl.gl.GLUniformLocation;

import flash.events.Event;

/**
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author szimek / https://github.com/szimek/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

typedef Info_memory = {
	programs: Int,
	geometries: Int,
	textures: Int
}

typedef Info_render = {
	calls: Int,
	vertices: Int,
	faces: Int,
	points: Int
}

typedef Info = {
	memory: Info_memory,
	render: Info_render
}

typedef Lights_directional = {
	length: Int,
	colors: Array<Float>,
	positions: Array<Float>
}

typedef Lights_point = {
	length: Int,
	colors: Array<Float>,
	positions: Array<Float>,
	distances: Array<Float>
}

typedef Lights_spot = {
	length: Int,
	colors: Array<Float>,
	positions: Array<Float>,
	distances: Array<Float>,
	directions: Array<Float>,
	anglesCos: Array<Float>,
	exponents: Array<Float>
}

typedef Lights_hemi = {
	length: Int,
	skyColors: Array<Float>,
	groundColors: Array<Float>,
	positions: Array<Float>
}

typedef Lights = {
	ambient: Array<Float>,
	directional: Lights_directional,
	point: Lights_point,
	spot: Lights_spot,
	hemi: Lights_hemi
}

typedef ThreeGLProgram = {
	id: Null<Int>,
	program: Null<Dynamic>,//GLProgram,
	code: Null<String>,
	usedTimes: Null<Int>,
	attributes: Null<Dynamic>,
	uniforms: Null<Map<String, GLUniformLocation>>
}

typedef ThreeGLAttribute = {
	type: String,
	value: Dynamic,
	array: Float32Array,
	buffer: ThreeGLBuffer,
	size: Int,
	boundTo: Null<String>,
	needsUpdate: Bool,
	__webglInitialized:Bool,
	createUniqueBuffers:Bool,
	__original:ThreeGLAttribute
}

typedef ThreeGLMaterial = {
	
}

typedef ThreeGLBuffer = {
	//gl: GL,
    buffer: Null<GLBuffer>,
    belongsToAttribute: Null<String>
}

typedef ThreeGLObject = {
	id: Null<Int>,
	__webglInit: Null<Bool>,
	__webglActive: Null<Bool>,
	_modelViewMatrix: Null<Matrix4>,
	_normalMatrix: Null<Matrix4>,
	_normalMatrixArray: Null<Array<Matrix4>>,
	_modelViewMatrixArray: Null<Array<Matrix4>>,
	modelMatrixArray: Null<Array<Matrix4>>,
	buffer: Null<Geometry>, //Null<BufferGeometryAttribute>,
	object: Null<Object3D>,
	opaque: Null<ThreeGLMaterial>,
	transparent: Null<ThreeGLMaterial>,
	__webglMorphTargetInfluences: Null<Dynamic>,
	render: Null<Bool>,
	z: Null<Float>
}

typedef Attributes = {
	_1: Null<Bool>,
	_2: Null<Bool>,
	_3: Null<Bool>
}

class WebGLRenderer {
	
	public var _canvas:OpenGLView;

	var _precision:String;

	var _alpha:Bool;
	var _premultipliedAlpha:Bool;
	var _antialias:Bool;
	var _stencil:Bool;
	var _preserveDrawingBuffer:Bool;

	var _clearColor:Color;
	var _clearAlpha:Float;

	// public properties
	public var devicePixelRatio:Float;

	// clearing
	public var autoClear:Bool;
	public var autoClearColor:Bool;
	public var autoClearDepth:Bool;
	public var autoClearStencil:Bool;

	// scene graph
	public var sortObjects:Bool;
	public var autoUpdateObjects:Bool;

	// physically based shading
	public var gammaInput:Bool;
	public var gammaOutput:Bool;
	public var physicallyBasedShading:Bool;

	// shadow map
	public var shadowMapEnabled:Bool;
	public var shadowMapAutoUpdate:Bool;
	public var shadowMapType:Int;
	public var shadowMapCullFace:Int;
	public var shadowMapDebug:Bool;
	public var shadowMapCascade:Bool;
	
	public var shadowMapPlugin:ShadowMapPlugin;

	// morphs
	public var maxMorphTargets:Int;
	public var maxMorphNormals:Int;

	// flags
	public var autoScaleCubemaps:Bool;

	// custom render plugins
	public var renderPluginsPre:Array<Dynamic>;
	public var renderPluginsPost:Array<Dynamic>;

	// info
	public var info:Info;

	// internal properties
	var _programs:Array<ThreeGLProgram>;	
	var _programs_counter:Int;


	// internal state cache
	var _currentProgram:GLProgram;
	var _currentFramebuffer:GLFramebuffer;
	var _currentMaterialId:Int;
	var _currentGeometryGroupHash:Dynamic;
	var _currentCamera:Camera;
	var _geometryGroupCounter:Int;

	var _usedTextureUnits:Int;

	// GL state cache
	var _oldDoubleSided:Int;
	var _oldFlipSided:Int;

	var _oldBlending:Int;

	var _oldBlendEquation:Int;
	var _oldBlendSrc:Int;
	var _oldBlendDst:Int;

	var _oldDepthTest:Int;
	var _oldDepthWrite:Int;

	var _oldPolygonOffset:Dynamic;
	var _oldPolygonOffsetFactor:Dynamic;
	var _oldPolygonOffsetUnits:Dynamic;

	var _oldLineWidth:Float;

	var _viewportX:Int;
	var _viewportY:Int;
	var _viewportWidth:Int;
	var _viewportHeight:Int;
	var _currentWidth:Int;
	var _currentHeight:Int;

	var _enabledAttributes:Attributes;

	// frustum
	var _frustum:Frustum;

	 // camera matrices cache
	var _projScreenMatrix:Matrix4;
	var _projScreenMatrixPS:Matrix4;

	var _vector3:Vector3;

	// light arrays cache
	var _direction:Vector3;

	var _lightsNeedUpdate:Bool;

	var _lights:Lights;

	// initialize
	var _gl:Dynamic;

	var _glExtensionTextureFloat:Dynamic;
	var _glExtensionTextureFloatLinear:Dynamic;
	var _glExtensionStandardDerivatives:Dynamic;
	var _glExtensionTextureFilterAnisotropic:Dynamic;
	var _glExtensionCompressedTextureS3TC:Dynamic;

	// GPU capabilities
	var _maxTextures:Dynamic;
	var _maxVertexTextures:Dynamic;
	var _maxTextureSize:Dynamic;
	var _maxCubemapSize:Dynamic;

	var _maxAnisotropy:Dynamic;

	var _supportsVertexTextures:Bool;
	var _supportsBoneTextures:Bool;

	var _compressedTextureFormats:Dynamic;

	//

	var _vertexShaderPrecisionHighpFloat:ShaderPrecisionFormat;
	var _vertexShaderPrecisionMediumpFloat:ShaderPrecisionFormat;
	var _vertexShaderPrecisionLowpFloat:ShaderPrecisionFormat;

	var _fragmentShaderPrecisionHighpFloat:ShaderPrecisionFormat;
	var _fragmentShaderPrecisionMediumpFloat:ShaderPrecisionFormat;
	var _fragmentShaderPrecisionLowpFloat:ShaderPrecisionFormat;

	var _vertexShaderPrecisionHighpInt:ShaderPrecisionFormat;
	var _vertexShaderPrecisionMediumpInt:ShaderPrecisionFormat;
	var _vertexShaderPrecisionLowpInt:ShaderPrecisionFormat;

	var _fragmentShaderPrecisionHighpInt:ShaderPrecisionFormat;
	var _fragmentShaderPrecisionMediumpInt:ShaderPrecisionFormat;
	var _fragmentShaderPrecisionLowpInt:ShaderPrecisionFormat;

	// clamp precision to maximum available
	var highpAvailable:Bool;
	var mediumpAvailable:Bool;

	public function new(parameters:Dynamic) {
		
		_canvas = new OpenGLView();		
		
		_precision = parameters.precision != null ? Std.string(parameters.precision) : "highp";

		_alpha = parameters.alpha != null ? parameters.alpha : false;
		_premultipliedAlpha = parameters.premultipliedAlpha != null ? parameters.premultipliedAlpha : true;
		_antialias = parameters.antialias != null ? parameters.antialias : false;
		_stencil = parameters.stencil != null ? parameters.stencil : true;
		_preserveDrawingBuffer = parameters.preserveDrawingBuffer != null ? parameters.preserveDrawingBuffer : false;

		_clearColor = new Color(0xAAAAAA);
		_clearAlpha = 0;

		this.devicePixelRatio = parameters.devicePixelRatio != null
					? parameters.devicePixelRatio
					: this.devicePixelRatio != 0
						? this.devicePixelRatio
						: 1;

		// clearing
		this.autoClear = true;
		this.autoClearColor = true;
		this.autoClearDepth = true;
		this.autoClearStencil = true;

		// scene graph
		this.sortObjects = true;
		this.autoUpdateObjects = true;

		// physically based shading
		this.gammaInput = false;
		this.gammaOutput = false;
		this.physicallyBasedShading = false;

		// shadow map
		this.shadowMapEnabled = false;
		this.shadowMapAutoUpdate = true;
		this.shadowMapType = THREE.PCFShadowMap;
		this.shadowMapCullFace = THREE.CullFaceFront;
		this.shadowMapDebug = false;
		this.shadowMapCascade = false;

		// morphs
		this.maxMorphTargets = 8;
		this.maxMorphNormals = 4;

		// flags
		this.autoScaleCubemaps = true;

		// custom render plugins
		this.renderPluginsPre = [];
		this.renderPluginsPost = [];

		// info
		this.info = {
			memory: {
				programs: 0,
				geometries: 0,
				textures: 0
			},
			render: {
				calls: 0,
				vertices: 0,
				faces: 0,
				points: 0
			}
		};

		// internal properties
		_programs = [];
		_programs_counter = 0;

		// internal state cache
		_currentProgram = null;
		_currentFramebuffer = null;
		_currentMaterialId = -1;
		_currentGeometryGroupHash = null;
		_currentCamera = null;
		_geometryGroupCounter = 0;

		_usedTextureUnits = 0;

		// GL state cache
		_oldDoubleSided = -1;
		_oldFlipSided = -1;

		_oldBlending = -1;

		_oldBlendEquation = -1;
		_oldBlendSrc = -1;
		_oldBlendDst = -1;

		_oldDepthTest = -1;
		_oldDepthWrite = -1;

		_oldPolygonOffset = null;
		_oldPolygonOffsetFactor = null;
		_oldPolygonOffsetUnits = null;

		_oldLineWidth = 1;

		_viewportX = 0;
		_viewportY = 0;
		_viewportWidth = Std.int(_canvas.width);
		_viewportHeight = Std.int(_canvas.height);
		_currentWidth = 0;
		_currentHeight = 0;

		_enabledAttributes = { _1: null, _2: null, _3: null };

		// frustum
		_frustum = new Frustum();

		 // camera matrices cache
		_projScreenMatrix = new Matrix4();
		_projScreenMatrixPS = new Matrix4();

		_vector3 = new Vector3();

		// light arrays cache
		_direction = new Vector3();

		_lightsNeedUpdate = true;

		_lights = {
			ambient: [0, 0, 0],
			directional: { length: 0, colors: [], positions: [] },
			point: { length: 0, colors: [], positions: [], distances: [] },
			spot: { length: 0, colors: [], positions: [], distances: [], directions: [], anglesCos: [], exponents: [] },
			hemi: { length: 0, skyColors: [], groundColors: [], positions: [] }
		};

		// initialize
		initGL();
		setDefaultGLState();

		// GPU capabilities
		_maxTextures = GL.getParameter(GL.MAX_TEXTURE_IMAGE_UNITS);
		_maxVertexTextures = GL.getParameter(GL.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
		_maxTextureSize = GL.getParameter(GL.MAX_TEXTURE_SIZE);
		_maxCubemapSize = GL.getParameter(GL.MAX_CUBE_MAP_TEXTURE_SIZE);
		
		trace(_maxTextures);
		trace(_maxVertexTextures);
		trace(_maxTextureSize);
		trace(_maxCubemapSize);

		_maxAnisotropy = _glExtensionTextureFilterAnisotropic != null ? GL.getParameter(_glExtensionTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT) : 0;
		
		trace(_maxAnisotropy);

		_supportsVertexTextures = _maxVertexTextures > 0;
		_supportsBoneTextures = _supportsVertexTextures && _glExtensionTextureFloat;

		_compressedTextureFormats = _glExtensionCompressedTextureS3TC != null ? GL.getParameter(GL.COMPRESSED_TEXTURE_FORMATS) : [];
		trace(_compressedTextureFormats);

		//
		/*try {
		_vertexShaderPrecisionHighpFloat = GL.getShaderPrecisionFormat(GL.VERTEX_SHADER, GL.HIGH_FLOAT);
		_vertexShaderPrecisionMediumpFloat = GL.getShaderPrecisionFormat(GL.VERTEX_SHADER, GL.MEDIUM_FLOAT);
		_vertexShaderPrecisionLowpFloat = GL.getShaderPrecisionFormat(GL.VERTEX_SHADER, GL.LOW_FLOAT);
		
		trace(_vertexShaderPrecisionHighpFloat);
		trace(_vertexShaderPrecisionMediumpFloat);
		trace(_vertexShaderPrecisionLowpFloat);

		_fragmentShaderPrecisionHighpFloat = GL.getShaderPrecisionFormat(GL.FRAGMENT_SHADER, GL.HIGH_FLOAT);
		_fragmentShaderPrecisionMediumpFloat = GL.getShaderPrecisionFormat(GL.FRAGMENT_SHADER, GL.MEDIUM_FLOAT);
		_fragmentShaderPrecisionLowpFloat = GL.getShaderPrecisionFormat(GL.FRAGMENT_SHADER, GL.LOW_FLOAT);

		_vertexShaderPrecisionHighpInt = GL.getShaderPrecisionFormat(GL.VERTEX_SHADER, GL.HIGH_INT);
		_vertexShaderPrecisionMediumpInt = GL.getShaderPrecisionFormat(GL.VERTEX_SHADER, GL.MEDIUM_INT);
		_vertexShaderPrecisionLowpInt = GL.getShaderPrecisionFormat(GL.VERTEX_SHADER, GL.LOW_INT);

		_fragmentShaderPrecisionHighpInt = GL.getShaderPrecisionFormat(GL.FRAGMENT_SHADER, GL.HIGH_INT);
		_fragmentShaderPrecisionMediumpInt = GL.getShaderPrecisionFormat(GL.FRAGMENT_SHADER, GL.MEDIUM_INT);
		trace(_fragmentShaderPrecisionHighpInt);
		trace(_fragmentShaderPrecisionMediumpInt);
		
		_fragmentShaderPrecisionLowpInt = GL.getShaderPrecisionFormat(GL.FRAGMENT_SHADER, GL.LOW_INT);
		} catch (err:Dynamic) {
			trace(err);
			
			trace(_fragmentShaderPrecisionLowpInt);
		}

		// clamp precision to maximum available
		highpAvailable = _vertexShaderPrecisionHighpFloat.precision > 0 && _fragmentShaderPrecisionHighpFloat.precision > 0;
		mediumpAvailable = _vertexShaderPrecisionMediumpFloat.precision > 0 && _fragmentShaderPrecisionMediumpFloat.precision > 0;

		if (_precision == "highp" && !highpAvailable) {
			if (mediumpAvailable) {
				_precision = "mediump";
				trace("WebGLRenderer: highp not supported, using mediump");
			} else {
				_precision = "lowp";
				trace("WebGLRenderer: highp and mediump not supported, using lowp");
			}
		}

		if (_precision == "mediump" && !mediumpAvailable) {
			_precision = "lowp";
			trace("WebGLRenderer: mediump not supported, using lowp");
		}*/
	}
	
	// API
	/*public function getContext():GL {
		return GL;
	}*/

	public function supportsVertexTextures():Bool {
		return _supportsVertexTextures;
	}

	public function supportsFloatTextures():Dynamic {
		return _glExtensionTextureFloat;
	}

	public function supportsStandardDerivatives():Dynamic {
		return cast _glExtensionStandardDerivatives;
	}

	public function supportsCompressedTextureS3TC():Dynamic {
		return _glExtensionCompressedTextureS3TC;
	}

	public function getMaxAnisotropy():Dynamic {
		return _maxAnisotropy;
	}

	public function getPrecision():String {
		return _precision;
	}

	public function setSize(width:Float, height:Float, updateStyle:Bool = true) {
		_canvas.width = width * this.devicePixelRatio;
		_canvas.height = height * this.devicePixelRatio;

		this.setViewport(0, 0, _canvas.width, _canvas.height);
	}

	public function setViewport(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		_viewportX = Std.int(x);
		_viewportY = Std.int(y);

		_viewportWidth = Std.int(width != 0 ? width : _canvas.width);
		_viewportHeight = Std.int(height != 0 ? height : _canvas.height);

		GL.viewport(Std.int(_viewportX), Std.int(_viewportY), Std.int(_viewportWidth), Std.int(_viewportHeight));
	}

	public function setScissor(x:Int, y:Int, width:Int, height:Int) {
		GL.scissor(x, y, width, height);
	}

	public function enableScissorTest(enable:Bool) {
		enable ? GL.enable(GL.SCISSOR_TEST) : GL.disable(GL.SCISSOR_TEST);
	}

	// Clearing
	public function setClearColor(color:Dynamic, alpha:Float = 1) {
		_clearColor.set(color);
		_clearAlpha = alpha;

		GL.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearAlpha);
	}

	public function setClearColorHex(hex:Int, alpha:Float) {
		trace("DEPRECATED: .setClearColorHex() is being removed. Use .setClearColor() instead.");
		this.setClearColor(hex, alpha);
	}

	public function getClearColor():Color {
		return _clearColor;
	}

	public function getClearAlpha():Float {
		return _clearAlpha;
	}

	public function clear(color:Bool = false, depth:Bool = false, stencil:Bool = false) {
		var bits = 0;

		if (color) bits |= GL.COLOR_BUFFER_BIT;
		if (depth) bits |= GL.DEPTH_BUFFER_BIT;
		if (stencil) bits |= GL.STENCIL_BUFFER_BIT;

		GL.clear(bits);
	}

	public function clearColor() {
		GL.clear(GL.COLOR_BUFFER_BIT);
	}

	public function clearDepth() {
		GL.clear(GL.DEPTH_BUFFER_BIT);
	}

	public function clearStencil() {
		GL.clear(GL.STENCIL_BUFFER_BIT);
	}

	public function clearTarget(renderTarget:Dynamic, color:Bool, depth:Bool, stencil:Bool) {
		this.setRenderTarget(renderTarget);
		this.clear(color, depth, stencil);
	}

	// Plugins
	public function addPostPlugin(plugin:Dynamic) {
		plugin.init(this);
		this.renderPluginsPost.push(plugin);
	}

	public function addPrePlugin(plugin:Dynamic) {
		plugin.init(this);
		this.renderPluginsPre.push(plugin);
	}

	// Rendering
	public function updateShadowMap(scene:Scene, camera:Camera) {
		_currentProgram = null;
		_oldBlending = -1;
		_oldDepthTest = -1;
		_oldDepthWrite = -1;
		_currentGeometryGroupHash = -1;
		_currentMaterialId = -1;
		_lightsNeedUpdate = true;
		_oldDoubleSided = -1;
		_oldFlipSided = -1;

		this.shadowMapPlugin.update(scene, camera);
	}

	// Internal functions
	// Buffer allocation
	function createParticleBuffers(geometry:Geometry) {
		geometry.__webglVertexBuffer = GL.createBuffer();
		geometry.__webglColorBuffer = GL.createBuffer();

		this.info.memory.geometries++;
	}

	function createLineBuffers(geometry:Geometry) {
		geometry.__webglVertexBuffer = GL.createBuffer();
		geometry.__webglColorBuffer = GL.createBuffer();
		geometry.__webglLineDistanceBuffer = GL.createBuffer();

		this.info.memory.geometries++;
	}

	function createMeshBuffers(geometryGroup:Geometry) {
		geometryGroup.__webglVertexBuffer = GL.createBuffer();
		geometryGroup.__webglNormalBuffer = GL.createBuffer();
		geometryGroup.__webglTangentBuffer = GL.createBuffer();
		geometryGroup.__webglColorBuffer = GL.createBuffer();
		geometryGroup.__webglUVBuffer = GL.createBuffer();
		geometryGroup.__webglUV2Buffer = GL.createBuffer();

		geometryGroup.__webglSkinIndicesBuffer = GL.createBuffer();
		geometryGroup.__webglSkinWeightsBuffer = GL.createBuffer();

		geometryGroup.__webglFaceBuffer = GL.createBuffer();
		geometryGroup.__webglLineBuffer = GL.createBuffer();

		if (geometryGroup.numMorphTargets != 0) {
			geometryGroup.__webglMorphTargetsBuffers = new Array<GLBuffer>();
			for (m in 0...geometryGroup.numMorphTargets) {
				geometryGroup.__webglMorphTargetsBuffers.push(GL.createBuffer());
			}
		}

		if (geometryGroup.numMorphNormals != 0) {
			geometryGroup.__webglMorphNormalsBuffers = new Array<GLBuffer>();
			for (m in 0...geometryGroup.numMorphNormals) {
				geometryGroup.__webglMorphNormalsBuffers.push(GL.createBuffer());
			}
		}

		this.info.memory.geometries++;
	}

	// Events
	public function onGeometryDispose(event:Event) {
		// TODO
		//var geometry = event.target;
		//geometry.removeEventListener("dispose", onGeometryDispose);
		//deallocateGeometry(geometry);
	}

	public function onTextureDispose(event:Event) {
		// TODO
		//var texture = event.target;
		//texture.removeEventListener("dispose", onTextureDispose);
		//deallocateTexture(texture);
		//this.info.memory.textures--;
	}

	public function onRenderTargetDispose(event:Event) {
		/*var renderTarget = event.target;
		renderTarget.removeEventListener("dispose", onRenderTargetDispose);
		deallocateRenderTarget(renderTarget);
		this.info.memory.textures--;*/
	}

	public function onMaterialDispose(event:Event) {
		/*var material = event.target;
		material.removeEventListener("dispose", onMaterialDispose);
		deallocateMaterial(material);*/
	}

	// Buffer deallocation
	public function deleteBuffers(geometry:Geometry) {
		if (geometry.__webglVertexBuffer != null) {
			GL.deleteBuffer(geometry.__webglVertexBuffer);
			geometry.__webglVertexBuffer = null;
		}
		if (geometry.__webglNormalBuffer != null) {
			GL.deleteBuffer(geometry.__webglNormalBuffer);
			geometry.__webglNormalBuffer = null;
		}
		if (geometry.__webglTangentBuffer != null) {
			GL.deleteBuffer(geometry.__webglTangentBuffer);
			geometry.__webglTangentBuffer = null;
		}
		if (geometry.__webglColorBuffer != null) {
			GL.deleteBuffer(geometry.__webglColorBuffer);
			geometry.__webglColorBuffer = null;
		}
		if (geometry.__webglUVBuffer != null) {
			GL.deleteBuffer(geometry.__webglUVBuffer);
			geometry.__webglUVBuffer = null;
		}
		if (geometry.__webglUV2Buffer != null) {
			GL.deleteBuffer(geometry.__webglUV2Buffer);
			geometry.__webglUV2Buffer = null;
		}

		if (geometry.__webglSkinIndicesBuffer != null) {
			GL.deleteBuffer(geometry.__webglSkinIndicesBuffer);
			geometry.__webglSkinIndicesBuffer = null;
		}
		if (geometry.__webglSkinWeightsBuffer != null) {
			GL.deleteBuffer(geometry.__webglSkinWeightsBuffer);
			geometry.__webglSkinWeightsBuffer = null;
		}

		if (geometry.__webglFaceBuffer != null) {
			GL.deleteBuffer(geometry.__webglFaceBuffer);
			geometry.__webglFaceBuffer = null;
		}
		if (geometry.__webglLineBuffer != null) {
			GL.deleteBuffer(geometry.__webglLineBuffer);
			geometry.__webglLineBuffer = null;
		}

		if (geometry.__webglLineDistanceBuffer != null) {
			GL.deleteBuffer(geometry.__webglLineDistanceBuffer);
			geometry.__webglLineDistanceBuffer = null;
		}
		
		// custom attributes
		if (geometry.__webglCustomAttributesList != null) {
			for (id in geometry.__webglCustomAttributesList) {
				GL.deleteBuffer(id.buffer.buffer);
				geometry.__webglCustomAttributesList.remove(id);
			}
		}

		this.info.memory.geometries--;

	}

	public function deallocateGeometry(geometry:Geometry) {
		geometry.__webglInit = false;

		if (Std.is(geometry, BufferGeometry)) {
			var attributes = cast(geometry, BufferGeometry).attributes;

			for (key in attributes.keys()) {
				if (attributes.exists(key)) {
					GL.deleteBuffer(attributes.get(key).buffer.buffer);		
				}
			}

			this.info.memory.geometries--;

		} else {
			if (geometry.geometryGroups != null) {
				for (g in geometry.geometryGroups) {
					var geometryGroup = g;
					if (geometryGroup.numMorphTargets != 0) {
						for (m in 0...geometryGroup.numMorphTargets) {
							GL.deleteBuffer(geometryGroup.__webglMorphTargetsBuffers[m]);
						}
					}
					if (geometryGroup.numMorphNormals != 0) {
						for (m in 0...geometryGroup.numMorphNormals) {
							GL.deleteBuffer(geometryGroup.__webglMorphNormalsBuffers[m]);
						}
					}

					deleteBuffers(geometryGroup);
				}
			} else {
				deleteBuffers(geometry);
			}
		}
	}

	public function deallocateTexture(texture:Dynamic) {
		// TODO
		/*if (texture.image && texture.image.__webglTextureCube) {
			// cube texture
			GL.deleteTexture(texture.image.__webglTextureCube);
		} else {
			// 2D texture
			if (! texture.__webglInit) return;

			texture.__webglInit = false;
			GL.deleteTexture(texture.__webglTexture);
		}*/
	}

	public function deallocateRenderTarget(renderTarget:WebGLRenderTarget = null) {
		if (renderTarget == null || renderTarget.__webglTexture == null) return;

		GL.deleteTexture(renderTarget.__webglTexture);

		if (Std.is(renderTarget, WebGLRenderTargetCube)) {
			for (i in 0...6) {
				GL.deleteFramebuffer(renderTarget.__webglFramebuffer[i]);
				GL.deleteRenderbuffer(renderTarget.__webglRenderbuffer[i]);
			}
		} else {
			GL.deleteFramebuffer(renderTarget.__webglFramebuffer);
			GL.deleteRenderbuffer(renderTarget.__webglRenderbuffer);
		}
	}

	public function deallocateMaterial(material:Material) {
		var program = material.program;

		if (program == null) return;

		material.program = null;

		// only deallocate GL program if this was the last use of shared program
		// assumed there is only single copy of any program in the _programs list
		// (that's how it's constructed)
		var programInfo:ThreeGLProgram;
		var deleteProgram = false;
		for (i in 0..._programs.length) {
			programInfo = _programs[i];
			if (programInfo.program == program) {
				programInfo.usedTimes--;
				if (programInfo.usedTimes == 0) {
					deleteProgram = true;
				}
				break;
			}
		}

		if (deleteProgram == true) {
			// TODO: check this on static targets
			// avoid using array.splice, this is costlier than creating new array from scratch
			var newPrograms = [];

			for (i in 0..._programs.length) {
				programInfo = _programs[i];
				if (programInfo.program != program) {
					newPrograms.push(programInfo);
				}
			}

			_programs = newPrograms;
			GL.deleteProgram(program);
			this.info.memory.programs--;
		}
	}
	
	// Buffer initialization
	function initCustomAttributes(geometry:Geometry, object:Object3D) {
		var nvertices = geometry.vertices.length;

		var material:Material = Reflect.field(object, "material");

		if (Reflect.field(material, "attributes") != null) {
			if (geometry.__webglCustomAttributesList == null) {
				geometry.__webglCustomAttributesList = [];
			}

			var matAttributes = cast(material, BufferGeometry).attributes;
			for (a in matAttributes.keys()) {
				var attribute:BufferGeometryAttribute = matAttributes.get(a);

				if (attribute.__webglInitialized == null || attribute.createUniqueBuffers == null) {
					attribute.__webglInitialized = true;

					var size:Int = 1;		// "f" and "i"

					if (attribute.type == "v2") size = 2;
					else if (attribute.type == "v3") size = 3;
					else if (attribute.type == "v4") size = 4;
					else if (attribute.type == "c") size = 3;

					attribute.size = size;

					attribute.array = new Float32Array(nvertices * size);

					attribute.buffer.buffer = GL.createBuffer();		
					attribute.buffer.belongsToAttribute = a;

					attribute.needsUpdate = true;
				}

				geometry.__webglCustomAttributesList.push(attribute);
			}
		}
	}

	function initParticleBuffers(geometry:Geometry, object:ParticleSystem) {
		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array(nvertices * 3);// (nvertices * 3);
		geometry.__colorArray = new Float32Array(nvertices * 3);// (nvertices * 3);

		geometry.__sortArray = new Array<Float>();

		geometry.__webglParticleCount = nvertices;

		initCustomAttributes(geometry, object);
	}

	function initLineBuffers(geometry:Geometry, object:Line) {
		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array(nvertices * 3);// (nvertices * 3);
		geometry.__colorArray = new Float32Array(nvertices * 3);// (nvertices * 3);
		geometry.__lineDistanceArray = new Float32Array(nvertices * 1);// (nvertices * 1);

		geometry.__webglLineCount = nvertices;

		initCustomAttributes(geometry, object);
	}

	function initMeshBuffers(geometryGroup:Geometry, object:Mesh) {
		var geometry = object.geometry;
		var	faces3 = geometryGroup.faces3;		// TODO - inspect this		geometryGroup.faces3;

		var	nvertices = faces3.length * 3;
		var	ntris     = faces3.length * 1;
		var	nlines    = faces3.length * 3;

		var	material = getBufferMaterial(object, geometryGroup);

		var	uvType = bufferGuessUVType(material);
		var	normalType = bufferGuessNormalType(material);
		var	vertexColorType = bufferGuessVertexColorType(material);

		// trace("uvType", uvType, "normalType", normalType, "vertexColorType", vertexColorType, object, geometryGroup, material);
		geometryGroup.__vertexArray = new Float32Array(nvertices * 3);// ();
		if (normalType != 0) {
			geometryGroup.__normalArray = new Float32Array(nvertices * 3);// ();
		}

		if (geometry.hasTangents) {
			geometryGroup.__tangentArray = new Float32Array(nvertices * 4);// ();
		}

		if (vertexColorType != 0) {
			geometryGroup.__colorArray = new Float32Array(nvertices * 3);// ();
		}

		if (uvType) {
			if (geometry.faceVertexUvs.length > 0) {
				geometryGroup.__uvArray = new Float32Array(nvertices * 2);// ();
			}

			if (geometry.faceVertexUvs.length > 1) {
				geometryGroup.__uv2Array = new Float32Array(nvertices * 2);// ();
			}
		}

		if (object.geometry.skinWeights.length > 0 && object.geometry.skinIndices.length > 0) {
			geometryGroup.__skinIndexArray = new Float32Array(nvertices * 4);// ();
			geometryGroup.__skinWeightArray = new Float32Array(nvertices * 4);// ();
		}

		geometryGroup.__faceArray = new Int16Array(ntris * 3);// ();
		geometryGroup.__lineArray = new Int16Array(nlines * 2);// ();

		if (geometryGroup.numMorphTargets != 0) {
			geometryGroup.__morphTargetsArrays = new Array<Float32Array>();

			for (m in 0...geometryGroup.numMorphTargets) {
				geometryGroup.__morphTargetsArrays.push(new Float32Array(nvertices * 3));
			}
		}

		if (geometryGroup.numMorphNormals != 0) {
			geometryGroup.__morphNormalsArrays = new Array<Float32Array>();

			for (m in 0...geometryGroup.numMorphNormals) {
				geometryGroup.__morphNormalsArrays.push(new Float32Array(nvertices * 3));// nvertices * 3));
			}
		}

		geometryGroup.__webglFaceCount = ntris * 3;
		geometryGroup.__webglLineCount = nlines * 2;

		// custom attributes
		if (Reflect.field(material, "attributes") != null) {
			if (geometryGroup.__webglCustomAttributesList == null) {
				geometryGroup.__webglCustomAttributesList = new Array<BufferGeometryAttribute>();
			}

			var matAttributes:Map<String, BufferGeometryAttribute> = Reflect.field(material, "attributes");
			for (a in matAttributes.keys()) {
				// Do a shallow copy of the attribute object so different geometryGroup chunks use different
				// attribute buffers which are correctly indexed in the setMeshBuffers function
				var originalAttribute:BufferGeometryAttribute = matAttributes.get(a);

				var attribute:BufferGeometryAttribute = originalAttribute;
				/*for (property in Reflect.fields(originalAttribute)) {
					Reflect.setField(attribute, property) = Reflect.field(originalAttribute, property);
				}*/

				if (!attribute.__webglInitialized || attribute.createUniqueBuffers) {
					attribute.__webglInitialized = true;

					var size = 1;		// "f" and "i"

					if(attribute.type == "v2") size = 2;
					else if(attribute.type == "v3") size = 3;
					else if(attribute.type == "v4") size = 4;
					else if(attribute.type == "c" ) size = 3;

					attribute.size = size;

					attribute.array = new Float32Array(nvertices * size);

					attribute.buffer.buffer = GL.createBuffer();
					attribute.buffer.belongsToAttribute = a;

					originalAttribute.needsUpdate = true;
					attribute.__original = originalAttribute;
				}

				geometryGroup.__webglCustomAttributesList.push(attribute);
			}
		}

		geometryGroup.__inittedArrays = true;
	}

	public function getBufferMaterial(object:Mesh, geometryGroup:Geometry):Material {
		return Std.is(object.material, MeshFaceMaterial)
			? cast(object.material, MeshFaceMaterial).materials[geometryGroup.materialIndex]
			: object.material;
	}

	public function materialNeedsSmoothNormals(material:Material = null) {
		return material != null && material.shading == THREE.SmoothShading;
	}

	public function bufferGuessNormalType(material:Material):Int {
		// only MeshBasicMaterial and MeshDepthMaterial don't need normals
		if ((Std.is(material, MeshBasicMaterial) && cast(material, MeshBasicMaterial).envMap == null) || Std.is(material, MeshDepthMaterial )) {
			return 0;	// return false;
		}
		
		if (materialNeedsSmoothNormals(material)) {
			return THREE.SmoothShading;
		} else {
			return THREE.FlatShading;
		}
		
		return THREE.NoShading;
	}

	public function bufferGuessVertexColorType(material:Material):Int {
		if (Reflect.hasField(material, "vertexColors")) {	// MeshLambertMaterial ??
			return Reflect.field(material, "vertexColors");
		}

		return THREE.NoColors;	// original:   return false
	}

	public function bufferGuessUVType(material:Material):Bool {
		// material must use some texture to require uvs
		if (Reflect.hasField(material, "map") ||
		    Reflect.hasField(material, "lightMap") ||
		    Reflect.hasField(material, "bumpMap") ||
		    Reflect.hasField(material, "normalMap") ||
		    Reflect.hasField(material, "specularMap") ||
		    Std.is(material, ShaderMaterial)) {

			return true;

		}

		return false;
	}

	//

	public function initDirectBuffers(geometry:Geometry) {		// TODO - check if only BufferGeometry
		var attribute:BufferGeometryAttribute;
		var type:Dynamic;

		for (a in geometry.attributes.keys()) {
			if (a == "index") {
				type = GL.ELEMENT_ARRAY_BUFFER;
			} else {
				type = GL.ARRAY_BUFFER;
			}

			attribute = geometry.attributes.get(a);

			if (attribute.numItems == null) {
				attribute.numItems = attribute.array.length;
			}

			attribute.buffer.buffer = GL.createBuffer();

			GL.bindBuffer(type, attribute.buffer.buffer);
			GL.bufferData(type, attribute.array, GL.STATIC_DRAW);
		}
	}

	// Buffer setting
	public function setParticleBuffers(geometry:Geometry, hint:Int, object:Dynamic) {
		var vertex:Vector3, offset:Int, index:Int, color:Color;
		var vertices:Array<Vector3> = geometry.vertices;
		var vl:Int = vertices.length;

		var colors:Array<Color> = geometry.colors;
		var cl:Int = colors.length;

		var vertexArray = geometry.__vertexArray;
		var colorArray = geometry.__colorArray;

		var sortArray = geometry.__sortArray;

		var dirtyVertices = geometry.verticesNeedUpdate;
		var dirtyElements = geometry.elementsNeedUpdate;
		var dirtyColors = geometry.colorsNeedUpdate;

		var customAttributes = geometry.__webglCustomAttributesList;
		var cal:Int, value:Dynamic, customAttribute:BufferGeometryAttribute;

		/*if (object.sortParticles) {
			_projScreenMatrixPS.copy(_projScreenMatrix);
			_projScreenMatrixPS.multiply(object.matrixWorld);

			for (v in 0...vl) {
				vertex = vertices[v];

				_vector3.copy(vertex);
				_vector3.applyProjection(_projScreenMatrixPS);

				sortArray[v] = [_vector3.z, v];
			}

			sortArray.sort(numericalSort);

			for (v in 0...vl) {
				vertex = vertices[sortArray[v][1]];

				offset = v * 3;

				vertexArray[offset]     = vertex.x;
				vertexArray[offset + 1] = vertex.y;
				vertexArray[offset + 2] = vertex.z;
			}

			for (c in 0...cl) {
				offset = c * 3;

				color = colors[sortArray[c][1]];

				colorArray[offset]     = color.r;
				colorArray[offset + 1] = color.g;
				colorArray[offset + 2] = color.b;
			}

			if (customAttributes != null) {
				for (i in 0...customAttributes.length) {
					customAttribute = customAttributes[i];

					if (!(customAttribute.boundTo == null || customAttribute.boundTo == "vertices")) continue;

					offset = 0;

					cal = customAttribute.value.length;

					if (customAttribute.size == 1) {
						for (ca in 0...cal) {
							index = sortArray[ca][1];
							customAttribute.array[ca] = customAttribute.value[index];
						}
					} else if (customAttribute.size == 2) {
						for (ca in 0...cal) {
							index = sortArray[ca][1];

							value = customAttribute.value[index];

							customAttribute.array[offset] 	= value.x;
							customAttribute.array[offset + 1] = value.y;

							offset += 2;
						}
					} else if (customAttribute.size == 3) {
						if (customAttribute.type == "c") {
							for (ca in 0...cal) {
								index = sortArray[ca][1];

								value = customAttribute.value[index];

								customAttribute.array[offset]     = value.r;
								customAttribute.array[offset + 1] = value.g;
								customAttribute.array[offset + 2] = value.b;

								offset += 3;
							}
						} else {
							for (ca in 0...cal) {
								index = sortArray[ca][1];

								value = customAttribute.value[index];

								customAttribute.array[offset] 	= value.x;
								customAttribute.array[offset + 1] = value.y;
								customAttribute.array[offset + 2] = value.z;

								offset += 3;
							}
						}
					} else if (customAttribute.size == 4) {
						for (ca in 0...cal) {
							index = sortArray[ca][1];

							value = customAttribute.value[index];

							customAttribute.array[offset]     = value.x;
							customAttribute.array[offset + 1] = value.y;
							customAttribute.array[offset + 2] = value.z;
							customAttribute.array[offset + 3] = value.w;

							offset += 4;
						}
					}
				}
			}
		} else {
			if (dirtyVertices) {
				for (v in 0...vl) {
					vertex = vertices[v];

					offset = v * 3;

					vertexArray[offset]     = vertex.x;
					vertexArray[offset + 1] = vertex.y;
					vertexArray[offset + 2] = vertex.z;
				}
			}
			if (dirtyColors) {
				for (c in 0...cl) {
					color = colors[c];

					offset = c * 3;

					colorArray[offset]     = color.r;
					colorArray[offset + 1] = color.g;
					colorArray[offset + 2] = color.b;
				}
			}

			if (customAttributes != null) {
				for (i in 0...customAttributes.length) {
					customAttribute = customAttributes[i];

					if (customAttribute.needsUpdate &&
						 (customAttribute.boundTo == null ||
						   customAttribute.boundTo == "vertices")) {

						cal = customAttribute.value.length;
						offset = 0;

						if (customAttribute.size == 1) {
							for (ca in 0...cal) {
								customAttribute.array[ca] = customAttribute.value[ca];
							}
						} else if (customAttribute.size == 2) {
							for (ca in 0...cal) {
								value = customAttribute.value[ca];

								customAttribute.array[offset] 	= value.x;
								customAttribute.array[offset + 1] = value.y;

								offset += 2;
							}
						} else if (customAttribute.size == 3) {

							if (customAttribute.type == "c") {
								for (ca in 0...cal) {
									value = customAttribute.value[ca];

									customAttribute.array[offset] 	= value.r;
									customAttribute.array[offset + 1] = value.g;
									customAttribute.array[offset + 2] = value.b;

									offset += 3;
								}
							} else {
								for (ca in 0...cal) {
									value = customAttribute.value[ca];

									customAttribute.array[offset] 	= value.x;
									customAttribute.array[offset + 1] = value.y;
									customAttribute.array[offset + 2] = value.z;

									offset += 3;
								}
							}
						} else if (customAttribute.size == 4) {
							for (ca in 0...cal) {
								value = customAttribute.value[ca];

								customAttribute.array[offset]     = value.x;
								customAttribute.array[offset + 1] = value.y;
								customAttribute.array[offset + 2] = value.z;
								customAttribute.array[offset + 3] = value.w;

								offset += 4;
							}
						}
					}
				}
			}
		}

		if (dirtyVertices || object.sortParticles) {

			GL.bindBuffer(GL.ARRAY_BUFFER, geometry.__webglVertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, vertexArray, hint);

		}

		if (dirtyColors || object.sortParticles) {
			GL.bindBuffer(GL.ARRAY_BUFFER, geometry.__webglColorBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, colorArray, hint);
		}

		if (customAttributes != null && customAttributes.length > 0) {
			for (i in 0...customAttributes.length) {
				customAttribute = customAttributes[i];

				if (customAttribute.needsUpdate || object.sortParticles) {
					GL.bindBuffer(GL.ARRAY_BUFFER, customAttribute.buffer);
					GL.bufferData(GL.ARRAY_BUFFER, customAttribute.array, hint);
				}
			}
		}*/
	}

	public function setLineBuffers(geometry:Geometry, hint:Int) {
		var vertex:Vector3, offset:Int, color:Color;

		var vertices = geometry.vertices;
		var colors = geometry.colors;
		var lineDistances = geometry.lineDistances;

		var vl:Int = vertices.length;
		var cl:Int = colors.length;
		var dl:Int = lineDistances.length;

		var vertexArray = geometry.__vertexArray;
		var colorArray = geometry.__colorArray;
		var lineDistanceArray = geometry.__lineDistanceArray;

		var dirtyVertices = geometry.verticesNeedUpdate;
		var dirtyColors = geometry.colorsNeedUpdate;
		var dirtyLineDistances = geometry.lineDistancesNeedUpdate;

		var customAttributes = geometry.__webglCustomAttributesList;

		var cal:Int, value:Dynamic, customAttribute:BufferGeometryAttribute;

		if (dirtyVertices) {

			for (v in 0...vl) {
				vertex = vertices[v];

				offset = v * 3;

				vertexArray[offset]     = vertex.x;
				vertexArray[offset + 1] = vertex.y;
				vertexArray[offset + 2] = vertex.z;

			}

			GL.bindBuffer(GL.ARRAY_BUFFER, geometry.__webglVertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, vertexArray, hint);
		}

		if (dirtyColors) {
			for (c in 0...cl) {
				color = colors[c];

				offset = c * 3;

				colorArray[offset]     = color.r;
				colorArray[offset + 1] = color.g;
				colorArray[offset + 2] = color.b;
			}

			GL.bindBuffer(GL.ARRAY_BUFFER, geometry.__webglColorBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, colorArray, hint);
		}

		if (dirtyLineDistances) {
			for (d in 0...dl) {
				lineDistanceArray[d] = lineDistances[d];
			}

			GL.bindBuffer(GL.ARRAY_BUFFER, geometry.__webglLineDistanceBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, lineDistanceArray, hint);
		}

		if (customAttributes != null && customAttributes.length > 0) {
			for (i in 0...customAttributes.length) {
				customAttribute = customAttributes[i];

				if (customAttribute.needsUpdate &&
					 (customAttribute.boundTo == null ||
					   customAttribute.boundTo == "vertices")) {

					offset = 0;

					cal = customAttribute.value.length;

					if (customAttribute.size == 1) {
						for (ca in 0...cal) {
							customAttribute.array[ca] = customAttribute.value[ca];
						}
					} else if (customAttribute.size == 2) {
						for (ca in 0...cal) {
							value = customAttribute.value[ca];

							customAttribute.array[offset] 	  = value.x;
							customAttribute.array[offset + 1] = value.y;

							offset += 2;
						}
					} else if (customAttribute.size == 3) {
						if (customAttribute.type == "c") {
							for (ca in 0...cal) {
								value = customAttribute.value[ca];

								customAttribute.array[offset] 	  = value.r;
								customAttribute.array[offset + 1] = value.g;
								customAttribute.array[offset + 2] = value.b;

								offset += 3;
							}
						} else {
							for (ca in 0...cal) {
								value = customAttribute.value[ca];

								customAttribute.array[offset]     = value.x;
								customAttribute.array[offset + 1] = value.y;
								customAttribute.array[offset + 2] = value.z;

								offset += 3;
							}
						}
					} else if (customAttribute.size == 4) {
						for (ca in 0...cal) {
							value = customAttribute.value[ca];

							customAttribute.array[offset] 	  = value.x;
							customAttribute.array[offset + 1] = value.y;
							customAttribute.array[offset + 2] = value.z;
							customAttribute.array[offset + 3] = value.w;

							offset += 4;
						}
					}

					GL.bindBuffer(GL.ARRAY_BUFFER, customAttribute.buffer.buffer);
					GL.bufferData(GL.ARRAY_BUFFER, customAttribute.array, hint);
				}
			}
		}
	}

	public function setMeshBuffers(geometryGroup:Geometry, object:Object3D, hint:Int, dispose:Bool, material:Material) {

		if (!geometryGroup.__inittedArrays) {
			return;
		}

		var normalType:Int = bufferGuessNormalType(material);
		var vertexColorType:Int = bufferGuessVertexColorType(material);
		var uvType:Bool = bufferGuessUVType(material);

		var needsSmoothNormals = normalType == THREE.SmoothShading;

		var face:Face3,
		vertexNormals, faceNormal, normal,
		vertexColors, faceColor,
		vertexTangents,
		uv, uv2;
		var v1:Dynamic; // Color or Vector3
		var v2:Dynamic; // Color or Vector3
		var v3:Dynamic; // Color or Vector3
		var v4:Dynamic; // Color or Vector3
		var t1, t2, t3, t4, n1, n2, n3, n4,
		c1, c2, c3, c4,
		sw1, sw2, sw3, sw4,
		si1, si2, si3, si4,
		sa1, sa2, sa3, sa4,
		sb1, sb2, sb3, sb4,
		m, ml, i, il, fi,
		vn, uvi, uv2i,
		vka,
		nka, chf, faceVertexNormals,
		a,

		vertexIndex = 0,

		offset = 0,
		offset_uv = 0,
		offset_uv2 = 0,
		offset_face = 0,
		offset_normal = 0,
		offset_tangent = 0,
		offset_line = 0,
		offset_color = 0,
		offset_skin = 0,
		offset_morphTarget = 0,
		offset_custom = 0,
		offset_customSrc = 0,

		value,

		vertexArray = geometryGroup.__vertexArray,
		uvArray = geometryGroup.__uvArray,
		uv2Array = geometryGroup.__uv2Array,
		normalArray = geometryGroup.__normalArray,
		tangentArray = geometryGroup.__tangentArray,
		colorArray = geometryGroup.__colorArray,

		skinIndexArray = geometryGroup.__skinIndexArray,
		skinWeightArray = geometryGroup.__skinWeightArray,

		morphTargetsArrays = geometryGroup.__morphTargetsArrays,
		morphNormalsArrays = geometryGroup.__morphNormalsArrays,

		customAttributes:Array<BufferGeometryAttribute> = geometryGroup.__webglCustomAttributesList,
		customAttribute:BufferGeometryAttribute,

		faceArray = geometryGroup.__faceArray,
		lineArray = geometryGroup.__lineArray,

		geometry:Geometry = object.geometry, // this is shared for all chunks

		dirtyVertices = geometry.verticesNeedUpdate,
		dirtyElements = geometry.elementsNeedUpdate,
		dirtyUvs = geometry.uvsNeedUpdate,
		dirtyNormals = geometry.normalsNeedUpdate,
		dirtyTangents = geometry.tangentsNeedUpdate,
		dirtyColors = geometry.colorsNeedUpdate,
		dirtyMorphTargets = geometry.morphTargetsNeedUpdate;

		var vertices:Array<Vector3> = geometry.vertices;
		var chunk_faces3:Array<Int> = geometryGroup.faces3;
		var obj_faces:Array<Face3> = geometry.faces;

		var obj_uvs:Array<Array<Vector2>> = geometry.faceVertexUvs[0];
		var obj_uvs2:Array<Array<Vector2>> = geometry.faceVertexUvs[1];

		var obj_colors = geometry.colors;

		var obj_skinIndices = geometry.skinIndices;
		var obj_skinWeights = geometry.skinWeights;

		var morphTargets:Array<Dynamic> = geometry.morphTargets;
		var morphNormals = geometry.morphNormals;

		if (dirtyVertices) {
			for (f in 0...chunk_faces3.length) {
				face = obj_faces[chunk_faces3[f]];

				v1 = vertices[face.a];
				v2 = vertices[face.b];
				v3 = vertices[face.c];

				vertexArray[offset]     = v1.x;
				vertexArray[offset + 1] = v1.y;
				vertexArray[offset + 2] = v1.z;

				vertexArray[offset + 3] = v2.x;
				vertexArray[offset + 4] = v2.y;
				vertexArray[offset + 5] = v2.z;

				vertexArray[offset + 6] = v3.x;
				vertexArray[offset + 7] = v3.y;
				vertexArray[offset + 8] = v3.z;

				offset += 9;
			}

			GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, vertexArray, hint);
		}

		if (dirtyMorphTargets) {
			for (vk in 0...morphTargets.length) {
				offset_morphTarget = 0;
				for (f in 0...chunk_faces3.length) {
					chf = chunk_faces3[f];
					face = obj_faces[chf];

					// morph positions

					v1 = morphTargets[vk].vertices[face.a];
					v2 = morphTargets[vk].vertices[face.b];
					v3 = morphTargets[vk].vertices[face.c];

					vka = morphTargetsArrays[vk];

					vka[offset_morphTarget] 	= v1.x;
					vka[offset_morphTarget + 1] = v1.y;
					vka[offset_morphTarget + 2] = v1.z;

					vka[offset_morphTarget + 3] = v2.x;
					vka[offset_morphTarget + 4] = v2.y;
					vka[offset_morphTarget + 5] = v2.z;

					vka[offset_morphTarget + 6] = v3.x;
					vka[offset_morphTarget + 7] = v3.y;
					vka[offset_morphTarget + 8] = v3.z;

					// morph normals
					if (material.morphNormals) {
						if (needsSmoothNormals) {
							faceVertexNormals = morphNormals[vk].vertexNormals[chf];

							n1 = faceVertexNormals.a;
							n2 = faceVertexNormals.b;
							n3 = faceVertexNormals.c;
						} else {
							n1 = morphNormals[vk].faceNormals[chf];
							n2 = n1;
							n3 = n1;
						}

						nka = morphNormalsArrays[vk];

						nka[offset_morphTarget] 	= n1.x;
						nka[offset_morphTarget + 1] = n1.y;
						nka[offset_morphTarget + 2] = n1.z;

						nka[offset_morphTarget + 3] = n2.x;
						nka[offset_morphTarget + 4] = n2.y;
						nka[offset_morphTarget + 5] = n2.z;

						nka[offset_morphTarget + 6] = n3.x;
						nka[offset_morphTarget + 7] = n3.y;
						nka[offset_morphTarget + 8] = n3.z;
					}

					//
					offset_morphTarget += 9;
				}

				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[vk]);
				GL.bufferData(GL.ARRAY_BUFFER, morphTargetsArrays[vk], hint);

				if (material.morphNormals) {
					GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[vk]);
					GL.bufferData(GL.ARRAY_BUFFER, morphNormalsArrays[vk], hint);
				}
			}
		}

		if (obj_skinWeights.length > 0) {

			for (f in 0...chunk_faces3.length) {
				face = obj_faces[chunk_faces3[f]];

				// weights
				sw1 = obj_skinWeights[face.a];
				sw2 = obj_skinWeights[face.b];
				sw3 = obj_skinWeights[face.c];

				skinWeightArray[offset_skin]     = sw1.x;
				skinWeightArray[offset_skin + 1] = sw1.y;
				skinWeightArray[offset_skin + 2] = sw1.z;
				skinWeightArray[offset_skin + 3] = sw1.w;

				skinWeightArray[offset_skin + 4] = sw2.x;
				skinWeightArray[offset_skin + 5] = sw2.y;
				skinWeightArray[offset_skin + 6] = sw2.z;
				skinWeightArray[offset_skin + 7] = sw2.w;

				skinWeightArray[offset_skin + 8]  = sw3.x;
				skinWeightArray[offset_skin + 9]  = sw3.y;
				skinWeightArray[offset_skin + 10] = sw3.z;
				skinWeightArray[offset_skin + 11] = sw3.w;

				// indices
				si1 = obj_skinIndices[face.a];
				si2 = obj_skinIndices[face.b];
				si3 = obj_skinIndices[face.c];

				skinIndexArray[offset_skin]     = si1.x;
				skinIndexArray[offset_skin + 1] = si1.y;
				skinIndexArray[offset_skin + 2] = si1.z;
				skinIndexArray[offset_skin + 3] = si1.w;

				skinIndexArray[offset_skin + 4] = si2.x;
				skinIndexArray[offset_skin + 5] = si2.y;
				skinIndexArray[offset_skin + 6] = si2.z;
				skinIndexArray[offset_skin + 7] = si2.w;

				skinIndexArray[offset_skin + 8]  = si3.x;
				skinIndexArray[offset_skin + 9]  = si3.y;
				skinIndexArray[offset_skin + 10] = si3.z;
				skinIndexArray[offset_skin + 11] = si3.w;

				offset_skin += 12;
			}

			if (offset_skin > 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer);
				GL.bufferData(GL.ARRAY_BUFFER, skinIndexArray, hint);

				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer);
				GL.bufferData(GL.ARRAY_BUFFER, skinWeightArray, hint);
			}

		}

		if (dirtyColors && vertexColorType != 0) {		// vertexColorType != 0
			for (f in 0...chunk_faces3.length) {
				face = obj_faces[chunk_faces3[f]];

				vertexColors = face.vertexColors;
				faceColor = face.color;

				if (vertexColors.length == 3 && vertexColorType == THREE.VertexColors) {
					c1 = vertexColors[0];
					c2 = vertexColors[1];
					c3 = vertexColors[2];
				} else {
					c1 = faceColor;
					c2 = faceColor;
					c3 = faceColor;
				}

				colorArray[offset_color]     = c1.r;
				colorArray[offset_color + 1] = c1.g;
				colorArray[offset_color + 2] = c1.b;

				colorArray[offset_color + 3] = c2.r;
				colorArray[offset_color + 4] = c2.g;
				colorArray[offset_color + 5] = c2.b;

				colorArray[offset_color + 6] = c3.r;
				colorArray[offset_color + 7] = c3.g;
				colorArray[offset_color + 8] = c3.b;

				offset_color += 9;
			}

			if (offset_color > 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglColorBuffer);
				GL.bufferData(GL.ARRAY_BUFFER, colorArray, hint);
			}
		}

		if (dirtyTangents && geometry.hasTangents) {
			for (f in 0...chunk_faces3.length) {
				face = obj_faces[chunk_faces3[f]];

				vertexTangents = face.vertexTangents;

				t1 = vertexTangents[0];
				t2 = vertexTangents[1];
				t3 = vertexTangents[2];

				tangentArray[offset_tangent]     = t1.x;
				tangentArray[offset_tangent + 1] = t1.y;
				tangentArray[offset_tangent + 2] = t1.z;
				tangentArray[offset_tangent + 3] = t1.w;

				tangentArray[offset_tangent + 4] = t2.x;
				tangentArray[offset_tangent + 5] = t2.y;
				tangentArray[offset_tangent + 6] = t2.z;
				tangentArray[offset_tangent + 7] = t2.w;

				tangentArray[offset_tangent + 8]  = t3.x;
				tangentArray[offset_tangent + 9]  = t3.y;
				tangentArray[offset_tangent + 10] = t3.z;
				tangentArray[offset_tangent + 11] = t3.w;

				offset_tangent += 12;
			}

			GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, tangentArray, hint);
		}

		if (dirtyNormals && normalType != 0) {
			for (f in 0...chunk_faces3.length) {
				face = obj_faces[chunk_faces3[f]];

				vertexNormals = face.vertexNormals;
				faceNormal = face.normal;

				if (vertexNormals.length == 3 && needsSmoothNormals) {
					for (i in 0...3) {
						vn = vertexNormals[i];

						normalArray[offset_normal]     = vn.x;
						normalArray[offset_normal + 1] = vn.y;
						normalArray[offset_normal + 2] = vn.z;

						offset_normal += 3;
					}
				} else {
					for (i in 0...3) {
						normalArray[offset_normal]     = faceNormal.x;
						normalArray[offset_normal + 1] = faceNormal.y;
						normalArray[offset_normal + 2] = faceNormal.z;

						offset_normal += 3;
					}
				}
			}

			GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, normalArray, hint);
		}

		if (dirtyUvs && obj_uvs != null && obj_uvs.length > 0 && uvType) {
			for (f in 0...chunk_faces3.length) {
				fi = chunk_faces3[f];

				uv = obj_uvs[fi];

				if (uv == null) continue;

				for (i in 0...3) {
					uvi = uv[i];

					uvArray[offset_uv]     = uvi.x;
					uvArray[offset_uv + 1] = uvi.y;

					offset_uv += 2;
				}
			}

			if (offset_uv > 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglUVBuffer);
				GL.bufferData(GL.ARRAY_BUFFER, uvArray, hint);
			}
		}

		if (dirtyUvs && obj_uvs2 != null && obj_uvs2.length > 0 && uvType) {
			for (f in 0...chunk_faces3.length) {
				fi = chunk_faces3[f];

				uv2 = obj_uvs2[fi];

				if (uv2 == null) continue;

				for (i in 0...3) {
					uv2i = uv2[i];

					uv2Array[offset_uv2]     = uv2i.x;
					uv2Array[offset_uv2 + 1] = uv2i.y;

					offset_uv2 += 2;
				}
			}

			if (offset_uv2 > 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer);
				GL.bufferData(GL.ARRAY_BUFFER, uv2Array, hint);
			}
		}

		if (dirtyElements) {
			for (f in 0...chunk_faces3.length) {
				faceArray[offset_face] 	   = vertexIndex;
				faceArray[offset_face + 1] = vertexIndex + 1;
				faceArray[offset_face + 2] = vertexIndex + 2;

				offset_face += 3;

				lineArray[offset_line]     = vertexIndex;
				lineArray[offset_line + 1] = vertexIndex + 1;

				lineArray[offset_line + 2] = vertexIndex;
				lineArray[offset_line + 3] = vertexIndex + 2;

				lineArray[offset_line + 4] = vertexIndex + 1;
				lineArray[offset_line + 5] = vertexIndex + 2;

				offset_line += 6;

				vertexIndex += 3;
			}

			GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer);
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, faceArray, hint);

			GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer);
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, lineArray, hint);
		}

		if (customAttributes != null && customAttributes.length > 0) {
			for (i in 0...customAttributes.length) {

				customAttribute = customAttributes[i];

				if (!customAttribute.__original.needsUpdate) continue;

				offset_custom = 0;
				offset_customSrc = 0;

				if (customAttribute.size == 1) {
					if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {
						for (f in 0...chunk_faces3.length) {
							face = obj_faces[chunk_faces3[f]];

							customAttribute.array[offset_custom] 	 = customAttribute.value[face.a];
							customAttribute.array[offset_custom + 1] = customAttribute.value[face.b];
							customAttribute.array[offset_custom + 2] = customAttribute.value[face.c];

							offset_custom += 3;
						}
					} else if (customAttribute.boundTo == "faces") {
						for (f in 0...chunk_faces3.length) {
							value = customAttribute.value[chunk_faces3[f]];

							customAttribute.array[offset_custom] 	 = value;
							customAttribute.array[offset_custom + 1] = value;
							customAttribute.array[offset_custom + 2] = value;

							offset_custom += 3;
						}
					}
				} else if (customAttribute.size == 2) {
					if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {
						for (f in 0...chunk_faces3.length) {
							face = obj_faces[chunk_faces3[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];

							customAttribute.array[offset_custom] 	 = v1.x;
							customAttribute.array[offset_custom + 1] = v1.y;

							customAttribute.array[offset_custom + 2] = v2.x;
							customAttribute.array[offset_custom + 3] = v2.y;

							customAttribute.array[offset_custom + 4] = v3.x;
							customAttribute.array[offset_custom + 5] = v3.y;

							offset_custom += 6;
						}
					} else if (customAttribute.boundTo == "faces") {
						for (f in 0...chunk_faces3.length) {
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttribute.array[offset_custom] 	   = v1.x;
							customAttribute.array[offset_custom + 1] = v1.y;

							customAttribute.array[offset_custom + 2] = v2.x;
							customAttribute.array[offset_custom + 3] = v2.y;

							customAttribute.array[offset_custom + 4] = v3.x;
							customAttribute.array[offset_custom + 5] = v3.y;

							offset_custom += 6;
						}
					}
				} else if (customAttribute.size == 3) {
					var pp:Array<String> = [];
					if (customAttribute.type == "c") {
						pp = ["r", "g", "b"];
					} else {
						pp = ["x", "y", "z"];
					}
					
					if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {
						for (f in 0...chunk_faces3.length) {
							face = obj_faces[chunk_faces3[f]];

							v1 = customAttribute.value[face.a];
							v2 = customAttribute.value[face.b];
							v3 = customAttribute.value[face.c];

							customAttribute.array[offset_custom] 	 = Reflect.field(v1, pp[0]);
							customAttribute.array[offset_custom + 1] = Reflect.field(v1, pp[1]);
							customAttribute.array[offset_custom + 2] = Reflect.field(v1, pp[2]);

							customAttribute.array[offset_custom + 3] = Reflect.field(v2, pp[0]);
							customAttribute.array[offset_custom + 4] = Reflect.field(v2, pp[1]);
							customAttribute.array[offset_custom + 5] = Reflect.field(v2, pp[2]);

							customAttribute.array[offset_custom + 6] = Reflect.field(v3, pp[0]);
							customAttribute.array[offset_custom + 7] = Reflect.field(v3, pp[1]);
							customAttribute.array[offset_custom + 8] = Reflect.field(v3, pp[2]);

							offset_custom += 9;
						}
					} else if (customAttribute.boundTo == "faces") {
						for (f in 0...chunk_faces3.length) {
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttribute.array[offset_custom] 	 = Reflect.field(v1, pp[0]);
							customAttribute.array[offset_custom + 1] = Reflect.field(v1, pp[1]);
							customAttribute.array[offset_custom + 2] = Reflect.field(v1, pp[2]);

							customAttribute.array[offset_custom + 3] = Reflect.field(v2, pp[0]);
							customAttribute.array[offset_custom + 4] = Reflect.field(v2, pp[1]);
							customAttribute.array[offset_custom + 5] = Reflect.field(v2, pp[2]);

							customAttribute.array[offset_custom + 6] = Reflect.field(v3, pp[0]);
							customAttribute.array[offset_custom + 7] = Reflect.field(v3, pp[1]);
							customAttribute.array[offset_custom + 8] = Reflect.field(v3, pp[2]);

							offset_custom += 9;
						}
					} else if (customAttribute.boundTo == "faceVertices") {
						for (f in 0...chunk_faces3.length) {
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value[0];
							v2 = value[1];
							v3 = value[2];

							customAttribute.array[offset_custom] 	 = Reflect.field(v1, pp[0]);
							customAttribute.array[offset_custom + 1] = Reflect.field(v1, pp[1]);
							customAttribute.array[offset_custom + 2] = Reflect.field(v1, pp[2]);

							customAttribute.array[offset_custom + 3] = Reflect.field(v2, pp[0]);
							customAttribute.array[offset_custom + 4] = Reflect.field(v2, pp[1]);
							customAttribute.array[offset_custom + 5] = Reflect.field(v2, pp[2]);

							customAttribute.array[offset_custom + 6] = Reflect.field(v3, pp[0]);
							customAttribute.array[offset_custom + 7] = Reflect.field(v3, pp[1]);
							customAttribute.array[offset_custom + 8] = Reflect.field(v3, pp[2]);

							offset_custom += 9;
						}
					}
				} else if (customAttribute.size == 4) {
					if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {
						for (f in 0...chunk_faces3.length) {
							face = obj_faces[chunk_faces3[f]];

							v1 = customAttribute.value[face.a ];
							v2 = customAttribute.value[face.b ];
							v3 = customAttribute.value[face.c ];

							customAttribute.array[offset_custom] 	 = v1.x;
							customAttribute.array[offset_custom + 1] = v1.y;
							customAttribute.array[offset_custom + 2] = v1.z;
							customAttribute.array[offset_custom + 3] = v1.w;

							customAttribute.array[offset_custom + 4] = v2.x;
							customAttribute.array[offset_custom + 5] = v2.y;
							customAttribute.array[offset_custom + 6] = v2.z;
							customAttribute.array[offset_custom + 7] = v2.w;

							customAttribute.array[offset_custom + 8]  = v3.x;
							customAttribute.array[offset_custom + 9]  = v3.y;
							customAttribute.array[offset_custom + 10] = v3.z;
							customAttribute.array[offset_custom + 11] = v3.w;

							offset_custom += 12;
						}
					} else if (customAttribute.boundTo == "faces") {
						for (f in 0...chunk_faces3.length) {
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttribute.array[offset_custom] 	 = v1.x;
							customAttribute.array[offset_custom + 1] = v1.y;
							customAttribute.array[offset_custom + 2] = v1.z;
							customAttribute.array[offset_custom + 3] = v1.w;

							customAttribute.array[offset_custom + 4] = v2.x;
							customAttribute.array[offset_custom + 5] = v2.y;
							customAttribute.array[offset_custom + 6] = v2.z;
							customAttribute.array[offset_custom + 7] = v2.w;

							customAttribute.array[offset_custom + 8] = v3.x;
							customAttribute.array[offset_custom + 9] = v3.y;
							customAttribute.array[offset_custom + 10] = v3.z;
							customAttribute.array[offset_custom + 11] = v3.w;

							offset_custom += 12;
						}
					} else if (customAttribute.boundTo == "faceVertices") {
						for (f in 0...chunk_faces3.length) {
							value = customAttribute.value[chunk_faces3[f]];

							v1 = value[0];
							v2 = value[1];
							v3 = value[2];

							customAttribute.array[offset_custom] 	= v1.x;
							customAttribute.array[offset_custom + 1] = v1.y;
							customAttribute.array[offset_custom + 2] = v1.z;
							customAttribute.array[offset_custom + 3] = v1.w;

							customAttribute.array[offset_custom + 4] = v2.x;
							customAttribute.array[offset_custom + 5] = v2.y;
							customAttribute.array[offset_custom + 6] = v2.z;
							customAttribute.array[offset_custom + 7] = v2.w;

							customAttribute.array[offset_custom + 8] = v3.x;
							customAttribute.array[offset_custom + 9] = v3.y;
							customAttribute.array[offset_custom + 10] = v3.z;
							customAttribute.array[offset_custom + 11] = v3.w;

							offset_custom += 12;
						}
					}
				}

				GL.bindBuffer(GL.ARRAY_BUFFER, customAttribute.buffer.buffer);
				GL.bufferData(GL.ARRAY_BUFFER, customAttribute.array, hint);
			}
		}

		if (dispose) {
			geometryGroup.__inittedArrays = false;
			geometryGroup.__colorArray = null;
			geometryGroup.__normalArray = null;
			geometryGroup.__tangentArray = null;
			geometryGroup.__uvArray = null;
			geometryGroup.__uv2Array = null;
			geometryGroup.__faceArray = null;
			geometryGroup.__vertexArray = null;
			geometryGroup.__lineArray = null;
			geometryGroup.__skinIndexArray = null;
			geometryGroup.__skinWeightArray = null;
		}
	}

	public function setDirectBuffers(geometry:Geometry, hint:Int, dispose:Bool) {
		var attributes = geometry.attributes;

		for (attributeName in attributes.keys()) {

			var attributeItem:BufferGeometryAttribute = attributes.get(attributeName);
			if (attributeItem.needsUpdate) {
				if (attributeName == "index") {
					GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, attributeItem.buffer.buffer);
					GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, attributeItem.array, hint);
				} else {
					GL.bindBuffer(GL.ARRAY_BUFFER, attributeItem.buffer.buffer);
					GL.bufferData(GL.ARRAY_BUFFER, attributeItem.array, hint);
				}

				attributeItem.needsUpdate = false;
			}

			if (dispose && !attributeItem.isDynamic) {
				attributeItem.array = null;
			}
		}
	}
	
	// Buffer rendering
	public function renderBufferImmediate(object:Object3D, program:Dynamic, material:Material) {
		if (object.hasPositions && object.__webglVertexBuffer == null) object.__webglVertexBuffer = GL.createBuffer();
		if (object.hasNormals && object.__webglNormalBuffer == null) object.__webglNormalBuffer = GL.createBuffer();
		if (object.hasUvs && object.__webglUvBuffer == null) object.__webglUvBuffer = GL.createBuffer();
		if (object.hasColors && object.__webglColorBuffer == null) object.__webglColorBuffer = GL.createBuffer();

		if (object.hasPositions) {
			GL.bindBuffer(GL.ARRAY_BUFFER, object.__webglVertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, object.positionArray, GL.DYNAMIC_DRAW);
			GL.enableVertexAttribArray(program.attributes.position);
			GL.vertexAttribPointer(program.attributes.position, 3, GL.FLOAT, false, 0, 0);
		}

		if (object.hasNormals) {
			GL.bindBuffer(GL.ARRAY_BUFFER, object.__webglNormalBuffer);

			if (material.shading == THREE.FlatShading) {
				var nx, ny, nz,
					nax, nbx, ncx, nay, nby, ncy, naz, nbz, ncz,
					normalArray;
					
				var i:Int = 0;
				var il = object.count * 3;
				while(i < il) {
					normalArray = object.normalArray;

					nax = normalArray[i];
					nay = normalArray[i + 1];
					naz = normalArray[i + 2];

					nbx = normalArray[i + 3];
					nby = normalArray[i + 4];
					nbz = normalArray[i + 5];

					ncx = normalArray[i + 6];
					ncy = normalArray[i + 7];
					ncz = normalArray[i + 8];

					nx = (nax + nbx + ncx) / 3;
					ny = (nay + nby + ncy) / 3;
					nz = (naz + nbz + ncz) / 3;

					normalArray[i]     = nx;
					normalArray[i + 1] = ny;
					normalArray[i + 2] = nz;

					normalArray[i + 3] = nx;
					normalArray[i + 4] = ny;
					normalArray[i + 5] = nz;

					normalArray[i + 6] = nx;
					normalArray[i + 7] = ny;
					normalArray[i + 8] = nz;
					i += 9;
				}
			}

			GL.bufferData(GL.ARRAY_BUFFER, object.normalArray, GL.DYNAMIC_DRAW);
			GL.enableVertexAttribArray(program.attributes.normal);
			GL.vertexAttribPointer(program.attributes.normal, 3, GL.FLOAT, false, 0, 0);
		}

		if (object.hasUvs && Reflect.field(material, "map")) {
			GL.bindBuffer(GL.ARRAY_BUFFER, object.__webglUvBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, Reflect.field(object, "uvArray"), GL.DYNAMIC_DRAW);
			GL.enableVertexAttribArray(program.attributes.uv);
			GL.vertexAttribPointer(program.attributes.uv, 2, GL.FLOAT, false, 0, 0);
		}

		if (object.hasColors && material.vertexColors != THREE.NoColors) {
			GL.bindBuffer(GL.ARRAY_BUFFER, object.__webglColorBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, Reflect.field(object, "colorArray"), GL.DYNAMIC_DRAW);
			GL.enableVertexAttribArray(program.attributes.color);
			GL.vertexAttribPointer(program.attributes.color, 3, GL.FLOAT, false, 0, 0);
		}

		GL.drawArrays(GL.TRIANGLES, 0, object.count);

		object.count = 0;
	}

	function renderBufferDirect(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, geometry:Geometry, object:Object3D) {
		if (material.visible == false) return;

		var linewidth:Float, a:Dynamic, attribute:Dynamic;
		var attributeItem:Dynamic, attributeName:Dynamic, attributePointer:Dynamic, attributeSize:Dynamic;

		var program:ThreeGLProgram = setProgram(camera, lights, fog, material, object);

		var programAttributes:Map<String, Dynamic> = program.attributes;
		var geometryAttributes = geometry.attributes;

		var updateBuffers = false;
		var wireframeBit = material.wireframe ? 1 : 0;
		var geometryHash = (geometry.id * 0xffffff) + (program.id * 2) + wireframeBit;

		if (geometryHash != _currentGeometryGroupHash) {
			_currentGeometryGroupHash = geometryHash;
			updateBuffers = true;
			disableAttributes();
		}

		// render mesh
		if (Std.is(object, Mesh)) {
			var index = geometryAttributes.get("index");

			// indexed triangles
			if (index != null) {
				var offsets = geometry.offsets;

				// if there is more than 1 chunk
				// must set attribute pointers to use new offsets for each chunk
				// even if geometry and materials didn't change
				if (offsets.length > 1) updateBuffers = true;

				for (i in 0...offsets.length) {
					var startIndex = offsets[i].index;
					if (updateBuffers) {
						for (attributeName in programAttributes.keys()) {

							attributePointer = programAttributes.get(attributeName);
							attributeItem = geometryAttributes.get(attributeName);

							if (attributePointer >= 0) {
								if (attributeItem != null) {
									attributeSize = attributeItem.itemSize;
									GL.bindBuffer(GL.ARRAY_BUFFER, attributeItem.buffer);
									enableAttribute(attributePointer);
									GL.vertexAttribPointer(attributePointer, attributeSize, GL.FLOAT, false, 0, Std.int(startIndex * attributeSize * 4)); // 4 bytes per Float32

								} else if (material.defaultAttributeValues != null) {
									if (material.defaultAttributeValues.get(attributeName).length == 2) {
										GL.vertexAttrib2fv(attributePointer, material.defaultAttributeValues.get(attributeName));
									} else if (material.defaultAttributeValues.get(attributeName).length == 3) {
										GL.vertexAttrib3fv(attributePointer, material.defaultAttributeValues.get(attributeName));
									}
								}
							}
						}

						// indices
						GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, index.buffer.buffer);
					}

					// render indexed triangles
					GL.drawElements(GL.TRIANGLES, offsets[i].count, GL.UNSIGNED_SHORT, offsets[i].start * 2); // 2 bytes per Uint16

					this.info.render.calls++;
					this.info.render.vertices += offsets[i].count; // not really true, here vertices can be shared
					this.info.render.faces += Std.int(offsets[i].count / 3);
				}
			// non-indexed triangles
			} else {
				if (updateBuffers) {
					for (attributeName in programAttributes.keys()) {
						if (attributeName == "index") continue;

						attributePointer = programAttributes.get(attributeName);
						attributeItem = geometryAttributes.get(attributeName);
						
						if (attributePointer >= 0) {
							if (attributeItem != null) {
								attributeSize = attributeItem.itemSize;
								GL.bindBuffer(GL.ARRAY_BUFFER, attributeItem.buffer);
								enableAttribute(attributePointer);
								GL.vertexAttribPointer(attributePointer, attributeSize, GL.FLOAT, false, 0, 0);

							} else if (material.defaultAttributeValues != null && material.defaultAttributeValues.get(attributeName) != null) {
								if (material.defaultAttributeValues.get(attributeName).length == 2) {
									GL.vertexAttrib2fv(attributePointer, material.defaultAttributeValues.get(attributeName));
								} else if (material.defaultAttributeValues.get(attributeName).length == 3) {
									GL.vertexAttrib3fv(attributePointer, material.defaultAttributeValues.get(attributeName));
								}
							}
						}
					}
				}

				var position = geometry.attributes.get("position");

				// render non-indexed triangles
				GL.drawArrays(GL.TRIANGLES, 0, Std.int(position.numItems / 3));

				this.info.render.calls++;
				this.info.render.vertices += Std.int(position.numItems / 3);
				this.info.render.faces += Std.int(position.numItems / 3 / 3);
			}
		// render particles
		} else if (Std.is(object, ParticleSystem)) {
			if (updateBuffers) {
				for (attributeName in programAttributes.keys()) {
					attributePointer = programAttributes.get(attributeName);
					attributeItem = geometryAttributes.get(attributeName);
					
					if (attributePointer >= 0) {
						if (attributeItem) {
							attributeSize = attributeItem.itemSize;
							GL.bindBuffer(GL.ARRAY_BUFFER, attributeItem.buffer);
							enableAttribute(attributePointer);
							GL.vertexAttribPointer(attributePointer, attributeSize, GL.FLOAT, false, 0, 0);
						} else if (material.defaultAttributeValues != null && material.defaultAttributeValues.get(attributeName) != null) {

							if (material.defaultAttributeValues.get(attributeName).length == 2) {
								GL.vertexAttrib2fv(attributePointer, material.defaultAttributeValues.get(attributeName));
							} else if (material.defaultAttributeValues.get(attributeName).length == 3) {
								GL.vertexAttrib3fv(attributePointer, material.defaultAttributeValues.get(attributeName));
							}
						}
					}
				}

				var position = geometryAttributes.get("position");

				// render particles
				GL.drawArrays(GL.POINTS, 0, Std.int(position.numItems / 3));

				this.info.render.calls++;
				this.info.render.points += Std.int(position.numItems / 3);
			}
		} else if (Std.is(object, Line)) {
			if (updateBuffers) {
				for (attributeName in programAttributes.keys()) {
					attributePointer = programAttributes.get(attributeName);
					attributeItem = geometryAttributes.get(attributeName);
					
					if (attributePointer >= 0) {
						if (attributeItem != null) {
							attributeSize = attributeItem.itemSize;
							GL.bindBuffer(GL.ARRAY_BUFFER, attributeItem.buffer);
							enableAttribute(attributePointer);
							GL.vertexAttribPointer(attributePointer, attributeSize, GL.FLOAT, false, 0, 0);
						} else if (material.defaultAttributeValues != null && material.defaultAttributeValues.get(attributeName) != null) {
							if (material.defaultAttributeValues.get(attributeName).length == 2) {
								GL.vertexAttrib2fv(attributePointer, material.defaultAttributeValues.get(attributeName));
							} else if (material.defaultAttributeValues.get(attributeName).length == 3) {
								GL.vertexAttrib3fv(attributePointer, material.defaultAttributeValues.get(attributeName));
							}
						}
					}
				}

				// render lines
				var primitives = (object.type == THREE.LineStrip) ? GL.LINE_STRIP : GL.LINES;
				setLineWidth(Reflect.field(material, "linewidth"));

				var position = geometryAttributes.get("position");

				GL.drawArrays(primitives, 0, Std.int(position.numItems / 3));

				this.info.render.calls++;
				this.info.render.points += position.numItems;
			}
    	}
	}

	function renderBuffer(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, geometryGroup:Geometry, object:Object3D) {
		if (material.visible == false) return;

		var linewidth:Float, a, attribute:BufferGeometryAttribute;

		var program = setProgram(camera, lights, fog, material, object);

		var attributes = program.attributes;

		var updateBuffers = false;
		var	wireframeBit = material.wireframe ? 1 : 0;
		var	geometryGroupHash = (geometryGroup.id * 0xffffff) + (program.id * 2) + wireframeBit;

		if (geometryGroupHash != _currentGeometryGroupHash) {
			_currentGeometryGroupHash = geometryGroupHash;
			updateBuffers = true;
		}

		if (updateBuffers) {
			disableAttributes();
		}

		// vertices
		if (material.morphTargets != null && material.morphTargets.length > 0 && attributes.position != null /*>= 0*/) {
			if (updateBuffers) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
				enableAttribute(attributes.position);
				GL.vertexAttribPointer(attributes.position, 3, GL.FLOAT, false, 0, 0);
			}
		} else {
			if (Reflect.field(object, "morphTargetBase") != null) {
				setupMorphTargets(material, geometryGroup, cast object);
			}
		}

		if (updateBuffers) {
			// custom attributes
			// Use the per-geometryGroup custom attribute arrays which are setup in initMeshBuffers
			if (geometryGroup.__webglCustomAttributesList != null) {
				for (i in 0...geometryGroup.__webglCustomAttributesList.length) {
					attribute = geometryGroup.__webglCustomAttributesList[i];
					if (attributes.get(attribute.buffer.belongsToAttribute) >= 0) {
						GL.bindBuffer(GL.ARRAY_BUFFER, attribute.buffer.buffer);
						enableAttribute(attributes.get(attribute.buffer.belongsToAttribute));
						GL.vertexAttribPointer(attributes.get(attribute.buffer.belongsToAttribute), attribute.size, GL.FLOAT, false, 0, 0);
					}
				}
			}

			// colors
			if (attributes.color >= 0) {
				if (object.geometry.colors.length > 0 || object.geometry.faces.length > 0) {
					GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglColorBuffer);
					enableAttribute(attributes.color);
					GL.vertexAttribPointer(attributes.color, 3, GL.FLOAT, false, 0, 0);
				} else if (material.defaultAttributeValues != null) {
					GL.vertexAttrib3fv(attributes.color, material.defaultAttributeValues.color);
				}
			}

			// normals
			if (attributes.normal >= 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer);
				enableAttribute(attributes.normal);
				GL.vertexAttribPointer(attributes.normal, 3, GL.FLOAT, false, 0, 0);
			}

			// tangents
			if (attributes.tangent >= 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer);
				enableAttribute(attributes.tangent);
				GL.vertexAttribPointer(attributes.tangent, 4, GL.FLOAT, false, 0, 0);
			}

			// uvs
			if (attributes.uv >= 0) {
				if (object.geometry.faceVertexUvs[0] != null) {
					GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglUVBuffer);
					enableAttribute(attributes.uv);
					GL.vertexAttribPointer(attributes.uv, 2, GL.FLOAT, false, 0, 0);
				} else if (material.defaultAttributeValues != null) {
					GL.vertexAttrib2fv(attributes.uv, material.defaultAttributeValues.uv);
				}
			}

			if (attributes.uv2 >= 0) {
				if (object.geometry.faceVertexUvs[1] != null) {
					GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer);
					enableAttribute(attributes.uv2);
					GL.vertexAttribPointer(attributes.uv2, 2, GL.FLOAT, false, 0, 0);
				} else if (material.defaultAttributeValues != null) {
					GL.vertexAttrib2fv(attributes.uv2, material.defaultAttributeValues.uv2);
				}
			}

			if ((Reflect.field(material, "skinning") != null && Reflect.field(material, "skinning") != false)&&
				 attributes.skinIndex >= 0 && attributes.skinWeight >= 0) {

				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer);
				enableAttribute(attributes.skinIndex);
				GL.vertexAttribPointer(attributes.skinIndex, 4, GL.FLOAT, false, 0, 0);

				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer);
				enableAttribute(attributes.skinWeight);
				GL.vertexAttribPointer(attributes.skinWeight, 4, GL.FLOAT, false, 0, 0);
			}

			// line distances
			if (attributes.lineDistance >= 0) {
				GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglLineDistanceBuffer);
				enableAttribute(attributes.lineDistance);
				GL.vertexAttribPointer(attributes.lineDistance, 1, GL.FLOAT, false, 0, 0);
			}
		}

		// render mesh
		if (Std.is(object, Mesh)) {
			// wireframe
			if (material.wireframe) {
				setLineWidth(Reflect.field(material, "wireframeLinewidth"));

				if (updateBuffers) GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer);
				GL.drawElements(GL.LINES, geometryGroup.__webglLineCount, GL.UNSIGNED_SHORT, 0);
			// triangles
			} else {
				if (updateBuffers) GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer);
				GL.drawElements(GL.TRIANGLES, geometryGroup.__webglFaceCount, GL.UNSIGNED_SHORT, 0);
			}

			this.info.render.calls++;
			this.info.render.vertices += geometryGroup.__webglFaceCount;
			this.info.render.faces += Std.int(geometryGroup.__webglFaceCount / 3);
		// render lines
		} else if (Std.is(object, Line)) {
			var primitives = object.type == THREE.LineStrip ? GL.LINE_STRIP : GL.LINES;

			setLineWidth(Reflect.field(material, "linewidth"));

			GL.drawArrays(primitives, 0, geometryGroup.__webglLineCount);

			this.info.render.calls++;
		// render particles
		} else if (Std.is(object, ParticleSystem)) {
			GL.drawArrays(GL.POINTS, 0, geometryGroup.__webglParticleCount);

			this.info.render.calls++;
			this.info.render.points += geometryGroup.__webglParticleCount;
		}
	}

	function enableAttribute(attribute:Int) {
		var _attribute:String = "_" + attribute;
		if (Reflect.field(_enabledAttributes, _attribute) == null || Reflect.field(_enabledAttributes, _attribute) == false) {
			GL.enableVertexAttribArray(attribute);
			Reflect.setField(_enabledAttributes, _attribute, true);
		}
	}

	function disableAttributes() {
		for (attribute in Reflect.fields(_enabledAttributes)) {
			if (Reflect.field(_enabledAttributes, Std.string(attribute)) != null || Reflect.field(_enabledAttributes, Std.string(attribute)) != false) {
				var _attribute:Int = Std.parseInt(StringTools.replace(attribute, "_", ""));
				GL.disableVertexAttribArray(_attribute);
				Reflect.setField(_enabledAttributes, Std.string(attribute), false);
			}
		}
	}

	function setupMorphTargets(material:Material, geometryGroup:Geometry, object:Mesh) {
		// set base
		var attributes = material.program.attributes;

		if (object.morphTargetBase != -1 && attributes.position >= 0) {
			GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[object.morphTargetBase]);
			enableAttribute(attributes.position);
			GL.vertexAttribPointer(attributes.position, 3, GL.FLOAT, false, 0, 0);
		} else if (attributes.position >= 0) {
			GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
			enableAttribute(attributes.position);
			GL.vertexAttribPointer(attributes.position, 3, GL.FLOAT, false, 0, 0);
		}

		if (object.morphTargetForcedOrder.length > 0) {
			// set forced order
			var m = 0;
			var order = object.morphTargetForcedOrder;
			var influences = object.morphTargetInfluences;
			while (m < Reflect.field(material, "numSupportedMorphTargets") && m < order.length) {
				if (attributes.get("morphTarget" + m) >= 0) {
					GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[order[m]]);
					enableAttribute(attributes.get("morphTarget" + m));
					GL.vertexAttribPointer(attributes.get("morphTarget" + m), 3, GL.FLOAT, false, 0, 0);
				}

				if (attributes.get("morphNormal" + m) >= 0 && material.morphNormals) {
					GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[order[m]]);
					enableAttribute(attributes.get("morphNormal" + m));
					GL.vertexAttribPointer(attributes.get("morphNormal" + m), 3, GL.FLOAT, false, 0, 0);
				}

				object.__webglMorphTargetInfluences[m] = influences[order[m]];
				m ++;
			}
		} else {
			// find the most influencing
			var influence, activeInfluenceIndices = [];
			var influences = object.morphTargetInfluences;

			for (i in 0...influences.length) {
				influence = influences[i];
				if (influence > 0) {
					activeInfluenceIndices.push([influence, i]);
				}
			}

			if (activeInfluenceIndices.length > Reflect.field(material, "numSupportedMorphTargets")) {
				activeInfluenceIndices.sort(numericalSort);
				//activeInfluenceIndices.length = Reflect.field(material, "numSupportedMorphTargets");
			} else if (activeInfluenceIndices.length > material.numSupportedMorphNormals) {
				activeInfluenceIndices.sort(numericalSort);
			} else if (activeInfluenceIndices.length == 0) {
				activeInfluenceIndices.push([0, 0]);
			}

			var influenceIndex:Int, m:Int = 0;

			while (m < Reflect.field(material, "numSupportedMorphTargets")) {
				if (activeInfluenceIndices[m] != null) {
					influenceIndex = activeInfluenceIndices[m][1];
					if (attributes.get("morphTarget" + m) >= 0) {
						GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[influenceIndex]);
						enableAttribute(attributes.get("morphTarget" + m));
						GL.vertexAttribPointer(attributes.get("morphTarget" + m), 3, GL.FLOAT, false, 0, 0);
					}

					if (attributes.get("morphNormal" + m) >= 0 && material.morphNormals) {
						GL.bindBuffer(GL.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[influenceIndex]);
						enableAttribute(attributes.get("morphNormal" + m));
						GL.vertexAttribPointer(attributes.get("morphNormal" + m), 3, GL.FLOAT, false, 0, 0);
					}

					object.__webglMorphTargetInfluences[m] = influences[influenceIndex];
				} else {
					/*
					GL.vertexAttribPointer(attributes[ "morphTarget" + m ], 3, GL.FLOAT, false, 0, 0);

					if (material.morphNormals) {

						GL.vertexAttribPointer(attributes[ "morphNormal" + m ], 3, GL.FLOAT, false, 0, 0);

					}
					*/

					object.__webglMorphTargetInfluences[m] = 0;
				}
				m++;
			}
		}

		// load updated influences uniform
		if (material.program.uniforms.morphTargetInfluences != null) {
			GL.uniform1fv(material.program.uniforms.morphTargetInfluences, cast object.__webglMorphTargetInfluences);
		}
	}

	// Sorting
	function painterSortStable(a:Dynamic, b:Dynamic):Int {
		if (a.z != b.z) {
			return Std.int(b.z - a.z);
		} else {
			return Std.int(a.id - b.id);
		}
	}

	function numericalSort(a, b):Int {
		return b[0] - a[0];
	}

	// Rendering
	public function render(scene:Scene, camera:Camera, renderTarget:WebGLRenderTarget = null, forceClear:Bool = null) {
		if (Std.is(camera, Camera) == false) {
			trace("THREE.WebGLRenderer.render: camera is not an instance of THREE.Camera.");
			return;
		}
		
		trace("render");

		var	webglObject, object, renderList;

		var lights = scene.__lights;
		var fog = scene.fog;

		// reset caching for this frame
		_currentMaterialId = -1;
		_lightsNeedUpdate = true;

		// update scene graph
		if (scene.autoUpdate == true) scene.updateMatrixWorld();

		// update camera matrices and frustum
		if (camera.parent == null) camera.updateMatrixWorld();
		
		trace(scene);
		trace(camera);

		camera.matrixWorldInverse.getInverse(camera.matrixWorld);

		_projScreenMatrix.multiplyMatrices(camera.projectionMatrix, camera.matrixWorldInverse);
		_frustum.setFromMatrix(_projScreenMatrix);

		// update WebGL objects
		if (this.autoUpdateObjects) this.initWebGLObjects(scene);

		// custom render plugins (pre pass)
		renderPlugins(this.renderPluginsPre, scene, camera);

		//

		this.info.render.calls = 0;
		this.info.render.vertices = 0;
		this.info.render.faces = 0;
		this.info.render.points = 0;

		this.setRenderTarget(renderTarget);

		if (this.autoClear || forceClear) {
			this.clear(this.autoClearColor, this.autoClearDepth, this.autoClearStencil);
		}

		// set matrices for regular objects (frustum culled)
		renderList = scene.__webglObjects;
		for (i in 0...renderList.length) {
			webglObject = renderList[i];
			object = webglObject.object;

			webglObject.id = i;
			webglObject.render = false;

			if (object.visible) {
				if (! (Std.is(object, Mesh) || Std.is(object, ParticleSystem)) || ! (object.frustumCulled) || _frustum.intersectsObject(object)) {
					setupMatrices(object, camera);
					unrollBufferMaterial(webglObject);

					webglObject.render = true;
					if (this.sortObjects == true) {
						if (object.renderDepth != null) {
							webglObject.z = object.renderDepth;
						} else {
							_vector3.setFromMatrixPosition(object.matrixWorld);
							_vector3.applyProjection(_projScreenMatrix);
							webglObject.z = _vector3.z;
						}
					}
				}
			}
		}

		if (this.sortObjects) {
			renderList.sort(painterSortStable);
		}

		// set matrices for immediate objects
		renderList = scene.__webglObjectsImmediate;

		for (i in 0...renderList.length) {
			webglObject = renderList[i];
			object = webglObject.object;

			if (object.visible) {
				setupMatrices(object, camera);

				unrollImmediateBufferMaterial(webglObject);
			}
		}

		if (scene.overrideMaterial != null) {
			var material = scene.overrideMaterial;

			this.setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);
			this.setDepthTest(cast material.depthTest);
			this.setDepthWrite(cast material.depthWrite);
			setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);

			renderObjects(scene.__webglObjects, false, "", camera, lights, fog, true, material);
			renderObjectsImmediate(scene.__webglObjectsImmediate, "", camera, lights, fog, false, material);
		} else {
			var material = null;
			// opaque pass (front-to-back order)
			this.setBlending(THREE.NoBlending);

			renderObjects(scene.__webglObjects, true, "opaque", camera, lights, fog, false, material);
			renderObjectsImmediate(scene.__webglObjectsImmediate, "opaque", camera, lights, fog, false, material);
			// transparent pass (back-to-front order)
			renderObjects(scene.__webglObjects, false, "transparent", camera, lights, fog, true, material);
			renderObjectsImmediate(scene.__webglObjectsImmediate, "transparent", camera, lights, fog, true, material);
		}

		// custom render plugins (post pass)
		renderPlugins(this.renderPluginsPost, scene, camera);

		// Generate mipmap if we're using any kind of mipmap filtering
		if (renderTarget != null && renderTarget.generateMipmaps && renderTarget.minFilter != THREE.NearestFilter && renderTarget.minFilter != THREE.LinearFilter) {
			updateRenderTargetMipmap(renderTarget);
		}

		// Ensure depth buffer writing is enabled so it can be cleared on next render
		this.setDepthTest(1/*true*/);
		this.setDepthWrite(1/*true*/);
		// GL.finish();
		trace("render OK");
	}

	function renderPlugins(plugins:Array<Dynamic>, scene:Scene, camera:Camera) {
		if (plugins.length == 0) return;

		for (i in 0...plugins.length) {
			// reset state for plugin (to start from clean slate)
			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = -1;
			_oldDepthWrite = -1;
			_oldDoubleSided = -1;
			_oldFlipSided = -1;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

			plugins[i].render(scene, camera, _currentWidth, _currentHeight);

			// reset state after plugin (anything could have changed)
			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = -1;
			_oldDepthWrite = -1;
			_oldDoubleSided = -1;
			_oldFlipSided = -1;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;
		}
	}

	function renderObjects(renderList:Array<ThreeGLObject>, reverse:Bool, materialType:Dynamic, camera:Camera, lights:Array<Light>, fog:Fog, useBlending:Bool, overrideMaterial:Material = null) {
		var webglObject:Dynamic, object:Dynamic, buffer:Dynamic, material:Material, start:Int, end:Int, delta:Int;

		if (reverse) {
			start = renderList.length - 1;
			end = -1;
			delta = -1;
		} else {
			start = 0;
			end = renderList.length;
			delta = 1;		}

		var i:Int = start;
		while (i != end) {
			webglObject = renderList[i];
			trace(webglObject);
			if (webglObject.render) {
				object = webglObject.object;
				buffer = webglObject.buffer;

				if (overrideMaterial != null) {
					material = overrideMaterial;
				} else {
					trace(materialType);
					material = Reflect.field(webglObject, materialType);
					if (material == null) continue;

					if (useBlending) this.setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);

					this.setDepthTest(cast material.depthTest);
					this.setDepthWrite(cast material.depthWrite);
					setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);
				}

				this.setMaterialFaces(material);

				if (Std.is(buffer, BufferGeometry)) {
					this.renderBufferDirect(camera, lights, fog, material, buffer, object);
				} else {
					this.renderBuffer(camera, lights, fog, material, buffer, object);
				}
			}
			i += delta;
		}
	}

	function renderObjectsImmediate(renderList:Array<ThreeGLObject>, materialType:Dynamic, camera:Camera, lights:Array<Light>, fog:Fog, useBlending:Bool, overrideMaterial:Material = null) {

		var webglObject, object, material:Material;

		for (i in 0...renderList.length) {
			webglObject = renderList[i];
			object = webglObject.object;

			if (object.visible) {
				if (overrideMaterial != null) {
					material = overrideMaterial;
				} else {
					material = Reflect.field(webglObject, materialType);

					if (material == null) continue;

					if (useBlending) this.setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);

					this.setDepthTest(cast material.depthTest);
					this.setDepthWrite(cast material.depthWrite);
					setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);
				}

				this.renderImmediateObject(camera, lights, fog, material, cast object);
			}
		}
	}

	function renderImmediateObject(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, object:Object3D) {
		var program = setProgram(camera, lights, fog, material, object);
		_currentGeometryGroupHash = -1;
		this.setMaterialFaces(material);

		if (Reflect.field(object, "immediateRenderCallback") != null) {
			Reflect.callMethod(object, "immediateRenderCallback", [program, GL, _frustum]);
		} else {
			trace("renderImmediateObject");
			// TODO
			//object.render(function(object) { this.renderBufferImmediate(object, program, material); });
		}
	}
	
	function unrollImmediateBufferMaterial(globject:Dynamic) {
		var object = globject.object;
		var	material = object.material;

		if (material.transparent) {
			globject.transparent = material;
			globject.opaque = null;
		} else {
			globject.opaque = material;
			globject.transparent = null;
		}
	}

	function unrollBufferMaterial(globject:Dynamic) {
		var object = globject.object;
		var	buffer = globject.buffer;
		var	material, materialIndex, meshMaterial;

		meshMaterial = object.material;

		if (Std.is(meshMaterial, MeshFaceMaterial)) {
			materialIndex = buffer.materialIndex;
			material = meshMaterial.materials[materialIndex];

			if (material.transparent) {
				globject.transparent = material;
				globject.opaque = null;
			} else {
				globject.opaque = material;
				globject.transparent = null;
			}
		} else {
			material = meshMaterial;
			if (material != null) {
				if (material.transparent) {
					globject.transparent = material;
					globject.opaque = null;
				} else {
					globject.opaque = material;
					globject.transparent = null;
				}
			}
		}
	}
	
	// Geometry splitting
	function sortFacesByMaterial(geometry:Geometry, material:Material) {
		var face:Face3, materialIndex:Int, vertices:Int;
		var	groupHash:String, hash_map:Map<Int, { hash: Int, counter: Int }> = new Map();

		var numMorphTargets = geometry.morphTargets.length;
		var numMorphNormals = geometry.morphNormals.length;

		var usesFaceMaterial = Std.is(material, MeshFaceMaterial);

		geometry.geometryGroups = new Map<String, Geometry>();

		for (f in 0...geometry.faces.length) {
			face = geometry.faces[f];
			materialIndex = usesFaceMaterial ? face.materialIndex : 0;

			if (!hash_map.exists(materialIndex)) {
				hash_map.set(materialIndex, { hash: materialIndex, counter: 0 });
			}

			groupHash = hash_map.get(materialIndex).hash + "_" + hash_map.get(materialIndex).counter;

			if (!geometry.geometryGroups.exists(groupHash)) {
				var __g:Geometry = new Geometry();
				__g.faces3 = [];
				__g.materialIndex = materialIndex;
				__g.numMorphTargets = numMorphTargets;
				__g.numMorphNormals = numMorphNormals;
				__g.vertices = null;
				geometry.geometryGroups.set(groupHash, __g);
			}

			vertices = 3;

			if (geometry.geometryGroups.get(groupHash)._vertices + vertices > 65535) {
				hash_map.get(materialIndex).counter += 1;
				groupHash = hash_map.get(materialIndex).hash + "_" + hash_map.get(materialIndex).counter;
				if (geometry.geometryGroups.get(groupHash) == null) {
					var __g:Geometry = new Geometry();
					__g.faces3 = [];
					__g.materialIndex = materialIndex;
					__g.numMorphTargets = numMorphTargets;
					__g.numMorphNormals = numMorphNormals;
					__g.vertices = null;
					geometry.geometryGroups.set(groupHash, __g);
				}
			}

			geometry.geometryGroups.get(groupHash).faces3.push(f);
			geometry.geometryGroups.get(groupHash)._vertices += vertices;
		}

		geometry.geometryGroupsList = [];
		for (g in geometry.geometryGroups.keys()) {
			geometry.geometryGroups.get(g).id = _geometryGroupCounter++;
			geometry.geometryGroupsList.push(geometry.geometryGroups.get(g));
		}
	}

	// Objects refresh
	function initWebGLObjects(scene:Scene) {
		if (scene.__webglObjects == null) {
			scene.__webglObjects = [];
			scene.__webglObjectsImmediate = [];
			scene.__webglSprites = [];
			scene.__webglFlares = [];
		}

		while (scene.__objectsAdded.length > 0) {
			addObject(scene.__objectsAdded[0], scene);
			scene.__objectsAdded.splice(0, 1);
		}

		while (scene.__objectsRemoved.length > 0) {
			removeObject(scene.__objectsRemoved[0], scene);
			scene.__objectsRemoved.splice(0, 1);
		}

		// update must be called after objects adding / removal
		for (o in 0...scene.__webglObjects.length) {
			var object = scene.__webglObjects[o].object;

			// TODO: Remove this hack (WebGLRenderer refactoring)
			if (object.__webglInit == false) {
				if (object.__webglActive != false) {
					removeObject(object, scene);
				}

				addObject(object, scene);
			}

			updateObject(object);
		}
	}

	// Objects adding
	function addObject(object:Object3D, scene:Scene) {
		var geometry:Geometry, material:Material, geometryGroup:Geometry = null;

		if (object.__webglInit == false) {
			object.__webglInit = true;

			object._modelViewMatrix = new Matrix4();
			object._normalMatrix = new Matrix3();

			if (object.geometry != null && (object.geometry.__webglInit == false)) {
				object.geometry.__webglInit = true;
				//object.geometry.addEventListener("dispose", onGeometryDispose);
			}

			geometry = object.geometry;
			if (geometry == null) {
				// fail silently for now

			} else if (Std.is(geometry, BufferGeometry)) {
				initDirectBuffers(geometry);

			} else if (Std.is(object, Mesh)) {
				material = Reflect.field(object, "material");

				if (geometry.geometryGroups == null) {
					sortFacesByMaterial(geometry, material);
				}

				// create separate VBOs per geometry chunk
				for (g in geometry.geometryGroups.keys()) {
					geometryGroup = geometry.geometryGroups.get(g);

					// initialise VBO on the first access
					if (geometryGroup.__webglVertexBuffer == null) {
						createMeshBuffers(geometryGroup);
						initMeshBuffers(geometryGroup, cast object);

						geometry.verticesNeedUpdate = true;
						geometry.morphTargetsNeedUpdate = true;
						geometry.elementsNeedUpdate = true;
						geometry.uvsNeedUpdate = true;
						geometry.normalsNeedUpdate = true;
						geometry.tangentsNeedUpdate = true;
						geometry.colorsNeedUpdate = true;
					}
				}
			} else if (Std.is(object, Line)) {
				if (geometryGroup.__webglVertexBuffer == null) {
					createLineBuffers(geometry);
					initLineBuffers(geometry, cast object);

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;
					geometry.lineDistancesNeedUpdate = true;
				}
			} else if (Std.is(object, ParticleSystem)) {
				if (geometryGroup.__webglVertexBuffer == null) {
					createParticleBuffers(geometry);
					initParticleBuffers(geometry, cast object);

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;
				}
			}
		}

		if (object.__webglActive == false) {
			if (Std.is(object, Mesh)) {
				geometry = object.geometry;

				if (Std.is(geometry, BufferGeometry)) {
					addBuffer(scene.__webglObjects, geometry, object);

				} else if (Std.is(geometry, Geometry)) {
					for (g in geometry.geometryGroups.keys()) {
						geometryGroup = geometry.geometryGroups.get(g);

						addBuffer(scene.__webglObjects, geometryGroup, object);
					}
				}
			} else if (Std.is(object, Line) || Std.is(object, ParticleSystem)) {
				geometry = object.geometry;
				addBuffer(scene.__webglObjects, geometry, object);

			} else if (Std.is(object, ImmediateRenderObject) || object.immediateRenderCallback != null) {
				addBufferImmediate(scene.__webglObjectsImmediate, object);

			} else if (Std.is(object, Sprite)) {
				scene.__webglSprites.push(object);

			} else if (Std.is(object, LensFlare)) {
				scene.__webglFlares.push(object);
			}

			object.__webglActive = true;
		}
	}

	function addBuffer(objlist:Array<ThreeGLObject>, buffer: Geometry/*BufferGeometryAttribute*/, object:Object3D) {
		objlist.push(
			{
				id: null,
				buffer: buffer,
				object: object,
				opaque: null,
				transparent: null,
				z: 0,
				__webglInit: null,
				__webglActive: null,
				_modelViewMatrix: null,
				_normalMatrix: null,
				_normalMatrixArray: null,
				_modelViewMatrixArray: null,
				modelMatrixArray: null,
				__webglMorphTargetInfluences: null,
				render: null
			}
		);
	}

	function addBufferImmediate(objlist:Array<ThreeGLObject>, object:Object3D) {
		objlist.push(
			{
				id: null,
				buffer: null,
				object: object,
				opaque: null,
				transparent: null,
				z: 0,
				__webglInit: null,
				__webglActive: null,
				_modelViewMatrix: null,
				_normalMatrix: null,
				_normalMatrixArray: null,
				_modelViewMatrixArray: null,
				modelMatrixArray: null,
				__webglMorphTargetInfluences: null,
				render: null
			}
		);
	}

	// Objects updates

	function updateObject(object:Object3D) {
		// TODO
		var geometry:Geometry = object.geometry,
			geometryGroup:Geometry, customAttributesDirty:Bool, material:Material;

		if (Std.is(geometry, BufferGeometry)) {
			setDirectBuffers(geometry, GL.DYNAMIC_DRAW, !geometry.isDynamic);

		} else if (Std.is(object, Mesh)) {
			// check all geometry groups
			for(i in 0...geometry.geometryGroupsList.length) {
				geometryGroup = geometry.geometryGroupsList[i];
				material = getBufferMaterial(cast object, geometryGroup);
				if (geometry.buffersNeedUpdate) {
					initMeshBuffers(geometryGroup, cast object);
				}

				customAttributesDirty = Reflect.field(material, "attributes") != null && areCustomAttributesDirty(cast material);

				if (geometry.verticesNeedUpdate || geometry.morphTargetsNeedUpdate || geometry.elementsNeedUpdate ||
					 geometry.uvsNeedUpdate || geometry.normalsNeedUpdate ||
					 geometry.colorsNeedUpdate || geometry.tangentsNeedUpdate || customAttributesDirty) {

					setMeshBuffers(geometryGroup, object, GL.DYNAMIC_DRAW, !geometry.isDynamic, material);
				}
			}

			geometry.verticesNeedUpdate = false;
			geometry.morphTargetsNeedUpdate = false;
			geometry.elementsNeedUpdate = false;
			geometry.uvsNeedUpdate = false;
			geometry.normalsNeedUpdate = false;
			geometry.colorsNeedUpdate = false;
			geometry.tangentsNeedUpdate = false;

			geometry.buffersNeedUpdate = false;

			if(Reflect.field(material, "attributes") != null) clearCustomAttributes(cast material);

		} else if (Std.is(object, Line)) {
			material = getBufferMaterial(object, geometry);

			customAttributesDirty = Reflect.field(material, "attributes") != null && areCustomAttributesDirty(cast material);

			if (geometry.verticesNeedUpdate || geometry.colorsNeedUpdate || geometry.lineDistancesNeedUpdate || customAttributesDirty) {
				setLineBuffers(geometry, GL.DYNAMIC_DRAW);
			}

			geometry.verticesNeedUpdate = false;
			geometry.colorsNeedUpdate = false;
			geometry.lineDistancesNeedUpdate = false;

			material.attributes && clearCustomAttributes(material);

		} else if (Std.is(object, ParticleSystem)) {
			material = getBufferMaterial(object, geometry);

			customAttributesDirty = Reflect.field(material, "attributes") != null && areCustomAttributesDirty(cast material);

			if (geometry.verticesNeedUpdate || geometry.colorsNeedUpdate || object.sortParticles || customAttributesDirty) {
				setParticleBuffers(geometry, GL.DYNAMIC_DRAW, object);
			}

			geometry.verticesNeedUpdate = false;
			geometry.colorsNeedUpdate = false;

			material.attributes && clearCustomAttributes(material);
		}
	}

	// Objects updates - custom attributes check
	function areCustomAttributesDirty(material:ShaderMaterial):Bool {
		for (a in material.attributes.keys()) {
			if (material.attributes.get(a).needsUpdate) return true;
		}

		return false;
	}

	function clearCustomAttributes(material:ShaderMaterial) {
		for (a in material.attributes.keys()) {
			material.attributes.get(a).needsUpdate = false;
		}
	}

	// Objects removal
	function removeObject(object:Object3D, scene:Scene) {
		// TODO
		/*if (object instanceof THREE.Mesh  ||
			 object instanceof THREE.ParticleSystem ||
			 object instanceof THREE.Line) {

			removeInstances(scene.__webglObjects, object);

		} else if (object instanceof THREE.Sprite) {

			removeInstancesDirect(scene.__webglSprites, object);

		} else if (object instanceof THREE.LensFlare) {

			removeInstancesDirect(scene.__webglFlares, object);

		} else if (object instanceof THREE.ImmediateRenderObject || object.immediateRenderCallback) {

			removeInstances(scene.__webglObjectsImmediate, object);

		}

		delete object.__webglActive;*/

	}

	function removeInstances(objlist:Array<Object3D>, object:Object3D) {
		// TODO
		/*for (var o = objlist.length - 1; o >= 0; o --) {

			if (objlist[ o ].object == object) {

				objlist.splice(o, 1);

			}

		}*/

	}

	function removeInstancesDirect(objlist:Array<Object3D>, object:Object3D) {
		// TODO
		/*for (var o = objlist.length - 1; o >= 0; o --) {

			if (objlist[ o ] == object) {

				objlist.splice(o, 1);

			}

		}*/

	}

	// Materials
	function initMaterial(material:Material, lights:Array<Light>, fog:Fog, object:Object3D) {		
		//material.addEventListener("dispose", onMaterialDispose);

		var u, a, identifiers, i, parameters:Dynamic, maxLightCount:Dynamic, maxBones:Int, maxShadows:Int, shaderID:String = "";

		if (Std.is(material, MeshDepthMaterial)) {
			shaderID ="depth";

		} else if (Std.is(material, MeshNormalMaterial)) {
			shaderID ="normal";

		} else if (Std.is(material, MeshBasicMaterial)) {
			shaderID ="basic";

		} else if (Std.is(material, MeshLambertMaterial)) {
			shaderID ="lambert";

		} else if (Std.is(material, MeshPhongMaterial)) {
			shaderID ="phong";

		} else if (Std.is(material, LineBasicMaterial)) {
			shaderID ="basic";

		} else if (Std.is(material, LineDashedMaterial)) {
			shaderID ="dashed";

		} else if (Std.is(material, ParticleSystemMaterial)) {
			shaderID ="particle_basic";
		}

		if (shaderID != "") {
			setMaterialShaders(cast material, Reflect.field(ShaderLib, shaderID));
		}

		// heuristics to create shader parameters according to lights in the scene
		// (not to blow over maxLights budget)
		maxLightCount = allocateLights(lights);
		maxShadows = allocateShadows(lights);
		maxBones = allocateBones(object);

		parameters = {

			map: Reflect.field(material, "map"),
			envMap: Reflect.field(material, "envMap"),
			lightMap: Reflect.field(material, "lightMap"),
			bumpMap: Reflect.field(material, "bumpMap"),
			normalMap: Reflect.field(material, "normalMap"),
			specularMap: Reflect.field(material, "specularMap"),

			vertexColors: material.vertexColors,

			fog: fog,
			useFog: Reflect.field(material, "fog"),
			fogExp: Std.is(fog, FogExp2),

			sizeAttenuation: Reflect.field(material, "sizeAttenuation"),

			skinning: Reflect.field(material, "skinning"),
			maxBones: maxBones,
			useVertexTexture: _supportsBoneTextures && Reflect.field(object, "useVertexTexture") != null && Reflect.field(object, "useVertexTexture") != false,

			morphTargets: Reflect.field(material, "morphTargets"),
			morphNormals: Reflect.field(material, "morphNormals"),
			maxMorphTargets: this.maxMorphTargets,
			maxMorphNormals: this.maxMorphNormals,

			maxDirLights: Reflect.field(material, "directional"),
			maxPointLights: Reflect.field(material, "point"),
			maxSpotLights: Reflect.field(material, "spot"),
			maxHemiLights: Reflect.field(material, "hemi"),

			maxShadows: maxShadows,
			shadowMapEnabled: this.shadowMapEnabled && object.receiveShadow,
			shadowMapType: this.shadowMapType,
			shadowMapDebug: this.shadowMapDebug,
			shadowMapCascade: this.shadowMapCascade,

			alphaTest: material.alphaTest,
			metal: Reflect.field(material, "metal"),
			perPixel: Reflect.field(material, "perPixel"),
			wrapAround: Reflect.field(material, "wrapAround"),
			doubleSided: material.side == THREE.DoubleSide,
			flipSided: material.side == THREE.BackSide
		};

		material.program = buildProgram(shaderID, Reflect.field(material, "fragmentShader"), Reflect.field(material, "vertexShader"), Reflect.field(material, "uniforms"), Reflect.field(material, "attributes"), Reflect.field(material, "defines"), parameters, Reflect.field(material, "index0AttributeName"));

		var attributes = material.program.attributes;

		if (material.morphTargets != null) {
			Reflect.setField(material, "numSupportedMorphTargets", 0);

			var id, base = "morphTarget";
			for (i in 0...this.maxMorphTargets) {
				id = base + i;

				if (attributes.get(id) >= 0) {
					Reflect.setField(material, "numSupportedMorphTargets", Reflect.field(material, "numSupportedMorphTargets") + 1);
				}
			}
		}

		if (material.morphNormals) {
			material.numSupportedMorphNormals = 0;

			var id, base = "morphNormal";
			for (i in 0...this.maxMorphNormals) {
				id = base + i;

				if (attributes.get(id) >= 0) {
					material.numSupportedMorphNormals ++;
				}
			}
		}

		// TODO
		/*material.uniformsList = [];

		for (u in material.uniforms) {
			material.uniformsList.push([ material.uniforms[ u ], u ]);
		}*/
	}

	function setMaterialShaders(material:ShaderMaterial, shaders:ShaderLibDesc) {
		material.uniforms = UniformsUtils.clone(shaders.uniforms);
		material.vertexShader = shaders.vertexShader;
		material.fragmentShader = shaders.fragmentShader;
	}

	function setProgram(camera:Camera, lights:Array<Light>, fog:Fog, material:Material, object:Object3D):ThreeGLProgram {
		_usedTextureUnits = 0;

		if (material.needsUpdate) {
			if (material.program != null) deallocateMaterial(material);

			this.initMaterial(material, lights, fog, object);
			material.needsUpdate = false;
		}

		if (material.morphTargets) {
			if (Reflect.field(object, "__webglMorphTargetInfluences") == null) {
				Reflect.setField(object, "__webglMorphTargetInfluences", new Float32Array(this.maxMorphTargets));
			}
		}

		var refreshMaterial = false;

		var program:ThreeGLProgram = material.program;
		var	p_uniforms = program.program.uniforms;
		var	m_uniforms = Reflect.field(material, "uniforms");

		if (program.program != _currentProgram) {
			GL.useProgram(program.program);
			_currentProgram = program.program;
			refreshMaterial = true;
		}

		if (material.id != _currentMaterialId) {
			_currentMaterialId = material.id;
			refreshMaterial = true;
		}

		if (refreshMaterial || camera != _currentCamera) {
			GL.uniformMatrix4fv(p_uniforms.projectionMatrix, false, cast camera.projectionMatrix.elements);
			if (camera != _currentCamera) _currentCamera = camera;
		}

		// skinning uniforms must be set even if material didn't change
		// auto-setting of texture unit for bone texture must go before other textures
		// not sure why, but otherwise weird things happen
		if (Reflect.field(material, "skinning") != null) {
			if (_supportsBoneTextures && Reflect.field(object, "useVertexTexture")) {
				if (p_uniforms.boneTexture != null) {
					var textureUnit = getTextureUnit();

					GL.uniform1i(p_uniforms.boneTexture, textureUnit);
					this.setTexture(Reflect.field(object, "boneTexture"), textureUnit);
				}

				if (p_uniforms.boneTextureWidth != null) {
					GL.uniform1i(p_uniforms.boneTextureWidth, Reflect.field(object, "boneTextureWidth"));
				}

				if (p_uniforms.boneTextureHeight != null) {
					GL.uniform1i(p_uniforms.boneTextureHeight, Reflect.field(object, "boneTextureHeight"));
				}
			} else {
				if (p_uniforms.boneGlobalMatrices != null) {
					GL.uniformMatrix4fv(p_uniforms.boneGlobalMatrices, false, Reflect.field(object, "boneMatrices"));
				}
			}
		}

		if (refreshMaterial) {
			// refresh uniforms common to several materials
			if (fog != null && Reflect.field(material, "fog") != null) {
				refreshUniformsFog(m_uniforms, fog);
			}

			if (Std.is(material, MeshPhongMaterial) ||
				Std.is(material, MeshLambertMaterial) ||
				Reflect.hasField(material, "lights")) {

				if (_lightsNeedUpdate) {
					setupLights(program, lights);
					_lightsNeedUpdate = false;
				}

				refreshUniformsLights(m_uniforms, _lights);
			}

			if (Std.is(material, MeshBasicMaterial) ||
				Std.is(material, MeshLambertMaterial) ||
				Std.is(material, MeshPhongMaterial)) {

				refreshUniformsCommon(m_uniforms, material);
			}

			// refresh single material specific uniforms
			if (Std.is(material, LineBasicMaterial)) {
				refreshUniformsLine(m_uniforms, cast material);

			} else if (Std.is(material, LineDashedMaterial)) {
				refreshUniformsLine(m_uniforms, cast material);
				refreshUniformsDash(m_uniforms, cast material);

			} else if (Std.is(material, ParticleSystemMaterial)) {
				refreshUniformsParticle(m_uniforms, cast material);

			} else if (Std.is(material, MeshPhongMaterial)) {
				refreshUniformsPhong(m_uniforms, cast material);

			} else if (Std.is(material, MeshLambertMaterial)) {
				refreshUniformsLambert(m_uniforms, cast material);

			} else if (Std.is(material, MeshDepthMaterial)) {
				m_uniforms.mNear.value = Reflect.field(camera, "near");
				m_uniforms.mFar.value = Reflect.field(camera, "far");
				m_uniforms.opacity.value = material.opacity;

			} else if (Std.is(material, MeshNormalMaterial)) {
				m_uniforms.opacity.value = material.opacity;
			}

			if (object.receiveShadow && Reflect.field(material, "_shadowPass") != null) {
				refreshUniformsShadow(m_uniforms, lights);
			}

			// load common uniforms
			loadUniformsGeneric(program, Reflect.field(material, "uniformsList"));

			// load material specific uniforms
			// (shader material also gets them for the sake of genericity)
			if (Std.is(material, ShaderMaterial) ||
				Std.is(material, MeshPhongMaterial) ||
				Reflect.hasField(material, "envMap")) {

				if (p_uniforms.cameraPosition != null) {
					_vector3.setFromMatrixPosition(camera.matrixWorld);
					GL.uniform3f(p_uniforms.cameraPosition, _vector3.x, _vector3.y, _vector3.z);
				}
			}

			if (Std.is(material, MeshPhongMaterial) ||
				Std.is(material, MeshLambertMaterial) ||
				Std.is(material, ShaderMaterial) ||
				Reflect.hasField(material, "skinning")) {

				if (p_uniforms.viewMatrix != null) {
					GL.uniformMatrix4fv(p_uniforms.viewMatrix, false, cast camera.matrixWorldInverse.elements);
				}
			}
		}

		loadUniformsMatrices(p_uniforms, object);

		if (p_uniforms.modelMatrix != null) {
			GL.uniformMatrix4fv(p_uniforms.modelMatrix, false, cast object.matrixWorld.elements);
		}

		return program;
	}

	// Uniforms (refresh uniforms objects)
	function refreshUniformsCommon(uniforms:Dynamic, material:Material) {		// TODO: is this MeshPhongMaterial ?
		uniforms.opacity.value = material.opacity;

		if (this.gammaInput) {
			uniforms.diffuse.value.copyGammaToLinear(Reflect.field(material, "color"));
		} else {
			uniforms.diffuse.value = Reflect.field(material, "color");
		}

		uniforms.map.value = Reflect.field(material, "map");
		uniforms.lightMap.value = Reflect.field(material, "lightMap");
		uniforms.specularMap.value = Reflect.field(material, "specularMap");

		if (Reflect.field(material, "bumpMap")) {
			uniforms.bumpMap.value = Reflect.field(material, "bumpMap");
			uniforms.bumpScale.value = Reflect.field(material, "bumpScale");
		}

		if (Reflect.field(material, "normalMap")) {
			uniforms.normalMap.value = Reflect.field(material, "normalMap");
			uniforms.normalScale.value.copy(Reflect.field(material, "normalScale"));
		}

		// uv repeat and offset setting priorities
		//	1. color map
		//	2. specular map
		//	3. normal map
		//	4. bump map

		var uvScaleMap = null;

		if (Reflect.hasField(material, "map")) {
			uvScaleMap = Reflect.field(material, "map");
		} else if (Reflect.hasField(material, "specularMap")) {
			uvScaleMap = Reflect.field(material, "specularMap");
		} else if (Reflect.hasField(material, "normalMap")) {
			uvScaleMap = Reflect.field(material, "normalMap");
		} else if (Reflect.hasField(material, "bumpMap")) {
			uvScaleMap = Reflect.field(material, "bumpMap");
		}

		if (uvScaleMap != null) {
			var offset = uvScaleMap.offset;
			var repeat = uvScaleMap.repeat;

			uniforms.offsetRepeat.value.set(offset.x, offset.y, repeat.x, repeat.y);
		}

		uniforms.envMap.value = Reflect.field(material, "envMap");
		uniforms.flipEnvMap.value = Std.is(Reflect.field(material, "envMap"), WebGLRenderTargetCube) ? 1 : -1;

		if (this.gammaInput) {
			//uniforms.reflectivity.value = material.reflectivity * material.reflectivity;
			uniforms.reflectivity.value = Reflect.field(material, "reflectivity");
		} else {
			uniforms.reflectivity.value = Reflect.field(material, "reflectivity");
		}

		uniforms.refractionRatio.value = Reflect.field(material, "refractionRatio");
		uniforms.combine.value = Reflect.field(material, "combine");
		uniforms.useRefract.value = Reflect.field(material, "envMap") != null && Std.is(Reflect.field(material, "envMap").mapping, THREE.CubeRefractionMapping);
	}
	
	function refreshUniformsLine(uniforms:Dynamic, material:LineBasicMaterial) {
		uniforms.diffuse.value = material.color;
		uniforms.opacity.value = material.opacity;
	}

	function refreshUniformsDash(uniforms:Dynamic, material:LineDashedMaterial) {
		uniforms.dashSize.value = material.dashSize;
		uniforms.totalSize.value = material.dashSize + material.gapSize;
		uniforms.scale.value = material.scale;
	}

	function refreshUniformsParticle(uniforms:Dynamic, material:ParticleSystemMaterial) {
		uniforms.psColor.value = material.color;
		uniforms.opacity.value = material.opacity;
		uniforms.size.value = material.size;
		uniforms.scale.value = _canvas.height / 2.0; // TODO: Cache this.

		uniforms.map.value = material.map;
	}

	function refreshUniformsFog (uniforms:Dynamic, fog:Fog) {
		uniforms.fogColor.value = fog.color;

		if (Std.is(fog, Fog)) {
			uniforms.fogNear.value = fog.near;
			uniforms.fogFar.value = fog.far;
		} else if (Std.is(fog, FogExp2)) {
			uniforms.fogDensity.value = Reflect.field(fog, "density");
		}
	}

	function refreshUniformsPhong (uniforms:Dynamic, material:MeshPhongMaterial) {
		uniforms.shininess.value = material.shininess;

		if (this.gammaInput) {
			uniforms.ambient.value.copyGammaToLinear(material.ambient);
			uniforms.emissive.value.copyGammaToLinear(material.emissive);
			uniforms.specular.value.copyGammaToLinear(material.specular);
		} else {
			uniforms.ambient.value = material.ambient;
			uniforms.emissive.value = material.emissive;
			uniforms.specular.value = material.specular;
		}

		if (material.wrapAround) {
			uniforms.wrapRGB.value.copy(material.wrapRGB);
		}
	}

	function refreshUniformsLambert(uniforms:Dynamic, material:MeshLambertMaterial) {
		if (this.gammaInput) {
			uniforms.ambient.value.copyGammaToLinear(material.ambient);
			uniforms.emissive.value.copyGammaToLinear(material.emissive);
		} else {
			uniforms.ambient.value = material.ambient;
			uniforms.emissive.value = material.emissive;
		}

		if (material.wrapAround) {
			uniforms.wrapRGB.value.copy(material.wrapRGB);
		}
	}

	function refreshUniformsLights(uniforms:Dynamic, lights:Lights) {
		uniforms.ambientLightColor.value = lights.ambient;

		uniforms.directionalLightColor.value = lights.directional.colors;
		uniforms.directionalLightDirection.value = lights.directional.positions;

		uniforms.pointLightColor.value = lights.point.colors;
		uniforms.pointLightPosition.value = lights.point.positions;
		uniforms.pointLightDistance.value = lights.point.distances;

		uniforms.spotLightColor.value = lights.spot.colors;
		uniforms.spotLightPosition.value = lights.spot.positions;
		uniforms.spotLightDistance.value = lights.spot.distances;
		uniforms.spotLightDirection.value = lights.spot.directions;
		uniforms.spotLightAngleCos.value = lights.spot.anglesCos;
		uniforms.spotLightExponent.value = lights.spot.exponents;

		uniforms.hemisphereLightSkyColor.value = lights.hemi.skyColors;
		uniforms.hemisphereLightGroundColor.value = lights.hemi.groundColors;
		uniforms.hemisphereLightDirection.value = lights.hemi.positions;
	}

	function refreshUniformsShadow (uniforms:Dynamic, lights:Array<Light>) {
		if (uniforms.shadowMatrix != null) {
			var j = 0;
			for (i in 0...lights.length) {
				var light = lights[i];

				if (/*light.castShadow != null && */light.castShadow) {
					if (Std.is(light, SpotLight) || (Std.is(light, DirectionalLight) && Reflect.field(light, "shadowCascade") != null)) {
						uniforms.shadowMap.value[j] = Reflect.field(light, "shadowMap");
						uniforms.shadowMapSize.value[j] = Reflect.field(light, "shadowMapSize");

						uniforms.shadowMatrix.value[j] = Reflect.field(light, "shadowMatrix");

						uniforms.shadowDarkness.value[j] = Reflect.field(light, "shadowDarkness");
						uniforms.shadowBias.value[j] = Reflect.field(light, "shadowBias");

						j++;
					}
				}
			}
		}
	}

	// Uniforms (load to GPU)
	function loadUniformsMatrices(uniforms:Dynamic, object:Object3D) {
		GL.uniformMatrix4fv(uniforms.modelViewMatrix, false, cast object._modelViewMatrix.elements);

		if (uniforms.normalMatrix) {
			GL.uniformMatrix3fv(uniforms.normalMatrix, false, cast object._normalMatrix.elements);
		}
	}

	function getTextureUnit():Int {
		var textureUnit = _usedTextureUnits;

		if (textureUnit >= _maxTextures) {
			trace("WebGLRenderer: trying to use " + textureUnit + " texture units while this GPU supports only " + _maxTextures);
		}

		_usedTextureUnits += 1;

		return textureUnit;
	}

	function loadUniformsGeneric (program:Dynamic, uniforms:Dynamic) {
		var uniform, value, type, location, texture, textureUnit, i, il, j, jl, offset;

		for (j in 0...uniforms.length) {
			location = program.uniforms[uniforms[j][1]];
			if (location == null) continue;

			uniform = uniforms[j][0];

			type = uniform.type;
			value = uniform.value;

			if (type == "i") { // single integer
				GL.uniform1i(location, value);

			} else if (type == "f") { // single float
				GL.uniform1f(location, value);

			} else if (type == "v2") { // single THREE.Vector2
				GL.uniform2f(location, Reflect.field(value, "x"), Reflect.field(value, "y"));

			} else if (type == "v3") { // single THREE.Vector3
				GL.uniform3f(location, Reflect.field(value, "x"), Reflect.field(value, "y"),  Reflect.field(value, "z"));

			} else if (type == "v4") { // single THREE.Vector4
				GL.uniform4f(location,  Reflect.field(value, "x"),  Reflect.field(value, "y"),  Reflect.field(value, "z"),  Reflect.field(value, "w"));

			} else if (type == "c") { // single THREE.Color
				GL.uniform3f(location,  Reflect.field(value, "r"),  Reflect.field(value, "g"),  Reflect.field(value, "b"));

			} else if (type == "iv1") { // flat array of integers (JS or typed array)
				GL.uniform1iv(location, cast value);

			} else if (type == "iv") { // flat array of integers with 3 x N size (JS or typed array)
				GL.uniform3iv(location, cast value);

			} else if (type == "fv1") { // flat array of floats (JS or typed array)
				GL.uniform1fv(location, cast value);

			} else if (type == "fv") { // flat array of floats with 3 x N size (JS or typed array)
				GL.uniform3fv(location, cast value);

			} else if (type == "v2v") { // array of THREE.Vector2
				var _value_:Array<Vector2> = cast value;
				if (uniform._array == null) {
					uniform._array = new Float32Array(2 * _value_.length);
				}

				for (i in 0..._value_.length) {
					offset = i * 2;

					uniform._array[offset] 	   = _value_[i].x;
					uniform._array[offset + 1] = _value_[i].y;
				}

				GL.uniform2fv(location, cast uniform._array);

			} else if (type == "v3v") { // array of THREE.Vector3
				var _value_:Array<Vector3> = cast value;
				if (uniform._array == null) {
					uniform._array = new Float32Array(3 * _value_.length);
				}

				for (i in 0..._value_.length) {
					offset = i * 3;

					uniform._array[offset] 	   = _value_[i].x;
					uniform._array[offset + 1] = _value_[i].y;
					uniform._array[offset + 2] = _value_[i].z;
				}

				GL.uniform3fv(location, cast uniform._array);

			} else if (type == "v4v") { // array of THREE.Vector4
				var _value_:Array<Vector4> = cast value;
				if (uniform._array == null) {
					uniform._array = new Float32Array(4 * _value_.length);
				}

				for (i in 0..._value_.length) {
					offset = i * 4;

					uniform._array[offset] 	   = _value_[i].x;
					uniform._array[offset + 1] = _value_[i].y;
					uniform._array[offset + 2] = _value_[i].z;
					uniform._array[offset + 3] = _value_[i].w;
				}

				GL.uniform4fv(location, cast uniform._array);

			} else if (type == "m4") { // single THREE.Matrix4
				var _value_:Matrix4 = cast value;
				if (uniform._array == null) {
					uniform._array = new Float32Array(16);
				}

				_value_.flattenToArray(cast uniform._array);
				GL.uniformMatrix4fv(location, false, uniform._array);

			} else if (type == "m4v") { // array of THREE.Matrix4
				var _value_:Array<Matrix4> = cast value;
				if (uniform._array == null) {
					uniform._array = new Float32Array(16 * _value_.length);
				}

				for (i in 0..._value_.length) {
					_value_[i].flattenToArrayOffset(cast uniform._array, i * 16);
				}

				GL.uniformMatrix4fv(location, false, uniform._array);

			} 
			// TODO
			/*else if (type == "t") { // single THREE.Texture (2d or cube)
				texture = value;
				textureUnit = getTextureUnit();

				GL.uniform1i(location, textureUnit);

				if (texture != null) {
					if (Std.is(texture.image, Array) && texture.image.length == 6) {
						setCubeTexture(texture, textureUnit);
					} else if (Std.is(texture, WebGLRenderTargetCube)) {
						setCubeTextureDynamic(texture, textureUnit);
					} else {
						this.setTexture(texture, textureUnit);
					}
				}
			} else if (type == "tv") { // array of THREE.Texture (2d)
				if (uniform._array == null) {
					uniform._array = [];
				}

				for(i in 0...uniform.value.length) {
					uniform._array[i] = getTextureUnit();
				}

				GL.uniform1iv(location, uniform._array);

				for(i in 0...uniform.value.length) {
					texture = uniform.value[i];
					textureUnit = uniform._array[i];

					if (texture != null) {
						this.setTexture(texture, textureUnit);
					}					
				}
			}*/ else {
				trace("THREE.WebGLRenderer: Unknown uniform type:" + type);
			}
		}
	}

	function setupMatrices(object:Object3D, camera:Camera) {
		object._modelViewMatrix.multiplyMatrices(camera.matrixWorldInverse, object.matrixWorld);
		object._normalMatrix.getNormalMatrix(object._modelViewMatrix);
	}

	//

	function setColorGamma(array:Array<Float>, offset:Int, color:Color, intensitySq:Float) {
		array[offset]     = color.r * color.r * intensitySq;
		array[offset + 1] = color.g * color.g * intensitySq;
		array[offset + 2] = color.b * color.b * intensitySq;
	}

	function setColorLinear(array:Array<Float>, offset:Int, color:Color, intensity:Float) {
		array[offset]     = color.r * intensity;
		array[offset + 1] = color.g * intensity;
		array[offset + 2] = color.b * intensity;
	}

	function setupLights(program:Dynamic, lights:Array<Light>) {
		var light:Light, n;
		var r:Float = 0, g:Float = 0, b:Float = 0;
		var color:Color, skyColor:Color, groundColor:Color;
		var intensity:Float, intensitySq:Float;
		var distance;

		var zlights:Lights = _lights,

		dirColors = zlights.directional.colors,
		dirPositions = zlights.directional.positions,

		pointColors = zlights.point.colors,
		pointPositions = zlights.point.positions,
		pointDistances = zlights.point.distances,

		spotColors = zlights.spot.colors,
		spotPositions = zlights.spot.positions,
		spotDistances = zlights.spot.distances,
		spotDirections = zlights.spot.directions,
		spotAnglesCos = zlights.spot.anglesCos,
		spotExponents = zlights.spot.exponents,

		hemiSkyColors = zlights.hemi.skyColors,
		hemiGroundColors = zlights.hemi.groundColors,
		hemiPositions = zlights.hemi.positions,

		dirLength = 0,
		pointLength = 0,
		spotLength = 0,
		hemiLength = 0,

		dirCount = 0,
		pointCount = 0,
		spotCount = 0,
		hemiCount = 0,

		dirOffset = 0,
		pointOffset = 0,
		spotOffset = 0,
		hemiOffset = 0;

		for (l in 0...lights.length) {
			light = lights[l];

			if (Reflect.hasField(light, "onlyShadow") && Reflect.field(light, "onlyShadow") == true) continue;

			color = light.color;
			intensity = Reflect.field(light, "intensity");
			distance = Reflect.field(light, "distance");

			if (Std.is(light, AmbientLight)) {
				if (!light.visible) continue;

				if (this.gammaInput) {
					r += color.r * color.r;
					g += color.g * color.g;
					b += color.b * color.b;
				} else {
					r += color.r;
					g += color.g;
					b += color.b;
				}
			} else if (Std.is(light, DirectionalLight)) {

				dirCount += 1;

				if (! light.visible) continue;

				_direction.setFromMatrixPosition(light.matrixWorld);
				_vector3.setFromMatrixPosition(Reflect.field(light, "target").matrixWorld);
				_direction.sub(_vector3);
				_direction.normalize();

				// skip lights with null direction
				// these create troubles in OpenGL (making pixel black)
				if (_direction.x == 0 && _direction.y == 0 && _direction.z == 0) continue;

				dirOffset = dirLength * 3;

				dirPositions[ dirOffset ]     = _direction.x;
				dirPositions[ dirOffset + 1 ] = _direction.y;
				dirPositions[ dirOffset + 2 ] = _direction.z;

				if (this.gammaInput) {
					setColorGamma(dirColors, dirOffset, color, intensity * intensity);
				} else {
					setColorLinear(dirColors, dirOffset, color, intensity);
				}

				dirLength += 1;

			} else if (Std.is(light, PointLight)) {

				pointCount += 1;

				if (!light.visible) continue;

				pointOffset = pointLength * 3;

				if (this.gammaInput) {
					setColorGamma(pointColors, pointOffset, color, intensity * intensity);
				} else {
					setColorLinear(pointColors, pointOffset, color, intensity);
				}

				_vector3.setFromMatrixPosition(light.matrixWorld);

				pointPositions[pointOffset]     = _vector3.x;
				pointPositions[pointOffset + 1] = _vector3.y;
				pointPositions[pointOffset + 2] = _vector3.z;

				pointDistances[pointLength] = distance;

				pointLength += 1;

			} else if (Std.is(light, SpotLight)) {
				spotCount += 1;

				if (! light.visible) continue;

				spotOffset = spotLength * 3;

				if (this.gammaInput) {
					setColorGamma(spotColors, spotOffset, color, intensity * intensity);
				} else {
					setColorLinear(spotColors, spotOffset, color, intensity);
				}

				_vector3.setFromMatrixPosition(light.matrixWorld);

				spotPositions[spotOffset]     = _vector3.x;
				spotPositions[spotOffset + 1] = _vector3.y;
				spotPositions[spotOffset + 2] = _vector3.z;

				spotDistances[spotLength] = distance;

				_direction.copy(_vector3);
				_vector3.setFromMatrixPosition(Reflect.field(light, "target").matrixWorld);
				_direction.sub(_vector3);
				_direction.normalize();

				spotDirections[spotOffset]     = _direction.x;
				spotDirections[spotOffset + 1] = _direction.y;
				spotDirections[spotOffset + 2] = _direction.z;

				spotAnglesCos[spotLength] = Math.cos(Reflect.field(light, "angle"));
				spotExponents[spotLength] = Reflect.field(light, "exponent");

				spotLength += 1;

			} else if (Std.is(light, HemisphereLight)) {
				hemiCount += 1;

				if (!light.visible) continue;

				_direction.setFromMatrixPosition(light.matrixWorld);
				_direction.normalize();

				// skip lights with null direction
				// these create troubles in OpenGL (making pixel black)

				if (_direction.x == 0 && _direction.y == 0 && _direction.z == 0) continue;

				hemiOffset = hemiLength * 3;

				hemiPositions[hemiOffset]     = _direction.x;
				hemiPositions[hemiOffset + 1] = _direction.y;
				hemiPositions[hemiOffset + 2] = _direction.z;

				skyColor = light.color;
				groundColor = Reflect.field(light, "groundColor");

				if (this.gammaInput) {
					intensitySq = intensity * intensity;

					setColorGamma(hemiSkyColors, hemiOffset, skyColor, intensitySq);
					setColorGamma(hemiGroundColors, hemiOffset, groundColor, intensitySq);
				} else {
					setColorLinear(hemiSkyColors, hemiOffset, skyColor, intensity);
					setColorLinear(hemiGroundColors, hemiOffset, groundColor, intensity);
				}

				hemiLength += 1;
			}
		}

		// null eventual remains from removed lights
		// (this is to avoid if in shader)
		for (l in dirLength * 3...Std.int(Math.max(dirColors.length, dirCount * 3))) {
			dirColors[l] = 0.0;
		}
		for (l in pointLength * 3...Std.int(Math.max(pointColors.length, pointCount * 3))) {
			pointColors[l] = 0.0;
		}
		for (l in spotLength * 3...Std.int(Math.max(spotColors.length, spotCount * 3))) {
			spotColors[l] = 0.0;
		}
		for (l in hemiLength * 3...Std.int(Math.max(hemiSkyColors.length, hemiCount * 3))) {
			hemiSkyColors[l] = 0.0;
		}
		for (l in hemiLength * 3...Std.int(Math.max(hemiGroundColors.length, hemiCount * 3))) {
			hemiGroundColors[l] = 0.0;
		}

		zlights.directional.length = dirLength;
		zlights.point.length = pointLength;
		zlights.spot.length = spotLength;
		zlights.hemi.length = hemiLength;

		zlights.ambient[0] = r;
		zlights.ambient[1] = g;
		zlights.ambient[2] = b;
	}

	// GL state setting
	function setFaceCulling(cullFace:Int, frontFaceDirection:Int) {
		if (cullFace == THREE.CullFaceNone) {
			GL.disable(GL.CULL_FACE);
		} else {
			if (frontFaceDirection == THREE.FrontFaceDirectionCW) {
				GL.frontFace(GL.CW);
			} else {
				GL.frontFace(GL.CCW);
			}

			if (cullFace == THREE.CullFaceBack) {
				GL.cullFace(GL.BACK);
			} else if (cullFace == THREE.CullFaceFront) {
				GL.cullFace(GL.FRONT);
			} else {
				GL.cullFace(GL.FRONT_AND_BACK);
			}

			GL.enable(GL.CULL_FACE);
		}
	}

	function setMaterialFaces(material:Material) {
		var doubleSided = cast(material.side == THREE.DoubleSide, Int);
		var flipSided = cast(material.side == THREE.BackSide, Int);

		if (_oldDoubleSided != doubleSided) {
			if (doubleSided != 0) {
				GL.disable(GL.CULL_FACE);
			} else {
				GL.enable(GL.CULL_FACE);
			}

			_oldDoubleSided = doubleSided;
		}

		if (_oldFlipSided != flipSided) {
			if (flipSided != 0) {
				GL.frontFace(GL.CW);
			} else {
				GL.frontFace(GL.CCW);
			}

			_oldFlipSided = flipSided;
		}
	}

	public function setDepthTest(depthTest:Int) {
		if (_oldDepthTest != depthTest) {
			if (depthTest != 0) {		// TODO check
				GL.enable(GL.DEPTH_TEST);
			} else {
				GL.disable(GL.DEPTH_TEST);
			}

			_oldDepthTest = depthTest;
		}
	}

	public function setDepthWrite(depthWrite:Int) {
		if (_oldDepthWrite != depthWrite) {
			GL.depthMask(cast depthWrite);
			_oldDepthWrite = depthWrite;
		}
	}

	function setLineWidth(width:Float) {
		if (width != _oldLineWidth) {
			GL.lineWidth(width);
			_oldLineWidth = width;
		}
	}

	function setPolygonOffset(polygonoffset, factor, units) {
		if (_oldPolygonOffset != polygonoffset) {
			if (polygonoffset) {
				GL.enable(GL.POLYGON_OFFSET_FILL);
			} else {
				GL.disable(GL.POLYGON_OFFSET_FILL);
			}

			_oldPolygonOffset = polygonoffset;
		}

		if (polygonoffset && (_oldPolygonOffsetFactor != factor || _oldPolygonOffsetUnits != units)) {
			GL.polygonOffset(factor, units);

			_oldPolygonOffsetFactor = factor;
			_oldPolygonOffsetUnits = units;
		}
	}

	function setBlending(blending:Int, blendEquation:Int = null, blendSrc:Int = null, blendDst:Int = null) {
		if (blending != _oldBlending) {
			if (blending == THREE.NoBlending) {
				GL.disable(GL.BLEND);

			} else if (blending == THREE.AdditiveBlending) {
				GL.enable(GL.BLEND);
				GL.blendEquation(GL.FUNC_ADD);
				GL.blendFunc(GL.SRC_ALPHA, GL.ONE);

			} else if (blending == THREE.SubtractiveBlending) {
				// TODO: Find blendFuncSeparate() combination
				GL.enable(GL.BLEND);
				GL.blendEquation(GL.FUNC_ADD);
				GL.blendFunc(GL.ZERO, GL.ONE_MINUS_SRC_COLOR);

			} else if (blending == THREE.MultiplyBlending) {
				// TODO: Find blendFuncSeparate() combination
				GL.enable(GL.BLEND);
				GL.blendEquation(GL.FUNC_ADD);
				GL.blendFunc(GL.ZERO, GL.SRC_COLOR);

			} else if (blending == THREE.CustomBlending) {
				GL.enable(GL.BLEND);
				
			} else {
				GL.enable(GL.BLEND);
				GL.blendEquationSeparate(GL.FUNC_ADD, GL.FUNC_ADD);
				GL.blendFuncSeparate(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA, GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
			}

			_oldBlending = blending;
		}

		if (blending == THREE.CustomBlending) {
			if (blendEquation != _oldBlendEquation) {
				GL.blendEquation(paramThreeToGL(blendEquation));
				_oldBlendEquation = blendEquation;
			}

			if (blendSrc != _oldBlendSrc || blendDst != _oldBlendDst) {
				GL.blendFunc(paramThreeToGL(blendSrc), paramThreeToGL(blendDst));

				_oldBlendSrc = blendSrc;
				_oldBlendDst = blendDst;
			}
		} else {
			_oldBlendEquation = 0;
			_oldBlendSrc = 0;
			_oldBlendDst = 0;
		}
	}

	// Defines
	function generateDefines(defines:Map<String, String>):String {
		var value:String = "";
		var chunk:String = "";
		var chunks:String = "";

		for (d in defines.keys()) {
			value = defines.get(d);
			if (value != "") {
				chunk = "#define " + d + " " + value;
				chunks += chunk;
			}
		}

		return chunks;
	}

	// TODO: should return GLProgram ...
	// Shaders
	function buildProgram(shaderID:String, fragmentShader:String, vertexShader:String, uniforms:Map<String, ULTypeValue>, attributes:Array<String>, defines:Map<String, String>, parameters:Dynamic, index0AttributeName:String):ThreeGLProgram {
		var program:ThreeGLProgram = {
			id: null,
			program: null,//GLProgram,
			code: null,
			usedTimes: null,
			attributes: null,
			uniforms: null
		};
		var code:String = "";
		var chunks:Array<String> = [];

		// Generate code
		if (shaderID != null && shaderID != "") {
			chunks.push(shaderID);
		} else {
			chunks.push(fragmentShader);
			chunks.push(vertexShader);
		}

		for (d in defines.keys()) {
			chunks.push(d);
			chunks.push(defines.get(d));
		}

		for (p in Reflect.fields(parameters)) {
			chunks.push(p);
			chunks.push(Reflect.field(parameters, p));
		}

		for(chunk in chunks) {
			code += chunk;
		}

		// Check if code has been already compiled
		for (p in 0..._programs.length) {
			var programInfo:ThreeGLProgram = _programs[p];

			if (programInfo.code == code) {
				// trace("Code already compiled." /*: \n\n" + code*/);
				programInfo.usedTimes++;
				return programInfo.program;
			}
		}

		var shadowMapTypeDefine = "SHADOWMAP_TYPE_BASIC";

		if (parameters.shadowMapType == THREE.PCFShadowMap) {
			shadowMapTypeDefine = "SHADOWMAP_TYPE_PCF";
		} else if (parameters.shadowMapType == THREE.PCFSoftShadowMap) {
			shadowMapTypeDefine = "SHADOWMAP_TYPE_PCF_SOFT";
		}

		// trace("building new program ");
		//

		var customDefines:String = generateDefines(defines);
		//

		program.program = GL.createProgram();
		var prefix_vertex:String = 
			"precision " + _precision + " float;" +
			"precision " + _precision + " int;" +

			customDefines +

			(_supportsVertexTextures ? "#define VERTEX_TEXTURES" : "") +

			(this.gammaInput ? "#define GAMMA_INPUT" : "") +
			(this.gammaOutput ? "#define GAMMA_OUTPUT" : "") +
			(this.physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "") +

			"#define MAX_DIR_LIGHTS " + parameters.maxDirLights +
			"#define MAX_POINT_LIGHTS " + parameters.maxPointLights +
			"#define MAX_SPOT_LIGHTS " + parameters.maxSpotLights +
			"#define MAX_HEMI_LIGHTS " + parameters.maxHemiLights +

			"#define MAX_SHADOWS " + parameters.maxShadows +

			"#define MAX_BONES " + parameters.maxBones +

			(parameters.map ? "#define USE_MAP" : "") +
			(parameters.envMap ? "#define USE_ENVMAP" : "") +
			(parameters.lightMap ? "#define USE_LIGHTMAP" : "") +
			(parameters.bumpMap ? "#define USE_BUMPMAP" : "") +
			(parameters.normalMap ? "#define USE_NORMALMAP" : "") +
			(parameters.specularMap ? "#define USE_SPECULARMAP" : "") +
			(parameters.vertexColors ? "#define USE_COLOR" : "") +

			(parameters.skinning ? "#define USE_SKINNING" : "") +
			(parameters.useVertexTexture ? "#define BONE_TEXTURE" : "") +

			(parameters.morphTargets ? "#define USE_MORPHTARGETS" : "") +
			(parameters.morphNormals ? "#define USE_MORPHNORMALS" : "") +
			(parameters.perPixel ? "#define PHONG_PER_PIXEL" : "") +
			(parameters.wrapAround ? "#define WRAP_AROUND" : "") +
			(parameters.doubleSided ? "#define DOUBLE_SIDED" : "") +
			(parameters.flipSided ? "#define FLIP_SIDED" : "") +

			(parameters.shadowMapEnabled ? "#define USE_SHADOWMAP" : "") +
			(parameters.shadowMapEnabled ? "#define " + shadowMapTypeDefine : "") +
			(parameters.shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "") +
			(parameters.shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "") +

			(parameters.sizeAttenuation ? "#define USE_SIZEATTENUATION" : "") +

			"uniform mat4 modelMatrix;" +
			"uniform mat4 modelViewMatrix;" +
			"uniform mat4 projectionMatrix;" +
			"uniform mat4 viewMatrix;" +
			"uniform mat3 normalMatrix;" +
			"uniform vec3 cameraPosition;" +

			"attribute vec3 position;" +
			"attribute vec3 normal;" +
			"attribute vec2 uv;" +
			"attribute vec2 uv2;" +

			"#ifdef USE_COLOR" +

				"attribute vec3 color;" +

			"#endif" +

			"#ifdef USE_MORPHTARGETS" +

				"attribute vec3 morphTarget0;" +
				"attribute vec3 morphTarget1;" +
				"attribute vec3 morphTarget2;" +
				"attribute vec3 morphTarget3;" +

				"#ifdef USE_MORPHNORMALS" +

					"attribute vec3 morphNormal0;" +
					"attribute vec3 morphNormal1;" +
					"attribute vec3 morphNormal2;" +
					"attribute vec3 morphNormal3;" +

				"#else" +

					"attribute vec3 morphTarget4;" +
					"attribute vec3 morphTarget5;" +
					"attribute vec3 morphTarget6;" +
					"attribute vec3 morphTarget7;" +

				"#endif" +

			"#endif" +

			"#ifdef USE_SKINNING" +

				"attribute vec4 skinIndex;" +
				"attribute vec4 skinWeight;" +

			"#endif";
		

		var prefix_fragment = 
			"precision " + _precision + " float; " +
			"precision " + _precision + " int; " +

			((parameters.bumpMap == true || parameters.normalMap == true) ? "#extension GL_OES_standard_derivatives : enable " : " ") +

			customDefines +

			"#define MAX_DIR_LIGHTS " + parameters.maxDirLights +
			"#define MAX_POINT_LIGHTS " + parameters.maxPointLights +
			"#define MAX_SPOT_LIGHTS " + parameters.maxSpotLights +
			"#define MAX_HEMI_LIGHTS " + parameters.maxHemiLights +

			"#define MAX_SHADOWS " + parameters.maxShadows +

			(parameters.alphaTest ? "#define ALPHATEST " + parameters.alphaTest: "") +

			(this.gammaInput ? "#define GAMMA_INPUT" : "") +
			(this.gammaOutput ? "#define GAMMA_OUTPUT" : "") +
			(this.physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "") +

			((parameters.useFog && parameters.fog) ? "#define USE_FOG" : "") +
			((parameters.useFog && parameters.fogExp) ? "#define FOG_EXP2" : "") +

			(parameters.map != false ? "#define USE_MAP" : "") +
			(parameters.envMap != false ? "#define USE_ENVMAP" : "") +
			(parameters.lightMap != false ? "#define USE_LIGHTMAP" : "") +
			(parameters.bumpMap != false ? "#define USE_BUMPMAP" : "") +
			(parameters.normalMap != false ? "#define USE_NORMALMAP" : "") +
			(parameters.specularMap != false ? "#define USE_SPECULARMAP" : "") +
			(parameters.vertexColors != false ? "#define USE_COLOR" : "") +

			(parameters.metal != false ? "#define METAL" : "") +
			(parameters.perPixel != false ? "#define PHONG_PER_PIXEL" : "") +
			(parameters.wrapAround != false ? "#define WRAP_AROUND" : "") +
			(parameters.doubleSided != false ? "#define DOUBLE_SIDED" : "") +
			(parameters.flipSided != false ? "#define FLIP_SIDED" : "") +

			(parameters.shadowMapEnabled != false ? "#define USE_SHADOWMAP" : "") +
			(parameters.shadowMapEnabled != false ? "#define " + shadowMapTypeDefine : "") +
			(parameters.shadowMapDebug != false ? "#define SHADOWMAP_DEBUG" : "") +
			(parameters.shadowMapCascade != false ? "#define SHADOWMAP_CASCADE" : "") +

			"uniform mat4 viewMatrix;" +
			"uniform vec3 cameraPosition; ";

		var glVertexShader = getShader("vertex", prefix_vertex + vertexShader);
		var glFragmentShader = getShader("fragment", prefix_fragment + fragmentShader);

		GL.attachShader(program.program, glVertexShader);
		GL.attachShader(program.program, glFragmentShader);

		//Force a particular attribute to index 0.
		// because potentially expensive emulation is done by browser if attribute 0 is disabled.
		//And, color, for example is often automatically bound to index 0 so disabling it
		if (index0AttributeName != null) {
			GL.bindAttribLocation(program.program, 0, index0AttributeName);
		}

		GL.linkProgram(program.program);

		if (GL.getProgramParameter(program.program, GL.LINK_STATUS) == 0) {
			trace("Could not initialise shader\n" + "VALIDATE_STATUS: " + GL.getProgramParameter(program.program, GL.VALIDATE_STATUS) + ", gl error [" + GL.getError() + "]");
			trace("Program Info Log: " + GL.getProgramInfoLog(program.program));
		}

		// clean up
		GL.deleteShader(glFragmentShader);
		GL.deleteShader(glVertexShader);

		// trace(prefix_fragment + fragmentShader);
		// trace(prefix_vertex + vertexShader);

		program.uniforms = new Map();
		program.attributes = new Map<String, Dynamic>();

		var identifiers, u, a, i;

		// cache uniform locations
		identifiers = [
			"viewMatrix", "modelViewMatrix", "projectionMatrix", "normalMatrix", "modelMatrix", "cameraPosition",
			"morphTargetInfluences"
		];

		if (parameters.useVertexTexture) {
			identifiers.push("boneTexture");
			identifiers.push("boneTextureWidth");
			identifiers.push("boneTextureHeight");
		} else {
			identifiers.push("boneGlobalMatrices");
		}

		for (u in uniforms.keys()) {
			identifiers.push(u);
		}

		cacheUniformLocations(program, identifiers);

		// cache attributes locations
		identifiers = [
			"position", "normal", "uv", "uv2", "tangent", "color",
			"skinIndex", "skinWeight", "lineDistance"
		];

		for (i in 0...parameters.maxMorphTargets) {
			identifiers.push("morphTarget" + i);
		}

		for (i in 0...parameters.maxMorphNormals) {
			identifiers.push("morphNormal" + i);
		}

		for (a in attributes) {
			identifiers.push(a);
		}

		cacheAttributeLocations(program, identifiers);

		program.id = _programs_counter++;

		_programs.push({ id: _programs.length, program: program, code: code, usedTimes: 1, attributes: null, uniforms: null });

		this.info.memory.programs = _programs.length;
		return program;
	}

	// Shader parameters cache
	function cacheUniformLocations(program:ThreeGLProgram, identifiers:Array<String>) {
		var id:String = "";
		for(i in 0...identifiers.length) {
			id = identifiers[i];
			program.uniforms.set(id, GL.getUniformLocation(program.program, id));
		}
	}

	function cacheAttributeLocations(program:ThreeGLProgram, identifiers:Array<String>) {
		var id:String = "";
		for(i in 0...identifiers.length) {
			id = identifiers[i];
			program.attributes.set(id, GL.getAttribLocation(program.program, id));
		}
	}

	// NOT NEEDED
	/*function addLineNumbers(string) {

		var chunks = string.split("\n");

		for (var i = 0, il = chunks.length; i < il; i ++) {

			// Chrome reports shader errors on lines
			// starting counting from 1

			chunks[ i ] = (i + 1) + ": " + chunks[ i ];

		}

		return chunks.join("\n");

	}*/

	function getShader(type:String, string:String) {
		var shader:GLShader = null;
		if (type == "fragment") {
			shader = GL.createShader(GL.FRAGMENT_SHADER);
		} else if (type == "vertex") {
			shader = GL.createShader(GL.VERTEX_SHADER);
		}

		GL.shaderSource(shader, string);
		GL.compileShader(shader);

		if (GL.getShaderParameter(shader, GL.COMPILE_STATUS) == 0) {
			trace(GL.getShaderInfoLog(shader));
			//trace(addLineNumbers(string));
			return null;
		}

		return shader;
	}

	// Textures
	function isPowerOfTwo(value:Int):Bool {
		return (value & (value - 1)) == 0;
	}

	function setTextureParameters (textureType:Int, texture:Texture, isImagePowerOfTwo:Bool) {
		if (isImagePowerOfTwo) {
			GL.texParameteri(textureType, GL.TEXTURE_WRAP_S, paramThreeToGL(texture.wrapS));
			GL.texParameteri(textureType, GL.TEXTURE_WRAP_T, paramThreeToGL(texture.wrapT));

			GL.texParameteri(textureType, GL.TEXTURE_MAG_FILTER, paramThreeToGL(texture.magFilter));
			GL.texParameteri(textureType, GL.TEXTURE_MIN_FILTER, paramThreeToGL(texture.minFilter));
		} else {
			GL.texParameteri(textureType, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri(textureType, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);

			GL.texParameteri(textureType, GL.TEXTURE_MAG_FILTER, filterFallback(texture.magFilter));
			GL.texParameteri(textureType, GL.TEXTURE_MIN_FILTER, filterFallback(texture.minFilter));
		}

		if (_glExtensionTextureFilterAnisotropic != null && texture.type != THREE.FloatType) {
			if (texture.anisotropy > 1 || texture.__oldAnisotropy != 0) {		// TODO -check this
				GL.texParameterf(textureType, _glExtensionTextureFilterAnisotropic.TEXTURE_MAX_ANISOTROPY_EXT, Math.min(texture.anisotropy, _maxAnisotropy));
				texture.__oldAnisotropy = texture.anisotropy;
			}
		}
	}

	function setTexture(texture:Texture, slot:Int) {
		if (texture.needsUpdate) {
			if (!texture.__webglInit) {
				texture.__webglInit = true;
				
				// TODO
				//texture.addEventListener("dispose", onTextureDispose);

				texture.__webglTexture = GL.createTexture();
				this.info.memory.textures++;
			}

			GL.activeTexture(GL.TEXTURE0 + slot);
			GL.bindTexture(GL.TEXTURE_2D, texture.__webglTexture);

			GL.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, cast texture.flipY);
			GL.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, cast texture.premultiplyAlpha);
			GL.pixelStorei(GL.UNPACK_ALIGNMENT, texture.unpackAlignment);

			var image = texture.image;
			var isImagePowerOfTwo = isPowerOfTwo(image.width) && isPowerOfTwo(image.height);
			var glFormat = paramThreeToGL(texture.format);
			var glType = paramThreeToGL(texture.type);

			setTextureParameters(GL.TEXTURE_2D, texture, isImagePowerOfTwo);

			var mipmap, mipmaps = texture.mipmaps;

			if (Std.is(texture, DataTexture)) {
				// use manually created mipmaps if available
				// if there are no manual mipmaps
				// set 0 level mipmap and then use GL to generate other mipmap levels
				if (mipmaps.length > 0 && isImagePowerOfTwo) {
					for (i in 0...mipmaps.length) {
						mipmap = mipmaps[i];
						GL.texImage2D(GL.TEXTURE_2D, i, glFormat, mipmap.width, mipmap.height, 0, glFormat, glType, mipmap.data);
					}

					texture.generateMipmaps = false;
				} else {
					GL.texImage2D(GL.TEXTURE_2D, 0, glFormat, image.width, image.height, 0, glFormat, glType, image.data);
				}

			} else if (Std.is(texture, CompressedTexture)) {
				for(i in 0...mipmaps.length) {
					mipmap = mipmaps[i];
					if (texture.format != THREE.RGBAFormat) {
						GL.compressedTexImage2D(GL.TEXTURE_2D, i, glFormat, mipmap.width, mipmap.height, 0, mipmap.data);
					} else {
						GL.texImage2D(GL.TEXTURE_2D, i, glFormat, mipmap.width, mipmap.height, 0, glFormat, glType, mipmap.data);
					}
				}
			} else { // regular Texture (image, video, canvas)
				// use manually created mipmaps if available
				// if there are no manual mipmaps
				// set 0 level mipmap and then use GL to generate other mipmap levels
				
				// TODO
				/*if (mipmaps.length > 0 && isImagePowerOfTwo) {
					for (i in 0...mipmaps.length) {
						mipmap = mipmaps[i];
						GL.texImage2D(GL.TEXTURE_2D, i, glFormat, glFormat, glType, mipmap.data,);
					}

					texture.generateMipmaps = false;
				} else {
					GL.texImage2D(GL.TEXTURE_2D, 0, glFormat, glFormat, glType, cast texture.image);
				}*/
			}

			if (texture.generateMipmaps && isImagePowerOfTwo) GL.generateMipmap(GL.TEXTURE_2D);

			texture.needsUpdate = false;

			if (texture.onUpdate) texture.onUpdate();

		} else {
			GL.activeTexture(GL.TEXTURE0 + slot);
			GL.bindTexture(GL.TEXTURE_2D, texture.__webglTexture);
		}
	}

	// TODO
	/*function clampToMaxSize(image, maxSize) {
		if (image.width <= maxSize && image.height <= maxSize) {
			return image;
		}

		// Warning: Scaling through the canvas will only work with images that use
		// premultiplied alpha.
		var maxDimension = Math.max(image.width, image.height);
		var newWidth = Math.floor(image.width * maxSize / maxDimension);
		var newHeight = Math.floor(image.height * maxSize / maxDimension);

		var canvas = document.createElement("canvas");
		canvas.width = newWidth;
		canvas.height = newHeight;

		var ctx = canvas.getContext("2d");
		ctx.drawImage(image, 0, 0, image.width, image.height, 0, 0, newWidth, newHeight);

		return canvas;
	}*/

	function setCubeTexture(texture:Texture, slot:Int) {
		// TODO
		/*if (texture.image.length == 6) {
			if (texture.needsUpdate) {
				if (texture.image.__webglTextureCube == null) {
					// TODO
					//texture.addEventListener("dispose", onTextureDispose);
					texture.image.__webglTextureCube = GL.createTexture();
					this.info.memory.textures++;
				}

				GL.activeTexture(GL.TEXTURE0 + slot);
				GL.bindTexture(GL.TEXTURE_CUBE_MAP, texture.image.__webglTextureCube);

				GL.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, cast(texture.flipY, Int));

				var isCompressed = Std.is(texture, CompressedTexture);

				var cubeImage = [];

				for (i in 0...6) {
					if (this.autoScaleCubemaps && !isCompressed) {
						// TODO
						cubeImage[i] = texture.image[i];// clampToMaxSize(texture.image[i], _maxCubemapSize);
					} else {
						cubeImage[i] = texture.image[i];
					}
				}

				var image = cubeImage[0];
				var isImagePowerOfTwo = isPowerOfTwo(image.width) && isPowerOfTwo(image.height);
				var glFormat = paramThreeToGL(texture.format);
				var glType = paramThreeToGL(texture.type);

				setTextureParameters(GL.TEXTURE_CUBE_MAP, texture, isImagePowerOfTwo);

				for (i in 0...6) {
					if(!isCompressed) {
						GL.texImage2D(GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, glFormat, glType, cubeImage[i]);
					} else {						
						var mipmap, mipmaps = cubeImage[i].mipmaps;

						for(j in 0...mipmaps.length) {
							mipmap = mipmaps[j];
							if (texture.format != THREE.RGBAFormat) {
								GL.compressedTexImage2D(GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, j, glFormat, mipmap.width, mipmap.height, 0, mipmap.data);
							} else {
								GL.texImage2D(GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, j, glFormat, mipmap.width, mipmap.height, 0, glFormat, glType, mipmap.data);
							}
						}
					}
				}

				if (texture.generateMipmaps && isImagePowerOfTwo) {
					GL.generateMipmap(GL.TEXTURE_CUBE_MAP);
				}

				texture.needsUpdate = false;

				if (texture.onUpdate) texture.onUpdate();

			} else {
				GL.activeTexture(GL.TEXTURE0 + slot);
				GL.bindTexture(GL.TEXTURE_CUBE_MAP, texture.image.__webglTextureCube);
			}
		}*/
	}

	function setCubeTextureDynamic(texture:Texture, slot:Int) {
		GL.activeTexture(GL.TEXTURE0 + slot);
		GL.bindTexture(GL.TEXTURE_CUBE_MAP, texture.__webglTexture);
	}

	// Render targets
	function setupFrameBuffer(framebuffer:GLFramebuffer, renderTarget:WebGLRenderTarget, textureTarget:Int) {
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, textureTarget, renderTarget.__webglTexture, 0);
	}

	function setupRenderBuffer(renderbuffer:GLRenderbuffer, renderTarget:WebGLRenderTarget) {
		GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);

		if (renderTarget.depthBuffer && !renderTarget.stencilBuffer) {
			GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, renderTarget.width, renderTarget.height);
			GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
		/* For some reason this is not working. Defaulting to RGBA4.
		} else if(! renderTarget.depthBuffer && renderTarget.stencilBuffer) {

			GL.renderbufferStorage(GL.RENDERBUFFER, GL.STENCIL_INDEX8, renderTarget.width, renderTarget.height);
			GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
		*/
		} else if (renderTarget.depthBuffer && renderTarget.stencilBuffer) {
			GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_STENCIL, renderTarget.width, renderTarget.height);
			GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
		} else {
			GL.renderbufferStorage(GL.RENDERBUFFER, GL.RGBA4, renderTarget.width, renderTarget.height);
		}
	}

	function setRenderTarget(renderTarget:WebGLRenderTarget) {
		var isCube = Std.is(renderTarget, WebGLRenderTargetCube);

		if (Reflect.field(renderTarget, "__webglFramebuffer") != null) {
			if (renderTarget.depthBuffer == false) renderTarget.depthBuffer = true;
			if (renderTarget.stencilBuffer == false) renderTarget.stencilBuffer = true;
			
			// TODO
			//renderTarget.addEventListener("dispose", onRenderTargetDispose);

			renderTarget.__webglTexture = GL.createTexture();

			this.info.memory.textures++;

			// Setup texture, create render and frame buffers
			var isTargetPowerOfTwo = isPowerOfTwo(Std.int(renderTarget.width)) && isPowerOfTwo(Std.int(renderTarget.height));
			var glFormat = paramThreeToGL(renderTarget.format);
			var	glType = paramThreeToGL(renderTarget.type);

			if (isCube) {
				renderTarget.__webglFramebuffer = new Array<GLFramebuffer>();
				renderTarget.__webglRenderbuffer = new Array<GLFramebuffer>();

				GL.bindTexture(GL.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
				setTextureParameters(GL.TEXTURE_CUBE_MAP, renderTarget, isTargetPowerOfTwo);

				for (i in 0...6) {
					renderTarget.__webglFramebuffer[i] = GL.createFramebuffer();
					renderTarget.__webglRenderbuffer[i] = GL.createRenderbuffer();

					GL.texImage2D(GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, Std.int(renderTarget.width), Std.int(renderTarget.height), 0, glFormat, glType, null);

					setupFrameBuffer(renderTarget.__webglFramebuffer[i], renderTarget, GL.TEXTURE_CUBE_MAP_POSITIVE_X + i);
					setupRenderBuffer(renderTarget.__webglRenderbuffer[i], renderTarget);
				}

				if (isTargetPowerOfTwo) GL.generateMipmap(GL.TEXTURE_CUBE_MAP);
			} else {
				renderTarget.__webglFramebuffer = GL.createFramebuffer();
				if (renderTarget.shareDepthFrom != null) {
					renderTarget.__webglRenderbuffer = renderTarget.shareDepthFrom.__webglRenderbuffer;
				} else {
					renderTarget.__webglRenderbuffer = GL.createRenderbuffer();
				}

				GL.bindTexture(GL.TEXTURE_2D, renderTarget.__webglTexture);
				setTextureParameters(GL.TEXTURE_2D, renderTarget, isTargetPowerOfTwo);

				GL.texImage2D(GL.TEXTURE_2D, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null);

				setupFrameBuffer(renderTarget.__webglFramebuffer, renderTarget, GL.TEXTURE_2D);

				if (renderTarget.shareDepthFrom != null) {
					if (renderTarget.depthBuffer && !renderTarget.stencilBuffer) {
						GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderTarget.__webglRenderbuffer);
					} else if (renderTarget.depthBuffer && renderTarget.stencilBuffer) {
						GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, renderTarget.__webglRenderbuffer);
					}
				} else {
					setupRenderBuffer(renderTarget.__webglRenderbuffer, renderTarget);
				}

				if (isTargetPowerOfTwo) GL.generateMipmap(GL.TEXTURE_2D);
			}

			// Release everything
			if (isCube) {
				GL.bindTexture(GL.TEXTURE_CUBE_MAP, null);
			} else {
				GL.bindTexture(GL.TEXTURE_2D, null);
			}

			GL.bindRenderbuffer(GL.RENDERBUFFER, null);
			GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		}

		var framebuffer:GLFramebuffer, width:Int, height:Int, vx:Int, vy:Int;

		if (renderTarget != null) {
			if (isCube) {
				framebuffer = renderTarget.__webglFramebuffer[cast(renderTarget, WebGLRenderTargetCube).activeCubeFace];
			} else {
				framebuffer = renderTarget.__webglFramebuffer;
			}

			width = renderTarget.width;
			height = renderTarget.height;

			vx = 0;
			vy = 0;
		} else {
			framebuffer = null;

			width = _viewportWidth;
			height = _viewportHeight;

			vx = _viewportX;
			vy = _viewportY;
		}

		if (framebuffer != _currentFramebuffer) {
			GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
			GL.viewport(vx, vy, width, height);

			_currentFramebuffer = framebuffer;
		}

		_currentWidth = width;
		_currentHeight = height;
	}

	function updateRenderTargetMipmap(renderTarget:WebGLRenderTarget) {
		if (Std.is(renderTarget, WebGLRenderTargetCube)) {
			GL.bindTexture(GL.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
			GL.generateMipmap(GL.TEXTURE_CUBE_MAP);
			GL.bindTexture(GL.TEXTURE_CUBE_MAP, null);
		} else {
			GL.bindTexture(GL.TEXTURE_2D, renderTarget.__webglTexture);
			GL.generateMipmap(GL.TEXTURE_2D);
			GL.bindTexture(GL.TEXTURE_2D, null);
		}
	}

	// Fallback filters for non-power-of-2 textures
	function filterFallback(f:Int):Dynamic {
		if (f == THREE.NearestFilter || f == THREE.NearestMipMapNearestFilter || f == THREE.NearestMipMapLinearFilter) {
			return GL.NEAREST;
		}

		return GL.LINEAR;
	}

	// Map three.js constants to WebGL constants
	function paramThreeToGL(p:Dynamic):Dynamic {
		if (p == THREE.RepeatWrapping) return GL.REPEAT;
		if (p == THREE.ClampToEdgeWrapping) return GL.CLAMP_TO_EDGE;
		if (p == THREE.MirroredRepeatWrapping) return GL.MIRRORED_REPEAT;

		if (p == THREE.NearestFilter) return GL.NEAREST;
		if (p == THREE.NearestMipMapNearestFilter) return GL.NEAREST_MIPMAP_NEAREST;
		if (p == THREE.NearestMipMapLinearFilter) return GL.NEAREST_MIPMAP_LINEAR;

		if (p == THREE.LinearFilter) return GL.LINEAR;
		if (p == THREE.LinearMipMapNearestFilter) return GL.LINEAR_MIPMAP_NEAREST;
		if (p == THREE.LinearMipMapLinearFilter) return GL.LINEAR_MIPMAP_LINEAR;

		if (p == THREE.UnsignedByteType) return GL.UNSIGNED_BYTE;
		if (p == THREE.UnsignedShort4444Type) return GL.UNSIGNED_SHORT_4_4_4_4;
		if (p == THREE.UnsignedShort5551Type) return GL.UNSIGNED_SHORT_5_5_5_1;
		if (p == THREE.UnsignedShort565Type) return GL.UNSIGNED_SHORT_5_6_5;

		if (p == THREE.ByteType) return GL.BYTE;
		if (p == THREE.ShortType) return GL.SHORT;
		if (p == THREE.UnsignedShortType) return GL.UNSIGNED_SHORT;
		if (p == THREE.IntType) return GL.INT;
		if (p == THREE.UnsignedIntType) return GL.UNSIGNED_INT;
		if (p == THREE.FloatType) return GL.FLOAT;

		if (p == THREE.AlphaFormat) return GL.ALPHA;
		if (p == THREE.RGBFormat) return GL.RGB;
		if (p == THREE.RGBAFormat) return GL.RGBA;
		if (p == THREE.LuminanceFormat) return GL.LUMINANCE;
		if (p == THREE.LuminanceAlphaFormat) return GL.LUMINANCE_ALPHA;

		if (p == THREE.AddEquation) return GL.FUNC_ADD;
		if (p == THREE.SubtractEquation) return GL.FUNC_SUBTRACT;
		if (p == THREE.ReverseSubtractEquation) return GL.FUNC_REVERSE_SUBTRACT;

		if (p == THREE.ZeroFactor) return GL.ZERO;
		if (p == THREE.OneFactor) return GL.ONE;
		if (p == THREE.SrcColorFactor) return GL.SRC_COLOR;
		if (p == THREE.OneMinusSrcColorFactor) return GL.ONE_MINUS_SRC_COLOR;
		if (p == THREE.SrcAlphaFactor) return GL.SRC_ALPHA;
		if (p == THREE.OneMinusSrcAlphaFactor) return GL.ONE_MINUS_SRC_ALPHA;
		if (p == THREE.DstAlphaFactor) return GL.DST_ALPHA;
		if (p == THREE.OneMinusDstAlphaFactor) return GL.ONE_MINUS_DST_ALPHA;

		if (p == THREE.DstColorFactor) return GL.DST_COLOR;
		if (p == THREE.OneMinusDstColorFactor) return GL.ONE_MINUS_DST_COLOR;
		if (p == THREE.SrcAlphaSaturateFactor) return GL.SRC_ALPHA_SATURATE;

		if (_glExtensionCompressedTextureS3TC != null) {
			if (p == THREE.RGB_S3TC_DXT1_Format) return _glExtensionCompressedTextureS3TC.COMPRESSED_RGB_S3TC_DXT1_EXT;
			if (p == THREE.RGBA_S3TC_DXT1_Format) return _glExtensionCompressedTextureS3TC.COMPRESSED_RGBA_S3TC_DXT1_EXT;
			if (p == THREE.RGBA_S3TC_DXT3_Format) return _glExtensionCompressedTextureS3TC.COMPRESSED_RGBA_S3TC_DXT3_EXT;
			if (p == THREE.RGBA_S3TC_DXT5_Format) return _glExtensionCompressedTextureS3TC.COMPRESSED_RGBA_S3TC_DXT5_EXT;
		}

		return 0;
	}

	// Allocations
	function allocateBones (object:Object3D):Int {
		if (_supportsBoneTextures && object != null && Reflect.field(object, "useVertexTexture")) {
			return 1024;
		} else {
			// default for when object is not specified
			// (for example when prebuilding shader
			//   to be used with multiple objects)
			//
			// 	- leave some extra space for other uniforms
			//  - limit here is ANGLE's 254 max uniform vectors
			//    (up to 54 should be safe)

			var nVertexUniforms = GL.getParameter(GL.MAX_VERTEX_UNIFORM_VECTORS);
			var nVertexMatrices = Math.floor((nVertexUniforms - 20) / 4);

			var maxBones:Int = nVertexMatrices;

			if (object != null && Std.is(object, SkinnedMesh)) {
				maxBones = Std.int(Math.min(cast(object, SkinnedMesh).bones.length, maxBones));
				if (maxBones < cast(object, SkinnedMesh).bones.length) {
					trace("WebGLRenderer: too many bones - " + cast(object, SkinnedMesh).bones.length + ", this GPU supports just " + maxBones + " (try OpenGL instead of ANGLE)");
				}
			}

			return maxBones;
		}
		return 0;
	}

	function allocateLights(lights:Array<Light>):Dynamic {
		var dirLights = 0;
		var pointLights = 0;
		var spotLights = 0;
		var hemiLights = 0;

		for (l in 0...lights.length) {
			var light = lights[l];

			if (Reflect.field(light, "onlyShadow")) continue;

			if (Std.is(light, DirectionalLight)) dirLights ++;
			if (Std.is(light, PointLight)) pointLights ++;
			if (Std.is(light, SpotLight)) spotLights ++;
			if (Std.is(light, HemisphereLight)) hemiLights ++;
		}

		return { "directional" : dirLights, "point" : pointLights, "spot": spotLights, "hemi": hemiLights };
	}

	function allocateShadows(lights:Array<Light>):Int {
		var maxShadows = 0;
		for (l in 0...lights.length) {
			var light = lights[l];

			if (light.castShadow == false) continue;

			if (Std.is(light, SpotLight)) maxShadows++;
			if (Std.is(light, DirectionalLight) && Reflect.field(light, "shadowCascade") == null) maxShadows++;
		}

		return maxShadows;
	}

	// Initialization
	function initGL() {
		/*try {

			var attributes = {
				alpha: _alpha,
				premultipliedAlpha: _premultipliedAlpha,
				antialias: _antialias,
				stencil: _stencil,
				preserveDrawingBuffer: _preserveDrawingBuffer
			};

			_gl = _canvas.getContext("webgl", attributes) || _canvas.getContext("experimental-webgl", attributes);

			if (_gl == null) {

				throw("Error creating WebGL context.";

			}

		} catch (error) {

			trace(error);

		}*/

		_glExtensionTextureFloat = GL.getExtension("OES_texture_float");
		_glExtensionTextureFloatLinear = GL.getExtension("OES_texture_float_linear");
		_glExtensionStandardDerivatives = GL.getExtension("OES_standard_derivatives");

		_glExtensionTextureFilterAnisotropic = GL.getExtension("EXT_texture_filter_anisotropic") || GL.getExtension("MOZ_EXT_texture_filter_anisotropic") || GL.getExtension("WEBKIT_EXT_texture_filter_anisotropic");

		_glExtensionCompressedTextureS3TC = GL.getExtension("WEBGL_compressed_texture_s3tc") || GL.getExtension("MOZ_WEBGL_compressed_texture_s3tc") || GL.getExtension("WEBKIT_WEBGL_compressed_texture_s3tc");

		if (_glExtensionTextureFloat == null) {
			trace("THREE.WebGLRenderer: Float textures not supported.");
		}

		if (_glExtensionStandardDerivatives == null) {
			trace("THREE.WebGLRenderer: Standard derivatives not supported.");
		}

		if (_glExtensionTextureFilterAnisotropic == null) {
			trace("THREE.WebGLRenderer: Anisotropic texture filtering not supported.");
		}

		if (_glExtensionCompressedTextureS3TC == null) {
			trace("THREE.WebGLRenderer: S3TC compressed textures not supported.");
		}

		if (GL.getShaderPrecisionFormat == null) {
			// TODO
			/*GL.getShaderPrecisionFormat = function() {
				return {
					"rangeMin"  : 1,
					"rangeMax"  : 1,
					"precision" : 1
				};
			}*/
		}
	}

	function setDefaultGLState() {
		GL.clearColor(0, 0, 0, 1);
		GL.clearDepth(1);
		GL.clearStencil(0);

		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LEQUAL);

		GL.frontFace(GL.CCW);
		GL.cullFace(GL.BACK);
		GL.enable(GL.CULL_FACE);

		GL.enable(GL.BLEND);
		GL.blendEquation(GL.FUNC_ADD);
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);

		GL.viewport(_viewportX, _viewportY, _viewportWidth, _viewportHeight);
		
		GL.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearAlpha);
	}

	// default plugins (order is important)
	
	// TODO
	/*this.shadowMapPlugin = new THREE.ShadowMapPlugin();
	this.addPrePlugin(this.shadowMapPlugin);

	this.addPostPlugin(new THREE.SpritePlugin());
	this.addPostPlugin(new THREE.LensFlarePlugin());*/

}
