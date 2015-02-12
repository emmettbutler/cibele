package org.flixel {
    import com.starmaid.Cibele.utils.GlobalTimer;

    import flash.events.*;

    public class GameMain extends FlxGame {
        public function GameMain(GameSizeX:uint,GameSizeY:uint,InitialState:Class,Zoom:Number=1,GameFramerate:uint=60,FlashFramerate:uint=30,UseSystemCursor:Boolean=false)
        {
            super(GameSizeX, GameSizeY, InitialState, Zoom, GameFramerate, FlashFramerate, UseSystemCursor);
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
