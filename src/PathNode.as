package {

    import org.flixel.*;

    public class PathNode extends FlxSprite
    {
        public var pos:DHPoint;
        public var next:PathNode;
        public var prev:PathNode;

        public function PathNode(pos:DHPoint)
        {
            super(pos.x, pos.y);
            makeGraphic(10, 10, 0xff0000ff);
            this.pos = pos;
            FlxG.state.add(this);

            this.next = null;
            this.prev = null;
        }
    }
}
