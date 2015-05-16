package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class HiisiHallway extends Hallway {
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_morning.mp3")] private static var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_westcoast.mp3")] private static var Convo2:Class;

        public function HiisiHallway(state:Number=0){
            _state = state;
            loading_screen_timer = 9;
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
                GlobalTimer.getInstance().setMark(Hiisi.SHOW_FIRST_POPUP,
                    5*GameSound.MSEC_PER_SEC,
                    (FlxG.state as Hiisi).showFlightEmail);
            }
        }

        public static function firstConvoPartTwo():void {
            GlobalTimer.getInstance().setMark("play 1st convo pt 2",
                5*GameSound.MSEC_PER_SEC, HiisiHallway.playFirstConvoPartTwo);
        }

        public static function playFirstConvoPartTwo():void {
            SoundManager.getInstance().playSound(HiisiHallway.Convo2,
                25*GameSound.MSEC_PER_SEC,
                HiisiHallway.startHiisiConvo, false, 1, GameSound.VOCAL,
                Hiisi.CONVO_2_HALL
            );
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call) {
                accept_call = true;
                SoundManager.getInstance().playSound(
                    HiisiHallway.Convo1, 20*GameSound.MSEC_PER_SEC,
                    HiisiHallway.firstConvoPartTwo, false, 1,
                    GameSound.VOCAL,
                    Hiisi.CONVO_1_HALL
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
