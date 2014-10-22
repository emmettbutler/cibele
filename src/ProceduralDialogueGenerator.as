package {
    import flash.utils.Dictionary;
    import org.flixel.*;

    public class ProceduralDialogueGenerator {
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

        public static const CIB_NICEHIT:String = "cib_nicehit";
        public static const CIB_EAST:String = "cib_east";
        public static const CIB_NORTH:String = "cib_north";
        public static const CIB_WEST:String = "cib_west";
        public static const CIB_SOUTH:String = "cib_south";
        public static const ICHI_NICEHIT:String = "ichi_nicehit";
        public static const ICHI_WHICHWAY:String = "ichi_whichway";
        public static const ICHI_EAST:String = "ichi_east";
        public static const ICHI_NORTH:String = "ichi_north";
        public static const ICHI_WEST:String = "ichi_west";
        public static const ICHI_SOUTH:String = "ichi_south";
        public static const CIB_WHICHWAY:String = "cib_whichway";
        public static const CIB_HERE:String = "cib_here";
        public static const ICHI_HERE:String = "ichi_here";

        public static const IDX_FILE:int = 0;
        public static const IDX_HAS_PLAYED:int = 1;

        public static var bitDialoguePieces:Dictionary = new Dictionary();
        public var containerState:LevelMapState;

        public function ProceduralDialogueGenerator(containerState:LevelMapState) {
            this.containerState = containerState;

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
        }

        public function update():void {
            var rand:Number = Math.random();
            //if (rand > .99) {
                playBitDialogue();
            //}
        }

        public function get player():Player {
            return this.containerState.getPlayer();
        }

        public function get pathWalker():PathFollower {
            return this.containerState.pathWalker;
        }

        public function playBitDialogue():void {
            if(player.isAttacking()) {
                if(pathWalker.inViewOfPlayer()){
                    GlobalTimer.getInstance().setMark("delayed_ichinicehit",
                        1*GameSound.MSEC_PER_SEC, this.buildDialogueCallback(this.playIchiNiceHit),
                        true);
                }
            }

            if(pathWalker.isAttacking()) {
                if(pathWalker.inViewOfPlayer()){
                    GlobalTimer.getInstance().setMark("delayed_cibnicehit",
                        1*GameSound.MSEC_PER_SEC, this.buildDialogueCallback(this.playCibNiceHit),
                        true);
                }
            }

            if(!pathWalker.inViewOfPlayer()) {
                var rand:Number = Math.random() * 4;
                if(rand > 1) {
                  this.buildDialogueCallback(this.playCibWhichWay)();
                } else {
                    this.buildDialogueCallback(this.playIchiWhichWay)();
                }
            }
        }

        public function directionalDialogue(from:PartyMember, to:PartyMember, prefix:String="cib_"):void {
            var dirForDialogue:Number = this.getDialogueDirection(from, to);
            if(pathWalker.inViewOfPlayer()){
                SoundManager.getInstance().playSound(
                    bitDialoguePieces[prefix+"here"][IDX_FILE],
                    7*GameSound.MSEC_PER_SEC, null, false, 1, GameSound.VOCAL
                );
            } else {
                if(dirForDialogue == LevelMapState.EAST) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[prefix+"east"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(dirForDialogue == LevelMapState.WEST) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[prefix+"west"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(dirForDialogue == LevelMapState.SOUTH) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[prefix+"south"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                } else if(dirForDialogue == LevelMapState.NORTH) {
                    SoundManager.getInstance().playSound(
                        bitDialoguePieces[prefix+"north"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        false, 1, GameSound.VOCAL
                    );
                }
            }
        }

        public function getDialogueDirection(from_obj:PartyMember, to_obj:PartyMember):Number {
            var dir:DHPoint = from_obj.directionToObj(to_obj.pos);
            if(Math.abs(dir.x) > Math.abs(dir.y)) {
                if(dir.x > 0) {
                    return LevelMapState.EAST;
                }
                return LevelMapState.WEST;
            } else {
                if(dir.y > 0) {
                    return LevelMapState.SOUTH;
                }
                return LevelMapState.NORTH;
            }
        }

        public function buildDialogueCallback(func:Function):Function {
            return function():void {
                if(!SoundManager.getInstance().soundOfTypeIsPlaying(
                    GameSound.VOCAL))
                {
                    func();
                }
            }
        }

        public function playIchiNiceHit():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[ICHI_NICEHIT][IDX_FILE], 4*GameSound.MSEC_PER_SEC, null,
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[ICHI_NICEHIT][IDX_HAS_PLAYED] = true;
        }

        public function playCibWhichWay():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[CIB_WHICHWAY][IDX_FILE], 2*GameSound.MSEC_PER_SEC,
                function():void {
                    directionalDialogue(player, pathWalker, "ichi_");
                },
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[CIB_WHICHWAY][IDX_HAS_PLAYED] = true;
        }

        public function playIchiWhichWay():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[ICHI_WHICHWAY][IDX_FILE], 2*GameSound.MSEC_PER_SEC,
                function():void {
                    directionalDialogue(pathWalker, player, "cib_");
                },
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[ICHI_WHICHWAY][IDX_HAS_PLAYED] = true;
        }

        public function playCibNiceHit():void {
            SoundManager.getInstance().playSound(
                bitDialoguePieces[CIB_NICEHIT][IDX_FILE], 4*GameSound.MSEC_PER_SEC, null,
                false, 1, GameSound.VOCAL
            );
            bitDialoguePieces[CIB_NICEHIT][IDX_HAS_PLAYED] = true;
        }
    }
}
