package com.gamestudiohx.three.renderers;

import com.gamestudiohx.three.math.ThreeMath;
import haxe.ds.Vector;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Element;
import js.html.Image;
import js.html.ImageData;
import js.html.Uint8ClampedArray;
import com.gamestudiohx.three.cameras.Camera;
import com.gamestudiohx.three.cameras.PerspectiveCamera;
import com.gamestudiohx.three.core.Projector;
import com.gamestudiohx.three.lights.Light;
import com.gamestudiohx.three.lights.PointLight;
import com.gamestudiohx.three.lights.SpotLight;
import com.gamestudiohx.three.lights.DirectionalLight;
import com.gamestudiohx.three.lights.AmbientLight;
import com.gamestudiohx.three.lights.AreaLight;
import com.gamestudiohx.three.lights.HemisphereLight;
import com.gamestudiohx.three.materials.Material;
import com.gamestudiohx.three.materials.SpriteCanvasMaterial;
import com.gamestudiohx.three.materials.ParticleSystemMaterial;
import com.gamestudiohx.three.materials.SpriteMaterial;
import com.gamestudiohx.three.materials.LineBasicMaterial;
import com.gamestudiohx.three.materials.LineDashedMaterial;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.materials.MeshFaceMaterial;
import com.gamestudiohx.three.materials.MeshLambertMaterial;
import com.gamestudiohx.three.materials.MeshPhongMaterial;
import com.gamestudiohx.three.materials.MeshDepthMaterial;
import com.gamestudiohx.three.materials.MeshNormalMaterial;
import com.gamestudiohx.three.math.Box2;
import com.gamestudiohx.three.math.Box3;
import com.gamestudiohx.three.math.Color;
import com.gamestudiohx.three.math.Vector2;
import com.gamestudiohx.three.math.Vector3;
import com.gamestudiohx.three.math.Vector4;
import com.gamestudiohx.three.renderers.renderables.RenderableFace3;
import com.gamestudiohx.three.renderers.renderables.RenderableLine;
import com.gamestudiohx.three.renderers.renderables.RenderableSprite;
import com.gamestudiohx.three.renderers.renderables.RenderableVertex;
import com.gamestudiohx.three.renderers.renderables.RenderableObject;
import com.gamestudiohx.three.scenes.Scene;
import com.gamestudiohx.three.textures.Texture;
import com.gamestudiohx.three.THREE;

/**
 * @author mrdoob / http://mrdoob.com/
 */

/**
 * 
 * @haxeport Krtolica Vujadin - GameStudioHx.com
 */

class CanvasRenderer {
		
	public var domElement:Element;
	
	private var _canvasWidth:Float;
	private var _canvasHeight:Float;
	private var _canvasWidthHalf:Float;
	private var _canvasHeightHalf:Float;
	
	public var _devicePixelRatio:Float = 1.0;
	public var sortObjects:Bool = true;
	public var sortElements:Bool = true;
	
	private var _canvas:CanvasElement;
	private var _context:CanvasRenderingContext2D;
	
	private var _projector:Projector;
	private var _renderData:Dynamic;
	private var _elements:Dynamic;
	private var _lights:Dynamic;
	private var _camera:Camera;
	
	public var autoClear:Bool = true;
	public var _clearColor:Color;
	public var _clearAlpha:Float = 1.0;
	
	private var _contextGlobalAlpha:Float = 1.0;
	private var _contextGlobalCompositeOperation:Int = 0;
	private var _contextStrokeStyle:String;
	private var _contextFillStyle:String;
	private var _contextLineWidth:Float = 1.0;
	private var _contextLineCap:String;
	private var _contextLineJoin:String;
	private var _contextDashSize:Float = 0.0;
	private var _contextGapSize:Float = 0.0;
	
	private var _v1:Dynamic;
	private var _v2:Dynamic;
	private var _v3:Dynamic;
	private var _v4:Dynamic;
	private var _v5:Dynamic;
	private var _v6:Dynamic;
	
	private var _v1x:Float = 0.0;
	private var _v2x:Float = 0.0;
	private var _v3x:Float = 0.0;
	private var _v4x:Float = 0.0;
	private var _v5x:Float = 0.0;
	private var _v6x:Float = 0.0;
	
	private var _v1y:Float = 0.0;
	private var _v2y:Float = 0.0;
	private var _v3y:Float = 0.0;
	private var _v4y:Float = 0.0;
	private var _v5y:Float = 0.0;
	private var _v6y:Float = 0.0;
	
