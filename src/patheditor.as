package{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class patheditor extends FlxGame{
        public function patheditor(){
            super(640, 480, PathEditorState, 1);
        }
    }
}
