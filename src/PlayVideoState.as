package {
    import org.flixel.*;

    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.events.NetStatusEvent;

    public class PlayVideoState extends GameState {
        public var videoStream:NetStream;
        public var video:Video;
        public var endCallback:Function;

        public function PlayVideoState(filename:String, endCallback:Function) {
            super(true, false, false);
            this.loadVideo(filename);
            this.endCallback = endCallback;
        }

        public function loadVideo(filename:String):void {
            var videoConnection:NetConnection = new NetConnection();
            videoConnection.connect(null);
            videoStream = new NetStream(videoConnection);
            videoStream.play(filename);
            videoStream.client = { onMetaData:function(obj:Object):void{} };
            videoStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            var screenWidth:Number = ScreenManager.getInstance().screenWidth;
            var screenHeight:Number = ScreenManager.getInstance().screenHeight;
            var aspectRatio:Number = ScreenManager.DEFAULT_ASPECT;

            var dim:DHPoint = ScreenManager.getInstance().calcFullscreenDimensions();
            var origin:DHPoint = ScreenManager.getInstance().calcFullscreenOrigin(dim);

            video = new Video(dim.x, dim.y);
            video.x = origin.x;
            video.y = origin.y;
            video.attachNetStream(videoStream);
            // mute videos for now
            videoStream.soundTransform = new SoundTransform(0);

            FlxG.stage.addChild(video);
        }

        override public function update():void {
            super.update();
        }

        private function netStatusHandler(evt:NetStatusEvent):void {
            if (evt.info.code == "NetStream.Play.Stop") {
                FlxG.stage.removeChild(video);  // kill video
                this.endCallback();
            }
        }
    }
}
