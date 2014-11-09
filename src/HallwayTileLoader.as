package {
    import org.flixel.*;

    public class HallwayTileLoader {
        public var dimensions:DHPoint, origin:DHPoint;
        public var tileDimensions:DHPoint;

        private var tiles:Array, rowLoads:Array;
        private var player:Player;

        public function HallwayTileLoader(dimensions:DHPoint, origin:DHPoint,
                                          player:Player) {
            this.dimensions = dimensions;
            this.origin = origin;
            this.player = player;

            this.tileDimensions = new DHPoint(77, 88);
            this.loadTiles();
        }

        public function loadTiles():void {
            this.tiles = new Array();
            this.rowLoads = new Array();
            var cur:HallwayTile;
            var rows:int = this.dimensions.y/this.tileDimensions.y;
            var cols:int = this.dimensions.x/this.tileDimensions.x;
            for (var i:int = 0; i < rows; i++) {
                var row:Array = new Array();
                for (var j:int = 0; j < cols; j++) {
                    cur = new HallwayTile(
                        new DHPoint(
                            this.origin.x + this.tileDimensions.x * j,
                            this.origin.y + this.tileDimensions.y * i
                        ), this.tileDimensions
                    );
                    FlxG.state.add(cur);
                    row.push(cur);
                }
                this.tiles.push(row.slice());
                this.rowLoads[i] = false;
            }
        }

        public function update():void {
            var cur:HallwayTile;
            var front:Number = this.player.pos.y - 100;
            var row:Array;
            for (var i:int = 0; i < this.tiles.length; i++) {
                row = this.tiles[i];
                for (var j:int = 0; j < this.tiles[i].length; j++) {
                    cur = this.tiles[i][j];
                    cur.update();
                    if (cur.pos.y >= front) {
                        GlobalTimer.getInstance().setMark("appear_" + i + "_" + j,
                            .01*GameSound.MSEC_PER_SEC*Math.random()*50,
                            cur.appear);
                        this.rowLoads[i] = true;
                    }
                }

                if (this.rowLoads[i] == false && row[0].pos.y > front - 100) {
                    for (j = 0; j < row.length; j++) {
                        cur = row[j];
                        if(Math.random() * 2 > 1) {
                            GlobalTimer.getInstance().setMark(
                                "appear_" + i + "_" + j,
                                .01*GameSound.MSEC_PER_SEC*Math.random()*50,
                                cur.appear);
                            this.rowLoads[i] = true;
                        }
                    }
                }
            }
        }
    }
}
