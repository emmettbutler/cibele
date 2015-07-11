package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.ProceduralDialogueGenerator;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.PartyMember;
    import com.starmaid.Cibele.entities.Enemy;
    import com.starmaid.Cibele.utils.Utils;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;

        public var bitDialogueLock:Boolean = true;

        public static const LEVEL_ID:int = 2837465;
        public static const NORTH:int = 948409;
        public static const SOUTH:int = 94876;
        public static const EAST:int = 9987;
        public static const WEST:int = 3447;
        public static const BOSS_MARK:String = "boss_mark";

        public var bitDialogue:ProceduralDialogueGenerator;
        public var last_convo_playing:Boolean = false;
        public var mapTilePrefix:String;
        public var tileGridDimensions:DHPoint;
        public var estTileDimensions:DHPoint;
        public var playerStartPos:DHPoint;
        public var colliderScaleFactor:Number;
        public var levelDimensions:DHPoint;
        public var enemyDirMultiplier:Number = 1;
        private var boundedObjects:Array;

        protected var conversationPieces:Array;
        protected var conversationCounter:Number = 0;

        override public function create():void {
            this.enable_fade = true;
            this.startPos = this.playerStartPos;
            super.create();

            this.ID = LEVEL_ID;

            this.bitDialogue = new ProceduralDialogueGenerator(this);

            var shouldShowColliders:Boolean = ScreenManager.getInstance().DEBUG ||
                                              this.editorMode == PathEditorState.MODE_EDIT;
            this.bgLoader = new BackgroundLoader(
                this.mapTilePrefix,
                this.tileGridDimensions,
                this.estTileDimensions,
                this.colliderScaleFactor,
                shouldShowColliders
            );
            this.bgLoader.setPlayerReference(player);

            this.levelDimensions = new DHPoint(
                bgLoader.cols * bgLoader.estTileWidth,
                bgLoader.rows * bgLoader.estTileHeight);
            ScreenManager.getInstance().setupCamera(player.cameraPos);
            FlxG.camera.setBounds(0, 0, levelDimensions.x, levelDimensions.y);

            super.postCreate();

            this.boundedObjects = new Array();
            this.boundedObjects.push(this.player);
            for (var i:int = 0; i < this.enemies.length(); i++) {
                this.boundedObjects.push(this.enemies.get_(i));
            }

            this.bgLoader.setEnemiesReference(this.enemies.enemies);
        }

        override public function destroy():void {
            this.bgLoader.destroy();
            super.destroy();
        }

        override public function update():void {
            super.update();
            this.bgLoader.update();
            this.resolveAttacks();
            this.imposeLevelBoundaries();

            this.bitDialogue.update();
            this.bitDialogue.lock = this.bitDialogueLock;

            if (GlobalTimer.getInstance().hasPassed(BOSS_MARK) &&
                !this.boss.hasAppeared() && FlxG.state.ID == LevelMapState.LEVEL_ID)
            {
                this.boss.appear();
            }
        }

        public function imposeLevelBoundaries():void {
            var cur:GameObject;
            for (var i:int = 0; i < this.boundedObjects.length; i++) {
                cur = this.boundedObjects[i];
                if (cur.pos.x < 0) {
                    cur.dir.x = Math.max(0, cur.dir.x);
                    cur.setPos(new DHPoint(0, cur.pos.y));
                } else if (cur.pos.x + cur.width > this.levelDimensions.x) {
                    cur.dir.x = Math.min(0, cur.dir.x);
                    cur.setPos(new DHPoint(cur.pos.x - 1, cur.pos.y));
                }
                if (cur.pos.y < 0) {
                    cur.dir.y = Math.max(0, cur.dir.y);
                    cur.setPos(new DHPoint(cur.pos.x, 0));
                } else if (cur.pos.y + cur.height > this.levelDimensions.y) {
                    cur.dir.y = Math.min(0, cur.dir.y);
                    cur.setPos(new DHPoint(cur.pos.x, cur.pos.y - 1));
                }
            }
        }

        public function lastConvoStarted():Boolean {
            return last_convo_playing;
        }

        override public function updateCursor():void {
            super.updateCursor();
            if (this.game_cursor != null) {
                var cursorObjectGroups:Array = [
                    this.enemies.enemies,
                    PopUpManager.getInstance().elements,
                    MessageManager.getInstance().elements
                ];
                this.game_cursor.checkObjectOverlap(cursorObjectGroups);
            }
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            this.clickObjectGroups = [
                this.enemies.enemies,
                PopUpManager.getInstance().elements,
                MessageManager.getInstance().elements
            ];
            super.clickCallback(screenPos, worldPos);
        }

        public function resolveAttacksHelper(obj:PartyMember):void {
            if (!obj.isAttacking()) {
                return;
            }
            var current_enemy:Enemy;
            for (var i:int = 0; i < this.enemies.length(); i++) {
                current_enemy = this.enemies.get_(i);
                if (obj.enemyIsInAttackRange(current_enemy) &&
                    current_enemy == obj.targetEnemy
                ) {
                    current_enemy.takeDamage(obj);
                }
            }
        }

        public function resolveAttacks():void {
            this.resolveAttacksHelper(this.player);
            this.resolveAttacksHelper(this.pathWalker);
        }

        public function rayCast(pt1:DHPoint, pt2:DHPoint,
                                color:uint=0xffff00ff, limit:Number=-1,
                                width:Number=1, draw:Boolean=true):FlxSprite {
            var xDisp:Number = pt2.x - pt1.x;
            var yDisp:Number = pt2.y - pt1.y;
            var disp:DHPoint = pt1.sub(pt2);

            if (disp._length() <= 0) {
                return null;
            }

            if (limit != -1 && disp._length() > limit) {
                return null;
            }

            var angle:Number = Math.atan2(yDisp, xDisp);

            var posX:Number = pt1.x + (disp._length() / 2) * Math.cos(angle);
            var posY:Number = pt1.y + (disp._length() / 2) * Math.sin(angle);

            var ray:FlxSprite = new FlxSprite(posX - disp._length() / 2, posY);
            try {
                ray.makeGraphic(disp._length(), width, color);
            } catch (err:Error) {  // handle broken rays at runtime
                return null;
            }
            ray.angle = Utils.radToDeg(angle);
            ray.active = false;
            if (ScreenManager.getInstance().DEBUG && draw) {
                //FlxG.state.add(ray);
            }
            return ray;
        }

        public function pointsCanConnect(pt1:DHPoint, pt2:DHPoint):Object {
            var ray:FlxSprite;
            if (pt1 != pt2) {
                ray = this.rayCast(pt1, pt2, 0xffff00ff, 440, 1);
            }

            if (ray == null) {
                return {"canConnect": false};
            }

            var canConnect:Boolean = !this.bgLoader.collideRay(ray, pt1, pt2);
            if (!canConnect) {
                ray.color = 0xffff0000;
            }
            if (canConnect && ScreenManager.getInstance().DEBUG) {
                trace("adding ray of length: " + ray.width);
            }
            return {"canConnect": canConnect, "length": ray.width};
        }

        public function playFirstConvo():void {
            this.playConvoPiece(0);
            this.bitDialogueLock = false;
        }

        public function playNextConvoPiece():void {
            this.playConvoPiece(this.conversationCounter + 1);
        }

        private function playConvoPiece(counterVal:Number):void {
            this.conversationCounter = counterVal;
            var audioInfo:Object = this.conversationPieces[this.conversationCounter];
            if (audioInfo != null) {
                var endfn:Function = this.playNextConvoPiece;
                if (audioInfo["endfn"] != null) {
                    if(audioInfo["ends_with_popup"] == null ||
                       audioInfo["ends_with_popup"] == true)
                    {
                        endfn = function():void {
                            registerPopupCallback();
                            audioInfo["endfn"]();
                        };
                    } else {
                        endfn = function():void {
                            incrementConversation();
                            audioInfo["endfn"]();
                        };
                    }
                }
                var prevEndFn:Function = this.buildIntermediateConvoEndFn(
                    endfn, audioInfo);
                var finalEndFn:Function = prevEndFn;
                var prevDialogueLock:Boolean = this.bitDialogueLock;
                if(audioInfo["audio"] == null) {
                    finalEndFn = function():void {
                        bitDialogueLock = prevDialogueLock;
                        prevEndFn();
                    };
                    this.bitDialogueLock = true;
                    GlobalTimer.getInstance().setMark(
                        "no audio",
                        GameState.SHORT_DIALOGUE ? 1 : audioInfo["len"],
                        finalEndFn, true
                    );
                } else {
                    SoundManager.getInstance().playSound(
                        audioInfo["audio"],
                        GameState.SHORT_DIALOGUE ? 1 : audioInfo["len"],
                        finalEndFn, false, 1, GameSound.VOCAL
                    );
                }
            } else {
                this.finalConvoDone();
            }
        }

        private function buildIntermediateConvoEndFn(endfn:Function,
                                                     audioInfo:Object):Function
        {
            var that:LevelMapState = this;
            return function():void {
                if(audioInfo["boss_gate"] != null){
                    if(that.boss.isDead()) {
                        endfn();
                    } else {
                        if (ScreenManager.getInstance().DEBUG) {
                            trace("Waiting for boss kill");
                        }
                        that.addEventListener(
                            GameState.EVENT_BOSS_DIED,
                            that.buildBossKillCallback(endfn)
                        );
                    }
                } else if (audioInfo["min_team_power"] != null) {
                    that.doIfMinTeamPower(endfn, audioInfo["min_team_power"]);
                } else {
                    endfn();
                }
            };
        }

        protected function doIfMinTeamPower(fn:Function, teamPower:Number):void {
            var min_:Number = GameState.SHORT_DIALOGUE ? 0 : teamPower;
            if (this.teamPower >= min_) {
                fn();
            } else {
                if (ScreenManager.getInstance().DEBUG) {
                    trace("Waiting for minimum teamPower: " + min_);
                }
                this.addEventListener(
                    GameState.EVENT_TEAM_POWER_INCREASED,
                    this.buildTeamPowerIncreasedCallback(teamPower, fn)
                );
            }
        }

        private function buildTeamPowerIncreasedCallback(minTeamPower:Number,
                                                         endfn:Function):Function
        {
            var that:LevelMapState = this;
            return function(event:DataEvent):void {
                if (that.teamPower >= minTeamPower) {
                    if (ScreenManager.getInstance().DEBUG) {
                        trace("Minimum team power (" + minTeamPower +
                              ") met: " + that.teamPower);
                    }
                    GlobalTimer.getInstance().setMark(
                        "teampower_delay",
                        (Math.random() * 3) * GameSound.MSEC_PER_SEC,
                        function():void {
                            endfn();
                        },
                        true
                    );
                    that.removeEventListener(GameState.EVENT_TEAM_POWER_INCREASED,
                                             arguments.callee)
                } else {
                    if (ScreenManager.getInstance().DEBUG) {
                        trace("Minimum team power (" + minTeamPower +
                              ") not met: " + that.teamPower);
                    }
                }
            };
        }

        private function buildBossKillCallback(endfn:Function):Function
        {
            var that:LevelMapState = this;
            return function(event:DataEvent):void {
                if(that.boss.isDead()) {
                    if (ScreenManager.getInstance().DEBUG) {
                        trace("Boss killed");
                    }
                    endfn();
                    that.removeEventListener(GameState.EVENT_BOSS_DIED,
                                             arguments.callee)
                } else {
                    if (ScreenManager.getInstance().DEBUG) {
                        trace("Boss not killed yet");
                    }
                }
            };
        }

        public function registerPopupCallback():void {
            var that:LevelMapState = this;
            this.addEventListener(GameState.EVENT_POPUP_CLOSED,
                function(event:DataEvent):void {
                    that.playNextConvoPiece();
                    that.playTimedEmotes(that.conversationCounter);
                    if(that.conversationPieces.length == that.conversationCounter + 1) {
                        that.last_convo_playing = true;
                    }
                    FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                    arguments.callee);
                });
        }

        public function incrementConversation():void {
            this.playNextConvoPiece();
            this.playTimedEmotes(this.conversationCounter);
            if(this.conversationPieces.length == this.conversationCounter + 1) {
                this.last_convo_playing = true;
            }
        }

        public function finalConvoDone():void {}

        public function playTimedEmotes(convoNum:Number):void {}
    }
}
