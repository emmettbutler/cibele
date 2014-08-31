package{
    import org.flixel.*;

    public class HallwayToFern extends FlxState {
        [Embed(source="../assets/pathtofern.png")] private var ImgBG:Class;
        [Embed(source="../assets/voc_firstconvo.mp3")] private var Convo1:Class;
        [Embed(source="../assets/bgm_fern_intro.mp3")] private var FernBGMIntro:Class;
        [Embed(source="../assets/bgm_fern_loop.mp3")] private var FernBGMLoop:Class;

        public var player:Player;
        public var timer:Number = 0;

        public var bg1:FlxSprite;
        public var bg2:FlxSprite;
        public var bg3:FlxSprite;

        public var door:FlxRect;

        public var enemy:SmallEnemy;

        public var img_height:Number = 480;

        public static const STATE_PRE_IT:Number = 0;
        public var _state:Number = 0;
        public var runSpeed:Number = 5;

        public var messages:MessageManager;

        public function HallwayToFern(state:Number = 0){
            _state = state;
        }

        override public function create():void {
            FlxG.mouse.show();
            /*
            FlxG.bgColor = 0xff000000;

            var _screen:ScreenManager = ScreenManager.getInstance();
            var originX:Number = (_screen.screenWidth * .5) - 640/2;

            bg1 = new FlxSprite(originX, -img_height);
            bg1.loadGraphic(ImgBG,false,false,640,img_height);
            add(bg1);
            bg2 = new FlxSprite(originX, 0);
            bg2.loadGraphic(ImgBG,false,false,640,img_height);
            add(bg2);
            bg3 = new FlxSprite(originX, img_height);
            bg3.loadGraphic(ImgBG,false,false,640,img_height);
            add(bg3);

            door = new FlxRect(210,100,200,100);

            player = new Player(originX + 640/2, 280);
            add(player);
*/

            (new BackgroundLoader()).loadSingleTileBG("../assets/it_teleport_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            var _screen:ScreenManager = ScreenManager.getInstance();
            var debugText:FlxText = new FlxText(_screen.screenWidth * .2, _screen.screenHeight * .2,200,"placeholder for hallway\nthat player will run down\nduring this sequence");
            add(debugText);
            debugText.size = 12;

            player = new Player(_screen.screenWidth * .5, _screen.screenHeight * .5);
            add(player);
            if(_state == STATE_PRE_IT){
                function _callback():void {
                    FlxG.switchState(new Fern());
                }
                SoundManager.getInstance().playSound(Convo1, 24000, _callback);
                function _musicCallback():void {
                    SoundManager.getInstance().playSound(FernBGMLoop, 0, null, true, .3);
                }
                SoundManager.getInstance().playSound(FernBGMIntro, 12631, _musicCallback, false, .5);
            }

            messages = new MessageManager();
        }

        override public function update():void{
            super.update();
            SoundManager.getInstance().update();
            messages.update();
/*
            if(FlxG.keys.UP){
                bg1.y += runSpeed;
                bg2.y += runSpeed;
                bg3.y += runSpeed;
            }
            if(FlxG.keys.DOWN){
                bg1.y -= runSpeed;
                bg2.y -= runSpeed;
                bg3.y -= runSpeed;
            }
            if(FlxG.keys.LEFT){
                player.x -= runSpeed;
            }
            if(FlxG.keys.RIGHT){
                player.x += runSpeed;
            }

            if(bg2.y == 0){
                bg1.y = bg2.y-bg2.height;
            }
            if(bg1.y == 0){
                bg3.y = bg2.y-bg1.height;
            }
            if(bg3.y == 0){
                bg2.y = bg3.y-bg3.height;
            }*/
        }
    }
}
