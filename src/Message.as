package{
    import org.flixel.*;

    public class Message extends GameObject {
        public var msg_text:String;
        public var msg:FlxText;
        public var send_time:Number;
        public var sent:Boolean = false;
        public var inbox_ref:FlxSprite;
        public var truncated_msg:FlxText;
        public var list_pos:DHPoint;
        public var msg_offset:Number = 10;

        public function Message(txt:String, sec:Number, inbox:FlxSprite) {
            inbox_ref = inbox;
            pos = new DHPoint(inbox_ref.x + 10, inbox_ref.y + 5);
            super(pos);

            msg_text = txt;
            send_time = sec;

            msg = new FlxText(pos.x, pos.y, inbox_ref.width, msg_text);
            msg.color = 0xff000000;
            FlxG.state.add(msg);
            msg.alpha = 0;

            list_pos = new DHPoint(pos.x, pos.y);

            truncated_msg = new FlxText(list_pos.x, list_pos.y, inbox_ref.width, msg_text.slice(0,3) + "...");
            truncated_msg.color = 0xff000000;
            FlxG.state.add(truncated_msg);
            truncated_msg.alpha = 0;
        }

        override public function update():void {
            if(sent){
                truncated_msg.alpha = 1;
            }
            truncated_msg.x = list_pos.x;
            truncated_msg.y = list_pos.y;

        }

        public function setListPos(new_pos:DHPoint):void {
            list_pos.y = new_pos.y+msg_offset;
        }
    }
}