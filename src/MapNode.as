package {

    import org.flixel.*;

    public class MapNode extends GameObject
    {
        public var _type:Number;
        public static const TYPE_MAP:Number = 1;
        public static const TYPE_PATH:Number = 2;

        public function MapNode(pos:DHPoint)
        {
            super(pos);
            this._type = TYPE_MAP;
            makeGraphic(10, 10, 0xff00ffff);
            this.pos = pos;
            FlxG.state.add(this);
        }

        public function mark():void{ }
    }
}
