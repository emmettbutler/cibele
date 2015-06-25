package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class Footstep extends ExpiringGameObject {
        [Embed(source="/../assets/images/characters/blue_steps.png")] private var ImgFeetBlue:Class;
        [Embed(source="/../assets/images/characters/purple-steps.png")] private var ImgFeetPurple:Class;

        public static const PURPLE:Number = 1;
        public static const BLUE:Number = 2;

        public function Footstep(type:Number) {
            super();

            if(type == PURPLE) {
                this.loadGraphic(ImgFeetPurple, false, false, 19, 47);
            } else if(type == BLUE) {
                this.loadGraphic(ImgFeetBlue, false, false, 19, 47);
            }
        }
    }
}
