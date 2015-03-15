package com.starmaid.Cibele.entities {
    import org.flixel.*;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.management.ScreenManager;

    public class BlankScreen extends GameState {
        public var endCallback:Function;
        public var endTime:Number;
        public var bg:GameObject;

        public function BlankScreen(end_timer:Number, end_callback:Function) {
            super(false,false,false);
            this.endCallback = end_callback;
            this.endTime = end_timer;

            var _screen:ScreenManager = ScreenManager.getInstance();

            this.bg = new GameObject(new DHPoint(0,0));
            this.bg.makeGraphic(_screen.screenWidth, _screen.screenHeight, 0xff000000);
            this.bg.scrollFactor = new FlxPoint(0,0);
            FlxG.state.add(this.bg);
            this.bg.visible = true;

            GlobalTimer.getInstance().setMark("deactivate blank screen", this.endTime, this.endCallback, true);
        }

        override public function update():void {
            super.update();
        }
    }
}
