package{
    import org.flixel.*;

    public class Message {
        public var display_text:String;
        public var textbox:FlxText;
        public var viewing:Boolean = false;
        public var read:Boolean = false;
        public var sent:Boolean = false;

        public var send_time:Number;
        public var sent_by:String;

        public var inbox_ref:FlxSprite;

        public var truncated_textbox:FlxText;
        public var list_offset:Number = 30;
        public var list_hitbox:FlxRect;

        public var pos:DHPoint;

        public var font_size:Number = 16;
        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public var _messages:MessageManager = null;

        public var reply_text:String;
        public var reply_sent:Boolean = false;

        public function Message(txt:String, rep:String, sec:Number,
                                inbox:FlxSprite, sender:String) {
            this.inbox_ref = inbox;
            this.sent_by = sender;
            this.reply_text = rep;
            this.pos = new DHPoint(inbox_ref.x + 5, inbox_ref.y + 10);

            this.display_text = sent_by + " >> " + txt + "\n";
            this.send_time = sec;
        }

        public function initVisibleObjects():void {
            this.textbox = new FlxText(pos.x, pos.y, inbox_ref.width - 50,
                                       display_text);
            this.textbox.color = this.font_color;
            this.textbox.scrollFactor = new FlxPoint(0, 0);
            this.textbox.size = this.font_size;
            this.textbox.alpha = 0;
            FlxG.state.add(textbox);

            this.truncated_textbox = new FlxText(pos.x, pos.y, inbox_ref.width,
                this.display_text.slice(0, this.sent_by.length + 10) + "...");
            this.truncated_textbox.color = this.font_color;
            this.truncated_textbox.scrollFactor = new FlxPoint(0, 0);
            this.truncated_textbox.size = this.font_size;
            this.truncated_textbox.alpha = 0;
            FlxG.state.add(truncated_textbox);

            this.list_hitbox = new FlxRect(this.truncated_textbox.x,
                this.truncated_textbox.y, this.inbox_ref.width, 50);
        }

        public function update():void {
            truncated_textbox.x = pos.x;
            truncated_textbox.y = pos.y;
            list_hitbox.x = truncated_textbox.x;
            list_hitbox.y = truncated_textbox.y;

            if (this._messages == null) {
                this._messages = MessageManager.getInstance();
            }

            if(this._messages.timeAlive > this.send_time && !this.sent) {
                this.sendMsg();
            }
        }

        public function setListPos(new_pos:DHPoint):void {
            pos.y = new_pos.y + list_offset;
        }

        public function hideMessage():void {
            truncated_textbox.alpha = 0;
            textbox.alpha = 0;
        }

        public function sendMsg():void {
            sent = true;
        }

        public function showPreview():void {
            textbox.alpha = 0;
            viewing = false;

            if(sent == true) {
                truncated_textbox.alpha = 1;
            }

            if(read == true){
                truncated_textbox.color = font_color;
            } else {
                truncated_textbox.color = unread_color;
            }
        }

        public function hidePreview():void {
            truncated_textbox.alpha = 0;
            textbox.alpha = 0;
        }

        public function showThread():void {
            viewing = true;
            truncated_textbox.alpha = 0;
            textbox.alpha = 1;
        }

        public function markAsRead():void {
            read = true;
        }

        public function hideFull():void {
            viewing = false;
            textbox.alpha = 0;
        }

        public function showReply():void {
            if(!reply_sent){
                reply_sent = true;
                textbox.text += "\n" + "Cibele >> " + reply_text;
            }
        }
    }
}
