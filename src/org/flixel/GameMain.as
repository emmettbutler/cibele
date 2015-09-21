package org.flixel {
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.management.ScreenManager;

    import flash.events.*;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;

    public class GameMain extends FlxGame {
        public var logfile:File;

        public function GameMain(GameSizeX:uint,GameSizeY:uint,InitialState:Class,Zoom:Number=1,GameFramerate:uint=60,FlashFramerate:uint=30,UseSystemCursor:Boolean=false)
        {
            super(GameSizeX, GameSizeY, InitialState, Zoom, GameFramerate, FlashFramerate, UseSystemCursor);
            this.logfile = File.applicationStorageDirectory.resolvePath(
                "error_log_" + new Date().valueOf() + ".txt");
            this.root.loaderInfo.uncaughtErrorEvents.addEventListener(
                UncaughtErrorEvent.UNCAUGHT_ERROR, this.handleUncaughtError);
        }

        public function handleUncaughtError(event:UncaughtErrorEvent):void {
            var str:FileStream = new FileStream();
            str.open(this.logfile, FileMode.APPEND);
            str.writeUTFBytes(event.error.getStackTrace() + "\n\n");
            str.close();
            if (ScreenManager.getInstance().RELEASE) {
                event.preventDefault();
            }
        }

        override protected function onMouseDown(FlashEvent:MouseEvent):void
        {
            if(_debuggerUp)
            {
                if(_debugger.hasMouse)
                    return;
                if(_debugger.watch.editing)
                    _debugger.watch.submit();
            }
            if(_replaying && (_replayCancelKeys != null))
            {
                var replayCancelKey:String;
                var i:uint = 0;
                var l:uint = _replayCancelKeys.length;
                while(i < l)
                {
                    replayCancelKey = _replayCancelKeys[i++] as String;
                    if((replayCancelKey == "MOUSE") || (replayCancelKey == "ANY"))
                    {
                        if(_replayCallback != null)
                        {
                            _replayCallback();
                            _replayCallback = null;
                        }
                        else
                            FlxG.stopReplay();
                        break;
                    }
                }
                return;
            }
            if (!GlobalTimer.getInstance().isPaused()) {
                FlxG.mouse.handleMouseDown(FlashEvent);
            }
        }
    }
}
