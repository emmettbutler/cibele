package{
    import org.flixel.*;

    public class PopUpManager {
        [Embed(source="../assets/programs.png")] private var ImgPrograms:Class;
        [Embed(source="../assets/bulldoghell.png")] private var ImgBulldogHell:Class;
        [Embed(source="../assets/cib_selfies_1.png")] private var ImgCibSelfie1:Class;

        public static var _instance:PopUpManager = null;

        public var program_picker:FlxSprite = null;
        public var bulldog_hell:PopUp;
        public var cib_selfies_1:PopUp;

        public var popup_order:Array;
        public var next_popup:PopUp = null;
        public var open_popup_time:Number = 0;

        public static const SHOWING_POP_UP:Number = 0;
        public static const SHOWING_PROGRAM_PICKER:Number = 1;
        public static const SHOWING_NOTHING:Number = 2;
        public var _state:Number = 2;

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
        }

        public function update():void {
            if(this.debugText._textField == null) {
                loadPopUps();
                this.debugText = new FlxText(FlxG.mouse.x,FlxG.mouse.y,500,"");
                FlxG.state.add(this.debugText);
            }

            this.debugText.x = FlxG.mouse.x;
            this.debugText.y = FlxG.mouse.y-10;
            this.debugText.text = this._state.toString();

            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            this.program_picker.scrollFactor.x = 0;
            this.program_picker.scrollFactor.y = 0;

            if(this._state == SHOWING_NOTHING) {
                checkForNextPopUp();
            } else if(this._state == SHOWING_PROGRAM_PICKER) {
                showPopUp();
            } else if(this._state == SHOWING_POP_UP) {
                if(FlxG.mouse.justPressed()) {
                    this._state = SHOWING_NOTHING;
                    this.next_popup.shown = true;
                    this.next_popup.alpha = 0;
                    this.next_popup = null;
                }
            }
        }

        public function createNewPopUp(this_popup:Number):void {
            //this should get called in whatever state the pop ups
            //associated convo starts
            //don't forget to add new pop ups to loadpopups too! in order!
            if(this_popup == 1) {
                this.bulldog_hell = new PopUp(ImgBulldogHell, 1030, 510, 18000);
                this.popup_order.push(this.bulldog_hell);
                FlxG.state.add(bulldog_hell);
            }
            if(this_popup == 2) {
                this.cib_selfies_1 = new PopUp(ImgCibSelfie1, 645, 457, 165000, 1);
                this.popup_order.push(this.cib_selfies_1);
                FlxG.state.add(cib_selfies_1);
            }
        }

        public function loadPopUps():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.program_picker = new FlxSprite(_screen.screenWidth * .3, _screen.screenHeight * .3);
            this.program_picker.loadGraphic(ImgPrograms,false,false,500,132);
            this.program_picker.alpha = 0;
            FlxG.state.add(this.program_picker);

            for(i = 0; i < this.popup_order.length; i++) {
                if(i == 0) {
                    FlxG.state.add(bulldog_hell);
                }
                if(i == 1) {
                    FlxG.state.add(cib_selfies_1);
                }
            }
        }

        public function showProgramPicker(popup:PopUp):void {
            this.next_popup = popup;
            this.open_popup_time = this.timeAlive;
            this.program_picker.alpha = 1;
        }

        public function showPopUp():void {
            if(this.open_popup_time == 0) {
                this.next_popup.alpha = 1;
            } else if(this.next_popup.timeAlive >= this.open_popup_time+2000) {
                this._state = SHOWING_POP_UP;
                this.program_picker.alpha = 0;
                this.open_popup_time = 0;
                this.next_popup.alpha = 1;
            }
        }

        public function checkForNextPopUp():void {
            for(i = 0; i < popup_order.length; i++) {
                if(this.popup_order[i].timeAlive >= this.popup_order[i].timer && !this.popup_order[i].shown) {
                    this._state = SHOWING_PROGRAM_PICKER;
                    showProgramPicker(this.popup_order[i]);
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
