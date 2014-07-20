package
{
    import org.flixel.*;

    public class EnemyGroup {
        public var enemies:Array;
        public var player:Player;

        public function EnemyGroup(p:Player) {
            this.enemies = new Array();
            player = p;
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

        public function update():void {
            for(var i:Number = 0; i < this.length(); i++){
                this.get_(i).update();
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
