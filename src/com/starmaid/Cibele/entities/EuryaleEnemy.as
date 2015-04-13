package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class EuryaleEnemy extends SmallEnemy {
        [Embed(source="/../assets/images/characters/dark_enemy.png")] private var ImgEn1:Class;
        [Embed(source="/../assets/images/characters/light_enemy.png")] private var ImgEn2:Class;
        [Embed(source="/../assets/images/ui/enemy_highlight.png")] private var ImgActive:Class;
        [Embed(source="/../assets/images/ui/enemy2_highlight.png")] private var ImgActive2:Class;

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

                    this.target_sprite = new GameObject(pos);
                    this.target_sprite.loadGraphic(ImgActive, false, false,
                                                   147, 24);
                    this.target_sprite.visible = false;
                    FlxG.state.add(this.target_sprite);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgEn1, true, false,
                                                   247, 300);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
                    FlxG.state.add(attack_sprite);
                    break;

                default:
                    this.loadGraphic(ImgEn2, false, false, 247, 300);
                    this.addAnimation("run_enemy",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 12, true);

                    this.target_sprite = new GameObject(pos);
                    this.target_sprite.loadGraphic(ImgActive2, false, false,
                                                   67, 15);
                    this.target_sprite.visible = false;
                    FlxG.state.add(this.target_sprite);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgEn2, true, false,
                                                   247, 300);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 12, true);
                    FlxG.state.add(attack_sprite);
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
