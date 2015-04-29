package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.entities.MenuButton;

    import org.flixel.*;

    import flash.desktop.NativeApplication;

    public class PauseScreen {
        private var baseLayer:GameObject;
        private var quitButton:MenuButton;
        private var _state:GameState;
        private var buttons:Array;

        public function PauseScreen() {
            this._state = (FlxG.state as GameState);
            this.buttons = new Array();

            this.baseLayer = new GameObject(new DHPoint(0, 0));
            this.baseLayer.scrollFactor = new DHPoint(0, 0);
            this.baseLayer.active = false;
            this.baseLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                0xaa000000
            );

            var _buttonWidth:Number = 200;

            this.quitButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth / 2 - _buttonWidth / 2,
                    ScreenManager.getInstance().screenHeight - 120
                ),
                new DHPoint(_buttonWidth, 30),
                "Quit",
                function ():void { NativeApplication.nativeApplication.exit(); }
            );
            this.quitButton.observeGlobalPause = false;
            this.buttons.push(this.quitButton);
            this._state.addMenuButton(this.quitButton);

            this.visible = false;
        }

        public function set visible(val:Boolean):void {
            this.baseLayer.visible = val;
            for(var i:int = 0; i < this.buttons.length; i++) {
                this.buttons[i].setVisible(val);
            }
        }

        public function get base():GameObject {
            return this.baseLayer;
        }

        public function addToState():void {
            this._state.add(this.baseLayer);
            for(var i:int = 0; i < this.buttons.length; i++) {
                this.buttons[i].addToState();
            }
        }
    }
}
