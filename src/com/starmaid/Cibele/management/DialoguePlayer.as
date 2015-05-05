package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;
    import flash.utils.Dictionary;

    public class DialoguePlayer {
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_photogenic.mp3")] private static var Convo3:Class;

        {
            public static var sndFiles:Object = {
                'voc_ikuturso_photogenic': Convo3
            };
        }

        public static const subtitlesFilename:String = "assets/data/subtitles.txt";

        private var subtitlesMap:Object;
        public static var _instance:DialoguePlayer = null;

        public function DialoguePlayer() {
            this.loadSubtitles();
        }

        public function playFile(filename:String,
                                 len:Number,
                                 endfn:Function=null,
                                 vol:Number=1):void
        {
            var sndFile:Class = sndFiles[filename];
            SoundManager.getInstance().playSound(
                sndFile, len, endfn, false, vol, GameSound.VOCAL
            );

            var dialogue:String;
            for (var ts:Number in subtitlesMap[filename]) {
                dialogue = subtitlesMap[filename][ts];
                GlobalTimer.getInstance().setMark(
                    "subtitle" + filename + ts,
                    ts, this.buildSubtitleCallback(dialogue),
                    false
                );
            }
        }

        private function buildSubtitleCallback(tx:String):Function {
            return function():void {
                trace(tx);
            };
        }

        public function loadSubtitles():void {
            this.subtitlesMap = {};

            var f:File = File.applicationDirectory.resolvePath(
                DialoguePlayer.subtitlesFilename);
            var str:FileStream = new FileStream();
            if (f == null || !f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var lines:Array = fileContents.split("\n");
            var line:Array;
            var filename:String, ts:Number, dialogueText:String;
            for (var i:int = 0; i < lines.length - 1; i++) {
                line = lines[i].split(" ");
                filename = line[0];
                ts = Number(line[1]);
                dialogueText = "";
                for (var k:int = 2; k < line.length; k++) {
                    dialogueText += " " + line[k];
                }
                if (!(filename in subtitlesMap)) {
                    subtitlesMap[filename] = new Dictionary();
                }
                subtitlesMap[filename][ts] = dialogueText;
            }
        }

        public static function getInstance():DialoguePlayer {
            if (_instance == null) {
                _instance = new DialoguePlayer();
            }
            return _instance;
        }
    }
}
