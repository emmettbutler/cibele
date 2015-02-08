package{
    import org.flixel.*;

    public class IkuTursoTeleportRoom extends TeleportRoom {

        override public function create():void {
            super.create();
        }

        override public function update():void{
            super.update();

            if (player.mapHitbox.overlaps(door)) {
                FlxG.switchState(new IkuTurso());
            }
        }
    }
}