	private var _color:Color;
	private var _color1:Color;
	private var _color2:Color;
	private var _color3:Color;
	private var _color4:Color;
	
	private var _diffuseColor:Color;
	private var _emissiveColor:Color;
	
	private var _lightColor:Color;
	
	private var _patterns:Map<String,Dynamic>;
	private var _imageDatas:Map<String,ImageData>;
	
	private var _near:Float;
	private var _far:Float;
	
	private var _image:Dynamic;
	private var _uvs:Array<Dynamic>;
	
	private var _uv1x:Float = 0.0;
	private var _uv1y:Float = 0.0;
	
	private var _uv2x:Float = 0.0;
	private var _uv2y:Float = 0.0;
	
	private var _uv3x:Float = 0.0;
	private var _uv3y:Float = 0.0;
	
	private var _clipBox:Box2;
	private var _clearBox:Box2;
	private var _elemBox:Box2;
	
	private var _ambientLight:Color;
	private var _directionalLights:Color;
	private var _pointLights:Color;
	
	private var _vector3:Vector3;
	
	private var _pixelMap:CanvasElement;
	private var _pixelMapContext:CanvasRenderingContext2D;
	private var _pixelMapImage:ImageData;
	private var _pixelMapData:Uint8ClampedArray;
	private var _gradientMap:CanvasElement;
	private var _gradientMapContext:CanvasRenderingContext2D;
	private var _gradientMapQuality:Int = 16;
	
	public var _info:Dynamic;

	
	public function new(parameters:Dynamic = null):Void {
		if (parameters == null) parameters = { };
		_projector = new Projector();
		_canvas = Browser.document.createCanvasElement();
		Browser.document.body.appendChild(_canvas);
		_context = _canvas.getContext2d();
				
		_clearColor = new Color(0x000000);
		
		_v5 = new RenderableVertex();
		_v6 = new RenderableVertex();
		
		_color = new Color();
		_color1 = new Color();
		_color2 = new Color();
		_color3 = new Color();
		_color4 = new Color();
		
		_diffuseColor = new Color();
		_emissiveColor = new Color();
		
		_lightColor = new Color();
		
		_patterns = new Map<String,Dynamic>();
		_imageDatas = new Map<String,ImageData>();
		
		_clipBox = new Box2();
		_clearBox = new Box2();
		_elemBox = new Box2();
		
		_ambientLight = new Color();
		_directionalLights = new Color();
		_pointLights = new Color();
		
		_vector3 = new Vector3();
		
		_pixelMap = Browser.document.createCanvasElement();
		_pixelMap.width = _pixelMap.height = 2;
		
		_pixelMapContext = _pixelMap.getContext2d();
		_pixelMapContext.fillStyle = 'rgba(0,0,0,1)';
		_pixelMapContext.fillRect(0, 0, 2, 2);
		
		_pixelMapImage = _pixelMapContext.getImageData(0, 0, 2, 2);
		_pixelMapData = _pixelMapImage.data;
		
		_gradientMap = Browser.document.createCanvasElement();
		_gradientMap.width = _gradientMap.height = _gradientMapQuality;
		
		_gradientMapContext = _gradientMap.getContext2d();
		_gradientMapContext.translate(-_gradientMapQuality / 2, -_gradientMapQuality / 2);
		_gradientMapContext.scale(_gradientMapQuality, _gradientMapQuality);
		
		_gradientMapQuality--; //THREE: Fix UVs
		
		// dash+gap fallbacks for Firefox and everything else
		/*if (_context.setLineDash == null) {
			if (_context.mozDash != null) {
				_context.setLineDash = function(values) {
					_context.mozDash = values[0] != null ? values : null;
				};
			} else {
				_context.setLineDash = function() { };
			}
		}*/
		
		domElement = _canvas;
		
		if (Reflect.hasField(parameters, 'devicePixelRatio') == true)
			_devicePixelRatio = parameters.devicePixelRatio;
		else _devicePixelRatio = Browser.window.devicePixelRatio;
		
		this.autoClear = true;
		this.sortObjects = true;
		this.sortElements = true;
		
		_info = {
			render: {
				vertices: 0,
				faces: 0
			}
		};
		
	}	
	
	//WebGLRenderer compatibility 
	public function supportsVertexTextures() {
	}
	
	public function setFaceCulling() {
	}	
	
