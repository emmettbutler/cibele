package
{
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
