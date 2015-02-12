package {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.DataEvent;

    import org.flixel.*;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.net.URLRequest;

    public class FernBackgroundLoader {
        public var doors:Array;

        public function load():FlxExtSprite {
            var _screen:ScreenManager = ScreenManager.getInstance();
            doors = [
                {
                    "xPos": _screen.screenWidth * .165,
                    "frame": new DHPoint(526, 1172),
                    "image": "../assets/images/worlds/waterfall_l.png",
                    "object": null
                },
                {
                    "xPos": _screen.screenWidth * .395,
                    "frame": new DHPoint(629, 940),
                    "image": "../assets/images/worlds/waterfall_m.png",
                    "object": null
                },
                {
                    "xPos": _screen.screenWidth * .65,
                    "frame": new DHPoint(526, 1172),
                    "image": "../assets/images/worlds/waterfall_r.png",
                    "object": null
                }
            ];

            var bg:FlxExtSprite = (new BackgroundLoader()).loadSingleTileBG("../assets/images/worlds/Fern-part-1.png");

            var cur:Object;
            for (var i:int = 0; i < doors.length; i++) {
                cur = doors[i];
                cur["object"] = new GameObject(new DHPoint(cur["xPos"], bg.y));
                FlxG.state.add(cur["object"]);
            }

            var state:GameState = FlxG.state as GameState;
            var that:FernBackgroundLoader = this;
            state.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    that.addDoors(bg, event.userData['bg_scale']);
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });

            return bg;

        }

        public function addDoors(bg:FlxExtSprite, scaleFactor:Number=1):void {
            var receivingMachines:Array = [new Loader(), new Loader(), new Loader()];
            var _screen:ScreenManager = ScreenManager.getInstance();

            var cur:Object;
            for (var i:int = 0; i < doors.length; i++) {
                cur = doors[i];
                cur["object"].y = bg.y;
                receivingMachines[i].contentLoaderInfo.addEventListener(
                    Event.COMPLETE,
                    this.buildScalerFunction(cur["object"], cur["frame"],
                                             scaleFactor));
                receivingMachines[i].load(new URLRequest(cur["image"]));
            }
        }

        public function buildScalerFunction(spr:FlxExtSprite, frameDim:DHPoint,
                                            scaleFactor:Number=1):Function
        {
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

    }
}
