package {
    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;

        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;

        public static const LEVEL_ID:int = 9234876592837465;

        override public function create():void {
            super.__create(new DHPoint(4600, 7565));

            FlxG.bgColor = 0xffffffff;
            this.bornTime = new Date().valueOf();
            this.ID = LEVEL_ID;

            this.bgLoader = new BackgroundLoader("full-map-iggo-turso", 10, 5,
                "paths", this.editorMode == PathEditorState.MODE_EDIT);
            this.bgLoader.setPlayerReference(player);

            ScreenManager.getInstance().setupCamera(player);
            FlxG.camera.setBounds(0, 0, bgLoader.cols * bgLoader.estTileWidth,
                                  bgLoader.rows * bgLoader.estTileHeight);
            super.postCreate();
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.bgLoader.update();
            this.resolveAttacks();
        }

        override public function updateCursor():void {
            super.updateCursor();
            if (this.game_cursor != null) {
                this.game_cursor.checkObjectOverlap(this.enemies.enemies);
            }
        }

        override public function clickCallback(pos:DHPoint):void {
            this.player.clickCallback(pos, this.enemies.enemies);
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
