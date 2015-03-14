package com.starmaid.Cibele.utils {
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.entities.PathFollower;
    import com.starmaid.Cibele.entities.Enemy;
    import org.flixel.*;

    public class EnemyGroup {
        public var enemies:Array;
        public var player:Player;
        public var path_follower:PathFollower;

        public function EnemyGroup(p:Player, f:PathFollower) {
            this.enemies = new Array();
            this.player = p;
            this.path_follower = f;
        }

        public function addEnemy(en:Enemy):void {
            en.setPlayerRef(this.player);
            en.setFollowerRef(this.path_follower);
            en.setPath(this.path_follower.getPath());
            this.enemies.push(en);
        }

        public function length():Number {
            return this.enemies.length;
        }

        public function get_(i:int):Enemy {
            return this.enemies[i];
        }

        public function update():void {
            for(var i:int = 0; i < this.enemies.length; i++) {
                this.enemies[i].toggleActive(this.player);
            }
        }
    }
}
