package{
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class EuryaleHallway extends Hallway {
        [Embed(source="../assets/audio/voiceover/voc_euryale_hey.mp3")] private var Convo1:Class;
        [Embed(source="../assets/audio/voiceover/voc_euryale_teleport.mp3")] private var Convo1_2:Class;

        public function EuryaleHallway(state:Number=0){
            _state = state;
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();
        }

        public function startEuryaleConvo():void {
            if(!(FlxG.state is Euryale)) {
            } else {
                (FlxG.state as Euryale).showFriendEmail();
            }
        }

        public function firstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo1_2, 27*GameSound.MSEC_PER_SEC, startEuryaleConvo, false, 1, GameSound.VOCAL,
                    "eu_convo_1_2_hall"
                );
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call) {
                accept_call = true;
                SoundManager.getInstance().playSound(
                    Convo1, 12*GameSound.MSEC_PER_SEC, firstConvoPartTwo, false, 1, GameSound.VOCAL,
                    "eu_convo_1_hall"
                );
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
