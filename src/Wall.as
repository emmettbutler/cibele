package{
    import org.flixel.*;

    public class Wall extends FlxSprite{
        public var img_height:Number = 357;
        public var pos:FlxPoint;

        public function Wall(x:Number, y:Number, w:Number, h:Number):void{
            super(x,y);
            makeGraphic(w,h);
            immovable = true;
            visible = false;
            pos = new FlxPoint(x,y);
        }


        override public function update():void{
            super.update();
            x = pos.x;
            y = pos.y;
        }
    }
}
