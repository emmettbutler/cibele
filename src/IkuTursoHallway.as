package{
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class IkuTursoHallway extends Hallway {
        [Embed(source="../assets/audio/voiceover/voc_firstconvo.mp3")] private var Convo1:Class;
        [Embed(source="../assets/audio/voiceover/voc_ikuturso_start.mp3")] private var Convo2:Class;
        [Embed(source="../assets/audio/voiceover/voc_extra_wannaduo.mp3")] private var SndWannaDuo:Class;
        [Embed(source="../assets/audio/voiceover/voc_extra_yeahsorry.mp3")] private var SndYeahSorry:Class;
        [Embed(source="../assets/audio/voiceover/voc_extra_ichiareyouthere.mp3")] private var SndRUThere:Class;
        [Embed(source="../assets/audio/voiceover/voc_extra_cibichi.mp3")] private var CibIchi:Class;
        [Embed(source="../assets/audio/music/bgm_fern_intro.mp3")] private var FernBGMIntro:Class;
        [Embed(source="../assets/audio/music/bgm_fern_loop.mp3")] private var FernBGMLoop:Class;

        public function IkuTursoHallway(state:Number=0){
            _state = state;
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();
        }

        public function firstConvo():void {
            if(!(FlxG.state is IkuTurso)) {
            } else {
                GlobalTimer.getInstance().setMark("First Convo", 7*GameSound.MSEC_PER_SEC, (FlxG.state as IkuTurso).bulldogHellPopup);
            }
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call) {
                accept_call = true;
                SoundManager.getInstance().playSound(
                    Convo1, 29*GameSound.MSEC_PER_SEC, firstConvo, false, 1, GameSound.VOCAL,
                    "convo_1_hall"
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
