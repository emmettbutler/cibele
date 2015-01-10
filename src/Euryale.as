package{
    import org.flixel.*;

    import flash.events.*;

    public class Euryale extends LevelMapState {
        public function Euryale() {
            PopUpManager.GAME_ACTIVE = true;
            this.ui_color_flag = GameState.UICOLOR_PINK;
        }

        override public function create():void {
            this.filename = null;
            this.mapTilePrefix = "euryale";
            this.tileGridDimensions = new DHPoint(6, 3);
            this.estTileDimensions = new DHPoint(2266, 1365);
            this.playerStartPos = new DHPoint(2266*3 - 500, 1365*6 - 500);
            this.colliderScaleFactor = 3.54;

            super.create();
        }

        override public function update():void{
            super.update();
        }
    }
}
