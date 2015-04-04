package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class IkuTursoEnemy extends SmallEnemy {
        [Embed(source="/../assets/images/characters/squid_baby.png")] private var ImgIT1:Class;
        [Embed(source="/../assets/images/characters/Enemy2_sprite.png")] private var ImgIT2:Class;
        [Embed(source="/../assets/images/characters/squid_attack.png")] private var ImgIT1_Attack:Class;
        [Embed(source="/../assets/images/characters/enemy2_attack.png")] private var ImgIT2_Attack:Class;
        [Embed(source="/../assets/images/ui/enemy_highlight.png")] private var ImgActive:Class;
        [Embed(source="/../assets/images/ui/enemy2_highlight.png")] private var ImgActive2:Class;

        public function IkuTursoEnemy(pos) {
            super(pos);
        }

        override public function setupSprites():void {
            var rand:Number = Math.floor(Math.random() * 2);
            switch(rand) {
                case 1:
                    this.loadGraphic(ImgIT1, false, false, 152, 104);

                    this.target_sprite = new GameObject(pos);
                    this.target_sprite.loadGraphic(ImgActive, false, false,
                                                   147, 24);
                    this.target_sprite.visible = false;
                    FlxG.state.add(this.target_sprite);

                    this.attack_sprite = new GameObject(pos);
                    this.attack_sprite.loadGraphic(ImgIT1_Attack, true, false,
                                                   165, 115);
                    this.attack_sprite.addAnimation("attack",
                        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 10, 9, 8, 7, 6,
                         5, 4, 3, 2, 1, 0], 12, true);
                    FlxG.state.add(attack_sprite);
                    break;

                default:
                    this.loadGraphic(ImgIT2, false, false, 70, 160);

                    this.target_sprite = new GameObject(pos);
                    this.target_sprite.loadGraphic(ImgActive2, false, false,
                                                   67, 15);
                    this.target_sprite.visible = false;
                    FlxG.state.add(this.target_sprite);

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

            this.addAnimation("run_enemy", [0, 1, 2, 3, 4, 5], 12, true);
            this.attack_sprite.play("attack");
            this.attack_sprite.zSorted = true;
            this.attack_sprite.basePos = new DHPoint(this.x,
                                                     this.y + this.height);
            this.play("run_enemy");

            this.bar = new GameObject(new DHPoint(pos.x,pos.y));
            this.bar.makeGraphic(1,8,0xffe2678e);
            this.bar.scale.x = this.hitPoints;
        }
    }
}
