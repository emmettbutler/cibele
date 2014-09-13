package{
    import org.flixel.*;

    public class EuryaleTeleportRoom extends FlxState {
        [Embed(source="../assets/it_teleport_640_480.png")] private var ImgBG:Class;
        public var player:Player;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:FlxSprite;
        public var door:FlxRect;
        public var exit:FlxRect;
        public var player_rect:FlxRect;
        public var wall_rect_l:Wall;
        public var bottom_wall_rect_l:Wall;
        public var wall_rect_r:Wall;
        public var bottom_wall_rect_r:Wall;

        public var img_height:Number = 357;

        override public function create():void {
            FlxG.bgColor = 0x00000000;
            bg = new FlxSprite(0,(FlxG.height-img_height)/2);
            bg.loadGraphic(ImgBG,false,false,640,img_height);
            add(bg);

            wall_rect_l = new Wall(0,(FlxG.height-img_height)/2,200,FlxG.height - (FlxG.height-img_height)/2);
            add(wall_rect_l);
            bottom_wall_rect_l = new Wall(65,FlxG.height - (FlxG.height-img_height+110)/2,200,200);
            add(bottom_wall_rect_l);
            wall_rect_r = new Wall(FlxG.width-200,(FlxG.height-img_height)/2,200,FlxG.height - (FlxG.height-img_height)/2);
            add(wall_rect_r);
            bottom_wall_rect_r = new Wall(FlxG.width-280,FlxG.height - (FlxG.height-img_height+60)/2,200,150);
            add(bottom_wall_rect_r);

            door = new FlxRect(210,50,200,100);

            exit = new FlxRect(200,FlxG.height - (FlxG.height-img_height+70)/2,210,50);

            player = new Player(220, 280);
            add(player);
            player.testAttackAnim();
            player_rect = new FlxRect(player.x,player.y,player.width,player.height);

            debugText = new FlxText(0,0,100,"");
            add(debugText);
        }

        override public function update():void{
            super.update();
            MessageManager.getInstance().update();

            player_rect.x = player.x;
            player_rect.y = player.y;
            FlxG.collide();
            if (player_rect.overlaps(door)){
                FlxG.switchState(new Fern());
            }
            //if (player_rect.overlaps(exit)){
            //    FlxG.switchState(new Fern());
            //}
            //TODO build an exit

            timeFrame++;
            debugText.x = player.x-50;
            debugText.y = player.y;


            debugText.text = FlxG.height + "";

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
