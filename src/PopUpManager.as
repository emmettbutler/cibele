package{
    import org.flixel.*;

    public class PopUpManager {
        [Embed(source="../assets/programpanel.png")] private var ImgPrograms:Class;
        [Embed(source="../assets/bulldoghell.png")] private var ImgBulldogHell:Class;
        [Embed(source="../assets/cib_selfies_1.png")] private var ImgCibSelfie1:Class;
        [Embed(source="../assets/forum_selfies_1.png")] private var ImgForumSelfie1:Class;

        public static var _instance:PopUpManager = null;

        public var program_picker:FlxSprite = null;
        public var bulldog_hell:PopUp;
        public var cib_selfies_1:PopUp;
        public var forum_selfies_1:PopUp;
        public var blinker:FlxSprite;

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

        public function PopUpManager() {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;

            this.popup_order = new Array();

            loadPopUps();
            this.debugText = new FlxText(FlxG.mouse.x,FlxG.mouse.y,500,"");
            FlxG.state.add(this.debugText);

            this.program_picker.scrollFactor = new FlxPoint(0, 0);
        }

        public function update():void {
            if(this.debugText._textField == null) {
                loadPopUps();
                this.debugText = new FlxText(FlxG.mouse.x,FlxG.mouse.y,500,"");
                FlxG.state.add(this.debugText);
            }

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
            } else if(this._state == FLASH_PROGRAM_PICKER) {
                showBlinker();
            } else if(this._state == SHOWING_POP_UP) {
                if(FlxG.mouse.justPressed()) {
                    this._state = SHOWING_NOTHING;
                    this.next_popup.shown = true;
                    this.next_popup.alpha = 0;
                    this.next_popup = null;
                    this.open_popup_time = 1000;
                }
            }
        }

        public function createNewPopUp(this_popup:Number):void {
            //this should get called in whatever state the pop ups
            //associated convo starts
            //don't forget to add new pop ups to loadpopups too! in order!
            if(this_popup == 1) {
                //18000
                this.bulldog_hell = new PopUp(ImgBulldogHell, 1030, 510, 1000);
                this.popup_order.push(this.bulldog_hell);
                FlxG.state.add(bulldog_hell);
            }
            if(this_popup == 2) {
                //165000
                this.cib_selfies_1 = new PopUp(ImgCibSelfie1, 645, 457, 5000, 1);
                this.popup_order.push(this.cib_selfies_1);
                FlxG.state.add(cib_selfies_1);
            }
            if(this_popup == 3) {
                //185000
                this.forum_selfies_1 = new PopUp(ImgForumSelfie1, 1174, 585, 10000);
                this.popup_order.push(this.forum_selfies_1);
                FlxG.state.add(forum_selfies_1);
            }
        }

        public function loadPopUps():void {
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.blinker = new FlxSprite(0,0);
            this.blinker.makeGraphic(20,20,0xffff0000);
            FlxG.state.add(this.blinker);
            this.blinker.alpha = 0;

            this.program_picker = new FlxSprite(_screen.screenWidth * .01, _screen.screenHeight * .7);
            this.program_picker.loadGraphic(ImgPrograms,false,false,150,28);
            this.program_picker.alpha = 1;
            FlxG.state.add(this.program_picker);

            this.blinker.x = program_picker.x;
            this.blinker.y = program_picker.y;

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
        }

        public function showBlinker():void {
            this.blinker.alpha = 1;
            if(FlxG.mouse.justReleased()) {
                this.blinker.alpha = 0;
                this.next_popup.alpha = 1;
                this._state = SHOWING_POP_UP;
            }
        }

        public function checkForNextPopUp():void {
            for(i = 0; i < popup_order.length; i++) {
                if(this.popup_order[i].timeAlive >= this.popup_order[i].timer && !this.popup_order[i].shown) {
                    this._state = FLASH_PROGRAM_PICKER;
                    this.next_popup = this.popup_order[i];
                    this.open_popup_time = this.timeAlive;
                    break;
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
