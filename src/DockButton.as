package {
    import org.flixel.*;

    public class DockButton extends UIElement {
        private var cur_popup:PopUp;
        public var cur_popup_tag:String;
        private var ownedKeys:Array;
        public var hasOpened:Boolean = true;
        public var tag:String;

        public function DockButton(x:Number, y:Number, ownedKeys:Array, tag:String) {
            super(x, y);
            this.ownedKeys = ownedKeys;
            this.tag = tag;
        }

        override public function update():void {
            super.update();
            if (!this.hasOpened) {
                this.alert();
            }
        }

        public function ownsKey(key:String):Boolean {
            return this.ownedKeys.indexOf(key) != -1;
        }

        public function sendPopup(popup:PopUp):void {
            this.setCurPopup(popup);
            this.hasOpened = false;
        }

        public function open():void {
            this.hasOpened = true;
            if (this.cur_popup != null) {
                this.cur_popup.visible = true;
            }
        }

        public function setCurPopup(popup:PopUp):void {
            this.cur_popup = popup;
            if (this.cur_popup != null) {
                this.cur_popup_tag = popup.tag;
            }
        }

        public function getCurPopup():PopUp {
            return this.cur_popup;
        }
    }
}
