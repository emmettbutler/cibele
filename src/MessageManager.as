package{
    import org.flixel.*;

    public class MessageManager {
        [Embed(source="../assets/messages.png")] private var ImgMsg:Class;
        [Embed(source="../assets/inbox.png")] private var ImgInbox:Class;
        public var img_msg:FlxSprite;
        public var notifications:FlxText;
        public var unread_count:Number = 0;
        public var notifications_pos:DHPoint;

        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public var img_inbox:FlxSprite;
        public var inbox_pos:DHPoint;

        public var msgs:Array;
        public var currently_viewing:Message;

        public var debugText:FlxText;

        public var mouse_rect:FlxRect;

        public static const HIDE_INBOX:Number = 0;
        public static const VIEW_LIST:Number = 1;
        public static const VIEW_MSG:Number = 2;
        public var state:Number = VIEW_LIST;

        public function MessageManager() {
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;

            var _screen:ScreenManager = ScreenManager.getInstance();
            notifications_pos = new DHPoint(_screen.screenWidth * .001, _screen.screenHeight * .9);
            img_msg = new FlxSprite(notifications_pos.x, notifications_pos.y);
            img_msg.loadGraphic(ImgMsg,false,false,132,28);
            FlxG.state.add(img_msg);

            notifications = new FlxText(notifications_pos.x+10, notifications_pos.y+5, img_msg.width, unread_count.toString() + " unread messages.");
            FlxG.state.add(notifications);

            inbox_pos = new DHPoint(_screen.screenWidth * .05, _screen.screenHeight * .3);
            img_inbox = new FlxSprite(inbox_pos.x, inbox_pos.y);
            img_inbox.loadGraphic(ImgInbox, false, false, 336, 127);
            FlxG.state.add(img_inbox);

            msgs = new Array(
                new Message("hey babe", 1, img_inbox),
                new Message("waaaa babeyyyyy", 2, img_inbox)
            );

            debugText = new FlxText(_screen.screenWidth * .01, _screen.screenHeight * .01, 500, "");
            FlxG.state.add(debugText);
            debugText.color = 0xffffffff;

            mouse_rect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y, 5, 5);

            for(var i:Number = 0; i < msgs.length; i++) {
                if(!msgs[i].read) {
                    unread_count += 1;
                }
            }
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;

            debugText.text = state.toString();
            notifications.text = unread_count.toString() + " unread messages.";

            for(var i:Number = 0; i < msgs.length; i++) {
                msgs[i].update();

                if(this.timeAlive > msgs[i].send_time && !msgs[i].sent) {
                    if(i != 0){
                        msgs[i].setListPos(msgs[i-1].list_pos);
                    }
                    msgs[i].sent = true;
                }
                if(state == VIEW_LIST) {
                    msgs[i].truncated_msg.alpha = 1;
                    msgs[i].msg.alpha = 0;
                    if(FlxG.mouse.justPressed() && mouse_rect.overlaps(msgs[i].list_hitbox)){
                        msgs[i].viewing = true;
                        currently_viewing = msgs[i];
                        state = VIEW_MSG;
                    }
                }
                if(state == VIEW_MSG) {
                    if(msgs[i] != currently_viewing){
                        msgs[i].truncated_msg.alpha = 0;
                        msgs[i].msg.alpha = 0;
                    }

                    currently_viewing.truncated_msg.alpha = 0;
                    currently_viewing.msg.alpha = 1;

                    if(!currently_viewing.read) {
                        currently_viewing.read = true;
                        unread_count -= 1;
                    }

                    if(FlxG.mouse.justPressed() && mouse_rect.overlaps(currently_viewing.exit_box)){
                        currently_viewing.viewing = false;
                        currently_viewing.msg.alpha = 0;
                        currently_viewing = null;
                        state = VIEW_LIST;
                    }
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
    }
}
