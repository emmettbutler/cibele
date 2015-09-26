package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.entities.IkuTursoBoss;
    import com.starmaid.Cibele.entities.MapNode;
    import com.starmaid.Cibele.states.BlankScreen;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        [Embed(source="/../assets/audio/music/bgm_ikuturso_intro.mp3")] private var ITBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_ikuturso_loop.mp3")] private var ITBGMLoop:Class;
        [Embed(source="/../assets/audio/music/vid_sexyselfie.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_bulldog.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_ampule.mp3")] private var Convo2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_photogenic.mp3")] private var Convo3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_attractive.mp3")] private var Convo4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_picture.mp3")] private var Convo5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_whattowear.mp3")] private var Convo6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichilasthit.mp3")] private var IchiBossKill:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_yeahsorry.mp3")] private var SndYeahSorry:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_areyoucoming.mp3")] private var SndRUComing:Class;
        [Embed(source="/../assets/images/worlds/bubbles_1.png")] private var ImgBubbles:Class;
        [Embed(source="/../assets/images/worlds/seaweed1.png")] private var ImgSeaweed1:Class;
        [Embed(source="/../assets/images/worlds/seaweed2.png")] private var ImgSeaweed2:Class;

        private var convo1Sound:GameSound;
        private var convo1Ready:Boolean;
        private var bubbles:Array, seaweeds:Array;

        public static var BGM:String = "ikuturso bgm loop";
        public static const BUBBLES_COUNT:Number = 45;
        public static const SEAWEEDS_COUNT:Number = 33;

        public function IkuTurso() {
            PopUpManager.GAME_ACTIVE = true;
            this.load_screen_text = "Iku Turso";
            this.ui_color_flag = GameState.UICOLOR_PINK;
            this.teamPowerBossThresholds = [6, 15];

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo1, "len": 59*GameSound.MSEC_PER_SEC,
                    "delay": 0, "ends_with_popup": false
                },
                {
                    "audio": null, "len": 4*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showIchiDownloadWindow, "min_team_power": 5
                },
                {
                    "audio": Convo2, "len": 80*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 4*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showSelfiesWindow, "min_team_power": 10
                },
                {
                    "audio": Convo3, "len": 27*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showGuilEmail
                },
                {
                    "audio": Convo4, "len": 108*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 2*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showIchiSelfie1, "min_team_power": 20
                },
                {
                    "audio": Convo5, "len": 16*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 8*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showCibSelfieFolder, "min_team_power": 22
                },
                {
                    "audio": Convo6, "len": 32 * GameSound.MSEC_PER_SEC, "delay": 0, "min_team_power": 25
                },
                {
                    "audio": null, "len": 1*GameSound.MSEC_PER_SEC,
                    "delay": 0, "boss_gate": true
                },
                {
                    "audio": null, "len": 3*GameSound.MSEC_PER_SEC, "endfn": playEndDialogue
                }
            ];
        }

        override public function create():void {
            this.filename = "data/ikuturso_path.txt";
            this.graph_filename = "data/ikuturso_graph.txt";
            this.mapTilePrefix = "ikuturso";
            this.tileGridDimensions = new DHPoint(10, 5);
            this.estTileDimensions = new DHPoint(1359, 818);  // 1360, 816
            this.playerStartPos = new DHPoint(4600, 7565);
            this.colliderScaleFactor = 8.65;
            this.enemyDirMultiplier = 1;
            this.maxTeamPower = 25;

            super.create();
            function _bgmCallback():void {
                SoundManager.getInstance().playSound(ITBGMLoop, 0, null, true, .08, GameSound.BGM, IkuTurso.BGM, false, false);
            }
            SoundManager.getInstance().playSound(ITBGMIntro, 3.6*GameSound.MSEC_PER_SEC, _bgmCallback, false, .08, Math.random()*928+298, IkuTurso.BGM, false, false, true);
            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                GlobalTimer.getInstance().setMark("First Convo", GameState.SHORT_DIALOGUE ? 1 : 7*GameSound.MSEC_PER_SEC, this.bulldogHellPopup);
            }
            this.convo1Sound = null;

            if (ScreenManager.getInstance().QUICK_LEVELS) {
                GlobalTimer.getInstance().setMark(
                    "end_level_it",
                    10 * GameSound.MSEC_PER_SEC,
                    this.playEndFilm
                )
            }
        }

        override public function destroy():void {
            this.bubbles = null;
            this.seaweeds = null;
            super.destroy();
        }

        override public function addEnvironmentDetails():void {
            this.setupBubbles();
            this.setupSeaweed();
        }

        override public function postPathRead():void {
            var randNode:MapNode;
            var seaweed:GameObject;
            var usedNodes:Array = new Array();
            for (var i:int = 0; i < this.seaweeds.length; i++) {
                randNode = this._mapnodes.getRandomNode();
                while (usedNodes.indexOf(randNode) != -1) {
                    randNode = this._mapnodes.getRandomNode();
                }
                seaweed = this.seaweeds[i];
                seaweed.setPos(randNode.pos.sub(new DHPoint(
                                                seaweed.width / 2,
                                                seaweed.height)));
                seaweed.basePos = new DHPoint(seaweed.x, seaweed.y + seaweed.height);
                usedNodes.push(randNode);
            }
        }

        private function setupSeaweed():void {
            this.seaweeds = new Array();
            var rand:Number;
            var seaweed:GameObject;
            for (var i:int = 0; i < SEAWEEDS_COUNT; i++) {
                rand = Math.floor(Math.random() * 2);
                seaweed = new GameObject(new DHPoint(0, 0));
                switch (rand) {
                    case 0:
                        seaweed.loadGraphic(ImgSeaweed1, false, false, 100, 200);
                        seaweed.addAnimation("run",
                            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 13, true);
                        break;
                    default:
                        seaweed.loadGraphic(ImgSeaweed2, false, false, 132, 150);
                        seaweed.addAnimation("run",
                            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 13, true);
                        break;
                }
                seaweed.zSorted = true;
                FlxG.state.add(seaweed);
                seaweed.play("run");
                this.seaweeds.push(seaweed);
            }
        }

        private function setupBubbles():void {
            this.bubbles = new Array();
            var bubble:GameObject;
            var bubblesDimensions:DHPoint = new DHPoint(130, 300);
            for (var i:int = 0; i < BUBBLES_COUNT; i++) {
                bubble = new GameObject(new DHPoint(
                    Math.random() * (this.levelDimensions.x - bubblesDimensions.x),
                    Math.random() * (this.levelDimensions.y - bubblesDimensions.y)
                ));
                bubble.loadGraphic(ImgBubbles, false, false,
                                   bubblesDimensions.x, bubblesDimensions.y);
                bubble.addAnimation("run",
                    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 13, true);
                bubble.zSorted = true;
                bubble.basePos = new DHPoint(bubble.x, bubble.y + bubble.height);
                FlxG.state.add(bubble);
                bubble.play("run");
                this.bubbles.push(bubble);
            }
        }

        public function bulldogHellPopup():void {
            var that:IkuTurso = this;
            this.doIfMinTeamPower(function():void {
                PopUpManager.getInstance().sendPopup(PopUpManager.BULLDOG_HELL);
                GlobalTimer.getInstance().setMark("First Emote", 5*GameSound.MSEC_PER_SEC, that.ichiStartEmote);
                that.addEventListener(GameState.EVENT_POPUP_CLOSED,
                        function(event:DataEvent):void {
                            if(event.userData['tag'] == PopUpManager.BULLDOG_HELL) {
                                that.playRUComing();
                            }
                            FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                           arguments.callee);
                    });
            }, 1);
        }

        public function ichiStartEmote():void {
            if (pathWalker == null) {
                return;
            }
            if(pathWalker.inViewOfPlayer()) {
                PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.HAPPY);
            } else {
                GlobalTimer.getInstance().setMark("First Emote", 3*GameSound.MSEC_PER_SEC, this.ichiStartEmote, true);
            }
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

        public function showSelfiesWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.SELFIES_1);
        }

        public function showGuilEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.GUIL_1);
        }

        public function showIchiDownloadWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.ICHI_PICLY_1);
        }

        public function showIchiSelfie1():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.ICHI_SELFIE1);
        }

        public function showCibSelfieFolder():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.CIB_SELFIE_FOLDER);
        }

        public function playEndDialogue():void {
            this.bitDialogueLock = true;
            SoundManager.getInstance().playSound(
                IchiBossKill, 3*GameSound.MSEC_PER_SEC, this.playEndFilm,
                false, 1, GameSound.VOCAL);
        }

        public function playEndFilm():void {
            this.fadeOut(
                function():void {
                    SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                        false, 1, GameSound.BGM);
                    FlxG.switchState(
                        new PlayVideoState("/../assets/video/sexy_selfie.flv",
                            function():void {
                                PopUpManager.GAME_ACTIVE = false;
                                FlxG.switchState(new BlankScreen(
                                    4*GameSound.MSEC_PER_SEC,
                                    function():void {
                                        FlxG.switchState(new TextScreen(5*GameSound.MSEC_PER_SEC,
                                        function():void {
                                            FlxG.switchState(new EuryaleDesktop());
                                        }, "April 13th, 2009"
                                        ));
                                    }
                                ));
                            }, SoundManager.getInstance().getSoundByName(BGM)
                        )
                    );
                },
                1 * GameSound.MSEC_PER_SEC
            );
        }

        override public function playTimedEmotes(convoNum:Number):void {
            if(convoNum == 1) {
                GlobalTimer.getInstance().setMark("2nd Convo Emote", 13*GameSound.MSEC_PER_SEC, this.ichiMadEmote);
            }
            if(convoNum == 2) {
                GlobalTimer.getInstance().setMark("3rd Convo Emote", 9*GameSound.MSEC_PER_SEC, this.ichiSadEmote);
            }
            if(convoNum == 3) {
                GlobalTimer.getInstance().setMark("4th Convo Emote", 22*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 4) {
                GlobalTimer.getInstance().setMark("5th Convo Emote", 7*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 5) {
                GlobalTimer.getInstance().setMark("6th Convo Emote", 14*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
        }

        public function playRUComing():void {
            SoundManager.getInstance().playSound(
                SndRUComing, GameSound.MSEC_PER_SEC * 3, this.playYeahSorry,
                false, 1, GameSound.VOCAL
            );
        }

        public function playYeahSorry():void {
            SoundManager.getInstance().playSound(
                SndYeahSorry, GameSound.MSEC_PER_SEC * 2, this.playFirstConvo,
                false, 1, GameSound.VOCAL
            );
        }

        override public function update():void{
            super.update();
            var snd:GameSound = SoundManager.getInstance().getSoundByName(Hallway.BGM);
            if(snd != null) {
                snd.fadeOutSound();
                snd.fading = true;
            }
        }
    }
}
