package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.UIElement;
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
                },
                'commentary_2': {
                    'file': Commentary1,
                    'dur': 20 * GameSound.MSEC_PER_SEC,
                    'str': 'this is super different guys'
                }
            }
            // make name accessible in object
            public static var k:String;
            for (k in sndFiles) {
                sndFiles[k]['name'] = k;
            }
        }

        public static var _instance:CommentaryPlayer = null;

        public var currentTrayCommentary:Object;
        public var elements:Array;
        private var commentaryNameText:FlxText;
        private var commentaryTextHitbox:GameObject;
        private var lastTextState:GameState;

        public function CommentaryPlayer() {
            this.elements = new Array();
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
            this.elements.push(this.commentaryTextHitbox);
            this.commentaryTextHitbox.visible = true;
            this.commentaryNameText.visible = true;
            this.commentaryNameText.text = this.currentTrayCommentary['str'];
        }

        public function initCommentaryText():void {
            if (!ScreenManager.getInstance().COMMENTARY) {
                return;
            }
            if (this.commentaryNameText == null || this.lastTextState != (FlxG.state as GameState)) {
                this.elements.length = 0;
                this.lastTextState = FlxG.state as GameState;

                var buttonPos:DHPoint = new DHPoint(
                    ScreenManager.getInstance().screenWidth * .4,
                    ScreenManager.getInstance().screenHeight - 100
                );
                var buttonWidth:Number = 500;

                this.commentaryTextHitbox = new UIElement(buttonPos.x, buttonPos.y);
                this.commentaryTextHitbox.scrollFactor = new DHPoint(0, 0);
                this.commentaryTextHitbox.active = false;
                this.commentaryTextHitbox.makeGraphic(buttonWidth, 70, 0xff00ff00);
                this.commentaryTextHitbox.visible = false;
                FlxG.state.add(this.commentaryTextHitbox, true);

                this.commentaryNameText = new FlxText(buttonPos.x, buttonPos.y,
                                                      buttonWidth, "");
                this.commentaryNameText.setFormat("NexaBold-Regular", 22,
                    0xffff0000, "center");
                this.commentaryNameText.scrollFactor = new DHPoint(0, 0);
                this.commentaryNameText.visible = false;
                FlxG.state.add(this.commentaryNameText, true);
            }
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y, 5, 5);
            var screenRect:FlxRect = this.commentaryTextHitbox._getScreenRect();
            if (mouseScreenRect.overlaps(screenRect) && this.commentaryNameText.visible){
                if (SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.COMMENTARY)) {
                    this.stop();
                } else {
                    this.playFile(this.currentTrayCommentary['name']);
                }
            }
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
