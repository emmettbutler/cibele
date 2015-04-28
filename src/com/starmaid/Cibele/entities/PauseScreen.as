package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class PauseScreen {
        private var baseLayer:GameObject;

        public function PauseScreen() {
            this.baseLayer = new GameObject(new DHPoint(0, 0));
            this.baseLayer.scrollFactor = new DHPoint(0, 0);
            this.baseLayer.active = false;
            this.baseLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                0xaa000000
            );
            this.baseLayer.visible = false;
        }

        public function set visible(val:Boolean):void {
            this.baseLayer.visible = val;
        }

        public function get base():GameObject {
            return this.baseLayer;
        }

        public function addToState():void {
            FlxG.state.add(this.baseLayer);
        }
    }
}
