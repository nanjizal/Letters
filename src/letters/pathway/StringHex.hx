package letters.pathway;

@:forward(substr)
abstract StringHex( String ) to String from String
{
    // safer way 
    public static inline function getStringHex( str: String ): StringHex 
    {
        str = str.toUpperCase();
        switch( str.charAt(0) )
        {
            case '#':
            case '0':
                if( str.charAt(1) == "X" ){
                    str = "#" + str.substr(2);
                } else {
                    // assumes valid ?
                }
            case "A","B","C","D","E","F","0","1","2","3","4","5","6","7","8","9":
                str = "#" + str;
            case _:
                str = "#000000";
        }
        return new StringHex( str );
    }
    
    // assumes well formatted otherwise use getStringHex
    public inline function new( str: String ): String
    {
        this = str;
    } 
    
    public var red( get, set ):StringHex;
    private inline function get_red(){
        return new StringHex( "#" + this.substr(1,2) + "0000" ); 
    }
    
    public inline function set_red( col: StringHex )
    {
        this = "#" + col.substr(1,2) + this.substr(3,2) + this.substr(5,2);
        return this;
    }
    
    public var green( get, set ):StringHex;
    private inline function get_green()
    {
        return new StringHex( "#00"+this.substr(3,2)+"00" ); 
    }
    
    public inline function set_green( col: StringHex )
    {
        this = "#" + this.substr(1,2) + col.substr(3,2) + this.substr(5,2);
        return this;
    }
    
    public var blue( get, set ):StringHex;
    private inline function get_blue()
    {
        return new StringHex( "#0000"+this.substr(5,2) ); 
    }
    
    public inline function set_blue( col: StringHex )
    {
        this = "#" + this.substr(1,2) + this.substr(3,2) + col.substr(5,2);
        return this;
    }
    
    public var rgb( get, set ): { r:Int, g:Int, b:Int };
    private inline function set_rgb( v:{ r:Int, g:Int, b:Int } )
    {
        this = "#" + StringTools.hex(v.r,2) + StringTools.hex(v.g,2)  + StringTools.hex(v.b,2);
        return v;
    }
    
    private inline function get_rgb(){
        var r: Int = red;
        r = r >> 16;
        var g: Int = green;
        g = g >> 8 & 0xff;
        var b: Int = blue;
        b = b & 0xff;
        return { r: r, g: g, b: b };
    }
    
    @:from public static inline function fromInt( col: Int )
    {
        return new StringHex( '#' + StringTools.hex( col, 6 ) );
    }
    
    @:to public inline function toInt(){
        return Std.parseInt("0x"+this.substr(1));
    }
    
    public static inline function blend( c0: StringHex, c1: StringHex, t: Float )
    {
        if( t > 1 || t < 0 ) throw( "StringHex blend function needs a T parameter between 0, 1");
        var rgb0 = c0.rgb;
        var rgb1 = c1.rgb;
        var r0 = rgb0.r;
        var r1 = rgb1.r;
        var g0 = rgb0.g;
        var g1 = rgb1.g;
        var b0 = rgb0.b;
        var b1 = rgb1.b;
        var out = new StringHex( "#000000" );
        out.rgb = { r: r0 + Std.int(( r1 - r0 )*t), g: g0 + Std.int(( g1 - g0 )*t), b: b0 + Std.int(( b1 - b0 )*t) }
        return out;
    }
    
    @:op(A + B)  static inline public function add( a: StringHex, b: StringHex )
    {
        var ai: Int = a;
        var bi: Int = b;
        var out: StringHex = ( ai + bi );
        return out;
    }
    @:op(A - B)  static inline public function minus( a: StringHex, b: StringHex )
    {
        var ai: Int = a;
        var bi: Int = b;
        var out: StringHex = ( ai - bi );
        return out;
    }
    
    public static var unitRed( get, null ): StringHex;
    private static inline function get_unitRed(){
        return new StringHex( '#010000' );
    }
    
    public static var unitGreen( get, null ): StringHex;
    private static inline function get_unitGreen(){
        return new StringHex( '#000100' );
    }
    
    public static var unitBlue( get, null ): StringHex;
    private static inline function get_unitBlue(){
        return new StringHex( '#000001' );
    }
    
    public static var unitColor( get, null ): StringHex;
    private static inline function get_unitColor(){
        return new StringHex( '#010101' );
    }
    
    @:op(A++)  inline public function brighter( ):StringHex
    {
        var ai: Int = toInt();
        var bi: Int = 0x010101;
        var out: StringHex = ( ai + bi);
        this = out;
        return this;
    }
    
    @:op(A--)  inline public function darker(  ):StringHex
    {
        var ai: Int = toInt();
        var bi: Int = 0x010101;
        var out: StringHex = ( ai - bi);
        this = out;
        return this;
    }
    
}