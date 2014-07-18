package{
    import flash.utils.ByteArray;

    import org.flixel.*;
    import org.flixel.system.FlxTile;

    public class Fern extends FlxState {
        //[Embed(source="../assets/tiles1.png")] private var ImgTiles:Class;
        //[Embed(source = "../assets/fight.mp3")] private var BGM:Class;

        protected var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        override public function create():void{

            FlxG.bgColor = 0xFFccfbff;
            //FlxG.mouse.show();
            //FlxG.playMusic(BGM, 1);

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
