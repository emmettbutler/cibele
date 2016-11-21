package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class GameSound {
        public var name:String;
        public var embeddedSound:Class;
        private var soundObject:FlxSound;
        private var callbackLock:Boolean = false, paused:Boolean = false;
        public var stopped:Boolean = false;
        public var endCallback:Function = null;
        public var virtualVolume:Number, dur:Number;
        public var running:Boolean = false;

        public static const VOCAL:Number = 0;
        public static const BGM:Number = 1;
        public static const SFX:Number = 2;
        public static const BIT_DIALOGUE:Number = 3;
        public static const COMMENTARY:Number = 4;
        public static const ALLSOUNDS:Number = 28743658;
        public static const DUCK_STEP:Number = .05;
        public var _type:Number = VOCAL;
        public var fadeIn:Boolean = false;
        public var fadeOut:Boolean = false;
        public var fading:Boolean = false;
        public var ducks:Boolean = false;
        public var ducking:Boolean = false;
        public var duckStep:Number;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameSound(embeddedSound:Class, dur:Number,
                                  _loop:Boolean=false, _vol:Number=1,
                                  _kind:Number=0, name:String=null,
                                  fadeIn:Boolean=false, fadeOut:Boolean=false,
                                  endCallback:Function=null, ducks:Boolean=false) {
            this.duckStep = DUCK_STEP;
            // XXX this is only here because removing it makes things sound
            // bad and i don't know what it's supposed to do
            if (_kind == BGM || ducks) {
                _vol += DUCK_STEP;
            }
            if (_kind == VOCAL) {
                this.duckStep = .95;
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
            if (!ScreenManager.getInstance().MUTE) {
                soundObject.play();
                if (GlobalTimer.getInstance().isPaused()) {
                    this.pause();
                }
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

        public function duck():void {
            if (this.ducking || this._type == COMMENTARY) {
                return;
            }
            this.decreaseVolume(this.duckStep);
            this.ducking = true;
        }

        public function unduck():void {
            if (!this.ducking || this._type == COMMENTARY) {
                return;
            }
            this.increaseVolume(this.duckStep);
            this.ducking = false;
        }

        public function applyVolume():void {
            if (this == null || this.soundObject == null) {
                return;
            }
            this.soundObject.volume = Math.min(Math.max(virtualVolume, 0), 1);
        }

        public function pause():void {
            if (!this.paused) {
                this.soundObject.pause();
                this.paused = true;
            }
        }

        public function resume():void {
            this.soundObject.resume();
            this.paused = false;
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

        public function fadeInSound(step:Number=.08):void {
            this.increaseVolume(step);
        }

        public function fadeOutSound(step:Number=.08):void {
            if (this.soundObject == null) {
                return;
            }
            this.decreaseVolume(step);
            if (this.soundObject.volume <= 0) {
                this.stopSound();
            }
        }

        public function defaultEnd():void { }

        public function stopSound():void {
            if (soundObject != null) {
                soundObject.stop();
                soundObject.destroy();
                soundObject = null;
            }
            this.running = false;
            this.stopped = true;
            if (this.endCallback != null && !this.callbackLock) {
                this.endCallback();
                this.callbackLock = true;
            }
        }
    }
}
