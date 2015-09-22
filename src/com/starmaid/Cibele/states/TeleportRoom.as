package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class TeleportRoom extends PlayerState {
        public var bg:GameObject;
        public var door:GameObject;
        public var door_fern:GameObject;
        public var bg_img_name:String = "it_teleport";
        public var bgLoader:BackgroundLoader;
        public var bgCollider:FlxExtSprite, bgImage:FlxExtSprite;

        public var img_height:Number = 357;

        override public function create():void {
            this.enable_fade = true;
            this.load_screen_text = "Fern";
            PopUpManager.GAME_ACTIVE = true;
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.startPos = new DHPoint(
                _screen.screenWidth * .4, _screen.screenHeight * .6);
            super.create();

            this.bgLoader = new BackgroundLoader();
            this.bgCollider = this.bgLoader.loadSingleTileBG("/../assets/images/worlds/" + this.bg_img_name + "_collider.png");
            this.bgImage = this.bgLoader.loadSingleTileBG("/../assets/images/worlds/" + this.bg_img_name + ".png");
            this.bgLoader.setPlayerReference(this.player);
            ScreenManager.getInstance().setupCamera(null, 1);

            var that:TeleportRoom = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    that.placeLevelDoor(event.userData['bg']);
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });

            door = new GameObject(new DHPoint(0, _screen.screenHeight * .5));
            door.makeGraphic(_screen.screenWidth, 20, 0xffff0000);
            door.visible = false;
            add(door);

            door_fern = new GameObject(new DHPoint(_screen.screenWidth * .4, _screen.screenHeight * .9));
            door_fern.makeGraphic(300,100,0xffff0000);
            door_fern.visible = false;
            add(door_fern);

            this.setScaleFactor(
                ScreenManager.getInstance().calcFullscreenScale());

            this.postCreate();
        }

        public function nextState():void { }
        public function placeLevelDoor(bg:FlxExtSprite):void { }

        override public function update():void{
            super.update();
            if(player.mapHitbox.overlaps(door_fern)) {
                this.fadeOut(
                    function():void {
                        nextState();
                    },
                    .1 * GameSound.MSEC_PER_SEC
                );
            }

            if (this.fading) {
                if(SoundManager.getInstance().getSoundByName(Hallway.BGM) != null) {
                    SoundManager.getInstance().getSoundByName(Hallway.BGM).fadeOutSound(.005);
                }
            } else {
                this.bgLoader.collideTile(this.bgCollider);
            }
        }
    }
}
