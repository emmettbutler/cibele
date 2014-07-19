package
{
    import org.flixel.*;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;

    public class Path
    {
        public var nodes:Array;
        public var currentNode:PathNode;

        public var dbgText:FlxText;

        public function Path() {
            this.nodes = new Array();
            this.currentNode = null;

            this.dbgText = new FlxText(100, 250, FlxG.width, "");
            FlxG.state.add(this.dbgText);

            this.readIn();
        }

        public function writeOut():void {
            var fString:String = "";
            var cur:PathNode = null;

            for (var i:int = 0; i < this.nodes.length; i++) {
                cur = this.nodes[i];
                fString += cur.pos.x + "x" + cur.pos.y + "\n";
            }

            var f:File = File.applicationStorageDirectory.resolvePath("cibele.txt");
            var str:FileStream = new FileStream();
            str.open(f, FileMode.WRITE);
            str.writeUTFBytes(fString);
            str.close();
        }

        public function readIn():void {
            var f:File = File.applicationStorageDirectory.resolvePath("cibele.txt");
            var str:FileStream = new FileStream();
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var lines:Array = fileContents.split("\n");
            var coords:Array;
            for (var i:int = 0; i < lines.length - 1; i++) {
                coords = lines[i].split("x");
                this.addNode(new DHPoint(Number(coords[0]), Number(coords[1])));
            }
        }

        public function addNode(point:DHPoint):void {
            var node:PathNode = new PathNode(point);
            node.next = null;
            var prevNode:PathNode = this.nodes[this.nodes.length - 1];
            node.prev = prevNode
            if (prevNode != null) {
                prevNode.next = node;
            }
            this.nodes.push(node);
        }

        public function advance():void {
            if (this.currentNode != null && this.currentNode.next != null) {
                this.currentNode = this.currentNode.next;
            } else {
                this.currentNode = this.nodes[0];
            }
        }

        public function hasNextNode():Boolean {
            return this.currentNode.next != null;
        }
    }
}
