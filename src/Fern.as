package{
    import org.flixel.*;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.net.URLRequest;

    public class Fern extends PlayerState {
        [Embed(source="../assets/voc_ikuturso.mp3")] private var Convo:Class;
        [Embed(source="../assets/waterfall1.png")] private var ImgWater1:Class;
        [Embed(source="../assets/waterfall2.png")] private var ImgWater2:Class;
        [Embed(source="../assets/waterfall3.png")] private var ImgWater3:Class;

        public var ikutursodoor:FlxExtSprite, euryaledoor:FlxExtSprite,
                   hiisidoor:FlxExtSprite;
        public var startCollisions:Boolean = false;

        public static const BOSS_MARK:String = "boss_iku_turso";
        public static const DOOR_MARK:String = "fern_door_lock";

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, _screen.screenHeight * .7));
            FlxG.bgColor = 0x00000000;

            GlobalTimer.getInstance().setMark(BOSS_MARK, 319632 - 60 * 1000);
            GlobalTimer.getInstance().setMark(DOOR_MARK, .5 * GameSound.MSEC_PER_SEC);

            var bg:FlxExtSprite = (new BackgroundLoader()).loadSingleTileBG("../assets/fern.jpg");
            ScreenManager.getInstance().setupCamera(null, 1);

            var that:Fern = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    that.addDoors(bg, event.userData['bg_scale']);
                    FlxG.stage.removeEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                                                    arguments.callee);
                });

            this.postCreate();
        }

        public function buildScalerFunction(spr:FlxExtSprite, frameDim:DHPoint, scaleFactor:Number=1):Function {
            return function (event_load:Event):void {
                var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                var matrix:Matrix = new Matrix();
                matrix.scale(scaleFactor, scaleFactor);
                var scaledBMD:BitmapData = new BitmapData(bmp.width * scaleFactor,
                                                        bmp.height * scaleFactor,
                                                        true, 0x000000);
                scaledBMD.draw(bmp, matrix, null, null, null, true);
                bmp = new Bitmap(scaledBMD, PixelSnapping.NEVER, true);
                spr.loadExtGraphic(bmp, true, true, frameDim.x*scaleFactor,
                                   frameDim.y*scaleFactor);
                spr.addAnimation("flow", [0,  1,  2,  3,  4,  5,  6,  7], 7, true);
                spr.play("flow");
            };
        }

        public function addDoors(bg:FlxExtSprite, scaleFactor:Number=1):void {
            var receivingMachines:Array = [new Loader(), new Loader(), new Loader()];
            var _screen:ScreenManager = ScreenManager.getInstance();

            ikutursodoor = new GameObject(new DHPoint(_screen.screenWidth * .185, bg.y));
            add(ikutursodoor);
            receivingMachines[0].contentLoaderInfo.addEventListener(Event.COMPLETE,
                this.buildScalerFunction(ikutursodoor, new DHPoint(458, 1128), scaleFactor));
            receivingMachines[0].load(new URLRequest("../assets/waterfall1.png"));

            euryaledoor = new GameObject(new DHPoint(_screen.screenWidth * .395, bg.y));
            add(euryaledoor);
            receivingMachines[1].contentLoaderInfo.addEventListener(Event.COMPLETE,
                this.buildScalerFunction(euryaledoor, new DHPoint(628, 1024), scaleFactor));
            receivingMachines[1].load(new URLRequest("../assets/waterfall2.png"));

            hiisidoor = new GameObject(new DHPoint(_screen.screenWidth * .65, bg.y));
            add(hiisidoor);
            receivingMachines[2].contentLoaderInfo.addEventListener(Event.COMPLETE,
                this.buildScalerFunction(hiisidoor, new DHPoint(526, 1172), scaleFactor));
            receivingMachines[2].load(new URLRequest("../assets/waterfall3.png"));

            this.startCollisions = true;
        }

        override public function postCreate():void {
            super.postCreate();
            player.setBlueShadow();
        }

        override public function update():void{
            super.update();

            if(this.startCollisions) {
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
