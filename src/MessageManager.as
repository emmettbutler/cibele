package{
    import org.flixel.*;

    public class MessageManager {
        [Embed(source="../assets/messages.png")] private var ImgMsg:Class;
        [Embed(source="../assets/inbox.png")] private var ImgInbox:Class;

        public static var _instance:MessageManager = null;

        public var img_msg:FlxSprite;
        public var notifications:FlxText;
        public var unread_count:Number = 0;
        public var notifications_pos:DHPoint;
        public var notifications_box:FlxRect;

        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public var img_inbox:FlxSprite;
        public var inbox_pos:DHPoint;
        public var exit_inbox:FlxText;
        public var exit_inbox_box:FlxRect;

        public var msgs:Array;
        public var currently_viewing:Message;

        public var debugText:FlxText;

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
                new Message("did you get that link i sent you on aim last night? its an anime you might like :D", 1, img_inbox, "Rusher"),
                new Message("hey giiiiiirl how are things? you never chat with me anymore </3", 1, img_inbox, "GuyverGuy"),
                new Message("Cib! Wanna do a euryale run w/ me on friday?", 1, img_inbox, "Airia")
            );
            this.loadVisibleMessageObjects();
            this.initDebugText();

            for(i = 0; i < msgs.length; i++) {
                if(!msgs[i].read) {
                    unread_count += 1;
                }
            }
        }

        public function initNotifications():void {
            mouse_rect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y, 5, 5);
            var _screen:ScreenManager = ScreenManager.getInstance();
            notifications_pos = new DHPoint(_screen.screenWidth * .001, _screen.screenHeight * .85);
            img_msg = new FlxSprite(notifications_pos.x, notifications_pos.y);
            img_msg.loadGraphic(ImgMsg,false,false,197,71);
            FlxG.state.add(img_msg);

            notifications = new FlxText(notifications_pos.x, notifications_pos.y, img_msg.width, unread_count.toString() + " unread messages.");
            notifications.size = 14;
            notifications.color = 0xff000000;
            FlxG.state.add(notifications);

            notifications_box = new FlxRect(notifications.x, notifications.y, img_msg.width, 100);

            inbox_pos = new DHPoint(_screen.screenWidth * .05, _screen.screenHeight * .3);
            img_inbox = new FlxSprite(inbox_pos.x, inbox_pos.y);
            img_inbox.loadGraphic(ImgInbox, false, false, 336, 127);
            FlxG.state.add(img_inbox);

            exit_inbox = new FlxText(inbox_pos.x+5, inbox_pos.y+(img_inbox.height-25), img_inbox.width, "Exit Inbox");
            exit_inbox.size = 16;
            exit_inbox.color = 0xff000000;
            FlxG.state.add(exit_inbox);
            exit_inbox_box = new FlxRect(exit_inbox.x, exit_inbox.y, img_inbox.width, 20);
        }

        public function loadVisibleMessageObjects():void {
            for (var i:int = 0; i < msgs.length; i++) {
                msgs[i].initVisibleObjects();
            }
        }

        public function initDebugText():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            debugText = new FlxText(_screen.screenWidth * .01, _screen.screenHeight * .01, 500, "");
            FlxG.state.add(debugText);
            debugText.color = 0xffffffff;
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if (debugText._textField == null) {
                // text was previously freed, and thus deleted - recreate it
                this.initDebugText();
            }
            debugText.text = state.toString();
            if (notifications._textField == null) {
                this.initNotifications();
                this.loadVisibleMessageObjects();
            }

            mouse_rect.x = FlxG.mouse.screenX;
            mouse_rect.y = FlxG.mouse.screenY;

            //debugText.text = "Mouse: " + FlxG.mouse.x + "," + FlxG.mouse.y + "\nMouse Rect: " + mouse_rect.x + "," + mouse_rect.y + "Notifications Box: " + notifications_box.x + "," + notifications_box.y;

            notifications.scrollFactor.x = 0;
            notifications.scrollFactor.y = 0;
            img_msg.scrollFactor.x = 0;
            img_msg.scrollFactor.y = 0;
            img_inbox.scrollFactor.x = 0;
            img_inbox.scrollFactor.y = 0;
            exit_inbox.scrollFactor.x = 0;
            exit_inbox.scrollFactor.y = 0;
            debugText.scrollFactor.x = 0;
            debugText.scrollFactor.y = 0;

            notifications_box.x = notifications.x;
            notifications_box.y = notifications.y;
            exit_inbox_box.x = exit_inbox.x;
            exit_inbox_box.y = exit_inbox.y;

            notifications.text = unread_count.toString() + " unread messages.";

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
                            if(FlxG.mouse.justPressed() && mouse_rect.overlaps(msgs[i].list_hitbox)){
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

                            if(FlxG.mouse.justPressed() && mouse_rect.overlaps(currently_viewing.exit_box)){
                                currently_viewing.exitCurrentlyViewedMsg();
                                currently_viewing = null;
                                state = VIEW_LIST;
                            }
                        }
                    }
                }
            }

            if(FlxG.mouse.justPressed()) {
                if(state != HIDE_INBOX && mouse_rect.overlaps(exit_inbox_box)){
                    state = HIDE_INBOX;
                } else if(state == HIDE_INBOX && mouse_rect.overlaps(notifications_box)) {
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
            exit_inbox.alpha = 0;
            img_inbox.alpha = 0;
        }

        public function viewingInbox():void {
            exit_inbox.alpha = 1;
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
