package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.SoundManager;

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
            // set tray string to selected['str']
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
