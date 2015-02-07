package{
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxCollision;

    public class EuryaleHallway extends Hallway {

        public function EuryaleHallway(state:Number=0){
            _state = state;
        }

        override public function create():void {
            super.create();
        }

        override public function update():void {
            super.update();
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            if (this._state == STATE_PRE && !this.accept_call) {
                accept_call = true;
                /*SoundManager.getInstance().playSound(
                    Convo1, 29*GameSound.MSEC_PER_SEC, firstConvo, false, 1, GameSound.VOCAL,
                    "convo_1_hall"
                );*/
            } else {
                super.clickCallback(screenPos, worldPos);
            }
        }
    }
}
