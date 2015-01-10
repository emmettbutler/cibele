package {
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.net.URLRequest;

    public class BackgroundLoader {

        private var receivingMachines:Array;
        private var colliderReceivingMachines:Array;

        public var macroImageName:String, colliderName:String;
        public var tiles:Array, colliderTiles:Array;
        public var rows:Number, cols:Number;
        public var playerRef:Player;
        public var estTileWidth:Number, estTileHeight:Number;
        public var adjacentCoords:Array;
        public var colliderScaleFactor:Number = 4;
        public var loadPositionThreshold:DHPoint;
        public var collisionData:Array;

        public var dbgText:FlxText;

        public function BackgroundLoader(macroImageName:String="", rows:Number=0,
                                         cols:Number=0, colliderName:String=null,
                                         showColliders:Boolean=false)
        {
            if (colliderName == null) {
                this.colliderName = macroImageName;
            } else {
                this.colliderName = colliderName;
            }
            this.macroImageName = macroImageName;
            this.rows = rows;
            this.cols = cols;
            this.estTileWidth = 1359;
            this.estTileHeight = 818;
            this.loadPositionThreshold = new DHPoint(
                Math.min((ScreenManager.getInstance().screenWidth) /
                    this.estTileWidth, .5),
                Math.min((ScreenManager.getInstance().screenHeight) /
                    this.estTileHeight, .7));
            this.adjacentCoords = new Array();
            this.receivingMachines = new Array();
            this.colliderReceivingMachines = new Array();

            tiles = new Array();
            colliderTiles = new Array();
            var spr:FlxExtSprite, colSpr:FlxExtSprite;
            for (var i:int = 0; i < this.rows; i++) {
                tiles[i] = new Array();
                colliderTiles[i] = new Array();
                receivingMachines[i] = new Array();
                colliderReceivingMachines[i] = new Array();
                for (var j:int = 0; j < this.cols; j++) {
                    colSpr = new FlxExtSprite(j * estTileWidth, i * estTileHeight);
                    colSpr.active = false;
                    if (showColliders) {
                        FlxG.state.add(colSpr);
                    }
                    colliderTiles[i][j] = colSpr;
                    colliderReceivingMachines[i][j] = new Loader();

                    spr = new FlxExtSprite(j * estTileWidth, i * estTileHeight);
                    spr.active = false;
                    FlxG.state.add(spr);
                    tiles[i][j] = spr;
                    receivingMachines[i][j] = new Loader();
                }
            }

            this.dbgText = new FlxText(100, 100, FlxG.width, "");
            this.dbgText.color = 0xff0000ff;
            this.dbgText.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(dbgText);
        }

        public function buildLoadCompleteCallback(tile:FlxExtSprite,
                                                  receivingMachine:Loader,
                                                  scaleFactor:Number=1):Function {
            return function (event_load:Event):void {
                tile.makeGraphic(10, 10, 0x00000000);
                if (!tile.hasLoaded) {
                    var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                    // scale bitmap up for collider tiles
                    if (scaleFactor != 1) {
                        var matrix:Matrix = new Matrix();
                        matrix.scale(scaleFactor, scaleFactor);
                        var scaledBMD:BitmapData = new BitmapData(bmp.width * scaleFactor,
                                                                  bmp.height * scaleFactor,
                                                                  true, 0x000000);
                        scaledBMD.draw(bmp, matrix, null, null, null, true);
                        bmp = new Bitmap(scaledBMD, PixelSnapping.NEVER, true);
                    }
                    // the last parameter is really important for transparent images
                    // it says "clear the pixel cache before loading this image"
                    // weird things happen with collider tiles when it's false
                    tile.loadExtGraphic(bmp, false, false, bmp.width, bmp.height, true);
                    tile.hasLoaded = true;
                }
                receivingMachine.contentLoaderInfo.removeEventListener(
                    Event.COMPLETE, arguments.callee);
            }
        }

        public function getTileByIndex(row:Number, col:Number, arr:Array=null):FlxExtSprite {
            if (arr == null) {
                arr = this.tiles;
            }
            var rowArr:Array = arr[row];
            if (rowArr == null) {
                return null;
            }
            var tile:FlxExtSprite = rowArr[col];
            if (tile == null) {
                return null;
            }
            return tile;
        }

        public function loadTile(row:Number, col:Number, arr:Array=null,
                                 machines:Array=null, imgName:String=null,
                                 isCollider:Boolean=false):void
        {
            if (imgName == null) {
                imgName = this.macroImageName;
            }
            if (arr == null) {
                arr = this.tiles;
            }
            if (machines == null) {
                machines = this.receivingMachines;
            }
            var tile:FlxExtSprite = this.getTileByIndex(row, col, arr);
            if (tile == null) {
                return;
            }

            var receivingMachine:Loader = machines[row][col];
            var numberString:String = this.getTileIndex(row, col);
            if (!tile.hasStartedLoad) {
                tile.hasStartedLoad = true;

                receivingMachine.contentLoaderInfo.addEventListener(Event.COMPLETE,
                    this.buildLoadCompleteCallback(tile, receivingMachine,
                                                   isCollider ? 8.65 : 1));
                var path:String = "../assets/map_tiles/" + imgName + "_" + numberString + ".png";
                var req:URLRequest = new URLRequest(path);
                receivingMachine.load(req);
            }
        }

        public function getTileIndex(row:int, col:int):String {
            var idx:int = cols * (row % rows) + col % cols;
            idx += 1;
            if (idx < 10) {
                return "0" + idx;
            }
            return "" + idx;
        }

        public function tileHasLoaded(row:int, col:int, arr:Array=null):Boolean {
            if (arr == null) {
                arr = this.tiles;
            }
            var rowArr:Array = arr[row];
            if (rowArr == null) {
                return false;
            }
            var tile:FlxExtSprite = rowArr[col];
            if (tile != null) {
                return tile.hasStartedLoad;
            }
            return false
        }

        public function getCollisionData(row:int, col:int):Array {
            var colliderTile:FlxExtSprite = this.getTileByIndex(row, col,
                                                                this.colliderTiles);
            if (colliderTile == null) {
                return [false, null];
            }
            return FlxCollision.pixelPerfectCheck(playerRef.mapHitbox,
                                                  colliderTile, 255, null, 6, 4,
                                                  ScreenManager.getInstance().DEBUG);
        }

        public function update():void {
            var playerRow:int, playerCol:int, playerRelativePos:DHPoint;
            playerRelativePos = new DHPoint(this.playerRef.pos.x / this.estTileWidth,
                                            this.playerRef.pos.y / this.estTileHeight);
            playerRow = Math.floor(playerRelativePos.y);
            playerCol = Math.floor(playerRelativePos.x);
            playerRelativePos.x -= playerCol;
            playerRelativePos.y -= playerRow;

            var numberString:String = this.getTileIndex(playerRow, playerCol);
            var playerSpriteTileWidthPct:Number = this.playerRef.width / this.estTileWidth;

            adjacentCoords.push([playerRow,   playerCol]);
            if (playerRelativePos.x > 1 - loadPositionThreshold.x - playerSpriteTileWidthPct) {
                adjacentCoords.push([playerRow,   playerCol+1]);
            }
            if (playerRelativePos.x <= loadPositionThreshold.x) {
                adjacentCoords.push([playerRow,   playerCol-1]);
            }
            if (playerRelativePos.y > 1 - loadPositionThreshold.y) {
                adjacentCoords.push([playerRow+1, playerCol]);
                if (playerRelativePos.x > 1 - loadPositionThreshold.x - playerSpriteTileWidthPct) {
                    adjacentCoords.push([playerRow+1, playerCol+1]);
                }
                if (playerRelativePos.x <= loadPositionThreshold.x) {
                    adjacentCoords.push([playerRow+1, playerCol-1]);
                }
            }
            if (playerRelativePos.y <= loadPositionThreshold.y) {
                adjacentCoords.push([playerRow-1, playerCol]);
                if (playerRelativePos.x > 1 - loadPositionThreshold.x - playerSpriteTileWidthPct) {
                    adjacentCoords.push([playerRow-1, playerCol+1]);
                }
                if (playerRelativePos.x <= loadPositionThreshold.x) {
                    adjacentCoords.push([playerRow-1, playerCol-1]);
                }
            }

            var row:int, col:int, contact:Boolean;
            for (var i:int = 0; i < adjacentCoords.length; i++) {
                row = adjacentCoords[i][0];
                col = adjacentCoords[i][1];
                // load background tiles
                if (!this.tileHasLoaded(row, col)) {
                    if (!ScreenManager.getInstance().DEBUG) {
                        this.loadTile(row, col, null, null, this.macroImageName);
                    }
                }
                // load tile colliders
                if (!this.tileHasLoaded(row, col, this.colliderTiles)) {
                    this.loadTile(row, col, this.colliderTiles,
                                  this.colliderReceivingMachines,
                                  this.colliderName, true);
                } else {
                    collisionData = this.getCollisionData(row, col)
                    if (collisionData[0]) {
                        contact = true;
                        this.playerRef.collisionDirection = collisionData[1];
                    }
                }
            }
            this.playerRef.colliding = contact;

            adjacentCoords.length = 0;
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
        }

        public function loadSingleTileBG(path:String):FlxExtSprite {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var bg:FlxExtSprite = new FlxExtSprite(0, 0);
            bg.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(bg);
            var receivingMachine:Loader = new Loader();
            receivingMachine.contentLoaderInfo.addEventListener(Event.COMPLETE,
                function (event_load:Event):void {
                    var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                    var imgDim:DHPoint = new DHPoint(bmp.width, bmp.height);
                    var dim:DHPoint = _screen.calcFullscreenDimensionsAlt(imgDim);
                    var origin:DHPoint = _screen.calcFullscreenOrigin(dim);
                    var bgScale:Number = _screen.calcFullscreenScale(imgDim);
                    var matrix:Matrix = new Matrix();
                    matrix.scale(bgScale, bgScale);
                    var scaledBMD:BitmapData = new BitmapData(bmp.width * bgScale,
                                                            bmp.height * bgScale,
                                                            true, 0x000000);
                    scaledBMD.draw(bmp, matrix, null, null, null, true);
                    bmp = new Bitmap(scaledBMD, PixelSnapping.NEVER, true);
                    bg.loadExtGraphic(bmp, false, false, bmp.width, bmp.height, true);
                    bg.x = origin.x;
                    bg.y = origin.y;
                    FlxG.stage.dispatchEvent(
                        new DataEvent(GameState.EVENT_SINGLETILE_BG_LOADED,
                                      {'bg_scale': bgScale, 'bg': bg}));
                }
            );
            receivingMachine.load(new URLRequest(path));
            return bg;
        }
    }
}
