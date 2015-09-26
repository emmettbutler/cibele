package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.entities.HallwayTile;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class HallwayTileLoader {
        public var dimensions:DHPoint, origin:DHPoint;
        public var tileDimensions:DHPoint, stopY:Number;

        private var tiles:Array, rowLoads:Array;
        private var player:Player;

        public function HallwayTileLoader(dimensions:DHPoint, origin:DHPoint,
                                          player:Player, stopY:Number) {
            this.dimensions = dimensions;
            this.origin = origin;
            this.player = player;
            this.stopY = stopY;

            this.tileDimensions = new DHPoint(77, 88);
            this.loadTiles();
        }

        public function loadTiles():void {
            this.tiles = new Array();
            this.rowLoads = new Array();
            var cur:HallwayTile;
            var rows:int = this.dimensions.y / this.tileDimensions.y;
            var cols:int = this.dimensions.x / this.tileDimensions.x;

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

        public function unload():void {
            for (var i:int = 0; i < this.tiles.length; i++) {
                for (var j:int = 0; j < this.tiles[i].length; j++) {
                    this.tiles[i][j].destroy();
                }
                this.tiles[i] = null;
            }
            this.tiles = null;
        }

        public function update():void {
            var cur:HallwayTile;
            var front:Number = this.player.pos.y - 100;
            var row:Array;

            if (front <= this.stopY) {
                return;
            }

            for (var i:int = 0; i < this.tiles.length; i++) {
                row = this.tiles[i];
                for (var j:int = 0; j < this.tiles[i].length; j++) {
                    cur = this.tiles[i][j];
                    cur.update();
                    if (cur.pos.y >= front) {
                        GlobalTimer.getInstance().setMark(
                            ScreenManager.getInstance().levelTracker.level + "_appear_" + i + "_" + j,
                            .01*GameSound.MSEC_PER_SEC*Math.random()*50,
                            cur.appear
                        );
                        this.rowLoads[i] = true;
                    }
                }

                if (this.rowLoads[i] == false && row[0].pos.y > front - 100) {
                    for (j = 0; j < row.length; j++) {
                        cur = row[j];
                        if(Math.random() * 2 > 1) {
                            GlobalTimer.getInstance().setMark(
                                ScreenManager.getInstance().levelTracker.level + "_appear_" + i + "_" + j,
                                .01*GameSound.MSEC_PER_SEC*Math.random()*50,
                                cur.appear
                            );
                            this.rowLoads[i] = true;
                        }
                    }
                }
            }
        }
    }
}
