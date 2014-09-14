package{
    import org.flixel.*;

    public class Fern extends PlayerState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;
        [Embed(source="../assets/sexyselfie_wip.mp3")] private var VidBGMLoop:Class;

        public var ikutursodoor:FlxSprite;
        public var euryaledoor:FlxSprite;
        public var hiisidoor:FlxSprite;
        public var convoSound:GameSound;

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, _screen.screenHeight * .5));
            FlxG.bgColor = 0x00000000;

            this.convoSound = SoundManager.getInstance().playSound(Convo, 319632,
                function():void {
                    SoundManager.getInstance().playSound(VidBGMLoop, 0, null, true, .2, GameSound.BGM);
                    FlxG.switchState(
                        new PlayVideoState("../assets/selfie.flv",
                            function():void {
                                FlxG.switchState(new StartScreen());
                            }));
                }, false, 1, GameSound.VOCAL);

            (new BackgroundLoader()).loadSingleTileBG("../assets/fern_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            ikutursodoor = new FlxSprite(_screen.screenWidth * .2, _screen.screenHeight * .1);
            ikutursodoor.makeGraphic(200, 300, 0xffff0000);
            ikutursodoor.alpha = 0;
            add(ikutursodoor);

            euryaledoor = new FlxSprite(_screen.screenWidth * .4, _screen.screenHeight * .1);
            euryaledoor.makeGraphic(200, 300, 0xffff0000);
            euryaledoor.alpha = 0;
            add(euryaledoor);

            hiisidoor = new FlxSprite(_screen.screenWidth * .7, _screen.screenHeight * .1);
            hiisidoor.makeGraphic(200, 300, 0xffff0000);
            hiisidoor.alpha = 0;
            add(hiisidoor);

            this.postCreate();
        }

        override public function update():void{
            super.update();

            if(player.mapHitbox.overlaps(ikutursodoor)){
                FlxG.switchState(new IkuTursoTeleportRoom(this.convoSound));
            }

            if(player.mapHitbox.overlaps(euryaledoor)){
                FlxG.switchState(new IkuTursoTeleportRoom(this.convoSound));
            }
            if(player.mapHitbox.overlaps(hiisidoor)){
                FlxG.switchState(new IkuTursoTeleportRoom(this.convoSound));
            }
        }
    }
}
