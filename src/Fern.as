package{
    import org.flixel.*;

    public class Fern extends PlayerState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var ikutursodoor:GameObject;
        public var euryaledoor:GameObject;
        public var hiisidoor:GameObject;

        public static const BOSS_MARK:String = "boss_iku_turso";

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, _screen.screenHeight * .5));
            FlxG.bgColor = 0x00000000;

            GlobalTimer.getInstance().setMark(BOSS_MARK, 319632 - 60 * 1000);

            (new BackgroundLoader()).loadSingleTileBG("../assets/fern_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            ikutursodoor = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            ikutursodoor.makeGraphic(200, 300, 0xffff0000);
            ikutursodoor.alpha = 0;
            add(ikutursodoor);

            euryaledoor = new GameObject(new DHPoint(_screen.screenWidth * .4, _screen.screenHeight * .1));
            euryaledoor.makeGraphic(200, 300, 0xffff0000);
            euryaledoor.alpha = 0;
            add(euryaledoor);

            hiisidoor = new GameObject(new DHPoint(_screen.screenWidth * .7, _screen.screenHeight * .1));
            hiisidoor.makeGraphic(200, 300, 0xffff0000);
            hiisidoor.alpha = 0;
            add(hiisidoor);

            this.postCreate();
        }

        override public function update():void{
            super.update();

            if(player.mapHitbox.overlaps(ikutursodoor)){
                FlxG.switchState(new IkuTursoTeleportRoom());
            }

            if(player.mapHitbox.overlaps(euryaledoor)){
                FlxG.switchState(new IkuTursoTeleportRoom());
            }
            if(player.mapHitbox.overlaps(hiisidoor)){
                FlxG.switchState(new IkuTursoTeleportRoom());
            }
        }
    }
}
