package {

    import org.flixel.*;

    public class PathNode extends MapNode
    {
        public var next:PathNode;
        public var prev:PathNode;
        public var marked:Boolean = false;

        public function PathNode(pos:DHPoint)
        {
            super(pos);
            this._type = TYPE_PATH;
            makeGraphic(10, 10, 0xff0000ff);
            this.pos = pos;
            FlxG.state.add(this);

            this.next = null;
            this.prev = null;
        }

        override public function mark():void{
            marked = true;
        }

        public function status_():Boolean{
            return marked;
        }
    }
}