	public function setSize(width:Float, height:Float, updateStyle:Bool = true) {
		_canvasWidth = width * this._devicePixelRatio;
		_canvasHeight = height * this._devicePixelRatio;

		_canvasWidthHalf = Math.floor(_canvasWidth / 2);
		_canvasHeightHalf = Math.floor(_canvasHeight / 2);

		_canvas.width = Std.int(_canvasWidth);
		_canvas.height = Std.int(_canvasHeight);

		if (this._devicePixelRatio != 1 && updateStyle != false) {
			_canvas.style.width = width + 'px';
			_canvas.style.height = height + 'px';
		}

		_clipBox.set(
			new Vector2(-_canvasWidthHalf, -_canvasHeightHalf),
			new Vector2(_canvasWidthHalf, _canvasHeightHalf)
		);

		_clearBox.set(
			new Vector2(-_canvasWidthHalf, -_canvasHeightHalf),
			new Vector2(_canvasWidthHalf, _canvasHeightHalf)
		);

		_contextGlobalAlpha = 1;
		_contextGlobalCompositeOperation = 0;
		_contextStrokeStyle = null;
		_contextFillStyle = null;
		_contextLineWidth = null;
		_contextLineCap = null;
		_contextLineJoin = null;
	}	
	
	public function setClearColor(color:Color, alpha:Float = null)	{
		_clearColor.set(color);
		_clearAlpha = alpha != null ? alpha : 1;

		_clearBox.set(
			new Vector2(-_canvasWidthHalf, -_canvasHeightHalf),
			new Vector2(_canvasWidthHalf, _canvasHeightHalf)
		);
	}	
	
	public function setClearColorHex (hex:Color, alpha:Float = null) {
		trace("DEPRECATED: .setClearColorHex() is being removed. Use .setClearColor() instead.");
		this.setClearColor(hex, alpha);
	}	
	
	public function getMaxAnisotropy():Int {
		return 0;
	}	
	
	public function clear() {
		_context.setTransform(1, 0, 0, - 1, _canvasWidthHalf, _canvasHeightHalf);

		if (_clearBox.empty() == false) {
			_clearBox.intersect(_clipBox);
			_clearBox.expandByScalar(2);

			if (_clearAlpha < 1) {
				_context.clearRect(
					_clearBox.min.x,
					_clearBox.min.y,
					(_clearBox.max.x - _clearBox.min.x),
					(_clearBox.max.y - _clearBox.min.y)
				);
			}

			if (_clearAlpha > 0) {
				setBlending(THREE.NormalBlending);
				setOpacity(1);

				setFillStyle('rgba(' + Math.floor(_clearColor.r * 255) + ',' + Math.floor(_clearColor.g * 255) + ',' + Math.floor(_clearColor.b * 255) + ',' + _clearAlpha + ')');

				_context.fillRect(
					_clearBox.min.x,
					_clearBox.min.y,
					(_clearBox.max.x - _clearBox.min.x),
					(_clearBox.max.y - _clearBox.min.y)
				);
			}

			_clearBox.makeEmpty();
		}
	}
	
	// compatibility
	public function clearColor() {}
	public function clearDepth() {}
	public function clearStencil() {}
	
