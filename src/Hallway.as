package{
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class Hallway extends PlayerState {
        [Embed(source="../assets/bgm_fern_intro.mp3")] private var FernBGMIntro:Class;
        [Embed(source="../assets/bgm_fern_loop.mp3")] private var FernBGMLoop:Class;

        public var accept_call:Boolean = false;

        public var light:FlxExtSprite;
        public var wall_left:GameObject;
        public var wall_right:GameObject;
        public var collisionData:Array;
        public var leftBound:Number, rightBound:Number;
        public var tileLoader:HallwayTileLoader;

        public static const STATE_PRE:Number = 0;
        public static const STATE_RETURN:Number = 1;
        public var _state:Number = STATE_PRE;

        public var _screen:ScreenManager;
        public var frameCount:int = 0;

        public var loader:FernBackgroundLoader;

        private var bottomY:Number, fernBase:FlxExtSprite, fernTop:FlxExtSprite;

        public static var BGM:String = "Hallway to fern BGM";

        public function Hallway(){
        }

        override public function create():void {
            PopUpManager.GAME_ACTIVE = true;

            function _musicCallback():void {
                SoundManager.getInstance().playSound(FernBGMLoop, 0, null,
                    true, .15, GameSound.BGM, HallwayToFern.BGM, false, false, true);
            }
            SoundManager.getInstance().playSound(
                FernBGMIntro, 12.4*GameSound.MSEC_PER_SEC, _musicCallback,
                false, .15, Math.random()*932+102, HallwayToFern.BGM, false,
                false, true);

            _screen = ScreenManager.getInstance();

            bottomY = 7000;
            var startPos:DHPoint = new DHPoint(_screen.screenWidth * .5,
                                               bottomY - _screen.screenHeight * .5);
            if (this._state == STATE_RETURN) {
                bottomY = _screen.screenHeight * 2;
                startPos.y = _screen.screenHeight * .8;
            }
            super.__create(startPos);

            FlxG.state.remove(this.baseLayer);
            this.baseLayer = new GameObject(new DHPoint(0, 0));
            this.baseLayer.scrollFactor = new DHPoint(0, 0);
            this.baseLayer.active = false;
            this.baseLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                0xff071026
            );
            this.add(this.baseLayer);

            ScreenManager.getInstance().setupCamera(player.cameraPos, 1);
            FlxG.camera.setBounds(0, 0, _screen.screenWidth, bottomY);

            loader = new FernBackgroundLoader();
            fernTop = loader.load();
            fernTop.scrollFactor = new DHPoint(1, 1);

            fernBase = (new BackgroundLoader()).loadSingleTileBG("../assets/Fern-part-2.png");
            fernBase.scrollFactor = new DHPoint(1, 1);

            leftBound = ScreenManager.getInstance().screenWidth * .39;
            rightBound = ScreenManager.getInstance().screenWidth * .52;

            this.tileLoader = new HallwayTileLoader(
                new DHPoint(77 * 3, bottomY),
                new DHPoint(leftBound + 40, 0),
                this.player, 0
            );

            this.postCreate();

            if(_state == STATE_PRE){
                call_button.visible = true;
            }

            this.player.nameText.color = 0xffffffff;
        }

        override public function update():void {
            super.update();
            if (this._state != STATE_RETURN) {
                this.tileLoader.update();
            }

            if (this.fernBase.y != this.fernTop.y + this.fernTop.height) {
                this.fernBase.y = this.fernTop.y + this.fernTop.height;
                this.tileLoader.stopY = this.fernBase.y + this.fernBase.height / 2;
            }

            if(SoundManager.getInstance().getSoundByName(MenuScreen.BGM) != null) {
                SoundManager.getInstance().getSoundByName(MenuScreen.BGM).fadeOutSound();
            }

            if (this.player.y > this.fernTop.y + this.fernTop.height) {
                if (this.player.x < leftBound) {
                    this.player.x = leftBound;
                }
                if (this.player.x > rightBound) {
                    this.player.x = rightBound;
                }
            }
            if (this.player.y > bottomY) {
                this.player.y = bottomY;
            }

            if(accept_call) {
                if(call_button.scale.x > 0) {
                    call_button.scale.x -= .1;
                    call_button.scale.y -= .1;
                } else {
                    call_button.kill();
                }
            }

            for (var i:int = 0; i < loader.doors.length; i++) {
                if(player.mapHitbox.overlaps(loader.doors[i]["object"])){
                    FlxG.switchState(new IkuTursoTeleportRoom());
                }
            }
        }

        public function getCollisionData(wall:GameObject):Array {
            return FlxCollision.pixelPerfectCheck(player.mapHitbox, wall, 255, FlxG.camera, 30, 30, ScreenManager.getInstance().DEBUG);
        }

        override public function postCreate():void {
            super.postCreate();
            player.setBlueShadow();
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
        }
    }
}