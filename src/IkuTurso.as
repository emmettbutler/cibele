package{
    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        override public function create():void {
            this.filename = "ikuturso_path.txt";

            super.create();

            debugText = new FlxText(0,0,100,"");
            debugText.color = 0xff000000;
            add(debugText);
        }

        override public function update():void{
            super.update();

            debugText.x = player.x;
            debugText.y = player.y-20;
        }
    }
}
