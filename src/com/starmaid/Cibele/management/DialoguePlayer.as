package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;
    import flash.utils.Dictionary;

    public class DialoguePlayer {
        [Embed(source="/../assets/audio/voiceover/voc_firstconvo.mp3")] private static var ConvoITH1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_bulldog.mp3")] private static var ConvoIT1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_ampule.mp3")] private static var ConvoIT2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_photogenic.mp3")] private static var ConvoIT3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_attractive.mp3")] private static var ConvoIT4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_picture.mp3")] private static var ConvoIT5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_whattowear.mp3")] private static var ConvoIT6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_hey.mp3")] private static var ConvoEUH1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_teleport.mp3")] private static var ConvoEUH2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_breakups.mp3")] private static var ConvoEU1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_nada.mp3")] private static var ConvoEU2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_crush.mp3")] private static var ConvoEU3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_callmeblake.mp3")] private static var ConvoEU4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_closer.mp3")] private static var ConvoEU5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_meetup.mp3")] private static var ConvoEU6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_parents.mp3")] private static var ConvoEU7:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_dredge.mp3")] private static var ConvoEU8:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_iwish.mp3")] private static var ConvoEU9:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_canicallyou.mp3")] private static var ConvoEU10:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_cibyeah.mp3")] private static var ConvoEU11:Class;
        [Embed(source="/../assets/audio/music/vid_phonecall.mp3")] private static var ConvoPhone:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_morning.mp3")] private static var ConvoHI1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_westcoast.mp3")] private static var ConvoHI2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_whatifwemet.mp3")] private static var ConvoHI3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_whatdoyouthink.mp3")] private static var ConvoHI4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_youtoldme.mp3")] private static var ConvoHI5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_weshouldmeet.mp3")] private static var ConvoHI6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_ifwemet.mp3")] private static var ConvoHI7:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_thinkabout.mp3")] private static var ConvoHI8:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_superhot.mp3")] private static var ConvoHI9:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_itcouldhappen.mp3")] private static var ConvoHI10:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_nervous.mp3")] private static var ConvoHI11:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_beingwithyou.mp3")] private static var ConvoHI12:Class;

        {
            public static var sndFiles:Object = {
                'voc_firstconvo': ConvoITH1,
                'voc_ikuturso_bulldog': ConvoIT1,
                'voc_ikuturso_ampule': ConvoIT2,
                'voc_ikuturso_photogenic': ConvoIT3,
                'voc_ikuturso_attractive': ConvoIT4,
                'voc_ikuturso_picture': ConvoIT5,
                'voc_ikuturso_whattowear': ConvoIT6,
                'voc_euryale_hey': ConvoEUH1,
                'voc_euryale_teleport': ConvoEUH2,
                'voc_euryale_breakups': ConvoEU1,
                'voc_euryale_nada': ConvoEU2,
                'voc_euryale_crush': ConvoEU3,
                'voc_euryale_callmeblake': ConvoEU4,
                'voc_euryale_closer': ConvoEU5,
                'voc_euryale_meetup': ConvoEU6,
                'voc_euryale_parents': ConvoEU7,
                'voc_euryale_dredge': ConvoEU8,
                'voc_euryale_iwish': ConvoEU9,
                'voc_euryale_canicallyou': ConvoEU10,
                'voc_euryale_cibyeah': ConvoEU11,
                'vid_phonecall': ConvoPhone,
                'voc_hiisi_morning': ConvoHI1,
                'voc_hiisi_westcoast': ConvoHI2,
                'voc_hiisi_whatifwemet': ConvoHI3,
                'voc_hiisi_whatdoyouthink': ConvoHI4,
                'voc_hiisi_youtoldme': ConvoHI5,
                'voc_hiisi_weshouldmeet': ConvoHI6,
                'voc_hiisi_ifwemet': ConvoHI7,
                'voc_hiisi_thinkabout': ConvoHI8,
                'voc_hiisi_superhot': ConvoHI9,
                'voc_hiisi_itcouldhappen': ConvoHI10,
                'voc_hiisi_nervous': ConvoHI11,
                'voc_hiisi_beingwithyou': ConvoHI12
            };
        }

        public static const subtitlesFilename:String = "assets/data/subtitles.txt";

        private var subtitlesMap:Object;
        private var subtitlesText:FlxText;
        private var textWidth:Number;
        public static var _instance:DialoguePlayer = null;

        public function DialoguePlayer() {
            this.loadSubtitles();
        }

        public function playFile(filename:String,
                                 len:Number,
                                 endfn:Function=null,
                                 vol:Number=1,
                                 _type:Number=GameSound.VOCAL,
                                 name:String=null):void
        {
            var sndFile:Class = sndFiles[filename];
            SoundManager.getInstance().playSound(
                sndFile, len, endfn, false, vol, _type, name
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

        private function initSubtitleText():void {
            if (this.subtitlesText == null || this.subtitlesText.scale == null) {
                this.textWidth = ScreenManager.getInstance().screenWidth * .6;
                this.subtitlesText = new FlxText(
                    ScreenManager.getInstance().screenWidth / 2 - this.textWidth / 2,
                    ScreenManager.getInstance().screenHeight - 200,
                    this.textWidth,
                    ""
                );
                this.subtitlesText.setFormat("NexaBold-Regular", 22, 0xffffffff, "center");
                this.subtitlesText.scrollFactor = new DHPoint(0, 0);
                FlxG.state.add(this.subtitlesText, true);
            }
        }

        private function buildSubtitleCallback(tx:String):Function {
            var that:DialoguePlayer = this;
            return function():void {
                initSubtitleText();
                that.subtitlesText.text = tx;

                GlobalTimer.getInstance().setMark(
                    "subtitle-remove",
                    8 * GameSound.MSEC_PER_SEC,
                    function():void {
                        if (that.subtitlesText.scale != null) {
                            that.subtitlesText.text = "";
                        }
                    }, true
                );
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
