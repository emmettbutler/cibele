package{
    import org.flixel.*;

    public class Message {
        public var msg_text:String;
        public var msg:FlxText;
        public var viewing:Boolean = false;
        public var read:Boolean = false;

        public var send_time:Number;
        public var sent:Boolean = false;
        public var sent_by:String;

        public var inbox_ref:FlxSprite;

        public var truncated_msg:FlxText;
        public var list_pos:DHPoint;
        public var list_offset:Number = 30;
        public var list_hitbox:FlxRect;

        public var exit_msg:FlxText;
        public var exit_box:FlxRect;
        public var reply_to_msg:FlxText;
        public var reply_box:FlxRect;

        public var pos:DHPoint;

        public var font_size:Number = 16;
        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public var _messages:MessageManager = null;

        public var reply_text:String;
        public var reply_sent:Boolean = false;

        public function Message(txt:String, rep:String, sec:Number, inbox:FlxSprite, sender:String) {
            inbox_ref = inbox;
            sent_by = sender;
            reply_text = rep;
            pos = new DHPoint(inbox_ref.x + 5, inbox_ref.y + 10);

            msg_text = sent_by + " >> " + txt + "\n";
            send_time = sec;
        }

        public function initVisibleObjects():void {
            msg = new FlxText(pos.x, pos.y, inbox_ref.width-50, msg_text);
            msg.color = font_color;
            msg.scrollFactor = new FlxPoint(0, 0);
            msg.size = font_size;
            FlxG.state.add(msg);
            msg.alpha = 0;

            list_pos = new DHPoint(pos.x, pos.y);

            truncated_msg = new FlxText(list_pos.x, list_pos.y, inbox_ref.width, msg_text.slice(0,sent_by.length + 10) + "...");
            truncated_msg.color = font_color;
            truncated_msg.scrollFactor = new FlxPoint(0, 0);
            truncated_msg.size = font_size;
            FlxG.state.add(truncated_msg);
            truncated_msg.alpha = 0;

            exit_msg = new FlxText(inbox_ref.x+110, inbox_ref.y+(inbox_ref.height-25), inbox_ref.width, "| Back")
            exit_msg.color = font_color;
            exit_msg.size = font_size;
            exit_msg.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(exit_msg);
            exit_msg.alpha = 0;

            exit_box = new FlxRect(exit_msg.x, exit_msg.y, 50, 50);

            reply_to_msg = new FlxText(inbox_ref.x+172, inbox_ref.y+(inbox_ref.height-25), inbox_ref.width, "| Reply")
            reply_to_msg.color = font_color;
            reply_to_msg.size = font_size;
            reply_to_msg.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(reply_to_msg);
            reply_to_msg.alpha = 0;

            reply_box = new FlxRect(reply_to_msg.x, reply_to_msg.y, 50, 50);

            list_hitbox = new FlxRect(truncated_msg.x, truncated_msg.y, inbox_ref.width, list_offset);
        }

        public function update():void {
            truncated_msg.x = list_pos.x;
            truncated_msg.y = list_pos.y;
            list_hitbox.x = truncated_msg.x;
            list_hitbox.y = truncated_msg.y;

            if (this._messages == null) {
                this._messages = MessageManager.getInstance();
            }

            if(this._messages.timeAlive > this.send_time && !this.sent) {
                this.sendMsg();
            }
        }

        public function setListPos(new_pos:DHPoint):void {
            list_pos.y = new_pos.y + list_offset;
        }

        public function hideMessage():void {
            truncated_msg.alpha = 0;
            msg.alpha = 0;
            exit_msg.alpha = 0;
            reply_to_msg.alpha = 0;
        }

        public function sendMsg():void {
            sent = true;
        }

        public function showPreview():void {
            msg.alpha = 0;
            viewing = false;
            exit_msg.alpha = 0;
            reply_to_msg.alpha = 0;

            if(sent == true) {
                truncated_msg.alpha = 1;
            }

            if(read == true){
                truncated_msg.color = font_color;
            } else {
                truncated_msg.color = unread_color;
            }
        }

        public function hidePreview():void {
            truncated_msg.alpha = 0;
            msg.alpha = 0;
        }

        public function showThread():void {
            viewing = true;
            truncated_msg.alpha = 0;
            msg.alpha = 1;
            exit_msg.alpha = 1;
            reply_to_msg.alpha = 1;
        }

        public function markAsRead():void {
            read = true;
        }

        public function hideFull():void {
            viewing = false;
            msg.alpha = 0;
        }

        public function showReply():void {
            if(!reply_sent){
                reply_sent = true;
                msg.text += "\n" + "Cibele >> " + reply_text;
            }
        }
    }
}
