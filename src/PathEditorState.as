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
        public var enemies:EnemyGroup;
        public var mouseImg:FlxSprite;

        public function create_(player:Player):void
        {
            add(player);

            mouseImg = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
            mouseImg.makeGraphic(5, 5, 0xffffffff);
            add(mouseImg);

            pathWalker = new PathFollower(new DHPoint(5460, 7390));
            add(pathWalker);

            _path = new Path();
            pathWalker.setPath(_path);
            pathWalker.setPlayerReference(player);

            this.enemies = new EnemyGroup(player, pathWalker);
            pathWalker.setEnemyGroupReference(this.enemies);

            this.readIn();

            if (this._path.hasNodes()) {
                this.pathWalker.moveToNextNode();
            }
        }

        override public function update():void {
            mouseImg.x = FlxG.mouse.x;
            mouseImg.y = FlxG.mouse.y;

            if (this.pathWalker != null) {
                this.pathWalker.update();
            }

            if (FlxG.mouse.justReleased()) {
                if (FlxG.keys["A"]) {
                    this._path.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
                    this.pathWalker.moveToNextNode();
                } else if (FlxG.keys["Z"]) {
                    var en:SmallEnemy = new SmallEnemy(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
                    add(en);
                    this.enemies.addEnemy(en);
                } else if (FlxG.keys["Q"]) {
                    var boss:BossEnemy = new BossEnemy(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
                    add(boss);
                    this.enemies.addEnemy(boss);
                }
            }

            if (FlxG.keys.justReleased("W")) {
                this.writeOut();
            } else if (FlxG.keys.justReleased("C")) {
                this._path.clearPath();
            }

            this.enemies.update();
        }

        public function writeBackup():void {
            var f:File = File.applicationStorageDirectory.resolvePath("cibele.txt");
            var str:FileStream = new FileStream();
            if (!f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var fBak:File = File.applicationStorageDirectory.resolvePath("cibele.txt.bak");
            str.open(fBak, FileMode.WRITE);
            str.writeUTFBytes(fileContents);
            str.close();
        }

        public function writeOut():void {
            this.writeBackup();
            var f:File = File.applicationStorageDirectory.resolvePath("cibele.txt");
            var str:FileStream = new FileStream();
            str.open(f, FileMode.WRITE);

            var fString:String = "";
            var curNode:PathNode = null;
            var curEnemy:Enemy = null;

            var i:int;

            for (i = 0; i < this._path.nodes.length; i++) {
                curNode = this._path.nodes[i];
                fString += "pathnode " + curNode.pos.x + "x" + curNode.pos.y + "\n";
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
            var f:File = File.applicationStorageDirectory.resolvePath("cibele.txt");
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
                        new DHPoint(Number(coords[0]), Number(coords[1])));
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
