package{
    import org.flixel.*;

    public class IkuTurso extends PathEditorState {
        public var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:FlxExtSprite;
        public var player_rect:FlxRect;
        public var img_height:Number = 357;
        public var current_enemy:Enemy;

        protected var zoomcam:ZoomCamera;
        public var bgLoader:BackgroundLoader;

        override public function create():void {
            FlxG.bgColor = 0xff000000;

            this.bgLoader = new BackgroundLoader("TestSquares", 10, 5);

            player = new Player(5460, 7390);
            this.bgLoader.setPlayerReference(player);
            player_rect = new FlxRect(player.x,player.y,player.width,player.height);

            debugText = new FlxText(0,0,100,"");
            debugText.color = 0xff000000;
            add(debugText);

            zoomcam = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(zoomcam);
            zoomcam.target = player;
            zoomcam.targetZoom = 1.2;
            FlxG.worldBounds = new FlxRect(0, 0, 15272, 17456);

            super.create_(player);
        }

        override public function update():void{
            super.update();
            this.bgLoader.update();
            player.update();
            enemies.update();

            enemiesFollowPlayer();
            resolvePlayerAttacks();
            resolveFollowerAttacks();

            player_rect.x = player.x;
            player_rect.y = player.y;

            timeFrame++;

            if(timeFrame%30 == 0){
                timer++;
            }
            debugText.x = player.x;
            debugText.y = player.y-20;

            if(pathWalker.pathComplete){
                //debugText.text = "Path Complete";
            }
        }

        public function resolvePlayerAttacks():void {
            if (!player.isAttacking()) {
                return;
            }
            var current_enemy:Enemy;
            var disp:DHPoint;
            for (var i:int = 0; i < this.enemies.length(); i++) {
                current_enemy = this.enemies.get_(i);
                disp = current_enemy.pos.sub(this.player.pos);
                if (disp._length() < 30) {
                    current_enemy.takeDamage();
                }
            }
        }

        public function resolveFollowerAttacks():void{
            if (!pathWalker.isAttacking()) {
                return;
            }
            var current_enemy:Enemy;
            var disp:DHPoint;
            for (var i:int = 0; i < this.enemies.length(); i++) {
                current_enemy = this.enemies.get_(i);
                disp = current_enemy.pos.sub(this.pathWalker.pos);
                if (disp._length() < 200) {
                    current_enemy.takeDamage();
                }
            }
        }

        public function enemiesFollowPlayer():void{
            var e:EnemyGroup = this.enemies;
            for(var i:Number = 0; i < e.length(); i++){
                current_enemy = e.get_(i);
                if(player.pos.sub(current_enemy.pos)._length() < 208){
                    if(player.pos.sub(current_enemy.pos)._length() > 10){
                        enemies.preventEnemyOverlap(current_enemy);
                        current_enemy.playerTracking(player);
                    }
                } else {
                    if(current_enemy.state != current_enemy.STATE_DAMAGED){
                        current_enemy.state = current_enemy.STATE_IDLE;
                    }
                }
            }
        }
    }
}
