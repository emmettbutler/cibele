package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class EuryaleEnemy extends SmallEnemy {
        [Embed(source="/../assets/images/characters/dark_enemy.png")] private var ImgEn1:Class;
        [Embed(source="/../assets/images/characters/light_enemy.png")] private var ImgEn2:Class;
        [Embed(source="/../assets/audio/effects/blackdoor.mp3")] private var SndCall1:Class;
        [Embed(source="/../assets/audio/effects/lightdoor.mp3")] private var SndCall2:Class;

        public static const TYPE1:Number = 1;
        public static const TYPE2:Number = 2;
        public var _type:Number;

        public function EuryaleEnemy(pos:DHPoint) {
            super(pos);
        }

        override public function setupSprites():void {
            var rand:Number = Math.floor(Math.random() * 2);
            switch(rand) {
                case 1:
                    this._type = EuryaleEnemy.TYPE1;
                    this.flipFacing = true;
                    this.loadGraphic(ImgEn1, false, false, 247, 300);
                    this.addAnimation("run_enemy",
                        [0, 1, 2, 3, 4, 5, 6, 7], 12, true);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgEn1, true, false,
                                                   247, 300);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
                    FlxG.state.add(attack_sprite);

                    this.footPosOffset = new DHPoint(this.width / 2, 200);
                    this.basePosOffset = this.footPosOffset;
                    break;

                default:
                    this._type = EuryaleEnemy.TYPE2;
                    this.loadGraphic(ImgEn2, false, false, 247, 300);
                    this.addAnimation("run_enemy",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 12, true);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgEn2, true, false,
                                                   247, 300);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 12, true);
                    FlxG.state.add(attack_sprite);

                    this.footPosOffset = new DHPoint(this.width / 2 + 10, 228);
                    this.basePosOffset = this.footPosOffset;
                    break;
            }

            this.attack_sprite.play("attack");
            this.attack_sprite.zSorted = true;
            this.attack_sprite.basePos = new DHPoint(this.x,
                                                     this.y + this.height);
            this.play("run_enemy");

            super.setupSprites();
        }

        override protected function playCallSound():void {
            super.playCallSound();
            var callSnd:Class;
            if (this._type == EuryaleEnemy.TYPE1) {
                callSnd = SndCall1;
            } else if (this._type == EuryaleEnemy.TYPE2) {
                callSnd = SndCall2;
            }
            SoundManager.getInstance().playSound(
                callSnd, 3 * GameSound.MSEC_PER_SEC
            );
        }
    }
}
