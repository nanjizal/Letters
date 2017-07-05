package letters.paragraphPath;
#if js
import turtle.targetJS.ColorJS;#end
import turtle.Turtle;

using letters.paragraphPath.PointMaker;
class PointMaker {
    
    public var points:      Array<{ x: Float, y: Float }> = [];
    private var fin:        Void -> Void;
    private var hasFin:     Bool = false;
    private var tot:        Int;
    
    public function new( tot_: Int, fin_: Void -> Void ){
        fin = fin_;
        tot = tot_;
        Turtle.PressDownStage( createPoint );
    }
    
    function createPoint( e: EventMouse ){
        var pos = Turtle.CurrentPosInt( e );
        var g = Turtle.surface;
        points.push( {  x: pos.x, y: pos.y } );
        GraphicsPoints.drawLinePath( points );
        randomColor();
        Turtle.circle8( pos.x, pos.y);
        if( points.length == tot ){
            Turtle.clear();
            Turtle.PressDownStage( null );
            hasFin = true;
            fin();
        }
    }
    
    public function randomColor(){
        var g = Turtle.surface;
        #if js
        var col1: ColorJS = RainbowPencilColours.random();
        var string: String;
        var col3: ColorJS;
        g.strokeStyle = string = col1;
        g.lineWidth = 2;
        var col2: ColorJS = col1; #end
        
        #if flash
        var col1: Int = RainbowPencilColours.random();
        if( points.length == 1 || points.length == tot ) {
            g.lineStyle( 2, col1 , 1 );
        } else {
            g.lineStyle( 2, col1 ,1 );
        }
        var col2: Int = col1;#end
        
        while( col1 == col2 ) col2 = RainbowPencilColours.random();
        if( points.length == 0 )
        {
            #if flash g.beginFill( 0x00ff00, 1 ); #end
            #if js g.fillStyle = string = col3 = 0x00ff00; #end
        } else if( points.length == ( tot-1) ){
            #if flash g.beginFill( 0x00ff00, 1 ); #end
            #if js g.fillStyle = string = col3 = 0xff0000;#end
        } else {
            #if flash g.beginFill( col2, 1 );#end
            #if js g.fillStyle = string = col2;#end
        }
    }
}