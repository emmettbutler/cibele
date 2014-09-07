package{
    import org.flixel.*;

    public class PopUpManager {
        [Embed(source="../assets/programs.png")] private var ImgPrograms:Class;
        [Embed(source="../assets/bulldoghell.png")] private var ImgBulldogHell:Class;

        public static var _instance:PopUpManager = null;

        public var program_picker:FlxSprite;
        public var bulldog_hell:PopUp;

        public var popup_order:Array;
        public var next_popup:PopUp = null;
        public var open_popup_time:Number = 0;

        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public var debugText:FlxText;

        public function PopUpManager() {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;

            var _screen:ScreenManager = ScreenManager.getInstance();

            program_picker = new FlxSprite(_screen.screenWidth * .3, _screen.screenHeight * .3);
            program_picker.loadGraphic(ImgPrograms,false,false,500,132);
            FlxG.state.add(program_picker);
            program_picker.alpha = 0;

            bulldog_hell = new PopUp(ImgBulldogHell, 1030, 510, 5000);
            popup_order = new Array();
            popup_order.push(bulldog_hell);

            debugText = new FlxText(FlxG.mouse.x,FlxG.mouse.y,500,"");
            FlxG.state.add(debugText);
        }

        public function update():void {
            debugText.x = FlxG.mouse.x;
            debugText.y = FlxG.mouse.y;
            //debugText.text = timeAlive.toString();

            SoundManager.getInstance().update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if(next_popup == null){
                for(var i:Number = 0; i < popup_order.length; i++) {
                    if(this.timeAlive >= popup_order[i].timer && !popup_order[i].shown) {
                        showNextPopUp(popup_order[i]);
                    }
                }
            }

            if(next_popup != null) {
                if(this.timeAlive >= open_popup_time+2000) {
                    program_picker.alpha = 0;
                    next_popup.alpha = 1;
                }
                if(FlxG.mouse.justPressed()) {
                    next_popup.shown = true;
                    next_popup.alpha = 0;
                    next_popup = null;
                    open_popup_time = 0;
                }
            }
        }

        public function showNextPopUp(popup:PopUp):void {
            next_popup = popup;
            open_popup_time = this.timeAlive;
            program_picker.alpha = 1;
        }

        public static function getInstance():PopUpManager {
            if (_instance == null) {
                _instance = new PopUpManager();
            }
            return _instance;
        }
    }
}