	public function render(scene:Scene, camera:Camera) {
		if (Std.is(camera, Camera) == false) {
			trace("THREE.CanvasRenderer.render: camera is not an instance of THREE.Camera.");
			return;
		}

		if (this.autoClear == true) this.clear();

		_context.setTransform(1, 0, 0, - 1, _canvasWidthHalf, _canvasHeightHalf);

		_info.render.vertices = 0;
		_info.render.faces = 0;

		_renderData = _projector.projectScene(scene, camera, this.sortObjects, this.sortElements);
		_elements = _renderData.elements;
		_lights = _renderData.lights;
		_camera = camera;

		/* DEBUG
		setFillStyle( 'rgba( 0, 255, 255, 0.5 )' );
		_context.fillRect( _clipBox.min.x, _clipBox.min.y, _clipBox.max.x - _clipBox.min.x, _clipBox.max.y - _clipBox.min.y );
		*/

		calculateLights();

		for (e in 0..._elements.length) {
			var element = _elements[e];
			var material = element.material;

			if (material == null || material.visible == false) continue;

			_elemBox.makeEmpty();

			if (Std.is(element, RenderableSprite)) {
				_v1 = cast(element, RenderableSprite);
				_v1.x *= _canvasWidthHalf; 
				_v1.y *= _canvasHeightHalf;

				renderSprite(_v1, _v1, cast(material, Material));
			} else if (Std.is(element, RenderableLine)) {
				_v1 = cast(element, RenderableLine).v1; 
				_v2 = cast(element, RenderableLine).v2;

				_v1.positionScreen.x *= _canvasWidthHalf; 
				_v1.positionScreen.y *= _canvasHeightHalf;
				
				_v2.positionScreen.x *= _canvasWidthHalf; 
				_v2.positionScreen.y *= _canvasHeightHalf;

				_elemBox.setFromPoints( [
					_v1.positionScreen,
					_v2.positionScreen
				] );

				if (_clipBox.isIntersectionBox(_elemBox) == true) {
					renderLine(_v1, _v2, cast(element, RenderableLine), cast(material, Material));
				}

			} else if (Std.is(element, RenderableFace3)) {

				_v1 = cast(element, RenderableFace3).v1; 
				_v2 = cast(element, RenderableFace3).v2; 
				_v3 = cast(element, RenderableFace3).v3;

				if (_v1.positionScreen.z < -1 || _v1.positionScreen.z > 1) continue;
				if (_v2.positionScreen.z < -1 || _v2.positionScreen.z > 1) continue;
				if (_v3.positionScreen.z < -1 || _v3.positionScreen.z > 1) continue;

				_v1.positionScreen.x *= _canvasWidthHalf; 
				_v1.positionScreen.y *= _canvasHeightHalf;
				
				_v2.positionScreen.x *= _canvasWidthHalf; 
				_v2.positionScreen.y *= _canvasHeightHalf;
				
				_v3.positionScreen.x *= _canvasWidthHalf; 
				_v3.positionScreen.y *= _canvasHeightHalf;

				if (material.overdraw > 0) {
					expand(_v1.positionScreen, _v2.positionScreen, material.overdraw);
					expand(_v2.positionScreen, _v3.positionScreen, material.overdraw);
					expand(_v3.positionScreen, _v1.positionScreen, material.overdraw);
				}

				_elemBox.setFromPoints([_v1.positionScreen, _v2.positionScreen, _v3.positionScreen]);

				if (_clipBox.isIntersectionBox(_elemBox) == true) {
					renderFace3(_v1, _v2, _v3, 0, 1, 2, cast(element, RenderableFace3), cast(material, Material));
				}
			}

			/* DEBUG
			setLineWidth( 1 );
			setStrokeStyle( 'rgba( 0, 255, 0, 0.5 )' );
			_context.strokeRect( _elemBox.min.x, _elemBox.min.y, _elemBox.max.x - _elemBox.min.x, _elemBox.max.y - _elemBox.min.y );
			*/

			_clearBox.union(_elemBox);
		}

		/* DEBUG
		setLineWidth( 1 );
		setStrokeStyle( 'rgba( 255, 0, 0, 0.5 )' );
		_context.strokeRect( _clearBox.min.x, _clearBox.min.y, _clearBox.max.x - _clearBox.min.x, _clearBox.max.y - _clearBox.min.y );
		*/

		_context.setTransform(1, 0, 0, 1, 0, 0);
	}
	
	
	inline function calculateLights() {
		_ambientLight.setRGB(0, 0, 0);
		_directionalLights.setRGB(0, 0, 0);
		_pointLights.setRGB(0, 0, 0);

		for (l in 0..._lights.length) {
			var light = _lights[l];
			var lightColor = light.color;

			if (Std.is(light, AmbientLight)) {
				_ambientLight.add(lightColor);
			} else if (Std.is(light, DirectionalLight)) {
				// for sprites
				_directionalLights.add(lightColor);
			} else if (Std.is(light, PointLight)) {
				// for sprites
				_pointLights.add(lightColor);
			}
		}		
	}
	
	
	inline function calculateLight(position:Vector3, normal:Vector3, color:Color) {
		for (l in 0..._lights.length) {
			var light = _lights[l];

			_lightColor.copy(light.color);

			if (Std.is(light, DirectionalLight)) {
				var lightPosition = _vector3.setFromMatrixPosition(light.matrixWorld).normalize();
				var amount = normal.dot(lightPosition);

				if (amount <= 0) continue;
				amount *= light.intensity;

				color.add(_lightColor.multiplyScalar(amount));
			} else if (Std.is(light, PointLight)) {
				var lightPosition = _vector3.setFromMatrixPosition(light.matrixWorld);

				var amount = normal.dot(_vector3.subVectors(lightPosition, position).normalize());
				if (amount <= 0) continue;

				amount *= light.distance == 0 ? 1 : 1 - Math.min(position.distanceTo(lightPosition) / light.distance, 1);
				if (amount == 0) continue;
				amount *= light.intensity;

				color.add(_lightColor.multiplyScalar(amount));
			}
		}
	}
		
