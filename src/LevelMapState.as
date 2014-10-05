package {
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class LevelMapState extends PathEditorState {
        [Embed(source="../assets/voc_extra_cibnicehit.mp3")] private var CibNiceHit:Class;
        [Embed(source="../assets/voc_extra_ichiwhichway.mp3")] private var IchiWhichWay:Class;
        [Embed(source="../assets/voc_extra_ichinice2.mp3")] private var IchiNiceHit:Class;
        [Embed(source="../assets/voc_extra_cibeast.mp3")] private var CibEast:Class;
        [Embed(source="../assets/voc_extra_cibnorth.mp3")] private var CibNorth:Class;
        [Embed(source="../assets/voc_extra_cibwest.mp3")] private var CibWest:Class;
        [Embed(source="../assets/voc_extra_cibsouth.mp3")] private var CibSouth:Class;
        [Embed(source="../assets/voc_extra_ichieast.mp3")] private var IchiEast:Class;
        [Embed(source="../assets/voc_extra_ichinorth.mp3")] private var IchiNorth:Class;
        [Embed(source="../assets/voc_extra_ichiwest.mp3")] private var IchiWest:Class;
        [Embed(source="../assets/voc_extra_ichisouth.mp3")] private var IchiSouth:Class;
        [Embed(source="../assets/voc_extra_ciblost.mp3")] private var CibWhichWay:Class;
        [Embed(source="../assets/voc_extra_cibhere.mp3")] private var CibHere:Class;
        [Embed(source="../assets/voc_extra_ichirighthere.mp3")] private var IchiHere:Class;

        public var debugText:FlxText;
        public var bgLoader:BackgroundLoader;

        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;

        public var bitDialogueLock:Boolean = true;

        public static const LEVEL_ID:int = 9234876592837465;
        public static const NORTH:int = 948409;
        public static const SOUTH:int = 94876;
        public static const EAST:int = 9987;
        public static const WEST:int = 3447;

        public static const CAN_REPEAT:int = 2;
        public static const HAS_PLAYED:int = 1;
        public static const FILE:int = 0;

        public static const CIB_NICEHIT:int = 0;
        public static const CIB_EAST:int = 1;
        public static const CIB_NORTH:int = 2;
        public static const CIB_WEST:int = 3;
        public static const CIB_SOUTH:int = 4;
        public static const ICHI_NICEHIT:int = 5;
        public static const ICHI_WHICHWAY:int = 6;
        public static const ICHI_EAST:int = 7;
        public static const ICHI_NORTH:int = 8;
        public static const ICHI_WEST:int = 9;
        public static const ICHI_SOUTH:int = 10;
        public static const CIB_WHICHWAY:int = 11;
        public static const CIB_HERE:int = 12;
        public static const ICHI_HERE:int = 13;

        public var dirForDialogue:Number;
        public var dirDialgueLock:Boolean = false;
        public static var bitDialoguePieces:Dictionary = new Dictionary();

        public var testcount:Number = 0;

        override public function create():void {
            super.__create(new DHPoint(4600, 7565));

            bitDialoguePieces[CIB_NICEHIT] = [CibNiceHit, false, false];
            bitDialoguePieces[CIB_EAST] = [CibEast, false, true];
            bitDialoguePieces[CIB_SOUTH] = [CibSouth, false, true];
            bitDialoguePieces[CIB_NORTH] = [CibNorth, false, true];
            bitDialoguePieces[CIB_WEST] = [CibWest, false, true];
            bitDialoguePieces[ICHI_NICEHIT] = [IchiNiceHit, false, false];
            bitDialoguePieces[ICHI_WHICHWAY] = [IchiWhichWay, false, true];
            bitDialoguePieces[ICHI_NORTH] = [IchiNorth, false, true];
            bitDialoguePieces[ICHI_SOUTH] = [IchiSouth, false, true];
            bitDialoguePieces[ICHI_WEST] = [IchiWest, false, true];
            bitDialoguePieces[ICHI_EAST] = [IchiEast, false, true];
            bitDialoguePieces[CIB_WHICHWAY] = [CibWhichWay, false, false];
            bitDialoguePieces[CIB_HERE] = [CibHere, false, false];
            bitDialoguePieces[ICHI_HERE] = [IchiHere, false, false];

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
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.bgLoader.update();
            this.resolveAttacks();

            if (!this.bitDialogueLock) {
                if (SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                } else {
                    controlBitDialogue();
                }
            }
        }

        public function controlBitDialogue():void {
            FlxG.log("bit");
            for(var key:Object in bitDialoguePieces){
                if(bitDialoguePieces[key][CAN_REPEAT] == true) { //if it can be played infinitely
                    playBitDialogue();
                } else if(bitDialoguePieces[key][HAS_PLAYED] == false) { //if it can be played once
                    playBitDialogue();
                }
            }
        }

        public function playBitDialogue():void {
            if(player.isAttacking()) {
                if(pathWalker.inViewOfPlayer()){
                    GlobalTimer.getInstance().setMark("delayed_ichinicehit",
                        10*GameSound.MSEC_PER_SEC, this.playIchiNiceHit);
                }
            } else if(!pathWalker.inViewOfPlayer()) {
                var rand:Number = Math.random() * 2;
                if(!this.dirDialgueLock) {
                    this.dirDialgueLock = true;
                    if(rand > 1) {
                        GlobalTimer.getInstance().setMark("delayed_cibwhichway",
                        1*GameSound.MSEC_PER_SEC, this.playCibWhichWay);
                    } else {
                        GlobalTimer.getInstance().setMark("delayed_ichiwhichway",
                        1*GameSound.MSEC_PER_SEC, this.playIchiWhichWay);
                    }
                }

            } else if(pathWalker.isAttacking()) {
                if(pathWalker.inViewOfPlayer()){
                    GlobalTimer.getInstance().setMark("delayed_cibnicehit",
                        10*GameSound.MSEC_PER_SEC, this.playCibNiceHit);
                }
            }
        }

        public function playerDirectionalDialogue():void {
            this.objDirectionalDialogue(pathWalker, player);
            if(pathWalker.inViewOfPlayer()){
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[CIB_HERE][FILE], 7*GameSound.MSEC_PER_SEC, null, false, 1, GameSound.VOCAL
                );
            } else {
                if(this.dirForDialogue == EAST) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[CIB_EAST][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(this.dirForDialogue == WEST) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[CIB_WEST][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(this.dirForDialogue == SOUTH) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[CIB_SOUTH][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(this.dirForDialogue == NORTH) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[CIB_NORTH][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                }
            }
            this.dirDialgueLock = false;
        }

        public function npcDirectionalDialogue():void {
            this.objDirectionalDialogue(player, pathWalker);
            if(pathWalker.inViewOfPlayer()) {
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[ICHI_HERE][FILE], 7*GameSound.MSEC_PER_SEC, null, false, 1, GameSound.VOCAL
                );
            } else {
                if(this.dirForDialogue == EAST) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[ICHI_EAST][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(this.dirForDialogue == WEST) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[ICHI_WEST][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(this.dirForDialogue == SOUTH) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[ICHI_SOUTH][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(this.dirForDialogue == NORTH) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[ICHI_NORTH][FILE], 7*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                }
            }
            this.dirDialgueLock = false;
        }

        public function objDirectionalDialogue(from_obj:PartyMember, to_obj:PartyMember):void {
            var dir:DHPoint = from_obj.directionToObj(to_obj.pos);
            if(Math.abs(dir.x) > Math.abs(dir.y)) {
                if(dir.x > 0) {
                    this.dirForDialogue = EAST;
                } else {
                    this.dirForDialogue = WEST;
                }
            } else {
                if(dir.y > 0) {
                    this.dirForDialogue = SOUTH;
                } else {
                    this.dirForDialogue = NORTH;
                }
            }
        }

        public function playIchiNiceHit():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[ICHI_NICEHIT][FILE], 4*GameSound.MSEC_PER_SEC, null,
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[ICHI_NICEHIT][HAS_PLAYED] = true;
        }

        public function playCibWhichWay():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[CIB_WHICHWAY][FILE], 2*GameSound.MSEC_PER_SEC, this.npcDirectionalDialogue,
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[CIB_WHICHWAY][HAS_PLAYED] = true;
        }

        public function playIchiWhichWay():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[ICHI_WHICHWAY][FILE], 2*GameSound.MSEC_PER_SEC, this.playerDirectionalDialogue,
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[ICHI_WHICHWAY][HAS_PLAYED] = true;
        }

        public function playCibNiceHit():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[CIB_NICEHIT][FILE], 4*GameSound.MSEC_PER_SEC, null,
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[CIB_NICEHIT][HAS_PLAYED] = true;
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
