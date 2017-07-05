package letters.luxe;

import hxDaedalus.graphics.SimpleDrawingContext;
import hxDaedalus.data.math.Point2D;
import luxe.Input.Key;
import luxe.Input.KeyEvent;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture;
import letters.Path;
import hxDaedalus.data.Mesh;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.data.Object;
import hxDaedalus.data.ConstraintSegment;
import hxDaedalus.data.Vertex;
import hxDaedalus.graphics.TargetCanvas;
import hxDaedalus.view.SimpleView;
import hxDaedalus.data.math.MathPoints;
import hxDaedalus.data.math.Tools;
import hxDaedalus.data.Edge;
import hxDaedalus.data.math.Geom2D;
import luxe.Color;
import phoenix.geometry.Geometry;
import luxe.Vector;
import phoenix.Batcher;
using letters.Path;
typedef DPoint2D = hxDaedalus.data.math.Point2D;
typedef PVertex = phoenix.geometry.Vertex;
class TriangleFillExample extends luxe.Game {
	static inline var letters = 'abcdefghijklmnopqrstuvwxyz';
	var lettersArr: Array<String>;
	var letterIds = new Array<String>();
	var letterData = new Array<String>();
	var arrObject: Array<Object>;
	var arrShapes: Array<Array<Float>>;
	// entry point
    override function ready() {
		// white background
		Luxe.renderer.clear_color.rgb(0x000000);
		// get the letter strings
		for( letter in 0...letterIds.length ) letterData[letter] = Luxe.resources.text( letterIds[letter] ).asset.text;
        var wid: Int = 600;
		var hi: Int = 400;
        var path = Path.generateVectorText(     'luxe'
                                            ,   100., 50., .7, 300., 22., null, Path.rainbowPencilHighlight );
		path = path.rotateXYZ( Math.PI/10, Math.PI/3, Math.PI/10, 1 );
		var dim = Path.getDim( path ); // not used
		arrObject = new Array<Object>();
		arrShapes = new Array<Array<Float>>();
		path = path.scale( 5, 5 );
		path = path.translate( -320, -150 );
		var dx = 0;
		var dy = 0;
        var p: Array<Float>;
		var obj: Object = new Object();
		var coord: Array<Float>= new Array<Float>();
		var count = 0;
		var moveTos= 0;
		var startX:Float = 0;
		var startY:Float = 0;
		trace( path.length );
        for( cmd in path ) {
            p = cmd.v0;
			count++;
            switch( cmd.v1 ) {
                case MoveTo:
					coord.push( startX );
					coord.push( startY );
					obj.coordinates = coord;
					if( moveTos != 0 ) 
					{
						arrShapes.push( coord );
					}
					moveTos += 1;
					obj = new Object();
					obj.x = 0;
					obj.y = 0;
					arrObject.push( obj );
					coord = new Array<Float>();
					coord.push( p[0] );
					coord.push( p[1] );
					startX = p[0];
					startY = p[1];
                case LineTo:
					lineTo( coord, p[0], p[1] );
                case CurveTo:
					quadTo( coord, p[0], p[1], p[2], p[3] );
                case _:
			}
        }
		coord.push( startX );
		coord.push( startY );
		obj.coordinates = coord;
		arrShapes.push( coord );
        var vertices = new Array<DPoint2D>();
        var triangles = new Array<Int>();
		Tools.extractMeshFromShapes( arrShapes, wid, hi, vertices, triangles, true ); // invert winding
		var i: Int = 0;
		while( i < triangles.length ){
			fillTriangles( vertices[triangles[i]], vertices[triangles[i+1]], vertices[triangles[i+2]], 0xff0000 );
			i+=3;
		}
		var g = new SimpleDrawingContext( new TargetCanvas() );
		g.lineStyle(1,0xffcc00);
		for( cmd in path ) {
			p = cmd.v0;
			switch( cmd.v1 ) {
				case MoveTo:
					g.moveTo( p[0], p[1] );
				case LineTo:
					g.lineTo( p[0], p[1] );
					g.lineTo( p[0], p[1] );
				case CurveTo:
					g.quadTo( p[0], p[1], p[2], p[3] );
				case _:
			}
		}
	}

	public inline static function vertexConverter( v: DPoint2D, col: Color ):PVertex {
		return new PVertex( new Vector( v.x, v.y ), col  );
	}

	inline function fillTriangles( v0: DPoint2D, v1: DPoint2D, v2: DPoint2D, col_: Int ): Geometry {
		var shape = new Geometry({
            primitive_type:PrimitiveType.triangles,
            batcher: Luxe.renderer.batcher,
        });
		//col_ = randomColor();
        var col = new Color().rgb( col_ );
		shape.depth = -1;
        shape.add( vertexConverter( v0, col ) );
        shape.add( vertexConverter( v1, col ) );
        shape.add( vertexConverter( v2, col ) );
		return shape;
	}

	@:access( letters.Path.rainbowPencilColors )
	function randomColor(): Int {
		var rand = Std.int(Math.random()*(Path.rainbowPencilColors().length - 1));
		var col_ = Path.rainbowPencilColors()[ rand ];
		return col_;
	}

    override function update( dt: Float ) {
	} // update

	inline function lineTo( coord: Array<Float>, x: Float, y: Float ): Void {
		coord.push( x );
		coord.push( y );
		coord.push( x );
		coord.push( y );
	}

	inline function quadTo( coord: Array<Float>, cx: Float, cy: Float, ax: Float, ay: Float ): Void {
		var _prevX = coord[ coord.length-2 ];
		var _prevY = coord[ coord.length-1 ];
		var p0 = { x: _prevX, y: _prevY };
		var p1 = { x: cx, y: cy };
		var p2 = { x: ax, y: ay }
		var approxDistance = MathPoints.distance( p0, p1 ) + MathPoints.distance( p1, p2 );
		var factor = 2;
		var v:{x: Float, y:Float };
		if( approxDistance == 0 ) approxDistance = 0.000001;
		var step = 0.1;
		var arr = [ p0, p1, p2 ];
		var t = 0.0;
		lineTo( coord, _prevX, _prevY );
		t += step;
		while( t < 1 ){
			v = MathPoints.quadraticBezier( t, arr );
			lineTo( coord, v.x, v.y );
			t+=step;
		}
		lineTo( coord, ax, ay );
	}

	override function onkeyup( e: KeyEvent ) {
		if (e.keycode == Key.escape) Luxe.shutdown();
    }

	override function config( config: luxe.AppConfig ) {
		lettersArr = letters.split('');
		for( i in 0...lettersArr.length ){
			var letter = lettersArr[i];
			letterIds.push( 'assets/$letter.txt' );
			config.preload.texts.push({ id:'assets/$letter.txt' });
		}
    	//config.render.antialiasing = 4;
    	return config;
	}

}
