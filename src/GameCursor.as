package
{
    import org.flixel.*;

    public class GameCursor extends GameObject {
        [Embed(source="../assets/attack_cursor.png")] private var ImgEnemy:Class;
        [Embed(source="../assets/gamemouse.png")] private var ImgGameCursor:Class;
        public var mouse_rect:FlxRect;
        public var enemy_mouse:FlxSprite;
        public var game_mouse:FlxSprite;

        public static const ENEMY:Number = 0;
        public static const GAME:Number = 1;

        public function GameCursor() {
            super(new DHPoint(0,0));
            this.mouse_rect = new FlxRect(0,0,5,5);
            this._state = GAME;

            this.enemy_mouse = new FlxSprite(0,0);
            this.enemy_mouse.loadGraphic(ImgEnemy,false,false,22,56);
            FlxG.state.add(enemy_mouse);
            this.enemy_mouse.alpha = 0;

            this.game_mouse = new FlxSprite(0,0);
            this.game_mouse.loadGraphic(ImgGameCursor,false,false,39,39);
            FlxG.state.add(game_mouse);
            this.game_mouse.alpha = 1;
        }

        override public function update():void {
            this.mouse_rect.x = FlxG.mouse.x;
            this.mouse_rect.y = FlxG.mouse.y;
            this.game_mouse.x = FlxG.mouse.x;
            this.game_mouse.y = FlxG.mouse.y;
            this.enemy_mouse.x = FlxG.mouse.x;
            this.enemy_mouse.y = FlxG.mouse.y;

            if(this._state == GAME) {
                this.game_mouse.alpha = 1;
                this.enemy_mouse.alpha = 0;
            } else if (this._state == ENEMY) {
                this.enemy_mouse.alpha = 1;
                this.game_mouse.alpha = 0;
            }
        }

        public function checkObjectOverlap(group:Array=null):void {
            //if(this._state == GAME) {
                var on_enemy:Boolean = false;
                if (group != null) {
                    var cur:GameObject, rect:FlxRect;
                    for (var i:int = 0; i < group.length; i++) {
                        cur = group[i];
                        rect = new FlxRect(cur.x, cur.y, cur.width, cur.height);
                        if (cur is Enemy) {
                            if (this.mouse_rect.overlaps(rect)) {
                                on_enemy = true;
                            }
                        }
                    }
                }
                if (on_enemy) {
                    this._state = ENEMY;
                } else {
                    this._state = GAME;
                }
            //}
        }
    }
}