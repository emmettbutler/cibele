package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class LoadingScreen {
        [Embed(source="/../assets/images/ui/loading_icon.png")] private var ImgLoadingIcon:Class;
        [Embed(source="/../assets/images/ui/loading_text.png")] private var ImgLoadingText:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_cibsoslow.mp3")] private var CibSlow:Class;

        public var loading_icon:GameObject;
        public var loading_text:GameObject;
        public var bg:GameObject;
        public var showing:Boolean = false;
        public var endCallback:Function;

        public function LoadingScreen(len:Number=3, play_dialogue:Boolean=true) {
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.bg = new GameObject(new DHPoint(0,0));
            this.bg.makeGraphic(_screen.screenWidth, _screen.screenHeight, 0xff000000);
            this.bg.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.bg);
            this.bg.visible = true;

            this.loading_icon = new GameObject(new DHPoint(40, _screen.screenHeight * .8));
            this.loading_icon.loadGraphic(ImgLoadingIcon, false, false, 76, 120);
            this.loading_icon.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.loading_icon);
            this.loading_icon.visible = true;

            this.loading_text = new GameObject(new DHPoint(130, _screen.screenHeight * .86));
            this.loading_text.loadGraphic(ImgLoadingText, false, false, 160, 27);
            this.loading_text.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.loading_text);
            this.loading_text.visible = true;

            GlobalTimer.getInstance().setMark("deactivate loading screen", len*GameSound.MSEC_PER_SEC, this.deactivate, true);
            if(play_dialogue && len > 3) {
                GlobalTimer.getInstance().setMark("say slow", 4*GameSound.MSEC_PER_SEC, this.slowDialogue, true);
            }

            this.showing = true;
        }

        public function update():void {
        }

        public function slowDialogue():void {
            SoundManager.getInstance().playSound(
                CibSlow, 3*GameSound.MSEC_PER_SEC, null,
                false, 1, GameSound.VOCAL
            );
        }

        public function deactivate():void {
            this.showing = false;
            this.bg.visible = false;
            this.loading_icon.visible = false;
            this.loading_text.visible = false;
            FlxG.state.remove(this.loading_text);
            if (this.endCallback != null) {
                this.endCallback();
            }
        }
    }
}
