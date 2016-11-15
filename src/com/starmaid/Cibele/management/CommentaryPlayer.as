package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.SoundManager;

    public class CommentaryPlayer {
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_superhot.mp3")] private static var Commentary1:Class;

        {
            public static var sndFiles:Object = {
                'commentary_1': Commentary1
            }
        }

        public static var _instance:CommentaryPlayer = null;

        public function CommentaryPlayer() {
        }

        public function playFile(filename:String):void
        {
            var sndFile:Class = sndFiles[filename];
            SoundManager.getInstance().playSound(
                sndFile, -1, null, false, 1, GameSound.COMMENTARY
            );
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
