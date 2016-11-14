package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class MenuButton extends GameObject {
        private var _text:FlxText;
        private var _dimensions:DHPoint;
        private var _clickFn:Function;
        private var fillLock:Boolean = false;

        public function MenuButton(pos:DHPoint, dim:DHPoint, txt:String, clickFn:Function,
                                   fontSize:Number=24) {
            super(pos);

            this._dimensions = dim;
            this._clickFn = clickFn;

            this.makeGraphic(dim.x, dim.y, 0xff6cb7ce);
            this.scrollFactor = new DHPoint(0, 0);

            this._text = new FlxText(pos.x, pos.y, dim.x, txt);
            this._text.scrollFactor = new DHPoint(0, 0);
            this._text.setFormat("NexaBold-Regular", fontSize, 0xffffffff, "center");
        }

        public function set text(t:String):void {
            this._text.text = t;
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

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);
            this._text.x = pos.x;
            this._text.y = pos.y;
        }

        override public function destroy():void {
            if (this._text != null) {
                this._text.destroy();
                this._text = null;
            }
            super.destroy();
        }

        public function setVisible(val:Boolean):void {
            this._text.visible = val;
            this.visible = val;
        }

        public function clickCallback():void {
            this._clickFn();
        }

        override public function update():void {
            if((FlxG.state as GameState).cursorOverlaps(this._getRect(), true)) {
                this.fill(0xff94def4);
                this.fillLock = false;
            } else {
                if(!this.fillLock) {
                    this.fillLock = true;
                    this.fill(0xff6cb7ce);
                }
            }
        }
    }
}
