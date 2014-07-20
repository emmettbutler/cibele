package
{
    import org.flixel.*;

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

        public function hasNodes():Boolean {
            return this.nodes.length != 0;
        }

        public function clearPath():void {
            for (var i:int = 0; i < this.nodes.length; i++) {
                FlxG.state.remove(this.nodes[i]);
                this.nodes[i].destroy();
            }
            this.currentNode = null;
            this.nodes.length = 0;
        }
    }
}
