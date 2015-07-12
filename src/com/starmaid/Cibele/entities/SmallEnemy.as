package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class SmallEnemy extends Enemy {
        public var attack_sprite:GameObject;
        public var colliding:Boolean = false;
        public var collisionDirection:Array;
        public var mapHitbox:GameObject;

        public function SmallEnemy(pos:DHPoint) {
            super(pos, 100);
            this.mapHitbox = new GameObject(this.pos);
            this.mapHitbox.makeGraphic(this.width / 4, this.height / 4,
                                       0xff000000);
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

            this.mapHitbox.x = this.footPos.x - this.mapHitbox.width / 2;
            this.mapHitbox.y = this.footPos.y - this.mapHitbox.height;
        }

        override public function update():void {
            super.update();
            if (this.colliding) {
                if (this.collisionDirection != null) {
                    if (this.collisionDirection[0] == 1 &&
                        this.collisionDirection[1] == 1 &&
                        this.collisionDirection[2] == 1 &&
                        this.collisionDirection[3] == 1)
                    {
                    } else {
                        if (this.dir.x > 0 && this.collisionDirection[1] == 1) {
                            // right
                            this.dir.x = 0;
                        } else if (this.dir.x < 0 && this.collisionDirection[0] == 1) {
                            // left
                            this.dir.x = 0;
                        }
                        if (this.dir.y > 0 && this.collisionDirection[3] == 1) {
                            // down
                            this.dir.y = 0;
                        } else if (this.dir.y < 0 && this.collisionDirection[2] == 1) {
                            // up
                            this.dir.y = 0;
                        }
                    }
                }
            }
        }
    }
}
