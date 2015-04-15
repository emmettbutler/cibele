package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.entities.Thread;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    public class MessageManager {
        [Embed(source="/../assets/images/ui/UI_letter.png")] private var ImgMsg:Class;
        [Embed(source="/../assets/images/ui/UI_letter_pink.png")] private var ImgMsgPink:Class;
        [Embed(source="/../assets/images/ui/UI_text_box.png")] private var ImgInbox:Class;
        [Embed(source="/../assets/images/ui/UI_text_box_x_blue.png")] private var ImgInboxX:Class;
        [Embed(source="/../assets/images/ui/UI_pink_msg_box.png")] private var ImgInboxPink:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public static var _instance:MessageManager = null;

        public var notifications_text:FlxText, debugText:FlxText,
                   exit_msg:FlxText, reply_to_msg:FlxText;

        public var img_inbox:UIElement;
        public var exit_ui:UIElement;
        public var img_msg:UIElement;

        public var notifications_box:FlxRect,
                   exit_box:FlxRect, reply_box:FlxRect;

        private var inbox_pos:DHPoint;

        public var threads:Array;
        public var it_threads:Array;
        public var eu_threads:Array;
        public var hi_threads:Array;
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
        public static const CIBELE_MSG:String = "Cibele";
        public static const FONT_SIZE:Number = 21;

        public static var SENT_BY_CIBELE:String = CIBELE_MSG;

        public var elements:Array;

        public var ui_loaded:Boolean = false;
        public var minimizeFlag:Boolean = false;
        public var maximizeExitFlag:Boolean = false;
        public var maximizeInboxFlag:Boolean = false;

        public var i:Number = 0;

        public function MessageManager() {
            this.elements = new Array();
            this.bornTime = new Date().valueOf();
            var _screen:ScreenManager = ScreenManager.getInstance();
            inbox_pos = new DHPoint(_screen.screenWidth * .4,
                                    _screen.screenHeight * .4);
            this.initNotifications();
            // forgive me
            this.notifications_text._textField = null

            this.it_threads = new Array(
                new Thread(this.img_inbox,
                    ["Rusher", "did you get that link i sent you on aim last night? its an anime you might like :D", 1],
                    [MessageManager.SENT_BY_CIBELE, "yeah! i think that one of the VAs was in sailor moon??", 1],
                    ["Rusher", "the little pink haired one looks just like you :3", 1],
                    [MessageManager.SENT_BY_CIBELE, "i always do my best to look anime ^_^", -1],
                    ["Rusher", "did you see that picture i put up on the forums?", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "yeah! it's nice!", -1],
                    ["Rusher", "thanks :3", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i really like knowing what everyone looks like irl~", -1]
                ),
                new Thread(this.img_inbox,
                    ["GuyverGuy", "hey giiiiiirl how are things? you never chat with me anymore </3", 1],
                    [MessageManager.SENT_BY_CIBELE, ";_; sorry, ive been pretty busy, ampule has been doing a lot lately", 1],
                    ["GuyverGuy", "everyone bowing to ichis whip as usual i see", 1],
                    [MessageManager.SENT_BY_CIBELE, "omg guyver stop lol", 1],
                    ["GuyverGuy", "are u seriously defending him lol he is an A S S", 1],
                    [MessageManager.SENT_BY_CIBELE, "he's nice to me", -1],
                    ["GuyverGuy", "lol of course he is, ur a girl", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "whatever guyver lol that's not true", -1],
                    ["GuyverGuy", "i bet he thinks ur hot", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i doubt that", -1]
                ),
                new Thread(this.img_inbox,
                    ["Airia", "Cib! Wanna do a euryale run w/ me on friday?", 1],
                    [MessageManager.SENT_BY_CIBELE, "ok! <3 see you then girl~", 1],
                    ["Airia", "ichi usually comes but lets go just us, girls night out", 1],
                    [MessageManager.SENT_BY_CIBELE, "yes! i have so much i wanna talk about with youuu", -1],
                    ["Airia", "ooooh? ;) something happen??", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i just need your opinion on someone ahhhhh you know", -1],
                    ["Airia", "OMG who is it??? guil? ICHI?", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "lol shhhh we will talk on friday", -1]
                ),
                new Thread(this.img_inbox,
                    ["Guillen", "where u at", 1],
                    [MessageManager.SENT_BY_CIBELE, "hey sorry duoing with ichi now", 1],
                    ["Guillen", "omg ur always with ichi come oooonnnn", 1],
                    [MessageManager.SENT_BY_CIBELE, "sorry! lets hang tomorrow maybe?", 1],
                    ["Guillen", "i wanna hang now cibby! can i meet u after in hiisi or something", 1],
                    [MessageManager.SENT_BY_CIBELE, "maybe, i will let you know what ichi and i end up doing", -1],
                    ["Guillen", "when did u start liking ichi more than me lol", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "whaaat are you talking about lol stop", -1]
                )
            );

            this.eu_threads = new Array(
                new Thread(this.img_inbox,
                    ["Rusher", "cibby! we should talk on the phone sometime", 1],
                    [MessageManager.SENT_BY_CIBELE, "yeah we could do that :D", 1],
                    ["Rusher", "we can text too and be ~real~ friends", 1],
                    [MessageManager.SENT_BY_CIBELE, "haha im kinda surprised, i asked for yours awhile ago didnt i?", -1],
                    ["Rusher", "yeah i was all awkward back then i guess", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, ";_; it made me sad", -1],
                    ["Rusher", ":( sorry", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i am kinda busy right now actually. i will msg my # to you later", -1]
                ),
                new Thread(this.img_inbox,
                    ["GuyverGuy", "<3 <3 <3", 1],
                    [MessageManager.SENT_BY_CIBELE, "lol hi guyver whats up", 1],
                    ["GuyverGuy", "ur cute", 1],
                    [MessageManager.SENT_BY_CIBELE, "uhhh haha thanks", 1],
                    ["GuyverGuy", "firesss showed me a pic of u", 1],
                    [MessageManager.SENT_BY_CIBELE, "the one i put on our forums?", -1],
                    ["GuyverGuy", "no, he said its a special one from a while ago ;)", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "uhhh what lol what are you talking about", -1],
                    ["GuyverGuy", "its a sexy pic u sent him", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "wow what the fuck why did he show you", -1],
                    ["GuyverGuy", "lol hes jealous of u hangin with ichi", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "fire and i had a thing but its over and he knows that wtf", -1]
                ),
                new Thread(this.img_inbox,
                    ["Airia", "ciiiiib ichi never shuts up about u lol", 1],
                    [MessageManager.SENT_BY_CIBELE, ":3 he was talking about me to you? what did he say", 1],
                    ["Airia", "he was just gushing about how chill you are compared to other girls", 1],
                    [MessageManager.SENT_BY_CIBELE, "chill?", -1],
                    ["Airia", "like ur down to log on for runs whenever. he said u get shit done", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "haha yeah i have been getting online for every run lately", -1],
                    ["Airia", "sounds like u two have been on the phone a lot too~", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "we have been talking on the phone a lot... its nice :3", -1]
                ),
                new Thread(this.img_inbox,
                    ["Guillen", "we really need to meet up next time im in nyc!!!", 1],
                    [MessageManager.SENT_BY_CIBELE, "i knowww im sorry i keep cancelling", 1],
                    ["Guillen", "stop being so busy ;_; ill be in town next weekend if ur free", 1],
                    [MessageManager.SENT_BY_CIBELE, "depends on what ichi has the ampule doing", -1],
                    ["Guillen", "aw come on you can take a break for one day", 10*GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "ill let you know~", -1]
                )
            );
            this.setCurrentThreads();

            this.loadVisibleMessageObjects();

            for(var i:int = 0; i < this.threads.length; i++) {
                if(i != 0){
                    this.threads[i].setListPos(this.threads[i - 1].pos);
                }
            }
        }

        public function setCurrentThreads():void {
            if (ScreenManager.getInstance().levelTracker.it()) {
                this.threads = this.it_threads;
            } else if (ScreenManager.getInstance().levelTracker.eu()) {
                this.threads = this.eu_threads;
            } else if (ScreenManager.getInstance().levelTracker.hi()) {
                this.threads = this.hi_threads;
            }
        }

        public function initNotifications(addToState:Boolean=false):void {
            var imgClass:Class;
            var imgSize:DHPoint;

            this.elements.length = 0;

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

            imgClass = ImgInbox;
            imgSize = new DHPoint(528, 338);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgInboxPink;
                imgSize = new DHPoint(525, 335);
            }
            this.img_inbox = new UIElement(inbox_pos.x, inbox_pos.y);
            this.img_inbox.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            this.img_inbox.scrollFactor = new FlxPoint(0, 0);
            this.img_inbox.active = false;
            this.img_inbox.visible = false;
            if (addToState) {
                FlxG.state.add(this.img_inbox);
            }
            this.elements.push(this.img_inbox);

            imgClass = ImgInboxX;
            imgSize = new DHPoint(13, 12);
            var imgPos:DHPoint = new DHPoint(this.img_inbox.x + (this.img_inbox.width - 20), this.img_inbox.y + 5);
            if((FlxG.state as GameState).ui_color_flag == GameState.UICOLOR_PINK)
            {
                imgClass = ImgInboxXPink;
                imgSize = new DHPoint(23, 18);
                imgPos = new DHPoint(imgPos.x-2, imgPos.y-5);
            }
            this.exit_ui = new UIElement(imgPos.x, imgPos.y);
            this.exit_ui.loadGraphic(imgClass, false, false, imgSize.x, imgSize.y);
            this.elements.push(this.exit_ui);
            this.exit_ui.scrollFactor = new FlxPoint(0, 0);
            this.exit_ui.visible = false;
            if (addToState){
                FlxG.state.add(this.exit_ui);
            }

            this.exit_msg = new FlxText(this.img_inbox.x + 20,
                this.img_inbox.y + (this.img_inbox.height-40),
                this.img_inbox.width, "Back");
            this.exit_msg.setFormat("NexaBold-Regular",FONT_SIZE,0xff616161,"left");
            this.exit_msg.scrollFactor = new FlxPoint(0, 0);
            this.exit_msg.visible = false;
            this.exit_msg.active = false;
            if (addToState) {
                FlxG.state.add(this.exit_msg);
            }

            this.exit_box = new FlxRect(this.exit_msg.x, this.exit_msg.y, 57, this.exit_msg.height);

            this.reply_to_msg = new FlxText(this.img_inbox.x + 70,
                this.img_inbox.y + (this.img_inbox.height - 40),
                this.img_inbox.width, "| Reply");
            this.reply_to_msg.setFormat("NexaBold-Regular",FONT_SIZE,0xff616161,"left");
            this.reply_to_msg.scrollFactor = new FlxPoint(0, 0);
            this.reply_to_msg.visible = false;
            this.reply_to_msg.active = false;
            if (addToState) {
                FlxG.state.add(this.reply_to_msg);
            }

            this.reply_box = new FlxRect(this.reply_to_msg.x, this.reply_to_msg.y, 64, this.reply_to_msg.height);

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
                this.img_msg.play("new");
            } else {
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
                thread.rotate();
                for(var i:int = 0; i < this.threads.length; i++) {
                    this.threads[i].hidePreview();
                }
            }
        }

        public function updateUIPositions():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            inbox_pos.x = _screen.screenWidth / 2 - this.img_inbox.width / 2;
            inbox_pos.y = _screen.screenHeight / 2 - this.img_inbox.height / 2;

            this.img_inbox.x = inbox_pos.x;
            this.img_inbox.y = inbox_pos.y;

            this.exit_ui.x = this.img_inbox.x + (this.img_inbox.width - 20);
            this.exit_ui.y = this.img_inbox.y + 5;

            this.exit_msg.x = this.img_inbox.x + 20;
            this.exit_msg.y = this.img_inbox.y + (this.img_inbox.height-40);
            this.exit_box = new FlxRect(this.exit_msg.x, this.exit_msg.y, 57,
                                        this.exit_msg.height);

            this.reply_to_msg.x = this.img_inbox.x + 70;
            this.reply_to_msg.y = this.img_inbox.y + (this.img_inbox.height - 40);
            this.reply_box = new FlxRect(this.reply_to_msg.x,
                                         this.reply_to_msg.y, 64,
                                         this.reply_to_msg.height);

            this.threads[0].pos.x = this.img_inbox.x + 20;
            this.threads[0].pos.y = this.img_inbox.y + 30;
            for(var i:int = 0; i < this.threads.length; i++) {
                if(i != 0){
                    this.threads[i].setListPos(this.threads[i - 1].pos);
                }
            }
        }

        public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            this.updateUnreadNotification();
            this.updateUIPositions();

            var cur_thread:Thread;
            this.unread_count = 0;

            if(this.minimizeFlag) {
                this.minimizeWindow(this.img_inbox);
                this.minimizeWindow(this.exit_ui);
            }

            if(this.maximizeExitFlag) {
                this.maximizeWindow();
            }

            if(this.maximizeInboxFlag) {
                this.maximizeInboxWindow();
            }

            if(img_inbox.scale.x >= 1) {
                img_inbox.scale.x = 1;
                img_inbox.scale.y = 1;
                this.maximizeInboxFlag = false;
            }

            if(exit_ui.scale.x >= 1) {
                exit_ui.scale.x = 1;
                exit_ui.scale.y = 1;
                this.maximizeExitFlag = false;
            }

            for(i = 0; i < this.threads.length; i++) {
                cur_thread = this.threads[i];
                cur_thread.update();
                if (cur_thread.unread) {
                    this.unread_count++;
                }
            }

            if(FlxG.mouse.justPressed()) {
                if(this._state == STATE_VIEW_LIST) {
                    for(i = 0; i < this.threads.length; i++) {
                        if((FlxG.state as GameState).cursorOverlaps(this.threads[i].list_hitbox, true))
                        {
                            this.openThread(this.threads[i]);
                        }
                    }
                }

                if(this._state == STATE_HIDE_INBOX) {
                    if ((FlxG.state as GameState).cursorOverlaps(this.notifications_box, true)) {
                        this._state = STATE_VIEW_LIST;
                        this.openInbox();
                    }
                } else {
                    if (this._state == STATE_VIEW_MESSAGE) {
                        if(cur_viewing != null) {
                            if((FlxG.state as GameState).cursorOverlaps(this.exit_box, true)) {
                                cur_viewing.hideFull();
                                cur_viewing = null;
                                this.showPreviews();
                                this._state = STATE_VIEW_LIST;
                            } else if((FlxG.state as GameState).cursorOverlaps(this.reply_box, true)) {
                                cur_viewing.reply();
                            }
                        }
                    }
                    if (!(FlxG.state as GameState).cursorOverlaps(new FlxRect(this.img_inbox.x, this.img_inbox.y, this.img_inbox.width, this.img_inbox.height), true) ||
                            (FlxG.state as GameState).cursorOverlaps(new FlxRect(this.exit_ui.x, this.exit_ui.y, this.exit_ui.width, this.exit_ui.height), true)
                        )
                    {
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

        public function maximizeWindow():void {
            if(this.maximizeExitFlag) {
                exit_ui.scale.x += .1;
                exit_ui.scale.y += .1;
            }
        }

        public function maximizeInboxWindow():void {
            if(this.maximizeInboxFlag){
                img_inbox.scale.x += .1;
                img_inbox.scale.y += .1;
            }
        }

        public function openInbox():void {
            this.showPreviews();
            this.exit_ui.visible = true;
            this.img_inbox.visible = true;
            this.exit_ui.scale.x = 0;
            this.img_inbox.scale.y = 0;
            this.maximizeExitFlag = true;
            this.maximizeInboxFlag = true;
        }

        public static function getInstance():MessageManager {
            if (_instance == null) {
                _instance = new MessageManager();
            }
            return _instance;
        }
    }
}
