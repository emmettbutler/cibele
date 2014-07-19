package{
    import org.flixel.*;

    public class IkuTurso extends FlxState {
        [Embed(source="../assets/fern_640_480.png")] private var ImgBG:Class;
        public var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:FlxSprite;
        public var player_rect:FlxRect;

        public var img_height:Number = 357;

        public var enemy:SmallEnemy;

        override public function create():void {
            FlxG.bgColor = 0x00000000;
            bg = new FlxSprite(0,(480-img_height)/2);
            bg.loadGraphic(ImgBG,false,false,640,img_height);
            add(bg);

            enemy = new SmallEnemy(new DHPoint(250,300));
            add(enemy);

            player = new Player(150, 200);
            add(player);
            player_rect = new FlxRect(player.x,player.y,player.width,player.height);

            debugText = new FlxText(0,0,100,"");
            add(debugText);
        }

        override public function update():void{
            super.update();
            player_rect.x = player.x;
            player_rect.y = player.y;

            FlxG.overlap(player,enemy,attack);

            timeFrame++;
            debugText.x = player.x-50;
            debugText.y = player.y;

            if(timeFrame%30 == 0){
                timer++;
            }
        }

        public function attack(p:Player, e:SmallEnemy):void{
            p.attacking(e);
        }
    }
}