package{
    import org.flixel.*;

    public class IkuTursoTeleportRoom extends FlxState {
        public var player:Player;

        public var bg:FlxSprite;
        public var door:FlxSprite;
        public var runningSound:GameSound;

        public var img_height:Number = 357;

        public function IkuTursoTeleportRoom(runningSound:GameSound) {
            super();
            this.runningSound = runningSound;
        }

        override public function create():void {
            (new BackgroundLoader()).loadSingleTileBG("../assets/it_teleport_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            var _screen:ScreenManager = ScreenManager.getInstance();
            door = new FlxSprite(_screen.screenWidth * .3, _screen.screenHeight * .4);
            door.makeGraphic(500, 20, 0xffff0000);
            door.alpha = 0;
            add(door);

            player = new Player(_screen.screenWidth * .4, _screen.screenHeight * .6);
            add(player);
            player.testAttackAnim();
        }

        override public function update():void{
            super.update();

            MessageManager.getInstance().update();
            SoundManager.getInstance().update();

            if (player.mapHitbox.overlaps(door)){
                FlxG.switchState(new IkuTurso(this.runningSound));
            }
        }
    }
}
