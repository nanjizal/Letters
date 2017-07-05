package letters.pathway;

class Iterator0_1<T>{
    var min:    Float;
    var max:    Float;
    var step:   Float;
    var count:  Int;
    inline static var accuracy: Int = 1000000;
    // where 1 is divisible by step
    public function new( step_: Float ) {
        min = 0.;
        step = step_;
        count = 1;
        max = 1.;
    }
    public function hasNext() return min < max;
    
    public function next():Float{
        var minOld: Float = Math.round( min*accuracy )/accuracy;
        min = ( count++ )*step;
        return minOld;
    }
    public function iterator ():Iterator0_1<T> { return this; }
}