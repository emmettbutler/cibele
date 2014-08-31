package{
    import org.flixel.*;

    public class Fern extends FlxState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var player:Player;
        public var ikutursodoor:FlxSprite;
        public var euryaledoor:FlxSprite;
        public var hiisidoor:FlxSprite;
        public var convoSound:GameSound;

        override public function create():void {
            FlxG.bgColor = 0x00000000;

            this.convoSound = SoundManager.getInstance().playSound(Convo, 319632,
                function():void {
                    FlxG.switchState(
                        new PlayVideoState("../assets/selfie.flv",
                            function():void {
                                FlxG.switchState(new StartScreen());
                            }));
                });

            (new BackgroundLoader()).loadSingleTileBG("../assets/fern_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            var _screen:ScreenManager = ScreenManager.getInstance();
            ikutursodoor = new FlxSprite(_screen.screenWidth * .2, _screen.screenHeight * .1);
            ikutursodoor.makeGraphic(200, 300, 0xffff0000);
            add(ikutursodoor);

            euryaledoor = new FlxSprite(_screen.screenWidth * .4, _screen.screenHeight * .1);
            euryaledoor.makeGraphic(200, 300, 0xffff0000);
            add(euryaledoor);

            hiisidoor = new FlxSprite(_screen.screenWidth * .7, _screen.screenHeight * .1);
            hiisidoor.makeGraphic(200, 300, 0xffff0000);
            add(hiisidoor);

            player = new Player(_screen.screenWidth * .5, _screen.screenHeight * .5);
            add(player);
        }

        override public function update():void{
            super.update();

            SoundManager.getInstance().update();

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
