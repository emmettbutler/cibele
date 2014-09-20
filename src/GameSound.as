package
{
    import org.flixel.*;

    public class GameSound {
        public var name:String;
        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var timeRemaining:Number = -1;
        public var currentTime:Number = -1;
        public var totalSeconds:Number = 0;
        public var paused:Boolean;
        public var embeddedSound:Class;
        private var soundObject:FlxSound;
        public var callbackLock:Boolean = false;
        public var virtualVolume:Number;

        public static const VOCAL:Number = 0;
        public static const BGM:Number = 1;
        public var _type:Number = VOCAL;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameSound(embeddedSound:Class, dur:Number,
                                  _loop:Boolean=false, _vol:Number=1,
                                  _kind:Number=0, name:String=null,
                                  paused:Boolean=false) {
            this.name = name;
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
            this.virtualVolume = _vol;
            this._type = _kind;
            this.paused = paused;

            this.totalSeconds = dur;
            this.embeddedSound = embeddedSound;

            soundObject = new FlxSound();
            soundObject.loadEmbedded(embeddedSound, _loop);
            soundObject.volume = _vol;
            soundObject.play();
            if (this.paused) {
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
            this.paused = !this.paused;
            if (!this.paused) {
                this.soundObject.resume();
            } else {
                this.soundObject.pause();
            }
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.timeRemaining = this.totalSeconds - this.timeAlive;
        }

        public function defaultEnd():void { }

        public function stopSound():void {
            soundObject.stop();
        }
    }
}
