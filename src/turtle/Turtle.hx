package turtle;

import letters.Path;// for CommandData
import haxe.macro.Compiler;
#if flash
import flash.Lib;
import flash.display.Graphics;
import flash.events.MouseEvent; #end
#if java
import = java.awt.geom.GeneralPath; #end
// add import for Java Mouse event
#if js
import js.html.CanvasRenderingContext2D; 
import js.html.Event;
import js.html.MouseEvent;
import turtle.targetJS.BasicJS;
import js.Browser;
import turtle.targetJS.ColorJS;
#end

using turtle.Turtle;

#if flash
typedef Surface = flash.display.Graphics; 
typedef EventMouse = flash.events.MouseEvent;
#end
#if java
typedef Surface = java.awt.geom.GeneralPath; #end
#if js
typedef Surface = js.html.CanvasRenderingContext2D;
typedef EventMouse = js.html.Event; #end


// TODO: abstract visual targets 
class Turtle{
    
    public static var surface: Surface;
    public function new()
    {
        #if js
        var basicJs = new BasicJs();
        surface = basicJs.surface; #end
        #if java
        var basicJava = new BasicJava();
        surface = basicJava.surface; #end
        #if flash
        surface = Lib.current.graphics; #end
    }
    
    public static var pressDownStageFunc: Array<EventMouse->Void> =[];
    
    public static inline function RemovePressDownStage(){
        for( func in pressDownStageFunc ){
            #if flash
            // assuming only one can be set at mo
            Lib.current.stage.removeEventListener( MouseEvent.MOUSE_DOWN, pressDownStageFunc[0] ); #end
            #if js
            Browser.document.body.onmousedown = null; #end
        }
    }
    
    public static inline function PressDownStage( func: EventMouse->Void ){
        if( func == null ) return RemovePressDownStage();
        #if js 
        Browser.document.body.onmousedown = func; #end
        #if flash
        Lib.current.stage.addEventListener( MouseEvent.MOUSE_DOWN, func ); #end
        
        pressDownStageFunc.push( func );
        
    }
    
    public static inline function CurrentPosFloat( e: EventMouse ):{x:Float,y:Float} {
        var currPos: {x:Float, y:Float};
        #if flash
        currPos = { x: Lib.current.mouseX, y: Lib.current.mouseY }; #end
        #if js
        var p: MouseEvent = cast e;
        currPos = { x: p.clientX, y: p.clientY }; #end
        return currPos;
    }
    
    public static inline function circle8( x: Float, y: Float ){
        var radius = 8;
        #if flash
        surface.moveTo( x, y );
        surface.drawCircle( x-(radius/2), y-(radius/2), radius );
        surface.endFill(); #end
        
        #if js
        surface.beginPath();
        surface.arc( x, y, radius, 0, 2*Math.PI, false );
        surface.stroke();
        surface.closePath();
        surface.fill(); #end
    }
    
    public static inline function CurrentPosInt( e: EventMouse ):{x:Int,y:Int} {
        var currPos: {x:Int, y:Int};
        #if flash
        currPos = { x: Math.round( Lib.current.mouseX ), y: Math.round( Lib.current.mouseY ) }; #end
        #if js
        var p: MouseEvent = cast e;
        currPos = { x: Math.round( p.clientX ), y: Math.round( p.clientY ) }; #end
        return currPos;
    }
    
    public static function lines( g: Surface, renderPath: Array<CommandData> ){
        var p: Array<Float>;
        for( cmd in renderPath ) {
            p = cmd.v0;
            var command = cmd.v1;
            switch( command ) { 
                case MoveTo: g.moveTo( p[0], p[1] );
                case LineTo: g.lineTo( p[0], p[1] );
                case _:
            }
        }
    }
    
    public static function drawCommands( g: Surface, renderPath: Array<CommandData> )
    {
        var p: Array<Float>;
        var lastCommand: Command = MoveTo;
        #if js var col: ColorJS; #end
        for( cmd in renderPath ) {
            p = cmd.v0;
            var command = cmd.v1;
            switch( command ) {
                case MoveTo:    g.moveTo( p[0], p[1] );
                case LineTo:    g.lineTo( p[0], p[1] );
                case CurveTo:   g.quadTo( p[0], p[1], p[2], p[3] );
                #if js
                case OutlineColor:
                    surface.closePath();
                    surface.stroke();
                    surface.fill();
                    surface.lineWidth = 5;
                    surface.strokeStyle = '#' + StringTools.hex( Std.int( p[ 0 ] ) , 6 );
                case FillColor: 
                    if( lastCommand != OutlineColor )
                    {
                        surface.stroke();
                        surface.closePath();
                        surface.fill();
                    }
                    surface.fillStyle = '#' + StringTools.hex( Std.int( p[ 0 ] ) , 6 );
                    surface.beginPath();
                #end
                #if flash
                case OutlineColor:
                    surface.lineStyle( 0, Std.int( p[0] ), 1 );
                case FillColor: 
                    surface.beginFill( Std.int( p[ 0 ] ), 1 );
                #end
            }
            lastCommand = command;
        }
        #if js
        surface.stroke();
        surface.closePath();
        surface.fill(); #end
    }
    
    #if flash
    public inline static function quadTo( g: Surface, x1: Float, y1: Float, x2: Float, y2: Float )
    {
        g.curveTo( x1, y1, x2, y2 );
    }
    #end
    #if java
    public inline static function quadTo( g: Surface, x1: Float, y1: Float, x2: Float, y2: Float )
    {
        g.quadTo( x1, y1, x2, y2 );
    }
    #end
    #if js
    public inline static function quadTo( g: Surface, x1: Float, y1: Float, x2: Float, y2: Float )
    {
        g.quadraticCurveTo( x1, y1, x2, y2 );
    }
    #end
    public inline static function clear(){
        #if js
        surface.clearRect ( 0, 0
                        ,   Std.parseInt( Compiler.getDefine("windowWidth") )
                        ,   Std.parseInt( Compiler.getDefine("windowHeight") ) ); #end
        #if flash
        surface.clear();#end
    }
}