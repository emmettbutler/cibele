package {
    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        public var player:Player;
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;
        public var zoomcam:ZoomCamera;

        override public function create():void {
            FlxG.bgColor = 0xffffffff;

            player = new Player(4600, 7565);
            this.add(player.mapHitbox)
            this.bgLoader = new BackgroundLoader("full-map-iggo-turso", 10, 5, "paths");
            this.bgLoader.setPlayerReference(player);

            ScreenManager.getInstance().setupCamera(player);
            FlxG.camera.setBounds(0, 0, bgLoader.cols * bgLoader.estTileWidth,
                                  bgLoader.rows * bgLoader.estTileHeight);
            super.create_(player);
        }

        override public function update():void {
            super.update();
            this.bgLoader.update();
            SoundManager.getInstance().update();
            this.resolveAttacks();
        }

        public function resolveAttacksHelper(obj:PartyMember):void {
            if (!obj.isAttacking()) {
                return;
            }
            var current_enemy:Enemy;
            for (var i:int = 0; i < this.enemies.length(); i++) {
                current_enemy = this.enemies.get_(i);
                if (current_enemy.pos.sub(obj.pos)._length() < obj.attackRange) {
                    current_enemy.takeDamage(obj);
                }
            }
        }

        public function resolveAttacks():void {
            this.resolveAttacksHelper(this.player);
            this.resolveAttacksHelper(this.pathWalker);
        }
    }
}
