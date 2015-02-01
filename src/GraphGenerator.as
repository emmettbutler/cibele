package{
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;

    public class GraphGenerator extends LevelMapState {
        public var generateLock:Boolean = false;

        public function GraphGenerator(state:LevelMapState):void {
            this.filename = state.filename;
            this.graph_filename = state.graph_filename;
            this.mapTilePrefix = state.mapTilePrefix;
            this.tileGridDimensions = state.tileGridDimensions;
            this.estTileDimensions = state.estTileDimensions;
            this.playerStartPos = state.playerStartPos;
            this.colliderScaleFactor = state.colliderScaleFactor;
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

        public function nodesCanConnect(node1:MapNode, node2:MapNode):Object {
            return this.pointsCanConnect(node1.pos, node2.pos);
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
