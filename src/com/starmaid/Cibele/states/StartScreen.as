package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.states.IkuTursoDesktop;
    import com.starmaid.Cibele.states.EuryaleDesktop;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class StartScreen extends GameState {
        [Embed(source="/../assets/audio/music/vid_intro.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public var startText:FlxText;
        private var _startButton:FlxText;

        override public function create():void {
            super.create();
            FlxG.bgColor = 0xff000000;

            startText = new FlxText(100,100,500,"Cibele\n\nCLICK to move and interact with objects.\nMake sure your sound is on.\n\nCOMMAND+Q or Alt+F4 to Quit.\n\nESC to pause.");
            add(startText);
            startText.setFormat("NexaBold-Regular",16,0xffffffff,"left");

            ScreenManager.getInstance();

            this.updatePopup = false;
            this.updateMessages = false;

            var _startButtonWidth:Number = 300;
            this._startButton = new FlxText(
                ScreenManager.getInstance().screenWidth / 2 - _startButtonWidth / 2,
                ScreenManager.getInstance().screenHeight - 100,
                _startButtonWidth,
                "START"
            );
            this._startButton.setFormat("NexaBold-Regular", 24, 0xffffffff, "center");
            this.add(this._startButton);

            super.postCreate();
        }

        public function startGame():void {
            ScreenManager.getInstance().levelTracker.loadProgress();

            if(ScreenManager.getInstance().levelTracker.it()) {
                SoundManager.getInstance().playSound(VidBGMLoop, 24*GameSound.MSEC_PER_SEC, null, false, 1, Math.random()*5000+100);
                FlxG.switchState(
                    new PlayVideoState(
                        "/../assets/video/computer_open.flv",
                        function ():void {
                            FlxG.switchState(new IkuTursoDesktop());
                        }
                    ));
            } else if(ScreenManager.getInstance().levelTracker.eu()) {
                FlxG.switchState(new EuryaleDesktop());
            } else if(ScreenManager.getInstance().levelTracker.hi()) {
            }
        }

        override public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var _mouseRect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y, 1, 1);
            var _startButtonRect:FlxRect = new FlxRect(this._startButton.x,
                                                       this._startButton.y,
                                                       this._startButton.width,
                                                       this._startButton.height);
            if (_mouseRect.overlaps(_startButtonRect)) {
                this.startGame();
            }
        }
    }
}
