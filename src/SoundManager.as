package {
    import org.flixel.*;

    public class SoundManager {
        public static var _instance:SoundManager = null;

        public var runningSounds:Array;
        public var newSound:GameSound;
        public var globalVolume:Number;

        public static const VOLUME_STEP:Number = .1;

        public function SoundManager() {
            this.runningSounds = new Array();
            this.globalVolume = .5;
        }

        public function playSound(embeddedSound:Class, dur:Number,
                                  endCallback:Function=null,
                                  _loop:Boolean=false, _vol:Number=1,
                                  _kind:Number=0, name:String=null,
                                  fadeIn:Boolean=false,
                                  fadeOut:Boolean=false):GameSound
        {
            if (name == null) {
                name = "" + Math.random();
            }

            this.clearSoundsByType(_kind);
            var newSound:GameSound = new GameSound(embeddedSound, dur, _loop,
                                                   _vol, _kind, name, fadeIn,
                                                   fadeOut, endCallback);
            this.runningSounds.push(newSound);

            GlobalTimer.getInstance().setMark(name, dur);

            return newSound;
        }

        public function update():void {
            var snd:GameSound;
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                snd = this.runningSounds[i];
                snd.update();
                if (snd.dur != 0 && GlobalTimer.getInstance().hasPassed(snd.name)) {
                    this.stopSound(snd);
                }
            }
        }

        public function pause():void {
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                this.runningSounds[i].pause();
            }
        }

        public function clearSoundsByType(_kind:Number):void {
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                if(this.runningSounds[i]._type == _kind) {
                    this.stopSound(runningSounds[i]);
                }
            }
        }

        private function stopSound(sound:GameSound):void {
            this.runningSounds.splice(this.runningSounds.indexOf(sound), 1);
            sound.stopSound();
        }

        public function soundOfTypeIsPlaying(_kind:Number):Boolean {
            var cur:GameSound;
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if(cur._type == _kind && !cur.stopped) {
                    return true;
                }
            }
            return false;
        }

        public function increaseVolume():void {
            if (this.globalVolume < 1) {
                this.globalVolume += VOLUME_STEP;
            }
            this.applyVolumeToRunningSounds();
        }

        public function decreaseVolume():void {
            if (this.globalVolume > 0) {
                this.globalVolume -= VOLUME_STEP;
            }
            this.applyVolumeToRunningSounds(true);
        }

        public function applyVolumeToRunningSounds(dec:Boolean=false):void {
            for(var i:Number = 0; i < runningSounds.length; i++){
                if (dec) {
                    this.runningSounds[i].decreaseVolume();
                } else {
                    this.runningSounds[i].increaseVolume();
                }
            }
        }

        public function getSoundByName(n:String):GameSound {
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                if(this.runningSounds[i].name == n) {
                    return this.runningSounds[i];
                }
            }
            return null;
        }

        public static function getInstance():SoundManager {
            if (_instance == null) {
                _instance = new SoundManager();
            }
            return _instance;
        }
    }
}
