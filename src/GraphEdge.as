package {
    import org.flixel.*;

    public class GraphEdge {
        public var target:MapNode;
        public var score:Number;

        public function GraphEdge(target:MapNode, score:Number) {
            this.target = target;
            // 0 <= score <= 1
            this.score = Math.max(Math.min(score, 1), 0);
        }

        public function mark():void{ }
    }
}
