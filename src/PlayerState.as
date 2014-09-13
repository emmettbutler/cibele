package {
    import org.flixel.*;

    public class PlayerState extends GameState {
        protected var player:Player;
        protected var startPos:DHPoint;

        public function PlayerState() {
        }

        override public function create():void {
            super.create();

            this.player = new Player(this.startPos.x, this.startPos.y);
            this.add(this.player.mapHitbox)
        }

        public function postCreate():void {
            add(this.player);
            this.player.addAttackAnim();
            add(this.player.debugText);
        }

        override public function update():void {
            super.update();
            if(PopUpManager.getInstance()._player == null) {
                PopUpManager.getInstance()._player = this.player;
            }

            this.restrictPlayerMovement();

            if(FlxG.mouse.justPressed()) {
                this.clickCallback(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
            }
        }

        public function clickCallback(pos:DHPoint):void {
            this.player.clickCallback(pos);
        }

        public function restrictPlayerMovement():void {
            if(PopUpManager.getInstance()._state == PopUpManager.SHOWING_POP_UP){
                this.player.inhibitX = this.player.inhibitY = true;
            } else {
                this.player.inhibitX = this.player.inhibitY = false;
            }
        }
    }
}
