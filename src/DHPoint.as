package
{
    import org.flixel.*;

    public class DHPoint extends FlxPoint
    {
        public function DHPoint(x:Number, y:Number)
        {
            super(x, y);
        }

        public function normalized():DHPoint
        {
            return new DHPoint(this.x/this._length(),
                               this.y/this._length());
        }

        public function _length():Number
        {
            return Math.sqrt(this.x*this.x + this.y*this.y)
        }

        public function sub(other:DHPoint):DHPoint {
            return new DHPoint(this.x - other.x, this.y - other.y);
        }

        public function add(other:DHPoint):DHPoint {
            return new DHPoint(this.x + other.x, this.y + other.y);
        }

        public function mul(other:DHPoint):DHPoint {
            return new DHPoint(this.x * other.x, this.y * other.y);
        }

        public function mulScl(other:Number):DHPoint {
            return new DHPoint(this.x * other, this.y * other);
        }
    }
}
