package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class MenuButton extends GameObject {
        private var _text:FlxText;
        private var _dimensions:DHPoint;
        private var _clickFn:Function;

        public function MenuButton(pos:DHPoint, dim:DHPoint, txt:String, clickFn:Function) {
            super(pos);

            this._dimensions = dim;
            this._clickFn = clickFn;

            this.makeGraphic(dim.x, dim.y, 0xff6cb7ce);
            this.scrollFactor = new DHPoint(0, 0);

            this._text = new FlxText(pos.x, pos.y, dim.x, txt);
            this._text.scrollFactor = new DHPoint(0, 0);
            this._text.setFormat("NexaBold-Regular", 24, 0xffffffff, "center");
        }

        public function addToState(_state:GameState=null):void {
            if (_state == null) {
                FlxG.state.add(this);
                FlxG.state.add(this._text);
            } else {
                _state.add(this);
                _state.add(this._text);
            }
        }

        public function setVisible(val:Boolean):void {
            this._text.visible = val;
            this.visible = val;
        }

        public function clickCallback():void {
            this._clickFn();
        }
    }
}
