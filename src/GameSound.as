package
{
    import org.flixel.*;

    public class GameSound {
        public var name:String;
        public var embeddedSound:Class;
        private var soundObject:FlxSound;
        private var callbackLock:Boolean = false;
        public var virtualVolume:Number;
        public var running:Boolean = false;

        public static const VOCAL:Number = 0;
        public static const BGM:Number = 1;
        public static const SFX:Number = 2;
        public var _type:Number = VOCAL;
        public var fadeIn:Boolean = false;
        public var fadeOut:Boolean = false;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameSound(embeddedSound:Class, dur:Number,
                                  _loop:Boolean=false, _vol:Number=1,
                                  _kind:Number=0, name:String=null, fadeIn:Boolean=false, fadeOut:Boolean=false) {
            this.name = name;
            this.virtualVolume = _vol;
            this._type = _kind;
            this.running = true;
            this.fadeOut = fadeOut;
            this.fadeIn = fadeIn;

            this.embeddedSound = embeddedSound;

            soundObject = new FlxSound();
            soundObject.loadEmbedded(embeddedSound, _loop);
            soundObject.volume = _vol;
            soundObject.play();
            if (GlobalTimer.getInstance().isPaused()) {
                soundObject.pause();
            }
        }

        public function increaseVolume():void {
            this.virtualVolume += SoundManager.VOLUME_STEP;
            this.applyVolume();
        }

        public function decreaseVolume():void {
            this.virtualVolume -= SoundManager.VOLUME_STEP;
            this.applyVolume();
        }

        public function applyVolume():void {
            this.soundObject.volume = Math.min(Math.max(virtualVolume, 0), 1);
        }

        public function pause():void {
            if (!GlobalTimer.getInstance().isPaused()) {
                this.soundObject.resume();
            } else {
                this.soundObject.pause();
            }
        }

        public function update():void {
            if(this.fadeIn) {
                if(GlobalTimer.getInstance().timeElapsed(this.name) < 3*GameSound.MSEC_PER_SEC) {
                    this.fadeInSound();
                }
            }
            if(this.fadeOut) {
                if(GlobalTimer.getInstance().timeRemaining(this.name) < 3*GameSound.MSEC_PER_SEC) {
                    this.fadeOutSound();
                }
            }
        }

        public function fadeInSound():void {
            this.soundObject.volume += .01;
        }

        public function fadeOutSound():void {
            this.soundObject.volume -= .01;
            if(this.name == "desktop room tone") {
                FlxG.log(this.soundObject.volume);
            }

        }

        public function defaultEnd():void { }

        public function stopSound():void {
            soundObject.stop();
            this.running = false;
        }
    }
}
