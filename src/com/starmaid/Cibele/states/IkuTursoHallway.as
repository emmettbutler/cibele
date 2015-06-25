package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.states.IkuTurso;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class IkuTursoHallway extends Hallway {
        [Embed(source="/../assets/audio/voiceover/voc_firstconvo.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/music/bgm_fern_intro.mp3")] private var FernBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_fern_loop.mp3")] private var FernBGMLoop:Class;

        public function IkuTursoHallway(state:Number=0){
            _state = state;
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_IT;
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();
        }

        override public function nextState():void {
            FlxG.switchState(new IkuTursoTeleportRoom());
        }

        public function firstConvo():void {
            if(!(FlxG.state is IkuTurso)) {
            } else {
                GlobalTimer.getInstance().setMark("First Convo", GameState.SHORT_DIALOGUE ? 1 : 7*GameSound.MSEC_PER_SEC, (FlxG.state as IkuTurso).bulldogHellPopup);
            }
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call &&
                !this.loadingScreenVisible())
            {
                accept_call = true;
                SoundManager.getInstance().playSound(
                    Convo1, GameState.SHORT_DIALOGUE ? 1 : 24*GameSound.MSEC_PER_SEC, firstConvo, false, 1, GameSound.VOCAL,
                    "convo_1_hall"
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
