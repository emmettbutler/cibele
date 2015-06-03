package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class EuryaleEnemy extends SmallEnemy {
        [Embed(source="/../assets/images/characters/dark_enemy.png")] private var ImgEn1:Class;
        [Embed(source="/../assets/images/characters/light_enemy.png")] private var ImgEn2:Class;

        public function EuryaleEnemy(pos:DHPoint) {
            super(pos);
        }

        override public function setupSprites():void {
            var rand:Number = Math.floor(Math.random() * 2);
            switch(rand) {
                case 1:
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
    }
}
