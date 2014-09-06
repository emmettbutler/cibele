package{
    import org.flixel.*;

    public class MessageManager {
        [Embed(source="../assets/messages.png")] private var ImgMsg:Class;
        [Embed(source="../assets/inbox.png")] private var ImgInbox:Class;

        public static var _instance:MessageManager = null;

        public var notifications_text:FlxText;
        public var unread_count:Number = 0;
        public var notifications_box:FlxRect;

        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public var img_inbox:FlxSprite;
        public var exit_inbox:FlxText;
        public var exit_inbox_rect:FlxRect;

        public var msgs:Array;
        public var currently_viewing:Message;

        public var debugText:FlxText;
        public var _screen:ScreenManager = ScreenManager.getInstance();
        public var mouse_rect:FlxRect;

        public static const HIDE_INBOX:Number = 0;
        public static const VIEW_LIST:Number = 1;
        public static const VIEW_MSG:Number = 2;
        public var state:Number = HIDE_INBOX;

        public var i:Number = 0;

        public function MessageManager() {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;

            this.initNotifications();
            msgs = new Array(
                new Message("did you get that link i sent you on aim last night? its an anime you might like :D", "yeah! the fairies were very very cute and i think that VA was in sailor moon??", 1, img_inbox, "Rusher"),
                new Message("hey giiiiiirl how are things? you never chat with me anymore </3", ";_; sorry, ive been pretty busy, ampule has been doing a lot lately", 1, img_inbox, "GuyverGuy"),
                new Message("Cib! Wanna do a euryale run w/ me on friday?", "ok! <3 see you then girl~", 1, img_inbox, "Airia")
            );
            this.loadVisibleMessageObjects();

            for(i = 0; i < msgs.length; i++) {
                if(!msgs[i].read) {
                    unread_count += 1;
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
                img_msg.width, unread_count.toString() + " unread messages.");
            this.notifications_text.size = 14;
            this.notifications_text.color = 0xff000000;
            FlxG.state.add(this.notifications_text);

            this.notifications_box = new FlxRect(this.notifications_text.x,
                                                 this.notifications_text.y,
                                                 img_msg.width, 100);
            this.notifications_box.x = this.notifications_text.x;
            this.notifications_box.y = this.notifications_text.y;

            var inbox_pos:DHPoint = new DHPoint(_screen.screenWidth * .05,
                                                _screen.screenHeight * .3);
            img_inbox = new FlxSprite(inbox_pos.x, inbox_pos.y);
            img_inbox.loadGraphic(ImgInbox, false, false, 500, 230);
            FlxG.state.add(img_inbox);

            this.exit_inbox = new FlxText(
                inbox_pos.x + 5, inbox_pos.y + (img_inbox.height-25),
                250, "Exit Inbox");
            this.exit_inbox.size = 16;
            this.exit_inbox.color = 0xff000000;
            FlxG.state.add(this.exit_inbox);

            this.exit_inbox_rect = new FlxRect(this.exit_inbox.x,
                                               this.exit_inbox.y, 70, 20);
            this.exit_inbox_rect.x = this.exit_inbox.x;
            this.exit_inbox_rect.y = this.exit_inbox.y;

            this.debugText = new FlxText(_screen.screenWidth * .01,
                                         _screen.screenHeight * .01, 500, "");
            FlxG.state.add(this.debugText);
            this.debugText.color = 0xffffffff;
        }

        public function loadVisibleMessageObjects():void {
            for (var i:int = 0; i < msgs.length; i++) {
                msgs[i].initVisibleObjects();
            }
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if (this.notifications_text._textField == null) {
                this.initNotifications();
                this.loadVisibleMessageObjects();
                for(i = 0; i < msgs.length; i++){
                    if(i != 0){
                        msgs[i].setListPos(msgs[i-1].list_pos);
                    }
                }
            }
            debugText.text = timeAlive.toString();

            this.mouse_rect.x = FlxG.mouse.screenX;
            this.mouse_rect.y = FlxG.mouse.screenY;

            //debugText.text = "Mouse: " + FlxG.mouse.x + "," + FlxG.mouse.y + "\nMouse Rect: " + this.mouse_rect.x + "," + this.mouse_rect.y + "Notifications Box: " + this.notifications_box.x + "," + notifications_box.y;

            this.notifications_text.scrollFactor.x = 0;
            this.notifications_text.scrollFactor.y = 0;
            img_inbox.scrollFactor.x = 0;
            img_inbox.scrollFactor.y = 0;
            this.exit_inbox.scrollFactor.x = 0;
            this.exit_inbox.scrollFactor.y = 0;
            debugText.scrollFactor.x = 0;
            debugText.scrollFactor.y = 0;

            this.notifications_text.text = unread_count.toString() + " unread messages.";
            if(unread_count > 0) {
                this.notifications_text.color = 0xff982708;
            } else {
                this.notifications_text.color = 0xff000000;
            }

            for(i = 0; i < msgs.length; i++) {
                if(state == HIDE_INBOX) {
                    exitInbox();
                    msgs[i].hideMessage();
                } else {
                    msgs[i].update();

                    if(this.timeAlive > msgs[i].send_time && !msgs[i].sent) {
                        if(i != 0){
                            msgs[i].setListPos(msgs[i-1].list_pos);
                        }
                        msgs[i].sendMsg();
                    }
                    if(msgs[i].sent){
                        viewingInbox();
                        if(state == VIEW_LIST) {
                            msgs[i].viewingList();
                            if(FlxG.mouse.justPressed() && this.mouse_rect.overlaps(msgs[i].list_hitbox)){
                                currently_viewing = msgs[i];
                                state = VIEW_MSG;
                            }
                        }
                        if(state == VIEW_MSG) {
                            if(msgs[i] != currently_viewing){
                                msgs[i].hideUnviewedMsgs();
                            }

                            currently_viewing.showCurrentlyViewedMsg();

                            if(!currently_viewing.read) {
                                currently_viewing.markAsRead();
                                unread_count -= 1;
                            }

                            if(FlxG.mouse.justPressed() && currently_viewing != null && this.mouse_rect.overlaps(currently_viewing.exit_box)){
                                currently_viewing.exitCurrentlyViewedMsg();
                                currently_viewing = null;
                                state = VIEW_LIST;
                            }

                            if(FlxG.mouse.justPressed() && currently_viewing != null && this.mouse_rect.overlaps(currently_viewing.reply_to_box)){
                                currently_viewing.showReply();
                            }
                        }
                    }
                }
            }

            if(FlxG.mouse.justPressed()) {
                if(state != HIDE_INBOX && this.mouse_rect.overlaps(this.exit_inbox_rect)){
                    state = HIDE_INBOX;
                } else if(state == HIDE_INBOX && this.mouse_rect.overlaps(this.notifications_box)) {
                    state = VIEW_LIST;
                }
            }
            // for each message in level list
            // if not appeared
            // is current time later than message.appear_time?
            // if so, set message.appeared = true
            // do animations etc (manager.appearMessage())
            // if not, continue
        }

        public function markRead(message:Message):void {
            //message.read = true;
        }

        public function appearMessage(message:Message):void {
            // blink the bar
            // show a preview
            // etc
        }

        public function resetBornTime():void {
            //this.bornTime = 0;
        }

        public function exitInbox():void {
            this.exit_inbox.alpha = 0;
            img_inbox.alpha = 0;
        }

        public function viewingInbox():void {
            this.exit_inbox.alpha = 1;
            img_inbox.alpha = 1;
        }

        public static function getInstance():MessageManager {
            if (_instance == null) {
                _instance = new MessageManager();
            }
            return _instance;
        }
    }
}