	function renderSprite(v1:RenderableSprite, element:RenderableSprite, material:Material) {
		setOpacity(material.opacity);
		setBlending(material.blending);

		var scaleX = element.scale.x * _canvasWidthHalf;
		var scaleY = element.scale.y * _canvasHeightHalf;

		var dist = 0.5 * Math.sqrt(scaleX * scaleX + scaleY * scaleY); // allow for rotated sprite
		_elemBox.min.set(v1.x - dist, v1.y - dist);
		_elemBox.max.set(v1.x + dist, v1.y + dist);

		if (_clipBox.isIntersectionBox(_elemBox) == false) {
			_elemBox.makeEmpty();
			return;
		}

		if (Std.is(material, SpriteMaterial) ||
			 Std.is(material, ParticleSystemMaterial)) { // Backwards compatibility

			if (cast(material, SpriteMaterial).map != null) {
				var bitmap = cast(material, SpriteMaterial).map.image;

				_context.save();
				_context.translate(v1.x, v1.y);
				_context.rotate(cast(material, SpriteMaterial).rotation);
				_context.scale(scaleX, -scaleY);

				_context.drawImage(bitmap, 0, 0, bitmap.width, bitmap.height, -0.5, -0.5, 1, 1);
				_context.restore();
			} else {
				setFillStyle(cast(material, SpriteMaterial).color.getStyle());

				_context.save();
				_context.translate(v1.x, v1.y);
				_context.rotate(cast(material, SpriteMaterial).rotation);
				_context.scale(scaleX, -scaleY);
				_context.fillRect(-0.5, -0.5, 1, 1);
				_context.restore();
			}
		} else if (Std.is(material, SpriteCanvasMaterial)) {
			setStrokeStyle(cast(material, SpriteCanvasMaterial).color.getStyle());
			setFillStyle(cast(material, SpriteCanvasMaterial).color.getStyle());

			_context.save();
			_context.translate(v1.x, v1.y);
			_context.rotate(-element.rotation);
			_context.scale(scaleX, scaleY);

			cast(material, SpriteCanvasMaterial).program(_context);

			_context.restore();
		}

		/* DEBUG
		setStrokeStyle( 'rgb(255,255,0)' );
		_context.beginPath();
		_context.moveTo( v1.x - 10, v1.y );
		_context.lineTo( v1.x + 10, v1.y );
		_context.moveTo( v1.x, v1.y - 10 );
		_context.lineTo( v1.x, v1.y + 10 );
		_context.stroke();
		*/
	}
	
	inline function renderLine(v1:RenderableVertex, v2:RenderableVertex, element:RenderableLine, material:Material) {
		setOpacity(material.opacity);
		setBlending(material.blending);

		_context.beginPath();
		_context.moveTo(v1.positionScreen.x, v1.positionScreen.y);
		_context.lineTo(v2.positionScreen.x, v2.positionScreen.y);

		if (Std.is(material, LineBasicMaterial)) {
			setLineWidth(cast(material, LineBasicMaterial).linewidth);
			setLineCap(cast(material, LineBasicMaterial).linecap);
			setLineJoin(cast(material, LineBasicMaterial).linejoin);

			if (cast(material, LineBasicMaterial).vertexColors != THREE.VertexColors) {
				setStrokeStyle(cast(material, LineBasicMaterial).color.getStyle());
			} else {
				var colorStyle1 = element.vertexColors[0].getStyle();
				var colorStyle2 = element.vertexColors[1].getStyle();

				if (colorStyle1 == colorStyle2) {
					setStrokeStyle(colorStyle1);
				} else {
					try {
						var grad = _context.createLinearGradient(
							v1.positionScreen.x,
							v1.positionScreen.y,
							v2.positionScreen.x,
							v2.positionScreen.y
						);
						grad.addColorStop(0, colorStyle1);
						grad.addColorStop(1, colorStyle2);

					} catch (exception:Dynamic) {
						trace(exception);
						//grad = colorStyle1;
					}
					
					setStrokeStyle(colorStyle1);
				}
			}

			_context.stroke();
			_elemBox.expandByScalar(cast(material, LineBasicMaterial).linewidth * 2);

		} else if ( Std.is(material, LineDashedMaterial)) {
			setLineWidth(cast(material, LineDashedMaterial).linewidth);
			setLineCap(cast(material, LineDashedMaterial).linecap);
			setLineJoin(cast(material, LineDashedMaterial).linejoin);
			setStrokeStyle(cast(material, LineDashedMaterial).color.getStyle());
			setDashAndGap(cast(material, LineDashedMaterial).dashSize, cast(material, LineDashedMaterial).gapSize);

			_context.stroke();

			_elemBox.expandByScalar(cast(material, LineDashedMaterial).linewidth * 2);

			setDashAndGap(null, null);
		}
	}
	
