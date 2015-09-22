package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.GlobalTimer;
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
        public var mouse_rect:FlxRect, mouse_screen_rect:FlxRect;
        public var enemy_mouse:GameObject;
        public var game_mouse:GameObject;
        public var pc_mouse:GameObject;

        private var on_ui:Boolean = false, on_enemy:Boolean = false;
        private var hidden:Boolean = false;

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
            this.mouse_screen_rect = new FlxRect(0,0,5,5);
            this._state = PC;
            this.observeGlobalPause = false;
            GameCursor.hideSystemMouse();
        }

        override public function update():void {
            super.update();
            if(this.game_mouse != null) {
                this.mouse_rect.x = FlxG.mouse.x;
                this.mouse_rect.y = FlxG.mouse.y;
                this.mouse_screen_rect.x = FlxG.mouse.screenX;
                this.mouse_screen_rect.y = FlxG.mouse.screenY;
                this.x = FlxG.mouse.screenX;
                this.y = FlxG.mouse.screenY;

                if (this.on_ui){
                    this._state = GAME;
                } else if (!GlobalTimer.getInstance().isPaused() && this.on_enemy) {
                    this._state = ENEMY;
                } else {
                    this._state = GAME;
                }

                if (this.hidden) {
                    if (this.pc_mouse.visible || this.game_mouse.visible ||
                        this.enemy_mouse.visible)
                    {
                        this.pc_mouse.visible = false;
                        this.game_mouse.visible = false;
                        this.enemy_mouse.visible = false;
                    }
                } else {
                    if(this._state == GAME) {
                        if (!this.game_mouse.visible) {
                            this.game_mouse.visible = true;
                            this.enemy_mouse.visible = false;
                            this.pc_mouse.visible = false;
                        }
                        this.game_mouse.x = FlxG.mouse.x;
                        this.game_mouse.y = FlxG.mouse.y;
                    } else if (this._state == ENEMY) {
                        if (!this.enemy_mouse.visible) {
                            this.enemy_mouse.visible = true;
                            this.game_mouse.visible = false;
                            this.pc_mouse.visible = false;
                        }
                        this.enemy_mouse.x = FlxG.mouse.x;
                        this.enemy_mouse.y = FlxG.mouse.y;
                    } else if (this._state == PC) {
                        if (!this.pc_mouse.visible) {
                            this.pc_mouse.visible = true;
                            this.game_mouse.visible = false;
                            this.enemy_mouse.visible = false;
                        }
                        this.pc_mouse.x = FlxG.mouse.x;
                        this.pc_mouse.y = FlxG.mouse.y;
                    }
                }
            }
            if (ScreenManager.getInstance().DEBUG) {
                this.debugText.text = "on enemy: " + this.on_enemy +
                                      "\non ui: " + this.on_ui;
            }
        }

        public static function hideSystemMouse():void {
            // believe it or not, you do need to show it before you hide it for
            // it to truly hide the system mouse
            Mouse.show();
            Mouse.hide();
        }

        public function addCursorSprites():void {
            this.enemy_mouse = new GameObject(new DHPoint(0,0));
            this.enemy_mouse.loadGraphic(ImgEnemy,false,false,28,63);
            FlxG.state.add(enemy_mouse);
            this.enemy_mouse.visible = false;

            this.game_mouse = new GameObject(new DHPoint(0,0));
            this.game_mouse.loadGraphic(ImgGameCursor,false,false,24,30);
            FlxG.state.add(game_mouse);
            this.game_mouse.visible = false;

            this.pc_mouse = new GameObject(new DHPoint(0, 0));
            this.pc_mouse.loadGraphic(ImgPCCursor,false,false,15,16);
            FlxG.state.add(pc_mouse);
            this.pc_mouse.visible = true;

            if (ScreenManager.getInstance().DEBUG) {
                this.debugText.scrollFactor = new DHPoint(0, 0);
                FlxG.state.add(this.debugText);
            }
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

        public function hide():void {
            this.hidden = true;
        }

        public function show():void {
            this.hidden = false;
        }

        public function checkObjectOverlap(groups:Array=null):void {
            if (GlobalTimer.getInstance().isPaused()) {
                _on_enemy = false;
                _on_ui = false;
                return;
            }
            var _on_enemy:Boolean, _on_ui:Boolean;
            if (groups != null) {
                var curGroup:Array, cur:GameObject, rect:FlxRect;
                for (var i:int = 0; i < groups.length; i++) {
                    curGroup = groups[i];
                    for (var k:int = 0; k < curGroup.length; k++) {
                        cur = curGroup[k];
                        rect = cur._getRect();
                        if (cur is Enemy) {
                            if (this.mouse_rect.overlaps(rect) && !(cur as Enemy).isDead()) {
                                _on_enemy = true;
                            }
                        }
                        if (cur is UIElement) {
                            if (this.mouse_screen_rect.overlaps(rect) && cur.visible) {
                                _on_ui = true;
                            }
                        }
                    }
                }
            }

            this.on_ui = _on_ui;
            this.on_enemy = _on_enemy;
        }
    }
}
