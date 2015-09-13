package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class CreditsState extends GameState {
        [Embed(source="/../assets/audio/music/bgm_euryale_intro.mp3")] private var BGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_euryale_loop.mp3")] private var BGMLoop:Class;
        private var creditsStructure:Array;
        private var creditsText:FlxText;
        private var curCredit:Number;
        private var bg:GameObject;

        private static const STATE_STEADY:Number= 0;
        private static const STATE_FADE_OUT:Number= 1;
        private static const STATE_FADE_IN:Number= 2;
        private var _state:Number = STATE_STEADY;

        public static var BGM:String = "credits bgm";

        public function CreditsState() {
            super(true, false, false);
            this.enable_fade = true;
            this.use_loading_screen = false;
            this.enable_cursor = false;

            this.creditsStructure = new Array(
                {
                    'text': 'Written and designed by Nina Freeman'
                },
                {
                    'text': 'Programmed by Emmett Butler'
                },
                {
                    'text': 'Soundtrack composed by Decky Coss'
                },
                {
                    'text': 'Illustrated and animated by Rebekka Dunlap'
                },
                {
                    'text': 'Short films produced by Samantha Corey'
                },
                {
                    'text': 'Special thanks to:\n\n\nNöel Hanson\n\nand Sean Hogan\n\nfor asset support.'
                },
                {
                    'text': 'Special thanks to:\n\n\nBennett Foddy,\n\nSteve Gaynor\n\nAnd our many helpful playtesters.'
                }
            );

            this.curCredit = 0;
        }

        override public function create():void {
            super.create();

            var _screen:ScreenManager = ScreenManager.getInstance();

            this.bg = new GameObject(new DHPoint(0,0));
            this.bg.makeGraphic(_screen.screenWidth, _screen.screenHeight, 0xff000000);
            this.bg.scrollFactor = new FlxPoint(0, 0);
            this.bg.visible = true;
            this.add(this.bg);

            var creditsWidth:Number = _screen.screenWidth * .7;
            this.creditsText = new FlxText(
                _screen.screenWidth / 2 - creditsWidth / 2,
                _screen.screenHeight * .2,
                creditsWidth, ""
            );
            this.creditsText.visible = true;
            this.creditsText.alpha = 0;
            this.creditsText.scrollFactor = new DHPoint(0, 0);
            this.creditsText.setFormat("NexaBold-Regular", 27, 0xffffffff, "center");
            this.add(this.creditsText);

            GlobalTimer.getInstance().setMark(
                "credits-start", 2 * GameSound.MSEC_PER_SEC,
                this.showNextCredit
            );

            function _bgmCallback():void {
                SoundManager.getInstance().playSound(
                    BGMLoop, 0, null, true, .4, GameSound.BGM, CreditsState.BGM,
                    false, false
                );
            }
            SoundManager.getInstance().playSound(
                BGMIntro, 2.6 * GameSound.MSEC_PER_SEC, _bgmCallback, false,
                .4, GameSound.BGM, CreditsState.BGM, false, false, false
            );

            this.postCreate();
        }

        override public function update():void {
            super.update();

            switch(this._state) {
                case STATE_FADE_OUT:
                    this.creditsText.alpha -= .1;
                    break;
                case STATE_FADE_IN:
                    this.creditsText.alpha += .1;
                    break;
                case STATE_STEADY:
                    break;
            }
        }

        public function showNextCredit():void {
            var that:CreditsState = this;
            this._state = STATE_FADE_IN;
            GlobalTimer.getInstance().setMark(
                "credits-steady-" + that.curCredit,
                1.5 * GameSound.MSEC_PER_SEC,
                function():void {
                    _state = STATE_STEADY;
                    GlobalTimer.getInstance().setMark(
                        "credits-fadeout-" + that.curCredit,
                        5 * GameSound.MSEC_PER_SEC,
                        function():void {
                            _state = STATE_FADE_OUT;
                            GlobalTimer.getInstance().setMark(
                                "credits-next-" + that.curCredit,
                                1.5 * GameSound.MSEC_PER_SEC,
                                that.showNextCredit
                            );
                        }
                    );
                }
            );
            if (this.curCredit <= this.creditsStructure.length - 1) {
                this.creditsText.text = this.creditsStructure[this.curCredit].text;
                this.curCredit += 1;
            } else {
                this.creditsText.text = "";
                this.fadeOut(
                    function():void {
                        ScreenManager.getInstance().resetGame();
                    },
                    1 * GameSound.MSEC_PER_SEC,
                    CreditsState.BGM
                );
            }
        }
    }
}
