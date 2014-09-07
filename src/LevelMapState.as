package {
    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        public var player:Player;
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;

        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;
        public var lastSlowUpdate:Number = -1;

        public static const LEVEL_ID:int = 9234876592837465;

        override public function create():void {
            FlxG.bgColor = 0xffffffff;
            this.bornTime = new Date().valueOf();
            this.ID = LEVEL_ID;

            player = new Player(4600, 7565);
            this.add(player.mapHitbox)
            this.bgLoader = new BackgroundLoader("full-map-iggo-turso", 10, 5,
                                                 "paths", this.editorMode == PathEditorState.MODE_EDIT);
            this.bgLoader.setPlayerReference(player);

            ScreenManager.getInstance().setupCamera(player);
            FlxG.camera.setBounds(0, 0, bgLoader.cols * bgLoader.estTileWidth,
                                  bgLoader.rows * bgLoader.estTileHeight);
            super.create_(player);
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.bgLoader.update();
            SoundManager.getInstance().update();
            // update these only once every 2s. they require lower time resolution
            // and this helps conserve FPS
            if (this.timeAlive - this.lastSlowUpdate > 2*1000) {
                PopUpManager.getInstance().update();
                MessageManager.getInstance().update();
                this.lastSlowUpdate = this.timeAlive;
            }
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
