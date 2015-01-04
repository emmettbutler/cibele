package{
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;

    public class GraphGenerator extends LevelMapState {
        public var generateLock:Boolean = false;

        public function GraphGenerator():void {
            this.filename = "ikuturso_path.txt";
            this.graph_filename = "ikuturso_graph.txt";
            this.shouldAddEnemies = false;

            this.writeFile = File.applicationStorageDirectory.resolvePath(
                this.graph_filename);
            this.backupFile = File.applicationStorageDirectory.resolvePath(
                this.graph_filename + ".bak");
            this.dataFile = File.applicationDirectory.resolvePath(
                "assets/" + this.graph_filename);

            this.readExistingGraph = false;
        }

        override public function create():void {
            super.create();

            this.bgLoader.shouldLoadMap = false;
            this.bgLoader.loadAllTiles();
        }

        override public function update():void {
            super.update();

            if (this.bgLoader.allTilesHaveLoaded) {
                if (!this.generateLock) {
                    this.generateLock = true;
                    trace("Generating spatial graph...");
                    this.generate();
                    trace("Graph generated. Writing to file...");
                    this.writeOut();
                    trace("Done");
                }
            }
        }

        public function generate():void {
            var curMapNode:MapNode, secondaryNode:MapNode, res:Object;
            var allNodes:Array = this.getAllNodes();
            for (var i:int = 0; i < allNodes.length; i++) {
                curMapNode = allNodes[i];
                for (var k:int = 0; k < allNodes.length; k++) {
                    secondaryNode = allNodes[k];
                    res = this.nodesCanConnect(curMapNode, secondaryNode);
                    if (res["canConnect"]) {
                        curMapNode.addEdge(secondaryNode, res["length"]);
                        secondaryNode.addEdge(curMapNode, res["length"]);
                    }
                }
            }
        }

        public function rayCast(pt1:DHPoint, pt2:DHPoint,
                                color:uint=0xffff00ff, limit:Number=-1,
                                width:Number=1):FlxSprite {
            var xDisp:Number = pt2.x - pt1.x;
            var yDisp:Number = pt2.y - pt1.y;
            var disp:DHPoint = pt1.sub(pt2);

            if (disp._length() <= 0) {
                return null;
            }

            if (limit != -1 && disp._length() > limit) {
                return null;
            }

            var angle:Number = Math.atan2(yDisp, xDisp);

            var posX:Number = pt1.x + (disp._length() / 2) * Math.cos(angle);
            var posY:Number = pt1.y + (disp._length() / 2) * Math.sin(angle);

            var ray:FlxSprite = new FlxSprite(posX - disp._length() / 2, posY);
            ray.makeGraphic(disp._length(), width, color);
            ray.angle = this.radToDeg(angle);
            ray.active = false;
            if (ScreenManager.getInstance().DEBUG) {
                FlxG.state.add(ray);
            }
            return ray;
        }

        public function degToRad(degrees:Number):Number {
            return degrees * Math.PI / 180;
        }

        public function radToDeg(radians:Number):Number {
            return radians * 180 / Math.PI;
        }

        public function nodesCanConnect(node1:MapNode, node2:MapNode):Object {
            var ray:FlxSprite;
            if (node1 != node2) {
                ray = this.rayCast(node1.pos, node2.pos, 0xffff00ff, 440, 40);
            }

            if (ray == null) {
                return {"canConnect": false};
            }

            var canConnect:Boolean = !this.bgLoader.collideRay(ray, node1.pos,
                                                               node2.pos);
            if (!canConnect) {
                ray.color = 0xffff0000;
            }
            if (canConnect) {
                trace("adding ray of length: " + ray.width);
            }
            return {"canConnect": canConnect, "length": ray.width};
        }

        override public function writeOut():void {
            this.writeBackup();
            var fString:String = "";

            var curMapNode:MapNode, curEdge:GraphEdge;
            var allNodes:Array = this.getAllNodes();
            for (var i:int = 0; i < allNodes.length; i++) {
                curMapNode = allNodes[i];
                for (var k:int = 0; k < curMapNode.edges.length; k++) {
                    curEdge = curMapNode.edges[k];
                    fString += curMapNode.node_id + " " + curEdge.target.node_id
                               + " " + curEdge.score + "\n";
                }
            }

            var f:File = this.writeFile;
            var str:FileStream = new FileStream();
            str.open(f, FileMode.WRITE);
            str.writeUTFBytes(fString);
            str.close();
        }

        override public function writeBackup():void {
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
    }
}
