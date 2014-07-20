package
{
    import org.flixel.*;

    import flash.display.StageDisplayState;

    public class PathEditorState extends FlxState
    {
        public var pathWalker:PathFollower;
        public var _path:Path;
        public var enemies:EnemyGroup;
        public var mouseImg:FlxSprite;

        override public function create():void
        {
            mouseImg = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
            mouseImg.makeGraphic(5, 5, 0xffffffff);
            add(mouseImg);

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
            mouseImg.x = FlxG.mouse.x;
            mouseImg.y = FlxG.mouse.y;

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
