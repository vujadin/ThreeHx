package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;

import openfl.display.OpenGLView;

import com.gamestudiohx.three.scenes.Scene;
import com.gamestudiohx.three.cameras.PerspectiveCamera;
import com.gamestudiohx.three.objects.Mesh;
import com.gamestudiohx.three.lights.DirectionalLight;
import com.gamestudiohx.three.extras.geometries.TorusKnotGeometry;
import com.gamestudiohx.three.materials.MeshBasicMaterial;
import com.gamestudiohx.three.materials.MeshNormalMaterial;
import com.gamestudiohx.three.renderers.WebGLRenderer;

/**
 * ...
 * @author Krtolica Vujadin
 */

class Main extends Sprite {
	var inited:Bool;

	var scene:Scene;
	var camera:PerspectiveCamera;
	var cube:Mesh;
	var torus:Mesh;
	var renderer:WebGLRenderer;
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		scene = new Scene();
		camera = new PerspectiveCamera(50, 1000 / 600, 0.1, 2000);
		
		var material = new MeshBasicMaterial({wireframe: false, color: 0xff0000});
		var geometry = new TorusKnotGeometry();
		//var geometry = new CubeGeometry();
		cube = new Mesh(geometry, material);
		var material2 = new MeshNormalMaterial();
		var geometry2 = new TorusKnotGeometry();
		
		torus = new Mesh(geometry2, material2);
		scene.add(torus);
		scene.add(cube);
		camera.position.z = 550;
		camera.lookAt(cube.position);	
		cube.translateX( -170);
		torus.translateX(200);
		
		var light = new DirectionalLight( 0xffffff );
		light.position.set( 0, 0, 1 );
		scene.add( light );
		
		trace(OpenGLView.isSupported);
		if(OpenGLView.isSupported) {
			renderer = new WebGLRenderer( { antialias: true } );
			renderer._canvas.render = render;
			//renderer.setSize(renderer._canvas.width, renderer._canvas.height);
		}
		
		addChild(renderer._canvas);
		
		render();
	}
	
	var counter:Int = 0;
	private function render(rect:Rectangle = null):Void {
		cube.rotation.x += 0.01;
		cube.rotation.y += 0.02;
		
		torus.rotation.x += 0.01;
		torus.rotation.y += 0.02;
 
		if(counter++ < 100) {
			renderer.render(scene, camera);
		}
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
