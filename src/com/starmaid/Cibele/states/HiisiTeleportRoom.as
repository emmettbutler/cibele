package com.starmaid.Cibele.states {
    import org.flixel.*;

    public class HiisiTeleportRoom extends TeleportRoom {

        override public function create():void {
            this.bg_img_name = "eu_teleport.png";
            super.create();
        }

        override public function nextState():void {
            FlxG.switchState(new HiisiHallway(Hallway.STATE_RETURN));
        }

        override public function update():void{
            super.update();

            if (player.mapHitbox.overlaps(door)) {
                FlxG.switchState(new Hiisi());
            }
        }
    }
}