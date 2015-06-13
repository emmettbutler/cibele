package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class SmallEnemy extends Enemy {
        public var attack_sprite:GameObject;

        public function SmallEnemy(pos:DHPoint) {
            super(pos, 100);
        }

        override public function setupSprites():void {
            super.setupSprites();
            this.attack_sprite.visible = false;
        }

        override public function enterIdleState():void {
            super.enterIdleState();
            this.attack_sprite.visible = false;
        }

        override public function startTracking():void {
            super.startTracking();
            this.attack_sprite.visible = true;
        }

        override public function die(p:PartyMember):void {
            super.die(p);
            this.attack_sprite.visible = false;
        }

        override public function setAuxPositions():void {
            super.setAuxPositions();
            this.attack_sprite.setPos(this.pos);
            this.attack_sprite.basePos.y = this.y + this.basePosOffset.y;
        }
    }
}
