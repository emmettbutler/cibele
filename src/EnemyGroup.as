package
{
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
            this.enemies.push(en);
        }

        public function length():Number {
            return this.enemies.length;
        }

        public function get_(i:int):Enemy {
            return this.enemies[i];
        }

        public function update():void {
            var cur:Enemy;
            for(var i:Number = 0; i < this.length(); i++){
                cur = this.get_(i);
                if (cur.isFollowing()) {
                    //this.preventEnemyOverlap(cur);
                }
            }
        }

        public function preventEnemyOverlap(e:Enemy):void{
            for(var i:Number = 0; i < this.length(); i++){
                if(this.get_(i).pos.sub(e.pos)._length() < 10){
                    FlxG.collide(this.get_(i), e);
                }
            }
        }
    }
}
