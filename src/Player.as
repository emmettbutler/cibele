package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        public var runSpeed:Number = 5;
        public var state:String = "idle";

        public var img_height:Number = 357;

        public function Player(x:Number, y:Number):void{
            super(x,y);
            makeGraphic(50,50,0xffffffff);

            /*addAnimation("run", [2,3], 14, true);
            addAnimation("runFront", [0,1], 14, true);
            addAnimation("standing", [0]);
            addAnimation("runBack", [4,5], 14, true);
            addAnimation("standingBack", [4]);
            play("standingBack");*/
        }


        override public function update():void{
            super.update();
            borderCollide();

            if(FlxG.keys.LEFT) {
                x -= runSpeed;
                //play("run");
            } else if(FlxG.keys.RIGHT){
                x += runSpeed;
                //play("run");
            } else if(FlxG.keys.UP){
                y -= runSpeed;
                //play("runBack");
            } else if(FlxG.keys.DOWN){
                y += runSpeed;
                //play("runFront");
            } else if(FlxG.keys.justPressed("UP")){
                //play("standingBack");
            } else if (FlxG.keys.justPressed("DOWN")){
                //play("standing");
            }

            if(FlxG.keys.justPressed("SPACE")){
                state = "attack";
            } else if(FlxG.keys.justReleased("SPACE")){
                state = "idle";
            }
        }

        public function borderCollide():void{
            if(this.x >= FlxG.width - width)
                this.x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= (FlxG.height - ((FlxG.height-img_height)/2)) - height)
                this.y = (FlxG.height - ((FlxG.height-img_height)/2)) - height;
            if(this.y <= (0 + ((FlxG.height-img_height)/2)))
                this.y = (0 + ((FlxG.height-img_height)/2));
        }
    }
}

