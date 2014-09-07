package{
    import org.flixel.*;

    public class MessageManager {
        [Embed(source="../assets/messages.png")] private var ImgMsg:Class;
        [Embed(source="../assets/inbox.png")] private var ImgInbox:Class;

        public static var _instance:MessageManager = null;

        public var notifications_text:FlxText, exit_inbox:FlxText,
                   debugText:FlxText, exit_msg:FlxText, reply_to_msg:FlxText;

        public var img_inbox:FlxSprite;

        public var notifications_box:FlxRect, exit_inbox_rect:FlxRect,
                   mouse_rect:FlxRect, exit_box:FlxRect, reply_box:FlxRect;

        public var threads:Array;
        public var cur_viewing:Thread;

        public var unread_count:Number = 0;
        public var bornTime:Number = -1;
        public var timeAlive:Number = 0;
        public var currentTime:Number = -1;

        public var _screen:ScreenManager = ScreenManager.getInstance();

        public static const STATE_HIDE_INBOX:Number = 0;
        public static const STATE_VIEW_LIST:Number = 1;
        public static const STATE_VIEW_MESSAGE:Number = 2;
        public var _state:Number = STATE_HIDE_INBOX;

        public static const SENT_BY_CIBELE:String = "Cibele";

        public function MessageManager() {
            this.bornTime = new Date().valueOf();
            this.initNotifications();

            this.threads = new Array(
                new Thread(this.img_inbox,
                    ["Rusher", "did you get that link i sent you on aim last night? its an anime you might like :D", 1],
                    [SENT_BY_CIBELE, "yeah! the fairies were very very cute and i think that VA was in sailor moon??", -1]
                ),
                new Thread(this.img_inbox,
                    ["GuyverGuy", "hey giiiiiirl how are things? you never chat with me anymore </3", 1],
                    [SENT_BY_CIBELE, ";_; sorry, ive been pretty busy, ampule has been doing a lot lately", -1]
                ),
                new Thread(this.img_inbox,
                    ["Airia", "Cib! Wanna do a euryale run w/ me on friday?", 1],
                    [SENT_BY_CIBELE, "ok! <3 see you then girl~", -1]
                )
            );

            this.loadVisibleMessageObjects();

            for(var i:int = 0; i < this.threads.length; i++) {
                if(this.threads[i].unread) {
                    this.unread_count += 1;
                }
                if(i != 0){
                    this.threads[i].setListPos(this.threads[i - 1].pos);
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

            this.exit_msg = new FlxText(this.img_inbox.x + 110,
                this.img_inbox.y + (this.img_inbox.height-25),
                this.img_inbox.width, "| Back");
            this.exit_msg.size = 14;
            this.exit_msg.color = 0xff000000;
            this.exit_msg.scrollFactor = new FlxPoint(0, 0);
            this.exit_msg.alpha = 0;
            FlxG.state.add(this.exit_msg);

            this.exit_box = new FlxRect(this.exit_msg.x, this.exit_msg.y, 50, 50);

            this.reply_to_msg = new FlxText(this.img_inbox.x + 172,
                this.img_inbox.y + (this.img_inbox.height - 25),
                this.img_inbox.width, "| Reply");
            this.reply_to_msg.size = 14;
            this.reply_to_msg.color = 0xff000000;
            this.reply_to_msg.scrollFactor = new FlxPoint(0, 0);
            this.reply_to_msg.alpha = 0;
            FlxG.state.add(this.reply_to_msg);

            this.reply_box = new FlxRect(this.reply_to_msg.x, this.reply_to_msg.y,
                                         50, 50);

            this.debugText = new FlxText(_screen.screenWidth * .01,
                                         _screen.screenHeight * .01, 500, "");
            this.debugText.scrollFactor = new FlxPoint(0, 0);
            this.debugText.color = 0xff0000ff;
            FlxG.state.add(this.debugText);
        }

        public function loadVisibleMessageObjects():void {
            for (var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].initVisibleObjects();
            }
        }

        public function reloadPersistentObjects():void {
            this.initNotifications();
            this.loadVisibleMessageObjects();
            for(var i:int = 1; i < this.threads.length; i++){
                this.threads[i].setListPos(this.threads[i - 1].pos);
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
            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].showPreview();
            }
            this.reply_to_msg.alpha = 0;
            this.exit_msg.alpha = 0;
        }

        public function openThread(thread:Thread):void {
            this.cur_viewing = thread;
            if(this.cur_viewing.unread) {
                this.unread_count -= 1;
            }
            this.cur_viewing.markAsRead();
            this.cur_viewing.show();
            this.reply_to_msg.alpha = 1;
            this.exit_msg.alpha = 1;
            this._state = STATE_VIEW_MESSAGE;

            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].hidePreview();
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

            var cur_thread:Thread;
            for(var i:int = 0; i < this.threads.length; i++) {
                cur_thread = this.threads[i];
                cur_thread.update();

                if(this._state == STATE_VIEW_LIST &&
                    FlxG.mouse.justPressed() &&
                    this.mouse_rect.overlaps(cur_thread.list_hitbox))
                {
                    this.openThread(cur_thread);
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
                            if(this.mouse_rect.overlaps(this.exit_box)) {
                                cur_viewing.hideFull();
                                cur_viewing = null;
                                this.showPreviews();
                                this._state = STATE_VIEW_LIST;
                            } else if(this.mouse_rect.overlaps(this.reply_box)) {
                                cur_viewing.reply();
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
            this.exit_msg.alpha = 0;
            this.reply_to_msg.alpha = 0;
            this.img_inbox.alpha = 0;
            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].hide();
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
