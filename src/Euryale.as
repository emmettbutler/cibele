package{
    import org.flixel.*;
    import flash.events.*;

    public class Euryale extends LevelMapState {
        [Embed(source="../assets/voc_euryale_hey.mp3")] private var Convo1:Class;
        [Embed(source="../assets/voc_euryale_teleport.mp3")] private var Convo1_2:Class;
        [Embed(source="../assets/voc_euryale_breakups.mp3")] private var Convo2:Class;
        [Embed(source="../assets/voc_euryale_nada.mp3")] private var Convo2_2:Class;
        [Embed(source="../assets/voc_euryale_callmeblake.mp3")] private var Convo2_3:Class;
        [Embed(source="../assets/voc_euryale_closer.mp3")] private var Convo3:Class;
        [Embed(source="../assets/voc_euryale_meetup.mp3")] private var Convo3_2:Class;
        [Embed(source="../assets/voc_euryale_parents.mp3")] private var Convo3_3:Class;
        [Embed(source="../assets/voc_euryale_dredge.mp3")] private var Convo4:Class;

        private var conversationPieces:Array;
        private var conversationCounter:Number = 0;

        public function Euryale() {
            PopUpManager.GAME_ACTIVE = true;
            this.ui_color_flag = GameState.UICOLOR_PINK;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo1, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.playTeleportConvo
                },
                {
                    "audio": Convo2, "len": 40*GameSound.MSEC_PER_SEC,
                    "delay": 20*GameSound.MSEC_PER_SEC,
                    "endfn": this.playNadaConvo
                },
                {
                    "audio": Convo3, "len": 40*GameSound.MSEC_PER_SEC,
                    "delay": 10*GameSound.MSEC_PER_SEC,
                    "endfn": null
                }
            ];
        }

        override public function create():void {
            this.filename = null;
            this.mapTilePrefix = "euryale";
            this.tileGridDimensions = new DHPoint(6, 3);
            this.estTileDimensions = new DHPoint(2266, 1365);
            this.playerStartPos = new DHPoint(2266*3 - 500, 1365*6 - 500);
            this.colliderScaleFactor = 3.54;

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                GlobalTimer.getInstance().setMark("First Convo", 2*GameSound.MSEC_PER_SEC, this.startConvo);
            }

            super.create();
        }

        public function playTeleportConvo():void {
            SoundManager.getInstance().playSound(Convo1_2, 27, this.showFriendEmail, false, 1, GameSound.VOCAL);
        }

        public function playNadaConvo():void {
            SoundManager.getInstance().playSound(Convo2_2, 17, this.playCallMeBlakeConvo, false, 1, GameSound.VOCAL);
        }

        public function playCallMeBlakeConvo():void {
            SoundManager.getInstance().playSound(Convo2_3, 46, this.showFriendEmail2, false, 1, GameSound.VOCAL);
        }

        public function playMeetupConvo():void {
            SoundManager.getInstance().playSound(Convo3_2, 72, this.playParentsConvo, false, 1, GameSound.VOCAL);
        }

        public function playParentsConvo():void {
            SoundManager.getInstance().playSound(Convo3_3, 47, this.showDredgeSelfie, false, 1, GameSound.VOCAL);
        }

        public function showFriendEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_1);
        }

        public function showFriendEmail2():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_2);
        }

        public function showDredgeSelfie():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_1);
        }

        override public function update():void{
            super.update();
        }

        public function playNextConvoPiece():void {
            var thisAudioInfo:Object = this.conversationPieces[this.conversationCounter];
            if (thisAudioInfo["endfn"] != null) {
                thisAudioInfo["endfn"]();
            }
            this.conversationCounter += 1;
            var that:Euryale = this;
            var nextAudioInfo:Object = this.conversationPieces[this.conversationCounter];
            if (nextAudioInfo != null) {
                this.addEventListener(GameState.EVENT_POPUP_CLOSED,
                    function(event:DataEvent):void {
                        SoundManager.getInstance().playSound(
                            nextAudioInfo["audio"], nextAudioInfo["len"],
                            that.playNextConvoPiece, false, 1, GameSound.VOCAL
                        );
                        that.playTimedEmotes(that.conversationCounter);
                        if(that.conversationPieces.length == that.conversationCounter + 1) {
                            that.last_convo_playing = true;
                        }
                        FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                       arguments.callee);
                    });
            } else {
                //GlobalTimer.getInstance().setMark("Boss Kill", 5*GameSound.MSEC_PER_SEC, this.ichiBossKill);
            }
        }
    }
}
