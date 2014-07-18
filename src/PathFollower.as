package
{
    import org.flixel.*;

    public class PathFollower extends FlxSprite
    {
        public var _path:Path;

        public function PathFollower(pos:DHPoint) {
            super(pos.x, pos.y);
            makeGraphic(10, 10, 0xffff0000);
        }

        public function setPath(path:Path):void {
            this._path = path;
        }
    }
}
