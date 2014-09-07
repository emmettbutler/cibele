package{
    import org.flixel.*;

    public class Thread {
        public var display_text:String, sent_by:String;

        public var viewing:Boolean = false, read:Boolean = false,
                   sent:Boolean = false;

        public var inbox_ref:FlxSprite;
        public var list_hitbox:FlxRect;
        public var truncated_textbox:FlxText, textbox:FlxText;

        public var pos:DHPoint;

        public var send_time:Number, font_size:Number = 16, list_offset:Number = 30;

        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public var _messages:MessageManager = null;

        public var reply_text:String;
        public var reply_sent:Boolean = false;

        public function Thread(txt:String, rep:String, sec:Number,
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
                this.truncated_textbox.y, this.inbox_ref.width, 10);
        }

        public function update():void {
            if (this._messages == null) {
                this._messages = MessageManager.getInstance();
            }

            if(this._messages.timeAlive > this.send_time && !this.sent) {
                this.sendMsg();
            }
        }

        public function setListPos(new_pos:DHPoint):void {
            this.pos.y = new_pos.y + this.list_offset;
            this.truncated_textbox.y = this.pos.y;
            this.list_hitbox = new FlxRect(this.truncated_textbox.x,
                this.truncated_textbox.y, this.inbox_ref.width, 10);
        }

        public function hideMessage():void {
            this.truncated_textbox.alpha = 0;
            this.textbox.alpha = 0;
        }

        public function sendMsg():void {
            this.sent = true;
        }

        public function showPreview():void {
            this.textbox.alpha = 0;
            this.viewing = false;

            if(this.sent == true) {
                this.truncated_textbox.alpha = 1;
            }

            if(this.read == true){
                this.truncated_textbox.color = this.font_color;
            } else {
                this.truncated_textbox.color = this.unread_color;
            }
        }

        public function hidePreview():void {
            this.truncated_textbox.alpha = 0;
            this.textbox.alpha = 0;
        }

        public function showThread():void {
            this.viewing = true;
            this.truncated_textbox.alpha = 0;
            this.textbox.alpha = 1;
        }

        public function markAsRead():void {
            this.read = true;
        }

        public function hideFull():void {
            this.viewing = false;
            this.textbox.alpha = 0;
        }

        public function showReply():void {
            if(!this.reply_sent){
                this.reply_sent = true;
                this.textbox.text += "\n" + "Cibele >> " + this.reply_text;
            }
        }
    }
}
