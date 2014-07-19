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

            this.dbgText = new FlxText(100, 150, 100, "");
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
    }
}
