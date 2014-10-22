package{
    import org.flixel.*;

    public class IkuTursoTeleportRoom extends PlayerState {
        public var bg:GameObject;
        public var door_it:GameObject;
        public var door_fern:GameObject;

        public var img_height:Number = 357;

        override public function create():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .4, _screen.screenHeight * .6));

            (new BackgroundLoader()).loadSingleTileBG("../assets/it_teleport.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            door_it = new GameObject(new DHPoint(_screen.screenWidth * .3, _screen.screenHeight * .4));
            door_it.makeGraphic(500, 20, 0xffff0000);
            door_it.alpha = 0;
            add(door_it);

            door_fern = new GameObject(new DHPoint(_screen.screenWidth * .4, _screen.screenHeight * .9));
            door_fern.makeGraphic(300,100,0xffff0000);
            door_fern.alpha = 0;
            add(door_fern);

            this.postCreate();
        }

        override public function postCreate():void {
            super.postCreate();
            player.setBlueShadow();
        }

        override public function update():void{
            super.update();

            if (player.mapHitbox.overlaps(door_it)) {
                FlxG.switchState(new IkuTurso());
            }

            if(player.mapHitbox.overlaps(door_fern)) {
                FlxG.switchState(new Fern());
            }
        }
    }
}
