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
        }

        public function loadTile(row:Number, col:Number):void {
            var tile:FlxExtSprite = tiles[row][col];

            function loadComplete(event_load:Event):void {
                var bmp:Bitmap = new Bitmap(event_load.target.content.bitmapData);
                tile.loadExtGraphic(bmp, false, false, bmp.width, bmp.height);
                tile.x = col * estTileWidth;
                tile.y = row * estTileHeight;
                receivingMachine.contentLoaderInfo.removeEventListener(
                    Event.COMPLETE, arguments.callee);
            }

            if (!tile.hasLoaded) {
                receivingMachine.contentLoaderInfo.addEventListener(
                    Event.COMPLETE, loadComplete);
                var req:URLRequest = new URLRequest(
                    "../assets/test_tiles/" + macroImageName + "_01.png")
                receivingMachine.load(req);
            }
        }

        public function update():void {
            var playerRow:Number, playerCol:Number;
            playerRow = this.playerRef.pos.y % this.estTileHeight;
            playerCol = this.playerRef.pos.x % this.estTileWidth;

            this.loadTile(playerRow, playerCol);
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
        }

    }
}
