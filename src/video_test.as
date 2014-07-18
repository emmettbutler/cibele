package{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class video_test extends FlxGame{
        public function video_test(){
            super(640, 480,LogoCutscene,1);
        }
    }
}
