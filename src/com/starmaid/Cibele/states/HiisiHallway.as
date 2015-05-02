package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class HiisiHallway extends Hallway {
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_morning.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_westcoast.mp3")] private var Convo2:Class;

        public function HiisiHallway(state:Number=0){
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
            FlxG.switchState(new HiisiTeleportRoom());
        }

        public function startHiisiConvo():void {
            if(!(FlxG.state is Hiisi)) {
            } else {
                GlobalTimer.getInstance().setMark(Hiisi.SHOW_FIRST_POPUP, 10*GameSound.MSEC_PER_SEC, (FlxG.state as Hiisi).showFlightEmail);
            }
        }

        public function firstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo2, 27*GameSound.MSEC_PER_SEC, startHiisiConvo, false, 1, GameSound.VOCAL,
                    Hiisi.CONVO_2_HALL
                );
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call) {
                accept_call = true;
                SoundManager.getInstance().playSound(
                    Convo1, 29*GameSound.MSEC_PER_SEC, firstConvoPartTwo, false, 1, GameSound.VOCAL,
                    Hiisi.CONVO_1_HALL
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}