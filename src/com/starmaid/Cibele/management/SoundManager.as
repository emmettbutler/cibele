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
        public static const DUCK_LEVEL:Number = .05;
        public static const DUCK_STEP:Number = .001;
        public static const DUCK_FADE:Number = 0;
        public static const UNDUCK_FADE:Number = 1;
        public static const STATE_NULL:Number = -1;

        public var _state:Number = STATE_NULL;

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
                        _state = UNDUCK_FADE;
                        ducking = false;
                    }
                }
                if (endCallback != null) {
                    endCallback();
                }
            };
            var newSound:GameSound = new GameSound(embeddedSound, dur, _loop,
                                                   _vol, _kind, name, fadeIn,
                                                   fadeOut, _callback, duck);
            this.runningSounds.push(newSound);
            if (_kind == GameSound.VOCAL && !this.ducking) {
                this.ducking = true;
                this._state = DUCK_FADE;
            }
            if (this.ducking && (_kind == GameSound.BGM || duck)) {
                newSound.decreaseVolume(DUCK_STEP);
            }

            GlobalTimer.getInstance().setMark(name, dur);

            return newSound;
        }

        public function duckMusic():void {
            var cur:GameSound
            var ducked_sound:GameSound;
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if ((cur.ducks || cur._type == GameSound.BGM) && !cur.fading) {
                    if(this.runningSounds[i].curVolume() > DUCK_LEVEL) {
                        this.runningSounds[i].decreaseVolume(DUCK_STEP);
                    }
                    ducked_sound = cur;
                }
            }
            if(ducked_sound.curVolume() <= DUCK_LEVEL) {
                this._state = STATE_NULL;
            }
        }

        public function unduckMusic():void {
            var cur:GameSound
            var ducked_sound:GameSound;
            for(var i:int = 0; i < this.runningSounds.length; i++) {
                cur = this.runningSounds[i];
                if ((cur.ducks || cur._type == GameSound.BGM) && !cur.fading) {
                    if(this.runningSounds[i].curVolume() < this.runningSounds[i].baseVolume) {
                        this.runningSounds[i].increaseVolume(DUCK_STEP);
                    }
                    ducked_sound = cur;
                }
            }
            if(ducked_sound.curVolume() >= ducked_sound.baseVolume) {
                this._state = STATE_NULL;
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

            switch(this._state) {
                case DUCK_FADE:
                    this.duckMusic();
                    break;
                case UNDUCK_FADE:
                    this.unduckMusic();
                    break;
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
