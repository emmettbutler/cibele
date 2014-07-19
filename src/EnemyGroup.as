package
{
    import org.flixel.*;

    public class EnemyGroup {
        public var enemies:Array;

        public function EnemyGroup() {
            this.enemies = new Array();
        }

        public function addEnemy(en:Enemy):void {
            this.enemies.push(en);
        }

        public function length():Number {
            return this.enemies.length;
        }

        public function get_(i:int):Enemy {
            return this.enemies[i];
        }
    }
}
