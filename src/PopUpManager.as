package{
    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PopUpManager {
        [Embed(source="../assets/programpanel.png")] private var ImgPrograms:Class;
        [Embed(source="../assets/bulldoghell.png")] private var ImgBulldogHell:Class;
        [Embed(source="../assets/cib_selfies_1.png")] private var ImgCibSelfie1:Class;
        [Embed(source="../assets/forum_selfies_1.png")] private var ImgForumSelfie1:Class;
        [Embed(source="../assets/happy_emoji.png")] private var ImgEmojiHappy:Class;
        [Embed(source="../assets/sad_emoji.png")] private var ImgEmojiSad:Class;
        [Embed(source="../assets/angry_emoji.png")] private var ImgEmojiAngry:Class;

        public static var _instance:PopUpManager = null;

        public var _player:Player;
        public var program_picker:UIElement = null;
        public var blinker:UIElement;

        private var emojiButtons:Dictionary;

        public var popup_order:Array;
        public var next_popup:PopUp = null;

        private static const CLOSED_POPUP:String = "closed_popup";
        public static const SHOWING_POP_UP:Number = 0;
        public static const FLASH_PROGRAM_PICKER:Number = 1;
        public static const SHOWING_NOTHING:Number = -699999999;
        public var _state:Number = SHOWING_NOTHING;

        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;

        // this text is used to detect when state elements have been destroyed
        // and need to be re-created. it is never displayed, but
        // flagText._textField == null indicates that destroy() was called on
        // the containing state
        public var flagText:FlxText;

        public var elements:Array;

        public function PopUpManager() {
            this.bornTime = new Date().valueOf();

            this.popup_order = new Array();
            this.elements = new Array();

            this.loadPopUps();

            this.flagText = new FlxText(0, 0, 500, "");
            FlxG.state.add(this.flagText);
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y,
                                                      5, 5);
            this.emote(mouseScreenRect);

            var blinker_rect:FlxRect = new FlxRect(blinker.x, blinker.y,
                                                   program_picker.width,
                                                   program_picker.height);

            if(this._state == SHOWING_NOTHING) {
                if(mouseScreenRect.overlaps(blinker_rect)) {
                    this.next_popup.shown = true;
                    this.next_popup.visible = true;
                    GlobalTimer.getInstance().setMark(CLOSED_POPUP,
                                                      GameSound.MSEC_PER_SEC);
                    this._state = SHOWING_POP_UP
                }
            } else if(this._state == FLASH_PROGRAM_PICKER) {
                if(mouseScreenRect.overlaps(blinker_rect)) {
                    this.blinker.alpha = 0;
                    this.next_popup.shown = true;
                    this.next_popup.visible = true;
                    this._state = SHOWING_POP_UP;
                }
            } else if(this._state == SHOWING_POP_UP) {
                this._state = SHOWING_NOTHING;
                GlobalTimer.getInstance().setMark(CLOSED_POPUP,
                                                  GameSound.MSEC_PER_SEC);
            }
        }

        public function update():void {
            if(this.flagText._textField == null) {
                this.loadPopUps();
                this.flagText = new FlxText(0, 0, 500, "");
                FlxG.state.add(this.flagText);
            }

            this.timeAlive = new Date().valueOf() - this.bornTime;

            if(this._state == SHOWING_NOTHING) {
                //do this check in case it's already time for the next popup
                //bc if it is, that popup will open immediately which is bad
                if (GlobalTimer.getInstance().hasPassed(CLOSED_POPUP)) {
                    this.checkForNextPopUp();
                }
                if(this.next_popup != null){
                    this.next_popup.visible = false;
                }
            } else if(this._state == FLASH_PROGRAM_PICKER) {
                if(this.next_popup.shown){
                    this._state = SHOWING_NOTHING;
                }
                if(this.blinker.alpha >= 1) {
                    this.blinker.alpha -= .1;
                } else if(this.blinker.alpha <= 0) {
                    this.blinker.alpha += .1;
                }
            }
        }

        public function loadPopUps():void {
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.emojiButtons = new Dictionary();

            var emoji_happy:UIElement = new UIElement(_screen.screenWidth * .7,
                                                      _screen.screenWidth * .01);
            emoji_happy.loadGraphic(ImgEmojiHappy,false,false,85,45);
            FlxG.state.add(emoji_happy);
            emoji_happy.scrollFactor.x = 0;
            emoji_happy.scrollFactor.y = 0;
            this.elements.push(emoji_happy);
            emojiButtons[emoji_happy] = Emote.HAPPY;

            var emoji_sad:UIElement = new UIElement(_screen.screenWidth * .8,
                                                    _screen.screenWidth * .01);
            emoji_sad.loadGraphic(ImgEmojiSad,false,false,71,45);
            FlxG.state.add(emoji_sad);
            emoji_sad.scrollFactor.x = 0;
            emoji_sad.scrollFactor.y = 0;
            this.elements.push(emoji_sad);
            this.emojiButtons[emoji_sad] = Emote.SAD;

            var emoji_angry:UIElement = new UIElement(_screen.screenWidth * .9,
                                                      _screen.screenWidth * .01);
            emoji_angry.loadGraphic(ImgEmojiAngry,false,false,93,45);
            FlxG.state.add(emoji_angry);
            emoji_angry.scrollFactor.x = 0;
            emoji_angry.scrollFactor.y = 0;
            this.elements.push(emoji_angry);
            this.emojiButtons[emoji_angry] = Emote.ANGRY;

            this.blinker = new UIElement(0,0);
            this.blinker.makeGraphic(227,43,0xffff0000);
            FlxG.state.add(this.blinker);
            this.blinker.alpha = 0;
            this.blinker.scrollFactor.x = 0;
            this.blinker.scrollFactor.y = 0;
            this.elements.push(this.blinker);

            this.program_picker = new UIElement(_screen.screenWidth * .001,
                                                _screen.screenHeight * .9);
            this.program_picker.loadGraphic(ImgPrograms,false,false,227,43);
            this.program_picker.alpha = 1;
            this.program_picker.scrollFactor.x = 0;
            this.program_picker.scrollFactor.y = 0;
            FlxG.state.add(this.program_picker);
            this.elements.push(this.program_picker);

            this.blinker.x = program_picker.x;
            this.blinker.y = program_picker.y;

            this.popup_order = [
                new PopUp(ImgBulldogHell, 1030, 510, 1),
                new PopUp(ImgCibSelfie1, 645, 457, 165000, 1000),
                new PopUp(ImgForumSelfie1, 1174, 585, 185000)
            ];
            for (var i:int = 0; i < this.popup_order.length; i++) {
                this.elements.push(this.popup_order[i]);
                FlxG.state.add(this.popup_order[i]);
            }

            this.checkForNextPopUp();
        }

        public function checkForNextPopUp():void {
            for(var i:int = 0; i < popup_order.length; i++) {
                if(this.popup_order[i].timeAlive >= this.popup_order[i].timer &&
                   !this.popup_order[i].shown)
                {
                    if(this.next_popup != null && !this.next_popup.shown){
                        this._state = FLASH_PROGRAM_PICKER;
                    }
                    this.next_popup = this.popup_order[i];
                    break;
                }
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
