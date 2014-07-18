package{
    import org.flixel.*;

    public class Fern extends FlxState {
        protected var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        override public function create():void {
            FlxG.bgColor = 0xFFccfbff;

            player = new Player(35, 30);
            add(player);

            debugText = new FlxText(0,0,100,"");
            add(debugText);
        }

        override public function update():void{
            super.update();
            timeFrame++;
            debugText.x = player.x-50;
            debugText.y = player.y;

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
