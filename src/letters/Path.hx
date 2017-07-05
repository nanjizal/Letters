 
 
 
package letters;
using letters.Path;

// Tuples just T_2 from the goodies library- https://github.com/deltaluca/goodies
// goodies author: Luca Deltodesco
typedef T_2<S,T> = { v0 : S, v1 : T };
abstract T2<S,T>(T_2<S,T>) from T_2<S,T> to T_2<S,T> {
    inline public function new (s:S,t:T) this = {v0:s,v1:t};
    public inline static function make<S,T>(s:S,t:T) return new T2(s,t);
    public var v0(get,set):S; inline function get_v0() return this.v0; inline function set_v0(v0:S) return this.v0 = v0;
    public var v1(get,set):T; inline function get_v1() return this.v1; inline function set_v1(v1:T) return this.v1 = v1;
    inline public function toString() return '($v0,$v1)';
}
//

@:enum
abstract Command( String ) {
    var MoveTo  = "M";
    var LineTo  = "L";
    var CurveTo = "Q";
    var FillColor = "F";
    var OutlineColor = "O";
}
typedef CommandData = T2<Array<Float>,Command>;
typedef Point2D = {
    var x: Float;
    var y: Float;
}
typedef Point3D = {
    > Point2D,
    var z : Float;
}
typedef DimInfo     = { pos: Point2D, dim: Point2D, centre: Point2D, end: Point2D };

class Path {
    
    static inline function rainbowPencilColors(){ return [   0xD2D0C1
                                                            ,   0xCD8028
                                                            ,   0xD29D11
                                                            ,   0xE37128
                                                            ,   0xF06771
                                                            ,   0xD23931
                                                            ,   0xAF2C31
                                                            ,   0x90333E
                                                            ,   0x863D50
                                                            ,   0x584A5D
                                                            ,   0x549EC3
                                                            ,   0x2C709D
                                                            ,   0x457AAE
                                                            ,   0x364D6D
                                                            ,   0x378C6D
                                                            ,   0x6EA748
                                                            ,   0x365DA4
                                                            ,   0x456E42
                                                            ,   0xC1882E
                                                            ,   0x813424
                                                            ,   0x402E24
                                                            ,   0x292420
                                                            ,   0x525751
                                                            ,   0x1B1B19
                                                            ]; }
    
