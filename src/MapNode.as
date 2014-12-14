package {

    import org.flixel.*;

    public class MapNode extends GameObject
    {
        public var _type:Number;
        public var edges:Array;
        public var node_id:String;
        public static const TYPE_MAP:Number = 1;
        public static const TYPE_PATH:Number = 2;

        public function MapNode(pos:DHPoint, addToState:Boolean=false)
        {
            super(pos);
            this.edges = new Array();
            this.node_id = pos.x + "x" + pos.y;
            this._type = TYPE_MAP;
            makeGraphic(10, 10, 0xff00ffff);
            this.pos = pos;
            if (addToState) {
                FlxG.state.add(this);
            }
        }

        public function addEdge(target:MapNode, score:Number):void {
            this.edges.push(new GraphEdge(target, score));
        }

        public function mark():void{ }
    }
}
