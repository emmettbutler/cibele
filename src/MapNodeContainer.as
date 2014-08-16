package
{
    import org.flixel.*;

    /*
        Make PathNode a subclass of GenericNode (to be implemented)
        Implement getClosestNode() in Path - take a DHPoint, return the pathnode closest to that point
        Implement MapNodeContainer class with a getClosestNode() method
        MapNodeContainer has a member _path which is a reference to the Path
        getClosestNode() should return the closest node of any kind (path or non path)
        Ichi logic is tbd - needs to know about the Path and the MapNodeContainer
    */

    public class MapNodeContainer
    {
        public var nodes:Array;
        public var path:Path;
        public var dbgText:FlxText;
        public var closestPathNode:PathNode;
        public var currentClosestNode:MapNode;

        public function MapNodeContainer(p:Path) {
            this.nodes = new Array();
            this.path = p;

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

        public function clearPath():void {
            for (var i:int = 0; i < this.nodes.length; i++) {
                FlxG.state.remove(this.nodes[i]);
                this.nodes[i].destroy();
            }
            this.nodes.length = 0;
        }

        public function getClosestNode(pos:DHPoint):MapNode {
            this.closestPathNode = this.path.getClosestNode(pos);
            for(var i:Number = 0; i < this.nodes.length; i++){
                if(pos.sub(this.nodes[i].pos)._length() < 100){
                    this.currentClosestNode = this.nodes[i];
                }
            }
            if(pos.sub(this.closestPathNode.pos)._length() <
                pos.sub(this.currentClosestNode.pos)._length()){
                return this.closestPathNode;
            } else {
                return this.currentClosestNode;
            }
        }
    }
}