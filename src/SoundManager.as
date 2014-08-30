package {
    import org.flixel.*;

    public class SoundManager {
        public static var _instance:SoundManager = null;

        public var runningSounds:Array;
        public var newSound:GameSound;

        public function SoundManager() {
            this.runningSounds = new Array();
        }

        public function playSound(embeddedSound:Class, dur:Number,
                                  endCallback:Function=null,
                                  _loop:Boolean=false, _vol:Number=1):void {
            if(runningSounds.length > 0){
                for(var i:Number = 0; i < runningSounds.length; i++){
                    if(embeddedSound != runningSounds[i].embeddedSound){
                        newSound = new GameSound(embeddedSound, dur, endCallback, _loop, _vol);
                        this.runningSounds.push(newSound);
                    }
                }
            } else {
                newSound = new GameSound(embeddedSound, dur, endCallback, _loop, _vol);
                this.runningSounds.push(newSound);
            }
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
