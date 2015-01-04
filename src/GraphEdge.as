package {
    import org.flixel.*;

    public class GraphEdge {
        public var target:MapNode;
        public var score:Number;

        public function GraphEdge(target:MapNode, score:Number) {
            this.target = target;
            this.score = score;
        }

        public function mark():void{ }
    }
}
