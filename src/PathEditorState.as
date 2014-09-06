package
{
    import org.flixel.*;

    import flash.display.StageDisplayState;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;

    public class PathEditorState extends FlxState
    {
        public var pathWalker:PathFollower;
        public var _path:Path;
        public var _mapnodes:MapNodeContainer;
        public var enemies:EnemyGroup;
        public var boss:BossEnemy;
        public var showNodes:Boolean;
        public var mouseImg:FlxSprite;
        public var filename:String;
        public var dataFile:File, backupFile:File, writeFile:File;
        public var fpsCounter:FPSCounter;

        public static const MODE_READONLY:Number = 0;
        public static const MODE_EDIT:Number = 1;
        public var editorMode:Number;

        public function create_(player:Player):void
        {
            this.dataFile = File.applicationDirectory.resolvePath(
                "assets/" + this.filename);
            this.writeFile = File.applicationStorageDirectory.resolvePath(
                this.filename);
            this.backupFile = File.applicationStorageDirectory.resolvePath(
                this.filename + ".bak");

            if (!this.writeFile.exists) {
                this.editorMode = MODE_READONLY;
                FlxG.flashGfxSprite.mouseEnabled = false;
            } else {
                this.editorMode = MODE_EDIT;
                FlxG.flashGfxSprite.mouseEnabled = true;
            }
            //this.editorMode = MODE_EDIT; //turn this on in order to edit
            //compile with -a flag if I edit or make new path

            this.showNodes = this.editorMode == MODE_EDIT;

            pathWalker = new PathFollower(new DHPoint(player.x-10, player.y-100));

            player.initFootsteps();
            pathWalker.initFootsteps();

            mouseImg = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
            mouseImg.makeGraphic(10, 10, 0xff000000);
            add(mouseImg);

            _path = new Path(player);
            pathWalker.setPath(_path);
            pathWalker.setPlayerReference(player);

            _mapnodes = new MapNodeContainer(_path, player);
            pathWalker.setMapNodes(_mapnodes);

            this.enemies = new EnemyGroup(player, pathWalker);
            pathWalker.setEnemyGroupReference(this.enemies);

            this.readIn();

            if (this._path.hasNodes()) {
                this.pathWalker.moveToNextPathNode();
            }

            this.fpsCounter = new FPSCounter();

            this.boss = new BossEnemy(new DHPoint(0, 0));
            add(this.boss);
            this.boss.visible = false;
            this.boss._mapnodes = this._mapnodes;
            this.enemies.addEnemy(this.boss);

            add(pathWalker);
            add(player);

            add(player.debugText);
            add(pathWalker.debugText);
        }

        override public function destroy():void {
            this.fpsCounter.destroy();
            super.destroy();
        }

        override public function update():void {
            super.update();

            mouseImg.x = FlxG.mouse.x;
            mouseImg.y = FlxG.mouse.y;

            this._mapnodes.update();
            this._path.update();

            if (FlxG.mouse.justReleased()) {
                if (FlxG.keys["A"]) {
                    this._path.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y),
                                       this.showNodes);
                    this.pathWalker.moveToNextPathNode();
                } else if(FlxG.keys["S"]){
                    this._mapnodes.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y),
                                           this.showNodes);
                    this.pathWalker.moveToNextNode();
                } else if (FlxG.keys["Z"]) {
                    var en:SmallEnemy = new SmallEnemy(new DHPoint(FlxG.mouse.x,
                                                                   FlxG.mouse.y));
                    add(en);
                    this.enemies.addEnemy(en);
                } else if (FlxG.keys["Q"]) {
                    var boss:BossEnemy = new BossEnemy(new DHPoint(FlxG.mouse.x,
                                                                   FlxG.mouse.y));
                    add(boss);
                    this.enemies.addEnemy(boss);
                }
            }

            if (FlxG.keys.justReleased("W")) {
                this.writeOut();
            } else if (FlxG.keys.justReleased("C")) {
                this._path.clearPath();
                this._mapnodes.clearNodes();
            }

            this.enemies.update();
        }

        public function writeBackup():void {
            var f:File = this.writeFile;
            var str:FileStream = new FileStream();
            if (!f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var fBak:File = this.backupFile;
            str.open(fBak, FileMode.WRITE);
            str.writeUTFBytes(fileContents);
            str.close();
        }

        public function writeOut():void {
            if (this.editorMode != MODE_EDIT) {
                return;
            }
            this.writeBackup();
            var f:File = this.writeFile;
            var str:FileStream = new FileStream();
            str.open(f, FileMode.WRITE);

            var fString:String = "";
            var curNode:PathNode = null;
            var curMapNode:MapNode = null;
            var curEnemy:Enemy = null;

            var i:int;

            for (i = 0; i < this._path.nodes.length; i++) {
                curNode = this._path.nodes[i];
                fString += "pathnode " + curNode.pos.x + "x" + curNode.pos.y + "\n";
            }

            for (i = 0; i < this._mapnodes.nodes.length; i++) {
                curMapNode = this._mapnodes.nodes[i];
                fString += "mapnode " + curMapNode.pos.x + "x" + curMapNode.pos.y + "\n";
            }

            for (i = 0; i < this.enemies.length(); i++) {
                curEnemy = this.enemies.get_(i);
                fString += curEnemy.enemyType + " " + curEnemy.pos.x + "x" + curEnemy.pos.y + "\n";
            }

            str.writeUTFBytes(fString);
            str.close();
            this.writeBackup();
        }

        public function readIn():void {
            var f:File = this.dataFile;
            if (this.editorMode == MODE_EDIT) {
                if (this.writeFile.exists) {
                    f = this.writeFile;
                }
            }
            var str:FileStream = new FileStream();
            if (!f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var lines:Array = fileContents.split("\n");
            var line:Array;
            var coords:Array;
            var prefix_:String;
            for (var i:int = 0; i < lines.length - 1; i++) {
                line = lines[i].split(" ");
                prefix_ = line[0];
                if (prefix_.indexOf("pathnode") == 0) {
                    coords = line[1].split("x");
                    this._path.addNode(
                        new DHPoint(Number(coords[0]), Number(coords[1])),
                        this.showNodes);
                } else if (prefix_.indexOf("mapnode") == 0) {
                    coords = line[1].split("x");
                    this._mapnodes.addNode(
                        new DHPoint(Number(coords[0]), Number(coords[1])),
                        this.showNodes);
                } else if (prefix_.indexOf("enemy") == 0) {
                    coords = line[1].split("x");
                    var en:SmallEnemy = new SmallEnemy(
                        new DHPoint(Number(coords[0]), Number(coords[1])));
                    add(en);
                    this.enemies.addEnemy(en);
                } else if (prefix_.indexOf("boss") == 0) {
                    coords = line[1].split("x");
                    var bo:BossEnemy = new BossEnemy(
                        new DHPoint(Number(coords[0]), Number(coords[1])));
                    add(bo);
                    this.enemies.addEnemy(bo);
                }
            }
        }
    }
}
