package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.LRUDVector;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.Path;

    import org.flixel.*;

    public class PartyMember extends GameObject {
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="/../assets/images/characters/cib_shadow.png")] private var ImgShadow:Class;

        public static const STATE_IN_ATTACK:Number = 1;
        public static const STATE_MOVE_TO_ENEMY:Number = 34987651333;
        public static const STATE_AT_ENEMY:Number = 91823419673;

        public var lastAttackTime:Number = 0;
        public var footsteps:FootstepTrail = null;
        public var footstepOffset:DHPoint;
        public var attackRange:Number = 70;
        public var nameText:FlxText;
        public var text_facing:String = "up";
        public var footPos:DHPoint;
        public var sightRange:Number;
        public var bossSightRange:Number;
        public var targetEnemy:Enemy;
        public var attackAnimDuration:Number;
        protected var _cur_path:Path;
        protected var walkTarget:DHPoint;
        protected var shadow_sprite:GameObject;
        protected var footstepOffsets:LRUDVector;
        protected var attackSounds:Array;
        protected var _debug_sightRadius:CircleSprite,
                      _debug_attackRadius:CircleSprite;

        public function PartyMember(pos:DHPoint) {
            super(pos);
            this.nameText = new FlxText(pos.x, pos.y, 500, "My Name");
            this.nameText.setFormat("NexaBold-Regular",16,0xff616161,"left");
            this.footPos = new DHPoint(0, 0);
            this.sightRange = 280;
            this.bossSightRange = 1200;
            this.attackAnimDuration = 2*GameSound.MSEC_PER_SEC;
            this.walkTarget = new DHPoint(0, 0);
            this.footstepOffsets = new LRUDVector();
            if (ScreenManager.getInstance().DEBUG) {
                this._debug_sightRadius = new CircleSprite(this.pos,
                                                           this.sightRange);
                this._debug_attackRadius = new CircleSprite(this.pos,
                                                            this.attackRange);
            }
        }

        public function setupSprites():void { }
        public function setupFootsteps():void { }

        public function initFootsteps():void {
            this.footsteps = new FootstepTrail(this);
        }

        public function buildShadowSprite():void {
            this.shadow_sprite = new GameObject(this.pos);
            this.shadow_sprite.zSorted = true;
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,70,42);
            this.shadow_sprite.alpha = .7;
        }

        public function setBlueShadow():void {
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,70,42);
            this.shadow_sprite.alpha = .7;
        }

        public function addVisibleObjects():void {
            if (ScreenManager.getInstance().DEBUG) {
                FlxG.state.add(this._debug_sightRadius);
                FlxG.state.add(this._debug_attackRadius);
            }
        }

        public function playAttackSound():void {
            var snd:Class = this.attackSounds[
                Math.floor(Math.random() * this.attackSounds.length)
            ];
            SoundManager.getInstance().playSound(
                snd, 2*GameSound.MSEC_PER_SEC, null, false, .3, GameSound.SFX,
                "" + Math.random()
            );
        }

        override public function update():void {
            super.update();

            if (ScreenManager.getInstance().DEBUG) {
                this._debug_sightRadius.setPos(this.footPos.sub(
                    new DHPoint(this._debug_sightRadius.radius,
                                this._debug_sightRadius.radius)
                ));
                this._debug_attackRadius.setPos(this.footPos.sub(
                    new DHPoint(this._debug_attackRadius.radius,
                                this._debug_attackRadius.radius)
                ));
            }

            if (this.footsteps != null) {
                this.footsteps.update();
            }

            if(this.text_facing == "up" || this.text_facing == "down"){
                this.nameText.x = this.pos.x+50;
            } else if(this.text_facing == "left") {
                this.nameText.x = this.pos.x+75;
            } else if(this.text_facing == "right") {
                this.nameText.x = this.pos.x+20;
            }

            this.nameText.y = this.pos.y-30;

            this.footPos.x = this.x + this.width/2;
            this.footPos.y = this.y + this.height;
        }

        public function isAttacking():Boolean{
            return this._state == STATE_IN_ATTACK;
        }

        public function directionToObj(obj:DHPoint):DHPoint {
            return obj.sub(this.pos);
        }

        public function attack():void {
            if (this.canAttack()) {
                this._state = STATE_IN_ATTACK;
                this.lastAttackTime = this.currentTime;
            }
        }

        public function timeSinceLastAttack():Number {
            return this.currentTime - this.lastAttackTime;
        }

        public function canAttack():Boolean {
            return this.timeSinceLastAttack() > this.attackAnimDuration;
        }

        public function enemyIsInAttackRange(en:Enemy):Boolean {
            if (en == null) { return false; }
            var disp:Number = en.getAttackPos().sub(this.footPos)._length();
            return disp < this.attackRange;
        }

        public function enemyIsInMoveTowardsRange(en:Enemy):Boolean{
            if (en == null) { return false; }
            var range:Number = this.sightRange;
            if (en is BossEnemy) {
                range = this.bossSightRange;
            }
            return en.getAttackPos().sub(this.footPos)._length() < range;
        }

        public function resolveStatePostAttack():void {}
    }
}
