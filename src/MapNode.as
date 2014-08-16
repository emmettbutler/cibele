package {

    import org.flixel.*;

    public class MapNode extends FlxSprite
    {
        public var pos:DHPoint;

        public function MapNode(pos:DHPoint)
        {
            super(pos.x, pos.y);
            makeGraphic(10, 10, 0xff0000ff);
            this.pos = pos;
            FlxG.state.add(this);
        }
    }
}
