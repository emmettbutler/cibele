package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.entities.MapNode;
    import com.starmaid.Cibele.entities.PathNode;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GraphEdge;

    import org.flixel.*;

    public class Path
    {
        public var nodes:Array;
        public var nodesHash:Object;
        public var currentNode:PathNode;
        public var complete_:Boolean = false;
        public var closestNode:PathNode;

        public var dbgText:FlxText;

        public function Path() {
            this.nodes = new Array();
            this.currentNode = null;
            this.nodesHash = {};
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
            this.nodesHash[node.node_id] = node;
        }

        public function advance():void {
            this.currentNode = this.getNextNode(this.currentNode);
        }

        public function isAtFirstNode():Boolean {
            return this.currentNode == this.nodes[0];
        }

        private function getNextNode(node:PathNode):PathNode {
            if (node != null && node.next != null) {
                return node.next;
            } else {
                return this.nodes[0];
            }
        }

        public function getNodeByIndex(idx:Number):PathNode {
            var counter:Number = 0;
            var cur:PathNode = this.nodes[counter];
            while (counter != idx) {
                cur = this.getNextNode(cur);
                counter += idx >= 0 ? 1 : -1;
            }
            return cur;
        }

        public function advanceToNode(node:PathNode):void {
            while (this.currentNode != node) {
                this.advance();
            }
        }

        public function init():void {
            this.setCurrentNode(this.nodes[0]);
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

        public function getClosestNode(pos:DHPoint, onscreen_allowed:Boolean=true):PathNode{
            var curNode:PathNode;
            var currentClosestNode:PathNode = this.nodes[0];
            for(var i:Number = 0; i < this.nodes.length; i++){
                curNode = this.nodes[i];
                var screenPos:DHPoint = new DHPoint(0, 0);
                curNode.getScreenXY(screenPos);
                if(this.shouldCheckNodePos(screenPos, onscreen_allowed)) {
                    if(pos.sub(curNode.pos)._length() <
                        pos.sub(currentClosestNode.pos)._length())
                    {
                        currentClosestNode = curNode;
                    }
                }
            }
            return currentClosestNode;
        }

        public function shouldCheckNodePos(screenPos:DHPoint,
                                            onscreen_allowed:Boolean):Boolean
        {
            var _screen:ScreenManager = ScreenManager.getInstance();
            if (!onscreen_allowed) {
                return (
                    screenPos.x > _screen.screenWidth ||
                    screenPos.x < 0 || screenPos.y < 0 ||
                    screenPos.y > _screen.screenHeight
                );
            }
            return true;
        }

        public function toString():String {
            var ret:String = "", cur:PathNode = this.nodes[0];
            while (cur != null) {
                ret += cur.node_id + "\n";
                cur = cur.next;
            }
            return ret;
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

            if (ScreenManager.getInstance().DEBUG) {
                trace("starting:\n    target node: " + targetNode.node_id + "\n    source node: " + sourceNode.node_id);
            }
            while (closedList.indexOf(targetNode) == -1 && openList.length > 0) {
                if (ScreenManager.getInstance().DEBUG) {
                    trace("continuing\n    target in closed: " + (closedList.indexOf(targetNode) != -1) + "\n    target in open: " + (openList.indexOf(targetNode) != -1));
                }
                curNode = Path.getLowestF(openList);
                Path.moveToArray(curNode, openList, closedList);
                if (ScreenManager.getInstance().DEBUG) {
                    trace("closed list: " + closedList.length + "\nopen list: " + openList.length);
                }
                for (var i:int = 0; i < curNode.edges.length; i++) {
                    curCheckEdge = curNode.edges[i];

                    // not on the closed list
                    if (closedList.indexOf(curCheckEdge.target) == -1) {

                        // not on the open list
                        if (openList.indexOf(curCheckEdge.target) == -1) {
                            curCheckEdge.target.parent = curNode;
                            curCheckEdge.target.costFromParent = curCheckEdge.score;
                            curG = Path.calcG(curCheckEdge.target, sourceNode);
                            curH = Path.calcH(curCheckEdge.target, targetNode);
                            curCheckEdge.target.setAStarMeasures(curG, curH);

                            // add to the open list
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
            while (cur != null) {
                orderedPath.push(cur);
                cur = cur.parent;
            }
            var path:Path = new Path();
            for (var k:int = orderedPath.length - 1; k >= 0; k--) {
                path.addNode(orderedPath[k].pos);
            }
            path.init();
            return path;
        }

        private static function calcH(curNode:MapNode, targetNode:MapNode):Number {
            // TODO - maybe need a better hueristic here than just a straight line
            return curNode.pos.sub(targetNode.pos)._length();
        }

        private static function calcG(curNode:MapNode, sourceNode:MapNode):Number {
            var cur:MapNode = curNode, total:Number = 0;
            while (cur.parent != null && cur != sourceNode) {
                total += cur.costFromParent;
                cur = cur.parent;
            }
            return total;
        }

        private static function moveToArray(item:Object, source:Array, target:Array):void {
            source.splice(source.indexOf(item), 1);
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

        public function destroy():void {
            this.clearPath();
            this.nodes = null;
            this.nodesHash = null;
        }
    }
}
