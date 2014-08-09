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

        public var macroImageName:String;
        public var tiles:Array, colliderTiles:Array;
        public var rows:Number, cols:Number;
        public var playerRef:Player;
        public var estTileWidth:Number, estTileHeight:Number;
        public var adjacentCoords:Array;
        public var colliderScaleFactor:Number = 4;

        public var dbgText:FlxText;

        public function BackgroundLoader(macroImageName:String, rows:Number, cols:Number) {
            this.macroImageName = macroImageName;
            this.rows = rows;
            this.cols = cols;
            this.estTileWidth = 1433;
            this.estTileHeight = 820;
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
                    colSpr.makeGraphic(10, 10, 0x00000000);
                    FlxG.state.add(colSpr);
                    colliderTiles[i][j] = colSpr;
                    colliderReceivingMachines[i][j] = new Loader();

                    spr = new FlxExtSprite(j * estTileWidth, i * estTileHeight);
                    spr.makeGraphic(10, 10, 0x00000000);
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

        public function makeCallback(tile:FlxExtSprite, receivingMachine:Loader, scaleFactor:Number=1):Function {
            return function (event_load:Event):void {
                var tileInner:FlxExtSprite = tile;
                tileInner.makeGraphic(10, 10, 0x00000000);
                if (!tileInner.hasLoaded) {
                    var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                    // scale bitmap up for collider tiles
                    if (scaleFactor != 1) {
                        var matrix:Matrix = new Matrix();
                        matrix.scale(scaleFactor, scaleFactor);
                        var scaledBMD:BitmapData = new BitmapData(bmp.width * scaleFactor, bmp.height * scaleFactor, true, 0x000000);
                        scaledBMD.draw(bmp, matrix, null, null, null, true);
                        bmp = new Bitmap(scaledBMD, PixelSnapping.NEVER, true);
                    }
                    tileInner.loadExtGraphic(bmp, false, false, bmp.width, bmp.height, true);
                    tileInner.hasLoaded = true;
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

        public function loadTile(row:Number, col:Number, arr:Array=null, machines:Array=null, suffix:String=""):void {
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
                    this.makeCallback(tile, receivingMachine, suffix == "_collide" ? 8 : 1));
                var path:String = "../assets/test_tiles/" + macroImageName + "_" + numberString + suffix + ".png";
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

        public function isColliding(row:int, col:int):Boolean {
            var colliderTile:FlxExtSprite = this.getTileByIndex(row, col, this.colliderTiles);
            if (colliderTile == null) {
                return false;
            }

            return FlxCollision.pixelPerfectCheck(playerRef, colliderTile);
        }

        public function update():void {
            var playerRow:int, playerCol:int;
            playerRow = Math.floor(this.playerRef.pos.y / this.estTileHeight);
            playerCol = Math.floor(this.playerRef.pos.x / this.estTileWidth);

            var numberString:String = this.getTileIndex(playerRow, playerCol);
            this.dbgText.text = playerRow + "x" + playerCol + "\n" + numberString;

            // TODO - be smart about making this list as small as possible
            adjacentCoords.push([playerRow,   playerCol]);
            adjacentCoords.push([playerRow-1, playerCol]);
            adjacentCoords.push([playerRow+1, playerCol]);
            adjacentCoords.push([playerRow, playerCol-1]);
            adjacentCoords.push([playerRow, playerCol+1]);
            adjacentCoords.push([playerRow-1, playerCol+1]);
            adjacentCoords.push([playerRow+1, playerCol-1]);
            adjacentCoords.push([playerRow-1, playerCol-1]);
            adjacentCoords.push([playerRow+1, playerCol+1]);

            var row:int, col:int, contact:Boolean;
            for (var i:int = 0; i < adjacentCoords.length; i++) {
                row = adjacentCoords[i][0];
                col = adjacentCoords[i][1];
                // load background tiles
                if (!this.tileHasLoaded(row, col)) {
                    this.loadTile(row, col);
                }
                // load tile colliders
                if (!this.tileHasLoaded(row, col, this.colliderTiles)) {
                    this.loadTile(row, col, this.colliderTiles, this.colliderReceivingMachines, "_collide");
                } else if (this.isColliding(row, col)) {
                    contact = true;
                }
            }
            this.playerRef.colliding = contact;

            adjacentCoords.length = 0;
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
        }
    }
}
