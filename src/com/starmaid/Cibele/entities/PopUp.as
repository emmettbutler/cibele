package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.UIElement;

    import org.flixel.*;

    public class PopUp extends UIElement {
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgXPink:Class;
        [Embed(source="/../assets/images/ui/UI_text_box_x_blue.png")] private var ImgXBlue:Class;

        public static const CLICK_THROUGH:Number = 1;
        public var cur_anim:Number = 0;
        public var timer_key:String;
        public var tag:String;
        public var links:Array;
        public var x_sprite:UIElement;
        public var was_opened:Boolean = false;

        public function PopUp(img:Class, w:Number, h:Number,
                              functionality:Number=0, tag:String=null,
                              links:Array=null) {
            this.timer_key = Math.random() + "";

            var _screen:ScreenManager = ScreenManager.getInstance();
            super(_screen.screenWidth - w - 100, _screen.screenHeight * .1);
            this._state = functionality;
            this.tag = tag;
            this.links = links;
            this.loadGraphic(img,false,false,w,h);

            var imgXSize:DHPoint = new DHPoint(23, 18);
            var imgClass:Class = ImgXPink;

            this.x_sprite = UIElement.fromPoint(new DHPoint((this.x+w)-imgXSize.x, this.y+1));
            this.x_sprite.loadGraphic(imgClass, false, false, imgXSize.x, imgXSize.y);

            this.visible = false;
            this.x_sprite.visible = false;
            this.x_sprite.scrollFactor.x = 0;
            this.x_sprite.scrollFactor.y = 0;
            this.scrollFactor.x = 0;
            this.scrollFactor.y = 0;
        }

        override public function update():void {
            if(this.visible) {
                this.x_sprite.visible = true;
            } else {
                this.x_sprite.visible = false;
            }
        }

        public function updatePos():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.x = _screen.screenWidth - this.width - 100;
            this.y = _screen.screenHeight * .1;
        }

        public function open():void {
            this.visible = true;
        }

        override public function destroy():void { }
    }
}
