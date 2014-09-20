package{
    import org.flixel.*;

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
        public var bulldog_hell:PopUp;
        public var cib_selfies_1:PopUp;
        public var forum_selfies_1:PopUp;
        public var blinker:UIElement;
        public var blinker_rect:FlxRect;

        public var popup_order:Array;
        public var next_popup:PopUp = null;
        public var open_popup_time:Number = 0;

        public static const SHOWING_POP_UP:Number = 0;
        public static const FLASH_PROGRAM_PICKER:Number = 1;
        public static const SHOWING_NOTHING:Number = -699999999;
        public var _state:Number = SHOWING_NOTHING;

        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public var debugText:FlxText;
        public var i:Number = 0;

        public var mouse_rect:FlxRect;
        public var blink:Boolean = false;

        public var emoji_happy:UIElement;
        public var emoji_sad:UIElement;
        public var emoji_angry:UIElement;
        public var emoji_happy_rect:FlxRect;
        public var emoji_sad_rect:FlxRect;
        public var emoji_angry_rect:FlxRect;

        public var elements:Array;
        public var ui_loaded:Boolean = false;

        public function PopUpManager() {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
            this.popup_order = new Array();
            this.elements = new Array();

            this.loadPopUps();

            for(var i:int = 1; i <= 3; i++) {
                this.createNewPopUp(i);
            }

            this.debugText = new FlxText(FlxG.mouse.x,FlxG.mouse.y,500,"");
            FlxG.state.add(this.debugText);
        }

        public function update():void {
            if(this.debugText._textField == null) {
                ui_loaded = false;
                loadPopUps();
                this.debugText = new FlxText(FlxG.mouse.x,FlxG.mouse.y,500,"");
                FlxG.state.add(this.debugText);
                ui_loaded = true;
            }
            this.mouse_rect.x = FlxG.mouse.screenX;
            this.mouse_rect.y = FlxG.mouse.screenY;

            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if(this._state == SHOWING_NOTHING) {
                //do this check in case it's already time for the next popup
                //bc if it is, that popup will open immediately which is bad
                if(this.open_popup_time > 0) {
                    this.open_popup_time--;
                } else {
                    checkForNextPopUp();
                }

                if(this.next_popup != null){
                    this.next_popup.visible = false;
                }

                if(mouse_rect.overlaps(this.blinker_rect) && FlxG.mouse.justPressed()) {
                    this.next_popup.shown = true;
                    this.next_popup.visible = true;
                    this.open_popup_time = 1000;
                    this._state = SHOWING_POP_UP
                }

                this.emote();
            } else if(this._state == FLASH_PROGRAM_PICKER) {
                if(this.next_popup.shown){
                    this._state = SHOWING_NOTHING;
                }
                showBlinker();
                this.emote();
                if(mouse_rect.overlaps(this.blinker_rect) && FlxG.mouse.justPressed()) {
                    this.blinker.alpha = 0;
                    this.next_popup.shown = true;
                    this.next_popup.visible = true;
                    this._state = SHOWING_POP_UP;
                }
            } else if(this._state == SHOWING_POP_UP) {
                if(FlxG.mouse.justPressed()) {
                    this._state = SHOWING_NOTHING;
                    this.open_popup_time = 1000;
                }
            }
        }

        public function createNewPopUp(this_popup:Number):void {
            //this should get called in whatever state the pop ups
            //associated convo starts
            //don't forget to add new pop ups to loadpopups too! in order!
            if(this_popup == 1) {
                this.bulldog_hell = new PopUp(ImgBulldogHell, 1030, 510, 1);
                this.popup_order.push(this.bulldog_hell);
                this.elements.push(this.bulldog_hell);
            }
            if(this_popup == 2) {
                //165000
                this.cib_selfies_1 = new PopUp(ImgCibSelfie1, 645, 457, 165000, 1000);
                this.popup_order.push(this.cib_selfies_1);
                this.elements.push(this.cib_selfies_1);
            }
            if(this_popup == 3) {
                //185000
                this.forum_selfies_1 = new PopUp(ImgForumSelfie1, 1174, 585, 185000);
                this.popup_order.push(this.forum_selfies_1);
                this.elements.push(this.forum_selfies_1);
            }
        }

        public function loadPopUps():void {
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.emoji_happy = new UIElement(_screen.screenWidth * .7, _screen.screenWidth * .01);
            this.emoji_happy.loadGraphic(ImgEmojiHappy,false,false,85,45);
            FlxG.state.add(emoji_happy);
            this.emoji_happy_rect = new FlxRect(this.emoji_happy.x, this.emoji_happy.y, this.emoji_happy.width, this.emoji_happy.height);
            this.emoji_happy.scrollFactor.x = 0;
            this.emoji_happy.scrollFactor.y = 0;
            this.elements.push(this.emoji_happy);

            this.emoji_sad = new UIElement(_screen.screenWidth * .8, _screen.screenWidth * .01);
            this.emoji_sad.loadGraphic(ImgEmojiSad,false,false,71,45);
            FlxG.state.add(emoji_sad);
            this.emoji_sad_rect = new FlxRect(this.emoji_sad.x, this.emoji_sad.y, this.emoji_sad.width, this.emoji_sad.height);
            this.emoji_sad.scrollFactor.x = 0;
            this.emoji_sad.scrollFactor.y = 0;
            this.elements.push(this.emoji_sad);

            this.emoji_angry = new UIElement(_screen.screenWidth * .9, _screen.screenWidth * .01);
            this.emoji_angry.loadGraphic(ImgEmojiAngry,false,false,93,45);
            FlxG.state.add(emoji_angry);
            this.emoji_angry_rect = new FlxRect(this.emoji_angry.x, this.emoji_angry.y, this.emoji_angry.width, this.emoji_angry.height);
            this.emoji_angry.scrollFactor.x = 0;
            this.emoji_angry.scrollFactor.y = 0;
            this.elements.push(this.emoji_angry);

            this.blinker = new UIElement(0,0);
            this.blinker.makeGraphic(227,43,0xffff0000);
            FlxG.state.add(this.blinker);
            this.blinker.alpha = 0;
            this.blinker.scrollFactor.x = 0;
            this.blinker.scrollFactor.y = 0;
            this.elements.push(this.blinker);

            this.mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,5,5);

            this.program_picker = new UIElement(_screen.screenWidth * .001, _screen.screenHeight * .9);
            this.program_picker.loadGraphic(ImgPrograms,false,false,227,43);
            this.program_picker.alpha = 1;
            this.program_picker.scrollFactor.x = 0;
            this.program_picker.scrollFactor.y = 0;
            FlxG.state.add(this.program_picker);
            this.elements.push(this.program_picker);

            this.blinker.x = program_picker.x;
            this.blinker.y = program_picker.y;
            this.blinker_rect = new FlxRect(blinker.x,blinker.y,program_picker.width,program_picker.height);

            for(i = 0; i < this.popup_order.length; i++) {
                if(i == 0) {
                    FlxG.state.add(bulldog_hell);
                }
                if(i == 1) {
                    FlxG.state.add(cib_selfies_1);
                }
                if(i == 2) {
                    FlxG.state.add(forum_selfies_1);
                }
            }
            this.ui_loaded = true;
            checkForNextPopUp();
        }

        public function showBlinker():void {
            if(this.blinker.alpha == 1) {
                this.blink = false;
            } else if(this.blinker.alpha == 0) {
                this.blink = true;
            }
            if(this.blink) {
                this.blinker.alpha += .1;
            } else {
                this.blinker.alpha -= .1;
            }
        }

        public function checkForNextPopUp():void {
            for(i = 0; i < popup_order.length; i++) {
                if(this.popup_order[i].timeAlive >= this.popup_order[i].timer && !this.popup_order[i].shown) {
                    if(this.next_popup != null && !this.next_popup.shown){
                        this._state = FLASH_PROGRAM_PICKER;
                    }
                    this.next_popup = this.popup_order[i];
                    break;
                }
            }
        }

        public function emote():void {
            if(FlxG.mouse.justPressed()){
                if(this.mouse_rect.overlaps(emoji_happy_rect)) {
                    new Emote(_player.pos, Emote.HAPPY);
                }
                if(this.mouse_rect.overlaps(emoji_sad_rect)) {
                    new Emote(_player.pos, Emote.SAD);
                }
                if(this.mouse_rect.overlaps(emoji_angry_rect)) {
                    new Emote(_player.pos, Emote.ANGRY);
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
