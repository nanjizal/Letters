package letters.paragraphPath;

import letters.Path;
import turtle.Turtle;
#if js
import turtle.targetJS.ColorJS; #end

using turtle.Turtle;
class GraphicsPoints
{
    public static inline function drawLinePath( arr: Array<{x: Float,y: Float}> ){
        var g = Turtle.surface;
        var string: String;
        
        #if flash
        g.lineStyle( 0, 0x333333, 1); #end
        #if js
        var col: ColorJS;
        g.fillStyle = "rgba("+ 0xff +"," + 0x00 +","+0xff+","+0.0 +")";
        g.strokeStyle = string = col = 0x333333;
        g.lineWidth = 1; #end
        
        g.moveTo( arr[ 0 ].x, arr[ 0 ].y );
        for( p in arr ) {//RainbowPencilColours.random()
            //g.lineStyle( 0, 0xff0000 , 1);
            g.lineTo( p.x, p.y );
        }
        #if js
        g.stroke(); #end 
        //g.closePath();
    }
    
    public static inline function drawCommandsMore( renderPath:Array<CommandData>
                                                    )
    {
        
        #if js var col: ColorJS; #end
        var g = Turtle.surface;
        #if flash
        g.lineStyle( 0, 0, 1); #end
        #if js
        g.strokeStyle = col = 0;
        g.lineWidth = 1; #end
        
        #if flash
        g.beginFill( 0, 1 ); #end
        #if js
        g.fillStyle = col = 0;
        g.beginPath(); #end
        
        g.drawCommands( renderPath );
        
        #if js 
        g.stroke();
        g.closePath();
        g.fill(); #end
        
        #if flash
        g.endFill(); #end
    }
    
    public static inline function drawCommandsAndFill( renderPath:Array<CommandData>,
                                                        line:Int, fill: Int 
                                                    )
    {
        
        #if js var col: ColorJS; #end
        var g = Turtle.surface;
        #if flash
        g.lineStyle( 0, line, 1); #end
        #if js
        g.strokeStyle = col = line;
        g.lineWidth = 1; #end
        
        #if flash
        g.beginFill( fill, 1 ); #end
        #if js
        g.fillStyle = col = fill;
        g.beginPath(); #end
        
        g.drawCommands( renderPath );
        
        #if js 
        g.stroke();
        g.closePath();
        g.fill(); #end
        
        #if flash
        g.endFill(); #end
    }
}