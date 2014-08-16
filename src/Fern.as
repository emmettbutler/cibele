package{
    import org.flixel.*;

    public class Fern extends FlxState {
        [Embed(source="../assets/fern_640_480.png")] private var ImgBG:Class;
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var ikutursodoor:FlxRect;
        public var euryaledoor:FlxRect;
        public var hiisidoor:FlxRect;
        public var player_rect:FlxRect;
        public var left_wall:Wall;
        public var right_wall:Wall;
        public var top_wall:Wall;

        override public function create():void {
            FlxG.bgColor = 0x00000000;

            SoundManager.getInstance().playSound(Convo, 340*1000,
                function():void {
                    FlxG.switchState(
                        new PlayVideoState("../assets/selfie.flv",
                            function():void {
                                FlxG.switchState(new StartScreen());
                            }));
                });

            (new BackgroundLoader()).loadSingleTileBG("../assets/fern_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            left_wall = new Wall(0,0,100,300);
            add(left_wall);
            right_wall = new Wall(FlxG.width-120,0,150,300);
            add(right_wall);
            top_wall = new Wall(0,0,640,130);
            add(top_wall);

            player = new Player(0, 0);
            add(player);
            player_rect = new FlxRect(player.x,player.y,player.width,player.height);

            ikutursodoor = new FlxRect(160,70,30,80);
            euryaledoor = new FlxRect(339,108,10,50);
            hiisidoor = new FlxRect(497,105,10,50);

            debugText = new FlxText(0,0,100,"TEST");
            add(debugText);
        }

        override public function update():void{
            super.update();

            SoundManager.getInstance().update();

            player_rect.x = player.x;
            player_rect.y = player.y;
            FlxG.collide();
            if(player_rect.overlaps(ikutursodoor)){
                FlxG.switchState(new IkuTursoTeleportRoom());
            }
            if(player_rect.overlaps(euryaledoor)){
                FlxG.switchState(new EuryaleTeleportRoom());
            }
            if(player_rect.overlaps(hiisidoor)){
                FlxG.switchState(new HiisiTeleportRoom());
            }

            timeFrame++;
            debugText.x = FlxG.mouse.x;
            debugText.y = FlxG.mouse.y;
            debugText.text = "X: " + FlxG.mouse.x + "Y: " + FlxG.mouse.y;

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
