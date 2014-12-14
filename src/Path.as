package
{
    import org.flixel.*;

    public class Path
    {
        public var nodes:Array;
        public var currentNode:PathNode;
        public var nodeStatusCounter:Number;
        public var complete_:Boolean = false;
        public var closestNode:PathNode;

        public var dbgText:FlxText;

        public function Path() {
            this.nodes = new Array();
            this.currentNode = null;

            this.dbgText = new FlxText(100, 250, FlxG.width, "");
            FlxG.state.add(this.dbgText);
        }

        public function addNode(point:DHPoint, showNodes:Boolean=false):void {
            var node:PathNode = new PathNode(point, showNodes);
            node.next = null;
            node.visible = showNodes ? true : false;
            var prevNode:PathNode = this.nodes[this.nodes.length - 1];
            node.prev = prevNode
            if (prevNode != null) {
                prevNode.next = node;
            }
            node.active = false;
            this.nodes.push(node);
        }

        public function advance():Boolean {
            if (this.currentNode != null && this.currentNode.next != null) {
                this.currentNode = this.currentNode.next;
                return false;
            } else {
                this.currentNode = this.nodes[0];
                return true;
            }
        }

        public function setCurrentNode(n:PathNode):void {
            this.currentNode = n;
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

        public function update():void {
        }

        public function isPathComplete():Boolean{
            var _status:Boolean = false;
            nodeStatusCounter = 0;
            for(var i:Number = 0; i < this.nodes.length; i++){
                _status = this.nodes[i].status_();
                if(_status == true){
                    nodeStatusCounter++;
                }
            }
            if(nodeStatusCounter >= this.nodes.length){
                complete_ = true;
            }
            return complete_;
        }

        public function getClosestNode(pos:DHPoint):PathNode{
            var currentClosestNode:PathNode = this.nodes[0];
            for(var i:Number = 0; i < this.nodes.length; i++){
                if(pos.sub(this.nodes[i].pos)._length() < pos.sub(currentClosestNode.pos)._length()){
                    currentClosestNode = this.nodes[i];
                }
            }
            return currentClosestNode;
        }

        /*
         * Supposedly, this is an A* implementation
         */
        public static function shortestPath(sourceNode:MapNode,
                                            targetNode:MapNode):Path
        {
            var openList:Array, closedList:Array, curNode:MapNode,
                curCheckEdge:GraphEdge, curG:Number, curH:Number;

            openList = new Array();
            closedList = new Array();

            sourceNode.setAStarMeasures(0, Path.calcH(sourceNode, targetNode))
            openList.push(sourceNode);

            while (closedList.indexOf(targetNode) == -1 && openList.length > 0) {
                curNode = Path.getLowestF(openList);
                Path.moveToArray(curNode, openList, closedList);
                for (var i:int = 0; i < curNode.edges.length; i++) {
                    curCheckEdge = curNode.edges[i];
                    if (closedList.indexOf(curCheckEdge.target) != -1) {
                        if (openList.indexOf(curCheckEdge.target) == -1) {
                            curCheckEdge.target.parent = curNode;
                            curCheckEdge.target.costFromParent = curCheckEdge.score;
                            curG = Path.calcG(curCheckEdge.target, sourceNode);
                            curH = Path.calcH(curCheckEdge.target, targetNode);
                            curCheckEdge.target.setAStarMeasures(curG, curH);
                            openList.push(curCheckEdge.target);
                        } else {
                            if (curCheckEdge.target.g < curNode.g) {
                                curCheckEdge.target.parent = curNode;
                                curCheckEdge.target.costFromParent = curNode.pos.sub(curCheckEdge.target.pos)._length();
                                curG = Path.calcG(curCheckEdge.target, sourceNode);
                                curCheckEdge.target.setAStarMeasures(curG, curCheckEdge.target.h);
                            }
                        }
                    }
                }
            }

            // assemble the path object
            var cur:MapNode = targetNode, orderedPath:Array = new Array();
            while (cur.parent != null) {
                orderedPath.push(cur);
                cur = cur.parent;
            }
            var path:Path = new Path();
            for (var k:int = orderedPath.length - 1; k >= 0; k--) {
                path.addNode(orderedPath[k]);
            }
            return path;
        }

        private static function calcH(curNode:MapNode, targetNode:MapNode):Number {
            // TODO - maybe need a better hueristic here than just a straight line
            return curNode.pos.sub(targetNode.pos)._length();
        }

        private static function calcG(curNode:MapNode, sourceNode:MapNode):Number {
            var cur:MapNode = curNode, total:Number = 0;
            while (cur.parent != null) {
                total += cur.costFromParent;
                cur = cur.parent;
            }
            return total;
        }

        private static function moveToArray(item:Object, source:Array, target:Array):void {
            source.splice(source.indexOf(item, 1));
            target.push(item);
        }

        private static function getLowestF(openList:Array):MapNode {
            var ret:MapNode = openList[0];
            for (var i:int = 0; i < openList.length; i++) {
                if (openList[i].f < ret.f) {
                    ret = openList[i];
                }
            }
            return ret;
        }
    }
}
