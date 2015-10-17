package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;
    import flash.utils.Dictionary;

    public class DialoguePlayer {
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibsoslow.mp3")] private static var VOCibSlow:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_areyoucoming.mp3")] private static var VOComing:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_yeahsorry.mp3")] private static var VOYeahSorry:Class;
        [Embed(source="/../assets/audio/voiceover/voc_firstconvo.mp3")] private static var ConvoITH1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_bulldog.mp3")] private static var ConvoIT1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_ampule.mp3")] private static var ConvoIT2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_photogenic.mp3")] private static var ConvoIT3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_attractive.mp3")] private static var ConvoIT4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_picture.mp3")] private static var ConvoIT5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_whattowear.mp3")] private static var ConvoIT6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichilasthit.mp3")] private static var VOIchiHit:Class;
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
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_illcome.mp3")] private static var ConvoHI13:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_doingthis.mp3")] private static var ConvoHI14:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_iloveyou.mp3")] private static var ConvoHI15:Class;
        [Embed(source="/../assets/audio/music/vid_goodbye.mp3")] private static var ConvoGoodbye:Class;

        [Embed(source="/../assets/audio/voiceover/voc_extra_cibnicehit.mp3")] private static var BitCibNice:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibeast.mp3")] private static var BitCibEast:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibnorth.mp3")] private static var BitCibNorth:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibwest.mp3")] private static var BitCibWest:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibsouth.mp3")] private static var BitCibSouth:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ciblost.mp3")] private static var BitCibWhichWay:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibhere.mp3")] private static var BitCibHere:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichieast.mp3")] private static var BitIchiEast:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichinorth.mp3")] private static var BitIchiNorth:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichiwest.mp3")] private static var BitIchiWest:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichisouth.mp3")] private static var BitIchiSouth:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichiwhichway.mp3")] private static var BitIchiWhichWay:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichinice2.mp3")] private static var BitIchiNiceHit:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichirighthere.mp3")] private static var BitIchiHere:Class;

        {
            public static var sndFiles:Object = {
                'voc_extra_cibsoslow': VOCibSlow,
                'voc_extra_areyoucoming': VOComing,
                'voc_extra_yeahsorry': VOYeahSorry,
                'voc_firstconvo': ConvoITH1,
                'voc_ikuturso_bulldog': ConvoIT1,
                'voc_ikuturso_ampule': ConvoIT2,
                'voc_ikuturso_photogenic': ConvoIT3,
                'voc_ikuturso_attractive': ConvoIT4,
                'voc_ikuturso_picture': ConvoIT5,
                'voc_ikuturso_whattowear': ConvoIT6,
                'voc_extra_ichilasthit': VOIchiHit,
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
                'voc_hiisi_beingwithyou': ConvoHI12,
                'voc_hiisi_illcome': ConvoHI13,
                'voc_hiisi_doingthis': ConvoHI14,
                'voc_hiisi_iloveyou': ConvoHI15,
                'vid_goodbye': ConvoGoodbye,

                'voc_extra_cibnicehit': BitCibNice,
                'voc_extra_cibeast': BitCibEast,
                'voc_extra_cibnorth': BitCibNorth,
                'voc_extra_cibwest': BitCibWest,
                'voc_extra_cibsouth': BitCibSouth,
                'voc_extra_ciblost': BitCibWhichWay,
                'voc_extra_cibhere': BitCibHere,
                'voc_extra_ichinorth': BitIchiNorth,
                'voc_extra_ichisouth': BitIchiSouth,
                'voc_extra_ichieast': BitIchiEast,
                'voc_extra_ichiwest': BitIchiWest,
                'voc_extra_ichiwhichway': BitIchiWhichWay,
                'voc_extra_ichinice2': BitIchiNiceHit,
                'voc_extra_ichirighthere': BitIchiHere
            };
        }

        public static const subtitlesFilename:String = "assets/data/subtitles.txt";

        private var subtitlesMap:Object;
        private var subtitlesText:FlxText;
        private var backgroundBox:GameObject;
        private var prePauseBoxVisible:Boolean;
        private var textWidth:Number;
        private var _subtitles_enabled:Boolean;
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
                var textX:Number = 500;
                this.textWidth = ScreenManager.getInstance().screenWidth - 50 - textX;
                if (!(FlxG.state as GameState).updatePopup) {
                    this.textWidth = ScreenManager.getInstance().screenWidth * .5;
                    textX = ScreenManager.getInstance().screenWidth / 2 - this.textWidth / 2;
                }
                var boxWidth:Number = this.textWidth + 20;

                this.backgroundBox = new GameObject(
                    new DHPoint(
                        textX,
                        ScreenManager.getInstance().screenHeight - 110
                    )
                );
                this.backgroundBox.makeGraphic(boxWidth, 110, 0x55555555);
                this.backgroundBox.scrollFactor = new DHPoint(0, 0);
                FlxG.state.add(this.backgroundBox);

                this.subtitlesText = new FlxText(
                    textX, ScreenManager.getInstance().screenHeight - 100,
                    this.textWidth, ""
                );
                this.subtitlesText.setFormat("NexaBold-Regular", 22,
                    0xffffffff, "center");
                this.subtitlesText.scrollFactor = new DHPoint(0, 0);
                FlxG.state.add(this.subtitlesText, true);
            }
        }

        private function buildSubtitleCallback(tx:String):Function {
            var that:DialoguePlayer = this;
            return function():void {
                if (!that._subtitles_enabled) {
                    return;
                }
                initSubtitleText();
                that.subtitlesText.text = tx;
                that.backgroundBox.visible = true;

                GlobalTimer.getInstance().setMark(
                    "subtitle-remove",
                    8 * GameSound.MSEC_PER_SEC,
                    function():void {
                        if (that.subtitlesText.scale != null) {
                            that.subtitlesText.text = "";
                            that.backgroundBox.visible = false;
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

        public function pause():void {
            if (this.subtitlesText != null) {
                this.subtitlesText.visible = false;
                this.prePauseBoxVisible = this.backgroundBox.visible;
                this.backgroundBox.visible = false;
            }
        }

        public function resume():void {
            if (this.subtitlesText != null) {
                this.subtitlesText.visible = true;
                this.backgroundBox.visible = this.prePauseBoxVisible;
            }
        }

        public function toggle_subtitles_enabled():void {
            this._subtitles_enabled = !this._subtitles_enabled;
        }

        public function set subtitles_enabled(v:Boolean):void {
            this._subtitles_enabled = v;
        }

        public function get subtitles_enabled():Boolean {
            return this._subtitles_enabled;
        }

        public static function getInstance():DialoguePlayer {
            if (_instance == null) {
                _instance = new DialoguePlayer();
            }
            return _instance;
        }
    }
}
