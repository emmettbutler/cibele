package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.entities.MenuButton;

    import org.flixel.*;

    import flash.desktop.NativeApplication;

    public class PauseScreen {
        private var baseLayer:GameObject, confirmLayer:GameObject;
        private var quitButton:MenuButton, titleScreenButton:MenuButton,
                    confirmButton:MenuButton, cancelButton:MenuButton,
                    resumeButton:MenuButton;
        private var confirmText:FlxText;
        private var _state:GameState;
        private var curConfirmFunction:Function;
        private var buttons:Array;

        private static const CONFIRM_SLUG:String = "confirmslug";

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
                function ():void {
                    confirmAction(function():void {
                        NativeApplication.nativeApplication.exit();
                    }, "Are you sure you want to quit Cibele?");
                }
            );
            this.quitButton.observeGlobalPause = false;
            this.buttons.push(this.quitButton);
            this._state.addMenuButton(this.quitButton);

            this.titleScreenButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth / 2 - _buttonWidth / 2,
                    ScreenManager.getInstance().screenHeight - 160
                ),
                new DHPoint(_buttonWidth, 30),
                "Title Screen",
                function ():void {
                    confirmAction(function():void {
                        ScreenManager.getInstance().resetGame();
                    }, "Are you sure you want to return to the title screen?");
                }
            );
            this.titleScreenButton.observeGlobalPause = false;
            this.buttons.push(this.titleScreenButton);
            this._state.addMenuButton(this.titleScreenButton);

            this.resumeButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth / 2 - _buttonWidth / 2,
                    ScreenManager.getInstance().screenHeight - 200
                ),
                new DHPoint(_buttonWidth, 30),
                "Resume",
                function ():void {
                    (FlxG.state as GameState).resume();
                }
            );
            this.resumeButton.observeGlobalPause = false;
            this.buttons.push(this.resumeButton);
            this._state.addMenuButton(this.resumeButton);

            var confirmLayerDim:DHPoint = new DHPoint(600, 130);
            this.confirmLayer = new GameObject(new DHPoint(
                ScreenManager.getInstance().screenWidth / 2 - confirmLayerDim.x / 2,
                ScreenManager.getInstance().screenHeight / 2 - confirmLayerDim.y / 2
            ));
            this.confirmLayer.active = false;
            this.confirmLayer.scrollFactor = new DHPoint(0, 0);
            this.confirmLayer.makeGraphic(
                confirmLayerDim.x, confirmLayerDim.y, 0xffffffff
            );
            this.confirmLayer.visible = false;
            this.confirmLayer.observeGlobalPause = false;

            this.confirmText = new FlxText(this.confirmLayer.x, this.confirmLayer.y,
                                           this.confirmLayer.width, "");
            this.confirmText.scrollFactor = new DHPoint(0, 0);
            this.confirmText.setFormat("NexaBold-Regular",
                                             MessageManager.FONT_SIZE,
                                             0xff333333, "center");

            this.confirmButton = new MenuButton(
                new DHPoint(
                    (this.confirmLayer.pos.x + this.confirmLayer.width / 2) - this.confirmLayer.width / 4 - _buttonWidth / 2,
                    (this.confirmLayer.pos.y + this.confirmLayer.height) - 50
                ),
                new DHPoint(_buttonWidth, 30),
                "Confirm",
                function ():void { doConfirmFunction(); }
            );
            this.confirmButton.observeGlobalPause = false;
            this.confirmButton.slug = CONFIRM_SLUG;
            this.buttons.push(this.confirmButton);
            this._state.addMenuButton(this.confirmButton);
            this.confirmButton.visible = false;

            this.cancelButton = new MenuButton(
                new DHPoint(
                    (this.confirmLayer.pos.x + this.confirmLayer.width / 2) + (this.confirmLayer.width / 4 - _buttonWidth / 2),
                    (this.confirmLayer.pos.y + this.confirmLayer.height) - 50
                ),
                new DHPoint(_buttonWidth, 30),
                "Cancel",
                function ():void { cancelConfirmDialogue(); }
            );
            this.cancelButton.observeGlobalPause = false;
            this.cancelButton.slug = CONFIRM_SLUG;
            this.buttons.push(this.cancelButton);
            this._state.addMenuButton(this.cancelButton);
            this.cancelButton.visible = false;

            this.visible = false;
        }

        public function confirmAction(fn:Function, text:String):void {
            this.confirmText.text = text;
            this.showConfirmDialogue();
            this.curConfirmFunction = fn;
        }

        public function doConfirmFunction():void {
            this.curConfirmFunction();
            this.hideConfirmDialogue();
        }

        public function showConfirmDialogue():void {
            this.confirmLayer.visible = true;
            this.confirmText.visible = true;
            this.confirmButton.setVisible(true);
            this.cancelButton.setVisible(true);
        }

        public function hideConfirmDialogue():void {
            this.confirmLayer.visible = false;
            this.confirmText.visible = false;
            this.confirmButton.setVisible(false);
            this.cancelButton.setVisible(false);
        }

        public function cancelConfirmDialogue():void {
            this.curConfirmFunction = null;
            this.hideConfirmDialogue();
        }

        public function addConfirmDialogue():void {
            this._state.add(this.confirmLayer);
            this._state.add(this.confirmText);
        }

        public function set visible(val:Boolean):void {
            this.baseLayer.visible = val;
            for(var i:int = 0; i < this.buttons.length; i++) {
                if (this.buttons[i].slug != CONFIRM_SLUG) {
                    this.buttons[i].setVisible(val);
                }
            }
            this.hideConfirmDialogue();
        }

        public function get base():GameObject {
            return this.baseLayer;
        }

        public function get quit_button():GameObject {
            return this.quitButton;
        }

        public function addToState():void {
            this._state.add(this.baseLayer);
            this.addConfirmDialogue();
            for(var i:int = 0; i < this.buttons.length; i++) {
                this.buttons[i].addToState(this._state);
            }
        }
    }
}
