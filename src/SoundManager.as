package {
    import org.flixel.*;

    public class SoundManager {
        public static var _instance:SoundManager = null;

        public var runningSounds:Array;

        public function SoundManager() {
            this.runningSounds = new Array();
        }

        public function playSound(embeddedSound:Class, dur:Number,
                                  endCallback:Function=null):void {
            var newSound:GameSound = new GameSound(embeddedSound, dur, endCallback);
            this.runningSounds.push(newSound);
        }

        public function update():void {
            var snd:GameSound;
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                snd = this.runningSounds[i];
                snd.update();
            }
        }

        public static function getInstance():SoundManager {
            if (_instance == null) {
                _instance = new SoundManager();
            }
            return _instance;
        }
    }
}
