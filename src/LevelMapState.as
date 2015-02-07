package {
    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;

        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;

        public var bitDialogueLock:Boolean = true;

        public static const LEVEL_ID:int = 2837465;
        public static const NORTH:int = 948409;
        public static const SOUTH:int = 94876;
        public static const EAST:int = 9987;
        public static const WEST:int = 3447;

        public var bitDialogue:ProceduralDialogueGenerator;
        public var last_convo_playing:Boolean = false;
        public var mapTilePrefix:String;
        public var tileGridDimensions:DHPoint;
        public var estTileDimensions:DHPoint;
        public var playerStartPos:DHPoint;
        public var colliderScaleFactor:Number;

        override public function create():void {
            super.__create(this.playerStartPos);

            this.bornTime = new Date().valueOf();
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

            ScreenManager.getInstance().setupCamera(player.cameraPos);
            FlxG.camera.setBounds(0, 0, bgLoader.cols * bgLoader.estTileWidth,
                                  bgLoader.rows * bgLoader.estTileHeight);

            super.postCreate();
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.bgLoader.update();
            this.resolveAttacks();

            if (!this.bitDialogueLock) {
                this.bitDialogue.update();
            }
        }

        public function lastConvoStarted():Boolean {
            return last_convo_playing;
        }

        override public function updateCursor():void {
            super.updateCursor();
            if (this.game_cursor != null) {
                this.game_cursor.checkObjectOverlap(this.enemies.enemies);
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
                if (obj.enemyIsInAttackRange(current_enemy) && current_enemy == obj.targetEnemy) {
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
                FlxG.state.add(ray);
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

    }
}
