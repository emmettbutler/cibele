package{
    import org.flixel.*;

    public class Fern extends PlayerState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;
        [Embed(source="../assets/waterfall 1.png")] private var ImgWater1:Class;
        [Embed(source="../assets/waterfall 2.png")] private var ImgWater2:Class;
        [Embed(source="../assets/waterfall 3.png")] private var ImgWater3:Class;

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

            (new BackgroundLoader()).loadSingleTileBG("../assets/fern.jpg");
            ScreenManager.getInstance().setupCamera(null, 1);

            ikutursodoor = new GameObject(new DHPoint(_screen.screenWidth * .15, 0));
            var imgDim:DHPoint = new DHPoint(1804/8, 567);
            ikutursodoor.loadGraphic(ImgWater1, true, false, imgDim.x * _screen.calcFullscreenScale(imgDim), imgDim.y * _screen.calcFullscreenScale(imgDim));
            ikutursodoor.addAnimation("flow",
               [0,  1,  2,  3,  4,  5,  6,  7], 20, true);
            ikutursodoor.play("flow");
            add(ikutursodoor);

            euryaledoor = new GameObject(new DHPoint(_screen.screenWidth * .4, _screen.screenHeight * .4));
            imgDim = new DHPoint(221, 579);
            //euryaledoor.loadGraphic(ImgWater2, true, false, imgDim.x * _screen.calcFullscreenScale(imgDim), imgDim.y * _screen.calcFullscreenScale(imgDim));
            //euryaledoor.addAnimation("flow",
             //  [0,  1,  2,  3,  4,  5,  6,  7], 20, true);
            //euryaledoor.play("flow");
            add(euryaledoor);

            hiisidoor = new GameObject(new DHPoint(_screen.screenWidth * .7, _screen.screenHeight * .7));
            imgDim = new DHPoint(221, 579);
            //hiisidoor.loadGraphic(ImgWater3, true, false, imgDim.x * _screen.calcFullscreenScale(imgDim), imgDim.y * _screen.calcFullscreenScale(imgDim));
            //hiisidoor.addAnimation("flow",
            //   [0,  1,  2,  3,  4,  5,  6,  7], 20, true);
            //hiisidoor.play("flow");
            add(hiisidoor);

            this.postCreate();
        }

        override public function postCreate():void {
            super.postCreate();
            player.setBlueShadow();
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
            super.clickCallback(screenPos, worldPos);
            var objects:Array = new Array();
            for (var i:int = 0; i < this.clickObjectGroups.length; i++) {
                for (var j:int = 0; j < this.clickObjectGroups[i].length; j++) {
                    objects.push(this.clickObjectGroups[i][j]);
                }
            }
            if(GlobalTimer.getInstance().hasPassed(DOOR_MARK) == true) {
                this.player.clickCallback(screenPos, worldPos, objects);
            }
        }
    }
}
