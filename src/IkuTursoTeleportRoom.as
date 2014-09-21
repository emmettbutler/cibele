package{
    import org.flixel.*;

    public class IkuTursoTeleportRoom extends PlayerState {
        public var bg:GameObject;
        public var door:GameObject;

        public var img_height:Number = 357;

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .4, _screen.screenHeight * .6));

            (new BackgroundLoader()).loadSingleTileBG("../assets/it_teleport_640_480.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            door = new GameObject(new DHPoint(_screen.screenWidth * .3, _screen.screenHeight * .4));
            door.makeGraphic(500, 20, 0xffff0000);
            door.alpha = 0;
            add(door);

            this.postCreate();
        }

        override public function update():void{
            super.update();

            if (player.mapHitbox.overlaps(door)){
                FlxG.switchState(new IkuTurso());
            }
        }
    }
}
