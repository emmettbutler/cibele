package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.entities.Enemy;
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.ui.Mouse;
    import flash.ui.MouseCursorData;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;

    public class GameCursor extends GameObject {
        [Embed(source="/../assets/images/ui/attack_cursor.png")] private var ImgEnemy:Class;
        [Embed(source="/../assets/images/ui/gamemouse.png")] private var ImgGameCursor:Class;
        [Embed(source="/../assets/images/ui/computermouse.png")] private var ImgPCCursor:Class;
        [Embed(source="/../assets/images/misc/clear_cursor.png" )] public var ClearCursor:Class;

        public var clearCursor:Object;
        public var mouse_rect:FlxRect;
        public var enemy_mouse:GameObject;
        public var game_mouse:GameObject;
        public var pc_mouse:GameObject;

        private var cursorBitmapData:BitmapData;
        private var cursorData:MouseCursorData;
        private var cursorVector:Vector.<BitmapData>;

        public static const ENEMY:Number = 0;
        public static const GAME:Number = 1;
        public static const PC:Number = 2;

        public var spritesActive:Boolean = false;

        public function GameCursor() {
            super(new DHPoint(0,0));
            this.mouse_rect = new FlxRect(0,0,5,5);
            this._state = PC;
            this.observeGlobalPause = false;

            this.hideSystemCursor();
            this.addCursorSprites();
        }

        public function hideSystemCursor():void {
            if(Mouse.supportsNativeCursor){
                clearCursor = new ClearCursor();
                cursorBitmapData = new BitmapData(1, 1, true, 0x000000);
                cursorBitmapData.draw(clearCursor as IBitmapDrawable);
                cursorVector = new Vector.<BitmapData>();
                cursorVector[0] = cursorBitmapData;
                cursorData = new MouseCursorData();
                cursorData.hotSpot = new Point(10, 10);
                cursorData.data = cursorVector;
                Mouse.registerCursor("clearCursor", cursorData);
                Mouse.cursor = "clearCursor";
            }
        }

        override public function update():void {
            if(this.game_mouse != null) {
                this.mouse_rect.x = FlxG.mouse.x;
                this.mouse_rect.y = FlxG.mouse.y;
                this.game_mouse.x = FlxG.mouse.x;
                this.game_mouse.y = FlxG.mouse.y;
                this.enemy_mouse.x = FlxG.mouse.x;
                this.enemy_mouse.y = FlxG.mouse.y;
                this.pc_mouse.x = FlxG.mouse.x;
                this.pc_mouse.y = FlxG.mouse.y;

                if(this._state == GAME) {
                    this.game_mouse.alpha = 1;
                    this.enemy_mouse.alpha = 0;
                    this.pc_mouse.alpha = 0;
                } else if (this._state == ENEMY) {
                    this.enemy_mouse.alpha = 1;
                    this.game_mouse.alpha = 0;
                    this.pc_mouse.alpha = 0;
                } else if (this._state == PC) {
                    this.pc_mouse.alpha = 1;
                    this.game_mouse.alpha = 0;
                    this.enemy_mouse.alpha = 0;
                }
            }
        }

        public function addCursorSprites():void {
            this.enemy_mouse = new GameObject(new DHPoint(0,0));
            this.enemy_mouse.loadGraphic(ImgEnemy,false,false,28,63);
            FlxG.state.add(enemy_mouse);
            this.enemy_mouse.alpha = 0;

            this.game_mouse = new GameObject(new DHPoint(0,0));
            this.game_mouse.loadGraphic(ImgGameCursor,false,false,39,39);
            FlxG.state.add(game_mouse);
            this.game_mouse.alpha = 0;

            this.pc_mouse = new GameObject(new DHPoint(0, 0));
            this.pc_mouse.loadGraphic(ImgPCCursor,false,false,15,16);
            FlxG.state.add(pc_mouse);
            this.pc_mouse.alpha = 1;
        }

        public function resetCursor():void {
            FlxG.state.remove(this.enemy_mouse);
            FlxG.state.remove(this.pc_mouse);
            FlxG.state.remove(this.game_mouse);
            FlxG.state.add(this.enemy_mouse, true);
            FlxG.state.add(this.pc_mouse, true);
            FlxG.state.add(this.game_mouse, true);
        }

        public function setGameMouse():void {
            this._state = GAME;
        }

        public function setPCMouse():void {
            this._state = PC;
        }

        public function checkObjectOverlap(group:Array=null):void {
            var on_enemy:Boolean = false;
            if (group != null) {
                var cur:GameObject, rect:FlxRect;
                for (var i:int = 0; i < group.length; i++) {
                    cur = group[i];
                    rect = new FlxRect(cur.x, cur.y, cur.width, cur.height);
                    if (cur is Enemy) {
                        if (this.mouse_rect.overlaps(rect) && !(cur as Enemy).dead) {
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
        }
    }
}
