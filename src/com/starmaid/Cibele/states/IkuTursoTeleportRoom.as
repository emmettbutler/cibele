package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.states.IkuTurso;

    import org.flixel.*;

    public class IkuTursoTeleportRoom extends TeleportRoom {

        override public function create():void {
            this.bg_img_name = "it_teleport.png";
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
