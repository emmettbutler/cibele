package{
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class EuryaleDesktop extends Desktop {
        public function EuryaleDesktop() {
        }

        override public function create():void {
            super.create();
            GameState.CUR_LEVEL = GameState.EU;
        }

        override public function update():void{
            super.update();
        }
    }
}