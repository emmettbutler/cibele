package{
    import org.flixel.*;

    public class MessageManager {
        [Embed(source="../assets/UI_letter.png")] private var ImgMsg:Class;
        [Embed(source="../assets/UI_letter_pink.png")] private var ImgMsgPink:Class;
        [Embed(source="../assets/UI_text_box.png")] private var ImgInbox:Class;
        [Embed(source="../assets/UI_text_box_x_blue.png")] private var ImgInboxX:Class;
        [Embed(source="../assets/UI_pink_msg_box.png")] private var ImgInboxPink:Class;
        [Embed(source="../assets/UI_pink_x.png")] private var ImgInboxXPink:Class;
        [Embed(source="../assets/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public static var _instance:MessageManager = null;

        public var notifications_text:FlxText, debugText:FlxText,
                   exit_msg:FlxText, reply_to_msg:FlxText;

        public var img_inbox:UIElement;
        public var exit_ui:UIElement;
        public var img_msg:UIElement;

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

        public var elements:Array;

        public var ui_loaded:Boolean = false;
        public var minimizeFlag:Boolean = false;

        public function MessageManager() {
            this.elements = new Array();
            this.bornTime = new Date().valueOf();
            this.initNotifications();
            // forgive me
            this.notifications_text._textField = null

            this.threads = new Array(
                new Thread(this.img_inbox,
                    ["Rusher", "did you get that link i sent you on aim last night? its an anime you might like :D", 1],
                    [SENT_BY_CIBELE, "yeah! the fairies were very very cute and i think that VA was in sailor moon??", -1],
                    ["Rusher", "the little pink haired one looks just like you :3", 10*1000],
                    [SENT_BY_CIBELE, "i always do my best to look anime ^_^", -1]
                ),
                new Thread(this.img_inbox,
                    ["GuyverGuy", "hey giiiiiirl how are things? you never chat with me anymore </3", 1],
                    [SENT_BY_CIBELE, ";_; sorry, ive been pretty busy, ampule has been doing a lot lately", -1],
                    ["GuyverGuy", "everyone bowing to ichis whip as usual i see", 2*1000],
                    [SENT_BY_CIBELE, "omg guyver stop lol", -1]
                ),
                new Thread(this.img_inbox,
                    ["Airia", "Cib! Wanna do a euryale run w/ me on friday?", 1],
                    [SENT_BY_CIBELE, "ok! <3 see you then girl~", -1]
                ),
                new Thread(this.img_inbox,
                    ["Guillen", "where u at", 1],
                    [SENT_BY_CIBELE, "hey sorry duoing with ichi now", -1],
                    ["Guillen", "omg stop hogging ichi come oooonnnn", 7*1000],
                    [SENT_BY_CIBELE, "^_^;", -1]
                )
            );

            this.loadVisibleMessageObjects();

            for(var i:int = 0; i < this.threads.length; i++) {
                if(i != 0){
                    this.threads[i].setListPos(this.threads[i - 1].pos);
                }
            }
        }

        public function initNotifications(addToState:Boolean=false):void {
            var imgClass:Class;
            var imgSize:DHPoint;

            this.elements.length = 0;

            this.mouse_rect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y, 5, 5);
            var notifications_pos:DHPoint = new DHPoint(
                PopUpManager.RING_INSET_X + 55,
                PopUpManager.RING_INSET_Y + 75
            );

            imgClass = ImgMsg;
            imgSize = new DHPoint(143, 143);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgMsgPink;
                imgSize = new DHPoint(144, 144);
            }
            img_msg = new UIElement(
                notifications_pos.x, notifications_pos.y);
            img_msg.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            img_msg.scrollFactor = new FlxPoint(0, 0);
            img_msg.active = true;
            img_msg.addAnimation("new", [0], 1, false);
            img_msg.addAnimation("open", [1], 1, false);
            img_msg.addAnimation("closed", [2], 1, false);
            if (addToState) {
                FlxG.state.add(img_msg);
            }
            this.elements.push(img_msg);

            this.notifications_box = new FlxRect(this.img_msg.x,
                                                 this.img_msg.y,
                                                 this.img_msg.width, this.img_msg.height);
            this.notifications_box.x = this.img_msg.x;
            this.notifications_box.y = this.img_msg.y;

            var inbox_pos:DHPoint = new DHPoint(_screen.screenWidth * .4,
                                                _screen.screenHeight * .4);

            imgClass = ImgInbox;
            imgSize = new DHPoint(406, 260);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgInboxPink;
                imgSize = new DHPoint(404, 258);
            }
            this.img_inbox = new UIElement(inbox_pos.x, inbox_pos.y);
            this.img_inbox.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            this.img_inbox.scrollFactor = new FlxPoint(0, 0);
            this.img_inbox.active = false;
            if (addToState) {
                FlxG.state.add(this.img_inbox);
            }
            this.elements.push(this.img_inbox);

            imgClass = ImgInboxX;
            imgSize = new DHPoint(13, 12);
            var imgPos:DHPoint = new DHPoint(this.img_inbox.x + (this.img_inbox.width - 24), this.img_inbox.y + 7);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgInboxXPink;
                imgSize = new DHPoint(23, 18);
                imgPos = new DHPoint(imgPos.x-5, imgPos.y-5);
            }
            this.exit_ui = new UIElement(imgPos.x, imgPos.y);
            this.exit_ui.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            this.elements.push(this.exit_ui);
            this.exit_ui.scrollFactor = new FlxPoint(0, 0);
            this.exit_ui.visible = false;
            if (addToState){
                FlxG.state.add(this.exit_ui);
            }

            this.exit_inbox_rect = new FlxRect(this.exit_ui.x,
                                               this.exit_ui.y,
                                               this.exit_ui.width,
                                               this.exit_ui.height);
            this.exit_inbox_rect.x = this.exit_ui.x;
            this.exit_inbox_rect.y = this.exit_ui.y;

            this.img_inbox.visible = false;

            this.exit_msg = new FlxText(this.img_inbox.x + 20,
                this.img_inbox.y + (this.img_inbox.height-40),
                this.img_inbox.width, "Back");
            this.exit_msg.setFormat("NexaBold-Regular",16,0xff616161,"left");
            this.exit_msg.scrollFactor = new FlxPoint(0, 0);
            this.exit_msg.visible = false;
            this.exit_msg.active = false;
            if (addToState) {
                FlxG.state.add(this.exit_msg);
            }

            this.exit_box = new FlxRect(this.exit_msg.x, this.exit_msg.y, 50, 50);

            this.reply_to_msg = new FlxText(this.img_inbox.x + 60,
                this.img_inbox.y + (this.img_inbox.height - 40),
                this.img_inbox.width, "| Reply");
            this.reply_to_msg.setFormat("NexaBold-Regular",16,0xff616161,"left");
            this.reply_to_msg.scrollFactor = new FlxPoint(0, 0);
            this.reply_to_msg.visible = false;
            this.reply_to_msg.active = false;
            if (addToState) {
                FlxG.state.add(this.reply_to_msg);
            }

            this.reply_box = new FlxRect(this.reply_to_msg.x, this.reply_to_msg.y,
                                         50, 50);

            this.debugText = new FlxText(_screen.screenWidth * .01,
                                         _screen.screenHeight * .01, 500, "");
            this.debugText.scrollFactor = new FlxPoint(0, 0);
            this.debugText.color = 0xff0000ff;
            this.debugText.active = false;
            if (addToState) {
                FlxG.state.add(this.debugText);
            }

            this.notifications_text = new FlxText(img_msg.x-28, img_msg.y-20, img_msg.width, this.unread_count.toString());
            this.notifications_text.setFormat("NexaBold-Regular",24,0xff616161,"left");
            this.notifications_text.scrollFactor = new FlxPoint(0, 0);
            this.notifications_text.active = false;
            if (addToState) {
                FlxG.state.add(this.notifications_text);
            }

            this.ui_loaded = true;
        }

        public function loadVisibleMessageObjects():void {
            for (var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].initVisibleObjects();
            }
        }

        public function reloadPersistentObjects():void {
            this.ui_loaded = false;
            this.initNotifications(true);
            this.loadVisibleMessageObjects();
            for(var i:int = 1; i < this.threads.length; i++){
                this.threads[i].setListPos(this.threads[i - 1].pos);
            }
            if (this._state == STATE_HIDE_INBOX) {
                this.exitInbox();
            } else {
                this.openInbox();
                this.openThread(this.cur_viewing);
            }
            this.ui_loaded = true;
        }

        public function updateUnreadNotification():void {
            this.notifications_text.text = this.unread_count.toString();
            if(this.unread_count > 0) {
                this.img_msg.alertOn();
                this.img_msg.play("new");
            } else {
                this.img_msg.alertOff();
                this.img_msg.play("closed");
            }
        }

        public function showPreviews():void {
            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].showPreview();
            }
            this.reply_to_msg.visible = false;
            this.exit_msg.visible = false;
        }

        public function openThread(thread:Thread):void {
            if (thread != null) {
                this.cur_viewing = thread;
                this.cur_viewing.markAsRead();
                this.cur_viewing.show();
                this.reply_to_msg.visible = true;
                this.exit_msg.visible = true;
                this._state = STATE_VIEW_MESSAGE;
                for(var i:int = 0; i < this.threads.length; i++) {
                    this.threads[i].hidePreview();
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

            var cur_thread:Thread;
            this.unread_count = 0;

            if(this.minimizeFlag) {
                this.minimizeWindow(this.img_inbox);
                this.minimizeWindow(this.exit_ui);
            }

            for(var i:int = 0; i < this.threads.length; i++) {
                cur_thread = this.threads[i];
                cur_thread.update();
                if (cur_thread.unread) {
                    this.unread_count++;
                }

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
                    if (!this.mouse_rect.overlaps(new FlxRect(this.img_inbox.x, this.img_inbox.y, this.img_inbox.width, this.img_inbox.height)))
                    {
                        FlxG.log("exit");
                        this._state = STATE_HIDE_INBOX;
                        this.exitInbox(true);
                        if (this.cur_viewing != null) {
                            this.cur_viewing.viewing = false;
                        }
                    }
                }
            }
        }

        public function exitInbox(minimize:Boolean=false):void {
            this._state = STATE_HIDE_INBOX;
            if(!minimize) {
                this.img_inbox.visible = false;
                this.exit_ui.visible = false;
            } else {
                this.minimizeFlag = true;
            }
            this.exit_msg.visible = false;
            this.reply_to_msg.visible = false;
            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].hide();
            }
        }

        public function minimizeWindow(obj:UIElement):void {
            if(obj.scale.x > 0) {
                obj.scale.x -= .1;
                obj.scale.y -= .1;
            } else {
                obj.visible = false;
                this.minimizeFlag = false;
                obj.scale.x = 1;
                obj.scale.y = 1;
            }
        }

        public function openInbox():void {
            this.showPreviews();
            this.exit_ui.visible = true;
            this.img_inbox.visible = true;
        }

        public static function getInstance():MessageManager {
            if (_instance == null) {
                _instance = new MessageManager();
            }
            return _instance;
        }
    }
}
