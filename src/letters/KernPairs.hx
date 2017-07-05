 
 
 
package letters;
import haxe.ds.StringMap;
class KernPairs {
    private var lookup: StringMap<Float>;
    private var last: String = '';
    public function new() {
        lookup = new StringMap<Float>();
        var kernStr = haxe.Resource.getString( 'kernPairs' );
        var kernPairStr = kernStr.split('\n');
        var arr: Array<String>;
        kernPairStr.shift();
        for( pairStr in kernPairStr ) {
            arr = pairStr.split(' ');
            lookup.set( arr[0], Std.parseFloat( arr[1] ) );
        }
    }
    public function getNextSpace( letter: String ){
        var pair = last + letter; 
        last = letter;
        return getSpacing( pair );
    }
    private function getSpacing( pair: String ): Float
    {
        if( pair.length != 2 ) return 0;
        if( lookup.exists( pair ) ) return -lookup.get( pair );
        return 0;
    }
}