	inline private function renderFace3(v1:RenderableVertex, v2:RenderableVertex, v3:RenderableVertex, uv1:Int, uv2:Int, uv3:Int, element:RenderableFace3, material:Material) {
		_info.render.vertices += 3;
		_info.render.faces++;
		
		setOpacity(material.opacity);
		setBlending(material.blending);
		
		_v1x = v1.positionScreen.x; _v1y = v1.positionScreen.y;
		_v2x = v2.positionScreen.x; _v2y = v2.positionScreen.y;
		_v3x = v3.positionScreen.x; _v3y = v3.positionScreen.y;
		
		drawTriangle(_v1x, _v1y, _v2x, _v2y, _v3x, _v3y);
		
		if ((Std.is(material, MeshLambertMaterial) || Std.is(material, MeshPhongMaterial)) && cast(material, MeshLambertMaterial).map == null) {
			_diffuseColor.copy(cast(material, MeshLambertMaterial).color);
			_emissiveColor.copy(cast(material, MeshLambertMaterial).emissive);

			if (cast(material, MeshLambertMaterial).vertexColors == THREE.FaceColors) {
				_diffuseColor.multiply(element.color);
			}

			if (cast(material, MeshLambertMaterial).wireframe == false && cast(material, MeshLambertMaterial).shading == THREE.SmoothShading && element.vertexNormalsLength == 3 ) {
				_color1.copy(_ambientLight);
				_color2.copy(_ambientLight);
				_color3.copy(_ambientLight);

				calculateLight(element.v1.positionWorld, element.vertexNormalsModel[0], _color1);
				calculateLight(element.v2.positionWorld, element.vertexNormalsModel[1], _color2);
				calculateLight(element.v3.positionWorld, element.vertexNormalsModel[2], _color3);

				_color1.multiply(_diffuseColor).add(_emissiveColor);
				_color2.multiply(_diffuseColor).add(_emissiveColor);
				_color3.multiply(_diffuseColor).add(_emissiveColor);
				_color4.addColors(_color2, _color3).multiplyScalar(0.5);

				_image = getGradientTexture(_color1, _color2, _color3, _color4);

				clipImage(_v1x, _v1y, _v2x, _v2y, _v3x, _v3y, 0, 0, 1, 0, 0, 1, _image);
			} else {
				_color.copy(_ambientLight);

				calculateLight(element.centroidModel, element.normalModel, _color);

				_color.multiply(_diffuseColor ).add(_emissiveColor);

				cast(material, MeshLambertMaterial).wireframe == true
					? strokePath(_color, cast(material, MeshLambertMaterial).wireframeLinewidth, cast(material, MeshLambertMaterial).wireframeLinecap, cast(material, MeshLambertMaterial).wireframeLinejoin)
					: fillPath(_color);
			}

		} else if (Std.is(material, MeshBasicMaterial) || Std.is(material, MeshLambertMaterial) || Std.is(material, MeshPhongMaterial)) {
			if (cast(material, MeshBasicMaterial).map != null) {
				if (Std.is(cast(material, MeshBasicMaterial).map.mapping, THREE.UVMapping)) {
					_uvs = element.uvs[0];
					patternPath(_v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _uvs[uv1].x, _uvs[uv1].y, _uvs[uv2].x, _uvs[uv2].y, _uvs[uv3].x, _uvs[uv3].y, cast(material, MeshBasicMaterial).map);
				}
			} else if (cast(material, MeshBasicMaterial).envMap != null) {
				if (Std.is(cast(material, MeshBasicMaterial).envMap.mapping, THREE.SphericalReflectionMapping)) {
					_vector3.copy(element.vertexNormalsModelView[uv1]);
					_uv1x = 0.5 * _vector3.x + 0.5;
					_uv1y = 0.5 * _vector3.y + 0.5;

					_vector3.copy(element.vertexNormalsModelView[uv2]);
					_uv2x = 0.5 * _vector3.x + 0.5;
					_uv2y = 0.5 * _vector3.y + 0.5;

					_vector3.copy(element.vertexNormalsModelView[uv3]);
					_uv3x = 0.5 * _vector3.x + 0.5;
					_uv3y = 0.5 * _vector3.y + 0.5;

					patternPath(_v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _uv1x, _uv1y, _uv2x, _uv2y, _uv3x, _uv3y, cast(material, MeshBasicMaterial).envMap);

				}/* else if ( material.envMap.mapping === THREE.SphericalRefractionMapping ) {



				}*/
			} else {
				_color.copy(cast(material, MeshBasicMaterial).color);

				if (cast(material, MeshBasicMaterial).vertexColors == THREE.FaceColors) {
					_color.multiply(element.color);
				}

				cast(material, MeshBasicMaterial).wireframe == true
					? strokePath(_color, cast(material, MeshBasicMaterial).wireframeLinewidth, cast(material, MeshBasicMaterial).wireframeLinecap, cast(material, MeshBasicMaterial).wireframeLinejoin)
					: fillPath(_color);
			}
		} else if (Std.is(material, MeshDepthMaterial)) {
			_near = cast(_camera, PerspectiveCamera).near;
			_far = cast(_camera, PerspectiveCamera).far;

			_color1.r = _color1.g = _color1.b = 1 - ThreeMath.smoothstep(v1.positionScreen.z * v1.positionScreen.w, _near, _far);
			_color2.r = _color2.g = _color2.b = 1 - ThreeMath.smoothstep(v2.positionScreen.z * v2.positionScreen.w, _near, _far);
			_color3.r = _color3.g = _color3.b = 1 - ThreeMath.smoothstep(v3.positionScreen.z * v3.positionScreen.w, _near, _far);
			_color4.addColors(_color2, _color3).multiplyScalar(0.5);

			_image = getGradientTexture(_color1, _color2, _color3, _color4);

			clipImage(_v1x, _v1y, _v2x, _v2y, _v3x, _v3y, 0, 0, 1, 0, 0, 1, _image);
		} else if (Std.is(material, MeshNormalMaterial)) {
			var normal:Vector3 = new Vector3();
			if (cast(material, MeshNormalMaterial).shading == THREE.FlatShading) {
				normal = element.normalModelView;

				_color.setRGB(normal.x, normal.y, normal.z).multiplyScalar(0.5).addScalar(0.5);

				cast(material, MeshNormalMaterial).wireframe == true
					? strokePath(_color, cast(material, MeshNormalMaterial).wireframeLinewidth, cast(material, MeshNormalMaterial).wireframeLinecap, cast(material, MeshNormalMaterial).wireframeLinejoin)
					: fillPath(_color);

			} else if (cast(material, MeshNormalMaterial).shading == THREE.SmoothShading) {
				normal = element.vertexNormalsModelView[uv1];
				_color1.setRGB(normal.x, normal.y, normal.z).multiplyScalar(0.5).addScalar(0.5);

				normal = element.vertexNormalsModelView[uv2];
				_color2.setRGB(normal.x, normal.y, normal.z).multiplyScalar(0.5).addScalar(0.5);

				normal = element.vertexNormalsModelView[uv3];
				_color3.setRGB(normal.x, normal.y, normal.z).multiplyScalar(0.5).addScalar(0.5);

				_color4.addColors(_color2, _color3).multiplyScalar(0.5);

				_image = getGradientTexture(_color1, _color2, _color3, _color4);

				clipImage(_v1x, _v1y, _v2x, _v2y, _v3x, _v3y, 0, 0, 1, 0, 0, 1, _image);
			}
		}
	}	
	
