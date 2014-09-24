package {
    import org.flixel.*;

    public class PlayerState extends GameState {
        protected var player:Player;
        protected var startPos:DHPoint;
        protected var clickObjectGroups:Array;

        public function PlayerState() {
        }

        public function __create(pos:DHPoint):void {
            super.create();
            this.startPos = pos;

            this.player = new Player(this.startPos.x, this.startPos.y);
            this.add(this.player.mapHitbox)
        }

        override public function postCreate():void {
            this.player.addVisibleObjects();
            super.postCreate();
            this.game_cursor.setGameMouse();
            FlxG.mouse.x = this.player.pos.x;
            FlxG.mouse.y = this.player.pos.y;

            this.clickObjectGroups = [
                PopUpManager.getInstance().elements,
                MessageManager.getInstance().elements
            ];
        }

        override public function update():void {
            super.update();
            if(PopUpManager.getInstance()._player != this.player) {
                PopUpManager.getInstance()._player = this.player;
            }

            this.restrictPlayerMovement();
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            super.clickCallback(screenPos, worldPos);
            var objects:Array = new Array();
            for (var i:int = 0; i < this.clickObjectGroups.length; i++) {
                for (var j:int = 0; j < this.clickObjectGroups[i].length; j++) {
                    objects.push(this.clickObjectGroups[i][j]);
                }
            }
            this.player.clickCallback(screenPos, worldPos, objects);
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
