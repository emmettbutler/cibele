package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.entities.Message;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    import flash.events.Event;

    public class Thread {
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public var display_text:String, sent_by:String;

        public var viewing:Boolean = false, unread:Boolean = true;

        private var _inbox_ref:GameObject;
        public var list_hitbox:FlxRect;
        public var truncated_textbox:FlxText;

        public var pos:DHPoint;

        public var list_offset:Number = 40,
                   sent_count:Number = 0;

        public var font_color:uint = 0xff616161;
        public var unread_color:uint = 0xffc1698a;

        public var messages:Array;

        public var list_hitbox_width:Number = 380;
        public var list_hitbox_height:Number = 25;

        public static const MSG_PADDING:Number = 10;

        public function Thread(inbox:GameObject,
                               ... messages) {
            this._inbox_ref = inbox;
            this.sent_by = messages[0][0];
            this.pos = new DHPoint(this._inbox_ref.x + 20, this._inbox_ref.y + 30);

            this.messages = new Array();
            var cur_message:Array;
            for (var i:int = 0; i < messages.length; i++) {
                cur_message = messages[i];
                this.messages.push(new Message(cur_message[1], cur_message[2],
                                               inbox, cur_message[0], this));
            }

            this.display_text = messages[0][1];

            GlobalTimer.getInstance().setMark(this.messages[0].display_text,
                                              this.messages[0].send_time);

            this.initVisibleObjects();
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

            this.truncated_textbox.x = pos.x;
            this.truncated_textbox.y = pos.y;
            this.list_hitbox.x = this.truncated_textbox.x;
            this.list_hitbox.y = this.truncated_textbox.y;

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


            this.list_hitbox = new FlxRect(this.truncated_textbox.x,
                this.truncated_textbox.y, this.list_hitbox_width, this.list_hitbox_height);
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].initVisibleObjects();
            }
        }

        private function send(cur:Message, prev:Message, next:Message, first:Boolean=false):void {
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
            GlobalTimer.getInstance().setMark(next.display_text, next.send_time);
            this.display_text = cur.display_text;
            this.truncated_textbox.color = this.unread_color;
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
                    FlxG.stage.dispatchEvent(new Event(GameState.EVENT_CHAT_RECEIVED));
                }
            }
        }

        public function setListPos(new_pos:DHPoint):void {
            this.pos.y = new_pos.y + this.list_offset;
            this.truncated_textbox.y = this.pos.y;
            this.list_hitbox = new FlxRect(this.truncated_textbox.x,
                this.truncated_textbox.y, this.list_hitbox_width, this.list_hitbox_height);
        }

        public function hide():void {
            this.truncated_textbox.visible = false;
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
            this.truncated_textbox.visible = true;

            if(this.unread == false){
                this.truncated_textbox.color = this.font_color;
            } else {
                this.truncated_textbox.color = this.unread_color;
            }
        }

        public function hidePreview():void {
            this.truncated_textbox.visible = false;
        }

        public function show():void {
            this.viewing = true;
            this.unread = false;
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
                        GlobalTimer.getInstance().setMark(
                            next.display_text, next.send_time
                        );
                    }
                    this.sent_count++;
                    break;
                }
            }
        }
    }
}
