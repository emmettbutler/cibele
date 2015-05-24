package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class SmallEnemy extends Enemy {
        public var target_sprite:GameObject, attack_sprite:GameObject;

        public function SmallEnemy(pos:DHPoint) {
            super(pos);
        }

        override public function setupSprites():void {
            super.setupSprites();

            this.attack_sprite.zSorted = false;
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

        override public function die():void {
            super.die();

            this.target_sprite.visible = false;
            this.attack_sprite.visible = false;
        }

        override public function setAuxPositions():void {
            super.setAuxPositions();

            this.target_sprite.x = this.footPos.x - this.target_sprite.width / 2;
            this.target_sprite.y = this.footPos.y - 10;

            this.attack_sprite.setPos(this.pos);
            this.attack_sprite.basePos.y = this.y + this.basePosOffset.y;
        }

        override public function activeTarget():void {
            super.activeTarget();

            if(!this.target_sprite.visible) {
                this.target_sprite.visible = true;
            }
        }

        override public function inactiveTarget():void {
            super.inactiveTarget();

            if(this.target_sprite.visible) {
                this.target_sprite.visible = false;
            }
        }
    }
}
