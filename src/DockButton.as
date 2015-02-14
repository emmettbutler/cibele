package {
    import com.starmaid.Cibele.states.MenuScreen;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.UIElement;

    import org.flixel.*;

    public class DockButton extends UIElement {
        [Embed(source="../assets/audio/effects/sfx_notification.mp3")] private var SfxNotification:Class;
        private var cur_popup:PopUp;
        public var cur_popup_tag:String;
        private var ownedKeys:Array;
        public var hasOpened:Boolean = true;
        public var tag:String;

        public function DockButton(x:Number, y:Number, ownedKeys:Array, tag:String) {
            super(x, y);
            this.ownedKeys = ownedKeys;
            this.tag = tag;
        }

        override public function update():void {
            super.update();
        }

        public function ownsKey(key:String):Boolean {
            return this.ownedKeys.indexOf(key) != -1;
        }

        public function sendPopup(popup:PopUp):void {
            this.setCurPopup(popup);
            this.hasOpened = false;
            this.alerting = true;
            SoundManager.getInstance().playSound(
                    SfxNotification, 2*GameSound.MSEC_PER_SEC, null, false, 1, GameSound.SFX,
                    "" + Math.random()
                );
        }

        public function open():void {
            this.hasOpened = true;
            this.alerting = false;
            if (this.cur_popup != null) {
                this.cur_popup.open();
            }
        }

        public function toggleGame():void {
            if(PopUpManager.GAME_ACTIVE == false) {
                FlxG.switchState(new MenuScreen());
                PopUpManager.GAME_ACTIVE = true;
            } else {
                //TODO (FlxG.state as GameState).pause();
            }
        }

        public function setCurPopup(popup:PopUp):void {
            this.cur_popup = popup;
            if (this.cur_popup != null) {
                this.cur_popup_tag = popup.tag;
            }
        }

        public function getCurPopup():PopUp {
            return this.cur_popup;
        }
    }
}
