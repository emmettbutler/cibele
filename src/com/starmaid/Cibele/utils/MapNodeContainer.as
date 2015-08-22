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
        public var nodes:Array;
        public var nodesHash:Object;
        public var path:Path;
        public var player:Player;
        public var dbgText:FlxText;
        public var closestPathNode:PathNode;
        public var currentClosestNode:MapNode;

        public function MapNodeContainer(p:Path, player:Player) {
            this.nodes = new Array();
            this.nodesHash = {};
            this.path = p;
            this.player = player;
            this.dbgText = new FlxText(100, 250, FlxG.width, "");
            this.dbgText.active = false;
            FlxG.state.add(this.dbgText);
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

        public function hasNodes():Boolean {
            return this.nodes.length != 0;
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
            trace("node num: " + this.nodes.length);
            for (var i:Number = 0; i < this.nodes.length; i++) {
                curNode = this.nodes[i];
                disp = curNode.pos.sub(pos)._length();
                if (disp < 700) {
                    checkedGroup.push({"node": curNode, "disp": disp});
                }
            }

            checkedGroup.sort(sortByDisp);
            trace("checkedGroupLenBefore: " + checkedGroup.length);
            checkedGroup.length = n;
            trace("checkedGroupLenAfter: " + checkedGroup.length);
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
