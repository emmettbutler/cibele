package
{
    import org.flixel.*;

    public class Path
    {
        public var nodes:Array;
        public var currentNode:PathNode;

        public function Path() {
            this.nodes = new Array();
        }

        public function addNode(point:DHPoint):void {
            var node:PathNode = new PathNode(point);
            if (this.nodes.length == 0) {
            } else {
                node.next = this.nodes[0];
                node.prev = this.nodes[this.nodes.length - 1];
            }
            this.nodes.push(node);
        }
    }
}
