package{
    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PopUpManager {
        [Embed(source="../assets/UI_icon_game.png")] private var ImgGameButton:Class;
        [Embed(source="../assets/UI_icon_folder.png")] private var ImgFileButton:Class;
        [Embed(source="../assets/UI_icon_photo.png")] private var ImgPhotoButton:Class;
        [Embed(source="../assets/UI_icon_internet.png")] private var ImgInternetButton:Class;
        [Embed(source="../assets/UI_dock.png")] private var ImgDock:Class;
        [Embed(source="../assets/bulldoghell.png")] private var ImgBulldogHell:Class;
        [Embed(source="../assets/cib_selfies_1.png")] private var ImgCibSelfie1:Class;
        [Embed(source="../assets/forum_selfies_1.png")] private var ImgForumSelfie1:Class;
        [Embed(source="../assets/UI_happy face_blue.png")] private var ImgEmojiHappy:Class;
        [Embed(source="../assets/UI_Sad Face_blue.png")] private var ImgEmojiSad:Class;
        [Embed(source="../assets/UI_Angry face_blue.png")] private var ImgEmojiAngry:Class;
        [Embed(source="../assets/UI_Outer Ring.png")] private var ImgRing:Class;

        public static var _instance:PopUpManager = null;

        public var _player:Player;
        public var internet_button:DockButton = null;
        public var game_button:DockButton = null;
        public var file_button:DockButton = null;
        public var photo_button:DockButton = null;
        public var showEmoji:Boolean = true;

        private var emojiButtons:Dictionary;
        private var programButtons:Array;
        public var popups:Dictionary;
        public var popupTags:Object;

        public var elements:Array;
        public var cur_popup:PopUp = null, cur_tag:String = null;
        public var popup_active:Boolean = false;

        public static const BUTTON_INTERNET:String = "innernet";
        public static const BUTTON_PHOTO:String = "photototot";
        public static const BUTTON_FILES:String = "philesz";

        {
            public static const RING_INSET_X:Number = ScreenManager.getInstance().screenWidth * .03;
            public static const RING_INSET_Y:Number = ScreenManager.getInstance().screenHeight * .03;
        }

        public static const SHOWING_POP_UP:Number = 0;
        public static const SHOWING_NOTHING:Number = -699999999;
        public var _state:Number = SHOWING_NOTHING;
        public static const BULLDOG_HELL:String = "bulldoghell";
        public static const SELFIES_1:String = "selfies1";
        public static const FORUM_1:String = "forum1";

        // this text is used to detect when state elements have been destroyed
        // and need to be re-created. it is never displayed, but
        // flagText._textField == null indicates that destroy() was called on
        // the containing state
        public var flagText:FlxText;

        public function PopUpManager() {
            this.flagText = new FlxText(0, 0, 500, "");
            this.flagText._textField = null;
            FlxG.state.add(this.flagText);

            this.popupTags = {
                BUTTON_INTERNET: BULLDOG_HELL,
                BUTTON_FILES: null,
                BUTTON_PHOTO: SELFIES_1
            };
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y,
                                                      5, 5);
            this.emote(mouseScreenRect);

            var curButton:DockButton;
            for (var i:int = 0; i < this.programButtons.length; i++) {
                curButton = this.programButtons[i];
                if(this.overlaps(mouseScreenRect, curButton)) {
                    this._state = SHOWING_POP_UP;
                    curButton.open();
                }
            }

            if(this._state != SHOWING_POP_UP) {
            } else if(this._state == SHOWING_POP_UP) {
                this._state = SHOWING_NOTHING;
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
            if(this.flagText._textField == null) {
                this.loadPopUps();
                this.flagText = new FlxText(0, 0, 500, "");
                FlxG.state.add(this.flagText);
            }

            if(this._state == SHOWING_NOTHING) {
                if(this.cur_popup != null){
                    this.cur_popup.visible = false;
                }
            } else if(this._state == SHOWING_POP_UP) {
                this.popup_active = true;
            }
        }

        public function sendPopup(key:String):void {
            for (var i:int = 0; i < this.programButtons.length; i++) {
                if (this.programButtons[i].ownsKey(key)) {
                    this.programButtons[i].sendPopup(this.popups[key]);
                }
            }
        }

        public function loadPopUps():void {
            this.elements = new Array();
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.emojiButtons = new Dictionary();
            this.programButtons = new Array();

            var ring:UIElement = new UIElement(RING_INSET_X, RING_INSET_Y);
            ring.loadGraphic(ImgRing, false, false, 291, 300);
            ring.scrollFactor.x = 0;
            ring.scrollFactor.y = 0;
            this.elements.push(ring);
            if (this.showEmoji) {
                FlxG.state.add(ring);
            }

            var emoji_happy:UIElement = new UIElement(ring.x + 140, ring.y - 10);
            emoji_happy.loadGraphic(ImgEmojiHappy, false, false, 96, 98);
            if (this.showEmoji) {
                FlxG.state.add(emoji_happy);
            }
            emoji_happy.scrollFactor.x = 0;
            emoji_happy.scrollFactor.y = 0;
            this.elements.push(emoji_happy);
            emojiButtons[emoji_happy] = Emote.HAPPY;

            var emoji_sad:UIElement = new UIElement(ring.x + 205, ring.y + 90);
            emoji_sad.loadGraphic(ImgEmojiSad, false, false, 94, 99);
            if (this.showEmoji) {
                FlxG.state.add(emoji_sad);
            }
            emoji_sad.scrollFactor.x = 0;
            emoji_sad.scrollFactor.y = 0;
            this.elements.push(emoji_sad);
            this.emojiButtons[emoji_sad] = Emote.SAD;

            var emoji_angry:UIElement = new UIElement(ring.x + 140, ring.y + 200);
            emoji_angry.loadGraphic(ImgEmojiAngry, false, false, 100, 99);
            if (this.showEmoji) {
                FlxG.state.add(emoji_angry);
            }
            emoji_angry.scrollFactor.x = 0;
            emoji_angry.scrollFactor.y = 0;
            this.elements.push(emoji_angry);
            this.emojiButtons[emoji_angry] = Emote.ANGRY;

            var dockOffset:Number = 100;
            var dock:UIElement = new UIElement(
                -dockOffset, _screen.screenHeight - 71
            );
            dock.alpha = 1;
            dock.loadGraphic(ImgDock, false, false, 570, 52);
            dock.scrollFactor = new FlxPoint(0, 0);
            this.elements.push(dock);
            FlxG.state.add(dock);

            this.game_button = new DockButton(dock.x + dockOffset + 10, dock.y - 60, [], null);
            this.game_button.loadGraphic(ImgGameButton, false, false, 62, 95);
            this.game_button.alpha = 1;
            this.game_button.scrollFactor.x = 0;
            this.game_button.scrollFactor.y = 0;
            FlxG.state.add(this.game_button);
            this.elements.push(this.game_button);
            this.programButtons.push(this.game_button);

            this.internet_button = new DockButton(this.game_button.x+ this.game_button.width + 30, dock.y - 50, [BULLDOG_HELL, FORUM_1], BUTTON_INTERNET);
            this.internet_button.loadGraphic(ImgInternetButton, false, false, 88, 75);
            this.internet_button.alpha = 1;
            this.internet_button.scrollFactor.x = 0;
            this.internet_button.scrollFactor.y = 0;
            FlxG.state.add(this.internet_button);
            this.elements.push(this.internet_button);
            this.programButtons.push(this.internet_button);

            this.file_button = new DockButton(this.internet_button.x + this.internet_button.width + 30, dock.y - 30, [], BUTTON_FILES);
            this.file_button.loadGraphic(ImgFileButton, false, false, 88, 60);
            this.file_button.alpha = 1;
            this.file_button.scrollFactor.x = 0;
            this.file_button.scrollFactor.y = 0;
            FlxG.state.add(this.file_button);
            this.elements.push(this.file_button);
            this.programButtons.push(this.file_button);

            this.photo_button = new DockButton(this.file_button.x + this.file_button.width + 30, dock.y - 25, [SELFIES_1], BUTTON_PHOTO);
            this.photo_button.loadGraphic(ImgPhotoButton, false, false, 82, 65);
            this.photo_button.alpha = 1;
            this.photo_button.scrollFactor.x = 0;
            this.photo_button.scrollFactor.y = 0;
            FlxG.state.add(this.photo_button);
            this.elements.push(this.photo_button);
            this.programButtons.push(this.photo_button);

            this.popups = new Dictionary();
            this.popups[BULLDOG_HELL] = new PopUp(ImgBulldogHell, 1030, 510, 0, BULLDOG_HELL);
            this.popups[SELFIES_1] = new PopUp(ImgCibSelfie1, 645, 457, PopUp.ARROW_THROUGH, SELFIES_1);
            this.popups[FORUM_1] = new PopUp(ImgForumSelfie1, 1174, 585, 0, FORUM_1);

            var curButton:DockButton;
            for (var i:int = 0; i < this.programButtons.length; i++){
                curButton = this.programButtons[i];
                curButton.setCurPopup(this.popups[this.popupTags[curButton.tag]]);
            }

            for (var key:Object in this.popups) {
                this.elements.push(this.popups[key]);
                FlxG.state.add(this.popups[key]);
            }
        }

        public function emote(mouseScreenRect:FlxRect):void {
            var overlap:Boolean, element:UIElement;
            for (var key:Object in this.emojiButtons) {
                element = key as UIElement;
                overlap = mouseScreenRect.overlaps(
                    new FlxRect(element.x, element.y, element.width,
                                element.height)
                );
                if (overlap) {
                    new Emote(_player.pos, this.emojiButtons[key]);
                }
            }
        }

        public static function getInstance():PopUpManager {
            if (_instance == null) {
                _instance = new PopUpManager();
            }
            return _instance;
        }
    }
}
