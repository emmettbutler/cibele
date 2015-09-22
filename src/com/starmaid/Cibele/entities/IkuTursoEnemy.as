package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class IkuTursoEnemy extends SmallEnemy {
        [Embed(source="/../assets/images/characters/squid_baby.png")] private var ImgIT1:Class;
        [Embed(source="/../assets/images/characters/Enemy2_sprite.png")] private var ImgIT2:Class;
        [Embed(source="/../assets/images/characters/squid_attack.png")] private var ImgIT1_Attack:Class;
        [Embed(source="/../assets/images/characters/enemy2_attack.png")] private var ImgIT2_Attack:Class;
        [Embed(source="/../assets/audio/effects/shell_enemy.mp3")] private var SndCall2:Class;

        public static const TYPE1:Number = 1;
        public static const TYPE2:Number = 2;
        public var _type:Number;

        public function IkuTursoEnemy(pos:DHPoint) {
            super(pos);
        }

        override public function setupSprites():void {
            var rand:Number = Math.floor(Math.random() * 2);
            switch(rand) {
                case 1:
                    this._type = IkuTursoEnemy.TYPE1;
                    this.flipFacing = true;
                    this.loadGraphic(ImgIT1, false, false, 152, 104);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgIT1_Attack, true, false,
                                                   165, 115);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 10, 9, 8, 7, 6,
                         5, 4, 3, 2, 1, 0], 12, true);
                    FlxG.state.add(attack_sprite);
                    break;

                default:
                    this._type = IkuTursoEnemy.TYPE2;
                    this.loadGraphic(ImgIT2, false, false, 70, 160);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgIT2_Attack, true, false,
                                                   71, 163);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                         16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
                         29, 30, 31, 32, 33, 32, 31, 30, 29, 28, 27, 26, 25,
                         24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12,
                         11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 12, true);
                    FlxG.state.add(attack_sprite);
                    break;
            }

            this.attack_sprite.play("attack");
            this.attack_sprite.zSorted = true;
            this.attack_sprite.basePos = new DHPoint(this.x,
                                                     this.y + this.height);
            this.addAnimation("run_enemy", [0, 1, 2, 3, 4, 5], 12, true);
            this.play("run_enemy");

            super.setupSprites();
        }

        override protected function playCallSound():void {
            super.playCallSound();
            var callSnd:Class;
            if (this._type == IkuTursoEnemy.TYPE1) {
                callSnd = SndCall2;
            } else if (this._type == IkuTursoEnemy.TYPE2) {
                callSnd = SndCall2;
            }
            SoundManager.getInstance().playSound(
                callSnd, 2 * GameSound.MSEC_PER_SEC, null, false, .5
            );
        }
    }
}
