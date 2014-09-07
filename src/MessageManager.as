package{
    import org.flixel.*;

    public class MessageManager {
        [Embed(source="../assets/messages.png")] private var ImgMsg:Class;
        [Embed(source="../assets/inbox.png")] private var ImgInbox:Class;

        public static var _instance:MessageManager = null;

        public var notifications_text:FlxText, exit_inbox:FlxText,
                   debugText:FlxText;

        public var img_inbox:FlxSprite;

        public var notifications_box:FlxRect, exit_inbox_rect:FlxRect,
                   mouse_rect:FlxRect;

        public var messages:Array;
        public var cur_viewing:Message;

        public var unread_count:Number = 0;
        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;

        public var _screen:ScreenManager = ScreenManager.getInstance();

        public static const STATE_HIDE_INBOX:Number = 0;
        public static const STATE_VIEW_LIST:Number = 1;
        public static const STATE_VIEW_MESSAGE:Number = 2;
        public var _state:Number = STATE_HIDE_INBOX;

        public function MessageManager() {
            this.bornTime = new Date().valueOf();
            this.initNotifications();

            this.messages = new Array(
                new Message("did you get that link i sent you on aim last night? its an anime you might like :D", "yeah! the fairies were very very cute and i think that VA was in sailor moon??", 1, this.img_inbox, "Rusher"),
                new Message("hey giiiiiirl how are things? you never chat with me anymore </3", ";_; sorry, ive been pretty busy, ampule has been doing a lot lately", 1, this.img_inbox, "GuyverGuy"),
                new Message("Cib! Wanna do a euryale run w/ me on friday?", "ok! <3 see you then girl~", 1, this.img_inbox, "Airia")
            );

            this.loadVisibleMessageObjects();

            for(var i:int = 0; i < this.messages.length; i++) {
                if(!this.messages[i].read) {
                    this.unread_count += 1;
                }
                if(i != 0){
                    this.messages[i].setListPos(this.messages[i - 1].pos);
                }
            }
        }

        public function initNotifications():void {
            this.mouse_rect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y, 5, 5);
            var notifications_pos:DHPoint = new DHPoint(
                _screen.screenWidth * .001, _screen.screenHeight * .85);
            var img_msg:FlxSprite = new FlxSprite(
                notifications_pos.x, notifications_pos.y);
            img_msg.loadGraphic(ImgMsg, false, false, 197, 71);
            img_msg.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(img_msg);

            this.notifications_text = new FlxText(
                notifications_pos.x, notifications_pos.y,
                img_msg.width, this.unread_count.toString() + " unread messages.");
            this.notifications_text.size = 14;
            this.notifications_text.color = 0xff000000;
            this.notifications_text.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(this.notifications_text);

            this.notifications_box = new FlxRect(this.notifications_text.x,
                                                 this.notifications_text.y,
                                                 img_msg.width, 100);
            this.notifications_box.x = this.notifications_text.x;
            this.notifications_box.y = this.notifications_text.y;

            var inbox_pos:DHPoint = new DHPoint(_screen.screenWidth * .05,
                                                _screen.screenHeight * .3);
            this.img_inbox = new FlxSprite(inbox_pos.x, inbox_pos.y);
            this.img_inbox.loadGraphic(ImgInbox, false, false, 500, 230);
            this.img_inbox.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(this.img_inbox);

            this.exit_inbox = new FlxText(
                inbox_pos.x + 5, inbox_pos.y + (this.img_inbox.height-25),
                250, "Exit Inbox");
            this.exit_inbox.size = 16;
            this.exit_inbox.color = 0xff000000;
            this.exit_inbox.scrollFactor = new FlxPoint(0, 0);
            FlxG.state.add(this.exit_inbox);

            this.exit_inbox_rect = new FlxRect(this.exit_inbox.x,
                                               this.exit_inbox.y, 70, 20);
            this.exit_inbox_rect.x = this.exit_inbox.x;
            this.exit_inbox_rect.y = this.exit_inbox.y;

            this.exit_inbox.alpha = 0;
            this.img_inbox.alpha = 0;

            this.debugText = new FlxText(_screen.screenWidth * .01,
                                         _screen.screenHeight * .01, 500, "");
            this.debugText.scrollFactor = new FlxPoint(0, 0);
            this.debugText.color = 0xffffffff;
            FlxG.state.add(this.debugText);
        }

        public function loadVisibleMessageObjects():void {
            for (var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].initVisibleObjects();
            }
        }

        public function reloadPersistentObjects():void {
            this.initNotifications();
            this.loadVisibleMessageObjects();
            for(var i:int = 1; i < this.messages.length; i++){
                this.messages[i].setListPos(this.messages[i - 1].pos);
            }
        }

        public function updateUnreadNotification():void {
            this.notifications_text.text = this.unread_count + " unread messages.";
            if(this.unread_count > 0) {
                this.notifications_text.color = 0xff982708;
            } else {
                this.notifications_text.color = 0xff000000;
            }
        }

        public function showPreviews():void {
            for(var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].showPreview();
            }
        }

        public function openThread(thread:Message):void {
            this.cur_viewing = thread;
            if(!this.cur_viewing.read) {
                this.cur_viewing.markAsRead();
                this.unread_count -= 1;
            }
            this.cur_viewing.showThread();
            if(!this.cur_viewing.read) {
                this.cur_viewing.markAsRead();
                this.unread_count -= 1;
            }
            this._state = STATE_VIEW_MESSAGE;

            for(var i:int = 0; i < this.messages.length; i++) {
                if(this.messages[i] != cur_viewing){
                    this.messages[i].hidePreview();
                }
            }
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if (this.notifications_text._textField == null) {
                this.reloadPersistentObjects();
            }

            this.updateUnreadNotification();

            this.mouse_rect.x = FlxG.mouse.screenX;
            this.mouse_rect.y = FlxG.mouse.screenY;

            var cur_message:Message;
            for(var i:int = 0; i < this.messages.length; i++) {
                cur_message = this.messages[i];
                cur_message.update();

                if(!cur_message.sent){
                    if(this._state == STATE_VIEW_LIST &&
                        FlxG.mouse.justPressed() &&
                        this.mouse_rect.overlaps(cur_message.list_hitbox))
                    {
                        this.openThread(cur_message);
                    }
                }
            }

            if(FlxG.mouse.justPressed()) {
                if(this._state == STATE_HIDE_INBOX) {
                    if (this.mouse_rect.overlaps(this.notifications_box)) {
                        this._state = STATE_VIEW_LIST;
                        this.showPreviews();
                        this.openInbox();
                    }
                } else {
                    if (this._state == STATE_VIEW_MESSAGE) {
                        if(cur_viewing != null) {
                            if(this.mouse_rect.overlaps(cur_viewing.exit_box)) {
                                cur_viewing.hideFull();
                                cur_viewing = null;
                                this.showPreviews();
                                this._state = STATE_VIEW_LIST;
                            } else if(this.mouse_rect.overlaps(cur_viewing.reply_box)) {
                                cur_viewing.showReply();
                            }
                        }
                    }
                    if (this.mouse_rect.overlaps(this.exit_inbox_rect)){
                        this._state = STATE_HIDE_INBOX;
                        this.exitInbox();
                    }
                }
            }
        }

        public function exitInbox():void {
            this.exit_inbox.alpha = 0;
            this.img_inbox.alpha = 0;
            for(var i:int = 0; i < this.messages.length; i++) {
                this.messages[i].hideMessage();
            }
        }

        public function openInbox():void {
            this.exit_inbox.alpha = 1;
            this.img_inbox.alpha = 1;
        }

        public static function getInstance():MessageManager {
            if (_instance == null) {
                _instance = new MessageManager();
            }
            return _instance;
        }
    }
}
