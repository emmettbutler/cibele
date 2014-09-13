package {
    public class PlayerState extends GameState {
        protected var player:Player;

        public function PlayerState() {
        }

        override public function create():void {
            super.create();

            this.player = new Player(4600, 7565);
            this.add(this.player.mapHitbox)
        }

        override public function update():void {
            super.update();

            this.restrictPlayerMovement();
        }

        public function restrictPlayerMovement():void {
            if(PopUpManager.getInstance()._state != PopUpManager.SHOWING_NOTHING){
                this.player.inhibitX = this.player.inhibitY = true;
            } else {
                this.player.inhibitX = this.player.inhibitY = false;
            }
        }
    }
}
