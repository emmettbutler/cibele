package com.starmaid.Cibele.states {
    import org.flixel.*;

    import flash.utils.Dictionary;

    public class IkuTursoDesktop extends Desktop {
        public function IkuTursoDesktop() {
            if(GameState.cur_level != GameState.LVL_IT) {
                GameState.cur_level = GameState.LVL_IT;
            }
        }

        override public function create():void {
            super.create();
        }

        override public function update():void{
            super.update();
        }
    }
}
