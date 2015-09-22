package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class HiisiHallway extends Hallway {
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_morning.mp3")] private static var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_westcoast.mp3")] private static var Convo2:Class;

        public function HiisiHallway(state:Number=0){
            _state = state;
            loading_screen_timer = 9;
            this.play_loading_dialogue = false;
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_HI;
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

        public static function startHiisiConvo():void {
            if(!(FlxG.state is Hiisi)) {
            } else {
                (FlxG.state as Hiisi).delayFlightEmail();
            }
        }

        public static function firstConvoPartTwo():void {
            GlobalTimer.getInstance().setMark("play 1st convo pt 2",
                GameState.SHORT_DIALOGUE ? 1 : 5*GameSound.MSEC_PER_SEC,
                HiisiHallway.playFirstConvoPartTwo);
        }

        public static function playFirstConvoPartTwo():void {
            if (FlxG.state is HiisiHallway || FlxG.state is HiisiTeleportRoom) {
                SoundManager.getInstance().playSound(HiisiHallway.Convo2,
                    GameState.SHORT_DIALOGUE ? 1 : 25*GameSound.MSEC_PER_SEC,
                    HiisiHallway.startHiisiConvo, false, 1, GameSound.VOCAL,
                    Hiisi.CONVO_2_HALL
                );
            }
        }

        override public function startConvoCallback():void {
            SoundManager.getInstance().playSound(
                HiisiHallway.Convo1,
                GameState.SHORT_DIALOGUE ? 1 : 20*GameSound.MSEC_PER_SEC,
                HiisiHallway.firstConvoPartTwo, false, 1,
                GameSound.VOCAL,
                Hiisi.CONVO_1_HALL
            );
        }

    }
}
