package
{
    import org.flixel.*;

    public class GameObject extends FlxSprite {
        public var pos:DHPoint;

        public function GameObject(pos:DHPoint) {
            super(pos.x, pos.y);
            this.pos = pos;
        }
    }
}
