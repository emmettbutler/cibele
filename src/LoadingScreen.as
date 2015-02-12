package{
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class LoadingScreen extends GameObject{
        [Embed(source="../assets/images/ui/loading_icon.png")] private var ImgLoadingIcon:Class;
        [Embed(source="../assets/images/ui/loading_text.png")] private var ImgLoadingText:Class;

        public var loading_icon:GameObject;
        public var loading_text:GameObject;
        public var bg:GameObject;
        public var fade_up:Boolean = false;
        public var showing:Boolean = false;

        public function LoadingScreen() {
            super(new DHPoint(0,0));
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.bg = new GameObject(new DHPoint(0,0));
            this.bg.makeGraphic(_screen.screenWidth, _screen.screenHeight, 0xff000000);
            this.bg.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.bg);
            this.bg.visible = true;

            this.loading_icon = new GameObject(new DHPoint(_screen.screenWidth * .01, _screen.screenHeight * .8));
            this.loading_icon.loadGraphic(ImgLoadingIcon, false, false, 76, 120);
            this.loading_icon.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.loading_icon);
            this.loading_icon.visible = true;

            this.loading_text = new GameObject(new DHPoint(_screen.screenWidth * .08, _screen.screenHeight * .86));
            this.loading_text.loadGraphic(ImgLoadingText, false, false, 160, 27);
            this.loading_text.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.loading_text);
            this.loading_text.visible = true;

            GlobalTimer.getInstance().setMark("deactivate loading screen", 3*GameSound.MSEC_PER_SEC, this.deactivate, true);

            this.showing = true;
        }

        override public function update():void {
            if(this.showing) {
                if(this.loading_text.alpha == 0) {
                    fade_up = true;
                } else if(this.loading_text.alpha == 1) {
                    fade_up = false;
                }
                if(this.fade_up) {
                    this.loading_text.alpha += .01;
                } else {
                    this.loading_text.alpha -= .01;
                }
            }
        }

        public function deactivate():void {
            this.showing = false;
            this.bg.visible = false;
            this.loading_icon.visible = false;
            this.loading_text.visible = false;
        }
    }
}
