package {
    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        public var player:Player;
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;
        public var zoomcam:ZoomCamera;

        override public function create():void {
            FlxG.bgColor = 0xff000000;

            player = new Player(4600, 7565);
            this.add(player.mapHitbox)
            this.bgLoader = new BackgroundLoader("Map", 10, 5);
            this.bgLoader.setPlayerReference(player);

            zoomcam = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(zoomcam);
            zoomcam.target = player;
            zoomcam.targetZoom = 1.2;
            FlxG.worldBounds = new FlxRect(0, 0, 15272, 17456);

            super.create_(player);
        }

        override public function update():void {
            super.update();
            this.bgLoader.update();
            this.player.update();
            SoundManager.getInstance().update();
            this.resolveAttacks();
        }

        public function resolveAttacksHelper(obj:PartyMember):void {
            if (!obj.isAttacking()) {
                return;
            }
            var current_enemy:Enemy;
            var disp:DHPoint;
            for (var i:int = 0; i < this.enemies.length(); i++) {
                current_enemy = this.enemies.get_(i);
                disp = current_enemy.pos.sub(obj.pos);
                if (disp._length() < obj.attackRange) {
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