    public var length:  Int;
    private var count:  Int;
    private var str:    String;
    private var last:   Command;
    public var left:    Float = 1000000;
    public var top:     Float = 1000000;
    public var right:   Float = -1000000;
    public var bottom:  Float = -1000000;
    public var hasIterated: Bool = false;
    public function new( str_: String ) {
        count = 0;
        //trace( str_ );
        length = str_.length;
        str = str_;
    }
    public function iterator ():Iterator<CommandData> { 
        count = 0;
        return this;
    }
    public function hasNext(): Bool {
        var hasAnother = count < length;
        // store if iterrated once, used for getting dimensions
        if( !hasAnother ) hasIterated = true;
        return hasAnother;
    }
    public function next(): CommandData {
        var command = str.charAt( count++ );
        var commandEnum: Command;
        // ignore space
        if( command == " " ) command = str.charAt( count++ );
        // if number use last draw type
        if( isNum( command ) ) {
            commandEnum = last;
            count--;
        } else {
            commandEnum = cast command;
        }
        return switch( commandEnum ){
            case LineTo:
                createCommandData( 2, LineTo );
            case CurveTo:
                createCommandData( 4, CurveTo );            
            case MoveTo,_:
                createCommandData( 2, MoveTo );
        }
    }
    public inline function createCommandData( len: Int, command: Command ): CommandData {
        last = command;
        var num = '';
        var increment = 0;
        var isX = true;
        var arr = new Array<Float>();
        while( increment < len ) {
            var char = str.charAt( count );
            count++;
            if( isNumOrDot( char ) ) {
                num += char;
            }else{
                isX = !isX;
                var out = Std.parseFloat( num );
                if( isX ) {
                    if( out < left ) left = out;
                    if( out > right ) right = out;
                } else {
                    if( out < top ) top = out;
                    if( out > bottom ) bottom = out;
                }
                num = '';
                arr.push( out );
                increment++;
            }
        }
        count--;
        var commandData: CommandData = new T2( arr, command );
        return commandData;
    }
    public function getCentre(): Point2D
    {
        if( !hasIterated ) this.mapArr( function(v){return v;} );
        return {    x: left + ( right - left)/2
                ,   y: top + (bottom - top)/2
                };
    }
    public inline static function isNum( x: String ): Bool {
        switch( x ){
            case '0','1','2','3','4','5','6','7','8','9': return true;
            case _: return false;
        }
    }
    public inline static function isNumOrDot( x: String ): Bool {
        return  isNum( x ) || x =='.';
    }
    public static inline function generateVectorText( str: String
                                                    , x: Float, y: Float
                                                    , scale: Float
                                                    , ?width: Float, ?lineSpace: Float
                                                    , ?path: Array<CommandData>
                                                    , ?highlightFunction:String->Float
                                                    , ?outlineFunction:String->Float
                                                    ): Array<CommandData> {
        if( path == null ) path = new Array<CommandData>();
        if( width == null ) 
        { 
            width = 1000000; lineSpace = 0;
        }
        //var kernPairs = new KernPairs();
        var temp: Array<CommandData>;
        var x1 = x;
        var x2 = x;
        var dx = 0.;
        var y1 = y;
        var tempDim: DimInfo;
        var word = new Array<CommandData>();
        var lastLetterX1: Float = 0;
        var letterResource = new LetterResource();
        var arrStr = str.split('');
        var counta = 0;
        // TODO: refactor this rather than repeat twice?
        if( highlightFunction != null ){
            var j = '';
            var count: Int = counta + 1;
            var wordContent = '';
            if( count < arrStr.length ){
                while( j != ' ' && count < arrStr.length ){
                    j = arrStr[ count ];
                    if( j != ' ' ) wordContent = wordContent + j; 
                    count++;
                }
                var float: Array<Float> = [ cast highlightFunction( wordContent ) ];
                var commandEnum: Command = cast "F";
                var fillColor: CommandData = new T2( float , commandEnum );
                if( outlineFunction != null )
                {
                    float = [ cast outlineFunction( wordContent ) ];
                    commandEnum = cast "O";
                    var outlineColor: CommandData = new T2( float , commandEnum );
                    path.push( outlineColor );
                }
                path.push( fillColor );
            }
        }
        for( i in arrStr ){
            x2 = x1;
            //x1 += kernPairs.getNextSpace( i )*scale;
            //trace( " i " + i + " _");
            if( i != ' ' && i != '' ) {
                y1 = y;
                var vert = LetterResource.verticalAdj( i ); 
                var preX = LetterResource.preAdjustX( i );
                if( vert != 0 )     y1 += vert*scale;
                if( preX != 0 )     x1 += preX*scale;
                temp = ( letterResource.getLetter( i ) ).scaleTranslate( x1, y1, scale, scale );
                tempDim = temp.getDim();
                dx = x2 - tempDim.pos.x;
                var postX = LetterResource.postAdjustX( i );
                if( postX != 0 )    x1 += postX*scale;
                if( preX != 0 )     dx += preX*scale;
                x1 += tempDim.dim.x + 2*scale;
                temp = temp.translate( dx, 0 );
                if( x1 > width )
                {
                    y += lineSpace;
                    word = word.concat( temp );
                    var dim2 = word.getDim();
                    var repos = x - dim2.pos.x;
                    word = word.translate( repos , lineSpace );
                    x1 = x1 + repos;
                }else{
                    word = word.concat( temp );
                }
            } else {
                path = path.concat( word );
                if( highlightFunction != null ){
                    var j = '';
                    var count: Int = counta + 1;
                    var wordContent = '';
                    if( count < arrStr.length ){
                        // potentially rather heavy!
                        while( j != ' ' && count < arrStr.length ){
                            j = arrStr[ count ];
                            if( j != ' ' ) wordContent = wordContent + j; 
                            count++;
                        }
                        var float: Array<Float> = [ cast highlightFunction( wordContent ) ];
                        var commandEnum: Command = cast "F";
                        var fillColor: CommandData = new T2( float , commandEnum );
                        if( outlineFunction != null )
                        {
                            float = [ cast outlineFunction( wordContent ) ];
                            commandEnum = cast "O";
                            var outlineColor: CommandData = new T2( float , commandEnum );
                            path.push( outlineColor );
                        }
                        path.push( fillColor );
                    }
                }
                x1 += LetterResource.space()*scale;
                word = new Array<CommandData>();
            }
            counta++;
        }
        path = path.concat( word );
        return path;
    }
    
    public static inline function rainbowPencilHighlight( str: String ): Int {
        var rand = Std.int(Math.random()*(rainbowPencilColors().length - 1));
        var col = rainbowPencilColors()[ rand ];
        return col;
    }
    
    public static inline function highlightAnd( str: String )
    {
        //trace( '_' + str + '_');
        if( str == "and" ) return 0xFF0000;
        if( str =="in" ) return 0x00ffff;
        return 0xFFCC00;
    }
    
