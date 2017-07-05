package letters.paragraphPath;

import letters.Path;
import haxe.Resource;
import haxe.Timer;

using letters.paragraphPath.GraphicsPoints;
using letters.pathway.Sides;
using turtle.Turtle;
using letters.Path;

class ParagraphPathRepeat{
    
    private var path1: Array<CommandData>;
    private var sidePoints: Array<SidePoint>;
    private var sidePoints2: Array<SidePoint>;
    private var count: Float = 0;
    public function new( sentence :String, sidePoints_: Array<SidePoint> ){
        Turtle.clear();
        sidePoints = sidePoints_;
        var coloring = Path.rainbowPencilHighlight;
        var path = Path.generateVectorText( sentence, 43., 200., .7, 640., 22., coloring, coloring );
        path1 = path.translate( 43, -197 );
        path1 = path1.scale( 1.4, -0.3 );
        path1 = path1.translate( 0, 10 );
        sidePoints2 = [].concat( sidePoints );
        var timer = new Timer( 30 );
        timer.run = redraw; 
    }
    
    public function redraw(){
        count+=0.1;
        Turtle.clear();
        for( i in 0...sidePoints.length )
        {
            sidePoints2[i].dx = sidePoints[i].dx + 0.5*Math.sin(  count );
            sidePoints2[i].dy = sidePoints[i].dy + 0.5*Math.cos(  count );
        }
        var renderPath: Array<CommandData> = sidePoints2.mapToRouting( path1 );
        var g = Turtle.surface;
        g.drawCommands( renderPath );
        renderPath.drawCommandsMore();
        var aPath: Array<CommandData>;
        var lastPath = path1;
        var k: Int;
        var paragraphWidth = lastPath.getDim().end.x;
        var maxY = sidePoints.length + 1;
        while( true ){
            aPath           = lastPath.translate( path1.getDim().end.x + 1, 0  );
            paragraphWidth  = aPath.getDim().end.x;
            if( paragraphWidth > maxY ) break;
            renderPath  = sidePoints2.mapToRouting( aPath );
            g.drawCommands( renderPath );
            lastPath    = aPath;
        }
    }
    
    
    
}