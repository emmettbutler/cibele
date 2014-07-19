package
{
    import org.flixel.*;

    public class Enemy extends GameObject {
        public function Enemy(pos:DHPoint) {
            super(pos);
            makeGraphic(10, 10, 0xff00ff00);
        }
    }
}
