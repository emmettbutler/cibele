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
            SoundManager.getInstance().update();

            resolveAttacks();

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

        public function resolveAttacksHelper(obj:PartyMember):void {
            if (!obj.isAttacking()) {
                return;
            }
            var current_enemy:Enemy;
            var disp:DHPoint;
            for (var i:int = 0; i < this.enemies.length(); i++) {
                current_enemy = this.enemies.get_(i);
                disp = current_enemy.pos.sub(obj.pos);
                if (disp._length() < 100) {
                    current_enemy.takeDamage();
                }
            }
        }

        public function resolveAttacks():void {
            this.resolveAttacksHelper(this.player);
            this.resolveAttacksHelper(this.pathWalker);
        }
    }
}
