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
            if (this._length() == 0) {
                return this;
            } else {
                return new DHPoint(this.x/this._length(), this.y/this._length());
            }
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

        public function reverse():DHPoint {
            return new DHPoint(this.x * -1, this.y * -1);
        }

        public function eq(other:DHPoint):Boolean {
            return this.x == other.x && this.y == other.y;
        }

        public function toString():String {
            return "DHPoint(" + this.x + ", " + this.y + ")";
        }
    }
}
