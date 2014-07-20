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

        public static const MSEC_PER_SEC:Number = 1000;

        public static var _instance:GameSound = null;

        public function GameSound() {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if(this.timeAlive >= totalSeconds){
                didEnd();
            }
        }

        public function didEnd():void{

        }

        public function play_(sound:Class, sec:Number):void{
            totalSeconds = sec;
            embeddedSound = sound;

            soundObject = new FlxSound();
            soundObject.loadEmbedded(sound, true);
            soundObject.play();
        }

        public static function getInstance():GameSound {
            if (_instance == null) {
                _instance = new GameSound();
            }
            return _instance;
        }
    }
}
