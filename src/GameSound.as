package
{
    import org.flixel.*;

    public class GameSound {
        public var name:String;
        public var embeddedSound:Class;
        private var soundObject:FlxSound;
        private var callbackLock:Boolean = false;
        public var stopped:Boolean = false;
        public var endCallback:Function = null;
        public var virtualVolume:Number, dur:Number;
        public var running:Boolean = false;

        public static const VOCAL:Number = 0;
        public static const BGM:Number = 1;
        public static const SFX:Number = 2;
        public var _type:Number = VOCAL;
        public var fadeIn:Boolean = false;
        public var fadeOut:Boolean = false;
        public var fading:Boolean = false;
        public var ducks:Boolean = false;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameSound(embeddedSound:Class, dur:Number,
                                  _loop:Boolean=false, _vol:Number=1,
                                  _kind:Number=0, name:String=null,
                                  fadeIn:Boolean=false, fadeOut:Boolean=false,
                                  endCallback:Function=null, ducks:Boolean=false) {
            if (_kind == BGM || ducks) {
                _vol += SoundManager.DUCK_STEP;
            }
            this.name = name;
            this.virtualVolume = _vol;
            this._type = _kind;
            this.dur = dur;
            this.running = true;
            this.fadeOut = fadeOut;
            this.fadeIn = fadeIn;
            this.endCallback = endCallback;
            this.ducks = ducks;

            this.embeddedSound = embeddedSound;

            soundObject = new FlxSound();
            soundObject.loadEmbedded(embeddedSound, _loop);
            soundObject.volume = _vol;
            soundObject.play();
            if (GlobalTimer.getInstance().isPaused()) {
                soundObject.pause();
            }
        }

        public function increaseVolume(step:Number=0):void {
            this.virtualVolume += step == 0 ? SoundManager.VOLUME_STEP : step;
            this.applyVolume();
        }

        public function decreaseVolume(step:Number=0):void {
            this.virtualVolume -= step == 0 ? SoundManager.VOLUME_STEP : step;
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
                    this.fading = true;
                } else if (!this.fadeOut) {
                    this.fading = false;
                }
            }
            if(this.fadeOut) {
                if(GlobalTimer.getInstance().timeRemaining(this.name) < 3*GameSound.MSEC_PER_SEC) {
                    this.fading = true;
                    this.fadeOutSound();
                }
            }
        }

        public function fadeInSound():void {
            this.soundObject.volume += .005;
        }

        public function fadeOutSound():void {
            this.soundObject.volume -= .005;
        }

        public function defaultEnd():void { }

        public function stopSound():void {
            soundObject.stop();
            this.running = false;
            this.stopped = true;
            if (this.endCallback != null && !this.callbackLock) {
                this.endCallback();
                this.callbackLock = true;
            }
        }
    }
}
