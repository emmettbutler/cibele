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

        public var ikutursodoor:FlxExtSprite, euryaledoor:FlxExtSprite,
                   hiisidoor:FlxExtSprite;
        public var startCollisions:Boolean = false;
        public var doors:Array;

        public static const BOSS_MARK:String = "boss_iku_turso";
        public static const DOOR_MARK:String = "fern_door_lock";

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .5, _screen.screenHeight * .7));
            FlxG.bgColor = 0x00000000;

            doors = [
                {
                    "xPos": _screen.screenWidth * .165,
                    "frame": new DHPoint(526, 1172),
                    "image": "../assets/waterfall_l.png",
                    "object": null
                },
                {
                    "xPos": _screen.screenWidth * .395,
                    "frame": new DHPoint(629, 940),
                    "image": "../assets/waterfall_m.png",
                    "object": null
                },
                {
                    "xPos": _screen.screenWidth * .65,
                    "frame": new DHPoint(526, 1172),
                    "image": "../assets/waterfall_r.png",
                    "object": null
                }
            ];

            GlobalTimer.getInstance().setMark(BOSS_MARK, 319632 - 60 * 1000);
            GlobalTimer.getInstance().setMark(DOOR_MARK, .5 * GameSound.MSEC_PER_SEC);

            var bg:FlxExtSprite = (new BackgroundLoader()).loadSingleTileBG("../assets/fern.jpg");
            ScreenManager.getInstance().setupCamera(null, 1);

            var cur:Object;
            for (var i:int = 0; i < doors.length; i++) {
                cur = doors[i];
                cur["object"] = new GameObject(new DHPoint(cur["xPos"], bg.y));
                add(cur["object"]);
            }

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
                var scaledBMD:BitmapData = new BitmapData(Math.ceil(bmp.width * scaleFactor),
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

            var cur:Object;
            for (var i:int = 0; i < doors.length; i++) {
                cur = doors[i];
                receivingMachines[i].contentLoaderInfo.addEventListener(Event.COMPLETE,
                    this.buildScalerFunction(cur["object"], cur["frame"], scaleFactor));
                receivingMachines[i].load(new URLRequest(cur["image"]));
            }

            this.startCollisions = true;
        }

        override public function postCreate():void {
            super.postCreate();
            player.setBlueShadow();
        }

        override public function update():void{
            super.update();

            if(this.startCollisions) {
                for (var i:int = 0; i < doors.length; i++) {
                    if(player.mapHitbox.overlaps(doors[i]["object"])){
                        FlxG.switchState(new IkuTursoTeleportRoom());
                    }
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
