package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class SoundManager {
        [Embed(source="/../assets/audio/effects/sfx_uigeneral.mp3")] private var SfxUI:Class;

        public static var _instance:SoundManager = null;

        public var runningSounds:Array;
        public var newSound:GameSound;
        public var globalVolume:Number;

        public static const VOLUME_STEP:Number = .1;

        public function SoundManager() {
            this.runningSounds = new Array();
            this.globalVolume = .5;
        }

        public function playSound(embeddedSound:Class,
                                  dur:Number,
                                  endCallback:Function=null,
                                  _loop:Boolean=false,
                                  _vol:Number=1,
                                  _kind:Number=-1,
                                  name:String=null,
                                  fadeIn:Boolean=false,
                                  fadeOut:Boolean=false,
                                  duck:Boolean=false,
                                  overwriteTimer:Boolean=false):GameSound
        {
            if (name == null) {
                name = "" + Math.random();
            }

            this.clearSoundsByType(_kind);

            var _callback:Function = function():void {
                if (this._type == GameSound.VOCAL ||
                    this._type == GameSound.COMMENTARY)
                {
                    unduckSounds(this._type);
                }
                if (endCallback != null) {
                    endCallback();
                }
            };
            var newSound:GameSound = new GameSound(embeddedSound, dur, _loop,
                                                   _vol, _kind, name, fadeIn,
                                                   fadeOut, _callback, duck);
            this.runningSounds.push(newSound);
            if (_kind == GameSound.COMMENTARY || _kind == GameSound.VOCAL)
            {
                this.duckSounds(_kind);
            }
            if (this.shouldDuckSound(newSound) || duck) {
                newSound.duck();
            }

            GlobalTimer.getInstance().setMark(name, dur, null, overwriteTimer);

            return newSound;
        }

        public function shouldDuckSound(sound:GameSound):Boolean {
            if (sound.fading) {
                return false;
            }
            if (sound.ducks) {
                return true;
            }
            var vocalIsPlaying:Boolean = this.soundOfTypeIsPlaying(GameSound.VOCAL);
            var commentaryIsPlaying:Boolean = this.soundOfTypeIsPlaying(
                GameSound.COMMENTARY);
            if (sound._type == GameSound.BGM) {
                return vocalIsPlaying;
            }
            return commentaryIsPlaying;
        }

        public function typesToDuckFromType(_type:Number):Number {
            if (_type == GameSound.VOCAL) {
                return GameSound.BGM;
            } else if (_type == GameSound.COMMENTARY) {
                return GameSound.ALLSOUNDS;
            }
            return -1;
        }

        public function duckSounds(_type:Number):void {
            var toDuck:Number = this.typesToDuckFromType(_type);
            var cur:GameSound
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if ((cur.ducks || cur._type == toDuck || toDuck == GameSound.ALLSOUNDS)
                    && !cur.fading)
                {
                    cur.duck();
                }
            }
        }

        public function unduckSounds(_type:Number):void {
            var toUnduck:Number = this.typesToDuckFromType(_type);
            var cur:GameSound
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if ((cur.ducks || cur._type == toUnduck || toUnduck == GameSound.ALLSOUNDS)
                    && !cur.fading)
                {
                    cur.unduck();
                }
            }
        }

        public function update():void {
            var snd:GameSound;
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                snd = this.runningSounds[i];
                snd.update();
                if (snd.running == false ||
                    (snd.dur != 0 &&
                     GlobalTimer.getInstance().hasPassed(snd.name)))
                {
                    this.stopSound(snd);
                }
            }
        }

        public function pause():void {
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                this.runningSounds[i].pause();
            }
        }

        public function resume():void {
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                this.runningSounds[i].resume();
            }
        }

        public function resetAll():void {
            for(var i:int = this.runningSounds.length - 1; i >= 0; i--) {
                this.stopSound(runningSounds[i]);
            }
        }

        public function clearSoundsByType(_kind:Number):void {
            var snd:GameSound;
            for(var i:int = this.runningSounds.length - 1; i >= 0; i--) {
                snd = this.runningSounds[i];
                if(snd._type == _kind && snd._type != -1) {
                    this.stopSound(runningSounds[i]);
                }
            }
        }

        private function stopSound(sound:GameSound):void {
            this.runningSounds.splice(this.runningSounds.indexOf(sound), 1);
            sound.stopSound();
            this.unduckSounds(sound._type);
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

        public function playUIGeneralSFX():void {
            this.playSound(
                SfxUI, 1*GameSound.MSEC_PER_SEC, null, false, .3, GameSound.SFX,
                "" + Math.random()
            );
        }

        public static function getInstance():SoundManager {
            if (_instance == null) {
                _instance = new SoundManager();
            }
            return _instance;
        }
    }
}
