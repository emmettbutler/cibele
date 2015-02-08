package{
    import org.flixel.*;

    import flash.events.Event;
    import flash.utils.Dictionary;

    public class PopUpManager {
        [Embed(source="../assets/audio/effects/sfx_notification.mp3")] private var SfxNotification:Class;
        [Embed(source="../assets/images/ui/UI_icon_game.png")] private var ImgGameButton:Class;
        [Embed(source="../assets/images/ui/UI_icon_folder.png")] private var ImgFileButton:Class;
        [Embed(source="../assets/images/ui/UI_icon_photo.png")] private var ImgPhotoButton:Class;
        [Embed(source="../assets/images/ui/UI_icon_internet.png")] private var ImgInternetButton:Class;
        [Embed(source="../assets/images/ui/UI_dock.png")] private var ImgDock:Class;
        [Embed(source="../assets/images/ui/popups/picly/nina1.png")] private var ImgCibSelfie1:Class;
        [Embed(source="../assets/images/ui/popups/it_email/guil1.png")] private var ImgGuilEmail1:Class;
        [Embed(source="../assets/images/ui/UI_happy face_blue.png")] private var ImgEmojiHappy:Class;
        [Embed(source="../assets/images/ui/UI_Sad Face_blue.png")] private var ImgEmojiSad:Class;
        [Embed(source="../assets/images/ui/UI_Angry face_blue.png")] private var ImgEmojiAngry:Class;
        [Embed(source="../assets/images/ui/UI_Outer Ring.png")] private var ImgRing:Class;
        [Embed(source="../assets/images/ui/UI_Outer_Ring_pink.png")] private var ImgRingPink:Class;
        [Embed(source="../assets/images/ui/popups/it_email/ichiselfieemail1.png")] private var ImgIchiSelfie1:Class;
        [Embed(source="../assets/images/ui/popups/files/camera1disconnect.png")] private var ImgCibCamDisconnect:Class;
        [Embed(source="../assets/images/ui/UI_happy_face_pink.png")] private var ImgEmojiHappyPink:Class;
        [Embed(source="../assets/images/ui/UI_sad_face_pink.png")] private var ImgEmojiSadPink:Class;
        [Embed(source="../assets/images/ui/UI_Angry_face_pink.png")] private var ImgEmojiAngryPink:Class;
        [Embed(source="../assets/images/ui/popups/ichidownloads.png")] private var ImgIchiDL2:Class;
        [Embed(source="../assets/images/ui/popups/it_email/none.png")] private var ImgEmptyInbox:Class;
        [Embed(source="../assets/images/ui/popups/picly/ninaopen.png")] private var ImgForIchi:Class;
        [Embed(source="../assets/images/ui/popups/it_email/bulldoghell_email.png")] private static var ImgBHEmail:Class;
        [Embed(source="../assets/images/ui/popups/picly/emmy1.png")] private static var ImgIchiPicly1:Class;

        //euryale popups
        [Embed(source="../assets/images/ui/popups/eu_email/email1.png")] private static var ImgEuEmail1:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/emailselfie.png")] private static var ImgEuEmailSelfie:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/email2.png")] private static var ImgEuEmail2:Class;
        [Embed(source="../assets/images/ui/popups/eu_picly/dredgeirl.png")] private static var ImgEuDredge:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/highschool.png")] private static var ImgEuHighSchool:Class;

        public static var _instance:PopUpManager = null;

        public var _player:Player;
        public var internet_button:DockButton = null;
        public var game_button:DockButton = null;
        public var file_button:DockButton = null;
        public var photo_button:DockButton = null;

        private var emojiButtons:Dictionary;
        private var programButtons:Array, sentPopups:Dictionary;
        public var popups:Dictionary;
        public var popupTags:Object;

        public var elements:Array;
        public var folder_structure:Object;
        public var folder_builder:FolderBuilder;

        public static const BUTTON_INTERNET:String = "innernet";
        public static const BUTTON_PHOTO:String = "photototot";
        public static const BUTTON_FILES:String = "philesz";
        public static const BUTTON_GAME:String = "gamez";

        public var open_popups:Array;

        {
            public static const RING_INSET_X:Number = ScreenManager.getInstance().screenWidth * .03;
            public static const RING_INSET_Y:Number = ScreenManager.getInstance().screenHeight * .03;
        }

        public static const SHOWING_POP_UP:Number = 0;
        public static const SHOWING_NOTHING:Number = -699999999;
        public var _state:Number = SHOWING_NOTHING;

        //set this to false again if player exits game screen
        public static var GAME_ACTIVE:Boolean = false;
        public var reminder_ding:Boolean = false;

        //ikuturso
        public static const BULLDOG_HELL:String = "bulldoghell";
        public static const SELFIES_1:String = "selfies1";
        public static const GUIL_1:String = "forum1";
        public static const ICHI_PICLY_1:String = "ichidownload";
        public static const ICHI_SELFIE1:String = "ichiselfie1";
        public static const CIB_SELFIE_FOLDER:String = "cibselfiefolder";
        public static const EMPTY_INBOX:String = "marm";
        public static const FOR_ICHI:String = "ichiluvu";
        public static const ICHI_DL_2:String = "dl2";

        //euryale
        public static const EU_EMAIL_1:String = "euemail1";
        public static const EU_EMAIL_SELFIE:String = "euemailselfie";
        public static const EU_EMAIL_2:String = "euemail2";
        public static const EU_DREDGE:String = "eudredge";
        public static const EU_HIGHSCHOOL:String = "euhighschool";

        public function PopUpManager() {
            this.elements = new Array();
            this.sentPopups = new Dictionary();
            this.open_popups = new Array();

            this.popupTags = {};
            this.popupTags[BUTTON_INTERNET] = EMPTY_INBOX;
            this.popupTags[BUTTON_FILES] = ICHI_DL_2;
            this.popupTags[BUTTON_PHOTO] = FOR_ICHI;
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y,
                                                      5, 5);
            var i:Number = 0;
            this.emote(mouseScreenRect, _player);

            for(var key:Object in this.folder_structure) {
                var _val:Object = this.folder_structure[key];
                this.folder_builder.resolveClick(_val, mouseScreenRect);
            }

            var curButton:DockButton;
            var curPopup:PopUp;
            for (i = 0; i < this.programButtons.length; i++) {
                curButton = this.programButtons[i];
                if(this.overlaps(mouseScreenRect, curButton)) {
                    if(curButton.tag == BUTTON_GAME) {
                        curButton.toggleGame();
                    } else {
                        curButton.open();
                        curPopup = curButton.getCurPopup();
                        this._state = SHOWING_POP_UP;
                        this.open_popups.push(curPopup);
                        if(folder_structure[curPopup.tag] != null) {
                            this.folder_builder.setIconVisibility(this.folder_structure[curPopup.tag], true);
                        }
                        this.deleteSentPopup(curButton.cur_popup_tag);
                    }
                }
            }

            for(i = 0; i < this.open_popups.length; i++) {
                if(this.open_popups[i] != null) {
                    if(mouseScreenRect.overlaps(this.open_popups[i].x_sprite._getRect())) {
                        this._state = SHOWING_NOTHING;
                        if(!this.open_popups[i].was_opened) {
                            this.open_popups[i].was_opened = true;
                            FlxG.stage.dispatchEvent(new DataEvent(GameState.EVENT_POPUP_CLOSED, {'tag': this.open_popups[i].tag}));
                        }
                        if(folder_structure[this.open_popups[i].tag] != null) {
                            this.folder_builder.setIconVisibility(this.folder_structure[this.open_popups[i].tag], false);
                        }
                        for (var k:Number = 0; k < this.programButtons.length; k++) {
                            curButton = this.programButtons[k];
                            if(curButton.getCurPopup() != null) {
                                if(curButton.getCurPopup() == this.open_popups[i]) {
                                    curButton.getCurPopup().visible = false;
                                } else {
                                    this.open_popups[i].visible = false;
                                }
                            }
                        }
                        this.open_popups[i] = null;
                    }
                }
            }
        }

        public function deleteSentPopup(tag:String):void {
            var toDelete:Object;
            for (var key:Object in this.sentPopups) {
                if ((key as String) == tag) {
                    toDelete = key;
                }
            }
            if (toDelete != null) {
                delete this.sentPopups[toDelete];
                this.reminder_ding = false;
            }
        }

        public function overlaps(mouseScreenRect:FlxRect, button:DockButton):Boolean {
            var overlap:Boolean = mouseScreenRect.overlaps(
                new FlxRect(button.x, button.y, button.width,
                            button.height)
            );
            if (overlap) {
                return true;
            }
            return false;
        }

        public function update():void {
        }

        public function sendPopup(key:String):void {
            for (var i:int = 0; i < this.programButtons.length; i++) {
                if (this.programButtons[i].ownsKey(key)) {
                    this.programButtons[i].sendPopup(this.popups[key]);
                    this.sentPopups[key] = 1;
                    this.reminder_ding = true;
                    GlobalTimer.getInstance().setMark("new popup", 10*GameSound.MSEC_PER_SEC, this.reminderDing);
                }
            }
        }

        public function reminderDing():void {
            if(this.reminder_ding) {
                playNotificationSound();
                GlobalTimer.getInstance().setMark("new popup", 10*GameSound.MSEC_PER_SEC, this.reminderDing);
            }
        }

        public function playNotificationSound():void {
            SoundManager.getInstance().playSound(
                    SfxNotification, 2*GameSound.MSEC_PER_SEC, null, false, 1, GameSound.SFX,
                    "" + Math.random()
                );
        }

        public function loadEmoji():void {
            this.emojiButtons = new Dictionary();
            this.elements.length = 0;
            var imgClass:Class, imgSize:DHPoint;

            imgClass = ImgRing;
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK) {
                imgClass = ImgRingPink;
            }
            var ring:UIElement = new UIElement(RING_INSET_X, RING_INSET_Y);
            ring.loadGraphic(imgClass, false, false, 291, 300);
            ring.scrollFactor.x = 0;
            ring.scrollFactor.y = 0;
            this.elements.push(ring);
            FlxG.state.add(ring);

            imgClass = ImgEmojiHappy;
            imgSize = new DHPoint(96, 98);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgEmojiHappyPink;
                imgSize = new DHPoint(100, 99);
            }
            var emoji_happy:UIElement = new UIElement(ring.x + 140, ring.y - 10);
            emoji_happy.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            FlxG.state.add(emoji_happy);
            emoji_happy.scrollFactor.x = 0;
            emoji_happy.scrollFactor.y = 0;
            this.elements.push(emoji_happy);
            emojiButtons[Emote.HAPPY] = emoji_happy;

            imgClass = ImgEmojiSad;
            imgSize = new DHPoint(94, 99);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgEmojiSadPink;
                imgSize = new DHPoint(100, 99);
            }
            var emoji_sad:UIElement = new UIElement(ring.x + 205, ring.y + 90);
            emoji_sad.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            FlxG.state.add(emoji_sad);
            emoji_sad.scrollFactor.x = 0;
            emoji_sad.scrollFactor.y = 0;
            this.elements.push(emoji_sad);
            this.emojiButtons[Emote.SAD] = emoji_sad;

            imgClass = ImgEmojiAngry;
            imgSize = new DHPoint(100, 99);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgEmojiAngryPink;
            }
            var emoji_angry:UIElement = new UIElement(ring.x + 140, ring.y + 200);
            emoji_angry.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            FlxG.state.add(emoji_angry);
            emoji_angry.scrollFactor.x = 0;
            emoji_angry.scrollFactor.y = 0;
            this.elements.push(emoji_angry);
            this.emojiButtons[Emote.ANGRY] = emoji_angry;
        }

        public function loadPopUps():void {
            var imgClass:Class;
            var imgSize:DHPoint;

            var _screen:ScreenManager = ScreenManager.getInstance();

            this.programButtons = new Array();

            var dockOffset:Number = 100;
            var dock:UIElement = new UIElement(
                -dockOffset, _screen.screenHeight - 71
            );
            dock.alpha = 1;
            dock.loadGraphic(ImgDock, false, false, 570, 52);
            dock.scrollFactor = new FlxPoint(0, 0);
            this.elements.push(dock);
            FlxG.state.add(dock);

            this.game_button = new DockButton(
                dock.x + dockOffset + 10, dock.y - 60, [], BUTTON_GAME);
            this.game_button.loadGraphic(ImgGameButton, false, false, 62, 95);
            this.game_button.alpha = 1;
            this.game_button.scrollFactor.x = 0;
            this.game_button.scrollFactor.y = 0;
            FlxG.state.add(this.game_button);
            this.elements.push(this.game_button);
            this.programButtons.push(this.game_button);

            this.internet_button = new DockButton(
                this.game_button.x + this.game_button.width + 30,
                dock.y - 50, [BULLDOG_HELL, GUIL_1, ICHI_SELFIE1, EU_EMAIL_1, EU_EMAIL_SELFIE, EU_EMAIL_2], BUTTON_INTERNET);
            this.internet_button.loadGraphic(ImgInternetButton, false, false,
                                             88, 75);
            this.internet_button.alpha = 1;
            this.internet_button.scrollFactor.x = 0;
            this.internet_button.scrollFactor.y = 0;
            FlxG.state.add(this.internet_button);
            this.elements.push(this.internet_button);
            this.programButtons.push(this.internet_button);

            this.file_button = new DockButton(this.internet_button.x + this.internet_button.width + 30, dock.y - 30, [CIB_SELFIE_FOLDER, EU_HIGHSCHOOL], BUTTON_FILES);
            this.file_button.loadGraphic(ImgFileButton, false, false, 88, 60);
            this.file_button.alpha = 1;
            this.file_button.scrollFactor.x = 0;
            this.file_button.scrollFactor.y = 0;
            FlxG.state.add(this.file_button);
            this.elements.push(this.file_button);
            this.programButtons.push(this.file_button);

            this.photo_button = new DockButton(
                this.file_button.x + this.file_button.width + 30,
                dock.y - 25, [ICHI_PICLY_1 , SELFIES_1, EU_DREDGE], BUTTON_PHOTO);
            this.photo_button.loadGraphic(ImgPhotoButton, false, false, 82, 65);
            this.photo_button.alpha = 1;
            this.photo_button.scrollFactor.x = 0;
            this.photo_button.scrollFactor.y = 0;
            FlxG.state.add(this.photo_button);
            this.elements.push(this.photo_button);
            this.programButtons.push(this.photo_button);

            this.popups = new Dictionary();
            //ikuturso
            this.popups[EMPTY_INBOX] = new PopUp(ImgEmptyInbox, 631, 356, 0, EMPTY_INBOX);
            this.popups[EMPTY_INBOX].was_opened = true;
            this.popups[FOR_ICHI] = new PopUp(ImgForIchi, 356, 463, 0, FOR_ICHI);
            this.popups[FOR_ICHI].was_opened = true;
            this.popups[ICHI_DL_2] = new PopUp(ImgIchiDL2, 631, 356, 0, ICHI_DL_2);
            this.popups[ICHI_DL_2].was_opened = true;
            this.popups[ICHI_PICLY_1] = new PopUp(ImgIchiPicly1, 356, 463, 0, ICHI_PICLY_1);
            this.popups[SELFIES_1] = new PopUp(ImgCibSelfie1, 356, 463, PopUp.CLICK_THROUGH, SELFIES_1);
            this.popups[GUIL_1] = new PopUp(ImgGuilEmail1, 631, 356, 0, GUIL_1);
            this.popups[BULLDOG_HELL] = new PopUp(ImgBHEmail, 631, 356, 0, BULLDOG_HELL);
            this.popups[ICHI_SELFIE1] = new PopUp(ImgIchiSelfie1, 631, 356, 0, ICHI_SELFIE1);
            this.popups[CIB_SELFIE_FOLDER] = new PopUp(ImgCibCamDisconnect, 253, 107, 0, CIB_SELFIE_FOLDER);

            //euryale
            this.popups[EU_EMAIL_1] = new PopUp(ImgEuEmail1, 631, 356, 0, EU_EMAIL_1);
            this.popups[EU_EMAIL_SELFIE] = new PopUp(ImgEuEmailSelfie, 631, 356, 0, EU_EMAIL_SELFIE);
            this.popups[EU_EMAIL_2] = new PopUp(ImgEuEmail2, 631, 356, 0, EU_EMAIL_2);
            this.popups[EU_DREDGE] = new PopUp(ImgEuDredge, 356, 463, 0, EU_DREDGE);
            this.popups[EU_HIGHSCHOOL] = new PopUp(ImgEuHighSchool, 631, 356, 0, EU_HIGHSCHOOL);

            var curButton:DockButton;
            for (var i:int = 0; i < this.programButtons.length; i++){
                curButton = this.programButtons[i];
                curButton.setCurPopup(this.popups[this.popupTags[curButton.tag]]);
            }

            this.folder_structure = PopupHierarchies.build();
            this.folder_builder = new FolderBuilder();

            for (var key:Object in this.popups) {
                this.elements.push(this.popups[key]);
                this.elements.push(this.popups[key].x_sprite);
                FlxG.state.add(this.popups[key]);
                FlxG.state.add(this.popups[key].x_sprite);
                if(this.folder_structure[key] != null) {
                    this.folder_builder.populateFolders(this.folder_structure[key], this.elements, this.popups[key]);
                }
            }

            this.folder_builder.setUpLeafPopups(this.elements);

            for (key in this.sentPopups) {
                this.sendPopup(key as String);
            }
        }

        public function emote(mouseScreenRect:FlxRect, char:PartyMember, procedural:Boolean=false, em:Number=111):void {
            if(procedural) {
                new Emote(new DHPoint(char.pos.x + (char.width/4), char.pos.y), em,
                                  (FlxG.state as GameState).ui_color_flag);
            } else {
                var overlap:Boolean, element:UIElement, mood:Number;
                for (var k:Object in this.emojiButtons) {
                    element = this.emojiButtons[k] as UIElement;
                    mood = k as Number;
                    overlap = mouseScreenRect.overlaps(
                        new FlxRect(element.x, element.y, element.width,
                                    element.height)
                    );
                    if (overlap) {
                        new Emote(new DHPoint(char.pos.x + (char.width/4), char.pos.y), mood,
                                  (FlxG.state as GameState).ui_color_flag);
                    }
                }
            }
        }

        public function showingPopup():Boolean {
            if(this._state == SHOWING_POP_UP) {
                return true;
            } else {
                return false;
            }
        }

        public function setOpeningPopups(internet:String, files:String, photo:String):void {
            this.popupTags[BUTTON_INTERNET] = internet;
            this.popupTags[BUTTON_FILES] = files;
            this.popupTags[BUTTON_PHOTO] = photo;
        }

        public static function getInstance():PopUpManager {
            if (_instance == null) {
                _instance = new PopUpManager();
            }
            return _instance;
        }
    }
}
