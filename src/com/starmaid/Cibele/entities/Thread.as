package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.entities.Message;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.UIElement;

    import org.flixel.*;

    import flash.events.Event;

    public class Thread {
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="/../assets/images/ui/UI_unread_msg.png")] private var ImgUnreadMsg:Class;
        [Embed(source="/../assets/images/ui/UI_read_msg.png")] private var ImgReadMsg:Class;


        private var display_text:String, sent_by:String;

        private var _viewing:Boolean = false, _read:Boolean = false, start_read_flag:Boolean = false, start_read_lock:Boolean = false, _awaiting_reply:Boolean = false;

        private var unread_icon:UIElement, read_icon:UIElement;
        private var _inbox_ref:GameObject;
        private var _list_hitbox:FlxRect;
        private var truncated_textbox:FlxText;

        private var _pos:DHPoint;
        private var messages:Array;

        private var list_offset:Number = 40,
                   sent_count:Number = 0,
                   list_hitbox_width:Number = 400,
                   list_hitbox_height:Number = 25;
        public static const MSG_PADDING:Number = 10;
        private var font_color:uint = 0xff8b8b8b;
        private var unread_color:uint = 0xff616161;

        public function Thread(inbox:GameObject, start_read:Boolean=false,
                               ... messages) {
            this._inbox_ref = inbox;
            this.sent_by = messages[0][0];
            this.pos = new DHPoint(this._inbox_ref.x + 20, this._inbox_ref.y + 30);

            if(start_read) {
                this.read = true;
                this.start_read_flag = true;
            }

            this.messages = new Array();
            var cur_message:Array;
            for (var i:int = 0; i < messages.length; i++) {
                cur_message = messages[i];
                this.messages.push(new Message(cur_message[1], cur_message[2],
                                               inbox, cur_message[0], this, this.read));
            }

            this.display_text = messages[0][1];

            GlobalTimer.getInstance().setMark(this.messages[0].display_text,
                                              this.messages[0].send_time);
            this.initVisibleObjects();
        }

        public function set awaiting_reply(r:Boolean):void {
            this._awaiting_reply = r;
        }

        public function get awaiting_reply():Boolean {
            return this._awaiting_reply;
        }

        public function set viewing(v:Boolean):void {
            this._viewing = v;
        }

        public function get viewing():Boolean {
            return this._viewing;
        }

        public function set read(r:Boolean):void {
            this._read = r;
        }

        public function get read():Boolean {
            return this._read;
        }

        public function set list_hitbox(l:FlxRect):void {
            this._list_hitbox = l;
        }

        public function get list_hitbox():FlxRect {
            return this._list_hitbox;
        }

        public function set pos(l:DHPoint):void {
            this._pos = l;
        }

        public function get pos():DHPoint {
            return this._pos;
        }

        public function set inbox_ref(ref:GameObject):void {
            if (this._inbox_ref != ref) {
                this._inbox_ref = ref;
                for (var i:int = 0; i < this.messages.length; i++) {
                    this.messages[i].inbox_ref = ref;
                }
            }
        }

        public function updatePos():void {
            this.pos.x = this._inbox_ref.x + 20;
            this.pos.y = this._inbox_ref.y + 30;

            this.truncated_textbox.x = this.pos.x+40;
            this.truncated_textbox.y = this.pos.y;
            this.unread_icon.x = this.pos.x;
            this.unread_icon.y = this.pos.y;
            this.read_icon.x = this.pos.x;
            this.read_icon.y = this.pos.y;
            this.list_hitbox.x = this.pos.x;
            this.list_hitbox.y = this.pos.y;

            this.rotate();
        }

        public function initVisibleObjects():void {
            this.truncated_textbox = new FlxText(pos.x, pos.y, _inbox_ref.width,
                this.sent_by + " >> " +
                this.display_text.slice(0, this.sent_by.length + 10) +
                "...");
            this.truncated_textbox.setFormat("NexaBold-Regular",MessageManager.FONT_SIZE,this.font_color,"left");
            this.truncated_textbox.scrollFactor = new FlxPoint(0, 0);
            this.truncated_textbox.visible = false;
            this.truncated_textbox.active = false;
            FlxG.state.add(truncated_textbox);
            if(!this.read) {
                this.truncated_textbox.color = this.unread_color;
            }

            this.unread_icon = new UIElement(pos.x, pos.y);
            this.unread_icon.loadGraphic(ImgUnreadMsg, false, false, 38, 31);
            this.unread_icon.visible = false;
            this.unread_icon.active = false;
            this.unread_icon.scrollFactor = new DHPoint(0,0);
            FlxG.state.add(this.unread_icon);

            this.read_icon = new UIElement(pos.x, pos.y);
            this.read_icon.loadGraphic(ImgReadMsg, false, false, 38, 31);
            this.read_icon.visible = false;
            this.read_icon.active = false;
            this.read_icon.scrollFactor = new DHPoint(0,0);
            FlxG.state.add(this.read_icon);

            this.list_hitbox = new FlxRect(pos.x,
                pos.y, this.list_hitbox_width, this.list_hitbox_height);
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].initVisibleObjects();
            }
        }

        private function send(cur:Message, prev:Message, next:Message, first:Boolean=false):void {
            cur.send();
            if (this.viewing) {
                cur.show();
                this.read = true;
                if(cur.sent_by != MessageManager.SENT_BY_CIBELE) {
                    MessageManager.getInstance().showReplyButton();
                    this.awaiting_reply = false;
                }
            } else {
                this.read = false;
                if(this.truncated_textbox.visible) {
                    this.unread_icon.visible = true;
                    this.read_icon.visible = false;
                }
            }

            if(this.read) {
                this.truncated_textbox.color = this.font_color;
            } else {
                this.truncated_textbox.color = this.unread_color;
            }

            if (!first) {
                cur.pos.y = prev.pos.y + 50;
            }
            this.sent_count++;
            GlobalTimer.getInstance().setMark(next.display_text, next.send_time);
            this.display_text = cur.display_text;
            this.truncated_textbox.text = this.sent_by + " >> " +
                this.display_text.slice(0, this.sent_by.length + 10) +
                "...";
        }

        private function setBaseMsgPos():void {
            var allSent:Array = new Array();
            for (var i:int = 0; i < this.messages.length; i++) {
                if (this.messages[i].sent) {
                    allSent.push(this.messages[i]);
                }
            }
            var totalVisibleHeight:Number = 0,
                invisibleMsgStackHeight:Number = 0;
            for (var k:int = allSent.length - 1; k >= 0; k--) {
                if (totalVisibleHeight + allSent[k].textbox.height <=
                    this._inbox_ref.height - 55)
                {
                    totalVisibleHeight += allSent[k].textbox.height + MSG_PADDING;
                } else {
                    invisibleMsgStackHeight += allSent[k].textbox.height + MSG_PADDING;
                }
            }
            this.messages[0].pos.y = this._inbox_ref.y - invisibleMsgStackHeight + 20;
        }

        public function rotate():void {
            this.setBaseMsgPos();
            for (var i:int = 0; i < this.messages.length; i++) {
                if (this.messages[i].sent) {
                    if (i != 0) {
                        this.messages[i].pos.y = this.messages[i - 1].pos.y + this.messages[i - 1].textbox.height + MSG_PADDING;
                    }
                    if (this.messages[i].pos.y < this._inbox_ref.y) {
                        this.messages[i].hide();
                    }
                }
            }
        }

        public function update():void {
            var passed:Boolean;
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].update();

                passed = GlobalTimer.getInstance().hasPassed(
                    this.messages[i].display_text
                );

                if(this.messages[i].send_time != -1 && passed &&
                    (i == 0 || (i > 0 && this.messages[i - 1].sent)) &&
                    !this.messages[i].sent)
                {
                    this.send(
                        this.messages[i],
                        this.messages[i - 1],
                        this.messages[i + 1],
                        i == 0
                    );
                    this.awaiting_reply = false;
                    FlxG.stage.dispatchEvent(new Event(GameState.EVENT_CHAT_RECEIVED));
                }
            }
        }

        public function setListPos(new_pos:DHPoint):void {
            this.pos.y = new_pos.y + this.list_offset;
            this.truncated_textbox.y = this.pos.y;
            this.unread_icon.y = this.pos.y;
            this.read_icon.y = this.pos.y;
            this.list_hitbox = new FlxRect(this.pos.x,
                this.pos.y, this.list_hitbox_width, this.list_hitbox_height);
        }

        public function hide():void {
            this.truncated_textbox.visible = false;
            this.unread_icon.visible = false;
            this.unread_icon.active = false;
            this.read_icon.visible = false;
            this.read_icon.active = false;
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
            if(this.messages[this.messages.length-1].read && this.start_read_flag && !this.start_read_lock) {
                this.start_read_lock = true;
                this.read = true;
            }
            this.viewing = false;
            this.truncated_textbox.visible = true;
            if(this.read){
                this.truncated_textbox.color = this.font_color;
                this.read_icon.visible = true;
                this.read_icon.active = true;
            } else {
                this.truncated_textbox.color = this.unread_color;
                this.unread_icon.visible = true;
                this.unread_icon.active = true;
            }
        }

        public function hidePreview():void {
            this.truncated_textbox.visible = false;
            this.unread_icon.visible = false;
            this.unread_icon.active = false;
            this.read_icon.visible = false;
            this.read_icon.active = false;
        }

        public function show():void {
            this.viewing = true;
            this.read = true;
            this.unread_icon.visible = false;
            this.unread_icon.active = false;
            this.read_icon.visible = false;
            this.read_icon.active = false;
            this.truncated_textbox.visible = false;
            for (var i:int = 0; i < this.messages.length; i++) {
                if (this.messages[i].sent) {
                    if (this.messages[i].pos.y >= this._inbox_ref.y) {
                        this.messages[i].show();
                    }
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
            var next:Message;
            for (var i:int = 0; i < this.messages.length; i++) {
                next = this.messages[i + 1];
                if (!this.messages[i].sent &&
                    this.messages[i].sent_by == MessageManager.SENT_BY_CIBELE && (i == 0 || this.messages[i - 1].sent))
                {
                    this.messages[i].send();
                    this.messages[i].show();
                    //this.messages[i].pos.y = this.messages[i - 1].pos.y + 50;
                    if (next != null) {
                        this.awaiting_reply = true;
                        GlobalTimer.getInstance().setMark(
                            next.display_text, next.send_time
                        );
                    } else if (next == null) {
                        this.awaiting_reply = true;
                    }
                    this.sent_count++;
                    break;
                }
            }
        }
    }
}
