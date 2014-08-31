package{
    import org.flixel.*;

    public class Message extends GameObject {
        public var msg_text:String;
        public var msg:FlxText;
        public var viewing:Boolean = false;
        public var read:Boolean = false;

        public var send_time:Number;
        public var sent:Boolean = false;

        public var inbox_ref:FlxSprite;

        public var truncated_msg:FlxText;
        public var list_pos:DHPoint;
        public var list_offset:Number = 30;
        public var list_hitbox:FlxRect;

        public var exit_msg:FlxText;
        public var exit_box:FlxRect;

        public var font_size:Number = 16;
        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xffF584CA;

        public function Message(txt:String, sec:Number, inbox:FlxSprite) {
            inbox_ref = inbox;
            pos = new DHPoint(inbox_ref.x + 10, inbox_ref.y + 5);
            super(pos);

            msg_text = txt;
            send_time = sec;

            msg = new FlxText(pos.x, pos.y, inbox_ref.width, msg_text);
            msg.color = font_color;
            msg.size = font_size;
            FlxG.state.add(msg);
            msg.alpha = 0;

            list_pos = new DHPoint(pos.x, pos.y);

            truncated_msg = new FlxText(list_pos.x, list_pos.y, inbox_ref.width, ">> " + msg_text.slice(0,3) + "...");
            truncated_msg.color = font_color;
            truncated_msg.size = font_size;
            FlxG.state.add(truncated_msg);
            truncated_msg.alpha = 0;

            exit_msg = new FlxText(pos.x+inbox_ref.width-30, pos.y+5, inbox_ref.width, "X")
            exit_msg.color = font_color;
            exit_msg.size = font_size;
            FlxG.state.add(exit_msg);
            exit_msg.alpha = 0;

            exit_box = new FlxRect(exit_msg.x, exit_msg.y, 50, 50);

            list_hitbox = new FlxRect(truncated_msg.x, truncated_msg.y, inbox_ref.width, list_offset);
        }

        override public function update():void {
            if(sent == true) {
                truncated_msg.alpha = 1;
            }
            if(viewing == true) {
                exit_msg.alpha = 1;
            } else {
                exit_msg.alpha = 0;
            }
            if(read == true){
                truncated_msg.color = font_color;
            } else {
                truncated_msg.color = unread_color;
            }
            truncated_msg.x = list_pos.x;
            truncated_msg.y = list_pos.y;
            list_hitbox.x = truncated_msg.x;
            list_hitbox.y = truncated_msg.y;

        }

        public function setListPos(new_pos:DHPoint):void {
            list_pos.y = new_pos.y+list_offset;
        }

        public function hideMessages():void {
            truncated_msg.alpha = 0;
            msg.alpha = 0;
            exit_msg.alpha = 0;
        }
    }
}