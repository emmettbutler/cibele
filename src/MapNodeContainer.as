package
{
    import org.flixel.*;

    public class MapNodeContainer
    {
        public var nodes:Array;
        public var path:Path;
        public var player:Player;
        public var dbgText:FlxText;
        public var closestPathNode:PathNode;
        public var currentClosestNode:MapNode;

        public function MapNodeContainer(p:Path, player:Player) {
            this.nodes = new Array();
            this.path = p;
            this.player = player;
            this.dbgText = new FlxText(100, 250, FlxG.width, "");
            FlxG.state.add(this.dbgText);
        }

        public function addNode(point:DHPoint, showNodes:Boolean=false):void {
            var node:MapNode = new MapNode(point);
            node.alpha = showNodes ? 1 : 0;
            this.nodes.push(node);
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
            for(var i:int = 0; i < this.nodes.length; i++) {
                this.nodes[i].toggleActive(this.player);
            }
        }

        public function getClosestNode(pos:DHPoint, exclude:MapNode=null):MapNode {
            this.closestPathNode = this.path.getClosestNode(pos);
            currentClosestNode = this.nodes[0];
            var curNode:MapNode;
            for(var i:Number = 0; i < this.nodes.length; i++){
                curNode = this.nodes[i];
                if(exclude != null && curNode != exclude &&
                   pos.sub(curNode.pos)._length() <
                   pos.sub(currentClosestNode.pos)._length())
                {
                    this.currentClosestNode = curNode;
                }
            }
            if(this.closestPathNode != null && pos.sub(this.closestPathNode.pos)._length() <
                pos.sub(this.currentClosestNode.pos)._length()){
                return this.closestPathNode;
            } else {
                return this.currentClosestNode;
            }
        }
    }
}
