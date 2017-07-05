package letters.pathway;

class ThreeIterator<T> {
    var min : Int;
    var max : Int;
    var step: Int;
    public var arr:     Array<T>;
    public var arrNext: Array<T>;
    public function new( min_ : Int, max_ : Int, step_: Int ) {
        min = min_;
        max = max_;
        step = step_;
    }
    public function hasNext() return min < (max - 2);
    public function next(): Int {
        arrNext = arr.slice( min, min + 3 );
        min += step;
        return min;
    }
    public function iterator ():ThreeIterator<T> { return this; }
}