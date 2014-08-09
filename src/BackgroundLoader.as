package {
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
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
            var spr:FlxExtSprite;
            for (var i:int = 0; i < this.rows; i++) {
                tiles[i] = new Array();
                colliderTiles[i] = new Array();
                receivingMachines[i] = new Array();
                colliderReceivingMachines[i] = new Array();
                for (var j:int = 0; j < this.cols; j++) {
                    spr = new FlxExtSprite(0, 0);
                    spr.makeGraphic(10, 10, 0x00000000);
                    FlxG.state.add(spr);
                    spr.x = j * estTileWidth;
                    spr.y = i * estTileHeight;
                    tiles[i][j] = spr;

                    receivingMachines[i][j] = new Loader();

                    spr = new FlxExtSprite(0, 0);
                    spr.makeGraphic(10, 10, 0x00000000);
                    FlxG.state.add(spr);
                    spr.x = j * estTileWidth;
                    spr.y = i * estTileHeight;
                    colliderTiles[i][j] = spr;

                    colliderReceivingMachines[i][j] = new Loader();
                }
            }

            this.dbgText = new FlxText(100, 100, FlxG.width, "");
            this.dbgText.color = 0xff0000ff;
            this.dbgText.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(dbgText);
        }

        public function makeCallback(tile:FlxExtSprite, receivingMachine:Loader, vis:Boolean=true):Function {
            return function (event_load:Event):void {
                var tileInner:FlxExtSprite = tile;
                var visInner:Boolean = vis;
                var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                tileInner.loadExtGraphic(bmp, false, false, bmp.width, bmp.height);
                tileInner.hasLoaded = true;
                receivingMachine.contentLoaderInfo.removeEventListener(
                    Event.COMPLETE, arguments.callee);
            }
        }

        public function loadTile(row:Number, col:Number):void {
            var rowArr:Array = this.tiles[row];
            if (rowArr == null) {
                return;
            }
            var tile:FlxExtSprite = rowArr[col];
            if (tile == null) {
                return;
            }

            var rowColliderArr:Array = this.colliderTiles[row];
            if (rowColliderArr == null) {
                return;
            }
            var colliderTile:FlxExtSprite = rowColliderArr[col];
            if (colliderTile == null) {
                return;
            }

            var receivingMachine:Loader, colliderReceivingMachine:Loader;
            receivingMachine = this.receivingMachines[row][col];
            colliderReceivingMachine = this.colliderReceivingMachines[row][col];

            if (!tile.hasStartedLoad) {
                tile.hasStartedLoad = true;
                var numberString:String = this.getTileIndex(row, col);
                receivingMachine.contentLoaderInfo.addEventListener(
                    Event.COMPLETE, this.makeCallback(tile, receivingMachine));
                var req:URLRequest = new URLRequest(
                    "../assets/test_tiles/" + macroImageName + "_"
                    + numberString + ".png"
                );
                receivingMachine.load(req);

                req = new URLRequest(
                    "../assets/test_tiles/" + macroImageName + "_02_collide.png"
                );
                colliderReceivingMachine.contentLoaderInfo.addEventListener(
                    Event.COMPLETE, this.makeCallback(colliderTile, colliderReceivingMachine, false));
                colliderReceivingMachine.load(req);
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

        public function tileHasLoaded(row:int, col:int):Boolean {
            var rowArr:Array = this.tiles[row];
            if (rowArr == null) {
                return false;
            }
            var tile:FlxExtSprite = rowArr[col];
            if (tile != null) {
                return tile.hasLoaded;
            }
            return false
        }

        public function performCollision(row:int, col:int):void {
            var rowColliderArr:Array = this.colliderTiles[row];
            if (rowColliderArr == null) {
                return;
            }
            var colliderTile:FlxExtSprite = rowColliderArr[col];
            if (colliderTile == null) {
                return;
            }

            if (FlxCollision.pixelPerfectCheck(playerRef, colliderTile)) {
                playerRef.colliding = true;
                playerRef.x += 10;
            } else {
                playerRef.colliding = false;
            }
        }

        public function update():void {
            var playerRow:int, playerCol:int;
            playerRow = Math.floor(this.playerRef.pos.y / this.estTileHeight);
            playerCol = Math.floor(this.playerRef.pos.x / this.estTileWidth);

            this.dbgText.text = playerRow + "x" + playerCol;

            adjacentCoords.push([playerRow,   playerCol]);

            var row:int, col:int;
            for (var i:int = 0; i < adjacentCoords.length; i++) {
                row = adjacentCoords[i][0];
                col = adjacentCoords[i][1];
                if (!this.tileHasLoaded(row, col)) {
                    this.loadTile(row, col);
                } else {
                    this.performCollision(row, col);
                }
            }

            adjacentCoords.length = 0;
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
        }
    }
}
