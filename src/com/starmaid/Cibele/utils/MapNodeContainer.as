package com.starmaid.Cibele.utils {
    import com.starmaid.Cibele.entities.MapNode;
    import com.starmaid.Cibele.entities.PathNode;
    import com.starmaid.Cibele.management.Path;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class MapNodeContainer
    {
        private var nodes:Array, sortedNodes:Array;
        public var nodesHash:Object;
        public var path:Path;
        public var player:Player;
        public var closestPathNode:PathNode;
        public var currentClosestNode:MapNode;

        public function MapNodeContainer(p:Path, player:Player) {
            this.nodes = new Array();
            this.sortedNodes = new Array();
            this.nodesHash = {};
            this.path = p;
            this.player = player;
        }

        public function addNode(point:DHPoint, showNodes:Boolean=false):MapNode {
            var node:MapNode = new MapNode(point, showNodes);
            node.visible = showNodes;
            node.active = false;
            this.nodes.push(node);
            this.nodesHash[node.node_id] = node;
            if (ScreenManager.getInstance().DEBUG) {
                //var lbl:FlxText = new FlxText(node.pos.x + 10, node.pos.y, 400, node.node_id);
                //lbl.color = 0xff444444;
                //FlxG.state.add(lbl);
            }
            return node;
        }

        public function getNode(i:int):MapNode {
            return this.nodes[i];
        }

        public function _length():Number {
            return this.nodes.length;
        }

        public function hasNodes():Boolean {
            return this.nodes.length != 0;
        }

        public function getRandomNode():MapNode {
            return this.nodes[Math.floor(Math.random() * (this.nodes.length))];
        }

        public function clearNodes():void {
            for (var i:int = 0; i < this.nodes.length; i++) {
                FlxG.state.remove(this.nodes[i]);
                this.nodes[i].destroy();
            }
            this.nodes.length = 0;
        }

        public function getNClosestGenericNodes(n:Number, pos:DHPoint):Array {
            var checkedGroup:Array = new Array();
            var curNode:MapNode, disp:Number;
            this.sortedNodes.length = 0;
            for (var i:Number = 0; i < this.nodes.length; i++) {
                curNode = this.nodes[i];
                disp = curNode.pos.sub(pos)._length();
                this.sortedNodes.push({"node": curNode, "disp": disp});
            }
            this.sortedNodes.sort(sortByDisp);
            for (i = 0; i < this.sortedNodes.length; i++) {
                if (checkedGroup.length < n) {
                    checkedGroup.push(this.sortedNodes[i]);
                }
            }
            checkedGroup.sort(sortByDisp);
            return checkedGroup;
        }

        private function sortByDisp(a:Object, b:Object):Number {
            var aY:Number = a['disp'];
            var bY:Number = b['disp'];

            if (aY > bY) {
                return 1;
            }
            if (aY < bY) {
                return -1;
            }
            return 0;
        }

        public function getClosestNode(pos:DHPoint, onscreen_allowed:Boolean=true):MapNode {
            this.closestPathNode = this.path.getClosestNode(pos, onscreen_allowed);
            currentClosestNode = this.nodes[0];
            var curNode:MapNode;
            for(var i:Number = 0; i < this.nodes.length; i++){
                curNode = this.nodes[i];
                var screenPos:DHPoint = new DHPoint(0, 0);
                curNode.getScreenXY(screenPos);
                if(this.path.shouldCheckNodePos(screenPos, onscreen_allowed)) {
                    if(pos.sub(curNode.pos)._length() <
                        pos.sub(currentClosestNode.pos)._length())
                    {
                        this.currentClosestNode = curNode;
                    }
                }
            }
            if(this.closestPathNode != null &&
                pos.sub(this.closestPathNode.pos)._length() <
                pos.sub(this.currentClosestNode.pos)._length())
            {
                return this.closestPathNode;
            } else {
                return this.currentClosestNode;
            }
        }
    }
}
