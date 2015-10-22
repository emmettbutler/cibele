package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.DialoguePlayer;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class EuryaleHallway extends Hallway {
        public function EuryaleHallway(state:Number=0){
            _state = state;
            loading_screen_timer = 9;
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_EU;
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

        public static function startEuryaleConvo():void {
            if(!(FlxG.state is Euryale)) {
            } else {
                GlobalTimer.getInstance().setMark(Euryale.SHOW_FIRST_POPUP,
                    10*GameSound.MSEC_PER_SEC,
                    (FlxG.state as Euryale).showFriendEmail);
            }
        }

        public static function firstConvoPartTwo():void {
            GlobalTimer.getInstance().setMark("play first convo pt 2",
                        GameState.SHORT_DIALOGUE ? 1 : 5*GameSound.MSEC_PER_SEC,
                        EuryaleHallway.playFirstConvoPartTwo);
        }

        public static function playFirstConvoPartTwo():void {
            DialoguePlayer.getInstance().playFile(
                "voc_euryale_teleport",
                GameState.SHORT_DIALOGUE ? 1 : 30*GameSound.MSEC_PER_SEC,
                EuryaleHallway.firstConvoPartTwoPause, 1,
                GameSound.VOCAL, Euryale.CONVO_1_2_HALL
            );
        }

        public static function firstConvoPartTwoPause():void {
            GlobalTimer.getInstance().setMark("pause after first convo pt 2",
                    GameState.SHORT_DIALOGUE ? 1 : 3*GameSound.MSEC_PER_SEC,
                    EuryaleHallway.startEuryaleConvo);
        }

        override public function startConvoCallback():void {
            DialoguePlayer.getInstance().playFile(
                "voc_euryale_hey",
                GameState.SHORT_DIALOGUE ? 1 : 8*GameSound.MSEC_PER_SEC,
                EuryaleHallway.firstConvoPartTwo, 1,
                GameSound.VOCAL, Euryale.CONVO_1_HALL
            );
        }
    }
}
