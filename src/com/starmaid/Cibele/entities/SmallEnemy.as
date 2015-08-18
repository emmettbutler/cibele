package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class SmallEnemy extends Enemy {
        [Embed(source="/../assets/audio/effects/sfx_die_small.mp3")] private var SfxSmallEnemyDeath:Class;

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
            if(this.inViewOfPlayer()) {
                SoundManager.getInstance().playSound(
                    SfxSmallEnemyDeath, 2 * GameSound.MSEC_PER_SEC, null,
                    false, .8
                );
            }
        }

        override public function isOnscreen():Boolean {
            var screenPos:DHPoint = new DHPoint(0, 0);
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.getScreenXY(screenPos);
            var width:Number = Math.max(this.width, this.attack_sprite.width);
            var height:Number = Math.max(this.height, this.attack_sprite.height);
            return (
                screenPos.x < _screen.screenWidth + width &&
                screenPos.x > 0 - width && screenPos.y > 0 - height &&
                screenPos.y < _screen.screenHeight + height
            );
        }

        override public function setAuxPositions():void {
            super.setAuxPositions();
            this.attack_sprite.setPos(this.pos);
            this.attack_sprite.basePos.y = this.y + this.basePosOffset.y;

            this.mapHitbox.x = this.footPos.x - this.mapHitbox.width / 2;
            this.mapHitbox.y = this.footPos.y - this.mapHitbox.height;
        }

        override public function takeDamage(p:PartyMember):void{
            super.takeDamage(p);
            if (this.colliding) {
                this.dir = ZERO_POINT;
            }
        }

        override public function update():void {
            super.update();
            this.attack_sprite.scale.x = (this.dir.x >= 0 ? 1 : -1) * (this.flipFacing ? -1 : 1);
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
