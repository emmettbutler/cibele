package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.states.IkuTurso;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class IkuTursoTeleportRoom extends TeleportRoom {

        override public function create():void {
            this.bg_img_name = "it_teleport";
            super.create();
        }

        override public function nextState():void {
            FlxG.switchState(new IkuTursoHallway(Hallway.STATE_RETURN));
        }

        override public function placeLevelDoor(bg:FlxExtSprite):void {
            this.door.setPos(new DHPoint(this.door.x,
                                         bg.y + bg.height * .5));
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
