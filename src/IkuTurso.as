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
        public var enemy:SmallEnemy;
        protected var zoomcam:ZoomCamera;
        public var bgLoader:BackgroundLoader;

        override public function create():void {
            FlxG.bgColor = 0xff000000;

            this.bgLoader = new BackgroundLoader("TestSquares", 10, 5);

            enemy = new SmallEnemy(new DHPoint(250,300));
            add(enemy);

            player = new Player(100, 100);
            add(player);
            player_rect = new FlxRect(player.x,player.y,player.width,player.height);

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            zoomcam = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(zoomcam);
            zoomcam.target = player;
            zoomcam.targetZoom = 1.2;
            FlxG.worldBounds = new FlxRect(0, 0, 15272, 17456);

            super.create();
        }

        override public function update():void{
            super.update();
            player.update();
            player_rect.x = player.x;
            player_rect.y = player.y;

            timeFrame++;
            debugText.x = player.x-50;
            debugText.y = player.y;
            debugText.text = "ENEMY HP: " + enemy.hitpoints + "ENEMY STATE" + enemy.state + "PLAYER STATE" + player.state;

            if(timeFrame%30 == 0){
                timer++;
            }

            if(player.pos.sub(enemy.pos)._length() < 208){
                if(player.pos.sub(enemy.pos)._length() > 10){
                    enemy.playerTracking(player);
                }
            } else {
                if(enemy.state != enemy.STATE_DAMAGED){
                    enemy.state = enemy.STATE_IDLE;
                }
            }

            if(FlxG.keys.justPressed("SPACE")){
               player.attack(enemy);
            }
        }
    }
}
