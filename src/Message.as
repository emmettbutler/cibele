package{
    import org.flixel.*;

    public class Message {
        [Embed(source="../assets/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public var display_text:String, sent_by:String;

        public var read:Boolean = false, sent:Boolean = false;

        public var pos:DHPoint;

        public var inbox_ref:GameObject;
        public var textbox:FlxText;

        public var send_time:Number, font_size:Number = 16, list_offset:Number = 30;

        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public function Message(txt:String, sec:Number,
                                inbox:GameObject, sender:String, parent:Thread) {
            this.inbox_ref = inbox;
            this.sent_by = sender;
            this.pos = new DHPoint(parent.pos.x, parent.pos.y);

            this.display_text = txt;
            this.send_time = sec;

            this.initVisibleObjects();
        }

        public function initVisibleObjects():void {
            this.textbox = new FlxText(this.pos.x, this.pos.y,
                                       this.inbox_ref.width - 50,
                                       this.sent_by + " >> " + this.display_text);
            this.textbox.scrollFactor = new FlxPoint(0, 0);
            this.textbox.alpha = 0;
            this.textbox.active = false;
            this.textbox.setFormat("NexaBold-Regular",this.font_size,this.font_color,"left");
            FlxG.state.add(this.textbox);
        }

        public function update():void {
            this.textbox.y = this.pos.y;
        }

        public function hide():void {
            this.textbox.alpha = 0;
        }

        public function show():void {
            this.textbox.alpha = 1;
        }

        public function send():void {
            this.sent = true;
        }

        public function markAsRead():void {
            this.read = true;
        }
    }
}
