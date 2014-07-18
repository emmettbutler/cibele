package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        public var runSpeed:Number = .5;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var pos:FlxPoint;

        public function Player(x:Number, y:Number):void{
            super(x,y);
            makeGraphic(50,50,0x00000000);
            pos = new FlxPoint(x,y);

            /*addAnimation("run", [2,3], 14, true);
            addAnimation("runFront", [0,1], 14, true);
            addAnimation("standing", [0]);
            addAnimation("runBack", [4,5], 14, true);
            addAnimation("standingBack", [4]);
            play("standingBack");*/

            this.scale = _scale;
        }


        override public function update():void{
            super.update();
            pos.x = x;
            pos.y = y;

            if(FlxG.keys.LEFT) {
                x -= runSpeed;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                //play("run");
            } else if(FlxG.keys.RIGHT){
                x += runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
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
        }
    }
}

