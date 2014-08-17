package
{
    import org.flixel.*;

    public class GameSound {
        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;
        public var totalSeconds:Number = 0;
        public var embeddedSound:Class;
        public var soundObject:FlxSound;
        public var endCallback:Function;
        public var callbackLock:Boolean = false;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameSound(embeddedSound:Class, dur:Number,
                                  endCallback:Function=null) {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;

            this.totalSeconds = dur;
            this.embeddedSound = embeddedSound;
            this.endCallback = endCallback;
            if (this.endCallback == null) {
                this.endCallback = this.defaultEnd;
            }

            soundObject = new FlxSound();
            soundObject.loadEmbedded(embeddedSound, false);
            soundObject.play();
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if (this.timeAlive % 4 == 0) {
                //trace(this.timeAlive);
            }

            if(this.timeAlive >= totalSeconds && !callbackLock){
                callbackLock = true;
                this.soundObject.stop();
                this.endCallback();
            }
        }

        public function defaultEnd():void { }
    }
}
