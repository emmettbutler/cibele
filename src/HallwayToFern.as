package{
    import org.flixel.*;

    public class HallwayToFern extends FlxState {
        [Embed(source="../assets/hallway sprite.png")] private var ImgBG:Class;
        [Embed(source="../assets/incomingcall.png")] private var ImgCall:Class;
        [Embed(source="../assets/voc_firstconvo.mp3")] private var Convo1:Class;

        public var player:Player;
        public var timer:Number = 0;

        public var call_button:FlxSprite;
        public var accept_call:Boolean = false;

        public var bg1:FlxSprite;
        public var bg2:FlxSprite;
        public var bg3:FlxSprite;

        public var enemy:SmallEnemy;

        public var img_height:Number = 480;

        public static const STATE_PRE_IT:Number = 0;
        public var _state:Number = 0;
        public var runSpeed:Number = 5;

        public var popupmgr:PopUpManager;

        public function HallwayToFern(state:Number = 0){
            _state = state;
        }

        override public function create():void {
            FlxG.mouse.show();
            FlxG.bgColor = 0xff000000;

            var _screen:ScreenManager = ScreenManager.getInstance();
            var originX:Number = (_screen.screenWidth * .5) - 1422/2;

            bg1 = new FlxSprite(originX, -img_height);
            bg1.loadGraphic(ImgBG,false,false,1422,800);
            bg1.addAnimation("run", [0, 1, 2, 3, 4], 12, true);
            bg1.play("run");
            add(bg1);
            bg2 = new FlxSprite(originX, 0);
            bg2.loadGraphic(ImgBG,false,false,1422,800);
            bg2.addAnimation("run", [0, 1, 2, 3, 4], 12, true);
            bg2.play("run");
            add(bg2);
            bg3 = new FlxSprite(originX, img_height);
            bg3.loadGraphic(ImgBG,false,false,1422,800);
            bg3.addAnimation("run", [0, 1, 2, 3, 4], 12, true);
            bg3.play("run");
            add(bg3);

            ScreenManager.getInstance().setupCamera(null, 1);

            var debugText:FlxText = new FlxText(_screen.screenWidth * .2, _screen.screenHeight * .2,200,"placeholder for hallway\nthat player will run down\nduring this sequence");
            //add(debugText);
            //debugText.size = 12;

            player = new Player(_screen.screenWidth * .5, _screen.screenHeight * .5);
            player.inhibitY = true;
            add(player);
            player.testAttackAnim();
            if(_state == STATE_PRE_IT){
                call_button = new FlxSprite(_screen.screenWidth * .3, _screen.screenHeight * .3);
                call_button.loadGraphic(ImgCall,false,false,500,230);
                FlxG.state.add(call_button);
            }
        }

        override public function update():void{
            super.update();
            popupmgr = PopUpManager.getInstance();
            popupmgr.update();

            if(_state == STATE_PRE_IT){
                if(FlxG.mouse.justPressed() && !accept_call){
                    accept_call = true;
                    call_button.kill();
                    function _callback():void {
                        FlxG.switchState(new Fern());
                    }
                    SoundManager.getInstance().playSound(Convo1, 24000, _callback, false, 1);
                    popupmgr.createNewPopUp(1);
                    popupmgr.createNewPopUp(2);
                    popupmgr.createNewPopUp(3);
                }
            }

            SoundManager.getInstance().update();
            MessageManager.getInstance().update();

            if(PopUpManager.getInstance()._state == 2){
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

                if(bg2.y == 0){
                    bg1.y = bg2.y-bg2.height;
                }
                if(bg1.y == 0){
                    bg3.y = bg2.y-bg1.height;
                }
                if(bg3.y == 0){
                    bg2.y = bg3.y-bg3.height;
                }
            }
        }
    }
}
