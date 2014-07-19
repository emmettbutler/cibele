package{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader_fern")]

    public class ferntest extends FlxGame{
        public function ferntest(){
            super(640, 480, HallwayToFern, 1);
        }
    }
}
