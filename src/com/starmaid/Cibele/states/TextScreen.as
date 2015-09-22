package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class TextScreen extends GameState {
        public var endCallback:Function;
        public var endTime:Number;
        public var bg:GameObject;

        private var textSpr:FlxText;
        private var textString:String;

        public function TextScreen(end_timer:Number, end_callback:Function,
                                   txt:String)
        {
            super(false,false,false);
            this.endCallback = end_callback;
            this.endTime = end_timer;
            this.textString = txt;
            this.hide_cursor_on_unpause = true;

            GlobalTimer.getInstance().setMark(
                "deactivate blank screen " + (Math.random() * 1000000),
                this.endTime, this.endCallback, true);
        }

        override public function create():void {
            super.create();
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.bg = new GameObject(new DHPoint(0,0));
            this.bg.makeGraphic(_screen.screenWidth, _screen.screenHeight, 0xff000000);
            this.bg.scrollFactor = new FlxPoint(0,0);
            this.bg.visible = true;
            this.add(this.bg);

            var textWidth:Number = _screen.screenWidth * .7;
            var _textHeight:Number = 34;
            this.textSpr = new FlxText(
                _screen.screenWidth / 2 - textWidth / 2,
                _screen.screenHeight / 2 - _textHeight,
                textWidth, this.textString
            );
            this.textSpr.visible = true;
            this.textSpr.scrollFactor = new DHPoint(0, 0);
            this.textSpr.setFormat("NexaBold-Regular", 44, 0xffffffff, "center");
            this.add(this.textSpr);

            this.updatePopup = false;
            this.updateMessages = false;
            this.use_loading_screen = false;

            super.postCreate();

            this.game_cursor.hide();
        }

        override public function update():void {
            super.update();
        }
    }
}
