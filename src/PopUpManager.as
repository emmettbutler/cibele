package{
    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PopUpManager {
        [Embed(source="../assets/game_button.png")] private var ImgGameButton:Class;
        [Embed(source="../assets/file_button.png")] private var ImgFileButton:Class;
        [Embed(source="../assets/photo_button.png")] private var ImgPhotoButton:Class;
        [Embed(source="../assets/internet_button.png")] private var ImgInternetButton:Class;
        [Embed(source="../assets/bulldoghell.png")] private var ImgBulldogHell:Class;
        [Embed(source="../assets/cib_selfies_1.png")] private var ImgCibSelfie1:Class;
        [Embed(source="../assets/forum_selfies_1.png")] private var ImgForumSelfie1:Class;
        [Embed(source="../assets/happy_emoji.png")] private var ImgEmojiHappy:Class;
        [Embed(source="../assets/sad_emoji.png")] private var ImgEmojiSad:Class;
        [Embed(source="../assets/angry_emoji.png")] private var ImgEmojiAngry:Class;

        public static var _instance:PopUpManager = null;

        public var _player:Player;
        public var internet_button:UIElement = null;
        public var game_button:UIElement = null;
        public var file_button:UIElement = null;
        public var photo_button:UIElement = null;
        public var blinker:UIElement;

        private var emojiButtons:Dictionary;
        private var programButtons:Dictionary;
        public var popups:Dictionary;

        public var elements:Array;
        public var next_popup:PopUp = null;
        public var popup_active:Boolean = false;

        private static const CLOSED_POPUP:String = "closed_popup";
        public static const SHOWING_POP_UP:Number = 0;
        public static const FLASH_PROGRAM_PICKER:Number = 1;
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
            this.loadPopUps();
            this.flagText = new FlxText(0, 0, 500, "");
            FlxG.state.add(this.flagText);
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y,
                                                      5, 5);
            this.emote(mouseScreenRect);

            if(this._state == SHOWING_NOTHING) {
                if(this.programPicker(mouseScreenRect)) {
                    if (this.next_popup != null) {
                        this.next_popup.shown = true;
                        this.next_popup.visible = true;
                        GlobalTimer.getInstance().setMark(CLOSED_POPUP,
                                                        GameSound.MSEC_PER_SEC);
                        this._state = SHOWING_POP_UP
                    }
                }
            } else if(this._state == FLASH_PROGRAM_PICKER) {
                if(this.programPicker(mouseScreenRect)) {
                    if (this.next_popup != null) {
                        this.blinker.alpha = 0;
                        this.next_popup.shown = true;
                        this.next_popup.visible = true;
                        this._state = SHOWING_POP_UP;
                    }
                }
            } else if(this._state == SHOWING_POP_UP) {
                this._state = SHOWING_NOTHING;
            }
        }

        public function programPicker(mouseScreenRect:FlxRect):Boolean {
            var overlap:Boolean, element:UIElement;
            for (var key:Object in this.programButtons) {
                element = key as UIElement;
                overlap = mouseScreenRect.overlaps(
                    new FlxRect(element.x, element.y, element.width,
                                element.height)
                );
                if (overlap) {
                    return true;
                    break;
                }
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
                if(this.next_popup != null){
                    this.next_popup.visible = false;
                }
            } else if(this._state == FLASH_PROGRAM_PICKER) {
                this.blinker.alpha = Math.sin(.1 *
                    GlobalTimer.getInstance().pausingTimer());
            } else if(this._state == SHOWING_POP_UP) {
                this.popup_active = true;
            }
        }

        public function sendPopup(key:String):void {
            this._state = FLASH_PROGRAM_PICKER;
            this.next_popup = this.popups[key];
        }

        public function loadPopUps():void {
            this.elements = new Array();
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.emojiButtons = new Dictionary();
            this.programButtons = new Dictionary();

            var emoji_happy:UIElement = new UIElement(_screen.screenWidth * .2,
                                                _screen.screenHeight * .01);
            emoji_happy.loadGraphic(ImgEmojiHappy,false,false,85,45);
            FlxG.state.add(emoji_happy);
            emoji_happy.scrollFactor.x = 0;
            emoji_happy.scrollFactor.y = 0;
            this.elements.push(emoji_happy);
            emojiButtons[emoji_happy] = Emote.HAPPY;

            var emoji_sad:UIElement = new UIElement(_screen.screenWidth * .27,
                                                _screen.screenHeight * .01);
            emoji_sad.loadGraphic(ImgEmojiSad,false,false,71,45);
            FlxG.state.add(emoji_sad);
            emoji_sad.scrollFactor.x = 0;
            emoji_sad.scrollFactor.y = 0;
            this.elements.push(emoji_sad);
            this.emojiButtons[emoji_sad] = Emote.SAD;

            var emoji_angry:UIElement = new UIElement(_screen.screenWidth * .32,
                                                _screen.screenHeight * .01);
            emoji_angry.loadGraphic(ImgEmojiAngry,false,false,93,45);
            FlxG.state.add(emoji_angry);
            emoji_angry.scrollFactor.x = 0;
            emoji_angry.scrollFactor.y = 0;
            this.elements.push(emoji_angry);
            this.emojiButtons[emoji_angry] = Emote.ANGRY;

            this.blinker = new UIElement(0,0);
            this.blinker.makeGraphic(237,43,0xffff0000);
            FlxG.state.add(this.blinker);
            this.blinker.alpha = 0;
            this.blinker.scrollFactor.x = 0;
            this.blinker.scrollFactor.y = 0;
            this.elements.push(this.blinker);

            this.game_button = new UIElement(_screen.screenWidth * .4,
                                                _screen.screenHeight * .94);
            this.game_button.loadGraphic(ImgGameButton,false,false,62,43);
            this.game_button.alpha = 1;
            this.game_button.scrollFactor.x = 0;
            this.game_button.scrollFactor.y = 0;
            FlxG.state.add(this.game_button);
            this.elements.push(this.game_button);
            this.programButtons[this.game_button] = 1111;

            this.internet_button = new UIElement(_screen.screenWidth * .45,
                                                _screen.screenHeight * .94);
            this.internet_button.loadGraphic(ImgInternetButton,false,false,52,43);
            this.internet_button.alpha = 1;
            this.internet_button.scrollFactor.x = 0;
            this.internet_button.scrollFactor.y = 0;
            FlxG.state.add(this.internet_button);
            this.elements.push(this.internet_button);
            this.programButtons[this.internet_button] = 1112;

            this.file_button = new UIElement(_screen.screenWidth * .5,
                                                _screen.screenHeight * .94);
            this.file_button.loadGraphic(ImgFileButton,false,false,54,43);
            this.file_button.alpha = 1;
            this.file_button.scrollFactor.x = 0;
            this.file_button.scrollFactor.y = 0;
            FlxG.state.add(this.file_button);
            this.elements.push(this.file_button);
            this.programButtons[this.file_button] = 1113;

            this.photo_button = new UIElement(_screen.screenWidth * .55,
                                                _screen.screenHeight * .94);
            this.photo_button.loadGraphic(ImgPhotoButton,false,false,44,43);
            this.photo_button.alpha = 1;
            this.photo_button.scrollFactor.x = 0;
            this.photo_button.scrollFactor.y = 0;
            FlxG.state.add(this.photo_button);
            this.elements.push(this.photo_button);
            this.programButtons[this.photo_button] = 1114;

            this.blinker.x = game_button.x;
            this.blinker.y = game_button.y;

            this.popups = new Dictionary();
            this.popups[BULLDOG_HELL] = new PopUp(ImgBulldogHell, 1030, 510, 1);
            this.popups[SELFIES_1] = new PopUp(ImgCibSelfie1, 645, 457, 165000, PopUp.ARROW_THROUGH);
            this.popups[FORUM_1] = new PopUp(ImgForumSelfie1, 1174, 585, 185000);

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
