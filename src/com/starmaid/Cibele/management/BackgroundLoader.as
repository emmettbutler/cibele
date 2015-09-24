package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.entities.SmallEnemy;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameSound;

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
        public var tiles:Array, colliderTiles:Array, scaledBMDs:Array;
        public var rows:Number, cols:Number;
        public var playerRef:Player;
        public var enemiesRef:Array, curEnemy:SmallEnemy;
        public var estTileWidth:Number, estTileHeight:Number;
        public var coordsToLoad:Array, coordsToUnload:Array;
        public var colliderScaleFactor:Number, lastTileLoadUpdate:Number = -1;
        public var collisionData:Array;
        public var shouldLoadMap:Boolean, shouldCollidePlayer:Boolean = true;
        public var allTilesHaveLoaded:Boolean = false;
        private var enemyContacts:Array;
        private var screenPos:DHPoint;

        public var dbgText:FlxText;

        public function BackgroundLoader(macroImageName:String="",
                                         gridDimensions:DHPoint=null,
                                         estTileDimensions:DHPoint=null,
                                         colliderScaleFactor:Number=1,
                                         showColliders:Boolean=false)
        {
            this.screenPos = new DHPoint(0, 0);
            this.shouldLoadMap = true;
            this.colliderName = macroImageName + "_collider"
            this.macroImageName = macroImageName + "_map";
            this.colliderScaleFactor = colliderScaleFactor;
            if (gridDimensions != null) {
                this.rows = gridDimensions.x;
                this.cols = gridDimensions.y;
            }
            if (estTileDimensions != null) {
                this.estTileWidth = estTileDimensions.x;
                this.estTileHeight = estTileDimensions.y;
            }
            this.coordsToLoad = new Array();
            this.coordsToUnload = new Array();
            this.scaledBMDs = new Array();
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

        public function destroy():void {
            for (var i:int = 0; i < this.tiles.length; i++) {
                for (var k:int = 0; k < this.tiles[i].length; k++) {
                    this.tiles[i][k].unload();
                    this.tiles[i][k].destroy();
                    this.colliderTiles[i][k].unload();
                    this.colliderTiles[i][k].destroy();
                    this.receivingMachines[i][k].unload();
                    this.colliderReceivingMachines[i][k].unload();
                }
            }
            for (i = 0; i < this.scaledBMDs.length; i++) {
                this.scaledBMDs[i].dispose();
            }
            this.tiles = null;
            this.receivingMachines = null;
            this.colliderTiles = null;
            this.colliderReceivingMachines = null;
            this.playerRef = null;
            this.enemiesRef = null;
            this.enemyContacts = null;
        }

        public function buildLoadCompleteCallback(tile:FlxExtSprite,
                                                  receivingMachine:Loader,
                                                  scaleFactor:Number=1):Function {
            var that:BackgroundLoader = this;
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
                                                                  true, 0x00000000);
                        scaledBMD.draw(bmp, matrix, null, null, null, true);
                        bmp = new Bitmap(scaledBMD, PixelSnapping.NEVER, true);
                        that.scaledBMDs.push(scaledBMD);
                    }
                    // the last parameter is really important for transparent images
                    // it says "clear the pixel cache before loading this image"
                    // weird things happen with collider tiles when it's false
                    tile.loadExtGraphic(bmp, false, false, bmp.width, bmp.height, true);
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

        public function tileIsOnscreen(tile:FlxExtSprite):Boolean {
            tile.getScreenXY(this.screenPos);
            return (this.screenPos.x < ScreenManager.getInstance().screenWidth &&
                this.screenPos.x > 0 - tile.frameWidth &&
                this.screenPos.y > 0 - tile.frameHeight &&
                this.screenPos.y < ScreenManager.getInstance().screenHeight);
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
            if (!tile.hasLoaded && !tile.loading) {
                tile.loading = true;

                receivingMachine.contentLoaderInfo.addEventListener(Event.COMPLETE,
                    this.buildLoadCompleteCallback(tile, receivingMachine,
                                                   isCollider ? this.colliderScaleFactor : 1));
                var path:String = "/../assets/images/worlds/map_tiles/" + imgName + "_" + numberString + ".png";
                var req:URLRequest = new URLRequest(path);
                receivingMachine.load(req);
            }
        }

        public function unloadTile(row:int, col:int):void {
            var tile:FlxExtSprite = this.getTileByIndex(row, col);
            if (tile == null) {
                return;
            }
            tile.unload();
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
                return tile.hasLoaded;
            }
            return false
        }

        public function getPlayerCollisionData(colliderTile:FlxExtSprite):Array {
            if (colliderTile == null) {
                return [false, null];
            }
            return FlxCollision.pixelPerfectCheck(playerRef.mapHitbox,
                                                  colliderTile, 255, null, 6, 4,
                                                  ScreenManager.getInstance().DEBUG);
        }

        public function getEnemyCollisionData(colliderTile:FlxExtSprite,
                                              enemy:SmallEnemy):Array
        {
            if (colliderTile == null) {
                return [false, null];
            }
            return FlxCollision.pixelPerfectCheck(enemy.mapHitbox,
                                                  colliderTile, 255, null, 6, 4,
                                                  ScreenManager.getInstance().DEBUG);
        }

        public function getCoordsAtPoint(pt:DHPoint):Array {
            var relPos:DHPoint = new DHPoint(pt.x / this.estTileWidth, pt.y / this.estTileHeight);
            var row:Number = Math.floor(relPos.y);
            var col:Number = Math.floor(relPos.x);
            return [row, col];
        }

        public function getTileAtPoint(pt:DHPoint, arr:Array):FlxExtSprite {
            var coords:Array = this.getCoordsAtPoint(pt);
            return this.getTileByIndex(coords[0], coords[1], arr);
        }

        public function collideRay(ray:FlxSprite, pt1:DHPoint, pt2:DHPoint):Boolean {
            var tilesToCheck:Array = new Array();
            //tilesToCheck.push(this.getTileAtPoint(pt1, this.colliderTiles));
            //tilesToCheck.push(this.getTileAtPoint(pt2, this.colliderTiles));

            var i:int;

            for (i = 0; i < this.colliderTiles.length; i++) {
                for (var k:int = 0; k < this.colliderTiles[i].length; k++) {
                    tilesToCheck.push(this.colliderTiles[i][k]);
                }
            }

            var colliderTile:FlxExtSprite;
            for (i = 0; i < tilesToCheck.length; i++) {
                colliderTile = tilesToCheck[i];
                if (FlxCollision.pixelPerfectCheck(ray, colliderTile, 255, null, 0, 0, false, pt1)[0]) {
                    return true;
                }
            }
            return false;
        }

        public function loadAllTiles():void {
            for (var row:int = 0; row < rows; row++) {
                for (var col:int = 0; col < cols; col++) {
                    this.loadTile(row, col, this.colliderTiles,
                                  this.colliderReceivingMachines,
                                  this.colliderName, true);
                }
            }
        }

        public function unloadAllTiles():void {
            for (var row:int = 0; row < rows; row++) {
                for (var col:int = 0; col < cols; col++) {
                    this.loadTile(row, col, this.colliderTiles,
                                  this.colliderReceivingMachines,
                                  this.colliderName, true);
                }
            }
        }

        public function allTilesLoaded():Boolean {
            for (var row:int = 0; row < rows; row++) {
                for (var col:int = 0; col < cols; col++) {
                    if (!this.tileHasLoaded(row, col, this.colliderTiles)) {
                        return false;
                    }
                }
            }
            return true;
        }

        public function update():void {
            var playerRow:int, playerCol:int, playerRelativePos:DHPoint;
            playerRelativePos = new DHPoint(
                this.playerRef.pos.x / this.estTileWidth,
                this.playerRef.pos.y / this.estTileHeight);
            playerRow = Math.floor(playerRelativePos.y);
            playerCol = Math.floor(playerRelativePos.x);

            var row:int, col:int, nextTileIn:FlxExtSprite, thisTile:FlxExtSprite;
            if (new Date().valueOf() - this.lastTileLoadUpdate > 1 * GameSound.MSEC_PER_SEC) {
                this.lastTileLoadUpdate = new Date().valueOf();
                // for each tile, check whether the one next to it that's closer
                // to the player is onscreen. if so, load it.
                for (row = 0; row < rows; row++) {
                    for (col = 0; col < cols; col++) {
                        nextTileIn = this.getTileByIndex(
                            playerRow == row ? playerRow : (row + (playerRow > row ? 1 : -1)),
                            playerCol == col ? playerCol : (col + (playerCol > col ? 1 : -1)),
                            this.colliderTiles);
                        thisTile = this.getTileByIndex(row, col,
                                                       this.colliderTiles);
                        if (this.tileIsOnscreen(nextTileIn) ||
                            this.tileIsOnscreen(thisTile))
                        {
                            coordsToLoad.push([row, col]);
                        } else {
                            coordsToUnload.push([row, col]);
                        }
                    }
                }
            }
            coordsToLoad.push([playerRow, playerCol]);

            var playerContact:Boolean;
            var colliderTile:FlxExtSprite;
            var k:int = 0;
            // clear out contacts array for next run
            for (k = 0; k < this.enemiesRef.length; k++) {
                this.enemyContacts[k] = false;
            }
            for (var i:int = 0; i < coordsToLoad.length; i++) {
                row = coordsToLoad[i][0];
                col = coordsToLoad[i][1];
                // load background tiles
                if (!ScreenManager.getInstance().DEBUG && this.shouldLoadMap) {
                    this.loadTile(row, col, null, null, this.macroImageName);
                }
                // load tile colliders
                this.loadTile(row, col, this.colliderTiles,
                              this.colliderReceivingMachines,
                              this.colliderName, true);
            }
            // unload background tiles that are far offscreen
            for (i = 0; i < coordsToUnload.length; i++) {
                row = coordsToUnload[i][0];
                col = coordsToUnload[i][1];
                this.unloadTile(row, col);
            }
            for (row = 0; row < rows; row++) {
                for (col = 0; col < cols; col++) {
                    colliderTile = this.getTileByIndex(row, col, this.colliderTiles);
                    if (this.tileIsOnscreen(colliderTile)) {
                        if (this.shouldCollidePlayer) {
                            collisionData = this.getPlayerCollisionData(colliderTile)
                            if (collisionData[0]) {
                                playerContact = true;
                                this.playerRef.collisionDirection = collisionData[1];
                            }
                        }
                        for (k = 0; k < this.enemiesRef.length; k++) {
                            if (this.enemiesRef[k] is SmallEnemy) {
                                curEnemy = this.enemiesRef[k];
                                if (curEnemy.isOnscreen() && !curEnemy.isDead()) {
                                    collisionData = this.getEnemyCollisionData(
                                        colliderTile, this.enemiesRef[k]);
                                    if (collisionData[0]) {
                                        this.enemyContacts[k] = true;
                                        this.enemiesRef[k].collisionDirection = collisionData[1];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            this.playerRef.colliding = playerContact;
            for (k = 0; k < this.enemiesRef.length; k++) {
                if (this.enemiesRef[k] is SmallEnemy) {
                    curEnemy = this.enemiesRef[k];
                    curEnemy.colliding = this.enemyContacts[k];
                }
            }

            coordsToLoad.length = 0;
            coordsToUnload.length = 0;

            if(this.allTilesLoaded()) {
                this.allTilesHaveLoaded = true;
            }
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
            this.playerRef.bgLoaderRef = this;
        }

        public function setEnemiesReference(en:Array):void {
            this.enemiesRef = en;
            this.enemyContacts = new Array(this.enemiesRef.length);
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

        public function collideTile(tile:FlxExtSprite):void {
            collisionData = this.getPlayerCollisionData(tile);
            this.playerRef.colliding = collisionData[0];
            if (collisionData[0]) {
                this.playerRef.collisionDirection = collisionData[1];
            }
        }
    }
}
