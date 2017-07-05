package letters.pathway;

typedef EquaPoints = {
    totDistance:    Float,
    currDistance:   Array<Float>,
    accumDistance:  Array<Float>,
    points:         Array<{ x: Float, y: Float }>
}

class Equa
{
    public inline static function getEquaPoints(    pointsIn: Array<{ x: Float, y: Float }>
                                                ,   numSections: Int ): EquaPoints {
        
        var totDistance:    Float;
        var currDistance:   Array<Float> = [];
        var accumDistance:  Array<Float> = [];
        var points:         Array<{ x: Float, y: Float }> = [];
        totDistance = 0;
        
        var dist3 = new ThreeIterator<{ x: Float, y: Float}>( 0, pointsIn.length, 1 );
        dist3.arr = pointsIn;
        for( dist in dist3 ){
            var pNext = dist3.arrNext;
            var d = MathPoints.distance( pNext[0], pNext[1] );
            currDistance.push( d );
            accumDistance.push( totDistance );
            totDistance += d;
        }
        
        var iterator3 = new ThreeIterator<{ x: Float, y: Float}>( 0, pointsIn.length, 2 );
        iterator3.arr = pointsIn;
        
        for( i in iterator3 ) {
            var factor: Float;
            var factorWorks = 1/ numSections;
            if( currDistance.length > i ) {
                factor = 10*currDistance[ i ]/totDistance;
            } else {
                factor = factorWorks;
            }
            if( factor == 0 ) factor = factorWorks;
            var it0_1 = new Iterator0_1( factorWorks );
            var pNext = iterator3.arrNext;
            
            for( t in it0_1 ) points.push( MathPoints.quadraticBezier( t, pNext ) );
        }
        
        return {
            totDistance:    totDistance,
            currDistance:   currDistance,
            accumDistance:  accumDistance,
            points:         points
        }
    }
    
}