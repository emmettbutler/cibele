package{
    import org.flixel.*;

    public class HallwayToFern extends PlayerState {
        [Embed(source="../assets/hallway sprite.png")] private var ImgBG:Class;
        [Embed(source="../assets/incomingcall.png")] private var ImgCall:Class;
        [Embed(source="../assets/voc_firstconvo.mp3")] private var Convo1:Class;
        [Embed(source="../assets/voc_ikuturso_start.mp3")] private var Convo2:Class;
        [Embed(source="../assets/voc_extra_wannaduo.mp3")] private var SndHurryUp:Class;

        public var call_button:GameObject;
        public var accept_call:Boolean = false;

        public var bgs:Array;

        public var img_height:Number = 800;

        public static const STATE_PRE_IT:Number = 0;
        public var _state:Number = 0;

        public var _screen:ScreenManager;

        public function HallwayToFern(state:Number = 0){
            _state = state;
        }

        override public function create():void {
            bgs = new Array();

            var bottomY:Number = 10000;
            _screen = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, bottomY - _screen.screenHeight * .5));

            FlxG.bgColor = 0xff000000;

            this.initTiles(bottomY);

            ScreenManager.getInstance().setupCamera(player, 1);
            FlxG.camera.setBounds(0, 0, _screen.screenWidth, bottomY);

            if(_state == STATE_PRE_IT){
                call_button = new GameObject(new DHPoint(_screen.screenWidth * .3,
                                            _screen.screenHeight * .3));
                call_button.loadGraphic(ImgCall,false,false,500,230);
                call_button.scrollFactor = new DHPoint(0, 0);
                FlxG.state.add(call_button);
            }
            this.postCreate();

            this.player.nameText.color = 0xffffffff;
        }

        public function initTiles(startY:Number):void {
            var originX:Number = (_screen.screenWidth * .5) - 1422 / 2;
            var cur:GameObject;
            for (var i:int = 0; i < 3; i++) {
                cur = new GameObject(new DHPoint(
                        originX, startY - (i * img_height)
                    )
                );
                cur.loadGraphic(ImgBG, false, false, 1422, img_height);
                cur.addAnimation("run", [0, 1, 2, 3, 4], 12, true);
                cur.play("run");
                add(cur);
                this.bgs.push(cur);
            }
        }

        override public function update():void {
            super.update();
            var highestTile:GameObject = this.bgs[0];
            var lowestTile:GameObject = this.bgs[0];
            for (var i:int = 0; i < this.bgs.length; i++) {
                if (this.bgs[i].y < highestTile.y) {
                    highestTile = this.bgs[i];
                }
                if (this.bgs[i].y > lowestTile.y) {
                    lowestTile = this.bgs[i];
                }
            }

            if (this.player.dir.y < 0 &&
                this.player.y < highestTile.y + highestTile.height) {
                lowestTile.y = highestTile.y - lowestTile.height;
            } else if (this.player.dir.y > 0 &&
                this.player.y > lowestTile.y + lowestTile.height) {
                highestTile.y = lowestTile.y + highestTile.height;
            }

            if (this.player.pos.y < ScreenManager.getInstance().screenHeight / 2) {
                FlxG.switchState(new Fern());
            }
        }

        override public function postCreate():void {
            super.postCreate();
            player.inhibitY = true;
        }

        override public function restrictPlayerMovement():void {
            super.restrictPlayerMovement();
            this.player.inhibitY = true;
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE_IT && !this.accept_call) {
                accept_call = true;
                call_button.kill();

                function convo2Done():void {
                    if (!(FlxG.state is IkuTurso)) {
                    } else {
                        (FlxG.state as IkuTurso).playFirstConvo();
                    }
                }

                function playConvo2():void {
                    SoundManager.getInstance().playSound(
                        Convo2, 24000, convo2Done, false, 1, GameSound.VOCAL,
                        "convo_2_hall"
                    );
                }

                function playWannaDuo():void {
                    if (!(FlxG.state is IkuTurso)) {
                        SoundManager.getInstance().playSound(
                            SndHurryUp, 4*GameSound.MSEC_PER_SEC, playConvo2,
                            false, 1, GameSound.VOCAL
                        );
                    } else {
                        SoundManager.getInstance().playSound(
                            Convo2, 24000, convo2Done, false, 1, GameSound.VOCAL,
                            "convo_2_hall"
                        );
                    }
                }

                function convo1Done():void {
                    GlobalTimer.getInstance().setMark("delayed_wannaduo",
                        10*GameSound.MSEC_PER_SEC, playWannaDuo);
                    PopUpManager.getInstance().sendPopup(PopUpManager.BULLDOG_HELL);
                }

                SoundManager.getInstance().playSound(
                    Convo1, 29000, convo1Done, false, 1, GameSound.VOCAL,
                    "convo_1_hall"
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
