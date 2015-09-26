package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class PlayerState extends GameState {
        public var player:Player;
        protected var startPos:DHPoint;
        protected var clickObjectGroups:Array;

        public function PlayerState() {
        }

        public function getPlayer():Player {
            return this.player;
        }

        override public function create():void {
            super.create();
            this.player = new Player(this.startPos.x, this.startPos.y);
            this.add(this.player.mapHitbox)
        }

        override public function destroy():void {
            this.player.destroy();
            this.player = null;
            super.destroy();
        }

        override public function postCreate():void {
            this.player.initFootsteps();
            this.player.addVisibleObjects();
            if (this is PathEditorState && (this as PathEditorState).boss != null) {
                (this as PathEditorState).boss.addHealthBarVisibleObjects();
                (this as PathEditorState).teamPowerBar.addVisibleObjects();
                (this as PathEditorState).buildTeamPowerAnimationObjects();
            }
            super.postCreate();
            this.game_cursor.setGameMouse();
            FlxG.mouse.x = this.player.pos.x;
            FlxG.mouse.y = this.player.pos.y;

            this.clickObjectGroups = [
                PopUpManager.getInstance().elements,
                MessageManager.getInstance().elements
            ];
            if (this is PathEditorState) {
                this.clickObjectGroups.push(
                    (this as PathEditorState).teamPowerBar.elements);
            }
        }

        public function setScaleFactor(scaleFactor:Number=1):void {
            this.player.setScaleFactor(scaleFactor);
        }

        override public function update():void {
            super.update();
            if(PopUpManager.getInstance()._player != this.player) {
                PopUpManager.getInstance()._player = this.player;
            }
        }

        override public function fadeOut(fn:Function, postFadeWait:Number=1,
                                         fadeSoundName:String=null):void
        {
            super.fadeOut(fn, postFadeWait, fadeSoundName);
            this.player.dir = new DHPoint(0, 0);
            this.player.active = false;
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (!GlobalTimer.getInstance().isPaused()) {
                var objects:Array = new Array();
                for (var i:int = 0; i < this.clickObjectGroups.length; i++) {
                    for (var j:int = 0; j < this.clickObjectGroups[i].length; j++) {
                        objects.push(this.clickObjectGroups[i][j]);
                    }
                }
                this.player.clickCallback(screenPos, worldPos, objects);
            }
            super.clickCallback(screenPos, worldPos);
        }
    }
}
