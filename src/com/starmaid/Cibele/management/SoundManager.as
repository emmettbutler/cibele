package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class SoundManager {
        public static var _instance:SoundManager = null;

        public var runningSounds:Array;
        public var newSound:GameSound;
        public var globalVolume:Number;
        public var ducking:Boolean = false;

        public static const VOLUME_STEP:Number = .1;
        public static const DUCK_STEP:Number = .05;

        public function SoundManager() {
            this.runningSounds = new Array();
            this.globalVolume = .5;
        }

        public function playSound(embeddedSound:Class, dur:Number,
                                  endCallback:Function=null,
                                  _loop:Boolean=false, _vol:Number=1,
                                  _kind:Number=0, name:String=null,
                                  fadeIn:Boolean=false,
                                  fadeOut:Boolean=false,
                                  duck:Boolean=false):GameSound
        {
            if (name == null) {
                name = "" + Math.random();
            }

            this.clearSoundsByType(_kind);

            var _callback:Function = function():void {
                if (this._type == GameSound.VOCAL) {
                    if (ducking) {
                        unduckMusic();
                        ducking = false;
                    }
                }
                if (endCallback != null) {
                    endCallback();
                }
            };
            if (ScreenManager.getInstance().MUTE) {
                _vol = 0;
            }
            var newSound:GameSound = new GameSound(embeddedSound, dur, _loop,
                                                   _vol, _kind, name, fadeIn,
                                                   fadeOut, _callback, duck);
            this.runningSounds.push(newSound);
            if (_kind == GameSound.VOCAL && !this.ducking) {
                this.ducking = true;
                this.duckMusic();
            }
            if (this.ducking && (_kind == GameSound.BGM || duck)) {
                newSound.decreaseVolume(DUCK_STEP);
            }

            GlobalTimer.getInstance().setMark(name, dur);

            return newSound;
        }

        public function duckMusic():void {
            var cur:GameSound
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if ((cur.ducks || cur._type == GameSound.BGM) && !cur.fading) {
                    this.runningSounds[i].decreaseVolume(DUCK_STEP);
                }
            }
        }

        public function unduckMusic():void {
            var cur:GameSound
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if ((cur.ducks || cur._type == GameSound.BGM) && !cur.fading) {
                    this.runningSounds[i].increaseVolume(DUCK_STEP);
                }
            }
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
