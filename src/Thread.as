package{
    import org.flixel.*;

    public class Thread {
        public var display_text:String, sent_by:String;

        public var viewing:Boolean = false, unread:Boolean = true;

        public var inbox_ref:FlxSprite;
        public var list_hitbox:FlxRect;
        public var truncated_textbox:FlxText;

        public var pos:DHPoint;

        public var font_size:Number = 16, list_offset:Number = 30;

        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public var _messages:MessageManager = null;

        public var messages:Array;

        public function Thread(sec:Number, inbox:FlxSprite, sender:String,
                               ... messages) {
            this.inbox_ref = inbox;
            this.sent_by = sender;
            this.pos = new DHPoint(this.inbox_ref.x + 5, this.inbox_ref.y + 10);

            this.messages = new Array();
            var send_time:Number;
            for (var i:int = 0; i < messages.length; i++) {
                if (i == 0) {
                    send_time = sec;
                } else {
                    send_time = -1;
                }
                this.messages.push(new Message(messages[i], send_time, inbox, sender));
            }

            this.display_text = sent_by + " >> " + messages[0] + "\n";
        }

        public function initVisibleObjects():void {
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

            for (var i:int = 0; i < this.messages.length; i++) {
                if(this.messages[i].send_time != -1 &&
                    this._messages.timeAlive > this.messages[i].send_time &&
                    !this.messages[i].sent)
                {
                    this.messages[i].sendMsg();
                }
            }
        }

        public function setListPos(new_pos:DHPoint):void {
            this.pos.y = new_pos.y + this.list_offset;
            this.truncated_textbox.y = this.pos.y;
            this.list_hitbox = new FlxRect(this.truncated_textbox.x,
                this.truncated_textbox.y, this.inbox_ref.width, 10);
        }

        public function hide():void {
            this.truncated_textbox.alpha = 0;
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].hide();
            }
        }

        public function markAsRead():void {
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].markAsRead();
            }
        }

        public function showPreview():void {
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].hide();
            }
            this.viewing = false;
            this.truncated_textbox.alpha = 1;

            if(this.unread == false){
                this.truncated_textbox.color = this.font_color;
            } else {
                this.truncated_textbox.color = this.unread_color;
            }
        }

        public function hidePreview():void {
            this.truncated_textbox.alpha = 0;
        }

        public function show():void {
            this.viewing = true;
            this.unread = false;
            this.truncated_textbox.alpha = 0;
            for (var i:int = 0; i < this.messages.length; i++) {
                if (this.messages[i].sent) {
                    this.messages[i].show();
                }
            }
        }

        public function hideFull():void {
            this.viewing = false;
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].hide();
            }
        }

        public function reply():void {

        }
    }
}
