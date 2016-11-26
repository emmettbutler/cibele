package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class CommentaryPlayer {
        [Embed(source="/../assets/audio/commentary/voc_hiisi_weshouldmeet.mp3")] private static var Commentary1:Class;

        {
            public static var sndFiles:Object = {
                'commentary_1': {
                    'file': Commentary1,
                    'dur': 20 * GameSound.MSEC_PER_SEC,
                    'str': 'this is a test commentary string'
                }
            }
        }

        public static var _instance:CommentaryPlayer = null;

        public var currentTrayCommentary:Object;
        private var commentaryNameText:FlxText;
        private var lastTextState:GameState;

        public function CommentaryPlayer() {
        }

        public function playFile(filename:String):void
        {
            if (!ScreenManager.getInstance().COMMENTARY) {
                return;
            }
            var selected:Object = sndFiles[filename];
            if (selected) {
                SoundManager.getInstance().playSound(
                    selected['file'], selected['dur'], null, false, 1, GameSound.COMMENTARY
                );
            }
        }

        /*
         * Set the commentary tray to the given track name
         */
        public function setCurrentFile(filename:String):void
        {
            if (!ScreenManager.getInstance().COMMENTARY) {
                return;
            }
            var selected:Object = sndFiles[filename];
            this.currentTrayCommentary = selected;
            this.initCommentaryText();
            this.commentaryNameText.text = this.currentTrayCommentary['str'];
        }

        public function initCommentaryText():void {
            if (!ScreenManager.getInstance().COMMENTARY) {
                return;
            }
            if (this.commentaryNameText == null || this.lastTextState != (FlxG.state as GameState)) {
                this.lastTextState = FlxG.state as GameState;
                this.commentaryNameText = new FlxText(
                    ScreenManager.getInstance().screenWidth * .4,
                    ScreenManager.getInstance().screenHeight - 100,
                    500, ""
                );
                this.commentaryNameText.setFormat("NexaBold-Regular", 22,
                    0xffff0000, "center");
                this.commentaryNameText.scrollFactor = new DHPoint(0, 0);
                FlxG.state.add(this.commentaryNameText, true);
            }
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            trace("click happened in commentary player");
        }

        public function stop():void {
            SoundManager.getInstance().clearSoundsByType(GameSound.COMMENTARY);
        }

        public static function getInstance():CommentaryPlayer {
            if (_instance == null) {
                _instance = new CommentaryPlayer();
            }
            return _instance;
        }
    }
}
