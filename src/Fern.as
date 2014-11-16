package{
    import org.flixel.*;

    public class Fern extends PlayerState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var loader:FernBackgroundLoader;

        public static const BOSS_MARK:String = "boss_iku_turso";

        override public function create():void {
            PopUpManager.GAME_ACTIVE = true;

            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, _screen.screenHeight * .7));
            FlxG.bgColor = 0x00000000;

            loader = new FernBackgroundLoader();
            loader.load();

            this.postCreate();
        }

        override public function postCreate():void {
            super.postCreate();
            player.setBlueShadow();
        }

        override public function update():void{
            super.update();

            for (var i:int = 0; i < loader.doors.length; i++) {
                if(player.mapHitbox.overlaps(loader.doors[i]["object"])){
                    FlxG.switchState(new IkuTursoTeleportRoom());
                }
            }
        }
    }
}