	inline function drawTriangle(x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float) {
		_context.beginPath();
		_context.moveTo( x0, y0 );
		_context.lineTo( x1, y1 );
		_context.lineTo( x2, y2 );
		_context.closePath();
	}	
	
	inline function strokePath(color:Color, linewidth:Float, linecap:String, linejoin:String) {
		setLineWidth(linewidth);
		setLineCap(linecap);
		setLineJoin(linejoin);
		setStrokeStyle(color.getStyle());

		_context.stroke();

		_elemBox.expandByScalar(linewidth * 2);
	}	
	
	inline function fillPath(color:Color) {
		setFillStyle(color.getStyle());
		_context.fill();
	}	
	
	inline function patternPath(x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float, u0:Float, v0:Float, u1:Float, v1:Float, u2:Float, v2:Float, texture:Texture) {
		//todo
	}	
	
	inline function clipImage(x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float, u0:Float, v0:Float, u1:Float, v1:Float, u2:Float, v2:Float, image:Image) {		
		// http://extremelysatisfactorytotalitarianism.com/blog/?p=2120
		var a:Float, b:Float, c:Float, d:Float, e:Float, f:Float, det:Float, idet:Float;
		var width = image.width - 1;
		var height = image.height - 1;

		u0 *= width; v0 *= height;
		u1 *= width; v1 *= height;
		u2 *= width; v2 *= height;

		x1 -= x0; y1 -= y0;
		x2 -= x0; y2 -= y0;

		u1 -= u0; v1 -= v0;
		u2 -= u0; v2 -= v0;

		det = u1 * v2 - u2 * v1;

		idet = 1 / det;

		a = (v2 * x1 - v1 * x2) * idet;
		b = (v2 * y1 - v1 * y2) * idet;
		c = (u1 * x2 - u2 * x1) * idet;
		d = (u1 * y2 - u2 * y1) * idet;

		e = x0 - a * u0 - c * v0;
		f = y0 - b * u0 - d * v0;

		_context.save();
		_context.transform(a, b, c, d, e, f);
		_context.clip();
		_context.drawImage(image, 0, 0);
		_context.restore();
	}	
	
