package com.starmaid.Cibele.states {
    import org.flixel.*;
    import com.starmaid.Cibele.base.GameState;
    import flash.utils.Dictionary;

    public class EuryaleDesktop extends Desktop {
        public function EuryaleDesktop() {
            if(GameState.cur_level != GameState.LVL_EU) {
                GameState.cur_level = GameState.LVL_EU;
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
