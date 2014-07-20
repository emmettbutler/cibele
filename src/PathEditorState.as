package
{
    import org.flixel.*;

    import flash.display.StageDisplayState;

    public class PathEditorState extends FlxState
    {
        public var pathWalker:PathFollower;
        public var _path:Path;
        public var enemies:EnemyGroup;

        override public function create():void
        {
            FlxG.mouse.show();

            pathWalker = new PathFollower(new DHPoint(100, 100));
            add(pathWalker);

            _path = new Path();
            pathWalker.setPath(_path);

            this.enemies = new EnemyGroup();
            pathWalker.setEnemyGroupReference(this.enemies);

            if (this._path.hasNodes()) {
                this.pathWalker.moveToNextNode();
            }
        }

        override public function update():void {
            if (this.pathWalker != null) {
                this.pathWalker.update();
            }

            if (FlxG.mouse.justReleased()) {
                if (FlxG.keys["A"]) {
                    this._path.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
                    this.pathWalker.moveToNextNode();
                } else if (FlxG.keys["Z"]) {
                    var en:SmallEnemy = new SmallEnemy(new DHPoint(FlxG.mouse.x, FlxG.mouse.y));
                    add(en);
                    this.enemies.addEnemy(en);
                }
            }

            if (FlxG.keys.justReleased("W")) {
                this._path.writeOut();
            } else if (FlxG.keys.justReleased("C")) {
                this._path.clearPath();
            }
        }
    }
}
