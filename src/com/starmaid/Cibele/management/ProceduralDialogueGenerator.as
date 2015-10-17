package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.entities.PathFollower;
    import com.starmaid.Cibele.entities.PartyMember;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.states.LevelMapState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import flash.utils.Dictionary;

    import org.flixel.*;

    public class ProceduralDialogueGenerator {
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

        public var cib_nice_hit_lock:Boolean = false;
        public var ichi_nice_hit_lock:Boolean = false;
        private var started:Boolean = false;
        private var _lock:Boolean = false;

        public function ProceduralDialogueGenerator(containerState:LevelMapState) {
            this.containerState = containerState;

            bitDialoguePieces[CIB_NICEHIT] = ["voc_extra_cibnicehit", false, false];
            bitDialoguePieces[CIB_EAST] = ["voc_extra_cibeast", false, true];
            bitDialoguePieces[CIB_SOUTH] = ["voc_extra_cibsouth", false, true];
            bitDialoguePieces[CIB_NORTH] = ["voc_extra_cibnorth", false, true];
            bitDialoguePieces[CIB_WEST] = ["voc_extra_cibwest", false, true];
            bitDialoguePieces[CIB_WHICHWAY] = ["voc_extra_ciblost", false, false];
            bitDialoguePieces[CIB_HERE] = ["voc_extra_cibhere", false, false];
            bitDialoguePieces[ICHI_NICEHIT] = ["voc_extra_ichinice2", false, false];
            bitDialoguePieces[ICHI_WHICHWAY] = ["voc_extra_ichiwhichway", false, true];
            bitDialoguePieces[ICHI_NORTH] = ["voc_extra_ichinorth", false, true];
            bitDialoguePieces[ICHI_SOUTH] = ["voc_extra_ichisouth", false, true];
            bitDialoguePieces[ICHI_WEST] = ["voc_extra_ichiwest", false, true];
            bitDialoguePieces[ICHI_EAST] = ["voc_extra_ichieast", false, true];
            bitDialoguePieces[ICHI_HERE] = ["voc_extra_ichirighthere", false, false];
        }

        public function update():void {
            if (!started) {
                started = true;
                this.loopBitDialogueCallback();
            }
        }

        public function set lock(l:Boolean):void {
            this._lock = l;
        }

        public function get player():Player {
            return this.containerState.getPlayer();
        }

        public function get pathWalker():PathFollower {
            return this.containerState.pathWalker;
        }

        private function loopBitDialogueCallback():void {
            if (!(FlxG.state is LevelMapState)) {
                return;
            }
            if (!this._lock && !PopUpManager.getInstance().showingPopup() &&
                !(FlxG.state as LevelMapState).lastConvoStarted() &&
                !SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL))
            {
                this.playBitDialogue();
            }
            GlobalTimer.getInstance().setMark(
                "bit_dialogue",
                (20 + (Math.random() * 15)) * GameSound.MSEC_PER_SEC,
                function():void {
                    if (!(FlxG.state is LevelMapState)) {
                        return;
                    }
                    loopBitDialogueCallback();
                },
                true
            );
        }

        private function playBitDialogue():void {
            if (this._lock || !(FlxG.state is LevelMapState)) {
                return;
            }
            if(player.isAttacking() && !this.ichi_nice_hit_lock) {
                if(pathWalker.inViewOfPlayer()){
                    GlobalTimer.getInstance().setMark("delayed_ichinicehit",
                        1*GameSound.MSEC_PER_SEC, this.buildDialogueCallback(this.playIchiNiceHit),
                        true);
                }
            }

            if(pathWalker.isAttacking() && !this.cib_nice_hit_lock) {
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
                DialoguePlayer.getInstance().playFile(
                    bitDialoguePieces[prefix+"here"][IDX_FILE],
                    7*GameSound.MSEC_PER_SEC, null, 1, GameSound.BIT_DIALOGUE
                );
            } else {
                if(dirForDialogue == LevelMapState.EAST) {
                    DialoguePlayer.getInstance().playFile(
                        bitDialoguePieces[prefix+"east"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        1, GameSound.BIT_DIALOGUE
                    );
                } else if(dirForDialogue == LevelMapState.WEST) {
                    DialoguePlayer.getInstance().playFile(
                        bitDialoguePieces[prefix+"west"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        1, GameSound.BIT_DIALOGUE
                    );
                } else if(dirForDialogue == LevelMapState.SOUTH) {
                    DialoguePlayer.getInstance().playFile(
                        bitDialoguePieces[prefix+"south"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        1, GameSound.BIT_DIALOGUE
                    );
                } else if(dirForDialogue == LevelMapState.NORTH) {
                    DialoguePlayer.getInstance().playFile(
                        bitDialoguePieces[prefix+"north"][IDX_FILE], 2*GameSound.MSEC_PER_SEC, null,
                        1, GameSound.BIT_DIALOGUE
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
                    GameSound.BIT_DIALOGUE))
                {
                    func();
                }
            }
        }

        public function playIchiNiceHit():void {
            DialoguePlayer.getInstance().playFile(
                bitDialoguePieces[ICHI_NICEHIT][IDX_FILE], 4*GameSound.MSEC_PER_SEC, null,
                1, GameSound.BIT_DIALOGUE
            );
            bitDialoguePieces[ICHI_NICEHIT][IDX_HAS_PLAYED] = true;
            PopUpManager.getInstance().emote(new FlxRect(0,0), pathWalker, true, Emote.HAPPY);
            this.ichi_nice_hit_lock = true;
            GlobalTimer.getInstance().setMark("ichi nice hit lock",
                    35*GameSound.MSEC_PER_SEC, this.unlockIchiNiceHit, false);
        }

        public function unlockIchiNiceHit():void {
            this.ichi_nice_hit_lock = false;
        }

        public function playCibWhichWay():void {
            DialoguePlayer.getInstance().playFile(
                bitDialoguePieces[CIB_WHICHWAY][IDX_FILE], 2*GameSound.MSEC_PER_SEC,
                function():void {
                    directionalDialogue(player, pathWalker, "ichi_");
                },
                1, GameSound.BIT_DIALOGUE
            );
            bitDialoguePieces[CIB_WHICHWAY][IDX_HAS_PLAYED] = true;
        }

        public function playIchiWhichWay():void {
            DialoguePlayer.getInstance().playFile(
                bitDialoguePieces[ICHI_WHICHWAY][IDX_FILE], 2*GameSound.MSEC_PER_SEC,
                function():void {
                    directionalDialogue(pathWalker, player, "cib_");
                },
                1, GameSound.BIT_DIALOGUE
            );
            bitDialoguePieces[ICHI_WHICHWAY][IDX_HAS_PLAYED] = true;
        }

        public function playCibNiceHit():void {
            DialoguePlayer.getInstance().playFile(
                bitDialoguePieces[CIB_NICEHIT][IDX_FILE], 4*GameSound.MSEC_PER_SEC, null,
                1, GameSound.BIT_DIALOGUE
            );
            bitDialoguePieces[CIB_NICEHIT][IDX_HAS_PLAYED] = true;
            PopUpManager.getInstance().emote(new FlxRect(0,0), pathWalker, true, Emote.HAPPY);
            this.cib_nice_hit_lock = true;
            GlobalTimer.getInstance().setMark("cib nice hit lock",
                    35*GameSound.MSEC_PER_SEC, this.unlockCibNiceHit, false);
        }

        public function unlockCibNiceHit():void {
            this.cib_nice_hit_lock = false;
        }
    }
}
