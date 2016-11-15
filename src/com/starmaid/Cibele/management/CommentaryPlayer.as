package com.starmaid.Cibele.management {
    public class CommentaryPlayer {
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_superhot.mp3")] private static var Commentary1:Class;

        {
            public static var sndFiles:Object = {
                'commentary_1': Commentary1
            }
        }

        public function CommentaryPlayer() {
        }

        public function playFile(filename:String,
                                 len:Number):void
        {
            var sndFile:Class = sndFiles[filename];
            SoundManager.getInstance().playSound(
                sndFile, len, null, false, 1, GameSound.COMMENTARY
            );
        }

        public static function getInstance():CommentaryPlayer {
            if (_instance == null) {
                _instance = new CommentaryPlayer();
            }
            return _instance;
        }
    }
}