	inline function getGradientTexture(color1:Color, color2:Color, color3:Color, color4:Color):CanvasElement {
		// http://mrdoob.com/blog/post/710
		_pixelMapData[0] = Std.int(color1.r * 255) | 0;
		_pixelMapData[1] = Std.int(color1.g * 255) | 0;
		_pixelMapData[2] = Std.int(color1.b * 255) | 0;

		_pixelMapData[4] = Std.int(color2.r * 255) | 0;
		_pixelMapData[5] = Std.int(color2.g * 255) | 0;
		_pixelMapData[6] = Std.int(color2.b * 255) | 0;

		_pixelMapData[8] = Std.int(color3.r * 255) | 0;
		_pixelMapData[9]  = Std.int(color3.g * 255) | 0;
		_pixelMapData[10] = Std.int(color3.b * 255) | 0;

		_pixelMapData[12] = Std.int(color4.r * 255) | 0;
		_pixelMapData[13] = Std.int(color4.g * 255) | 0;
		_pixelMapData[14] = Std.int(color4.b * 255) | 0;

		_pixelMapContext.putImageData(_pixelMapImage, 0, 0);
		_gradientMapContext.drawImage(_pixelMap, 0, 0);

		return _gradientMap;
	}
	
	// Hide anti-alias gaps
	inline function expand(v1:Vector4, v2:Vector4, pixels:Float) {
		var x = v2.x - v1.x, y = v2.y - v1.y,
		det = x * x + y * y, idet;

		if(det != 0) {
			idet = pixels / Math.sqrt( det );

			x *= idet; y *= idet;

			v2.x += x; v2.y += y;
			v1.x -= x; v1.y -= y;
		}
	}
	
	// Context cached methods.
	inline function setOpacity(value:Float)	{
		if (_contextGlobalAlpha != value) {
			_context.globalAlpha = value;
			_contextGlobalAlpha = value;
		}
	}	
	
	inline function setBlending(value:Int) {
		if (_contextGlobalCompositeOperation != value) {
			if (value == THREE.NormalBlending) {
				_context.globalCompositeOperation = 'source-over';
			} else if (value == THREE.AdditiveBlending) {
				_context.globalCompositeOperation = 'lighter';
			} else if (value == THREE.SubtractiveBlending) {
				_context.globalCompositeOperation = 'darker';
			}

			_contextGlobalCompositeOperation = value;
		}
	}
		
	inline function setLineWidth(value:Float) {
		if ( _contextLineWidth != value ) {
			_context.lineWidth = value;
			_contextLineWidth = value;
		}
	}	
	
	inline function setLineCap(value:String) {	
		// "butt", "round", "square"
		if (_contextLineCap != value) {
			_context.lineCap = value;
			_contextLineCap = value;
		}
	}	
	
	inline function setLineJoin(value:String) {
		// "round", "bevel", "miter"
		if (_contextLineJoin != value) {
			_context.lineJoin = value;
			_contextLineJoin = value;
		}
	}	
	
	inline function setStrokeStyle(value:String) {
		if (_contextStrokeStyle != value) {
			_context.strokeStyle = value;
			_contextStrokeStyle = value;
		}
	}	
	
	inline function setFillStyle(value:String) {
		if (_contextFillStyle != value) {
			_context.fillStyle = value;
			_contextFillStyle = value;
		}
	}	
	
	inline function setDashAndGap(dashSizeValue:Float, gapSizeValue:Float) {
		if (_contextDashSize != dashSizeValue || _contextGapSize != gapSizeValue) {
			_context.setLineDash([dashSizeValue, gapSizeValue]);
			_contextDashSize = dashSizeValue;
			_contextGapSize = gapSizeValue;
		}
	}
}

