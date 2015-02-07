package{
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class IkuTursoDesktop extends Desktop {
        public function IkuTursoDesktop() {
        }

        override public function create():void {
            super.create();
            GameState.CUR_LEVEL = GameState.IT;
        }

        override public function update():void{
            super.update();
        }
    }
}