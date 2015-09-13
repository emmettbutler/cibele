package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class Mist extends GameObject {
        [Embed(source="/../assets/images/worlds/mist_01.png")] private var ImgMist1:Class;
        [Embed(source="/../assets/images/worlds/mist_02.png")] private var ImgMist2:Class;

        private var leftBound:Number, rightBound:Number;

        public function Mist() {
            var imgs:Array = [[ImgMist1, new DHPoint(556, 122)],
                              [ImgMist2, new DHPoint(389, 80)]];
            this.leftBound = 0;
            this.rightBound = ScreenManager.getInstance().screenWidth;
            var pos:DHPoint = new DHPoint(
                leftBound + Math.random() * rightBound,
                -2 * ScreenManager.getInstance().screenHeight + Math.random() * (4 * ScreenManager.getInstance().screenHeight)
            );
            var choice:Array = imgs[Math.floor(Math.random() * imgs.length)];
            super(pos);
            this.scrollFactor = new DHPoint(0, .2);
            this.dir = new DHPoint(-2 + Math.random() * 4, 0);
            this.loadGraphic(choice[0], false, false,
                             choice[1].x, choice[1].y);
            FlxG.state.add(this);
        }

        override public function toggleActive():void {
            this.active = true;
        }

        override public function update():void {
            super.update();

            if (this.pos.x >= this.rightBound || this.pos.x <= this.leftBound)
            {
                this.dir.x *= -1;
            }
        }
    }
}
