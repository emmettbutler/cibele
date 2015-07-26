package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.UIElement;

    import org.flixel.*;

    public class PopUp extends UIElement {
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgXPink:Class;
        [Embed(source="/../assets/images/ui/UI_text_box_x_blue.png")] private var ImgXBlue:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x_hover.png")] private var ImgXPinkHover:Class;
        [Embed(source="/../assets/images/ui/UI_text_box_x_blue_hover.png")] private var ImgXBlueHover:Class;

        public static const CLICK_THROUGH:Number = 1;
        public var cur_anim:Number = 0;
        public var timer_key:String;
        public var tag:String;
        public var links:Array;
        public var x_sprite:UIElement;
        public var x_sprite_hover:UIElement;
        public var was_opened:Boolean = false;
        private var imgXSize:DHPoint;
        private var hover_active:Boolean = false;

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

            var imgClass:Class = ImgXPink;
            var imgHoverClass:Class = ImgXPinkHover;
            imgXSize = new DHPoint(32, 29);

            this.x_sprite = XSprite.fromPoint(new DHPoint((this.x+w)-imgXSize.x, this.y+1));
            this.x_sprite.loadGraphic(imgClass, false, false, imgXSize.x, imgXSize.y);
            this.x_sprite_hover = XSprite.fromPoint(new DHPoint((this.x+w)-imgXSize.x, this.y+1));
            this.x_sprite_hover.loadGraphic(imgHoverClass, false, false, imgXSize.x, imgXSize.y);

            this.visible = false;
            this.x_sprite.visible = false;
            this.x_sprite.scrollFactor.x = 0;
            this.x_sprite.scrollFactor.y = 0;
            this.x_sprite_hover.visible = false;
            this.x_sprite_hover.scrollFactor.x = 0;
            this.x_sprite_hover.scrollFactor.y = 0;
            this.scrollFactor.x = 0;
            this.scrollFactor.y = 0;
        }

        override public function update():void {
            if (this.visible) {
                if (this.hover_active) {
                    this.x_sprite.visible = false;
                    this.x_sprite_hover.visible = true;
                } else {
                    this.x_sprite.visible = true;
                    this.x_sprite_hover.visible = false;
                }
            } else {
                this.x_sprite_hover.visible = false;
                this.x_sprite.visible = false;
            }
        }

        override public function updatePos():void {
            super.updatePos();
            this.x_sprite.x = (this.x + this.width) - 26;
            this.x_sprite.y = this.y - 5;
            this.x_sprite_hover.x = (this.x + this.width) - 26;
            this.x_sprite_hover.y = this.y - 5;
        }

        public function open():void {
            this.visible = true;
        }

        public function showXHover():void {
            this.hover_active = true;
        }

        public function hideXHover():void {
            this.hover_active = false;
        }

        override public function destroy():void { }
    }
}
