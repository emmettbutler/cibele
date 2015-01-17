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

        private var convo1Sound:GameSound;

        public function Euryale() {
            PopUpManager.GAME_ACTIVE = true;
            this.ui_color_flag = GameState.UICOLOR_PINK;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo1, "len": 7*GameSound.MSEC_PER_SEC,
                },
                {
                    "audio": Convo1_2, "len": 27*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showFriendEmail
                },
                {
                    "audio": Convo2, "len": 40*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo2_2, "len": 17*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo2_3, "len": 46*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showFriendEmail2
                },
                {
                    "audio": Convo3, "len": 10*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo3_2, "len": 72*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo3_3, "len": 47*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": showDredgeSelfie
                },
                {
                    "audio": Convo4, "len": 85*GameSound.MSEC_PER_SEC,
                    "delay": 0
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

            GlobalTimer.getInstance().setMark("start euryale convo", 5*GameSound.MSEC_PER_SEC, this.playFirstConvo);

            super.create();
        }

        public function showFriendEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_1);
        }

        public function showFriendEmail2():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_2);
        }

        public function showDredgeSelfie():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_DREDGE);
        }

        override public function update():void{
            super.update();
        }

        public function ichiMadEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.ANGRY);
        }
    }
}
