package{
    import org.flixel.*;

    public class Fern extends FlxState {
        [Embed(source="../assets/fern_640_480.png")] private var ImgBG:Class;
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:FlxSprite;
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

            var imgDim:DHPoint = new DHPoint(640, 375);
            var bgAspect:Number = imgDim.x / imgDim.y;
            var dim:DHPoint = ScreenManager.getInstance().calcFullscreenDimensionsAlt(imgDim);
            var bgScale:DHPoint = ScreenManager.getInstance().calcFullscreenScale(imgDim);
            var origin:DHPoint = ScreenManager.getInstance().calcFullscreenOrigin(dim);

            trace(origin.x + "x" + origin.y);
            trace(dim.x + "x" + dim.y);
            bg = new FlxSprite(origin.x, origin.y);
            bg.loadGraphic(ImgBG, false, false, imgDim.x, imgDim.y);
            bg.scale.x = bgScale.x;
            bg.scale.y = bgScale.y;
            bg.x = origin.x;
            bg.y = origin.y;
            add(bg);

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

            ScreenManager.getInstance().setupCamera(null, 1);
            //FlxG.camera.setBounds(origin.x, origin.y, ScreenManager.getInstance().screenWidth,
            //                      ScreenManager.getInstance().screenHeight);
        }

        override public function update():void{
            super.update();

            SoundManager.getInstance().update();

            bg.x += 1;
            bg.y += 1;
            trace(bg.x + "x" + bg.y);

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
