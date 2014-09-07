package{
    import org.flixel.*;

    public class Message {
        public var display_text:String, sent_by:String;

        public var read:Boolean = false, sent:Boolean = false;

        public var pos:DHPoint;

        public var inbox_ref:FlxSprite;
        public var textbox:FlxText;

        public var send_time:Number, font_size:Number = 16, list_offset:Number = 30;

        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public function Message(txt:String, sec:Number,
                                inbox:FlxSprite, sender:String) {
            this.inbox_ref = inbox;
            this.sent_by = sender;
            this.pos = new DHPoint(inbox_ref.x + 5, inbox_ref.y + 10);

            this.display_text = sent_by + " >> " + txt + "\n";
            this.send_time = sec;

            this.initVisibleObjects();
        }

        public function initVisibleObjects():void {
            this.textbox = new FlxText(this.pos.x, this.pos.y,
                                       this.inbox_ref.width - 50,
                                       this.display_text);
            this.textbox.color = this.font_color;
            this.textbox.scrollFactor = new FlxPoint(0, 0);
            this.textbox.size = this.font_size;
            this.textbox.alpha = 0;
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
