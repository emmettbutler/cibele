package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.entities.FallingObject;
    import com.starmaid.Cibele.entities.Mist;
    import com.starmaid.Cibele.states.BlankScreen;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    import flash.events.*;

    public class Euryale extends LevelMapState {
        [Embed(source="/../assets/audio/music/bgm_euryale_intro.mp3")] private var EUBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_euryale_loop.mp3")] private var EUBGMLoop:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_hey.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_teleport.mp3")] private var Convo1_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_breakups.mp3")] private var Convo2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_nada.mp3")] private var Convo2_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_crush.mp3")] private var Convo3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_callmeblake.mp3")] private var Convo3_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_closer.mp3")] private var Convo4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_meetup.mp3")] private var Convo4_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_parents.mp3")] private var Convo4_3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_dredge.mp3")] private var Convo5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_iwish.mp3")] private var Convo5_1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_canicallyou.mp3")] private var Convo5_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_cibyeah.mp3")] private var Convo5_3:Class;
        [Embed(source="/../assets/audio/music/vid_phonecall.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/images/worlds/sparkles_1.png")] private var ImgSparkle1:Class;
        [Embed(source="/../assets/images/worlds/sparkles_2.png")] private var ImgSparkle2:Class;
        [Embed(source="/../assets/images/worlds/sparkles_3.png")] private var ImgSparkle3:Class;
        [Embed(source="/../assets/images/worlds/droplet.png")] private var ImgDroplet1:Class;
        [Embed(source="/../assets/images/worlds/droplet_sparkle.png")] private var ImgDroplet2:Class;

        public static var BGM:String = "euryale bgm loop";
        public static const CONVO_1_HALL:String = "trigigioji";
        public static const CONVO_1_2_HALL:String = "spiddlydiddlydee";
        public static const SHOW_FIRST_POPUP:String = "pennisuyuyi";

        public static const SPARKLES_COUNT:Number = 45;
        public static const DROPLETS_COUNT:Number = 3;
        public static const MIST_COUNT:Number = 30;

        private var sparkles:Array, droplets:Array, mists:Array;

        public function Euryale() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_EU;

            this.bitDialogueLock = false;
            this.load_screen_text = "Euryale";
            this.teamPowerBossThresholds = [6, 15];
            PopUpManager.GAME_ACTIVE = true;

            GlobalTimer.getInstance().deleteMark(BOSS_MARK);

            this.conversationCounter = -1;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo2, "len": 43*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo2_2, "len": 19*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showSelfiePostEmail, "min_team_power": 10
                },
                {
                    "audio": Convo3, "len": 28*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 8*GameSound.MSEC_PER_SEC,
                    "delay": 0, "min_team_power": 12
                },
                {
                    "audio": Convo3_2, "len": 44*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showFriendEmail2, "min_team_power": 15
                },
                {
                    "audio": Convo4, "len": 11*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 10*GameSound.MSEC_PER_SEC,
                    "delay": 0, "min_team_power": 17
                },
                {
                    "audio": Convo4_2, "len": 74*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo4_3, "len": 50*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 10*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": showDredgeSelfie, "min_team_power": 25
                },
                {
                    "audio": Convo5, "len": 54*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, "min_team_power": 30
                },
                {
                    "audio": Convo5_1, "len": 42*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 1*GameSound.MSEC_PER_SEC,
                    "delay": 0, "boss_gate": true
                },
                {
                    "audio": null, "len": 3*GameSound.MSEC_PER_SEC,
                    "delay": 0, "ends_with_popup": false
                },
                {
                    "audio": Convo5_2, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo5_3, "len": 4*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.playEndFilm
                }
            ];

            this.filename = "data/euryale_path.txt";
            this.graph_filename = "data/euryale_graph.txt";
            this.mapTilePrefix = "euryale";
            this.tileGridDimensions = new DHPoint(10, 5);
            this.estTileDimensions = new DHPoint(1359, 818);
            this.playerStartPos = new DHPoint(3427, 7657);
            this.colliderScaleFactor = 8;
            this.enemyDirMultiplier = 2;
            this.maxTeamPower = 30;
        }

        override public function create():void {
            this.registerPopupCallback();
            super.create();

            function _bgmCallback():void {
                SoundManager.getInstance().playSound(
                    EUBGMLoop, 0, null, true, .07, GameSound.BGM, Euryale.BGM,
                    false, false
                );
            }
            SoundManager.getInstance().playSound(
                EUBGMIntro, 2.6*GameSound.MSEC_PER_SEC, _bgmCallback, false,
                .07, Math.random()*928+298, Euryale.BGM, false, false, true
            );

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                SoundManager.getInstance().playSound(
                    Convo1,
                    GameState.SHORT_DIALOGUE ? 1 : 12*GameSound.MSEC_PER_SEC,
                    firstConvoPartTwo, false, 1, GameSound.VOCAL,
                    CONVO_1_HALL
                );
            }

            if (ScreenManager.getInstance().QUICK_LEVELS) {
                GlobalTimer.getInstance().setMark(
                    "end_level_eu",
                    10 * GameSound.MSEC_PER_SEC,
                    this.playEndFilm
                )
            }
        }

        override public function destroy():void {
            this.sparkles = null;
            this.droplets = null;
            this.mists = null;
            super.destroy();
        }

        override public function addEnvironmentDetails():void {
            this.setupSparkles();
        }

        override public function addScreenspaceDetails():void {
            this.setupDroplets();
            this.setupMist();
        }

        private function setupMist():void {
            this.mists = new Array();
            for (var i:int = 0; i < MIST_COUNT; i++) {
                this.mists.push(new Mist());
            }
        }

        private function setupDroplets():void {
            this.droplets = new Array();
            var droplet:GameObject;
            var dropletDimensions:DHPoint = new DHPoint(90, 216);
            var imgs:Array = [ImgDroplet1, ImgDroplet2];
            var img:Class;
            for (var i:int = 0; i < DROPLETS_COUNT; i++) {
                droplet = new FallingObject(new DHPoint(
                    Math.random() * (ScreenManager.getInstance().screenWidth - dropletDimensions.x),
                    -1 * dropletDimensions.y
                ));
                img = imgs[Math.floor(Math.random() * imgs.length)];
                droplet.loadGraphic(img, false, false,
                                    dropletDimensions.x, dropletDimensions.y);
                droplet.addAnimation("run",
                    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 13, true);
                droplet.scale.x = droplet.scale.y = .5 + Math.random() * .2;
                FlxG.state.add(droplet);
                droplet.play("run");
                this.droplets.push(droplet);
            }
        }

        private function setupSparkles():void {
            this.sparkles = new Array();
            var sparkle:GameObject;
            var sparkleDimensions:DHPoint;
            var sparkleImages:Array = [[ImgSparkle1, 10, new DHPoint(100, 100)],
                                       [ImgSparkle2, 9, new DHPoint(150, 150)],
                                       [ImgSparkle3, 13, new DHPoint(150, 150)]];
            var sparkleConfig:Array;
            var frames:Array, idx:Number;
            for (var i:int = 0; i < SPARKLES_COUNT; i++) {
                frames = new Array();
                idx = Math.floor(Math.random() * sparkleImages.length);
                sparkleConfig = sparkleImages[idx];
                sparkleDimensions = sparkleConfig[2];
                for (var k:int = 0; k < sparkleConfig[1]; k++) {
                    frames.push(k);
                }
                for (k = 0; k < 10; k++) {
                    frames.push(sparkleConfig[1]);
                }
                sparkle = new GameObject(new DHPoint(
                    Math.random() * (this.levelDimensions.x - sparkleDimensions.x),
                    Math.random() * (this.levelDimensions.y - sparkleDimensions.y)
                ));
                sparkle.loadGraphic(sparkleConfig[0],
                                    false, false,
                                    sparkleDimensions.x, sparkleDimensions.y);
                sparkle.addAnimation("run", frames, 13, true);
                sparkle.zSorted = true;
                sparkle.basePos = new DHPoint(sparkle.x, sparkle.y + sparkle.height);
                FlxG.state.add(sparkle);
                sparkle.play("run");
                this.sparkles.push(sparkle);
            }
        }

        override public function loadingScreenEndCallback():void {
            super.loadingScreenEndCallback();
        }

        public function firstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo1_2, GameState.SHORT_DIALOGUE ? 1 : 33*GameSound.MSEC_PER_SEC, this.delayShowFriendEmail, false, 1, GameSound.VOCAL,
                    CONVO_1_2_HALL
                );
        }

        public function delayShowFriendEmail():void {
            GlobalTimer.getInstance().setMark(SHOW_FIRST_POPUP, GameState.SHORT_DIALOGUE ? 1 : 10*GameSound.MSEC_PER_SEC, this.showFriendEmail);
        }

        public function showFriendEmail():void {
            this.doIfMinTeamPower(function():void {
                PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_1);
            }, 1);
        }

        public function showSelfiePostEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_SELFIE);
        }

        public function showFriendEmail2():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_2);
            this.bitDialogueLock = true;
        }

        public function showDredgeSelfie():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_DREDGE);
        }

        override public function startBoss():void {
            super.startBoss();
        }

        override public function update():void{
            super.update();
        }

        public function ichiMadEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.ANGRY);
        }

        public function ichiSadEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.SAD);
        }

        public function ichiHappyEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.HAPPY);
        }

        override public function playTimedEmotes(convoNum:Number):void {
            if(convoNum == 0) {
                GlobalTimer.getInstance().setMark("2nd Convo Emote", 31*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 1) {
                GlobalTimer.getInstance().setMark("3rd Convo Emote", 17*GameSound.MSEC_PER_SEC, this.ichiSadEmote);
            }
            if(convoNum == 2) {
                GlobalTimer.getInstance().setMark("4th Convo Emote", 11*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 5) {
                GlobalTimer.getInstance().setMark("5th Convo Emote", 22*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
        }

        public function playEndFilm():void {
            this.fadeOut(
                function():void {
                    FlxG.switchState(
                        new BlankScreen(4*GameSound.MSEC_PER_SEC,
                            function():void {
                                SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                                    false, 1, GameSound.BGM);
                                FlxG.switchState(new PlayVideoState(
                                    "/../assets/video/Phone Talk_v1.mp4",
                                    function():void {
                                        PopUpManager.GAME_ACTIVE = false;
                                        FlxG.switchState(new BlankScreen(
                                            11*GameSound.MSEC_PER_SEC,
                                            function():void {
                                                FlxG.switchState(new TextScreen(
                                                    5*GameSound.MSEC_PER_SEC,
                                                    function():void {
                                                        FlxG.switchState(new HiisiDesktop());
                                                    }, "August 10th, 2009"
                                                ));
                                            }
                                        ));
                                    }, null
                                ));
                            }
                        )
                    );
                },
                1 * GameSound.MSEC_PER_SEC,
                Euryale.BGM
            );
        }
    }
}
