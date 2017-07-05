package letters.paragraphPath;

// use the one in Path
class RainbowPencilColours{

    static inline function colors(){ return [ 0xD2D0C1
                                            , 0xCD8028
                                            , 0xD29D11
                                            , 0xE37128
                                            , 0xF06771
                                            , 0xD23931
                                            , 0xAF2C31
                                            , 0x90333E
                                            , 0x863D50
                                            , 0x584A5D
                                            , 0x549EC3
                                            , 0x2C709D
                                            , 0x457AAE
                                            , 0x364D6D
                                            , 0x378C6D
                                            , 0x6EA748
                                            , 0x365DA4
                                            , 0x456E42
                                            , 0xC1882E
                                            , 0x813424
                                            , 0x402E24
                                            , 0x292420
                                            , 0x525751
                                            , 0x1B1B19
                                            ]; }
    public static function random():Int
    {
        var col = colors();
        return col[Math.round(Math.random()*(col.length+1))];
    }
    /*
    public static function randomStringHex():StringHex
    {
        var out: StringHex = StringHex.fromInt( random() );
        return out;
    }
    */
}