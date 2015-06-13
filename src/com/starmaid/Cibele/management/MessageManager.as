package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.entities.Thread;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class MessageManager {
        [Embed(source="/../assets/images/ui/UI_letter.png")] private var ImgMsg:Class;
        [Embed(source="/../assets/images/ui/UI_letter_pink.png")] private var ImgMsgPink:Class;
        [Embed(source="/../assets/images/ui/UI_text_box.png")] private var ImgInbox:Class;
        [Embed(source="/../assets/images/ui/UI_text_box_x_blue.png")] private var ImgInboxX:Class;
        [Embed(source="/../assets/images/ui/UI_pink_msg_box.png")] private var ImgInboxPink:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        [Embed(source="/../assets/images/ui/ellipse_anim.png")] private var ImgEllipse:Class;
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public static var _instance:MessageManager = null;

        public var notifications_text:FlxText, debugText:FlxText,
                   exit_msg:FlxText, reply_to_msg:FlxText;

        public var img_inbox:UIElement;
        public var exit_ui:UIElement;
        public var img_msg:UIElement;
        public var ellipse_anim:UIElement;

        public var notifications_box:FlxRect,
                    notification_num_box:FlxRect,
                   exit_box:FlxRect, reply_box:FlxRect;

        private var inbox_pos:DHPoint;

        public var threads_map:Object;
        public var threads:Array;
        public var cur_viewing:Thread;

        public var unread_count:Number = 0;

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
        public var bouncing_icon:Boolean = false;

        public var i:Number = 0;

        public function MessageManager() {
            this.elements = new Array();
            var _screen:ScreenManager = ScreenManager.getInstance();
            inbox_pos = new DHPoint(_screen.screenWidth * .4,
                                    _screen.screenHeight * .4);
            this.initNotifications();
            // forgive me
            this.notifications_text._textField = null

            this.threads_map = {};
            this.threads_map['it'] = new Array(
                new Thread(this.img_inbox, false,
                    ["Rusher", "did you get that link i sent you on aim last night? its an anime you might like :D", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "yeah! i think that one of the VAs was in sailor moon??", Thread.SEND_IMMEDIATELY],
                    ["Rusher", "the little pink haired one looks just like you :3", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "i always do my best to look anime ^_^", -1],
                    ["Rusher", "did you see that picture i put up on the forums?", (GameState.SHORT_DIALOGUE ? 5 : 6) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "yeah! it's nice!", -1],
                    ["Rusher", "thanks :3", (GameState.SHORT_DIALOGUE ? 1 : 10) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i really like knowing what everyone looks like irl~", -1]
                ),
                new Thread(this.img_inbox, true,
                    ["GuyverGuy", "hey giiiiiirl how are things? you never chat with me anymore </3", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, ";_; sorry, ive been pretty busy, ampule has been doing a lot lately", Thread.SEND_IMMEDIATELY],
                    ["GuyverGuy", "everyone bowing to ichis whip as usual i see", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "omg guyver stop lol", Thread.SEND_IMMEDIATELY],
                    ["GuyverGuy", "are u seriously defending him lol he is an A S S", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "he's nice to me", -1],
                    ["GuyverGuy", "lol of course he is, ur a girl", (GameState.SHORT_DIALOGUE ? 5 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "whatever guyver lol that's not true", -1],
                    ["GuyverGuy", "i bet he thinks ur hot", (GameState.SHORT_DIALOGUE ? 1 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i doubt that", -1]
                ),
                new Thread(this.img_inbox, true,
                    ["Airia", "Cib! Wanna do a euryale run w/ me on friday?", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "ok! <3 see you then girl~", Thread.SEND_IMMEDIATELY],
                    ["Airia", "ichi usually comes but lets go just us, girls night out", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "yes! i have so much i wanna talk about with youuu", -1],
                    ["Airia", "ooooh? ;) something happen??", (GameState.SHORT_DIALOGUE ? 5 : 15) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i just need your opinion on someone ahhhhh you know", -1],
                    ["Airia", "OMG who is it??? guil? ICHI?", (GameState.SHORT_DIALOGUE ? 1 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "lol shhhh we will talk on friday", -1]
                ),
                new Thread(this.img_inbox, false,
                    ["Guillen", "where u at", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "hey sorry duoing with ichi now", Thread.SEND_IMMEDIATELY],
                    ["Guillen", "omg ur always with ichi come oooonnnn", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "sorry! lets hang tomorrow maybe?", Thread.SEND_IMMEDIATELY],
                    ["Guillen", "i wanna hang now cibby! can i meet u after in hiisi or something", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "maybe, i will let you know what ichi and i end up doing", -1],
                    ["Guillen", "when did u start liking ichi more than me lol", (GameState.SHORT_DIALOGUE ? 5 : 40) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "whaaat are you talking about lol stop", -1]
                )
            );

            this.threads_map['eu'] = new Array(
                new Thread(this.img_inbox, true,
                    ["Rusher", "cibby! we should talk on the phone sometime", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "yeah we could do that :D", Thread.SEND_IMMEDIATELY],
                    ["Rusher", "we can text too and be ~real~ friends", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "haha im kinda surprised, i asked for yours awhile ago didnt i?", -1],
                    ["Rusher", "yeah i was all awkward back then i guess", (GameState.SHORT_DIALOGUE ? 5 : 10) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, ";_; it made me sad", -1],
                    ["Rusher", ":( sorry", (GameState.SHORT_DIALOGUE ? 1 : 5) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i am kinda busy right now actually. i will msg you later", -1]
                ),
                new Thread(this.img_inbox, true,
                    ["GuyverGuy", "<3 <3 <3", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "lol hi guyver whats up", Thread.SEND_IMMEDIATELY],
                    ["GuyverGuy", "ur cute", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "uhhh haha thanks", Thread.SEND_IMMEDIATELY],
                    ["GuyverGuy", "firesss showed me a pic of u", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "the one i put on our forums?", -1],
                    ["GuyverGuy", "no, he said its a special one from a while ago ;)", (GameState.SHORT_DIALOGUE ? 5 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "uhhh what lol what are you talking about", -1],
                    ["GuyverGuy", "its a sexy pic u sent him", (GameState.SHORT_DIALOGUE ? 1 : 40) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "wow what the fuck why did he show you", -1],
                    ["GuyverGuy", "lol hes jealous of u hangin with ichi", (GameState.SHORT_DIALOGUE ? 1 : 15) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "fire and i had a thing but its over and he knows that wtf", -1]
                ),
                new Thread(this.img_inbox, false,
                    ["Airia", "ciiiiib ichi never shuts up about u lol", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, ":3 he was talking about me to you? what did he say", Thread.SEND_IMMEDIATELY],
                    ["Airia", "he was just gushing about how chill you are compared to other girls", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "chill?", -1],
                    ["Airia", "like ur down to log on for runs whenever. he said u get shit done", (GameState.SHORT_DIALOGUE ? 5 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "haha yeah i have been getting online for every run lately", -1],
                    ["Airia", "sounds like u two have been on the phone a lot too~", (GameState.SHORT_DIALOGUE ? 1 : 50) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "we have been talking on the phone a lot... its nice :3", -1]
                ),
                new Thread(this.img_inbox, false,
                    ["Guillen", "we really need to meet up next time im in nyc!!!", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "i knowww im sorry i keep cancelling", Thread.SEND_IMMEDIATELY],
                    ["Guillen", "stop being so busy ;_; ill be in town next weekend if ur free", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "depends on what ichi has the ampule doing", -1],
                    ["Guillen", "aw come on you can take a break for one day", (GameState.SHORT_DIALOGUE ? 5 : 20) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "ill let you know~", -1]
                )
            );

            this.threads_map['hi'] = new Array(
                new Thread(this.img_inbox, false,
                    ["Rusher", "ninaaaaaa", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "hey what's up!", Thread.SEND_IMMEDIATELY],
                    ["Rusher", "rex is pissed at you lol", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "haha what why", -1],
                    ["Rusher", "she's jealous that you never talk to her anymore. you're always with ichi~", (GameState.SHORT_DIALOGUE ? 5 : 5) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, ";_;", -1],
                    ["Rusher", ":(", (GameState.SHORT_DIALOGUE ? 1 : 5) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "idk that feels kinda unfair. her and i still chat all the time.", -1],
                    ["Rusher", "o rly? we barely chat anymore", (GameState.SHORT_DIALOGUE ? 1 : 30) * GameSound.MSEC_PER_SEC],
                    ["Rusher", "i miss you cibby", (GameState.SHORT_DIALOGUE ? 1 : 2) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "; ;", -1]
                ),
                new Thread(this.img_inbox, true,
                    ["GuyverGuy", "CIB stop ignoring me", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "what's up? i wasn't ignoring you lol", Thread.SEND_IMMEDIATELY],
                    ["GuyverGuy", "i was lookin at ur facebook", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "haha why", -1],
                    ["GuyverGuy", "ur friend kate is really hot", (GameState.SHORT_DIALOGUE ? 5 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "yeah she's pretty lol", -1],
                    ["GuyverGuy", "does she play valtameri ;)", (GameState.SHORT_DIALOGUE ? 1 : 50) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "nah, she's not into online games", -1],
                    ["GuyverGuy", "u should hook us up", (GameState.SHORT_DIALOGUE ? 1 : 20) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "uh no lol", -1]
                ),
                new Thread(this.img_inbox, false,
                    ["Airia", "cib! stop making rusher sad", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "whaaaat lol", Thread.SEND_IMMEDIATELY],
                    ["Airia", "i know you used to like him <3 what happened", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "yeah i did a while ago", -1],
                    ["Airia", "so??? what happened?", (GameState.SHORT_DIALOGUE ? 5 : 10) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "he totally rejected me", -1],
                    ["Airia", "really? then why is he trying to get with you now...", (GameState.SHORT_DIALOGUE ? 1 : 20) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "idk, we have always gone back and forth like this, but he always rejects me", -1],
                    ["Airia", "do you still like him?", (GameState.SHORT_DIALOGUE ? 1 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i'll always like him in a way, but he rejected me and it really hurt my feelings...", -1],
                    ["Airia", "wow that sucks", (GameState.SHORT_DIALOGUE ? 1 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "yeah i can't really get past that", -1]
                ),
                new Thread(this.img_inbox, false,
                    ["Guillen", "yo i know what's going on with you and ichi", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "what are you talking about lol", Thread.SEND_IMMEDIATELY],
                    ["Guillen", "everyone knows lol stop trying to hide it", Thread.SEND_IMMEDIATELY],
                    [MessageManager.SENT_BY_CIBELE, "knows what? lol whatttt are you going off about", -1],
                    ["Guillen", "you two totally fcked", (GameState.SHORT_DIALOGUE ? 5 : 30) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "uhhh no lol", -1],
                    ["Guillen", "come oooooon i bet he was good ;) is he bossy in bed like he is irl", (GameState.SHORT_DIALOGUE ? 1 : 40) * GameSound.MSEC_PER_SEC],
                    [MessageManager.SENT_BY_CIBELE, "i wouldn't know -_-", -1]
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
                this.threads = this.threads_map['it'];
            } else if (ScreenManager.getInstance().levelTracker.eu()) {
                this.threads = this.threads_map['eu'];
            } else if (ScreenManager.getInstance().levelTracker.hi()) {
                this.threads = this.threads_map['hi'];
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
            img_msg.setSmallBounce();
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
                this.img_inbox.width, "Back /");
            this.exit_msg.setFormat("NexaBold-Regular",FONT_SIZE,0xff616161,"left");
            this.exit_msg.scrollFactor = new FlxPoint(0, 0);
            this.exit_msg.visible = false;
            this.exit_msg.active = false;
            if (addToState) {
                FlxG.state.add(this.exit_msg);
            }

            this.exit_box = new FlxRect(this.exit_msg.x, this.exit_msg.y, 57, this.exit_msg.height);

            this.reply_to_msg = new FlxText(this.img_inbox.x + 85,
                this.img_inbox.y + (this.img_inbox.height - 35),
                this.img_inbox.width, "/ Reply");
            this.reply_to_msg.setFormat("NexaBold-Regular",FONT_SIZE,0xff616161,"left");
            this.reply_to_msg.scrollFactor = new FlxPoint(0, 0);
            this.reply_to_msg.visible = false;
            this.reply_to_msg.active = false;
            if (addToState) {
                FlxG.state.add(this.reply_to_msg);
            }

            this.reply_box = new FlxRect(this.reply_to_msg.x, this.reply_to_msg.y, 64, this.reply_to_msg.height);


            this.ellipse_anim = new UIElement(reply_to_msg.x, reply_to_msg.y + 10);
            this.ellipse_anim.loadGraphic(ImgEllipse, false, false, 23, 4);
            this.ellipse_anim.addAnimation("ellipse", [0,1,2,3], 5, true);
            this.ellipse_anim.play("ellipse");
            this.ellipse_anim.scrollFactor = new DHPoint(0,0);
            FlxG.state.add(this.ellipse_anim);
            this.ellipse_anim.visible = false;

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

            this.notification_num_box = new FlxRect(this.notifications_text.x-15, this.notifications_text.y-10, 50, 53);

            this.ui_loaded = true;
        }

        public function loadVisibleMessageObjects():void {
            var curThreads:Array;
            for (var k:String in this.threads_map) {
                curThreads = this.threads_map[k];
                for (var i:int = 0; i < this.threads_map[k].length; i++) {
                    this.threads_map[k][i].initVisibleObjects();
                }
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
                if(!this.bouncing_icon) {
                    this.bouncing_icon = true;
                    this.img_msg.alertOn();
                }
                this.img_msg.play("new");
            } else {
                if(this.bouncing_icon) {
                    this.bouncing_icon = false;
                    this.img_msg.alertOff();
                }
                this.img_msg.play("closed");
            }
        }

        public function showPreviews():void {
            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].showPreview();
            }
            this.reply_to_msg.visible = false;
            this.ellipse_anim.visible = false;
            this.exit_msg.visible = false;
        }

        public function openThread(thread:Thread):void {
            if (thread != null) {
                this.cur_viewing = thread;
                this.cur_viewing.markAsRead();
                this.cur_viewing.show();
                if(thread.awaiting_reply) {
                    this.ellipse_anim.visible = true;
                } else {
                    this.reply_to_msg.visible = true;
                }
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

            this.img_inbox.setPos(inbox_pos);

            this.exit_ui.x = this.img_inbox.x + (this.img_inbox.width - 20);
            this.exit_ui.y = this.img_inbox.y + 5;

            this.exit_msg.x = this.img_inbox.x + 20;
            this.exit_msg.y = this.img_inbox.y + (this.img_inbox.height-40);
            this.exit_box = new FlxRect(this.exit_msg.x, this.exit_msg.y, 57,
                                        this.exit_msg.height);

            this.reply_to_msg.x = this.img_inbox.x + 83;
            this.reply_to_msg.y = this.img_inbox.y + (this.img_inbox.height - 40);
            this.reply_box = new FlxRect(this.reply_to_msg.x,
                                         this.reply_to_msg.y, 64,
                                         this.reply_to_msg.height);

            this.ellipse_anim.x = this.reply_to_msg.x + 2;
            this.ellipse_anim.y = this.reply_to_msg.y + 13;

            for(var i:int = 0; i < this.threads.length; i++) {
                this.threads[i].inbox_ref = this.img_inbox;
                this.threads[i].updatePos();
                if(i != 0){
                    this.threads[i].setListPos(this.threads[i - 1].pos);
                }
            }
        }

        public function update():void {
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
                if (!cur_thread.read) {
                    this.unread_count++;
                }
                if(this._state == STATE_VIEW_LIST) {
                    if((FlxG.state as GameState).cursorOverlaps(this.threads[i].list_hitbox, true))
                        {
                            this.threads[i].highlightTextColor();
                        } else if(this.threads[i].read){
                            this.threads[i].defaultTextColor();
                        } else {
                            this.threads[i].unreadTextColor();
                        }
                } else if (this._state == STATE_VIEW_MESSAGE) {
                    if((FlxG.state as GameState).cursorOverlaps(this.exit_box, true)) {
                        this.highlightExitColor();
                    } else {
                        this.defaultExitColor();
                    }
                    if((FlxG.state as GameState).cursorOverlaps(this.reply_box, true)) {
                        this.highlightReplyColor();
                    } else {
                        this.defaultReplyColor();
                    }
                }
            }

            if(FlxG.mouse.justReleased()) {
                if(this._state == STATE_VIEW_LIST) {
                    for(i = 0; i < this.threads.length; i++) {
                        if((FlxG.state as GameState).cursorOverlaps(this.threads[i].list_hitbox, true))
                        {
                            this.openThread(this.threads[i]);
                        }
                    }
                }

                if(this._state == STATE_HIDE_INBOX) {
                    if ((FlxG.state as GameState).cursorOverlaps(this.notifications_box, true) || (FlxG.state as GameState).cursorOverlaps(this.notification_num_box, true)) {
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
                                this.ellipse_anim.visible = true;
                                this.reply_to_msg.visible = false;
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

        public function highlightReplyColor():void {
            this.reply_to_msg.color = Thread.HIGHLIGHT_COLOR;
        }

        public function defaultReplyColor():void {
            this.reply_to_msg.color = Thread.DEFAULT_COLOR;
        }

        public function highlightExitColor():void {
            this.exit_msg.color = Thread.HIGHLIGHT_COLOR;
        }

        public function defaultExitColor():void {
            this.exit_msg.color = Thread.DEFAULT_COLOR;
        }

        public function showReplyButton():void {
            this.ellipse_anim.visible = false;
            this.reply_to_msg.visible = true;
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
            this.ellipse_anim.visible = false;
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

        public static function resetInstance():void {
            _instance = new MessageManager();
        }

        public static function getInstance():MessageManager {
            if (_instance == null) {
                _instance = new MessageManager();
            }
            return _instance;
        }
    }
}