    public static inline function translate(    path: Iterable<CommandData>
                                            ,   x_: Float, y_:Float 
                                            ):  Array<CommandData> {
        var x = x_;
        var y = y_;
        var x0 = x == 0;
        var y0 = y == 0;
        if( x0 && y0 ) return Lambda.array( path );
        if( x0 ){
            return mapArr( path, function( v ) {
                var v0 = v.v0;
                var v1 = v.v1;
                switch( v1 ){
                    case LineTo, MoveTo:
                        v0 = [ v0[0], y + v0[1] ];
                    case CurveTo:
                        v0 = [ v0[0], y + v0[1], v0[2], y + v0[3] ];
                    case _:
                }
                var commandData: CommandData = new T2( v0, v1 );
                return commandData;
            });
        } 
        if( y0 ) {
            return mapArr( path, function( v ) {
                var v0 = v.v0;
                var v1 = v.v1;
                switch( v1 ){
                    case LineTo, MoveTo:
                        v0 = [ x + v0[0], v0[1] ];
                    case CurveTo:
                        v0 = [ x + v0[0], v0[1], x + v0[2], v0[3] ];
                    case _:
                }
                var commandData: CommandData = new T2( v0, v1 );
                return commandData;
            });
        }
        return mapArr( path, function( v ) {
            var v0 = v.v0;
            var v1 = v.v1;
            switch( v1 ){
                case LineTo, MoveTo:
                    v0 = [ x + v0[0], y + v0[1] ];
                case CurveTo:
                    v0 = [ x + v0[0], y + v0[1], x + v0[2], y + v0[3] ];
                case _:
            }
            var commandData: CommandData = new T2( v0, v1 );
            return commandData;
        });
    }
    public static inline function scale(    path: Iterable<CommandData>
                                        ,   x_: Float, y_:Float 
                                        ):  Array<CommandData> {
        var x = x_;
        var y = y_;
        var x0 = x == 1;
        var y0 = y == 1;
        if( x0 && y0 ) return Lambda.array( path );
        if( x0 ) {
            return mapArr( path, function( v ) {
                var v0 = v.v0;
                var v1 = v.v1;
                switch( v1 ){
                    case LineTo, MoveTo:
                        v0 = [ v0[0], y * v0[1] ];
                    case CurveTo:
                        v0 = [ v0[0], y * v0[1], v0[2], y * v0[3] ];
                    case _:
                }
                var commandData: CommandData = new T2( v0, v1 );
                return commandData;
            });
        } 
        if( y0 ) {
            return mapArr( path, function( v ) {
                var v0 = v.v0;
                var v1 = v.v1;
                switch( v1 ){
                    case LineTo, MoveTo:
                        v0 = [ x * v0[0], v0[1] ];
                    case CurveTo:
                        v0 = [ x * v0[0], v0[1], x * v0[2], v0[3] ];
                    case _:
                }
                var commandData: CommandData = new T2( v0, v1 );
                return commandData;
            });
        }
        return mapArr( path, function( v ) {
            var v0 = v.v0;
            var v1 = v.v1;
            switch( v1 ){
                case LineTo, MoveTo:
                    v0 = [ x * v0[0], y * v0[1] ];
                case CurveTo:
                    v0 = [ x * v0[0], y * v0[1], x * v0[2], y * v0[3] ];
                case _:
            }
            var commandData: CommandData = new T2( v0, v1 );
            return commandData;
        });
    }
    public static inline function scaleTranslate(  path: Iterable<CommandData>
                                        ,   x_: Float, y_:Float 
                                        ,   sx_: Float, sy_:Float
                                        ):  Array<CommandData> {
        var x = x_;
        var y = y_;
        var sx = sx_;
        var sy = sy_;
        return mapArr( path, function( v ) {
            var v0 = v.v0;
            var v1 = v.v1;
            switch( v1 ){
                case LineTo, MoveTo:
                    v0 = [ sx * v0[0] + x, sy * v0[1] + y ];
                case CurveTo:
                    v0 = [ sx * v0[0] + x, sy * v0[1] + y, sx * v0[2] + x, sy * v0[3] + y ];
                case _:
            }
            var commandData: CommandData = new T2( v0, v1 );
            return commandData;
        });
    }
    public static inline var fl: Float = 420;
    public static function rotateXYZ(   path: Iterable<CommandData>
                                    ,   rX: Float, rY: Float, rZ: Float
                                    ,   zSpecial: Float
                                    ,   ?ox: Float, ?oy: Float, ?oz: Float
                                    ):  Array<CommandData> {
        // if no rotation point defined assume centre of path
        if( ox == null || oy == null || oz == null ) {
            var dim = path.getDim();
            var centre = dim.centre;
            ox = centre.x;
            oy = centre.y;
            oz = zSpecial;
        }
        var sX = Math.sin( rX ); 
        var sY = Math.sin( rY ); 
        var sZ = Math.sin( rZ );
        var cX = Math.cos( rX ); 
        var cY = Math.cos( rY ); 
        var cZ = Math.cos( rZ );
        var x: Float;
        var y: Float;
        var z: Float;
        var x2: Float;
        var y2: Float;
        var z2: Float;
        var tx: Float;
        var ty: Float;
        var tz: Float;
        var s: Float;
        var fL = fl;
        return mapArr( path, function( v ) {
            var v0 = v.v0;
            var v1 = v.v1;
            switch( v1 ) {
                case MoveTo, LineTo:
                    tx = v0[0] - ox;
                    ty = v0[1] - oy;
                    tz = zSpecial - oz;
                    x = tx*cY*cZ + tz*sY - ty*sZ + ox;
                    y = ty*cX*cZ -tz*sX + tx*sZ + oy;
                    z = ty*sX + tz*cX*cY - tx*sY + oz;
                    s = 1-(-z)/fL;
                    v0 = [ x/s, y/s ];
                case CurveTo:
                    tx = v0[0] - ox;
                    ty = v0[1] - oy;
                    tz = zSpecial - oz;
                    x = tx*cY*cZ + tz*sY - ty*sZ + ox;
                    y = ty*cX*cZ -tz*sX + tx*sZ + oy;
                    z = ty*sX + tz*cX*cY - tx*sY + oz;
                    s = 1-(-z)/fL;
                    x = x/s;
                    y = y/s;
                    tx = v0[2] - ox;
                    ty = v0[3] - oy;
                    tz = zSpecial - oz;
                    x2 = tx*cY*cZ + tz*sY - ty*sZ + ox;
                    y2 = ty*cX*cZ -tz*sX + tx*sZ + oy;
                    z2 = ty*sX + tz*cX*cY - tx*sY + oz;
                    s = 1-(-z2)/fL;
                    x2 = x2/s;
                    y2 = y2/s;
                    v0 = [ x, y, x2, y2 ];
                case _:
            }
            var commandData: CommandData = new T2( v0, v1 );
            return commandData;
        });
    }
    // width, height, centreX, centreY 
    public static inline function getDim( path: Iterable<CommandData>): DimInfo
    {
        // TODO: Need to investigate especially issue with 'c' not render
        #if java
            var l:   Float = 1000000.0;
            var t:   Float = 1000000.0;
            var r:   Float = -1000.0;
            var b:   Float = -1000.0;
        #else
            var l:   Float = 1000000;
            var t:   Float = 1000000;
            var r:   Float = -1000000;
            var b:   Float = -1000000;
        #end
        var x:   Float;
        var y:   Float;
        var count: Int = 0;
        for( i in path )
        {
            var v = i.v0;
            var command = i.v1;
            switch( command ){
                case MoveTo, LineTo, CurveTo:
                    x = v[0];
                    y = v[1];
                    if( x < l ) l = x;
                    if( x > r ) r = x;
                    if( y < t ) t = y;
                    if( y > b ) b = y;
                    if( v.length > 2 ) {
                        x = v[2];
                        y = v[3];
                        if( x < l ) l = x;
                        if( x > r ) r = x;
                        if( y < t ) t = y;
                        if( y > b ) b = y;
                    }
                case _:
            }
        }
        return {    pos:    { x: l, y: t }
                ,   dim:    { x: r - l, y: b - t }
                ,   centre: { x: l + ( r - l )/2, y: t + ( b - t )/2 }
                ,   end:    { x: r, y: b }
                };
    }
    public static inline function tracePoints( path: Iterable<CommandData> ) {
        var str = '';
        var path = Lambda.map( path, function( v: CommandData ):CommandData{ str += Std.string( v.v0[0] ) + ' ' + Std.string( v.v0[1] ) + '\n'; return v; } );
        trace( str );
    }
    /**
        Creates a new Array by applying function `f` to all elements of `it`.
        The order of elements is preserved.
        If `f` is null, the result is unspecified.
    **/
    public static inline function mapArr<A,B>( it : Iterable<A>, f : A -> B ) : Array<B> {
        var a = new Array<B>();
        for( x in it )
            a.push( f(x) );
        return a;
    }
}
