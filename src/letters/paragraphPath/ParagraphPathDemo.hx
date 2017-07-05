package letters.paragraphPath;
import turtle.Turtle;
import letters.Path;
import letters.pathway.MathPoints;
import letters.pathway.Equa;
import letters.pathway.Sides;
using turtle.Turtle;
using letters.Path;
class ParagraphPathDemo {
    
    private inline static var numBeziers:     Int = 40;
    private inline static var numSections:    Int = 100;
    
    private var pointMaker:     PointMaker;
    
    public static function main(){ new ParagraphPathDemo(); }
    
    public function new(){
        new Turtle();
        showInstructions();        
        pointMaker = new PointMaker( numBeziers, draw );
    }
    
    private function showInstructions()
    {
        var coloring = Path.rainbowPencilHighlight;
        var instructions = "click on screen to create a path of forty points for the text to follow";
        var path = Path.generateVectorText( instructions, 100., 50., .7, 300., 22., null, coloring );
        path = path.rotateXYZ( Math.PI/10, Math.PI/3, Math.PI/10, 1 );
        path = path.scale( 3, 3 );
        var g = Turtle.surface;
        g.drawCommands( path );
    }
    
    private function draw()
    {
        var points = pointMaker.points;
        points = MathPoints.generateMidPoints( pointMaker.points );
        var equaPoints = Equa.getEquaPoints( points, numSections );
        var sidePoints = Sides.getPoints( equaPoints.points );
        // render shape...
        //var snake = new Snake( sidePoints, numSections );
        var sentence = 'hi my name is justin and i live in bath a small city in the south west of the uk';
        new ParagraphPathRepeat( sentence, sidePoints );
        
    }
    
}