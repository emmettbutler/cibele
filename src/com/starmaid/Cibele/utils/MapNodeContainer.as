package com.starmaid.Cibele.utils {
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
            FlxG.state.add(this.dbgText);
        }

        public function addNode(point:DHPoint, showNodes:Boolean=false):MapNode {
            var node:MapNode = new MapNode(point, showNodes);
            node.alpha = showNodes ? 1 : 0;
            node.active = false;
            this.nodes.push(node);
            this.nodesHash[node.node_id] = node;
            if (ScreenManager.getInstance().DEBUG) {
                var lbl:FlxText = new FlxText(node.pos.x + 10, node.pos.y, 400, node.node_id);
                lbl.color = 0xff444444;
                FlxG.state.add(lbl);
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

        public function update():void {
        }

        public function getClosestGenericNode(pos:DHPoint):MapNode {
            var closestPathNode:MapNode = this.path.getClosestNode(pos);
            var currentClosestNode:MapNode = this.nodes[0];
            var curNode:MapNode, curDisp:Number, curClosestDisp:Number;
            if (currentClosestNode == null) {
                return null;
            }
            curClosestDisp = pos.sub(currentClosestNode.pos)._length();
            for(var i:Number = 0; i < this.nodes.length; i++){
                curNode = this.nodes[i];
                curDisp = pos.sub(curNode.pos)._length();
                if(curDisp < curClosestDisp)
                {
                    currentClosestNode = curNode;
                    curClosestDisp = pos.sub(currentClosestNode.pos)._length();
                }
            }
            if(this.closestPathNode != null && pos.sub(closestPathNode.pos)._length() < curClosestDisp){
                return closestPathNode;
            } else {
                return currentClosestNode;
            }
        }

        public function getNClosestGenericNodes(n:Number, pos:DHPoint):Array {
            var checkedGroup:Array = new Array();
            var curNode:MapNode, disp:Number;
            for (var i:Number = 0; i < this.nodes.length; i++) {
                curNode = this.nodes[i];
                disp = curNode.pos.sub(pos)._length();
                if (disp < 700) {
                    checkedGroup.push({"node": curNode, "disp": disp});
                }
            }

            checkedGroup.sort(sortByDisp);
            checkedGroup.length = n;
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

        public function getClosestNode(pos:DHPoint, exclude:MapNode=null, on_screen:Boolean = true):MapNode {
            this.closestPathNode = this.path.getClosestNode(pos);
            currentClosestNode = this.nodes[0];
            var curNode:MapNode;
            for(var i:Number = 0; i < this.nodes.length; i++){
                curNode = this.nodes[i];
                if(on_screen) {
                    if(exclude != null && curNode != exclude &&
                       pos.sub(curNode.pos)._length() <
                       pos.sub(currentClosestNode.pos)._length())
                    {
                        this.currentClosestNode = curNode;
                    }
                } else {
                    var screenPos:DHPoint = new DHPoint(0, 0);
                    curNode.getScreenXY(screenPos);
                    if((screenPos.x < ScreenManager.getInstance().screenWidth &&
                       screenPos.x > 0 && screenPos.y > 0 &&
                       screenPos.y < ScreenManager.getInstance().screenHeight) == false)
                    {
                        if(pos.sub(curNode.pos)._length() <
                           pos.sub(currentClosestNode.pos)._length())
                        {
                            this.currentClosestNode = curNode;
                        }
                    }
                }
            }
            if(this.closestPathNode != null && pos.sub(this.closestPathNode.pos)._length() <
                pos.sub(this.currentClosestNode.pos)._length() && on_screen){
                return this.closestPathNode;
            } else {
                return this.currentClosestNode;
            }
        }
    }
}
