package{
    import org.flixel.*;

    public class Fern extends FlxState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var player:Player;
        public var ikutursodoor:FlxSprite;
        public var euryaledoor:FlxSprite;
        public var hiisidoor:FlxSprite;

        override public function create():void {
            FlxG.bgColor = 0x00000000;

            SoundManager.getInstance().playSound(Convo, 319632,
                function():void {
                    FlxG.switchState(
                        new PlayVideoState("../assets/selfie.flv",
                            function():void {
                                FlxG.switchState(new StartScreen());
                            }));
                });

            (new BackgroundLoader()).loadSingleTileBG("../assets/fern_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            player = new Player(0, 0);
            add(player);

            var _screen:ScreenManager = ScreenManager.getInstance();
            ikutursodoor = new FlxSprite(_screen.screenWidth * .3, _screen.screenHeight * .5);
            ikutursodoor.makeGraphic(20, 20, 0xffff0000);
            add(ikutursodoor);

            euryaledoor = new FlxSprite(_screen.screenWidth * .6, _screen.screenHeight * .5);
            euryaledoor.makeGraphic(20, 20, 0xffff0000);
            add(euryaledoor);

            hiisidoor = new FlxSprite(_screen.screenWidth * .9, _screen.screenHeight * .5);
            hiisidoor.makeGraphic(20, 20, 0xffff0000);
            add(hiisidoor);
        }

        override public function update():void{
            super.update();

            SoundManager.getInstance().update();

            if(player.mapHitbox.overlaps(ikutursodoor)){
                FlxG.switchState(new IkuTursoTeleportRoom());
            }
            if(player.mapHitbox.overlaps(euryaledoor)){
                FlxG.switchState(new EuryaleTeleportRoom());
            }
            if(player.mapHitbox.overlaps(hiisidoor)){
                FlxG.switchState(new HiisiTeleportRoom());
            }
        }
    }
}
