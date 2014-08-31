package{
    import org.flixel.*;

    public class Message extends GameObject {
        public var msg_text:String;
        public var msg:FlxText;
        public var viewing:Boolean = false;

        public var send_time:Number;
        public var sent:Boolean = false;

        public var inbox_ref:FlxSprite;

        public var truncated_msg:FlxText;
        public var list_pos:DHPoint;
        public var list_offset:Number = 30;
        public var list_hitbox:FlxRect;

        public var exit_msg:FlxText;
        public var exit_box:FlxRect;

        public function Message(txt:String, sec:Number, inbox:FlxSprite) {
            inbox_ref = inbox;
            pos = new DHPoint(inbox_ref.x + 10, inbox_ref.y + 5);
            super(pos);

            msg_text = txt;
            send_time = sec;

            msg = new FlxText(pos.x, pos.y, inbox_ref.width, msg_text);
            msg.color = 0xff000000;
            msg.size = 16;
            FlxG.state.add(msg);
            msg.alpha = 0;

            list_pos = new DHPoint(pos.x, pos.y);

            truncated_msg = new FlxText(list_pos.x, list_pos.y, inbox_ref.width, ">> " + msg_text.slice(0,3) + "...");
            truncated_msg.color = 0xff000000;
            truncated_msg.size = 16;
            FlxG.state.add(truncated_msg);
            truncated_msg.alpha = 0;

            exit_msg = new FlxText(pos.x+inbox_ref.width-30, pos.y+5, inbox_ref.width, "X")
            exit_msg.color = 0xff000000;
            exit_msg.size = 16;
            FlxG.state.add(exit_msg);
            exit_msg.alpha = 0;

            exit_box = new FlxRect(exit_msg.x, exit_msg.y, 50, 50);

            list_hitbox = new FlxRect(truncated_msg.x, truncated_msg.y, inbox_ref.width, list_offset);
        }

        override public function update():void {
            if(sent) {
                truncated_msg.alpha = 1;
            }
            if(viewing) {
                exit_msg.alpha = 1;
            } else {
                exit_msg.alpha = 0;
            }
            truncated_msg.x = list_pos.x;
            truncated_msg.y = list_pos.y;
            list_hitbox.x = truncated_msg.x;
            list_hitbox.y = truncated_msg.y;

        }

        public function setListPos(new_pos:DHPoint):void {
            list_pos.y = new_pos.y+list_offset;
        }
    }
}