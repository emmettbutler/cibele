package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.FolderBuilder;
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Desktop extends GameState {
        [Embed(source="/../assets/audio/effects/sfx_roomtone.mp3")] private var SFXRoomTone:Class;

        public var bg:GameObject, folder_structure:Object, leafPopups:Array;
        public var folder_builder:FolderBuilder;

        public static var ROOMTONE:String = "desktop room tone";

        public function Desktop() {
            super(true, true, false);
            this.showEmoji = false;
        }

        override public function create():void {
            super.create();
            this.ui_color_flag = GameState.UICOLOR_PINK;
            this.use_loading_screen = false;
            FlxG.bgColor = 0x00000000;
            if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_IT) {
                (new BackgroundLoader()).loadSingleTileBG("/../assets/images/ui/UI_Desktop.png");
            } else if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_EU) {
                (new BackgroundLoader()).loadSingleTileBG("/../assets/images/ui/UI_Desktop_Eu.png");
            } else if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_HI) {
                (new BackgroundLoader()).loadSingleTileBG("/../assets/images/ui/UI_Desktop_Hi.png");
            }

            ScreenManager.getInstance().setupCamera(null, 1);
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.leafPopups = new Array();

            super.postCreate();

            var that:Desktop = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    var cur:Object;
                    for (var i:int = 0; i < that.folder_structure["contents"].length; i++) {
                        cur = that.folder_structure["contents"][i];
                        cur["hitbox_sprite"].y = event.userData['bg'].height * cur["hitbox_pos"].y;
                    }
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });

            SoundManager.getInstance().clearSoundsByType(GameSound.BGM);
            SoundManager.getInstance().clearSoundsByType(GameSound.SFX);
            SoundManager.getInstance().playSound(SFXRoomTone, 0, null, true, 1, Math.random()*2938, Desktop.ROOMTONE);
        }

        override public function update():void{
            super.update();

            var mouseScreenRect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);
            var clicked:GameObject;
            if(FlxG.mouse.justPressed()) {
                clicked = this.folder_builder.getClickedElement(mouseScreenRect);
                this.folder_builder.resolveClick(this.folder_structure,
                                                 mouseScreenRect, clicked);
            }

            this.folder_builder.overlapXSprite(this.folder_structure);
        }
    }
}
