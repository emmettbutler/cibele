package com.starmaid.Cibele.states {
    import org.flixel.*;

    public class EuryaleTeleportRoom extends TeleportRoom {

        override public function create():void {
            this.bg_img_name = "eu_teleport.png";
            super.create();
        }

        override public function update():void{
            super.update();

            if (player.mapHitbox.overlaps(door)) {
                FlxG.switchState(new Euryale());
            }
        }
    }
}
