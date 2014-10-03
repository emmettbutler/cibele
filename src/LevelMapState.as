package {
    import org.flixel.*;

    public class LevelMapState extends PathEditorState {
        [Embed(source="../assets/voc_extra_cibnicehit.mp3")] private var CibNiceHit:Class;
        [Embed(source="../assets/voc_extra_ichiwhichway.mp3")] private var IchiWhichWay:Class;
        [Embed(source="../assets/voc_extra_ichinice2.mp3")] private var IchiNiceHit:Class;
        [Embed(source="../assets/voc_extra_cibeast.mp3")] private var CibEast:Class;
        [Embed(source="../assets/voc_extra_cibnorth.mp3")] private var CibNorth:Class;
        [Embed(source="../assets/voc_extra_cibwest.mp3")] private var CibWest:Class;
        [Embed(source="../assets/voc_extra_cibsouth.mp3")] private var CibSouth:Class;
        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;

        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;

        public static const LEVEL_ID:int = 9234876592837465;
        public static const NORTH:int = 948409;
        public static const SOUTH:int = 94876;
        public static const EAST:int = 9987;
        public static const WEST:int = 3447;

        public var bitDialoguePieces:Array;
        public var dirForDialogue:Number;

        override public function create():void {
            super.__create(new DHPoint(4600, 7565));

            FlxG.bgColor = 0xffffffff;
            this.bornTime = new Date().valueOf();
            this.ID = LEVEL_ID;

            this.bgLoader = new BackgroundLoader("full-map-iggo-turso", 10, 5,
                "paths", this.editorMode == PathEditorState.MODE_EDIT);
            this.bgLoader.setPlayerReference(player);

            ScreenManager.getInstance().setupCamera(player);
            FlxG.camera.setBounds(0, 0, bgLoader.cols * bgLoader.estTileWidth,
                                  bgLoader.rows * bgLoader.estTileHeight);
            super.postCreate();

            //name of dialogue and
            //whether or not it can repeat in bit dialogue sequence and
            //if it has played at least once
            bitDialoguePieces = [
                [CibNiceHit, false, false],
                [IchiWhichWay, true, false],
                [IchiNiceHit, false, false],
                [CibNorth, true, false],
                [CibSouth, true, false],
                [CibEast, true, false],
                [CibWest, true, false]
            ];
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.bgLoader.update();
            this.resolveAttacks();

            if (SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {

            } else {
                controlBitDialogue();
            }
        }

        public function controlBitDialogue():void {
            FlxG.log("should play bit stuff");
            for(var i:Number = 0; i < bitDialoguePieces.length; i++){
                if(bitDialoguePieces[i][1] == true) { //if it can be played infinitely
                    playBitDialogue();
                } else if(bitDialoguePieces[i][2] == false) { //if it can be played once
                    playBitDialogue();
                }
            }
        }

        public function playBitDialogue():void {
            if(player.isAttacking()) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[2][0], 4*GameSound.MSEC_PER_SEC, null,
                    false, 1, GameSound.VOCAL
                );
                bitDialoguePieces[2][2] = true;
            } else if(pathWalker.shouldWarpToPlayer()) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[1][0], 4*GameSound.MSEC_PER_SEC, this.playerDirectionalDialogue,
                    false, 1, GameSound.VOCAL
                );
                bitDialoguePieces[1][2] = true;
            } else if(pathWalker.isAttacking()) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[0][0], 4*GameSound.MSEC_PER_SEC, null,
                    false, 1, GameSound.VOCAL
                );
                bitDialoguePieces[0][2] = true;
            }
        }

        public function playerDirectionalDialogue():void {
            this.objDirectionalDialogue(pathWalker, player);
            if(this.dirForDialogue == EAST) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[5][0], 4*GameSound.MSEC_PER_SEC, null,
                    false, 1, GameSound.VOCAL
                );
            } else if(this.dirForDialogue == WEST) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[6][0], 4*GameSound.MSEC_PER_SEC, null,
                    false, 1, GameSound.VOCAL
                );
            } else if(this.dirForDialogue == NORTH) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[3][0], 4*GameSound.MSEC_PER_SEC, null,
                    false, 1, GameSound.VOCAL
                );
            } else if(this.dirForDialogue == SOUTH) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[4][0], 4*GameSound.MSEC_PER_SEC, null,
                    false, 1, GameSound.VOCAL
                );
            }
        }

        public function objDirectionalDialogue(from_obj:PartyMember, to_obj:PartyMember):void {
            var dir:DHPoint = from_obj.directionToObj(to_obj);
            if(Math.abs(dir.x) > Math.abs(dir.y)) {
                if(dir.x > 0) {
                    this.dirForDialogue = EAST;
                } else {
                    this.dirForDialogue = WEST;
                }
            } else {
                if(dir.y > 0) {
                    this.dirForDialogue = NORTH;
                } else {
                    this.dirForDialogue = SOUTH;
                }
            }
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
                if (current_enemy.pos.sub(obj.pos)._length() < obj.attackRange) {
                    current_enemy.takeDamage(obj);
                }
            }
        }

        public function resolveAttacks():void {
            this.resolveAttacksHelper(this.player);
            this.resolveAttacksHelper(this.pathWalker);
        }
    }
}
