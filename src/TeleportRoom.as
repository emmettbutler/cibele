package{
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class TeleportRoom extends PlayerState {
        public var bg:GameObject;
        public var door:GameObject;
        public var door_fern:GameObject;

        public var img_height:Number = 357;

        override public function create():void {
            PopUpManager.GAME_ACTIVE = true;
            var _screen:ScreenManager = ScreenManager.getInstance();
            super.__create(new DHPoint(
                _screen.screenWidth * .4, _screen.screenHeight * .6));

            (new BackgroundLoader()).loadSingleTileBG("../assets/images/worlds/it_teleport.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            door = new GameObject(new DHPoint(_screen.screenWidth * .3, _screen.screenHeight * .4));
            door.makeGraphic(500, 20, 0xffff0000);
            door.alpha = 0;
            add(door);

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
            if(player.mapHitbox.overlaps(door_fern)) {
                if(GameState.cur_level == GameState.LVL_IT) {
                    FlxG.switchState(new IkuTursoHallway(Hallway.STATE_RETURN));
                } else if(GameState.cur_level == GameState.LVL_EU) {
                    FlxG.switchState(new EuryaleHallway(Hallway.STATE_RETURN));
                }
            }
        }
    }
}
