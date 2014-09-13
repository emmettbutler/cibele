package {
    import org.flixel.*;

    public class GameState extends FlxState {
        private var updateSound:Boolean, updatePopup:Boolean,
                    updateMessages:Boolean;

        public function GameState(snd:Boolean=true, popup:Boolean=true,
                                  messages:Boolean=true){
            this.updateSound = snd;
            this.updatePopup = popup;
            this.updateMessages = messages;
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();

            if (this.updateSound) {
                SoundManager.getInstance().update();
            }
            if (this.updatePopup) {
                PopUpManager.getInstance().update();
            }
            if (this.updateMessages) {
                MessageManager.getInstance().update();
            }
        }
    }
}
