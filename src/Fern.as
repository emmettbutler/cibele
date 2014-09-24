package{
    import org.flixel.*;

    public class Fern extends PlayerState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;

        public var ikutursodoor:GameObject;
        public var euryaledoor:GameObject;
        public var hiisidoor:GameObject;

        public static const BOSS_MARK:String = "boss_iku_turso";
        public static const DOOR_MARK:String = "fern_door_lock";

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, _screen.screenHeight * .7));
            FlxG.bgColor = 0x00000000;

            GlobalTimer.getInstance().setMark(BOSS_MARK, 319632 - 60 * 1000);
            GlobalTimer.getInstance().setMark(DOOR_MARK, .5 * GameSound.MSEC_PER_SEC);

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

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if(GlobalTimer.getInstance().hasPassed(DOOR_MARK)) {
                super.clickCallback(screenPos, worldPos);
                var objects:Array = new Array();
                for (var i:int = 0; i < this.clickObjectGroups.length; i++) {
                    for (var j:int = 0; j < this.clickObjectGroups[i].length; j++) {
                        objects.push(this.clickObjectGroups[i][j]);
                    }
                }
                this.player.clickCallback(screenPos, worldPos, objects);
            }
        }
    }
}
