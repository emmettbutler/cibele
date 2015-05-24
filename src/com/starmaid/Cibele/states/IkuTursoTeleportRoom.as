package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.states.IkuTurso;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    public class IkuTursoTeleportRoom extends TeleportRoom {

        override public function create():void {
            this.bg_img_name = "it_teleport.png";
            super.create();
        }

        override public function nextState():void {
            FlxG.switchState(new IkuTursoHallway(Hallway.STATE_RETURN));
        }

        override public function update():void{
            super.update();

            if (player.mapHitbox.overlaps(door)) {
                this.fadeOut(
                    function():void {
                        FlxG.switchState(new IkuTurso());
                    },
                    .2 * GameSound.MSEC_PER_SEC
                );
            }
        }
    }
}
