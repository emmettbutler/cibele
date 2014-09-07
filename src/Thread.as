package{
    import org.flixel.*;

    public class Thread {
        public var display_text:String, sent_by:String;

        public var viewing:Boolean = false, unread:Boolean = true;

        public var inbox_ref:FlxSprite;
        public var list_hitbox:FlxRect;
        public var truncated_textbox:FlxText;

        public var pos:DHPoint;

        public var font_size:Number = 16, list_offset:Number = 30,
                   last_send_time:Number = 0, sent_count:Number = 0;

        public var font_color:uint = 0xff000000;
        public var unread_color:uint = 0xff982708;

        public var _messages:MessageManager = null;

        public var messages:Array;

        public function Thread(inbox:FlxSprite,
                               ... messages) {
            this.inbox_ref = inbox;
            this.sent_by = messages[0][0];
            this.pos = new DHPoint(this.inbox_ref.x + 5, this.inbox_ref.y + 10);

            this.messages = new Array();
            var cur_message:Array;
            for (var i:int = 0; i < messages.length; i++) {
                cur_message = messages[i];
                this.messages.push(new Message(cur_message[1], cur_message[2],
                                               inbox, cur_message[0]));
            }

            this.display_text = messages[0][1];

            this.initVisibleObjects();
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

            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].initVisibleObjects();
            }
        }

        public function send(cur:Message, prev:Message, first:Boolean=false):void {
            cur.send();
            if (this.viewing) {
                cur.show();
            } else {
                this.unread = true;
            }
            if (!first) {
                cur.pos.y = prev.pos.y + 50;
            }
            this.sent_count++;
            this.last_send_time = this._messages.timeAlive;
            this.display_text = cur.display_text;
            this.truncated_textbox.color = this.unread_color;
            this.truncated_textbox.text = this.sent_by + " >> " +
                this.display_text.slice(0, this.sent_by.length + 10) +
                "...";

            if (this.sent_count > 3) {
                this.rotate();
            }
        }

        public function rotate():void {
            for (var i:int = 0; i < this.messages.length; i++) {
                if (this.messages[i].sent) {
                    if (i != 0) {
                        this.messages[i].pos.y = this.messages[i - 1].pos.y + 50;
                    } else {
                        this.messages[i].pos.y -= 50;
                    }
                    if (this.messages[i].pos.y < this.inbox_ref.y) {
                        this.messages[i].hide();
                    }
                }
            }
        }

        public function update():void {
            if (this._messages == null) {
                this._messages = MessageManager.getInstance();
            }

            var time_since_last_send:Number = this._messages.timeAlive - this.last_send_time;

            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].update();

                if(this.messages[i].send_time != -1 &&
                    time_since_last_send > this.messages[i].send_time &&
                    (i == 0 || (i > 0 && this.messages[i - 1].sent)) &&
                    !this.messages[i].sent)
                {
                    this.send(this.messages[i], this.messages[i - 1], i == 0);
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
            for (var i:int = 0; i < messages.length; i++) {
                if (!this.messages[i].sent &&
                    this.messages[i].sent_by == MessageManager.SENT_BY_CIBELE)
                {
                    this.messages[i].send();
                    this.messages[i].show();
                    this.messages[i].pos.y = this.messages[i - 1].pos.y + 50;
                    this.last_send_time = this._messages.timeAlive;
                    this.sent_count++;
                    if (this.sent_count > 3) {
                        this.rotate();
                    }
                    break;
                }
            }
        }
    }
}
