package
{
    import org.flixel.*;

    import flash.display.StageDisplayState;

    public class PathEditorState extends FlxState
    {
        public var pathWalker:PathFollower;
        public var _path:Path;

        override public function create():void
        {
            FlxG.mouse.show();

            pathWalker = new PathFollower(new DHPoint(100, 100));
            add(pathWalker);

            _path = new Path();
            pathWalker.setPath(_path);
        }

        override public function update():void {
            if (FlxG.mouse.pressed()) {
                _path.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
            }
        }
    }
}
