package letters.pathway;
import letters.Path;
typedef SidePoint = {
    x:  Float,
    y:  Float,
    dx: Float,
    dy: Float
}

class Sides {
    
    public inline static function getPoints( points_:Array<{ x: Float, y: Float}> ) {
        var thetas:     Array<Float> = [];
        var points:     Array<SidePoint> = [];
        var iterTheta3 = new ThreeIterator<{ x: Float, y: Float}>( 0, points_.length, 1 );
        iterTheta3.arr = points_;
        for( i in iterTheta3 ) thetas.push( createTheta( iterTheta3.arrNext ) );
        thetas.unshift( thetas[0] );
        thetas.unshift( thetas[0] );
        
        var aSidePoint: SidePoint;
        var lastSidePoint: SidePoint = createInitSidePoint( thetas[ 0 ], points_[ 0 ] );
        
        var count = 0;
        for( p in points_ ) {
            aSidePoint = createSidePoints( thetas[ count ], lastSidePoint, p );
            count++;
            points.push( aSidePoint );
            lastSidePoint = aSidePoint;
        }
        return points;
    }
    
    private inline static function createTheta( pNext: Array<{ x: Float, y: Float }> ): Float {
        return (   
                MathPoints.arcTan( pNext[ 0 ], pNext[ 1 ] ) +
                MathPoints.arcTan( pNext[ 1 ], pNext[ 2 ] ) 
            )/2;
    }
    
    private inline static function createInitSidePoint( theta: Float
                                        , nextP: { x: Float, y: Float } ): SidePoint {
        var dx = 5*Math.cos( theta + Math.PI/2 );
        var dy = 5*Math.sin( theta + Math.PI/2 );
        return { x: nextP.x, y: nextP.y, dx: dx, dy: dy };
    }
    
    private inline static function createSidePoints( theta: Float
                                    , lastSp: SidePoint
                                    , nextP: { x: Float, y: Float } ): SidePoint {
        var dx = 5*Math.cos( theta + Math.PI/2 );
        var dy = 5*Math.sin( theta + Math.PI/2 );
        var x1 = nextP.x + 15*dx;
        var y1 = nextP.y + 15*dy;
        var x2 = nextP.x - 15*dx;
        var y2 = nextP.y - 15*dy;
        var sAx = lastSp.x + 15*lastSp.dx;
        var sAy = lastSp.y + 15*lastSp.dy;
        var sBx = lastSp.x - 15*lastSp.dx;
        var sBy = lastSp.y - 15*lastSp.dy;
        var same = Math.abs( distance( x1, y1, sAx, sAy ) - distance( x2, y2, sBx, sBy ) );
        var dif  = Math.abs( distance( x2, y2, sAx, sAy ) - distance( x1, y1, sBx, sBy ) );
        var totSame = distance( x1, y1, sAx, sAy ) + distance( x2, y2, sBx, sBy );
        var totDif  = distance( x2, y2, sAx, sAy ) + distance( x1, y1, sBx, sBy );
        if( same > dif && totSame < totDif ) {} else {
            dx = -dx;
            dy = -dy;
        }
        return { x: nextP.x, y: nextP.y, dx: dx, dy: dy };
    }
    
    // to get the distance between first point and second point
    private static inline function distance( p0x: Float, p0y: Float
                                           , p1x: Float, p1y: Float ) : Float {
        var x = p0x-p1x;
        var y = p0y-p1y;
        return Math.sqrt(x*x + y*y);
    }
    
    // take a letter path and draw it along a sides
    public static inline function mapToRouting( sidePoints_: Array<SidePoint>
                                              , pathIn: Array<CommandData> 
                                              ): Array<CommandData> {
        var sp = sidePoints_; 
        return Path.mapArr( pathIn, function( v ) {
            var v0 = v.v0;
            var v1 = v.v1;
            var p1 = sp[ Math.round( v0[0] ) ];
            switch( v1 ){
                case LineTo, MoveTo:
                    v0 = [  p1.x + v0[1] * p1.dx, p1.y + v0[1] * p1.dy ];
                case CurveTo:
                    var p2 = sp[ Math.round( v0[2] ) ];
                    v0 = [ p1.x + v0[1] * p1.dx, p1.y + v0[1] * p1.dy
                         , p2.x + v0[3] * p1.dx, p2.y + v0[3] * p1.dy ];
                case _:
            }
            var commandData: CommandData = new T2( v0, v1 );
            return commandData;
        });
    }
    
}