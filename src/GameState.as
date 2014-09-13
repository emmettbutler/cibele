package {
    import org.flixel.*;

    public class GameState extends FlxState {
        public function GameState(){
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();

            SoundManager.getInstance().update();
            PopUpManager.getInstance().update();
            MessageManager.getInstance().update();
        }
    }
}
