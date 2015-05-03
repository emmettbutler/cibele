package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class EuryaleHallway extends Hallway {
        [Embed(source="/../assets/audio/voiceover/voc_euryale_hey.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_teleport.mp3")] private var Convo1_2:Class;

        public function EuryaleHallway(state:Number=0){
            _state = state;
            loading_screen_timer = 9;
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();
        }

        override public function nextState():void {
            FlxG.switchState(new EuryaleTeleportRoom());
        }

        public function startEuryaleConvo():void {
            if(!(FlxG.state is Euryale)) {
            } else {
                this.playEuryaleConvoFromHall();
            }
        }

        public function playEuryaleConvoFromHall():void {
            if(!SoundManager.getInstance().
                    soundOfTypeIsPlaying(GameSound.VOCAL))
                {
                    GlobalTimer.getInstance().setMark(Euryale.SHOW_FIRST_POPUP,
                        10*GameSound.MSEC_PER_SEC,
                        (FlxG.state as Euryale).showFriendEmail);
                }
        }

        public function firstConvoPartTwo():void {
            GlobalTimer.getInstance().setMark("play first convo pt 2",
                        5*GameSound.MSEC_PER_SEC,
                        this.playFirstConvoPartTwo);
        }

        public function playFirstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo1_2, 30*GameSound.MSEC_PER_SEC, firstConvoPartTwoPause, false, 1, GameSound.VOCAL,
                    Euryale.CONVO_1_2_HALL
                );
        }

        public function firstConvoPartTwoPause():void {
            if(!(FlxG.state is Euryale)) {
                GlobalTimer.getInstance().setMark("pause after first convo pt 2",
                        3*GameSound.MSEC_PER_SEC,
                        this.startEuryaleConvo);
            } else {
               this.playEuryaleConvoFromHall();
            }
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call) {
                accept_call = true;
                SoundManager.getInstance().playSound(
                    Convo1, 8*GameSound.MSEC_PER_SEC, firstConvoPartTwo, false, 1, GameSound.VOCAL,
                    Euryale.CONVO_1_HALL
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
