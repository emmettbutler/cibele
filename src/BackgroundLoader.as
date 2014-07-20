package {
    import org.flixel.*;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;

    public class BackgroundLoader {

        private var receivingMachine:Loader;

        public var macroImageName:String;
        public var tiles:Array;
        public var rows:Number, cols:Number;
        public var playerRef:Player;
        public var estTileWidth:Number, estTileHeight:Number;

        public var dbgText:FlxText;

        public function BackgroundLoader(macroImageName:String, rows:Number, cols:Number) {
            this.macroImageName = macroImageName;
            this.rows = rows;
            this.cols = cols;
            this.estTileWidth = 1400;
            this.estTileHeight = 750;

            tiles = new Array();
            var spr:FlxExtSprite;
            for (var i:int = 0; i < this.rows; i++) {
                tiles[i] = new Array();
                for (var j:int = 0; j < this.cols; j++) {
                    spr = new FlxExtSprite(0, 0);
                    spr.makeGraphic(10, 10, 0x00000000);
                    FlxG.state.add(spr);
                    tiles[i][j] = spr;
                }
            }

            this.receivingMachine = new Loader();
            this.loadTile(0, 0);

            this.dbgText = new FlxText(100, 100, FlxG.width, "");
            this.dbgText.color = 0xff0000ff;
            this.dbgText.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(dbgText);
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

            function loadComplete(event_load:Event):void {
                var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                tile.loadExtGraphic(bmp, false, false, bmp.width, bmp.height);
                tile.x = col * estTileWidth;
                tile.y = row * estTileHeight;
                tile.hasLoaded = true;
                receivingMachine.contentLoaderInfo.removeEventListener(
                    Event.COMPLETE, arguments.callee);
            }

            if (!tile.hasStartedLoad) {
                tile.hasStartedLoad = true;

                var numberString:String = this.getTileIndex(row, col);

                receivingMachine.contentLoaderInfo.addEventListener(
                    Event.COMPLETE, loadComplete);
                var req:URLRequest = new URLRequest(
                    "../assets/test_tiles/" + macroImageName + "_" + numberString + ".png")
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

        public function update():void {
            var playerRow:int, playerCol:int;
            playerRow = Math.floor(this.playerRef.pos.y / this.estTileHeight);
            playerCol = Math.floor(this.playerRef.pos.x / this.estTileWidth);

            this.dbgText.text = playerRow + "x" + playerCol;

            if (!this.tileHasLoaded(playerRow, playerCol)) {
                this.loadTile(playerRow, playerCol);
            }
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
        }

    }
}
